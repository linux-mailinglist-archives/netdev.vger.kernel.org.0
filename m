Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9636E44CB4E
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 22:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbhKJV2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 16:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbhKJV2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 16:28:45 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1788C061766;
        Wed, 10 Nov 2021 13:25:57 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id m26so3784743pff.3;
        Wed, 10 Nov 2021 13:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7t8P8Q4j/y6WykkDsECi+hA6gTG4UAWOCLccneL7O0Y=;
        b=KNVYELvEFH8mBkAfPuf2YY5J6TLGj+RiZc2ebrsshM/fA9BbmQU1OXGhnsyWT4ZyZr
         uArgiF0JyiTiTUOffJC/a7xPx1WGq8gYSRcZaU1bNErMmEA6XQZt94dun0Q/8Tqox9DR
         hvDgatQ1aNxY1yF+oj0XDAvrmcbv28X3KEynJ6RVASip//cq29NhO1aT8s6DFsw+TYsU
         OEEBgFICT7uePsvyqJlmIJHNJZLGSbwz4P81GVtz6T8UVOLpXJcCSBdyzB1hRJLCayef
         hf1MBjev9rj6rRrY1rCdSNRk3WIik70lTwbMuRWxaKofnrReEYbu8KxJom011VsZw6aH
         HNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7t8P8Q4j/y6WykkDsECi+hA6gTG4UAWOCLccneL7O0Y=;
        b=5GH19JLib2PD72bsw5N1oaeXAXUzcSLV55a0YCYvHy8cfs0iFpuR4YiGmQevBJPvPa
         5nxn03H/C7LedrO90kiq3Z8N6yoJF1IHLHh3cQxNZEEL7I+CLh/y3zqJ6QWQKXOR9iFw
         U83P+cYgkDygGSdvrM3tL2FRcWaiiKnHVfotfTXRpq0wyMWor1T3hrxQeoVNc1oHPFhd
         sRIw4BJ55wtbKF1MT6DA5qem/VFb3uWbeSbpQ5trWZYbBEq0+PwIkuPBmTVRzsHqYwJy
         iDbfLAqC+QED6EDCmIK1b1MwdVK5UCn8OZEtoolwai3Ubo0XhWp6O0ZkeQfyLjFHp2qP
         N/tA==
X-Gm-Message-State: AOAM532CqncBYoY085xDGxuxumU9haO+c+ztQoBReJAbklurxc3AF8WE
        D52lEdKBZzWs5kQQWpLnisk=
X-Google-Smtp-Source: ABdhPJx0kIy6PXhciEVv9Ca2RI46mgs/wQnd4mZdy5xG/0l/nwnVgXwqTD7YHxfE59iTrxsAi2/45g==
X-Received: by 2002:a63:6e4d:: with SMTP id j74mr1248223pgc.257.1636579557352;
        Wed, 10 Nov 2021 13:25:57 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id f11sm412263pga.11.2021.11.10.13.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 13:25:57 -0800 (PST)
Date:   Thu, 11 Nov 2021 02:55:53 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, andrii@kernel.org,
        songliubraving@fb.com, yhs@fb.com
Subject: Re: [PATCH net v2] bpf: Fix build when CONFIG_BPF_SYSCALL is disabled
Message-ID: <20211110212553.e2xnltq3dqduhjnj@apollo.localdomain>
References: <20211110205418.332403-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110205418.332403-1-vinicius.gomes@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 02:24:18AM IST, Vinicius Costa Gomes wrote:
> When CONFIG_DEBUG_INFO_BTF is enabled and CONFIG_BPF_SYSCALL is
> disabled, the following compilation error can be seen:
>
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   AR      init/built-in.a
>   LD      vmlinux.o
>   MODPOST vmlinux.symvers
>   MODINFO modules.builtin.modinfo
>   GEN     modules.builtin
>   LD      .tmp_vmlinux.btf
> ld: net/ipv4/tcp_cubic.o: in function `cubictcp_unregister':
> net/ipv4/tcp_cubic.c:545: undefined reference to `bpf_tcp_ca_kfunc_list'
> ld: net/ipv4/tcp_cubic.c:545: undefined reference to `unregister_kfunc_btf_id_set'
> ld: net/ipv4/tcp_cubic.o: in function `cubictcp_register':
> net/ipv4/tcp_cubic.c:539: undefined reference to `bpf_tcp_ca_kfunc_list'
> ld: net/ipv4/tcp_cubic.c:539: undefined reference to `register_kfunc_btf_id_set'
>   BTF     .btf.vmlinux.bin.o
> pahole: .tmp_vmlinux.btf: No such file or directory
>   LD      .tmp_vmlinux.kallsyms1
> .btf.vmlinux.bin.o: file not recognized: file format not recognized
> make: *** [Makefile:1187: vmlinux] Error 1
>
> 'bpf_tcp_ca_kfunc_list', 'register_kfunc_btf_id_set()' and
> 'unregister_kfunc_btf_id_set()' are only defined when
> CONFIG_BPF_SYSCALL is enabled.
>
> Fix that by moving those definitions somewhere that doesn't depend on
> the bpf() syscall.
>
> Fixes: 14f267d95fe4 ("bpf: btf: Introduce helpers for dynamic BTF set registration")
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Thanks for the fix.

But instead of moving this to core.c, you can probably make the btf.h
declaration conditional on CONFIG_BPF_SYSCALL, since this is not useful in
isolation (only used by verifier for module kfunc support). For the case of
kfunc_btf_id_list variables, just define it as an empty struct and static
variables, since the definition is still inside btf.c. So it becomes a noop for
!CONFIG_BPF_SYSCALL.

I am also not sure whether BTF is useful without BPF support, but maybe I'm
missing some usecase.

That's just my opinion however, I'll defer to BPF maintainers.

--
Kartikeya
