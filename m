Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EE9297BD8
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 12:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760979AbgJXKaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 06:30:07 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:20952 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1760974AbgJXKaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 06:30:05 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09OALGCO012357;
        Sat, 24 Oct 2020 03:29:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=DJQPhRAzXPC7iLTQrFIo54dQXfRhYJ/6ZYft74NPReg=;
 b=Z2MYLZHfnpQnwa+p8J4BlaPraclEvLwKK23pJAUuN+uWWHvPS8KTrDdv6n6Xh2W9iWks
 opCDUXsjoTf36kr8qowzYlezjgza8RgKoUCDsA79TRdvb/VHTxwN6T9czdHS85T3hlme
 OIwJSmfJy9lnYcSs7kZONXLxpQ79AyBAo32E6T8xBaIKP2niJVjn5QYEHOSqhA/JFCO0
 Cl60rvDRfUQqVzV9W9EECHhP3JBFiIiBuB84Sz2um6GSHLUzfLSLNM2Zt2dabC0zXhHW
 rBiUdAjqhb9VuDc/lFyoqdjcfWvpY0wH8EWgaOJbR6WbZiAy3WRvGanVj2muISxj5sa6 rg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0b-0014ca01.pphosted.com with ESMTP id 34cfuwrb5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 24 Oct 2020 03:29:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDBcBSaC0NO8W/T4irWy75w35xs75kdbPEUjTOzlcUSaqLXUQHw90vx1WPxVA+lZ5PEUtg3iJqGkcYlK+GOpB7FI2J+Z4fqrYylrZ/rexU0RKjZBx6xIocJ5XBjpYWEVowZJ/UtV70KLBv8rpoldCq76GI1X2yptyOS8LnvFOH+CVLUxMRhnLd5OeYsRQVLTTWZgpFPx7sIIAPOXOraSbyvrweEXV4gCOEoTpTuc+xdNMqDwt+yRDtuyxqBNs0fZWDR3SdWNIoCAViqoMUZX9T37ryau1eebiYuBBf+Rqgap/R4TB4S+BqyIwouwvlNr9D3rs74TbnGvrwicCgafzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJQPhRAzXPC7iLTQrFIo54dQXfRhYJ/6ZYft74NPReg=;
 b=i8AkFUoXmsdBzP8v3N4AkBqZFCFWBCYCpVHKvPJ7YTRQKMbkw1rjWfKF2Eo/ztOxB39Ou0vXHDGo7ETc1mQUTtcSrsnI65mHWoKoQuRFN+4aZ8dz34keESgOzVWftV5xAC2nsQUcrz9ZW8kPGjzlW5nDLPc+5teE/+YlGJOR6/sOSjaTGvkzF1tFLNvmPQRu00AqJD526IiQTIc94n+Nb8hZi2No8IuGmVUR9NoIMOoRIv+FyPtXb/5BPNlscgZLp6aqHnOwU9Qra0w7rVxk41Pp3nI4vcrMmdXmK7kd9wjcCA6CTHUnVdfnKaUOpo4ycriqHGlLWhMkfISWXy43Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJQPhRAzXPC7iLTQrFIo54dQXfRhYJ/6ZYft74NPReg=;
 b=voPDCEEJv9N9ssviz4Fz/YoCt1ngQ3ej4t7Uvw/J56M49zkZXQd5myeHGYxOn04ByAb5BUVrME9QhXygzI3A9N0QIKLv1f3WdVgYmBFQ7FrN2c0MW8qlaGDYsqpHDfJ6yLg3pqYHPQ219M5D7E0ef40INfTBcPCu+BLUFptU6Ro=
Received: from DM5PR07MB3196.namprd07.prod.outlook.com (2603:10b6:3:e4::16) by
 DM5PR07MB2796.namprd07.prod.outlook.com (2603:10b6:3:b::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.25; Sat, 24 Oct 2020 10:29:46 +0000
Received: from DM5PR07MB3196.namprd07.prod.outlook.com
 ([fe80::e183:a7f3:3bcd:fa64]) by DM5PR07MB3196.namprd07.prod.outlook.com
 ([fe80::e183:a7f3:3bcd:fa64%7]) with mapi id 15.20.3499.019; Sat, 24 Oct 2020
 10:29:46 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "inux-kernel@vger.kernel.org" <inux-kernel@vger.kernel.org>,
        Milind Parab <mparab@cadence.com>
Subject: RE: [PATCH v4] net: macb: add support for high speed interface
Thread-Topic: [PATCH v4] net: macb: add support for high speed interface
Thread-Index: AQHWqVKsSi61OMBGz0qjv35pPpVjTKmlWZGAgAExlWA=
Date:   Sat, 24 Oct 2020 10:29:45 +0000
Message-ID: <DM5PR07MB31966ACD385290E44A8B960BC11B0@DM5PR07MB3196.namprd07.prod.outlook.com>
References: <1603467547-27604-1-git-send-email-pthombar@cadence.com>
 <20201023160355.GF1551@shell.armlinux.org.uk>
In-Reply-To: <20201023160355.GF1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1kMzFlYTgxZS0xNWUzLTExZWItODYwZi0wMDUwNTZjMDAwMDhcYW1lLXRlc3RcZDMxZWE4MWYtMTVlMy0xMWViLTg2MGYtMDA1MDU2YzAwMDA4Ym9keS50eHQiIHN6PSI0NzIiIHQ9IjEzMjQ4MDA4OTgxOTMyOTQ4MyIgaD0iaFdUN0VtQVhJbXlzMFRaRDdCWGdrUi92clhrPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=cadence.com;
x-originating-ip: [64.207.220.243]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e06263e-91f7-4639-5eeb-08d87807ba68
x-ms-traffictypediagnostic: DM5PR07MB2796:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR07MB2796762D5B1016CBA002B53AC11B0@DM5PR07MB2796.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pj0UEvmMMj7OeuYtVyllHP/0u27ScDQ3D1QmtIyjzW5d+2WgQhA3WPp6wtnuTS5NZazisr6BIjVRXZwlUny4nxZPKUP9Pg5AuDbmmmDSFAOXHjGQSEqBgKpSQSDCCN036+W6TPU1w0sC08N7Ohyy2KP3TBT5mKwSINUDkgeIlnUrnSRnzljKi3Dc7hnzDGPA4wvtC0T8ktbaXf00R5ycthLxEpRhIF0PsiVO4n93n0QpdbliomkDAbZBnj3oBApfI9plRNdl6n0bRgMLjBCrRAZgM6SYKljELnT9353T3egnHtsQXTU67U7etLy9kNeCBTsQA7tin1MVJIZ502bu4gIZwUAARfKTCM+OtDX1lCgOn584C9OmiXX81C8swYue
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR07MB3196.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(36092001)(55016002)(71200400001)(4326008)(9686003)(8676002)(7696005)(5660300002)(8936002)(26005)(107886003)(66476007)(6916009)(64756008)(54906003)(6506007)(66446008)(66556008)(66946007)(33656002)(186003)(76116006)(4744005)(478600001)(2906002)(86362001)(316002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: S7dLaC1VQjFzg9Q6ulPMnO3myrr5dbkAUukj72R3u9hhRkjVS5dWvWar+cjSHcbHokFsp9u+2NLTxUiCWi/Qy5b+mlM6L2JFRPig4ajjB3B0HWRf6ixfqw/oRPzpciyIbByUZvL2UyINlDCeUe7rDkaRz+ZwXaIfA87lpIzhHyNKmM428kDugSZKit1H8us+41sg/tDv7iOpIUDAk3VcLJUbOUjQRsbB7eV2BTQpK41fXBr03cFjEX2Fg28icRtdApu/kfC396ek8YR4GeMivsBG2OqIIYKUqOhJZE9uy10/L9AuomUa8AoHHKNDcl98jg9aVBKZGquRJ5B68Au4wEpSxxCL8LGzDerU+bLtKMMAeuFbidUNZJHBQhRa0egzda9kKDf3PXS12v3M6M6TfZzIUCrHA6RR7W/ggtl4W5zDEYPA4/EW2igdPtUegPJ+c0PERYnxSzB2gKOu9re8jOgvRU0od3tKxy6vHlv4+SCmckaIS2CHa/8v7nSU/NLbqi5Fn9xTdSrld9788vUJ9LcTYzl+W7EBGrp7CmOXruHAkpRwW8B3OsWVWyKpgTQwAV81YbVpNEPTw2SJBWOAFoH7VgPXqi/W19jJOa8mOGMAimejxjIM37HlmMRYo/Mz1PmzE7VAIQZqD8GMeA5TKw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR07MB3196.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e06263e-91f7-4639-5eeb-08d87807ba68
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2020 10:29:45.8292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PGIuVgtx0vGjpHiKqAWsWpObMrMvrTVAYrbMn2cLe32tnL3QL1xrgx+aenzEMgb/eZlq/oLbegwret0Zqbd0a4oTJwnxNAC+XnZCbSKqsF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR07MB2796
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-24_08:2020-10-23,2020-10-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0 mlxlogscore=608
 priorityscore=1501 suspectscore=0 spamscore=0 adultscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240076
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>If we configure 10GBASE-R, then you clear the SGMIIEN bit and then
>enable the HS MAC. Can we go back to non-10GBASE-R after that? Should
>the code reverse those actions here?

Yes, when interface mode changes, SGMIIEN, PCSSEL and ENABLE_HS_MAC
bits need to be programmed accordingly. I will make that modification and
send next version.

Regards,
Parshuram Thombare
