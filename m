Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17762833E1
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 12:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgJEKQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 06:16:44 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:49936 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgJEKQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 06:16:43 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 095AGcYj102005;
        Mon, 5 Oct 2020 05:16:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601892998;
        bh=BIrAyC/UllJ2D7vPxFH2SxwI4Y1wK41La+DILzDaZXg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=i3Fi3UA4zcaZl2QMUO/HHF4fp7UWhw8/fZwhZxX9UXbiv4M6ifiJ79W2PjUjOs+74
         bcXYZjQotAhH/8FmAJAn8HpqWyApLd6HCRtakxClDGRLa7z7vmIsbpqkbMNLzuuH5B
         bw6xGHxa2SN3PGPO7JwEIld8TJfkd8LC8LOeTW6o=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 095AGcug018599
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 5 Oct 2020 05:16:38 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 5 Oct
 2020 05:16:38 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 5 Oct 2020 05:16:38 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 095AGZrs103006;
        Mon, 5 Oct 2020 05:16:35 -0500
Subject: Re: [PATCH net-next 0/8] net: ethernet: ti: am65-cpsw: add multi port
 support in mac-only mode
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
References: <20201001105258.2139-1-grygorii.strashko@ti.com>
 <20201001160847.3b5d91f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c758885c-6834-e689-2356-81291e4628e8@ti.com>
 <20201002160421.59363229@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201002160752.1166cffe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <c67c1bb3-b71e-848a-7c03-f68830605dee@ti.com>
Date:   Mon, 5 Oct 2020 13:16:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201002160752.1166cffe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/10/2020 02:07, Jakub Kicinski wrote:
> On Fri, 2 Oct 2020 16:04:21 -0700 Jakub Kicinski wrote:
>> On Fri, 2 Oct 2020 12:56:43 +0300 Grygorii Strashko wrote:
>>> On 02/10/2020 02:08, Jakub Kicinski wrote:
>>>> On Thu, 1 Oct 2020 13:52:50 +0300 Grygorii Strashko wrote:
>>>>> This series adds multi-port support in mac-only mode (multi MAC mode) to TI
>>>>> AM65x CPSW driver in preparation for enabling support for multi-port devices,
>>>>> like Main CPSW0 on K3 J721E SoC or future CPSW3g on K3 AM64x SoC.
>>>>>
>>>>> The multi MAC mode is implemented by configuring every enabled port in "mac-only"
>>>>> mode (all ingress packets are sent only to the Host port and egress packets
>>>>> directed to target Ext. Port) and creating separate net_device for
>>>>> every enabled Ext. port.
>>>>
>>>> Do I get it right that you select the mode based on platform? Can the
>>>> other mode still be supported on these platforms?
>>>>
>>>> Is this a transition to normal DSA mode where ports always have netdevs?
>>>
>>> The idea here is to start in multi mac mode by default, as we still
>>> have pretty high demand for this. Then, and we are working on it, the
>>> switchdev mode is going to be introduces (not DSA). The switch
>>> between modes will happen by using devlink option - the approach is
>>> similar to what was used for Sitara CPSW cpsw_new.c driver [1].
>>
>> What's unclear from the patches is whether the default configuration
>> for already supported platforms will change?
>>
>> All the patches sound like they are "in preparation for support of K3
>> J721E" etc. So this is just code restructuring with no user-visible
>> changes?
> 
> Another way of putting the question perhaps would be - is num_ports
> always 1 for existing platforms?
> 

Yes. Sorry for confusion - all now supported K3 CPSW instances have 1 external port and
these changes should not have affect on them.

-- 
Best regards,
grygorii
