Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801B17B69C
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 02:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbfGaAQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 20:16:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34996 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726210AbfGaAQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 20:16:04 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6V08B9O004436;
        Tue, 30 Jul 2019 17:15:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=1cP2hSX/3zk+VjxEdT+WCzYrb6por2mdG5SMMxd4wg4=;
 b=Q9y6z5zgJOWDMrWr9sZOlg2MFCSrbALJ1V3mcj1DL4314gfhDEoHIf3AZTvpI3JAd0QX
 SvYjA1xv0Pts6L1bEeInzaYXVxUoIYOv6Bh2/I0nH8+LoMbzEvHziYyCxBunJFzWmI15
 gwu77A3VHpKJq5271eSX7rjhI5UgBUZ2eck= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2ty516wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jul 2019 17:15:51 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 17:15:49 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 17:15:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvZPRX7dpxOn6CcZ8VqYkNBgffc/i5eLiqIvC4iSHZoDJ4NQIQCKcJr3dNMVjvAZsDbA4bPteuLJODzDN0DQEEzQ79Pve0fi7lJ/78WVe2hf+xfBrHG6KTBxUORDqdmNLRpRlLDWLglHupzJwx6S4GX/HPQfdCP9fF13tGeV2WMVe+2iDoJ3PHyfdFS91absPyTszmdimTlRuZqfk+B9OArTZ1rr+y/3XhO1LTGujcC7s0sQXXukLwrkfVC1oLU0I5rssMTgCoQpvQUb4UMubkJ2yrJnc1tFwBB8QC3z3+TeWff5bMa8enUlHRzn/Zs2OglWslKy977Os+W/xF1ftQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cP2hSX/3zk+VjxEdT+WCzYrb6por2mdG5SMMxd4wg4=;
 b=KWxlsHckBFLpWXLco6mEpH6Phov4l+pz2acCf/sbX/uQQ89t4sHgB4wz6DtM5ZuCzgXH9YMHYOENFarEWj9cC+FSScvZR/CBVSHyjk5A/R54MN+Tjlb/50ZCbahdvzQHlwbyyP1xACRUrRlx62bsmhfk/Efck5wCfsLcv4X65mFnApLyMs0FaXZTJOdExI/aFs3azB1f43zvprQ7BTb0QQIG+WsyfME7rJy7cdsHSzNAPPyu7YJjBMIo8GDZvXmv7iYtRPa9OGYEBRDK5/kw4H8Ft5A8gMI38SpUUFAwJ4iCLOAxO3E95lG5/Kk6CeLz4W7OvubWBkhHtHSCKoH61Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cP2hSX/3zk+VjxEdT+WCzYrb6por2mdG5SMMxd4wg4=;
 b=FrLjwJt267UkW14d1Os7YoLM8yoaU2TZ38Ojn7mycaGyuvv5q4m+Yu7OBRqqgzAPbBtBK89oU+w69aFt7rl5Ij6JCDdPwExwDc4cEcwmkkAzo5khTkj3wB2wIJEcLqAWlt6whwP3yol62QFUFcRuutKZsc5rttyZIlhekEfMTe0=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1502.namprd15.prod.outlook.com (10.173.235.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.12; Wed, 31 Jul 2019 00:15:48 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c%8]) with mapi id 15.20.2136.010; Wed, 31 Jul 2019
 00:15:48 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Arun Parameswaran" <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next 2/2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Topic: [PATCH net-next 2/2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Index: AQHVRm4oHxOo2s4k1kyYCsigpkISsabiYHeAgAA34ACAAFoWAIAAMvGAgAC3+AA=
Date:   Wed, 31 Jul 2019 00:15:48 +0000
Message-ID: <ed0a7455-1999-90c2-6d7c-a6587542c804@fb.com>
References: <20190730002549.86824-1-taoren@fb.com>
 <CA+h21hq1+E6-ScFx425hXwTPTZHTVZbBuAm7RROFZTBOFvD8vQ@mail.gmail.com>
 <3987251b-9679-dfbe-6e15-f991c2893bac@fb.com>
 <CA+h21ho1KOGS3WsNBHzfHkpSyE4k5HTE1tV9wUtnkZhjUZGeUw@mail.gmail.com>
 <20190730131719.GA28552@lunn.ch>
In-Reply-To: <20190730131719.GA28552@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0014.namprd14.prod.outlook.com
 (2603:10b6:301:4b::24) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:463a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9b09410-359f-425d-56cc-08d7154c3d46
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1502;
x-ms-traffictypediagnostic: MWHPR15MB1502:
x-microsoft-antispam-prvs: <MWHPR15MB15022396764FB81AEC6A9636B2DF0@MWHPR15MB1502.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(396003)(376002)(39860400002)(189003)(199004)(86362001)(66946007)(14444005)(11346002)(46003)(8936002)(53936002)(486006)(66476007)(64756008)(14454004)(316002)(65956001)(66556008)(65806001)(476003)(2616005)(446003)(31686004)(58126008)(54906003)(110136005)(7416002)(71190400001)(71200400001)(2906002)(256004)(66446008)(6246003)(81166006)(8676002)(4326008)(31696002)(6436002)(478600001)(65826007)(6486002)(6512007)(229853002)(7736002)(25786009)(81156014)(36756003)(68736007)(64126003)(6116002)(76176011)(186003)(52116002)(5660300002)(4744005)(99286004)(305945005)(102836004)(6506007)(386003)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1502;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wAQGDtfDEAHgZgI4W8Alt7lHS+JZgO8ol+PXbrRM6tAc1NbRKS2TxUH2QxPYQHlnKxlqNGvx6Q2SMzC+t6p2gGIFHVLkMvbjdzCZ+MlMtvbe9/4GtUzW+fCZ4IrzvLLZVXWceeJe8NSbjnmZABKxBsjWhdR9dkPjhgJT5evUPyPHXfQmSSXrhBKk//SfxSxHIQ4TDartEosGAn3/1PVr0CYvfyararopHTo1rqprvvZ/qAhZhnJgtutTG+c0TNE8htDabD6cMMQho0VFxvArF2R5l7LEoAfPtjtdtw8fDvtEZkZGIrUbS7y/Ed4fo2TdyKsfUlRS4HLtuTY6j/V9qaovveJ1ox0qisMUqCheVyRi//AKES4Oe4/O3jH8r/4eTOMZqHS93MehlCo8XY0DQLGB/kbHvCxDV0nbCpbwkQk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF27B83DF65E3C43AA973C4833857C05@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b09410-359f-425d-56cc-08d7154c3d46
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 00:15:48.8043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: taoren@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1502
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8zMC8xOSA2OjE3IEFNLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+IEFnYWluLCBJIGRvbid0
IHRoaW5rIExpbnV4IGhhcyBnZW5lcmljIHN1cHBvcnQgZm9yIG92ZXJ3cml0aW5nIChvcg0KPj4g
ZXZlbiBkZXNjcmliaW5nKSB0aGUgb3BlcmF0aW5nIG1vZGUgb2YgYSBQSFksIGFsdGhvdWdoIG1h
eWJlIHRoYXQncyBhDQo+PiBkaXJlY3Rpb24gd2Ugd291bGQgd2FudCB0byBwdXNoIHRoZSBkaXNj
dXNzaW9uIHRvd2FyZHMuIFJHTUlJIHRvDQo+PiBjb3BwZXIsIFJHTUlJIHRvIGZpYmVyLCBTR01J
SSB0byBjb3BwZXIsIGNvcHBlciB0byBmaWJlciAobWVkaWENCj4+IGNvbnZlcnRlciksIGV2ZW4g
UkdNSUkgdG8gU0dNSUkgKFJUTDgyMTFGUyBzdXBwb3J0cyB0aGlzKSAtIGxvdHMgb2YNCj4+IG1v
ZGVzLCBhbmQgdGhpcyBpcyBvbmx5IGZvciBnaWdhYml0IFBIWXMuLi4NCj4gDQo+IFRoaXMgaXMg
c29tZXRoaW5nIFJ1c3NlbGwgS2luZyBoYXMgUEhZTElOSyBwYXRjaGVzIGZvciwgd2hpY2ggaGF2
ZSBub3QNCj4geWV0IGJlZW4gbWVyZ2VkLiBUaGVyZSBhcmUgc29tZSBib2FyZHMgd2hpY2ggdXNl
IGEgUEhZIGFzIGEgbWVkaWENCj4gY29udmVydGVyLCBwbGFjZWQgYmV0d2VlbiB0aGUgTUFDIGFu
ZCBhbiBTRlAuDQoNClRoYW5rIHlvdSBBbmRyZXcuIExldCBtZSBzZWUgaWYgdGhlIG9wZXJhdGlu
ZyBtb2RlIGNhbiBiZSBhdXRvLWRldGVjdGVkIG9uIEJDTTU0NjE2UyBjaGlwLCBhbmQgSSB3aWxs
IHVwZGF0ZSBiYWNrIHNvb24uDQoNClRoYW5rcywNCg0KVGFvDQo=
