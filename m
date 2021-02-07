Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8CE312621
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 17:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhBGQwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 11:52:53 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28054 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229445AbhBGQww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 11:52:52 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 117GpIdk025161;
        Sun, 7 Feb 2021 08:51:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=uY9l0McMi9d9vMcVsWIAnEmR+YeRoF01FuTnUt1DynY=;
 b=LlBMcs7JUANmvNUEN9rUx9Z1YMCa9d0TkiQhH4oYbyCjkxiby2veEGcULQI3uxTrJoND
 wf4gzOOa0epDe6s/yLepEBe/Sc5OBoCPQo4EyLwrs3mws35BYr/eT12zWgzIhJ8DnYe1
 ggMAg1JaEcKiy6Gr8BRNfYW6t2OX9fAy1SBShFSOQNdoaBhH0rURRtchhqGm/ZaAyn2B
 BX9lH6Id8LF8xaK/PYKNy+9PAMC/0PclnDOTlPdE8Qx6/TJi996o+0A69jMFT6VsNSPM
 JbHwvGMNt7UOklL+KbFDAucNVBpxrHqfkCUFco5qYxS88u7YpI15JAzXqLBKaBzxWa4L tg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbragec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 07 Feb 2021 08:51:55 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 08:51:54 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 7 Feb 2021 08:51:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5qDg6NU9qJUAnS19LWbtekBay+ZKsBTnpoKxFozRti84GLOkrUuLc9+u/b9P1zHxzcwPXOL6lt1fka36/5gH/j1ko1voYTVrzRpFGaqjiM3dCLYEy6iIokrZC7Ct7lItkjX5jounigDlxT6PVGjIS3P37ITkLy1aIlp7Os0CGuzckH6IKUWCqqEOyvR8SldnsenVv9Req0N8532Mo9TfWf+jTNyBeO9tUzNq+EPgpzDyrOlsTw71ylweThrBzmZFpUd0USBcg6UHUsX/zMTTr0Mli0LVMvOwq67ATMI/hBFZ2Hc5fUQDZyrfHxIIjdX7lEvIvhLcIx+di9XkmRs8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uY9l0McMi9d9vMcVsWIAnEmR+YeRoF01FuTnUt1DynY=;
 b=a+gXBv4bUhH65fRaCGJpL3FcTJMlvt2IjkOWHjquT96jv3QOTmyOYuU6AG0x4Vahd/nFiwFYYvsgPxEnHMiP8mXYl0eZJ5fOT3q2MOFvGGwStwyo06MUFY6O4l6XGDDDbdqw/w4ibJDTbwrVsEBmDiN3GHxeLtFYebKOieQ4QVGXw46bfD39UgrPQ+kFr2Viwnk+JCu5IkJX0oO5S+IfBNqvZvkg+4nuo0rZlPNBf/iXYRZWooLUqzfD3gcZJQEWtGKdgGJ+LY6Ru5ztw17bc2tKN8W2Lh9l32jiJRkKNISjUq82bS0y6t7F6M5XW9xbygKcz26dNRA37CzZ2YovvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uY9l0McMi9d9vMcVsWIAnEmR+YeRoF01FuTnUt1DynY=;
 b=GE359f7vkG+KjTG9yhWy1UcdVAQQ3lbZ71gKuFdJBhVCpo+hDyD/NbRD5m0b6FlWaP0H953zdGPfv7njH58RGiz59Bpt2UX4KnST/MxaaG5bk9ashOiSQSFNf7LOv9ZBfWVCl5qBWwDThhtNNDI5LjPxskTIeHQafbml7MU+5NA=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW3PR18MB3532.namprd18.prod.outlook.com (2603:10b6:303:5e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Sun, 7 Feb
 2021 16:51:53 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 16:51:53 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [EXT] Re: [RESEND PATCH v8 net-next 03/15] net: mvpp2: add CM3
 SRAM memory map
Thread-Topic: [EXT] Re: [RESEND PATCH v8 net-next 03/15] net: mvpp2: add CM3
 SRAM memory map
Thread-Index: AQHW/SobMD3vDu1MAkO+p8Aai21QfKpM5cqAgAAA5yA=
Date:   Sun, 7 Feb 2021 16:51:53 +0000
Message-ID: <CO6PR18MB387374A4B8FA0FD1213EDAE6B0B09@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1612685964-21890-1-git-send-email-stefanc@marvell.com>
 <1612685964-21890-4-git-send-email-stefanc@marvell.com>
 <YCAYL+jEVijKQqaa@lunn.ch>
In-Reply-To: <YCAYL+jEVijKQqaa@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79d589d1-646f-4313-3c31-08d8cb88ac11
x-ms-traffictypediagnostic: MW3PR18MB3532:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB3532046AF9291251D5D91602B0B09@MW3PR18MB3532.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2yog9LTwlPr7DhUud/XW7p+gG+BQ1FQb2Vlgb9ufeu4OjNEDRqoIK85+oPF0tCjh6dQTjumrELEc97O8+oeiI/XfmdeTVws2ylr579RnY6WmCQKU9RIK6+KUZz/QPgERKH3qtFU9k706dlZ+6l/cliF3YicvFIWytIypEmzRe625HsSb1U7gFbMF5nsVVAvom9FRCXFcmrzTZYfuT1rZ+0c7FjHya5YsskORpMmDX2StYKImxWL74YABodkPNxgCQ8VKBoi2TxB551Wsxt+9aC/3skkpS6VZEu6tEyF62X2h03MOGuF6vDBfnWPLPHSRz1NYQWn+2D+PNKvK+7e7USjoSLdYvmvOpnY+LjdV/7JIrxncvVUB1B9wWSnk+23VDl9dU1PKDvD1A1DYADX4HgTgYGJ69SRqyOaTRttmhRQQPYwnX+8ByE2euPrei7Df1tu6iWW7vDi9AUwCtxNKO0M4u+aCPRTq+sqvPWBaeBhQ2Wo6iQgzxiHS2A8VfRSyuiOQTtZIxrlT6LmVfPJaSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(39850400004)(136003)(52536014)(76116006)(316002)(7696005)(4326008)(54906003)(6506007)(6916009)(66476007)(64756008)(33656002)(66556008)(66446008)(9686003)(8676002)(86362001)(7416002)(55016002)(186003)(8936002)(2906002)(66946007)(5660300002)(83380400001)(478600001)(26005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?J7ZXE027Nytwknj9ns7gjfJqZJu1UnhinjSb4nHPCOMH4S6UYN0D4ciseuBd?=
 =?us-ascii?Q?Wg4JWbRT+R4F1IqC1vEkMpgS06q8cVXwQqy2f24ZFAag7hT9ZhtxF93+CZas?=
 =?us-ascii?Q?+tBFZ1tuGBsjbl9RZ51Z8HF1rcMWLSjeigWglboh9nv5k8F/jS4GhtjOjA0u?=
 =?us-ascii?Q?KBMHlTQuVaxNW62KZWeOtQ2ceO28BOjDmWRELXfqShPRf1eqUFrkOoARrAQf?=
 =?us-ascii?Q?+DDg5Y1bZrMyhncQBqCnwEMNZHYhkAyN3whV9ttNjnnEBmcLXcEkrFHAs/er?=
 =?us-ascii?Q?+s+FO9DVPONMzO+i9BDd220Jx7KlR52fBKaK0+M3ILS6Fc8Jn2CgUJyRfDX1?=
 =?us-ascii?Q?oXy+PfuMjduxY3HhtGESuE2IA9ty5TqCr/Uk/6XADTqFiav6oWlf02RHCddq?=
 =?us-ascii?Q?hUl5a9mD/qg52nOWaJeMpnXSt2PCsvzUg0nmfKeOEWp2MwDb9yLD8JASrhuc?=
 =?us-ascii?Q?FkKZ2JoBi9YT3ZZNWe1kKXe1SPs8Yv/+6ttpqXPl7nbsZhwYdOx08UEF4fDj?=
 =?us-ascii?Q?nLAgR+QGNI4hlxc8MD9+V0oYhSe7MyH1jtIzuU9KctVnKYu5LShTHAW6OnbU?=
 =?us-ascii?Q?szdPlo1HnE6Uz5uG4wkC8PZCAAjRiI6TNHw0h8eiLO+MX7ASuqtCb16R4q8E?=
 =?us-ascii?Q?FfYewp5ASpzZeABV/a5t57qhEy3hm1UA/ThZNlEEsIjLSPRhpj/PCicfu7tY?=
 =?us-ascii?Q?Gz4PKxkKVfZuUTZNYXUp9fPoj+tD0/V3wV70kxt3jrkGwWDvtoN4HvUKrQkv?=
 =?us-ascii?Q?fNYXwoDdks/KVQlZk6ikLSV4BjnY0W7d10x06AUG56zr/81PI/OqirSBzhjo?=
 =?us-ascii?Q?p3ju7+tC429uHxfQlBch2i0xEkR3/j6msMZe/M0z8gHiZUwSx2R85FYSTNY+?=
 =?us-ascii?Q?xOyzVAXkT23qAtzorQgyKLnnBes9cnCi8debUq33NYKa3h/FEDfB2zKIPStG?=
 =?us-ascii?Q?Xt4YSM9weE0s/CdY7XcQcFBmLgyP3iNQ6bqfZ/1ZEpaIk6QOCVhN8ghT7i94?=
 =?us-ascii?Q?kPAEE4CHwQapuAzcslkYwY3tkVEDQ55IwnHcPyoOMCzk+Wjt5xIHpMJ6JU4e?=
 =?us-ascii?Q?P/8hmwaMAm8s1qPA8Okz/0tb2Fj8S0WwSMZ3s35/HF0DQktB2+zoiLZYuyzt?=
 =?us-ascii?Q?wdEW7AJaSQJkpwKQerLaHpdQzRtpnyaYmYhF3TWjeDMti6nzyV0kyJjwXmn9?=
 =?us-ascii?Q?b1CdJAciVMod1QQupUxNkCr8GwlUX5dq+xEjg8bAOjacnebFjQWbC2cB2m2w?=
 =?us-ascii?Q?4hvJBG69Qgbpq7e2fWPHtuisJNcIErhKnDtxaMI3Z8iJ3qTug2eBePanVBvK?=
 =?us-ascii?Q?rcI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79d589d1-646f-4313-3c31-08d8cb88ac11
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2021 16:51:53.4721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GN/yITzNyO5M5vYOxXfr2tCi3y04uZ30HJjiZICR0wWw+T+356sLwSVolnVy6Ht7Y67WHA4TpCD2IWCzJPfAMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3532
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-07_08:2021-02-05,2021-02-07 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +		priv->sram_pool =3D of_gen_pool_get(dn, "cm3-mem", 0);
> > +		if (!priv->sram_pool) {
> > +			if (!defer_once) {
> > +				defer_once =3D true;
> > +				/* Try defer once */
> > +				return -EPROBE_DEFER;
> > +			}
> > +			dev_warn(&pdev->dev, "DT is too old, Flow control
> not supported\n");
> > +			return -ENOMEM;
> > +		}
> > +		/* cm3_base allocated with offset zero into the SRAM since
> mapping size
> > +		 * is equal to requested size.
> > +		 */
> > +		priv->cm3_base =3D (void __iomem *)gen_pool_alloc(priv-
> >sram_pool,
> > +
> 	MSS_SRAM_SIZE);
> > +		if (!priv->cm3_base)
> > +			return -ENOMEM;
> > +	}
>=20
> For v2 i asked:
>=20
> > I'm wondering if using a pool even makes sense. The ACPI case just
> > ioremap() the memory region. Either this memory is dedicated, and then
> > there is no need to use a pool, or the memory is shared, and at some
> > point the ACPI code is going to run into problems when some other
> > driver also wants access.
>=20
> There was never an answer to this.

Sorry probably missed this. Currently this memory not shared and I can just=
 ioremap same way as in ACPI case.
In this case I can remove EPROBE_DEFER.

Thanks,
Stefan.
