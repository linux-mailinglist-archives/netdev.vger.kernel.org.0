Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D621E64FC76
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 22:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiLQVhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 16:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiLQVhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 16:37:20 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBC0AE5C;
        Sat, 17 Dec 2022 13:37:19 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id c7so5509254qtw.8;
        Sat, 17 Dec 2022 13:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HtFHmDiZdhCBd3AYorc5R49zCwK13HQcbUolbEz3R6U=;
        b=VErxAKwASmsxRND0FtHwJBvLHoqVGMxEX0602KEiOqqNSgMj1JhwpaZ0tMitBdfBhI
         ArThuzu9pnP85KphHcjpghaJV/pF3Zk80AJ/s+sulAFmIDKHuFoToZ1PdY4W9KgxFY6K
         Pghyol2GXMRyB88BBWQrKn9JdZtGu/ZLMuKouOd+ex2zqWkXJmJiqRdn1rZfYYCqocBS
         yKZd2aQM2DanaHrpKs+WgTkGBy5aHXYPYYE+leWITF6AZa7ah83r6AP8znNHHsKC5e7g
         olPGD+/NTOn8RGS20X0HI5ah5UFVj8mdg4DZLxsthAuPHXwpPnAoVX/05/Gv1walKIe7
         P1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HtFHmDiZdhCBd3AYorc5R49zCwK13HQcbUolbEz3R6U=;
        b=o/S8IEZc1+RMtVeBAZvyW6eJWrMshl4cPYBMw1rzndFpyBCUh5W8nGzo9/NMPpwIv6
         Eh6CLblgQDK4iTKOoZRzQRTPZJ1m5TEckiT6/RbgYTtPI6i83T8hom9o3uXah0d5YtPD
         qSYkapxMiroeNRssnf9uFIbmq3mrfLoYZIxqgUyMH33XPFQ6Zr1AbTRHzCu7+OSD1d5i
         954Nb9aoBL/yEPzRqjfmjBpxaNnORM7dpZECbtjSYYumjBr3x4H5p9Ryl85rySbWWi6R
         rrbvOCckpy1Cp+KCjxHU+MFTrt0lYbFEsN4NtYzHagyr8e1YdkJMFFAlLYsmOINR2UBP
         Rs8g==
X-Gm-Message-State: ANoB5pl3/ZGgQIAz5f2UVR/N5TBgP4qvV4zmEPeYbw5vVyexrWFGXWkf
        822Bv8D02Kg4kkGmEvqX/l4=
X-Google-Smtp-Source: AA0mqf70mi1N6Mmb+f+DwUawtikOqYGZ0oLF9h2eOT6o/H1kgb8D3Nqs6Ts4PLeX0Lm9E8QZWaO57g==
X-Received: by 2002:ac8:51d0:0:b0:3a7:e271:fc05 with SMTP id d16-20020ac851d0000000b003a7e271fc05mr47664883qtn.3.1671313038289;
        Sat, 17 Dec 2022 13:37:18 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:5eb1:3c61:24e:7911])
        by smtp.gmail.com with ESMTPSA id s5-20020a05620a254500b006f9f714cb6asm4155158qko.50.2022.12.17.13.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 13:37:16 -0800 (PST)
Date:   Sat, 17 Dec 2022 13:37:15 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jun Nie <jun.nie@linaro.org>, jhs@mojatatu.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: sched: ematch: reject invalid data
Message-ID: <Y542i4NHrt7RIA+C@pop-os.localdomain>
References: <20221214022058.3625300-1-jun.nie@linaro.org>
 <f8af2b70e3c2074de04b2117100b2cdc5ec4ec6d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f8af2b70e3c2074de04b2117100b2cdc5ec4ec6d.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 01:50:43PM +0100, Paolo Abeni wrote:
> On Wed, 2022-12-14 at 10:20 +0800, Jun Nie wrote:
> > ---
> >  net/sched/em_cmp.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/sched/em_cmp.c b/net/sched/em_cmp.c
> > index f17b049ea530..0284394be53f 100644
> > --- a/net/sched/em_cmp.c
> > +++ b/net/sched/em_cmp.c
> > @@ -22,9 +22,14 @@ static int em_cmp_match(struct sk_buff *skb, struct tcf_ematch *em,
> >  			struct tcf_pkt_info *info)
> >  {
> >  	struct tcf_em_cmp *cmp = (struct tcf_em_cmp *) em->data;
> > -	unsigned char *ptr = tcf_get_base_ptr(skb, cmp->layer) + cmp->off;
> > +	unsigned char *ptr;
> >  	u32 val = 0;
> >  
> > +	if (!cmp)
> > +		return 0;
> 
> It feels like this is papering over the real issue. Why em->data is
> NULL here? why other ematches are not afflicted by this issue? 
> 
> is em->data really NULL or some small value instead? KASAN seams to
> tell it's a small value, not 0, so this patch should not avoid the
> oops. Have you tested it vs the reproducer?

Right. I think I have found the root cause, let me test my patch to see
if it makes syzbot happy.

Thanks.
