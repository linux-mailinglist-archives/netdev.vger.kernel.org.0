Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A01F503524
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 10:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiDPIT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 04:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiDPIT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 04:19:27 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0395A15A3C;
        Sat, 16 Apr 2022 01:16:57 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id kl29so7808553qvb.2;
        Sat, 16 Apr 2022 01:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uZHCzWAZCF54H9l8o4Fov+TpziM3IgLdlvWuOde2Hlw=;
        b=Gn//A44OZ9VIhXCSQRhhD9YlLcsIXv+T7gjBpJ5gl01mdcddI/NTjwmOo+HLm5/xRA
         W4ei2Z+/2BnN7cF9EOdNGXaQsrCzayzpkhkIImtSdmD2Z6dWxWSkqZqh5e5VVBYrEWce
         HuOhgn8GiolvPs6YngcUESziI8keS7+4SL6Z1a6isSqPqMWjQwIhH5K9BngBT3UnKg7W
         /pgFmpbtWGw5SOjTibKuzLvYpnLnxBUN1EwZ5dzxteSP5AnUhb2QyjRYipMUYBJFUAGe
         3Y8mSvOppqBfRnGO41CXZm2sE1X0b4sonx12cxVXODY0JR8t0Lhd9qZw76RRChPNXITM
         wn8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uZHCzWAZCF54H9l8o4Fov+TpziM3IgLdlvWuOde2Hlw=;
        b=zNuk04i265preBDJokwARTY2OGDPwJNYpxGQcT0t/932y4gGFg16/J3dMEy4Enqku5
         YtyyeIYlmR5Wrt+9UKENQz5vFoq017g2X7J1au+rEBuAvMeh11llgY4COB1TvDWbciU2
         zjrtLpWAXxSFu4P2B5gUR2QAzLAme2Wl0lcRqDcQ7U8EXivcK5qp2Fq+3fGhYKdbE0+Y
         x1BERnkisi50qbKkxeLjbAXSi0aQXwaxzQRqUJqPmIvcfCbXhZJL3JN624taiVEJqU4O
         nz+KbX03l5q7Bcz4i8MfyNoev0USvkyuBAXS0cLLpEoXynfO1nh7AYxQ2XmTyQOP38M7
         2hMQ==
X-Gm-Message-State: AOAM5313EyOzS7gacLLjykCXIQgvOc4q/irHO2lJWJnxN1Qg+rLGYKOv
        aAihMraG2USS39oAmELFJcf0N0HuJg==
X-Google-Smtp-Source: ABdhPJwXlUfOf0YOaRQOksXz/q++G39mW3V1vbRT/E4O/CBmdB+2j6fwCz3hhVCtaK2sqkj0pTxO1Q==
X-Received: by 2002:a05:6214:1ccd:b0:443:652e:69d with SMTP id g13-20020a0562141ccd00b00443652e069dmr1933166qvd.114.1650097016083;
        Sat, 16 Apr 2022 01:16:56 -0700 (PDT)
Received: from bytedance (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id o3-20020a05622a008300b002ef3ba485c0sm4354786qtw.6.2022.04.16.01.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Apr 2022 01:16:55 -0700 (PDT)
Date:   Sat, 16 Apr 2022 01:16:52 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Feng Zhou <zhoufeng.zf@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] ip6_gre: Fix skb_under_panic in __gre6_xmit()
Message-ID: <20220416081652.GA11007@bytedance>
References: <c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649715555.git.peilin.ye@bytedance.com>
 <9cd9ca4ac2c19be288cb8734a86eb30e4d9e2050.1649715555.git.peilin.ye@bytedance.com>
 <20220414131424.744aa842@kernel.org>
 <20220414200854.GA2729@bytedance>
 <20220415191133.0597a79a@kernel.org>
 <20220416065633.GA10882@bytedance>
 <20220416093320.13f4ba1d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220416093320.13f4ba1d@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 16, 2022 at 09:33:20AM +0200, Jakub Kicinski wrote:
> On Fri, 15 Apr 2022 23:56:33 -0700 Peilin Ye wrote:
> > On Fri, Apr 15, 2022 at 07:11:33PM +0200, Jakub Kicinski wrote:
> > > > Could you explain this a bit more?  It seems that commit 77a5196a804e
> > > > ("gre: add sequence number for collect md mode.") added this
> > > > intentionally.  
> > > 
> > > Interesting. Maybe a better way of dealing with the problem would be
> > > rejecting SEQ if it's not set on the device itself.  
> > 
> > According to ip-link(8), the 'external' option is mutually exclusive
> > with the '[o]seq' option.  In other words, a collect_md mode IP6GRETAP
> > device should always have the TUNNEL_SEQ flag off in its
> > 'tunnel->parms.o_flags'.
> > 
> > (However, I just tried:
> > 
> >   $ ip link add dev ip6gretap11 type ip6gretap oseq external
> > 					       ^^^^ ^^^^^^^^
> >  ...and my 'ip' executed it with no error.  I will take a closer look at
> >  iproute2 later; maybe it's undefined behavior...)
> > 
> > How about:
> > 
> > 1. If 'external', then 'oseq' means "always turn off NETIF_F_LLTX, so
> > it's okay to set TUNNEL_SEQ in e.g. eBPF";
> > 
> > 2. Otherwise, if 'external' but NOT 'oseq', then whenever we see a
> > TUNNEL_SEQ in skb's tunnel info, we do something like WARN_ONCE() then
> > return -EINVAL.
> 
> Maybe pr_warn_once(), no need for a stacktrace.

Ah, thanks, coffee needed...

> > > When the device is set up without the SEQ bit enabled it disables Tx
> > > locking (look for LLTX). This means that multiple CPUs can try to do
> > > the tunnel->o_seqno++ in parallel. Not catastrophic but racy for sure.  
> > 
> > Thanks for the explanation!  At first glance, I was wondering why don't
> > we make 'o_seqno' atomic until I found commit b790e01aee74 ("ip_gre:
> > lockless xmit").  I quote:
> > 
> > """
> > Even using an atomic_t o_seq, we would increase chance for packets being
> > out of order at receiver.
> > """
> > 
> > I don't fully understand this out-of-order yet, but it seems that making
> > 'o_seqno' atomic is not an option?
> 
> atomic_t would also work (if it has enough bits). Whatever is simplest
> TBH. It's just about correctness, I don't think seq is widely used.

I see, I will work on this, thanks!

Peilin Ye

