Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAB84AA4A2
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 00:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348745AbiBDXw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 18:52:57 -0500
Received: from mail-centralusazon11021014.outbound.protection.outlook.com ([52.101.62.14]:16776
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231301AbiBDXw4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 18:52:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgsDDSmSoEeTkc3+8ZMGBGZsiq7IaQb1EIw4TSpvTyHvflkfc5FpAuK9YNcm8e/xX/E6FqDoT52DhCmBD853kMAMoS1Aa0axLcS7Vf/Z3AilV6TrR9xBhWegbFVTiv7e3lUQmCBdwVbhXZ+1d9TGP7NlfhMw4A5WFTGIiV090yAsypRiL/5ZG3KjlJRnulhVS+IFLgbboTwikxTTDOrb03gKu5EGTx/8Mope3Iu8C5dpatj9/SFkRbvkV0QgW26NUGemOWvItFPIYcEDBbREF217HCmmUrCjNmF9tuJz2UBL6dkhtV9n8dMAP6RU34Z1Lx7G58L3T0ei8YQd1a2sMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9vKssXPZ5yb/J3wYw+sKIxoYcKtWzfWr/XSyrbZjuI=;
 b=oWi1+nlgOErKbzlPc2bU0L1o23vWcF0pTcMlRFdbNL+cGxuFw3QZr/zWAQYZ/1LeI708fgtpWTxkHzKtLxurzvy9mLgl1Ux1i+v9PtEOzcTXQltBRDVVRFgh2i+a5O5k4Ikn6GPRxxCRKN6KG4iYQV2ef8tcWb6vEtfVZi3F8l1RSEcbJJVskluPP5fV/cBzDH4rmousyBmzqEDOCwk2NRte9cxPW+56wah956wlWA1m/bLA+vbXZQ6oUZyOqSXTEk9JIHMHipP4tShPeEx+ewi+A/M8OkcNy1A3MVNv1hs5Lxuyr5RKOR4XffbsyJsuVGVQ+XX6hJjNobYjgrSSJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9vKssXPZ5yb/J3wYw+sKIxoYcKtWzfWr/XSyrbZjuI=;
 b=PIh9lwCmyYHiiGY5OUrnCuPvoiUkA0J39EHWrv0hq/4Zr3GbixUKPTHFZxXtnQwfFiFcM3SoUe6SmQZGjtZQtv0I8HF+oKYYDCB6hXi3mW5wYLeqE2vdtvm5M1ub/jnYxTpgMH1GIfwUQfpIl6x0BcmHrGZFzGLFtEBmrfC2spk=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by SN4PR2101MB1599.namprd21.prod.outlook.com (2603:10b6:803:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.8; Fri, 4 Feb
 2022 23:52:53 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::e9fa:3037:e252:66e7]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::e9fa:3037:e252:66e7%5]) with mapi id 15.20.4975.008; Fri, 4 Feb 2022
 23:52:53 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next, 2/2] net: mana: Remove unnecessary check of
 cqe_type in mana_process_rx_cqe()
Thread-Topic: [PATCH net-next, 2/2] net: mana: Remove unnecessary check of
 cqe_type in mana_process_rx_cqe()
Thread-Index: AQHYGhkd6pMY/dCar0CRyjyWw+/jfqyEEEPQ
Date:   Fri, 4 Feb 2022 23:52:53 +0000
Message-ID: <BYAPR21MB12706F8450DC31ADDB94B510BF299@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
 <1644014745-22261-3-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1644014745-22261-3-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5d292909-917c-440f-ab87-d42fd5f0e182;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-02-04T23:52:12Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58498c14-574e-4b1e-6940-08d9e8397594
x-ms-traffictypediagnostic: SN4PR2101MB1599:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <SN4PR2101MB1599B885246F40856F2E3282BF299@SN4PR2101MB1599.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:549;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9HEM8EWP0seEux+DY0qYdT8X6Y1m1hd82BpStEEfuiEhY/pdb/Yv3DM7j/dwI2pKwgE3JUMyFfgIDyNzhyEGyUDK+RUuFGVgfsHk98M/xQ35YJF3Kp6DjpP92ei3sgK00N02jMu5FTS388rlBYlPh8XxgfzkbELf0uuAqYR0WkhKg4s9qPsNBFs6uWsej5OF7Xj4PEk0ef7VW7B+MxnoAeACfcN1ktcObSyCkyEp1BYsHTPzBSGGsDJUlqDKvkF8oi68gcbRD5qka+apmsYTqJXKGLlfFj08NZp9jzPp6FutLtol5BwfS2K+/Biobu8fOw04avUK9aOonvzdLxQ4STp1yorVtu4HDifM+0E7zLqCMS70wYEB16AMhC+Kyq5fISLQCIYMaoGT9u5N8HWuEhO3hCQgDVyeEbNpXzH4hrUm7As1p8+GnOA+QKYuMpgYO1IGKY3jJm+Ebu8jNnfqHxhmIFI9XeM6gVYersYD2IG80goEmB6EBWnkJfHlWsu25BDULXknXe3FG9mdD9CXFL4v8449XAfqkQqIo4ZSqorYQZCQjVleVuHzrkjWgGkrH0y0lnCJS6E/Q/LUqX4S5weSILQASBwn/MNSa7CXbcW7CfBoRSbRW2CqjD9DpLctjl68Bvm92lakkGwDVI/Em/txo9or70byngo8y//ZtJaNoasZyFEeyY2O07g/TFh9p4apNYQa5geYswP/yVT50PH+5CQCWK6BzBqVGZk3cO70HK0v8oxpXmjzmEQGH9Ac
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(316002)(52536014)(8676002)(26005)(86362001)(186003)(66476007)(8990500004)(2906002)(4326008)(66946007)(76116006)(66446008)(64756008)(110136005)(54906003)(5660300002)(66556008)(55016003)(9686003)(122000001)(508600001)(38070700005)(6506007)(558084003)(7696005)(71200400001)(33656002)(82950400001)(38100700002)(10290500003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JcpXWmhG1opJMdrlxC0pdJwvv7MZbw+4RRVdkS0UmsccP03X4QlBiCn6oQ9o?=
 =?us-ascii?Q?ImaRM8HGkXhHQh4EG75PBFiA15DbXpvUSCR+IipAmdV9bugtdtVX2buLTqYr?=
 =?us-ascii?Q?yJIhZspTY/0lBdQTnO4kpxLiVs3jDD5W2hAoax6aINoCxbZEssutPYBhL4DS?=
 =?us-ascii?Q?I5f8Et7giFqIeVXkL0bWVHk4F8x8ejlrYfFnOByh+E5RPWHcj7GCBDNOKCYk?=
 =?us-ascii?Q?4fvLuOJXOXYNIDqcaAKj6vsf08WdKyDHY5q/DbqW/0vtL8Yt8MoyyccPFg/v?=
 =?us-ascii?Q?Rk4OOFDNp62VfiAp/HROiKbCxLF8CyEwZQjPWS/+3jK1LwHobVEMLqWpAK0o?=
 =?us-ascii?Q?IyVEjEiLnrDtDLHxu3FizUf//cIkSOYY+Ruib7i/4ilHxJOboX8sIQ3BNYmt?=
 =?us-ascii?Q?x3ZA4mnRGKprVPTPZWiwF0AQ6yxQusYNbuk8FwoUmPhi0CpJX5WZrqVXzAJ5?=
 =?us-ascii?Q?THoQ3q5NZLIhBkdL3X+4MKIRABvQycRPyqk8DQxdVjTvDwqFuJmCielTRTnr?=
 =?us-ascii?Q?E6CCcidagiv6/8cptSKGvLAb2bnIWxpKvej8rwJ2kJj3wB4jKqznehqTqQKk?=
 =?us-ascii?Q?j22zKQ5iqA7YFyUYxO1C3f4Id84rNBOngxd35ljku1ksKyij2ot9AezNb1Yi?=
 =?us-ascii?Q?kedYqOY+Spw4QOKdST9GMP1reqLrmE6S6CzhgWa51jdoKEnvHXEw7b76io5T?=
 =?us-ascii?Q?Zwht/tXe6n40zcnAT0meZBtJEq7xxvDhFqt3TM/3F8nGhQQ3pmcwwZ9tfJ+1?=
 =?us-ascii?Q?q+9jw5DPfvTpPL3IRc8smo+UgDljD8Hd5B6aORqT/jIH+c2mjF3syaPS2yI+?=
 =?us-ascii?Q?tsGvsR+G+LRhOPbl2RNxciHNy2u2rYjN5ecw+VSJ30mM3o+nXbTKJ3VVw6mB?=
 =?us-ascii?Q?YsI6R/N1CFGbfGJZWTVxNELaNtBNk/DWOtjc3DGB79zgbnbtw2mP39wnDaXv?=
 =?us-ascii?Q?eqzwbPv35p9P2ZVgeqxnM0aeLl2uRZfGCk04kuvOr6cFis74vtPhQduIoj8R?=
 =?us-ascii?Q?obHMftA2T/My53eO7Bi1XgzzmIlOAVsX8XWxLADbuY18BadFtgn8YlF385/I?=
 =?us-ascii?Q?jIV3vJrwGsgaX/7dfbKgvHcQa6SeS02CzSoF0i7KXZindfXfsoSOixN5z/pp?=
 =?us-ascii?Q?RtvAq0sf96HNOiUvL6jA1aDUGzB4VYsBYRJYhtJb5X40YfflmBlXXFmsh1rL?=
 =?us-ascii?Q?ikwVvr38xe7B+ZNmi9cIyUbH7DMT75m8Igq52osgUXi/DMxz1F7JUpchIX8I?=
 =?us-ascii?Q?ZTVd01idL7yL+pYmYwoHuj9219BeR0IpsjBQc4neVXg4iIo/6nFlbignpQQa?=
 =?us-ascii?Q?R5JG4Q4JjLuPVeLKE4jnjQJjNcgtBHKVMEa0z/ABdloVmTyka15Q3JX8EiRy?=
 =?us-ascii?Q?tchwhvY25f/P6aEJ61t2ByI43VUWOII6ZakrnyIiJ8crSqz8dQVmwRMUzDEZ?=
 =?us-ascii?Q?IOOKQhlawvVwvd2apPu1/+rvpFg7036qcbMldGe5c6q0ZT6o590WcwC4IHLq?=
 =?us-ascii?Q?mzYeDMAaQPHYE8rBOmul/gLX3hRXlyFDn9gRBSqh5rspLII4ju50tuK1OTBB?=
 =?us-ascii?Q?h/ABSJsktoNQjvh+DOyU6EpmFoNEmt90VJl0OhLCSxnEHhn+7jx/Blfb/DbF?=
 =?us-ascii?Q?SAUdD6+vhI+/HNWAloEDeJc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58498c14-574e-4b1e-6940-08d9e8397594
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2022 23:52:53.0226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghKpjJizpl4Ad98RdGZ5Dwg+vzX39aP2tNbHIsn02Knpfir/Hwv1yOmDbbhwvqHG3hI2eBzyGuzGdcLBdZzldA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR2101MB1599
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: LKML haiyangz <lkmlhyz@microsoft.com> On Behalf Of Haiyang Zhang
> Sent: Friday, February 4, 2022 2:46 PM
> ...
> The switch statement already ensures cqe_type =3D=3D CQE_RX_OKAY at that
> point.
>=20
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Reviewed-by: Dexuan Cui <decui@microsoft.com>
