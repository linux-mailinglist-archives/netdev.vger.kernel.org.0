Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CB91A3EA4
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 05:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgDJDQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 23:16:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:30990 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgDJDQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 23:16:02 -0400
IronPort-SDR: PN9ikPB35N86S1TxQ1Y7iKKmRLqWdbur6JDEZcHDVGINu8KlteSPrVQybc7+IEkQzrpg8MBNWS
 E4L/unrmXNmQ==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 20:16:02 -0700
IronPort-SDR: mwdWbfioCrT9VIiCeFwnyiAwXxTS540MpfN+bFY47xMSgBGlLgy6waCrSFIv8sRAwtyPeKw0RS
 G9XpNPegE/pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,364,1580803200"; 
   d="scan'208,223";a="270284078"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.31.39]) ([10.255.31.39])
  by orsmga002.jf.intel.com with ESMTP; 09 Apr 2020 20:15:54 -0700
Subject: Re: [PATCH V9 9/9] virtio: Intel IFC VF driver for VDPA
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Jason Wang <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Networking <netdev@vger.kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        eperezma@redhat.com, lulu@redhat.com,
        Parav Pandit <parav@mellanox.com>, kevin.tian@intel.com,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, aadam@redhat.com,
        Jiri Pirko <jiri@mellanox.com>, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, Bie Tiwei <tiwei.bie@intel.com>
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-10-jasowang@redhat.com>
 <CAK8P3a1RXUXs5oYjB=Jq5cpvG11eTnmJ+vc18_-0fzgTH6envA@mail.gmail.com>
 <20200409162427-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <77962da1-b9ec-2eaf-21d0-9790e7f0366d@intel.com>
Date:   Fri, 10 Apr 2020 11:15:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200409162427-mutt-send-email-mst@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------6E5E274523B4D96E25AC383C"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------6E5E274523B4D96E25AC383C
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/10/2020 4:25 AM, Michael S. Tsirkin wrote:
> On Thu, Apr 09, 2020 at 12:41:13PM +0200, Arnd Bergmann wrote:
>> On Thu, Mar 26, 2020 at 3:08 PM Jason Wang <jasowang@redhat.com> wrote:
>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>
>>> This commit introduced two layers to drive IFC VF:
>>>
>>> (1) ifcvf_base layer, which handles IFC VF NIC hardware operations and
>>>      configurations.
>>>
>>> (2) ifcvf_main layer, which complies to VDPA bus framework,
>>>      implemented device operations for VDPA bus, handles device probe,
>>>      bus attaching, vring operations, etc.
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> Signed-off-by: Bie Tiwei <tiwei.bie@intel.com>
>>> Signed-off-by: Wang Xiao <xiao.w.wang@intel.com>
>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>> +
>>> +#define IFCVF_QUEUE_ALIGNMENT  PAGE_SIZE
>>> +#define IFCVF_QUEUE_MAX                32768
>>> +static u16 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>>> +{
>>> +       return IFCVF_QUEUE_ALIGNMENT;
>>> +}
>> This fails to build on arm64 with 64kb page size (found in linux-next):
>>
>> /drivers/vdpa/ifcvf/ifcvf_main.c: In function 'ifcvf_vdpa_get_vq_align':
>> arch/arm64/include/asm/page-def.h:17:20: error: conversion from 'long
>> unsigned int' to 'u16' {aka 'short unsigned int'} changes value from
>> '65536' to '0' [-Werror=overflow]
>>     17 | #define PAGE_SIZE  (_AC(1, UL) << PAGE_SHIFT)
>>        |                    ^
>> drivers/vdpa/ifcvf/ifcvf_base.h:37:31: note: in expansion of macro 'PAGE_SIZE'
>>     37 | #define IFCVF_QUEUE_ALIGNMENT PAGE_SIZE
>>        |                               ^~~~~~~~~
>> drivers/vdpa/ifcvf/ifcvf_main.c:231:9: note: in expansion of macro
>> 'IFCVF_QUEUE_ALIGNMENT'
>>    231 |  return IFCVF_QUEUE_ALIGNMENT;
>>        |         ^~~~~~~~~~~~~~~~~~~~~
>>
>> It's probably good enough to just not allow the driver to be built in that
>> configuration as it's fairly rare but unfortunately there is no simple Kconfig
>> symbol for it.
>>
>> In a similar driver, we did
>>
>> config VMXNET3
>>          tristate "VMware VMXNET3 ethernet driver"
>>          depends on PCI && INET
>>          depends on !(PAGE_SIZE_64KB || ARM64_64K_PAGES || \
>>                       IA64_PAGE_SIZE_64KB || MICROBLAZE_64K_PAGES || \
>>                       PARISC_PAGE_SIZE_64KB || PPC_64K_PAGES)
>>
>> I think we should probably make PAGE_SIZE_64KB a global symbol
>> in arch/Kconfig and have it selected by the other symbols so drivers
>> like yours can add a dependency for it.
>>
>>           Arnd
> It's probably easier to make the alignment u32 - I don't really know why it's
> u16, all callers seem to assign the result to a u32 value.

Thanks Michael!

@ Arnd, would you please kindly have a try on the attached patch? I 
failed to find an armv8 or above platform for now.

Thanks
BR
Zhu Lingshan

--------------6E5E274523B4D96E25AC383C
Content-Type: text/plain; charset=UTF-8;
 name="0001-vdpa-change-get_vq_align-to-u32-alignment.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-vdpa-change-get_vq_align-to-u32-alignment.patch"

RnJvbSBiYjIwMTlmMDYyMDYwOWZiYmRjNjg1NGJjY2M1ZmVmZGI1M2YzZDlkIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBaaHUgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBpbnRl
bC5jb20+CkRhdGU6IEZyaSwgMTAgQXByIDIwMjAgMTE6MDQ6MzggKzA4MDAKU3ViamVjdDog
W1BBVENIXSB2ZHBhOiBjaGFuZ2UgZ2V0X3ZxX2FsaWduKCkgdG8gdTMyIGFsaWdubWVudAoK
VGhpcyBjb21taXQgY2hhbmdlIHRoZSByZXR1cm4gdmFsdWUgb2YgZ2V0X3ZxX2FsaWduKCkg
dG8gdTMyLiB0aGlzCmNhbiBoZWxwIHJlc29sdmUgYSBidWlsZCBpc3N1ZSBvZiBhcm02NCBw
bGF0Zm9ybSwgYW5kIGFkYXB0aW5nIHRvCnRoZSBjYWxsZXJzLgoKU2lnbmVkLW9mZi1ieTog
Wmh1IExpbmdzaGFuIDxsaW5nc2hhbi56aHVAaW50ZWwuY29tPgotLS0KIGRyaXZlcnMvdmRw
YS9pZmN2Zi9pZmN2Zl9tYWluLmMgIHwgMiArLQogZHJpdmVycy92ZHBhL3ZkcGFfc2ltL3Zk
cGFfc2ltLmMgfCAyICstCiBpbmNsdWRlL2xpbnV4L3ZkcGEuaCAgICAgICAgICAgICB8IDIg
Ky0KIDMgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmRwYS9pZmN2Zi9pZmN2Zl9tYWluLmMgYi9kcml2ZXJz
L3ZkcGEvaWZjdmYvaWZjdmZfbWFpbi5jCmluZGV4IDhkNTRkYzUuLjk3MDg5NWMgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvdmRwYS9pZmN2Zi9pZmN2Zl9tYWluLmMKKysrIGIvZHJpdmVycy92
ZHBhL2lmY3ZmL2lmY3ZmX21haW4uYwpAQCAtMjI4LDcgKzIyOCw3IEBAIHN0YXRpYyB1MzIg
aWZjdmZfdmRwYV9nZXRfdmVuZG9yX2lkKHN0cnVjdCB2ZHBhX2RldmljZSAqdmRwYV9kZXYp
CiAJcmV0dXJuIElGQ1ZGX1NVQlNZU19WRU5ET1JfSUQ7CiB9CiAKLXN0YXRpYyB1MTYgaWZj
dmZfdmRwYV9nZXRfdnFfYWxpZ24oc3RydWN0IHZkcGFfZGV2aWNlICp2ZHBhX2RldikKK3N0
YXRpYyB1MzIgaWZjdmZfdmRwYV9nZXRfdnFfYWxpZ24oc3RydWN0IHZkcGFfZGV2aWNlICp2
ZHBhX2RldikKIHsKIAlyZXR1cm4gSUZDVkZfUVVFVUVfQUxJR05NRU5UOwogfQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy92ZHBhL3ZkcGFfc2ltL3ZkcGFfc2ltLmMgYi9kcml2ZXJzL3ZkcGEv
dmRwYV9zaW0vdmRwYV9zaW0uYwppbmRleCA2ZThhMGNmLi5hNGIzZjBkIDEwMDY0NAotLS0g
YS9kcml2ZXJzL3ZkcGEvdmRwYV9zaW0vdmRwYV9zaW0uYworKysgYi9kcml2ZXJzL3ZkcGEv
dmRwYV9zaW0vdmRwYV9zaW0uYwpAQCAtNDM1LDcgKzQzNSw3IEBAIHN0YXRpYyB1NjQgdmRw
YXNpbV9nZXRfdnFfc3RhdGUoc3RydWN0IHZkcGFfZGV2aWNlICp2ZHBhLCB1MTYgaWR4KQog
CXJldHVybiB2cmgtPmxhc3RfYXZhaWxfaWR4OwogfQogCi1zdGF0aWMgdTE2IHZkcGFzaW1f
Z2V0X3ZxX2FsaWduKHN0cnVjdCB2ZHBhX2RldmljZSAqdmRwYSkKK3N0YXRpYyB1MzIgdmRw
YXNpbV9nZXRfdnFfYWxpZ24oc3RydWN0IHZkcGFfZGV2aWNlICp2ZHBhKQogewogCXJldHVy
biBWRFBBU0lNX1FVRVVFX0FMSUdOOwogfQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC92
ZHBhLmggYi9pbmNsdWRlL2xpbnV4L3ZkcGEuaAppbmRleCA3MzNhY2ZiLi41NDUzYWY4IDEw
MDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L3ZkcGEuaAorKysgYi9pbmNsdWRlL2xpbnV4L3Zk
cGEuaApAQCAtMTY0LDcgKzE2NCw3IEBAIHN0cnVjdCB2ZHBhX2NvbmZpZ19vcHMgewogCXU2
NCAoKmdldF92cV9zdGF0ZSkoc3RydWN0IHZkcGFfZGV2aWNlICp2ZGV2LCB1MTYgaWR4KTsK
IAogCS8qIERldmljZSBvcHMgKi8KLQl1MTYgKCpnZXRfdnFfYWxpZ24pKHN0cnVjdCB2ZHBh
X2RldmljZSAqdmRldik7CisJdTMyICgqZ2V0X3ZxX2FsaWduKShzdHJ1Y3QgdmRwYV9kZXZp
Y2UgKnZkZXYpOwogCXU2NCAoKmdldF9mZWF0dXJlcykoc3RydWN0IHZkcGFfZGV2aWNlICp2
ZGV2KTsKIAlpbnQgKCpzZXRfZmVhdHVyZXMpKHN0cnVjdCB2ZHBhX2RldmljZSAqdmRldiwg
dTY0IGZlYXR1cmVzKTsKIAl2b2lkICgqc2V0X2NvbmZpZ19jYikoc3RydWN0IHZkcGFfZGV2
aWNlICp2ZGV2LAotLSAKMS44LjMuMQoK
--------------6E5E274523B4D96E25AC383C--
