Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E39518218
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 12:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbiECKOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 06:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbiECKOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 06:14:40 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2057.outbound.protection.outlook.com [40.107.96.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C10369C6
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 03:11:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tb6owiRqGUjQ0FRbh0T6EVHPYBy7xuCNflSpAkxfRJeYzJm0bR+p9ZQm5R6hN27WsCsPQZIiS2+BtWwI/J+1F6I5vJ4MNKvhjpwPM447E4FlT4nxBsU7BjjRbofKqcxH8dme/cN7sUL9sDd+LivLIx66KXvCnv7VBsOtNuUeyd+9XUPnzwiakLsuLHPuhNFrFt5RDACeAF26hUKt0g2zPHWyJXn5xxM7wx19/w892oSnoBCmuxfR8iF6ZxvbhRO8mg1AgWty3iauc74P2wV6WNW48LtlKaAHSfJggHRRZlJbM1O/WXwRyoSmKIffF27HgJJUkPvfutyH5iF08DStvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3M8ZilZDdRh7N4Irgo/jUyma3aIbbhPkGXhR7ChM8dQ=;
 b=esI+TcPO1wnpzhf76w6hKdSxZkV5na43BwY9KHkRQXpnuNTl3BvnqBANP61J6v1/fpFUvce5YEhwtOXeSTNcr3MDvQNCH7SLN2e13ozhki3L44N7gdwyHQ0VTXxxtPnIIZ2G+PSLXGp2oquNTm/Hb7AzV/koElXpM7MH/5XpiEdkqceX419AG65ySTKem3Ldfhu45SNzFqm5+pQ8AKLRp0bVd84/hkmd7EsQbIuznvEAzn0pgkizLK752EejbzGL/AiOacUOGbvLxOSkYS4NxOctmUXUfZSETYslTQQFlQ1yNoFnkMcnOhpE3E8QW/z8BikqcPqtwZL3dgaRzDUSgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3M8ZilZDdRh7N4Irgo/jUyma3aIbbhPkGXhR7ChM8dQ=;
 b=XT407zNKhVHN6mNg7o4CqMT9XHkddH7mehKAaKiEtBusEphW4GC400M1lVh5DwNqAJpYzB9hfXnwXnrs+vDx8cK5qA0XpANXWWDVATcUXGC7pIg3V1BF6+uMhzitGSvSSRUmGS9JZX59nYNVBVhOKxlI43Hjpb9mW8ZdeykNHzwm6MGo5+Ynw3VdSl9TB1/A1j0sQYOcJdFj40SX45DPAKxj45YAbasGbGIp1jgJOMKbRK1Nk/EOUn9NmowMnjdU4O9YG5lZat1q4fTGc6I4uoxzY5m92Gf7QT4bJuMxVnmsvt5Igq9t/Qr4yHBMPou5yplIkyHUQ9CVCXmj7j1bpQ==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 CH2PR12MB4921.namprd12.prod.outlook.com (2603:10b6:610:62::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.24; Tue, 3 May 2022 10:11:04 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::ec12:70ec:e591:ab6]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::ec12:70ec:e591:ab6%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 10:11:04 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     virtualization <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: utilizing multi queues of a net device
Thread-Topic: utilizing multi queues of a net device
Thread-Index: Adhd2w/i6AOjpZwuS9ujOEf6zHoz5wAZaCkAACVUm0A=
Date:   Tue, 3 May 2022 10:11:04 +0000
Message-ID: <DM8PR12MB540039DD483251A8D551A02AABC09@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <DM8PR12MB5400B7E41EB88FF4C9E0F87AABC19@DM8PR12MB5400.namprd12.prod.outlook.com>
 <20220502092134.160f43b3@kernel.org>
In-Reply-To: <20220502092134.160f43b3@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71aaa893-80fe-4f7e-dd82-08da2ced3baa
x-ms-traffictypediagnostic: CH2PR12MB4921:EE_
x-microsoft-antispam-prvs: <CH2PR12MB4921DC4DA0D0FC4A8433FE1DABC09@CH2PR12MB4921.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ygubGNGdl7beNy4wubJ7x4LnHpg+hCvXvqbdM0r1MRzkv7xY4KCc6slfs8Shs3cD0OmogE/CiHVk4qHXGX8ucjl5FRCb7jZAImco+tqRY0EIsIqx8hScAxsxrCCsMi8TGz5iTZQU73xTTyhcQ4+bcXh8BwTPX2QeYeZwdUic0Dpkk5gjOKiqmtT0887spNWuzzV4QbdtqhbC+bM9/mQLGYs5M9absrYU5LUgBI3Uv9z5V+eSxTsXr5siRQ3Uz89rPYKSlpTWPTr+zBagQ0rvODyVpsXj84xKv453D26YLvQgCi22IwL2b0b0Bxo5RkYxTmyRUiETeTtF46/maRfQuM3aS/EljL0jYEmn46+V2xByuY4siyBFhyTjO1kVtIIqP7oZW4BEMFnNtPlOsmQXv6uvXrnSBcY1l6/DjCRiw0Wk+KGTb0LN6tVhNqmx9qwA85OWBAJarq5DHkbpcsk8f+T5uHoL10F1aYFqjaLIcUqE9szEoKMFwBD7BVXzo37QSBLxqZf09hZ4HcwQ4Vbi3gW8a7jCN6KXtr9yXDnzAvk8R42y5XMxfsVOgz1vkUQcZFr1XO0nR7AGM7KHAVyLIY6uwOkPyrYrby2HIf5Xu23vYGQKVVlJxDZ+ihRupVARZsAO6WxynjOsjG7azRAgw3tkriIT+5khWSTHBjA7t3A0RRGWTspQ7WYmK5PxyoIcs/0FrkSr90m0Fr5ESP6vWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(64756008)(66946007)(66556008)(66476007)(66446008)(33656002)(83380400001)(4326008)(76116006)(8676002)(6916009)(54906003)(186003)(316002)(2906002)(9686003)(26005)(55016003)(86362001)(6506007)(53546011)(71200400001)(5660300002)(7696005)(122000001)(38100700002)(508600001)(38070700005)(52536014)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CI0r5Yfe8KQUNAnldKL4/gqggHhFUyW3Ql1xT1GkhkoftnO05z5XwLqxc0wd?=
 =?us-ascii?Q?YG03j57LSN3bCAYU/gvd7LKblXImyrpHz08TCOCy31OJ9FkcQrxv66FMuULO?=
 =?us-ascii?Q?Evdhs+BpEBPRznXAqsaNVI/grhlwkmJ1hXnod1ByvYCvF67U43zhsf9xsrcw?=
 =?us-ascii?Q?n7H/TNOt60HEI0XhQ1jH/FJUrxiuT46o3ybr6p9wdAs3Nxvt6YDoM+q5vaY/?=
 =?us-ascii?Q?HWKIcLVhyD1eboUibeZDeFZaIni+Bw91DNe/5zAqE6EeHDwddiuDj9KCF5Fu?=
 =?us-ascii?Q?2ShwRDJGVY5Z2UEljevZ6xaF85N+enN04ji4JE9pBPWgyG1BdzM0UtcG3hRE?=
 =?us-ascii?Q?cxxUcSnWdmRk5aykm5dwQQxMsmdXI63/hpFF0MYhahwR8J0fF9mhfdPANsSm?=
 =?us-ascii?Q?JdRibI5rCSIx9cdNraqyyDoNDWtAI8B5+0fJU6o3BcZRN4Edeg63PQhp0MQo?=
 =?us-ascii?Q?H3DWyqGbCmVuF8cMV2hF41LJokM9728FiHtc1u9AyksxXCD/0cJ+/JqRQeU8?=
 =?us-ascii?Q?ld1DbbtCPRslty2f2VMSUaEavyvH3H6cDoh+GEbpfo4G54dz+KujGrZDRkqc?=
 =?us-ascii?Q?/GrzQGcETsGikCxiJoCbb9sKoo/CXmCGglK1gj3CaL2IxotSSg7YuEn/33oK?=
 =?us-ascii?Q?DAP/2z5cT6x1mqjDXyPMO7M4IraVIALtO+M5CHiwHiJFNTuTjj2AapGXtsnd?=
 =?us-ascii?Q?tHOLrfhCV3RfjfqJRDaft0rbLwyDwIOFodEfLzncwP93yHpPtTabkgptI4Ze?=
 =?us-ascii?Q?XtXp1HTR12TcM4xSjbBa1WAT+1BkTf1ZXPfE3hz4yuULqGdiaJ9lG80UvXon?=
 =?us-ascii?Q?4uperr6GadzOyInOAXhzmc+0sCxVkBOW8+Af7/U6KSGtMxi2LsO3K8bs6RdE?=
 =?us-ascii?Q?7bQ3W2q0HYopQHbUtK7SJVtXJ7S3pqlW+nBvouyCrOp3Cd4W+892cGhXw2G5?=
 =?us-ascii?Q?MewY78+iSEY8hiLuxlcGhQTdfRjp+yoxysxiHSITAkNfsmrIadwLWC35Z6Ez?=
 =?us-ascii?Q?bueBQmaV+1rtSUrNzvPykgw6Jx1p26irp1gI65mZMQBuI3kLgTAb9xNLJeC8?=
 =?us-ascii?Q?bV4zmdMs+AWkvHxVaVF3mo0LIGm/YPAUWufxGQ5afNSnoEwy7mt/0dakRXE3?=
 =?us-ascii?Q?+XRVc361nA7u6c2CDw0Or5Vp9Ph8myGBYChtqbY2W/QI3aMDqb6MXbqPAtrX?=
 =?us-ascii?Q?F0bXs07z/Sxg6JMpTnMPzMzKYFjw1hZWa0mVTJIOdcx8lP3qX3UmvufZzp3b?=
 =?us-ascii?Q?/+egH54VQyJvSB6PEFuosY0/WA7GqPWwsM7rVvEf3E5Rp1mobh09uPCL7S1+?=
 =?us-ascii?Q?kn9u5SZxLqM50O5o4JmReY4t9PSsNTlb2RJaZnQBG/Q58spv8kjLmwlLv9mT?=
 =?us-ascii?Q?7+UprNAEOyWCCm6lIbcfM67/hxPn0IiTQU+shXaSMg0dwyfw/yRxw5OypFFS?=
 =?us-ascii?Q?4PYSZfZF33RaNZKjDu4VybOGccqntv1vysQLNbjsZtJXcs3Ffcz4BE9Itjzy?=
 =?us-ascii?Q?+Fn/yS8WguevAgfPTODRbQVSleRb2xbXWgmST2FLzN+5EQ7sPs8lNAoXAs4/?=
 =?us-ascii?Q?lFlTa945elHfoCOR9JHY20FwaJN55m6G4qc/HHnxwoypTTICdp8VbylZzjwj?=
 =?us-ascii?Q?IWTv3876M+TJ7qeYdTZFI5/VTWKpSVlTrRz7ADZWTwj6xqB7LltOG0eBrtNC?=
 =?us-ascii?Q?VxgtQFaE4Rh5CfaVvTRu5RVpa07wZU0Eg3uSmvlBBL4XSRlu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71aaa893-80fe-4f7e-dd82-08da2ced3baa
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 10:11:04.5646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p2UOzQA0hoYUgfy4gQ9zxMT+CeUVWvmPRpWMROosmkDkTGZPQlnO/O1Ie59m4t3F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4921
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, May 2, 2022 7:22 PM
> To: Eli Cohen <elic@nvidia.com>
> Cc: virtualization <virtualization@lists.linux-foundation.org>; netdev@vg=
er.kernel.org
> Subject: Re: utilizing multi queues of a net device
>=20
> On Mon, 2 May 2022 04:29:09 +0000 Eli Cohen wrote:
> > Hi all,
> >
> > I am experimenting with virtio net device running on a host. The net de=
vice has
> > multiple queues and I am trying to measure the throughput while utilizi=
ng all
> > the queues simultaneously. I am running iperf3 like this:
> >
> > taskset 0x1 iperf3 -c 7.7.7.24 -p 20000 & \
> > taskset 0x2 iperf3 -c 7.7.7.24 -p 20001 & \
> > ...
> > taskset 0x80 iperf3 -c 7.7.7.24 -p 20007
> >
> > Server instances with matching ports exist.
> >
> > I was expecting traffic to be distributed over the available send queue=
s but
> > the vast majority goes to a single queue. I do see a few packets going =
to other
> > queues.
> >
> > Here's what tc qdisc shows:
> >
> > tc qdisc show dev eth1
> > qdisc mq 0: root
> > qdisc fq_codel 0: parent :8 limit 10240p flows 1024 quantum 1514 target=
 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :7 limit 10240p flows 1024 quantum 1514 target=
 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :6 limit 10240p flows 1024 quantum 1514 target=
 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :5 limit 10240p flows 1024 quantum 1514 target=
 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :4 limit 10240p flows 1024 quantum 1514 target=
 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :3 limit 10240p flows 1024 quantum 1514 target=
 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :2 limit 10240p flows 1024 quantum 1514 target=
 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :1 limit 10240p flows 1024 quantum 1514 target=
 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >
> > Any idea?
>=20
> Make sure XPS is configured correctly. Looks like virtio_net cooked
> a less-than-prevalent-for-networking way of distributing CPUs.

That make the trick.
Thanks!
