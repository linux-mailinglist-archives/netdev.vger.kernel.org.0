Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A953158675
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 01:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgBKAPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 19:15:31 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45912 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbgBKAPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 19:15:30 -0500
Received: by mail-pf1-f193.google.com with SMTP id 2so4504937pfg.12;
        Mon, 10 Feb 2020 16:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r5ohSbrtojTxCSFCkg8rYW9zCxgtMfpQZkLpXgHPTpk=;
        b=KQylGPxdiaGvk+7Y+4BneWCRdxmvASR00418Jv7gHTm/EZxZkAZt8Hj7qbRh3JOGFy
         oxl2x5m6yV6iMc5YLIlOjEox0c90qBOT+fwVam8DvtExHZ1JkoYBwPjGtqNhiRcZzwQq
         TtY0mLuruewCig3yfcTFRMCAesZI8xyGIGReVInSiRC1XvxvpQq6veSmY1sNTWCG4Fwl
         LLMc6e0KVLz+vy3Umv/5RTzT1ubEHIv95CCcWRKM8oKJcjqI1cX1Y8UcJSx9wMbYbBi7
         H3aZXfZWPc9EK8I+72g6uwnDPYF0MUz4QJtn6UjV0uyHk3G1avz4AXDxhznkFQy9s/5o
         JNFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=r5ohSbrtojTxCSFCkg8rYW9zCxgtMfpQZkLpXgHPTpk=;
        b=BWJkqB8kaXTQ6vRF2tfYkpBrwH5Aal6vL1eAr01oX1eJZmRWaMdlXeSb+bT5Wxq0ev
         lnD7SH0TK7edouZG0a82L94GS6l2gAz2Ls9shKGUmebYbR7m7jI+MTkaeidC9DY8wEpG
         pTiTkiBx9KioZ4HyKMvP9bNN7bEpqUhzP8XgsBjlqh/RC//rXTR5kmyy5lKSZZCqUIcK
         appJ9QczHPEmclmdmhUVhdF6Z7vAy7Wk/Pu7eH4x1Jh1xN3b0L8S2WP7ze8C5wUWVu87
         jcxchbeZgZedXllDkuiwxdvOR86zNa8zoG/A+DqQnXwTI4a3FwFFz2yxM1HAq7Ghl+ZB
         fa7Q==
X-Gm-Message-State: APjAAAWuyuIpZdTjeu2Lf6XZxEOFiZd6kCV23/J4MXkrVK1roLjQvTLf
        DYorImDf4/koNJ1Pv9bat+s=
X-Google-Smtp-Source: APXvYqwaI1pmqbF0HQJmCdNPwqmI2s1WtrWOIQeTyY/IRieg6LQrDFvOhcDN4OionXTTqMh7Vs1K2g==
X-Received: by 2002:a65:5549:: with SMTP id t9mr4124065pgr.439.1581380129926;
        Mon, 10 Feb 2020 16:15:29 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::2:685c])
        by smtp.gmail.com with ESMTPSA id z26sm1201161pgu.80.2020.02.10.16.15.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Feb 2020 16:15:29 -0800 (PST)
Date:   Mon, 10 Feb 2020 16:15:27 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Bjorn Topel <bjorn.topel@gmail.com>, daniel@iogearbox.net,
        ast@kernel.org, zlim.lnx@gmail.com, catalin.marinas@arm.com,
        will@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, shuah@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com, kernel-team@android.com
Subject: Re: [PATCH 4/4] arm64: bpf: Elide some moves to a0 after calls
Message-ID: <20200211001526.xbfwdnpjqrg3ed6q@ast-mbp>
References: <20200128021145.36774-1-palmerdabbelt@google.com>
 <20200128021145.36774-5-palmerdabbelt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128021145.36774-5-palmerdabbelt@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 06:11:45PM -0800, Palmer Dabbelt wrote:
>  
> +	/* Handle BPF_REG_0, which may be in the wrong place because the ARM64
> +	 * ABI doesn't match the BPF ABI for function calls. */
> +	if (ctx->reg0_in_reg1) {
> +		/* If we're writing BPF_REG_0 then we don't need to do any
> +		 * extra work to get the registers back in their correct
> +		 * locations. */
> +		if (insn->dst_reg == BPF_REG_0)
> +			ctx->reg0_in_reg1 = false;
> +
> +		/* If we're writing to BPF_REG_1 then we need to save BPF_REG_0
> +		 * into the correct location if it's still alive, as otherwise
> +		 * it will be clobbered. */
> +		if (insn->dst_reg == BPF_REG_1) {
> +			if (!dead_register(ctx, off + 1, BPF_REG_0))
> +				emit(A64_MOV(1, A64_R(7), A64_R(0)), ctx);
> +			ctx->reg0_in_reg1 = false;
> +		}
> +	}

I'm not sure this is correct, since it processes insns as a linear code, but
there could be jumps in the middle. The logic should be following the control
flow of the program. The verifier is a better place to do such analysis.
I don't see how JITs can do it on their own.
