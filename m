Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BEF24E22F
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 22:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHUUh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 16:37:56 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14834 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725834AbgHUUhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 16:37:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LKU2kx030405;
        Fri, 21 Aug 2020 13:37:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=1uziaX5/JOBQ5auyBV9ARBWvD8p56oppsHgXKVUKFWQ=;
 b=Og6BbsqVI1Y3Pw1V+z0qUJCfK2ppsTW8y41Q4EBM6W9g8ik2f1GRqLFBGlngJDEV7XoM
 qmxFIuhZu2YTERSuQmkLVQgTtb++QYlUH33YjWzGKAedg0st9PPqtVHLa8SO3bejg3w9
 5ygkXjt+jrCn+nLqTAYoRhKrIQoLO4Cm9N5wx+tQsQcsqqSlmp8ffkTZlr8zXRrG7bv+
 7+03m88tAaiBbjnZ+NYauTAYr2sYVxnu7TlU20PgF0gU3jcNEo4SHkin3snVYMyxo3X1
 crB9+7PfqyaqRrmoYc6eY2avFH3OqqLfvwu6TqsatWf5x6RKaE6qDbCNxSOmLc63u04k 9w== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 3304fj4myj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 13:37:51 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 Aug
 2020 13:37:50 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 Aug
 2020 13:37:49 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 21 Aug 2020 13:37:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4LhxBST/bV2MyFpUsjIG0I8pKJQ6I4jsp3wk8CHKAHJEwsybIP6HQZPgL7LTZ4s9IIiYd+EEagSLb4NBEz8QZA4OsN9pOOPFLrN2SSlaedgiB8cOV/tbKbgKqKfTzfxUKC2FY4tePm9LadNdYT95WOxGMh3XReQxa4epQc/3WwSdCp1vDZ3rbEEwV/LVgE+NEA2HbKF89sXpRYaFqweYY0Gi+InJjCmtsLCxmur8MGGg07W9ipN31exmboQ8s4DnZ8VXi8NZ7k3rtbXODrDmRt/6xEvF5DDk/DpqKP/xWvZbAlBOdx2AOxH/zVFdRJRoiw9FzY1JIool3BSLU2Bng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1uziaX5/JOBQ5auyBV9ARBWvD8p56oppsHgXKVUKFWQ=;
 b=EeP7+fne9W81itppyBrM78STFtDAJJMdRZrRI4Be6v6yTYGO5YV9r7/IYqflyv/w4ofQS215vtu1d3b0eSH5QUf5amcjbW01PF4n0ACrQiQslvio8CR86N+uBmSO38W69szdXnSZSuHtyDrZahvBg1F5ralIYfFYYeMyUqFBy00pTGF26KB2vweY4pVPMzhYMagVD5ntzpRH4ThjVPHR/ZgAysMaTxgBdU5emb1CJsafVk35QZgBLLYX7txusfTvqid/ajNxTp9knb7eTdGLIZ0XxuTuUJhBAMRlopcNuQS/Z7eCHoOeFLy9Mo2gDysNLhGQ5tRo9Lxg4J8VqZA4tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1uziaX5/JOBQ5auyBV9ARBWvD8p56oppsHgXKVUKFWQ=;
 b=qwV8MdtwNBgxoxgmDVueXgC2iTZmWuXRVl7qaX+vLwzlNYIsVHFK1wbqHzbmzu+gb8dKxyy3Z7dr+cJUd242KJkQbC//1BC72Kd5RlonomdsuFcAg0PSeLgJq8o5SRAo/wFgqjjfvK+XIwgsqieGWlK74F38dThaqKV8zcY+gJQ=
Received: from CY4PR1801MB1816.namprd18.prod.outlook.com
 (2603:10b6:910:7f::33) by CY4PR18MB1349.namprd18.prod.outlook.com
 (2603:10b6:903:147::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.22; Fri, 21 Aug
 2020 20:37:48 +0000
Received: from CY4PR1801MB1816.namprd18.prod.outlook.com
 ([fe80::5f0:b1ec:580e:cb4b]) by CY4PR1801MB1816.namprd18.prod.outlook.com
 ([fe80::5f0:b1ec:580e:cb4b%7]) with mapi id 15.20.3305.025; Fri, 21 Aug 2020
 20:37:48 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>
Subject: RE: [EXT] Re: [PATCH v6 net-next 00/10] qed: introduce devlink health
 support
Thread-Topic: [EXT] Re: [PATCH v6 net-next 00/10] qed: introduce devlink
 health support
Thread-Index: AQHWd/TczDsbR2gRd02EOWT62ZpIlalDBZPw
Date:   Fri, 21 Aug 2020 20:37:48 +0000
Message-ID: <CY4PR1801MB181650AF3451BD2D9CC54292B75B0@CY4PR1801MB1816.namprd18.prod.outlook.com>
References: <20200820185204.652-1-irusskikh@marvell.com>
 <20200821125410.00005c08@intel.com>
In-Reply-To: <20200821125410.00005c08@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [79.126.41.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07ece58b-d255-4c11-abf8-08d84612110b
x-ms-traffictypediagnostic: CY4PR18MB1349:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR18MB1349A4F5690B81CA8646AE87B75B0@CY4PR18MB1349.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x2QZ2QA8V1tGHfyGSZF81USL8no67BgYHF+3IzoWjmJsHEKg3WLXwNMX0mdJBjG4JXiF3vcY1a6G3Mbr0gODmenOiJnhtQBNlag2zaAlbjv0maI9HICaK2ydprToC+tHYhncveb29ZuVBSInn88cHv6tFPZUDyxvD8QJIe6nB5xoLFrQR/6cH8bGUH74+X7rDIUVp9Bs/gGwawBckqIArRe+2oVk7Zo62a7W+Rd4f7lEQF2r7rYSDmU0ycmMLAPDoj2VMo/1oZVIRD8Oy3jOpE2Pvx4yAPxpSkGEkHVm8mPSfy7InzM0nXVFpqV7uydE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1801MB1816.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(54906003)(4326008)(71200400001)(66446008)(5660300002)(316002)(8676002)(8936002)(6506007)(76116006)(55016002)(83380400001)(7696005)(107886003)(9686003)(64756008)(86362001)(52536014)(66476007)(66946007)(6916009)(33656002)(478600001)(4744005)(66556008)(2906002)(186003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /G98Uhmf26wy344dMpx9pkBUHeiznO6i/Qv9m8O/n8/lcD5E4kIFHBjpkJ5DbVG9kpkKj9Xi8JfVzvL6uHlct6JYQBz2AuakdKWdJniqbiTqycLZjXcQWJEl8f6CWnY7vRaLDiRgeZ2+/n/K324CjqKNcQs3WFXDPMoUvhEN3AWBV//D6dEdvXlM6aHNAcccvn+kx+4hX13GtUaGOKuKZl+V5LvRFiKmlsWS58/3orhmDdxPbdKXj6sOoF602f8OtaX1+KUMW4oBrMApURGK3EYmYdEb5hG/RaTimCrY55yN9HbbQgSOkir/mitDF1hoCUfh3pl/8WO2D2Bv1AnyqxvVydERD+pVuOKVpOxkKxQALbwSODRv/MYZmJ+mWekjvycC3LTjMbQfY6kz6+ruW51MNkPe5w2KDHsdIGFkVQaZ+ONVBB1o73kBkk5s9qRbP4gDtHyEJXP/z00J43CjDdyIgKdsY2fTxvzBeqoaQBW1YUfC+8NCzijYOH42YmHuOY3cFhtaklC2NpsYGsxo8Vs7LerNXne1DO2rtjzlCFcOzTN7RCm3SOqdCFPV9esGKj65GSoBpsxOpp2h01OH/lcGRCytBAx8lnmy1r/spe5NkcDJ/hqomnDgp5ZTCM76816nWY1hCOBpwhpfz0szaQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1801MB1816.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07ece58b-d255-4c11-abf8-08d84612110b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2020 20:37:48.0419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o5sXbhq7YhQxEKB1rznPGW0QIVz38ngyq9NF25++IjSKknG7dadhKbxbRWSiLi+NsUmPwTYNNcn2hXCO72ttCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1349
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_10:2020-08-21,2020-08-21 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> > v6: patch 4: changing serial to board.serial and fw to fw.app
> > v5: improved patch 4 description
> > v4:
> >  - commit message and other fixes after Jiri's comments
> >  - removed one patch (will send to net)
> > v3: fix uninit var usage in patch 11
> > v2: fix #include issue from kbuild test robot.
> >
>=20
> I think you're really close, please address the two patches I had comment=
s on
> and then I'd say you can add my Reviewed-by.

Hi Jesse,

Thanks a lot for the review, applying the comments, will resend.

Regards,
   Igor
