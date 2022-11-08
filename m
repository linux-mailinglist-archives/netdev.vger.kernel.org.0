Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA2F621DFE
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiKHUsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiKHUsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:48:02 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943A0CD
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 12:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667940481; x=1699476481;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DcFAZ9mG4NHZd8b6RbsKd8cp1KiWMGacYbHrX8YCUMg=;
  b=fRJ4yUHBfSWtOYzUbSeEqrRIkTY2rx3SOFYz6JXHn+rKJ8LAkQNS2ygv
   SYwV995G1+QF6oZ7iMYa7l8hl4C/g7+AsJNv2l6+X3Bw3iI+WoBl9vkxp
   sDvvA8+JikH5lbPsO9sbC6mZfXeS7s+XWy6mKW5o7+81aEc56QIzToGot
   XlPLyYQMNCEPL06xMOOPhFKQ+n7WcdnitrCntX0kC65/eul+y3oJTBlJp
   8Oc6qj0r7Q9AMR/6fB+JfT4h1nghwrcf3uNFDdHJ+9ARNje+lCp7HKp2S
   WhjNRd6z/TXYayjjitEZhsXPY7GLHaXaI7Fw/KE6FtWJdoYdZEHo0Cimh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="337536970"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="337536970"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 12:48:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="614413168"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="614413168"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 08 Nov 2022 12:48:00 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 12:48:00 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 12:48:00 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 12:48:00 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 12:47:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JqhwVU1jNmiEIEolU+F3nw6sbqQiscRxFP4gJrh0FyoicPKgobXJ5Q205uR+7GXTwRAm+5aTg/oabdQvV3/t+oHqe3EL4B6QE04D4pUzlLqHEF0b0s6FFvp/n5b8jgnHUPjCIUrVqz1CFKgTnNE7Kg6OWIDbkftAXy5yCsbn0AO3K76WdcMz1LSsH6j2fWIg1IHiGLc/nLUwc4nLe5UA1Vy9kmLmJyAcFDBLKUaW5FySBhT1dw9PBsEx6NUifd617sA+OgYrJSDy7hBMD64RjJH6HcULjk9hyP5xM7KDgxWvc7xy0n03NAixew7ZkYvHfV/MR+caA7vIAYzhEH23aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCo+xHNKQvF7wfAJAetvnqEvzZhiDKyazWNYWzNna/Y=;
 b=Yu3PRKQmYDRGwKl49Y9oLB83nKI0K4vz5X7dqo+lt9IgvpbJ8PGncN746dQs6Y3IjXi+fcmBvissdd37treNW8he87J/eAc3d9bRgaLbPnt1BZiEXb072ZiYrXjPegUHHfHTgL67gG/NVI14B9D8662GE5Hwh7e7gnlGI9vOyFZUFDQl38UyQT2dagBu9EQivsQpeuf9vvknVSdzPuoElHIoFwlHvQLQlENHeFxA5Rz0oMrUnJUWF/RcUh9j8KU8BnJvrHthFUlWAIv52uEvcH1qdMGUOFwtvSKwJ6+Icp+NG/tZ4+0KgsrGn/34YXfI2+5fZzgMwz+dMkAn9yr8Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW4PR11MB5775.namprd11.prod.outlook.com (2603:10b6:303:181::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Tue, 8 Nov
 2022 20:47:58 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 20:47:58 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Jonathan Lemon" <bsd@meta.com>
Subject: RE: [PATCH net-next] genetlink: fix policy dump for dumps
Thread-Topic: [PATCH net-next] genetlink: fix policy dump for dumps
Thread-Index: AQHY87J3PJ91FsvdGkawuKDY7cP1mK41fsCQ
Date:   Tue, 8 Nov 2022 20:47:57 +0000
Message-ID: <CO1PR11MB5089F3CECB59624025A648A3D63F9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221108204041.330172-1-kuba@kernel.org>
In-Reply-To: <20221108204041.330172-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|MW4PR11MB5775:EE_
x-ms-office365-filtering-correlation-id: 03a438f7-132c-406c-2857-08dac1ca84ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HEXtAUu+/T2FRsv8ruKlBUzvkBA3AemvjEqz9aA5NSLy568Jtrh7QFjtffI1SI+t65IfWX6l3v5NWcC0ZOKIVoTh3+EehMVRq17HA5CdjiJ2CVEOP/nTRORsFB4QfISfgVsmH5xRkceWIsy3MZV8C1kLkqcha88oUy656f4euf0TdkstiRZZNSf0BdovaxqUY492b3qcZuKRc98S6MLrErRJ6CIUKhn8VRrSrtpANkkhOpPdmu/wlZ0U5doGaxQBEBFYnoNOAGsLUFI1+GzVETjIj/VBAltEeOX9OlM/QuPajOsRu3PYvOSMv2mj4cw6XXKZG7744lDrH5VdZ9LvBVRQuvdAXV1PLs3q5S/4brpZjdXGgeuCbE+WuVsYE7LVJIBcY5ooDn84TqyKvcfQfSsng5FgBMTuSC8fYaX5jrTUiMFn5YkdMcEpcmyoVsNaAb0tW1z6fp/FNNcoQ7ACwK4fNEXawkvsoKmUa06qQeOMULsKvTLpD0OaXC8f+lLuVzEFyDzmrM03IOXsLP5MuX6q93tYWDiXcczoyeS4/+8fGeI6FMI8BircJHLR0ttuPh1ksNqQRpJT0NXEh49G6A/hp/h9ObJHVdrhK/wLh45aiJD4XFdOWUEjQC/0YrQbHlY3ZOM0Aj1fraEfDgd5qwZuMX+mEDKjBpVuM0itiMM9LmcnCKTPhfrJaaPANmN3iskQrSQosDjAbt6ANotigu4GlV5/7HMTAAlrBsXZLjml9j9vaa4NbGvBHepOM5GgwpvFY2kMt76tDBizMtYMq4pmIeAMwrqqvpH+GNiPyL8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(376002)(136003)(366004)(396003)(451199015)(2906002)(8676002)(41300700001)(66476007)(64756008)(76116006)(8936002)(66556008)(5660300002)(66946007)(4326008)(52536014)(66446008)(110136005)(316002)(54906003)(478600001)(82960400001)(86362001)(6506007)(26005)(9686003)(7696005)(53546011)(33656002)(71200400001)(83380400001)(122000001)(55016003)(186003)(38100700002)(38070700005)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Wenc80T0PYKuZiUq5NH83NxkKxoxX0YpNhUnj4bWf04PYpqazRKMZm/fBC7b?=
 =?us-ascii?Q?Gn6p1P5xQSQaN7IuqleTTiyde/ugkDK+nAqmQRoXQe4zX0BUQFjtKvgQacKp?=
 =?us-ascii?Q?4FoRjPELoZn6rlf7w/p7jNeqJGHyHL7DRnk/L/1oAXbQQrz9MCzQKp0ftFSB?=
 =?us-ascii?Q?7lqALW2POV9mp0S7A5MOznIOQfhWtUZsoivAzLFwsOMVGkr8eubwu9kjCgUQ?=
 =?us-ascii?Q?3Mjx/aIINR05LkgLI24vuHILcZNvIesxl7IvdWgpefBN7ChwyBtoNnX0oxeb?=
 =?us-ascii?Q?60wyOSoOwxaV70Mcnxksrsb6w/qvOgDxMcbVuJVBGPBup3vfnaSdKWuLu2Pn?=
 =?us-ascii?Q?bxUpXeo5T6B6HH5ADBIjdjFOeV/bIok2LWEjzAlDEcfZtUSamsfBq+xuVW1V?=
 =?us-ascii?Q?uypYPhaKTn4FJjDAgdt97+PD+H2fuPQ7i13/S/zBmZANtgZ8YgM39RdJ792L?=
 =?us-ascii?Q?d1tYM+d0Shm/WxWQ65zwq52WDToEs/YNNMY4Ze6xlJS0fNe0Y2ojL9SIcwBC?=
 =?us-ascii?Q?JC70rqTOCLSTgctP1SWjdjul5Z5Ul5d5vJIXBa0H0RKFGz+0H0bCWVkbRMlz?=
 =?us-ascii?Q?WMBSiHzZcupLysJ6vOAw5CkYImNHY7/BMA3KqO1D1El694QqMDOJwWt3lu62?=
 =?us-ascii?Q?Hd51mU9VzSQdGv6dJO2uJTH7BrD/Uxc/AHwUFF8syk6fvha2YoNXiTvY+F9p?=
 =?us-ascii?Q?2QoWZrFFesIpb4SSprI7qeJ1HGK+YHzrxQAnXA9qM3ZSeqGQrB77Rks/KR4E?=
 =?us-ascii?Q?thMzl2AK419kCStY9X3NjWl/NQj+SQU0/3QG9r8xheFt24+pFnW1/n5X884u?=
 =?us-ascii?Q?w+qz/zeDs41mRb52xMN1AX7up9pGnLVBGUzponVJw7jApHZH6po8PlBd/o/1?=
 =?us-ascii?Q?6ZpZxqyheRX18FCyqVAPzG9VzunvSBU/6sxQg99zMymSpeU2hp7UvgAj5+gz?=
 =?us-ascii?Q?IxX2mBeLe8FRXeQNG0G5x1LMyx/Ge0q3SSMmLkcZLlPxyan+MroWcLgZ96fb?=
 =?us-ascii?Q?2xLJd0incap+GPcUn3SEExpxozzP2QhWJMo4h9h9qygMVksYsM5cruFeIFMe?=
 =?us-ascii?Q?JCSmAu9P6rsGXuPYeZ0dmUNcZ1McsxK534sRjOF7qdyziycbOeicAU0UHNmQ?=
 =?us-ascii?Q?+4DwbgV1hxVqLt5hrfViv4Pf2nuvLKbqTKfq/jJQaCrB+B4YODPrjyu8D/ok?=
 =?us-ascii?Q?YFYzrUs+NBXvQyBvKVi3k4bIppM/n7In6VFTCXTB9QqGceMrzWQUSCl1k5EI?=
 =?us-ascii?Q?eVFwkzLi4dMFeTdsLr5cdy6DlXZlFX7+Xr/fOHKp/Y9RcxyLfxVxOm5Hn6Q8?=
 =?us-ascii?Q?l5qGPATxZxRF60k/PF3KPKO2V4jJpkwqhPlYkAo9BxLGTHHEQBPekzbAKkUQ?=
 =?us-ascii?Q?FObYhqjWPyZiH1dxqTIoTcbblcN+i3+QtYTiqp9kYk3hq6RPVg7JUyP0GV2j?=
 =?us-ascii?Q?SjY9uVUqEei34MULXHg39AxhPFIJSl6jAMfgmHAIolpw8Kun4FrTMtHtd4nG?=
 =?us-ascii?Q?G2Ji2Hs3zZKa+pl4cmujGQjFqJcNtdJdNoG42SX8DduH15NPgTlwgs0ndg46?=
 =?us-ascii?Q?QhNDBTsHhvRbLFTUE/mHjVysWyHt+ozmqpxQaElg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03a438f7-132c-406c-2857-08dac1ca84ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 20:47:58.3879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bPOMRuwbJ0nnXUf4Fo567qhpKNzNDZ3SZEtRcBkGQSwhVrZehsntLMSUsm64YiHomxLBzOK67D4hCBDf65pJbjGT/Qn8sv7FZqrUl02DsSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5775
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
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, November 8, 2022 12:41 PM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; edumazet@google.com; pabeni@redhat.com; Jakub
> Kicinski <kuba@kernel.org>; Jonathan Lemon <bsd@meta.com>; Keller, Jacob =
E
> <jacob.e.keller@intel.com>
> Subject: [PATCH net-next] genetlink: fix policy dump for dumps
>=20
> Jonathan reports crashes when running net-next in Meta's fleet.
> Stats collection uses ethtool -I which does a per-op policy dump
> to check if stats are supported. We don't initialize the dumpit
> information if doit succeeds due to evaluation short-circuiting.
>=20
> The crash may look like this:
>=20
>    BUG: kernel NULL pointer dereference, address: 0000000000000cc0
>    RIP: 0010:netlink_policy_dump_add_policy+0x174/0x2a0
>      ctrl_dumppolicy_start+0x19f/0x2f0
>      genl_start+0xe7/0x140
>=20
> Or we may trigger a warning:
>=20
>    WARNING: CPU: 1 PID: 785 at net/netlink/policy.c:87
> netlink_policy_dump_get_policy_idx+0x79/0x80
>    RIP: 0010:netlink_policy_dump_get_policy_idx+0x79/0x80
>      ctrl_dumppolicy_put_op+0x214/0x360
>=20
> depending on what garbage we pick up from the stack.
>=20


Oops. Yay subtle bugs :D

> Reported-by: Jonathan Lemon <bsd@meta.com>
> Fixes: 26588edbef60 ("genetlink: support split policies in
> ctrl_dumppolicy_put_op()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jacob.e.keller@intel.com
> ---
>  net/netlink/genetlink.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 9b7dfc45dd67..7b7bac9e7524 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -1406,8 +1406,8 @@ static int ctrl_dumppolicy_start(struct netlink_cal=
lback
> *cb)
>  		ctx->single_op =3D true;
>  		ctx->op =3D nla_get_u32(tb[CTRL_ATTR_OP]);
>=20
> -		if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
> -		    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
> +		if (!!genl_get_cmd(ctx->op, GENL_CMD_CAP_DO, rt, &doit) +
> +		    !!genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump) <
> 1) {


A little bit tricky code here, but it makes sense. We could rewrite this to=
 be a bit more verbose like:

doit_err =3D genl_get_cmd(.. GENL_CMD_CAP_DO ..);
dumpit_err =3D genl_get_cmd(.. GENL_CMD_CAP_DUMPIT ..);
if (doit_err && dumpit_err) {
  ...
}

That might be a bit easier to read than the !! ( ) + ( ) < 1 notation.

Either way I think it looks correct at least.

Thanks,
Jake

>  			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
>  			return -ENOENT;
>  		}
> @@ -1551,10 +1551,10 @@ static int ctrl_dumppolicy(struct sk_buff *skb, s=
truct
> netlink_callback *cb)
>  		if (ctx->single_op) {
>  			struct genl_split_ops doit, dumpit;
>=20
> -			if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO,
> -					 ctx->rt, &doit) &&
> -			    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP,
> -					 ctx->rt, &dumpit)) {
> +			if (!!genl_get_cmd(ctx->op, GENL_CMD_CAP_DO,
> +					   ctx->rt, &doit) +
> +			    !!genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP,
> +					   ctx->rt, &dumpit) < 1) {
>  				WARN_ON(1);
>  				return -ENOENT;
>  			}
> --
> 2.38.1

