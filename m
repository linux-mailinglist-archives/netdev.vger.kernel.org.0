Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36BE2652D9
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgIJVYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:24:39 -0400
Received: from foss.arm.com ([217.140.110.172]:37282 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731004AbgIJOXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:23:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3BEB11B3;
        Thu, 10 Sep 2020 07:21:17 -0700 (PDT)
Received: from [10.57.40.122] (unknown [10.57.40.122])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B4783F66E;
        Thu, 10 Sep 2020 07:21:08 -0700 (PDT)
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to
 break;
To:     Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>
Cc:     linux-wireless@vger.kernel.org, linux-fbdev@vger.kernel.org,
        oss-drivers@netronome.com, nouveau@lists.freedesktop.org,
        alsa-devel <alsa-devel@alsa-project.org>,
        dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org,
        dm-devel@redhat.com, linux-mtd@lists.infradead.org,
        linux-i2c@vger.kernel.org, sparclinux@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-rtc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        dccp@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net,
        linux-afs@lists.infradead.org, coreteam@netfilter.org,
        intel-wired-lan@lists.osuosl.org, linux-serial@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kees Cook <kees.cook@canonical.com>,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-sctp@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org,
        storagedev@microchip.com, ceph-devel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-mips@vger.kernel.org, iommu@lists.linux-foundation.org,
        netfilter-devel@vger.kernel.org, linux-crypto@vger.kernel.org,
        bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Will Deacon <will@kernel.org>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <9372456a-8dcf-2735-57a4-e126aa5df3a6@arm.com>
Date:   Thu, 10 Sep 2020 15:21:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-09 21:06, Joe Perches wrote:
> fallthrough to a separate case/default label break; isn't very readable.
> 
> Convert pseudo-keyword fallthrough; statements to a simple break; when
> the next label is case or default and the only statement in the next
> label block is break;
> 
> Found using:
> 
> $ grep-2.5.4 -rP --include=*.[ch] -n "fallthrough;(\s*(case\s+\w+|default)\s*:\s*){1,7}break;" *
> 
> Miscellanea:
> 
> o Move or coalesce a couple label blocks above a default: block.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> Compiled allyesconfig x86-64 only.
> A few files for other arches were not compiled.
> 

[...]
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index c192544e874b..743db1abec40 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3777,7 +3777,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
>   	switch (FIELD_GET(IDR0_TTF, reg)) {
>   	case IDR0_TTF_AARCH32_64:
>   		smmu->ias = 40;
> -		fallthrough;
> +		break;
>   	case IDR0_TTF_AARCH64:
>   		break;
>   	default:

I have to say I don't really agree with the readability argument for 
this one - a fallthrough is semantically correct here, since the first 
case is a superset of the second. It just happens that anything we would 
do for the common subset is implicitly assumed (there are other 
potential cases we simply haven't added support for at the moment), thus 
the second case is currently empty.

This change actively obfuscates that distinction.

Robin.
