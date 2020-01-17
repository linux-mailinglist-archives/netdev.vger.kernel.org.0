Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E8B140E63
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 16:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgAQP4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 10:56:02 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43876 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729108AbgAQP4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 10:56:02 -0500
Received: by mail-wr1-f66.google.com with SMTP id d16so23214571wre.10
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 07:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/xDNB5x2Pqgumh7EdT3mX4eeIVee1TWuWd3DRGi+IwM=;
        b=0rorb5zKlzzyDzahBLOhNKd6H71DhQl8cRPbfIH2OOEdh8j+7u7V0CMRe1ktS1l50h
         vVgROMNlFUoR4V99+JX/dFmQqPElvbfOhCGFi4soNyNyMc4nt54VkqK6Ns0QB51DG54f
         jBtB8JyVG9gPduOuTTAgmZYzwl2rHDDw0F4vWw82l9s9tAnfrjEWBp9KswJTm5Z6lpDm
         QwkXmbinDtyAKoqov1rlqkO8PeTVR5gbyWavdahz2vYIBSIFlahDe+fnSqRT7vbtzEAP
         75261KeVF6nYKTgZoGJ1Mcefiq1hCn36+ZX6rbk1a6ApPvKsWLlPwwZ/pP2aT1VCPclK
         6mxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/xDNB5x2Pqgumh7EdT3mX4eeIVee1TWuWd3DRGi+IwM=;
        b=E4yqDj0+e9kTLwuBdFjD8b+DyzX4i9DNrKWegdXNGbmZ9otEz7v7HLZO4lT+HBE2wM
         /iwPL6yF7HNXKG65LpvdOvVWI9KZULvon0rHDMycUeiCe1xqhm5teVktTEhq9oQ20wQn
         /G9mvUBJq1EAm18WtdPg2zZ8EgRX9quxCbtbXFXtSF+kPxDMV5eLP8a+4XE5yvipK130
         TMrd4Jl5mB0acNEc74gAcjdYNzWnl5Lp3dgzf7FBwMJS6RsuwOs5DhowPG/YgRasyaU9
         B+F7wZj/YLdE9xLzpsNf4wm4BMR8K92ytLW6/q50msZrQKKyvdDo9m4SuHD5imJPe1XP
         qXsQ==
X-Gm-Message-State: APjAAAXnbP78qGvW2BerbiMP0+mEkKtF+ilx5hcLQ27HZKUFk/v70NnZ
        eiFGaRDtqhjAIxg+w/ZhBExlzQ==
X-Google-Smtp-Source: APXvYqwJvaNhqRIe3CqVj0Uk6hCrdVJPGp4msEg0pMMdAvcXcfGo9dxycYpUhkeZpPpHhSy9WKC3SQ==
X-Received: by 2002:adf:ff84:: with SMTP id j4mr3836185wrr.27.1579276558771;
        Fri, 17 Jan 2020 07:55:58 -0800 (PST)
Received: from [192.168.1.43] ([91.143.66.155])
        by smtp.gmail.com with ESMTPSA id g25sm3591793wmh.3.2020.01.17.07.55.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Jan 2020 07:55:57 -0800 (PST)
Subject: Re: [PATCH bpf-next 4/4] bpftool: avoid const discard compilation
 warning
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200117060801.1311525-1-andriin@fb.com>
 <20200117060801.1311525-5-andriin@fb.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Message-ID: <a1f6c13d-775c-6e48-6102-27332b5366a1@netronome.com>
Date:   Fri, 17 Jan 2020 15:55:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200117060801.1311525-5-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-01-16 22:08 UTC-0800 ~ Andrii Nakryiko <andriin@fb.com>
> Avoid compilation warning in bpftool when assigning disassembler_options by
> casting explicitly to non-const pointer.
> 
> Fixes: 3ddeac6705ab ("tools: bpftool: use 4 context mode for the NFP disasm")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/bpf/bpftool/jit_disasm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
> index bfed711258ce..22ef85b0f86c 100644
> --- a/tools/bpf/bpftool/jit_disasm.c
> +++ b/tools/bpf/bpftool/jit_disasm.c
> @@ -119,7 +119,7 @@ void disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
>  	info.arch = bfd_get_arch(bfdf);
>  	info.mach = bfd_get_mach(bfdf);
>  	if (disassembler_options)
> -		info.disassembler_options = disassembler_options;
> +		info.disassembler_options = (char *)disassembler_options;
>  	info.buffer = image;
>  	info.buffer_length = len;
>  
> 

Thanks Andrii,

This fix has been proposed and discussed before:
https://lore.kernel.org/bpf/20190328141652.wssqboyekxmp6tkw@yubo-2/t/#u

I still believe that we should not add the cast.

Best regards,
Quentin
