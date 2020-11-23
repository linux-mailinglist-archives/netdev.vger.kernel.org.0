Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255E52BFEF5
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 05:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgKWEUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 23:20:41 -0500
Received: from outbound-ip23b.ess.barracuda.com ([209.222.82.220]:55596 "EHLO
        outbound-ip23b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbgKWEUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 23:20:40 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100]) by mx1.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 23 Nov 2020 04:20:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GwCeO/3oCdMPe5ci4yHlW6TGkczcshmQsprR5syVJj8iIXHTPp1x4NWGGuC01BQLzHSTAUhKprxrpTblQM06if8mHNvlu0B+ejavGW6erhBo1W/ZhOyIlMJHE7YbbaseGIU1n5n7gbi/VuPwuXlUNGHNtzjsUt08aPeVv/oQtGIGvhZBwyWCFXSQkkGIZcgbkMtH9VHuXwkL07VcuhsUDTWkvP38UzNWyRdIv33BhQ6WCrQBPZSI3edvFRXX6deuhE5hWbiun4KB1TsLsNLvFSr/xfFDq6dD++Sgi2gOX+5kPUeHDXOW3uXtdH0gYNPDfr+vEW+j2VjqkK3pp+abwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1O13UnkwiRKvjvt+ocD78BDXKZVYOZ7GM+XmeaNydY=;
 b=HXl3ZNguq/EmEoJNci/9lC0N5q2fgJlgJJAUdRBPIeA8jaFEKSbdg3n73rCsdJqHOWb2NyLBdJriG2W7DzQMoB5l2ji7K6Nhd/K87ik5EZIdoGw+sSR8lpqcYAwW9V21BFu4Imq+ztbeedx/HyAtyqB89dM6wgZAME7Q/oXjg7AWxFFQCLghIxsX5PjucvFQckxixCyObPcVDs45cDaT55biOPbM4ADNBiTVGINtOYyMPx1e0JaQJqpHpHbpQ2m2YD0KceLtd7K3XXKsqeqvsqwq6ywzWMNldooTp7RTCzYrgW2cLgJFtnEVrwJzvXmf8sQzY+s554b70ci8PiG9BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1O13UnkwiRKvjvt+ocD78BDXKZVYOZ7GM+XmeaNydY=;
 b=unv7TwVCFePol1kwBHkrwF/iPvYKIMtqGSgiz8LGEDDinAOOtRjNgTXIrtGQrsaP3UasGTloxl7mAatK8RAsbv63n0lpHDq5NUw9djgk4U8ZwYA3d6eh8wsYOM35NovXoL1lWnpg9nYC4CLUocbfzc76rzN1fMu9BrAXM1nkL3E=
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 (2603:10b6:910:44::24) by CY4PR1001MB2088.namprd10.prod.outlook.com
 (2603:10b6:910:40::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Mon, 23 Nov
 2020 04:20:31 +0000
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197]) by CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197%6]) with mapi id 15.20.3564.038; Mon, 23 Nov 2020
 04:20:31 +0000
From:   "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Dmitry Bogdanov [C]" <dbogdanov@marvell.com>
Subject: Re: [EXT] [PATCH] aquantia: Remove the build_skb path
Thread-Topic: [EXT] [PATCH] aquantia: Remove the build_skb path
Thread-Index: AQHWvr+D9OUe7+XJI0yBaR2s4ZL4BanQptMAgAQJ92U=
Date:   Mon, 23 Nov 2020 04:20:31 +0000
Message-ID: <CY4PR1001MB23115129ED895150C388E12CE8FD0@CY4PR1001MB2311.namprd10.prod.outlook.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
 <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>,<12fbca7a-86c9-ab97-d052-2a5cb0a4f145@marvell.com>
In-Reply-To: <12fbca7a-86c9-ab97-d052-2a5cb0a4f145@marvell.com>
Accept-Language: en-AU, en-US
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=digi.com;
x-originating-ip: [158.140.192.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 661864ca-673c-4532-0a51-08d88f671dae
x-ms-traffictypediagnostic: CY4PR1001MB2088:
x-microsoft-antispam-prvs: <CY4PR1001MB20887EB2BFA5BD6A92E23581E8FC0@CY4PR1001MB2088.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uiefg+0m70oev/AZaN4fpQ1loIHKoyEI3PlupWon+wkBH5AYJsCujVILJs8Kv/QAqruJmbbJQLnqUvPcN7BVQxTebz2n0ScvNkH4ZJXvy3QxIhrn4XWEzHE8dWohGzsoUC8sDRYoaFL/LEpCTgpEpJvP+tUwDXShlsksO6Duy+EVku3r7QJu1b6ObxtNHSBVWCalhomhjyJCn2DyBIq+M9DnzHPeAPOn+tDNmBCwvSdcpVBnzlQHJWfuMz7DjXD7cV4MDgYbBYr7qglF/Qxijhib5nT1+cvjlcS4yWHN9SmcWR/VWqOmHEsmH4TDMoh7RqJxCrC9A6j0s0kJmDaSKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2311.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(136003)(366004)(376002)(346002)(396003)(76116006)(316002)(64756008)(4744005)(66476007)(66556008)(66946007)(5660300002)(91956017)(52536014)(478600001)(26005)(8676002)(8936002)(86362001)(83380400001)(2906002)(55016002)(9686003)(186003)(66446008)(110136005)(7696005)(6506007)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: FxEOkZEWPLwxsYRjHkKXM9x9/Yb8gbvqTCFALKhtJODuRLzX/LUXv6FNLtHtuanBok8RBx9QhHOcGkrXS2M4sKHtdmVcAZcdB7TotlpaAStg2jimLELqwNFHVUR1SdvpY2shkUr5aeXcwsCjAwn0Dkf5mmaQ3jueUBvGxb34CdFfPamSxfEbN9/rshnbofb1WdGei4z46Ru1q6pMUBOOGGVVTD+NmZYy4sAoQZaNWTWq/Rrnq8tzyaYYJuXD7GZDz0G5mEP/8HLnsSdTNW+j4ImNlckO1ulcy5Kg5ujGhOo6SSgdl/v9Ja/HtUue9ybuEdGWfxZ0vjU58JeQwNhitdCDaRpA1RN27z8YhE4kFJaA72GnSswPJl6JvcafEZWdc5de4gvVdVd81HqApeeD/p95Bm1NT+to61NhZdXMixSMuDqg+r7eQ4/ZDwoz5eC+AnKZ/B36DC835wYSao0OL9dG9XGGSbXz7N2mcBaVaQIL/e1jsFVrCvcsCYfXLPOtrXszKZZ24bbZFyXImdL4wBx0sdBTcdQ/AlSWR7Nzh/xyMdrw2Kx01dfKOFAqWS7roU7IB0jJ5PXD01X/rP7foBCAHY+15/BxS0rPfNVCH5b42yJsJRN1XVybLodH2xCD8CeJakd8nX+bvy+AVt/OZWZqkZzxL/iJAz5HeeDz+ehS6NeH/MZ+VgaFCw7Qe3I+RokmsFZ7iNqdL5wFeivLhx1QczlSCHB/6IHq59ah57282+Gw1K4k472U5bZ1FlWtQg+vqIoRNoCNE+unRj2qvctn7fA6Y0qUNmI9FW721JTPmj6HBTVtMIePL0jLlYtmfhFFZfbYa4lut6hQDzr47k0Oqg4wnHWRv18gldNaEUYvP4gKBJXzJNeEqAk4S6UuWGJjJDY/fSaYLPkvlz9FFA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2311.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 661864ca-673c-4532-0a51-08d88f671dae
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 04:20:31.3844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7EmJn+QbiZvtqlrY+7cvnv/fNQyi7aAoXUbtXJ52OcwR8UeUfQtECrBeW51X7hPRCSYfdJXC37/LZJ6+gIj9Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2088
X-BESS-ID: 1606105233-893001-21862-157939-1
X-BESS-VER: 2019.3_20201120.2333
X-BESS-Apparent-Source-IP: 104.47.58.100
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228379 [from 
        cloudscan22-139.us-east-2b.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yep, that could be the only way to fix this for now.=0A=
> Have you tried to estimate any performance drops from this?=0A=
=0A=
Unfortunately, I am not in a very good position to do this. The 10G interfa=
ces on our device don't actually have enough raw PCI bandwidth available to=
 hit 10G transfer rates.=0A=
=0A=
I did use iperf3 and saw bursts over 2Gbit/sec (with average closer to 1.3G=
bit/sec on a good run). There was no significant difference between running=
 with and without the patch. I am told that this is about as good as can be=
 expected.=0A=
=0A=
Make of that what you will :)=0A=
=0A=
Lincoln=0A=
