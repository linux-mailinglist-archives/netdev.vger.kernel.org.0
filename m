Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A645C4A4D5A
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350294AbiAaRft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:35:49 -0500
Received: from mail-eopbgr00066.outbound.protection.outlook.com ([40.107.0.66]:46215
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245413AbiAaRft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 12:35:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZ4uLwyXTxVlld/wRzE7kgkY/mVcJtkKAj9mnEI3dxn3x7LjXfR+qHgmVjoE5p2WXGASoOqETC7cdfLVlwasUrIoMftk0NeIO+BvdqrDP3gKXJYernpDzmpHRKq7eCuVZ6/H8FhvHTmTtq2ilQZzBWR+czBL/Otul4+FquVBhcjeTho6g6Z+AzoKFEHqnQOdjddpGnBaEfJHfyjiwMBsPzbO1P5HhpUWgYF9D7lxPJgSYlzbofCm/DT0CRuCyEi6cIwgsILOeGCx96tEc1mxqs/hGDbvyvVy9LHXYofBDzLjrfDk1sdDYtuUI6R7PMprAdTl7bNxN+8nsD1AcLJ+xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c+HF7Jgq0tVbFynJzYoyuneFhNuxjVpfJZjFJ7SpsuQ=;
 b=e4DHxMtShQ/K6Be3SwswV5vEHtpJYXiOUbdu2oDGFQp8yntlGzASNkDirfxuhxBAQJFMrxBATy1rz4kajPs/zHTDD0bDCAC0j46Otxop6TkMrB11A27sALDzurOYyVyYOG9splzhqmjugFKyTiDGa6U1fJKlaOSVlHLF4dpje6Rv1Tyjaj5g6kjQcN4DNJgMJjPWN/6vTuCQvm/rtAQ0PBCmtxRiath2dZ0qg2Ah5KVH1Dbl8fNSHbfn7s7N15G5K46CtDxPc9DMQPQmBVK7srTcT7qmaDb0lJR6PkMU/N/0Os4qpZvHnM+j5LmOakxViOD156HXM08KPIRhLGQi6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.71) smtp.rcpttodomain=kernel.org smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+HF7Jgq0tVbFynJzYoyuneFhNuxjVpfJZjFJ7SpsuQ=;
 b=aLThN8aj5kKnQ9L7N4CfAtZbEKgKeMB4hW6m5e4OadXB65txNBbTxRkyVv/joO940P3ZeUaEvpz+6PME8OWVIa50m3UFlvmiN4INQKM3xjb3rNYNQ65+O0a3K+gEtFUnNriupLQDqTNn9y2CnmQ1CQmglaXdjXLlEkmlV3YK4kuMR29JOFKlE79j0lCQ/OJXtr5cfrU67WpZjxk2wvBqdpoG06V+Mh882lEavN63OcrnfZOkJTiweqyXekvlWUrOWpUfJGXg80t3pkJe7SZds39IFsJx4UDMWMder+kZueyh5w9lBYSLIilDq3/5EALmJhwmK3ZT4iYf1pLMLiRXLA==
Received: from DB6PR0301CA0079.eurprd03.prod.outlook.com (2603:10a6:6:30::26)
 by AS1PR10MB5167.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:4ab::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 17:35:47 +0000
Received: from DB5EUR01FT013.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:6:30:cafe::3) by DB6PR0301CA0079.outlook.office365.com
 (2603:10a6:6:30::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21 via Frontend
 Transport; Mon, 31 Jan 2022 17:35:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.71)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.71 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.71; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.71) by
 DB5EUR01FT013.mail.protection.outlook.com (10.152.4.239) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 17:35:46 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SKA.ad011.siemens.net (194.138.21.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Mon, 31 Jan 2022 18:35:46 +0100
Received: from [167.87.32.84] (167.87.32.84) by DEMCHDC8A0A.ad011.siemens.net
 (139.25.226.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 31 Jan
 2022 18:35:45 +0100
Message-ID: <6108f260-36bf-0059-ccb9-8189f4a2d0c1@siemens.com>
Date:   Mon, 31 Jan 2022 18:35:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Georgi Valkov <gvalkov@abv.bg>,
        Greg KH <gregkh@linuxfoundation.org>, <davem@davemloft.net>,
        <mhabets@solarflare.com>, <luc.vanoostenryck@gmail.com>,
        <snelson@pensando.io>, <mst@redhat.com>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <corsac@corsac.net>,
        <matti.vuorela@bitfactor.fi>, <stable@vger.kernel.org>
References: <B60B8A4B-92A0-49B3-805D-809A2433B46C@abv.bg>
 <20210720122215.54abaf53@cakuba>
 <5D0CFF83-439B-4A10-A276-D2D17B037704@abv.bg> <YPa4ZelG2k8Z826E@kroah.com>
 <C6AA954F-8382-461D-835F-E5CA03363D84@abv.bg> <YPbHoScEo8ZJyox6@kroah.com>
 <AEC79E3B-FA7F-4A36-95CE-B6D0F3063DF8@abv.bg>
 <80a13e9b-e026-1238-39ed-32deb5ff17b0@siemens.com>
 <20220131092726.3864b19f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
In-Reply-To: <20220131092726.3864b19f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.87.32.84]
X-ClientProxiedBy: DEMCHDC89YA.ad011.siemens.net (139.25.226.104) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0eeafc2-d743-4c6e-95b0-08d9e4e01da3
X-MS-TrafficTypeDiagnostic: AS1PR10MB5167:EE_
X-Microsoft-Antispam-PRVS: <AS1PR10MB5167FCB4526D06732EABAC0595259@AS1PR10MB5167.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F9Qql6+yJpqFvjITUwoXZGH0KSMj8/DYxH/ToG9aesB+ZcuN7uZA/KflrCRK3d653mA6yJlLxHCxeP1u+qsw5vJ0Z+zFFZUvNEit8EXHjaLKKrEiEJUUqRGh5PU6fYAV6SB5DeGi5moqLVigA0shu1dMV1jp8lUAw2YXqaJ4TFkDFVGPvzBZr4B1vKd7NMPMSmFXiVa0tG2pGkx660PDY/OIIzIcZel44qXGgSI3hWDZ50DKh1T74ByoPmHsYI4MhEX2+HP0NDuAkEA9f3xivHFApLGv08o/Mq0Q/TV8Wo4CNK80lklmLDXD/6B+pCqkh27tV/+pA1QuB02Uh9gJKWlhXsQ2eFKmeW/Ps9owlbt35jOJ1hZc/11l0WztQ7xd2amlqJzAFu2PF4GJ6vXEI68jNrviD11/6WsAWKXUwqEMjfRo3art2vCSlhIB8R4pgwvO9VSSPPm2GCb8F4aPpzyKXneSXvHO20xZ96E6+eXyIrO64g+sV+OvTbIuXKTTn7r75NLnjLQD8El57lrFjoObLeEpJOMAoo68DI4MfcRPVsTjoI0KzxJLN0jpFNo1anbB0bmsplKIKOZUhRqvghBPNJcLx67tglXNN8eaqvIsZjmJuJtlnimjYRBZZNiSqTc2AK4nuNUQusnHRsfwSluS4IppttC8RZGcvMKAFPc+g9gU9yfinIq1bnrhM3H5BTKIJZZifxBEEG70bcSoGLdCUNQ6ugShOxBpiud4+RYZ37ChqI1xhnimTLSddM5GZsNyVdW7bnmiaCAOI9b0Sg==
X-Forefront-Antispam-Report: CIP:194.138.21.71;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(83380400001)(36860700001)(31686004)(47076005)(44832011)(7416002)(5660300002)(2906002)(356005)(81166007)(26005)(8676002)(186003)(336012)(40460700003)(956004)(8936002)(70206006)(4326008)(70586007)(2616005)(82960400001)(16526019)(31696002)(82310400004)(54906003)(316002)(86362001)(4744005)(6706004)(6916009)(16576012)(53546011)(36756003)(508600001)(3940600001)(36900700001)(43740500002)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 17:35:46.9921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0eeafc2-d743-4c6e-95b0-08d9e4e01da3
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.71];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR01FT013.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR10MB5167
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.01.22 18:27, Jakub Kicinski wrote:
> On Mon, 31 Jan 2022 10:45:23 +0100 Jan Kiszka wrote:
>> On 20.07.21 15:12, Georgi Valkov wrote:
>>> Thank you, Greg!
>>>
>>> git send-email drivers/net/0001-ipheth-fix-EOVERFLOW-in-ipheth_rcvbulk_callback.patch
>>> ...
>>> Result: OK
>>>
>>> I hope I got right. I added most of the e-mail addresses, and also tried adding Message-Id.
>>> I have not received the e-mail yet, so I cannot confirm if it worked or not.
>>>    
>>
>> What happened here afterwards?
>>
>> I just found out the hard way that this patch is still not in mainline
>> but really needed.
> 
> I have not seen the repost :(

Would it help if I do that on behalf of Georgi? Meanwhile, I can add a 
tested-by to it, after almost a full working day with it applied.

Jan

-- 
Siemens AG, Technology
Competence Center Embedded Linux
