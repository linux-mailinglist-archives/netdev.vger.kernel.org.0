Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97C748CAB6
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356075AbiALSKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356130AbiALSJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:09:52 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14313C061212
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:09:27 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id i5so6378233uaq.10
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CkDLUchtiAQjQPvWP/g41Hk9LcgxdYKi8yd9DM0TO5o=;
        b=3zjk7AaChTB2HLGAruQKce7Ivss94jr/cQAwzbjFzQc4LJZ6VVWjcs5yca9IYbc/J+
         62OgrX2eTm2n1NWU4dCAVSIxQsO+Hq33HbrqtPtd7l02/mjchvzOmNXPOi8K9PkbREYf
         OKg1vjjzGl/S9KZN1jM7jIL42ZNHjDpHMqneJB/MZZTHcoSfAQohlPrgNdWD4OFAJBI2
         UWeZUmW6+GkJfXAIeSX6LBZMRHrkLQMBeP1bgq4AQ6iTZtsYkFgvrRD65D//bMD/L9Od
         QDuZr/vyOkFyl/ByhQ/aWn/ZbAXr19M1K1gJJ6D7QOYi8o4IT2Wd/Rl6V/YfJ+u42eqJ
         c6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CkDLUchtiAQjQPvWP/g41Hk9LcgxdYKi8yd9DM0TO5o=;
        b=pfMcNO52qvLO8V6rSNyVf6d6vFBYcwyIR5qA90Nc/39SxUpdWLO171sW9KLEjdE4cG
         bkJzJE+b4qLSpmsSjCiV4PKriFbMUovyTn/cTg7cDJXDNQ5+/kRUqY1IyvMfuP2eaXKM
         5+9vRuOSro4b6ZfH8uFd0tvvnYqkCcIeakWTxJrMQVvxQpTkBG2STQPW49XH6t+6btwl
         /GJ6eLYHDFlrgPmd+XzFgutRY+c9Os1NbVqvJYjku13JbgPpTkS1Y8GbahW7cPogb5bS
         qHQc2E8hsTMl74IXNkB2Pf4jWCi0C31gk3vtxZtsPpJk9zIpec0z9aL+oivMqKnIhslj
         ECCg==
X-Gm-Message-State: AOAM530ug72T/rCHHGiLLWdeOtYTTEde0p2lwneZcBmg4MjKqpvvQc3Z
        aMmA5P/JA4EfwMM0qSoPVDxwNA==
X-Google-Smtp-Source: ABdhPJyPdX7xWnC5iCZOdPnTFYLxXyl5TG8/4R8hMKzSkKATpfAGlCVK1HX5aK+poX6WFGANphhZNg==
X-Received: by 2002:a05:6102:ec7:: with SMTP id m7mr562406vst.43.1642010966227;
        Wed, 12 Jan 2022 10:09:26 -0800 (PST)
Received: from [192.168.1.8] ([149.86.74.57])
        by smtp.gmail.com with ESMTPSA id k23sm402484vsm.1.2022.01.12.10.09.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 10:09:25 -0800 (PST)
Message-ID: <6d76725c-6161-3acc-cf04-8e3f301e804b@isovalent.com>
Date:   Wed, 12 Jan 2022 18:09:23 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH bpf-next v4 6/8] bpftool: Implement btfgen()
Content-Language: en-GB
To:     =?UTF-8?Q?Mauricio_V=c3=a1squez?= <mauricio@kinvolk.io>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
References: <20220112142709.102423-1-mauricio@kinvolk.io>
 <20220112142709.102423-7-mauricio@kinvolk.io>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220112142709.102423-7-mauricio@kinvolk.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-01-12 09:27 UTC-0500 ~ Mauricio Vásquez <mauricio@kinvolk.io>
> btfgen() receives the path of a source and destination BTF files and a
> list of BPF objects. This function records the relocations for all
> objects and then generates the BTF file by calling btfgen_get_btf()
> (implemented in the following commits).
> 
> btfgen_record_obj() loads the BTF and BTF.ext sections of the BPF
> objects and loops through all CO-RE relocations. It uses
> bpf_core_calc_relo_insn() from libbpf and passes the target spec to
> btfgen_record_reloc() that saves the types involved in such relocation.
> 
> Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/bpf/bpftool/gen.c | 221 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 219 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index 905ab0ee6542..cef0ea99d4d9 100644

> +static int btfgen(const char *src_btf, const char *dst_btf, const char *objspaths[])
> +{
> +	struct btfgen_info *info;
> +	struct btf *btf_new = NULL;
> +	int err;
> +
> +	info = btfgen_new_info(src_btf);
> +	if (!info) {
> +		p_err("failed to allocate info structure: %s", strerror(errno));
> +		err = -errno;
> +		goto out;
> +	}
> +
> +	for (int i = 0; objspaths[i] != NULL; i++) {
> +		printf("OBJ : %s\n", objspaths[i]);

p_info()

> +
> +		err = btfgen_record_obj(info, objspaths[i]);
> +		if (err)
> +			goto out;
> +	}
> +
> +	btf_new = btfgen_get_btf(info);
> +	if (!btf_new) {
> +		err = -errno;
> +		p_err("error generating btf: %s", strerror(errno));
> +		goto out;
> +	}
> +
> +	printf("DBTF: %s\n", dst_btf);

p_info()
