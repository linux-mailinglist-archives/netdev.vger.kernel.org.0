Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3259847195C
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 10:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhLLJAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 04:00:53 -0500
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com ([104.47.59.172]:12087
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229593AbhLLJAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 04:00:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMVM5MX95hZ2EfRImQydV9rU9EWGr+hj/EYKM3g0Q8b4eI5Ie8/DCfzBXcrgbroIcmDrPwqiDFu9HrWVcI1kqycMacNILc35EdIkb1HA0hIKBJpZX9vGrN8PHuJg3WO2PEuDWX2c8IMiXR1wnsB0spOEoeKeFj0iDqEtXtFUs5OZDE1S7PUD8baJpD43x95UqDpbmFr60DYUtOD8anav6QaKeo121wBJaZqe0ElMJUiS7AVeVrL++bzTKudPpzQUQ6GigZbMZn0QcJoSjX4EPIUshz3Ur/9f9KpnBZPoR9XipwJBR6pmO/h0FS04Ga584S4yWEIqiZ9KY7RPVhXLFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAMoWgfegQNv2IbB2h4ZmqYQchas1439TNL6xBevqCg=;
 b=btniVq0eox5/WyJ8eOWl5989X8e1Haiwrl7Vf1OJtTIj4rlpQSNnkaGUkmNTsidw/rWvf0Sqss43dDDFe9Vf/YVhz8ZtTHIgM7GlDo8JtXEAIM5v12g9t3SbpSR7R4DPMKjrTcLLx1Xv/BINVtapT1Tq5YqSAaVqrXWUqqncN24T1u8mNRoTJBnMom4KmJu+Tk6p6QTvKjcd4c6kHwxPUY11iztKZiGqsTeF0tD9B9xO4SWJaaO5E+U50NZWAaNnd+qDAr9+YBlhMWUeaCL+3TTGkyGkFP3WIMyjeAIn6I3EtKnOhpNoUpfIR7WwnMXlENLrV4sOBDmZVVjwueWN0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAMoWgfegQNv2IbB2h4ZmqYQchas1439TNL6xBevqCg=;
 b=eAEHiE42ztzfNrrcEr5OMOSkPo3okWJqSUmQ1Kpi8xliVDa9LOhCC/2aHAbPuhvfJvozVnc6Imzx+b0qvplfBTw/7aCLysVhjEnMKg3UX4qis3DTgNRTmnDPQv+vOiSMsgp+A2Qv3OMMVvA1WUQyP50dngDfgnEb0rjZtOKgjBw=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM5PR13MB1865.namprd13.prod.outlook.com (2603:10b6:3:135::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.12; Sun, 12 Dec
 2021 09:00:51 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15%4]) with mapi id 15.20.4801.010; Sun, 12 Dec 2021
 09:00:51 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH v6 net-next 08/12] flow_offload: add process to update
 action stats from hardware
Thread-Topic: [PATCH v6 net-next 08/12] flow_offload: add process to update
 action stats from hardware
Thread-Index: AQHX7N8rxbSjY0IJLEePq/ca2Cw9Kawtt2mAgADaTQA=
Date:   Sun, 12 Dec 2021 09:00:51 +0000
Message-ID: <DM5PR1301MB2172002C966B5CC41EA6537AE7739@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <20211209092806.12336-9-simon.horman@corigine.com>
 <c03a786e-6d21-1d93-2b97-9bf9a13250ef@mojatatu.com>
In-Reply-To: <c03a786e-6d21-1d93-2b97-9bf9a13250ef@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3b9f1aa-9577-4fd7-cbdf-08d9bd4de59e
x-ms-traffictypediagnostic: DM5PR13MB1865:EE_
x-microsoft-antispam-prvs: <DM5PR13MB1865C0DEBC489087880D4F4BE7739@DM5PR13MB1865.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vt2Q4pVSJXeNWo7VxcIkPbtsyD752fIZxFHA5NU0JopQ+DhUe0wHveE5xKHBf/Qv5/SDx78EGXyGulm/DtndFyMCNggBA4xhG23+K3QkV/1tkHqQv/xaZ6QZbqYdesSY8yrIs8L2oZI2msoX0mQbV0N8nR98kaeptJ/wZQ/q81f7UlBRajGOklfmHy4bRAvVX/ObXgZgyWCFZ4a1ZA2pRVzzv0W1GdrrzPMfLV6yVe6DjU9qRDNqntk4N3MAgmICzJkSSnlz7KDHA7GWP5Qid5NchKIFzHDZg83HXvcwFU0VGLRRdL58BDMNWWuNQxjGrjEgT74FbKXpn0G4EwgPru3Zq8CksN+LQ367zYCCtXXa0bGuVFFkuObs2nzmUvt1EaNCvk7qChr0Jp5w4v1VYqpZkvp7v8gzgiiSfBPao6111B9neWUo0G5hCX5Mi77PnQ1XGvvS7WFxMsF6WgReeuUUSG6nsH+kQTxAJ1TbaVhMM1wFXP2JgRWBZ/u41zQaS0D1oOnZGj1Cop6ZeL0l3FaW6NtaYDi76qyswMn9oay6XeqwauaQHrWJ3lm1K3KbhjdQFbfs8Oa7htWT0ibBh5kjjkCFRLxnayRfd52wj/aJ0lH3LxDNOBUPM3Iw7LTKqjejxZacgyFIVeS0yDHob2lBGdW6Yqmm0hNqqyUlh3X4YKR1p4JP9g3rF8cOUrkmn93QyCFN8Au/5ojCALLTtA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(39830400003)(396003)(376002)(346002)(4326008)(38100700002)(66476007)(64756008)(66556008)(66446008)(86362001)(8936002)(26005)(52536014)(122000001)(8676002)(107886003)(316002)(508600001)(71200400001)(110136005)(66946007)(186003)(76116006)(54906003)(38070700005)(33656002)(6506007)(2906002)(7696005)(55016003)(44832011)(15650500001)(5660300002)(83380400001)(9686003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3lDeHVVM0pmL0J6K0RhL3RmSDBMMFB5VFRnS0d0ald4M0JDSWFVM2I0Z3FG?=
 =?utf-8?B?SHA1ZVBVWi9tVXJaZlhGakhsUDQzdnpReUM4MzkwYWNzNGVPamh3SmszaEh1?=
 =?utf-8?B?d1k2U05KRzlDWjZ4K0Rtbjl1MEJKdnI3SW1BS2pnV1RVaDZyemhhRUkvTWpt?=
 =?utf-8?B?Y1lTRFVwT09ObW5Nd2F1NHBiNkdCZk9OZjhNZmdMdVZ5UldEb0tvNzZZUzVK?=
 =?utf-8?B?eDlLOFJ1V05laVo5UThvZXVFQURnYjBCcS95VVVMby9raDI3cFI2UWpEY0Ir?=
 =?utf-8?B?ZXcxYWhvSytwYWxJUmlDNTQ1cXlyaXZFa2hkc3FFT0h4a1NUajVNRzcvR2R6?=
 =?utf-8?B?dkdYMUdkZjBubUxPWVhWeEZCcGpIbjFwdUJsNjBQNWJXRGROUm5Ed0k2U0Iv?=
 =?utf-8?B?QlE0Rkl5cVRvVHJmREs1VkFRSkNDNTdzaXpnajJHUzZYVnBZMlRXMzhKVHpV?=
 =?utf-8?B?eDQ4MjM4NmsycXk2WFdwNFJSSkROc1dkc2hUSlk0R01pZjNJRHRRdHk3Q29E?=
 =?utf-8?B?RWdFdGVkQmFnRC9sMWhmSkFPZkU5Tk92S3ZzR0N0NXFUZHNDM1JqTkUwaXJR?=
 =?utf-8?B?UDE3WmV2T2lKOG5GNGlEaExGTmFiZXJFNVZyRmtZSzFaWFB0bksxM0JuVnpW?=
 =?utf-8?B?WHNWZi8yNlNmNlFBRWFieTY4N1FvY1FGbklvMlV6bXZjNlFDRHB3QS9KaXFK?=
 =?utf-8?B?QUpvUFZMWW11YnZmaDZGdWx6OHU2UGVUdXRpR1pUd3czWnlUbEowVXNhUnl0?=
 =?utf-8?B?NGVZd0VrZXZ4WmZndEc3eVZjaThDc0UvOVdoVnRFRE5Kb1FOY0lscGpwcU5l?=
 =?utf-8?B?N2hJME8wRG1rdS9UZ1QybzlBS3pZOGlIRnlFQXhxWHU2MWVMVHpvVHJDN05H?=
 =?utf-8?B?b2pkeXQxU0Y2anB3SkFZWnJqcDMxZHR2ME8yQmtTbEV0a2FZeDFGL2t4NVA1?=
 =?utf-8?B?V3lWaEhtd3NObXVGaW5oekZGVmh3bCs2SlJDbFpvcnFtKzYwblUwWFNFbk9x?=
 =?utf-8?B?QVU1ei9iUjhFTnkrVk5YaklrU2FuTFovL0U5OHl0UlAvRFgzdlBLOUhHekg0?=
 =?utf-8?B?ZVJUMkhOYjBwazdRUmJIaDlMQittOVVMQVVPNUtqU29IdVViNHBkNm8vanVs?=
 =?utf-8?B?YjgrWFlBR0Rwem9iZUVSaG15R05URHFUczNIVVBuVWs3M2ZZb1lQclFCOENu?=
 =?utf-8?B?dXFhNFlMM3ZoRGJVZlNMM2hvamtSSzk2VVYwK1FUUnNjd29RaDJVR1AvdE9J?=
 =?utf-8?B?WjY4Q1ZrTkJWaEkyejNuMU1MNzA4QmhmTEl4M3FOZXVGSUl5cWE3WWkvd0o4?=
 =?utf-8?B?UGhYOFNBTUdBMkhaSWZnQ2VDYzNVQ2VWV0trdmpoRnNxMkdYT095YVpTb2dV?=
 =?utf-8?B?dUtObmRIVFprdmNiVTNKNWYzcFhaM3cydzB1Mk5PTkE0SVRHRFg1OVFYVWl3?=
 =?utf-8?B?MDhqYzZMNzV1cGlCYVpuQTJnRm1QTXIyRmp2ZTJHUDNyaU5BcWJKMVNOUElV?=
 =?utf-8?B?eGtDdDY4eHNJMEJKZUN3a0hLb2lzKzZ0d3kvUXg2ZVZNSkw1WFF1ellhcm0x?=
 =?utf-8?B?aWJ4cEJDcEpHYVlHeDZESVFWbjNoaS9RMnFwVnJzR2RydWJNSVlLYXJCRmVL?=
 =?utf-8?B?ME11bHI2eXZNNEV3SVVLaTFTT1g2ZW9kOTkweXJHSWRHUXdCS0cvdm9mL29E?=
 =?utf-8?B?cVl1bDhvbXphYlY5dGRnWUQzMzZpdFdSV0xid2xCNWdlRWRpdE1jNmZoUjRW?=
 =?utf-8?B?blRTQktnaXZNZm5DaWhZWGtnUHpQUy9YQ3NsOXJGK3Z3cFFaWU8xSUNzNTdK?=
 =?utf-8?B?YlJxbngvSkxZeDFKZDhydEcwR3NjZzRKREplcDB1aGQ3NmJaV2R6WGFWblVh?=
 =?utf-8?B?VGV6TnZZd2ZrWWF2dFQ1b2p1bXJEZVFBTTN6bGpHQnUwUFgxd1B3QlUwU3BB?=
 =?utf-8?B?UUloejBmdGREeUZKTExaUkoyVWtGRE1vKytCWE42KzVTY3FaUTRxOFVzb2RR?=
 =?utf-8?B?ZnBjWHNhSjNFVng2WnB0bFBhS2lVZGJvWWorTFdsZ3hKUk9YQmhqWXhjYzVX?=
 =?utf-8?B?WWFoV1ZUemZ5WVZ3YlhpZ0dIV0FxQXJXVGxpUzdMa2Y4Yld2cnFWYk4zVVRF?=
 =?utf-8?B?M1FzZVRseVdPNk03Vzk0VndZOW9RaGxJN1pmYlpmTzNwZVJDSHgySVdJbXJ2?=
 =?utf-8?B?TjNmbVZZWW5abHptWVNrelNwSndJbFJBR01XRzFManQyR1IxUi9RaFh0Sjdp?=
 =?utf-8?B?a3k3bGJXMWxzcFZyanhYb2ZNQmRRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3b9f1aa-9577-4fd7-cbdf-08d9bd4de59e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2021 09:00:51.0957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kCelM3mpirBUyOvyLfSUIU8xkOSHIenBX9jriDqbRHw1aP9PQrewJKwW7wJSvN8HxV7pDhGl8dXV5/kHwtMt+1hIyukcIoKWN8SaHMEq338=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1865
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRGVjZW1iZXIgMTIsIDIwMjEgMzo1MiBBTSwgSmFtYWwgSGFkaSBTYWxpbSB3cm90ZToNCj5P
biAyMDIxLTEyLTA5IDA0OjI4LCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+PiBpbmNsdWRlL25ldC9h
Y3RfYXBpLmggfCAgMSArDQo+PiAgIGluY2x1ZGUvbmV0L3BrdF9jbHMuaCB8IDE4ICsrKysrKysr
KystLS0tLS0tLQ0KPj4gICBuZXQvc2NoZWQvYWN0X2FwaS5jICAgfCAzNCArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrDQo+PiAgIDMgZmlsZXMgY2hhbmdlZCwgNDUgaW5zZXJ0aW9u
cygrKSwgOCBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvYWN0
X2FwaS5oIGIvaW5jbHVkZS9uZXQvYWN0X2FwaS5oIGluZGV4DQo+PiA3ZTRlNzliNTAyMTYuLmNl
MDk0ZTc5ZjcyMiAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvbmV0L2FjdF9hcGkuaA0KPj4gKysr
IGIvaW5jbHVkZS9uZXQvYWN0X2FwaS5oDQo+PiBAQCAtMjUzLDYgKzI1Myw3IEBAIHZvaWQgdGNm
X2FjdGlvbl91cGRhdGVfc3RhdHMoc3RydWN0IHRjX2FjdGlvbiAqYSwNCj51NjQgYnl0ZXMsIHU2
NCBwYWNrZXRzLA0KPj4gICAJCQkgICAgIHU2NCBkcm9wcywgYm9vbCBodyk7DQo+PiAgIGludCB0
Y2ZfYWN0aW9uX2NvcHlfc3RhdHMoc3RydWN0IHNrX2J1ZmYgKiwgc3RydWN0IHRjX2FjdGlvbiAq
LA0KPj4gaW50KTsNCj4+DQo+PiAraW50IHRjZl9hY3Rpb25fdXBkYXRlX2h3X3N0YXRzKHN0cnVj
dCB0Y19hY3Rpb24gKmFjdGlvbik7DQo+PiAgIGludCB0Y2ZfYWN0aW9uX2NoZWNrX2N0cmxhY3Qo
aW50IGFjdGlvbiwgc3RydWN0IHRjZl9wcm90byAqdHAsDQo+PiAgIAkJCSAgICAgc3RydWN0IHRj
Zl9jaGFpbiAqKmhhbmRsZSwNCj4+ICAgCQkJICAgICBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpu
ZXdjaGFpbik7IGRpZmYgLS1naXQNCj4+IGEvaW5jbHVkZS9uZXQvcGt0X2Nscy5oIGIvaW5jbHVk
ZS9uZXQvcGt0X2Nscy5oIGluZGV4DQo+PiAxM2YwZTRhM2ExMzYuLjE5NDJmZTcyYjNlMyAxMDA2
NDQNCj4+IC0tLSBhL2luY2x1ZGUvbmV0L3BrdF9jbHMuaA0KPj4gKysrIGIvaW5jbHVkZS9uZXQv
cGt0X2Nscy5oDQo+PiBAQCAtMjY5LDE4ICsyNjksMjAgQEAgdGNmX2V4dHNfc3RhdHNfdXBkYXRl
KGNvbnN0IHN0cnVjdCB0Y2ZfZXh0cyAqZXh0cywNCj4+ICAgI2lmZGVmIENPTkZJR19ORVRfQ0xT
X0FDVA0KPj4gICAJaW50IGk7DQo+Pg0KPj4gLQlwcmVlbXB0X2Rpc2FibGUoKTsNCj4+IC0NCj4+
ICAgCWZvciAoaSA9IDA7IGkgPCBleHRzLT5ucl9hY3Rpb25zOyBpKyspIHsNCj4+ICAgCQlzdHJ1
Y3QgdGNfYWN0aW9uICphID0gZXh0cy0+YWN0aW9uc1tpXTsNCj4+DQo+PiAtCQl0Y2ZfYWN0aW9u
X3N0YXRzX3VwZGF0ZShhLCBieXRlcywgcGFja2V0cywgZHJvcHMsDQo+PiAtCQkJCQlsYXN0dXNl
LCB0cnVlKTsNCj4+IC0JCWEtPnVzZWRfaHdfc3RhdHMgPSB1c2VkX2h3X3N0YXRzOw0KPj4gLQkJ
YS0+dXNlZF9od19zdGF0c192YWxpZCA9IHVzZWRfaHdfc3RhdHNfdmFsaWQ7DQo+PiAtCX0NCj4+
ICsJCS8qIGlmIHN0YXRzIGZyb20gaHcsIGp1c3Qgc2tpcCAqLw0KPj4gKwkJaWYgKHRjZl9hY3Rp
b25fdXBkYXRlX2h3X3N0YXRzKGEpKSB7DQo+PiArCQkJcHJlZW1wdF9kaXNhYmxlKCk7DQo+PiAr
CQkJdGNmX2FjdGlvbl9zdGF0c191cGRhdGUoYSwgYnl0ZXMsIHBhY2tldHMsIGRyb3BzLA0KPj4g
KwkJCQkJCWxhc3R1c2UsIHRydWUpOw0KPj4gKwkJCXByZWVtcHRfZW5hYmxlKCk7DQo+Pg0KPj4g
LQlwcmVlbXB0X2VuYWJsZSgpOw0KPj4gKwkJCWEtPnVzZWRfaHdfc3RhdHMgPSB1c2VkX2h3X3N0
YXRzOw0KPj4gKwkJCWEtPnVzZWRfaHdfc3RhdHNfdmFsaWQgPSB1c2VkX2h3X3N0YXRzX3ZhbGlk
Ow0KPj4gKwkJfQ0KPj4gKwl9DQo+PiAgICNlbmRpZg0KPj4gICB9DQo+DQo+U29ycnkgLSBkaWRu
dCBxdWlldCBmb2xsb3cgdGhpcyBvbmUgZXZlbiBhZnRlciByZWFkaW5nIHRvIHRoZSBlbmQuDQo+
SSBtYXkgaGF2ZSBtaXNzZWQgdGhlIG9idmlvdXMgaW4gdGhlIGVxdWl2YWxlbmNlOg0KPkluIHRo
ZSBvbGQgY29kZSB3ZSBkaWQgdGhlIHByZWVtcHQgZmlyc3QgdGhlbiBjb2xsZWN0LiBUaGUgY2hh
bmdlZCB2ZXJzaW9uIG9ubHkNCj5kb2VzIGl0IGlmIHRjZl9hY3Rpb25fdXBkYXRlX2h3X3N0YXRz
KCkgaXMgdHJ1ZS4NCkhpIEphbWFsLCBmb3IgdGhpcyBjaGFuZ2UsIHRoaXMgaXMgYmVjYXVzZSBm
b3IgdGhlIGZ1bmN0aW9uIG9mIHRjZl9hY3Rpb25fdXBkYXRlX2h3X3N0YXRzLCBpdCB3aWxsIHRy
eSB0byByZXRyaWV2ZSBodyBzdGF0cyBmcm9uIGhhcmR3YXJlLiBCdXQgaW4gaGUgcHJvY2VzcyBv
ZiByZXRyaWV2aW5nIHN0YXRzIGluZm9ybWF0aW9uLCB0aGUgZHJpdmVyIG1heSBoYXZlDQpMb2Nr
IG9yIG90aGVyIHNsZWVwaW5nIGZ1bmN0aW9uLiBTbyB3ZSBzaG91bGQgbm90IGNhbGwgdGNmX2Fj
dGlvbl91cGRhdGVfaHdfc3RhdHMgZnVuY3Rpb24gaW4gY29udGV4dCBvZiBwcmVlbXB0X2Rpc2Fi
bGUuDQpBY3R1YWxseSwgc2luY2UgdGhlcmUgaXMgbm8gdmVuZG9yIHRvIHN1cHBvcnQgdXBkYXRl
IHNpbmdsZSBhY3Rpb24gc3RhdHMgZnJvbSBoYXJkd2FyZSwgc28gaXQgaXMgbm90IG9idmlvdXMs
IHdlIHdpbGwgcG9zdCBvdXIgaW1wbGVtZW50IHN1cHBvcnQgYWZ0ZXIgdGhlc2UgcGF0Y2hlcyBz
ZXQuIA0KRG8geW91IHRoaW5rIGlmIGl0IG1ha2Ugc2Vuc2U/DQo+DQo+Y2hlZXJzLA0KPmphbWFs
DQo=
