Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0C8480548
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 01:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbhL1AGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 19:06:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:7713 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhL1AGk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 19:06:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640650000; x=1672186000;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n1jfHQxvF7CzHtYOBgDCn/Xx7a4UnuB3MBDqh9A1tqE=;
  b=OWMaXAC8RaS+K2EMBZoga30psoZsXSlKNpUGHG+wxunjz1G6/Y4NDJhR
   avR1w66DRmoGVHBAHZWu7Hfq6/Rs5FUiCnj1yKS3GzZbONcBHYc64MGEV
   70DITRZ9eVEyuGkFeAUsL5HknprGYt/ybiCPdHJFoSJQUQwcdZt5Lcmin
   h453Eeqak3U84QwfUGcZWxwqOsO8T4J6OLRinUasoS2RRfndYcEjcEQww
   JPO5MsWS/4rJzkzTn8Ww28d7IskGISqrECvucqBb0TMwmbCf0pzu/vq/+
   /jvPmNJ++sIFKykORvNYoAEzZGChl/QJblMcZ2u5V72DnLEMecuhPTq2m
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10210"; a="228588773"
X-IronPort-AV: E=Sophos;i="5.88,240,1635231600"; 
   d="scan'208";a="228588773"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 16:06:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,240,1635231600"; 
   d="scan'208";a="510005033"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 27 Dec 2021 16:06:40 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 27 Dec 2021 16:06:39 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 27 Dec 2021 16:06:39 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 27 Dec 2021 16:06:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrNb6IBBuair4p5h+2gosNGdOTqE6DsReoTxfCAhh+1GZC3Yc+0Ge46UTSgju5RjgfF+WFI5j7thRAxwFZgrxFQpO8NEq1GhdEz5KjnWdwxiA1bpwmkHvlfEEQh2RbesE1lo0xh/W2y04FKwV/+KcjhsMA0eK0Y4YI5gmJo7XUXy5OE6hySYmiRy2XjBma3Eh6e6ICqA54Bk3/Hw++NnLHyaEtOWYL3bbIUQLd1KvwmurTOTbHFllmcEXyl9QK6mqxe8UDT1cXf8aTC7JmrvIYpy5R4mCMDf+B5bOCPCJ4FWQjZCFhbzv0gnwt72//DImaFX1PFlZc923I9PaRrTlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=heBzyh5/Io3dAKSzvw+Cb42t8HnPAfoULGtp+fzwFQU=;
 b=gFL8+N+sAe8sP1wr6/PjBOZbGxdRsI3O7YszQy08Nc+hHMKrfTKPH/VB5k06UPGrvzsJJ9FvKYcVy2X2bm4olw/GOab9bCGPoGUV+6yytWkHAszhE1GKgbUOzUbXO/PS6tDaKnLh/Fsp3p8kveb0IMp+KOz1TXaZhQSbDSYhuUFo763GqqZziBIxFAVQsIQFVxFqjivawFbBASHniRN5+5hlpC0g5+l/HCQU0BSaYqn8gbBG34nYVnFKmgxXLGmrnGP/apwj2lCiC+RwkwPq4bsznGUQ/spmqu3bGsQUOQmUTlws6wpl76nq2L4H/Xp61nhTSodFKNmtMhZdg6im3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4218.namprd11.prod.outlook.com (2603:10b6:5:201::15)
 by DM6PR11MB3706.namprd11.prod.outlook.com (2603:10b6:5:13e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Tue, 28 Dec
 2021 00:06:37 +0000
Received: from DM6PR11MB4218.namprd11.prod.outlook.com
 ([fe80::1df3:d03:1e1b:5d6b]) by DM6PR11MB4218.namprd11.prod.outlook.com
 ([fe80::1df3:d03:1e1b:5d6b%7]) with mapi id 15.20.4823.023; Tue, 28 Dec 2021
 00:06:37 +0000
From:   "Brelinski, Tony" <tony.brelinski@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net-next 1/9] e1000: switch to
 napi_consume_skb()
Thread-Topic: [Intel-wired-lan] [PATCH net-next 1/9] e1000: switch to
 napi_consume_skb()
Thread-Index: AQHX4I+dk+BNkj9z/EKU4Wq29BPruKxHPEqQ
Date:   Tue, 28 Dec 2021 00:06:37 +0000
Message-ID: <DM6PR11MB4218AFE1E9E4DD604693DFBC82439@DM6PR11MB4218.namprd11.prod.outlook.com>
References: <20211123171840.157471-1-alexandr.lobakin@intel.com>
 <20211123171840.157471-2-alexandr.lobakin@intel.com>
In-Reply-To: <20211123171840.157471-2-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a511ac8a-653e-44ea-2450-08d9c995ead7
x-ms-traffictypediagnostic: DM6PR11MB3706:EE_
x-microsoft-antispam-prvs: <DM6PR11MB3706A02A19F6454F9EA3446A82439@DM6PR11MB3706.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sLIwiT+7/4rrumsv7235wbAhhCk0NuPEZ0kwbsDQ6Ym56AI+OK1Xek2cLLlS4y8EVdaTvccqq9fEaWE0XMONx7kfh0RORQyWE98mBRd5ElU6SjzuOqc7YXuMTHUuyXWEqkJXg9x45bExaY4nED2EFZ0ei11xiSQ0afD+OBBvEtIofxgZC9Sbp5vZ3ARrEapUa/Y5AXqkqUxNNofNfBEsOJ7fQ8g8O9sATrm3switK85gJ2aK6JyCRJ3UDDheA+hkDsLjzrg+AoDDwaSBL3fgeQ5d9jTRd2cE+qGMZFcc1OX+laZoQdvlybuujm5+2Qiia2J9k5m+Ir24q5KwJ7+hzOOpRZ5fwfcq90g6lM7c6nb5DYm6sm1jG3bl8eZKr3cP76UBuiE55XpndDkvX10F+zhWVB5g8Dmm3iXiv8wiuldwSYK7EVZJ/zn6YBep+8241h4mexTWpjUd29Ha4MO2J9yOPddkTLW3a0PhUKKrkqf7AN2P8G2oYKbXbRMxrOvI6Wl3Nd47z06JNZMRVZEdxtQ8FJGOyrhGWRi9QBKhfuoCdpBEnx0/eZi5xK2SluMGhAT8CR8tNMRbZrj5W8NEFr6vFr0Ud7TbGpxc3vIUyMGIit3dBhQajw7857+MtmpxwuaOe4EKnYcZ2xIABqCgNVTsPL67xrhW1o/ONGHQWLv0HLb4Wfjt/B5WJPktR4dkZP35Tt4xBJmm06PS/5MQcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4218.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(53546011)(71200400001)(110136005)(5660300002)(82960400001)(508600001)(76116006)(38070700005)(33656002)(86362001)(8936002)(8676002)(122000001)(6506007)(2906002)(52536014)(54906003)(7696005)(55016003)(9686003)(38100700002)(66556008)(64756008)(66476007)(66446008)(4326008)(26005)(83380400001)(66946007)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wVzieo5TONaUJfCrb9FfrTG6/7rzBqWzx+7k24omZCQBCRKXHYv2g2+U+45s?=
 =?us-ascii?Q?IPJRJGKf9J1J283q+Xy9aZ6P5rDcpiQvgMbVykRqm5Ys3XsBDy4X2X0vgiJl?=
 =?us-ascii?Q?2qPfsirjc+8v59C5ri6/c4YtOAhIxkGbc9BQ0ep76AwPwl8HVN0SFJ04BtaN?=
 =?us-ascii?Q?oA80DDlYkYFH8H8BlfkzCqqGhzDAAVKqGPDg0WNMyunsqPaDLv+ef3WV7zXH?=
 =?us-ascii?Q?sPwaIsDEazWvF7cXGqJ9eTjTwCN7YlDYTLKAyWqoxc0CkZSjNMTFy+i6LJfi?=
 =?us-ascii?Q?y6F1e6R6QqwU6S7j0gyGuRXeRSKjxSwoWYZdHrdxzc08xde1naT8104v1m2L?=
 =?us-ascii?Q?TDS4Ab2xzuWWjuEI2s8kMgrB90yI5rSxKhv73t/wLD1Fp8YJWbbdjZUoo5tR?=
 =?us-ascii?Q?tFl/e5fqbxai9QH3PZ/4/PJvDLQk8+n9+N94nT3C6mQLRrxpZC4wbSUFeYKy?=
 =?us-ascii?Q?FVqTWkLrw/32R8GdaYnYBl9KxMa6dPlOHfJ4CMdoW5AZQHJKbfwtMADXswbk?=
 =?us-ascii?Q?9/yEwc4tm7E6mhs4+wzx/RSenUbfymgmSQRI48XfvyDn3LXOD/RBUu2x96fj?=
 =?us-ascii?Q?KHmrb8nE8GvQCmTsanwVCfFS+Y+s4+1KDw+gMy37zsR81rmGp+vqKdpC6wpw?=
 =?us-ascii?Q?fvOpCkUYp8+8dqV6t2sANNviVSOLlrXPt0xXJJuItwVHvgYrlGZXuHYbg1K8?=
 =?us-ascii?Q?JxTOKiWU5kBFjqZq6woeqXuM/Pjb3UFl4XiPQ6742nmB+YY9+rxfasAtjjRd?=
 =?us-ascii?Q?sZ79IQ94K5phjOsT22+4Z42cc0SJkNTWpg1TBQOhWgPB+AOCg1rqwxxLX3VD?=
 =?us-ascii?Q?dqqHNlTqfsIdoUwbKdF/xsXBaAtQGMK8S1qmuOQW0pIyyG87iGIN4xtHVuNg?=
 =?us-ascii?Q?gcNCz8hrAufIwykZ+Gg08i1Qee47mXkrOgZ48IZT9/0x/PE2KP9O6DcxYKNO?=
 =?us-ascii?Q?nc0tBx95MzSE0Xg+CdMClUaOtOKp3xl7h+DPlVpIkmVH3c7Az784KBiGFHjW?=
 =?us-ascii?Q?flO/rb+v6R+uf0pYUZlLMVtYwZarcqk5rEr5rv7KTZzz0cbfdKZGiXhn/rUp?=
 =?us-ascii?Q?dVjQf4Z4HGpCljUE7pg+Nc8yn7znS3/DCWP3kLQ9x/gaO29DMo2rvaHbrbzX?=
 =?us-ascii?Q?hqfEnx5I83bgu2+YnGG7CmFFvS/J29QNVsKXRC2pyRh/1Pl3OfWLv/uGNdWW?=
 =?us-ascii?Q?mVCnkPqElpMyJMOp9ZYjUDRPXXCdOtupm0HPsEwA2w4PxqCHM4YbdTTXdYgG?=
 =?us-ascii?Q?27/TY7lO7yyzCzNN8LPNGW4cz/uVYatnOmwnhWPEhfAWrRqx/OqvJhRiPWk9?=
 =?us-ascii?Q?b6i+/cZu5Sddl22itptrbf9LAazTuxLvYBBAiRotvMW9EP0DSeyg6MfP0RM1?=
 =?us-ascii?Q?+7R4T1g/63c2yVMOmx3E5QD6hY+RRV3L5Mc+vmvpHhP+czI/yisBunrkTbml?=
 =?us-ascii?Q?r1QVURq/JLfv4yh8R84R+ShRI3T6tYke3/DHbD4eWcBmCEn3tuG5LQxhcU+d?=
 =?us-ascii?Q?ceiESgsZF3WqveUfQAlG/WsUAdoi46dfiUQUSGLptR5/GJHbQCFWDWyYpxN9?=
 =?us-ascii?Q?DGzueDclBxwK9QafGTLqMVQc/0cUmqk6EXeZCAeCcfrDw4BgPdJxqItrtb0o?=
 =?us-ascii?Q?ZkyphFjHR+KI8EqFICZbToCQS0ySjI8LK1LtvcD/Cd1V3aU81keI2RFMqeTH?=
 =?us-ascii?Q?47fwww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4218.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a511ac8a-653e-44ea-2450-08d9c995ead7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2021 00:06:37.5754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QaJnwSVDyPb1MYRJ5rE6WtiX0odHnUr8wU6OpzCXFq2v4vgCNHO1BFj2pXP4TT3hjd2DIgTsKTxdr/ekMhqdbwVAUlWTYGEFSyWDMw2BoCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3706
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Alexander Lobakin
> Sent: Tuesday, November 23, 2021 9:19 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jakub Kicinski
> <kuba@kernel.org>; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net-next 1/9] e1000: switch to
> napi_consume_skb()
>=20
> In order to take the best from per-cpu NAPI skbuff_head caches and CPU
> cycles, let's switch from dev_kfree_skb_any(), which passes skb back to t=
he
> mm layer, to napi_consume_skb(), which feeds those caches on non-zero
> budget instead (falls back to the former on 0).
> Do the replacement in e1000_unmap_and_free_tx_resource(). There are
> 4 call sites of this function throughout the driver:
>  * e1000_clean_tx_ring(). Slowpath, process context, cleans the
>    whole Tx ring on ifdown. Use budget of 0 here;
>  * e1000_tx_map(). Hotpath, net Tx softirq, unmaps the buffers in
>    case of error. Use 0 as well;
>  * e1000_clean_tx_irq(). Hotpath, NAPI Tx completion polling cycle.
>    As the driver doesn't count completed Tx entries towards the NAPI
>    budget, just use the poll budget of 64 to utilize caches.
>=20
> Apart from being a preparation for switching to napi_build_skb(), this is
> useful on its own as well, as napi_consume_skb() flushes skb caches by
> batches of 32 instead of one-at-a-time.
>=20
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/e1000/e1000_main.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)

Tested-by: Tony Brelinski <tony.brelinski@intel.com>


