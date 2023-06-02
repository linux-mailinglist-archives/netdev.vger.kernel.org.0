Return-Path: <netdev+bounces-7328-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 462FC71FB27
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79E611C20AB5
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D799C79ED;
	Fri,  2 Jun 2023 07:40:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81E263CC;
	Fri,  2 Jun 2023 07:40:57 +0000 (UTC)
Received: from mail-yw1-x1142.google.com (mail-yw1-x1142.google.com [IPv6:2607:f8b0:4864:20::1142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D77E1A1;
	Fri,  2 Jun 2023 00:40:55 -0700 (PDT)
Received: by mail-yw1-x1142.google.com with SMTP id 00721157ae682-568bb833462so18651147b3.1;
        Fri, 02 Jun 2023 00:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685691654; x=1688283654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oM3fAwJKm3WQ26amYPUOEVz+QzB/5EEs4dGWk0XfUBQ=;
        b=EpcDldyc/xJAJSWsy4/nbiCnWjNh4lnuQsxXsmfzFcKyo0NOCYcjD6HcsAT+oVgKHP
         70MQvmc8G7+kcKUTlKQflJop4tjllC2G8QfpoSrVnf4GMZlkQEEhYS4sQgJbmXb34dq4
         NipGqJ/juk0rk3B5Rp0k57Z4TsFF3OxeAisgoW0oP++iiphEP53dJPy016b1vAhS7lWb
         GAFDOkaD9OxNrBkkqxBHmMF5stHiMJKXjOaCU9q218iA5rYNMin3xs7c1RqsClrIj0MC
         /mANooql1iZXtf52FZN9VtANxbeVPdKi3wnNBDvJIL8ic73tcVwt+bIrXwp17dQkvf5U
         DMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685691654; x=1688283654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oM3fAwJKm3WQ26amYPUOEVz+QzB/5EEs4dGWk0XfUBQ=;
        b=OXnSdvAkg/M7dLvNViKnsxsOS0L8cIBZRjvcBWnxTsxY+qGxTRySnT3Lsjv9gilNEn
         XM8NVWICUKmVDkgI2nmjEQFI1qYPCP1c8Y0l3vGEQCBYMDoepWfEPY5NoaVHAvYp1/cz
         KGaVkBxipbbFRlj4lv28A9R9qFwJoj0k7/LKsXU4ixT3aokyqb4ZSzddzevxJbN4S4ru
         bexmA+YO1SAPuA0uj5oOWTSWKm5BhYzKXZGvoYHxZy50Bvi+wZ0l36c9PlOuSwqsPwgb
         0ogL2r0SHZf4AgZNm8euxz88I1naavdLY98i16lCv9ME3JJa+nwadX67ZpqbVKr5SfzC
         Y1Og==
X-Gm-Message-State: AC+VfDy6pZZCXdEmMChOUJ527piNylJdvI7K6TwuuPn17ie1VT59t54o
	irYlOR5lyiROunxXbllfW4scRP8iNoqwh5Y0PtA=
X-Google-Smtp-Source: ACHHUZ7dq+nyoMyR2vPjTFZyqws79z3rSs3uYbsWdIBlshpIKWvybc79mfHHaow3yloEzFhAu+wmAO1J8m6WapVESns=
X-Received: by 2002:a81:4e11:0:b0:561:81b:734b with SMTP id
 c17-20020a814e11000000b00561081b734bmr11667281ywb.39.1685691654522; Fri, 02
 Jun 2023 00:40:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602065958.2869555-1-imagedong@tencent.com> <20230602065958.2869555-3-imagedong@tencent.com>
In-Reply-To: <20230602065958.2869555-3-imagedong@tencent.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Fri, 2 Jun 2023 15:40:43 +0800
Message-ID: <CADxym3ZnmD_DhvS_KaJo4yt6PteaUDvifj4dp4gBBRuvoks=-g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/5] bpf, x86: allow function arguments up to
 14 for TRACING
To: olsajiri@gmail.com
Cc: davem@davemloft.net, dsahern@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, 
	sdf@google.com, haoluo@google.com, jolsa@kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	mykolal@fb.com, shuah@kernel.org, benbjiang@tencent.com, iii@linux.ibm.com, 
	imagedong@tencent.com, xukuohai@huawei.com, chantr4@gmail.com, 
	zwisler@google.com, eddyz87@gmail.com, netdev@vger.kernel.org, 
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 3:01=E2=80=AFPM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
> @@ -2262,6 +2327,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_im=
age *im, void *image, void *i
>
>         if (flags & BPF_TRAMP_F_CALL_ORIG) {
>                 restore_regs(m, &prog, nr_regs, regs_off);
> +               prepare_origin_stack(m, &prog, nr_regs, arg_stack_off);
>
>                 if (flags & BPF_TRAMP_F_ORIG_STACK) {
>                         emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8)=
;
> @@ -2321,14 +2387,14 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_=
image *im, void *image, void *i
>         if (save_ret)
>                 emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
>
> -       EMIT1(0x5B); /* pop rbx */
> +       emit_ldx(&prog, BPF_DW, BPF_REG_6, BPF_REG_FP, -rbx_off);
>         EMIT1(0xC9); /* leave */
>         if (flags & BPF_TRAMP_F_SKIP_FRAME)
>                 /* skip our return address and return to parent */
>                 EMIT4(0x48, 0x83, 0xC4, 8); /* add rsp, 8 */
>         emit_return(&prog, prog);
>         /* Make sure the trampoline generation logic doesn't overflow */
> -       if (WARN_ON_ONCE(prog > (u8 *)image_end - BPF_INSN_SAFETY)) {
> +       if (prog > (u8 *)image_end - BPF_INSN_SAFETY) {

Oops, this line is a mistake, and I should keep it still.

>                 ret =3D -EFAULT;
>                 goto cleanup;
>         }
> --
> 2.40.1
>

