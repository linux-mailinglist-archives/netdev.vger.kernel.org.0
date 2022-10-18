Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC015602E0B
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiJROMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiJROMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:12:48 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CBB3B736
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 07:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666102363; x=1697638363;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Itkg8VkpSphdiSLhfDLEO6+O2Abkhe3QXxyA+qJMLeU=;
  b=QD8B54RUNpcrRw0EvS2mMTEiCwmgfLtJYt5jaz7XIobhrPOM0TORG4ge
   M4wBg/0XiqBypzX8uxzxACl/KUnOOdnoi4GCLrduov3ENKC7Ob68hiyYy
   CYu2HuCNyva8YnLKrzBRnsRMAUjx2gEu8ySzomceUEDQzVelDNLlbCam2
   vwfvAJ7p6ME6swnrExD2wDBaadG20BxjBSBrnsc8UXNQTR7KwUXRRvci9
   qZ49TGfmLXzvONGPybvkWpCP9kZCCJheDgRDkknyERFR5hB5eZ9bdMw3m
   nxFb2HAFAE90bTNPHfDOyn1wUrGzNbv7BIaOROM1ITkpbAEVuzwbmzBEl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="392419287"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="392419287"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 07:12:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="579804111"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="579804111"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 18 Oct 2022 07:12:41 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 07:12:40 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 18 Oct 2022 07:12:40 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 18 Oct 2022 07:12:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9nYQxQ/GSOlYRtzh2XZo6/yfpfgqU6q/EfxayYLAFxo3wJ39vvrtuDqS3gNP2qUKBSqJUWE4fnoRcBGPjttGEAY2syj9Ksjl6Vj+KnviwPTU2JVnkeTkA1vr4TXNzdz4MnHsjgJac12iMk489t8bi4I3s3WyAxx55OnBt+fkFruhasgpQQJIq3V50l9DvLkpF5qrze+DqYqEyI6W3YHpATf0f0NuCCXFI72SbhX10iGPk1eaoC5+/sdbPGjyvI76Cn1fNpQ99wbyiLMXINHHDwcMDflp5S3Dvkzt61BkMdb6GISkrKsXnE3Psy929S0vg2VNO3YFk5ouctZqU2weA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Itkg8VkpSphdiSLhfDLEO6+O2Abkhe3QXxyA+qJMLeU=;
 b=MEJdeqWVEsXL+7cCZXM+t/uX+Oa55BJPWt0LKfyIORf77vIQGsKkCwdmQAPf9vZlKIDmYDhUuo/wy0ZSkr17kad1s6E1qgIBah3f9Lff5OO0/ewvLUw4Eb0WiGmJFU948QZwMNv7T/3zL1i8F94GZqBzraQmlC5LmKbGdgA3ffy1qEqTPBw44y8E4bd0ktWtpC97btzvU1DTyjwavnPB7AXM4wJ3LqPw/DoAt4q8/GXE59LsUP195CCjvzWtLjqPOJs4femK6EQ8LKTEjTZEY210a+W9wKdFmRuOzoYTnCJUBp+Tykz2yvrMw9iZgpe9eZ5cDBymFXLMRGxgHPpnuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by DS7PR11MB6175.namprd11.prod.outlook.com (2603:10b6:8:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Tue, 18 Oct
 2022 14:12:37 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::ec4c:6d34:fe3f:8c60]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::ec4c:6d34:fe3f:8c60%4]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:12:37 +0000
From:   "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>
Subject: RE: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP packets
Thread-Topic: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP packets
Thread-Index: AQHY4o49ev0KReGUxEyWlnOqPWSac64UCRKAgAAniEA=
Date:   Tue, 18 Oct 2022 14:12:37 +0000
Message-ID: <SJ1PR11MB618053D058C8171AAC4D3FADB8289@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
 <Y06RzWQnTw2RJGPr@hoboy.vegasvil.org>
In-Reply-To: <Y06RzWQnTw2RJGPr@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|DS7PR11MB6175:EE_
x-ms-office365-filtering-correlation-id: 7611b063-9ab8-4701-6fed-08dab112cf72
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PtkUVQbZlLccWvQQDmzHFUB9VHXoJGygNNcp3x46YHpGhNsKcAg3SEm41EzZNP3sxIteKt7Ht8vYliJ3vhBO8aiq+iknJyVvPBdaKiqzNQazrSPxnerzJ1wCERDRGnzUd2THpg0QPMEXlVEUHDn6PhdkgB+DWwGwQ0MeXCxA/sVPhX70gWSjb9VZKfftZC2rPYuKJ9Dnt/e6E6i6ULdI7UbELktK7eZZFzOrNspCleLOZFpwwri5xBTAFlBOs7gQfJGkhIVfN8nDTKTMs3KCosHGNL72oFQH7EMQzra5Ql1VbYC0McO7IlcyUkQLaWIM9mMCVMqw9rTaYPyrTTB5ThKtetQY7ORReTXO1FKch8had27jFEeqlgDF51xX6d0BEaabzZ7YXu/XtDiSFBFqE3aEcXwIKvhK2dpWBx1TmUolkj0KBi49KYobd21pUK87nsFpnIaKng7e1YKcwGkvtTkWTHXVqsUmqpl8wl0gpg8/HywbOgiEYk3RQt7D4ZUiilkQiAdCAdf07RfxKDLSsID1E7O3RqlBdVvu6GO4bIxp/wpLn51uRvSyBLk6vGvPopZEnfTK5KXQF/9oP5dI5SefIMydyu/bsswEPdxebd/+g6IAzP6oaMeGZFmbnKHdYA0i7N8l/24uqeOgLN/Y6cz58JB0iCkqkLrF9Oii9yhzDLM1EYZgLSFrjMykK9UlfqgWaGsXCQofiC8Eq/oM1bBqCFMp8t9mUGSZ10513M2wkxZGQb7QO0tqFmiJryyBTfpRRpK+hn3Ta0GOFZ15Ow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199015)(186003)(107886003)(6506007)(7696005)(26005)(9686003)(53546011)(83380400001)(7416002)(2906002)(5660300002)(55016003)(54906003)(6916009)(478600001)(316002)(41300700001)(66946007)(8936002)(52536014)(4326008)(8676002)(64756008)(66446008)(66476007)(76116006)(66556008)(71200400001)(66899015)(86362001)(33656002)(122000001)(38100700002)(38070700005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/IadkgOEyEOtrRIHXKq1CMuU8dhIlPyGdetGeu2yJXV6bxK/gec9K20aA1UT?=
 =?us-ascii?Q?tqlThN0EUp/8u+wcf2C3JWwuT/fNfnKx/hy2XqleWFgamll7PbU102t7hXHb?=
 =?us-ascii?Q?9GMMsCEKNxSuuN+bdAigHaSfS/H3m60gyEKtqE2U/FVxzsIwFOoQVn32v6lB?=
 =?us-ascii?Q?8QkYMbwzWeuYjSSp7RztDhPpsNbkFwOr8v2U0nXCM9Uqm8h3AWvHUmPtrn56?=
 =?us-ascii?Q?X87Lk4Z+qJAHvGHjAkH9/L2yXi/cDMcnaYLXKymCKlHa4pMHdKwHT4Ju/lUn?=
 =?us-ascii?Q?bK1nWVXyGxom9nPGIEcn1rFfKUfGp/Yvg+yJebe6+ABxmm2YQjA7MAagD0zX?=
 =?us-ascii?Q?CT0ZnXKiSyidyVYIFoLtxMf84GNijJc6l2tCrqfdC9H3b0WUYeGWIc5V2Gmq?=
 =?us-ascii?Q?4uAkvyBuj6p2MAhSLlEJZh2f0QRrkybSNHxTzrSP0WdOXq/llV9/+3ngphgP?=
 =?us-ascii?Q?6psOkjBRqnVoe9b8t3rI1r3My4RT9Yv/ZZYWGVaf7hAvmwlzQv9lpuDGumIK?=
 =?us-ascii?Q?OZx+945hzrpKJ0EfZfHXeObSeMvhD3Loh+qmim0c01cTiFLR/hZVvMIqyeWh?=
 =?us-ascii?Q?mWc2EoWL9e8HjRnI/Zyel3liJUVamJAMk7lBj44QjyvZO0UBcDZmr2cNOk4k?=
 =?us-ascii?Q?i1T85aWbuX9Ul1ys8XtJp86Ekfar8z0lyKbfNfAwD5z3sXPZLWw8mZwaiJu7?=
 =?us-ascii?Q?lVEgwi5u5PGqVTo1SIKIP9ACsyykeI95mqaeAa5wfETn7akiPjoGljfJ0qG9?=
 =?us-ascii?Q?r1GpgvkhiS7GxmOlwB7it1z72KY+hhOoi2tbCGYabMcekMCIlyrSTICOHcmo?=
 =?us-ascii?Q?1vVnGSCp4sHxBsaJxdwNKto26Ucm9YxFN6+uf0rUTvOUajlJkAMqWuNbWmn2?=
 =?us-ascii?Q?El+qBBFBX/kGHyqqEWGBqkjEpESrnl7XOx1Zn6zD1p2oS7CYrk3Bfyoy3fFL?=
 =?us-ascii?Q?z/LXWN2QCtvvYVeSrtD33rNLMv6UC6guxXVoVwq10NpIIoVWfDjYpcMMnEUg?=
 =?us-ascii?Q?vN6MTporAxzQVgDcQGzmiQueJI7mSzPnqDXhrQQ9OuyGk9m80TCGdPsnVGJt?=
 =?us-ascii?Q?ZNGIQwTxXmvIch8J+3+eJkqQFDd9NH71VN8GCsLfDrA3yLwy2Zv+vK9L4C32?=
 =?us-ascii?Q?8SqX2eAUskcwoLnlTkO/GxabLSc+3RRMUFo/2RmBP54rAGB8p1TLePKttkgi?=
 =?us-ascii?Q?FtxdMc193ICD60cQ4jivTQ1M5mAAUWq5H67/n1x9t4i9GawkmFG2JmaTWjlf?=
 =?us-ascii?Q?R6SK1N8ck3l0zqU+dd449xmCBOa/JByyq5Mn+bqLwkh0nWlP7F/37zjVkUk1?=
 =?us-ascii?Q?bfBemTI1pgTtQFOZ3lQuKSd1Sz3daV2i3mESuwSFTWB3ImkQQXDKFrbVIBmg?=
 =?us-ascii?Q?xP5AK5/TB5L2ZYag91DwuIkGLjhFUXoe1UduqFX0chBBrL9N9ZDNvwkIek6X?=
 =?us-ascii?Q?AuUFDpeSO+bDHaMiwfeip52K/hLDbYF4IFMgWLHM0tYcBPRz7OCgZVV/sXWZ?=
 =?us-ascii?Q?TcTKA8LPzLGunVkjCFSzJI4jiFOm+qhOvpc/k/8pUKQral3cESChP7kJGVHV?=
 =?us-ascii?Q?4YPEHUC6UD5dTUKVQ6EtrDGvESVqzd3inICQ5eQSJ98H5MyRpdUnONpY8nn0?=
 =?us-ascii?Q?WnenBd6Tfe+l8aAlzKCmWyo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7611b063-9ab8-4701-6fed-08dab112cf72
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 14:12:37.3633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4brCSFlIugeLxM9p7ET7+uxpadA6DN0J1pTLdq+D+g/m3S7Z7B6ATC666sV7PI64566qOQMR8OE7Ovw9Bi91hfnQtuLeBTE70W7gzfnMaWQRMU1Wi8j5HXCaub206DHw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6175
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

Thanks for your review. Replied inline.

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Tuesday, 18 October, 2022 7:45 PM
> To: Zulkifli, Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>
> Cc: intel-wired-lan@osuosl.org; netdev@vger.kernel.org; kuba@kernel.org;
> davem@davemloft.net; edumazet@google.com; Gunasekaran, Aravindhan
> <aravindhan.gunasekaran@intel.com>; gal@nvidia.com; saeed@kernel.org;
> leon@kernel.org; michael.chan@broadcom.com; andy@greyhouse.net;
> Gomes, Vinicius <vinicius.gomes@intel.com>
> Subject: Re: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP
> packets
>=20
> On Tue, Oct 18, 2022 at 09:07:28AM +0800, Muhammad Husaini Zulkifli
> wrote:
>=20
> > With these additional socket options, users can continue to utilise HW
> > timestamps for PTP while specifying non-PTP packets to use DMA
> > timestamps if the NIC can support them.
>=20
> What is the use case for reporting DMA transmit time?
>=20
> How is this better than using SOF_TIMESTAMPING_TX_SOFTWARE ?

The ideal situation is to use SOF TIMESTAMPING TX SOFTWARE.=20
Application side will undoubtedly want to utilize PHY timestamps as much as=
 possible.=20

But if every application requested the HW Tx timestamp, especially during p=
eriods of high load like TSN,=20
in some cases when the controller only supports 1 HW timestamp, it would be=
 a disaster.
We will observe some missing timestamp reported later.

Using the DMA transmit time for the tx timestamp, if supported, is one of t=
he solutions that we propose here.

>=20
>=20
> Thanks,
> Richard
