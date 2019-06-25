Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB8252688
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbfFYI0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:26:52 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:12488 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730048AbfFYI0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 04:26:52 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5P8JGpu013434;
        Tue, 25 Jun 2019 01:26:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=lGkX0xmJQwW65344YxhZAtxjkgNYSulRupwSf5wSLhI=;
 b=jiNhayr7Vxw7/7t9NE8J+Q3MskJRHD3PGpMVpG8PB3MKhUGG74fHM9DSXGqXeSJCWXwF
 4Fe3HY9NDZ4erHh/iYT2QVDzVQWLL8IkaRZCwA6bQuaXHkB2TTuTyWeMiHshhKhIt3GT
 FDinw60LiNBmxth5AffmphivRjlZKJ9ZXK8mj5a7eO43iT8ljjpJPRBPLKuxavYxA2V+
 y5O8X2hVO1gdwL13wlOSsBdWGEbQwTVPmzGhDmP7mEJ27euNn7u5AQBFxzSZjtGved+u
 hx/3dvYR4D/IjpOMdaE9NeznbOkXtAI0LyD4jaxBhJlyxDILgwe/Aw7uwXGra15NcZmM uQ== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2055.outbound.protection.outlook.com [104.47.45.55])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t9fwtvhau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 01:26:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lGkX0xmJQwW65344YxhZAtxjkgNYSulRupwSf5wSLhI=;
 b=PNf1PAu2fzvrSwZKmjauJgsy9oDKIV0WpM0qtJzRneNoS5UcJIiieuirw2GVxvC97lFiV0ufjtLo488WTVgswUdty+IpyaflOUqQ5ucjD9HS9UrdvMMMTTFrzA+PVuLp1FsDuKa2FMmtTqUuBFa8b+h2PsHlUAhIBF0VbxlunrM=
Received: from SN2PR07MB2480.namprd07.prod.outlook.com (10.166.212.14) by
 SN2PR07MB2622.namprd07.prod.outlook.com (10.167.15.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 08:26:30 +0000
Received: from SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba]) by SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba%10]) with mapi id 15.20.2008.014; Tue, 25 Jun
 2019 08:26:30 +0000
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
Thread-Index: AQHVKaViPgBsYhBhPEirHsdMjDQLc6apV+MAgAEGcyCAAGt/gIABQWYA
Date:   Tue, 25 Jun 2019 08:26:29 +0000
Message-ID: <SN2PR07MB2480DBE64F2550C0135335EEC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281806-13991-1-git-send-email-pthombar@cadence.com>
 <20190623150902.GB28942@lunn.ch>
 <CO2PR07MB2469FDA06C3F8848290013B8C1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
 <20190624131307.GA17872@lunn.ch>
In-Reply-To: <20190624131307.GA17872@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1lYjhiMzcxMS05NzIyLTExZTktODRmOS0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcZWI4YjM3MTMtOTcyMi0xMWU5LTg0ZjktMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSIzODciIHQ9IjEzMjA1OTI0Nzg1ODIxNjgwNCIgaD0iN0pXUjBPYkRXUFNCTDhPbVdQKzg3STEvQSs0PSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a515dd0-2827-4521-44bb-08d6f946d2e3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN2PR07MB2622;
x-ms-traffictypediagnostic: SN2PR07MB2622:
x-microsoft-antispam-prvs: <SN2PR07MB262207490EAD382AC9F7F846C1E30@SN2PR07MB2622.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(376002)(136003)(39860400002)(189003)(199004)(36092001)(66476007)(66446008)(305945005)(81156014)(68736007)(316002)(55016002)(6916009)(446003)(9686003)(102836004)(478600001)(476003)(66066001)(2906002)(558084003)(86362001)(486006)(11346002)(25786009)(3846002)(71200400001)(71190400001)(78486014)(53936002)(7736002)(14454004)(6436002)(74316002)(52536014)(6246003)(6116002)(33656002)(229853002)(256004)(99286004)(7696005)(76116006)(186003)(5660300002)(107886003)(6506007)(73956011)(66946007)(76176011)(8936002)(66556008)(64756008)(8676002)(81166006)(55236004)(26005)(4326008)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR07MB2622;H:SN2PR07MB2480.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TA6AvcQH5iDce9u8tjaSw3SUCxW2KK3+4MgaAsPuqrGMzQnL4fXjRdEHqh/ShnAaod6pUAifjOyB5yt329QSNuXQXi3h5cWAv3RXiiZG3w2ybwjbHHGxlZWfLxVrY7af3u3QTtq4rFFO4ZO0w4iprNXRguKEvWJrR9VA+FKm/fM3d7CwXXQ5qEHXDszv7UTv2MpEvysVPoEBaMBSjKSSrAuCuSokatAwp2ymlxf4ApMNpPZGlMdXf/zbbHx/yI4SRlrKOjL3KxMmy9eg2ualZm+pXe4Eq+ksw676G3+ipbQHyH8v9CDtNPN7ZhD7BKGh9teInSxwJQRM47HyEUKUZwIXwzxqNi6SoC2pmprWA+SHMfq3CWG8xR/VbNXdPnhJ4zmb5CZdWKvcbZGDPtZivfh9AGKfqVQ0Tj/kfaW4BqY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a515dd0-2827-4521-44bb-08d6f946d2e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 08:26:29.9309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR07MB2622
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=739 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250069
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

>What i'm saying is that the USXGMII rate is fixed. So why do you need a de=
vice
>tree property for the SERDES rate?
This is based on Cisco USXGMII specification, it specify USXGMII 5G and USX=
GMII 10G.
Sorry I can't share that document here.

Regards,
Parshuram Thombare
