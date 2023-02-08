Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAA168E5FC
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 03:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjBHCQy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Feb 2023 21:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjBHCQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 21:16:52 -0500
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09AC5FF3;
        Tue,  7 Feb 2023 18:16:47 -0800 (PST)
X-QQ-mid: bizesmtp81t1675822584trrozg97
Received: from smtpclient.apple ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 08 Feb 2023 10:16:23 +0800 (CST)
X-QQ-SSF: 00400000000000N0O000000A0000000
X-QQ-FEAT: QityeSR92A2Iyp0bb1oGxYmEVdI5K8IJwfpAjYyRKdH9eI36zAv0ix/Yz9huX
        fBdFz4hT2v0UF7LVfFzxaiCJpeBU8LA0vpT4N4irp45t+sfJwkPcVBiwCXs1EMTqUxjFjBZ
        BW42YY/1Zpc+26XnU8oRu2ZVX21h2peTq7Rr/BCkGMZSEVsNU2WCnCUSntEPFh7OfJmGoC2
        A6wl3S33ne8+8l4ET0Igm+r7evS+AW6HF/MxHz71hpkc1BqIHTi4ZLRFyE8nWlWfDoyvk3t
        443uKMCsai2oXoVCHxCB//kpy3nkFyCq+WFV24pU7JeS6fhlTUOr7Wn8iWui15plFhRaqIg
        HBHzODcSB/T1YL2adRdejmVFcto3J4MFYegKlWCY2DvENdkgfD6G16ZLbkq4Q6+yOXLO1qE
        l5NWwmNTel0=
X-QQ-GoodBg: 2
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.51\))
Subject: Re: [PATCH] PCI: Add ACS quirk for Wangxun NICs
From:   "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <Y+KMhg145coygAdY@corigine.com>
Date:   Wed, 8 Feb 2023 10:16:13 +0800
Cc:     netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        helgaas@kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <5E1719B4-C7B4-49F7-9883-AF92A6685C03@net-swift.com>
References: <20230207102419.44326-1-mengyuanlou@net-swift.com>
 <Y+KMhg145coygAdY@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
X-Mailer: Apple Mail (2.3731.300.51)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 2023年2月8日 01:38，Simon Horman <simon.horman@corigine.com> 写道：
> 
> On Tue, Feb 07, 2023 at 06:24:19PM +0800, Mengyuan Lou wrote:
>> Wangxun has verified there is no peer-to-peer between functions for the
>> below selection of SFxxx, RP1000 and RP2000 NICS.
>> They may be multi-function device, but the hardware does not advertise
>> ACS capability.
>> 
>> Add an ACS quirk for these devices so the functions can be in
>> independent IOMMU groups.
>> 
>> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> 
> ...
> 
>> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
>> index b362d90eb9b0..bc8f484cdcf3 100644
>> --- a/include/linux/pci_ids.h
>> +++ b/include/linux/pci_ids.h
>> @@ -3012,6 +3012,8 @@
>> #define PCI_DEVICE_ID_INTEL_VMD_9A0B 0x9a0b
>> #define PCI_DEVICE_ID_INTEL_S21152BB 0xb152
>> 
>> +#define PCI_VENDOR_ID_WANGXUN 0x8088
>> +
> 
> nit: this is already present in drivers/net/ethernet/wangxun/libwx/wx_type.h
>     perhaps it can be removed from there as a follow-up ?
It will be removed in a later patch.

> 
>> #define PCI_VENDOR_ID_SCALEMP 0x8686
>> #define PCI_DEVICE_ID_SCALEMP_VSMP_CTL 0x1010
>> 
>> -- 
>> 2.39.1
>> 
> 

Best Regards,
Mengyuanlou
