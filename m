Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E248A1CEC87
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 07:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgELFsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 01:48:17 -0400
Received: from mx0a-00273201.pphosted.com ([208.84.65.16]:63590 "EHLO
        mx0a-00273201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbgELFsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 01:48:16 -0400
Received: from pps.filterd (m0108159.ppops.net [127.0.0.1])
        by mx0a-00273201.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04C5mDPB003336;
        Mon, 11 May 2020 22:48:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=PPS1017;
 bh=c82Of8JTG2kpJ9ILScxW5Ipf/NUZmD682ezXhT+XwPk=;
 b=LglYmyEinD/qCRfQ/c2IC2IroRamxg53zVhTSH8KPTuAly5z0UkNehU8PCnVtLzOlXyv
 H2hJRbKVOim/fPsOvXbNudgYPyTDKEB9JF/JYLO4xLzpWKGx9KEU+hgieQfJrFCI5PZW
 2Qa6G7q8Ug6tSSJDkiF9NnBmSZscJgkAsv+1jhZgaLTOQrSSRSH6i8SQrxZb1+QPyY0E
 QXXZ1j088XEfNBNjmIdhU/fa/aiHMqrCA7o478DI36KBKfC4ULM4Qf2JACGHxUvUIRJ9
 tXzGVu5l3WwJFHIvz3oyeSziZ4Eydp4aGlvVRRQJYhUg/FRRaabfhfw/7PTFgsXQdyq+ TA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by mx0a-00273201.pphosted.com with ESMTP id 30yfa2gkay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 May 2020 22:48:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oe2I0yl8KPFwcS6vbIZzuSI8AZ7jkRlU3+sfapqYe2F4RRX8vlzSfHSu/84HGElvbpptaDKePWmFN3gcQh8s2xQQAem8KX2gfz3w+CIss9Wj634tEzouM7O0jqmw7b49CIAs3FnX4ypHpzypsrWKJKat7bITpfOLZtn7N2Jw1GSKs1Xg3/T7mbyamBJfNEMZvIe9HJgSzFTXnpJwLnhAV+MQ6MyDQxuV0KGUeTqcqsh/xh692IxEiZ6Adjks9hhTuhdY4Lro5dVluiQWJIKRqPwVd7coA13w4cmN04bx7hx48kaATRemiHBlCQOu5t2yA6exRLza/49D+X7Pdc3ngg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c82Of8JTG2kpJ9ILScxW5Ipf/NUZmD682ezXhT+XwPk=;
 b=Rxon+ksYaFThK54oU9E6EPvMyWYIrJ/Lr1di3JJfjDWBKuwwqooGOpvkEjDi5dxIcoVi7XzLc2GFzXCiG6pp4+Uk0Gi6fRLPDrGRYrxkTOWBUVxnHWhxUh+eQkRooctCFem35BKzCh8GIk04lqdXkcQQx4ZOxdSFaHYJ+zAqWV4/mTeY8P4sQgkZauZgls/h/LDzF34aDwLcgyoUMv08X5moiqblyvw606qd0+vMb0OK5Ycg+ZEgTKHEIUCd5hwiGfn7EgkcBx7pLpHHHybmJWzUi4m1rfktfScEIa/EVoQPNZQm19B5tzWIHIq2ThV1zN9TCaaSAzWJM8kI3Gl2MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c82Of8JTG2kpJ9ILScxW5Ipf/NUZmD682ezXhT+XwPk=;
 b=kiLi2L19SouMvocDx6Xl27Ji9SUz7syQ1Ud3yp3j+e9kQV37K+rX7K+Yo9KLSXoSh9jHJxMRMmakkSF4INdIve4Fc+I3wcVUa+7BspKN6tW09R4/kN0gt1uUushN2dSxiapR6fqrjXlqVsN1nTEZr78K7BI8zad1eZyNGBtfMWs=
Received: from SN6PR05MB5183.namprd05.prod.outlook.com (2603:10b6:805:e3::26)
 by SN6PR05MB4301.namprd05.prod.outlook.com (2603:10b6:805:2e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.15; Tue, 12 May
 2020 05:48:06 +0000
Received: from SN6PR05MB5183.namprd05.prod.outlook.com
 ([fe80::d4b4:14d6:1265:5f84]) by SN6PR05MB5183.namprd05.prod.outlook.com
 ([fe80::d4b4:14d6:1265:5f84%5]) with mapi id 15.20.3000.011; Tue, 12 May 2020
 05:48:06 +0000
From:   Preethi Ramachandra <preethir@juniper.net>
To:     "linux-net@vger.kernel.org" <linux-net@vger.kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: ICMPV6 param problem with new error code 3 for first fragment not
 having valid upper layer header
Thread-Topic: ICMPV6 param problem with new error code 3 for first fragment
 not having valid upper layer header
Thread-Index: AQHWKBS35mJ+RVX9xUqpjF4NeYfX2qikPX4AgAAQW4A=
Date:   Tue, 12 May 2020 05:48:06 +0000
Message-ID: <F4B5B339-1E36-47E8-9AB9-EE4EF4362F7E@juniper.net>
References: <A64D75CA-608F-4460-B618-A51AD755FD2C@juniper.net>
 <1F7D8CC5-832E-4057-B033-7CFFD00CC6FA@juniper.net>
In-Reply-To: <1F7D8CC5-832E-4057-B033-7CFFD00CC6FA@juniper.net>
Accept-Language: en-029, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Enabled=true;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_ContentBits=0;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SiteId=bea78b3c-4cdb-4130-854a-1d193232e5f4;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_ActionId=80f52e48-9f07-44c1-81bd-0000dad4ff01;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SetDate=2020-05-12T04:12:30Z;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Method=Standard;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Name=Juniper
 Business Use
 Only;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Enabled=true;
user-agent: Microsoft-MacOutlook/16.36.20041300
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=juniper.net;
x-originating-ip: [116.197.184.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1baa673c-bda1-4f3f-7116-08d7f6380b49
x-ms-traffictypediagnostic: SN6PR05MB4301:
x-microsoft-antispam-prvs: <SN6PR05MB4301465628E7B066CD1F29C1D1BE0@SN6PR05MB4301.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0401647B7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bnju5TYaD+ojU81FMNnIMHtmgU9ycqcGhYCEAV7sfHoYHbwlAbNxHsB7f+J498CR5WvkyQDUNrcbHdU/kMI2acl0kCJCWm1Sd9xtb1iv6VKeDzDuMcgO/C94bNhzc38tm1X8WDisPtXwsAKVQTPsFG9LnFqgEXIfq9B39ZFZAttTzS5QdnI3n5AFKrwS8s1dJJ1OmM8inv/munmFvby7z2JyVWvMXpQ2huUVzPGvwAMoxgAnRGDHUE09ZY0f+oyhLY4V/N8UvljlCyv6WaoM5ueOvxHCTXRjHd4Z3aGYh0e6c8erZvw7bhofGvPJnnPsMMZpPC7BPn6zZJg0Iec/QMsuMywMnvOwhL1vl8eqNh/bdmeBrb2oXWVKQQJC4oTIJONKAr0+oDGv8Nkkqi63FyMwN/faMoH6puJIfag6GVt7fguNSk5ka70vCCtnCZnZ5JdKOP0h0kik1okW9Ok9cIR2Bi147iGSc/at7e0VUNvhk4hVkxCuo25nKO+9X6xFCYY6dXoid9R2mIZQbnNlxMLGb46kWqgjVs8jZbPkitVbfJGKlgEyze+9Ty/iOZIS5u4ZdDHL9t+PZY++qrVOM8WVCDp1GBvYQi4a7nTFOfE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR05MB5183.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(33430700001)(186003)(36756003)(966005)(478600001)(5660300002)(26005)(2616005)(71200400001)(2906002)(110136005)(8936002)(6512007)(86362001)(6506007)(316002)(91956017)(33440700001)(6486002)(64756008)(66946007)(8676002)(66476007)(66446008)(33656002)(76116006)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: gLNrDOC7b06WeFCSF2iubhyqbcFdes61oz6mlyyahaGn6lP37F4kFrQN5l2edT/e35eL+k33d6MCVl3128bmc0eOdBUx5p5VFs3Y9B1LZUigztgkSutyNA805bOusj0kEhaAQby+WliuPfFMQSFFYNba38jwY5f6nhLBniuhR6pvCau8uxtggf5U7ozyRNq10tn32o2k0FdVAjECrbSRFgft78FS9bYsMCMxna6ItZMflwM6Pvcf6hBoyt9wV+UUGe0BH3N2F9GCMyBSIDicq8+mshYOU2C9PxoNBkVBbq6YXd/9Q2K/OEDndoWf+GhJ1FR1XWADEPh66aGXbKjoqN9PQH+x7D3woGFbsYjPnFKhBqjfqvuW6fPLQ+7rRlDfFzS0M1v9rwVvh6TlVMdcoYc+MwmBRckqxpstiu9nxKzB7/D3S9l7zt4iL3iPYvIy1ceJZKhrRxtCJu9VnsyJQkb6kcLA7GD2/GF/9E1xCkyuRECQu1MPy/Vv/SRf5Gxv
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <92058E54FE72134F8BA82057F8798165@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 1baa673c-bda1-4f3f-7116-08d7f6380b49
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2020 05:48:06.2925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uQLHNopXqHavsRZ3XOOTzaa71OoFonPai9IDk2Tp102MFIbqWRtZR89W9p6keRElqN2PnZ3si1CJ4z1zZsggZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4301
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_01:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120051
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXMgcGVyIGlzX2luZWxpZ2libGUgaW1wbGVtZW50YXRpb24gaW4gbmV0L2lwdjYvaWNtcC5jLiBJ
ZiB0aGUgaW5jb21pbmcgaWNtcCBpcyBhbiBlcnJvciBvciBpcyB0cnVuY2F0ZWQsIHJlc3BvbnNl
cyB3aWxsIG5vdCBiZSBzZW50IG91dC4NClJGQzgyMDAgYW5kIFJGQyA3MTEyIHN0YXRlcyB0aGUg
Zm9sbG93aW5nOg0KDQogICAgICAgIOKAnElmIHRoZSBmaXJzdCBmcmFnbWVudCBkb2VzIG5vdCBp
bmNsdWRlIGFsbCBoZWFkZXJzIHRocm91Z2ggYW4NCiAgICAgICAgIFVwcGVyLUxheWVyIGhlYWRl
ciwgdGhlbiB0aGF0IGZyYWdtZW50IHNob3VsZCBiZSBkaXNjYXJkZWQgYW5kDQogICAgICAgICBh
biBJQ01QIFBhcmFtZXRlciBQcm9ibGVtLCBDb2RlIDMsIG1lc3NhZ2Ugc2hvdWxkIGJlIHNlbnQg
dG8NCiAgICAgICAgIHRoZSBzb3VyY2Ugb2YgdGhlIGZyYWdtZW50LCB3aXRoIHRoZSBQb2ludGVy
IGZpZWxkIHNldCB0byB6ZXJvLuKAnQ0KDQpJbiBJUFY2IFRD4oCZcyBkZXJpdmVkIGZyb20gbGF0
ZXN0IFJGQyA4MjAwIGh0dHBzOi8vd3d3LmlwdjZyZWFkeS5vcmcvZG9jcy9Db3JlX0NvbmZvcm1h
bmNlXzVfMF8wLnBkZiAtIFRDIDEuMy42LCB0aGVyZSBpcyBhIHBvc3NpYmlsaXR5IG9mIG5leHQg
aGVhZGVyIHNldCB0byA1OChORVhUSERSX0lDTVApIGJ1dCB0aGVyZSBpcyBubyBJQ01QIGhlYWRl
ciBpbiBmaXJzdCBmcmFnbWVudC4gU2Vjb25kIGZyYWdtZW50IGhhcyBJQ01QIGhlYWRlci4gSW4g
dGhpcyBjYXNlIFJGQyBleHBlY3RzIHRvIGRpc2NhcmQgdGhlIGZpcnN0IGZyYWdtZW50IGFuZCBz
ZW5kIElDTVBWNiBwYXJhbSBwcm9ibGVtIHdpdGggbmV3IGVycm9yIGNvZGUgMy4gSSBkb27igJl0
IHNlZSB0aGlzIGJlaW5nIGltcGxlbWVudGVkIGluIGxhdGVzdCBsaW51eCB1cHN0cmVhbSBjb2Rl
LiBJcyBpdCBvayB0byBjaGFuZ2UgaXNfaW5lbGlnaWJsZSBpbiBsaW51eCBmb3IgdGhpcyBzcGVj
aWZpYyBjYXNlPw0KDQpMaW51eCBzb3VyY2UgY29kZToNCg0KLyoNCiogRmlndXJlIG91dCwgbWF5
IHdlIHJlcGx5IHRvIHRoaXMgcGFja2V0IHdpdGggaWNtcCBlcnJvci4NCioNCiogV2UgZG8gbm90
IHJlcGx5LCBpZjoNCiogICAgICAgICAgICAgIC0gaXQgd2FzIGljbXAgZXJyb3IgbWVzc2FnZS4N
CiogICAgICAgICAgICAgIC0gaXQgaXMgdHJ1bmNhdGVkLCBzbyB0aGF0IGl0IGlzIGtub3duLCB0
aGF0IHByb3RvY29sIGlzIElDTVBWNg0KKiAgICAgICAgICAgICAgICAoaS5lLiBpbiB0aGUgbWlk
ZGxlIG9mIHNvbWUgZXh0aGRyKQ0KKg0KKiAgICAgICAgICAgICAgLS1BTksgKDk4MDcyNikNCiov
DQoNCnN0YXRpYyBib29sIGlzX2luZWxpZ2libGUoY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYikN
CnsNCiAgICAgICAgICAgICAgICBpbnQgcHRyID0gKHU4ICopKGlwdjZfaGRyKHNrYikgKyAxKSAt
IHNrYi0+ZGF0YTsNCiAgICAgICAgICAgICAgICBpbnQgbGVuID0gc2tiLT5sZW4gLSBwdHI7DQog
ICAgICAgICAgICAgICAgX191OCBuZXh0aGRyID0gaXB2Nl9oZHIoc2tiKS0+bmV4dGhkcjsNCiAg
ICAgICAgICAgICAgICBfX2JlMTYgZnJhZ19vZmY7DQoNCiAgICAgICAgICAgICAgICBpZiAobGVu
IDwgMCkNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHRydWU7DQoNCiAg
ICAgICAgICAgICAgICBwdHIgPSBpcHY2X3NraXBfZXh0aGRyKHNrYiwgcHRyLCAmbmV4dGhkciwg
JmZyYWdfb2ZmKTsNCiAgICAgICAgICAgICAgICBpZiAocHRyIDwgMCkNCiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlOw0KICAgICAgICAgICAgICAgIGlmIChuZXh0
aGRyID09IElQUFJPVE9fSUNNUFY2KSB7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHU4IF90eXBlLCAqdHA7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRwID0gc2ti
X2hlYWRlcl9wb2ludGVyKHNrYiwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHB0citvZmZzZXRvZihzdHJ1Y3QgaWNtcDZoZHIsIGljbXA2X3R5cGUpLA0K
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc2l6ZW9mKF90
eXBlKSwgJl90eXBlKTsNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKCF0cCB8
fCAhKCp0cCAmIElDTVBWNl9JTkZPTVNHX01BU0spKQ0KICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHRydWU7DQogICAgICAgICAgICAgICAgfQ0K
ICAgICAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCn0NCg0KVGhhbmtzLA0KUHJlZXRoaQ0KDQoN
Cg0KSnVuaXBlciBCdXNpbmVzcyBVc2UgT25seQ0K
