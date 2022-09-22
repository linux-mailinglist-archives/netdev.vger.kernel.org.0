Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7988B5E607C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 13:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiIVLKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 07:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiIVLJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 07:09:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE27140BC0
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 04:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663844996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+LP9Kj6CGsCmY03Fgk61XjMRjtDfw7MffuoBr2216cw=;
        b=EV1VN1ZX5VGsomijQNa0pv1pcRmq/Ico3z9SDYsD+ufI01Y5RXsflOfXZ54LSP9ToYXUyU
        uT3GA5ZagYqHLnROPyOLX3+HXSUs51AGbLqj9Pz+mCOAsS4yikNr5rKeM/xNwAwGD+mQEH
        43WUDimEYYnVui/q0gOec1A6eLFPLQk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-643-jteLiG8JOIWVyGJrOiqAnw-1; Thu, 22 Sep 2022 07:09:55 -0400
X-MC-Unique: jteLiG8JOIWVyGJrOiqAnw-1
Received: by mail-wr1-f69.google.com with SMTP id r23-20020adfb1d7000000b002286358a916so3134768wra.3
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 04:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=+LP9Kj6CGsCmY03Fgk61XjMRjtDfw7MffuoBr2216cw=;
        b=x6IyZiIyibiAa5edEb99ylICYYLunK7YX5Cbk8D72modFH84gxmFwbkNtpwcqSGK5i
         kk3hp1S6PcxfTBeHI+DOKFNAqMiRBmhuq4T9n4sHNmxbXNczafh0u2lXadjG8CWcObOQ
         llgn/hBfrObGNDVP9C2BCOJ/6jhndPshAAW9epTtVoZhWTJy4BFLLAw+mYbUuSqCIoRU
         HbF2Y7hur70bGcsedoa8loegY6A5631RVLmgZuAFFnf7FsePUe9cwFV7X+zwj+vqBgYn
         cbzDA+BuCCBrz8DTF6etnOJwY7loPoW/muMmURNO8KwB46/WJ3bOTI+hyJ3z5vZNwkYT
         RYKA==
X-Gm-Message-State: ACrzQf0yyRWgjaJquiYs4BB1mY6VsVLve44O5btlsmWxkn6C+y3jtvpD
        fVIICFY8W3jW7JM+o8Jtrg2aGTLw/ULogjJqVo56AFBqMj60m5BC12JLDOQT7FQOr7KeFKzMPUj
        roH7JtOPIcZetWX7K
X-Received: by 2002:a5d:457b:0:b0:22b:24d6:1a9f with SMTP id a27-20020a5d457b000000b0022b24d61a9fmr1603475wrc.201.1663844994326;
        Thu, 22 Sep 2022 04:09:54 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7WnIpDlF2uyVkiuQACqtPIILbmnWVa7XNKcHM8l4oCZmkB3tO56ZYMju/zyCEFnh7Xi0mCEg==
X-Received: by 2002:a5d:457b:0:b0:22b:24d6:1a9f with SMTP id a27-20020a5d457b000000b0022b24d61a9fmr1603461wrc.201.1663844994049;
        Thu, 22 Sep 2022 04:09:54 -0700 (PDT)
Received: from debian.home (2a01cb058d2cf4004ad3915553d340e2.ipv6.abo.wanadoo.fr. [2a01:cb05:8d2c:f400:4ad3:9155:53d3:40e2])
        by smtp.gmail.com with ESMTPSA id id21-20020a05600ca19500b003b27f644488sm5426150wmb.29.2022.09.22.04.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 04:09:53 -0700 (PDT)
Date:   Thu, 22 Sep 2022 13:09:51 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new,
 set}link
Message-ID: <20220922110951.GA21605@debian.home>
References: <20220921030721.280528-1-liuhangbin@gmail.com>
 <20220921060123.1236276d@kernel.org>
 <20220921161409.GA11793@debian.home>
 <20220921155640.1f3dce59@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921155640.1f3dce59@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 03:56:40PM -0700, Jakub Kicinski wrote:
> On Wed, 21 Sep 2022 18:14:09 +0200 Guillaume Nault wrote:
> > > I'd love to hear what others think. IMO we should declare a moratorium
> > > on any use of netlink flags and fixed fields, push netlink towards
> > > being a simple conduit for TLVs.  
> > 
> > At my previous employer, we had a small program inserting and removing
> > routes depending on several external events (not a full-fledged routing
> > daemon). NLM_F_ECHO was used at least to log the real kernel actions (as
> > opposed to what the program intended to do) and link that to the events
> > that triggered these actions. That was really helpful for network
> > administrators. Yes, we were lucky that the RTM_NEWROUTE and
> > RTM_DELROUTE message handlers supported NLM_F_ECHO. I was surprised when
> > I later realised that RTM_NEWLINK and many others didn't.
> > 
> > Then, a few years ago, I had questions from another team (maybe Network
> > Manager but I'm not sure) who asked how to reliably retrieve
> > informations like the ifindex of newly created devices. That's the use
> > case NLM_F_ECHO is for, but lacking this feature this team had to
> > rely on a more convoluted and probably racy way. That was the moment
> > I decided to expose the problem to our team. Fast-forwarding a couple
> > of years and Hangbin picked up the task.
> 
> Looking closer at the code it seems like what NLM_F_ECHO does in most
> places is to loop notifications resulting from the command back onto
> the requesting socket. See nlmsg_notify(), report is usually passed 
> as nlmsg_report(req).

Yes, this is how it's supposed to work. NLM_F_ECHO is already handled
by the core netlink code. Netlink message handlers only have to pass
the right parameters to nlmsg_notify() (or the rtnl_notify() wrapper
for rtnetlink) to make it work.

That's why I complained when RTM_NEWNSID tried to implement its own
notification mechanism:
https://lore.kernel.org/netdev/20191003161940.GA31862@linux.home/

I mean, let's just use the built-in mechanism, rather than reinventing
a new one every time the need comes up.

> I guess that answers Hangbin's question - yes, I'd vote that we just
> pass the nlh to rtnl_notify() and let the netlink core do its thing.

Definitely.

> In general I still don't think NLM_F_ECHO makes for a reasonable API.
> It may seem okay to those who are willing to write manual netlink
> parsers but for a normal programmer the ability to receive directly
> notifications resulting from a API call they made is going to mean..
> nothing they can have prior experience with. NEWLINK should have
> reported the allocated handle / ifindex from the start :(

I also don't know of any other API that works this way. But given the
current situation, I also can't really see that change.

> The "give me back the notifications" semantics match well your use
> case to log what the command has done, in that case there is no need
> to "return" all the notifications from the API call.

It's not really _my_ use case anymore :), but I'm pretty sure this
piece of software is still in use. Anyway I used this example just to
illustrate why a programmer would use this feature. The RTM_NEWNSID
is another practical use case.

