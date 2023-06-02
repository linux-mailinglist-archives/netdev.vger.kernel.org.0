Return-Path: <netdev+bounces-7527-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B62D7208ED
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:17:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32EB1281A39
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023801DDC8;
	Fri,  2 Jun 2023 18:17:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74771D2CE;
	Fri,  2 Jun 2023 18:17:44 +0000 (UTC)
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2056E194;
	Fri,  2 Jun 2023 11:17:43 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2b1a86cdec6so22272181fa.3;
        Fri, 02 Jun 2023 11:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685729861; x=1688321861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KLFNCMhv+spGlpOSH+9ycbJCZbcr4uBlI4qw7DshkZ8=;
        b=KyhHrtcqhrgtW/KY3WyjzLqvw3iKTxgOBu62HKzjvMOn9BR7iU68cHO4y/TP0FAHdp
         IwGXll8PxV8kEcuM3N4FdFzQLZq/snGmXfLtj4FB2KsfD8aZ24aN98wwXtRwyEreVS64
         0wq0I78FfdoxTOe2u5aGY/OT8eLcIhFfLI+ev4ayYvi0lByP66uuu3dYwf1lF3AWTuRg
         ti+1DpvpzO3jFBIWlFSU4+2Xk/Q0TAivuKApBQxY2iSW4KbO70VQoZs2EYjUt/mqSCJ3
         YfMI5AlU82kYbB85XrUR+n22S3XoZ68wfI5gFhHyfcUhO+/p1JUohp9DlsjPzWWRsPT8
         IG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685729861; x=1688321861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KLFNCMhv+spGlpOSH+9ycbJCZbcr4uBlI4qw7DshkZ8=;
        b=GMqoJVy7ZZI9uVBQ2QYMPpsltiDEXm/m2SDUO9VvcduflUVoyRrLrR3iKSRdBgISKt
         eoQtHdTOWXneb42zEUt9xc26m+infNHpHlEV7W6YAX5L4r93aBfsYQnziq1EzLPvgaI9
         x1rH2p7fPyxJhbfN8iDVxSwoc/dR6QwYIh4wCIUos7NcpKaV5eWJNNAlPT3pYmhrzmj9
         p1Q/0SaLfX88bFL7LfE2r8mDoAaZjOKM87FkKh4j/hVPfs85umv9geffun1ujWJBrek8
         2DkSlkSKb/fTabl5Kv8myJaOm24w2pwU6zi3NzINhDiwr0fj8EvlGpFrnJUfvo/Hn5Jq
         P72A==
X-Gm-Message-State: AC+VfDwX9gXJ5Hpx0pSBTFo6a2K1bIFiaegI0nvdDNTMc9dTYVuZdsFm
	k7qhtMJAg8RvtJxKzvzzkgVsIsrVxFfx6Q67SX9iKA/vlRg=
X-Google-Smtp-Source: ACHHUZ7DxBiO+vgM+60Tryc29RsBRvao4RVTxaqEv4+BPbaOmGl8KbQ1WwBKGLpU/vRqoMEEVd/ddp73Sbng8H1agY4=
X-Received: by 2002:a2e:800e:0:b0:2ad:95dd:8802 with SMTP id
 j14-20020a2e800e000000b002ad95dd8802mr487855ljg.38.1685729860693; Fri, 02 Jun
 2023 11:17:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602065958.2869555-1-imagedong@tencent.com> <20230602065958.2869555-2-imagedong@tencent.com>
In-Reply-To: <20230602065958.2869555-2-imagedong@tencent.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 2 Jun 2023 11:17:29 -0700
Message-ID: <CAADnVQL8F23zxfYBacD9mFt_2uWRXN8Cno3tZGce4W3QC8iSew@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/5] bpf: make MAX_BPF_FUNC_ARGS 14
To: Menglong Dong <menglong8.dong@gmail.com>
Cc: Jiri Olsa <olsajiri@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, 
	John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>, 
	benbjiang@tencent.com, Ilya Leoshkevich <iii@linux.ibm.com>, 
	Menglong Dong <imagedong@tencent.com>, Xu Kuohai <xukuohai@huawei.com>, 
	Manu Bretelle <chantr4@gmail.com>, Ross Zwisler <zwisler@google.com>, Eddy Z <eddyz87@gmail.com>, 
	Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 12:01=E2=80=AFAM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> According to the current kernel version, below is a statistics of the
> function arguments count:
>
> argument count | FUNC_PROTO count
> 7              | 367
> 8              | 196
> 9              | 71
> 10             | 43
> 11             | 22
> 12             | 10
> 13             | 15
> 14             | 4
> 15             | 0
> 16             | 1
>
> It's hard to statisics the function count, so I use FUNC_PROTO in the btf
> of vmlinux instead. The function with 16 arguments is ZSTD_buildCTable(),
> which I think can be ignored.
>
> Therefore, let's make the maximum of function arguments count 14. It used
> to be 12, but it seems that there is no harm to make it big enough.

I think we're just fine at 12.
People need to fix their code. ZSTD_buildCTable should be first in line.
Passing arguments on the stack is not efficient from performance pov.

