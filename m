Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21B435DBF3
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhDMJ43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:56:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17988 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229687AbhDMJ40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:56:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13D9tewP022369;
        Tue, 13 Apr 2021 02:55:57 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0a-0016f401.pphosted.com with ESMTP id 37w6vugeyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 02:55:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/JrgBScUsr9gHVuPnE+pp1xFU/UDVT7lXvR/mz2Dpaz3sm1rH156vqNhl9yBYghq8WHJDvZDS8ETQiPpQLQ3DNwMBuNOEnAiKhylVnw/Af+KWisWuLlCLYIQETmjryHcPRUAJQfT66Q+h1zeajFZD5cMp54B3Bt1p9KsRxtO7NjCjaf7FtPVlFg4jubpeNLq21XRuiCaNlRnp9uVSqjnkj1f3gXSvVaha4eC1EW6mna9o9MFqJqy/OQzYU1S3glvAzQDHYXxaUMeWQDyV+eeURtwkhoht8OpEjhzJKXyNPSh4XlR2GgTZKUdpR/b/AAeAg0Hta1KWGzLYv65Qvx/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOVUQdLSQWGZ+j1AOxsv8SlKfrjQ+w7GS7WE3hoWLkc=;
 b=btnaeuZJx6XbTf8BCB7Bjo7hFayPnnnmvY2a8rtYPtscZW+bNp+0VFQQeqDCvsuqyUxeKXr8oYL3u04sWLmomt6+cg2yXr1uHhKSpssp1wUVy2QbdMVjLN0BRLVXszDJVUt/QduYLNlIzhAQckqBOruPAnY/DQBah9bQvtMdE/+hqrNUL67wk1z433wa5+MSj9TZr+6rhMIvXhfle9hBt8F4C4cqbYBZqvGfIOAQhjExwA1MO8CVWmX4JrXNJ0X16fC53lNB/9zcmDFSOj5Gfccc81ICwC6S6k4VF0bJ1pAt15QdMKRlBnDzepX9wjnjnk/suOgRPVUAsEyRPo7d4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOVUQdLSQWGZ+j1AOxsv8SlKfrjQ+w7GS7WE3hoWLkc=;
 b=dTBRH1WW3Y1nLKxYr2YcdEEwo9i40Okv7tWSgSMcXms/GTNCLMWdxL5+Lwi4vsNoEjqL9qavY3LgSs7B8m5rEV3luiegKdbF1DLxmGhUh/P+vSeNKrzo4uyOnosrNlPmowu/fngWkegrrV3jaPzDJq19EkBBTWc7fG0XG4EouOU=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1566.namprd18.prod.outlook.com (2603:10b6:300:cb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Tue, 13 Apr
 2021 09:55:54 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ddee:3de3:f688:ee3e]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ddee:3de3:f688:ee3e%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 09:55:54 +0000
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
        "atenart@kernel.org" <atenart@kernel.org>,
        Liron Himi <lironh@marvell.com>, Dana Vardi <danat@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next] net: mvpp2: Add parsing support for
 different IPv4 IHL values
Thread-Topic: [EXT] Re: [PATCH net-next] net: mvpp2: Add parsing support for
 different IPv4 IHL values
Thread-Index: AQHXMEFo10wdEFvjykKGBHXbluX/IaqyKzMAgAADlZCAAAZBcA==
Date:   Tue, 13 Apr 2021 09:55:54 +0000
Message-ID: <CO6PR18MB3873B0B27E086CA02E09B08DB04F9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1618303531-16050-1-git-send-email-stefanc@marvell.com>
 <20210413091741.GL1463@shell.armlinux.org.uk>
 <CO6PR18MB38732288887550115ACCCF75B04F9@CO6PR18MB3873.namprd18.prod.outlook.com>
In-Reply-To: <CO6PR18MB38732288887550115ACCCF75B04F9@CO6PR18MB3873.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a11e4e7c-1ffa-4e73-2a6f-08d8fe625443
x-ms-traffictypediagnostic: MWHPR18MB1566:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB15669699AFA8B2786E725DFAB04F9@MWHPR18MB1566.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bqa/EFwDnUrAUHgkiZqcZUJpzn7wYaapLjs3iNYod+Lgv05pOGPl9Zp2lwuVXdyGbR6p3NZhkX3EkEYZhW7vwzU8QYo/CMHT5aWqSVQHiFRx4kCsGdyvCJkW6P6ZvbfkzcQvNPO097z3g+PrdF+350uwCNQTO1uWH15qkhXUEoX6r2ATHvH3y9V5jhfFp/53K4+nvaLXjoMEqVnnsXEP6ISwbgY36TeizXc7pFQkilpcw1pTzrXXINlZca5Zmp+u42f0xpOadOTLzyUhDQR0hE0uDlGj0i+na+Tqn0MiZcJZKb9GmzQifCc1VuaORYMFt5mwM2zEOUQm6Dj/TCBKw6aGn95JaCL6nQT4RvrAmSHFer8aP5PM+1ePmm7I85Nbg0iPgdrpM4ZHCrGv29YeHBS7dkAJ282kaBtkv4P7Ax3K59hCXQVSMzbp5Ntg7rcvmUIhH+bPP32VPwlnZYRmdsi1KxChrjh0YwkBZ8qjUI/VSraBqs7ehYcRLKaVqu3/xpr3upo7ipJ9CrlpBax3nEHxSQ/PZWIOrzug+DMySeFHEmAFR6hLLuocqIwo2Y7BWFaY49CveKktaQMxwJ8sxprsWAFlzjj77DDMGTob9K0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39850400004)(376002)(136003)(4326008)(186003)(2906002)(8936002)(83380400001)(122000001)(66946007)(6916009)(52536014)(6506007)(53546011)(66476007)(66446008)(64756008)(33656002)(107886003)(71200400001)(478600001)(66556008)(5660300002)(86362001)(2940100002)(316002)(76116006)(54906003)(7696005)(8676002)(26005)(38100700002)(55016002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Bhiq3pNpfnnQ8mH4A6WtscOv2E55XHzUt3evk2CXBtC1/tO+D33eUeWtDwdt?=
 =?us-ascii?Q?XrdgKi5AJvG1o4NZZ/ylRK2XfSqcq+6RCIeTL2dsDgPvnr8hbcIKjNCgahze?=
 =?us-ascii?Q?09JgVK8rJqKNA+YV2sPKhPKPKumN3vq7tlIUuH9yWQVTz2l8vsBchaLRX9KA?=
 =?us-ascii?Q?jQU+Z9qJBpndZUHY0fARemumADE+0Ze6hjQ7ObALGeApjPW9X8Z1u2zn2L6n?=
 =?us-ascii?Q?YumsCyCKJGom92TVbMs5KkRLHNMcb/xKaK8oC0OZ9a2w//XhgwJsf09J3hwu?=
 =?us-ascii?Q?6CMUjBzJB+1smpW8lUW5d6R3vA0YpzJ/vj3+sg7blvFc4Rxa3P6oyM722RLK?=
 =?us-ascii?Q?MFcczEdiKM9w/fx6Zii6wRLl8tUwttocuoHWS/FanDITc3WWQcci9eirhai9?=
 =?us-ascii?Q?ySlp8rv6fHH+B/Q1TuVukIMyGlDqyxpRCWDO0GiJfMVfFkiQdUo+4GByD1eQ?=
 =?us-ascii?Q?nlwBct8rPJosMbz6bQJUH8lJ6Vf1nqgG9Fao5fwDvfYQPdWbOg9c1bnxvQLR?=
 =?us-ascii?Q?5k5phVAbvjzUdqtVR2EG20GQLYoSxKfRf8RpcuruNO0Yv13MsxUYcPYHyj25?=
 =?us-ascii?Q?KpTdOq82i0vISlzoFX1PnHuDrHwKDnWyByM7ChP/k7dNaqmv+s5QsYagGRtY?=
 =?us-ascii?Q?vXxG7S1CsgYJ+471DRiQXwSvq8ZvS/Qvq+1ua4n52g0UvTnKlZmmtBwZtTXo?=
 =?us-ascii?Q?TYhe1p9K1XqYIDQvQs/WDMZDmUL8jxMwBmjr4wsSQdltMs/FZMp9+QGFwNvW?=
 =?us-ascii?Q?4iMzFLU8wcw/QGu0HH3j+pKKBifdML+HC6/weDf2qwy6ktLUdvPHSHqeBwmN?=
 =?us-ascii?Q?hWwt+CREN/NFbZVZyYeLfx3RAfBxCfvUMmzxC5JF9OFaaWBhWynyM2pyX3zr?=
 =?us-ascii?Q?sYp/fxnLyB8ElxD+e81P3kt5AttFT6/oyofBzWtvo3gvLT2mutoYMGNDxRWL?=
 =?us-ascii?Q?y4/rcJIfkVMJh0NaNc62be8MjldDuofZkvW/x6BBFvNgEg3T8x6hB58aY7U9?=
 =?us-ascii?Q?cALjFpoAu1Tiif6AsgYY9uNYAXqrMiJIt3sykZTrTfK+IAerm81tV5dNVibo?=
 =?us-ascii?Q?4KatySNZmLz9nbn+S5f1e0kRp7WDjNqeZ/DBQ879jk+pcYtYqyjDT5CXJawS?=
 =?us-ascii?Q?DGRYliweMh7aYh90gCaWm0vEpvWNWTdrAnuL8Q0arOC1iU0tEBs0IuoaTBrs?=
 =?us-ascii?Q?m2OFC63k3cexb58VeZnVb5xIUmXZUIyeYvAeIKdbbHBZsTuAWmXDb5r+tD/f?=
 =?us-ascii?Q?rn4jv4GYqDp7D7bCzo7re9LJkOcFIo1jtIfv5YmmC03gyuV0COAbDoulgR0v?=
 =?us-ascii?Q?5TY0utl4NxoJ1RBqkOw5azEn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a11e4e7c-1ffa-4e73-2a6f-08d8fe625443
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 09:55:54.5130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lWvaMoetO0YXkerq9W+sLIRgm0jYX98OKC8YM4Hb0Md+qtlOwua6T5eU9+C+cN57NnEj4nwe6WT2sBPeHtm5dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1566
X-Proofpoint-GUID: 3WaRM0snAbKbrPmwInmpRlZ5BMHkaqA3
X-Proofpoint-ORIG-GUID: 3WaRM0snAbKbrPmwInmpRlZ5BMHkaqA3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_04:2021-04-13,2021-04-13 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > -----Original Message-----
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Sent: Tuesday, April 13, 2021 12:18 PM
> > To: Stefan Chulski <stefanc@marvell.com>
> > Cc: netdev@vger.kernel.org; thomas.petazzoni@bootlin.com;
> > davem@davemloft.net; Nadav Haklai <nadavh@marvell.com>; Yan
> Markman
> > <ymarkman@marvell.com>; linux-kernel@vger.kernel.org;
> kuba@kernel.org;
> > mw@semihalf.com; andrew@lunn.ch; atenart@kernel.org; Liron Himi
> > <lironh@marvell.com>; Dana Vardi <danat@marvell.com>
> > Subject: [EXT] Re: [PATCH net-next] net: mvpp2: Add parsing support
> > for different IPv4 IHL values
> >
> > External Email
> >
> > ----------------------------------------------------------------------
> > On Tue, Apr 13, 2021 at 11:45:31AM +0300, stefanc@marvell.com wrote:
> > > From: Stefan Chulski <stefanc@marvell.com>
> > >
> > > Add parser entries for different IPv4 IHL values.
> > > Each entry will set the L4 header offset according to the IPv4 IHL fi=
eld.
> > > L3 header offset will set during the parsing of the IPv4 protocol.
> >
> > What is the impact of this commit? Is something broken at the moment,
> > if so what? Does this need to be backported to stable kernels?
> >
> > These are key questions, of which the former two should be covered in
> > every commit message so that the reason for the change can be known.
> > It's no good just describing what is being changed in the commit
> > without also describing why the change is being made.
> >
> > Thanks.
>=20
> Due to missed parser support for IP header length > 20, RX IPv4 checksum
> offload fail.
>=20
> Regards.

Currently driver set skb->ip_summed =3D CHECKSUM_NONE and checksum done by =
software.
So this just improve performance for packets with IP header length > 20.=20
IMO we can keep it in net-next.

Stefan.
