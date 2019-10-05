Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF6FCC84A
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 08:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfJEGDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 02:03:12 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35091 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbfJEGDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 02:03:12 -0400
Received: by mail-pl1-f195.google.com with SMTP id c3so2677625plo.2;
        Fri, 04 Oct 2019 23:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+kB/pDJbKSOYQnNsLM6RtWH27TRijztzTo4+rcGO0Yg=;
        b=NDMddipupK/KoPoWPZ1PcfBVagdqiAyoVjNPqq4M+QQNpwNO9Z1M1bxLBMyWA6QKUw
         DgsTwVvTf1ieXEPr1Cj2GPxVKsH74JFhhxj4174oBa4sdnkKAwRWT9MGNxVshvbOnwsW
         dU0QmnE4riGE453+4iEyARcv6m1EATafVWEuwFtNn/5LvCUqyR2uoy+CSq4RYmicczaT
         cimn/k5umAU0lrhcPkkRs+nMyMaBEJ9wG+uakAobPPThTltLeH9aYkSuHrUm27N+Do9u
         B6QMPE+NN8uBQDmdsoXwSFszhQ54eCbqHCdM4rzVOjop+M7I/ZS64LALvMAdwaCKuDxX
         cGug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+kB/pDJbKSOYQnNsLM6RtWH27TRijztzTo4+rcGO0Yg=;
        b=TGz0/LlfjYNVe7lE92iyvRnlzZdGk9p2kv0YWeju6AMrL4jnvH7YMilu+agI4Wce+N
         HxpwNEjZOLCm3UABlG3YBhPNPKlPkHLalOrxnTxdNLL3yBgaw7Y6zZQ1EO04f2/C6OU0
         j1e+em6YcD5w9bcwKWMYIzbzv4IA4DTyRwfpLzKSLvuRHgkoDERBtPa+CGE6vp/Mlz6r
         XRqmL5ou48TBgNL2hE38o7pe64lNHtKpVmqW8+2JSpgblNVo5047Or86/24nRZ3T7LeH
         7qseJBvzrITxYY988tODNwhowGc4fXB1y+c6/YJgJAotejalWFIsfnU1wYC7qX6k0d7Z
         UbgQ==
X-Gm-Message-State: APjAAAXSGN7gb5RoBSPSpc62/QJunXBm4koT8wwEaj4+7E0CEq1vhhRV
        Q9Nalah6NZ1rpiht3O3ckiA=
X-Google-Smtp-Source: APXvYqyEyQzZtk858jgozNsaLtvUc2A1erHbtCtzCodSLVIBSssUHbS15t8kObbBHXYldeUwZAZEJA==
X-Received: by 2002:a17:902:8bc4:: with SMTP id r4mr18191999plo.341.1570255389372;
        Fri, 04 Oct 2019 23:03:09 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id v5sm9628752pfv.76.2019.10.04.23.03.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 23:03:08 -0700 (PDT)
Subject: Re: [PATCH bpf-next 07/10] bpf: add support for BTF pointers to x86
 JIT
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     daniel@iogearbox.net, x86@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
References: <20191005050314.1114330-1-ast@kernel.org>
 <20191005050314.1114330-8-ast@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <74e72059-7961-a65d-5a8c-5c50c7a4a453@gmail.com>
Date:   Fri, 4 Oct 2019 23:03:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191005050314.1114330-8-ast@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/19 10:03 PM, Alexei Starovoitov wrote:
> Pointer to BTF object is a pointer to kernel object or NULL.
> Such pointers can only be used by BPF_LDX instructions.
> The verifier changed their opcode from LDX|MEM|size
> to LDX|PROBE_MEM|size to make JITing easier.
> The number of entries in extable is the number of BPF_LDX insns
> that access kernel memory via "pointer to BTF type".

...

>  		}
>  		if (proglen == oldproglen) {
> -			header = bpf_jit_binary_alloc(proglen, &image,
> -						      1, jit_fill_hole);
> +			/*
> +			 * The number of entries in extable is the number of BPF_LDX
> +			 * insns that access kernel memory via "pointer to BTF type".
> +			 * The verifier changed their opcode from LDX|MEM|size
> +			 * to LDX|PROBE_MEM|size to make JITing easier.
> +			 */
> +			u32 extable_size = prog->aux->num_exentries *
> +				sizeof(struct exception_table_entry);
> +
> +			/* allocate module memory for x86 insns and extable */
> +			header = bpf_jit_binary_alloc(proglen + extable_size,
> +						      &image, 1, jit_fill_hole);
>  			if (!header) {
>  				prog = orig_prog;
>  				goto out_addrs;
>  			}
> +			prog->aux->extable = (void *) image + proglen;

You might want to align ->extable to __alignof__(struct exception_table_entry) (4 bytes currently)

