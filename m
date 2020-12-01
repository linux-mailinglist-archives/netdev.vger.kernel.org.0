Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257582C9583
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 04:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgLADDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 22:03:44 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:23594 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725859AbgLADDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 22:03:43 -0500
Received: from pps.filterd (m0170389.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B12wEa2023908;
        Mon, 30 Nov 2020 22:02:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=m5jLSUbFmoeerZ/tq9ojWOSM2y4gZiSgFGtBMVbh+yI=;
 b=RvaYHkTMh9v3cVhfHcg4CLlET56Uv5p+v6BgWknot8eRu8mosRfcMyl5So0yjX3FfEgn
 R+qLlLNi0FLAmEurpfjjaKMXhisidf+WLidShx5gkeiUPDqriMFR0PFJn+NOieegboWA
 z1rPhYzWXZW25h43n3uwgKQVkUKEXf2bOJ+p7LEfUUeuxTxrkEfIyuipnfm5GmepDwuu
 hEPmRZu2953OYs0dr5/nPPPAswlp0S5jxmoXYH63Z9UOjybR4aOHNx29NJh5FbunzdRi
 b6PjlnQB9ycTBlllbf6YfJewG7phgsT0Dux2U3/U0l6G5NGMgn81wvGZ2e1nVOGZxGQi QA== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0a-00154904.pphosted.com with ESMTP id 353keq0e9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 22:02:54 -0500
Received: from pps.filterd (m0089483.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B12wGPa062291;
        Mon, 30 Nov 2020 22:02:53 -0500
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by mx0b-00154901.pphosted.com with ESMTP id 355cefs3kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 22:02:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBFZnTBCgSIS4s3kAaQef0fdjGvT4BFx+alNrRerC+iwsUJMx85rTf5H3dcXpr73tA+fd+eHgN7impvzjPZuR3qDMqLJ1kg1T+8Rp8RjGTPXqQIYd1B4gHP5bxdQsHdDF0+gmw5NPWALTva2vZwndafdBaBHBdbrZRmU174u6NRvAU1pOdFnd7DjCTqnORfm/Fj+3tFLqZYGRX8Rmupu+KQGfc2CVQXrvqI6P2PzUSdUflY7DCG7QwUMnflLG7f3AzDF8R4v2hgYHKwuyWInuIcnybPKxPy5kEKvB/jczmkYp9j716LUKPPPIVdwZdZh9oFkdSiCX1Hm1UYuKPGcpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5jLSUbFmoeerZ/tq9ojWOSM2y4gZiSgFGtBMVbh+yI=;
 b=ZLRYCZzXgtmpFyC0wVNunX3B4rXaw2rQO+DPQq3JaZMiiKVzfRFtlfWAdOptI7LWydUscQX4AEijdWU8Pws/cGS1BZdT4sp+mNug99sBGbs+JrJMUojBs9tKpelZj8i2N+9njVPdPVghM+vSyuyE0opqnb21vT3FgOpBo/o1OaLgrGwOV7nBwwW5zTEqhtOys3ZI0Vls33kbEssNLh1uXFf+MyYADyjhKEeXRDVVmDrHt0jYJfYuroGTfjiPH8Cs4XMakOvot2+OoQuHzQWc0xus/9y8DaPY4SDCaJlA/sTHdClqrM0fRjK4eeTNSV5bhlOBVapEcwpd0yFxbKztfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5jLSUbFmoeerZ/tq9ojWOSM2y4gZiSgFGtBMVbh+yI=;
 b=PIIw0W3mF8QVv1kxy6aRL7yc6DzC9Sw2t6AfEYh7T43s2JkuuyZwCg0Qy+A7fiPJsF9NthMQGMmOpMwMhbOmVtaFnmCw0Xd4gpE64eWjkzUG086jsh8uC6LVZpteoqJd8XbnYY/y6P0yfX4QuISUNiPsBuXwB8/Xdt041dUlx34=
Received: from DM6PR19MB2636.namprd19.prod.outlook.com (2603:10b6:5:15f::15)
 by DM5PR19MB0153.namprd19.prod.outlook.com (2603:10b6:4:66::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Tue, 1 Dec
 2020 03:02:51 +0000
Received: from DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914]) by DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914%7]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 03:02:51 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@dell.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Stefan Assmann <sassmann@redhat.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: RE: [net-next 1/4] e1000e: allow turning s0ix flows on for systems
 with ME
Thread-Topic: [net-next 1/4] e1000e: allow turning s0ix flows on for systems
 with ME
Thread-Index: AQHWx2BlnSBfbFNF7kaA8I5RcYCtH6nhOZsAgAAAO7CAAAbvAIAATOtw
Date:   Tue, 1 Dec 2020 03:02:51 +0000
Message-ID: <DM6PR19MB2636467945B04B2182FB8999FAF40@DM6PR19MB2636.namprd19.prod.outlook.com>
References: <20201130212907.320677-1-anthony.l.nguyen@intel.com>
 <20201130212907.320677-2-anthony.l.nguyen@intel.com>
 <CAKgT0Uf7BoQ5DAWD8V7vhRZfRZCEBxc_X4Wn35mYEvMPSq-EaQ@mail.gmail.com>
 <DM6PR19MB263628DAC7F032E575C5E5EAFAF50@DM6PR19MB2636.namprd19.prod.outlook.com>
 <CAKgT0UedAJbhh5dA5V+otzXe2Hn3VZ44+=DGEtNWjA5R3sDBug@mail.gmail.com>
In-Reply-To: <CAKgT0UedAJbhh5dA5V+otzXe2Hn3VZ44+=DGEtNWjA5R3sDBug@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Mario_Limonciello@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2020-12-01T03:02:48.7651317Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_ActionId=b3b399a5-af3c-4557-a7da-6086bc70c939;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=Dell.com;
x-originating-ip: [76.251.167.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25e56973-39fd-4fc1-b107-08d895a59789
x-ms-traffictypediagnostic: DM5PR19MB0153:
x-microsoft-antispam-prvs: <DM5PR19MB0153F375CCF8D9E632944044FAF40@DM5PR19MB0153.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dpNfffJDK5J4aAuCxts7ZVJ54QX1OQISMjvvmTGYIuYb08s7ShUM58HkUCNHWSI5VRxPIrD/+Kf/bf8iOEmcOMZKothwa/fHzv0VHNXEIF6XTbaj+QOGeU3LtgoiG02ghOnwSVbA48nIVVXcqSIGOWQMi5TplHfDN2VDdNX7HFAZIgtdscvluc05eaYWVv37hQIDYUWUnTM0YV+NUlf67dl1PM6r5UrWa/x0+jF1nvqd+agp8/2Vy+a61bMDH8oiGbH5VJCav3ylwjLgFQ2IHCIseZEsXE4cIACjdU5e6eb3VihX2AK1zacHp2064xqvoZ6fMrs9ySE5BIG9gwwNFOT8wb9dFWcRWuUpuClBSocN0B/1I9vdUMrNRM++yH9M
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB2636.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(346002)(366004)(5660300002)(478600001)(52536014)(4326008)(316002)(786003)(54906003)(8936002)(55016002)(33656002)(6916009)(8676002)(7696005)(2906002)(66946007)(66556008)(64756008)(6506007)(66446008)(76116006)(186003)(9686003)(26005)(71200400001)(86362001)(83380400001)(66476007)(53546011)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?anlGcGtxNldVbjQvV1pERGVWTnZCajEybXY4UFMvMER5Zk00QkE5NnM3VE41?=
 =?utf-8?B?dldtUzVBR3YxVWNwMzlWTE9WR0lyU2lnSzFpQ0Z5R3Zib1ZtdmVmY3VOUk1r?=
 =?utf-8?B?WXdOWHdqeE5oYWtiazFINDluU1BrSXZJS1RoMk0wYWt5NnlvVzMrY1orbFZp?=
 =?utf-8?B?QS9SYWtJRGhld0RINjY2MXZ1UzgrVXJudHMxN0dZQnRURHVMMmdqNnpXajRB?=
 =?utf-8?B?a3ZXWml1UHdlUllucCtZWUtvNEpoUjFOQnpwQmZtS09vY2FRMHFPcGdGRUhD?=
 =?utf-8?B?L3R2bXcrMTcrazB0Q3VlQlRoMUxQREluRk0zS2E0WldTWHQ5YnJDcUV0dENH?=
 =?utf-8?B?Z2JrRG9CdVlGcmRIVkZFM1oveEVka1h4UGYzcmVzMkpJRFc2Ukd5U2dlMDQ2?=
 =?utf-8?B?SlllVlFGeGJMR0lVMThvTVJqakN3YnZpL0drOVEySGRqU1VlbDJyaXY0ZTBT?=
 =?utf-8?B?L091ZFRtQTBvaGFRSGdQY3hxdlV1bkU2WFVOUEcxOHMveTU4MjFBTnpPVGFw?=
 =?utf-8?B?ZTI3alQ3UUJLOG8vRUZ2Mk9ybExJUGhtSVlVSStnaUhYVUxLYkNRalJoMWl5?=
 =?utf-8?B?NUR5WnJCa3BDaStLa3NncUwwMXZydDdybUFzQ3JnQmxvTGkxRlcwMldLUDYz?=
 =?utf-8?B?cWw5dlFyUTRkSFQyUklQOTB4UXROY0J3dU1uMWV5L205OHhsUGk0OWZTSmF2?=
 =?utf-8?B?MlN6cHRCZWl1dXZrZWQycEYvMkJzenlOT1U0LytSTGZoYll6dmpxYWVtd2cv?=
 =?utf-8?B?RWZYbUptZmthOEZWVlFCRGZmL0lRWWZRRFMzNURrUlFNOTRjSXdxVTQ0V25V?=
 =?utf-8?B?YzVlclRzOVBvZTJQSStQNXBPeFI3SE1RMTVOL2NoU0Z3Q1pDYUZvdG42MHVI?=
 =?utf-8?B?cll5dm9KVENURWx2amI5YmZvdDd0N2ZGbXJhNHY2VWtYaU9qYUZZZ1gxOFJO?=
 =?utf-8?B?M054M0dwcno4WHZHOWp0NFVpMnZiY3lwdFpMVjgxWU1vaG9ycEsrcTlrVnRC?=
 =?utf-8?B?cjZwTVpRenB1aDB2TGxITlZzTUcrUjVuNi9KZ2pBRjd3SmVoTks1MGsrWGVx?=
 =?utf-8?B?WlpMckp1bmVWd2Y3dDFjakxRQkJSeUtNMGw4VUZPQUtjckd0aktRMlgydzdo?=
 =?utf-8?B?QVJOZHBoV1JEc2c4c1hsQlNLalU1QTE4V1dTWGtxTzdGZWtVTzMxQ3BwUmpt?=
 =?utf-8?B?UzIxejRFVm9mOWFtQ0dXQmJyek5BeVBYS1cvcmY5VW9ZdnVYdHBaUER2MlNW?=
 =?utf-8?B?ZUF6VWZZdGdWTC80SjZYdWJPdFpBTExHUTlRZll4a1YvMDN5dGgveHMwcTRC?=
 =?utf-8?Q?GXTvNlATr0orU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB2636.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e56973-39fd-4fc1-b107-08d895a59789
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 03:02:51.6321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 66fbjJ3F/sYTV0kJzvYrfXMBIgAt/ReP1QVCrS7RiN+RIbNLmSttY+lvNWEhgqPG8CYUhlcPRXtGDZGYdXz6kiNRi7XFFw0MQOckhofy1ZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR19MB0153
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 phishscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010018
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010018
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IA0KPiBPbiBNb24sIE5vdiAzMCwgMjAyMCBhdCAyOjE2IFBNIExpbW9uY2llbGxvLCBNYXJpbw0K
PiA8TWFyaW8uTGltb25jaWVsbG9AZGVsbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gPg0KPiA+ID4g
R2VuZXJhbGx5IHRoZSB1c2Ugb2YgbW9kdWxlIHBhcmFtZXRlcnMgYW5kIHN5c2ZzIHVzYWdlIGFy
ZSBmcm93bmVkDQo+ID4gPiB1cG9uLg0KPiA+DQo+ID4gSSB3YXMgdHJ5aW5nIHRvIGJ1aWxkIG9u
IHRoZSBleGlzdGluZyBtb2R1bGUgcGFyYW1ldGVycyB0aGF0IGV4aXN0ZWQNCj4gPiBhbHJlYWR5
IGZvciBlMTAwMGUuICBTbyBJIGd1ZXNzIEkgd291bGQgYXNrLCB3aHkgYXJlIHRob3NlIG5vdCBk
b25lIGluDQo+ID4gZXRodG9vbD8gIFNob3VsZCB0aG9zZSBwYXJhbWV0ZXJzIGdvIGF3YXkgYW5k
IHRoZXkgbWlncmF0ZSB0byBldGh0b29sDQo+ID4gZm9yIHRoZSBzYW1lIHJlYXNvbnMgYXMgdGhp
cz8NCj4gDQo+IFdoYXQgaXQgY29tZXMgZG93biB0byBpcyB0aGF0IHRoZSBleGlzdGluZyBtb2R1
bGUgcGFyYW1ldGVycyBhcmUNCj4gZ3JhbmRmYXRoZXJlZCBpbiBhbmQgd2Ugc2hvdWxkIG5vdCBi
cmVhayB0aGluZ3MgYnkgcmVtb3ZpbmcgdGhlbS4gTmV3DQo+IGRyaXZlcnMgYXJlbid0IGFsbG93
ZWQgdG8gYWRkIHRoZW0sIGFuZCB3ZSBhcmUgbm90IHN1cHBvc2VkIHRvIGFkZCB0bw0KPiB0aGVt
Lg0KPiANCj4gPiA+IEJhc2VkIG9uIHRoZSBjb25maWd1cmF0aW9uIGlzbid0IHRoaXMgc29tZXRo
aW5nIHRoYXQgY291bGQganVzdA0KPiA+ID4gYmUgY29udHJvbGxlZCB2aWEgYW4gZXRodG9vbCBw
cml2IGZsYWc/IENvdWxkbid0IHlvdSBqdXN0IGhhdmUgdGhpcw0KPiA+ID4gZGVmYXVsdCB0byB3
aGF0ZXZlciB0aGUgaGV1cmlzdGljcyBkZWNpZGUgYXQgcHJvYmUgb24gYW5kIHRoZW4gc3VwcG9y
dA0KPiA+ID4gZW5hYmxpbmcvZGlzYWJsaW5nIGl0IHZpYSB0aGUgcHJpdiBmbGFnPyBZb3UgY291
bGQgbG9vayBhdA0KPiA+ID4gaWdiX2dldF9wcml2X2ZsYWdzL2lnYl9zZXRfcHJpdl9mbGFncyBm
b3IgYW4gZXhhbXBsZSBvZiBob3cgdG8gZG8gd2hhdA0KPiA+ID4gSSBhbSBwcm9wb3NpbmcuDQo+
ID4NCj4gPiBJIGRvbid0IGRpc2FncmVlIHRoaXMgc29sdXRpb24gd291bGQgd29yaywgYnV0IGl0
IGFkZHMgYSBuZXcgZGVwZW5kZW5jeQ0KPiA+IG9uIGhhdmluZyBldGh0b29sIGFuZCB0aGUga2Vy
bmVsIG1vdmUgdG9nZXRoZXIgdG8gZW5hYmxlIGl0Lg0KPiANCj4gQWN0dWFsbHkgZXRodG9vbCB3
b3VsZG4ndCBoYXZlIHRvIGNoYW5nZS4gVGhlIHByaXYtZmxhZ3MgYXJlIHBhc3NlZCBhcw0KPiBz
dHJpbmdzIHRvIGV0aHRvb2wgZnJvbSB0aGUgZHJpdmVyIGFuZCBzZXQgYXMgYSB1MzIgYml0IGZs
YWcgYXJyYXkgaWYNCj4gSSByZWNhbGwgY29ycmVjdGx5Lg0KDQpBaCB0aGFua3MsIHllYWggSSBz
ZWUgdGhhdC4gIFNvIHNob3VsZCB0aGlzIGp1c3QgYmUgcGFzc2luZyBpbiBhbmQgb3V0DQpwcml2
LT5mbGFncyBzaGlmdGVkIGFuZCBPUmVkIHdpdGggcHJpdi0+ZmxhZ3MyPyAgSUlSQyBib3RoIG9m
IHRob3NlIGFyZSAxNiBiaXRzLg0KDQpBbmQgbGlrZSBteSBzdWdnZXN0ZWQgY2hhbmdlIGEgbmV3
IGJpdCBpbiBwcml2LT5mbGFnczIuDQoNCj4gDQo+ID4gT25lIGFkdmFudGFnZSBvZiB0aGUgd2F5
IHRoaXMgaXMgZG9uZSBpdCBhbGxvd3Mgc2hpcHBpbmcgYSBzeXN0ZW0gd2l0aCBhbg0KPiA+IG9s
ZGVyIExpbnV4IGtlcm5lbCB0aGF0IGlzbid0IHlldCByZWNvZ25pemVkIGluIHRoZSBrZXJuZWwg
aGV1cmlzdGljcyB0bw0KPiA+IHR1cm4gb24gYnkgZGVmYXVsdCB3aXRoIGEgc21hbGwgdWRldiBy
dWxlIG9yIGtlcm5lbCBjb21tYW5kIGxpbmUgY2hhbmdlLg0KPiA+DQo+ID4gRm9yIGV4YW1wbGUg
c3lzdGVtcyB0aGF0IGFyZW4ndCB5ZXQgcmVsZWFzZWQgY291bGQgaGF2ZSB0aGlzIGRvY3VtZW50
ZWQgb24NCj4gPiBSSEVMIGNlcnRpZmljYXRpb24gcGFnZXMgYXQgcmVsZWFzZSB0aW1lIGZvciBv
bGRlciBSSEVMIHJlbGVhc2VzIGJlZm9yZSBhDQo+ID4gcGF0Y2ggdG8gYWRkIHRvIHRoZSBoZXVy
aXN0aWNzIGhhcyBiZWVuIGJhY2twb3J0ZWQuDQo+IA0KPiBJIHN1Z2dlc3QgdGFraW5nIGEgbG9v
ayBhdCB0aGUgcHJpdi1mbGFncyBpbnRlcmZhY2UuIEkgYW0gbm90DQo+IHN1Z2dlc3RpbmcgYWRk
aW5nIGEgbmV3IGludGVyZmFjZSB0byBldGh0b29sLiBJdCBpcyBhbiBleGlzdGluZw0KPiBpbnRl
cmZhY2UgZGVzaWduZWQgdG8gYWxsb3cgZm9yIG9uZS1vZmYgZmVhdHVyZXMgdG8gYmUNCj4gZW5h
YmxlZC9kaXNhYmxlZCBvbiBhIGdpdmVuIHBvcnQuDQoNClllcywgdGhpcyBtYWtlcyBtb3JlIHNl
bnNlIHRvIG1lIG5vdywgdGhhbmtzLg0KDQo+IA0KPiA+ID4NCj4gPiA+IEkgdGhpbmsgaXQgd291
bGQgc2ltcGxpZnkgdGhpcyBxdWl0ZSBhIGJpdCBzaW5jZSB5b3Ugd291bGRuJ3QgaGF2ZSB0bw0K
PiA+ID4gaW1wbGVtZW50IHN5c2ZzIHNob3cvc3RvcmUgb3BlcmF0aW9ucyBmb3IgdGhlIHZhbHVl
IGFuZCB3b3VsZCBpbnN0ZWFkDQo+ID4gPiBiZSBhbGxvd2luZyBmb3IgcmVhZGluZy9zZXR0aW5n
IHZpYSB0aGUgZ2V0X3ByaXZfZmxhZ3Mvc2V0X3ByaXZfZmxhZ3MNCj4gPiA+IG9wZXJhdGlvbnMu
IEluIGFkZGl0aW9uIHlvdSBjb3VsZCBsZWF2ZSB0aGUgY29kZSBmb3IgY2hlY2tpbmcgd2hhdA0K
PiA+ID4gc3VwcG9ydHMgdGhpcyBpbiBwbGFjZSBhbmQgaGF2ZSBpdCBzZXQgYSBmbGFnIHRoYXQg
Y2FuIGJlIHJlYWQgb3INCj4gPiA+IG92ZXJ3cml0dGVuLg0KPiA+DQo+ID4gSWYgdGhlIGNvbnNl
bnN1cyBpcyB0byBtb3ZlIGluIHRoaXMgZGlyZWN0aW9uLCB5ZXMgSSdsbCByZWRvIHRoZSBwYXRj
aA0KPiA+IHNlcmllcyBhbmQgbW9kaWZ5IGV0aHRvb2wgYXMgd2VsbC4NCj4gDQo+IE5vIGNoYW5n
ZXMgbmVlZGVkIHRvIGV0aHRvb2wuIFRoZSBmbGFncyBhcmUgZHJpdmVyIHNwZWNpZmljIHdoaWNo
IGlzDQo+IHdoeSB0aGlzIHdvdWxkIHdvcmssIG9yIGFyZSB5b3Ugc2F5aW5nIHRoaXMgY2hhbmdl
IHdpbGwgYmUgbmVlZGVkIGZvcg0KPiBvdGhlciBkcml2ZXJzPyBJZiBzbyB0aGVuIHllcyBJIHdv
dWxkIHJlY29tbWVuZCBjb21pbmcgdXAgd2l0aCBhDQo+IHN0YW5kYXJkIGludGVyZmFjZSB3ZSBj
YW4gdXNlIGZvciB0aG9zZSBkcml2ZXJzIGFzIHdlbGwuDQoNCkkgZG9uJ3QgZXhwZWN0IHRoaXMg
dG8gYmUgbmVlZGVkIGluIGFueSBvdGhlciBkcml2ZXJzIHJpZ2h0IG5vdy4NCg0K
