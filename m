Return-Path: <netdev+bounces-6828-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08B537185A2
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:06:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58B501C20E75
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF42F1642E;
	Wed, 31 May 2023 15:06:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ED616425
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:06:02 +0000 (UTC)
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E78DE57
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:05:41 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-19f8af9aa34so2001085fac.1
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685545536; x=1688137536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HKym96YAzpIP9uRUNi0zGjtXWFUPd2ygLCpBbo0BoMc=;
        b=rsDm8mSycBA9yjsx3K+zjz6B/A5ovegUVU46esg64idEZcUM2/vcGhkQIejHdpUUqi
         ZiFFtrVJzP1DyFEVjp8ckHlunExlJkN15Yraj7vBA8415T/sWBiGugfEtislSdrcOgIp
         I/4aoyfpmO/nnteg81xWA6cN/hT2v+F9KtMnEgFGk0CvRjTDwh9wnIGgx0CrSOMu2zl3
         pEK/MO4SgzhvQHmXlAHBsbOOOHjjtPhbYbTHJobAUkiiqFWTNL1ZX4kx4WTEJiigKcXC
         rv6XqqfwdXshhLCzNELkHJs6CRBDHTtxTktrj3kZHSf+1wt0etkahP1LRMQiR/3e2Xus
         BR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685545536; x=1688137536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HKym96YAzpIP9uRUNi0zGjtXWFUPd2ygLCpBbo0BoMc=;
        b=kBwF+isUr0CpEPDgaSdfPE2GUj/ZmrBI7c0lQGcmjz2WdWDY8grBvcGWuxe6vXzFsP
         yxLee5//5n2a4lloTbd8SStXDJ2asS2u1SopdqAK5jAFQzWELFCBLXA2wFr7/Wtt0mUe
         UGYp2mU8vRgimbWB/U4tDjCPv2x8pbqECuGFDM3n1RbzOhvDYtT/km9COs5iwl7RpT8Y
         lVR5NXiH4VJYsY2Ltqi74sT0BJKxkA6BFeOq/HgdUZ0ZQXGDgUl5xYudtSk8J9bL0a69
         HuN2G2vLBySpzdJhvcXqpC7EqsjPOeFWdZ8ptxriooVxICnjOQB4pozXD/MYieuOm1Mh
         sBDQ==
X-Gm-Message-State: AC+VfDyJAbKGKvmEk1YzD8nSEN/RzDc/WDg9X5bMafOL6Es4Ox38z82p
	oLQtSViI1sUzqMam3+bDNRpbiHLw3s64zmIO0+xapsSA6BKSFJb85HQ=
X-Google-Smtp-Source: ACHHUZ6Axf4tx5LENQVUBnzkqzLQgLlmHXX/SDmmcOAQYfuZVZ9/AY8qp30uzVjHucMHU4QqsUwiTJcV09Soko9AgWA=
X-Received: by 2002:a05:6870:659e:b0:192:63b5:13cc with SMTP id
 fp30-20020a056870659e00b0019263b513ccmr5480033oab.12.1685545536357; Wed, 31
 May 2023 08:05:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230531141556.1637341-1-lee@kernel.org>
In-Reply-To: <20230531141556.1637341-1-lee@kernel.org>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Wed, 31 May 2023 11:05:25 -0400
Message-ID: <CAM0EoMnw_4Z6tGC8=JkGKuCFTkJHt5JOFj56+_Z6GDExAMbugQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] net/sched: cls_u32: Fix reference counter leak
 leading to overflow
To: Lee Jones <lee@kernel.org>
Cc: xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 10:16=E2=80=AFAM Lee Jones <lee@kernel.org> wrote:
>
> In the event of a failure in tcf_change_indev(), u32_set_parms() will
> immediately return without decrementing the recently incremented
> reference counter.  If this happens enough times, the counter will
> rollover and the reference freed, leading to a double free which can be
> used to do 'bad things'.
>
> Cc: stable@kernel.org # v4.14+
> Signed-off-by: Lee Jones <lee@kernel.org>
> ---
>  net/sched/cls_u32.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> index 4e2e269f121f8..fad61ca5e90bf 100644
> --- a/net/sched/cls_u32.c
> +++ b/net/sched/cls_u32.c
> @@ -762,8 +762,11 @@ static int u32_set_parms(struct net *net, struct tcf=
_proto *tp,
>         if (tb[TCA_U32_INDEV]) {
>                 int ret;
>                 ret =3D tcf_change_indev(net, tb[TCA_U32_INDEV], extack);
> -               if (ret < 0)
> +               if (ret < 0) {
> +                       if (tb[TCA_U32_LINK])
> +                               n->ht_down->refcnt--;
>                         return -EINVAL;
> +               }
>                 n->ifindex =3D ret;
>         }
>         return 0;

The spirit of the patch looks right I dont think this fully solves the
issue you state.
My suggestion: Move the if (tb[TCA_U32_INDEV])  above the if
(tb[TCA_U32_LINK]) {
Did you see this in practice or you found it by eyeballing the code?
Can you also add a tdc test for it? There are simple ways to create
the scenario.

cheers,
jamal
> 2.41.0.rc0.172.g3f132b7071-goog
>

