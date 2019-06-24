Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5686A5028D
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 08:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfFXGxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 02:53:05 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:25386 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726399AbfFXGxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 02:53:04 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5O6qjHM012923;
        Sun, 23 Jun 2019 23:52:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=wWuPBrRMQ2q3wtt9//9+JoWPLpUoSwurNi++1AQdmoY=;
 b=cgJK36arwm8CGCEdj7B4oFzkoFfLCNN57CRH2KwpQ3Nr4/myo9OYyXZktosVUUvKHCnE
 9rpe0OC3oHU1Uytzb6xwMMJBjuttSIY1Dh+m7y6031Sdu2XCIO9VwhEe8zLWI1CO28dE
 G/tBOSZvTZ7Fm8obz7+cV64je0zE3/Ro1HbWTzAbhVo+4+tQBeVYcKi0IWdLQNe7drkn
 V/5Ouz2zlKl2BAryQVssMRS6rTqjzyTsecaG1SoE0dJeog9fZWmfklnBze0TLVaC3lmy
 BF87sXh2MqXK4yRaWd1kyJ5aeOwcaTb4qcBrvvCXwG+ICso4634oKbh5XE/MAVAdh99Y FA== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam05-by2-obe.outbound.protection.outlook.com (mail-by2nam05lp2055.outbound.protection.outlook.com [104.47.50.55])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t9gvs61k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Jun 2019 23:52:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWuPBrRMQ2q3wtt9//9+JoWPLpUoSwurNi++1AQdmoY=;
 b=f+M++EE+7D9u7dQoSvxdJhpdGsxWgi5RHopWyHEMuno5oMKIOQ18A0seKwIb5mEMq/fh8pK148EFaDgs+LPVkZgf9MamvLhhsjpoMYFLKTN/8C4RhptH1LZh/Ll8JS337W0kZxDuA8MtA3Br04aCa4Wri930dHJy0RAJjS9aDR4=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2631.namprd07.prod.outlook.com (10.166.215.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 06:52:51 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Mon, 24 Jun 2019
 06:52:51 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: RE: [PATCH v4 4/5] net: macb: add support for high speed interface
Thread-Topic: [PATCH v4 4/5] net: macb: add support for high speed interface
Thread-Index: AQHVKaViPgBsYhBhPEirHsdMjDQLc6apV+MAgAEGcyA=
Date:   Mon, 24 Jun 2019 06:52:51 +0000
Message-ID: <CO2PR07MB2469FDA06C3F8848290013B8C1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281806-13991-1-git-send-email-pthombar@cadence.com>
 <20190623150902.GB28942@lunn.ch>
In-Reply-To: <20190623150902.GB28942@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1hZDhlZGE3Yi05NjRjLTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcYWQ4ZWRhN2QtOTY0Yy0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSIxMTM4IiB0PSIxMzIwNTgzMjc2OTUxOTY2ODciIGg9Ik9Gd0pWc0xYN1JmSitYME9tNEt3cyt0Rm4zWT0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff3b6996-9b81-497c-9440-08d6f87093bf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2631;
x-ms-traffictypediagnostic: CO2PR07MB2631:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CO2PR07MB2631CF48217FC844D633A70EC1E00@CO2PR07MB2631.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:983;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(366004)(136003)(396003)(346002)(36092001)(199004)(189003)(14454004)(81156014)(5660300002)(81166006)(316002)(6506007)(53936002)(6916009)(7696005)(6246003)(76176011)(8676002)(11346002)(2906002)(8936002)(9686003)(99286004)(6436002)(52536014)(229853002)(3846002)(66446008)(64756008)(66556008)(66476007)(73956011)(66946007)(446003)(55016002)(33656002)(6116002)(6306002)(54906003)(66066001)(486006)(86362001)(74316002)(25786009)(71190400001)(71200400001)(78486014)(76116006)(68736007)(7736002)(4326008)(305945005)(102836004)(26005)(256004)(476003)(478600001)(107886003)(55236004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2631;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: U2Dtxqx6lwznEgumkLxLpbjewbl/LmDhHUQWCD7j8Nq0LOVG+EeCW5RRoaDIT+2A+i/Of+0f36pblWbOh4Plx1jGrXokAbTULaUyaMMri9sp05bACEr/fOwBHn9MDwEf7PTpgQrx3HFPKgA3E8hRQF0KXXr/GowJZB15cxoeFwdTr3wk9YBU6wQb+vdiY8BQiYyEe1YWQrucSyNkehuRQvnFOyKDb22K/hgicpt6PpOezHJpLDWZqy78AXd6xGbIB9n4Cx6gTP0hy5TcfVeaFKLmkB/H4bkH4xYt/WD73bPp3fx4e6TkrGpzbiHsGypHWIScLD9xW6Fy0C+hcyK0pSEbkLtOXcEA67Q9POiUV5M/xm8zsTJNfvjXw3rrtC9Vn+1KK3x6Y1T8WcxYYxsr/jl3rdd887BhIP62oYnqLKk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff3b6996-9b81-497c-9440-08d6f87093bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 06:52:51.7294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2631
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=602 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240058
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

>> +enum {
>> +	MACB_SERDES_RATE_5_PT_15625Gbps =3D 5,
>> +	MACB_SERDES_RATE_10_PT_3125Gbps =3D 10,
>> +};
>What do the units mean here? Why would you clock the SERDES at 15Tbps,
>or 3Tbps? 3.125Mbps would give you 2.5Gbps when using 8b/10b encoding.
>
MACB_SERDES_RATE_5_PT_15625Gbps is for 5.15625Gbps, I think this should be =
just
MACB_SERDES_RATE_5_Gbps and MACB_SERDES_RATE_10_Gbps. I will do it in next =
patch set.

>Xilinx documentation:
>https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
>3A__www.xilinx.com_support_documentation_ip-5Fdocumentation_usxgmii_v1-
>5F1_pg251-
>2Dusxgmii.pdf&d=3DDwIBAg&c=3DaUq983L2pue2FqKFoP6PGHMJQyoJ7kl3s3GZ-
>_haXqY&r=3DGTefrem3hiBCnsjCOqAuapQHRN8-rKC1FRbk0it-
>LDs&m=3D6V8fNIg49czRjfvVtDJ5BbR28p9UPlLLyB7fah7ypcw&s=3DLsDphgLBe1VDpM
>_K9pkuyal873WeKqHDv64NDRUWy1Q&e=3D
>seems to suggest USXGMII uses a fixed rate of 10.3125Gb/s. So why do
>you need to change the rate?
For USXGMII, Cadence MAC need to be correctly programmed for external serde=
s rate.

Regards,
Parshuram Thombare
