Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3114CCE21
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 06:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfJFEAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 00:00:42 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41936 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfJFEAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 00:00:42 -0400
Received: by mail-io1-f66.google.com with SMTP id n26so21692671ioj.8;
        Sat, 05 Oct 2019 21:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=A+tBkYadqSd6pEKJzNOFwe+pAuxIx5Y6jSkDvXBqQIk=;
        b=alAY01nAifBAhp67mDbKCybYOH1jmDGBhwacz0mtok3QOc9B7dBGhU2rfDRSWm2Bls
         s4NqXpiLDqAI381Z5N7nPHRx1IIkJAXQdqnsFBa12RHOF05q2yoPCE3FYjVVuVrC1pCs
         ey7/5/ekiegGxtNoewkkdFey6Vw+RjvWTqeqSnDBy8NUIvOAfkV1xCA9pKyXuoxTw76L
         14Xnrity4xchNcnJ9mN/z376w7jllF6JywM7R9ZCadrAL/3sNPsEk7/FCOrJAB18blHV
         XNWHQKJKBYJQ6vuLdLAjNieQVHlGvO4nNavptNUHq/Nfb9I1ksVTGOCxhVZj+RbAsafb
         pBJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=A+tBkYadqSd6pEKJzNOFwe+pAuxIx5Y6jSkDvXBqQIk=;
        b=dI1nfdcSWRiVg1rgn9MvwZ2tCWFLwZCAEs3I43rC6iDu3PHSlj+T29lbwBzYQ0JSlL
         lIaJ2g+nhErgtsal1M8FR62ABOePT8yIiy0V+KP33pvHyavstPW5+A92XOFniqDKw/LL
         LttnVAO5p5+1vcznJkQBWYeH5ae4NYryWnnd8uoECQ4pmLTprpJl5gicp54gMIZrJA9L
         x+Y2bRenj7nl8T5gBD1tEdU3vX+UntLNeEvhLwTxYEHLkMRZWWxqEzboXq/Nco5LH3ze
         Pm33PpUQR5KUvwWcfb2OcLIQ88IzuqmHBvcAUau/BekVA3OnWE+PukCh/m3zj+Mu8siI
         Asdw==
X-Gm-Message-State: APjAAAVfEi1LCvH7WrCcN1SuwHLrv4DFe5X4NQtJEr5f5XowjC/HG1qX
        0+CKEXZWlYD+iVBuJ2PhHmTO/L8xTW4=
X-Google-Smtp-Source: APXvYqzcFgINfSWqzHdoSzySngou2E743vzAYMrc2QFas8Dvkcd2Dl/njLcqrG9z4f6x3AG4PEvRqA==
X-Received: by 2002:a6b:b2c3:: with SMTP id b186mr7711869iof.128.1570334440191;
        Sat, 05 Oct 2019 21:00:40 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h17sm4682704ilq.66.2019.10.05.21.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 21:00:39 -0700 (PDT)
Date:   Sat, 05 Oct 2019 21:00:32 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     daniel@iogearbox.net, x86@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Message-ID: <5d9966e09618b_41932aacfa49e5b8cb@john-XPS-13-9370.notmuch>
In-Reply-To: <20191005050314.1114330-3-ast@kernel.org>
References: <20191005050314.1114330-1-ast@kernel.org>
 <20191005050314.1114330-3-ast@kernel.org>
Subject: RE: [PATCH bpf-next 02/10] bpf: add typecast to bpf helpers to help
 BTF generation
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> When pahole converts dwarf to btf it emits only used types.
> Wrap existing bpf helper functions into typedef and use it in
> typecast to make gcc emits this type into dwarf.
> Then pahole will convert it to btf.
> The "btf_#name_of_helper" types will be used to figure out
> types of arguments of bpf helpers.
> The generate code before and after is the same.
> Only dwarf and btf are different.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/filter.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 2ce57645f3cd..d3d51d7aff2c 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -464,10 +464,11 @@ static inline bool insn_is_zext(const struct bpf_insn *insn)
>  #define BPF_CALL_x(x, name, ...)					       \
>  	static __always_inline						       \
>  	u64 ____##name(__BPF_MAP(x, __BPF_DECL_ARGS, __BPF_V, __VA_ARGS__));   \
> +	typedef u64 (*btf_##name)(__BPF_MAP(x, __BPF_DECL_ARGS, __BPF_V, __VA_ARGS__)); \
>  	u64 name(__BPF_REG(x, __BPF_DECL_REGS, __BPF_N, __VA_ARGS__));	       \
>  	u64 name(__BPF_REG(x, __BPF_DECL_REGS, __BPF_N, __VA_ARGS__))	       \
>  	{								       \
> -		return ____##name(__BPF_MAP(x,__BPF_CAST,__BPF_N,__VA_ARGS__));\
> +		return ((btf_##name)____##name)(__BPF_MAP(x,__BPF_CAST,__BPF_N,__VA_ARGS__));\
>  	}								       \
>  	static __always_inline						       \
>  	u64 ____##name(__BPF_MAP(x, __BPF_DECL_ARGS, __BPF_V, __VA_ARGS__))
> -- 
> 2.20.0
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
