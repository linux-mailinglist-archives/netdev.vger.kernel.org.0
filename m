Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CC64A9B1
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbfFRSW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:22:28 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:19734 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727616AbfFRSW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:22:28 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5II4PnS012832;
        Tue, 18 Jun 2019 11:22:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=QWCDzjQRvV8akWp2ARDi4djWuxZe7bSVFFGCiCih7Wc=;
 b=E+5gmLcrinTN+Za/jRl/i7pVxlx14a0fc3h1lyHZWyLMCofVexV8x5EibdkdPoH+XZQU
 Js858HulkeUMe6h4eYEc72b9MOqJyyW6D1P2XzrkFjig2qsdn1JN5EmEaED8bZEoSfSL
 A11VBqmnye52LYZuVhb9Q6zTOHm/T+LNjUO0PF3XP8G7T3vx/W3leC4yDLEaJcDPrKRQ
 GTKdYgRjoBNwY+9eFz3n2Ltves2o6Ke03J+gMMWNzrKhSlVxjz1/Nu2b6hnzy/Os2eiz
 OL0bAI3lcV4a7mXdcNIdRbF9+ILxbR7eWin9AKM7TSMN0UG0Rdhgz3/zRzAeI9Q9RuTL DQ== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam05-by2-obe.outbound.protection.outlook.com (mail-by2nam05lp2056.outbound.protection.outlook.com [104.47.50.56])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t4v8wd9r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jun 2019 11:22:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWCDzjQRvV8akWp2ARDi4djWuxZe7bSVFFGCiCih7Wc=;
 b=QgJuWpUSdkSEwDj+41zxG38BjbvpXBkm2NfA8G4nyiFfbEUKOj9x0xCq34opE4PKlqlhEcX7Ibsq3E4hVvZ448nNMX89RA/nLCFef/EUte8KkIKTQbhS1mxkMXQJYKckwhX3CXoJhrxkXVHUgUJhxBxjBagUe+azlthMuu0AcM4=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2694.namprd07.prod.outlook.com (10.166.94.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Tue, 18 Jun 2019 18:22:19 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::b9c0:ba2d:e9e8:4176%4]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 18:22:19 +0000
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
        Piotr Sroka <piotrs@cadence.com>
Subject: RE: [PATCH 1/6] net: macb: add phylink support
Thread-Topic: [PATCH 1/6] net: macb: add phylink support
Thread-Index: AQHVI9SIY9+TxQa7kEy/sk4ETzB+jKagIHcAgAGcrzA=
Date:   Tue, 18 Jun 2019 18:22:18 +0000
Message-ID: <CO2PR07MB2469C003D5583A2AD1FAA833C1EA0@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1560642311-25585-1-git-send-email-pthombar@cadence.com>
 <1560642367-26425-1-git-send-email-pthombar@cadence.com>
 <20190617174242.GL17551@lunn.ch>
In-Reply-To: <20190617174242.GL17551@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1mZTc5YjU2Zi05MWY1LTExZTktODRmOC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcZmU3OWI1NzEtOTFmNS0xMWU5LTg0ZjgtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSI2MjAiIHQ9IjEzMjA1MzU1NzM0NDQ1MzcyMCIgaD0ieUxHUWhoVjVQMHJpWXJLRmc1QVlxRFBtSklBPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: 
x-originating-ip: [59.145.174.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19e865f4-0e7e-41d1-2988-08d6f419e613
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2694;
x-ms-traffictypediagnostic: CO2PR07MB2694:
x-microsoft-antispam-prvs: <CO2PR07MB26942853AF77973A5C6BB132C1EA0@CO2PR07MB2694.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(39860400002)(136003)(346002)(376002)(36092001)(189003)(199004)(66556008)(186003)(5024004)(6436002)(66476007)(6916009)(86362001)(66946007)(76116006)(4326008)(53936002)(66446008)(5660300002)(107886003)(68736007)(73956011)(64756008)(66066001)(4744005)(99286004)(3846002)(478600001)(6506007)(2906002)(76176011)(7696005)(14454004)(6246003)(26005)(446003)(305945005)(6116002)(476003)(9686003)(11346002)(102836004)(256004)(52536014)(229853002)(7736002)(55016002)(81166006)(81156014)(8676002)(486006)(33656002)(8936002)(74316002)(316002)(71200400001)(71190400001)(54906003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2694;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zRN7slPorrXXpAuJbqxsoLDNryxViChd+QX7JxcHFs1VmezmbrwVppnyN64RymHU09y00tetDwkYYIdccvDgsYbCUnSlBoVQTfxumbKPpCdmN8M0k74UAFxkR/mPyfRxvNyTZMHb7eOAz/O5UasB3JK7ZGytSrE+vaToPJMzJNXUmQxBhfu+1ARCvzNdctC454cGt6c4bmxbUBu9Kfwe6+P4Yc0X8jCw90S1soicfsp0ShS2weLqk/N+LoheBS0M9A31TxMVoEyQy3u/UN2Rh/qm36VjQhgbmWUODYpEBM0PprvbSR/oppPvtSYCk7lC48LBZ+NH5u3NOG6N9OiP8saKaXqr3UG8619/MsGIXQTMz+f+p2PVpwNWnjzk3n0oqeVzdLHsteNiz1phhlJY3l/XhdIqNwPj8bmSnvQfDWc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19e865f4-0e7e-41d1-2988-08d6f419e613
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 18:22:19.0008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2694
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=824 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> @@ -4217,8 +4257,8 @@ static int macb_probe(struct platform_device *pdev=
)
>>
>>  	tasklet_init(&bp->hresp_err_tasklet, macb_hresp_error_task,
>>  		     (unsigned long)bp);
>> -
>> -	phy_attached_info(phydev);
>> +	if (dev->phydev)
>> +		phy_attached_info(dev->phydev);
>
>When can this happen? I don't see anything assigning to dev->phydev.
This is for non sfp (MDIO) based PHY. It is set in phy_attach_direct  (phyl=
ink_connect_phy -> __ phylink_connect_phy -> phy_attach_direct)
>
>     Andrew

Regards,
Parshuram Thombare
