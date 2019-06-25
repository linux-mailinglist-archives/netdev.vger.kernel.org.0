Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6CD95283A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731628AbfFYJit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:38:49 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:62016 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729136AbfFYJit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:38:49 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5P9bCmL012074;
        Tue, 25 Jun 2019 02:38:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=Q7Kf655OodjWp6WsEX9d5KutreOSgwoib4Ogj+4yWa8=;
 b=o4bQtlTgjQzlfcKTFd/ihbC5kFfw92A5AxJhc1X7dTgFRV6QgcrJsN+dWnGRJKun242h
 zPxFjAMw10kXYDdLkIYiHnPhA9L0DoaMkR+QUl9bR1XnWL6n1nVcEwTwZ/rDnjQg6gCL
 yiQnz2yYWGdTEcRw0AbrvmWVyhD9vRsfUxgtyjqYHMl97Q223QQXDm5U0uYpLNvWW7/W
 ti6K/ODELnPJ8c5Fekl+GUsjFhIRf41UhF67MiVQ/rnWq+c1psCpyFy/UXEDI/EcLx4Q
 CFdgTnuC3SqvafD2C5vcwbDQScIQeZ5Y6AdIDNS6evoAoi2y8vk0mlt99oM9wGi9DnFL PA== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2057.outbound.protection.outlook.com [104.47.41.57])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t9gvsbwed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 02:38:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q7Kf655OodjWp6WsEX9d5KutreOSgwoib4Ogj+4yWa8=;
 b=EP7LnWasYEFE++p1k/+24wg2qH/k2gFmAvpfq9/Tnq9uJ2UVJF6PBILub50cy47vljb2g764INeFUSM1xEaPG7fGuujz2axfcGXWN2Uikzyx8ENl2pHnMjTIefFBGPp2h1BsMAKySOaiIAYvVzCgCOtpz8HTzoFHK6ZncZ69ILg=
Received: from SN2PR07MB2480.namprd07.prod.outlook.com (10.166.212.14) by
 SN2PR07MB2672.namprd07.prod.outlook.com (10.167.15.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Tue, 25 Jun 2019 09:38:37 +0000
Received: from SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba]) by SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba%10]) with mapi id 15.20.2008.014; Tue, 25 Jun
 2019 09:38:37 +0000
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
Thread-Index: AQHVKoXvEFWLlsIg00eQABDiRQGpFaaq0E4AgAFDHQCAAAiEAIAAAOSg
Date:   Tue, 25 Jun 2019 09:38:37 +0000
Message-ID: <SN2PR07MB24800C63DCBC143B3A802A6EC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
References: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
 <1561378274-12357-1-git-send-email-pthombar@cadence.com>
 <20190624134233.suowuortj5dcbxdg@shell.armlinux.org.uk>
 <SN2PR07MB2480B53AFE512F46986A1CAFC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
 <20190625092930.ootk5nvbkqqvfbtd@shell.armlinux.org.uk>
In-Reply-To: <20190625092930.ootk5nvbkqqvfbtd@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1mZmEyNzEzNC05NzJjLTExZTktODRmOS0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcZmZhMjcxMzYtOTcyYy0xMWU5LTg0ZjktMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSIxMDQ4IiB0PSIxMzIwNTkyOTExNDQ5MzUxMjciIGg9IlF3N1YxUEVwdmdObFgrT2FXZzRKVnRCVEtyTT0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35fca7ea-f6aa-4120-1694-08d6f950e67d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN2PR07MB2672;
x-ms-traffictypediagnostic: SN2PR07MB2672:
x-microsoft-antispam-prvs: <SN2PR07MB267239DCFEED6B55F6E0CD66C1E30@SN2PR07MB2672.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(136003)(396003)(39860400002)(376002)(199004)(189003)(36092001)(66556008)(54906003)(66946007)(55236004)(316002)(102836004)(476003)(26005)(71190400001)(68736007)(55016002)(6916009)(78486014)(11346002)(74316002)(4744005)(86362001)(8936002)(6436002)(9686003)(52536014)(6116002)(71200400001)(446003)(305945005)(7736002)(256004)(25786009)(6506007)(99286004)(186003)(14454004)(3846002)(486006)(33656002)(53936002)(8676002)(66066001)(4326008)(478600001)(81166006)(229853002)(2906002)(6246003)(107886003)(7696005)(5660300002)(76116006)(81156014)(66476007)(73956011)(64756008)(66446008)(76176011)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR07MB2672;H:SN2PR07MB2480.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PClwevzwTAhjPFN0F60Ls8P/b30kdneJQm4ykLujE1eN4mU5d5RwDC2sdSO6lOQ0FJSPv77uFhuhZz0vd6FlZ0hVUstVFXxtSUIyMRYDSQZ2ptpWOrWNHBfXQqwXDKZWVZOJT668gTrBAswtA/SxvJrWT2bxkmGW1mAGC7XRdh46JB/uT4l1dvTB90o95V4mmIskC1vupHXCJyt7Cj3lMDJyXSDBGTofqdyMmezW4Ur2VMwHJvpLi3SP9TM7uE/tBxtET+rkzezdyYVZWDH42Gi3PQFZ9L6lyHQR4L9GF3XEsK1WeUBifjz+3okbLw522ti9C8UB6+oUm4NbcYOKuQTRt+ZFf93mBg5pDP/EOVZYYZg/rQfXHsDjx2AL3SVVmpeZv19HuB8ZYwBBw40uu+Ov1mXWYl8CXpIYG6tMIt8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35fca7ea-f6aa-4120-1694-08d6f950e67d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 09:38:37.7599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR07MB2672
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
 mlxlogscore=924 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> >In which case, gem_phylink_validate() must clear the support mask when
>> >SGMII mode is requested to indicate that the interface mode is not
>> >supported.
>> >The same goes for _all_ other PHY link modes that the hardware does not
>> >actually support, such as PHY_INTERFACE_MODE_10GKR...
>> If interface is not supported by hardware probe returns with error, so w=
e don't
>> net interface is not registered at all.
>That does not negate my comment above.
Sorry if I misunderstood your question, but hardware supports interfaces an=
d based
on that link modes are supported. So if interface is not supported by hardw=
are,
net device is not registered and there will be no phylink_validate call.
If hardware support particular interface, link modes supported by interface
are added to (not cleared from) supported mask, provided configs is not try=
ing to limit=20
data rate using GIGABIT_ENABLE* macro.

Regards,
Parshuram Thombare
