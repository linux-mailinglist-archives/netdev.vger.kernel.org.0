Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F93CDEB8
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 12:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfJGKHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 06:07:46 -0400
Received: from mail-eopbgr40069.outbound.protection.outlook.com ([40.107.4.69]:55439
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbfJGKHp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 06:07:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCFV8SJ6XqFNfHa8sCCMwofzlhMaieXZw6m5nDuMpuMjl/DEzAXllW8Ahk+aOlPHtra5izCMaGoOvFGP6YrGk3bst6kSAkPk+I1mUFPebFxMscXcU7q01ohUoOqvbZOTFVUhND/gjsDKJ3+surz5F2qwlzTBVBsC375NF/0NpnhnKHOEbIaxLmSqKzeq6wk4++mDyDowHOPD6erl26sAq+mbg/bcMZIAF5SPpzwuwgsQBNregbda6ng3r6butOEIV4s3w7UGmzRlTZjsJSXUJKl9DMZHQvynCRPmUAvGcC6hW57j66LLChiatyzuYdJbKTNpiUo1HPvTh3NAsZJuxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWonl1IQ0SjAPhe170jcyvodLv6PnX5p9JrFLuKguOk=;
 b=eSYHFJOqgAWjayv7rkwUG9u00pvKRzk5JolgcMgBb7RQi0V+UtgTmCfmtck4pUy2oICfSORFBzNie7HTBKKJtxTgGMu3cqZP2QCBSqcEX7Ahr4V6xCtAi6J86fY0w6vaAaaCASHWWkAgCJtc5VFW2Bd5B3bKl3ZbEPyYvZhNrUBjdljFpHehz9p8R9wILHaCRw6RtN1Jlvx9AzgqkD5p6DJ4QyjnUrkSbk1ATkZ8uMlIpTm/bqntAUjpnaaqeGfmNcbXO+wdCSyO/82Xydpnw/SBkTHyvzXxGZ0T7Hukt9ExyXuxi+akQzYt5m/G6UfF9B3KbI078BOhhMkyzfalkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 193.47.165.251) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=mellanox.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=mellanox.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWonl1IQ0SjAPhe170jcyvodLv6PnX5p9JrFLuKguOk=;
 b=ZhNbuGBcXZgA43PSJeSFnr6BDYdYBQhx6LGUaI+m43Nor8INsBwh+3onUQYqCK9ywkXYZfteK1/PqlqJOnPR9kmFJVU06WmoHbMKMyqtcrG7PMrcCUy1CLwJ9E6bv8cMqr7vS9qnsearvCpAVDrq6J/VuwVXPCC3/7YKbz7HGBE=
Received: from HE1PR05CA0261.eurprd05.prod.outlook.com (2603:10a6:3:fc::13) by
 VI1PR05MB5152.eurprd05.prod.outlook.com (2603:10a6:803:b2::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Mon, 7 Oct 2019 10:07:41 +0000
Received: from VE1EUR03FT039.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::207) by HE1PR05CA0261.outlook.office365.com
 (2603:10a6:3:fc::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2327.23 via Frontend
 Transport; Mon, 7 Oct 2019 10:07:40 +0000
Authentication-Results: spf=pass (sender IP is 193.47.165.251)
 smtp.mailfrom=mellanox.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=mellanox.com;
Received-SPF: Pass (protection.outlook.com: domain of mellanox.com designates
 193.47.165.251 as permitted sender) receiver=protection.outlook.com;
 client-ip=193.47.165.251; helo=mtlcas13.mtl.com;
Received: from mtlcas13.mtl.com (193.47.165.251) by
 VE1EUR03FT039.mail.protection.outlook.com (10.152.19.196) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Mon, 7 Oct 2019 10:07:40 +0000
Received: from MTLCAS13.mtl.com (10.0.8.78) by mtlcas13.mtl.com (10.0.8.78)
 with Microsoft SMTP Server (TLS) id 15.0.1178.4; Mon, 7 Oct 2019 13:07:38
 +0300
Received: from MTLCAS01.mtl.com (10.0.8.71) by MTLCAS13.mtl.com (10.0.8.78)
 with Microsoft SMTP Server (TLS) id 15.0.1178.4 via Frontend Transport; Mon,
 7 Oct 2019 13:07:38 +0300
Received: from [10.223.0.100] (10.223.0.100) by MTLCAS01.mtl.com (10.0.8.71)
 with Microsoft SMTP Server (TLS) id 14.3.468.0; Mon, 7 Oct 2019 13:07:02
 +0300
Subject: Re: [PATCH rdma-next 3/3] RDMA/rw: Support threshold for registration
 vs scattering to local pages
To:     Leon Romanovsky <leon@kernel.org>,
        Christoph Hellwig <hch@infradead.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20191006155955.31445-1-leon@kernel.org>
 <20191006155955.31445-4-leon@kernel.org>
 <20191007065825.GA17401@infradead.org> <20191007075437.GV5855@unreal>
From:   Max Gurtovoy <maxg@mellanox.com>
Message-ID: <3b0f2757-eb84-f5f8-d036-4bdce21ae943@mellanox.com>
Date:   Mon, 7 Oct 2019 13:07:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191007075437.GV5855@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.223.0.100]
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:193.47.165.251;IPV:NLI;CTRY:IL;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(396003)(346002)(199004)(189003)(47776003)(106002)(70586007)(36756003)(478600001)(86362001)(4326008)(31696002)(70206006)(486006)(3846002)(6116002)(126002)(65956001)(65806001)(5660300002)(31686004)(76176011)(305945005)(316002)(16576012)(7736002)(36906005)(336012)(53546011)(229853002)(8936002)(58126008)(11346002)(81166006)(8676002)(2616005)(110136005)(50466002)(446003)(81156014)(476003)(26005)(14444005)(2906002)(6246003)(54906003)(230700001)(2486003)(23676004)(16526019)(186003)(356004)(3940600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5152;H:mtlcas13.mtl.com;FPR:;SPF:Pass;LANG:en;PTR:InfoDomainNonexistent;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1acdb01-4356-434c-09ec-08d74b0e300c
X-MS-TrafficTypeDiagnostic: VI1PR05MB5152:
X-Microsoft-Antispam-PRVS: <VI1PR05MB5152ADA9A3FA1AD2FE13531BB69B0@VI1PR05MB5152.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 01834E39B7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 81TwVSheUOntvq7bUm7h+HdELR5TkiKbzkioocrkCX36CK0EcFDwmVAMvB7FaLBE0MOMyokgB+Vd6X9lqXcC4ww3r0qPAgo8rGSbK/eJIViqV47+KNNZISWG41RWcFlwjb6z/VuqaDJcWyrq24m6CJ8bwQxXi0neJQDmYCsJNZM4kdNM6oyvhHnwn1Qg7qxsUXXvfsgPi+wiHFJeACQG/axBUSXy6s+2p6I11yUW5KkYaXsSQ25UMczThe/WXFI0fmSDRbfHoKnOvEBClTZmEVsN3dOZmlsbFW4T46hG2rXY3wN7fvlqm0zpJR9tJfV+UVRjHPb9HWXBCumnVg3cYcf9B3ysQ/uU03a5Hvf0TGS1QiNGQNN+z6HBmL5xWguLyMdEivIPOR6+Q5yI6jmnC/s5u6q6oZIYQuyUcXWHdnE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2019 10:07:40.0312
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1acdb01-4356-434c-09ec-08d74b0e300c
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a652971c-7d2e-4d9b-a6a4-d149256f461b;Ip=[193.47.165.251];Helo=[mtlcas13.mtl.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5152
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/7/2019 10:54 AM, Leon Romanovsky wrote:
> On Sun, Oct 06, 2019 at 11:58:25PM -0700, Christoph Hellwig wrote:
>>>   /*
>>> - * Check if the device might use memory registration.  This is currently only
>>> - * true for iWarp devices. In the future we can hopefully fine tune this based
>>> - * on HCA driver input.
>>> + * Check if the device might use memory registration.
>>>    */
>> Please keep the important bits of this comments instead of just
>> removing them.
>>
>>>   {
>>> @@ -30,6 +28,8 @@ static inline bool rdma_rw_can_use_mr(struct ib_device *dev, u8 port_num)
>>>   		return true;
>>>   	if (unlikely(rdma_rw_force_mr))
>>>   		return true;
>>> +	if (dev->attrs.max_sgl_rd)
>>> +		return true;
>> Logically this should go before the rdma_rw_force_mr check.
>>
>>>   	if (unlikely(rdma_rw_force_mr))
>>>   		return true;
>>> +	if (dev->attrs.max_sgl_rd && dir == DMA_FROM_DEVICE
>>> +	    && dma_nents > dev->attrs.max_sgl_rd)
>> Wrong indendation.  The && belongs on the first line.  And again, this
>> logically belongs before the rdma_rw_force_mr check.
> I'll fix.
>
> Thanks

The above comments looks reasonable.

Nice optimization Yamin.

