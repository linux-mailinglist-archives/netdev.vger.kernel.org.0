Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531361DF029
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 21:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730968AbgEVTrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 15:47:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9942 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730689AbgEVTrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 15:47:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04MJj7uC009901;
        Fri, 22 May 2020 12:47:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=rjKJRfVveqWTnbzzhyD0ZDq/Y6LX3wP/ZN5keXyzl2Y=;
 b=GLdm380yyLjNJ1kJdveGuOi2J8gwzatBrn5YOWc2q+IAO3fYQMEtb6JIXfc40oxYlMTf
 JHwRy17ECXHdX4BGVcH5kFEKM5YOTZadCvwUn8nZtx004RytrzT6Z4ZqvY2XIDxu/umH
 yCugr+zaZ4pGOvUyOb03TD14rL+rKXQCrpIyaqiiM6A/hL7BVN3hLcarNw3RMshBeSbX
 bFO66bgmWhhDrW/3vvjVvQ9hakf7M7XBNOtTUSJm1rGmmEj8hmtIjBqFsZ3JUCW8MKVW
 ZTG3H59MrZvkmtfatYCtlJ1oSu54bOMLS/cyqM9VAxOEMr6XNUPqwcealTuCgGc4ARps gA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 312dhr4jm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 22 May 2020 12:47:40 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 22 May
 2020 12:47:39 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 22 May 2020 12:47:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1aEg8a7ULzEgdqRbbT5iH5taKsKyU4syTxIZYx1/pj2i0H/hfLqyuBRygileRzL7+4G9G2xNR7FFBDqID2YelI8pjGLKK/15riw8z37yjqKzM0HtLDg3/ZBGD5PO1ZyS3pte9GBZ76CxSjXvl7qRK/2UVKx2rHCo+/IJIEE7w4TFxcp6Bio7IAdn/uBWgqUSXPaceU9bkRMZp2Byx02fZarlFQgpqCXPigmC0UMJ7JOJzZkYUB6d8a8uVx6dFFLqoPBOKOIkaDmr1f1wKTOsaiNopyU8rq1SWTmbl/sC4qoLTd7ga8CCMIrfnHVsnqNmahYkEF0S0Q4LBqX3m9PUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjKJRfVveqWTnbzzhyD0ZDq/Y6LX3wP/ZN5keXyzl2Y=;
 b=ULhnu/ISQ1dUnHw5Nxi07KSjDDH+s9Ob6fAsUMzF/HWhaxL3NxIEIxKc+2mm+NeRvF+VHEYKNwM3nj1XXFCaRtHa9f1YYJjLUKXg5bIP+bBaSeWaZLd3YO6oA3CItGWMBGenblpADYHaFHG28stIKkwYntlHnl7yZ+RKAhKt0zdWMF8Ncz5UwdUT3hV/74VgumQFStQraW2cUHdE9hdiCpP/+YqtBNOTvxWR8zkhFst/bAuO4iUGGPhXcGg9ye/lje53HYH82BM0tSlXAPZENaGlwVkaKaMx2fFeTEosyiZjqu7rpFFJSKECAuiYIsjFDJkIRIqlAzylgGIbyn+ovw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjKJRfVveqWTnbzzhyD0ZDq/Y6LX3wP/ZN5keXyzl2Y=;
 b=fTABeWmeX256kXLFT1PgJJdgOarAuCUOe8eUF9eTA7d1f0jkcfqXlw2ZibA5OvbilZiAdXobLhSUaYwVhIb4/DfZLsRNuj0vwd2wHIHQfgVH3Nwryiv48vzpKl0qvaBCEIzywb549NzBNd+yHa4zayj8KAd47TETFew7/5ym9HU=
Received: from CH2PR18MB3238.namprd18.prod.outlook.com (2603:10b6:610:28::12)
 by CH2PR18MB3269.namprd18.prod.outlook.com (2603:10b6:610:27::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 22 May
 2020 19:47:38 +0000
Received: from CH2PR18MB3238.namprd18.prod.outlook.com
 ([fe80::8ac:a709:c804:631c]) by CH2PR18MB3238.namprd18.prod.outlook.com
 ([fe80::8ac:a709:c804:631c%6]) with mapi id 15.20.3021.024; Fri, 22 May 2020
 19:47:38 +0000
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dmitry Bezrukov <dbezrukov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: RE: [EXT] Re: [PATCH v2 net-next 01/12] net: atlantic: changes for
 multi-TC support
Thread-Topic: [EXT] Re: [PATCH v2 net-next 01/12] net: atlantic: changes for
 multi-TC support
Thread-Index: AQHWMBHJUGOgDEsRvEqcguvmio8sVai0ZRGAgAAc/AA=
Date:   Fri, 22 May 2020 19:47:37 +0000
Message-ID: <CH2PR18MB3238B6DC3153AF4A38038454D3B40@CH2PR18MB3238.namprd18.prod.outlook.com>
References: <20200522081948.167-1-irusskikh@marvell.com>
        <20200522081948.167-2-irusskikh@marvell.com>
 <20200522105831.4ab00ca5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200522105831.4ab00ca5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [95.161.223.64]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: adea4647-5da9-4ac4-57d4-08d7fe88fb66
x-ms-traffictypediagnostic: CH2PR18MB3269:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB3269945B079DBD5017FC6170D3B40@CH2PR18MB3269.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04111BAC64
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N+/ZErqPnr9h/jXJjavCufj1skNm79FRHBvyFQUEwpaYNR0m7GQsW4krjV1qTVx1KxX+T+JcSMATerFWOdZ4zlwIw6PXvA5TlVkO+TNVu4+78psjHYNiMftlskFnEJLSJff4ZVbmMl40kFaN2usRVGSGyDrhTt/C6pigR4BPH0EroB1rfjT19VRlUdj57P3VGJeQnOW5tgSJYyr/ABJBj5QLFOebu5TWf53wGpFMN5bWqFG6xDiMK4hitez465+gXrGfnjieO7NV/Rke3kQ88P/s4GfYYkRSdO7o1R42ZmmV8aCZq3HQhmyGPZmB8vy7I90kVPBoSlw8ujQcZcHlkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR18MB3238.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(396003)(346002)(39860400002)(86362001)(71200400001)(5660300002)(66446008)(8936002)(4744005)(64756008)(66476007)(8676002)(66556008)(6916009)(2906002)(7696005)(33656002)(316002)(9686003)(4326008)(76116006)(66946007)(6506007)(186003)(55016002)(107886003)(52536014)(26005)(54906003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 9fm9dpKY62V8DrjSORDkpcT7pBKXuicSuo/lUdPjr38BEvpnlmUGUHTijWUCLxp4ogMHPMwNbYW4tb4JYD6ioH8TDV/0ASZcJNWGrRQEARMf5nA2DUOf+lTRhRlsjtXMevTO0A+9lYXNoKPDBbsJHDNxeuXbQy4XjYLwW/H9+pfHBWwpJMLoBzsjLWjF+ofaq9cnoazVB5HRFnTbcnYgiV5nMBFz16O7lhFx4otSqpgnidHCbSAcnswGZMKIZAfJJR19FirL4QfKW9HO6rw7mFGEbvdMpVCmq1d4LK6ie9vavT1BXQ/X8pG5+fbLqHQrOyPBKXlRcSyyUplpcOGyedog27a2/PIG8LDhiYSkgpS1hoYgzraelFwWnajcIyRd0cDSQS5Vz9dtfbEerzIp/+XJdpu9hmXOYk+fHmQJ4E4qEMDIAFIGdOe6gbVAp1COOXKMwZfe2hON2tBdfhvY8CoSrNDsRkH8UGHzNqOzR7U=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: adea4647-5da9-4ac4-57d4-08d7fe88fb66
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2020 19:47:38.1101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sz+nmwBTpe56AZ/UH4MZzUDZ99J2QgOjgZqya/Sw9NjYD58uq1m6X25GdK1zpDk09qXd89XPG7wIW8zQgAAtanhVmghOkAEv/2VXzgF956U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3269
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-22_08:2020-05-22,2020-05-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thank you for the review.

> > This patch contains the following changes:
> > * access cfg via aq_nic_get_cfg() in aq_nic_start() and
> > aq_nic_map_skb();
...
> > * use AQ_HW_*_TC instead of hardcoded magic numbers;
> > * actually use the 'ret' value in aq_mdo_add_secy();
>=20
> Whenever you do an enumeration like this - it's a strong indication that =
those
> should all be separate patches. Please keep that in mind going forward.

Understood, but I've also seen a recommendation that a single patchset shou=
ldn't have more than 15 patches (if my memory doesn't fail me). And unfortu=
nately it would have been impossible to meet the 15 patches limit, if all t=
hese small changes were in separate patches. What's the best/recommended ap=
proach in this case?

> >  static int aq_mdo_upd_secy(struct macsec_context *ctx)
>=20
> This should have been a separate fix for sure.

My bad, note taken.

Best regards,
Mark.
