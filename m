Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC282A662F
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbgKDOQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:16:12 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:11170 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbgKDOQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:16:12 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A4ECxf7004985;
        Wed, 4 Nov 2020 06:15:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=126MJZnPmoTYHiRCApDiB8dtkCZpH1wOqjRx01xvIXg=;
 b=RGWRRzsy0bcWgCLa7eH37gsMUtlPr5gHUt9A8r70rLpAsNdRCaJNVVzxL4cUhSfbhVRK
 6kK5/6o5Pq07skkDtE+hdY0cNXCOnBiOA0JdusIfTuhAzK2/Ae4HmYK4oILOYIrI0WiT
 /pyg+yequjbsaWYjCe54kRw1vpFu/cejA4wfv/WFoV0CUwVHmecL5z1kbips6yapgASE
 yC1TaVKxKmSKr+8iWfIPGgtlQltQoh0wF+NFsozm+u3cKPVU1/p021cUw4id/kheEomx
 ucvTHM+7qLmlzIlA9DzTc3ZUTVSglF1n4tBIgIuUAUxspadadtc6pn0vMNphrDH41+sA nA== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by mx0a-0014ca01.pphosted.com with ESMTP id 34h4fvg33k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 06:15:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSfWUtyh397KspkaAenAGMtQjcVU6d5b1sEppwBog9xTL7HGc0s/pRi5XgvREB3t/ewAtzFxdnsZMFp8+NVtGhvq3QgXuppjtOlQzt3FFL7JXyn8iBudp39SErinCdJzzBsk+Pdb67juTtrHzXotY627bjtdwzdX4QzRNB28MSALYlQ0YT9NxbUcYXYZtCZpvVl2YZsqZnCmKAUHZ9Y937kWMcN/c9itUbZ3DONmPeX4GIFaBqjcMZPPdBLVWhKVKjLHUnSXzEbE9QUhgi24LMOw/QCwgT/6mwjjE6uIsPaiRV78JEgHt8llwnh01CochnPSeSWVVFFF0wonIDBRkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=126MJZnPmoTYHiRCApDiB8dtkCZpH1wOqjRx01xvIXg=;
 b=BcdpTxLWGl9vRfoFeTEwJKErJwklZmfXhqbYJq2PcaxUsUuUGAOeQoL3WuDgt6SisfEjSTqC9ejiu54zR4noCiLBsLpLHz6jnDn3xdHhjmlRTLeEVbxFdcVT3vKsSkQ5/8SNkNYk6v4UVHCXiZHQcF4yztmXtSKHocD3TerBkcJKsh03+U3tc1bkSNFuGw3/ZbEjt2QleQRcQEwDZxQ8zrHgbdJS9JMOn01V2VrcTbwZrKeZ4IxyXhWf42ETFrlnVc6EgTpY7ub3+nNbU5BwThlIToHWZFPQBM3wbJc0tl9rE/s0hAX5JMNM4cptsiG9z89OvTJkNuFPIUVC7e3tLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=126MJZnPmoTYHiRCApDiB8dtkCZpH1wOqjRx01xvIXg=;
 b=OLVCybdMQBuLazN83N7arfKJq24k36yUTZEpIpz6cNo2XXVj71R5Qspfh5dBmwhkB3RZ6jKPvh27DTGg8nYyoh0ZadqwrXGBeQaIRE1lT3dWa9I/EnecaHuubOsTwwmT7eXcdF5curoDa1Q7rrSLsMz3Dopw6JC4LrkULR/ldFU=
Received: from DM5PR07MB3196.namprd07.prod.outlook.com (2603:10b6:3:e4::16) by
 DM6PR07MB6332.namprd07.prod.outlook.com (2603:10b6:5:154::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.29; Wed, 4 Nov 2020 14:15:53 +0000
Received: from DM5PR07MB3196.namprd07.prod.outlook.com
 ([fe80::e183:a7f3:3bcd:fa64]) by DM5PR07MB3196.namprd07.prod.outlook.com
 ([fe80::e183:a7f3:3bcd:fa64%7]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 14:15:53 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Claudiu.Beznea@microchip.com" <Claudiu.Beznea@microchip.com>,
        "Santiago.Esteban@microchip.com" <Santiago.Esteban@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "harini.katakam@xilinx.com" <harini.katakam@xilinx.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>
Subject: RE: net: macb: linux-next: null pointer dereference in
 phylink_major_config()
Thread-Topic: net: macb: linux-next: null pointer dereference in
 phylink_major_config()
Thread-Index: AQHWsq6BvPM9dPOV2Uq2LXB0FhVdIqm3+1wwgAAIARA=
Date:   Wed, 4 Nov 2020 14:15:53 +0000
Message-ID: <DM5PR07MB31966C39424E0DEB4A5C5F6FC1EF0@DM5PR07MB3196.namprd07.prod.outlook.com>
References: <2db854c7-9ffb-328a-f346-f68982723d29@microchip.com>
 <DM5PR07MB31962607B69631EC5F742A54C1EF0@DM5PR07MB3196.namprd07.prod.outlook.com>
In-Reply-To: <DM5PR07MB31962607B69631EC5F742A54C1EF0@DM5PR07MB3196.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy0zY2U4Njk0Ny0xZWE4LTExZWItODYxMS0wNGQzYjAyNzc0NDdcYW1lLXRlc3RcM2NlODY5NDktMWVhOC0xMWViLTg2MTEtMDRkM2IwMjc3NDQ3Ym9keS50eHQiIHN6PSI5OTciIHQ9IjEzMjQ4OTcyOTUwMDEzNTM2NyIgaD0iVG13VXRlSTNZa3NnNGJKbVV2WCtuQ0FNU2pzPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=cadence.com;
x-originating-ip: [64.207.220.243]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e63a7d3-22ac-404a-40d1-08d880cc23f4
x-ms-traffictypediagnostic: DM6PR07MB6332:
x-microsoft-antispam-prvs: <DM6PR07MB633298496CAD28A6104E3ED1C1EF0@DM6PR07MB6332.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xWzvZWT4NQrHu45AFvW1aSyneYPd/ryxh9LgSODfNiWDVIDHU2zGUg3njuLFJOCS7YttQIHhUAYUo0re0oF658zAnWTTPxA+Ias9VTu86o4/T+BYhqOmgCqh0tIAz2pd49bnGMz3ixX44yVRl0M+nJao3u2DM4v9iCjxQSr45zo/+PiBv5Roy6XycF0WjcvpmAou35Y45MKZ0s7NfxYyU4WwF5OFREQLAljk4YFEj+JcLDnJ88g4G2P81K/byWuNuOCLyPbQpadi6WJ/xu0jDSggjo9P9elMcKLchozXmfVMKeWTls9Wu2LJYuJAYwQsLypPFZjO3Py5l9uCOAye/baDPHl4CrMUuTniXoHEeLrpl3fVbhRb6iw8lReNFx+9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR07MB3196.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(36092001)(2906002)(9686003)(186003)(7696005)(55016002)(5660300002)(8936002)(8676002)(6506007)(26005)(4744005)(33656002)(86362001)(52536014)(66446008)(66556008)(66476007)(64756008)(76116006)(66946007)(2940100002)(71200400001)(4326008)(110136005)(54906003)(7416002)(478600001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Dw3/sTM7g8BGMLIF8tjyZDMeGfvzHCBK03lMfyahUJQutgTiXa2v0aOc9B314pYfixJqy9QwoRJeysE/1OiwRqBtKyud2Fj9923Fvm/g7e9zyAtZ5tYlQLDSwIGV7C3Lw/atWknpCb2cgUFJFFRW37i4ULLN4SyaWecnLA9bMhE7F7GZ0yWku5LltoH5765InY3DdlPxwJ5JsPS3omp0oMrIYdaqAo/WtE5Nrb/LdAgt3Kxtpc2OK1U2aZjobS9yGgRoir9EgAU+lEmPV2Cw/aOdwPsw0uaE68uF73uf75jS253hEiKDH1fBtz/nvsIUsAf0V7Y5hHWEc/CPQmrbO22ukzrMJt15p0ZXa9/T6D3f1ebwp7HNXX26OmJdxlo5CZqO9WmlL+MXVf1Fo+YeqPhy8xQAA+5/2uq7rZiipccNSMdbfq1x33If2xG+cymY3xPcSkBWIVuWNoHu+vWagP8S/YiZ0RvvIocbcqxiQD9bQq1+fGmBs/x8uXqs1iD7FrCz21xFWcJOJDZUs4ZxRwzOJgRhU8cYibAFlZPpSjy3hNwWfy/KjFuHi2/WHVbVeSvER+7PvrBB7NOlPMuiYmc8KUHfea+Z3l+CfBGug9xW5fDvuofBGPMxjTqiYYRp3530yHH5v6gWLrNxs4IBqg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR07MB3196.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e63a7d3-22ac-404a-40d1-08d880cc23f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 14:15:53.6739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IdKMvUvidTbnL4ucrME5fub2fc+LOKZsuL9vvgjc0ghnLelk2IHPJziEev1J+2LXxwMQ72KMdR9NxBdRAk3OAQHLso1q3plLnnNyKv/tGDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6332
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-04_08:2020-11-04,2020-11-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 phishscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 impostorscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011040107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

It seems apart from changes in driver, we also need check for NULL pcs_conf=
ig
below or make pcs_config as mandatory method for registering pcs_ops.

456         if (pl->pcs_ops) {
 457                 err =3D pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_=
an_mode,
 458                                               state->interface,
 459                                               state->advertising,
 460                                               !!(pl->link_config.pause=
 &
 461                                                  MLO_PAUSE_AN));
 462                 if (err < 0)
 463                         phylink_err(pl, "pcs_config failed: %pe\n",
 464                                     ERR_PTR(err));
 465                 if (err > 0)
 466                         restart =3D true;
 467         }

Please suggest.

Regards,
Parshuram Thombare

