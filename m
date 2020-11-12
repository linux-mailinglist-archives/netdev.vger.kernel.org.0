Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2122B0020
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 08:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgKLHIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 02:08:13 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42384 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725902AbgKLHIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 02:08:12 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AC75cC1020026;
        Wed, 11 Nov 2020 23:07:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=4/jHH3GoIW7z3EUOHcgJstg08DoxmvncRZtkKkKaNrM=;
 b=WDNCQztaEFfyPcfnD+uXxuJF6B1udzB/w9WRgJmSGv8pvJUaVsu282HmvbzUVH1sm5Lq
 n15NzySi17I92CTO8a0LnzBSpAC1h/IMTH0awss++sRS5/CDJdDGtg4rLFd2sapnOszX
 N+nfo2+FzKQ+oRtoTSVVhKjziA5oQ0i888dXBgSCd6cTaH7mItsLb2jB0kKI2zjzUSDg
 T8hQ2dDEVXjiJCfU+3fMIJTfBhZPRZ1FsdG17H4v0OE4QkQpr6BHb7DDSv0F4WHLcsC/
 kIpag7N4lEADQSpS7iMBxAJX3MttShi+Ls05AGK6t9GxeTPtgqCId8AcyitYdxxgHs48 9w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 34nstuawbd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Nov 2020 23:07:48 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 11 Nov
 2020 23:07:47 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 11 Nov 2020 23:07:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jaB8naVa8bs8jwJW14QX8SBvUMwvtZZokwUKhSbEgcz9gcogLnRdwbR2omjO3H3qJBCbBiFt3dnia93UyQOXSJXJzi28d1GrKK1QG2QvQU4o0vid075Zy9k14+YokY6UmWX/zOYE9CrfS4Ht8im43W7TDpSkeIj99e29v6Mtw+0ZkF7gkzaypYgK71satzep1ZcQrPdBkpQsJ1fvz71QV9/+pJ/9UvylS/aYh1S7PXA5bVUfCzIbtjpLmqHPM5N9zePhR1wc5sgQIpiPLOwp8FdJfJX5I4q1A8uXpGTkCcatasWGAo4DHlhCfwenuT25fDPxM3evptgXkq89fvbL6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/jHH3GoIW7z3EUOHcgJstg08DoxmvncRZtkKkKaNrM=;
 b=ll+Wi2bLEEje0rjc1wPVUa45tcNzZezWigBVObURK2tvjIiZY1Co0yYyYjEhjG25Tu4NoPh3KpyrDtI6683snbfvttobZAVCDgJNHoUY6Fl8Q4I/KZUX2s0nE+0CGG5805L9+4UIGO4G6gSTEB2mB9yo2Bv03qO/jsB013ymA9LzC4wQgUl8YH9ydZsD/bNcdwyZJgzQPLX9HIbhoy62UOL5o46HmshvXNgB8IoSDWT197MOZWrQbKGuCpZJM9wBy0DKn2dRMW7tczrxt/vSC7V86K4nqcOMcSLkOReuHcm87omdoT6p/CEtiRZ2n1afZAIBUcBRTqPvJCPZX1ETbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/jHH3GoIW7z3EUOHcgJstg08DoxmvncRZtkKkKaNrM=;
 b=EqpaIZKgrbsG/ZZKP4IrjDcd/8ZELn+6o5CUPhpajMlgRvEv+OXkuTqBQUgOS2YqLb/r1P/HauI8VTphAR1YvTzsTXFlnmp/U4x/ujkiX9PQ4b5z5aUEVVXGNpm68fMrMrJfnRN8ZnpjXNegpap7ZkHq0Z83Lh28iIj/gIxDHjI=
Received: from BYAPR18MB2791.namprd18.prod.outlook.com (2603:10b6:a03:111::21)
 by BY5PR18MB3249.namprd18.prod.outlook.com (2603:10b6:a03:1ab::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.24; Thu, 12 Nov
 2020 07:07:35 +0000
Received: from BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::68cb:a1a3:e1cf:f9d2]) by BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::68cb:a1a3:e1cf:f9d2%5]) with mapi id 15.20.3541.025; Thu, 12 Nov 2020
 07:07:34 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "Narayana Prasad Raju Athreya" <pathreya@marvell.com>,
        "Lukas Bartosik [C]" <lbartosik@marvell.com>
Subject: RE: [EXT] Re: [PATCH v9,net-next,05/12] crypto: octeontx2: add
 mailbox communication with AF
Thread-Topic: [EXT] Re: [PATCH v9,net-next,05/12] crypto: octeontx2: add
 mailbox communication with AF
Thread-Index: AQHWtpFSDsIU7hjKv0uAaYw7geYeMKnDnsUAgAB3yHA=
Date:   Thu, 12 Nov 2020 07:07:34 +0000
Message-ID: <BYAPR18MB2791873F6D23CC618AD76093A0E70@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <20201109120924.358-1-schalla@marvell.com>
        <20201109120924.358-6-schalla@marvell.com>
 <20201111155412.388660b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111155412.388660b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.70.131.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 684f5458-65b8-4989-244d-08d886d9a13c
x-ms-traffictypediagnostic: BY5PR18MB3249:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB32492BEA84B65C47A9BCE3F3A0E70@BY5PR18MB3249.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bPgEV/ou8PDzWvFML+e6WEcpQ/9fPxYWzgipteIi/nvSjhgHTmR6vOIaREUnEvx6l9QTCZs+mCEV2is6c2pNpqAhHf0qh+20jTedd7ptKFMVfiGV3px4j3eDtKAIxa1yoiLZsrK9InQQj1YpFtNWNfgGH1t/LkuMavrAEnBU6EZJxMyrYO9svKEXJWL/az4QI/eQ5s5P5GtISMbMfsFuso9KoXfMXe8eWI8Oi5A8Pka0mO9rNjZ2iUGsxLnjZSDkpg9n6BF7zTWDZgUkl14+PRblQ2tfqSAfsYrqr9w2SGOUN2aQYCR3pOr/u/AFwmaR4GEJEtq/B7jnT+dXMThJCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2791.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(76116006)(107886003)(4744005)(2906002)(8936002)(66946007)(478600001)(71200400001)(66556008)(52536014)(5660300002)(66446008)(86362001)(33656002)(64756008)(66476007)(6916009)(8676002)(316002)(6506007)(7696005)(55016002)(26005)(54906003)(4326008)(9686003)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3st9jHn5Val/3bQ204OOU6ny157Mtz01SwlOyywYa+FWEwhA44T05BqaJHptnOu4fpCZQgA8F+JisP7LEp3UO8AxHVD5S6AGhgouxWDZmQHw0NZujaYGNCP5q2f4bJ5/ZiLhVl0nMArL26BA4CQBpzmzIv9WmH436K7rZ98tbBNChq3ejbCZqblPHJq++tI/2l7OdyExtA3W4F2lOcKV+2X5wzQX/TwJrcxtc87OiH/ZUyIYI2fBRJv6KjUyzI6E+q/S57xSXCHLkNfwlucZ1CbgLQJhPzsdWFMEdFOI8k/EC5pNjlix08Z+mlF5TImXTQrGwuwl8hWxPf6GGYzSW9v1UVjVYVM4jri/ZgRT4heS7Uzydk4fgGHCh7fnrQv6zyq4y2iC+DijmNWwaX8UyNY+7DvTTmQjFMhth2t+Wbwktm84uoZ52SrT1n53kKRusxoedUuRZoafuhNCe0Zf0qZZii3OtDMAMDQ+AGtHe+R5EvzeJJRVYJpIVQcNIwkI8jG4apy3yOzOmHFCqVx9zuUSb7qxTxFui8od7ei/HCowezUjumILnaOslFB1cba2dS/nHFDdAsFEBlm7/IG1Si2R/EqKDa5Z46N1COGJwdn8VV+ShUXvYoLJWNp2Cu83l5vmZnme73KCZB8sNS5+up1K/i9HPOZzdyFdwPttPss0qZbYLRF43ftIE9hT416uefhpS6XHEp2LNSzXZ+Wd3ukQvlF1zDk3wBI/4T8Wj1OP9KAoCNqFHH6YVo9ecYVqcWckCnTtTvx1x6F4xLWevsN5hSW18Z7KGYOKKsFpucVSKXY794GUOvDI2B1GIJhzZFRVx6OvnZB5MKHT+JBP1JB6BC8/LdmXRmLDDK/FdVHns5PDpXUiRyXlnRKtV6BICzPiwysycVebe8g47kQ7Xw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2791.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 684f5458-65b8-4989-244d-08d886d9a13c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2020 07:07:34.1704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oas2L6QgzGcBTykZEEj70wMwJy2QcLBW1monEONZNfYYTagcnE7dLZ4h58DTgzu/N50DSYG6sS+XylRkbp+oqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3249
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-11_12:2020-11-10,2020-11-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, 9 Nov 2020 17:39:17 +0530 Srujana Challa wrote:
> > +	err =3D pci_alloc_irq_vectors(pdev, RVU_PF_INT_VEC_CNT,
> > +				    RVU_PF_INT_VEC_CNT, PCI_IRQ_MSIX);
>=20
> I don't see any pci_free_irq_vectors() in this patch

This will be handled by the devres managed PCI interface.

Copied code for reference:

static void pcim_release(struct device *gendev, void *res)
{
    struct pci_dev *dev =3D to_pci_dev(gendev);
    struct pci_devres *this =3D res;
    int i;

    if (dev->msi_enabled)
        pci_disable_msi(dev);
    if (dev->msix_enabled)
        pci_disable_msix(dev);

    ....
}
