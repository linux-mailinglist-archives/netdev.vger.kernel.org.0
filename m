Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B1015601
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 00:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfEFWZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 18:25:49 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36992 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfEFWZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 18:25:48 -0400
Received: by mail-wm1-f68.google.com with SMTP id y5so17199358wma.2
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 15:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=x2SgwnqATieY2WvANoSNGQZvNpE578kNebP/0S40QH8=;
        b=BxlG4uxITnnuBBsIfSoLGR8qNWAc47Kd23QEA87uLPd58MeQAxxfPJ0HkbiF7yjwVY
         hrq5EmxwUwqXKN/KusUnQZqFoG4HKu6NBCNI85pFQz4WjoF8WC9jbQLTHa1q0UCIP56d
         GfalW+7Wcv3EbN6NuGicJWudGb6eUzGEi11yMbPX/K4Tgpeoot6WOIff2gREwmiisW2S
         0q6SMrX8oIFTaPQ7FwrPntPzmq2A02WRtar/wOVHRMcQGBTwa7wbhzjWJCrj1Tgzp66f
         KlDjujnjEyUSHTG6C339t+hKtPi9rm2ITd+s5R9YHD2++zyzKRZvr/DomvF+nklAYJHc
         8RfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=x2SgwnqATieY2WvANoSNGQZvNpE578kNebP/0S40QH8=;
        b=ndvY8eiN7zaL0+uUMNFCmLR+IVVG9ZbBH3aQvHCvAV+TZIknAM0zwxvDQZ8q/WBHY6
         +heUNDlKa+hde1tXQzylJBcEFRTpnbbUVlKFcbwWJqYG9DOaG761sYSAVpcKVZDnhZem
         fsCHHj/OHBHqyLSndQk3eGQ5YjWNhxQ1Ph9vH8H5paJwJlmEHMFbZxW2DRWnG125N6K2
         We3qs/8pSoTJ1T9+tD2Con+hjdNIWI0xmcXx+Mcrw7ozJgBTGZEUnwemWQUiNPu+MsOa
         Ky4L14Ahq2rF8pDf/4hTSsDhpjYg5OFuZVWl1eR+jzf3ivDksxIUjEyrxGo46FxuxMY6
         M3Fw==
X-Gm-Message-State: APjAAAXv38dyMPth4/BHDQDLLPT7eEjn1mkpT5G9GmJtRzojixtfJR9r
        FkxvvSkf7pHuv3XqdQLfe8pc+w==
X-Google-Smtp-Source: APXvYqwQ2yvZqNlqS/QK+rEhX5ZAl2ejwrR7Vh5xFnQGtWHwyfESjU4u2FqGI3DMR92NMxoDEvNYjg==
X-Received: by 2002:a1c:2ecd:: with SMTP id u196mr7839788wmu.111.1557181546643;
        Mon, 06 May 2019 15:25:46 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL (cpc1-cmbg19-2-0-cust104.5-4.cable.virginm.net. [82.27.180.105])
        by smtp.gmail.com with ESMTPSA id a20sm24358066wrf.37.2019.05.06.15.25.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 15:25:45 -0700 (PDT)
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com> <1556880164-10689-2-git-send-email-jiong.wang@netronome.com> <2c83afa7-d3ba-0881-e98f-81a406367f93@iogearbox.net>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        alexei.starovoitov@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH v6 bpf-next 01/17] bpf: verifier: offer more accurate helper function arg and return type
In-reply-to: <2c83afa7-d3ba-0881-e98f-81a406367f93@iogearbox.net>
Date:   Mon, 06 May 2019 23:25:44 +0100
Message-ID: <87k1f3usnr.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Borkmann writes:

> On 05/03/2019 12:42 PM, Jiong Wang wrote:
>> BPF helper call transfers execution from eBPF insns to native functions
>> while verifier insn walker only walks eBPF insns. So, verifier can only
>> knows argument and return value types from explicit helper function
>> prototype descriptions.
>> 
>> For 32-bit optimization, it is important to know whether argument (register
>> use from eBPF insn) and return value (register define from external
>> function) is 32-bit or 64-bit, so corresponding registers could be
>> zero-extended correctly.
>> 
>> For arguments, they are register uses, we conservatively treat all of them
>> as 64-bit at default, while the following new bpf_arg_type are added so we
>> could start to mark those frequently used helper functions with more
>> accurate argument type.
>> 
>>   ARG_CONST_SIZE32
>>   ARG_CONST_SIZE32_OR_ZERO
>
> For the above two, I was wondering is there a case where the passed size is
> not used as 32 bit aka couldn't we generally assume 32 bit here w/o adding
> these two extra arg types?

Will give a detailed reply tomorrow. IIRC there was. I was benchmarking
bpf_lxc and found it contains quite a few helper calls which generates a
fairly percentage of unnecessary zext on parameters.

> For ARG_ANYTHING32 and RET_INTEGER64 definitely
> makes sense (btw, opt-in value like RET_INTEGER32 might have been easier for
> reviewing converted helpers).
>
>>   ARG_ANYTHING32
>> 
>> A few helper functions shown up frequently inside Cilium bpf program are
>> updated using these new types.
>> 
>> For return values, they are register defs, we need to know accurate width
>> for correct zero extensions. Given most of the helper functions returning
>> integers return 32-bit value, a new RET_INTEGER64 is added to make those
>> functions return 64-bit value. All related helper functions are updated.
>> 
>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> [...]
>
>> @@ -2003,9 +2003,9 @@ static const struct bpf_func_proto bpf_csum_diff_proto = {
>>  	.pkt_access	= true,
>>  	.ret_type	= RET_INTEGER,
>>  	.arg1_type	= ARG_PTR_TO_MEM_OR_NULL,
>> -	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
>> +	.arg2_type	= ARG_CONST_SIZE32_OR_ZERO,
>>  	.arg3_type	= ARG_PTR_TO_MEM_OR_NULL,
>> -	.arg4_type	= ARG_CONST_SIZE_OR_ZERO,
>> +	.arg4_type	= ARG_CONST_SIZE32_OR_ZERO,
>>  	.arg5_type	= ARG_ANYTHING,
>>  };
>
> I noticed that the above and also bpf_csum_update() would need to be converted
> to RET_INTEGER64 as they would break otherwise: it's returning error but also
> u32 csum value, so use for error checking would be s64 ret =
> bpf_csum_xyz(...).

Ack.

(I did searched ^u64 inside upai header, should also search ^s64, will
double-check all changes)

>
> Thanks,
> Daniel

