Return-Path: <netdev+bounces-11511-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD727335F8
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:30:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9797328182A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 824F2171C9;
	Fri, 16 Jun 2023 16:30:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7302C22E2F;
	Fri, 16 Jun 2023 16:30:39 +0000 (UTC)
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B7E2D50;
	Fri, 16 Jun 2023 09:30:37 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b43a99c887so12375531fa.2;
        Fri, 16 Jun 2023 09:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686933036; x=1689525036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VjlwNenpbBvePCbCX3+0aHT644/faHIQIb21tKNGV9g=;
        b=nVhp0TMQZWKA2yBqjazDADC+lM+qmOv+fHH/cUlGdNAmWmmDj61U4388WVvCwYnAgK
         4IPQhSPrwZkfKvMLRcKlM7KtADOt2Etmy2gmt1zXshnpy5JIx0fBGEY7CBsX8w8b4l7u
         xhJwDRacLhOllQGphYvJSGNh3gPPNFJ7Y5naimqTpoShz5YQlFiKWgQcOQIGVeCJrNTf
         P7vobmXDVj0ZvuzZjj55ogvTnpXUB05aBXmCuDFg+TTESrEG2nO37nswK7wPL3AY/Fnw
         933zJ/6dwfzXbfbupNx9Xo7nn8859/aAfrD1eUv44nTo88VO8Ch8xtO/DNJVrp2IM2Yu
         sY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686933036; x=1689525036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VjlwNenpbBvePCbCX3+0aHT644/faHIQIb21tKNGV9g=;
        b=RvWwpVSsYopiSSxEM60lXARekVKbL0Yz6hzi3IRWVxmCLikroNMHcCoSbZomMwSR8A
         VHnctqzw4sLnB33ke3aVCVd3709Vkn8Ja0ki4aM7bD8LCMsHx627KyU0Q0CO5e+xg79a
         K5+ma7j7gCriC1DOVAyEeWle78UT590+97u6flsvXkfcqOajOFgoXZ7qs/aL/bJGEEoC
         gNWi0eh8e5W9oVU5dEe0ouFEce4nBs9t5mMmmGtQU8/75SijGW4xz1hP8pBiefPMUSj+
         YbyKZDvUZeN6tL9VgaJ8q+bTZziLPTB+7IkPlCONV8hoPY7eCDN6fXRxTSbxXPQQdMlr
         xtSg==
X-Gm-Message-State: AC+VfDzW61pU1aMxDX2b8USnArBI08bdFyOiMNrv5Kzrev7uu3r3URbO
	GEdy3nDF+OICTPBpUvdpkUuM+/R4O3g5/OVU3HxJViB9Q14=
X-Google-Smtp-Source: ACHHUZ4aPUJ9v1M9t1QRhY2nfMXjlEd6/oeFNXbrW826Etp4titXacK1a1NCD/kWSdSLsLWoBmN6YA13U9H0bViQmtM=
X-Received: by 2002:a2e:9083:0:b0:2ad:996f:5d11 with SMTP id
 l3-20020a2e9083000000b002ad996f5d11mr2294205ljg.28.1686933035366; Fri, 16 Jun
 2023 09:30:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230610124403.36396-1-denghuilong@cdjrlc.com>
 <e980bbb2536d4c35ce90a4666b3e8bf6@208suo.com> <f65f9d0caf6a315f21eb09e7a29a8189@208suo.com>
In-Reply-To: <f65f9d0caf6a315f21eb09e7a29a8189@208suo.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 16 Jun 2023 09:30:22 -0700
Message-ID: <CAEf4BzZhD+a=c_gp0V0_6Zvp1gSa4=Wt+fUpo7EgDp1cH8Hjjg@mail.gmail.com>
Subject: Re: [PATCH] bpf: Remove unneeded variable
To: xuanzhenggang001@208suo.com
Cc: davem@davemloft.net, dsahern@kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, bpf@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 11:29=E2=80=AFPM <xuanzhenggang001@208suo.com> wrot=
e:
>
> Fix the following coccicheck warning:
>
> arch/x86/net/bpf_jit_comp32.c:1274:5-8: Unneeded variable: "cnt".
>
> Signed-off-by: Zhenggang Xuan <xuanzhenggang001@208suo.com>
> ---
>   arch/x86/net/bpf_jit_comp32.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp32.c
> b/arch/x86/net/bpf_jit_comp32.c
> index 429a89c5468b..bc71329ac5ed 100644
> --- a/arch/x86/net/bpf_jit_comp32.c
> +++ b/arch/x86/net/bpf_jit_comp32.c
> @@ -1271,7 +1271,6 @@ static void emit_epilogue(u8 **pprog, u32
> stack_depth)
>   static int emit_jmp_edx(u8 **pprog, u8 *ip)
>   {
>       u8 *prog =3D *pprog;
> -    int cnt =3D 0;
>
>   #ifdef CONFIG_RETPOLINE
>       EMIT1_off32(0xE9, (u8 *)__x86_indirect_thunk_edx - (ip + 5));

EMIT macroses are updating this cnt. Have you tested this patch by any chan=
ce?

> @@ -1280,7 +1279,7 @@ static int emit_jmp_edx(u8 **pprog, u8 *ip)
>   #endif
>       *pprog =3D prog;
>
> -    return cnt;
> +    return 0;
>   }
>
>   /*
>

