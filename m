Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C67B477987
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 17:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbhLPQov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 11:44:51 -0500
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com ([104.47.70.106]:24802
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233452AbhLPQou (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 11:44:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfzqdJL/iS7MKd80zrdVvcpSilpOFAMn1hZ4fMFeuft07/kDyfLd8y7Jq5LDVqYQjYU6SM54SmwVwflqUGVszfnVqqbA4VAP2brSX1j47K65oEXLgdP5AnmPEMr6B7s75RHqQjHE5WnQHPrGgdv6BOZVbtFXj00aXtdvAer9uHXVdWjHaZ5a+4Bl4mH2Y3dOACifPBE5oW6LQyn0Ol+Ws1IrqXPE6pTRl8ZdOrvK+ItF/vvXw7g8Cpn/MZ8pPRZxZLUHyCGnDLl7f97RTCEcQCBwY8VtEFehJQnbiW7PIzqd1wn/y+f4WUl4EQuIEcbfGCF+di/CIGkKrHumKRAegQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4HKKflOWafx9Qr+itaLX74BRKdJHKQ6UVzjmdNobOk=;
 b=anQLRI5J2CKqwgg5EuDeyEBv0Hmx8JCU/BbiquK644F2DLQlwoG6JwrDxFwOEmFzdTXffQmibQgR5VmtsATCVG6rLoy4dj2DGjfBQ8Jbw5To0Hwo3E6IYmP/IcZXLIEf3yEv8vTscS0u+OnSB/sNg9qN6cQCaT1IZXe9N0TUv6iZeghW7O90o712uOIGBqUFwiwm/K0jYpZEHfutTzGMBeZmSA+rJ7hZp+0E0/VQjbNqHQUy4AYV/yk/F8TRumDS6KUwTgzB4puv/kPYz0CJ5oIWwDXcr8tI/60yspx3+UgHK/1M49VeInWoi7w1N6I7tYHSbbPpep5ykGIliootSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4HKKflOWafx9Qr+itaLX74BRKdJHKQ6UVzjmdNobOk=;
 b=ZjUm0+YFV8QmWBoNpPSRCYC7WvxEF/pujs1o1xNqg30jqWVs560OykYldMaVvnf9a0IWfQ28MyFXYc0Xn5LHJzZaqRjHOl0hubKziiKFLgvf5Qq9/2vCxPhxXC+fMAgtmK39P3m4QM1b52aGn0AqFcf0zAS6U99qPeDtevtY8I4=
Received: from BN8PR21MB1284.namprd21.prod.outlook.com (2603:10b6:408:a2::22)
 by MW2PR2101MB1130.namprd21.prod.outlook.com (2603:10b6:302:4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.1; Thu, 16 Dec
 2021 16:44:45 +0000
Received: from BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::e95d:8758:9beb:f7fe]) by BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::e95d:8758:9beb:f7fe%4]) with mapi id 15.20.4823.008; Thu, 16 Dec 2021
 16:44:45 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH net-next] net: mana: Add RX fencing
Thread-Topic: [PATCH net-next] net: mana: Add RX fencing
Thread-Index: AQHX8hKnwrz4drl/K06DQMpBV4SI+Kw1U9cQ
Date:   Thu, 16 Dec 2021 16:44:44 +0000
Message-ID: <BN8PR21MB1284192697C792E80D53233BCA779@BN8PR21MB1284.namprd21.prod.outlook.com>
References: <20211216001748.8751-1-decui@microsoft.com>
In-Reply-To: <20211216001748.8751-1-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2a0180c2-880f-4ccb-8129-4acdf6ef1607;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-16T16:43:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e2a6f3c-081b-4045-4b13-08d9c0b35d97
x-ms-traffictypediagnostic: MW2PR2101MB1130:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB11309E5FF5D3215AEFD78142CA779@MW2PR2101MB1130.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fn/9iBTEdpxAd+Vpc/f2VcUo8V180L0n3COQIiQtcI30hogoWG6Weyq9JD6M1aBhD57KxtcvDXwjzqcQYfHCMgnQAeNPyw7LTsS2T+VzpXntlURm5wSlqtVIy+ikZx/xTrpmV15juIg5iYdNFBnRwfX2Jof5ai5vM9Fi0Q6m+gU0HCCZVgGjk9G5fi+RG6PsKOl5CLhTQHqFmcuiwHFvsdihb9zHFrxBYzkTrEWzXOmRDM/Z+bPh2HQ3aE51D5NMsYw9ij6TRtdnphK4ZO0uYEiqMXjayBCQoO/Om8/0xuY74TCfOvWJlYWspDz4kSw8azY/xXEFfapG9lLXbxIqHDxCvMfn/6mIYU/ybCa1l8cpsMYCknx9Rl4D239kvCAh3My/MbXp3EAqnjFSmuhSaIhrWQg68Rj2AZCJENQ5YOM/P0x6Raiw+GvH7+fy9uoZCrA8f41ylNXDJ4KDcfXGnZJorf+b0LnTCw5Qup8H4Pwp+3JCfyOcYXL2LCURGCFr0BYNZa/Rc3cp1WWeeRCebehptVoI1ipm+GIpyyu8PTnAt8q/w6xxtXzWluDuXXZ8Rgv6CkBtmNRwiYaTw2ikf8xh+e6k80A7hnuCZebtEh5dVgY7hCYV0AcSrPsk/Og4oFAbucP87snxfelmHSuQqRE6vnowmOEdfuqbM++q1AKvsF8vwMrQR+Z9gmX82yu1vbjlhZrSZBsIooErUKeslfl0qNVtWY1W1OA7qds6xmLueFN3/Ik1j72ZCvh4asDj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1284.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(83380400001)(7416002)(64756008)(8936002)(10290500003)(38070700005)(5660300002)(66476007)(8676002)(26005)(55016003)(186003)(66946007)(2906002)(66446008)(7696005)(66556008)(76116006)(8990500004)(33656002)(52536014)(82960400001)(86362001)(38100700002)(122000001)(9686003)(71200400001)(110136005)(53546011)(54906003)(508600001)(316002)(82950400001)(4326008)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ec9qO77XCVzkzmmGe6ylkP5RDG1xqExNMBbh+1iggAYLTRX9Viy+6kqsezvQ?=
 =?us-ascii?Q?QO3caFZVKcouI4p0PxLxLudae6jHyhrXBliJqKoNouM6SZeYg2g25XDb+OvD?=
 =?us-ascii?Q?YcKPccSBZnhAMz++8kdkw6MF1UmeWqYzsCOBfLNYpTCw6kS9Za2L3fjacdMu?=
 =?us-ascii?Q?j0IGyEmGh2eKOLKd+q/rOJL1aC2k7gcS4caa0w7JBUZLvZhEwqPrPbDx7k45?=
 =?us-ascii?Q?ppyexLbad0Zv1i/i//du3N8C6hWEL9CLcsb//Zk4LWR3BLyXwj5yTiBV6exs?=
 =?us-ascii?Q?gb+WEcb+rRN/CutQ4V4G8FNSja24rw1Cva9G8p3DGbJZyMDQaz6O/dvfYS8T?=
 =?us-ascii?Q?R+aGEaoNnixdmG4UsSLZ4u5/aPWgnh1FQgbWXGthbaaqogQJ2BcKS2hDTIaz?=
 =?us-ascii?Q?1/Ra7w91MC+r7oyID1F1ZPgAvad0cwD1/3OD4M6Yq0urp4NWkYNNn0oDiQWA?=
 =?us-ascii?Q?YXnb1qBzfyBt8j/0qN4iGlQsmy6ShhY2K60QlItpUyuCgvZ5tAWlHonQbvwF?=
 =?us-ascii?Q?jZziwcWQ+os2j78IQm615D0BrJjbHNkWscdjMrKrbRq+FqhShZRC5cA8/F1+?=
 =?us-ascii?Q?ShuSK+DvoAGQeOKWAZsuUGrYlmFl5QnL9YdfKV6sKICMqpOJkmHgIChzCqfF?=
 =?us-ascii?Q?OAUlKP5gp856dP+3xbGN9vTVzl1K2g22Ovm2+qEf5LHvO3jZOg7AfGNjIr/Y?=
 =?us-ascii?Q?tjMIDQy4eASf1MAanx5E/f3XO8YmgAGjf9p//XiTBrxj1UCyDnglhwVx2yRf?=
 =?us-ascii?Q?Ykwfud5iZryeeh+fJJb+ekn7oScmge1Hj1bHL9ekswVACRShiviZTQmHtKsG?=
 =?us-ascii?Q?EWwgg0UmeYZ7h+pnQEPFtQzOmx4e/6m63QIlIQTzzctjVaEGHs7Rn7iZHnSr?=
 =?us-ascii?Q?tNQZH7AqsjP3eptRh4ZRaLli8lvhXBDngLAhI/A602AwWhOJk26BpUuYFSXy?=
 =?us-ascii?Q?FnHRVdk9CI9YhyULNQlpS+ixsT2iyWOkXqHY9fk99FRf40+hzt8kRtOoxE4r?=
 =?us-ascii?Q?wJy1YQLPxhthzjl972oR4oU8dbp3G2eJxvYlvcaee7GQTHwyMzEON6DkyGk8?=
 =?us-ascii?Q?zdt5/VTXel7dol6qejG4pG2kWnz2YXmtR9YArhnFbRyacBnJVfD9YKt542ZG?=
 =?us-ascii?Q?mKvI6PPt2E0KIUWtugz+mPQNUJq3B1aGapuhzZ+RTQQyDAX9oUn4DWxdv2Le?=
 =?us-ascii?Q?uhL/O88y7bf2LASRdFomH67hhXCL+izkqWCo3QNpKSBK65iRl5IN8BYjvgaM?=
 =?us-ascii?Q?1pZM/yrNw8IuXw5odDLL5roWxqarePqDA3m4x5UyM91sABaXAvQotgIYrsHR?=
 =?us-ascii?Q?W+Csv+MrgOBN3fww34C3t0m77M2A4t0dj7Ayf3xIJGGf7RPmUOPBKjb9/8ut?=
 =?us-ascii?Q?32wxw7Km2yeI4lPIXt5/lwiBWiQA2wP+6btr31HiHnr7pl4uvYWYxmYGjB6Z?=
 =?us-ascii?Q?Fe5dPQu/udAZ4kzbNyt5Jq9BqQgmkDYFT3OXfFvEui8Y5Hm+3GCP1/1ccm+v?=
 =?us-ascii?Q?aXXqypSqesPKvIEqP5OyBKxUgietH5iiDov/b4X3CLtFwK+2AVJBPZnPWjNW?=
 =?us-ascii?Q?x94d6TFNz8OUPhYG0hpl04KJMm2V/hoFI4skes8ExwAUt/3zTdevjVZkOXmu?=
 =?us-ascii?Q?NQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1284.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e2a6f3c-081b-4045-4b13-08d9c0b35d97
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 16:44:45.0011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c/Oc89t1CnPWjPnV4HcEfDAmr7VFIPuVMgacQEawwstEQjTVJps8uao8bkmPY40CVAIg7NxnXirQpqULgOWamA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1130
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Wednesday, December 15, 2021 7:18 PM
> To: davem@davemloft.net; kuba@kernel.org; gustavoars@kernel.org; Haiyang =
Zhang
> <haiyangz@microsoft.com>; netdev@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; stephen@networkplumber.org; wei.li=
u@kernel.org;
> linux-kernel@vger.kernel.org; linux-hyperv@vger.kernel.org; Shachar Raind=
el
> <shacharr@microsoft.com>; Paul Rosswurm <paulros@microsoft.com>; olaf@aep=
fle.de; vkuznets
> <vkuznets@redhat.com>; Dexuan Cui <decui@microsoft.com>
> Subject: [PATCH net-next] net: mana: Add RX fencing
>=20
> RX fencing allows the driver to know that any prior change to the RQs has
> finished, e.g. when the RQs are disabled/enabled or the hashkey/indirecti=
on
> table are changed, RX fencing is required.
>=20
> Remove the previous workaround "ssleep(1)" and add the real support for
> RX fencing as the PF driver supports the MANA_FENCE_RQ request now (any
> old PF driver not supporting the request won't be used in production).
>=20
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/net/ethernet/microsoft/mana/mana.h    |  2 +
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 69 +++++++++++++++++--
>  2 files changed, 66 insertions(+), 5 deletions(-)
>=20

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

Thanks!

