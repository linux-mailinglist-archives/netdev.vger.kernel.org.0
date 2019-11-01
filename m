Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE9BEC363
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfKANBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:01:12 -0400
Received: from mail-eopbgr80051.outbound.protection.outlook.com ([40.107.8.51]:44501
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726784AbfKANBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 09:01:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1mZSqD3VlddBVgR/NiofDGR+IDnKBVsgBJJj6uBfk3h4wiUdHGOoMMX6AwXGy5PoqSFxt4aSsMjlquhFghmWDmE1OaeZXIt4noASwdDRrhFyhSgI2iB2oCjbbv5diu3lqkbbtpC2Lj7Ng093MvOGVHKb/AUrJm7G113BSk8G8m7U7X8XFaFHib9Ho6pjEDpYYkZCumRU5GlC2X3BkSUbj8I5LLrtziTUQbMspT7tFWOD5X5bcvotv57SvscFhbnON/ARjTFScmRf/q1u+dbYAqv9RXcKDNyVagkyLmZGGBVJsp2Wxu+oPw29Vp+c90eqasp0u9IITwhirfl39GKHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xn3wU8zzfMyC60cLqPOhezSNKkmwSAdjb49EG8r19EI=;
 b=e7AiVMiR2TEbRnVkE+g8pAzYorveVQvTG5usQTP8vSc9GdWtjiSCtrng9UTimizgRMiCuyCQYICB6vCzafx8HlLROmSqjeuWDOoi4FnZpIJnEAXVcSRBwOa+TzAzpo76BXsbpP8HVYkaM1bbumxbohacvn98osaTUYzEZF0AzLS3THPSnI4CJEkhlMcqO0JvtIpWY/l7MPRkcVwj8oDWDUrnXO7LV0Tnj8pfO5GTT6itYcv9SPy0jCF96smjMbsJwUlWE8ZVULRBRV/i8+c9Lu06gcAr0cx1d/YbWZ8EdRSe1lj65KAQI2NuECqjnowF++swHofXXOalAJ9zoJukGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xn3wU8zzfMyC60cLqPOhezSNKkmwSAdjb49EG8r19EI=;
 b=YUjctLQyK7XS1/+Kprtdvbx3M6OkLTskoyqRNn/BELzZzZnIUYojnHU/cJTX7/0+4etkgnv97tHZLyRgjS2vsoZpKQcXdZa9U+rtV1R48h6MqC3NkQKhJvAUTBt5xGI9HYUvym2FnlQ1ofnZFkdu4TODg9q1+ReKrWQaZpjhEoE=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5823.eurprd05.prod.outlook.com (20.178.122.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.19; Fri, 1 Nov 2019 13:01:06 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3580:5d45:7d19:99f5]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3580:5d45:7d19:99f5%7]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 13:01:06 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     John Hurley <john.hurley@netronome.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "louis.peens@netronome.com" <louis.peens@netronome.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Subject: Re: [RFC net-next v2 1/1] net: sched: prevent duplicate flower rules
 from tcf_proto destroy race
Thread-Topic: [RFC net-next v2 1/1] net: sched: prevent duplicate flower rules
 from tcf_proto destroy race
Thread-Index: AQHVkLMx5/o4Jg/wfUOIpPLf83boNqd2R26A
Date:   Fri, 1 Nov 2019 13:01:06 +0000
Message-ID: <vbfeeyrycmo.fsf@mellanox.com>
References: <1572548904-3975-1-git-send-email-john.hurley@netronome.com>
In-Reply-To: <1572548904-3975-1-git-send-email-john.hurley@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0160.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::28) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0dfb6ce8-64e7-4897-3a4f-08d75ecb8ed4
x-ms-traffictypediagnostic: VI1PR05MB5823:|VI1PR05MB5823:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB58236E537CF652A08F80A6FCAD620@VI1PR05MB5823.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(189003)(199004)(8676002)(11346002)(476003)(102836004)(26005)(6506007)(6916009)(256004)(14444005)(5024004)(2616005)(66066001)(66476007)(2906002)(446003)(186003)(486006)(316002)(66556008)(64756008)(386003)(66946007)(66446008)(66616009)(8936002)(4326008)(6486002)(305945005)(6436002)(6246003)(86362001)(14454004)(81166006)(81156014)(99286004)(3846002)(52116002)(99936001)(76176011)(36756003)(229853002)(71190400001)(6512007)(71200400001)(5660300002)(25786009)(54906003)(478600001)(7736002)(6116002)(4226003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5823;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PUKCYEFGZHlq7LPDHm7rBfE5k/6rD/GSV3qZ3Vaw/s1GlXr0OoYY1Mj0MCPtk+LzubZKA3pLtWidDwWFMTlEb96wK8OSE5lp3RikTA9m/SkXaGGrpKyhY/l7dOm2fb850VNbbJx6Q61RkeMB4qXepQp4sGgwl+BJP+FGBQ93ckn4m9TGWk7YC5bFOoEXTJFkJLW0F7kDDL2TFIu2K0JX7xiJWsHtHmVz5SBcOpGcuciCsUdiBNl1qWwbstwCY2e/lYoqOQ/YA+vlKIVk11hI/uXmew+MYAoR2d98WL25fBY+uA+tyPwgWFzz0PbAp7jZho/ol57vk6NsBripJcvzfMgZL6MUVFRHbD1IEm7TG9Nly0jxsG8IaHuvYtsL31iY7URor0QaoSRAcRNXuAEio6RJ3lxpN2pKnVdFcfZROt9Vttz+2palItnmTMrHZPXH
Content-Type: multipart/mixed; boundary="_002_vbfeeyrycmofsfmellanoxcom_"
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dfb6ce8-64e7-4897-3a4f-08d75ecb8ed4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 13:01:06.5848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2i5KiivYvAQGeDAt8+WBvtaVHRzvy1j1OzCMzslTWnsjcVl9LVvbWy1YcqrTdw2ysd03PcjiCNPJZKbInBwCXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5823
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_vbfeeyrycmofsfmellanoxcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


On Thu 31 Oct 2019 at 21:08, John Hurley <john.hurley@netronome.com> wrote:
> When a new filter is added to cls_api, the function
> tcf_chain_tp_insert_unique() looks up the protocol/priority/chain to
> determine if the tcf_proto is duplicated in the chain's hashtable. It the=
n
> creates a new entry or continues with an existing one. In cls_flower, thi=
s
> allows the function fl_ht_insert_unque to determine if a filter is a
> duplicate and reject appropriately, meaning that the duplicate will not b=
e
> passed to drivers via the offload hooks. However, when a tcf_proto is
> destroyed it is removed from its chain before a hardware remove hook is
> hit. This can lead to a race whereby the driver has not received the
> remove message but duplicate flows can be accepted. This, in turn, can
> lead to the offload driver receiving incorrect duplicate flows and out of
> order add/delete messages.
>
> Prevent duplicates by utilising an approach suggested by Vlad Buslov. A
> hash table per block stores each unique chain/protocol/prio being
> destroyed. This entry is only removed when the full destroy (and hardware
> offload) has completed. If a new flow is being added with the same
> identiers as a tc_proto being detroyed, then the add request is replayed
> until the destroy is complete.
>
> v1->v2:
> - put tcf_proto into block->proto_destroy_ht rather than creating new key
>   (Vlad Buslov)
> - add error log for cases when hash entry fails. Previously it failed
>   silently with no indication. (Vlad Buslov)
>
> Fixes: 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurren=
t execution")
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> Reported-by: Louis Peens <louis.peens@netronome.com>
> ---

Hi John,

Patch looks good! However, I think we can simplify it even more and
remove duplication of data in tcf_proto (hashtable key contains copy of
data that is already available in the struct itself) and remove all
dynamic memory allocations. I have refactored your patch accordingly
(attached). WDYT?

[...]


--_002_vbfeeyrycmofsfmellanoxcom_
Content-Type: text/plain; name="ht_refactor1"
Content-Description: patch
Content-Disposition: attachment; filename="ht_refactor1"; size=6325;
	creation-date="Fri, 01 Nov 2019 13:01:06 GMT";
	modification-date="Fri, 01 Nov 2019 13:01:06 GMT"
Content-ID: <82CC9110876FC54EACEFAE9B7AFE05D3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L3NjaF9nZW5lcmljLmggYi9pbmNsdWRlL25ldC9zY2hf
Z2VuZXJpYy5oDQppbmRleCA2Mzc1NDhkNTRiM2UuLmU2MDg1ODExNTU5YyAxMDA2NDQNCi0tLSBh
L2luY2x1ZGUvbmV0L3NjaF9nZW5lcmljLmgNCisrKyBiL2luY2x1ZGUvbmV0L3NjaF9nZW5lcmlj
LmgNCkBAIC0xNSw2ICsxNSw3IEBADQogI2luY2x1ZGUgPGxpbnV4L211dGV4Lmg+DQogI2luY2x1
ZGUgPGxpbnV4L3J3c2VtLmg+DQogI2luY2x1ZGUgPGxpbnV4L2F0b21pYy5oPg0KKyNpbmNsdWRl
IDxsaW51eC9oYXNodGFibGUuaD4NCiAjaW5jbHVkZSA8bmV0L2dlbl9zdGF0cy5oPg0KICNpbmNs
dWRlIDxuZXQvcnRuZXRsaW5rLmg+DQogI2luY2x1ZGUgPG5ldC9mbG93X29mZmxvYWQuaD4NCkBA
IC0zNjIsNiArMzYzLDcgQEAgc3RydWN0IHRjZl9wcm90byB7DQogCWJvb2wJCQlkZWxldGluZzsN
CiAJcmVmY291bnRfdAkJcmVmY250Ow0KIAlzdHJ1Y3QgcmN1X2hlYWQJCXJjdTsNCisJc3RydWN0
IGhsaXN0X25vZGUJZGVzdHJveV9odF9ub2RlOw0KIH07DQogDQogc3RydWN0IHFkaXNjX3NrYl9j
YiB7DQpAQCAtNDE0LDYgKzQxNiw4IEBAIHN0cnVjdCB0Y2ZfYmxvY2sgew0KIAkJc3RydWN0IGxp
c3RfaGVhZCBmaWx0ZXJfY2hhaW5fbGlzdDsNCiAJfSBjaGFpbjA7DQogCXN0cnVjdCByY3VfaGVh
ZCByY3U7DQorCURFQ0xBUkVfSEFTSFRBQkxFKHByb3RvX2Rlc3Ryb3lfaHQsIDE2KTsNCisJc3Ry
dWN0IG11dGV4IHByb3RvX2Rlc3Ryb3lfbG9jazsgLyogTG9jayBmb3IgcHJvdG9fZGVzdHJveSBo
YXNodGFibGUuICovDQogfTsNCiANCiAjaWZkZWYgQ09ORklHX1BST1ZFX0xPQ0tJTkcNCmRpZmYg
LS1naXQgYS9uZXQvc2NoZWQvY2xzX2FwaS5jIGIvbmV0L3NjaGVkL2Nsc19hcGkuYw0KaW5kZXgg
ODcxN2MwYjI2YzkwLi5jODI3ODUxNmY4NDcgMTAwNjQ0DQotLS0gYS9uZXQvc2NoZWQvY2xzX2Fw
aS5jDQorKysgYi9uZXQvc2NoZWQvY2xzX2FwaS5jDQpAQCAtMjEsNiArMjEsNyBAQA0KICNpbmNs
dWRlIDxsaW51eC9zbGFiLmg+DQogI2luY2x1ZGUgPGxpbnV4L2lkci5oPg0KICNpbmNsdWRlIDxs
aW51eC9yaGFzaHRhYmxlLmg+DQorI2luY2x1ZGUgPGxpbnV4L2poYXNoLmg+DQogI2luY2x1ZGUg
PG5ldC9uZXRfbmFtZXNwYWNlLmg+DQogI2luY2x1ZGUgPG5ldC9zb2NrLmg+DQogI2luY2x1ZGUg
PG5ldC9uZXRsaW5rLmg+DQpAQCAtNDcsNiArNDgsNjEgQEAgc3RhdGljIExJU1RfSEVBRCh0Y2Zf
cHJvdG9fYmFzZSk7DQogLyogUHJvdGVjdHMgbGlzdCBvZiByZWdpc3RlcmVkIFRDIG1vZHVsZXMu
IEl0IGlzIHB1cmUgU01QIGxvY2suICovDQogc3RhdGljIERFRklORV9SV0xPQ0soY2xzX21vZF9s
b2NrKTsNCiANCitzdGF0aWMgdTMyIGRlc3Ryb3lfb2JqX2hhc2hmbihjb25zdCBzdHJ1Y3QgdGNm
X3Byb3RvICp0cCkNCit7DQorCXJldHVybiBqaGFzaF8zd29yZHModHAtPmNoYWluLT5pbmRleCwg
dHAtPnByaW8sIHRwLT5wcm90b2NvbCwgMCk7DQorfQ0KKw0KK3N0YXRpYyB2b2lkIHRjZl9wcm90
b19zaWduYWxfZGVzdHJveWluZyhzdHJ1Y3QgdGNmX2NoYWluICpjaGFpbiwNCisJCQkJCXN0cnVj
dCB0Y2ZfcHJvdG8gKnRwKQ0KK3sNCisJc3RydWN0IHRjZl9ibG9jayAqYmxvY2sgPSBjaGFpbi0+
YmxvY2s7DQorDQorCW11dGV4X2xvY2soJmJsb2NrLT5wcm90b19kZXN0cm95X2xvY2spOw0KKwlo
YXNoX2FkZF9yY3UoYmxvY2stPnByb3RvX2Rlc3Ryb3lfaHQsICZ0cC0+ZGVzdHJveV9odF9ub2Rl
LA0KKwkJICAgICBkZXN0cm95X29ial9oYXNoZm4odHApKTsNCisJbXV0ZXhfdW5sb2NrKCZibG9j
ay0+cHJvdG9fZGVzdHJveV9sb2NrKTsNCit9DQorDQorc3RhdGljIGJvb2wgdGNmX3Byb3RvX2Nt
cChjb25zdCBzdHJ1Y3QgdGNmX3Byb3RvICp0cDEsDQorCQkJICBjb25zdCBzdHJ1Y3QgdGNmX3By
b3RvICp0cDIpDQorew0KKwlyZXR1cm4gdHAxLT5jaGFpbi0+aW5kZXggPT0gdHAyLT5jaGFpbi0+
aW5kZXggJiYNCisJCXRwMS0+cHJpbyA9PSB0cDItPnByaW8gJiYNCisJCXRwMS0+cHJvdG9jb2wg
PT0gdHAyLT5wcm90b2NvbDsNCit9DQorDQorc3RhdGljIGJvb2wNCit0Y2ZfcHJvdG9fZXhpc3Rz
X2Rlc3Ryb3lpbmcoc3RydWN0IHRjZl9jaGFpbiAqY2hhaW4sIHN0cnVjdCB0Y2ZfcHJvdG8gKnRw
KQ0KK3sNCisJdTMyIGhhc2ggPSBkZXN0cm95X29ial9oYXNoZm4odHApOw0KKwlzdHJ1Y3QgdGNm
X3Byb3RvICppdGVyOw0KKwlib29sIGZvdW5kID0gZmFsc2U7DQorDQorCXJjdV9yZWFkX2xvY2so
KTsNCisJaGFzaF9mb3JfZWFjaF9wb3NzaWJsZV9yY3UoY2hhaW4tPmJsb2NrLT5wcm90b19kZXN0
cm95X2h0LCBpdGVyLA0KKwkJCQkgICBkZXN0cm95X2h0X25vZGUsIGhhc2gpIHsNCisJCWlmICh0
Y2ZfcHJvdG9fY21wKHRwLCBpdGVyKSkgew0KKwkJCWZvdW5kID0gdHJ1ZTsNCisJCQlicmVhazsN
CisJCX0NCisJfQ0KKwlyY3VfcmVhZF91bmxvY2soKTsNCisNCisJcmV0dXJuIGZvdW5kOw0KK30N
CisNCitzdGF0aWMgdm9pZA0KK3RjZl9wcm90b19zaWduYWxfZGVzdHJveWVkKHN0cnVjdCB0Y2Zf
Y2hhaW4gKmNoYWluLCBzdHJ1Y3QgdGNmX3Byb3RvICp0cCkNCit7DQorCXN0cnVjdCB0Y2ZfYmxv
Y2sgKmJsb2NrID0gY2hhaW4tPmJsb2NrOw0KKw0KKwltdXRleF9sb2NrKCZibG9jay0+cHJvdG9f
ZGVzdHJveV9sb2NrKTsNCisJaWYgKGhhc2hfaGFzaGVkKCZ0cC0+ZGVzdHJveV9odF9ub2RlKSkN
CisJCWhhc2hfZGVsX3JjdSgmdHAtPmRlc3Ryb3lfaHRfbm9kZSk7DQorCW11dGV4X3VubG9jaygm
YmxvY2stPnByb3RvX2Rlc3Ryb3lfbG9jayk7DQorfQ0KKw0KIC8qIEZpbmQgY2xhc3NpZmllciB0
eXBlIGJ5IHN0cmluZyBuYW1lICovDQogDQogc3RhdGljIGNvbnN0IHN0cnVjdCB0Y2ZfcHJvdG9f
b3BzICpfX3RjZl9wcm90b19sb29rdXBfb3BzKGNvbnN0IGNoYXIgKmtpbmQpDQpAQCAtMjM0LDkg
KzI5MCwxMSBAQCBzdGF0aWMgdm9pZCB0Y2ZfcHJvdG9fZ2V0KHN0cnVjdCB0Y2ZfcHJvdG8gKnRw
KQ0KIHN0YXRpYyB2b2lkIHRjZl9jaGFpbl9wdXQoc3RydWN0IHRjZl9jaGFpbiAqY2hhaW4pOw0K
IA0KIHN0YXRpYyB2b2lkIHRjZl9wcm90b19kZXN0cm95KHN0cnVjdCB0Y2ZfcHJvdG8gKnRwLCBi
b29sIHJ0bmxfaGVsZCwNCi0JCQkgICAgICBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2sp
DQorCQkJICAgICAgYm9vbCBzaWdfZGVzdHJveSwgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0
YWNrKQ0KIHsNCiAJdHAtPm9wcy0+ZGVzdHJveSh0cCwgcnRubF9oZWxkLCBleHRhY2spOw0KKwlp
ZiAoc2lnX2Rlc3Ryb3kpDQorCQl0Y2ZfcHJvdG9fc2lnbmFsX2Rlc3Ryb3llZCh0cC0+Y2hhaW4s
IHRwKTsNCiAJdGNmX2NoYWluX3B1dCh0cC0+Y2hhaW4pOw0KIAltb2R1bGVfcHV0KHRwLT5vcHMt
Pm93bmVyKTsNCiAJa2ZyZWVfcmN1KHRwLCByY3UpOw0KQEAgLTI0Niw3ICszMDQsNyBAQCBzdGF0
aWMgdm9pZCB0Y2ZfcHJvdG9fcHV0KHN0cnVjdCB0Y2ZfcHJvdG8gKnRwLCBib29sIHJ0bmxfaGVs
ZCwNCiAJCQkgIHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjaykNCiB7DQogCWlmIChyZWZj
b3VudF9kZWNfYW5kX3Rlc3QoJnRwLT5yZWZjbnQpKQ0KLQkJdGNmX3Byb3RvX2Rlc3Ryb3kodHAs
IHJ0bmxfaGVsZCwgZXh0YWNrKTsNCisJCXRjZl9wcm90b19kZXN0cm95KHRwLCBydG5sX2hlbGQs
IHRydWUsIGV4dGFjayk7DQogfQ0KIA0KIHN0YXRpYyBpbnQgd2Fsa2VyX2NoZWNrX2VtcHR5KHN0
cnVjdCB0Y2ZfcHJvdG8gKnRwLCB2b2lkICpmaCwNCkBAIC0zNzAsNiArNDI4LDcgQEAgc3RhdGlj
IGJvb2wgdGNmX2NoYWluX2RldGFjaChzdHJ1Y3QgdGNmX2NoYWluICpjaGFpbikNCiBzdGF0aWMg
dm9pZCB0Y2ZfYmxvY2tfZGVzdHJveShzdHJ1Y3QgdGNmX2Jsb2NrICpibG9jaykNCiB7DQogCW11
dGV4X2Rlc3Ryb3koJmJsb2NrLT5sb2NrKTsNCisJbXV0ZXhfZGVzdHJveSgmYmxvY2stPnByb3Rv
X2Rlc3Ryb3lfbG9jayk7DQogCWtmcmVlX3JjdShibG9jaywgcmN1KTsNCiB9DQogDQpAQCAtNTQ1
LDYgKzYwNCwxMiBAQCBzdGF0aWMgdm9pZCB0Y2ZfY2hhaW5fZmx1c2goc3RydWN0IHRjZl9jaGFp
biAqY2hhaW4sIGJvb2wgcnRubF9oZWxkKQ0KIA0KIAltdXRleF9sb2NrKCZjaGFpbi0+ZmlsdGVy
X2NoYWluX2xvY2spOw0KIAl0cCA9IHRjZl9jaGFpbl9kZXJlZmVyZW5jZShjaGFpbi0+ZmlsdGVy
X2NoYWluLCBjaGFpbik7DQorCXdoaWxlICh0cCkgew0KKwkJdHBfbmV4dCA9IHJjdV9kZXJlZmVy
ZW5jZV9wcm90ZWN0ZWQodHAtPm5leHQsIDEpOw0KKwkJdGNmX3Byb3RvX3NpZ25hbF9kZXN0cm95
aW5nKGNoYWluLCB0cCk7DQorCQl0cCA9IHRwX25leHQ7DQorCX0NCisJdHAgPSB0Y2ZfY2hhaW5f
ZGVyZWZlcmVuY2UoY2hhaW4tPmZpbHRlcl9jaGFpbiwgY2hhaW4pOw0KIAlSQ1VfSU5JVF9QT0lO
VEVSKGNoYWluLT5maWx0ZXJfY2hhaW4sIE5VTEwpOw0KIAl0Y2ZfY2hhaW4wX2hlYWRfY2hhbmdl
KGNoYWluLCBOVUxMKTsNCiAJY2hhaW4tPmZsdXNoaW5nID0gdHJ1ZTsNCkBAIC04NDQsNiArOTA5
LDcgQEAgc3RhdGljIHN0cnVjdCB0Y2ZfYmxvY2sgKnRjZl9ibG9ja19jcmVhdGUoc3RydWN0IG5l
dCAqbmV0LCBzdHJ1Y3QgUWRpc2MgKnEsDQogCQlyZXR1cm4gRVJSX1BUUigtRU5PTUVNKTsNCiAJ
fQ0KIAltdXRleF9pbml0KCZibG9jay0+bG9jayk7DQorCW11dGV4X2luaXQoJmJsb2NrLT5wcm90
b19kZXN0cm95X2xvY2spOw0KIAlpbml0X3J3c2VtKCZibG9jay0+Y2JfbG9jayk7DQogCWZsb3df
YmxvY2tfaW5pdCgmYmxvY2stPmZsb3dfYmxvY2spOw0KIAlJTklUX0xJU1RfSEVBRCgmYmxvY2st
PmNoYWluX2xpc3QpOw0KQEAgLTE2MjEsNiArMTY4NywxMiBAQCBzdGF0aWMgc3RydWN0IHRjZl9w
cm90byAqdGNmX2NoYWluX3RwX2luc2VydF91bmlxdWUoc3RydWN0IHRjZl9jaGFpbiAqY2hhaW4s
DQogDQogCW11dGV4X2xvY2soJmNoYWluLT5maWx0ZXJfY2hhaW5fbG9jayk7DQogDQorCWlmICh0
Y2ZfcHJvdG9fZXhpc3RzX2Rlc3Ryb3lpbmcoY2hhaW4sIHRwX25ldykpIHsNCisJCW11dGV4X3Vu
bG9jaygmY2hhaW4tPmZpbHRlcl9jaGFpbl9sb2NrKTsNCisJCXRjZl9wcm90b19kZXN0cm95KHRw
X25ldywgcnRubF9oZWxkLCBmYWxzZSwgTlVMTCk7DQorCQlyZXR1cm4gRVJSX1BUUigtRUFHQUlO
KTsNCisJfQ0KKw0KIAl0cCA9IHRjZl9jaGFpbl90cF9maW5kKGNoYWluLCAmY2hhaW5faW5mbywN
CiAJCQkgICAgICAgcHJvdG9jb2wsIHByaW8sIGZhbHNlKTsNCiAJaWYgKCF0cCkNCkBAIC0xNjI4
LDEwICsxNzAwLDEwIEBAIHN0YXRpYyBzdHJ1Y3QgdGNmX3Byb3RvICp0Y2ZfY2hhaW5fdHBfaW5z
ZXJ0X3VuaXF1ZShzdHJ1Y3QgdGNmX2NoYWluICpjaGFpbiwNCiAJbXV0ZXhfdW5sb2NrKCZjaGFp
bi0+ZmlsdGVyX2NoYWluX2xvY2spOw0KIA0KIAlpZiAodHApIHsNCi0JCXRjZl9wcm90b19kZXN0
cm95KHRwX25ldywgcnRubF9oZWxkLCBOVUxMKTsNCisJCXRjZl9wcm90b19kZXN0cm95KHRwX25l
dywgcnRubF9oZWxkLCBmYWxzZSwgTlVMTCk7DQogCQl0cF9uZXcgPSB0cDsNCiAJfSBlbHNlIGlm
IChlcnIpIHsNCi0JCXRjZl9wcm90b19kZXN0cm95KHRwX25ldywgcnRubF9oZWxkLCBOVUxMKTsN
CisJCXRjZl9wcm90b19kZXN0cm95KHRwX25ldywgcnRubF9oZWxkLCBmYWxzZSwgTlVMTCk7DQog
CQl0cF9uZXcgPSBFUlJfUFRSKGVycik7DQogCX0NCiANCkBAIC0xNjY5LDYgKzE3NDEsNyBAQCBz
dGF0aWMgdm9pZCB0Y2ZfY2hhaW5fdHBfZGVsZXRlX2VtcHR5KHN0cnVjdCB0Y2ZfY2hhaW4gKmNo
YWluLA0KIAkJcmV0dXJuOw0KIAl9DQogDQorCXRjZl9wcm90b19zaWduYWxfZGVzdHJveWluZyhj
aGFpbiwgdHApOw0KIAluZXh0ID0gdGNmX2NoYWluX2RlcmVmZXJlbmNlKGNoYWluX2luZm8ubmV4
dCwgY2hhaW4pOw0KIAlpZiAodHAgPT0gY2hhaW4tPmZpbHRlcl9jaGFpbikNCiAJCXRjZl9jaGFp
bjBfaGVhZF9jaGFuZ2UoY2hhaW4sIG5leHQpOw0KQEAgLTIxODgsNiArMjI2MSw3IEBAIHN0YXRp
YyBpbnQgdGNfZGVsX3RmaWx0ZXIoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5sbXNnaGRy
ICpuLA0KIAkJZXJyID0gLUVJTlZBTDsNCiAJCWdvdG8gZXJyb3V0X2xvY2tlZDsNCiAJfSBlbHNl
IGlmICh0LT50Y21faGFuZGxlID09IDApIHsNCisJCXRjZl9wcm90b19zaWduYWxfZGVzdHJveWlu
ZyhjaGFpbiwgdHApOw0KIAkJdGNmX2NoYWluX3RwX3JlbW92ZShjaGFpbiwgJmNoYWluX2luZm8s
IHRwKTsNCiAJCW11dGV4X3VubG9jaygmY2hhaW4tPmZpbHRlcl9jaGFpbl9sb2NrKTsNCiANCg==

--_002_vbfeeyrycmofsfmellanoxcom_--
