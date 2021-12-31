Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11CD48210F
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 01:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242413AbhLaAn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 19:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhLaAn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 19:43:27 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8F9C061574;
        Thu, 30 Dec 2021 16:43:27 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 8so22614717pgc.10;
        Thu, 30 Dec 2021 16:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WnhN3kMe3VENULvjYSV92C/m7+KOrcGSnKmq3Z/qE9s=;
        b=dcw8ptgqfh3oEWvj1AP2DEYu2tya2xmL+W4mVY8+bdbXqKMtvFH9FNaI5AIt6Uv7QS
         2w7T3QPbLQsGPgcfNFIFM5muxSMOHVH+r6t/3eTJJimRi32pgyFEvi3Iy5Ax6yVwyRxU
         9g8xrg/7G31nhNhx+krDP2/SnS05incs2Yu4EUwX12Po8C7BR/HbIlc7pkhcpUPrHlWz
         44pgUgQdRiaosQaV13iPD50nuXx75qGcAT6nQHEMq4B/bIzloArcDYLxpBgTWNfE/aon
         n8Ux1kbfVSSJQbxht/wzFOTN7m8I81FuzryWffyBGk3emB959vPwnYV+sBJcMWqkqKwB
         etBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WnhN3kMe3VENULvjYSV92C/m7+KOrcGSnKmq3Z/qE9s=;
        b=msJ6V8KXKyNEtjm3I3evoU7aXjU5ZQ+R3BpA/1JuHdz0cmwyPumlGOC/F8l4o1xkKW
         UyPRnjT2BTNZQxKWgZU0QQ4HCMiZCllZMhqhQc/QWksAnjCnLcEbaoUc50DIfhNBFte8
         7/VGBfTy+8e7IOntN4kNhI/kYfDyanan4lKAdZkFpfwNxXKrkOhrSC/boccbQlo1qXQG
         1CbzELha64UUMwr1aoFmNobp00/lzlAS4ZzraxuXPUQKKQBOUKuNxrfiuntG3hrQKmpS
         J1vM+i254wastlrTz8ZXXeARfjAzujptePwVg8r5rTg3OsP5dco7LD0eDXqqFfBBYmRH
         Uobg==
X-Gm-Message-State: AOAM53238GdrXHQjHxJ8teebMBaGBsPVmhqT3ieFR9AgvEiWVEzOga+9
        m2zMtSuxFy9hJKm7qw7QfrzGWAM65Dk=
X-Google-Smtp-Source: ABdhPJxruE0yBw1trj8i+OOtqRwMb2rbVjgaL18Y/pv3YFd1gau2Rcdaiw39aDRg9hFHpoxbnm/jYQ==
X-Received: by 2002:a63:701b:: with SMTP id l27mr29533945pgc.241.1640911406891;
        Thu, 30 Dec 2021 16:43:26 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:4e61])
        by smtp.gmail.com with ESMTPSA id 6sm22430120pgc.90.2021.12.30.16.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 16:43:26 -0800 (PST)
Date:   Thu, 30 Dec 2021 16:43:24 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 3/4] bpf, docs: Generate nicer tables for instruction
 encodings
Message-ID: <20211231004324.wvfqqgntnpswhzby@ast-mbp>
References: <20211223101906.977624-1-hch@lst.de>
 <20211223101906.977624-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223101906.977624-4-hch@lst.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 11:19:05AM +0100, Christoph Hellwig wrote:
>  
> +For class BPF_ALU or BPF_ALU64:
> +
> +  ========  =====  =========================
> +  code      value  description
> +  ========  =====  =========================
>    BPF_ADD   0x00
>    BPF_SUB   0x10
>    BPF_MUL   0x20
> @@ -68,26 +76,31 @@ If BPF_CLASS(code) == BPF_ALU or BPF_ALU64 BPF_OP(code) is one of::
>    BPF_NEG   0x80
>    BPF_MOD   0x90
>    BPF_XOR   0xa0
> -  BPF_MOV   0xb0  /* mov reg to reg */
> -  BPF_ARSH  0xc0  /* sign extending shift right */
> -  BPF_END   0xd0  /* endianness conversion */
> +  BPF_MOV   0xb0   mov reg to reg
> +  BPF_ARSH  0xc0   sign extending shift right
> +  BPF_END   0xd0   endianness conversion
> +  ========  =====  =========================
>  
> -If BPF_CLASS(code) == BPF_JMP or BPF_JMP32 BPF_OP(code) is one of::
> +For class BPF_JMP or BPF_JMP32:
>  
> -  BPF_JA    0x00  /* BPF_JMP only */
> +  ========  =====  =========================
> +  code      value  description
> +  ========  =====  =========================
> +  BPF_JA    0x00   BPF_JMP only
>    BPF_JEQ   0x10
>    BPF_JGT   0x20
>    BPF_JGE   0x30
>    BPF_JSET  0x40

Not your fault, but the new table looks odd with
only some opcodes documented.
Same issue with BPF_ALU table.
In the past the documented opcodes were for eBPF only and
not documented in both, so it wasn't that bad.
At least there was a reason for discrepancy.
Now it just odd.
May be add a comment to all rows?

> -  BPF_JNE   0x50  /* jump != */
> -  BPF_JSGT  0x60  /* signed '>' */
> -  BPF_JSGE  0x70  /* signed '>=' */
> -  BPF_CALL  0x80  /* function call */
> -  BPF_EXIT  0x90  /*  function return */
> -  BPF_JLT   0xa0  /* unsigned '<' */
> -  BPF_JLE   0xb0  /* unsigned '<=' */
> -  BPF_JSLT  0xc0  /* signed '<' */
> -  BPF_JSLE  0xd0  /* signed '<=' */
> +  BPF_JNE   0x50   jump '!='
> +  BPF_JSGT  0x60   signed '>'
> +  BPF_JSGE  0x70   signed '>='
> +  BPF_CALL  0x80   function call
> +  BPF_EXIT  0x90   function return
> +  BPF_JLT   0xa0   unsigned '<'
> +  BPF_JLE   0xb0   unsigned '<='
> +  BPF_JSLT  0xc0   signed '<'
> +  BPF_JSLE  0xd0   signed '<='
> +  ========  =====  =========================
>  
>  So BPF_ADD | BPF_X | BPF_ALU means::
>  
> @@ -108,37 +121,58 @@ the return value into register R0 before doing a BPF_EXIT. Class 6 is used as
>  BPF_JMP32 to mean exactly the same operations as BPF_JMP, but with 32-bit wide
>  operands for the comparisons instead.
>  
> -For load and store instructions the 8-bit 'code' field is divided as::
>  
> -  +--------+--------+-------------------+
> -  | 3 bits | 2 bits |   3 bits          |
> -  |  mode  |  size  | instruction class |
> -  +--------+--------+-------------------+
> -  (MSB)                             (LSB)
> +Load and store instructions
> +===========================
> +
> +For load and store instructions (BPF_LD, BPF_LDX, BPF_ST and BPF_STX), the
> +8-bit 'opcode' field is divided as:
> +
> +  ============  ======  =================
> +  3 bits (MSB)  2 bits  3 bits (LSB)
> +  ============  ======  =================
> +  mode          size    instruction class
> +  ============  ======  =================
> +
> +The size modifier is one of:
>  
> -Size modifier is one of ...
> +  =============  =====  =====================
> +  size modifier  value  description
> +  =============  =====  =====================
> +  BPF_W          0x00   word        (4 bytes)
> +  BPF_H          0x08   half word   (2 bytes)
> +  BPF_B          0x10   byte
> +  BPF_DW         0x18   double word (8 bytes)
> +  =============  =====  =====================
>  
> -::
> +The mode modifier is one of:
>  
> -  BPF_W   0x00    /* word */
> -  BPF_H   0x08    /* half word */
> -  BPF_B   0x10    /* byte */
> -  BPF_DW  0x18    /* double word */
> +  =============  =====  =====================
> +  mode modifier  value  description
> +  =============  =====  =====================
> +  BPF_IMM        0x00   used for 64-bit mov
> +  BPF_ABS        0x20
> +  BPF_IND        0x40
> +  BPF_MEM        0x60

May be say here that ABS and IND are legacy for compat with classic only?
and MEM is the most common modifier for load/store?

> +  BPF_ATOMIC     0xc0   atomic operations 

I removed trailing space in above line.

And applied all patches to bpf-next. Thanks!
