Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530DF2616F6
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731834AbgIHRXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:23:13 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34520 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731712AbgIHRXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:23:07 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 088E7Sj8038986;
        Tue, 8 Sep 2020 09:07:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599574048;
        bh=QLaKQ/Q1xV0ZUM+n4xuaJnI1s6Kz1NtLSH7K2BZHlbg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=mSpTbyOZzMrkwv7gbHo0YJhf9UTEzpVNmmVOe2ff4WdUA9iLJA9ZDGxF+RIxVQ7Um
         CHy68IZrFc8zttfeP1yp/9o5O3JF/eFqrWBySoQQTbTs6NOWJhtphBmx2SzJv9PKQH
         nCTSJGfdmqEbcVGi+AUZXjD7WoD9OGIH3v2HMZBw=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 088E7Sfu043635
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 8 Sep 2020 09:07:28 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 8 Sep
 2020 09:07:27 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 8 Sep 2020 09:07:27 -0500
Received: from [10.250.38.37] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 088E7RSx043677;
        Tue, 8 Sep 2020 09:07:27 -0500
Subject: Re: [PATCH net-next v3 3/3] net: dp83869: Add speed optimization
 feature
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200903114259.14013-1-dmurphy@ti.com>
 <20200903114259.14013-4-dmurphy@ti.com>
 <20200905113818.7962b6d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <9848c3ee-51c2-2e06-a51b-3aacc1384557@ti.com>
Date:   Tue, 8 Sep 2020 09:07:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200905113818.7962b6d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub

On 9/5/20 1:38 PM, Jakub Kicinski wrote:
> On Thu, 3 Sep 2020 06:42:59 -0500 Dan Murphy wrote:
>> +static int dp83869_set_downshift(struct phy_device *phydev, u8 cnt)
>> +{
>> +	int val, count;
>> +
>> +	if (cnt > DP83869_DOWNSHIFT_8_COUNT)
>> +		return -E2BIG;
> ERANGE

This is not checking a range but making sure it is not bigger then 8.

IMO I would use ERANGE if the check was a boundary check for upper and 
lower bounds.

Dan

