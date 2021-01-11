Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387AD2F171B
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 15:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388055AbhAKOBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 09:01:36 -0500
Received: from exchange.tu-berlin.de ([130.149.7.70]:18571 "EHLO
        exchange.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730367AbhAKOBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 09:01:34 -0500
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jan 2021 09:01:33 EST
Received: from SPMA-02.tubit.win.tu-berlin.de (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 9844238E98_FFC57C1B;
        Mon, 11 Jan 2021 13:50:57 +0000 (GMT)
Received: from exchange.tu-berlin.de (exchange.tu-berlin.de [130.149.7.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "exchange.tu-berlin.de", Issuer "DFN-Verein Global Issuing CA" (verified OK))
        by SPMA-02.tubit.win.tu-berlin.de (Sophos Email Appliance) with ESMTPS id E085830420C_FFC57C0F;
        Mon, 11 Jan 2021 13:50:56 +0000 (GMT)
Received: from [192.168.178.37] (77.11.67.233) by ex-01.tubit.win.tu-berlin.de
 (130.149.6.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3; Mon, 11 Jan 2021
 14:50:56 +0100
Subject: Re: Security issue with vmxnet3 and e100 for AMD SEV(-SNP) / Intel
 TDX
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Radev, Martin" <martin.radev@aisec.fraunhofer.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "doshir@vmware.com" <doshir@vmware.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "Morbitzer, Mathias" <mathias.morbitzer@aisec.fraunhofer.de>,
        "file@sect.tu-berlin.de" <file@sect.tu-berlin.de>,
        "Banse, Christian" <christian.banse@aisec.fraunhofer.de>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "Thomas.Lendacky@amd.com" <Thomas.Lendacky@amd.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
References: <AM7P194MB0900E443CEBD6EF2EE37325ED9AE0@AM7P194MB0900.EURP194.PROD.OUTLOOK.COM>
 <AM7P194MB09004AD790C5C85EDCB42323D9AE0@AM7P194MB0900.EURP194.PROD.OUTLOOK.COM>
 <20210111132602.bcd5hmtoqe4dcjwp@black.fi.intel.com>
From:   Robert Buhren <robert.buhren@sect.tu-berlin.de>
Message-ID: <749d3ace-877f-1c5c-bb00-ffcb8394f36a@sect.tu-berlin.de>
Date:   Mon, 11 Jan 2021 14:56:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111132602.bcd5hmtoqe4dcjwp@black.fi.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: ex-04.tubit.win.tu-berlin.de (130.149.6.144) To
 ex-01.tubit.win.tu-berlin.de (130.149.6.151)
X-SASI-RCODE: 200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tu-berlin.de; h=subject:to:cc:references:from:message-id:date:mime-version:in-reply-to:content-type:content-transfer-encoding; s=dkim-tub; bh=MkaDCo5TDAZn9e+yLg1ESgxnzLOnnryJsSht1kcLDj8=; b=OOnIQHCoc3xPi5D1C9PuLJ+rJOr8a9rkHdK3exqrV+l+w3/RMhbmKLysdxO6r84M6vUM/8WRSQFLWNwHe4Nzq2Ogb6oK1vof4MR4RoIDgOJBw1k8Ri9ZKtF7AEUD9ozAhYBcE4N0wpmtS6uwyy//5/098sEKdf5m86UMQLlsdkg=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/11/21 2:26 PM, Kirill A. Shutemov wrote:
> On Fri, Jan 08, 2021 at 03:31:56PM +0000, Radev, Martin wrote:
>> Just noticed that Intel TDX already does the device filtering. Check: https://github.com/intel/tdx/commit/6789eee52aab8985e49b362379fab73aa3eecde2
>>
>> CC-ing Kirill and Kuppuswamy from Intel in case they want to be part of the discussion.
>> ________________________________
>> From: Radev, Martin
>> Sent: Friday, January 8, 2021 12:57 PM
>> To: netdev@vger.kernel.org <netdev@vger.kernel.org>; intel-wired-lan@lists.osuosl.org <intel-wired-lan@lists.osuosl.org>
>> Cc: doshir@vmware.com <doshir@vmware.com>; jesse.brandeburg@intel.com <jesse.brandeburg@intel.com>; anthony.l.nguyen@intel.com <anthony.l.nguyen@intel.com>; Morbitzer, Mathias <mathias.morbitzer@aisec.fraunhofer.de>; Robert Buhren <robert.buhren@sect.tu-berlin.de>; file@sect.tu-berlin.de <file@sect.tu-berlin.de>; Banse, Christian <christian.banse@aisec.fraunhofer.de>; brijesh.singh@amd.com <brijesh.singh@amd.com>; Thomas.Lendacky@amd.com <Thomas.Lendacky@amd.com>; pv-drivers@vmware.com <pv-drivers@vmware.com>; martin.b.radev@gmail.com <martin.b.radev@gmail.com>
>> Subject: Security issue with vmxnet3 and e100 for AMD SEV(-SNP) / Intel TDX
>>
>> Hello everybody,
>>
>> tldr: Both drivers expose skb GVAs to untrusted devices which gives RIP
>>          control to a malicious e100 / vmxnet3 device implementation. This is
>>          an issue for AMD SEV (-SNP) [1] and likely Intel TDX [2].
>>
>> Felicitas and Robert have started a project on fuzzing device drivers which
>> may have negative security impact on solutions like AMD SEV Secure
>> Nested Paging and Intel Trusted Domain Extensions. These solutions protect
>> a VM from a malicious Hypervisor in various way.
>>
>> There are a couple of devices which carry security issues under the attacker
>> models of SEV-SNP / Intel TDX, but here we're only discussing VMXNET3 and
>> e100, because we have detailed PoCs for both.
>>
>> Maintainers of both vmxnet3 and e100 were added in this email because the
>> discussion will likely be the same. The issues were already sent to AMD PSIRT,
>> and Tom Lendacky and Brijesh Singh have volunteered to be part of the email
>> communication with the maintainers. Both have been working on AMD SEV.
>>
>> Please check the two attached files: vmxnet3_report.txt and e100_report.txt.
>> Both contain detailed information about what the issue is and how it can be
>> exploited by a malicious HV or attacker who has access to the QEMU process.
>>
>> Fix:
>> In an earlier discussion with AMD, there was the idea of making a list of
>> allowed devices with SEV and forbidding everything else. This would avoid
>> issues with other drivers whose implementation has not been yet scrutinized
>> under the threat model of SEV-SNP and Intel Trusted Domain Extensions.
> +Andi.
>
> Right. Our TDX guest enabling has white list of devices that allowed to be
> used. For now it's only VirtIO, but I believe it also requires hardening.
> We need to validate any VMM input.
>
> It might be beneficial to have coordination between Intel and AMD on what
> devices (and device drivers) considered to be safe for trusted computing.
> I think we can share burden of code audit and fuzzing.
Let us know if you are interested in our fuzzing/static analysis setup.
We're planning to submit a paper soon and we will publish the source
code along with the paper.

-- 
Robert Buhren <robert.buhren@sect.tu-berlin.de>
Security in Telecommunications <https://sect.tu-berlin.de>
TU Berlin / Telekom Innovation Laboratories
Ernst-Reuter-Platz 7, Sekr TEL 16 / D - 10587 Berlin, Germany
phone: +49 30 835358325

