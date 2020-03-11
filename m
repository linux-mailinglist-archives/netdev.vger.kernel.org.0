Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE35181352
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 09:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbgCKIgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 04:36:23 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21598 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728852AbgCKIgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 04:36:23 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02B8Z4jJ002832;
        Wed, 11 Mar 2020 01:36:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=aqGHY2Gcm8l8l3ur5qb2ltIHWk8t4SQV283iktFBlmk=;
 b=SZjkmFkVtCKAtsbD5UwonH0vnYuEx0MuD5zyhciBI2DykJtI/HuLM8YM1MV/wK92pVtT
 osVqU+VCKCSg8SuGbfGreh/OBMJTr8BowSyUIzkWx8Eu2UR/7ZMiAG26geLBihoHQ0+v
 fE2WhEfFbVWrJKaIBAexm7ss3TxYod0VXSA4+henqTpIQC7NcMEgYIz2ytTrrvPZXUUW
 LLATuQxCNeOBrXUP9d6Blpcao6Dzbcfho5aJbJ7srojcBcziyon/5RgO/MFk185FHdm+
 tiM41Z8R+eenhm4Da3fF6xy7ML3Fe2LPqrlFMRLXadGTWQkwwZcmkdyji9EoWUdibX4/ Sw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ypstsgykx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Mar 2020 01:36:19 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 11 Mar
 2020 01:36:17 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.58) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 11 Mar 2020 01:36:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Is0J5zD10QRMk5D8bk52EqzFFErtppcrW7ykmFCbn2cPL1u6sW+TO/J/obHFQv/IBeN6uToFFuIG4CYZ6ktx4K7LB1E7HwhHynS2dCgQVogS6xuUa2iBIRgGFXI67F/KUx8NH7ni4LZ4b8/7yFDI/jD43cTSqpzVM2uyuAcBFCog/Im6GupjyVIfYfMGWPmYqIjrcQtYYgSeme68InlkEI1JeJs0MvFUJGTzs0q/zN+PJ9uwaxO6zpG9TGn+J2we3wP2XpEPy6FghCFWXRd17bHp18RB/64hOQ5h36u3LKVmF+dUywUwBeWGflFpkfBeDj/M7BE2ROTyOL++fKQG6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqGHY2Gcm8l8l3ur5qb2ltIHWk8t4SQV283iktFBlmk=;
 b=Y49nfWU9Eirr7W9hqaCZeMS7x4waxIIb4HsMPQyslsxCgJtORSJTfK6dll4SQnd8EsVdSRbstHT+PpoajUYDL9WqQamya3QXqWN7RWFCUpll7tn3Deyn9d1Ec4Lu3raFn9dchDOT1fgyFT3qBzaZM2n3umWYLXfxgPOTk2focktSWWKbvSaPK4uQVh5513+Wa75TqM1w1V5P8LpgXiKV/felpF51tqwDeAyjkayFisgoq01e7N6RURq7Pvwb7LLc/rwzp+wswwP/UHR5nryH6/VP9w8DV4Pu6G97JAPpXdg1hPlDt9VQcTT/HcR50/CFNm86qDzetZd8N4XJeIADIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqGHY2Gcm8l8l3ur5qb2ltIHWk8t4SQV283iktFBlmk=;
 b=ilUcOfWuc2ivHNa7kH7rVX0v9hHLJN7d1MBQBd1xsspxQM6HmBk/CR2oa0TbRlRdZo+boCIEPvVS0MznLe2YKL/DgypkXHKiyQ/0lca8mgS5ID7qUECgmSnim3luH8/m8nbNXOdcR1sJ4JbouXjX+Ol8zyYdYZJGGesadEockyk=
Received: from BYAPR18MB2630.namprd18.prod.outlook.com (2603:10b6:a03:134::33)
 by BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Wed, 11 Mar
 2020 08:36:17 +0000
Received: from BYAPR18MB2630.namprd18.prod.outlook.com
 ([fe80::e4cc:4e1f:9345:9863]) by BYAPR18MB2630.namprd18.prod.outlook.com
 ([fe80::e4cc:4e1f:9345:9863%3]) with mapi id 15.20.2814.007; Wed, 11 Mar 2020
 08:36:17 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [EXT] [RFC v2 00/16] net: atlantic: MACSec support for AQC
 devices
Thread-Topic: [EXT] [RFC v2 00/16] net: atlantic: MACSec support for AQC
 devices
Thread-Index: AQKLoDPckfRH4OG49IPaTDEFar32/wK++HDh
Date:   Wed, 11 Mar 2020 08:36:16 +0000
Message-ID: <BYAPR18MB2630098AE9E08528B82BC520B7FC0@BYAPR18MB2630.namprd18.prod.outlook.com>
References: <20200310150342.1701-1-irusskikh@marvell.com>
In-Reply-To: <20200310150342.1701-1-irusskikh@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7895a94c-d011-4cee-2f32-08d7c597442f
x-ms-traffictypediagnostic: BYAPR18MB2535:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB25357BB4CD5A0E2FD9983422B7FC0@BYAPR18MB2535.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(199004)(4326008)(186003)(9686003)(2906002)(26005)(81166006)(8676002)(8936002)(7696005)(81156014)(52536014)(316002)(110136005)(55016002)(4744005)(54906003)(53546011)(5660300002)(76116006)(33656002)(71200400001)(6506007)(66446008)(66476007)(64756008)(66556008)(86362001)(66946007)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2535;H:BYAPR18MB2630.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JP5tD5hW0wdNMKlLuwNysjBzLOnYZBmGrj+hhmycs7O7n24/jF7ETaRirXf5WzpXSj0zo/HB4UyhvrTIAYUZGFDmKRhCfTgInZgIhYeyHv2rI38ZHnVNIlp0IEGSCO1nkvAZNDbkQA/cgevd6GY/WoHvckxZdgHTbRSnumHg0h9GW4p77Dxu1y518jAcD4SteemDicMCCfpS0dj43X4cTtoWdyIhgR/Q4hIYoR5YN6oZBetUxP3tVz4ktAlhhEw1Kd1QlHKIDTgXEkxxHTt+cwR+6nr+1k3dMEb18AEFs2CLnT/MHQ7yT6UPlWZDdjelwYalYz4wBNtQtVa51C7jte8y5ASbuPOSCRRam7DAWH/ydYeLm2vRXFI103b4+HMUKU6eNntTmRdJsqCwdbBIGTq5g6VU6CS0O8HvDY8qBUMK/1C2uEHBFqnCAJ6YT8ik
x-ms-exchange-antispam-messagedata: 2Rs4TsuJ862SJzXyhHIZLVbZiencWDEh13ueLwNBJNjoblSRZwGbny6qvXjzNct37v3vq7QW1WibmrlbmhUifFzj5zC6rneEo1A7qWBPwccrlszfbvQdCgZkg/tsk+GfgCDWWgxoqMBqKXvqD/StRA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7895a94c-d011-4cee-2f32-08d7c597442f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 08:36:16.8822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F4ZB7ndOJw3djm7F9McfCo5DF9A8cnKO4i4bMXJAaorVRpdpbtoUtM50kTj67KMwrrRs557MU8cdG0HvoqQXnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2535
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-11_02:2020-03-10,2020-03-11 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Antoine,

Sorry forgot to CC you on a whole patchset.

On 10.03.2020 18:03, Igor Russkikh wrote:
> External Email
>=20
> ----------------------------------------------------------------------
> This RFC patchset introduces MACSec HW offloading support in
> Marvell(Aquantia) AQC atlantic driver.
>=20
> This implementation is a joint effort of Marvell developers on top of
> the work started by Antoine Tenart.
>=20
> RFC v2:
>   - Split out patch for updating the SCI upon MAC address change.
>     Sent as a net tree fix;
>   - Improved changelog for "net: macsec: add support for getting offloade=
d
>     stats" patch (patch 0008 in this series);
>   - Don't fallback to s/w stats when offloading is enabled;
>   - Removed the "enable HW offloading by default" patch. Separate patch
>     will be submitted to enable specifying the desired offload upon macse=
c
>     device creation (upon ip link add);
>   - Accommodated comments related to "MACSec offload skeleton" patch.
>=20


--=20

Regards,
  Igor
