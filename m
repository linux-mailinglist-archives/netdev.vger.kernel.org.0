Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCE556C7D6
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 10:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiGIIF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 04:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiGIIF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 04:05:58 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CA368713
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 01:05:56 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id p129so1221344yba.7
        for <netdev@vger.kernel.org>; Sat, 09 Jul 2022 01:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tgP5+W3LpYD31hetDdw0xBVPNUVkDVTE78SizymlG1Y=;
        b=S8OP+yxPOI+mth6gGOBb+0lhTGTGLjxBqBLB1Y7q9jhN/5UTmcNRtl4cuRR/FU1767
         YD6fnywmja1W7pYmbM9/2P5hc663rfeYEZP1R+Fh52HGy0BGyEiewAXMyewjFE6Vb7i9
         rrIjvDzFJCqWbQ++hnoZBFceL6P6ecjPzPy8JZO5Oh9uUfMPqVLrSxUKexQNyx6MbISQ
         DifwaA50Sa1rFPItqAD3GYFvBoX64yciS0LVIUQSIrmgK2XOcoIP+qiL+wNBzDa+clF+
         bx4FaBlrGyQvDUXja+hKag3shpi0Q7PF00qts9nVavFQMol7wSQIVEvm360O+F25JFRm
         86vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tgP5+W3LpYD31hetDdw0xBVPNUVkDVTE78SizymlG1Y=;
        b=37R9MoV1e2FVfF03KEvyc0vvAsyTz98zh7n3DnHFMUgy7303Gw6487dkY31FnlsNSh
         429GhwNYgUgXD+acMEQlZO+nATaP7AIKL4+hRnn31Gss+8c6c4d6+qqGfoXMaTnxTQsE
         S2N6zW8kxvVqj2bNOTqbDNFXtntmuU8Nt3ylSxQoh7SoCoNOQktx/2uB+YqHCOsnJF9Y
         p99GMCP52DasRkDEhlV5vFpKUXOuu+Q1TNc9Fch5BleSJSFZWjCXW0FiKUw61mU9k8Ha
         g/WT6DuYcPPoKZ9OCPwozsNxbupJHSrDNKqEE4ypBjGwSukwBoCbsx59nHyrZxHcBjM2
         j1hg==
X-Gm-Message-State: AJIora/TaM0sb7S8DCIt6xa5MQZmbFFkewWZU6uc+rS7pqPKUWRLHoeo
        jUYETtVO6yi3tlGxkSZ5OVvilK7k4ciSVNqadYVFm0Vaj3E=
X-Google-Smtp-Source: AGRyM1t1XI+8G6V++3WxJN8vxykyrsFoTeXslPToWblDCN0N90VAC8nkrVRlbhfd0YezTv5UbgjyyI4k/o8IFEJNdu0=
X-Received: by 2002:a05:6902:114b:b0:66f:d0:57c7 with SMTP id
 p11-20020a056902114b00b0066f00d057c7mr80159ybu.55.1657353955779; Sat, 09 Jul
 2022 01:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <HE1P193MB01236F580D05214179C7AAC0A8819@HE1P193MB0123.EURP193.PROD.OUTLOOK.COM>
 <HE1P193MB01233D583E9A7B1418A77713A8859@HE1P193MB0123.EURP193.PROD.OUTLOOK.COM>
 <20220709064114.GA4860@1wt.eu>
In-Reply-To: <20220709064114.GA4860@1wt.eu>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 9 Jul 2022 10:05:43 +0200
Message-ID: <CANn89i+bkcDg=Wq-uzLOPOT5PUjuLUQDQktPRb-_+Syn_P3CYw@mail.gmail.com>
Subject: Re: TPROXY + Attempt to release TCP socket in state 1
To:     netdev <netdev@vger.kernel.org>
Cc:     Michelle Bies <mimbies@outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 9, 2022 at 8:41 AM Willy Tarreau <w@1wt.eu> wrote:
>
> Hi,
>
> On Sat, Jul 09, 2022 at 06:14:14AM +0000, Michelle Bies wrote:
> > Hi Eric
> > unfortunately, nobody response to my problem :(
> > Did I report my problem to the right mailing list?
>
> You sent it only 4 days ago!

As a matter of fact, email did not reach the list because it had html format.

> As you might have noticed you're not the
> only one to request help, code reviews or anything that requires time
> from only a few people. What progress have you made on your side on
> the analysis of this problem in during this time, that you could share
> to save precious time to those who are going to help you, and to make
> your issue more interesting to analyse than other ones ?
>
> Also, I'm seeing that your kernel is tainted by an out-of-tree module:
>
> > >   CPU: 5 PID: 0 Comm: swapper/5 Tainted: GO 5.4.181+ #9
>                                              ^^
>
> Most likely it's this "xt_geoip" module but it may also be anything
> else I have not spotted in your dump. Have you rechecked without it ?
> While unlikely to be related, any out-of-tree code must be handled
> with extreme care, as their impact on the rest of the kernel remains
> mostly unknown, so they're the first ones to disable during
> troubleshooting.
>
> > > My current kernel is 5.4 and these are my iptables config:
>
> Please always mention the exact version in reports. I've seen "5.4.181+"
> in your dump, which means 5.4.181 plus extra patches. Have you tried
> again without them ?
>
> Hoping this helps,
> Willy
