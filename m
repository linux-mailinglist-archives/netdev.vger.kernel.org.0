Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B68974F66
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbfGYN2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:28:22 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:50284 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728359AbfGYN2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 09:28:22 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6PDNptF021304;
        Thu, 25 Jul 2019 06:28:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=EyyBGUacYXnQjizWq9fNekcgqM0FLXqrya+m4HVdjDw=;
 b=QUkbnBB/XatwUSe/L7XNpGqcErDJOYk1iWvP4Uy1Sf1iSuq2AUohDoIKSC1hbhfBgj56
 QLAaLkWxsPbU+oOJ4hSmu8+Bax/LeY4eC79JXLbbPGzXuAOKfaZkdZr6g5IQGm8Ibj56
 SE9KAQmPpantxJX/s+AO8OApArAoPDWMO5gALhWq4UsOJip7tnXQNe5qoFYPErcbN+Qg
 xyYiPdEF3ruX/BYY6yTjMZA/i/j+EIaxzsRd8zi062VIuKLsNapj59jiGljALt+PnGNS
 C7V/Qn6S4sxCt7kCqDs4NfsnC9MthpzsvqVkMAuLZTOYefRI2zND7iJSQ+Agnxt0tEca aw== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2054.outbound.protection.outlook.com [104.47.46.54])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2tx61f9f8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jul 2019 06:28:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBECF5C6BJkExE/8XTg51752LMDtRcMGYNV2yYBIrpWPsyA2Y6WxPW1mfQnKLKndItU7Irt5DaDCXa26D0bPzpFAUFC9hKVlZCwK+T4iL6vrZQRS9UAFSKS1p3cKfIkAw32QmNiCyiSgciZ86KzAgaJHJ2jxB5xLKfarsDPFHu2SR1yfTm6c8NUD7AWiY5Tn1/gyG4R/n/32Xv/QM5//NwZj1YDuwpcadV+/yhcJNcwJWaX3S/ejqX1rsRLKRp9DUQ9MinZYf9Z+/B6yWULZmz9Cl8RuMVHkiQaRDouulGwn1gGTebeSI1BEfLZTBXMck4IOy7M1Vfyu+jPhu74tsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyyBGUacYXnQjizWq9fNekcgqM0FLXqrya+m4HVdjDw=;
 b=TUbNzkplg7Vf0AjFibs5yDa/koBBc4sNB/wI0jT4MCjZNPl67PEYLQYkVwiuVjp/lt5eeN/f1QqnYB8iInIPrg2Sp5fO2LfSeXsJE1JqBBVkdhMCSBRt1L9ZZZjJNhWEkUvD80uLF4ELbzeouI1po9xVLEe+/L8iq696N6wVm9d7birBEtl7jj10YTZZUE0L5Ydf7uA4LZXxpnZpnQI75ZnL0WZ9U9ZcplxEdr6EhKi9Z/IGuGkUpfgG1DIPc3hjWVUjDA7ISBBj2hmAPAe233TjKNM6fHkFXIWoqfKfwvXCf3g311sNa28H1m757X4BPML5KvGPGRWegdZieyei9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=cadence.com;dmarc=pass action=none
 header.from=cadence.com;dkim=pass header.d=cadence.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyyBGUacYXnQjizWq9fNekcgqM0FLXqrya+m4HVdjDw=;
 b=Sde3X7ZLtaKnx5CleHxZvoZKclEvtUqW5Fyy/58Ta2anitnnbcBXH8W4O/5N67sx6YmZOVZBYeXNsLTtDvKtG+/XQ5MMsXF4b/QRPnLdgIVwO70ghgV6/5eMq1adOoYf1XrGI9d1c46uRvamcpoX0hG78/lwIKlaUsEm0/g/24U=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2565.namprd07.prod.outlook.com (10.166.201.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Thu, 25 Jul 2019 13:27:58 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::8d1b:292f:5f51:f6d]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::8d1b:292f:5f51:f6d%6]) with mapi id 15.20.2115.005; Thu, 25 Jul 2019
 13:27:58 +0000
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
        Piotr Sroka <piotrs@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Arthur Marris <arthurm@cadence.com>,
        Steven Ho <stevenh@cadence.com>,
        Milind Parab <mparab@cadence.com>
Subject: RE: [PATCH v6 0/5] net: macb: cover letter
Thread-Topic: [PATCH v6 0/5] net: macb: cover letter
Thread-Index: AQHVNyz5FQb5Z+JcbkKLGishkgcgwabQiEQAgArffIA=
Date:   Thu, 25 Jul 2019 13:27:58 +0000
Message-ID: <CO2PR07MB246961335F7D401785377765C1C10@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1562769391-31803-1-git-send-email-pthombar@cadence.com>
 <20190718151310.GE25635@lunn.ch>
In-Reply-To: <20190718151310.GE25635@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy0wMTY0Nzk3MC1hZWUwLTExZTktODUwMy0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcMDE2NDc5NzItYWVlMC0xMWU5LTg1MDMtMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSIxNDU1IiB0PSIxMzIwODUzNDg3NDE0Mjg1NjMiIGg9ImVFRHFiMjhoNE91WDlEREJNOU5pclBkdmlYND0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [59.145.174.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67c097c8-c3b9-41ff-3abd-08d71103e90c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CO2PR07MB2565;
x-ms-traffictypediagnostic: CO2PR07MB2565:
x-microsoft-antispam-prvs: <CO2PR07MB25655D2978C1F8AB8BF3092BC1C10@CO2PR07MB2565.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(36092001)(199004)(189003)(478600001)(8936002)(14444005)(6916009)(86362001)(256004)(71190400001)(6506007)(71200400001)(6436002)(74316002)(26005)(4326008)(102836004)(66476007)(66556008)(64756008)(81156014)(55016002)(66446008)(186003)(8676002)(66946007)(33656002)(229853002)(81166006)(476003)(11346002)(446003)(486006)(2906002)(9686003)(107886003)(66066001)(5660300002)(25786009)(52536014)(53936002)(54906003)(6246003)(3846002)(305945005)(68736007)(7736002)(7696005)(316002)(76176011)(6116002)(99286004)(76116006)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2565;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CL/aJcBuvYLYzsndeLuvZT36PkJiVuoO12nRULfBQq2DaacWuOpURNar1zyc9j8fh6ND89Yf8seUu1FHTZi1W8Vf6Esc4HV5Dl60PBlp6yfUoeRdQOeE1syK/4JJYDehJyTFxKDBswLgxfquqIRdHLFM5BJ18pYg5IAt2RW+eQWVjQOS0aW+ayQUOcEau5agBcUpplVjs9EGhSEmKbpFqtIQfN197715sDznWfPotxT3OstoaegY0FoTk0vb/wRHvLrCkJq0yG2zeVOY161gbUsp9lnsvPfd+x10ViSNnkre4yfafrSrcd8NOWUVEfgjs5CzOurKdlJDIUNveIKIGE+fI3mjrXlP+LKS1weIu5oU5B6PefjEmX8bErS9GvR508IOV0n4KaGUuhEytG8VxDYifn/uL/slg/gwy6n+P88=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67c097c8-c3b9-41ff-3abd-08d71103e90c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 13:27:58.5942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2565
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-25_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=905 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907250157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

>One thing which was never clear is how you are testing the features you ar=
e
>adding. Please could you describe your test setup and how each new feature
>is tested using that hardware. I'm particularly interested in what C45 dev=
ice
>are you using? But i expect Russell would like to know more about SFP
>modules you are using. Do you have any which require 1000BaseX,
>2500BaseX, or provide copper 1G?

Sorry for late reply.
Here is a little more information on our setup used for testing C45 patch w=
ith a view to
try clarify a few points.=20
Regarding the MDIO communication channel that our controller supports - We =
have tested
MDIO transfers through Clause 22, but none of our local PHY's support Claus=
e 45 so our hardware
team have created an example Clause 45 slave device for us to add support t=
o the driver.
Note our hardware has been in silicon for 20 years, with customers using th=
eir own software to support
MDIO (both clause 22 and clause 45 functionality) and so this has been in C=
adence's hardware controller
many times.=20
The programming interface is not hugely different between the two clauses a=
nd therefore we feel the risk is low.

For other features like SGMII, USXGMII we are using kc705 and vcu118 FPGA b=
oards.
10G SFP+ module from Tyco electronics is used for testing 10G USXGMII in fi=
xed AN mode.

Regards,
Parshuram Thombare
