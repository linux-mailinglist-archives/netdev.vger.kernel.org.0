Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30732595971
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbiHPLIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbiHPLIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:08:16 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABB9F5A0;
        Tue, 16 Aug 2022 03:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660646136; x=1692182136;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=koB2q+FAdgFuFrunXG66bbY2MOJBXt9IuQx+eyyl5jE=;
  b=T0CkukVQsU6F2sWYkS0OY8Cy43nkvqEV0FVaQ/XmvAus2qNOm6fn5ahH
   uCOVjw/Mr2CQ/vXeLRZ+9blG7iFoRLkk4sdCex1gVuIxTLxOr1q0+EVKs
   tVXlf8EydoKkdcBG+34I5P+YB1q/SnwUBuNSPU7nevY0s+uJL5q6K6Na9
   ZXwqkJaNaKzY0HG+3u1mpgDNTm8m6Ooag/XvGuXQUsGFoX2JAUPjuXkBQ
   oZmWI9WfBqQlrH1FAENVD9rOds8QeClttHNH2wsHPZaLXaH+JXYp+ssLX
   vgQSfI+QVdODASJXSs1wO+jcni+8Ju9KqJ5RFUL/BpIbby5wrgK+ugbZh
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="353926880"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="353926880"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 03:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="782977277"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 16 Aug 2022 03:35:13 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 16 Aug 2022 03:35:12 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 16 Aug 2022 03:35:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 16 Aug 2022 03:35:12 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 16 Aug 2022 03:35:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnRbhS5c+nsidjfeUejCqaj0ymjABYLS8i5qN3lcCmuxs2cXb0M7wQj4HV+opeE0rk7kZfY2CUjlnNahYo2QGFq4I+gaHDu5OcTjTzbu4CiLMd/ZGlHU43Y2wSb3CwC322dNqxa6Vm00FRHss9UTy5jULe0XYaX/r4tl7UilKDyp3UuvYMQ3rT6PPIu4uwqz6HYJBWxEv+98EmwrNKxN01adDV6y7hNbyWxPsU5u7sMJuhhZ8ZsERgjVL2nGVPrWrHNTqlxMKSDuKEKHjbpvkDqIl1oOJu3t+2ZfHrlI1vnAFi0Ix1xBBd/IbR+F4o00GH+ManhqMhunpv1n8JZMCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=py73irwEso+pNJt2I5jcj0yCrNSAO81+sQdGfPTTx/s=;
 b=Rw+c5+3c1d2TP6VEYpi6jqxrXN0v7DMCV0Nw2jRam0QbxcQbE+e2GAYtgIpKRI5WlyNHr0DeZmiX2JD2Br73y1NRGY2iQK0n9GELdvKeUnIFB5vziG9/R3LaqxTdymlRv9Z9sLPRHZtIPY785wUghzsftqwyerRR8LEbun+iNnF7mpCrpp6u1jN90PFL7ckxsasM2XeMQ3XD1rhKwt8eaqygrSi4xyM1nTjGZrJzcJsC77p4xoD3QI8i+nfzBz35eDEV2zZazydiUh3CKJiZSwblzU3wrwdKc2Bp1gAK9fN/QWhLDGeORzmqSR3BjmjVT5mo1MAKfgkQKz1Q0mx62w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 BN9PR11MB5545.namprd11.prod.outlook.com (2603:10b6:408:102::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 10:35:05 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::d45a:9b13:46a1:8a35]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::d45a:9b13:46a1:8a35%8]) with mapi id 15.20.5504.028; Tue, 16 Aug 2022
 10:35:05 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Lin Ma <linma@zju.edu.cn>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH v3] igb: Add lock to avoid data race
Thread-Topic: [Intel-wired-lan] [PATCH v3] igb: Add lock to avoid data race
Thread-Index: AQHYq8LJ/nnQsBEYNUqoCgAWEQWOLa2xX9pg
Date:   Tue, 16 Aug 2022 10:35:05 +0000
Message-ID: <DM8PR11MB5621A0C7FD7E20ABE4187137AB6B9@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20220809073542.3390-1-linma@zju.edu.cn>
In-Reply-To: <20220809073542.3390-1-linma@zju.edu.cn>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 845c022c-64dc-4aa7-38fa-08da7f72fbb9
x-ms-traffictypediagnostic: BN9PR11MB5545:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ij09asE0+XroMDXzU3ZOZJdjGbDZpCiqpIMDbpS5tmGobZ9goLe35I2WcIXWePN0W0t9XnRO+x1bP2+jIGF0AStu9IEuev1dhGx6GGSLvWAK/enxjB1uZxCQX6W/9Byf6qPT2sZ34HK1MF5csnMRlpjrNhYY0s94wX8eil4ilO6AYV5x1JbY5It4mWvy7YvG6rTwLX6Ah4qVTX+3hx9olHK9llM1lt6iU7ZGZt6Edhp5CbY7h0RZSBiNXs9+6BaLwzX2czTMt48CGeH13mbNPc1VPOAcc9p5KhhH0BsfBpK0EYxYSQ38QaMAHpsGmquRQ/pigoTuUpkOQKUeY72dL7ED8HFKSuES2b2xECCdL3zn/HJK3l6p1mCv7c2+1NbKH9WTAh2nBuwY+Hxb8PQFWYevsVjOiEYoWbxg8CSZv/md8Sg6YuW01H0uX+GhrqyfgBD1JH+EZhxZ0OylTV5LHuyxZm0vXnUPd1owbOfS7ACV6CRDM3RFlIvePSXSQrVMegf2lY3KxXlviJfdpPREbZkJ3UycWF7yGf28lCz6xph486AAd1SOzpGPsLe4e7vf0lDUwyTzHVlme1uiW4Bugc3HwusWPKNSz+WIMSfST0G6p320hZM6ZjTV8VC7FK9jaFAivCQuG4yK4f7sPxK2VWvFg02icI7JCoMBwEkM5lOYE5hkc2rEMKGGBiPBFuAzZmquYHesvGhOUmgqisL5SfvetEz/OXdfKeHaVfvjR4i6lSYtJuJAGNvcqQcMpbpPgZYRNh6yMx7mPP1YoMUTL/hE3bmBsUNXyXyFLggAGZpUr1vbJYvFBgV06SNha4MJez+/G9imcilOrfYFanu3hA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(376002)(136003)(366004)(346002)(26005)(122000001)(71200400001)(38070700005)(316002)(41300700001)(7416002)(921005)(33656002)(82960400001)(66446008)(2906002)(53546011)(66476007)(66946007)(7696005)(9686003)(8676002)(76116006)(38100700002)(66556008)(5660300002)(64756008)(186003)(478600001)(83380400001)(8936002)(86362001)(110136005)(52536014)(6506007)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jwCsWB7ZA7ASu54f3XZ8UHwAIWGATtebGROWiDYrKBcfenvnO0mV/WMLdSDj?=
 =?us-ascii?Q?ixxXOs4zMi6QAyrVd6HIFVvfdWZlcAhjNS4V43maJiqfzXb08Sev6j0GbePk?=
 =?us-ascii?Q?7rQyxYzoZvYN+gmkvGb5wQJBLIqX5fR0DTv10jVkQS4nv6b3OjJQTWLNknhz?=
 =?us-ascii?Q?WcHv2Xx5fLu7rLFV0l3qGrWYPcrlFtTHGLb4V/Bi61Rg/C2jxntmW8OLvODX?=
 =?us-ascii?Q?uWM3ZZbisXVx0LzSYQunRSdBOzc9NfimsGM93CiPhyKdOFdP37fc5QUgeaSz?=
 =?us-ascii?Q?COZhZizy+ffr5qqg8hYQRmOAHeIMbtXDIMX2DnTPZ1OO207f7lJ2B2PcyKnK?=
 =?us-ascii?Q?pxYW6A2o6f9OI8zy6bhhnw/NSLa/HcoK0q7T8PYBrC2hihkvyJnt15sfy2pf?=
 =?us-ascii?Q?xmaHoFixZjAPbi6AJ+/d6x/6aiMnxZQMROudgYZnsYm7zXqxbk2cbNWhO0sy?=
 =?us-ascii?Q?SFhYISJ0pjahzEnJ1b87lIt5httbGwMVap33RzA+pSjti0FnR++RaZYXiqzo?=
 =?us-ascii?Q?lWVDcUm1NaeHDpKgZRQPdj2AofderaB0R4iR6axu3nZWaLHpoFVzEBbcmOH+?=
 =?us-ascii?Q?24JmwAJbrlIHk5L2bYXingApCcjbaGHey1fIeejVS8LvkTG62rD8pgwVJRQk?=
 =?us-ascii?Q?Y7oHd6e9LpmPI3t5CwID+j6AUhGNZ/DtE+zoNA18BC/c3X1nUpfItJrG51z/?=
 =?us-ascii?Q?Zv+UoMUARMHRSI3yF0MNubCqs58mExXw2JHbPbkGbGDCpyyf2LJraflzmPL4?=
 =?us-ascii?Q?Atu+ewXADir6AhLYZbTwYSG2vaVxfQvdY/95zLS8dmYIYt22L6GRvygADdqE?=
 =?us-ascii?Q?xh0UFozXJUMYAGsGdecuFV3e8MSLwZ/wzH/n1dpyq4iFILAztxEg0ZyMGFdh?=
 =?us-ascii?Q?zMpgggYtXhWVlD8LGux2TqfZjkArLTX6cfvIKoak8xYiGB6z/NlN2tRd+sPE?=
 =?us-ascii?Q?wATt1UOVF7RCrposob478wshZOkf9jMF/vjM/6aGl3h6hp76VKmtOw3zJ+nL?=
 =?us-ascii?Q?vmRRySJAuGY4Fl39nXOHKRyvoepyINchDiz9NDNEj1Lv4w0qxAGY8GP3W9vL?=
 =?us-ascii?Q?rxbo79wgJOF9HQhBVDsK7AEsQYrNCIZvBlV+Mrba1hfkMTZXfJZwPIoA+x1D?=
 =?us-ascii?Q?VH0K0aETVfcCH8L+Wf73RFbN9FJ/hzBNlCWDF8Ah4lvykPZQx/aglXQbTG8+?=
 =?us-ascii?Q?rsPciVi/Vlj6UvOlQlJrh6bpNI+nJFHrJohQu5i0o7Vb2nan/J7/mQAQyNSi?=
 =?us-ascii?Q?Psn4TWkWZLfAbKiA+e0PgaOE5/hdp0I1iKSRdgUF4e797D6l7vRiRtp8vtFV?=
 =?us-ascii?Q?n/KpaaYwYkAuAWkc+7jGL+ET/E1hBsx7ajBJvtc/KZTxj68cioztJHuKEeE1?=
 =?us-ascii?Q?hT6tTVobig8fHAZnuJuCQoOXw80BLbQgs+4xC/ZaCfM3bL9l/yM3wkOSdZcr?=
 =?us-ascii?Q?ZAzmps3wgHbcggTsa8yOZfmEhSAsGuMm+ZHq5rDXsY/DA60OsETlKM2wG5m3?=
 =?us-ascii?Q?bhH8yg+Uzy5BYmE4SdU1FRmr1TGdJsHJUtlrYvLhAWmurX/hrzzsMDVjB0hn?=
 =?us-ascii?Q?rpDiG/Sbaw+PMD8W7SzjhuWvpRxoQCivCCeYxnvwuO1oWIz5qOY0h6fxtjHH?=
 =?us-ascii?Q?xg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 845c022c-64dc-4aa7-38fa-08da7f72fbb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2022 10:35:05.1940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QgGR+iVvekl7JkGx4U8QvgbNNQxi65WQqYo8qhVf8Ld4m4pc0s5ZKlBQWQG4MA5j7hVyqunXMcWP9BBPBRX5Q/m7s5PwWTOdmu7Ju3WdhMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5545
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Lin Ma
> Sent: Tuesday, August 9, 2022 9:36 AM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> ast@kernel.org; daniel@iogearbox.net; hawk@kernel.org;
> john.fastabend@gmail.com; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> bpf@vger.kernel.org
> Cc: Lin Ma <linma@zju.edu.cn>
> Subject: [Intel-wired-lan] [PATCH v3] igb: Add lock to avoid data race
>=20
> The commit c23d92b80e0b ("igb: Teardown SR-IOV before
> unregister_netdev()") places the unregister_netdev() call after the
> igb_disable_sriov() call to avoid functionality issue.
>=20
> However, it introduces several race conditions when detaching a device.
> For example, when .remove() is called, the below interleaving leads to us=
e-
> after-free.
>=20
>  (FREE from device detaching)      |   (USE from netdev core)
> igb_remove                         |  igb_ndo_get_vf_config
>  igb_disable_sriov                 |  vf >=3D adapter->vfs_allocated_coun=
t?
>   kfree(adapter->vf_data)          |
>   adapter->vfs_allocated_count =3D 0 |
>                                    |    memcpy(... adapter->vf_data[vf]
>=20
> Moreover, the igb_disable_sriov() also suffers from data race with the
> requests from VF driver.
>=20
>  (FREE from device detaching)      |   (USE from requests)
> igb_remove                         |  igb_msix_other
>  igb_disable_sriov                 |   igb_msg_task
>   kfree(adapter->vf_data)          |    vf < adapter->vfs_allocated_count
>   adapter->vfs_allocated_count =3D 0 |
>=20
> To this end, this commit first eliminates the data races from netdev core=
 by
> using rtnl_lock (similar to commit 719479230893 ("dpaa2-eth: add MAC/PHY
> support through phylink")). And then adds a spinlock to eliminate races f=
rom
> driver requests. (similar to commit 1e53834ce541
> ("ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero")
>=20
>=20
> Fixes: c23d92b80e0b ("igb: Teardown SR-IOV before unregister_netdev()")
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> ---
> V2 -> V3:  make the commit message much clear
> V1 -> V2:  fix typo in title idb -> igb
> V0 -> V1:  change title from "Add rtnl_lock" to "Add lock"
>            add additional spinlock as suggested by Jakub, according to
>            1e53834ce541 ("ixgbe: Add locking to prevent panic when settin=
g
>            sriov_numvfs to zero")
>=20
>  drivers/net/ethernet/intel/igb/igb.h      |  2 ++
>  drivers/net/ethernet/intel/igb/igb_main.c | 12 +++++++++++-
>  2 files changed, 13 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/igb/igb.h
> b/drivers/net/ethernet/intel/igb/igb.h
> index 2d3daf022651..015b78144114 100644
> --- a/drivers/net/ethernet/intel/igb/igb.h
> +++ b/drivers/net/ethernet/intel/igb/igb.h
> @@ -664,6 +664,8 @@ struct igb_adapter {

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
