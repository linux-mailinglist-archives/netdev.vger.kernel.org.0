Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45FB77B68E
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 02:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbfGaANB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 20:13:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52230 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726253AbfGaANA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 20:13:00 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6V08WZ7016955;
        Tue, 30 Jul 2019 17:12:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Ic8JxuFXGjnGAUEgKrj189WzHzMbYXqdmaNGuKeTNGI=;
 b=Bl3subIr+mvaZRZZdX1OVt6VS3a4FqtlxIoqTBTAUJMKSaLmcaeOD5ZA3CXDvT4j0lFR
 AgUxq9jSo0tqFTeEjTmLzi5ak40IADgpWfMgJ/dye2ohQoWBV6UgN/b0CDn97zUqTK4s
 59ajCbZu2zkE7xPo5Td1R2DEV2193rrEYTw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2wufrfha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 30 Jul 2019 17:12:43 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 30 Jul 2019 17:12:41 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 30 Jul 2019 17:12:41 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 17:12:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYtsw9opSzH0IYJcGG4mT8sWO0AYFvZa0T+YfdpHYwIQu2GUceOkIe5j9GMLqWbVdGjyxzzk6jIJdEP1EoExZXo6zxVJNTIWo2cuiKsS5hnOlfsZGzdECuMnBprNv8M3xHQnSLhrz82SWW0q1CCiv2LmEZ6FzR37Y0E4B1+yoYqQGQaYF0CSZTU7QhP8RxIdqVmp6/SwgD3P34fzsbnq+QzTzuedJenWYNw2PDN7nwg1YlHRIUL2KcjK8Yl49Fe1piqrZW+bBJHlOyqR07w7+51Oi6cc/UoBFyOy2gikYdSCPcW5QMPNzXb0sBUYpmQRHuSyAk+CuwTLQ/x2nhHEEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ic8JxuFXGjnGAUEgKrj189WzHzMbYXqdmaNGuKeTNGI=;
 b=nX8tPYJgJlQWW0JTITIpz1cYGUzHeON27gmwavuZKsm7NowKKTwHxNR0qSimJfWQXaZ3Fn5xvdqJdOsed3cMJNAnFtSPFZgr7P6wIJVar3lc+bPInmg6FBYeb4+DOXUqpfsageIJg2u0zX1VG8kNq6ZkC9tKIMRLzM/qhNylxAXQT0c57CuiCFdO2mU4owucGnT+N22Z0MtcEep571pKvtNSJEGA6KTkbdS50FfVzwWFogYUmwpuM8kCH/s/0H53kqP2BfxyIItwD/M/1ug1FXGOBgB/cqVUZBtWPT2cV2uWTgb1WtPUp1sQ429cK4rppmM76QjjrwKA8nYGyrYljQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ic8JxuFXGjnGAUEgKrj189WzHzMbYXqdmaNGuKeTNGI=;
 b=RSM9ux8QvC8vfJ/jeVKa2VqFSqnsaN/cbezeUhNFKim2CAfCrXv+Bd5EOE8RLhHRJ3iceXszWHbK9MioAtp1kzy5tTYfrhpeVujBzdVZGTCgFOVNlp0pBlW1tsTfigy9Srp8y9qTu5NnVQR162HXbq9pQyUZL5cSwnvqqr5QOWE=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1455.namprd15.prod.outlook.com (10.173.234.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Wed, 31 Jul 2019 00:12:40 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c%8]) with mapi id 15.20.2136.010; Wed, 31 Jul 2019
 00:12:40 +0000
From:   Tao Ren <taoren@fb.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next 1/2] net: phy: broadcom: set features explicitly
 for BCM54616S
Thread-Topic: [PATCH net-next 1/2] net: phy: broadcom: set features explicitly
 for BCM54616S
Thread-Index: AQHVRm4tZSvvLl002ECU4Omi5U5C86bigvAA//+jr4CAAISsAIABMSsA
Date:   Wed, 31 Jul 2019 00:12:40 +0000
Message-ID: <f59c2ae9-ef44-1e1b-4ae2-216eb911e92e@fb.com>
References: <20190730002532.85509-1-taoren@fb.com>
 <20190730033558.GB20628@lunn.ch>
 <aff2728d-5db1-50fd-767c-29b355890323@fb.com>
 <bdfe07d3-66b4-061a-a149-aa2aef94b9b7@gmail.com>
In-Reply-To: <bdfe07d3-66b4-061a-a149-aa2aef94b9b7@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0030.namprd08.prod.outlook.com
 (2603:10b6:301:5f::43) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:463a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63528a20-93f9-4514-6cfd-08d7154bccc5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1455;
x-ms-traffictypediagnostic: MWHPR15MB1455:
x-microsoft-antispam-prvs: <MWHPR15MB14554DE8CBB2F368A003C1C9B2DF0@MWHPR15MB1455.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(396003)(376002)(39860400002)(199004)(189003)(40764003)(25786009)(65956001)(256004)(229853002)(6116002)(65806001)(52116002)(7416002)(86362001)(65826007)(66446008)(66476007)(58126008)(5660300002)(110136005)(64756008)(305945005)(64126003)(31696002)(6486002)(316002)(54906003)(68736007)(66556008)(6436002)(6512007)(11346002)(36756003)(2906002)(2616005)(486006)(446003)(478600001)(99286004)(66946007)(46003)(31686004)(71190400001)(53546011)(53936002)(476003)(14454004)(6246003)(8936002)(186003)(7736002)(81156014)(102836004)(6506007)(386003)(4326008)(71200400001)(76176011)(81166006)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1455;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: J6JKrxSmXyqXcjaZsAEElcZpVJBX/IhbJE2uXZ6aiYrptD1s47oGaBA3GlWosgDaq4E8Nbua6oGlsg00+n5Wq608wstlqfP9PpKIsRq6UnUGhaBvEQGZrCJo98/Uph4okd2aSE1BsiiQDI9YOZNFkQfwq6909Go+qvX9+sgwXBMg5t/v2mUCxJ80B8sLe3Ow+9mPbDsTeATlg6OhGxMCkokufuYyfnY73wDTnY97SMsK+aDj4s9moqzkn5G9uQBl9T/HbB+AYgIT2Oox+M1ckKkHMnrJm0fkWeMxYrzOD74ybRZDXycq1UUA1UfWXqWXs9xA/ukyWV7bZGQtNYZlHEeF1iRvHGXXn9Xd1uL+ZFA5W7fsNJpDGxbebkRxUm21Z/Dz3+s9sWVPMtl+pj9EMtIojmKqJh1suCqe+p3kxWs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48D72DA867A88C4DB62D92387243E12B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 63528a20-93f9-4514-6cfd-08d7154bccc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 00:12:40.0707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: taoren@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1455
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

T24gNy8yOS8xOSAxMTowMCBQTSwgSGVpbmVyIEthbGx3ZWl0IHdyb3RlOg0KPiBPbiAzMC4wNy4y
MDE5IDA3OjA1LCBUYW8gUmVuIHdyb3RlOg0KPj4gT24gNy8yOS8xOSA4OjM1IFBNLCBBbmRyZXcg
THVubiB3cm90ZToNCj4+PiBPbiBNb24sIEp1bCAyOSwgMjAxOSBhdCAwNToyNTozMlBNIC0wNzAw
LCBUYW8gUmVuIHdyb3RlOg0KPj4+PiBCQ001NDYxNlMgZmVhdHVyZSAiUEhZX0dCSVRfRkVBVFVS
RVMiIHdhcyByZW1vdmVkIGJ5IGNvbW1pdCBkY2RlY2RjZmUxZmMNCj4+Pj4gKCJuZXQ6IHBoeTog
c3dpdGNoIGRyaXZlcnMgdG8gdXNlIGR5bmFtaWMgZmVhdHVyZSBkZXRlY3Rpb24iKS4gQXMgZHlu
YW1pYw0KPj4+PiBmZWF0dXJlIGRldGVjdGlvbiBkb2Vzbid0IHdvcmsgd2hlbiBCQ001NDYxNlMg
aXMgd29ya2luZyBpbiBSR01JSS1GaWJlcg0KPj4+PiBtb2RlIChkaWZmZXJlbnQgc2V0cyBvZiBN
SUkgQ29udHJvbC9TdGF0dXMgcmVnaXN0ZXJzIGJlaW5nIHVzZWQpLCBsZXQncw0KPj4+PiBzZXQg
IlBIWV9HQklUX0ZFQVRVUkVTIiBmb3IgQkNNNTQ2MTZTIGV4cGxpY2l0bHkuDQo+Pj4NCj4+PiBI
aSBUYW8NCj4+Pg0KPj4+IFdoYXQgZXhhY3RseSBkb2VzIGl0IGdldCB3cm9uZz8NCj4+Pg0KPj4+
ICAgICAgVGhhbmtzDQo+Pj4gCUFuZHJldw0KPj4NCj4+IEhpIEFuZHJldywNCj4+DQo+PiBCQ001
NDYxNlMgaXMgc2V0IHRvIFJHTUlJLUZpYmVyICgxMDAwQmFzZS1YKSBtb2RlIG9uIG15IHBsYXRm
b3JtLCBhbmQgbm9uZSBvZiB0aGUgZmVhdHVyZXMgKDEwMDBCYXNlVC8xMDBCYXNlVC8xMEJhc2VU
KSBjYW4gYmUgZGV0ZWN0ZWQgYnkgZ2VucGh5X3JlYWRfYWJpbGl0aWVzKCksIGJlY2F1c2UgdGhl
IFBIWSBvbmx5IHJlcG9ydHMgMTAwMEJhc2VYX0Z1bGx8SGFsZiBhYmlsaXR5IGluIHRoaXMgbW9k
ZS4NCj4+DQo+IEFyZSB5b3UgZ29pbmcgdG8gdXNlIHRoZSBQSFkgaW4gY29wcGVyIG9yIGZpYnJl
IG1vZGU/DQo+IEluIGNhc2UgeW91IHVzZSBmaWJyZSBtb2RlLCB3aHkgZG8geW91IG5lZWQgdGhl
IGNvcHBlciBtb2RlcyBzZXQgYXMgc3VwcG9ydGVkPw0KPiBPciBkb2VzIHRoZSBQSFkganVzdCBz
dGFydCBpbiBmaWJyZSBtb2RlIGFuZCB5b3Ugd2FudCB0byBzd2l0Y2ggaXQgdG8gY29wcGVyIG1v
ZGU/DQoNCkhpIEhlaW5lciwNCg0KVGhlIHBoeSBzdGFydHMgaW4gZmliZXIgbW9kZSBhbmQgdGhh
dCdzIHRoZSBtb2RlIEkgd2FudC4NCk15IG9ic2VydmF0aW9uIGlzOiBwaHlkZXYtPmxpbmsgaXMg
YWx3YXlzIDAgKExpbmsgc3RhdHVzIGJpdCBpcyBuZXZlciBzZXQgaW4gTUlJX0JNU1IpIGJ5IHVz
aW5nIGR5bmFtaWMgYWJpbGl0eSBkZXRlY3Rpb24gb24gbXkgbWFjaGluZS4gSSBjaGVja2VkIHBo
eWRldi0+c3VwcG9ydGVkIGFuZCBpdCdzIHNldCB0byAiQXV0b05lZyB8IFRQIHwgTUlJIHwgUGF1
c2UgfCBBc3ltX1BhdXNlIiBieSBkeW5hbWljIGFiaWxpdHkgZGV0ZWN0aW9uLiBJcyBpdCBub3Jt
YWwvZXhwZWN0ZWQ/IE9yIG1heWJlIHRoZSBmaXggc2hvdWxkIGdvIHRvIGRpZmZlcmVudCBwbGFj
ZXM/IFRoYW5rIHlvdSBmb3IgeW91ciBoZWxwLg0KDQoNClRoYW5rcywNCg0KVGFvDQo=
