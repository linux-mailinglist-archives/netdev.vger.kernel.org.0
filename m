Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2EC54D7D
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730765AbfFYLXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:23:11 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:39944 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729846AbfFYLXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 07:23:11 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5PBHtN9002099;
        Tue, 25 Jun 2019 04:23:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=et4wUWJVZw057/2q8zGK44n5ER/JuZX7HsjPYPzGYZo=;
 b=A9puFINNCzfiI65jGQWbRaMLtLeopdgDlodVIYdPLSVo3t3JNc7rnaWdTYb6x17KopMt
 6cDuum8EXymifsh+UerqrvQC+TsSfHf5NFDmRrZ9bv3HheLm3WQh2KlkCUatN7ZYAryA
 L/dPEYtelllgZYlj2VYVH+3ljs3hhnSZaUGKVtCAmZg7xQkd2r98YaoBMrtafAiIZE3f
 +dZT3YMJDUNf3lBOL2t8mknriI3vwDz44w1kaMcsGnvGw9usAhPYdrTjOowvRvqxm25S
 OpNbh0yVi7r6p3bvUKUgCKTlxZS7iDjqA2iQlDaAErmtbUEZKrdBGWXs7XNQL9jEMNkx lA== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2054.outbound.protection.outlook.com [104.47.42.54])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t9gvsc8r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 04:23:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=et4wUWJVZw057/2q8zGK44n5ER/JuZX7HsjPYPzGYZo=;
 b=qlPYkjqKVMnWoTHTlajdQi2r5KGl1ZGCYwCBuOCzxA945fkXxw0Y/mHeM/21XpnhwihQNXvl5nNnhqdBCpockb0r15taHdgGnk/BWQOxt6mXCHIA2tuGbygeVNmHgIsAU+uq7BLXAcaRTJwFvwIHicp5ISvP+lP2JhQy43ds0j4=
Received: from SN2PR07MB2480.namprd07.prod.outlook.com (10.166.212.14) by
 SN2PR07MB2736.namprd07.prod.outlook.com (10.167.19.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 11:23:00 +0000
Received: from SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba]) by SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba%10]) with mapi id 15.20.2008.014; Tue, 25 Jun
 2019 11:23:00 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: RE: [PATCH v4 4/5] net: macb: add support for high speed interface
Thread-Topic: [PATCH v4 4/5] net: macb: add support for high speed interface
Thread-Index: AQHVKaViPgBsYhBhPEirHsdMjDQLc6apV+MAgAEGcyCAAGt/gIABQWYAgAApO4CAAAirwA==
Date:   Tue, 25 Jun 2019 11:23:00 +0000
Message-ID: <SN2PR07MB2480F022835F78FDAA085236C1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281806-13991-1-git-send-email-pthombar@cadence.com>
 <20190623150902.GB28942@lunn.ch>
 <CO2PR07MB2469FDA06C3F8848290013B8C1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
 <20190624131307.GA17872@lunn.ch>
 <SN2PR07MB2480DBE64F2550C0135335EEC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
 <20190625105101.xvcwgt3jh5pk7p2x@shell.armlinux.org.uk>
In-Reply-To: <20190625105101.xvcwgt3jh5pk7p2x@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy05NTAxOTU3OC05NzNiLTExZTktODRmOS0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcOTUwMTk1N2EtOTczYi0xMWU5LTg0ZjktMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSI1ODIiIHQ9IjEzMjA1OTM1Mzc4MDUwNDE2OCIgaD0iK2tCU2ptaktVamJUN0cxOWpEZmU5VTk3a2dvPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08589f9c-0c78-43af-c54f-08d6f95f7b3f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN2PR07MB2736;
x-ms-traffictypediagnostic: SN2PR07MB2736:
x-microsoft-antispam-prvs: <SN2PR07MB2736C824AA9DA0B84EE06F41C1E30@SN2PR07MB2736.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(376002)(366004)(39860400002)(36092001)(189003)(199004)(33656002)(66066001)(6916009)(81156014)(66556008)(81166006)(7696005)(446003)(478600001)(102836004)(78486014)(55236004)(64756008)(66476007)(5660300002)(4744005)(6246003)(76176011)(305945005)(66446008)(3846002)(9686003)(55016002)(25786009)(256004)(14454004)(52536014)(99286004)(54906003)(6116002)(53936002)(7736002)(4326008)(66946007)(68736007)(71190400001)(73956011)(2906002)(6506007)(107886003)(74316002)(186003)(229853002)(486006)(6436002)(71200400001)(8936002)(26005)(316002)(8676002)(86362001)(76116006)(11346002)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR07MB2736;H:SN2PR07MB2480.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eMAsI+w88vomGQczjEEL8es972GiwCQ/CPN9z23xNgoGSfth4AcVD8b8wE1XDKwPnj5GEPivA947IZ4pNkKCzwzoXvqiBRARIR6qsmJbFj38p4HcmkzIEeoC1pzMg3bgMOBr1TrJYUVpeQmYd1NCoVmMfO6VtcOhn2DBojC5Oe2fmC492qJeoR+9xxVNlwjjsXEMngFk7kTkWpTNwyYf2tgFSB8H1WaH+4YFNXXL3/36JeQcWyQK33f+LRGKLpsb4K5/b7orsxk5bhpvB7A0pfl3YpMGPL6lHsp8VydAzLmzLYSIaSau40YgXR+MFrFE1MvxAL512gYnLnf4X+HnkbxxBZHcBkt4aR8BRN9oMMjHkFS4KQ0oRbH4SvNI7DrnbOJaGudmkrvsk2sJ6FpQcvP933876glSJKxDwKm3d4w=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08589f9c-0c78-43af-c54f-08d6f95f7b3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 11:23:00.3599
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
 mlxlogscore=793 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250091
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>The closed nature of the USXGMII spec makes it very hard for us to know
>whether your implementation is correct or not.
>
>I have some documentation which suggests that USVGMII is a USXGMII link
>running at "5GR" rate as opposed to USXGMII running at "10GR" rate.
>
>So, I think 5G mode should be left out until it becomes clear that (a)
>we should specify it as USXGMII with a 5G rate, or as USVGMII.
>
Ok, I will remove 5G rate for USXGMII.

Regards,
Parshuram Thombare
