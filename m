Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDCE4B11D5
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243689AbiBJPiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:38:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238346AbiBJPiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:38:51 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70048.outbound.protection.outlook.com [40.107.7.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BE59C
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:38:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PwL7qQR77cpMiPT1oW+v0snID+p+T6ia4/YVSaHmNdLvLGwiuSTJTZtEnUvbxCw9t9IoNz8QYy+K5Bf6XHdv1SS/pZDpDxlGVB5Yj/752mG6qltYqXr1wHg8KgiDO62c8gii/VE0mqOSCFLdDS+19LwTtul4z26H/H6PqfUU2pqwmDE5F3bdz8LyZlrU/9zRtecyqjf3Fu3HdfxJD1A+YlvxDsBT1KO7Xw5pnmxqw8qrH4BSI5Wjjkqj+X1B3hujvMzM78/8O2nqPmEeSFm8b0JOkfttu2hxVbvwROcpCM7En4fCNbkVBwefBNL3B/k08lNVcoLpmGYOvAFSgEMX5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TUU2RFTz3q2TsTK5e1TPrUxCzmSxgoYs6ABCEd7J+14=;
 b=V8X+RFSZ9Uu2DMWp7u2mgHoYUE4mmh8pv2HrfgZrJBy2GiE+E2U6kKoNYc0m7H1chzQYVbyxCFhAq/ksD2bteV/hNlH/d29FQtpcC5kxdWCBuW6btAm7tth/AVCFhTw7O2oK11rNojtXxI+Cjlcr16mx9R8FUZak5eRaNOFkeBur5uBd1mDwKPTrY3Mr7KbuguUhXaz7wCdAcl9l5XOH1x7OklYmjfL146f3bIOpBepOFqLk5iCMRb4sQYYVlOJbJXGuHxR/xTnJyjk+Lk3pSfulW7FvOOYdx16Hwjdi9YZKIAZUf7FJATWeVSkeyrH7mSUa2VosLrgoGQrwLNj+cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.72) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUU2RFTz3q2TsTK5e1TPrUxCzmSxgoYs6ABCEd7J+14=;
 b=FSqjCb0b3tkgFY4XYjpxKKM6/RI4Sp5s9/IPG5zjg7pvFjwftGwrcfzgUt0przKwZNobGxZBoed/wkhNiGXlQfkv+WTX0NXgpWk/4/xEzLxLYlqvzTn4h9GwUA3w1p0KrvDaSfkVPJeUVISIH3tlUylv3Kie5wyNpGRqkCm2p0HZmtrn6R1a2dF8wsoXwwB/IX4yXlXxHV/ja0ZtE65FU32qDUfyoYzx75XxB25y8u0qTYFGorlKenNA2Cm5POOvsQ3nvbSsh4rpngVU+P6BxMKUD6nMtUTbH6uvKsDqjgl5Klu7U7N7JMIGNSSr1jm6bNsvoQjnjuKZYHuAQ3dc0g==
Received: from OL1P279CA0069.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:15::20)
 by AM0PR10MB2708.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:12a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 15:38:49 +0000
Received: from HE1EUR01FT014.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:e10:15:cafe::d5) by OL1P279CA0069.outlook.office365.com
 (2603:10a6:e10:15::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Thu, 10 Feb 2022 15:38:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.72)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.72 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.72; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.72) by
 HE1EUR01FT014.mail.protection.outlook.com (10.152.0.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 15:38:49 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SMA.ad011.siemens.net (194.138.21.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Thu, 10 Feb 2022 16:38:48 +0100
Received: from [167.87.32.18] (167.87.32.18) by DEMCHDC8A0A.ad011.siemens.net
 (139.25.226.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Thu, 10 Feb
 2022 16:38:48 +0100
Message-ID: <1c9240af-dbf4-0c11-ab25-bec5af132c24@siemens.com>
Date:   Thu, 10 Feb 2022 16:38:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] net: wwan: iosm: Enable M.2 7360 WWAN card
 support
Content-Language: en-US
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>, <ryazanov.s.a@gmail.com>,
        <loic.poulain@linaro.org>, <krishna.c.sudi@intel.com>,
        <linuxwwan@intel.com>, <flokli@flokli.de>
References: <20220210153445.724534-1-m.chetan.kumar@linux.intel.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
In-Reply-To: <20220210153445.724534-1-m.chetan.kumar@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.87.32.18]
X-ClientProxiedBy: DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2e9d492-5a2b-4073-4903-08d9ecab6ef2
X-MS-TrafficTypeDiagnostic: AM0PR10MB2708:EE_
X-Microsoft-Antispam-PRVS: <AM0PR10MB2708A05FDC2B5B11929CBD00952F9@AM0PR10MB2708.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: apFIaxjM2cUrH9zzOoTQakIEVw7pANS475GvkmnWGKMM8yeQZm2DUfU38k7JkIlA8raodLuw3fuZ5ouiMnhOKauRLbevWgN4LJQ1GwknApq1BP79Mis4SBrr7SXXI98Ws4vd1VVqHTxJ//ngxUCZmTN3bZv9PfZEA0mI+GPEJGxs31thtt4Ovc0HxIS5zKXXXsW7+zSH2ojOx1VhiZifVZ0Tq+2CNu+RAe/QCYKg7HVPTnO8ITKasV6JdD9MtfQ1GyoYDECpMFx9HwV3MMyWHRVCaEW7BrrK4Cxm5GSQkx02zSYNG8IbQ6nNDuXN/tf0Ueul+pNMSJWgnTrdsJLUVfrekqFFM5CalWSXRbb7DZcNUlko02mMgPH3WZUaPV5UmJ9YZQKu4jIB3jAhzcrNGIpm8pb/de3y+Q0RmkMTyDF87iQx4+fh+HWkeuqP5821nLoiuFto7tcK+IE21xISnSQKja7A7YnZ436uSD3Tg55voZtp1DuD/lmdsEJsKm5RIvQ8AGjHlmaqs1my1nTbbt9iYQziTByvG+Q4Jy7ElYCsF1ox5bj/+GeVBscQ4uDyf3hrh7/s+h9v7bOG/58fJ8a9uvdZQSg7p9A9snRr9dAX/0EVltL2yU96/ziJzDvk6ZelOfzwRZTOFC/NK/K7V3gaXSZeSL3BxvrfMeuWjgUjuhQCYPQTVURFdUM+XC2qb8hUxAVjOSLPcC/F7IOCseMwyCxsTitZJAlsbdNAWGB17jrmeBHmF6UV+VVAbHANgii6qV/qyW6PUw4g8D1b/Q==
X-Forefront-Antispam-Report: CIP:194.138.21.72;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(70206006)(16576012)(36756003)(5660300002)(6706004)(8676002)(54906003)(508600001)(8936002)(2906002)(31686004)(110136005)(316002)(7416002)(70586007)(53546011)(4326008)(44832011)(26005)(82960400001)(86362001)(356005)(47076005)(83380400001)(36860700001)(16526019)(336012)(2616005)(956004)(31696002)(186003)(81166007)(40460700003)(82310400004)(3940600001)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 15:38:49.3789
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2e9d492-5a2b-4073-4903-08d9ecab6ef2
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.72];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT014.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2708
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.02.22 16:34, M Chetan Kumar wrote:
> This patch enables Intel M.2 7360 WWAN card support on
> IOSM Driver.
> 
> Control path implementation is a reuse whereas data path
> implementation it uses a different protocol called as MUX
> Aggregation. The major portion of this patch covers the MUX
> Aggregation protocol implementation used for IP traffic
> communication.
> 
> For M.2 7360 WWAN card, driver exposes 2 wwan AT ports for
> control communication.  The user space application or the
> modem manager to use wwan AT port for data path establishment.
> 
> During probe, driver reads the mux protocol device capability
> register to know the mux protocol version supported by device.
> Base on which the right mux protocol is initialized for data
> path communication.
> 
> An overview of an Aggregation Protocol
> 1>  An IP packet is encapsulated with 16 octet padding header
>     to form a Datagram & the start offset of the Datagram is
>     indexed into Datagram Header (DH).
> 2>  Multiple such Datagrams are composed & the start offset of
>     each DH is indexed into Datagram Table Header (DTH).
> 3>  The Datagram Table (DT) is IP session specific & table_length
>     item in DTH holds the number of composed datagram pertaining
>     to that particular IP session.
> 4>  And finally the offset of first DTH is indexed into DBH (Datagram
>     Block Header).
> 
> So in TX/RX flow Datagram Block (Datagram Block Header + Payload)is
> exchanged between driver & device.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Hey, cool! I'll be happy to try that out soon. Any special userland
changes required, or will it "just work" with sufficiently recent
ModemManager or whatever?

Thanks,
Jan

-- 
Siemens AG, Technology
Competence Center Embedded Linux
