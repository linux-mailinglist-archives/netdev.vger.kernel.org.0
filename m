Return-Path: <netdev+bounces-8662-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12C0D7251A7
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 03:44:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2874F1C20C37
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 01:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E655963D;
	Wed,  7 Jun 2023 01:44:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24697C;
	Wed,  7 Jun 2023 01:44:07 +0000 (UTC)
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2921BC7;
	Tue,  6 Jun 2023 18:44:04 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4f640e48bc3so501283e87.2;
        Tue, 06 Jun 2023 18:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686102243; x=1688694243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cydTVkBZ9wwA36xiKOsKWVLXBix81SsiChs8AFPXSco=;
        b=WipqcehkIxHd2tQDwpQumUKrwlpxPGp4/5QgqPivgYOTZ/VBLupHzlAYXUT5nWDHrr
         EIlP4+KC2/1f1oQ1f3+eC4KsCaVHMCu8E/3xm8KExPpLFV18XqoULPnAQnJSUsSBi82v
         s+U8cTPMYzoGrOXN2B/+Hf7hkUTUwZyhFXbbfPoEn9nfoCm1B1N4n/LYXMt1/0JndYkw
         JGM7bJlxgifFi+rnfyk3XHr/PTp2mWPIzTKLCnK0nJyJ0LSYZT+5yeux5KuBcseosu7n
         lZP1YzPXtVl0oxZCWjGcSUcWj9aX4rYjQwZc7nmBd6Zy1bTbQ0VH1+QlQVqdBuLOdNcF
         9ypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686102243; x=1688694243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cydTVkBZ9wwA36xiKOsKWVLXBix81SsiChs8AFPXSco=;
        b=AiBr1JoOvmHidxQtzQZcFCPSV88e/0B2joG8WGOGAo7b+SulzzyDn1Pk1GFSgnZvFL
         u2Ybt6lSEOPMtD1xBzbgZfb6T1KsmW2pm71d9LKri1S/2RQ8sPpHlvIeuXGcgL9mdvw3
         uIq9f1B0byFgdIVaN7FdKlhK0yAT1kIQ8wyndgC0r0MiO8zeI99ZgFDqwhNUqLOJGUir
         0PucDpEI9xZLQFNqhIjSUlsRn0caauf0tL4ZroR9Og23J0Q/IGAmkED4ohgnqWrTmTSe
         4dFFu6g1VyUTAb0b733MmWhwCQI5NMQkkMtn0q1GgG7zReyQFS+zh5RIT397kzRouhZF
         xikw==
X-Gm-Message-State: AC+VfDyOTYD4G4fmDuA5850zfM0iYEIDm1kj0Dm0Q1VEF/e8znxRUBhA
	n7/GEWHQ2xPD2GXViqoOv2yfypbVLAo3OcM4Cn/lIryg
X-Google-Smtp-Source: ACHHUZ4wqElTlOsU89vFlZCDs9eKYShpLYo1+aomjTwzh+9Iw5GujYy0qPuQenPOiw2SH0Cm+NhFYWjpGLhcVJA2Hm8=
X-Received: by 2002:ac2:511d:0:b0:4f6:3c67:ddfc with SMTP id
 q29-20020ac2511d000000b004f63c67ddfcmr971952lfb.23.1686102242851; Tue, 06 Jun
 2023 18:44:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606214246.403579-1-maxtram95@gmail.com> <20230606214246.403579-3-maxtram95@gmail.com>
In-Reply-To: <20230606214246.403579-3-maxtram95@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 6 Jun 2023 18:43:51 -0700
Message-ID: <CAADnVQ+urU87JnBi5fLTTzG0V0_Bi5o7eGPPTjmbTqtfLEqgag@mail.gmail.com>
Subject: Re: [PATCH bpf v3 2/2] selftests/bpf: Add test cases to assert proper
 ID tracking on spill
To: Maxim Mikityanskiy <maxtram95@gmail.com>
Cc: bpf <bpf@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Maxim Mikityanskiy <maxim@isovalent.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Mykola Lysenko <mykolal@fb.com>, 
	Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 2:43=E2=80=AFPM Maxim Mikityanskiy <maxtram95@gmail.=
com> wrote:
>
> From: Maxim Mikityanskiy <maxim@isovalent.com>
>
> The previous commit fixed a verifier bypass by ensuring that ID is not
> preserved on narrowing spills. Add the test cases to check the
> problematic patterns.
>
> Signed-off-by: Maxim Mikityanskiy <maxim@isovalent.com>
> ---
>  .../selftests/bpf/progs/verifier_spill_fill.c | 198 ++++++++++++++++++
>  1 file changed, 198 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c b/to=
ols/testing/selftests/bpf/progs/verifier_spill_fill.c
> index 136e5530b72c..999677acc8ae 100644
> --- a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
> +++ b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
> @@ -371,4 +371,202 @@ __naked void and_then_at_fp_8(void)
>  "      ::: __clobber_all);
>  }
>
> +SEC("xdp")
> +__description("32-bit spill of 64-bit reg should clear ID")
> +__failure __msg("math between ctx pointer and 4294967295 is not allowed"=
)
> +__naked void spill_32bit_of_64bit_fail(void)

It's an overkill to test all possible combinations.
32_of_64 and 16_of_32 would be enough.

