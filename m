Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D2D2970A0
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464920AbgJWNeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 09:34:24 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:58550 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S374889AbgJWNeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 09:34:23 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09NDXh3f006708;
        Fri, 23 Oct 2020 06:34:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=qpHezhoznFWssT1rcvo5yXHLsx0wKw6m2fxclRNSGJA=;
 b=pHpen4C4bNm2vjw4TzsktJuIgHWA8NfYInWu6Ruy9wPGT6W6/+F4pDj/Yc+yQ0bCg2OD
 6vSbS0nY7OMGu7WJl+5c/U50emXiTxJPwwmxUkUu1/wx242QdlYlgZVxs3m5VrAggKxR
 d9t/ZcuSnzG9oKOYYC9ZSGj6SqA8ackkVy/vrCe83xoCZkx2ejc2EL7YGbVRtASMdarQ
 2y78+H8lJKK9HIZdVXj58/KmgKWBEOiXNqI6edNI99IZQd4u8I5mj4Z2s1/mIg6zbfRh
 AR110xS/za7Sr6PPlQj2w7K3KtX9X4w2rfEZDuoGa2PzFMqWUiKumSgIl0MHCKJFNcxu fQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by mx0b-0014ca01.pphosted.com with ESMTP id 347v6yshj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Oct 2020 06:34:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdRdAgTuLU/RbDFj3h+W9ZEmGYKhlcfibWRfyEXu1sL+/pMj9ZH1VhV2n6jcgoJCPItzNhAbkKNr+UnIXrUWKJSy8+eWhIxjiJyCCrJFWASrQMGDqFuQBzATqr9F2Scrqdgzo5sYiFjVw4cd28NA2dv/fbgVJV6eJEKfrK5+cV6d0QdvedHsuP6sLeoQhgEDr0ENPQJoQcDJpzg+qeEhxQs+HTPuhe6YuQwG7Zbx+OeedX6IXaphbfeoAiKk05zDbKTsHiIOw6a5K/bKLKxZyCrI9lB+YZ7pbJ2bTpE9LzKdsJ6rXKSAVLlq1w0J3TRPkTavErhxHzW/a/DAibdfTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpHezhoznFWssT1rcvo5yXHLsx0wKw6m2fxclRNSGJA=;
 b=Jdoh0YjMfUgmVvurm4+02U2vnBcDreIllXzMlunyEwfQ1+EPQqsaVQUMdpKbaeEUBB6PcufEEi0kXm0ve43M2Zw8x39CFLhO4R/292y+nn+F+Tb5cLEio5f5Jowm5O/Yuj0+LBzxIAR4a3s/x9iqvRFatpdtjZMzqiWbhzJdHuVNcO2lEntszoBIlj6o44MchFdBgnrWWYRY3f7+/HdHYbwQzHFx/DhTsvb2RcZGsd/sEPnqM3oqV8auAUjj8g3Xikj/nKyAySLJ5VRLPXCfp+rqXRisQLvwXqnZc5j4YMaGw5MUlmqJ3tiAI9vQgtiYV/+MfeD+s/P8u0SacyPCug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpHezhoznFWssT1rcvo5yXHLsx0wKw6m2fxclRNSGJA=;
 b=rAhAUuyOQT54nvY2PJb3NGKdU0AvOI0aVDmhMaQmKhbBAOpH3CS3+uU5tVijxTNY58spoDx4S3Cjoh4+MsKYNh0qPpuRMDXjy5QVJmfb4PVQHnW25J5/JcuG34fvX+7ALPwFlCB2/Mabel5uuAExW4T/Tao6qnX905XB/twE8pI=
Received: from DM5PR07MB3196.namprd07.prod.outlook.com (2603:10b6:3:e4::16) by
 DM6PR07MB4874.namprd07.prod.outlook.com (2603:10b6:5:a1::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.18; Fri, 23 Oct 2020 13:34:10 +0000
Received: from DM5PR07MB3196.namprd07.prod.outlook.com
 ([fe80::e183:a7f3:3bcd:fa64]) by DM5PR07MB3196.namprd07.prod.outlook.com
 ([fe80::e183:a7f3:3bcd:fa64%7]) with mapi id 15.20.3499.019; Fri, 23 Oct 2020
 13:34:10 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Milind Parab <mparab@cadence.com>
Subject: RE: [PATCH v3] net: macb: add support for high speed interface
Thread-Topic: [PATCH v3] net: macb: add support for high speed interface
Thread-Index: AQHWp9HS4UctazNdVUWuQbMULgmNwKmiZpMAgAEAG1CAAY/28IAAGDyAgAAhBDA=
Date:   Fri, 23 Oct 2020 13:34:09 +0000
Message-ID: <DM5PR07MB31961A008F4EFA98443E63C6C11A0@DM5PR07MB3196.namprd07.prod.outlook.com>
References: <1603302245-30654-1-git-send-email-pthombar@cadence.com>
 <20201021185056.GN1551@shell.armlinux.org.uk>
 <DM5PR07MB31961F14DD8A38B7FFA8DA24C11D0@DM5PR07MB3196.namprd07.prod.outlook.com>
 <DM5PR07MB3196723723F236F6113DDF9EC11A0@DM5PR07MB3196.namprd07.prod.outlook.com>
 <20201023112549.GB1551@shell.armlinux.org.uk>
In-Reply-To: <20201023112549.GB1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy02YjRiMmFjMC0xNTM0LTExZWItODYwZi0wMDUwNTZjMDAwMDhcYW1lLXRlc3RcNmI0YjJhYzItMTUzNC0xMWViLTg2MGYtMDA1MDU2YzAwMDA4Ym9keS50eHQiIHN6PSI4MzMiIHQ9IjEzMjQ3OTMzNjQ1NzcwODIzOSIgaD0iTi9nSFNhRG1XNjRwdm5VY04xOTZvMEloQlB3PSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=cadence.com;
x-originating-ip: [64.207.220.243]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 397d7b56-9c1e-4c28-ed03-08d8775852a3
x-ms-traffictypediagnostic: DM6PR07MB4874:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR07MB487499E346B5B3663FFF1AF3C11A0@DM6PR07MB4874.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3vSIU2KK2rhPf5zNHZ3KpVE7S/iTvf+KlkkP+9VxgCKxZYsp+gQSv17o0IzbFi8y89Q+DSLal7DPxGgTj6aaOAONzxpsBxlhayNWGDurhh/kwDtV0bKcH4GMtc9aueagZa3WZElk0nr3/DRHtQmc76GcVP0Xz290hOAVFNiYC4gQCTBqhVhLIy5+LbLKyP0ZqW2iuXKym9eh0Y4OBE68uWMBLAAXBu+V+42gqFUpMtoEEvs6dZtFH0wns/vrxilI1K80ao4WXTzDJoXUXxxxI3qtwVX9Ym2EAPbf1+QGv4XWhoVvYCKBk6bae3DnYR0BPS1ruMr42njAXtOwanqp/qtohXV+tiKpIy7G8srPtLw2FPwqRCdRrXqIs1ryIxmQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR07MB3196.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(36092001)(6916009)(8936002)(55016002)(66476007)(9686003)(71200400001)(4744005)(8676002)(107886003)(2906002)(76116006)(52536014)(5660300002)(66946007)(66446008)(64756008)(66556008)(6506007)(26005)(478600001)(54906003)(186003)(33656002)(86362001)(4326008)(316002)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: iuXdcKjR/SSSTcFkJpNEMQmCxmlqwqKC271er7trwSdALWsjeXYPCamvSLBckpfY0erC+0gs2RhvHUpw/f4ZJTvYZcwqSM3/lcPO1egeez3v3Gi0qkBo8n0SKC/shy7QqvqFZU5YsLapyeQkWoHq1pn2GnR6YYdvdAUMTTQ0XMppixk1f5Yc98RUZwhDADIkW/3DkXM1OMsZsRbUp5iTh287AJ2ChfX0PRsBx8d5GOCzFFz/VcuPgYenV5uRCLlMF3PyuTR+3e/47yWHC52BhC0NS00s1cgn3+yki/x8yigoY8RDvzDfx07JPZu4fSDnyaCjKrVQCzgZ0lGip3GFdCXKqAouk2EoC+7SOPrzVO9jLzXKiIny7ya24a1W4X222oymvsPpaUhv3241FAK6X5UjJhxMELkCbaDG97+USZY5XrtcBp6QNEt9t7fFm6TU4vS+EeAEN+gDLCneg/tsgeBisIWkIde93wEFt4DWi+/wzK9SwQVYPetcbeK6Xu7rYSG53b01LXicxquJlDrfux7IK4k+ABoQV4hD/Gzns9GbJwDHiHUXK7wAj5YfpICdnpkhNdG1np4y2CzWskp8Y+/bxZ2iZ9Ske2Tn6hGyuy8NPJcp4WSPzDUTdEdaQ1+kqhJXtDcvxiucTf6oWG+rJQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR07MB3196.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 397d7b56-9c1e-4c28-ed03-08d8775852a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2020 13:34:09.8847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o/8YQYpfuwJoc57tdJx0E9MPoTiUcC/ac6ml1sv5+OUZVMHeDg1Ihf3i3BKYzYG+/rdAW7bW1h9RkPs30C01UxFxJgxo4d98pyVF0GRbiqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB4874
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-23_07:2020-10-23,2020-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1015
 mlxlogscore=754 phishscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Whenever the interface changes, we go through the full reconfiguration
>procedure that I've already outlined. This involves calling the
>mac_prepare() method which calls into mvpp2_mac_prepare() and its
>child mvpp2__mac_prepare().

Ok, I misunderstood it as interface mode change between successive mac_prep=
are().
If major reconfiguration is certain to happen after every interface mode ch=
ange,
I will make another small modification in mac_prepare method to set appropr=
iate
pcs_ops for selected interface mode.=20
pcs_ops for low speed, however, will just be existing non 10GBASE-R functio=
ns renamed.
This will allow us to get rid of old API's for non 10GBASE-R PCS. I hope yo=
u are ok with
these changes done in the same patch.
