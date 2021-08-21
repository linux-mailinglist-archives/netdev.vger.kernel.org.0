Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836E63F37BF
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbhHUAdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:33:43 -0400
Received: from mail-oln040093008007.outbound.protection.outlook.com ([40.93.8.7]:25845
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229783AbhHUAdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:33:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXMvviMpMjX5TRPpKkQw39mxdFyy3+7je7ucI8IHFVobAIjYZwJ5DbXJ4V5DnG9LGFgQMMjn7S8r/3fJo4hWTR9f2tIRUemn8zzM7UnUXoOymdoq9wEyq75pfs7Ez4Mge8r7LuYVRnTHB+CrC1UAyj515eb3e/8vyOqnpQfOI7dA4FoAUjnZwdfY4EXu1VTP4ODuMQycuPYOHgttYuzAXlWa3isgaj1EN4LaTP3LPnvoSd51vGpUGmwIOOnkGEPjtwXyCeQR2Mlu5A/mRy+u+X2tlStUeNTGppCYhNL6ZR0FB+mDS4Zw8CVzl7tZCM9INwCIJ/hEfLscICR6BZUyGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+8iapUXxzMPKiNB5u3koXEanDDZUGp1hG/kkfrQYjo=;
 b=jRTp9fGch0EEgLHNpaid74Sz0PG8fcA0UiRdC/IbWwYc0jr+wYsVEUBFbjUWEPYpO+FyR3qWykeG1QnWDhLFIpkGUb0RZshhqxdrWd7/fzl/xJ/5tnxjDse6k9gZymRGBU2UZuKsj1kf2n0hqiNNxk9HS4DAwmF1ndgpWEBd/mKX0eAS1dnw9IxDJrjbfrlMGvCpm3uLYqSqxN9hljK9mddGgAvOA4wXpx2ZszA18KhiAiF14GWQnlopC6SgU3JVHWDsit96DTqJeDbUl1QNeue8PcE4r2RXc9uEYyNgDCCHHNzN8GTGOLOoEjU3un/cRjGvAWD8vrMC6l0+ZllqfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+8iapUXxzMPKiNB5u3koXEanDDZUGp1hG/kkfrQYjo=;
 b=apKgHFB9CfHwClELbHqxbaQnahav5guta2GvDUmL6VRhv3Ji/THinQDW1GMf8klb38LkD9/3Y70+fEq2QvrlWCeU7JBy1nDoltOgjj+EWfqWuLDfbzTO0zJcmLpQaN4M14v19NQqQDUHt91N4biSuChlxJKsHtdtEZU6cSzu0HY=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BYAPR21MB1638.namprd21.prod.outlook.com (2603:10b6:a02:c2::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.1; Sat, 21 Aug
 2021 00:32:59 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::40bd:1fd1:f54b:e7b7]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::40bd:1fd1:f54b:e7b7%3]) with mapi id 15.20.4457.008; Sat, 21 Aug 2021
 00:32:59 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] mana: Add support for EQ sharing
Thread-Topic: [PATCH net-next] mana: Add support for EQ sharing
Thread-Index: AQHXlgQI4YpBkA2JjEWp71Mlpoc2l6t8+fEA
Date:   Sat, 21 Aug 2021 00:32:59 +0000
Message-ID: <BYAPR21MB12708078CCAD0B60EAA1508BBFC29@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <1629492169-11749-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1629492169-11749-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=39af8494-2174-414d-b904-55e74a9fa146;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-20T22:30:32Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d7de1e2-b192-4c53-4e02-08d9643b3a75
x-ms-traffictypediagnostic: BYAPR21MB1638:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BYAPR21MB16381723701A42B3EAD9CEB0BFC29@BYAPR21MB1638.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fQfiN+C4k4C/XJAWKzs83VznrPH/etgp1g1UbPb4ynTjlvdnFFU0VE0uBpSlSaNMJ/N/jgZQ/2N0LXX9xc0FscfpcF4Ax2I6+aqpGFDxjZSXHAcirJiHJ1j3Jz2sTlQPtqLdw02XRf7iT3OxmwRJDhVZ/5aT3MZdTIMXkNmlOksbtUF67afIDxjS/caTcuWGlY58hGWk0aJKuX4Fi3aHwgQ0EV2qHHQd6GemtTCLyiL7pvl9x7zc2w6rB4CsKZghbv7v3NsOdGKTHBNoOo9hX8pUWcz8Gj5I77rD8J7bJL+nqxrOj2C+8RpDX0jLoz7uJtKXSYcbN0C9jz0/njdk77WYZwc1pyLsuP7tVzJrEEVrTwZAx2VZvUy1XKMl92rWbTaeh6ICpckB/xhkpiszBuZBoTYxEb8+6LeEDZl/kW+0nCtc24jLtzudh2o/92a+ilby+dU4lbm1vuJEXpRCQqveqfvc4+MMetYwHMmYNICghf2AMWTBuB3LFpx90OzQ0l+5LsEJA1TsQXstPkmZhZy6/2gwMBTFxwTt1EUYqovlRr4rrzjWP48gcL5xJygOarB8aCXzhSU4fDeuml/LydXwmdjfDXW130ZF7C1da9ajdEleL7NeqK14aTNQb/MbZxaebNjl5XAAEbeguYWK3abmwUQeBedkj4tIm7nDpsdS3GsB5oBGLmq2pIGTVnPR9J4YUKEJyEssepNRzxby3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(2906002)(5660300002)(38100700002)(55016002)(83380400001)(508600001)(4326008)(8676002)(10290500003)(9686003)(71200400001)(6506007)(26005)(316002)(38070700005)(8936002)(86362001)(110136005)(7696005)(54906003)(82960400001)(82950400001)(66946007)(8990500004)(66446008)(66476007)(64756008)(76116006)(66556008)(33656002)(122000001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3N+CzxlXBZI8St48dGxoNUonv1tfc3stiCI7TJIM+uIbKEscWNpIy9UmzSdM?=
 =?us-ascii?Q?SOhoKvPNHJdz4Z5GUs2FAFQm7qOt9clQiJN6nXJIJ/t84PdNqLgJagopWj+g?=
 =?us-ascii?Q?NwtxvFgSNA3YfmGOZJEQdiu2umPdjZQS1vGfSyQrOs8zlrlvjPObOt5hPPEz?=
 =?us-ascii?Q?6q9/kr/BO1GvNgM38sOpFtQqiiRwpxnVyn8y42pNzOCYmgoMxkqT5dsTUDqT?=
 =?us-ascii?Q?F0SRrYyEeEi/lhW3JWbjyYi2o6vOD+uLY7g3nxImkeviAwxCe/zjK4JjGG4+?=
 =?us-ascii?Q?7MfY2x1dOV1HOeqW6AKoKJe08tOzU+8iO/6mI1bPVJO5gEjl1s1RChA2xevd?=
 =?us-ascii?Q?mlmULjfBgZaUCBRLDyrqUxjx92KAndGqZ4ghSPgdkHyWcm0UYtxIIEkvvxqp?=
 =?us-ascii?Q?XXB1lPhEfd6wpiqU1fkYsUXyfyVvyj3XVMtAHrIQmmNhfDqNv3B9UptnnOM7?=
 =?us-ascii?Q?3B53YxwSAcsVDcTe1mDM9Ai6N9dT10p6P95Y3Q9dz83Tc/7zpiiDNkmXqIk3?=
 =?us-ascii?Q?JW4YFj/dQaZapwsM7lMAu3xRIF75bG2qpjPhpXyzyhOppMTwzq4xM7q/TsWI?=
 =?us-ascii?Q?NFLIW/7hUB5Vu/PPMAs3jOxBdk3STA1K61o/kpq9tBHhRHr60VGeygqz5U9B?=
 =?us-ascii?Q?wV3TO8IzsZLzfvfkfooeK/Du9jpESlZPtMwyTarRv55kR5FMwCVqTir01R/S?=
 =?us-ascii?Q?Y16c3S5n+2NMryXRG9aLWplQs5l/wkoQLInkmICI2DzDXeLVexjZNxxMzCxv?=
 =?us-ascii?Q?vLcZEwnmOj7kEkZK6uIYF+2vK1GsC75tFidx2aO6Gh+wO4O7QC1ckbVagNBH?=
 =?us-ascii?Q?TaRKs/3NTW7v7X9lRZT17M7lA1ddKg9dWgEwBhMoJ7E7ur/QmRNMmCLugZfG?=
 =?us-ascii?Q?WgNYRNquvGy0VMBMWwSnosn2kVQNez825sYaqIrzpy0zEFDxPRY31OXvRoom?=
 =?us-ascii?Q?ywIwFwO2kck+H9si2XNhzV4yys0ZldFQMLMRabKpP4ilsp1dkQHpJbltjGCp?=
 =?us-ascii?Q?ERTQ8+30MNDMNEicVbzWMOVHK2QumXGcx/3Ny8PmIgzsFgaSXSJevCvHKtp8?=
 =?us-ascii?Q?JKKG73ulbHul8ezn/77PG/C136BTIZausjl5twNOMdScAqiuxo//bSlSzezZ?=
 =?us-ascii?Q?aFir7BGR3iJXOGUipEe1IXzge1eU3pY5Ru2tYyDBS0klHELzKRyONF9zq6wz?=
 =?us-ascii?Q?m9Sel9ClOuB9HRveMOY1h6tp+zkAI2x7wShDhQL6nor7KJ9xhgH8zs11ZTKl?=
 =?us-ascii?Q?FHKpblGvkg6PSCUbPsuE2p68c1Eh/++iVbl1RBgalkrIFaaa87DgNP56Ymfa?=
 =?us-ascii?Q?gcUQNhl15pLvI9+a1RG+TWHq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d7de1e2-b192-4c53-4e02-08d9643b3a75
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2021 00:32:59.3931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4WJWwfVGb3sv3xr4JLSMa/Bwsyg8ySoE0ANHCZ0k4xorEZsTYHhdZta8iFSNWHBwxcWYD6Q0oPYkywnaWf3X0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1638
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH net-next] mana: Add support for EQ sharing

"mana:" --> "net: mana:"

> The existing code uses (1 + #vPorts * #Queues) MSIXs, which may exceed
> the device limit.
>=20
> Support EQ sharing, so that multiple vPorts can share the same set of
> MSIXs.
>=20
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

The patch itself looks good to me, but IMO the changes are too big to be
in one patch. :-) Can you please split it into some smaller ones and
please document the important changes in the commit messages, e.g.
1) move NAPI processing from EQ to CQ.

2) report the EQ-sharing capability bit to the host, which means the host
can potentially offer more vPorts and queues to the VM.

3) support up to 256 virtual ports (it was 16).

4) support up to 64 queues per net interface (it was 16). It looks like the
default number of queues is also 64 if the VM has >=3D64 CPUs? -- should
we add a new field apc->default_queues and limit it to 16 or 32? We'd
like to make sure typically the best performance can be achieved with
the default number of queues.

5) If the VM has >=3D64 CPUs, with the patch we create 1 HWC EQ and 64
NIC EQs, and IMO the creation of the last NIC EQ fails since now the
host PF driver allows only 64 MSI-X interrupts? If this is the case, I thin=
k
mana_probe() -> mana_create_eq() fails and no net interface will be
created. It looks like we should create up to 63 NIC EQs in this case,
and make sure we don't create too many SQs/RQs accordingly.

At the end of mana_gd_query_max_resources(), should we add
something like:
	if (gc->max_num_queues >=3D gc->num_msix_usable -1)
		gc->max_num_queues =3D gc->num_msix_usable -1;

6) Since we support up to 256 ports, up to 64 NIC EQs and up to=20
64 SQ CQs and 64 RQ CQs per port, the size of one EQ should be at
least 256*2*GDMA_EQE_SIZE =3D 256*2*16 =3D 8KB. Currently EQ_SIZE
is hardcoded to 8 pages (i.e. 32 KB on x86-64), which should be big
enough. Let's add the below just in case we support more ports in future:

BUILD_BUG_ON(MAX_PORTS_IN_MANA_DEV*2* GDMA_EQE_SIZE > EQ_SIZE);

7) In mana_gd_read_cqe(), can we add a WARN_ON_ONCE() in the
case of overflow. Currently the error (which normally should not happen)
is sliently ignored.

Thanks,
-- Dexuan
