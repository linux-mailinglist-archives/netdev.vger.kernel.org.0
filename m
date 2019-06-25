Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8A954D7A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730643AbfFYLWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:22:24 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:28744 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727138AbfFYLWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 07:22:24 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5PBHtN1002099;
        Tue, 25 Jun 2019 04:22:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=3ydM2NEvSUrrJIgPibfMSi9m9b+Vd31KblUmYY/tmik=;
 b=AicU+S24dI9HrXwcC0110Kb0pnJzvhpJ1xXM5RgzIKYNgoeQH51K8Hge99t56a6YOLr6
 7yr6szeP/uIBGUBe77FOSsB70GQnHI/Qs1aIG5bIIKwjOQ53/JMci9UE+6QluEu1M9h0
 UttCshfgXUNUBCKx2J57vW4dpQtw4tJh5oJZOQuSnvyqaoSmdTJhQLKJokmIlf/bYtqX
 2jwl943CR64BQpmfXv4npM68NNZjhiVh7kG+wbqtMYHjIQGbA6j56tmSaD38zLQdvg5O
 5CE92yh9+y1tcrYlZhc9ExV0XMDAmKfUggS4qVi1/IXKy+Gki+1rlQC0ZkqDimsP+2Oz Gg== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2051.outbound.protection.outlook.com [104.47.42.51])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t9gvsc8m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 04:22:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ydM2NEvSUrrJIgPibfMSi9m9b+Vd31KblUmYY/tmik=;
 b=MoAqyaPmbvS/YV0SiJC3m/B7Br/ugGVO2Z1m4aeoEwPbKzpQ3026PsIbGaGkKDULlwyuClI4jPOp/Dtmwvs1BFAIUP+cCdHGv0H58VKCilzlyrp/9AdQ0LH4QMc7HNTdHSToKIsCw0QUiVi7JkOGXzGu+u01gJhAOz6t/5KfZHQ=
Received: from SN2PR07MB2480.namprd07.prod.outlook.com (10.166.212.14) by
 SN2PR07MB2736.namprd07.prod.outlook.com (10.167.19.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 11:22:05 +0000
Received: from SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba]) by SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba%10]) with mapi id 15.20.2008.014; Tue, 25 Jun
 2019 11:22:05 +0000
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
Thread-Index: AQHVKoXvEFWLlsIg00eQABDiRQGpFaaq0E4AgAFDHQCAAAiEAIAAAOSggAARKgCAAAmr4A==
Date:   Tue, 25 Jun 2019 11:22:05 +0000
Message-ID: <SN2PR07MB2480251DCF4218BB1D1EDECCC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
References: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
 <1561378274-12357-1-git-send-email-pthombar@cadence.com>
 <20190624134233.suowuortj5dcbxdg@shell.armlinux.org.uk>
 <SN2PR07MB2480B53AFE512F46986A1CAFC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
 <20190625092930.ootk5nvbkqqvfbtd@shell.armlinux.org.uk>
 <SN2PR07MB24800C63DCBC143B3A802A6EC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
 <20190625103408.5rh2slqobruavyju@shell.armlinux.org.uk>
In-Reply-To: <20190625103408.5rh2slqobruavyju@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy03MWUyYzUwMS05NzNiLTExZTktODRmOS0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcNzFlMmM1MDItOTczYi0xMWU5LTg0ZjktMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSIxMDAzIiB0PSIxMzIwNTkzNTMxOTE2MzcxMTEiIGg9InpyRVluT1NvN1puRlFSR2NMNEFzbDJZTWNWaz0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e4be46b-25bc-4a46-286d-08d6f95f5a6a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN2PR07MB2736;
x-ms-traffictypediagnostic: SN2PR07MB2736:
x-microsoft-antispam-prvs: <SN2PR07MB27365A5CF5F10EF1F2C1E334C1E30@SN2PR07MB2736.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(376002)(366004)(39860400002)(36092001)(189003)(199004)(33656002)(66066001)(6916009)(81156014)(66556008)(81166006)(7696005)(446003)(478600001)(102836004)(78486014)(55236004)(64756008)(66476007)(5660300002)(4744005)(6246003)(76176011)(305945005)(66446008)(3846002)(9686003)(55016002)(25786009)(256004)(14444005)(14454004)(52536014)(99286004)(54906003)(6116002)(53936002)(7736002)(4326008)(66946007)(68736007)(71190400001)(73956011)(2906002)(6506007)(107886003)(74316002)(186003)(229853002)(486006)(6436002)(71200400001)(8936002)(26005)(316002)(8676002)(86362001)(76116006)(11346002)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR07MB2736;H:SN2PR07MB2480.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1cMeosIxhT7IxRDeaYHh+EPbSXCr+TpfahNfWuEAL4jHKnY6jRmPoxaC/k0Dlmk9j/WkEUgVAy9jTGmTCKA8H1JVe57GLkED5FV3lvx9Av9cOJjmHISFSyI0kGRSJBCtFpJalutVi1HjNUA/RJtD1LN7p19KY+HxYEyz6/+3SM1OyEK7kkRLgfL8KGyWvGbuGKckF0baWlkeWO2w93Uc21P4A0PNcCH/PsGLQPqCRSAMrh2/zPJFwNQvbCze8SPiMA2/caI0QBB51Z6S4MOtaJ5+IEAOBij9NGhLbSl65PGJbiwq5ZlxHKWulMksiMABfwSsmBWYa/J02ptygnKDWLhgjc1GuCqr2y221E4WUHryGR80gs3sEKVKy4ccprZRar79XTCb+dPFaBcfFQL7k4OjaKhl1WWiZB+J5psy0Fg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e4be46b-25bc-4a46-286d-08d6f95f5a6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 11:22:05.2979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR07MB2736
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=845 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250091
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>If you are interested in supporting SFPs as well, then using phylink
>makes sense, but you need to implement your phylink conversion properly,
>and that means supporting dynamic switching of the PHY interface mode,
>and allowing phylink to determine whether a PHY interface mode is
>supported or not.
Yes, we want to support SFP+.
10G is tested in fixed mode on SFP+.
Based on your suggestions, dynamic switching of PHY interface is handled.
And check in probe is for hardware support for user selected interface,=20
which can be moved to  validate callback but then supported mask will be em=
pty.

>However, with what you've indicated through our discussion, your MAC
>does not support BASE-X modes, nor does it support 10GBASE-R, both of
>which are required for direct connection of SFP or SFP+ modules.
1000Base-X and 10GBASE-R supported by separate PCS.=20

Regards,
Parshuram Thombare
