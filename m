Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C78F63B15D
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbiK1ScP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbiK1Sbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:31:36 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C45BDE8B
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669660070; x=1701196070;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5mugxkauDE+vfQ3Oh/CJIPXo/kLrc6YBM/gOFy1nGjY=;
  b=Dy1pyQIfnzPVdZSae845uSng91xjC4H4uWJY/r3sRpaYrbc5w4+2v469
   GGJBY8b5BnaTp+vUPid7zP0OwqLRQZhY5BLUWqe99/iSm686i8igB5t/+
   DAEU8kNGShscxfKDofXTE+u4NLpzUc/fnnHHopjLCxa133gDuSU667xQB
   fWU5Guigxlbu1/hMOIwZxkQcz0fah0Lbxw8+qWS7BwBHfdyM0q+WHGdDy
   znqPkeWo6u6DZ3tOwCs55g7JwV9BShYDg1jThXXW3vcKdr7JcgPZpmUNq
   Ir43o6dcGieeuQyxUN5tQEAtj13EujGYRDp1rpT76uYScFJT5De5Gigtm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="341828771"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="341828771"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 10:27:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="817925271"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="817925271"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 28 Nov 2022 10:27:45 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 10:27:45 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 10:27:44 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 10:27:44 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 10:27:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdppfV2rM9l6rDX45NwfsomHBlD2UMJOQbaUWU4pgzemUVZ39bzSfAdp1IyrzsPkVckIysbXy4+80yi5vjKwjqJqnhJFgBSyjZ4mFh4TiKeU9c0ZgBzb+3z0RSs3Hoys+n1C7siT2F6ioj618ioyQfNR+SXq/2y3p6QLCPp601/mGqmhWAdJsyKEpdP4rn/0w52/Z1D1xjvd+Ulahmdw8RudzXXVTCkn1kwyWfNdaNC//zss2C9k1WPkyCB5ZOtNat9x2uYuiUvW0gIXLO6V6urqCcrNL0zh4MEWs9A71xymSpZUEqcCsgISIXBoRALg1iGFV+YnjME9qKhxJr0eNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIGKhqTq24i+0FKSty6bzNhQP42lVxALRYKBnP4mJ/U=;
 b=CKtPGMjYIjc+w43Q1kgASBENpHe4D5EX8mv4wEJVfyHR2661WfiftXzw+0tlt1webEYUxOgVikTEJ9YodgEoxlfKKqox7vtbmAvZp7xlTZzsx9jc7fZ3HLEcRIKfJmht6ZB2OEiwl9LQO5rgWrqhiMohnw6JQYLeryTjGL3J+i8qY/vAFhSLA1xzSFoW6vfi2zeN0FH7s9CP2U+CWZ2heBU3HCGiBltlBrQjoFTKvsMLcdYD+k8L5hmpTrcUoE153nsMcWtX4NEn8Bn4sd7OcpjAtcHTWcVY0sLaPLoK/GCJ42x3vfLxjIoooZRPwA306VojXH+uhCq+20wxt+v7PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB5063.namprd11.prod.outlook.com (2603:10b6:510:3d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 18:27:42 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 18:27:42 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: RE: [PATCH net-next v2 5/9] devlink: refactor
 region_read_snapshot_fill to use a callback function
Thread-Topic: [PATCH net-next v2 5/9] devlink: refactor
 region_read_snapshot_fill to use a callback function
Thread-Index: AQHY/3uZ2p5u0lMYtki/9oMA3wzSVq5NyriAgAbitOA=
Date:   Mon, 28 Nov 2022 18:27:42 +0000
Message-ID: <CO1PR11MB5089966656A01AF44BD6F17ED6139@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
 <20221123203834.738606-6-jacob.e.keller@intel.com>
 <Y381byfh6Oz6xKBD@nanopsycho>
In-Reply-To: <Y381byfh6Oz6xKBD@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|PH0PR11MB5063:EE_
x-ms-office365-filtering-correlation-id: 713d55e3-4473-4413-ecc0-08dad16e3caa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hkd6J4OffJsBOYA1EXcTukzcPKN8wnUX0jHyrdgUNHTWq2VD1XRM7d9gEz23h/0iCOtLf8yZWyqD3xntHModqyVhHcZpznTI+FXzMBYEqkBDXzfm1Fi7XpJcIfd4csY3jHuluavaGw0smEfetjvfp0ZGVMCtkVq/C/fmSXHMCOVkrf5hmDfL44ucW48VOrxtPprBqXeHx3mVT8tvlYOnSoUoym0Kbj/QKA77KiB85BYfjA3PHPXpKp5x1gj03ysXhfAzG+JvmNkbm2qsucRrqIV4c77Z/SVAQuj8wqrRF+IKydwcWufLbLiW1HoDDbWERUIZl7vvL9UqMhKsONssk8p2ZLB5t9C05WZRsrpA1kadL58HpgmXZXG6PiN0K+6NxG/j2aSwYTtnpxPWFcBf5W8g+ud4zD+zpZxVwUv33/ZCaDJGYN4LcoKNi8RfOFT9dSOB5tEKMQwl/jcKR23Q5IiXQlmDBTbbJc455GUWPxA15zOwi1TfWEWuGj/W/D94hXcgFrwvg0XxcWA6XQtQhXYwXXC2Ba6MO0YtIa4V6DF5dxmxwxycnrFa0BnX08ogOADKFG7N/j5Mp9Wow03IwLYMmt4SOseMZjlsAm7NLke4fFU8ywf8ZS6a5C8M1JWA+MbBLJLSf/gEwZ7jDhU2jOpfyOSgerV7CmwtiBg9E/dxPMjTjyaL3a51nnE4B85lAKGN2SJJ7KUdX70HnEl9Yg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199015)(2906002)(83380400001)(7696005)(64756008)(6506007)(38100700002)(122000001)(478600001)(33656002)(66446008)(41300700001)(66946007)(66476007)(66556008)(76116006)(8676002)(71200400001)(53546011)(82960400001)(9686003)(26005)(5660300002)(8936002)(186003)(4326008)(86362001)(54906003)(6916009)(52536014)(55016003)(38070700005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BBPWPB7ARDFrMWO950j/DFJW0DQaPAEaU4m8SzSMlExUsAtOkDVgXigh/fTw?=
 =?us-ascii?Q?rydH6fyJjkRPS7mIdaDRxV4QS/MzOXhYXNp4Il0L0mk2g35H8h4XEAA7KDBn?=
 =?us-ascii?Q?cG68rDwrR1tgGMsU04tqOwbfH2tevIou+eMN8KsugVixIBhs5tN3Xz042yUi?=
 =?us-ascii?Q?RJHOdI7JCr/SYElru7t90EcxUK+8ubrr4ruTa+H4MTL0x3H/bN3OEZK1FHTp?=
 =?us-ascii?Q?Yz/zllnfoMad9b7xX+C3F5GcO0btD5RixjGEEq8p9sK55BXxeKSSSrx3NW+P?=
 =?us-ascii?Q?Qimb1Bok26MusnKUjzG0ezzb0k/HlGimWm7bESm/d8JBd4mv2TOVzsPoqotM?=
 =?us-ascii?Q?FZRtUBv59ouCnoBN26LuogLAcA0fuj/jzHbTX4BiLAT6Sb1cGzFz0z1O3Vgp?=
 =?us-ascii?Q?AolxyobKEuXjmic97/USykVrEK1+Ppe5MrfXZuLqxNEYMn+YeXyv9qGYJat6?=
 =?us-ascii?Q?ofrcYoigtPfur/JLB2nUYfzXgf0JdITdELh8A0+k/u164WH/1WlPs9A/IwAe?=
 =?us-ascii?Q?nanCMdt+OEv0LM1hkZS4FmuPkWqtLO+Igw2tk7QXkJz+NDDyO7bvRGoHBIas?=
 =?us-ascii?Q?c7mCISV7gPjWWmnzBQRIn3TAvAM5rIhElnHlcn00krvjAxV+h1rU36L0PvtQ?=
 =?us-ascii?Q?d8lMW8wXqSJKRqRcHZ1vTu5yU2LJQgn8gS8o7xS4uAHNm6heqDSDPbyEbBjs?=
 =?us-ascii?Q?B4ag+u3WzL0V6rAbgWEgJeG6O9aw/Bhyi1SAjglanp2EQid/mBynjkBgQt4t?=
 =?us-ascii?Q?GYx2tGa4F0xcQSGSZONyLRfuUHSiPNe/G7JnCyPY4Y2435u4l2wAp+dONjB9?=
 =?us-ascii?Q?LhYOSeiM+f9ixr7RSsL4ig0U7aozPzF2rnu10OuTp+iuTaYbk53EzweD4d+P?=
 =?us-ascii?Q?2nAZwqxEGUbj/MWe6jYN/9Sahq8gBgxhz9IEY9K6uy64g3UtxIcic9jIX7A1?=
 =?us-ascii?Q?HQqrsHd3Jq7060BccB0IPMtH5e3/4KSOLeJtiBEWrXHpkO67JSa0yC/PhMue?=
 =?us-ascii?Q?LODEBjh/ai4f1pTKGoiy0oPu0BZ0pHF6bAZteO+FGkFeqi4G01LjZmJKjyKf?=
 =?us-ascii?Q?8kQfNtrsR3u1uj+7NYz459QIv0j9Pja691wm5u1pCRNmN7MASPxYYJByfRWn?=
 =?us-ascii?Q?WKdzCpOpsi1xeVuanmUI4z2mmEoaOqZsQHwJa6DPltNNIl8mUaX27N4ZN6Fj?=
 =?us-ascii?Q?umf31ppmIvzB3VtLIxLR/eVG20dOBA1JXcQEJeFWbk5kSS9uyFLTIho1UMiE?=
 =?us-ascii?Q?kUghlO0EXQCWREOxNkzUXy4OlwKB1wkyXeXbLTiB7CMzYTN85qBf7Gnb763S?=
 =?us-ascii?Q?/oFjnJt7e2bHWFw14CBoP0uIB3OGTPBAEb8r4ASOYRy+fmbihnYbkJ7AiJR+?=
 =?us-ascii?Q?0b6+zAmM4UrQvM80GR6mr8yJBqaUa7PmLYxJLke+5iotDNfKk7KL8F5+ZV8e?=
 =?us-ascii?Q?u8B3p4bCRUOb+L5OVlizje3lp/4Ibz7KRap7AjbUVwYkgxDtI8n1ed59yXIX?=
 =?us-ascii?Q?t1iSmkNnUO8Ia+FIsTnF0Fbu+2L53httwfIGBzTRLO+QjOjBHpQ2i9wzjGWr?=
 =?us-ascii?Q?eVcTJuU/xT1R0Cel2ojPbkIJqHCt+V705k1fzs8h?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 713d55e3-4473-4413-ecc0-08dad16e3caa
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 18:27:42.0320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cxY9h5Iy9Q64f0JP/Qoz8Patf7sqRquYIzeVrjMUxsuNpZF5BZa3sdIYaOBsd7JYlqYKfLnkibQF29QCV+VMvDyKJ6oBNqsr0d24omWm+ZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5063
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Thursday, November 24, 2022 1:12 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jiri Pirko <jiri@nvidia.com>; Jakub Kicinski
> <kuba@kernel.org>
> Subject: Re: [PATCH net-next v2 5/9] devlink: refactor region_read_snapsh=
ot_fill
> to use a callback function
>=20
> Wed, Nov 23, 2022 at 09:38:30PM CET, jacob.e.keller@intel.com wrote:
> >The devlink_nl_region_read_snapshot_fill is used to copy the contents of
> >a snapshot into a message for reporting to userspace via the
> >DEVLINK_CMG_REGION_READ netlink message.
> >
> >A future change is going to add support for directly reading from
> >a region. Almost all of the logic for this new capability is identical.
> >
> >To help reduce code duplication and make this logic more generic,
> >refactor the function to take a cb and cb_priv pointer for doing the
> >actual copy.
> >
> >Add a devlink_region_snapshot_fill implementation that will simply copy
> >the relevant chunk of the region. This does require allocating some
> >storage for the chunk as opposed to simply passing the correct address
> >forward to the devlink_nl_cmg_region_read_chunk_fill function.
> >
> >A future change to implement support for directly reading from a region
> >without a snapshot will provide a separate implementation that calls the
> >newly added devlink region operation.
> >
> >Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> >---
> >Changes since v1:
> >* Use kmalloc instead of kzalloc
> >* Don't combine data_size declaration and assignment
> >* Fix the always_unused placement for devlink_region_snapshot_fill
> >
> > net/core/devlink.c | 44 +++++++++++++++++++++++++++++++++++---------
> > 1 file changed, 35 insertions(+), 9 deletions(-)
> >
> >diff --git a/net/core/devlink.c b/net/core/devlink.c
> >index bd7af0600405..729e2162a4db 100644
> >--- a/net/core/devlink.c
> >+++ b/net/core/devlink.c
> >@@ -6460,25 +6460,36 @@ static int
> devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
> >
> > #define DEVLINK_REGION_READ_CHUNK_SIZE 256
> >
> >-static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
> >-						struct devlink_snapshot
> *snapshot,
> >-						u64 start_offset,
> >-						u64 end_offset,
> >-						u64 *new_offset)
> >+typedef int devlink_chunk_fill_t(void *cb_priv, u8 *chunk, u32 chunk_si=
ze,
> >+				 u64 curr_offset,
> >+				 struct netlink_ext_ack *extack);
> >+
> >+static int
> >+devlink_nl_region_read_fill(struct sk_buff *skb, devlink_chunk_fill_t *=
cb,
> >+			    void *cb_priv, u64 start_offset, u64 end_offset,
> >+			    u64 *new_offset, struct netlink_ext_ack *extack)
> > {
> > 	u64 curr_offset =3D start_offset;
> > 	int err =3D 0;
> >+	u8 *data;
> >+
> >+	/* Allocate and re-use a single buffer */
> >+	data =3D kmalloc(DEVLINK_REGION_READ_CHUNK_SIZE, GFP_KERNEL);
>=20
> Hmm, I tried to figure out how to do this without extra alloc and
> memcpy, didn't find any nice solution :/
>=20

I also came up blank as well :( I can take another look when sending v3 wit=
h the other fixups.

> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>=20
> Btw, do you plan to extend this for write as well. It might be valuable
> for debugging purposes to have that. I recall we discussed it in past.
>=20

We could extend to support writing. I haven't had a strong need yet, and I =
worry about the potential for abuse of such an interface. We've already see=
n examples of people (ab)using such interfaces for unclear purposes...

Thanks,
Jake

