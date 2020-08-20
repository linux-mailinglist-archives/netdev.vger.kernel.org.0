Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A3824C766
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 23:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgHTVxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 17:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgHTVxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 17:53:32 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DC5C061385;
        Thu, 20 Aug 2020 14:53:31 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id h12so1777350pgm.7;
        Thu, 20 Aug 2020 14:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S9Z8hpT+5e288agiJKvAQ+cPNXvehT28abc/4EOiIj4=;
        b=Qy5SWJE12sxzcIftKB1/LCUfZ0kqq4F9mdgTqJ7o7Qe6le4UECdsoS6jAHLuVEwFAG
         EZodBvtj0SKUHoC0qq6j2SHZd3It0H6LcDTl8KuqWk/NGMeb1iz7o/ywXO9Jk8d9rkmG
         S/Gislu7WKnunM3AM7mxy/FjwWq5Tqb6O5OSgxT9aqkwgOQgzPFYSwSsyatDljdYdPe1
         zqgrLgIRXL1khYDyQirUv/76SphJeZlSbBZiDPa1d6Fc/dwVcASNu3tz60CYnr5jMxUN
         i0WC7RCk/Ti2BnQ6fx0v5TtDleDxjyX6yPVWvdfcSiZQ8OKkpFZWAiOuzSbJAR5Hg9zz
         JWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S9Z8hpT+5e288agiJKvAQ+cPNXvehT28abc/4EOiIj4=;
        b=Gdcgr4EU0KYEW5f9MLf5Pu4cQbHLSD5Wx/3PDT6HDAJ1v7Vf3KMxyR4ZSRYYFwU2hH
         9d4buX7og1iVTi+kQG2a7G5X4Vcma3RiM6WJPTAkRWNN8jMWkDMPqbUgd0Zu8BDplEus
         PkC0FeOdUi75G8VMuar7IomyCnOIK/o1fYbIzDEJ0yk6RmhWtqLT/x2FPOIHoz9PTUr2
         BnMu8xAwS9Z15+qryiN9yYjD1A3NguwI0TuEYF/GC4oiN/64HpAUTg1ZnupoQFlFUjVJ
         IYF1zT1cERZZu2/gtToOexFuJRfYJIveQHH0MDLwzVIbzNMBdwv56D0f55RBDEkNpa+/
         pPcw==
X-Gm-Message-State: AOAM532W9IISbxkJxnw+ATAwr94PO5ow30ts9PElzYIVHQUnItDPToTK
        VXJ4oizfd+4b9kp+4GNmy1g=
X-Google-Smtp-Source: ABdhPJwEOLAr4dCCQrc1S7uU7K/MDHikhI6jwqO4ud3WICgef1abJYYFxKi+yurZi1hirc408MUDbA==
X-Received: by 2002:a63:e258:: with SMTP id y24mr74849pgj.434.1597960411194;
        Thu, 20 Aug 2020 14:53:31 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8791])
        by smtp.gmail.com with ESMTPSA id w9sm3443224pgg.76.2020.08.20.14.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 14:53:30 -0700 (PDT)
Date:   Thu, 20 Aug 2020 14:53:27 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Hao Luo <haoluo@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [PATCH bpf-next v1 1/8] bpf: Introduce pseudo_btf_id
Message-ID: <20200820215327.jsvjbsvv6ts3x4wn@ast-mbp.dhcp.thefacebook.com>
References: <20200819224030.1615203-1-haoluo@google.com>
 <20200819224030.1615203-2-haoluo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819224030.1615203-2-haoluo@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 03:40:23PM -0700, Hao Luo wrote:
> +
>  /* verify BPF_LD_IMM64 instruction */
>  static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
>  {
> @@ -7234,6 +7296,9 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
>  		return 0;
>  	}
>  
> +	if (insn->src_reg == BPF_PSEUDO_BTF_ID)
> +		return check_pseudo_btf_id(env, insn);
> +
>  	map = env->used_maps[aux->map_index];
>  	mark_reg_known_zero(env, regs, insn->dst_reg);
>  	regs[insn->dst_reg].map_ptr = map;
> @@ -9255,6 +9320,9 @@ static int replace_map_fd_with_map_ptr(struct bpf_verifier_env *env)
>  				/* valid generic load 64-bit imm */
>  				goto next_insn;
>  
> +			if (insn[0].src_reg == BPF_PSEUDO_BTF_ID)
> +				goto next_insn;
> +

Why did you choose to do it during main do_check() walk instead of this pre-pass ?
check_ld_imm() can be called multiple times for the same insn,
so it's faster and less surprising to do it during replace_map_fd_with_map_ptr().
BTF needs to be parsed first, of course.
You can either move check_btf_info() before replace_map_fd_with_map_ptr() or
move replace_map_fd_with_map_ptr() after check_btf_info().
The latter is probably cleaner.
