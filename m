Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7D53E2A63
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 14:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343600AbhHFMKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 08:10:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28271 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343592AbhHFMKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 08:10:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628251821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iUX9tkPbPQoCHmRVVBakL5GihoDlnIvlBLjyIrxXxlQ=;
        b=LAow66GmT3jca8v5qZWQ/6Tv7iZKzy0EI7aaO1SR8Msy7YiX8dml201kibDgynQZ+pTc+3
        DjJnz0pq3KeSrjf/P7ow79rklmBRSgl7yVofPBnOjFl9IRM6bvf0N+xHjapehj7vYZ/blZ
        STZZd4fwijkhpg9xeeMhp/4/1V2Nor8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-EfI8pywsOeGjGoRYnwhErw-1; Fri, 06 Aug 2021 08:10:20 -0400
X-MC-Unique: EfI8pywsOeGjGoRYnwhErw-1
Received: by mail-ed1-f70.google.com with SMTP id cm18-20020a0564020c92b02903bc7f21d540so4806711edb.13
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 05:10:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iUX9tkPbPQoCHmRVVBakL5GihoDlnIvlBLjyIrxXxlQ=;
        b=OT5Aj8Hqk1ZpFGXUOBlzTUislsjw+1GIoYkQrnPiuhlPz/BW8W2HcesaNCX2HLz3Yc
         RHOP8tz9gOljAxjmEcnQ5aSDx5rrIY3yH1dlMpMm+l5gwurxqrrlqjXCI+XSv4hfPQQp
         RHH4NoLysr1fM+wJshJRZNhR9R9+1OgiHnOFdVdjK+jYBIkkLVf3U2izJthCmnzMQ/Ah
         T+1kUgXgL7rpuD6hTK31TFVN3p4SIqwbkOW27oblX6Hi3exSDzzm76mzQvGZginzZyDu
         dh5DFr5yLfTnP3QGu/jRM1KI2bmzV1Ha+igV0ehsjFIe7haZJFBuC7FvEy1TAZ3CqGdg
         3LuQ==
X-Gm-Message-State: AOAM532xVrXBdVlQjZQhwM2m/dWJpe4d12nXp4J5bJe+PjOT5o0vDZPQ
        lE+A/e0GhH0lHtbTdwBvcbYSiLTgc+o5pyvPB8jxsnE0Mn2+nCRNnMr1C1StSi2hOufmQuLuRye
        qCcXlKgrINv7PI8KzcHxAbyKq0xM8nc+ytbOqEcsnwwoGryNJvBsM+Mi0kpU2M7zB7sJc
X-Received: by 2002:a17:906:190c:: with SMTP id a12mr9606630eje.141.1628251818782;
        Fri, 06 Aug 2021 05:10:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIy7pPE5neyynmuNk+K1t2AeMYsAbqvWPh61GejqqHO3cLZMf+XAD32NUXkg67Vn1gH2F8cw==
X-Received: by 2002:a17:906:190c:: with SMTP id a12mr9606597eje.141.1628251818587;
        Fri, 06 Aug 2021 05:10:18 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id ov4sm2818048ejb.122.2021.08.06.05.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 05:10:18 -0700 (PDT)
Subject: Re: [PATCH v4 0/7] Add TDX Guest Support (Attestation support)
To:     Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
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
References: <20210806000946.2951441-1-sathyanarayanan.kuppuswamy@linux.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <a9d0c7b3-31fa-b7d9-4631-7d0d44a7c848@redhat.com>
Date:   Fri, 6 Aug 2021 14:10:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210806000946.2951441-1-sathyanarayanan.kuppuswamy@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 8/6/21 2:09 AM, Kuppuswamy Sathyanarayanan wrote:
> Hi All,
> 
> Intel's Trust Domain Extensions (TDX) protect guest VMs from malicious
> hosts and some physical attacks. VM guest with TDX support is called
> as TD Guest.
> 
> In TD Guest, the attestationÂ process is used to verify the 
> trustworthiness of TD guest to the 3rd party servers. Such attestation
> process is required by 3rd party servers before sending sensitive
> information to TD guests. One usage example is to get encryption keys
> from the key server for mounting the encrypted rootfs or secondary drive.
>     
> Following patches adds the attestation support to TDX guest which
> includes attestation user interface driver, user agent example, and
> related hypercall support.
> 
> In this series, only following patches are in arch/x86 and are
> intended for x86 maintainers review.
> 
> * x86/tdx: Add TDREPORT TDX Module call support
> * x86/tdx: Add GetQuote TDX hypercall support
> * x86/tdx: Add SetupEventNotifyInterrupt TDX hypercall support
> 
> Patch titled "platform/x86: intel_tdx_attest: Add TDX Guest attestation
> interface driver" adds the attestation driver support. This is supposed
> to be reviewed by platform-x86 maintainers.

Since the patches depend on each other I believe that it would be best
if the entire series gets merged through the tip tree.

Here is my ack for patch 6/7 for that:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> 
> Also, patch titled "tools/tdx: Add a sample attestation user app" adds
> a testing app for attestation feature which needs review from
> bpf@vger.kernel.org.
> 
> This series is the continuation of the following TDX patch series which
> added basic TDX guest support.
> 
> [set 1, v5] - https://lore.kernel.org/patchwork/project/lkml/list/?seriesQ0805
> [set 2, v4] - https://lore.kernel.org/patchwork/project/lkml/list/?seriesQ0814
> [set 3, v4] - https://lore.kernel.org/patchwork/project/lkml/list/?seriesQ0816
> [set 4, v4] - https://lore.kernel.org/patchwork/project/lkml/list/?seriesQ0836
> [set 5, v3] - https://lkml.org/lkml/2021/8/5/1195
> 
> Also please note that this series alone is not necessarily fully
> functional.
> 
> You can find TDX related documents in the following link.
> 
> https://software.intel.com/content/www/br/pt/develop/articles/intel-trust-domain-extensions.html
> 
> Changes since v3:
>  * Since the code added by patch titled "x86/tdx: Add tdg_debug_enabled()
>    interface" is only used by other patches in this series, moved it here.
>  * Rebased on top of Tom Lendacky's protected guest
>    changes (https://lore.kernel.org/patchwork/cover/1468760/
>  * Rest of the history is included in individual patches.
> 
> Changes since v2:
>  * Rebased on top of v5.14-rc1.
>  * Rest of the history is included in individual patches.
> 
> Changes since v1:
>  * Included platform-x86 and test tool maintainers in recipient list.
>  * Fixed commit log and comments in attestation driver as per Han's comments.
> 
> Kuppuswamy Sathyanarayanan (7):
>   x86/tdx: Add tdg_debug_enabled() interface
>   x86/tdx: Add TDREPORT TDX Module call support
>   x86/tdx: Add GetQuote TDX hypercall support
>   x86/tdx: Add SetupEventNotifyInterrupt TDX hypercall support
>   x86/tdx: Add TDX Guest event notify interrupt vector support
>   platform/x86: intel_tdx_attest: Add TDX Guest attestation interface
>     driver
>   tools/tdx: Add a sample attestation user app
> 
>  arch/x86/include/asm/hardirq.h                |   1 +
>  arch/x86/include/asm/idtentry.h               |   4 +
>  arch/x86/include/asm/irq_vectors.h            |   7 +-
>  arch/x86/include/asm/tdx.h                    |   8 +
>  arch/x86/kernel/irq.c                         |   7 +
>  arch/x86/kernel/tdx.c                         | 140 +++++++++++
>  drivers/platform/x86/intel/Kconfig            |   1 +
>  drivers/platform/x86/intel/Makefile           |   1 +
>  drivers/platform/x86/intel/tdx/Kconfig        |  13 +
>  drivers/platform/x86/intel/tdx/Makefile       |   3 +
>  .../platform/x86/intel/tdx/intel_tdx_attest.c | 212 ++++++++++++++++
>  include/uapi/misc/tdx.h                       |  37 +++
>  tools/Makefile                                |  13 +-
>  tools/tdx/Makefile                            |  19 ++
>  tools/tdx/attest/.gitignore                   |   2 +
>  tools/tdx/attest/Makefile                     |  24 ++
>  tools/tdx/attest/tdx-attest-test.c            | 232 ++++++++++++++++++
>  17 files changed, 717 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/platform/x86/intel/tdx/Kconfig
>  create mode 100644 drivers/platform/x86/intel/tdx/Makefile
>  create mode 100644 drivers/platform/x86/intel/tdx/intel_tdx_attest.c
>  create mode 100644 include/uapi/misc/tdx.h
>  create mode 100644 tools/tdx/Makefile
>  create mode 100644 tools/tdx/attest/.gitignore
>  create mode 100644 tools/tdx/attest/Makefile
>  create mode 100644 tools/tdx/attest/tdx-attest-test.c
> 

