Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0980C688319
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjBBPwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbjBBPwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:52:33 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F506EA8;
        Thu,  2 Feb 2023 07:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675353151; x=1706889151;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AbNtYQ0++/jIa+8NEZ96f7NH+9w9rkmM1ffyVC34pNY=;
  b=QkGH7lB3iD+YJZqFQvmXWAeK4rhcMRZvVAaXTKFcQ76ZPqI/e3dDSY2p
   AGHDw5f6GqsniFWX6TfKtmfhEC+nINlLsd6hyIbwgpPvrg3xeotPUVg+4
   /zgqmV07Sr02QVG70zVEBEsdMb4LH48u2gDbQAN7vYJpnCijS9wYnJyWn
   X1uycPpEdGsh6lPAdEFvUigzeBYxpos2kLLwdxZ4few1xX+XW0T0ejMwZ
   kJdFtcESSkvjFUkoHR4JQUOZKrE7gdmHb4TBt3CPBp5hZf6eV/vKd2BJL
   JJ9Kfr78xehVHnlwd7863b5Xe7ay6Keeox/G/GmSjem2Ne6C/H5HEnUeQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="308128786"
X-IronPort-AV: E=Sophos;i="5.97,267,1669104000"; 
   d="scan'208";a="308128786"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 07:52:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="754111056"
X-IronPort-AV: E=Sophos;i="5.97,267,1669104000"; 
   d="scan'208";a="754111056"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Feb 2023 07:52:30 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 07:52:30 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 07:52:30 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 07:52:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLq/zGOBeQSv8TVOPwpDWuBSZ1vgiL5gnW/09HA4U1ecZzhw95fYuXlf0E4PmfWJ3zSfrGlbNZdlEEJ+HP+GkkluivTxiDI1BF0KHPQ/Tdz3Fx51KVy5EBqGQlBiHWB9HH54RdIiDLSDKAUzpTVkf2uMdSEREDYs0Q7tt926XRZ3Dj1ds3aGX8DHjXhim3dTf0FTOfg1JRfGGPZt+EBmllhC8pkfLa1zHA0DLbNzgIAk1XTCCQ7pHXCJFYhqTq0ArD3sRyST0xsaFbNwqBjEFkvKt5WMlW0tcaTQS+JoJOzTT6wKwwB6zIRe78jrnma2oO6ngKfEr4j+L7ED8Pp2pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AbNtYQ0++/jIa+8NEZ96f7NH+9w9rkmM1ffyVC34pNY=;
 b=J0Z8LNK4052XErWEP4E/xlNGKs2lANKPC+uYc7cZG6+eJDXQYnylFqgRXmnaf21I7b2sp3FGPp+MMwIWOQeIoQQTOQXVldzDuO8/vfrSUxrA7JpI8WRVSXb8sSkl8JIq34cQsi2z8aFO+/NgWLmyM0wJHMkQzI20fFc7iCpf8GrzATpJTpvGlme71QLJXbaTIL8ZI2WSVZ5ya8hCbSHYMsBAWDcIqy1RPDknDJKbKLIdaGp7gwfC1TmmUBWEgsu9cwZH9UI77ohbMo8bFb8MRFYfziMPkw/7B4jwPm2tRkPChssX6wLzTH1BXwwwYO4EfmYgkXjCJLf008iBRTrSUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by PH0PR11MB5064.namprd11.prod.outlook.com (2603:10b6:510:3b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 15:52:27 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::d25b:fb66:f78e:16b2]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::d25b:fb66:f78e:16b2%8]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 15:52:27 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     Stanislav Fomichev <sdf@google.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Brouer, Jesper" <brouer@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "song@kernel.org" <song@kernel.org>, "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "haoluo@google.com" <haoluo@google.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "Burakov, Anatoly" <anatoly.burakov@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Tahhan, Maryam" <mtahhan@redhat.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [xdp-hints] Re: [PATCH bpf-next v8 00/17] xdp: hints via kfuncs
Thread-Topic: [xdp-hints] Re: [PATCH bpf-next v8 00/17] xdp: hints via kfuncs
Thread-Index: AQHZL1xlARwFBoZemkW8/8iYd14K+K6tbEWAgAAIzgCAAAmggIAOUuaAgAAF7OA=
Date:   Thu, 2 Feb 2023 15:52:27 +0000
Message-ID: <PH0PR11MB58309A9579C44151FA3A3B87D8D69@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <20230119221536.3349901-1-sdf@google.com>
 <901e1a7a-bb86-8d62-4bd7-512a1257d3b0@linux.dev>
 <CAKH8qBs=1NgpJBNwJg7dZQnSAAGpH4vJj0+=LNWuQamGFerfZw@mail.gmail.com>
 <5b757a2a-86a7-346c-4493-9ab903de19e4@intel.com> <87lelsp2yl.fsf@toke.dk>
 <da633a14-0d0e-0be3-6291-92313ab1550d@redhat.com>
 <8627b210-315d-45c1-5638-258a74ed8f7d@intel.com>
In-Reply-To: <8627b210-315d-45c1-5638-258a74ed8f7d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|PH0PR11MB5064:EE_
x-ms-office365-filtering-correlation-id: 45b50327-f149-4dbe-8883-08db05357be1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FxSHs3X2nU0XVchiHDRSsiLE3fGxJrQJYDWgvB0bWuQV3txGro4tuUnxvk7xAF1Qk8DslhvYgPNX3lB476kV0wTKpfYpp8cBi6WP36KHsAwlKD4oscFmGcP1Uv3+qpS6ZxHAAwr02n48Z0V2X/6V8PFsO4OcjEVi9FBggvGFz5b4TPBYJw2CBp0oCB0DKFpAuheBy7/xhuP8udNDr8tytpFUGDsbDkEADzRQczABoA+Orc70QRuFwCcj+VtRVvLGOtG9ST3laJW+nDtNjmROJLq2vto75gX/7DbLo2MG5IS3jgIGW9pLVNzJfbt5D0CQrdAHMBHGBEvpRgd8UlptFD7uv5thfnScCMmSZtvs6yFj4iwAOPK3xO9uaa6uqKFDV9iI/52OQl4nEEo6kWwZj9FkOFuMaNDGjwFt5lk0wCE+ZxHdE0lvEw3FjburmGo17jbGqPFIkMopyPQSAs+A+UHqZtst4rn/+OHRbxXN4iaQ/fUQh43lHzPVb24VYgEaKNhSFRi9aLiYzFdOp0lsAalMcSAaK/JCNzuT9GDWc7rPytcKPy7SWCNiQkhOtV8XBURXIzY3DkUWySIZjaViROaqpYRpvZtFn5NJGLjwq0wNffqGjCJXvqytm9pPi6vlvRO/lIHapfKQAeFkij4v9qXYthwiEQrqd02FNqNDP2cZeIWJzAn77KGUtSBEvBP4SjxHs/o1jSzihcNPNAZtfsj3Hxp6EeqoPOxGTJf3SyuMMknozyoX6oR4ysLC2VOgnMcQhcD3ADJwnc+PL3ZBmg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(346002)(136003)(396003)(39860400002)(451199018)(66899018)(66446008)(66476007)(64756008)(66946007)(76116006)(66556008)(7696005)(316002)(71200400001)(4326008)(8676002)(38070700005)(33656002)(122000001)(86362001)(38100700002)(54906003)(966005)(478600001)(107886003)(83380400001)(66574015)(53546011)(186003)(26005)(9686003)(6506007)(55236004)(8936002)(52536014)(41300700001)(5660300002)(110136005)(82960400001)(2906002)(55016003)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3I4ZHgybTRhTk9jRGo5RkZBQUNhdUF3R0trQU12aG10bzNqL3dnRzlyOVhJ?=
 =?utf-8?B?Qk8yQTh4YWpIcDBDaGR0bEtsUWY5L2JHWXNkZ05wMCtlaTkwNnRiQVIxbzda?=
 =?utf-8?B?dlBMUVhoUmY0N1NCRFhSMHVIaU82YjlhNVVUSjFlb0M0S2V0d3R3amQ0eXU5?=
 =?utf-8?B?VDY1bDlZdXdDTytBdmQrNjN3c0xRd1pjVDIwRDgxUUtSMFY3dTlJMk5jamRs?=
 =?utf-8?B?NGVVWmlEWjFGeXMvMVcrd2pqSmwxaU5zaW8rV0pMYVJDdU1STCtyOUdpSXVC?=
 =?utf-8?B?VFV3T29SQ09TcGJKNHdYS21jY0hDelpKa0NrRzllMk9KSFJrRW1laUo4d3U2?=
 =?utf-8?B?MU1rOFZsWEg0NmxNMDVDc2ZleFIyWUJvaG94d1kwTkJvTDZsRW84T0V0YTUw?=
 =?utf-8?B?akFSRjJzTlBqZWpaK2cwM05HMGtZZ0xTR2Fhc24rVG5JZE1hMWJsV2xTbEN2?=
 =?utf-8?B?NjJ5SVErNWFuNXZoUnV3WFpNMlFhU3VrdnpPWDZRaUJLeW8zMURIU0lzcytS?=
 =?utf-8?B?Mk14dHo5Z2tPUm42RmF3M05COTJmUXoxUFk4NjNlODJTY2l0QlU1anlUT1lh?=
 =?utf-8?B?WDBPOEt4eXJleFFSQW0zNG5Dams5RWkzK0NXbFJPVkJrcGhGTFhaRFY2dEdB?=
 =?utf-8?B?N2VqMVZGdCtkZkFXV2dmeG5tQzU5SExjdkJrK2pjNUhrTmpXck1sT2tZbm5h?=
 =?utf-8?B?ZEpUdEJzNDVWRnB2a1VMUTZ1eHBJcUY2clF1QXU1azQrWGs5RnhjUnVZeXBi?=
 =?utf-8?B?bFRIL2Jicm1tc2xVL2J2UEJyZjVubk82dnpJcHo5WElJdlR5N1lsYXhSNzZN?=
 =?utf-8?B?YnpQWjNCek1XendvalhWUXBPMHFKejRRaUd6ZFlvbjg4b2Z1ZXcybkRTQkdE?=
 =?utf-8?B?UVlCWmRpSlJZSE8vK0c3SUYzR2MydXFTMUpQVHRHdWwvSSsrYWp5WTJKa2Nx?=
 =?utf-8?B?dTlXdE5IYk9YMlpDdUlwSEhPWHNJTURpMkptMDhUUmsvZ1hCRHVlaFdxcys1?=
 =?utf-8?B?WE9OVG0wQW5JRjVXZ2pEK2M4RzJRdVduMGJXRmhOaXlLenFuV3UrY3hteUd6?=
 =?utf-8?B?aVZCdEN2dUZrZHhlWmpqemljMm9FbjluN1ExbmxZQndsTUZiSUVwWDZZcUhK?=
 =?utf-8?B?UG1RY1Y0SS8vb3BrSkdIU05Gc0U4ekJsVE90MWllVklVZ2ZqZ3ZZYW9ndjIx?=
 =?utf-8?B?OXZQRkdVa2NLV3Q5ZmpsRVZyWnRrWTBVK2NZWmdoY1VpeHdRdTlERDhwaUti?=
 =?utf-8?B?Tmh3V0k1czNXQUVhYVdIeEMyb1hic1cyTThDMnBnMmF4akJiakIyakNBL3JB?=
 =?utf-8?B?RUt3dlphMForbkJJNnVjWlRONFhoZTNIM3ZCZmJBNzd6cUx1Q1BxakVGQS9w?=
 =?utf-8?B?ZkpjVUo3UWYvdGxGQ21SK3lyRmM0Mm91eEtmWGJjK2ZSaWhiMVlIbjFDMHpH?=
 =?utf-8?B?ODc3ZDYrOU10bDJKcnI2b29sVEQ2cVVXU2FuKzhQTmlIUzZjLzdsZVhYNW1I?=
 =?utf-8?B?bWZyZGlDYmdrbXE0TTBYOUFkVGhMRlQ5L3RkL1lvMHpWd1BwaU9LaUw4RUhC?=
 =?utf-8?B?WlhLeW5aU2k3MGx3UjJ2M2pSZ1VxUXk4T2owY3BlUTErRHlYZEFqWnJDNGhB?=
 =?utf-8?B?WXBETWE0U1hmbWR6cllJRVhTMmNoeHRPbVNaTGQwV0xYakV6aTNrL1lXa0hO?=
 =?utf-8?B?cElob2hjbU5peE04Sjh1d1lZbGhSNHJzdXVBSXJxdExVeWg3OURwWDJUUHVV?=
 =?utf-8?B?SnU1bEFoWHhkMGEvbFJrOVJmaFBibjJvbFZlUzZra3JGeXhYNFdTMHRmR2dF?=
 =?utf-8?B?Z1ZsQU1iUVZEdnZXYk83dlB6UG5KN2ZnN1cyQ1JJb3M4eW5wMnZsdlhmK0ZR?=
 =?utf-8?B?ZWlla2RHN0p3SURVNE9mWi80aTBFcFlHakNUbldUVURBMmI0U2k3MWRnMXJX?=
 =?utf-8?B?WXBXZTY2MUs1WlpMZVBCSjQvcUNWWmkyUC9VN0RwYldLYlZ6bGZiV25YWU9Y?=
 =?utf-8?B?c080WTAvWEh6ZStLSlMvU0JvTlY0bVVJK0djQUtVTmFOWnhlbkxCbktuWG0v?=
 =?utf-8?B?V25LNVhDUGgzcXEyK1JUaGQwR2VtWWFGWVBrcUpKK0tpSzNKSDkzZitQRWlj?=
 =?utf-8?B?NEExVjNaRlNubGVTRWlEb2NQU05OSkxkczFSZFAvYjlxbUJxcXBEekNpbW5v?=
 =?utf-8?B?UUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b50327-f149-4dbe-8883-08db05357be1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 15:52:27.2372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5PeEZLLTVtfa1e59MCfsbPNRtsZL5w0mqWC1uBpu6aammeHkJLd+6QgBKjwCChKE8OmWOF6J0W80RnH894pEOdBAZUCJp+EzbhlqDmHJXXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5064
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pg0KPkZyb206IEplc3BlciBEYW5nYWFyZCBCcm91ZXIgPGpicm91ZXJAcmVkaGF0LmNvbT4NCj5E
YXRlOiBUdWUsIDI0IEphbiAyMDIzIDEzOjIzOjQ5ICswMTAwDQo+DQo+Pg0KPj4gT24gMjQvMDEv
MjAyMyAxMi40OSwgVG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIHdyb3RlOg0KPj4+IEFsZXhhbmRl
ciBMb2Jha2luIDxhbGV4YW5kci5sb2Jha2luQGludGVsLmNvbT4gd3JpdGVzOg0KPj4+DQo+Pj4+
IEZyb206IFN0YW5pc2xhdiBGb21pY2hldiA8c2RmQGdvb2dsZS5jb20+DQo+Pj4+IERhdGU6IE1v
biwgMjMgSmFuIDIwMjMgMTA6NTU6NTIgLTA4MDANCj4+Pj4NCj4+Pj4+IE9uIE1vbiwgSmFuIDIz
LCAyMDIzIGF0IDEwOjUzIEFNIE1hcnRpbiBLYUZhaSBMYXUNCj4+Pj4+IDxtYXJ0aW4ubGF1QGxp
bnV4LmRldj4gd3JvdGU6DQo+Pj4+Pj4NCj4+Pj4+PiBPbiAxLzE5LzIzIDI6MTUgUE0sIFN0YW5p
c2xhdiBGb21pY2hldiB3cm90ZToNCj4+Pj4+Pj4gUGxlYXNlIHNlZSB0aGUgZmlyc3QgcGF0Y2gg
aW4gdGhlIHNlcmllcyBmb3IgdGhlIG92ZXJhbGwgZGVzaWduDQo+Pj4+Pj4+IGFuZCB1c2UtY2Fz
ZXMuDQo+Pj4+Pj4+DQo+Pj4+Pj4+IFNlZSB0aGUgZm9sbG93aW5nIGVtYWlsIGZyb20gVG9rZSBm
b3IgdGhlIHBlci1wYWNrZXQgbWV0YWRhdGENCj4+Pj4+Pj4gb3ZlcmhlYWQ6DQo+Pj4+Pj4+IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2JwZi8yMDIyMTIwNjAyNDU1NC4zODI2MTg2LTEtc2RmQGdv
b2dsZS5jDQo+Pj4+Pj4+IG9tL1QvI200OWQ0OGVhMDhkNTI1ZWM4ODM2MGM3ZDE0YzRkMzRmYjBl
NDVlNzk4DQo+Pj4+Pj4+DQo+Pj4+Pj4+IFJlY2VudCBjaGFuZ2VzOg0KPj4+Pj4+PiAtIEtlZXAg
bmV3IGZ1bmN0aW9ucyBpbiBlbi94ZHAuYywgZG8gJ2V4dGVybg0KPj4+Pj4+PiBtbHg1X3hkcF9t
ZXRhZGF0YV9vcHMnIChUYXJpcSkNCj4+Pj4+Pj4NCj4+Pj4+Pj4gLSBSZW1vdmUgbXhidWYgcG9p
bnRlciBhbmQgdXNlIHhza19idWZmX3RvX214YnVmIChUYXJpcSkNCj4+Pj4+Pj4NCj4+Pj4+Pj4g
LSBDbGFyaWZ5IHhkcF9idWZmIHZzICdYRFAgZnJhbWUnIChKZXNwZXIpDQo+Pj4+Pj4+DQo+Pj4+
Pj4+IC0gRXhwbGljaXRseSBtZW50aW9uIHRoYXQgQUZfWERQIFJYIGRlc2NyaXB0b3IgbGFja3Mg
bWV0YWRhdGENCj4+Pj4+Pj4gc2l6ZQ0KPj4+Pj4+PiAoSmVzcGVyKQ0KPj4+Pj4+Pg0KPj4+Pj4+
PiAtIERyb3AgbGliYnBmX2ZsYWdzL3hkcF9mbGFncyBmcm9tIHNlbGZ0ZXN0cyBhbmQgdXNlIGlm
aW5kZXgNCj4+Pj4+Pj4gaW5zdGVhZA0KPj4+Pj4+PiDCoMKgwqAgb2YgaWZuYW1lIChkdWUgdG8g
cmVjZW50IHhzay5oIHJlZmFjdG9yaW5nKQ0KPj4+Pj4+DQo+Pj4+Pj4gQXBwbGllZCB3aXRoIHRo
ZSBtaW5vciBjaGFuZ2VzIGluIHRoZSBzZWxmdGVzdHMgZGlzY3Vzc2VkIGluIHBhdGNoDQo+Pj4+
Pj4gMTEgYW5kIDE3Lg0KPj4+Pj4+IFRoYW5rcyENCj4+Pj4+DQo+Pj4+PiBBd2Vzb21lLCB0aGFu
a3MhIEkgd2FzIGdvbm5hIHJlc2VuZCBhcm91bmQgV2VkLCBidXQgdGhhbmsgeW91IGZvcg0KPj4+
Pj4gdGFraW5nIGNhcmUgb2YgdGhhdCENCj4+Pj4gR3JlYXQgc3R1ZmYsIGNvbmdyYXRzISA6KQ0K
Pj4+DQo+Pj4gWWVhaCEgVGhhbmtzIGZvciBjYXJyeWluZyB0aGlzIGZvcndhcmQsIFN0YW5pc2xh
diEgOikNCj4+DQo+PiArMTAwMCAtLSBncmVhdCB3b3JrIGV2ZXJ5Ym9keSEgOi0pDQo+Pg0KPj4g
VG8gQWxleGFuZGVyIChDYyBKZXNzZSBhbmQgVG9ueSksIGRvIHlvdSB0aGluayBzb21lb25lIGZy
b20gSW50ZWwNCj4+IGNvdWxkIGxvb2sgYXQgZXh0ZW5kaW5nIGRyaXZlcnM6DQo+Pg0KPj4gwqBk
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2IvIC0gY2hpcCBpMjEwDQo+PiDCoGRyaXZlcnMv
bmV0L2V0aGVybmV0L2ludGVsL2lnYy8gLSBjaGlwIGkyMjUNCj4+IMKgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvc3RtaWNyby9zdG1tYWMgLSBmb3IgQ1BVIGludGVncmF0ZWQgTEFOIHBvcnRzDQo+DQo+
U29ycnksIGp1c3Qgbm90aWNlZCA6cw0KPg0KPkkgd29yayB3aXRoIGljZSBvbmx5LCBidXQgc2Vl
bXMgbGlrZSB0aGUgcmVzcG9uc2libGUgdGVhbXMgc3RhcnRlZCBzb21lIHdvcmsNCj5hbHJlYWR5
LiBBdCBsZWFzdCBmb3IgaTIyNS4gVGhleSBtYXkgd3JpdGUgc29tZSBmb2xsb3ctdXBzIHNvb24u
DQo+DQpIaSBKZXNwZXIsDQoNCkZZSSwgbWUgYW5kIG15IHRlYW0gd2lsbCBlbmFibGUgUnggbWV0
YWRhdGEgb24gc3RtbWFjIGFuZCBpZ2MgZm9yIFJ4IEhXVFMuDQpXaWxsIHN1Ym1pdCB0aGUgcGF0
Y2hlcyBmb3IgcmV2aWV3IGFmdGVyIGRvbmUuDQo+Pg0KPj4gV2UgaGF2ZSBhIGN1c3RvbWVyIHRo
YXQgaGF2ZSBiZWVuIGVhZ2VyIHRvIGdldCBoYXJkd2FyZQ0KPj4gUlgtdGltZXN0YW1waW5nIGZv
ciB0aGVpciBBRl9YRFAgdXNlLWNhc2UgKFBvQyBjb2RlWzFdIHVzZSBzb2Z0d2FyZQ0KPj4gdGlt
ZXN0YW1waW5nIHZpYQ0KPj4gYnBmX2t0aW1lX2dldF9ucygpIHRvZGF5KS7CoCBHZXR0aW5nIGRy
aXZlciBzdXBwb3J0IHdpbGwgcXVhbGlmeSB0aGlzDQo+PiBoYXJkd2FyZSBhcyBwYXJ0IG9mIHRo
ZWlyIEhXIHNvbHV0aW9uLg0KPj4NCj4+IC0tSmVzcGVyDQo+PiBbMV0NCj4+IGh0dHBzOi8vZ2l0
aHViLmNvbS94ZHAtcHJvamVjdC9icGYtZXhhbXBsZXMvYmxvYi9tYXN0ZXIvQUZfWERQLWludGVy
YWMNCj4+IHRpb24vYWZfeGRwX2tlcm4uYyNMNzcNCj4+DQo+DQo+VGhhbmtzLA0KPk9sZWsNCg0K
VGhhbmtzICYgUmVnYXJkcw0KU2lhbmcNCg==
