Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30216471954
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 09:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhLLIl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 03:41:27 -0500
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com ([104.47.66.42]:6242
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229593AbhLLIl0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 03:41:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ix6XX/iwkqtWu7Tkm5OUmbbOjc4m+ZjMns7seeV9yIFSYKjLBRzVrJm8sbO/llu7bePHkJxq1JzzUbAtJYz+uKPt1iZyJ1ju9tyZDhgUDi5p4sH5d92a0fLZJYeOBbB+vTaRrbrvLSpJK45o1z7z+pn43XgeHx9ZFlUtWwBwTkTeh766rsU5fiHhfT4bOyc0PPyVgxLMVtV/7dny8QAgsxATvOJn2CYvWXhmnBJTejnSSN37yAWN9OzM3oCVAUJGBuNb+ruNLEBL/jYrfdIIjO7DmodJ3IjGpFu9w6iVDRe/nTfyHjRdopv66wwB//GvajBjABunDxJ7THTevRmmDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57SrSMVZtDNKEE7JvfrpUSAmboLBFeWH8I37xQSw0Gw=;
 b=X7IE0PdM6X2Dpb+RSiAYLx0tdMmzlXJG7sjfTsIGAOaIFpiz8h6uMCE4Q1KspEwD7ACu0Y6DuYage9pFiEKN5VRiwNX5CxicmviTk5swcvdcgR25rPsrmA4AYBZZgipdufCOTGQjdtLof83Whpcr5wMR0UG7ohxdOoJMjb8WqIuT1VoSwaEnaSbFoI/C4XyPzwy1Hrsex1oLgXxU8SYRRgz1RC8Y4EGp2l8KNUtLtUaizm7UaDZaKo6Ip5/JHgA1VHa3ssw1dYl+YMCjKjtLrjarh0er/ni6+5NVU0IqUrz3lK1qt0bAYaYjW7Eplby+Wo5nkmq7Li5ekeNC+J0Kxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57SrSMVZtDNKEE7JvfrpUSAmboLBFeWH8I37xQSw0Gw=;
 b=qoFq3GhB8iB34QvYE69jqmaKiZJxJ3ihEm+dC7/fLFXJD8zu2QAZ75w0WFsrJEpNvO4vFuvShsSeMADZLLILPYh2EuPstt+8w32V6gy246XBFHUevo1E8RBtug3tm9vh+5VOovrE6vwE2cA2XwtYRiY9q3doelpgOyNIiAxivnc=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM6PR13MB2473.namprd13.prod.outlook.com (2603:10b6:5:cb::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.7; Sun, 12 Dec
 2021 08:41:24 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15%4]) with mapi id 15.20.4801.010; Sun, 12 Dec 2021
 08:41:24 +0000
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
Subject: RE: [PATCH v6 net-next 03/12] flow_offload: add index to
 flow_action_entry structure
Thread-Topic: [PATCH v6 net-next 03/12] flow_offload: add index to
 flow_action_entry structure
Thread-Index: AQHX7N8jVCNZyubkU0qf0CHUFLH5G6wtq5KAgADiHzA=
Date:   Sun, 12 Dec 2021 08:41:23 +0000
Message-ID: <DM5PR1301MB21721795F1BC59C4589512B0E7739@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <20211209092806.12336-4-simon.horman@corigine.com>
 <ca81db9e-7d88-41ad-23d9-6ff8f03c86ba@mojatatu.com>
In-Reply-To: <ca81db9e-7d88-41ad-23d9-6ff8f03c86ba@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f22511d-29ef-475f-8b9b-08d9bd4b2df9
x-ms-traffictypediagnostic: DM6PR13MB2473:EE_
x-microsoft-antispam-prvs: <DM6PR13MB2473944F932B82794401FED2E7739@DM6PR13MB2473.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qU6uwryOjR9Q5Em8fdnXISKacV0dRB787CncRg/to2PRqau2JF+tlIyiCMYiO2XUry8SVqTl/1UuRzDbALxDQ3ceA8JltNYTmlftoccrXVSyxn27qBiXEdS4T1+46BKiJSCpeEe+UUcmJ6UF9Y2UvK5kSORg7wd5ctsgv+bh9dDdZm2C+z4WaXDxhTtFFUsG7CpJbjXrgioCRrmumdbeMOajiGOwcs7TWmKuozYu5tTxE/IKzwi+6YOpnb/qPSXyMRzYFXxArujNdL3Tq8EaRmBvlXHyh0sNcXX+9zZQESmu6XfpoFNWVtV79Xf7AMFu2C2hgFF5XOV2TiSQ5omjP2VfyT1VQrfYlOVpGXWmx1BqmaQSckJxya8GlqKk1wa4RiP4vWiO2Fq34g811VrgEwi1MQsa9JWQwPOqDxdQtA7GSENm5c1nhkcvg0Zpi7m6+JxMRtjx683f0iMi/cMAFRQxMiv8nOpg11pq9VAZqYleX2Bntd+RNVuaVHa2KEkQFxqStCF10rwJBCwxcUKa8HLVvH+I55bwE21yirT4Ik5mNRTyUY38pDXi/M97xyn2Ar112HUJOu+VTbQ9r73kVFRsyeyuc9bTNEVZxj/uV6i9hGNtJeo8PCLSVW9dBBqvti33KHToTrdGy/crMFthHQXUExujCoa9mYAazEbs7pRR3/VEJ5VcokiMUiqUfi96z5dcR5eWIITKuKH5jJSRQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(136003)(396003)(39830400003)(376002)(110136005)(44832011)(4744005)(5660300002)(33656002)(52536014)(38070700005)(86362001)(71200400001)(8676002)(66476007)(2906002)(66446008)(64756008)(316002)(4326008)(66556008)(54906003)(55016003)(122000001)(8936002)(9686003)(76116006)(107886003)(26005)(6506007)(7696005)(38100700002)(186003)(508600001)(66946007)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUxNK0t0RldYVWFZdVBSNm1LSnp0dTM5TWgvdEw5L3RmQ1FLOFRPeVFtTEg4?=
 =?utf-8?B?dzhLeStLYkJLOGVQenRXbjRFNGlvNHY0alFoeHpHbzZrbU43cnJoZnBJMEhE?=
 =?utf-8?B?OGQxMTdWMmhFVllEbHNBZ0NqMGM3c2JGT1JHZlZVUFpmckVwR2RrNTV6SXJ4?=
 =?utf-8?B?RmJ5azRFVHZWSi9xb1RVZWU5dFdDTHpTQnJ6Qjh5bVoyNmE1VHlkYnBSMUhW?=
 =?utf-8?B?ZzdvdEVUZDRTc0F2RFpNcnkzZ1lBUlRuYVppdnZUWndyanlBS2IyZjgrMkpT?=
 =?utf-8?B?Nk9ZUytNaFpwS3pyam5UN3ZmZkdsb0l3STJSREZDa3ZiQ1pNSUtxZlhWVEYw?=
 =?utf-8?B?eEkyN0tPd0dlZExaU0cwMW5VM3dwazRxWXRGUXR1RGNaSVRqdUlDdFcvOUtq?=
 =?utf-8?B?dHhYaS83TjgxT3BrSlFTTC9jOGhRTXhYUUc5OTlLWHdIRi84a2JhSlNYRlJt?=
 =?utf-8?B?N1dobEZycUl4QUdWcDFJUVpwZERXYXo3aEc4Ym4zbGpMOEpLR0ZQUkF6bzlO?=
 =?utf-8?B?V0VWMlBRZytFZ2ttakJKSm53N0NLSmEzbTNoRWttbjdXaWVsZFlpcUpQemlJ?=
 =?utf-8?B?YzQvU3dvc2RwblBHT05NQVE4YUJNa1ZHcmRaZmVXQUVQWXI3cWtPZE5nWTRR?=
 =?utf-8?B?cE53S2NMRFB3aVRqcG9JcjZ0QkhsZW8yaUNJNmQ0KzRrNU1yRFEyaWNPRFJx?=
 =?utf-8?B?WVJYTzVZTWhQRUl5WXozKzZBcFlmdjBadk5aSUF6Mm9QdmtpSFkyN3QwNXlU?=
 =?utf-8?B?M3RzZDRCWTU3d1puYlJVZ2VXTytjbWIzNDhlRXMzcERFTzRTYjZKaHNKM0Rv?=
 =?utf-8?B?RHV6SmJKZmVvWG1wbGtSN0Q4YUp6ai8vTEh0L1VFbEE4LzQyV0pjT3dybnMw?=
 =?utf-8?B?QUlqbHJNeGIwNCsyZHFlMGtrNVkweDZUWVZwVU9IOXNzWWhTcnhMWk5zUUo3?=
 =?utf-8?B?dkFYZnY3WE42cnY5MkpLWHNqdFpSRituanRld3JEaWRsZzlVV1NiVjRMcFNi?=
 =?utf-8?B?WUtIRWtmNmdEWXlXRS8wcXFCRjNvLzl4SDBoenUxejQvcVdNbGNoeERhS282?=
 =?utf-8?B?dU5nb0FOZk5SS3cyVnl0UENEOWtJeDJrSTRnUWw2YkM4MDIvNDdGS1UxVGZu?=
 =?utf-8?B?UjdMakswQXRhc3h1NmNlZmJMVHZNenBNR00zdERReGpUZUJ3aEI0UlZzUVhz?=
 =?utf-8?B?ZlNLS0tiak12dUhPdERJTk52bUdqWnNWV214eFpiUzJtVjdKR2d5MElnZWd4?=
 =?utf-8?B?S2pjOXJycXBkb29hN09wZjJyVTNod01BS2E0U2Myd3pKMkREd3Fla0psQWFH?=
 =?utf-8?B?cTc4dUJLUkZWOFpzS1VhL3g3V0toQTNTRm5KeWVvclZ6L2FxM0lXRmZ6UEFi?=
 =?utf-8?B?d1hDajM3MzZNSEFIcU9EN2p1REY3Uk1BTHlsdytEdmtudm5VcnY1WGIzOTRv?=
 =?utf-8?B?RCsvRXRLWm5iUlpiOHRZaXNaOWhtUEdaaCsrUEtiSTc3VnN5dGtJM1ZzVVhE?=
 =?utf-8?B?N1V4RDAxbHFQV1BsR2ppeHp4VjNwT3VhTkgyVlR1djk1T1hFQ3RaTlU2cTZq?=
 =?utf-8?B?UHRiWlhSRElOR3JpZ2FudHFUa2o2V2ZkVWlrVnFDU0F6NE9BZFlwc3A2cTBW?=
 =?utf-8?B?aC9Idi8rWjU1OExFdTN1ZnAxbGF3UzNwQXgzdVFvNWpwY0JVaThTRlRkenVs?=
 =?utf-8?B?MTlTd01vTm1WUldVd0tRdEhkN0Qxc252UzB1Vkk4NXArNHRxVnoxNnFveS90?=
 =?utf-8?B?V2V6VTRRSjhXWW40Yi9SV1Eydk9Ndisybi9tWVc5cFFCRGh6OEFYazhQMnk2?=
 =?utf-8?B?d1pWM0ZOSS9udXJLdUFxbnJ4VzgvZC80eTdPVGs2OThqVTRQZEtvNnErSCs3?=
 =?utf-8?B?V3pXYlFTRVkzRkNkMnBhdlJvU3dTcjMxL3pycGxaMnRYME8vYVJnZEFURTJ6?=
 =?utf-8?B?SGdseWlSZytjNzJ1Q2huTVhQOGgwczFUMVRJdXVJWjhGdk9CTkpMendtNFhr?=
 =?utf-8?B?RVM1K0RnK0xpZmE4aTA1dGlDaVI2WnI5c2NKUFJlRjNXMHExWHIvNVZWaEhV?=
 =?utf-8?B?UVZsQWJ6dlpMRmdQd1BUem5BMkNhV2kvWDZPNzM5bkdpaWF3bnRWTE9ad1Zr?=
 =?utf-8?B?OEE0dkhIblNxRG5HM000Qm9mYmthRUlPbGFIRytiSm1MWG5jM0Z3MCtUUDQy?=
 =?utf-8?B?WWFNVGVxNThDc2ozVXZodmhzL1Ztdm1KWktOODJEalY0bkpJZUNhWXRoNVNZ?=
 =?utf-8?B?NDNsNXdIU1NzTUZxV0ZGa1JlUWhBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f22511d-29ef-475f-8b9b-08d9bd4b2df9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2021 08:41:23.9142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VGZIeTSX/lXqEfS0mPt9LpwyCGcVtmvqWTo3kcNn8s6k1p5PflZjXKFPkA/bm+rO4+aiKV1ODJxbDyZsN94rquMGsRqj2/RD9XPUXxX3aC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2473
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRGVjZW1iZXIgMTIsIDIwMjEgMzoxMCBBTSwgSmFtYWwgSGFkaSBTYWxpbSB3cm90ZToNCj5P
biAyMDIxLTEyLTA5IDA0OjI3LCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+DQo+PiBkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9uZXQvZmxvd19vZmZsb2FkLmggYi9pbmNsdWRlL25ldC9mbG93X29mZmxvYWQu
aA0KPj4gaW5kZXggMzk2MTQ2MWQ5YzhiLi5mNjk3MDIxMzQ5N2EgMTAwNjQ0DQo+PiAtLS0gYS9p
bmNsdWRlL25ldC9mbG93X29mZmxvYWQuaA0KPj4gKysrIGIvaW5jbHVkZS9uZXQvZmxvd19vZmZs
b2FkLmgNCj4+IEBAIC0xOTcsNiArMTk3LDcgQEAgdm9pZCBmbG93X2FjdGlvbl9jb29raWVfZGVz
dHJveShzdHJ1Y3QNCj4+IGZsb3dfYWN0aW9uX2Nvb2tpZSAqY29va2llKTsNCj4+DQo+PiAgIHN0
cnVjdCBmbG93X2FjdGlvbl9lbnRyeSB7DQo+PiAgIAllbnVtIGZsb3dfYWN0aW9uX2lkCQlpZDsN
Cj4+ICsJdTMyCQkJCWluZGV4Ow0KPj4gICAJZW51bSBmbG93X2FjdGlvbl9od19zdGF0cwlod19z
dGF0czsNCj4+ICAgCWFjdGlvbl9kZXN0cgkJCWRlc3RydWN0b3I7DQo+PiAgIAl2b2lkCQkJCSpk
ZXN0cnVjdG9yX3ByaXY7DQo+DQo+DQo+QmVjYXVzZSAiaW5kZXgiIGlzIHN1Y2ggYSBjb21tb24g
bm91biAtIGNhbiB5b3UgbmFtZSB0aGlzIG9uZSAiaHdfaW5kZXgiDQo+Zm9yIGdyZXAtYWJpbGl0
eT8NCk9rIHdlIHdpbGwgcmVuYW1lIHRoZSBpbmRleCB0byBzb21ldGhpbmcgbGlrZSAiIGh3X2lu
ZGV4ICIgYXMgeW91ciBzdWdnZXN0aW9uLg0KVGhhbmtzDQo+DQo+Y2hlZXJzLA0KPmphbWFsDQoN
Cg==
