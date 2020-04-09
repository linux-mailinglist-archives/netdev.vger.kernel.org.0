Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC631A3702
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgDIP0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:26:08 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28256 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727912AbgDIP0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 11:26:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 039FPUww025152;
        Thu, 9 Apr 2020 08:25:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=SAObrDh4BpvmmmMIk906+21KJgLj+iVWSYavS1bfa1g=;
 b=GNdL6uWvNwBJl+uULPy4Wd6hNu/T1mKt+0EcjpxtHekRy1WOolu1oAMfzW/ShZRFo6ok
 48KUHoqrNK2fcj3+hWIrogQwIrHXli1EpJe9qB83eBaxHFdQe7e77dvg3rtE7yMOSB73
 izMlayTSgZeqkkmtpR8nLmay2eVLULneeHEFWSmUx8CA0AOawTGIoaf/pWBmPBVyMaZH
 HO+0HXxBd5HkeKJpBuBa+gmaHHQya5tURIIe/WP17o1Gqt0quB18TcR09Vs7imh6oaB1
 1jZs+4lSujFsEHZrK3jaAWuOSxmaDNOam3IueoeK1BDgqwN5gKSbC9Irq9bkQNzRAjO+ Pw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 3091jwh18r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 09 Apr 2020 08:25:41 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:25:39 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 9 Apr 2020 08:25:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvHE4WUXXx/zVCqTiE0QdVzeEMYvETqO/Mm5WA4rLyBc4xS94oSVLw+9u1MQKpvZS+OwOrHn+mQEj+v5hVTsAZtK0Tl9w8/B/Asf5ONTZ/b2e7xCHG/6Yguk+St4TH+V22QxM+yY+PzjqZoD1S3jR4d+q5J6fsxpnVwAn/IRBBfaZZbMU9dhfwPYeWZz3gCJX5axoh9672/g8HckE8CKcOoFEMv8BiW95TQNsswnqkNHCoE5oauiJ8n34NRMWZlIGwFGcJ6kXAQpysAna+y1GsCep+g5tb1S3hECKeMBsffXYAYyG8mLmUYnDbon/xTRI6sEGb+Cf1qMlnHJ6GW7kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAObrDh4BpvmmmMIk906+21KJgLj+iVWSYavS1bfa1g=;
 b=GJkiprLwqVXiVZkVU9C0jwLSAFzDOdaL5gZEo14xJP4v1arw2OUUJ8+xCeI+ePOK0VQfrUHu6JJ+F9z0EvfFRAx+di64nlKMINhkl+CM6qwQAloufxSVyyQc8WJAgwLTb/h77JrSlQS4SQEnmPaRpIfvMrqk/AaVviF7xnj+dbueXK9YxCq6Emnacec3gqa0mcikyZvs726XP+vEzphTIs91p7nxxabTFpl5kAgHOAkQDxV5q2o9vG4aM4iPKHxt4nZ655d1lPkvjI/fL6Z4ji3DUPzGBySNTtc4hd7HhRJMxFjKyEKJ3qCCoM6inJUHA2jnCSCEB6soN2NQlHv/rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAObrDh4BpvmmmMIk906+21KJgLj+iVWSYavS1bfa1g=;
 b=mnPrfBVh6BC4WxATdxArvtNrykdZis6c4avcvHxhrt+MLP5wpKK33O0RbAuyJxaUKJfqQ1xGMCSAEDelDF2dP0uoXunWYP1fAEd5/GtiyHytgGDVA511yfj9ehjg8KtcNW2FrXuM23sIfP3Cp59x+j+Aw1tQLlMdTDWV9YswfQ4=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Thu, 9 Apr
 2020 15:25:37 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280%3]) with mapi id 15.20.2878.022; Thu, 9 Apr 2020
 15:25:37 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH v3 09/13] task_isolation: don't interrupt CPUs with
 tick_nohz_full_kick_cpu()
Thread-Topic: [PATCH v3 09/13] task_isolation: don't interrupt CPUs with
 tick_nohz_full_kick_cpu()
Thread-Index: AQHWDoMezv9vdBNP0UKJE60niGuu6A==
Date:   Thu, 9 Apr 2020 15:25:37 +0000
Message-ID: <eb1f4ecbda4aa49a23bc459a37b8f160828f2919.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
         <07c25c246c55012981ec0296eee23e68c719333a.camel@marvell.com>
In-Reply-To: <07c25c246c55012981ec0296eee23e68c719333a.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd9a56da-5fd7-4969-82c4-08d7dc9a4166
x-ms-traffictypediagnostic: BYAPR18MB2423:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB24236FB93201BB22CFB1E33EBCC10@BYAPR18MB2423.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2535.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(86362001)(26005)(186003)(5660300002)(316002)(2616005)(81166007)(36756003)(7416002)(71200400001)(2906002)(76116006)(4744005)(6486002)(478600001)(6506007)(6512007)(66556008)(64756008)(66446008)(8676002)(81156014)(66476007)(8936002)(66946007)(54906003)(4326008)(110136005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u8lIxSXLq+5FP9v9JHnqyAeolh5Fvh8Vbc8wtR/ZKwKvELXDUxR08Rtr54EaO20ncKIYbQtdXPOSrUMs0Vn0Maaj5mcw6LJG8Pm4NlAf1bqwNPFNQ3BQAIVyRMCLmm1/fdfv+NO9+F/jlMQAP9peOnRu+X+hy9UWlSkRVl4Oq/dQXvra1Xuo8NdO6T+i/sAhKKjIsfDmQiLi81adQunnSaL4RXi9e8YGS5lrVUHMgtmqNLUbq6ML+GwVGFlXB5zv8PsqSgw1NlKLUsDoxW0MxyLcHlL1pPFEGsBrKVXrQuadJTRmtHfmtzoOsksl9zAwnUdrk3SNaeEryHHxKKsdw/oqQxpEkYo86t9NU5Oon7q/lvJfZMAAiN8Xu+4HYrv2yV8tC7NkAy61xWuhO11fnrdWTpTOsQzpVIXENG5MAqCwaeP/KWct6pJmahFEXEeX
x-ms-exchange-antispam-messagedata: PVp9uW4Ymz1S8U6GLyvdvFiAqOv0PgoSNl5vnn03WCc6afG94RP3DO3yTOdED7JDOGHGcRCXQyx5y6zBZuF1Fo0Y5lB+4oXfvSWGg9nSTZtL4inZaXJVIh8H+ovQi0uh30ZYWRIdaw4h4KgBu3ZTwQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <75515075B8A98845BEB0DA9CF39FEF36@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dd9a56da-5fd7-4969-82c4-08d7dc9a4166
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 15:25:37.4267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g4KQWbzNfvW9YmKek8OD5BCVPKWRmmybLMl5ES8JQmDU3lyE4K+h013+vKp6A60FIHYPyENMsLtSLNTn44FF7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2423
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-09_05:2020-04-07,2020-04-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29tPg0KDQpGb3Igbm9oel9mdWxsIENQ
VXMgdGhlIGRlc2lyYWJsZSBiZWhhdmlvciBpcyB0byByZWNlaXZlIGludGVycnVwdHMNCmdlbmVy
YXRlZCBieSB0aWNrX25vaHpfZnVsbF9raWNrX2NwdSgpLiBCdXQgZm9yIGhhcmQgaXNvbGF0aW9u
IGl0J3MNCm9idmlvdXNseSBub3QgZGVzaXJhYmxlIGJlY2F1c2UgaXQgYnJlYWtzIGlzb2xhdGlv
bi4NCg0KVGhpcyBwYXRjaCBhZGRzIGNoZWNrIGZvciBpdC4NCg0KU2lnbmVkLW9mZi1ieTogWXVy
aSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29tPg0KW2FiZWxpdHNAbWFydmVsbC5jb206IHVwZGF0
ZWQsIG9ubHkgZXhjbHVkZSBDUFVzIHJ1bm5pbmcgaXNvbGF0ZWQgdGFza3NdDQpTaWduZWQtb2Zm
LWJ5OiBBbGV4IEJlbGl0cyA8YWJlbGl0c0BtYXJ2ZWxsLmNvbT4NCi0tLQ0KIGtlcm5lbC90aW1l
L3RpY2stc2NoZWQuYyB8IDQgKysrLQ0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2tlcm5lbC90aW1lL3RpY2stc2NoZWQuYyBi
L2tlcm5lbC90aW1lL3RpY2stc2NoZWQuYw0KaW5kZXggMWQ0ZGVjOWQzZWU3Li44NDg4YzI4MjVh
NDUgMTAwNjQ0DQotLS0gYS9rZXJuZWwvdGltZS90aWNrLXNjaGVkLmMNCisrKyBiL2tlcm5lbC90
aW1lL3RpY2stc2NoZWQuYw0KQEAgLTIwLDYgKzIwLDcgQEANCiAjaW5jbHVkZSA8bGludXgvc2No
ZWQvY2xvY2suaD4NCiAjaW5jbHVkZSA8bGludXgvc2NoZWQvc3RhdC5oPg0KICNpbmNsdWRlIDxs
aW51eC9zY2hlZC9ub2h6Lmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0KICNpbmNs
dWRlIDxsaW51eC9tb2R1bGUuaD4NCiAjaW5jbHVkZSA8bGludXgvaXJxX3dvcmsuaD4NCiAjaW5j
bHVkZSA8bGludXgvcG9zaXgtdGltZXJzLmg+DQpAQCAtMjYyLDcgKzI2Myw4IEBAIHN0YXRpYyB2
b2lkIHRpY2tfbm9oel9mdWxsX2tpY2sodm9pZCkNCiAgKi8NCiB2b2lkIHRpY2tfbm9oel9mdWxs
X2tpY2tfY3B1KGludCBjcHUpDQogew0KLQlpZiAoIXRpY2tfbm9oel9mdWxsX2NwdShjcHUpKQ0K
KwlzbXBfcm1iKCk7DQorCWlmICghdGlja19ub2h6X2Z1bGxfY3B1KGNwdSkgfHwgdGFza19pc29s
YXRpb25fb25fY3B1KGNwdSkpDQogCQlyZXR1cm47DQogDQogCWlycV93b3JrX3F1ZXVlX29uKCZw
ZXJfY3B1KG5vaHpfZnVsbF9raWNrX3dvcmssIGNwdSksIGNwdSk7DQotLSANCjIuMjAuMQ0KDQo=
