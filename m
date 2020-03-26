Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A524E1948A5
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgCZUS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:18:28 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:52352 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgCZUS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 16:18:27 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02QKILlB035158;
        Thu, 26 Mar 2020 15:18:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1585253901;
        bh=acOH02zgrD/iIEWGjM+u8IbzyboIFHTfr8eulz18fTU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=cb8aQenQF02vYBMSxaBaUe9B0YiviWLZtYdoBU8ddLTkhjiypDNsaonduB+5JI86i
         oqHCySREE6ossz0gpkszNpmLlw4lPLVjOfeApVl5/hL6OBv7+73Veo4aMHILJbAEv+
         xnZ3CUZkQamz6p/4xoyYxRQOd+62/O11krF6kE0c=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02QKILW6013512
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 26 Mar 2020 15:18:21 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 26
 Mar 2020 15:18:21 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 26 Mar 2020 15:18:21 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02QKIII6080272;
        Thu, 26 Mar 2020 15:18:19 -0500
Subject: Re: [PATCH net-next v3 03/11] net: ethernet: ti: cpts: move tc mult
 update in cpts_fifo_read()
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
 <20200320194244.4703-4-grygorii.strashko@ti.com>
 <20200326142049.GD20841@localhost>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <f91001c9-2b11-53ac-84a7-11e1e94c5dc9@ti.com>
Date:   Thu, 26 Mar 2020 22:18:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200326142049.GD20841@localhost>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/03/2020 16:20, Richard Cochran wrote:
> On Fri, Mar 20, 2020 at 09:42:36PM +0200, Grygorii Strashko wrote:
>> Now CPTS driver .adjfreq() generates request to read CPTS current time
>> (CPTS_EV_PUSH) with intention to process all pending event using previous
>> frequency adjustment values before switching to the new ones. So
>> CPTS_EV_PUSH works as a marker to switch to the new frequency adjustment
>> values. Current code assumes that all job is done in .adjfreq(), but after
>> enabling IRQ this will not be true any more.
>>
>> Hence save new frequency adjustment values (mult) and perform actual freq
>> adjustment in cpts_fifo_read() immediately after CPTS_EV_PUSH is received.
> 
> Now THIS comment is much better!  The explanation here really should
> be in the previous patch, to help poor reviewers like me.

I've been thinking to squash them. What's your opinion.

Thank you.

-- 
Best regards,
grygorii
