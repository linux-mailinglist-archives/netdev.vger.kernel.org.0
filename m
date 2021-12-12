Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02A34719F8
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 13:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhLLMSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 07:18:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:14285 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230334AbhLLMSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 07:18:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639311528; x=1670847528;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bl50xwlHZh8NTdtBSQ5yG6fhRmkYK62TFeO5r+xlnQg=;
  b=hAdvGWqXjEt2hKoNe9tL5ZzMVkco3RymcMfyoU+K8pR3UBxdj8fSiN5Q
   aZ2OwGYjfx2GB5YVSmkzaX4SQULUqE8kM+wbpG2GzL5hWk9RSDgJcUCOA
   inD4hMPkciPobVbfRR2Eg0RizpJ3xGoYtHi4LYv5Q51FfbzWKZaND15Ck
   +oETRsAjU+phgjfH1kPngmC09eb1npRLWMDAtBW7Qn4UAl7ZJbvwqU1Py
   1KoZob6MSncNs5+Yci4NZBsHAzH3vPcMseZ7GbL6Vm3URaE5ej1LR12ot
   N6tIemtA1IJ3fPpTk1sqt0HVpeBmccuNdb+paWV10tzh8Af3TShfwQt58
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10195"; a="225874425"
X-IronPort-AV: E=Sophos;i="5.88,200,1635231600"; 
   d="scan'208";a="225874425"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2021 04:18:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,200,1635231600"; 
   d="scan'208";a="504562256"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 12 Dec 2021 04:18:48 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 12 Dec 2021 04:18:47 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 12 Dec 2021 04:18:47 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 12 Dec 2021 04:18:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYzx3JJ8Zb46E72CPV/AydqMmaq8RvOruXSK6GghlyTa487yCTw2T936lgeG5ZUp0wQSA3hTJCnHghUI5ejKEGtCp4xKZtUhx4v09tmTrxYycY0/ByFoBZjJZs94Two84z4QTnWAUXNOzFNxIeWPuw951Rw3d1XSXCpxBOh9+fFyGFz+KhdLgEjDUvk6LlRi/BYSeY3cfFPrGytpHh2XMe19sE9c51o5rm8tNpbH3ar5YuMPzQq6/wagyaqQ38BZ7jd3Q9O/K+jteEVQR/3UaDj0Q6o+TRdozFZMiU8TY7rF9TaGh5vNQmwJxf2wOTX+9ulSH51isja+Q09Byqm+Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KsZ0fcQBh3OCwbQZulYEGOW1rOKchOSmGxs0RaCXLw=;
 b=UFmvVt+sDt90xDj7gDFGo+GCtvV78iP6F3XXtPJRW08+eEjj766IPj1+Kz7QJ59ooK2UaTo+1Y41ikqXWlKcSeTZ3ALnSawLILL8BKvuosADAjOcgJlhhRtR+8uBvv9XMPzPQ0cFFnFNcymTKWRTc54BkRnycZfo2KK66IUjVTHo6pek/QcnAkrYY8vhC9iq4TWLjIId6xQ3P/693vliPCBOWyzI+jn13Cl9Cwbk5XBCnace++yV4ncTWe1kWKPxTsz2w2zAD5u8PNX+5wkZP8A9Pd93jrKXKluft7LOBxzWs06eK7kn8ZGvzPLM4FM1uQEdK5EBVvcdCetjmVw/lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KsZ0fcQBh3OCwbQZulYEGOW1rOKchOSmGxs0RaCXLw=;
 b=aRQAmlMwjXobcleqIb8Jvz0Ujx1Lb5UpCpOE2VM5Lc8En+jKs1LUlFyZFWqaBZ5w7//lwDi0JhYj41n6iC3kkIAWnN47hE1tagXibdfFZEil6DZi3YoR7DYC+C479o3Hb8nUgx4IymBUcdvUX5OfjT4CZvA+ycu8/dqpTuE1tC4=
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 DM8PR11MB5576.namprd11.prod.outlook.com (2603:10b6:8:37::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Sun, 12 Dec 2021 12:18:46 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::3114:bfaa:f64d:684a]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::3114:bfaa:f64d:684a%4]) with mapi id 15.20.4778.012; Sun, 12 Dec 2021
 12:18:46 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Letu Ren <fantasquex@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: RE: [Intel-wired-lan] [PATCH v2] net: igbvf: fix double free in
 `igbvf_probe`
Thread-Topic: [Intel-wired-lan] [PATCH v2] net: igbvf: fix double free in
 `igbvf_probe`
Thread-Index: AQHX2aMP4BUjAPVs6EiZBRF4B/2N46wu8WmA
Date:   Sun, 12 Dec 2021 12:18:46 +0000
Message-ID: <DM8PR11MB5621C68793BED519CC5D7A11AB739@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20211113034235.8153-1-fantasquex@gmail.com>
In-Reply-To: <20211113034235.8153-1-fantasquex@gmail.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20b57d4d-7693-4844-bc7b-08d9bd698bc0
x-ms-traffictypediagnostic: DM8PR11MB5576:EE_
x-microsoft-antispam-prvs: <DM8PR11MB557602B394B29CEEEC6D5A28AB739@DM8PR11MB5576.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9yn+yvFJewFk0gk/PnR6lGTy27hjlBfHFkFxqo6mvdRCa+bMrDHnpIAPzfWMwrmD00f5Yw1x20C1DR5t6+AOf4PBECbwj8byMdi7aUi834TEUAL4lE55t1O3jm686Vvm7sVljBaqOU22T4BjxONF4FvbRY+YRDcvqGLCtK92wCz0UQTHa3+MS+65JXgoEkmFk3yserpe32GiRM4W6dE0xeX9Nmo9zwKx7AqHVBPs3DQGfoaZoT/Fs9DCW9QLAUW3bqWQO/inKbiCOc3s6txMNfMjUnSgKf9oA2tEI7oUTWlasH90h6MxAhU9LLCwXgZCF9GlMjLwk388uLdJlduS5Kxe348IGJIlmdR4lqRQH8kUkMnrf3oWBmsY2LPMh4dfQ3wTEu+9rt/LEodZgkEzGwN3cCY2vKv7dBmjkoIzGRu/HRIf5cuwRG7xiHPbd4tSZhwpi/GFIIc/V9C/dUG3KnAyte/O1ry2t8OdD7sIclkWo6yYvNI3McJxLKv+vx1XeiudvjM/UE33xJ6t5wxTSLf+Q3hPCnyHlOaRBS9+w3MR90EwM9NRcAw4dWGGuoBSwmCbIHZ6QNTXFkSU26SLbLY5o6UnSM0KhLzeyX61DCKY0f1aBmoKMj1QUPwSHYQD9+4agweuW9tnMZ7b2qTKdsb+/jal3fZWrnrCtq9Lb0nbVNjpjZ6YUGG1CQuJtXk9j2TQFYb6Muf4vbbdODTCALwkCYkwNSyjPry7Stk0O2E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(7696005)(33656002)(76116006)(66446008)(83380400001)(8936002)(110136005)(54906003)(66476007)(66946007)(71200400001)(64756008)(66556008)(122000001)(82960400001)(86362001)(316002)(6506007)(53546011)(38100700002)(38070700005)(8676002)(5660300002)(508600001)(186003)(2906002)(52536014)(4326008)(55016003)(26005)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kaOrAD1nuKcnyYeJrtxRSq0n15CdboZsc8JByPOXQB1p65Sx9REwELKFdKwI?=
 =?us-ascii?Q?WgdGeLdpXb1/3bTa8gxnlBnka7lLAEYkNA1FtXnOelqtjuBOmKZtSH2K3Giy?=
 =?us-ascii?Q?P7pyECEwaz2h7+1lPnE1/lU9O9q8xXNgENhRDbcEMByK4g85273XJNeXDAND?=
 =?us-ascii?Q?roSkacgRA1CiAaS8PjeSqDtsPR4dDQ4PsCWwVKtLP0r7J9LY9pKd8bms/ZjA?=
 =?us-ascii?Q?hhxvqpkbFZzVTMVyyaFQ6wobqgbd38iGWS5un6i65TciDTt9V7Ct6srRHykZ?=
 =?us-ascii?Q?rWU48J3CWQTKxuahe+TPbWRcv/4rEpEN+/lD3aYJ4pb4n8q34Ycs6dj7oo/E?=
 =?us-ascii?Q?P6vkhKME5aFDXJPvygjpDQhsM+mkKQm9Qu/thQaVuUuLhiv0vro6QvmzhBCZ?=
 =?us-ascii?Q?yesyAG7XyX8cGWoNcf3iyZyUV+ObpuVfUxSo4j67q31T5cOFmHiw+Fa+co83?=
 =?us-ascii?Q?zXbVnQhsHpDCfQWi946oXAqg3qD+sRIRwGhBnWU2gg1M2Wx/QcQAjugcfq2M?=
 =?us-ascii?Q?ZikaRiHoTDhjT0nvzcnhDvvATSGpnQJ9gVXux2Yr7sh/yURIIsvNqykGKZEV?=
 =?us-ascii?Q?PyA6HQtVQg0GTVdV08llTa5r2a1GoIB7poEsyKSw0jXYzAPsft3eI+oRUyk3?=
 =?us-ascii?Q?kLY9hZVMA+oV1FM8PI5OzvGhoC14QXaPEhE48hvGARTh6/NKcRO48u7XRF0W?=
 =?us-ascii?Q?BleeUpYdTkiQhHlGCUhLIB9Fvn7fHbRJ2VWOOVVWssM4Ksu/jr1FzZkW4KpY?=
 =?us-ascii?Q?Zl1WwKQ2C4xSsB1IgCjSMzZdkvb41A6MvdjF1ZD3qDgRau4d9/Zxg13dxkZ/?=
 =?us-ascii?Q?ohrIHLTMVFI+XXCfjU72mEzip1+kOqu6bq7JIjq/fYNK1CM9PLd5vFHZWDIE?=
 =?us-ascii?Q?EupUegmqCgw6imfTI13asVnnUbke4ch4YYr5byHiZTg+URr0bo8fDrMm4Edd?=
 =?us-ascii?Q?/8k0aFJTlScJz9lRaQ4/0ICbMeRuzNIjT0Ig5kU/RJoTXG2AIKpfee/BehnU?=
 =?us-ascii?Q?WT/iWY2Pa4kY54F/SaLkSmx+fc3KcMPukyOaQDhdvl49uFaWO1KxaLc3/8EG?=
 =?us-ascii?Q?VRE0PQEdQNV6vfdNZFMtaKdOtYFHAk6ezPWHAQQrrlHKICBi6jToPDW4bqas?=
 =?us-ascii?Q?hpovCGrp+pZ6MUiKxieQ6bAbH22g0AH3+I5T7N/+rdke+NZQcYJDheA2cXzB?=
 =?us-ascii?Q?Vhc7KllnlPsO7RKt5UAkoXm3+D4T3drYhGwlb3qNTNQLv5DNMm9S8c60pahm?=
 =?us-ascii?Q?TjSHPmFyXefYC6v8+zMNLCgvdX/EFDmkAZikSvHzwkx8swOGcEsoFJcpu514?=
 =?us-ascii?Q?Y9vQErkb96gR13dvHyAc+080r9MX6u5wnVsk8b9QEcBmnVxOZKm6nUUgpKx4?=
 =?us-ascii?Q?wtez5839YADNKFFwo+tLa35VAfaFGlFBjauPQsbGTwVNC3+kp7UP2ejn0UDq?=
 =?us-ascii?Q?OwgwHzcuTzUvdSgxq29OM+kiL/C87uXBclnrt1k1lqGxvcWC6LYHh7gabh5P?=
 =?us-ascii?Q?Y5ScPKGhbNdgAquyk7ahR1tbrW18NcfAuCMSEdEmOh6lYCI8UAI8DmYMjPpJ?=
 =?us-ascii?Q?x5c1glMW/X22UmLufb0JqsSQlzhB6qculJduwQuKzNvN4XORxLXf/jdh4aUS?=
 =?us-ascii?Q?NATk1Nj5nKhsAfbz5qhbXw/qbbxxWavrc4KMrZMaKJeYDSQpdKil5Bmu/kTO?=
 =?us-ascii?Q?+JNv/g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20b57d4d-7693-4844-bc7b-08d9bd698bc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2021 12:18:46.1892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2tlpNytRL2LoFvS0uifclY8VkDOhDyvdbEKekVUyTxao+OzOg62DG8vFQL1gSFCnOY1DPycmkAElPcwRCGTFI3Hnoz5wWiklrMqUDtLC6pg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5576
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Letu Ren
> Sent: sobota, 13 listopada 2021 04:43
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org
> Cc: netdev@vger.kernel.org; Letu Ren <fantasquex@gmail.com>; intel-
> wired-lan@lists.osuosl.org; linux-kernel@vger.kernel.org; Zheyu Ma
> <zheyuma97@gmail.com>
> Subject: [Intel-wired-lan] [PATCH v2] net: igbvf: fix double free in
> `igbvf_probe`
>=20
> In `igbvf_probe`, if register_netdev() fails, the program will go to labe=
l
> err_hw_init, and then to label err_ioremap. In free_netdev() which is jus=
t
> below label err_ioremap, there is `list_for_each_entry_safe` and
> `netif_napi_del` which aims to delete all entries in `dev->napi_list`.
> The program has added an entry `adapter->rx_ring->napi` which is added by
> `netif_napi_add` in igbvf_alloc_queues(). However, adapter->rx_ring has
> been freed below label err_hw_init. So this a UAF.
>=20
> In terms of how to patch the problem, we can refer to igbvf_remove() and
> delete the entry before `adapter->rx_ring`.
>=20
> The KASAN logs are as follows:
>=20
> [   35.126075] BUG: KASAN: use-after-free in free_netdev+0x1fd/0x450
> [   35.127170] Read of size 8 at addr ffff88810126d990 by task modprobe/3=
66
> [   35.128360]
> [   35.128643] CPU: 1 PID: 366 Comm: modprobe Not tainted 5.15.0-rc2+ #14
> [   35.129789] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> [   35.131749] Call Trace:
> [   35.132199]  dump_stack_lvl+0x59/0x7b
> [   35.132865]  print_address_description+0x7c/0x3b0
> [   35.133707]  ? free_netdev+0x1fd/0x450
> [   35.134378]  __kasan_report+0x160/0x1c0
> [   35.135063]  ? free_netdev+0x1fd/0x450
> [   35.135738]  kasan_report+0x4b/0x70
> [   35.136367]  free_netdev+0x1fd/0x450
> [   35.137006]  igbvf_probe+0x121d/0x1a10 [igbvf]
> [   35.137808]  ? igbvf_vlan_rx_add_vid+0x100/0x100 [igbvf]
> [   35.138751]  local_pci_probe+0x13c/0x1f0
> [   35.139461]  pci_device_probe+0x37e/0x6c0
> [   35.165526]
> [   35.165806] Allocated by task 366:
> [   35.166414]  ____kasan_kmalloc+0xc4/0xf0
> [   35.167117]  foo_kmem_cache_alloc_trace+0x3c/0x50 [igbvf]
> [   35.168078]  igbvf_probe+0x9c5/0x1a10 [igbvf]
> [   35.168866]  local_pci_probe+0x13c/0x1f0
> [   35.169565]  pci_device_probe+0x37e/0x6c0
> [   35.179713]
> [   35.179993] Freed by task 366:
> [   35.180539]  kasan_set_track+0x4c/0x80
> [   35.181211]  kasan_set_free_info+0x1f/0x40
> [   35.181942]  ____kasan_slab_free+0x103/0x140
> [   35.182703]  kfree+0xe3/0x250
> [   35.183239]  igbvf_probe+0x1173/0x1a10 [igbvf]
> [   35.184040]  local_pci_probe+0x13c/0x1f0
>=20
> Fixes: d4e0fe01a38a0 (igbvf: add new driver to support 82576 virtual
> functions)
> Reported-by: Zheyu Ma <zheyuma97@gmail.com>
> Signed-off-by: Letu Ren <fantasquex@gmail.com>
> ---
> Changes in v2:
>     - Add fixes tag
> ---
>  drivers/net/ethernet/intel/igbvf/netdev.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c
> b/drivers/net/ethernet/intel/igbvf/netdev.c
> index d32e72d953c8..d051918dfdff 100644
> --- a/drivers/net/ethernet/intel/igbvf/netdev.c
> +++ b/drivers/net/ethernet/intel/igbvf/netdev.c
> @@ -2861,6 +2861,7 @@ static int igbvf_probe(struct pci_dev *pdev, const

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
