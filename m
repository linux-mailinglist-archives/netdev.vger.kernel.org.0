Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C112B63189D
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 03:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiKUC0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 21:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKUC0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 21:26:44 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EA22AC45
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 18:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668997603; x=1700533603;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ji7Ov3RIt3dU2+30hFwd4lIZzhc4lCx33bLWkP/OYNE=;
  b=JMO0beF+xUfoDzxXm2o84lnzOo/iXmRUODfzMR0e1+MecZNJBgiu/7j5
   ZpZV+FBS4ZyBVtczj6d1Zf8o98UB16N9Hql9pVG5AmCdbBcCvNAmJXkUl
   W3JeYt/BiMOM9rYFK+MnPp0VweiBlFDftAP0ZQ3zmqgfw4rMZ+eEKoTGZ
   bx2aId2pqBAjAK62cq1c/09ot6lCr1hdLWcHwXzfuj1p8x/WB29mOTRAd
   zfOXSc8Mfh/TEVPrltN4WstDGOequ+EPfTtx/Ip88UPwwldtNDkkx0mI2
   eGiSbH/ZIztlxUaImAWxX27hW3rWvgTOKTm6VdldkSGy/xIvKUzOojNbK
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="312159169"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="312159169"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 18:26:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729846423"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729846423"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Nov 2022 18:26:43 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 20 Nov 2022 18:26:43 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 20 Nov 2022 18:26:42 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 20 Nov 2022 18:26:42 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 20 Nov 2022 18:26:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DywNrrRJonDGc2h64lZRQNrE++ZsESfvApaBYj/uJVJXwqCHBAy1e9Ytbyi6zTo6qKRUld1N5G2MBz7aO4oRQcafiqLsS7Y0w2GpBfe7FEbZI0XP+COi4KxJbr+lsKFxEFI1QKVuSmtNmMj30DEDdY6yvzaLpn/Wztd2QYG3lLIU9m7AsIm43dcx8nnFZxud1xAGch11tbmGtXsoqe2jGRitNBIvF+bnZrds2OHuCgb0qKPisGK30une3RwgZKLCY3HKfZyA0i8zn5oVgNexlD0AM/WomsRjaLnvGKppxHAIFvzQqa4+jANqn5RqOzWHfX7rLd06RDRkd8sXbszJiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ji7Ov3RIt3dU2+30hFwd4lIZzhc4lCx33bLWkP/OYNE=;
 b=c6QvQUxuzU6vO2iguaSUqkdxBa20QHdc+ZHKj8b9fssW7evtwM/9cImxtR5jYRL1DRonWd6ntHw3TFPGsDtrLp6opWMar2A2Oy5idhxEGvIVVl/j9nASFstGdq/IzpplhF9kwangaRCBZiVO5eVROK7PnIBT7WRmaZonojTTk/QhCvfPt7AcmavJmE5AWqAeualuRyDGWG9ku0sbXJ0taipYF9LcfXcdxyyBIOJnCClPK0eZWV7JD+XO797m2YpmKQV9F4yaiUYUVilmuHXILnowvzI09XvIHTAxKrl7EFCyYeo2yyzfWt2jOVTD+5f5HPHFfgXMyWyS+rR004Dwnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5093.namprd11.prod.outlook.com (2603:10b6:510:3e::23)
 by PH0PR11MB5805.namprd11.prod.outlook.com (2603:10b6:510:14a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 02:26:40 +0000
Received: from PH0PR11MB5093.namprd11.prod.outlook.com
 ([fe80::7449:6c17:695f:83fd]) by PH0PR11MB5093.namprd11.prod.outlook.com
 ([fe80::7449:6c17:695f:83fd%4]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 02:26:40 +0000
From:   "Lai, Peter Jun Ann" <peter.jun.ann.lai@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Jiri Pirko" <jiri@resnulli.us>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Subject: RE: [PATCH iproute2-next v1] tc_util: Fix no error return when large
 parent id used
Thread-Topic: [PATCH iproute2-next v1] tc_util: Fix no error return when large
 parent id used
Thread-Index: AQHY+kYkjHECN9jx/kqbi17k/Tfs+K5DULKAgAVa0+A=
Date:   Mon, 21 Nov 2022 02:26:40 +0000
Message-ID: <PH0PR11MB50931D530F53E85C828FFAE2E30A9@PH0PR11MB5093.namprd11.prod.outlook.com>
References: <1668663197-22115-1-git-send-email-jun.ann.lai@intel.com>
 <20221117083537.6aceb759@hermes.local>
In-Reply-To: <20221117083537.6aceb759@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5093:EE_|PH0PR11MB5805:EE_
x-ms-office365-filtering-correlation-id: 47831cfc-0b07-4472-9132-08dacb67d302
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fjqIuatVrI6Cq4Yy/UkxefxMqWlWQEcT5lQI2w4+Pme9dapwl8EgWG8Edhs90X+GqFiUj3AXSood+oOswFrzbCNskbvDYvdE7VFg4wmtHhyESiX6thvul3bTfEqzliEoLZ8Kq1PY74dlFC8ZpKV/QywQConSLuRpa6cHcW+QwTYXLqyb5d2ofwoeoZJzIhfekGKbdlh7dkk63aqGC8V/Xd/ENZVUR9jNmWTrYb7NajTYYVCVQC9tJxkClA17PCquKk96HCiylb554FO9RU+34D+kTUbSvsfBBLZAqrqIpQ52k2IHKIjpsN7dRYuaZSf6xOLnhLOQ9ZPKoQ8ovsdEVxIHum4UN+1126Y4lPXmPlLOXFt2+MsIv5W2b3oTsqfJgVmSR8El5PE8n3h+8F5rRg2R+WI5XVZwq1ZdSw8NbzjVTBmmMt3GeU1aQ7sIaxIx83q8s2vAjIU+MGQH8EVHdeUFmITZLHJA+PkPFl/EoHNnGQeRADuaQPm6IAXqVIvieggC89qasAE4WSxbd9fHhzeH6lSYBoIXd9DGQyCK4dStrLtE8SvZ+acuOWXwCM1oAkr5bGJ3fYgVaqZwbEPSCJva2P7wSCWJAbT8lENldOMKp574JE99iOKYSg1LFPMy14PqoR/QuVGH80C4Y8jh1RxGn6MOLNZ7v8qpHu8KvcnIK0Pi8MU4Uuv+i6Mu6TFx2a/SnHdW1Hu74myoBvfAow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5093.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199015)(33656002)(38070700005)(86362001)(7696005)(64756008)(76116006)(55016003)(5660300002)(4744005)(2906002)(26005)(53546011)(186003)(9686003)(82960400001)(38100700002)(122000001)(83380400001)(54906003)(107886003)(71200400001)(52536014)(8936002)(41300700001)(66476007)(66556008)(66946007)(66446008)(316002)(6916009)(478600001)(8676002)(4326008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qYODINvhXibNHOwC/qYMZVy0E93H02X2PhxD62djMWsvUTS8B/APHmOodl2B?=
 =?us-ascii?Q?VGrCleyzQaaa5pNZp3c5viebJ1Xbl5dJzwxkwhaD2WBoXz8wcJkCtYuVvTPn?=
 =?us-ascii?Q?EdbykCdCKhn9YPyA+moPhGWttLdGhPaNUYJFWfEjdOGVgMiOuhr6CeK0knTe?=
 =?us-ascii?Q?OkTA25qkrd1TMGElU8ps1efFYsiuVVH3ybw5MX2/xYbS7K685VH0a0qZEduJ?=
 =?us-ascii?Q?Zuv+zdvaG4JFVuXhSycAmrKrtklKmD5OWB7mcwz5ne/V7cHWs1jvTTHPWitm?=
 =?us-ascii?Q?QEnjwIebwEWoY8g59L5F+RviacQ7Z/H49FiT1zbbHNu2DAZvjI4CMgYylNAJ?=
 =?us-ascii?Q?r24PkuYAAt9sgQ9gg7zzlSkmJ6ILeGgJnwoW05zuFDrQ/MjBTyyTy5eMSswf?=
 =?us-ascii?Q?47CJ14C/Hksc1eqZtTuIIH4h2hniP7P3FFvE3NtsUX9bZcE9Xg0RWPxehYZQ?=
 =?us-ascii?Q?Tzpd9dwfxk7M/oU+lHgrQlQwLrbvt+HBA11LqvN1QMG2f5Xr4Ee+ElHx6V0K?=
 =?us-ascii?Q?Dxi1zYpZ5g9P8Mm6poNQKnl5Y7qoThGaBHXy/kiuP7fdbD9DvLig7sjdtvjj?=
 =?us-ascii?Q?5fevpHS/H9YY7IUDE8BUd0a2RYSX1mGDh3Y5MxjeFWXjzwsUrpXHsmpr9tzd?=
 =?us-ascii?Q?sMTgZRDJLLlzQ0tpqP+l1VnKh+1jQSUwdNcmz5JiGtCn5FPen5QJ4SyyheGi?=
 =?us-ascii?Q?bcI6zxhqMPjm6uZPrpixwlVrnNaUKN/Oy+x+VLmE8+6U9jKz2rl84x/VXWOo?=
 =?us-ascii?Q?SRMEj+bVHtPsNW9tsGsobWZEDfvyVJt230uOOmPNKeSlHVWSbHLoT7blPePN?=
 =?us-ascii?Q?A7DJnZykmebANBcwkp+tOdP/HLDG+tfS8pyOGXjsbjhx23IhDbiyxcnarZmi?=
 =?us-ascii?Q?+MD3qnsj45/O5Q7NTqFZ4/tlXqI2/a8lQKTExGnB9nu3qi/kLhS23U7Ro1CT?=
 =?us-ascii?Q?HnkswQUSjTIb/jVzdGMgZUxmYXXpVDfgSgo3ZGpv3gJso1OJNJ7CyiDQ3TFl?=
 =?us-ascii?Q?p0fyj001MPwEfFC22UWFcgStsalwl3DjH/xTl5hCMHFlJtGTU/cA27z6MOXl?=
 =?us-ascii?Q?uEe5Cxjagscca0r3ndgyb32EI6m1Zn3UKNCKHcJbfER21oL/etTNrS9Y83DW?=
 =?us-ascii?Q?Ztkirx6a9jakPNn9GxFkaqk5sw9R+jp5t82iX0Kpf0m+QSK2pcYBSK2DBmRE?=
 =?us-ascii?Q?DGBo3I4EvaIwg4GkRNRGOtcQIksxPcBeMtINhj6C7U4M8gcnbDAQu/mgc7jF?=
 =?us-ascii?Q?qc5RxfuP21AGF2xzRB9UMpkHWQ4LsjufSKTS78IIOunvUe3/H/VxWuiGjuFd?=
 =?us-ascii?Q?jPj22R6XgMhly34vmY2ezcVUPCVPSi609w/k04s8njKeSwlXBAKBXR8LAs71?=
 =?us-ascii?Q?Ym3omVO953y0Q0/JpZeVRIyyFFnYhxzbpgDbNX5wmVhSSvXUKzaQAFbwkVX0?=
 =?us-ascii?Q?X3I1ptKgX5LCNVYQhy31O4i+k/3BjcAJNXqh06KsIbHG3HwsDkupVtHBPVAm?=
 =?us-ascii?Q?P3cmEWGWIBIdOvreVG/ESLHjuIPUypYnrUpFGUkuUW/RHxqJbgWeKRgIh5Sf?=
 =?us-ascii?Q?xKqaAOLze/loUMdojy3kg9uR+9pWxkmwpf303p5cow3G6GTQdQCfO3R/fNLX?=
 =?us-ascii?Q?jQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5093.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47831cfc-0b07-4472-9132-08dacb67d302
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 02:26:40.8108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G6UEKXWaq8+DU32+vR5nOfVgerAcWAmVSI2tN3FKt9RIoO+RVPYSDsaUSKqN+hD1nqJSqZzYqsCzT5epW1+RrsFLOBI2z7kdS9O5vlQKOKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5805
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Friday, November 18, 2022 12:36 AM
> To: Lai, Peter Jun Ann <peter.jun.ann.lai@intel.com>
> Cc: netdev@vger.kernel.org; David Ahern <dsahern@kernel.org>; Gomes,
> Vinicius <vinicius.gomes@intel.com>; Jamal Hadi Salim <jhs@mojatatu.com>;
> Cong Wang <xiyou.wangcong@gmail.com>; Jiri Pirko <jiri@resnulli.us>;
> Zulkifli, Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>
> Subject: Re: [PATCH iproute2-next v1] tc_util: Fix no error return when l=
arge
> parent id used
>=20
> On Thu, 17 Nov 2022 13:33:17 +0800
> Lai Peter Jun Ann <jun.ann.lai@intel.com> wrote:
>=20
> > This patch is to fix the issue where there is no error return when
> > large value of parent ID is being used. The return value by
> > stroul() is unsigned long int. Hence the datatype for maj and min
> > should defined as unsigned long to avoid overflow issue.
> >
> > Signed-off-by: Muhammad Husaini Zulkifli
> > <muhammad.husaini.zulkifli@intel.com>
> > Signed-off-by: Lai Peter Jun Ann <jun.ann.lai@intel.com>
>=20
> Yes, looks good. Will apply to main.
> What about qdisc_handle as well?

Thanks for prompt response.=20
I will submit another patch for qdisc_handle.
