Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C9561637B
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 14:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiKBNM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 09:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiKBNMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 09:12:37 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70118.outbound.protection.outlook.com [40.107.7.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBEB2A707;
        Wed,  2 Nov 2022 06:12:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fs99JQf0MK4cEU77sj+1cBP07Rf3J3vKruUL3+lxNr64age4uI7uoRMT/LUlCepHNpxRZdbEXK+ktXt/L9kbuHgf63s4Lyyl/GsxM639HfI/GQ9H31JDbDSM3FyBqQI3kJZ4+Hac3aO3zwXn5VitexUN/ICZr834zlja2cW5YOetYZA7D5RxFPjuPE9AJ/By4jnMLO5S8FTJae8211lPl4vcFWjU6bBaM/E3JXdjkzdkoGlBBuzbBXqLztj1PUsRcIZNOdek6O8uh8SNdfFRDAbWG+iOY4shj58yhHk+d7jwir2FRXLEwn/TJsx249DbjSaOogl0MLcg1+wKB4jBqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGuyGeveLuINKGABQSsQj4A9XmxK7iF+jxbSiFi8qFs=;
 b=MNiq/3gmNZElAOs5xHCefuWTypvG8WgCAGvWZLZ3++oqiqGtTbLe4rj5XwzEY81yb72XATQvzwyWoiYdktxEkFphgG0tAL7FsLP/NJZabYGQr0U9UFKAAfZTtAW6+fyptxC2Kq38k2b4VKtGbiI4weMQpoF1m6R9cyaxzxSgG2sEoi39uMR/lMyO8NMdRzxXd49Hp4Znf9HJFv60QkUKGWdVcg7hDUmIEOwn7zvwPgTShjHnfAE/+2FhlklXvX6/H5b/u7xtIMwHgJfUsZ6BUwRCedQit8aRW4EufyKJsocTw+5YKxlh51PLaVYKXmS/LAetwRn12DoLrb464IneHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 217.111.95.7) smtp.rcpttodomain=gmail.com smtp.mailfrom=arri.de; dmarc=none
 action=none header.from=arri.de; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrigroup.onmicrosoft.com; s=selector1-arrigroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGuyGeveLuINKGABQSsQj4A9XmxK7iF+jxbSiFi8qFs=;
 b=ZQAFv4/bvzy/IFo2uTfZkslGn9a4VhixbSA/hykhIyHG0DPiplyWNBwewIR3CIzNb2ZsdVHjW6JcGA5urwG4kiA1oSY/CTzPtU2DpoRXY5u9YummrQvkNuOWq1hrrPoJBhVDwJuaXwyHeC0ybqiEnDjnkp/BPYAG/smUIOVtnZc=
Received: from FR0P281CA0125.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:97::20)
 by PA4PR07MB7198.eurprd07.prod.outlook.com (2603:10a6:102:d7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Wed, 2 Nov
 2022 13:12:32 +0000
Received: from VE1EUR02FT063.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:d10:97:cafe::ff) by FR0P281CA0125.outlook.office365.com
 (2603:10a6:d10:97::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20 via Frontend
 Transport; Wed, 2 Nov 2022 13:12:32 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 217.111.95.7)
 smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arri.de;
Received-SPF: Fail (protection.outlook.com: domain of arri.de does not
 designate 217.111.95.7 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.111.95.7; helo=mta.arri.de;
Received: from mta.arri.de (217.111.95.7) by
 VE1EUR02FT063.mail.protection.outlook.com (10.152.13.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Wed, 2 Nov 2022 13:12:32 +0000
Received: from n95hx1g2.localnet (192.168.54.23) by mta.arri.de (10.10.18.5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.32; Wed, 2 Nov
 2022 14:12:31 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     <olteanv@gmail.com>, <Arun.Ramadoss@microchip.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>, <b.hutchman@gmail.com>
Subject: Re: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support for LAN937x switch
Date:   Wed, 2 Nov 2022 14:12:25 +0100
Message-ID: <21674031.EfDdHjke4D@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <cd9bed118823c23bb0080f904fab9371e4eb9a25.camel@microchip.com>
References: <d8459511785de2f6d503341ce5f87c6e6064d7b5.camel@microchip.com> <20221026214455.3n5f7eqp3duuie22@skbuf> <cd9bed118823c23bb0080f904fab9371e4eb9a25.camel@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.23]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1EUR02FT063:EE_|PA4PR07MB7198:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d7b0fd2-eea9-46f6-cea8-08dabcd3e6d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zc1cblWb3G95+k31MGd664I7hcDa2dpeVaeRbLyhCCbkTlUDClVousos51EUwbpPoDuvJdvK1uZsYbZ8eyWI3F4RX94VjjV4kvR85lnGLjJO8KjZX+A3ErYL1frpY8Mlff5aP0ybZJ7DIhKXHCh6fqVRZgetH+rnxaP/6jmHDeCoTShbFhyUotd6zf2xrA7pA4A0xMQiyN/3QO64uDwtgeXuy8Sb79zCPp6+VyRPyoJcNLC45ds+HgmKEhm0twd6D8SEnKpXWTbdhZDmIV+Q3O4jHMvpSti7ZQrGpgdTTNSZAKK0D5QrC05u85ec7ORSXOetj7us0Kewpt68rt4mmsCvxbMLYet/IvmKPWDdzw8qiw+bXNbUesmTPiwnCPw56/dvkZZQya6KOmUfl1IsKvLRavX00qaNPlclPM1WX6T50PYDRp/kUMuuIy/Q1122XXMuL1w88XWv9yB30ljkcAdNzn1g212lByz161LGcK8EkukYZSUJ/yr3JY361LYXTTYBJVU6dRBiODyVyIoC1Unh4q/EDlXAYcU3XWuC5lHjyQMkY5dgodjGDnLNxfWEaia5P7O1CX2kKpBnuYrgmRxrhGm0KNsVwZ77rRpHz9RF8wHI45TlQ1X83JESBpZ97Jdl8xFQp9SxlBT8/xxwPl8Skc3Cb830vcWUOKCvvGjS4TOflI27yre8p4WNtFTLjbpHmDVpU0N87AQ3tqPIVKoSWM2tiwrLiF6M+X/eDb3ok2szkC55cYjA/6jUjauxnHRKLUSCZ1wIhLUCceiZYIaohGxdsX1g/h0wUlg/G3U=
X-Forefront-Antispam-Report: CIP:217.111.95.7;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(136003)(396003)(346002)(376002)(451199015)(36840700001)(46966006)(86362001)(36860700001)(9576002)(8936002)(2906002)(16526019)(186003)(83380400001)(9686003)(82740400003)(336012)(356005)(47076005)(426003)(81166007)(110136005)(54906003)(41300700001)(70206006)(70586007)(6666004)(107886003)(4326008)(8676002)(450100002)(316002)(40480700001)(33716001)(82310400005)(5660300002)(478600001)(36916002)(26005)(39026012)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 13:12:32.2876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d7b0fd2-eea9-46f6-cea8-08dabcd3e6d9
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.7];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR02FT063.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR07MB7198
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

On Thursday, 27 October 2022, 17:51:54 CEST, Arun.Ramadoss@microchip.com wrote:
> I tried to bring up the KSZ9563 setup following are my observation
> - With this patch series, I am getting the Null pointer exception.
> - After applying the patch provided by you, switch probe is successful.
> 
> Usually I test the gPTP using the following command
> # ptp4l -f ~/ptp4l/gPTP.cfg -i lan1
> 
> How did you test this PTP in your setup, so that I can also get the
> same result as below.

as the KSZ9563 supports no 2-step time stamping, I use 1-step with E2E.
The problem with E2E is, that the "master/slave" filter
on the KSZ9563 filters out some message types.  In order to circumvent
this, I use the KSZ as slave_only for the first tests.  Later I would like
to use P2P, but this requires additional implementation in the driver. 

> > > Maybe this could be mentioned somewhere (e.g. extra line in file
> > > header of
> > > ksz_ptp.c). 
> 
> Sure, I will add it in the File Header in the next version.
thanks.

> 
> I thought 1PPS and periodic output are same, So I sent the 1PPS patch.
> I need to look into periodic output.
I fell the same when I first started with PTP... But maybe you can use
same code for periodic output from my original patches.

regards,
Christian




