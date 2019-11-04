Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59417EEE22
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 23:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388415AbfKDWMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 17:12:20 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14636 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729549AbfKDWMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 17:12:19 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA4M1R8T024594;
        Mon, 4 Nov 2019 14:12:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=J/5qeNIAcORCNUFS8grWwmip5tTBTVDL8w+D51z59UQ=;
 b=TFePQXd+PdGbpzSsQBn0T0vlp3HL8qUdIAQqHjsY5878WX19G1qf0/7fjXAut9xdnjDs
 rYalUxsAOhnz3Ffe0Yt88PAqaUFUrxiPBwwAlRIxAc5aEGFXDf0iBD2VXnFYZHdY45lq
 YADp35dWGvitRzSCVBQifj1hzehLLK1LhGU4oXaj14szqxZxrHfKxvL3DAlv5mbcN38d
 VJYQvVJLDnb30LiCXVpeDYJtHokhQ3qxbk6uxkAnPo9sgbVMid6/UR6ZFa6gnEm6vueR
 yLwv1zJ+7SWOqcnYSx1uolCcF9pVKXiO1a6icP1VS2ZjeNmpMQFKP4b7fXoHK1k2Neii WA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w17n8yu3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 04 Nov 2019 14:12:18 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 4 Nov
 2019 14:12:17 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.50) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 4 Nov 2019 14:12:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnjJJUSDnlVwIGCKTPIq/UaKuQ++EVdsZnruJ/w9nAq+cEoErIOCcSCYgxq5INxn35sqq/8EWsMfTOXaGBfGmXti9SCvZriAsHbCZjxZ+C3jYRP5zbL9LQVrlgP9fsm4RpyOgl3+hzDmQrY1z6FgPwV/bP6AWCoSkhYIuU0I+366kqBEg5B+L87hjpFJU6j8nJrEGR/taXocBzrTID98RZx8xzahlYU0nK/978B5Y+7Jix/VsSr7PM2c+/1lkkTENAA6PV0JuEc9Y3KdbC87UJCzsBHJPjaM/dw2Myrl/Kf7EkxVtzbQ+IMtBaY4nhwqwArP0ZuHfEj9iJe379eVeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/5qeNIAcORCNUFS8grWwmip5tTBTVDL8w+D51z59UQ=;
 b=FzdRCqn4dlLBpoGL6+mO8hv8aRdfzy6O+O9zcAvsZo9dg05xqaKjLmE2g46uDHEB3dhrn3iM1cSPea6pcf9wIivBFV21iMtXT3lcxhkd8M6BZ51y8cbjcaTB8ZerwOhTF/65hVVa+/VQ1rQNqwziiE09Q9IFutb6+S0pWVIbKgqVg5Xsc3eNwcmy/gKXFkPCf6q2XJ0e8k8O9pYVIpwbjYSprcwCt+WNxZY796tycPQ13dVvRsrNnIFsuramLCpwUTewXX9TaDl9YYCw3GuuGE2pgiBrQSDOTA/IpIXZncSYQvKBY0chI3lV7chmPmIFsH++nvp3+DAFRihfWgCRJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/5qeNIAcORCNUFS8grWwmip5tTBTVDL8w+D51z59UQ=;
 b=L+lFwEOK3hmnRj8w1PlK1JI+OVXlyZCd1/uZedyF3RGc+vlc5I2glBsFDWAjCAaRcNHfPWrAtvM3qa6vWvJrMdOXh3UIwZXKXaSpShiMiL2lYmVGqE8PZPkALlpe3G7Da9RNk4WNuuP/JDDWwnM9f8MWfXXiAxvYV5NH5FDXOCs=
Received: from DM5PR18MB1642.namprd18.prod.outlook.com (10.175.224.8) by
 DM5PR18MB0971.namprd18.prod.outlook.com (10.168.116.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 22:12:15 +0000
Received: from DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15]) by DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15%10]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 22:12:15 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 07/12] net: atlantic: loopback tests
 via private flags
Thread-Topic: [EXT] Re: [PATCH net-next 07/12] net: atlantic: loopback tests
 via private flags
Thread-Index: AQHVkK5PevX5L1L65UKTRGodnIDJLg==
Date:   Mon, 4 Nov 2019 22:12:15 +0000
Message-ID: <ed12ecfd-6ac3-2547-a324-5f97080e9815@marvell.com>
References: <cover.1572610156.git.irusskikh@marvell.com>
 <76690e382c4916800aa042b393721d263feb18fe.1572610156.git.irusskikh@marvell.com>
 <20191101.101518.2091216468172595538.davem@davemloft.net>
In-Reply-To: <20191101.101518.2091216468172595538.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: GVAP278CA0012.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:20::22) To DM5PR18MB1642.namprd18.prod.outlook.com
 (2603:10b6:3:14c::8)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d66b1ecb-d486-469a-7300-08d761740c9f
x-ms-traffictypediagnostic: DM5PR18MB0971:
x-microsoft-antispam-prvs: <DM5PR18MB097115577F3FE6F0A341DE2AB77F0@DM5PR18MB0971.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:201;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(189003)(199004)(6506007)(4744005)(7736002)(86362001)(25786009)(3846002)(186003)(8676002)(6512007)(256004)(31696002)(5660300002)(305945005)(486006)(66946007)(66556008)(8936002)(66446008)(476003)(64756008)(66476007)(81156014)(4326008)(6116002)(99286004)(11346002)(36756003)(2616005)(446003)(6246003)(6916009)(6436002)(478600001)(52116002)(2906002)(26005)(66066001)(6486002)(81166006)(76176011)(14454004)(71200400001)(229853002)(71190400001)(102836004)(386003)(316002)(31686004)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB0971;H:DM5PR18MB1642.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YQLit1mlqwzlAPfOephJrmT8dAD78ES090rYCOK9cjXoJSmbQuSjJzqtLvX1GMXr0OvF7E+HDgM8iPo0bQRByJs5lq9CrzT4GC8anM1W/tYG+cwS1CFBU1Oy/Lp+gN9C66TAzkvqWQ1+R535THYTryMfeNYJXnMrS3ZuElI9VdV2HPJRHQ2q9OsCU/H5WTqle1/rCtKDk5hYwXNIiOtblr5lo6YtakQzZqLyb+jqszz8iL5x1PUA4fQppsNPQM0ngnvCbvm3gLnkgWA1pwe8/AEzVRDbMfSiGNrRr8MPBOtZPxZpYCAONAPANE34h7xZ+RmxXKh/aJJ0GnJDi/3ebr/vAGyaLsrhNBDhmTj2Slz2I78OO+QDeq/MDos0vpvKqGSps1ehnK1+GbIxlywOREm7YsiHBES86XGN5QOA3rLMveNdILYu289fUnw7+Ljd
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F264EF04DBA2B5489C2EF46F29209DB8@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d66b1ecb-d486-469a-7300-08d761740c9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 22:12:15.7309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S1YvqdhkkoEXYhJA0+NHGFtYGBdJzjh6Nh4rTmu6k7Fy8je8tNjw2ZmdcIE2Qi5eQsxnhrrABM0xDcRvv9X21g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB0971
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-04_11:2019-11-04,2019-11-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDEuMTEuMjAxOSAyMDoxNSwgRGF2aWQgTWlsbGVyIHdyb3RlOg0KPiBFeHRlcm5hbCBFbWFp
bA0KPiANCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBGcm9tOiBJZ29yIFJ1c3NraWtoIDxpcnVzc2tpa2hA
bWFydmVsbC5jb20+DQo+IERhdGU6IEZyaSwgMSBOb3YgMjAxOSAxMjoxNzoyMSArMDAwMA0KPiAN
Cj4+ICtpbnQgYXFfZXRodG9vbF9zZXRfcHJpdl9mbGFncyhzdHJ1Y3QgbmV0X2RldmljZSAqbmRl
diwgdTMyIGZsYWdzKQ0KPj4gK3sNCj4+ICsJc3RydWN0IGFxX25pY19zICphcV9uaWMgPSBuZXRk
ZXZfcHJpdihuZGV2KTsNCj4+ICsJc3RydWN0IGFxX25pY19jZmdfcyAqY2ZnID0gJmFxX25pYy0+
YXFfbmljX2NmZzsNCj4+ICsJdTMyIHByaXZfZmxhZ3MgPSBjZmctPnByaXZfZmxhZ3M7DQo+IA0K
PiBSZXZlcnNlIGNocmlzdG1hcyB0cmVlLg0KDQpIaSBEYXZpZCwgdGhhbmtzLCB3aWxsIGZpeC4N
Cg0KDQotLSANClJlZ2FyZHMsDQogIElnb3INCg==
