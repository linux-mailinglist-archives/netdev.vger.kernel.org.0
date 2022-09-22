Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC1C5E5D4A
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 10:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiIVITQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 04:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIVITO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 04:19:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F18ECD1FE
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 01:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663834752; x=1695370752;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Smxwynfi/XLoWWSbflAC0JnD/fHc//7Yu258laaqPqE=;
  b=VotUTSXANhv+FblNJri8NldnXQukDnV0OYlPVseSro6KGrCNwdP3DyEx
   lYp8+Gr1Ra/VKCRtKVJGqez9ddyI3R+D2kawP+5vQHHwcRgZh5ZrXa1Gu
   Rtn+YjXIAPXPly9RGGADtMBAbppg6BxH+yeY8kfopK6K1hW+TYHnOwZwl
   Y0euMqd/umb9UHXWyqR3rJnc8geb0f4eLARC7hMNbukNCKWe7mG7n6KNO
   GU/mVeeC3foN9UCZmMEPW4uGOj+CPYikAcOkFD3/bDQCImBrL1vHGLrWg
   /hcEeEEVu5SyJZ7qMMwfx6aAHx4MS8rcSKyovg3LYrXk7LHwUL119Cc03
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="279956834"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="279956834"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 01:19:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="723564138"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 22 Sep 2022 01:19:11 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 01:19:10 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 01:19:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 01:19:10 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 01:19:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZC1XYEQrIuksBU/05YVUquZQdR0tkkchwVQ/xU5/cV8aA3QhELFK7oj1cyfjGLn6WYQOafbXQRZ5svHqef3VP+jhMy0jyWuK1mRz/X2wd4KIO4gsOTL1LdnyqJ4cSTcl3WGwrQAmn+CSxyS2K1G6TaC+pBLVSowy6Yx/3DoGxukZ3lskpkY0G/SYxwvNDtrozNFO0gkkPnqYfqCRjWizeppCgsoMa5j3kNNUcEJqaLQzBSvkcEki2T5Kf2OKU7t+6i1LPelNi0uHq8sDDWyfy+B3CE1wXjByKtT5vV2/E/aJTm0D59ZXXf5/P71th1m6H53mtI8U8uXi21pUqwwvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Smxwynfi/XLoWWSbflAC0JnD/fHc//7Yu258laaqPqE=;
 b=kjfXByJ6SxFMD1jZDq6Uce9w5sVPSmOZO2msA3diXR22MULL5UBIUTBp5tRtqyvsSbTjkN83sOSvXjQpgi4sTXnCEFBcJrANbrhfrHG6GHBeTsvABXvCClizuyvhuZbeA6ZhW6qEWFFUtitRq/9Y3Oho8hpE+bHZTV0dcyaUz1OthAxTVfkci2dPPt03YsIg+WZJOIKcDB4AIo/2YqjGauSsMRNT+l/tFWvzUvUJ/UjYiwSHDUZbHYMqiMCPBHPH1vuRJteGY0IYzh0bYDNKXVAXSGgLQuKjz62pvq7+vBJF9zCwFloHS3Hk/yccHvQRzKnyPqBaev7nAo4q/EmNmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by PH8PR11MB6854.namprd11.prod.outlook.com (2603:10b6:510:22d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 08:19:08 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::a0a4:bd71:e7c9:851a]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::a0a4:bd71:e7c9:851a%8]) with mapi id 15.20.5654.018; Thu, 22 Sep 2022
 08:19:08 +0000
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next PATCH v2 0/4] Extend action skbedit to RX queue mapping
Thread-Topic: [net-next PATCH v2 0/4] Extend action skbedit to RX queue
 mapping
Thread-Index: AQHYwyBaPBOhs3BGO0uGs2JDALv3X63qa3KAgADC2YA=
Date:   Thu, 22 Sep 2022 08:19:07 +0000
Message-ID: <MWHPR11MB1293C87E3EC9BD7D64829F2FF14E9@MWHPR11MB1293.namprd11.prod.outlook.com>
References: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
 <20220921132929.3f4ca04d@kernel.org>
In-Reply-To: <20220921132929.3f4ca04d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1293:EE_|PH8PR11MB6854:EE_
x-ms-office365-filtering-correlation-id: 242a1d8f-dc3a-43f5-5ca5-08da9c731ef6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: exbofs+tJWBHkZG724HRlCPQJQ9JyCdP7H4IE2eNvZBB2DvoMPqIJU048RelyhNnsLGhwDLe+aJ+rWXExHp1Lwy1UUZWBvf0AiFqhQr356JOIUt1M7f7C0VPbIRBW7nO8LbELJpCZ3FKSAeuwQ2JUC2vK1tQEwdi8Yt1PzOE0MIkRrIYYaSodGk4vttseD/CU/zQru4PyWeDEcHL2KvRdUNMbfs6TsIT0Mxl2hUEUmJjcitrJi/zR2RDqo0bGFbm4rZzNXAqKj6o9pOqTAZKFifa6hDwedWMwym8TTHJGmbSBlRIkGqZMP4DXtUL/tOFAS4tJkxK1bYdbZ6yC6DQUJ6KUd4CyZM+IqJVzAEGHg7Ui4tsKAeppS5qUIHbQ2TTyu/N6niERfjxSZQjSrN/lDCPIMbXevzKQo9D1GE72donScWnyyWHdND3Xl3gtvbNADu3JJJ7OEjK/60r4wSMe3Fo8hAvzTuMKyXSem/uP8QOZbsNwwyjYXVVmFXspAgPLBkv88OrvjonFPgsBlXJuYjQ0bJbuumpJqBp1CIXlhauj7+x2CVEf5Wc+0sdX3DwuTJ2uk+mDmUcr6F3FUbvH+3ye8PrH5k18uOK2L4YA2Zhs9Q5h6PNsBRrbuhYtLFxEwDJnU/KvN1DiEQ8yd0C8fnKInLa8dbpppXKxLl2fiKnj4T/ZnYmMQ/hKsfGyPwdPJ8vhTJWJhvg37vWZzAPHTSxCi8QfYfQNzptqO35D2rK5sf01WDZSXdp+zE20DCdTsot3A9IPUWeFHZVFMBI8kSnzrPKIbmRRY9i4kzNMSk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199015)(66946007)(33656002)(82960400001)(86362001)(38100700002)(122000001)(38070700005)(478600001)(7696005)(83380400001)(2906002)(5660300002)(26005)(107886003)(53546011)(9686003)(186003)(71200400001)(52536014)(6506007)(316002)(76116006)(66556008)(8676002)(8936002)(66476007)(966005)(66446008)(4326008)(41300700001)(55016003)(64756008)(6916009)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DQeSNQkXBCbxzVtnLbGPjV7wo6s049YbkDrQw5zayAtOxDxVQfRV/Il4Ip0E?=
 =?us-ascii?Q?9eldP49R23KNphCrs2GGa1XZTDM/oTTfW0MvPlb+qYnNNxem0MI0nbBJQ6ul?=
 =?us-ascii?Q?+x33SXRwdElchzckiYHkRAhojWUxEBxG0z87iHdKV/JobVazDvWAzq4MUopB?=
 =?us-ascii?Q?HrgKkb8tmUSyUTg5meZCsG1yjU9X88OLZzC/2P2tRhRuoT4MRdS0Rx42/Lib?=
 =?us-ascii?Q?s4W8he1YzAzI+8iKSF119ZnngIzCbbPfUNBPYlO7lxckQ/GlAI/3ME1IZWyf?=
 =?us-ascii?Q?QsWJlaXeN/JpkqxwuGZq0wzjraPA2/kIhajISMo0dTAFhEzTC/jDDMDAKYIM?=
 =?us-ascii?Q?koyIzKQiWe/9mRKEyv6MK3JekaNaeSH7LLsDmy77Mr/EG/6Y886BaT5xxHgw?=
 =?us-ascii?Q?Ua+HmCv9nQyFkD/Cpg1NLzwaG/af9WsuvXJN1TcHIOiVpSXp2+BOE5fHcifS?=
 =?us-ascii?Q?/EtN54/zp75mDmfbWZARUQhgJwiUXLwi7eUbR0+MqZ+wqwMU8NA2RbewiTw5?=
 =?us-ascii?Q?nyaVwiVTr+lxyLEtcmELQN7bC98TCp+bSiFY2ZYD3VC0+95V00yCdBTa3bQN?=
 =?us-ascii?Q?T1bst3Rn/UjnFmZN0B+cVvsWSC2VjN5dMMMQu9P+piQlON4O7dRAka+iXc0K?=
 =?us-ascii?Q?xgzCNws7Zbq6ek0ndaj0owrvZy6BPMq59Q6C2OLBQKC7FPZCRpZ3TItE37mY?=
 =?us-ascii?Q?uFWrK9kuWhsSdphkay62eRb2QRFk1OWiNjjN2W700ZGrsEAyBMxQp8buiHhu?=
 =?us-ascii?Q?ekX7RQ2UxldscGUfWabNUm81NapFO+8oeuZcbo/Tb0LIMeAHM7qQlc783GTW?=
 =?us-ascii?Q?XLKjvrhlsMF6dk7SQSJQe3R8uAZfvQPbYoB7nPi4TjVe9TZUYyJa5q1gAhVV?=
 =?us-ascii?Q?Dho3rQVJ4QByzeF/w/OLZqbULYoPcJTQZBH0QezYXW8ZnbRiSd2Yrp6ag1NH?=
 =?us-ascii?Q?JP0oGhk/x7555NJ1qrXuYb3aLBq0s9zkbF/LF3ymSDqE0YUkM2aDf+gZNy3v?=
 =?us-ascii?Q?YWotXdV5CW/uVPAlii2BJ+NBtNV7aOym6UCFu+h9R4tFkQySBe8sQO4tdF9l?=
 =?us-ascii?Q?oCWege58Fb0MSMRsFmEpqe5htxU3iHUuqeF94U09KwggnzMGPimwXGYx0Lr/?=
 =?us-ascii?Q?GgYCUR74mCQ21VotCFb7fCSexuCJ6PMOoGM4iv9CujRdCOM0Hu/Nixip+dHD?=
 =?us-ascii?Q?s5JcxIxEFh6B39wxTMmZf+Q++yBXEzvrMbJe64PX5lN2dCm3cMAH7XukVUsv?=
 =?us-ascii?Q?fWfc8bcPBXGjBOCT+Ow0LwOXDBKbXiDodGcnLnCq2zSUm/Z800/aW6eekFGB?=
 =?us-ascii?Q?cPm3pZ7xzA4iVJIOy2u/5IlBL+rfSJl1Ww0y7EGCbRV9LFX4ma5uhUpo/XU9?=
 =?us-ascii?Q?mqlRqlK/S8QsrhEfr28Yk8M5DddIdztdrcD0Y11uLImXsy1j0gCCM20XwftL?=
 =?us-ascii?Q?d6nc9bjrHT3cQqTCPHrczNrE0tr0tpNKtaRY1oGnryBCJAIfPz24cymcAe8d?=
 =?us-ascii?Q?mj3nCyoUbwNr/G72Abp/Nabg1/TgW78FwFTW+L2JlB1Qjk37AwdwG8R7XdlS?=
 =?us-ascii?Q?VACpRmYfPZzTsbr0jIswTofe0M0Ni9QT0jhOPO9LQFcP3SLzlvOP+N08OZhj?=
 =?us-ascii?Q?2w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 242a1d8f-dc3a-43f5-5ca5-08da9c731ef6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 08:19:08.0355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YhNbscQCP4oc2V9iJJUhLIkhUqwV4Drn9tPg9qEi0OU6LzIlLw2kr4fbdF2be971qaalE3FAAyGa/e6ZtTCtgIUr34dPbXwCKd9UCZFcPlc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6854
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, September 21, 2022 1:29 PM
> To: Nambiar, Amritha <amritha.nambiar@intel.com>
> Cc: netdev@vger.kernel.org; alexander.duyck@gmail.com;
> jhs@mojatatu.com; jiri@resnulli.us; xiyou.wangcong@gmail.com; Gomes,
> Vinicius <vinicius.gomes@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next PATCH v2 0/4] Extend action skbedit to RX queue
> mapping
>=20
> On Wed, 07 Sep 2022 18:23:57 -0700 Amritha Nambiar wrote:
> > Based on the discussion on
> > https://lore.kernel.org/netdev/20220429171717.5b0b2a81@kernel.org/,
> > the following series extends skbedit tc action to RX queue mapping.
> > Currently, skbedit action in tc allows overriding of transmit queue.
> > Extending this ability of skedit action supports the selection of recei=
ve
> > queue for incoming packets. Offloading this action is added for receive
> > side. Enabled ice driver to offload this type of filter into the
> > hardware for accepting packets to the device's receive queue.
> >
> > v2: Added documentation in Documentation/networking
>=20
> Alex and I had a quick chat about this, I think we can work around
> the difficulties with duplicating the behavior in SW by enforcing
> that the action can only be used with skip_sw. Either skbedit or
> Alex's suggested approach with act_mirred. Or new hw-only action.
>=20

Okay, I will go with skbedit and enforce skip_sw for the action on Rx
side. So, skbedit for TX queue is SW only and skbedit for RX queue is
HW only action.

> Alex pointed out that it'd be worth documenting the priorities of
> aRFS vs this thing, which one will be used if HW matches both.

Sure, I will document the priorities of aRFS and TC filter selecting
the Rx queue. On Intel E810 devices, the TC filter selecting Rx queue
has higher priority over aRFS (Flow director filter) if both the filters
are matched.

