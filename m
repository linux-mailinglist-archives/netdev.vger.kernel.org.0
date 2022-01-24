Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4C4498D1A
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 20:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351682AbiAXT1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 14:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350847AbiAXTZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 14:25:25 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722DDC02B86E;
        Mon, 24 Jan 2022 11:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=630GZf2pl7dUC09jByd2lRVEJ71rHFIBrI9U48V8bzA=; b=l0WJXVDaYcmJ3/V3RWFezwDDer
        C44GbJGe7OjLN0KX4PaF1IWCv0kAoNTjNLYvwuH+jZell6Ad2JgbYr55poxlvv5DL8vopnnR/7kMY
        vn/kveSmXCK7I5QKtfyV0XYyRC15LtirFVJpZLpus0tksAvWxi6l/uO/J6VOZyNLBn7KViVZO+pmi
        tCMavBPk+ocRsC6yujO5bPnGRcZhKLBisgW7TtJG3/FxTW3BAp4mXk9rBm2YHM6MqRSSbpG11QU3K
        iU0eefreID+Mspii6FT8TND1o3Wgkgcez5ouyqVdYFPOacbzF1GFPC3zVTqT0YP/NTts2M908BtFX
        6ETemMoQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nC4l3-003F5b-C0; Mon, 24 Jan 2022 19:12:05 +0000
Message-ID: <aca104cf-5f5f-b696-754a-35e62dbe64c3@infradead.org>
Date:   Mon, 24 Jan 2022 11:11:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Build regressions/improvements in v5.17-rc1
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Alex Deucher <alexdeucher@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        KVM list <kvm@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>,
        sparclinux <sparclinux@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "Tobin C. Harding" <me@tobin.cc>
References: <20220123125737.2658758-1-geert@linux-m68k.org>
 <alpine.DEB.2.22.394.2201240851560.2674757@ramsan.of.borg>
 <CADnq5_MUq0fX7wMLJyUUxxa+2xoRinonL-TzD8tUhXALRfY8-A@mail.gmail.com>
 <CAMuHMdWUWqHYbbavtMT-XAD_sarDPC5xnc3c0pX1ZAh3Wuzuzg@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <CAMuHMdWUWqHYbbavtMT-XAD_sarDPC5xnc3c0pX1ZAh3Wuzuzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/24/22 10:55, Geert Uytterhoeven wrote:
> Hi Alex,
> 
> On Mon, Jan 24, 2022 at 7:52 PM Alex Deucher <alexdeucher@gmail.com> wrote:
>> On Mon, Jan 24, 2022 at 5:25 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>> On Sun, 23 Jan 2022, Geert Uytterhoeven wrote:
>>>>  + /kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c: error: control reaches end of non-void function [-Werror=return-type]:  => 1560:1
>>
>> I don't really see what's going on here:
>>
>> #ifdef CONFIG_X86_64
>> return cpu_data(first_cpu_of_numa_node).apicid;
>> #else
>> return first_cpu_of_numa_node;
>> #endif
> 
> Ah, the actual failure causing this was not included:
> 
> In file included from /kisskb/src/arch/x86/um/asm/processor.h:41:0,
>                  from /kisskb/src/include/linux/mutex.h:19,
>                  from /kisskb/src/include/linux/kernfs.h:11,
>                  from /kisskb/src/include/linux/sysfs.h:16,
>                  from /kisskb/src/include/linux/kobject.h:20,
>                  from /kisskb/src/include/linux/pci.h:35,
>                  from
> /kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:25:
> /kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c: In
> function 'kfd_cpumask_to_apic_id':
> /kisskb/src/arch/um/include/asm/processor-generic.h:103:18: error:
> called object is not a function or function pointer
>  #define cpu_data (&boot_cpu_data)
>                   ^
> /kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:1556:9:
> note: in expansion of macro 'cpu_data'
>   return cpu_data(first_cpu_of_numa_node).apicid;
>          ^
> /kisskb/src/drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:1560:1:
> error: control reaches end of non-void function [-Werror=return-type]
>  }
>  ^

ah yes, UML.
I have a bunch of UML fixes that I have been hesitant to post.

This is one of them.
What do people think about this?

thanks.

---
From: Randy Dunlap <rdunlap@infradead.org>


../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:1556:9: note: in expansion of macro ‘cpu_data’
  return cpu_data(first_cpu_of_numa_node).apicid;
         ^~~~~~~~
../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:1560:1: error: control reaches end of non-void function [-Werror=return-type]

../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_crat.c: In function ‘kfd_fill_iolink_info_for_cpu’:
../arch/um/include/asm/processor-generic.h:103:19: error: called object is not a function or function pointer
 #define cpu_data (&boot_cpu_data)
                  ~^~~~~~~~~~~~~~~
../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_crat.c:1688:27: note: in expansion of macro ‘cpu_data’
  struct cpuinfo_x86 *c = &cpu_data(0);
                           ^~~~~~~~
../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_crat.c:1691:7: error: dereferencing pointer to incomplete type ‘struct cpuinfo_x86’
  if (c->x86_vendor == X86_VENDOR_AMD)
       ^~
../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_crat.c:1691:23: error: ‘X86_VENDOR_AMD’ undeclared (first use in this function); did you mean ‘X86_VENDOR_ANY’?
  if (c->x86_vendor == X86_VENDOR_AMD)
                       ^~~~~~~~~~~~~~
                       X86_VENDOR_ANY

../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_crat.c: In function ‘kfd_create_vcrat_image_cpu’:
../drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_crat.c:1742:11: warning: unused variable ‘entries’ [-Wunused-variable]
  uint32_t entries = 0;

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c     |    6 +++---
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20220107.orig/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ linux-next-20220107/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -1552,7 +1552,7 @@ static int kfd_cpumask_to_apic_id(const
 	first_cpu_of_numa_node = cpumask_first(cpumask);
 	if (first_cpu_of_numa_node >= nr_cpu_ids)
 		return -1;
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
 	return cpu_data(first_cpu_of_numa_node).apicid;
 #else
 	return first_cpu_of_numa_node;
--- linux-next-20220107.orig/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ linux-next-20220107/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1679,7 +1679,7 @@ static int kfd_fill_mem_info_for_cpu(int
 	return 0;
 }
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
 static int kfd_fill_iolink_info_for_cpu(int numa_node_id, int *avail_size,
 				uint32_t *num_entries,
 				struct crat_subtype_iolink *sub_type_hdr)
@@ -1738,7 +1738,7 @@ static int kfd_create_vcrat_image_cpu(vo
 	struct crat_subtype_generic *sub_type_hdr;
 	int avail_size = *size;
 	int numa_node_id;
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
 	uint32_t entries = 0;
 #endif
 	int ret = 0;
@@ -1803,7 +1803,7 @@ static int kfd_create_vcrat_image_cpu(vo
 			sub_type_hdr->length);
 
 		/* Fill in Subtype: IO Link */
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
 		ret = kfd_fill_iolink_info_for_cpu(numa_node_id, &avail_size,
 				&entries,
 				(struct crat_subtype_iolink *)sub_type_hdr);


