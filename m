Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DD33E1180
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 11:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239354AbhHEJjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 05:39:52 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13281 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239159AbhHEJjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 05:39:51 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GgNjv31F7z7x6Z;
        Thu,  5 Aug 2021 17:34:43 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 5 Aug 2021 17:39:35 +0800
Subject: Re: [PATCH V7 8/9] PCI/IOV: Add 10-Bit Tag sysfs files for VF devices
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20210805000525.GA1693795@bjorn-Precision-5520>
CC:     <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <06da7110-da9f-5afe-e086-7a9a9b448fd7@huawei.com>
Date:   Thu, 5 Aug 2021 17:39:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210805000525.GA1693795@bjorn-Precision-5520>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Miss a comment reply  :).

On 2021/8/5 8:05, Bjorn Helgaas wrote:
> On Wed, Aug 04, 2021 at 09:47:07PM +0800, Dongdong Liu wrote:
>> PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
>> sending Requests to other Endpoints (as opposed to host memory), the
>> Endpoint must not send 10-Bit Tag Requests to another given Endpoint
>> unless an implementation-specific mechanism determines that the
>> Endpoint supports 10-Bit Tag Completer capability.
>> Add sriov_vf_10bit_tag file to query the status of VF 10-Bit Tag
>> Requester Enable. Add sriov_vf_10bit_tag_ctl file to disable the VF
>> 10-Bit Tag Requester. The typical use case is for p2pdma when the peer
>> device does not support 10-BIT Tag Completer.
>
> Fix the usual spec quoting issue.  Or maybe this is not actually
> quoted but is missing blank lines between paragraphs.
>
> s/10-BIT/10-Bit/
>
>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>> ---
>>  Documentation/ABI/testing/sysfs-bus-pci | 20 +++++++++++++
>>  drivers/pci/iov.c                       | 50 +++++++++++++++++++++++++++++++++
>>  2 files changed, 70 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
>> index 0e0c97d..8fdbfae 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-pci
>> +++ b/Documentation/ABI/testing/sysfs-bus-pci
>> @@ -421,3 +421,23 @@ Description:
>>  		to disable 10-Bit Tag Requester when the driver does not bind
>>  		the deivce. The typical use case is for p2pdma when the peer
>>  		device does not support 10-BIT Tag Completer.
>> +
>> +What:		/sys/bus/pci/devices/.../sriov_vf_10bit_tag
>> +Date:		August 2021
>> +Contact:	Dongdong Liu <liudongdong3@huawei.com>
>> +Description:
>> +		This file is associated with a SR-IOV physical function (PF).
>> +		It is visible when the device has VF 10-Bit Tag Requester
>> +		Supported. It contains the status of VF 10-Bit Tag Requester
>> +		Enable. The file is only readable.
>
> s/only readable/read-only/
>
>> +What:		/sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl
>
> Why does this file have "_ctl" on the end when the one in patch 7/9
> does not?

PF: 0000:82:00.0  VF:0000:82:10.0
/sys/bus/pci/devices/0000:82:00.0/sriov_vf_10bit_tag
/sys/bus/pci/devices/0000:82:10.0/sriov_vf_10bit_tag_ctl

sriov_vf_10bit_tag is used to qeury the status of VF 10-Bit Tag
Requester Enable,  bind with PF device.

sriov_vf_10bit_tag_ctl is used to disable the VF 10-Bit Tag Requester,
bind with VF device, although in fact it writes PF SR-IOV control 
register, just detect if the VF driver have already bond with the VF deivce.

Thanks,
Dongdong
