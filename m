Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C187F3E1825
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 17:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242066AbhHEPhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 11:37:19 -0400
Received: from ale.deltatee.com ([204.191.154.188]:46304 "EHLO
        ale.deltatee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242000AbhHEPhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 11:37:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:content-disposition;
        bh=FxYXTHDKCyAHR0FYBUwfJJEcH3aS8cyREXURVdqN5q0=; b=BjKGfcMbJaSz5EI4uoGVGgtNou
        zfsti+KtAHPe6/B1GVGOmRjNso8+YObUCICxTILRRqezHaHobvX4d4r7x6yz7w5C04P191lQH1Syr
        2ADzcIxeZZwp71jJRPRCrd2S1Gp0QbvMzDUq7cnoB4SvD9QKmccnh0J/JUriAYF/wsCG4+ZnHVtzw
        pPNAXdrdWOKXv/+2dJcoUUnZwB7ZOcyu6dKPnGiGd8oN3EP+C+ghLngsGKLZjXRBSo75qFImfKAcM
        oBW6FUiG/zmmePYL7Ssa4m1kdI/m8q//cy9U3kCDYUAPuRkDvoGGBZsv8w556Zvoq1cFEubtM1HXt
        pd0JNqbA==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1mBfQZ-0001xq-3P; Thu, 05 Aug 2021 09:36:59 -0600
To:     Dongdong Liu <liudongdong3@huawei.com>, helgaas@kernel.org,
        hch@infradead.org, kw@linux.com, leon@kernel.org,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org, netdev@vger.kernel.org
References: <1628084828-119542-1-git-send-email-liudongdong3@huawei.com>
 <1628084828-119542-8-git-send-email-liudongdong3@huawei.com>
 <75243571-3213-6ae2-040f-ae1b1f799e42@deltatee.com>
 <8758a42b-233b-eb73-dce4-493e0ce8eed5@huawei.com>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <fee2f889-f549-26a1-4afa-57f52500d6e2@deltatee.com>
Date:   Thu, 5 Aug 2021 09:36:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <8758a42b-233b-eb73-dce4-493e0ce8eed5@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, linux-media@vger.kernel.org, hverkuil-cisco@xs4all.nl, rajur@chelsio.com, linux-pci@vger.kernel.org, leon@kernel.org, kw@linux.com, hch@infradead.org, helgaas@kernel.org, liudongdong3@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        GREYLIST_ISWHITE,MYRULES_OFFER,NICE_REPLY_A autolearn=ham
        autolearn_force=no version=3.4.2
Subject: Re: [PATCH V7 7/9] PCI/sysfs: Add a 10-Bit Tag sysfs file
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-08-05 7:14 a.m., Dongdong Liu wrote:
> On 2021/8/4 23:51, Logan Gunthorpe wrote:
>>
>>
>>
>> On 2021-08-04 7:47 a.m., Dongdong Liu wrote:
>>> PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
>>> sending Requests to other Endpoints (as opposed to host memory), the
>>> Endpoint must not send 10-Bit Tag Requests to another given Endpoint
>>> unless an implementation-specific mechanism determines that the Endpoint
>>> supports 10-Bit Tag Completer capability. Add a 10bit_tag sysfs file,
>>> write 0 to disable 10-Bit Tag Requester when the driver does not bind
>>> the device if the peer device does not support the 10-Bit Tag Completer.
>>> This will make P2P traffic safe. the 10bit_tag file content indicate
>>> current 10-Bit Tag Requester Enable status.
>>
>> Can we not have both the sysfs file and the command line parameter? If
>> the user wants to disable it always for a specific device this sysfs
>> parameter is fairly awkward. A script at boot to unbind the driver, set
>> the sysfs file and rebind the driver is not trivial and the command line
>> parameter offers additional options for users.
> Does the command line parameter as "[PATCH V6 7/8] PCI: Add
> "pci=disable_10bit_tag=" parameter for peer-to-peer support" does?
> 
> Do we also need such command line if we already had sysfs file?
> I think we may not need.

In my opinion, for reasons stated above, the command line parameter is
way more convenient.

Logan
