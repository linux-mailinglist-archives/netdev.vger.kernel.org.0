Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C01B64B40A
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 10:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731314AbfFSI2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 04:28:25 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:9406 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726142AbfFSI2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 04:28:25 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5J8Lb3m008925;
        Wed, 19 Jun 2019 01:28:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=3U5799OqhmrDiSCfVD7/pXnxe43WLl6wNlOWVnhWcb0=;
 b=d85AMMdzVtchZrajiVvk/2NJasAVZMS7urRTy+w1OpmNv6h8jJ0iYmagJtIY70VTgzKv
 HCZRJooYwcCGKYa+UtVdkKC1t0039VySGlL5yKUixwx2FxreOSUWyhToFHhWQNU2cZuG
 2F2T7e6+I2GWvBSmBj/9uvC2Mesn3WMwzbsyHlTTEBEgl8LCgENNCbN+lgkufmQn7JJi
 yOBhYJ8yvUuB7ym8lZSsHAyEMSxOB8TBv3xpJboswvenSTDdocX2VbVC9Z6xdp9BfhxR
 Z7XOjgwvsJWz3hWV+MhozDb0zKI71UZ1FimR/q8PcXmk/kRaFn4KGdEogHoAoVsjZDBV nQ== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam05-co1-obe.outbound.protection.outlook.com (mail-co1nam05lp2056.outbound.protection.outlook.com [104.47.48.56])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t7805ae3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 01:28:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3U5799OqhmrDiSCfVD7/pXnxe43WLl6wNlOWVnhWcb0=;
 b=OFnfxX4g4x6KiWB6p8PI2s3vn2Q1S0LjbbQchhlw3FhvkGfZQePB4/81i9Tji2zBQTCg4sSsuU16yt5ha5ryaG0n7d8jomg/AxX8pvlFaci/3IYDtwey9zHlThOA9dCavGNDau3cslT2m/YbPGNS9uuDd/kLHkyI8ox9TQMhnmo=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2613.namprd07.prod.outlook.com (10.166.94.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Wed, 19 Jun 2019 08:28:04 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 08:28:04 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: RE: [PATCH v2 1/6] net: macb: add phylink support
Thread-Topic: [PATCH v2 1/6] net: macb: add phylink support
Thread-Index: AQHVJgVonjJRgVP9fE6tX1Jh4Fpdgaah7sGAgAC2z8A=
Date:   Wed, 19 Jun 2019 08:28:04 +0000
Message-ID: <CO2PR07MB246919CA8A28E5F3A9ECD2F8C1E50@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1560642367-26425-1-git-send-email-pthombar@cadence.com>
 <1560883265-6057-1-git-send-email-pthombar@cadence.com>
 <20190618213259.GB18352@lunn.ch>
In-Reply-To: <20190618213259.GB18352@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy0yNTk3YzgzZS05MjZjLTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcMjU5N2M4NDAtOTI2Yy0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSIxMDI3IiB0PSIxMzIwNTQwNjQ4MDY1Mjg5MjQiIGg9InR1eFByRFVBbFM4QXIzVFRnVXVqa3dCSzN1TT0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb64277a-891c-4599-8411-08d6f4900ca6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2613;
x-ms-traffictypediagnostic: CO2PR07MB2613:
x-microsoft-antispam-prvs: <CO2PR07MB26133CB8DA81B9287E4E246DC1E50@CO2PR07MB2613.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(376002)(346002)(366004)(13464003)(36092001)(199004)(189003)(71190400001)(73956011)(66446008)(64756008)(8676002)(316002)(81156014)(66556008)(66946007)(6916009)(81166006)(76116006)(6116002)(74316002)(508600001)(66066001)(186003)(76176011)(102836004)(55236004)(2906002)(446003)(26005)(7696005)(6246003)(229853002)(3846002)(66476007)(6506007)(11346002)(8936002)(14454004)(7736002)(33656002)(99286004)(4744005)(6436002)(78486014)(5660300002)(305945005)(476003)(54906003)(71200400001)(9686003)(53936002)(55016002)(25786009)(256004)(4326008)(68736007)(86362001)(486006)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2613;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: go0OItA0/LK8vwGqoYAptLdmtVWAmMdEoATht6MoJoHoBZ9vzmszg1X73CkE2rT6aV42g7vcF5iebKgPvwl+9ppn9yL9qv2XHpM5fYmpGw5G9sIsqi7/GBDwC/ek7GSjc3bd/xTfcv3qWSBlehq4xgB6p55Fdq2GCG5KwTGePsYH4Tr616YcpL2hxYedHnXYn0wI72n2UHrFj61irRdIUNGwaWq2spiglCTShwkcdklIY7hZkinKvdqXICkdQrufFNyIlnJJ2th7ZkyI8/eSO1UVnlSVOkUtfzkdokc6GzFb2ds0+CxLShT9zd10Je4WQmW74/wL7+t/5q3wzd6NIYi6AQINTMCsFmtRqJea3LbPHgEQDF9GRodJR+FjoM572JwIejr+TgZHabNSfIHs+XWb4c5j9KVmHfY3+stiWSU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb64277a-891c-4599-8411-08d6f4900ca6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 08:28:04.2109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2613
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190070
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Sure, I will Cc Russel King in next version of patch series.

Regards,
Parshuram Thombare

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Wednesday, June 19, 2019 3:03 AM
>To: Parshuram Raju Thombare <pthombar@cadence.com>
>Cc: nicolas.ferre@microchip.com; davem@davemloft.net;
>f.fainelli@gmail.com; netdev@vger.kernel.org; hkallweit1@gmail.com; linux-
>kernel@vger.kernel.org; Rafal Ciepiela <rafalc@cadence.com>; Anil Joy
>Varughese <aniljoy@cadence.com>; Piotr Sroka <piotrs@cadence.com>;
>Russell King <rmk+kernel@arm.linux.org.uk>
>Subject: Re: [PATCH v2 1/6] net: macb: add phylink support
>
>EXTERNAL MAIL
>
>
>On Tue, Jun 18, 2019 at 07:41:05PM +0100, Parshuram Thombare wrote:
>> This patch replace phylib API's by phylink API's.
>
>Hi Parshuram
>
>When you repost as a proper threaded patchset, please Cc: Russell King, th=
e
>phylink maintainer.
>
>      Thanks
>	Andrew
