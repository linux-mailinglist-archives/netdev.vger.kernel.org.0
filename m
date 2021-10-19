Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B60432D93
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 07:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhJSGBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 02:01:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21020 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229755AbhJSGBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 02:01:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19J0liiJ032025;
        Mon, 18 Oct 2021 22:59:29 -0700
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bsfk49x3f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 22:59:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyWYJCXj4sAhmf1fXA3X8f1jvezUw3gVpxnEcF4DDEWeCH7PhySnsHzgIM2P6WFeXYUc5pvwN9uCZr50v3kG0/puOCzuCbWbE+UG3/n5fXoKP4FCByET78PUZhmxoMFuSFFOlPZO0QsW9zHfIMtwMxi3MVyRY9cHZdmoHuNbUEALcHBFSBq8YsH6PscnjpR8Lv0x71AAvOit00k6oWsaEfcN0tA0mPiD+4yrAgSZqXRKttdAu2MTk4WdevHjL94YnFXROJeZOIa/1qn3VymHy3LzA5oTOc2iVX9klWIo2JiY1sFBWclhoPZMAgU/TxgiI4o1cm9fg5MaR8Ef3Arj7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ksZCY2bkik1iCtdZr2l+i0yDPlIa3f79eA55Wks0gm8=;
 b=cEJBYsvLfs5vFpW0IXh26eSm14w80mdsmLY1MRHn2OaiiZKWoJB8k9aKcg1MzVv+dTaoAi7LTmRc9yJqRYDpbXnXbkjvevJPpqIdC68LHKjuWlnoM6WEHpy+quNCL5rCFasPTrCyIG9YGQAkEO8ZRZRkoB+oZsDnEYOF4aJn8kXiS9e6/fWoCrWENMdC9fvTF0SmK+5pR4j2jn1Ixsd4TY80waXlX0z7KqPc09ywY12eJm1Lmk8Ro0XfkJ2PfMBOqHuPGH9oCcKX+hDjHC2LV6fE2hJieB+Pb+S2u2xF1TOxvYibw0psa2Qf0EBPCfMTP6YtvVh2XgxPqLIAAOy46g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ksZCY2bkik1iCtdZr2l+i0yDPlIa3f79eA55Wks0gm8=;
 b=NSoQh9vKFmr1mo1gSARReswvzH+j3+WlH2iYDBKUvNSXf5qLQk/K6dZEVZFs1kjlDwiUdZMF4SVI8QqOE+dSeDqyP4SmqNshcTaxTrK7aEeIxixprjywk63kGcDi1Zxkg8plezCOER7oRZbhWJt05Tvf2PdfIyRlqbRV+LCg9iw=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by SJ0PR18MB3916.namprd18.prod.outlook.com (2603:10b6:a03:2c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 05:59:26 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502%9]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 05:59:26 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: marvell: prestera: add firmware v4.0
 support
Thread-Topic: [PATCH net-next] net: marvell: prestera: add firmware v4.0
 support
Thread-Index: AQHXxK54YSpVVTNlUU+p0CbrszeP8A==
Date:   Tue, 19 Oct 2021 05:59:26 +0000
Message-ID: <SJ0PR18MB4009B03A1F0BFA37D82A242CB2BD9@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1634309793-23816-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <20211015141951.07852e95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211015141951.07852e95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 1fa29e82-afd9-2f15-b810-9ae5f3492d53
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8fed3f7e-68b8-46c6-10f3-08d992c59b5a
x-ms-traffictypediagnostic: SJ0PR18MB3916:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB391642D293174430824A7752B2BD9@SJ0PR18MB3916.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2YCz80NnrrOSn7pUhuBlcyiP7jwSPG79C2sdTk7SjdExy6nQb5/LZ1tO4QPQd8cAAeiEPm7TfZhcTj2m20ctXzIt7u6cMcREkJOmPtNrcUMUP22CVDYKgdIlsUPdInrudZVrEvZ/sRQgi1pmbeejGsF/gMWUQl0fU5AXlcN1wICmlTP0ARxmbu6vW/HB0cPGuQ0BwOTNTbanootDbgPXoLs/BcSWM9Ct+15n+KI+VprLfR5ZjgakZNg9MTTrSmJEoGRsyy24YbGbhIuwrJHX8+BO44/+T+mMlZPZ0/k9/yN+5GntOJ2aci4p0ErhYub8m97cDPPSk6kPTd3Rq3RicA5fZjUADbre0Nzs/dV8EyiHQtWQJklRcVKj1h8fy7vdkYRbrjek0AVElzx40X0bKTnUNXbH2DgO3jVK9+pvBSHSs5h5TTAGmIrMVxNCoJ2mvHKeWzhxwXGkY/8M3DoFYKjXb8i3s6OznxrLY8jpwSCoK6ahe1H6Zk/BMlqlLF2PXtgzzclceks0iL33PtVjtyp6N8eSrb0pLK5KkMMPnvFlX9/lRnQ6xQsTl9EXCoQ7ZZfVJtbpZvZafMDPcv2TWga7i1hQMzlEDNpyLdMhwuGY5hp0ixSkkQBeJYztTIJ++K+BPF4gF+Tq5JpFTvPEbMjliQnAWnbnE2g26fcSQyFHk0bJq9BSfH4JBMxxViqm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(38070700005)(8936002)(316002)(6506007)(6916009)(54906003)(508600001)(55016002)(66476007)(186003)(66556008)(64756008)(2906002)(8676002)(4744005)(5660300002)(4326008)(7696005)(66446008)(52536014)(9686003)(71200400001)(86362001)(76116006)(66946007)(122000001)(38100700002)(33656002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?8J3pAwKimZg7NZ0w0rtIzSlRb+rZs1vnW6iKHsqzCnOYTwkJBtEs7+n3?=
 =?Windows-1252?Q?0QOtlk6Pg7d2tci4yGgtrClucAZkSBvoQReEBbTgR3MbaNOE6yTkJLFV?=
 =?Windows-1252?Q?S+cc1LRmDZCcRzebFM0eO7EQOZkX85+YxMRp1dP/ua3GPGbCoft0GCC8?=
 =?Windows-1252?Q?DXpn6jyWlZB1mCdHOA/uUJuOLfqNAbvxZn66yDXtSSAiEGrSwrj81o7I?=
 =?Windows-1252?Q?LEzP/6j49n8rQ/SSzCQTY81VZzCKbBizYYb4uKkDOTzp2LSNl8yDMPOV?=
 =?Windows-1252?Q?Mad7hbCUaMkwJwO0S9NDao+bJmPLzE9aRTrXH8ArWA8IjqvpfFKMbN2N?=
 =?Windows-1252?Q?03tIWdQKhUjfXfk/2vXkDlEFZ6WAt+IkcyTCKsUTl6SW1q/DUAzGOtkL?=
 =?Windows-1252?Q?+fzvdPVZiyG4rjVuQW1bGGUxX0CJ4QlNdrfrX94lxK/nPwOCy1mGnrKF?=
 =?Windows-1252?Q?kBqjUHGqWDRuwh46EtwDYjEIpPINl5TRfYTaPKm1RwOzZI18UTdtIsa8?=
 =?Windows-1252?Q?unYFHpa0PFuHbCfONjgPnqWQp+9wDyd7oMI3nAU0yGNTXhl7CnEObtjN?=
 =?Windows-1252?Q?8dpavbj1t/sYJCA7Am92VeKArQjcetKSCWZ5Qc5T+mZe7N78NW7spA0B?=
 =?Windows-1252?Q?INk75Icf1Eps5F2/0TdQp36kmwjr6GgHjpmP1aEhfuIZesIE755w/sHD?=
 =?Windows-1252?Q?hJKUxQR8XbRECDVPxZbqgJxk9czEPaiDSGI2Al8tmNznV4SEyoMr08G7?=
 =?Windows-1252?Q?QBT4Mr+aMwyeUtlTiug5NLfcLxFWf+Ccx0Cm+8w1m4njrYz0e/tsQIAT?=
 =?Windows-1252?Q?2l8H94rtmr58ef0jwpoPfn6igCPK2ttjQCkZq+cSu71jpGUlBGXi9tKZ?=
 =?Windows-1252?Q?miRcOyf0HWI85yHVLVL2tGHE3d9LwjgWmH4wVw2zuAfliY3HyFWeDcPc?=
 =?Windows-1252?Q?tJjrGM87B0aDErfX2ZJ69ab2nOr5O0XuBr/oTEF9fYXQQp6FrshUD25F?=
 =?Windows-1252?Q?YDkzzLbChnn2kbbQeUpmRmDWR80OEseMdU50G8zKvH7xSsPSB/CbXpYn?=
 =?Windows-1252?Q?4SVG3qFHvflKAo7Ld2/SCSwt3RYWaR6PLnD7HiHHxg2wcb+dnf9gQurD?=
 =?Windows-1252?Q?9c0iCpN/ezIZQELWD/PPJ/yfurjiputfziABx/1BNvF7Il4ppJtJp/rM?=
 =?Windows-1252?Q?cNKbI+0GzMAXfs9DeL2pi/MLz6TVRET8ANjx46HiFdYc9XOc8ivHxzBz?=
 =?Windows-1252?Q?YotbWBJwJMwWE3QR0daHNKMS6LaNR08i61+XqHMSi2FvygcCjoo0q/N/?=
 =?Windows-1252?Q?t8JWzR4vgBmmPdqVmWU6n8fHC4mu4m8xxOIidNC8ZrnZGUr2ZksAxtgw?=
 =?Windows-1252?Q?rVCqr53btEjkyrlQFItt3l5dboCQcZq80Vk=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fed3f7e-68b8-46c6-10f3-08d992c59b5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2021 05:59:26.1243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o97TskrDG4lzYrYEY1Z8onINoXotq0oHsFAEevyX5TSBZn8ARqTY5/1bcMF6r6YEFCGtn7lTP26fN1a0nN8o8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB3916
X-Proofpoint-ORIG-GUID: 3x-Ql2uMb9JHtBvSPZKBZb_AQFacEDiY
X-Proofpoint-GUID: 3x-Ql2uMb9JHtBvSPZKBZb_AQFacEDiY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_07,2021-10-18_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,=0A=
=0A=
Thanks for pointing this. Fixed in v2 patch set.=0A=
=0A=
Regards,=0A=
Volodymyr=0A=
=0A=
> On Fri, 15 Oct 2021 17:56:32 +0300 Volodymyr Mytnyk wrote:=0A=
> > From: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> > =0A=
> > Add firmware (FW) version 4.0 support for Marvell Prestera=0A=
> > driver. This FW ABI will be compatible with future Prestera=0A=
> > driver versions and features.=0A=
> > =0A=
> > The previous FW support is dropped due to significant changes=0A=
> > in FW ABI, thus this version of Prestera driver will not be=0A=
> > compatible with previous FW versions.=0A=
> =0A=
> drivers/net/ethernet/marvell/prestera/prestera_hw.c:786:5: warning: no pr=
evious prototype for =91prestera_hw_port_state_set=92 [-Wmissing-prototypes=
]=0A=
> =A0 786 | int prestera_hw_port_state_set(const struct prestera_port *port=
,=0A=
> =A0=A0=A0=A0=A0 |=A0=
