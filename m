Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32823F5584
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 03:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhHXBjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 21:39:32 -0400
Received: from mail-oln040093008008.outbound.protection.outlook.com ([40.93.8.8]:14375
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233634AbhHXBja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 21:39:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PtqWPiAY+WYdWS2JucO5Wc4UTn+zG9RRfaLx3rj5Z9k1kYW8424M/T1+mLNRWEAgODYSy01X0K3xhMq8IsA4UGgSrZC87zj9g/L6YxRFnYOtd/cU4FAu/lurEjkfbooQoafnfr51Feu2aQX1gLC8/FhBZv+7fuTtc/zOJgiXl5fTetp9Yuk3I9ZtciPAjlRxEdlGHP84eRceMVgqg0HHDJegbY43axHBFDxf2442Tr9WdB9ddv0s3g2V0nxVhdzWhK/7JoPG9HYF/vARDTK+3GYH6ItJIq9fkI0eFEFzNcXHAS4Y5gw0ZJvH4h1j7VSNw4aRr7E4Zt4nUELY62cGNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=aRfNsOxhtUKQvdSan7K+HibqJAidii2jHeqPMzyr3NU=;
 b=ImZfJlUtDVQvLhJ1hMI9g65D6n2xtsh9BGkDipBRr6w+SfB9yT/uVrHt2lJWpZUFh9BXnOlq1mIZ6iLoqOkYJt+NK0A3MpunNHrIpaRx8mMQHBPyxfiEValx3wriYel6KfrBoILhSU7vZgBModWi8ZvKmt9lAgI+4Kk2TF2gW1InYeqqDBh51DNIfxXJzwo/R3aw+M5vQ2aeSfHa9JvBty5RsTTP9yFMYbaO+y2vG/i2e/URkaVdN2Nr2aJe3RU225SV5zl3ranJt7w5JacUy+mzTjMqyJ9ZrAeTHG4ICDs5FFBBpe9FdvkbE+PrgBjV4lqQPuYPxhzbNBEalHE3TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRfNsOxhtUKQvdSan7K+HibqJAidii2jHeqPMzyr3NU=;
 b=RaCxo4dIN4GbMdQzkEicY5hODCC2+hqsrtn2N/yXZshBmLnWQYpGlyo3bACeCkdrzV5kvZxoe9Cvwfua0BI7CKdzNl9pTE+EKMtJYoIoc4mLF1r/KqgIK/SIqDxrqKmpj/8xc3GIA+Of/R3DLT5snljbXg4/93iUiuncTuQ0Uf0=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BYAPR21MB1623.namprd21.prod.outlook.com (2603:10b6:a02:c7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.2; Tue, 24 Aug
 2021 01:38:44 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::40bd:1fd1:f54b:e7b7]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::40bd:1fd1:f54b:e7b7%3]) with mapi id 15.20.4457.016; Tue, 24 Aug 2021
 01:38:44 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] mana: Add support for EQ sharing
Thread-Topic: [PATCH net-next] mana: Add support for EQ sharing
Thread-Index: AQHXlgQI4YpBkA2JjEWp71Mlpoc2l6t8+fEAgAF+CoCAA2q+gA==
Date:   Tue, 24 Aug 2021 01:38:44 +0000
Message-ID: <BYAPR21MB1270B8B3B70465B7B355EF86BFC59@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <1629492169-11749-1-git-send-email-haiyangz@microsoft.com>
 <BYAPR21MB12708078CCAD0B60EAA1508BBFC29@BYAPR21MB1270.namprd21.prod.outlook.com>
 <MN2PR21MB1295573318B3897A2039B094CAC29@MN2PR21MB1295.namprd21.prod.outlook.com>
In-Reply-To: <MN2PR21MB1295573318B3897A2039B094CAC29@MN2PR21MB1295.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=39af8494-2174-414d-b904-55e74a9fa146;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-20T22:30:32Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed606621-1a3c-4855-5384-08d9669fe8f0
x-ms-traffictypediagnostic: BYAPR21MB1623:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BYAPR21MB16230AC75ACE77884A414C2ABFC59@BYAPR21MB1623.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UlBLT9TUR8UAAfc9FySPlYkyEydlwQSULUEWGJKfRI5qkjRlctw4ZzNWoABfCFzfKPfjq100Av6NC6yL/dpDjyqzvLUAQWIESI15NFhGWAYkfKqyKJ53W/Mf9RG73jDETSrWhe5zEmdytqiKZzlGQB+0ye7K/nN0oqQNnROI7usVxjr340hJzGvyB0hAGys3QwfoLZDiA1mUMGKXUMdG+r+20UoGQQMkcZVVkuXg4Wycx6zNDNilI1piMGHZ51HEhS/19y6DXLv5A6tmhcPNe4/bQmG1MnCb5dbX/HsL1Dz5vRloidoEbVJV9rtA/AiBSnQ8sVGqYLV7BN4gMtlWgRjMrmSxYgH9JwARwmq3u1Q7rX0ks8bIWTztw0o+VVUWZauBisyXP+1IEGQx5BenFVIsP8S3wm4bu1Co8aGTokOFjfaF7mdn7HK0co0LFUchxYUbjXlZpP8Lc4iP6xh8/E8lHXaHVEl74zwypTT5JPZPwsPfaWn4XzhKtggO/cukLmu3G6hNU0x6ycdkfMUEa/3+wACjgbHG6BPxD5LB4NbE7+x/bVMxerjNHp5prpjiTBtgELfp1AlDQU0rLo/NZls/z9L+c3JWklMoMMDXVFKdltjTUgE2RfX+HR+mAenCj1IQHb28buejp2IiHZcHmY8H0WYy4+RPxSE4UQaiF26HjAMsIYXY8gG4APauP/9was8EDw+NHDdDW/e9D79lCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(8990500004)(38070700005)(8676002)(4326008)(66946007)(82950400001)(8936002)(82960400001)(122000001)(86362001)(33656002)(7696005)(66556008)(64756008)(6506007)(66476007)(83380400001)(38100700002)(10290500003)(54906003)(66446008)(110136005)(71200400001)(508600001)(55016002)(9686003)(316002)(26005)(186003)(76116006)(5660300002)(52536014)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RW1cc1JvsG4m9pyC/Cu7xBwkrw3ebEwOI5iOgriu9C3PhNSeGz5Irwc2j9Vv?=
 =?us-ascii?Q?WpWY96SFjQojEqD8EF5VgCMADQTJRqN0FdWOAmVzopZEjgdwknfXyBsYO2KY?=
 =?us-ascii?Q?Ai6Wj560OsP7N4/AvGV07xxB3FcN3AKhZzANZQZFFG/r3kggBqcHOppmdCua?=
 =?us-ascii?Q?3+SnnkWt5ONd6cVGffAsDf+GBUZBfQ1UwPpNMQgZHRbVZUkRFCwPAHwC6Crg?=
 =?us-ascii?Q?LLlt3dELD5bQF5QCZmoojFmo/DEfRRB83xNZiWr3Gos9fJr52sT8af+eRMZO?=
 =?us-ascii?Q?Cn1Y4/Rgeu4naaK0ldWMm10uT7CfC1TLgZB1+845wa8TRLe2A70F2f810TlS?=
 =?us-ascii?Q?v8Wz0ckK1ytLsfJPFYlR17a6cdbjccYNDcgPmgM5zcykzOZQI1aeR+vu9C1d?=
 =?us-ascii?Q?zjXOQup2JniL2RC/OkfTNUjNDnT5GzJp3jdIHjQ6vh8oNESJ+lIphnwVj5j7?=
 =?us-ascii?Q?I9YyvHS6gZ5zV+QQlGYLgFMnKnaW6oD3KM4Zw6DdQ9k8itcxaRV8fDTTXtFN?=
 =?us-ascii?Q?1ZsRalYjOBFL1n/389l9xm9FXo7XU1Tay4NMaAkblfiKkCkUYsS/BD+KEn6E?=
 =?us-ascii?Q?nt5gPzd2OFMlJ2CI4MrES+C89um+rjihXgJOsNKc8TztbFm314GYSui1WF2o?=
 =?us-ascii?Q?9tW8dqdGxNFIDThP8rT6DrTHlNDLFAO/KeI8Cbi+tXD9bFiAhdD1FGSQqEva?=
 =?us-ascii?Q?FOipmZQzDaBttNGeTmeo6+993+aDL3Iz+GRbEJNzOd+zVZ5DnncWopvHLytF?=
 =?us-ascii?Q?KLXbKZJ6rqfO/VADoxDNVrfjmzMtU5lyHkTRQYVCez6SHyztXY/VohWma6yQ?=
 =?us-ascii?Q?Y1LBNLRJWnodSNvTk2F7O2+bOs3qreYwxQlSeAHqJB9Z15IlQp9NUli0Rc3M?=
 =?us-ascii?Q?xK7xXEt/s5E84pkfzMc/6wehRXPST8t0pxwk3DlNl3Nf0Y5iN27/pnUy53/u?=
 =?us-ascii?Q?jcBkdVW1KJ90SKfgtW32qUo2U9Yo9Cw+HQ7eQm2wLFeeyJvO6S2AFUN7UuP9?=
 =?us-ascii?Q?jAF1MVF3bOnx1cmK7eUf1L10jJbsvh4yOreyrjRP2SaZslfenZzDJEOlkKhw?=
 =?us-ascii?Q?iSlbd28pFZnpoqaEorT8ALG2yBVn2T0GeJ3fHppFcJ6AwqGImQ0tgYcSKYlF?=
 =?us-ascii?Q?JnM9R79XxXqfZHjl1jYAUukykCcKbpjtkRI1l9ws9WqlHwJl9M9quOlz5r26?=
 =?us-ascii?Q?rO0yj2EuyXt4182JX3eriiRJ1Wezn26UfUF/SNCH6LdxWfVsvwk8jQFcus8s?=
 =?us-ascii?Q?2i2ixsfI7QLyqhZa2SurKHa+ATcKpglw3xQNokmorm2dRYX27HAuSAL69RHi?=
 =?us-ascii?Q?RolMUY+mQsNEVuh3S9rJyCt2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed606621-1a3c-4855-5384-08d9669fe8f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2021 01:38:44.1894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LLMG3qA6eh2ozSYrdbl2v7xf7jBzGV2HbMfmeAuBYTpUFvhgJDTPtLpP2jSrMR8pWhBLsEL/cUCAOWNF1KOofA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1623
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Haiyang Zhang <haiyangz@microsoft.com>
> Sent: Saturday, August 21, 2021 2:18 PM
> To: Dexuan Cui <decui@microsoft.com>; linux-hyperv@vger.kernel.org;
> >
> > 4) support up to 64 queues per net interface (it was 16). It looks like
> > the default number of queues is also 64 if the VM has >=3D64 CPUs? --
> > should we add a new field apc->default_queues and limit it to 16 or 32?
> > We'd like to make sure typically the best performance can be achieved
> > with the default number of queues.
> I found on a 40 cpu VM, the mana_query_vport_cfg() returns max_txq:32,
> max_rxq:32, so I didn't further reduce the number (32) from PF.
>=20
> That's also the opinion from the host team -- if they upgrade the NIC
> HW in the future, they can adjust the setting from PF side without
> requiring VF driver change.

Ah, I forgot this. Thanks for the explanation! =20

> > 5) If the VM has >=3D64 CPUs, with the patch we create 1 HWC EQ and 64 =
NIC
> > EQs, and IMO the creation of the last NIC EQ fails since now the host P=
F
> > driver allows only 64 MSI-X interrupts? If this is the case, I think
> > mana_probe() -> mana_create_eq() fails and no net interface will be
> > created. It looks like we should create up to 63 NIC EQs in this case,
> > and make sure we don't create too many SQs/RQs accordingly.
> >
> > At the end of mana_gd_query_max_resources(), should we add something
> > like:
> > 	if (gc->max_num_queues >=3D gc->num_msix_usable -1)
> > 		gc->max_num_queues =3D gc->num_msix_usable -1;
> As said, the PF allows 32 queues, and 64 MSI-X interrupts for now.
> The PF should increase the MSI-X limit if the #queues is increased to
> 64+.

Makes sense. My description was a false alarm.
=20
> But for robustness, I like your idea that add a check in VF like above.

Thanks!

