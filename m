Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9D2165CE5
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 12:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgBTLmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 06:42:11 -0500
Received: from mail-am6eur05on2069.outbound.protection.outlook.com ([40.107.22.69]:6032
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726882AbgBTLmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 06:42:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGNtFHznnJtqPtTrUrglt0MxCQzVkPo34ZWppVBpEfbmhVoFsP1hfmVaMqBR54kCGh6sjl/2n95KKn7uAmo1WTLp+xbimdqXz9REaVp90WcLpZq2F1EHjsg+Pd4XMftvzYp8aF1pdTvcA49S98d5dXZ5dAzAnBzC4EFmRU9dkgsgUqm+lpO+osqUl0dcJHF3uDixisVyF0tJdjU8b2s/lqtQ69OyW+ri7EMf3sJZnd4lkjX3Z4cDmvokVYrZNiFr0Ks2/BH7mAtEC9dgx/3GpA22NCCLMzTaGB+yBeuRV/9DyNszaJC5jCgVdrzEzvd0SRVDdlr3Ai9i0wFlKIeQow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xiIQNKhPZ6IZNXk4qBL7qRV16gEu4IM2T+ih6EV4XPM=;
 b=PScgZUnthKsrpT26b3qL/5mtzj3wbr3qEEk0n9AvOClHWKbxtqZ2S8Opy8rjLDiTu3Tv/uC8ntL6AVtOTO9Fdwhp6BpC0UiQAHIwaiVSL1HRLDZOoo+GI1Atv25gxyZXMQhGcMEYVRqtG7WiS8TEfaP/MZhOADVPi1li3T6sOBvwcWykLyZD/SOom49FGZ+2RkFTDErQYUEngQP3V55UPedrJvd80Taz2BzJrcEZtrPTiyKbikM5lY8Dm+HqJkHZKX6OL69HjexcQBF2MiaLdauaAQ9BXzIHPvtcPchYLajxT3qsTX8qAODK1yj7X5T3z10gFM1HbEzKGCh3lzoW8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xiIQNKhPZ6IZNXk4qBL7qRV16gEu4IM2T+ih6EV4XPM=;
 b=KXzAA60hlBdjlFK6o8LmZ2Tubz0Mb3WE3O9xVWlJ2Lzyw1lbA0EPLIPYCpC8i47M3Ln2f8z1mt8yqDCujsCLnqL3sATuCG5sHO6kPmat2MUWwl9FdSJ4wT2hx4Z2RIjmk+BU9EBOML5yrul1272m7KBXcojquJRYCTP9a74yN0s=
Received: from AM6PR04MB4774.eurprd04.prod.outlook.com (20.177.33.85) by
 AM6PR04MB5400.eurprd04.prod.outlook.com (20.178.95.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Thu, 20 Feb 2020 11:42:07 +0000
Received: from AM6PR04MB4774.eurprd04.prod.outlook.com
 ([fe80::48e8:9bdb:166d:1402]) by AM6PR04MB4774.eurprd04.prod.outlook.com
 ([fe80::48e8:9bdb:166d:1402%5]) with mapi id 15.20.2729.033; Thu, 20 Feb 2020
 11:42:07 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "Daniel Walker (danielwa)" <danielwa@cisco.com>
CC:     "HEMANT RAMDASI (hramdasi)" <hramdasi@cisco.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sathish Jarugumalli -X (sjarugum - ARICENT TECHNOLOGIES MAURIITIUS
        LIMITED at Cisco)" <sjarugum@cisco.com>
Subject: RE: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Topic: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Index: AQHVmWkzb/KVHeRA/ECvEdv93vqv/qeHvtCAgAACaQCAAAFWgIAAB7IAgAFH0xCAABZzAIAAGbCggJo36YCAARaNoA==
Date:   Thu, 20 Feb 2020 11:42:07 +0000
Message-ID: <AM6PR04MB4774558014A5CF408B66FD0196130@AM6PR04MB4774.eurprd04.prod.outlook.com>
References: <1573570511-32651-1-git-send-email-claudiu.manoil@nxp.com>
 <20191112164707.GQ18744@zorba>
 <E84DB6A8-AB7F-428C-8A90-46A7A982D4BF@cisco.com>
 <VI1PR04MB4880787A714A9E49A436AD2496770@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <873EB68B-47CB-44D6-80BD-48DD3F65683B@cisco.com>
 <VI1PR04MB4880A48175A5FE0F08AB7B2196760@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <79AEA72F-38A7-447C-812E-4CA31BFC4B55@cisco.com>
 <VI1PR04MB48805B8F4AE80B3E72D14E7B96760@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <20200219185747.GK24043@zorba>
In-Reply-To: <20200219185747.GK24043@zorba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a98c6d02-da22-4c91-d92e-08d7b5f9ea38
x-ms-traffictypediagnostic: AM6PR04MB5400:
x-microsoft-antispam-prvs: <AM6PR04MB540018EB4D6640EE81834C9496130@AM6PR04MB5400.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(189003)(199004)(71200400001)(9686003)(55016002)(6916009)(186003)(26005)(6506007)(4326008)(33656002)(7696005)(2906002)(8676002)(81166006)(81156014)(8936002)(86362001)(478600001)(52536014)(54906003)(66556008)(66476007)(76116006)(44832011)(66446008)(64756008)(5660300002)(66946007)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB5400;H:AM6PR04MB4774.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4KXitMtavLyjIBsILNA/TSnpONfeIiTn0pHLfMzlCvaL2YizNUQI0NgqtGrHrGHg9rSiEM1pUn+nFMawQ2ia13jFZRXLLuz7vixIPrsclWc8s7OkL+xrxMAcmfmhPjNeljJe9PMCT0Tv0t14BP6gCoo+WoKI5OFRHO73jhNOYrSlHD2SmmVl2cxnfUHYwKRkl3QPtKr2BIL6ojBjVEyI0z+kYXySDZNtj3GZxnjS8j/aD4IrN/jDyf2qPMGJyhrUSU+kyaqx94nr0JA3r2BKMMZT2hF84IjwkaaHnkh+y8JUNKbrnuRgzPaJUkv/zgFK+EgbdGW1suSoOXDQvh1UFw9t6ZsUVCMDpbfewUpmo7tKzOAGKpE+i2MgnOcNIpyaIvw7FsxCqGEjmklL8rDRBJnWlbQZp3bR6adIvq7fAyAwNfSqvm051+zXdLF1ZIwc
x-ms-exchange-antispam-messagedata: Z3ghxQl2+bro2HCr0huFl/Vl4cAI0baA+6Anfn8FyY4KBi5WlsoRGQg3K2tLAp0iO01GOVeO4rsc3hJ6F4Z1a/TnkUAm2vJV5Bz1cnzqmMv9U7gm7OYL21PsTZv1v4gw4o1QXpQXW5zdSMSGX2eAsA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a98c6d02-da22-4c91-d92e-08d7b5f9ea38
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 11:42:07.5541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jvjVOhSXoBRtO2226oXUy7fIQEtO2/4ZRsckJOA3vwW+it8/tsC9W42fyaPL1mCnAgJKPY8HJpUSdNeve+JO9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5400
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Daniel Walker (danielwa) <danielwa@cisco.com>
>Sent: Wednesday, February 19, 2020 8:58 PM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>
>Cc: HEMANT RAMDASI (hramdasi) <hramdasi@cisco.com>; David S . Miller
><davem@davemloft.net>; netdev@vger.kernel.org; Sathish Jarugumalli -X
>(sjarugum - ARICENT TECHNOLOGIES MAURIITIUS LIMITED at Cisco)
><sjarugum@cisco.com>
>Subject: Re: [PATCH net] gianfar: Don't force RGMII mode after reset, use
>defaults
>
>On Wed, Nov 13, 2019 at 04:01:39PM +0000, Claudiu Manoil wrote:
>> >-----Original Message-----
>> >From: HEMANT RAMDASI (hramdasi) <hramdasi@cisco.com>
>> [..]
>> >
>> >>> This bit must be set when in half-duplex mode (MACCFG2[Full_Duplex]
>is cleared).
>> >>
>> >> Should the bit be clear when in full duplex or it does not matter?
>> >>
>> >
>> >> From my tests, in full duplex mode small frames won't get padded if
>> >> this bit is disabled, and will be counted as undersize frames and
>> >> dropped. So this bit needs to be set in full duplex mode to get packe=
ts
>smaller than 64B past the MAC (w/o software padding).
>> >
>> >This is little strange as we do not see this problem on all pkt type,
>> >icmp passes well and we observed issue with tftp ack.
>>
>> I tested on a 1Gbit (full duplex) link, and ARP and small ICMP ipv4
>> packets were not passing with the PAD_CRC bit disabled.
>
>
>Have you looked into this patch any further ?
>

Hi,
I have an idea on how to parameterize the interface mode setting.
Let me try a patch and if it passes on my boards I'll send it as v2.
