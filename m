Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA191938A9
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgCZGep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:34:45 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35997 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgCZGep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:34:45 -0400
Received: by mail-pf1-f195.google.com with SMTP id i13so2292818pfe.3;
        Wed, 25 Mar 2020 23:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8Yp31voZWlVivg9kGYEITrYNynKJ5KaUpyuZtUu51uQ=;
        b=RT3xnHvCGWEV0TWOMX6vqaa1p5KvabcHIB812s/x8VHWpRemFVAcdI4antoxrXLnC+
         Tbi9RQSZm8eKUOCgQ5TnEq1UB2UA9A5P3CdcHL5JvPUh64phHTzJ73+Pp29TfXZlEfLh
         P+N3/ADKawlAlu4cgOm1hpHpa63VGL7P8yw2KDtnmxTSba/J5v1l2wt0+Ec5ZigQOWG4
         1ef6oDdNCWHgRi7eeOLgZ0js/SJ0HU3X53CgPKK+swpbWSNB3JblCab2X7a6VD0gUkHn
         zcAtxiGLRn/1PjYx6IkrLOvxWaydtndG+T86cLAHIhvA6GSZPoGM0mGFghj4cQRmdEKy
         MWCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8Yp31voZWlVivg9kGYEITrYNynKJ5KaUpyuZtUu51uQ=;
        b=j8jFsnq7tR76Vn+z72Xf8q/d7gYk+K6dM3p0f0GlWzGRPaavn+hv6DCnquc84Nqs1j
         Y5HebhxwlAL3L5poFD38ls6Giyw8OzSeJcAEhe4g2Du3CWVSamtht+czlIKHAJQt7tJ0
         v1aXOUFpvIBciRiNlqNmeMjPqKuC0F356bE+9wkQNu4s48AEvJOW6UztBluKokbn1zFJ
         QXITGxEnnwUfaBS08dl/Gxtnxj2dNH7zxP60fcwPQTK1rbE+AfA0TakvRZcY3DwKOLia
         o7hZ7S62G+j6ve9xbNkSSqmlcUwAr5+39dZBpAbdcvLSxMSOpCklDXu2cT6bvrKXx5+S
         6a1g==
X-Gm-Message-State: ANhLgQ3ad38o8FhKiDlJxsfaaJrB7rpOnQRpymtboVEjy5scw21w9+FB
        C2sFBt/GeWb9UGNJQqH6+A8=
X-Google-Smtp-Source: ADFU+vsEozPuAJZ0JBU+YJWGR6hIPOtVjOwrapG+zB3wOabHNX22Y3b2KSy0yM5IXQ4nG9RqkpPPcQ==
X-Received: by 2002:a62:686:: with SMTP id 128mr7144824pfg.152.1585204483982;
        Wed, 25 Mar 2020 23:34:43 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:5929])
        by smtp.gmail.com with ESMTPSA id y193sm799162pgd.87.2020.03.25.23.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 23:34:43 -0700 (PDT)
Date:   Wed, 25 Mar 2020 23:34:41 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ecree@solarflare.com, yhs@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [bpf-next PATCH 10/10] bpf: test_verifier, add alu32 bounds
 tracking tests
Message-ID: <20200326063441.ymitkh5z6sgevbm4@ast-mbp>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
 <158507165554.15666.6019652542965367828.stgit@john-Precision-5820-Tower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158507165554.15666.6019652542965367828.stgit@john-Precision-5820-Tower>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 10:40:55AM -0700, John Fastabend wrote:
> Its possible to have divergent ALU32 and ALU64 bounds when using JMP32
> instructins and ALU64 arithmatic operations. Sometimes the clang will
> even generate this code. Because the case is a bit tricky lets add
> a specific test for it.
> 
> Here is  pseudocode asm version to illustrate the idea,
> 
>  1 r0 = 0xffffffff00000001;
>  2 if w0 > 1 goto %l[fail];
>  3 r0 += 1
>  5 if w0 > 2 goto %l[fail]
>  6 exit
> 
> The intent here is the verifier will fail the load if the 32bit bounds
> are not tracked correctly through ALU64 op. Similarly we can check the
> 64bit bounds are correctly zero extended after ALU32 ops.
> 
>  1 r0 = 0xffffffff00000001;
>  2 w0 += 1
>  2 if r0 < 0xffffffff00000001 goto %l[fail];

This should be 3.

> +	"bounds check mixed 32bit and 64bit arithmatic. test2",
> +	.insns = {
> +	BPF_MOV64_IMM(BPF_REG_0, 0),
> +	BPF_MOV64_IMM(BPF_REG_1, -1),
> +	BPF_ALU64_IMM(BPF_LSH, BPF_REG_1, 32),
> +	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 1),
> +	/* r1 = 0xffffFFFF00000001 */
> +	BPF_MOV64_IMM(BPF_REG_2, 3),
> +	/* r1 = 0x2 */
> +	BPF_ALU32_IMM(BPF_ADD, BPF_REG_1, 1),
> +	/* check ALU32 op zero extends 64bit bounds */
> +	BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_2, 1),
> +	BPF_JMP_A(1),
> +	/* invalid ldx if bounds are lost above */
> +	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
> +	BPF_EXIT_INSN(),
> +	},
> +	.result = ACCEPT
> +},
> 
