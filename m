Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAFAD19650
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 03:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfEJBx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 21:53:58 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35476 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfEJBx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 21:53:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id t87so2303136pfa.2;
        Thu, 09 May 2019 18:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=imHmjd3FjLPkdyNzm2S8aV5NU8a+XaJpO3Z+38YTWEQ=;
        b=o0SVgpc8f+XqwILolMc9q+PIph8+IZIYY7i9dNM71N/sC+ZK/4r584yrzVBLkH3HUY
         7m9Yhq7LF5dce3iJa+AXeYua5lOkul8g8zU8Xvs4i/gRplNJ/66yuUOuTdUiekTOea0f
         fFFZBQZZ4b41luFJn6btVY2GNWACXSXtIzScS0c/cpYQfy0oZ0VVGYONRujAFIF6bBRP
         mNmGtMqIBqzVFFMc9smIDo7r8xWg1roRdPmdKyDItqjy+DhcoZ3WytxIdOd1DW12UGgg
         gJsYBp/sfp8bMkOUqYbEDlvBkYGpRELqknARHpVBAGxCKW0u6E3Jvgd7I135t5kmcRg/
         ICCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=imHmjd3FjLPkdyNzm2S8aV5NU8a+XaJpO3Z+38YTWEQ=;
        b=uRV04zz3PUDBjjm0vVhmgMU2ODHDh2LB7GJzjxZZKO32avCW3eeTw4Wfwpj8NKBn+N
         aHTPQuKSwVkGhA4Vx/6JWWW7FpoupKfvlAWSLlNuqd8P5xVpKL3opeXMHyeDFXsm1sdb
         Bg+wNxRX19TniTu+a+4b6Egoeic5U7WaXb1zLORgBXBfcpkm0ygKxoshaDwF4PHX/Job
         oxim1s92UFGaDx/AR3SMcEi1lrw1a4aoRM9XyXCs2FLKPni4Pvs9risrFFr2fa6B09Dn
         Iy7pXn+beUf0/LTTNvCmw5ijgSudHX4/VNSD6Cycl74/QwRoPduCu+mjZiDIL4rnXKZM
         rfBg==
X-Gm-Message-State: APjAAAVISBXN8QuNt4WchcQs3UwidQqZi6J4GpABkjgg2IIRwfwO86Aa
        b4cCEs2uGg7q26Hbp6Obrs8=
X-Google-Smtp-Source: APXvYqwBsfYMM2SooMccb8lxVymGcDKm5fkyy7QjNiDt/XYB8LIp0ZdUqHA0sTcWO1qX4fSUUOJQ0g==
X-Received: by 2002:aa7:99dd:: with SMTP id v29mr10433184pfi.252.1557453236880;
        Thu, 09 May 2019 18:53:56 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::bc44])
        by smtp.gmail.com with ESMTPSA id e6sm9064876pfl.115.2019.05.09.18.53.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 18:53:56 -0700 (PDT)
Date:   Thu, 9 May 2019 18:53:54 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH v6 bpf-next 01/17] bpf: verifier: offer more accurate
 helper function arg and return type
Message-ID: <20190510015352.6w6fghcthtjj74pl@ast-mbp>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
 <1556880164-10689-2-git-send-email-jiong.wang@netronome.com>
 <20190506155041.ofxsvozqza6xrjep@ast-mbp>
 <87mujx6m4n.fsf@netronome.com>
 <20190508175111.hcbufw22mbksbpca@ast-mbp>
 <87ef5795b5.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ef5795b5.fsf@netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 01:32:30PM +0100, Jiong Wang wrote:
> 
> Alexei Starovoitov writes:
> 
> > On Wed, May 08, 2019 at 03:45:12PM +0100, Jiong Wang wrote:
> >> 
> >> I might be misunderstanding your points, please just shout if I am wrong.
> >> 
> >> Suppose the following BPF code:
> >> 
> >>   unsigned helper(unsigned long long, unsigned long long);
> >>   unsigned long long test(unsigned *a, unsigned int c)
> >>   {
> >>     unsigned int b = *a;
> >>     c += 10;
> >>     return helper(b, c);
> >>   }
> >> 
> >> We get the following instruction sequence by latest llvm
> >> (-O2 -mattr=+alu32 -mcpu=v3)
> >> 
> >>   test:
> >>     1: w1 = *(u32 *)(r1 + 0)
> >>     2: w2 += 10
> >>     3: call helper
> >>     4: exit
> >> 
> >> Argument Types
> >> ===
> >> Now instruction 1 and 2 are sub-register defines, and instruction 3, the
> >> call, use them implicitly.
> >> 
> >> Without the introduction of the new ARG_CONST_SIZE32 and
> >> ARG_CONST_SIZE32_OR_ZERO, we don't know what should be done with w1 and
> >> w2, zero-extend them should be fine for all cases, but could resulting in a
> >> few unnecessary zero-extension inserted.
> >
> > I don't think we're on the same page.
> > The argument type is _const_.
> > In the example above they are not _const_.
> 
> Right, have read check_func_arg + check_helper_mem_access again.
> 
> Looks like ARG_CONST_SIZE* are designed for describing memory access size
> for things like bounds checking. It must be a constant for stack access,
> otherwise prog will be rejected, but it looks to me variables are allowed
> for pkt/map access.
> 
> But pkt/map has extra range info. So, indeed, ARG_CONST_SIZE32* are
> unnecessary, the width could be figured out through the range.
> 
> Will just drop this patch in next version.
> 
> And sorry for repeating it again, I am still concerned on the issue
> described at https://www.spinics.net/lists/netdev/msg568678.html.
> 
> To be simple, zext insertion is based on eBPF ISA and assumes all
> sub-register defines from alu32 or narrow loads need it if the underlying

It's not an assumption. It's a requirement. If JIT is not zeroing
upper 32-bits after 32-bit alu or narrow load it's a bug.

> hardware arches don't do it. However, some arches support hardware zext
> partially. For example, PowerPC, SPARC etc are 64-bit arches, while they
> don't do hardware zext on alu32, they do it for narrow loads. And RISCV is
> even more special, some alu32 has hardware zext, some don't.
> 
> At the moment we have single backend hook "bpf_jit_hardware_zext", once a
> backend enable it, verifier just insert zero extension for all identified
> alu32 and narrow loads.
> 
> Given verifier analysis info is not pushed down to JIT back-ends, verifier
> needs more back-end info pushed up from back-ends. Do you think make sense
> to introduce another hook "bpf_jit_hardware_zext_narrow_load" to at least
> prevent unnecessary zext inserted for narrowed loads for arches like
> PowerPC, SPARC?
> 
> The hooks to control verifier zext insertion then becomes two:
> 
>   bpf_jit_hardware_zext_alu32
>   bpf_jit_hardware_zext_narrow_load

and what to do with other combinations?
Like in some cases narrow load on particular arch will be zero extended
by hw and if it's misaligned or some other condition then it will not be?
It doesn't feel that we can enumerate all such combinations.
It feels 'bpf_jit_hardware_zext' backend hook isn't quite working.
It optimizes out some zext, but may be adding unnecessary extra zexts.

May be it should be a global flag from the verifier unidirectional to JITs
that will say "the verifier inserted MOV32 where necessary. JIT doesn't
need to do zext manually".
And then JITs will remove MOV32 when hw does it automatically.
Removal should be easy, since such insn will be right after corresponding
alu32 or narrow load.

