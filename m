Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53558596FBE
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 15:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbiHQNVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239803AbiHQNTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:19:51 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B1E786F1
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 06:19:15 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id p132so15344932oif.9
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 06:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=dUoIS1mdB9GBw/ZLFYLwzDX1Mo+0WQ2EGSC5YGDqW7g=;
        b=fZWmBcOSgJBzrVmHoPZFx1mA/LJ+dLkAt4yaMyZb6S7bX5jo128RdCKAYBSr0ajcwp
         sb0bKXYD6EfYAsM5enNs7mHIPSR2ek67PLB1QaTnpBIpqRt8AS+Nxx8BFbxnqd+rXR6c
         ioPV720gY2YxAE1vSQPrq8j5CaV9WKIdRHqo6oohs4lo7mvmPpDoc1H8h6fdvSk7U0NO
         vcYLllNVePMfQjowT8XYtuP9ZT+z5aGIEOe/IQfV+4XwEO2pgLGAXGTb51UVJd6mjHOi
         uXAGus9T/F7StM9xGnkFIRiEOQ1JzZA+fT7b8H4upXJ5tdzdTM9DM8RTvPehc9/UDea2
         hV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=dUoIS1mdB9GBw/ZLFYLwzDX1Mo+0WQ2EGSC5YGDqW7g=;
        b=EOUNKw4bMpUeT0aAxC4K0zx4FYI1RCQRqVCgZTUYUMX2MVoI42y7sYNXCZ5XVCQy6M
         FZKCgU7GL3bnU3fGWFf9bes0Xaxeg8k3mW6y45Y+sF4oC5ORSrjuXJpjSfgwLRoiykuO
         J8sWSObUIbkA1HktUD42UJ2ToOUqdPEI0ertOln9iv9qEK3nAKtFlavbDH9tR8nfLM/i
         0DPasgNZt/dflPIG7ffSH7YY52Cjk60NEiQirp9DhdIshBJ1yY8Ldf2OiHiJh3ILFIgm
         qZ842hL2uLCja7ZrilIYOa3xQjl29YFhg0XMMDB/PTIOpm0GHopUvdVxAfwuthoXDpZp
         iUpw==
X-Gm-Message-State: ACgBeo2tQ2wCcC3kIgTRMVRzzNJfz61gEG6xLqs4wrxIx4qskTEoQtS3
        VjprU6pSZSVfwKcIgTBZ8XsPNCvhAJRxO3r55Zyh5Q==
X-Google-Smtp-Source: AA6agR5CG0lvkM1VCXUjoacKsulh2GXq9RRCuleqhHVKvQ6hx5QH5M4s5yKqbr/gC52VCvpGdkkVZTDWRDWUgOyx54s=
X-Received: by 2002:a05:6808:1d6:b0:344:93c6:ec88 with SMTP id
 x22-20020a05680801d600b0034493c6ec88mr1388766oic.2.1660742354628; Wed, 17 Aug
 2022 06:19:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220816020423.323820-1-shaozhengchao@huawei.com>
 <20220815201038.4321b77e@kernel.org> <694f07e3-d5ad-1bc5-1cdb-ae814b1a12f7@huawei.com>
 <20220816111305.4851a510@kernel.org>
In-Reply-To: <20220816111305.4851a510@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 17 Aug 2022 09:19:03 -0400
Message-ID: <CAM0EoMkcOXNfd0dyoGeqGVqN1EQ5jHr_2BuWQoLUAyudsLwdRg@mail.gmail.com>
Subject: Re: [PATCH net-next,0/3] cleanup of qdisc offload function
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     shaozhengchao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 2:13 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 16 Aug 2022 11:32:03 +0800 shaozhengchao wrote:
> > On 2022/8/16 11:10, Jakub Kicinski wrote:
> > > On Tue, 16 Aug 2022 10:04:20 +0800 Zhengchao Shao wrote:
> > >> Some qdiscs don't care return value of qdisc offload function, so make
> > >> function void.
> > >
> > > How many of these patches do you have? Is there a goal you're working
> > > towards? I don't think the pure return value removals are worth the
> > > noise. They don't even save LoC:
> > >
> > >   3 files changed, 9 insertions(+), 9 deletions(-)
> >
> >       Thank you for your reply. Recently I've been studying the kernel code
> > related to qdisc, and my goal is to understand how qdisc works. If the
> > code can be optimized, I do what I can to modify the optimization. Is it
> > more appropriate to add warning to the offload return value? I look
> > forward to your reply. Thank you.
>
> Understood. Please stop sending the cleanups removing return values
> unless the patches materially improve the code.

Quoting appropriate here.
+1

cheers,
jamal
