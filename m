Return-Path: <netdev+bounces-2644-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05F75702CBC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:31:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 095521C20B33
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3005B846E;
	Mon, 15 May 2023 12:31:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236B3C8E8
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:31:00 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0241729
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:30:56 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f42397f41fso348655e9.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684153855; x=1686745855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=umnwVKI63XC1E5tVu9dUEQNT8S7VHAd6OTkDfG6Pjrc=;
        b=AnT046pAlshDM0WpdLkrRxte3HfFtBXa7X/j7QpznGqWMPbX0buZ+0xrJ4JHia3IVh
         AVSnYLRLxf2Kzvc3AS0oWMoPkZ+OKdTlb3G7A8tPBvAe07Ci89WYaFFqjSW7oS4EqAB9
         TScB2ryib1kSVAe2/vvTM6QsuYtiTonfTAx8i4noLUuzMjEnp0guvPZJ/i2tBYh+zAem
         tMPJNKN/hQRpu17SEA6lCUNhiGjKp7gt4iB5l6VdcB/ot/uj5Ckt+92Jjj74UMHjygOc
         tOHSs13/KqHQFmEguzNxt9NU2pSockpIIL4W60v/UqWwMMdeztHw/wK7ZgqWWkNtuZTn
         NUQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684153855; x=1686745855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=umnwVKI63XC1E5tVu9dUEQNT8S7VHAd6OTkDfG6Pjrc=;
        b=YKWfX3mV+6rbqJSljJx/5zWI3HVgAyBAhA/EchxRuQd8Rl+e6R0WHDUM8XS5qaQWI0
         58XFVDMa4d6tJ0pXqvaCor+D+OKKEw6IMnz+DvCgicEt/7qHGN7jxQ/PelIAP8Tcfd5Z
         C72oKDa2BKCA1FutAYW5fB7dA6Nx1KL7yLbQWSVmQADJNOYUWu3kIC+bNqwDdFu6y+XD
         9gY8imRlEK+U+eF2Jav3Q3I1EA61tPH+Dv1kmfH79mnSyDcaTKolWDF72Hy+vHPuKnBi
         pfi61Cw7ZPT1uUMPKqgwUuvDXtK4cHJP+WqlNjHx+XcrqvDIMc7p5pW1YCTB2hZnFLf0
         JJ2w==
X-Gm-Message-State: AC+VfDxadJWYjvOE41HcMGLqZB3Lhckwb3pKiXBJjCBxUt1zcT2U/zAD
	bXVgnRZVHRlPAdlkQcuH1DulVS9jp1eGCMlbuXp3s/dHReg23FknIGGLhQ==
X-Google-Smtp-Source: ACHHUZ7i2kvrUiU2BWb/GrDuamaRdDc3q3KMYc4BmqhDSjSyLJhvnsjxFXmtLbxqwVJeo9b95GkQ44rIPy5R2WDedck=
X-Received: by 2002:a05:600c:4750:b0:3f1:9a3d:4f7f with SMTP id
 w16-20020a05600c475000b003f19a3d4f7fmr787354wmo.1.1684153854824; Mon, 15 May
 2023 05:30:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230515091226.sd2sidyjll64jjay@soft-dev3-1>
In-Reply-To: <20230515091226.sd2sidyjll64jjay@soft-dev3-1>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 15 May 2023 14:30:42 +0200
Message-ID: <CANn89iLDtbQTQEdOgkisHZ28O+cdXKBSKrwubHagA7iVUmKXBg@mail.gmail.com>
Subject: Re: Performance regression on lan966x when extracting frames
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 11:12=E2=80=AFAM Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> Hi,
>
> I have noticed that on the HEAD of net-next[0] there is a performance dro=
p
> for lan966x when extracting frames towards the CPU. Lan966x has a Cortex
> A7 CPU. All the tests are done using iperf3 command like this:
> 'iperf3 -c 10.97.10.1 -R'
>
> So on net-next, I can see the following:
> [  5]   0.00-10.01  sec   473 MBytes   396 Mbits/sec  456 sender
> And it gets around ~97000 interrupts.
>
> While going back to the commit[1], I can see the following:
> [  5]   0.00-10.02  sec   632 MBytes   529 Mbits/sec   11 sender
> And it gets around ~1000 interrupts.
>
> I have done a little bit of searching and I have noticed that this
> commit [2] introduce the regression.
> I have tried to revert this commit on net-next and tried again, then I
> can see much better results but not exactly the same:
> [  5]   0.00-10.01  sec   616 MBytes   516 Mbits/sec    0 sender
> And it gets around ~700 interrupts.
>
> So my question is, was I supposed to change something in lan966x driver?
> or is there a bug in lan966x driver that pop up because of this change?
>
> Any advice will be great. Thanks!
>
> [0] befcc1fce564 ("sfc: fix use-after-free in efx_tc_flower_record_encap_=
match()")
> [1] d4671cb96fa3 ("Merge branch 'lan966x-tx-rx-improve'")
> [2] 8b43fd3d1d7d ("net: optimize ____napi_schedule() to avoid extra NET_R=
X_SOFTIRQ")
>
>

Hmmm... thanks for the report.

This seems related to softirq (k)scheduling.

Have you tried to apply this recent commit ?

Commit-ID:     d15121be7485655129101f3960ae6add40204463
Gitweb:        https://git.kernel.org/tip/d15121be7485655129101f3960ae6add4=
0204463
Author:        Paolo Abeni <pabeni@redhat.com>
AuthorDate:    Mon, 08 May 2023 08:17:44 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 09 May 2023 21:50:27 +02:00

Revert "softirq: Let ksoftirqd do its job"


Alternative would be to try this :

diff --git a/net/core/dev.c b/net/core/dev.c
index b3c13e0419356b943e90b1f46dd7e035c6ec1a9c..f570a3ca00e7aa0e605178715f9=
0bae17b86f071
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6713,8 +6713,8 @@ static __latent_entropy void
net_rx_action(struct softirq_action *h)
        list_splice(&list, &sd->poll_list);
        if (!list_empty(&sd->poll_list))
                __raise_softirq_irqoff(NET_RX_SOFTIRQ);
-       else
-               sd->in_net_rx_action =3D false;
+
+       sd->in_net_rx_action =3D false;

        net_rps_action_and_irq_enable(sd);
 end:;

