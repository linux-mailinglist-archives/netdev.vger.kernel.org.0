Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E5914B1FF
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 10:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgA1Juj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 04:50:39 -0500
Received: from mail-eopbgr70131.outbound.protection.outlook.com ([40.107.7.131]:31630
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725987AbgA1Juj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 04:50:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7Gs230wpxTwEYI/Ww31RoZF+TPGsZsNc5qDLd1oKiX1P1GUSmSSG8EsR+cLl3YHatRukaNabCcvShfino06UfnChIowYz6ZLP1AdnimlMRKGtay6u4uiafbWauLNUMRRIdPGUjlnt5Ydya9RtfaYSM2q1d2Yg+PyoOomaWU0IpCmnKime8psGTkvcESsuDIWNfc9QkvItk8SkwAj7nKdUpKttZc6sJEdR6nYtHpccacjJm7k4hxhfJbrG73w3nYPHEIHEA89vch2LqCMH/3CMEXpG25sHPWq7J6H97MKuHAONm9vuVIgsrR6pb6UR8jiR7pZHAuz+dm6Ik1cRSNog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IijY61Yupu3lpZShNtNKKqM22oGkxJyhATEBVRGXy+M=;
 b=EiysYZsbvIfei+E6ZTz9MYdxLjhipG3/fXnDTuAF6FYsAKKtj2J4FmMkUPPMqoRXHCY5ndhF/VoVef2/hCVsDV+DbynxEnU9O9jSo7SltUtIbzkrsNkyUFXXXm4Go2G/GeeuONz7e/c4QPHTms/8rhxkHwhYxY7PT9pZhxSiCTfZRI0WzSd1BJyeakNDy8K9fRMO4wzf6Qt8TxnSeKVok1G2v8/i1/3Lc8PmPuXylBQz+NR6cV2dWH7RF0W856PPffky9fQZ6l9bN/JEkPSwiOtiL5fWRaQJI3q/i2qJFX5q3SgWF/+XwlDVo2Ko7VguKV0fp2Zk7ajlg4LAO451kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=televic.com; dmarc=pass action=none header.from=televic.com;
 dkim=pass header.d=televic.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=televic.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IijY61Yupu3lpZShNtNKKqM22oGkxJyhATEBVRGXy+M=;
 b=TNBfkGm+152pfp+0idSHyzjtJDZcIKs8ZLzHccqnzBHd8Y8EZvc3jK7dx1wkStz19R6JkNF5jjedbMhM7Ec6pjiWKgksUJnig1UdKpCEyS4tmL/lopXp31tlahIvb79SdoiagSGL1BmlmBhG+a6MxwGWXVwwxVHHMQY9dBj4oxM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=J.Lambrecht@TELEVIC.com; 
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com (20.177.203.77) by
 VI1PR07MB5837.eurprd07.prod.outlook.com (20.178.122.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.13; Tue, 28 Jan 2020 09:50:35 +0000
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::6591:ac75:8bbf:2349]) by VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::6591:ac75:8bbf:2349%5]) with mapi id 15.20.2686.019; Tue, 28 Jan 2020
 09:50:35 +0000
From:   =?UTF-8?Q?J=c3=bcrgen_Lambrecht?= <j.lambrecht@televic.com>
Subject: Re: [RFC net-next v3 06/10] net: bridge: mrp: switchdev: Extend
 switchdev API to offload MRP
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-7-horatiu.vultur@microchip.com>
 <20200125163504.GF18311@lunn.ch>
 <20200126132213.fmxl5mgol5qauwym@soft-dev3.microsemi.net>
 <20200126155911.GJ18311@lunn.ch>
 <20200127110418.f7443ecls6ih2fwt@lx-anielsen.microsemi.net>
Message-ID: <8f59fcfc-09e3-2411-0139-9be54d3e156f@televic.com>
Date:   Tue, 28 Jan 2020 10:50:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200127110418.f7443ecls6ih2fwt@lx-anielsen.microsemi.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR05CA0029.eurprd05.prod.outlook.com
 (2603:10a6:208:55::42) To VI1PR07MB5085.eurprd07.prod.outlook.com
 (2603:10a6:803:9d::13)
MIME-Version: 1.0
Received: from [10.40.216.140] (84.199.255.188) by AM0PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:208:55::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Tue, 28 Jan 2020 09:50:34 +0000
X-Originating-IP: [84.199.255.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ec00279-ed93-4d4e-64bd-08d7a3d78568
X-MS-TrafficTypeDiagnostic: VI1PR07MB5837:
X-Microsoft-Antispam-PRVS: <VI1PR07MB5837CF1444E2C00967C7EF4FFF0A0@VI1PR07MB5837.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 029651C7A1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39850400004)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(109986005)(478600001)(8936002)(36756003)(31696002)(52116002)(81156014)(81166006)(450100002)(8676002)(956004)(4326008)(2616005)(66946007)(31686004)(66556008)(66476007)(2906002)(26005)(86362001)(16526019)(186003)(53546011)(16576012)(6486002)(316002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB5837;H:VI1PR07MB5085.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: TELEVIC.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bbl7LEjh9D5kRfwPV/wcSKsp1UpUssnmqazoMfwJENKYKggdh0CcmNW5v6tUd92e6RRH8IDn/Es6aQxG1Csl0tZGO3MlmRjrTub/e2SXk/stq3gFzcXWPnBByl1LVb+rqN55mAgcLNA8IAdoKOQlQbU43su/PNwoQ5CLT8Siz6z2ED7KkZk5ONhz1Lx0bR0lZsAVv8/02R5eF7SkWCQNyosr2ewau2HHcJ4cy49+cWRlyMdgzEytcJ9pABizuLI0n8Kl6r2zYsPglc5RHKESUFv0OnVe3HVu67/XgKrg5FkwNtWQkWYB9QE+8ABx0hYT1NY3DatrlKWe/pSyWKRronKPpxK3oLhB4o5YCiyOA1DODTtdV+zoolT4kH/HoaoOT4aiuqZM4ejY2zIC1LdYZPKbSoQhf0T7mn1a2KYLBeZJ0mLnWyTVgmMPfuIw4cHo
X-MS-Exchange-AntiSpam-MessageData: XC3N0pFXPVtQJD3IvTZh6yBEFJtjg1lIL11aknG4f4u6Fc4ifglnEtZUCX3l3E+qa3i4AAG7AIiUGCbul52l3PDZKKrMyfLdaaeCsV5YkgyXmXR90iupjohDKYej54Nidb5k/JnKsUrd3eYESdNXlg==
X-OriginatorOrg: televic.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec00279-ed93-4d4e-64bd-08d7a3d78568
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2020 09:50:35.0050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 68a8593e-d1fc-4a6a-b782-1bdcb0633231
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gEWU7ZbajPrMW6tBHE9Xdq6b0mmc/B/CNcQ3tHcCtcRRvJYPTHtgu7+dOQJ2aRS4vZhwuLvapia3G5iydNxuaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB5837
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[sending again to vger.kernel.org, because previous was rejected]

On 1/27/20 12:04 PM, Allan W. Nielsen wrote:
>>> > How do you handle the 'headless chicken' scenario? User space tells
>>> > the port to start sending MRP_Test frames. It then dies. The hardware

Andrew, I am a bit confused here - maybe I missed an email-thread, I'm sorry then.

In previous emails you and others talked about hardware support to send packets (inside the switch). But somebody also talked about data-plane and control-plane (about STP in-kernel being a bad idea), and that data-plane is in-kernel, and control plane is a mrp-daemon (in user space).
And in my mind, the "hardware" you mention is a frame-injector and can be both real hardware and a driver in the kernel.

Do I see it right?

>>> > continues sending these messages, and the neighbours thinks everything
>>> > is O.K, but in reality the state machine is dead, and when the ring
>>> > breaks, the daemon is not there to fix it?
> I agree, we need to find a solution to this issue.
>

