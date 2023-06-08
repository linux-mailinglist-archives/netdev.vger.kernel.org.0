Return-Path: <netdev+bounces-9298-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E1467285C9
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:50:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E1BA1C21007
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C3E18015;
	Thu,  8 Jun 2023 16:50:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4765710973
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:50:18 +0000 (UTC)
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34846125
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:50:15 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-39c7f5706f0so529439b6e.3
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 09:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686243014; x=1688835014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IECq8KyOKR32OJ+rnKQtgyrHARYp4mOJM0dHXG0n6bk=;
        b=LqfPqWVaI7J26WyIYJY6FbTyqb0AQDxw2gCqTGttONMMUV3dJO3RXB/G+SYjKuHCv0
         MyxQnw/E7Ye6ct+KIdyGj89J2HNX+OHL2x058gzZ6TFUFPQOJaSvSumkJ8yuJ+bp5d+C
         tzd1wrhIoPLJaTR+eO3719tbhqD9AOUypq0eCnXNAriAltT1coQqARIlyVSU3uUKq2oM
         DuSQCs95wJFCyTbuu4BWLRebzPK61DurXhjp67AeGZbOMZUJ0uJS3owO7q5EeCgIrdkt
         A0q4dfhQowo2To0mqZoua5yIpyQdzlyumNf9wVrreOCu0LfnlXqs9DpVEbOl4jkfYDVb
         x8jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686243014; x=1688835014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IECq8KyOKR32OJ+rnKQtgyrHARYp4mOJM0dHXG0n6bk=;
        b=OEQcggElu/7xJ4nT7x+r7dbuivcdqCAb5edLkQS+89vCHiPAp/lqhTHqtD7+g57z4f
         u+bljDDfQEqW3voxb0k8fwsJd/SLkYnzsWIOeXMc0ibEmxt3rwUTV6zUlMXVuhpWTWVb
         HMnXOY9CFzu9O87aiTj8Mvs0pOGzVPs1go5M6vSfyOUVCMIipJVX2D4afk8ze9VtKfkc
         uZYLUSuB1xnP/4wXoupkhXPGJnAf2i3BVu51ytJEFSCuyB2l6rVOIIaYBGNp7dpiKTSP
         M7sNIm2BXkv8wecVgixrB8r3oX+Gv02n/L2a+zQ4oTqg7RHOusXGqX388+D0ehyPoUAd
         vlTA==
X-Gm-Message-State: AC+VfDy2kUdbXhSYT78OiiyJWol8ua628nvvE0hZAyboSdtDn8BiHkV+
	sUBxWhZuvt/50JMTijaIbmN2M5nXkuYdATyY6O/j+RguYfkp4oEO
X-Google-Smtp-Source: ACHHUZ5O/+/QzJultL1FBKZvqh7v+znjyfAj7OQfVOK1HSLMtLFEHsueBEr2yUpTBWgAsBLIxWmT7VGNxWJ/ezn1wRw=
X-Received: by 2002:a05:6808:1ca:b0:398:57fe:5fa with SMTP id
 x10-20020a05680801ca00b0039857fe05famr5246523oic.29.1686243014538; Thu, 08
 Jun 2023 09:50:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230608140246.15190-1-fw@strlen.de>
In-Reply-To: <20230608140246.15190-1-fw@strlen.de>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Thu, 8 Jun 2023 12:50:03 -0400
Message-ID: <CAM0EoMmcgoTbneB+JYt_oUKwsFMiA7xsuCWA=epr=mZnzhaX6w@mail.gmail.com>
Subject: Re: [PATCH net v2 0/3] net/sched: act_ipt bug fixes
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com, 
	davem@davemloft.net, pabeni@redhat.com, xiyou.wangcong@gmail.com, 
	jiri@resnulli.us
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 10:03=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> v2: add "Fixes" tags, no other changes, so retaining Simons RvB tag.
>
> While checking if netfilter could be updated to replace selected
> instances of NF_DROP with kfree_skb_reason+NF_STOLEN to improve
> debugging info via drop monitor I found that act_ipt is incompatible
> with such an approach.  Moreover, it lacks multiple sanity checks
> to avoid certain code paths that make assumptions that the tc layer
> doesn't meet, such as header sanity checks, availability of skb_dst
> skb_nfct() and so on.
>
> act_ipt test in the tc selftest still pass with this applied.
>
> I think that we should consider removal of this module, while
> this should take care of all problems, its ipv4 only and I don't
> think there are any netfilter targets that lack a native tc
> equivalent, even when ignoring bpf.
>

I am all for removing it - but i am worried there are users based on
past interactions. Will try to ping some users and see if they
actually were using it. I will send a patch to retire it if it looks
safe.
Unfortunately ipt suffered because we couldnt coordinate between the
netfilter and tc subsystem. In the old days so calling/callee bugs
fixed in the netfilter world find their way into ipt. At some point
that stopped. Also the user space interfacing suffered from similar
issues.

cheers,
jamal

> Florian Westphal (3):
>   net/sched: act_ipt: add sanity checks on table name and hook locations
>   net/sched: act_ipt: add sanity checks on skb before calling target
>   net/sched: act_ipt: zero skb->cb before calling target
>
>  net/sched/act_ipt.c | 70 ++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 63 insertions(+), 7 deletions(-)
>
> --
> 2.40.1
>

