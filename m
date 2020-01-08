Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BBA134632
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 16:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgAHP2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 10:28:34 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46025 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728927AbgAHP2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 10:28:33 -0500
Received: by mail-wr1-f68.google.com with SMTP id j42so3758748wrj.12
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 07:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V+jjQ4Ip9VghYx4Ogoeys27CKAs+Gf9yYIGWHjojKP4=;
        b=C0rT988ua9tw5YGgg+iHRVuWkLt2IMZ3t00QD8f68MvEHxgNT+gI8znrD7VGuk4VF1
         sXanIE0z0BKh2924mEqk4nzNVKcwuH8ZLaWf/kUAhI1ZioPspwFKA2TQlmQTaeUHp9Gz
         0huHTUXygWfK0o+XLbzjgnU2Q/WN3dV5MtCd1bSvkeg9I+hrDQVFRv503UNJy4LGVWbK
         T6mtftG0hSe89xQq7iNt4JksgEAvouw9RxfAz/hieIM+LSKpc6/EahQipNFdSEsv8QYt
         d2j9Ta2W4gEuZitnCWpUsG/VpO00CUiYCpRuJl+YJyGHdLI56QLzsnpAxV+UXe6HO9KQ
         egUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=V+jjQ4Ip9VghYx4Ogoeys27CKAs+Gf9yYIGWHjojKP4=;
        b=bDx7xuR0n812zG08/oKY7CkHMlNtan+XRBzJq1X7uYr8dxqBBRxuTEYVb1H3ubvhAB
         mIqU0taWqnZ63oRkOqfMOCS/n7SlZRgtHlYuLAheF7LmW4Gr41zsrh96NPMZIqMgxWsE
         hoUIaCTL8ZuRaQuTybyGzPzDBRR4ZaVcugWMze4IKiHkOsRYYJNx9kfDQ3cSXMK8cWRE
         Rk7x4CsDlb1U83OmA2iXLoeiWqyPVoiJWg2U6G4oR7UUrE9kp7LN1dfaewvsOqsyxGJ7
         4k7zz+qz/p9ArYzyAbn4dm3piVqzSnoyW7E2rYxOodNJr4qJ/53qO+vNXPIF/wj9LyU7
         ReYg==
X-Gm-Message-State: APjAAAVncU740CWDAwQO1aWwzJG3E0RN2P3xVYN19IL6Fr0Y71NeeNfc
        DumOWD6SHDQU5+NDK/Bu4wAU3w==
X-Google-Smtp-Source: APXvYqxJ9aRKfVFIyCU1I4W0biSdU30z65gLa9YVZJeeUyxUmuOg/X4T5ZLLlGSvgZ0V6HWusdrRSA==
X-Received: by 2002:a5d:6886:: with SMTP id h6mr5200645wru.154.1578497311918;
        Wed, 08 Jan 2020 07:28:31 -0800 (PST)
Received: from [172.20.1.104] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id s1sm4181780wmc.23.2020.01.08.07.28.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jan 2020 07:28:31 -0800 (PST)
Subject: Re: [PATCH bpf-next v2 2/2] bpftool: Add misc secion and probe for
 large INSN limit
To:     Michal Rostecki <mrostecki@opensuse.org>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@google.com>,
        Peter Wu <peter@lekensteyn.nl>,
        Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200107130308.20242-1-mrostecki@opensuse.org>
 <20200107130308.20242-3-mrostecki@opensuse.org>
 <70565317-89af-358f-313c-c4b327cdca4a@netronome.com>
 <20200108134148.GD2954@wotan.suse.de>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Message-ID: <091b68b1-d651-6b23-c3d7-7334ccde1700@netronome.com>
Date:   Wed, 8 Jan 2020 15:28:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200108134148.GD2954@wotan.suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-01-08 13:41 UTC+0000 ~ Michal Rostecki <mrostecki@opensuse.org>
> On Tue, Jan 07, 2020 at 02:36:15PM +0000, Quentin Monnet wrote:
>> Nit: typo in subject ("secion").
>>
>> 2020-01-07 14:03 UTC+0100 ~ Michal Rostecki <mrostecki@opensuse.org>
>>> Introduce a new probe section (misc) for probes not related to concrete
>>> map types, program types, functions or kernel configuration. Introduce a
>>> probe for large INSN limit as the first one in that section.
>>>
>>> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
>>> ---
>>>  tools/bpf/bpftool/feature.c | 18 ++++++++++++++++++
>>>  1 file changed, 18 insertions(+)
>>>
>>> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
>>> index 03bdc5b3ac49..d8ce93092c45 100644
>>> --- a/tools/bpf/bpftool/feature.c
>>> +++ b/tools/bpf/bpftool/feature.c
>>> @@ -572,6 +572,18 @@ probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
>>>  		printf("\n");
>>>  }
>>>  
>>> +static void
>>> +probe_large_insn_limit(const char *define_prefix, __u32 ifindex)
>>> +{
>>> +	bool res;
>>> +
>>> +	res = bpf_probe_large_insn_limit(ifindex);
>>> +	print_bool_feature("have_large_insn_limit",
>>> +			   "Large complexity and program size limit",
>>
>> I am not sure we should mention "complexity" here. Although it is
>> related to program size in the kernel commit you describe, the probe
>> that is run is only on instruction number. This can make a difference
>> for offloaded programs: When you probe a device, if kernel has commit
>> c04c0d2b968a and supports up to 1M instructions, but hardware supports
>> no more than 4k instructions, you may still benefit from the new value
>> for BPF_COMPLEXITY_LIMIT_INSNS for complexity, but not for the total
>> number of available instructions. In that case the probe will fail, and
>> the message on complexity would not be accurate.
>>
>> Looks good otherwise, thanks Michal!
>>
>> Quentin
> 
> Thanks for review! Should I change the description just to "Large
> program size limit" or "Large instruction limit"?
> 
> Michal
> 

I don't really have a preference here, let's keep "program size"?
Quentin
