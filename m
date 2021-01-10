Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3FE2F0914
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 19:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbhAJSjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 13:39:52 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43342 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726415AbhAJSjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 13:39:51 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AIVMaS028015;
        Sun, 10 Jan 2021 10:39:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=ORdQk4a8/aqE2WzIpbISdyLdtqNPHxRXnv/FT3vFLlY=;
 b=LUKrSbQzEb3jt7pMW+pUWXJkvEpoRV5YINQSqDdNRveo0OiMYHkw+qatV8xZr3Vl1Utn
 93ucKVCMYgPswHqozVS8kOvamfbsH8SRXqv6wlt/h4JC615wooYMK8NXFqSpwp+mxFih
 Ls0u17swoAlkAJETE7bz9pxKyE6eyC6VQKvHe+0otvX5EXtwEItKV6/smqFC0EkWWGrC
 OGVU2j1YUZOIIDFM9AvaLKYOJDfFHxmDYjG4avgGEFNFDUisYMv6+FP9v95W9T9F4pkY
 rKyhf48xM2BfRqk7EnEusWspSp5kH1jFLXa0pd33Ott2LUJKWTsPT/sq0iMDLJ73kGQW 5Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsjccv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 10:39:02 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 10:39:01 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 10:39:00 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 10 Jan 2021 10:39:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMoCZy0UVRWD9nYmcF1rP77Ue12mMma21/aHFRVAUVROvlCnfW0AMX+ftvJq3hHAsbo5W+AEgRkJXl4qVN/deJbjKuhjyQEDU/rXQDd25NvZpfVU4wAM0uFTCvPyStgQjUVnWRhB7UBGc1qCcLxEnZj+lriohG0CpbchGl7JeboetiWqPc49W9nsddpn1pXcFqsUeubmHRNOjEySpf/4mQdpJI2CpqMxdCwnrdGEOnT5YnvsqE/Dur2dmWexQuRvnAE/asvvhab7tMDzz0xA6uXRu9pefSknFj+FbAG4bkFxUd0nhhiZXTduhRcuhfYzmuOVE8e+hBZyWp/ZNX1ONw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORdQk4a8/aqE2WzIpbISdyLdtqNPHxRXnv/FT3vFLlY=;
 b=Y+H4UkisbDl3uoHPoOVLgrPY3CjlFsmhbUdmAO2he94tkWsQGt5rpultbw6s4uLQno44td47wUKIDkDDPVhtBfvIRBrbplpl4/LUvpHCf4yVvv+y41GVvuk3vRHZx2iUi1eup4bTugzqUW0gu/VA+Zipk1vtxDslOgXn64lEzndj1T6SjogqHn5jgUJd8EUM+F9GRQKc7GQzstVPZkR0Sj57nX5zGAePPdsUkfJwWsB/0JL2lvonRZn9PDZym59JD67GzlsDI58aszt7MNaL59KD6Yq3ttB32+U11oN1GHWdSiXGtzjuJYLsBn8HTxOLcGOy2+cxAhwc7qahjeuZGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORdQk4a8/aqE2WzIpbISdyLdtqNPHxRXnv/FT3vFLlY=;
 b=gC164VrjEP9DdPp6UsiUMnuMyQ40tx3jG2Kx0wl0O86dBhW6dZ5qq7sKbn8LP5DkdC43zXfxNwNLT9nrVf9hmbWchcAZKEGSDSJ63HSddPEqm3u6TgXcbYHzoqCwx0grk5wrW6RAp14ltjZNG6CaoqOo2MsUt0gfWljO9WrCI04=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB4099.namprd18.prod.outlook.com (2603:10b6:5:34d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Sun, 10 Jan
 2021 18:38:59 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3742.012; Sun, 10 Jan 2021
 18:38:59 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH RFC net-next  11/19] net: mvpp2: add flow
 control RXQ and BM pool config callbacks
Thread-Topic: [EXT] Re: [PATCH RFC net-next  11/19] net: mvpp2: add flow
 control RXQ and BM pool config callbacks
Thread-Index: AQHW52W3RQcyKW0u602QjxvG4m7J5aohJ+cAgAABELCAAAXhgIAAAHMA
Date:   Sun, 10 Jan 2021 18:38:59 +0000
Message-ID: <CO6PR18MB3873B6957F4CD2430C288C4EB0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-12-git-send-email-stefanc@marvell.com>
 <20210110180642.GH1551@shell.armlinux.org.uk>
 <CO6PR18MB387313CF1DB7B16D015043CCB0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210110183133.GM1551@shell.armlinux.org.uk>
In-Reply-To: <20210110183133.GM1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.29.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6df055c7-efe7-4c24-f91a-08d8b596fe8f
x-ms-traffictypediagnostic: CO6PR18MB4099:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB409949635DD93D28C74A81DDB0AC9@CO6PR18MB4099.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lvjczl1HAGsKtSXZJczjrelweGt2jz21qqshdRjahOxVb91/RK8X2rcOEH91nUdeUyoNbs7MeqMb+5J3ZkDOtH32EKQMVEDnmaJL84XwfAO1oi93jmrHQebYVHTHddk3SRGTfI2FkX+6VywLMkmfiYd1GnrjVBAVwyLA+bQFnAlnsl/xNnIjP4vLb0DVaJ7AVMN82LlnWuPLS+t+Fp2SGnTUjoI6lWn9lk7pkrTF0b66NZIYgUmNCsqLO592+5iHQxJz0haAevKOd36xco1P1u9dZnx7Thgx9+npz8ABRuaCvB32VtZw0/+92ezM/lPGhmgb5RnTlHiL5gZgTdDKqudzfz7UrZFrSo3CdqHmAAuGdAhtSEdreNP7ck6RzdPRifC/a6MZu4yT9BPCDeOncg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(71200400001)(83380400001)(64756008)(478600001)(5660300002)(6506007)(52536014)(55016002)(4744005)(76116006)(9686003)(8676002)(54906003)(4326008)(26005)(186003)(316002)(8936002)(86362001)(66446008)(66556008)(66476007)(2906002)(6916009)(66946007)(7696005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6LlnkmoOZJDQ3kVfCJPOalum1m6G/6WsMtd2mqprkuhTvdWho3lcloZRJsal?=
 =?us-ascii?Q?jK7HclnMCIfu0eHJYRxOf6LO1ENj40g3PWTixyvsSsCCeSELQPxk3a10kPdE?=
 =?us-ascii?Q?8D36hkQDJXrEw4Jc62ytuTHonFW8dcxcbtoaqeVr+2hzt8P2yLScm5YFTV4W?=
 =?us-ascii?Q?AmnxjO3ymH1L3sGOMY2hZ8121EixPJF8ZC5upS600eO2WPHQ5CI2JkEXvGiM?=
 =?us-ascii?Q?CJHjD92wICb40+c47tZkLWWBUX+Aj52tVyR6ACoBscd5h7O4/dct0EhO7Oo4?=
 =?us-ascii?Q?FVq3uQss5QEO5ES+RJSSZsyStjDSmPdDUOjIKU8Bwd51phWF5SLWUinbP5Pm?=
 =?us-ascii?Q?8j+rf4UFy5nxRBWMEDjM2Bbky/FYAqgNxzH+GtqHNVp+7FFu/1no7GL6uXob?=
 =?us-ascii?Q?Xa+JqjfZeflOH+Lid/MvCzXA717rOHPfc76qfgV29xfoacnedG58CnF1esxo?=
 =?us-ascii?Q?JV4X+JHY4jNuJn1ZphCW2PYZfNd0sryVl/8hJZb1XxbzEbjpYsPpJUtyXR34?=
 =?us-ascii?Q?ylfnXqWX4a/tgBNSZkcedQqrMLrtogMZoVrpb3qGiV/ucGJWJgw46XSLccI8?=
 =?us-ascii?Q?d+alEgQ4MBEr0LvwjVSiqcTDD4OlPmYAvneN3/8Qq1NuJy5hBmRrZtv51JF7?=
 =?us-ascii?Q?JgJv3tJ35ygeEZROxzycIfxOr7R8gM0Hl/Oe/67EHaAX5a3Y5PB2neR+TcF6?=
 =?us-ascii?Q?7OZ0IkT6//+Y10u9YajvIn5hW9zoBwGAkeniRLjrAjBHoQ2UFBrQifXasdSB?=
 =?us-ascii?Q?2zxwRHmjfNFLqJFRt/vmu5QOBdm3+FbH932Z1vHPEtvwxqLxV0mSd6klylVD?=
 =?us-ascii?Q?6bUaNA5/LgTALxmjDYCPAB+85OWs0pJaSxWDGlWbWxq+wbqOWRO16Ktdi5HX?=
 =?us-ascii?Q?PR9vVBqmWwTG6r9GYGjB3pl2CXw9+tBvmF0ZOKXgG0hQh9LOJELOoihSrLLR?=
 =?us-ascii?Q?rrN9Wrl6iC/4jc79ydSPxdsecVi028q4VqmVwF4nMfM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6df055c7-efe7-4c24-f91a-08d8b596fe8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2021 18:38:59.2011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ny10MnzKVIoM7g/Fr2TAAcZvNXKGB1Se4TlHUEZ9m3VOOdPTbPZw9NSVIp2pn/lTlIxgmLL7X2XhE/0uriWwCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB4099
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Sorry, but that is not really a decision the driver can make. It is part =
of a kernel
> that _does_ support CPU hotplug, and the online CPUs can be changed today=
.
>=20
> It is likely that every distro out there builds the kernel with CPU hotpl=
ug
> enabled.
>=20
> If changing the online CPUs causes the driver to misbehave, that is a(not=
her)
> bug with the driver.

This function doesn't really need to know num_active_cpus, only host ID use=
d by
used by shared RX interrupt in single queue mode.
Host ID is just register address space used to access PPv2 register space.
So I can remove this use of  num_active_cpus.

Stefan,
Regards.
