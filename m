Return-Path: <netdev+bounces-10967-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 27DB7730DC5
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 05:55:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58CF41C20DDC
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 03:55:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B29A4639;
	Thu, 15 Jun 2023 03:55:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B6E625
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 03:55:48 +0000 (UTC)
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020023.outbound.protection.outlook.com [52.101.61.23])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724E22133;
	Wed, 14 Jun 2023 20:55:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4nDQLXtBrHKjc50hMe7hGXLLJTrPn//qLKoWrQNZZwpwg3qAZya7R7ccA4h0FMXS+Q9fUk5BUnRR16x88AXOJdrfAS5zTDGKRGvCpl+1SgWnva6Yn4h7VQQEtBXNUkRyqAY3FofQuHhQJWYkxiJ0lzgbBE9yUf/XbRHL+f5v2ErKT8FQ/VrwMYi0Pe+RLCUO2PX/qhZyUQWmf1b9yA2SnxwV58mQuQMA44eHaK1m00hKJctfkqfafeWMuiT6gYfVWXI/nTZZ7g6sCyYwk55gpkfYhzfs86QXBGhbDKA364t8Ikqf9czyLlx3ddTBEZJxW48vCMuHVXMUBX7mTXckQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrichSzLPYq+YUu82LbzmuirLDiaXyTwDNkCwoFSZLE=;
 b=hB7lY8LiD981vVcLYGJlr2YYd45UF4YoDZ6pFWqUk9vWpKLe46HHxNgUT5tMr5WekA3xpAWBtMpiJ9OD/nK99lUzwT5MoWaOd+YLR9IHyOCJ8co51er8svxCkN7TLE8v/Z69CMUdPj7QT2fX4HG7NLSMZ/kI4SFXyE7Bn7MhInu22BjuKaWtof6cG9Bxcd7cQeK0PAo4sv2iLS8Gcy95IjKahmUcKD9HHRR9EF9cz8txRIgAGRpTlkRGmA9qyRRq5Dhl9VZg8Di1cKuChBa8W+TOmJq0874BiIA+kd7HohEzIcyik96PjcKjMdqBM9LkfczjuOkD4mw9n4T8p36SxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JrichSzLPYq+YUu82LbzmuirLDiaXyTwDNkCwoFSZLE=;
 b=h4EAyzrSBD7xOhmE353to6aQb2m+sMRnhuHD4CJ70eRZUETlyY4WfzaCEjWaExLR9k9KpC/ZMeo2W00eK2qjOQSC54ryNvaoq7fLBub3ZEmAh3Txm5efU8jOdqLXgFdAVPvWskFm9lONFSApIUusmxv2xL2+XeOgEXcBPhhJNDA=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by PH7PR21MB3260.namprd21.prod.outlook.com (2603:10b6:510:1d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.6; Thu, 15 Jun
 2023 03:55:43 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::bb03:96fc:3397:6022]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::bb03:96fc:3397:6022%4]) with mapi id 15.20.6521.009; Thu, 15 Jun 2023
 03:55:43 +0000
From: Dexuan Cui <decui@microsoft.com>
To: Lorenzo Pieralisi <lpieralisi@kernel.org>
CC: "bhelgaas@google.com" <bhelgaas@google.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>, Haiyang
 Zhang <haiyangz@microsoft.com>, Jake Oshins <jakeo@microsoft.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "kw@linux.com" <kw@linux.com>, KY
 Srinivasan <kys@microsoft.com>, "leon@kernel.org" <leon@kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Michael Kelley
 (LINUX)" <mikelley@microsoft.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"robh@kernel.org" <robh@kernel.org>, "saeedm@nvidia.com" <saeedm@nvidia.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>, Long Li <longli@microsoft.com>,
	"boqun.feng@gmail.com" <boqun.feng@gmail.com>, Saurabh Singh Sengar
	<ssengar@microsoft.com>, "helgaas@kernel.org" <helgaas@kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Jose Teuttli Carranco
	<josete@microsoft.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 1/6] PCI: hv: Fix a race condition bug in
 hv_pci_query_relations()
Thread-Topic: [PATCH v3 1/6] PCI: hv: Fix a race condition bug in
 hv_pci_query_relations()
Thread-Index: AQHZjuDp3/HWlZZHlUKokFlSLFMUD6+LWp4Q
Date: Thu, 15 Jun 2023 03:55:43 +0000
Message-ID:
 <SA1PR21MB133577C1859A3B1DCE1ACAA5BF5BA@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230420024037.5921-1-decui@microsoft.com>
 <20230420024037.5921-2-decui@microsoft.com> <ZG8YzuK/5+8iE8He@lpieralisi>
In-Reply-To: <ZG8YzuK/5+8iE8He@lpieralisi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f554af38-df63-4f69-b441-4d0e85cb67dc;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-15T03:48:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|PH7PR21MB3260:EE_
x-ms-office365-filtering-correlation-id: 25e9e427-70a1-47fc-b3d2-08db6d546454
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 4kkL3w+St+5wcM5U24X4JfOGqVnN2aZU0/TaGfawHY11PNTWrY3LeufcNx5fhk6Q9mGYx6miT107lZfvm8FJNfDKEnYQH5mjXTFoat5oUUv6zN8KbwLjs8dePylUhsyMoOHEghaLJl4ROVcJbPyWECZ4OqxwxwaBC9dLFWxsvPAQYPdfoRRNFqUvDozQPYH0dnYX4lIK/mLo8oM5sECiNdZiJMN9alHvohc/8qz9i+jmKM0pBRXhqnv0DYYtx8IObvgzN716tf/WoRbwm1KLAFTEOLwh/4SzhiZdEeEUO7dl6CZWpP7SWt5e9kXEt32OyCGNhd47jcCLnG4ixVql6gw5uo4ODe2ucTnF8Ql40ed4OTM6oP7Rex8Z/RADAeaVJBTiO/4iTC3F3kSlX2ls0yqz5DwFim3K3GxZtKReVpZnaL31B1n/VYEW0ckVe/ksL3rT+cYAMghCYnEACb5pn7oWpz+NCi1n6FWtiNlZmN78/D/Jith+4otkIVgrNizDHNM6DatWhcAECSXcRyJuWRiSJZ4fMBAm5UalHLQMJlo1ubMdoNtUlbAJh0tW1L2+S++/7+C6CyEsetcq8OePahJD7c+Z3OUIbMa5+ibjfEUv+ZwKDhG6Usel7tYDQ9Ql/qw1aT9QM6bL16VjJiZcLAfc597ZOLdEHyEfMo8Niuo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199021)(86362001)(38070700005)(8990500004)(33656002)(7416002)(2906002)(66899021)(55016003)(38100700002)(7696005)(186003)(83380400001)(52536014)(53546011)(9686003)(6506007)(82960400001)(82950400001)(71200400001)(54906003)(122000001)(5660300002)(66476007)(10290500003)(76116006)(316002)(66556008)(6916009)(4326008)(478600001)(64756008)(66946007)(8676002)(41300700001)(66446008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?y08mJpOX6Psi9+Nor0+EqM6W+feECnp/F1qXOrEUuDzAZmhyj5O/otfqgEkD?=
 =?us-ascii?Q?d72ee/0D6zGqZ8sFr06CcDFUKg8qyhc5G1Q/ym30JxIe7JDkB1uAe3kN90Fe?=
 =?us-ascii?Q?T6bFOIu1OPqHBhF4paHJa8ssCXEHALHAHSQfaevAQVtMyFI6NOzI/LXyEi3s?=
 =?us-ascii?Q?t6TnHqVA2yp8tUfydfLkx3UCZD+4Ws7mFGoV0sJn9E8802bZfGY6aqk0lYIV?=
 =?us-ascii?Q?AsD9n6CvrU9biXrUUQf7Jh247GYXICbFZrQyIh3wWU3CNKy2ouH01ofRw3oQ?=
 =?us-ascii?Q?jbDZtVfVVGGzVTELQrTno97nZFPMpLSjEzCQ15uO5+GRne2n1Xb4ieoR/zqY?=
 =?us-ascii?Q?IeDn2/fz/6N8CB9R7w4KNcBGoDseh80PBtne7IC9mRLfLi/z/Jd9RspZnRER?=
 =?us-ascii?Q?mTWs+8vD+qoEZvQJVExrv8N3zUaL6sQZtPpooZF1vbfH5j66pvBEsBJwgXwF?=
 =?us-ascii?Q?QlamJXaf/DPOWW0rPMrGzkY19BNV2gDY+fkeGiSpnLBPOVvEuAf/uT/ZKBe3?=
 =?us-ascii?Q?Jo6yohdPg1TIdiiglnyJUcDwhkanaTybNbmdFvhsaQtPKkvxYtQJs0d5mr7g?=
 =?us-ascii?Q?ZdrnyBfoL91yc5NkWlyqw+FvA+ixQBuv/Ya7LZWWrAOukSCMfLeAVmeXEAld?=
 =?us-ascii?Q?jvikpDCxacDpEiSjVVp/f/JFB9cDbOMTQW0DOpdPx5B3b81TY7+qaBl4Zn7j?=
 =?us-ascii?Q?1Shvv7GDkn/lELFIF+Hirawozf/AFKUpvM1NkXAdqc8kyFSb+ZJPYmkuKFwQ?=
 =?us-ascii?Q?6zAlMYLM0Um7/cw8m4ETChjqK4vB7tLMbvwAHbjxm8KN9e2z3pz1sTEBbclf?=
 =?us-ascii?Q?y8B8mPiYNibbSlqUFCPTCmmOUWjpBwC3lXemkxe/57xQwQrRGg+VYyauwzzU?=
 =?us-ascii?Q?QRtYvBcuZzpvhCXjh46oBm2neWXLautBDJ1ISEbzxRyL+0fUS06Qgv910zAG?=
 =?us-ascii?Q?AlHkVuYKYyMLmy6yyWe4b0Wn4b2q4vDQ/42LbR7lYbVitSlKNpDTTHUnpc4q?=
 =?us-ascii?Q?tC4veBlcA79HuFh9jBDherL/ewyYDD3ZFCLbgRi+tTO8FGOdhZZBWC24hntg?=
 =?us-ascii?Q?POlIDOVmWVNz3I+bAsS7xYwKiUqdaVSq0iqZHuh78WWHfgzBd3yNF+FKemaf?=
 =?us-ascii?Q?inC5IZfqDFh5RqCxcATc2JCys8aLAWMw45j+OFf2Dy/RSduW/caH41lHQElD?=
 =?us-ascii?Q?o9owJ4VYEdGbzKbfFQr4oQK3ZhKjPnag+70Sl9QRHQKKmpBUlbiLsI7zsKtx?=
 =?us-ascii?Q?i7Pe/fLAgCxgQG6GvBNE0syqQco7O0j8vnNIpC5gmL/lH1nPF4aDkM/4Z2Ox?=
 =?us-ascii?Q?Lt2fe+cESCGXTfK65/WgnCY9AUig6CL4W+n2PGykxo+1AGDHvtzMFDrWjmJV?=
 =?us-ascii?Q?s2DbRnCzeYanyjrF0X+fCnMaYJgOOs3hrsFXBknXiuJAucAyXCaIqFwnR00u?=
 =?us-ascii?Q?0dveFmgMVDP2B4SzJhx9LIATD+iNe3QjwknEWvyjR1vRFZwM3J/pagyJD9XW?=
 =?us-ascii?Q?Ij0c2xoTK9xQ8mVI5vif/hhSzzmnc5Q7eh9P+tvU5+RUbSYu7Uox+qXKpcFw?=
 =?us-ascii?Q?Sj0tyjI3M6vlj539/0JC8fBEGOhnHgqzxhG8BJO11NbUVapYzjNKVIbpf2VM?=
 =?us-ascii?Q?N86YFKePOGuhTzFT5wFnlRE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e9e427-70a1-47fc-b3d2-08db6d546454
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 03:55:43.0614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oQl98l7LPcQ39ZI6GSxjpYf8I0cm4BhUCl78GqJmKN03SrMtKvAa/WmFhfIxiurUypjYUy4wQuNuJx+xp96Rng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3260
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Lorenzo Pieralisi <lpieralisi@kernel.org>
> Sent: Thursday, May 25, 2023 1:14 AM
> To: Dexuan Cui <decui@microsoft.com>
>=20
> On Wed, Apr 19, 2023 at 07:40:32PM -0700, Dexuan Cui wrote:
> > Fix the longstanding race between hv_pci_query_relations() and
> > survey_child_resources() by flushing the workqueue before we exit from
> > hv_pci_query_relations().
>=20
> "Fix the longstanding race" is vague. Please describe the race
> succinctly at least to give an idea of what the problem is.
Hi Lozenzo, I'm sorry for the late response -- finally I'm back on the patc=
hset...

I'll use the below commit message in v4:
=20
 Since day 1 of the driver, there has been a race between
 hv_pci_query_relations() and survey_child_resources(): during fast
 device hotplug, hv_pci_query_relations() may error out due to
 device-remove and the stack variable 'comp' is no longer valid;
 however, pci_devices_present_work() -> survey_child_resources() ->
 complete() may be running on another CPU and accessing the no-longer-valid
 'comp'. Fix the race by flushing the workqueue before we exit from
 hv_pci_query_relations().

I'll also update the comment to share more details of the race:

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3401,6 +3401,24 @@ static int hv_pci_query_relations(struct hv_device *=
hdev)
        if (!ret)
                ret =3D wait_for_response(hdev, &comp);

+       /*
+        * In the case of fast device addition/removal, it's possible that
+        * vmbus_sendpacket() or wait_for_response() returns -ENODEV but we
+        * already got a PCI_BUS_RELATIONS* message from the host and the
+        * channel callback already scheduled a work to hbus->wq, which can=
 be
+        * running pci_devices_present_work() -> survey_child_resources() -=
>
+        * complete(&hbus->survey_event), even after hv_pci_query_relations=
()
+        * exits and the stack variable 'comp' is no longer valid; as a res=
ult,
+        * a hang or a page fault may happen when the complete() calls
+        * raw_spin_lock_irqsave(). Flush hbus->wq before we exit from
+        * hv_pci_query_relations() to avoid the issues. Note: if 'ret' is
+        * -ENODEV, there can't be any more work item scheduled to hbus->wq
+        * after the flush_workqueue(): see vmbus_onoffer_rescind() ->
+        * vmbus_reset_channel_cb(), vmbus_rescind_cleanup() ->
+        * channel->rescind =3D true.
+        */
+       flush_workqueue(hbus->wq);
+
        return ret;
 }

> > +	 * In the case of fast device addition/removal, it's possible that
> > +	 * vmbus_sendpacket() or wait_for_response() returns -ENODEV but we
> > +	 * already got a PCI_BUS_RELATIONS* message from the host and the
> > +	 * channel callback already scheduled a work to hbus->wq, which can
> >  be
> > +	 * running survey_child_resources() -> complete(&hbus->survey_event),
> > +	 * even after hv_pci_query_relations() exits and the stack variable
> > +	 * 'comp' is no longer valid. This can cause a strange hang issue
>=20
> "A strange hang" sounds like we don't understand what's happening, it
> does not feel like it is a solid understanding of the issue.
>=20
> I would remove it - given that you already explain that comp is no
> longer valid - that is already a bug that needs fixing.
I share more details in the comment (see the above).
=20
> Acked-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Thanks!

