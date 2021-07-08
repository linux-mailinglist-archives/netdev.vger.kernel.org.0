Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A9B3C150E
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 16:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhGHOXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 10:23:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231612AbhGHOXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 10:23:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625754032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rMd4AWjD6adpOD0cHBKiOHOCr1xW7T6v5/60Gt2npvY=;
        b=Lap068H0hVfEmXUgBDxH53nx6UCfyvmrc5QPyvPekxTtLWox5NubDg8qm1heeNIesqxObP
        YxYmbQIfOz4kyTv0tbASqABYKG/ByZscpSSvVZ+lBhCmgZlKpJXfPmPIFECi72LC7G+cG6
        jPBAKIGQr9E8TOFjMCkqxYmaAcQMO4Q=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-VevkX01EMYmEMyNjqHNdRQ-1; Thu, 08 Jul 2021 10:20:31 -0400
X-MC-Unique: VevkX01EMYmEMyNjqHNdRQ-1
Received: by mail-ej1-f72.google.com with SMTP id f1-20020a1709064941b02903f6b5ef17bfso1881126ejt.20
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 07:20:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rMd4AWjD6adpOD0cHBKiOHOCr1xW7T6v5/60Gt2npvY=;
        b=WjMrTJd+ysblWixT/1TW+eZ36EKaKHKBk8x6m+krQW/jDEbD3/88lJK0MtJATXkQ5d
         htXJikjznMcT5NXAyMcU73ldsKeu49PEAMrFC/Q7go+slpgQZI1NBOjDG55z1fbQ0oWu
         GmCWOI0i2M57AEVPCuWn1CfyGA1Ol271zPpoXTbH3w+R9QRexcAjtGgNGStk8LXMbIIg
         zqCoJuHYDw4lsJ53c6Ai9dtqke30zf7tTQxO3CnAYR2w/sYAYrMf3lTwnQfKWUsjC/Yf
         5Kj+zBj1m8+nvYJtF6KiTyax5ShjA5BuB+Mg33JtVIv1X1gMXAWWBxl4jzoGeWBGehXO
         m4IA==
X-Gm-Message-State: AOAM531pjFdoLvOGZEdbvTp1fQHqXb+Eh4A2SA545Gzk0b094ZmH3yD0
        tMQzxnJ0r5C8kg+N8URxyiuKZ3+eSj4mjWryRfdODn0+eQTV/Q8JpooaymPkgsFyd/7JakPmbXz
        Jh+6u5TH/PjGxBUowj9Sm9Yphew9/q32qtpdCzVvrnQ17eA+6quSX0xqvAu9Fx4xcBOPS
X-Received: by 2002:a17:906:31d4:: with SMTP id f20mr30158008ejf.383.1625754030268;
        Thu, 08 Jul 2021 07:20:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+CRFaKbiL2TI3Vd12pHECJc8QTdAdXLv8YYfZAUALlnriDC30i16VBgmVrmOvk7uIBlhUxw==
X-Received: by 2002:a17:906:31d4:: with SMTP id f20mr30157971ejf.383.1625754030111;
        Thu, 08 Jul 2021 07:20:30 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id aq6sm1011569ejc.77.2021.07.08.07.20.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 07:20:29 -0700 (PDT)
Subject: Re: [PATCH v2 1/6] x86/tdx: Add TDREPORT TDX Module call support
To:     "Kuppuswamy, Sathyanarayanan" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Peter H Anvin <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210707204249.3046665-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210707204249.3046665-2-sathyanarayanan.kuppuswamy@linux.intel.com>
 <d9aac97c-aa08-de9f-fa44-91b7dde61ce3@intel.com>
 <46944ac2-4841-7f1d-4f54-ecb477f43d63@linux.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <20c227e0-1299-0bf8-690c-f0260d39f420@redhat.com>
Date:   Thu, 8 Jul 2021 16:20:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <46944ac2-4841-7f1d-4f54-ecb477f43d63@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 7/8/21 4:07 PM, Kuppuswamy, Sathyanarayanan wrote:
> 
> 
> On 7/8/21 1:16 AM, Xiaoyao Li wrote:
>>
>> Sorry I guess I didn't state it clearly during internal review.
>>
>> I suggest something like this
>>
>> if (ret != TDCALL_SUCCESS) {
>>      if (TDCALL_RETURN_CODE(ret) == TDCALL_INVALID_OPERAND)
>>          return -EINVAL;
>>      else if (TDCALL_RETURN_CODE(ret) == TDCALL_OPERAND_BUSY)
>>          return -EBUSY;
>>      else
>>          return -EFAULT; //I'm not sure if -EFAULT is proper.
>> }
> 
> As per current spec, TDCALL_INVALID_OPERAND, TDCALL_OPERAND_BUSY and
> 0 are the only possible return values. So I have checked for failure case
> in if condition and returned success by default. Any reason for specifically
> checking for success code ?

Yes, new error codes might be introduced and you might forget to
update this (or other) checks.

Checking for errors really MUST always be done by checking for
ret != success (typically ret != 0 or ret < 0).

Only checking for known error codes means that if somehow an
unknown error code gets thrown this gets treated as success,
which is not acceptable behavior.

Regards,

Hans


