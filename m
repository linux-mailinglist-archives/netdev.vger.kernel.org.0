Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886F4508FA
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 12:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfFXKcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 06:32:50 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:10232 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726716AbfFXKcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 06:32:50 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5OASfF9016582;
        Mon, 24 Jun 2019 03:32:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=SIzodM/1O8sKxUQR7RXb+TWq6k8pVWUGxSWg3o6QMlg=;
 b=Jkq7HmHO7gg/WNn8k4i7FtitF59kTPtNEW2v7d5r4PYYZr4jxzjkzdEvxuuhQZP3CEka
 Fpe6k8F3xDdVWwx2Uu7mO5qkvEqFGtfu9f2heZ4fLUXdrVARlxOunhWQU86RuErpElMu
 wUvbwJvmX/kTCbGkB9IR1Ct90IObsQZ/5CgO6013pu0YC1lpCF7VV/W+2iCLOTc1JBrR
 5vOR6yWvaAvPZLyDGb47zqnz7LhZX4Z2F1WyMa9vbKdcmppgUSXqkVmMEpsVof6xom0X
 K3rWtMnIofLoDW/pHirWO1MnXyU1q0MBuzx21rZpynmn+2Ezt+jnrMfIUY5CIcaofqvq 7w== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2051.outbound.protection.outlook.com [104.47.37.51])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t9fwtqgq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 03:32:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIzodM/1O8sKxUQR7RXb+TWq6k8pVWUGxSWg3o6QMlg=;
 b=YerRWkBk3PSF+klJNEjKH1bSAzsUfl4FczLTQvdYRJKytGB3zwD5fXy89//SBPDqYddVvdw3TPviD2R22scABO72ikQ6qrE2CgRCxrrGWVZKzb3LKNwsXofmoci2ZI/JER9ABoWW8kuf4FZXpEpnOZW3N6eiieSP9d0an6s22OE=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2568.namprd07.prod.outlook.com (10.166.92.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 10:32:36 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Mon, 24 Jun 2019
 10:32:36 +0000
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
Subject: RE: [PATCH v4 2/5] net: macb: add support for sgmii MAC-PHY interface
Thread-Topic: [PATCH v4 2/5] net: macb: add support for sgmii MAC-PHY
 interface
Thread-Index: AQHVKaVHMt019Pka20mPugoFl8ah06apBQMAgAFRdiCAADaTgIAABQ5QgAAICQCAAAGfcA==
Date:   Mon, 24 Jun 2019 10:32:36 +0000
Message-ID: <CO2PR07MB246978081887C195B9005039C1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281781-13479-1-git-send-email-pthombar@cadence.com>
 <20190623101224.nzwodgfo6vvv65cx@shell.armlinux.org.uk>
 <CO2PR07MB246931C79F736F39D0523D3BC1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
 <20190624093533.4vhvjmqqrucq2ixf@shell.armlinux.org.uk>
 <CO2PR07MB24699250A3773DE76B6D2E9EC1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
 <20190624102224.6gudxxdaz43wrlcc@shell.armlinux.org.uk>
In-Reply-To: <20190624102224.6gudxxdaz43wrlcc@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy01ZjlmMjU2Zi05NjZiLTExZTktODRmOS0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcNWY5ZjI1NzEtOTY2Yi0xMWU5LTg0ZjktMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSIxNTEwIiB0PSIxMzIwNTg0NTk1MzE2NTgwMTIiIGg9IjhRcFpVZ28ydkprMDhMRXNBQ1V1UUdHbFBOOD0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8176837-9008-472e-2ae5-08d6f88f4653
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2568;
x-ms-traffictypediagnostic: CO2PR07MB2568:
x-microsoft-antispam-prvs: <CO2PR07MB25686FC60470809BBA1F7D3AC1E00@CO2PR07MB2568.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(136003)(396003)(366004)(199004)(189003)(36092001)(5660300002)(478600001)(6506007)(53936002)(33656002)(81156014)(68736007)(86362001)(3846002)(256004)(8676002)(81166006)(7736002)(229853002)(2906002)(446003)(78486014)(66446008)(11346002)(66476007)(486006)(6916009)(66556008)(71190400001)(71200400001)(476003)(73956011)(76116006)(99286004)(64756008)(66946007)(54906003)(76176011)(102836004)(55016002)(9686003)(7696005)(25786009)(107886003)(74316002)(6246003)(6116002)(6436002)(316002)(66066001)(55236004)(4326008)(8936002)(14454004)(52536014)(186003)(26005)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2568;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: g/M9/9XOj2li40GgixmF1n+sJTEQgJTj3Xo2k3mHedCuAZyB+YJfSP/nvmamypgas8odzN6Nqha6z1kgxxra+WBONFBYO9HfhqogyL+Yt/96pWnuwNEsIawSt4gamNqOrFtSD17+F4bmKW1sMW0oriAJMLayIlMa9X6f1+vLpkuCimssa424olT5ALaKUrWRjc0CojQq967yYzt6yob78SHecHk97N3p1ayrc7Rc6Jb99H5okVwpB6mPOHPRFdlqy7Ajmcgn27ZLIrvFPoYNw6UTLCmTKqV6rp8EE9Nx8oob1Fmt9PsBCoNnt7w3u531PJPJN13RUMEz2ApEkeACKDwCgp5wZMyCtTR5x2+3zWtpeo+iTTUIxcD8a3886RYkEPJp07LEaloN4hzFDLHzawpZyLLR12ur7sRxws+5p/k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8176837-9008-472e-2ae5-08d6f88f4653
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 10:32:36.2380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2568
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240089
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> >Sorry, this reply doesn't answer my question.  I'm not asking about
>> >bp->speed and bp->duplex.  I'm asking:
>> >1) why you are initialising bp->phy_interface here
>> >2) you to consider the impact that has on the mac_config() implementati=
on
>> >  you are proposing
>> > because I think it's buggy.
>> bp->phy_interface is to store phy mode value from device tree. This is u=
sed
>later
>> to know what phy interface user has selected for PHY-MAC. Same is used
>> to configure MAC correctly and based on your suggestion code is
>> added to handle PHY dynamically changing phy interface, in which
>> case bp->phy_interface is also updated. Though it may not be what user
>> want,
>> if phy interface is totally decided by PHY and is anyway going to be dif=
ferent
>> from what user has selected in DT, initializing it here doesn't make sen=
se.
>> But in case of PHY not changing phy_interface dynamically bp-
>>phy_interface need to be initialized with value from DT.
>When phylink_start() is called, you will receive a mac_config() call to
>configure the MAC for the initial operating settings, which will include
>the current PHY interface mode.  This will initially be whatever
>interface mode was passed in to phylink_create().
Yes, and same bp->phy_interface is passed to phylink_create().
We need this to know what phy interface is selected by user.

Regards,
Parshuram Thombare
