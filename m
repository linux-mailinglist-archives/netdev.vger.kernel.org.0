Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059C12D4739
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 17:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732118AbgLIQxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 11:53:55 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3726 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730807AbgLIQxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 11:53:55 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B9GkO9u001716;
        Wed, 9 Dec 2020 08:53:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=1Qs6jmtWvJOyUXv8bOiiyNdprMDKCRZ7q266HV/Mft8=;
 b=DwOVguec2DXU/rMfAHgEU7TAVxW7GLXvhm0N8sEw9fuyWZPDFWXBNrj2PhkMLKcHepTN
 Q823tAN6KWld34G4dyh9NDpL3T+cv5q2bW+K8U1fcwRUTUdm4kqr5OD1HWdEZ5V9CRpf
 X/gZQ03vn75uxCSzEWnDi9II0pvhxKLsbIo5Lj3iztdS8b4p1ney3V3hqpd5f76uZet2
 5sVFnOAMMVPzYe7OXN8nlXcOTwc+J5+cfKEPPOzXJMCvp3q1gd1aAT48qTSfcZ3Ma/lH
 uzL07cvMC/PEMrL0tBcXUNa4NIwaiwyLQIW/pRXRZ34Qf2NdcrmqXUayNANh9RgzrTCC BA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3588etcmf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 08:53:10 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Dec
 2020 08:53:09 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Dec
 2020 08:53:09 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 9 Dec 2020 08:53:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhC873ytVum/Jwg9X3m5grPNNQTeUykL1uBZ52wbO0VWgs7Jh/xMOuIkGkwdy/DurDjjtlm2nrJ81FmgseF2c1lXLn74JAqazF7C4cJKJgQ8ZBl6B5YSc3vtt7FPEjt9iZgdD+jQ26ksAsxGuF4+hk0uiz66yz2DnboNusHJJrayaTmYvOEzpvfBaoRzeBzsXC7YHvw9ApXfNg8f7nkEOkuDx5ah0zSst7pT864jR5sofYo6LQWbCsS5y9L+KDDREMlA46wU0qsvOeNwRFxjiJrbBiqEj1rJ9rB5XDrPETr31OFCS6BTCnjvBhsV9WfLKUjFY4Mt8wdIS0g3a9V3OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Qs6jmtWvJOyUXv8bOiiyNdprMDKCRZ7q266HV/Mft8=;
 b=GIfbzbYtcpYbYa0ytq6vTQoeIRlnM5QyKw31RJGoqUadQpAqmHapQ/f38fAD9M+XPT2hLt1pze+SneGklpTfq8tSAv1TOT9mZmNzIZD+xf+mnduLsYdKkMRd2W+70obdNXvthwyOXHF2UM5kOt+4W/9FvbgZufa7J/MO9nhXSCy6a9w2+MGz9ml+oScxvyXspejHQ6jRE7v0ySDDJKXXem8gHEM/iaNow0UpkJ3Otc4oXrlVKL4YxLoh7T0S0cL09ikpOzcwOCzNlMacTrECYeaVk4/ohfvahDKnY9WKi3hFCa+d6bYpOjAveL07oe+8zGwq0yYtNHFVKh2GI/3Q/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Qs6jmtWvJOyUXv8bOiiyNdprMDKCRZ7q266HV/Mft8=;
 b=D6gt1xuJczW72socoqncLC/bJzjenAG48ciWTZu47iQOQbNYf1XG0fZqVHHGhLPV7fx7dBkGj9/af4iSrHyBxm3Fey2pkR9HTDHf+bBH1XwirTqvZc5S2wOJ0iZHeThr4bRcrWWeJ4mKQSDnn+7n/piWnvWq8zCPeoxlMVjIjwQ=
Received: from DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25)
 by DM5PR18MB1564.namprd18.prod.outlook.com (2603:10b6:3:14b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Wed, 9 Dec
 2020 16:53:08 +0000
Received: from DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::c4e7:19ce:d712:bd91]) by DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::c4e7:19ce:d712:bd91%5]) with mapi id 15.20.3654.012; Wed, 9 Dec 2020
 16:53:08 +0000
From:   Geethasowjanya Akula <gakula@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sunil Kovvuri Goutham" <sgoutham@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [EXT] Re: [PATCH v2] octeontx2-pf: Add RSS multi group support
Thread-Topic: [EXT] Re: [PATCH v2] octeontx2-pf: Add RSS multi group support
Thread-Index: AQHWzLOHe2bt26aup0yK7Ag+C7GeYantunwAgAFDOLg=
Date:   Wed, 9 Dec 2020 16:53:08 +0000
Message-ID: <DM6PR18MB2602BAD0AE2BAA007EDC1345CDCC0@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <20201207161018.25127-1-gakula@marvell.com>,<20201208133444.62618a42@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208133444.62618a42@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.248.210.142]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d62c665-f53c-4027-80c4-08d89c62e7b1
x-ms-traffictypediagnostic: DM5PR18MB1564:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB156459F3A8E01716514C6A4CCDCC0@DM5PR18MB1564.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fEPPfoXpgHLKgL85vRKQ716Vv5cnxd93x8HexGhly7wKfNH7LXqMSjsJzdjnbN8ie7owtagxCUOH6AYpSUuSoLgbLR2nu0mSbxX7qjO9H1BgjlIIh0hLda4eDQhzTJo1HLyRC4ndHQKwBuyZpn7yTexjMzPjTJBJi4wvpB0GEFfQAdrYU9vxjDIP7gqbe9XfTVjRhinfdDRF25xb275izE7c32gYYxGsJ1iGGJ1srIyOpI9/iGOzuftzqtKzuPMxXhnJQxnOBurew/pPpPowxqP/oFT7txMhLRFgGkQTOg4H9Qu007EK+MeptwCNe1erIROXgwnhAc18HHIZyWP/1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2602.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(66476007)(7696005)(55016002)(54906003)(5660300002)(71200400001)(86362001)(76116006)(66946007)(66446008)(33656002)(6916009)(9686003)(508600001)(91956017)(107886003)(8676002)(186003)(64756008)(53546011)(83380400001)(26005)(4326008)(8936002)(2906002)(66556008)(52536014)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cuGF2puvQwkPl2L6B9EvQ1UhJv2SLtwBuG7NaqASKlx/lULH96iqAew42MIi?=
 =?us-ascii?Q?rC66oe6jlPRxZ121xO+Mm8RaloDSgMsk/V8SToN7yDb3LUPp9Gyox4Sz0B07?=
 =?us-ascii?Q?6xJG2hm2yZvwwDRi4Qqwgn5QqyYUIx6YR3QPXtCqOfmZWpAPxr2gxXH37CBM?=
 =?us-ascii?Q?t3JKEsn39nCXdiFttRFEvgPg5qfJMUq8Uve0b6jvmHl/m2q5cpqi+Qm6CCZI?=
 =?us-ascii?Q?V+gZuTejsqrFpFdNVXc84WPLT5l7mK2RwtayXXHarGEInvg4QngqcVeO5s+l?=
 =?us-ascii?Q?fyHyW39U306E619P4ARB0k7TSd8+teqhemxTs7dJz+C8lb3xBb5iHLjR3YaC?=
 =?us-ascii?Q?o4AHIKN8FcX+72BZn/VuW4R8fFX0aqm3QXitHoW73cOD9iIvggc+cXojwzsp?=
 =?us-ascii?Q?tcxfxWXjpqBSPEP2kb1NTWjIboZCZlsyq8kOyHcYCIGgNoKQIpaDdXKImqwi?=
 =?us-ascii?Q?fSdrbSeYXLVsgcnuDvSjjvFD0Q1lrT58gwFLON6Qv/1Voq7vE3DtPgd5kxHi?=
 =?us-ascii?Q?f/U9GiacqlaGordaoMqFEkJPZy+dx4Q4mxHwKHqPD6SnuFxcgs5t2/59ff3L?=
 =?us-ascii?Q?w0jtAJ2v1fXxGpU952Jkc66fyJKuF6DpftvX3cGThEp3FqfDJ1VPSp2dCjCn?=
 =?us-ascii?Q?7OBUw9NF09xtfe5nnMdselvvJC+cRXqiugBwMLjgAZ7qNQKsPnLwxQ6yUQOH?=
 =?us-ascii?Q?UbVoSx+EZ8ACSTkLU8MKaLSckzHi/WZwfSKvwdifaUqvmcXLYOXFRMzq2MZA?=
 =?us-ascii?Q?NLLs7VQm35U1Y/3bYgNcj1hEpTvJE9F2JLiQJ5018zUeyPJjFPJNm9G+Wpk5?=
 =?us-ascii?Q?DAzZCTNiIRC48ULLvjGZBULk172/s7ZFRer1lDj3MqfnewXTDwlsTMlWN6nK?=
 =?us-ascii?Q?mF+u6ZY9SYCfGd9eINrRFIPlNFYspDFnUUiLGALFbajRvcYLuHgkPgWW63cF?=
 =?us-ascii?Q?QJY1DaAIoz5WmVGvgPh+GO8/JnH+vRl/kYrtnaJoo0Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB2602.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d62c665-f53c-4027-80c4-08d89c62e7b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 16:53:08.0383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dr3TwJIAOkXxqDy4+DV7NEsGwmZm/nKe69oOfe7eqsxpBoCaagy8tZlK4fgoRMswTQduKas0SxftIpogc8Vuhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1564
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_14:2020-12-09,2020-12-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, Jakub. Will address your comments in next version.


________________________________________
From: Jakub Kicinski <kuba@kernel.org>
Sent: Wednesday, December 9, 2020 3:04 AM
To: Geethasowjanya Akula
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sunil Kovvuri Gou=
tham; davem@davemloft.net; Subbaraya Sundeep Bhatta
Subject: [EXT] Re: [PATCH v2] octeontx2-pf: Add RSS multi group support

External Email

----------------------------------------------------------------------
On Mon, 7 Dec 2020 21:40:18 +0530 Geetha sowjanya wrote:
> Hardware supports 8 RSS groups per interface. Currently we are using
> only group '0'. This patch allows user to create new RSS groups/contexts
> and use the same as destination for flow steering rules.
>
> usage:
> To steer the traffic to RQ 2,3
>
> ethtool -X eth0 weight 0 0 1 1 context new
> (It will print the allocated context id number)
> New RSS context is 1
>
> ethtool -N eth0 flow-type tcp4 dst-port 80 context 1 loc 1
>
> To delete the context
> ethtool -X eth0 context 1 delete
>
> When an RSS context is removed, the active classification
> rules using this context are also removed.
>
> Change-log:
> v2
> - Removed unrelated whitespace
> - Coverted otx2_get_rxfh() to use new function.

Thanks, I gave otx2_get_rxfh() as an example, please also convert
otx2_set_rxfh().
