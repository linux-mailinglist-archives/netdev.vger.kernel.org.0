Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF432F0922
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 19:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbhAJS4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 13:56:05 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27814 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726263AbhAJS4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 13:56:04 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AIpgdi027697;
        Sun, 10 Jan 2021 10:55:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=dojg1NsTZm6PohAbrYeMm+W6x+DWGxzX5cJ0iE/2ySY=;
 b=ZNrOrswpJKRQM+MMDLfGkVB0Fdwo9FZiA7h8tR1yuZYLl6xjMddUa8pUY/pBgoOGDpR4
 /q9gzSHA0KuG5Mv+D2RbujTGyRHfRcG1kIw6y4DlChCpC3UW3d/zZ63kc5+S4iyMswaI
 ycjRMXDIqATm6wxNW+zL8fmGzQp9mqzHRKQBQT7QJAejdUTAFJ1L05Q7Q3EbYvjD03R0
 QaYgRNfUDfDAc98jw09fKbDPHNRimeN1aiLmb/2xH1aVSpgLEJhtBN3Hp6rK6dr6LuEq
 aP23+O3c/KmcCBl9eGZPvvMyPHgcbLM95i/+ITZK8nhk93Exb188HefJDUv/0wQC87Ci bQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsjcvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 10:55:14 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 10:55:13 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 10:55:12 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 10 Jan 2021 10:55:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBq1tavc/MhXQDp55pagvoPjtbDLZthxtUMbjOXIGPkwGCVHyvPkfpjKv31B0KXVNSEIEi3a4usMHyDGvhFVirs8V2jwlL2mrA883011cTReP1LHOSGOnnkFkfIVAYvgmAMN+PGZnHRH7Mh5MueaXc45I18DnKh+BFyGo/UmxGoM+HeLHTYl2TgD+E1SMz/vnxIh7XsImGPDgjvnPmmUXE5Y334GTlrVpr87k1jf5lbtSGKJGJQTM5z6D5+SExHCOsvAB198ZSVUhDlFMCxWotHAJDUEHCF52A6Rr48nNij0TCjC8CQmGGQeiLqoKeyyexnf1YqtnUMDCWExxz8qUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dojg1NsTZm6PohAbrYeMm+W6x+DWGxzX5cJ0iE/2ySY=;
 b=QSvCvIacekjcu/pTA0v7C2kYkXl29YTb2BAhT6MAMRjOYVPyX5ZCbZ8lrbGEVu029p8d4+igdM1dYi+VW18g95ypPX9TNwkx24Vi7GPkdVfWwrn6hdOocXuwPnlNW1FjuD2HxXNzBCn2I5pq03AnLqh7Y2fqfIUpd4mrZoMDLfEPJp94b85HBQx9HyzLmSjR7K44rTWs/o5M6eMY6nseER8ZTYtcD3+J2Gjnk2888HXJKXPz7VmdK9IRiv30ctPTQS87svfuVWQhKRdtYOt3NsYIUFX6B031YjaxsNIO1xWWcoiIUnBJYBbfaJ5+ZK2RF315FRaWBIUGhA2fS3FH2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dojg1NsTZm6PohAbrYeMm+W6x+DWGxzX5cJ0iE/2ySY=;
 b=SGhqcnjWE5FDrRs3LZOZ3VFaZN2ZfR6MBle11rqvJkai83XjtqLrMiNw5Y4EwhVxQAlMk6tSdtMUJGYXI5ZMwq16/gEn+FO0WlmJGQlizIExmO2Z2Pl9DBbSUpnICzVhJ1qoSflpOGZL43Zo0YV81aGz4PG6hXiRKLIiIgYPZX0=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3843.namprd18.prod.outlook.com (2603:10b6:5:34b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Sun, 10 Jan
 2021 18:55:12 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3742.012; Sun, 10 Jan 2021
 18:55:11 +0000
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
Subject: RE: [EXT] Re: [PATCH RFC net-next  00/19] net: mvpp2: Add TX Flow
 Control support
Thread-Topic: [EXT] Re: [PATCH RFC net-next  00/19] net: mvpp2: Add TX Flow
 Control support
Thread-Index: AQHW52WJ6b6KlH/9dUq7cLwyM+o1P6ohKuiAgAAJQ+A=
Date:   Sun, 10 Jan 2021 18:55:11 +0000
Message-ID: <CO6PR18MB38737A567187B2BBAFACFF6AB0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <20210110181727.GK1551@shell.armlinux.org.uk>
In-Reply-To: <20210110181727.GK1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.29.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cec2910c-b98f-47c7-7505-08d8b599424d
x-ms-traffictypediagnostic: CO6PR18MB3843:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB38430950E085AC30AC165010B0AC9@CO6PR18MB3843.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RPOz+0QsVxp8JvqRjK7vHOHMXsAtp0BwqFQyuIZ329YW/5evAtd1viExqMSgfhLTdENn9RWr0/TG35f1TjZ6MFErNhtRZzbuFI3b5LIqkXYqpjEgwL9MAsynYJLiBWHre3Wa1bLnMaaCPlfYybHMvQOiu3IB5KYsAyQJ7aLy8khssmSOgV2OY8nvfZwT7pLwtCexNb0vpV7mUfgxZrluhwazzLienByyq3s5UYrPTDN+2mXyVlz/W67zHKt0mGtAHRuPNVe6AxM38XuLjX2kv88P4q5Sb9oS/GGR1QHZYR/m1TeL0jAjAfyNwET+SGX1O8hzR3GZnrD5M8ZR0jo1RIuzreIdzjsILTIszm0xOHJxNxhNPkJs9efujKS8XNvhpkaB6aT7G6QgCSpg6E7klw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(4326008)(64756008)(6916009)(66946007)(8676002)(66476007)(478600001)(5660300002)(52536014)(316002)(6506007)(9686003)(71200400001)(66556008)(66446008)(55016002)(7696005)(86362001)(54906003)(26005)(8936002)(4744005)(33656002)(2906002)(186003)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?er4fxkskwfjuRI076aoPCmeT3Pso+gfDV5BhvU+zFmKSg6eRMIxMFJ/JXPEF?=
 =?us-ascii?Q?gpog2Kw9EHBWSahP55o5qU3LxLHiLAf620w53x6RKJBxDxWdnkdbrki+4Aft?=
 =?us-ascii?Q?2rNIpgaBgv+/Z+LjlJHsHZlI2h4DrtP5p4yWmTnKiT04eSsWtRN5KOrpTgjt?=
 =?us-ascii?Q?A+uidEgn1faNiHbhqjIzUAY6Za9q2UQv/f3g5UkSn80/4UiJ6c0Yr8Q3ganE?=
 =?us-ascii?Q?ZTVtUBok5HEWjQNUnlD9iVZN9qHE2Z2afvUR04NlQ75su/BDFqK/awLt5Z05?=
 =?us-ascii?Q?CzNEL+MDTF4Rrs5Las5JBAkY5hAEY/pElOlG/213oRddYRLodU8hXdsLI9mK?=
 =?us-ascii?Q?y4zcxbdD9GxCUbtNXt+Cfrcf8DZ3DWVN30M3W0GJH4D+fHGz4vQnQmuLekTf?=
 =?us-ascii?Q?YSXUSi6cMqTGlLKu+guawNsPaQNE1H8aN036dMLUepWeFy93dny+y23DUhXz?=
 =?us-ascii?Q?UlXcwITe1QaWNoblP3DvFu9CtzIUyoyCiYOIALUAS3a+aMsNSN38fq5F1A67?=
 =?us-ascii?Q?8Ogh7UqEQTyE6BG2Zw3VPuqiDqb36fjePhmu1+rLebI/99PgQa6wjOmzUO4d?=
 =?us-ascii?Q?WK+SJrAUsy2TTin7UQs41cqQlsu08JQsk2GaGJ8dihSCpIYeLdOS9EPHKZr0?=
 =?us-ascii?Q?eAOXuDxfg22ayTtTfWweEEEuDLl+/SXvZoZv5X/ZvK1pKDCsUWEgQafeOaHj?=
 =?us-ascii?Q?eTCrz0NDCfgLH34Gr0tmDfkfvxifcfnahNhf9ttp/eG3wdfm7TJl3IvgRcOb?=
 =?us-ascii?Q?NDH0geKzHbS5gXJDqNKBlHR6zukirM2XhOy+fSJyy/jDbZgYoO/k92NPUG6e?=
 =?us-ascii?Q?R/HSgU3WqExERdd8v/k62CmXkpkdArMvYRMmKkP+pq5roqdlbS+3lOED/dnY?=
 =?us-ascii?Q?TsrfONSU1O4whrl5S5kyKRltr8LNabJ+45Q8NDmvwgKwbtIrdaiYujpifPMW?=
 =?us-ascii?Q?2+knQCuM8dPFNMyDuSFy4iGYhnVEQb3ugvWqHun7svk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cec2910c-b98f-47c7-7505-08d8b599424d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2021 18:55:11.8696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0odGDjZGwRh2tT+0fXkvHg//e+tUTOe5Twr4cLxJGg5z5+26X2BiPlDV46OJz8Q5a0BDNR1NLCale2laPn9r7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3843
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > not connected to the GOP flow control generation mechanism.
> > To solve this issue Armada has firmware running on CM3 CPU dedectated
> > for Flow Control support. Firmware monitors Packet Processor resources
> > and asserts XON/XOFF by writing to Ports Control 0 Register.
>=20
> What is the minimum firmware version that supports this?
>=20

Support were added to firmware about two years ago.=20
All releases from 18.09 should has it.

Stefan,
Regards.
