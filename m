Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2482CC670
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgLBTUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:20:33 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:45595 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbgLBTUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 14:20:33 -0500
Received: from [192.168.1.155] ([77.7.48.174]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MmlGg-1kIKQL2oGE-00jsn4; Wed, 02 Dec 2020 20:17:27 +0100
Subject: Re: [PATCH 1/2] x86: make vmware support optional
To:     Borislav Petkov <bp@alien8.de>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dmitry.torokhov@gmail.com,
        derek.kiernan@xilinx.com, dragan.cvetic@xilinx.com,
        richardcochran@gmail.com, linux-hyperv@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org
References: <20201117202308.7568-1-info@metux.net>
 <20201117203155.GO5719@zn.tnic>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <0c0480af-bcf5-d7ba-9e76-d511e60f76ec@metux.net>
Date:   Wed, 2 Dec 2020 20:17:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201117203155.GO5719@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:FP2CYEq15R80dQ6d6l9Zeukb8qsW02XwbWcM7FTCUJ8N+wkBHN0
 sVeoBh7Gnt/ZU7cQZLYDkwMUzPKGAElGYu4M3oZ/jNQePe8BRSR3qqYISPbWlAoazq8aC8c
 FcOGUM8zdRTqhe0fI6e+PfOa9Gyb4avrDwLJo3MmgNiRmpx5ru3P7WjHXmssc+Uxb2dOVCI
 rWRWyKfa2kuthRj//6NHw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2HkvspBsxR8=:gaZWtRyrjr7D/OFxL4NKCm
 /ouXkkPhyblj0piWqhd2Rg20ajU17FMi7vLb2KbGhLQCDAaWh+DtitqHcNbsqB6Yh8gBQvM34
 Pj4+HOXfoaD26Czve6SXOH2eE93HM18Wqrs7+1u5Zpm9+Wsqv4TxGpqEu2Fg72rU4BTkJuBKZ
 M4mIEKCvRCiY8+IncEXVifFv8r/mUOKPEObURZI/biQ4JhLfg31A5LnrSxX9gu40FRvHXEdPB
 mcvNrsPg032JJ4Fn6qvp53pw/2JuwuO3blwr5OQMghpOkokxf/FRLiDxtpLxQEWvUVBCHvk8D
 0D3xC+Dq+6wH1Z5FpKw+oIkmt/mpMVGkgv7mFT++sw3Nbpm4t46/MovaaRqcA4u/isCUo7Tzt
 lFm7aMfk14l0YQkJZfgeaWpcrfJdGwoXu3TWqEDyn7MOj9MOzpbz9HMR0axkD
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.11.20 21:31, Borislav Petkov wrote:
> On Tue, Nov 17, 2020 at 09:23:07PM +0100, Enrico Weigelt, metux IT consult wrote:
>> Make it possible to opt-out from vmware support
> 
> Why?

Reducing the kernel size. Think of very high density virtualization
(w/ specially stripped-down workloads) or embedded systems.

For example, I'm running bare minimum kernels w/ only kvm and virtio
(not even pci, etc) in such scenarios.

Of course, that's nothing for an average distro, therefore leaving
default y.


--mtx


> 
> I can think of a couple of reasons but maybe yours might not be the one
> I'm thinking of.
> 
>> Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
>> ---
>>  arch/x86/Kconfig                 | 7 +++++++
>>  arch/x86/kernel/cpu/Makefile     | 4 +++-
>>  arch/x86/kernel/cpu/hypervisor.c | 2 ++
>>  drivers/input/mouse/Kconfig      | 2 +-
>>  drivers/misc/Kconfig             | 2 +-
>>  drivers/ptp/Kconfig              | 2 +-
>>  6 files changed, 15 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index f6946b81f74a..c227c1fa0091 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -801,6 +801,13 @@ config X86_HV_CALLBACK_VECTOR
>>  
>>  source "arch/x86/xen/Kconfig"
>>  
>> +config VMWARE_GUEST
>> +	bool "Vmware Guest support"
>> +	default y
> 
> depends on HYPERVISOR_GUEST. The hyperv one too.
> 

-- 
---
Hinweis: unverschlüsselte E-Mails können leicht abgehört und manipuliert
werden ! Für eine vertrauliche Kommunikation senden Sie bitte ihren
GPG/PGP-Schlüssel zu.
---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
