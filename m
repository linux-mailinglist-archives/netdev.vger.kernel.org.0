Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661D45ED999
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbiI1J5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233530AbiI1J4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:56:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CF89E0D8
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 02:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664358941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KOcKqqAqNfd55B50yhiHNhHf8OQzjKjX/ahbscXLMLU=;
        b=crFVX4/QF83Hib07tKkd484O2J2Wtc7FFLatoUJFw9qWz5JtLIWkxBNl81j5/okGXbe8VM
        h3rxnqZT2U0B/1Rube6rgPC85oKhm5ygq8wIl+6iTyPwtzDmd5zPYdZgELegXd7kcx5M40
        CczQjZAVjrmflkTAiujidYQaFi9uAeE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-55-K9SLJaAsPeiW1-6QjwcyRg-1; Wed, 28 Sep 2022 05:55:40 -0400
X-MC-Unique: K9SLJaAsPeiW1-6QjwcyRg-1
Received: by mail-wm1-f72.google.com with SMTP id y20-20020a05600c365400b003b4d4ae666fso389214wmq.4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 02:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=KOcKqqAqNfd55B50yhiHNhHf8OQzjKjX/ahbscXLMLU=;
        b=yNq7iWjYVbUTqpVVHRP+Pqo72lk/h56YyjRZBM78aHzU+GOOozb2rwne/Z+zlxfH3+
         jFnOrqaVXDkDY7Nw+ifRYku1kRdLgon1QALXgWuvknKdjanR2hmYojQ0bL7KQI62EqGX
         zzrpMaGFlfnW95FXXYxiHwEZ4em9ihr0FZWhF5EdEMWFEGdosm8vAfvugDIusrzaOhGX
         Obes5AtVGDHgpxY/I6MxH1FXiMPzd1vO6/f8QvX4oDOiYeFLVm69XG7b0oorWCsDUuWa
         9q/YEgmLs3Z3j/jivU/wD1lFbTgDaBo4yeSRULNWSUEPN7L6cY5ke9tPA2xfRXZ2jsyV
         kyjA==
X-Gm-Message-State: ACrzQf0R0druidhF9PTHHQIitg+hWCHFQbimwYD2qKOfu20rvE6mvRM3
        IMlfK1CcJUAgf7h3/9gmLdufXrwYSFoB3j+FBWyy8mYAqYEfY5bNfFW3eylfkDq5sjSXoB6Ik/W
        G4TE1+ZoD9RJ9yRte
X-Received: by 2002:a05:6000:2a6:b0:22a:fb53:316 with SMTP id l6-20020a05600002a600b0022afb530316mr20478054wry.55.1664358939262;
        Wed, 28 Sep 2022 02:55:39 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7F8tGRqJPp0Zb4oni9yn6z8QF/WxGMgqEmPbSEmwGpPadDVqnzbVfiIblr7oCxBtZo2PU7tw==
X-Received: by 2002:a05:6000:2a6:b0:22a:fb53:316 with SMTP id l6-20020a05600002a600b0022afb530316mr20478032wry.55.1664358939037;
        Wed, 28 Sep 2022 02:55:39 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id jb5-20020a05600c54e500b003a604a29a34sm1238441wmb.35.2022.09.28.02.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 02:55:38 -0700 (PDT)
Date:   Wed, 28 Sep 2022 11:55:36 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCHv3 net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set, del}link
Message-ID: <20220928095536.GB3081@localhost.localdomain>
References: <20220927041303.152877-1-liuhangbin@gmail.com>
 <YzO943B4Id2jLZkI@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzO943B4Id2jLZkI@Laptop-X1>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 11:22:11AM +0800, Hangbin Liu wrote:
> Hi Jakub,
> On Tue, Sep 27, 2022 at 12:13:03PM +0800, Hangbin Liu wrote:
> > @@ -3009,6 +3012,11 @@ static int do_setlink(const struct sk_buff *skb,
> >  		}
> >  	}
> >  
> > +	nskb = rtmsg_ifinfo_build_skb(RTM_NEWLINK, dev, 0, 0, GFP_KERNEL, NULL,
> > +				      0, pid, nlh->nlmsg_seq);
> > +	if (nskb)
> > +		rtnl_notify(nskb, dev_net(dev), pid, RTNLGRP_LINK, nlh, GFP_KERNEL);
> 
> BTW, in do_setlink() I planed to use RTM_SETLINK. But I found iproute2 use
> RTM_NEWLINK to set links. And I saw an old doc[1] said
> 
> """
> - RTM_SETLINK does not follow the usual rtnetlink conventions and ignores
>   all netlink flags
> 
> The RTM_NEWLINK message type is a superset of RTM_SETLINK, it allows
> to change both driver specific and generic attributes of the device.
> """
> 
> So I just use RTM_NEWLINK for the notification. Do you think if we should
> use RTM_SETLINK?

This problem should go away once you switch to reusing the existing
notifications (instead of adding new ones).

> [1] https://lwn.net/Articles/236919/
> 
> Thanks
> Hangbin
> 

