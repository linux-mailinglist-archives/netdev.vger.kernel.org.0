Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8590D52808
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfFYJ0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:26:44 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:27416 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727039AbfFYJ0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:26:44 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5P9Nuse005422;
        Tue, 25 Jun 2019 02:26:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=hI3LQp0sFWIriwALoWRODmBM6JoGnz0uIcHLJssu/hg=;
 b=GhqeJHwsh8qIEtDX9593rfui/fum0IubwqoK+6nFBtKUBZZQGt0i1w9iA9Ku9rQBfFb4
 GodHm5BKJOeR9CXEtG44TnepTRGFY8MNx9sLfbRyJDheGlmM2Ev2fkSHbSw0tlqjrjHo
 v8vjnGbjULCwceIpIWerLY2blwb18qLXBarrz1xH8yyOpKXXDWRNoDGQgul7yaGL9nOz
 JxwEuDVMFUGI5b2EKl3khgXrwdO/yCVjiLVwnsv/+x8iQlupNyM0rEqGaJrJJ+dYXoKM
 9iEJxDYOyTsrKfAF1FJG8dp/flRj53rc1sc5Yr3uVtuO8fRZm/dXVl8dlEaG1qShZn7R 7g== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2055.outbound.protection.outlook.com [104.47.40.55])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t9fwtvsm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 02:26:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hI3LQp0sFWIriwALoWRODmBM6JoGnz0uIcHLJssu/hg=;
 b=PV3CPtDQ0f0NgQGguBQpzGz3mcfthAECdOg92B1t/6B1+0eRtBdgNDEcgmWX5mLbeAyK00IFl2tQkqHjXURKPrxQztohqw2Yez6PVA3mOgF7yRUE2I+Ec543JTlrK0hbJm5lo2S661hxx0s0ZRm0vt9fLMbP6y8ocRzgS8VrCK8=
Received: from SN2PR07MB2480.namprd07.prod.outlook.com (10.166.212.14) by
 SN2PR07MB2640.namprd07.prod.outlook.com (10.167.15.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 09:26:29 +0000
Received: from SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba]) by SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba%10]) with mapi id 15.20.2008.014; Tue, 25 Jun
 2019 09:26:29 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: RE: [PATCH v5 2/5] net: macb: add support for sgmii MAC-PHY interface
Thread-Topic: [PATCH v5 2/5] net: macb: add support for sgmii MAC-PHY
 interface
Thread-Index: AQHVKoXvEFWLlsIg00eQABDiRQGpFaaq0E4AgAFDHQA=
Date:   Tue, 25 Jun 2019 09:26:29 +0000
Message-ID: <SN2PR07MB2480B53AFE512F46986A1CAFC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
References: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
 <1561378274-12357-1-git-send-email-pthombar@cadence.com>
 <20190624134233.suowuortj5dcbxdg@shell.armlinux.org.uk>
In-Reply-To: <20190624134233.suowuortj5dcbxdg@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy00ZTA0MTM2NC05NzJiLTExZTktODRmOS0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcNGUwNDEzNjUtOTcyYi0xMWU5LTg0ZjktMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSIxNDIxIiB0PSIxMzIwNTkyODM4NzAzOTIxMzIiIGg9IiszZWdIQVZJYWFpN1JmUXJSWkJqbHh4MkFwOD0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 578fd0fd-9356-49f6-dbf2-08d6f94f3471
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN2PR07MB2640;
x-ms-traffictypediagnostic: SN2PR07MB2640:
x-microsoft-antispam-prvs: <SN2PR07MB264019C9FABF2038BCD43096C1E30@SN2PR07MB2640.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(366004)(396003)(376002)(346002)(189003)(36092001)(199004)(66556008)(2906002)(66476007)(26005)(76116006)(66946007)(102836004)(71190400001)(71200400001)(305945005)(229853002)(81156014)(486006)(11346002)(33656002)(25786009)(54906003)(4326008)(316002)(78486014)(3846002)(8676002)(53936002)(81166006)(6246003)(8936002)(256004)(14444005)(107886003)(7736002)(9686003)(55016002)(478600001)(55236004)(66446008)(186003)(64756008)(86362001)(6116002)(99286004)(6436002)(6506007)(66066001)(76176011)(73956011)(446003)(74316002)(14454004)(52536014)(476003)(68736007)(5660300002)(7696005)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR07MB2640;H:SN2PR07MB2480.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Dz5dTjrVLBa1D8uXfWMmKxmwcr/zt5QUu0xfcVGicq/PYytRXwWpc30K1w5PtOb/4hho+oPauptbgv5ix7Gz1KE+JJSo8veihsNqUmJSenI63XVLntT2MDccY7hGtKvk23pwuGefo8+jTMaXgsrCT3XG+V7t4T3Ifryu7K+sy6fqM2X/zHVAcvVTdVaXgQf3snPFFVwN3ERbcFU+/WykKdqWTa8p6D2HHwD1r4jZvT0wLhEHePuTQ/iANLK6JodiNqwt/NMNRyfb13idDdsxGab1SVV1Iuu2VNJn52KGv36N8IL/9Z4uE+txNCVouukvRVLK3HePn6pFJhJqM8sr66OoBOXLaYHBNA/dXW1TRG9UoTwJ/ca7GOcv3MlS1z16C27HhnjgMhFVnkPHmAQRQA83g+JNByVeGfBaZO+DmFg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 578fd0fd-9356-49f6-dbf2-08d6f94f3471
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 09:26:29.5182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR07MB2640
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=895 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250075
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> +	if (change_interface) {
>> +		bp->phy_interface =3D state->interface;
>> +		gem_writel(bp, NCR, ~GEM_BIT(TWO_PT_FIVE_GIG) &
>> +			   gem_readl(bp, NCR));
>This could do with a comment, such as the one I gave in my example.
Sure. I will add a comment here.

>> @@ -493,6 +516,7 @@ static void gem_mac_config(struct phylink_config
>*pl_config, unsigned int mode,
>>  		reg &=3D ~(MACB_BIT(SPD) | MACB_BIT(FD));
>>  		if (macb_is_gem(bp))
>>  			reg &=3D ~GEM_BIT(GBE);
>> +
>Useless change.
Ok, I will remove this empty line.


>> +		if (phy_mode =3D=3D PHY_INTERFACE_MODE_SGMII) {
>> +			if (!(bp->caps & MACB_CAPS_PCS))
>> +				interface_supported =3D 0;
>
>So if bp->caps does not have MACB_CAPS_PCS set, then SGMII mode is not
>supported?
Yes

>In which case, gem_phylink_validate() must clear the support mask when
>SGMII mode is requested to indicate that the interface mode is not
>supported.
>The same goes for _all_ other PHY link modes that the hardware does not
>actually support, such as PHY_INTERFACE_MODE_10GKR...
If interface is not supported by hardware probe returns with error, so we d=
on't=20
net interface is not registered at all.
I think what is missing is setting appropriate err value (-ENOTSUPP ?), rig=
ht now it is returning
default err.



Regards,
Parshuram Thombare
