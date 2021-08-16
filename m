Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA963EDF4D
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbhHPVaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:30:16 -0400
Received: from mga05.intel.com ([192.55.52.43]:61873 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233490AbhHPVaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:30:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="301527928"
X-IronPort-AV: E=Sophos;i="5.84,327,1620716400"; 
   d="scan'208";a="301527928"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 14:29:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,327,1620716400"; 
   d="scan'208";a="441273338"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga002.jf.intel.com with ESMTP; 16 Aug 2021 14:29:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 16 Aug 2021 14:29:40 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 16 Aug 2021 14:29:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 16 Aug 2021 14:29:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KutNE2XN/84rnwphkqrRXho6EA8monahIm7zYCFNBluGMFHVeFlNiYLBECMprAS/B920zCUghGGm9sVBUo+UfKkc9o/I1vBtDQASSwvpCgqbpPl80Ya6DILGkKIBX8K0IZsKc1eUQK7R90VQNQicU7ZEbPCSK5XY7fhgVSUOdBfcFUf4EbFNDsxQbIqvXygXuDTA3ngWJOTq9RA/ELLFX2usmX3xKrAbtSDAQlZJYlXKJt2H3v5gwjyvz/RxaEGfeOzfmVw6RE7V33OSeiAryI+7hyBhvHZkSDc06EEFdYYKTng5EJiy1F3ZNEvt6JNy9H6riZjIiVlNdDSMwX+9ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QuaNjXyS7cj3O774x9qFZpnptrhE6sFDgbHJXyknS7E=;
 b=azryBCTTc3Bj7W4IQ09dUN7Qi/j1qVPrTeARmvWQaiyTOF9dEROCPB20Q3EELROo4faJ+kD/Rb7CNiaJ24WLfDhLS/DXwd7Y+i9IjJQLZUU9ElQNiHhVW699vSuAq0GFz1Z6nLVgESAMKEJ9JMI5+gBaoDUzIyLwFOAz3MD2yEUg2bRDW3qoD4+9tv3rhJAxDHjxYGvennD/5FtoSSM5dhcWc2Jyk1f9aJi7BO1HKiHzzo9dlRLokV99sE93COZ/37pPClfFAOz9fel15y287U0AdVE5ruVXo4WWFw7Ry6IWiseS4V0XgCs4eCqK3kLoepp5rXi4u18TaZzxlVMjVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QuaNjXyS7cj3O774x9qFZpnptrhE6sFDgbHJXyknS7E=;
 b=s2UcO+T+v6PG1UWzzw5iQBpfzxKvBSlrbBCDfD/HgG03m2ChjTEuTsAMKFaNthEwq7nQsumHT+pqPvxhelF+7aBYP2S1YnlcVDEHT2QAKSJBD05YlAQVvt8ggXREirzvnrCthHuApxNldg1A7TCaoJ/nVyxnkQzVf1B6UN+qXNo=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:95::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Mon, 16 Aug
 2021 21:29:39 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960%4]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 21:29:39 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: RE: [PATCH net-next 5/6] devlink: Clear whole devlink_flash_notify
 struct
Thread-Topic: [PATCH net-next 5/6] devlink: Clear whole devlink_flash_notify
 struct
Thread-Index: AQHXkPLcujmXdlFgmkiF0D7fqGlHUat2qVXw
Date:   Mon, 16 Aug 2021 21:29:39 +0000
Message-ID: <CO1PR11MB50896CC64EB40DE3B2D1775AD6FD9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <cover.1628933864.git.leonro@nvidia.com>
 <d66bfd66eb8744663b7a299db0df7203bc6640cd.1628933864.git.leonro@nvidia.com>
In-Reply-To: <d66bfd66eb8744663b7a299db0df7203bc6640cd.1628933864.git.leonro@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20219bf8-eb66-4016-6c8b-08d960fcf43e
x-ms-traffictypediagnostic: CO1PR11MB5154:
x-microsoft-antispam-prvs: <CO1PR11MB5154B04F77AC45ACEA7E02EBD6FD9@CO1PR11MB5154.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ns+M6tJJi0Kdoj+D0lEfm89RzdfO7ZG2t21EV4gjc3k03SJ0Dk+RIMXeDm7Yj1um7mWk2LGPixTHY2U3Zxj9oFvxFrI+5GerZCM4P5fxxsoHqjnm48W2r2YtpPAGAoU/3PPnIdDrj/KOY3fUyn5wi/0LwHiMfYyr2gvG9aYldhEW2/1x/yFUYcDjtU/D3R8YeVCmaHLMl4xppiISC5J4H83I5LanbotQGFtIxVwwnYYghE0YUQiZDxAbPDog+ZjCEXUycuvIpifyR3db+kCpHuJlYdvj7vOjEPx+e5wAMQ3YA9HWn+HzUxe80Roa2gtPutjHQYbN5Nz0eMgT7m9ONEF/r7zCEBQcu1ap8vXMZXbdU+/iQLlbIoNlByR4HpfNBhIbRPb88u8gdfDfkuAOchMz4lhTDgt2S+A0/5lDvpxIVwpLpcgGDT7Mq4JgknasTpduhfREq2BSVc+95Nuc+H4uFzw1jc6fycVZEZS5EQeJ0id5/f+3Lq6dHBahdH/2vdVsWI1t/Rdp9Zcspg0CuOAVJt8D59pctNsZ6qb1J3Maw6mLFmbDFi+sOyvTuOJMzCu49N77DepDUJ7ykwJVEo10746B3woMAogL4sj95gsN936R6f9ofuC+5OSfkYC0fnhtrtveHKHEpLk5IWUV4eGGMBXgFNzrjF/o8NxxXfQuGr8r/f5dvTRkmXrwFSQZPTU9u6uP7k+YlYTI386NA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(53546011)(66476007)(6506007)(7416002)(122000001)(52536014)(83380400001)(66946007)(316002)(508600001)(8676002)(38100700002)(7696005)(71200400001)(5660300002)(8936002)(66556008)(66446008)(64756008)(26005)(55016002)(4326008)(9686003)(86362001)(54906003)(38070700005)(2906002)(186003)(110136005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RvVkATjJ9JmFCNN4f3YKDde10I9onbAU894FbwwKBIJvUBfRA3r0cN9HstF5?=
 =?us-ascii?Q?V9l/LfocOuOr3g2dnxbZxWbR1IWqD0I0Tfa/bAuUFPFtFlZwir46p5TXm0xD?=
 =?us-ascii?Q?Ar0EoJcg+qhbleBhLHBJFIXq3SHXjt30niJzWeYK2k5i7679xtN8SHMWnCn3?=
 =?us-ascii?Q?FpuspBZ8ifUktxViktHpcU3u5+Z7ss9Em5G1NfqGFiI29AKYGWL0h4fgTzM5?=
 =?us-ascii?Q?FCt8r3ZsnwzXj0x0jrgWqLr+rqy4d5EjFy+pQVm05Os361SuTZqRel65f4ap?=
 =?us-ascii?Q?O5vXYmgWKhq3J7c8YNbw5V4ufGiKRCocynfPjQMyb4NIM4zY7I6kjTCdj3pQ?=
 =?us-ascii?Q?vLgnv5j3T0aecWf6iWulr/NQ6oqhbzqxvf9eBm5xT0o/rKM8UelEcsOU6cqZ?=
 =?us-ascii?Q?m79llIVYVK25o2DgkQxc7MsVL4OZ1uvdPSZ+vFsEgBV6RdYjffzfWK1HkVH5?=
 =?us-ascii?Q?WfBkJ+v64chkHUDUwFcYYatAHKuv2Tv3boSnQH/4bTbDeIFjE0Ik8+w0H5dz?=
 =?us-ascii?Q?Ybm9G+jTidDzdw2/jeEIFxo4mU613IVzVPlB5PZRhPK0cveQc05HzL98COAS?=
 =?us-ascii?Q?vcDTzFu7Joryu892WO3IDqxBVwcLHZSJmyXdnTkRydfLMkIgxGtSlLOzx2Ld?=
 =?us-ascii?Q?q/HoP9mUa/L1bbdajYKFJHBeHFpO/tRVkvPNAMvDT2bo6IsdPAHz7nBcfCb1?=
 =?us-ascii?Q?mUHRS7vOYSikVlmPm9m1rXTHzYnmJ2kG5E3OUDGj/tf4hkR/tO5PXFSXFBxS?=
 =?us-ascii?Q?9hu496gpo4rQJMpLh1U0al4sVf85QKe7NhXp5u15WLtAlu57IUJc8Nnon3QS?=
 =?us-ascii?Q?vnHh4SIxLI2xgP1brb/Dha5265xmmVRAvdeRlXXD4Gq+rnguxWKyNMFzlvrT?=
 =?us-ascii?Q?BP92zjWy1LF1O1u2/H3wM52YztdJXF+WZVX0LiM6obh3RxOznDex4dNTdg8W?=
 =?us-ascii?Q?3MMlHC/3/O6OlgqjZFy8hot7fG6xgo/2a8upqimecmZ/Vmz3XycZCy+yp8hx?=
 =?us-ascii?Q?q6N2HBsig036X+gySu7NRBoBwe5mHlQra1qXvY4L+c8vdb+zr1/dSrxAVvRw?=
 =?us-ascii?Q?Vk0y72cYZ3jNJrjSYE+s1ebK/k84nuWWjjLg27bnyo1aUGbT3Idkh25ShQF5?=
 =?us-ascii?Q?g8U3cMZ2NQHhZsLIu/YiBuDhplF6RPrW9Boa5XqKJt+Ht1F0q16WYp8zG3gl?=
 =?us-ascii?Q?GBx5EaCNqMf15HtfI6Qr5qEqVvlVS52FPwn175fAYouJnxkoCFHxlGqXaTIU?=
 =?us-ascii?Q?poBCf2qMORvassNub1HWOLgLLnvIHaoWYx0YetRIede9gd6LVW20gALvQRzv?=
 =?us-ascii?Q?FIY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20219bf8-eb66-4016-6c8b-08d960fcf43e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 21:29:39.4197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8CjW+ckA7+kb2nTzMTbIm2xnwtmKivH+qMMbbGpXyKnAmzc6+kc0Pf0ncPSXpM8wYSxT5fuO3K4mM7QsSz3+t6bXDe6IEIXPzeVE9VGxxAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5154
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Saturday, August 14, 2021 2:58 AM
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.o=
rg>
> Cc: Leon Romanovsky <leonro@nvidia.com>; Guangbin Huang
> <huangguangbin2@huawei.com>; Keller, Jacob E <jacob.e.keller@intel.com>; =
Jiri
> Pirko <jiri@nvidia.com>; linux-kernel@vger.kernel.org; netdev@vger.kernel=
.org;
> Salil Mehta <salil.mehta@huawei.com>; Shannon Nelson
> <snelson@pensando.io>; Yisen Zhuang <yisen.zhuang@huawei.com>; Yufeng
> Mo <moyufeng@huawei.com>
> Subject: [PATCH net-next 5/6] devlink: Clear whole devlink_flash_notify s=
truct
>=20
> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> The { 0 } doesn't clear all fields in the struct, but tells to the
> compiler to set all fields to zero and doesn't touch any sub-fields
> if they exists.
>=20
> The {} is an empty initialiser that instructs to fully initialize whole
> struct including sub-fields, which is error-prone for future
> devlink_flash_notify extensions.
>=20
> Fixes: 6700acc5f1fe ("devlink: collect flash notify params into a struct"=
)
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Yep, we should have used {} before. Are there any other misses where I used=
 { 0 }.... Nope, I just double checked. Ok great!

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  net/core/devlink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index d218f57ad8cf..a856ae401ea5 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -4169,7 +4169,7 @@ static void __devlink_flash_update_notify(struct
> devlink *devlink,
>=20
>  static void devlink_flash_update_begin_notify(struct devlink *devlink)
>  {
> -	struct devlink_flash_notify params =3D { 0 };
> +	struct devlink_flash_notify params =3D {};
>=20
>  	__devlink_flash_update_notify(devlink,
>  				      DEVLINK_CMD_FLASH_UPDATE,
> @@ -4178,7 +4178,7 @@ static void devlink_flash_update_begin_notify(struc=
t
> devlink *devlink)
>=20
>  static void devlink_flash_update_end_notify(struct devlink *devlink)
>  {
> -	struct devlink_flash_notify params =3D { 0 };
> +	struct devlink_flash_notify params =3D {};
>=20
>  	__devlink_flash_update_notify(devlink,
>  				      DEVLINK_CMD_FLASH_UPDATE_END,
> --
> 2.31.1

