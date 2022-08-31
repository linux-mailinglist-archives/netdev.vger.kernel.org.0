Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E75F5A7C25
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 13:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiHaL0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 07:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiHaL0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 07:26:18 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2048.outbound.protection.outlook.com [40.107.212.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11BE25E3
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 04:26:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtkuEq4Fy5O77UBEJiMYl/jc4t9VoXc+Cas1QE8yHvOJb5sLukmJQSToPQEUy4755k/2TIYZQsFv7PJ90uqN3Dv597Eah1algq3Z46480A4FqCDHPuMWl06lYVCjv1hDqZOn2QeBRIu5qhSEvmtRvb6SwIlzTukNsk+9yAuSPf5f3SlCyqRhJnW0STov+lPD6aBhNwZpVJ6mdz48T0DwKHIAT2bt38GKibXyOMF3s/LXHfYwNNNrm0ZIplBquSQdeyVn0Gp9Nu/dh77VwKSMCVkvM6qZ9fLD0YG7J/BX1O1erGfPAJQAwNmbLfVzIEl/S7R/lmyFhujNVLMkMgF0kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DV72KTf6YNgl3U2I5Q+KhCVsKjxaADRhtN4dC70ot6w=;
 b=dQqAvk4e6Hlbmh9jmtnRzaTnCCC4ssmiqDweF759KQitRQsGMPrzf8b568tqK33Beo1tAc0bgqcbZZFI6TdZ2uhAz655xxdzKZYanwt7tpFpDGILn9SeSprNbq7ml3SeGhh/k2KlD52idrP+oPzZA3aluGq3JCsOg9LUGiwcCceImSQomWDQ2lv6tvoTCSvB24LfQWsfwMnZ/FFKQZyt8/IAtsbN1BGcijD6N3Mrq/AXB9kUNs81eaS/8L3jYdW0tdWJluFW4r8LjBMBw0NnaI3mzDiMJGo3HL2sKWCogmnmSCvQQXkL3BOY2pETJWzu/v5eHAhiyZIPuu9tWLVPtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DV72KTf6YNgl3U2I5Q+KhCVsKjxaADRhtN4dC70ot6w=;
 b=tJlOA7VpgoxIK2FfKnZwkfekDjVubv34FVsEI+g6EWpLBrR8K6kPeF8rITe7SzF1ewmNLyC+1LG5d+EOfEeZ12h2RFLxQBpzpMIUc1HCJ5EwXtvid/eOAwQEs52eB3bmFTv/nRFgkNfxVa693ZvWkxHlL2oTDutIfJvu1CihmB4GByUAPqSn83BjkDUNEBza71uAKu8XN4yQoNpags8LmOpK6JliCTYQkjk4IC0XrMlIfpc/tSnBkfRFywHeNZw/HPhDANRDhOKmI4hVCAnjbB5fkWDh6uMqk0xdP2M6OVW5qnemU/e5IaaWhKtgR1Tbi3V+1+9NaBPxWAygryi8jA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 11:26:14 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98%7]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 11:26:14 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "mst@redhat.com" <mst@redhat.com>
CC:     Gavi Teitz <gavi@nvidia.com>
Subject: RE: [PATCH v4 1/2] virtio-net: introduce and use helper function for
 guest gso support checks
Thread-Topic: [PATCH v4 1/2] virtio-net: introduce and use helper function for
 guest gso support checks
Thread-Index: AQHYvRiPn6VRJtzDQEyRckLWQsjYza3I3meQ
Date:   Wed, 31 Aug 2022 11:26:13 +0000
Message-ID: <PH0PR12MB54819F82D423B90F92DC256EDC789@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220831090305.63510-1-gavinl@nvidia.com>
 <20220831090305.63510-2-gavinl@nvidia.com>
In-Reply-To: <20220831090305.63510-2-gavinl@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f69eee34-9be6-416e-84dd-08da8b439d0d
x-ms-traffictypediagnostic: BL1PR12MB5062:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RfW/OemQRZvDH7beUGY7UuCSX0zSS5w8eOEQPC9mfQ4xwY4Oy2F8srU8abBchPk/DG7QCRN8T3utSfhziKWDmUtBf4p87rgXq+1/Ayc3rz4QolwvMDSkajbG1Jeel76gJnM/lWc+FC9nCNs02jx09HuFZu4TX0dq+iK5HeGodb3ni+aG0VUxn9TSoXonGtjvfh3yFUkKbyVNb2pEOO/n6YOWQdpY16y0YwfjYd3N6SKFV5LiOeNmrHsk/3Hahqmj1KAsDYTmkJWIu0tlZh8exrn2sKtg/Jq5By96Qf3kOGN9iiJ8PJk9iwMwn1P5IkAaf9tGOLjisD3HG982YHvsujH2uBGGWYXQayaHkHVmovsI6tD4yA3se3weXd9Pb6w5sYTmV5W8Uq8Sgx93iR7Akr+DMaNFpWV2isvtIk/4LLywDqNSx523nb/waGWL7ZP3CFU1rmAgBQISBKcoqD8hkq5+j7KBcLCAmK7s6JLS3Eal9EZGgVJDreZPOLRdz4nIkn0YjpudM2pVyoZZEw4Ugg/5BOJIXem6sJUJTxaEo/PtbSe48qC2sGDTK/DyypgDEOkc4NM2gHx7tPoY9K52CMGNxzu08WUQvrcxOu5Irufph7on2QIsnmduRV4hi3bXXHuSwf8kxGHb/BHznAYx44uKxbtCnVqWMNS35cpVxnZCg9vCq7IL6uyOA4Scgk4efEkEfO7Sj/b7ZCDKUrahKlcU2zJFFdtxcloZ6FzS4EUNGk2TaX7Yev6skK1iL4mZpT8NDNo4nsQZXz65PfxGnq0xiVOJo/eeZWDVH0qZO9c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(64756008)(478600001)(66556008)(4326008)(66476007)(316002)(66946007)(76116006)(66446008)(110136005)(71200400001)(55016003)(8676002)(38070700005)(2906002)(5660300002)(8936002)(52536014)(921005)(4744005)(7416002)(122000001)(38100700002)(86362001)(33656002)(9686003)(26005)(6506007)(107886003)(7696005)(186003)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5e1khJzAnRQYw9vD4+bYhyHXUgf3/cXr02f/pk9b5rh9tfxi2cLDjDrOFUBW?=
 =?us-ascii?Q?9HOvEN7quHM78N0jSw67SbhkWa+XOKJHhjlFtt9Kf4EmpD932Ifh1/6uihWk?=
 =?us-ascii?Q?+CiFudpz6wJOdoPrzi8KDF5NZg7DidQQtLBLBwK4GbbwiN6Lh4ybAHj2vQea?=
 =?us-ascii?Q?Mo4saS5J+Q/30Bjpc9BaT9vvZjt0jPDCvVeYpouNTfeFWO8OJ0Orbv0JmfhA?=
 =?us-ascii?Q?18ZlLG6AUD7H23SJdju2V9uf51Uj66iQg1oOMqr4oazrOJgdTG9C0J3Ze02f?=
 =?us-ascii?Q?0M6kUACEhuASuCEQdtjUbrs2IoeK6dP2E2fjyA8nEC/aw6IZWzJ0NR+nVGcU?=
 =?us-ascii?Q?ZV9NhjFw8bFYOdNgghEIkl0h756s6G2LzYaXc93MDQBFsji1HVjL9khMKZ9z?=
 =?us-ascii?Q?St+LPo81BHpC6ev6qJeD0+tqOaqv/uderyJSEUrKdAN0MEcTFX+hnYOLNOme?=
 =?us-ascii?Q?b41wIFeZLSpPmB3Jai+bVLkPYDIRLb+cYvlTWuErO3CtvwHPhyCHoC51R3zO?=
 =?us-ascii?Q?qwnBYgnf3VvuFMEs/6+b/Cw7wuJCWl+XE86JnazJUKlj+uhSwSoV5M5TxiIW?=
 =?us-ascii?Q?GR93W7FjdTNfa6JxfOoiCvEj9MMnsyTz3NCDI3tSkWVqGuFvAsWcfyuwdvp9?=
 =?us-ascii?Q?fNhgNoQyX3K4pzOABiFNVi6d79X6wI+5t3N5jf6pxrfde8LaaPVrMeZDgTYt?=
 =?us-ascii?Q?35VhhFwPHxjAzaIM9i4oiCCvz0FBLofm2J+YxTtscQ0uOXPxeRXL3cmavzKC?=
 =?us-ascii?Q?s2URFby96/8nOmo2Q+O3Nvdmyp/AUPFtEPKTrfHv/K4fNWzrF26JbHBI7TZv?=
 =?us-ascii?Q?BDF43sOTfofves465mEP0SML+4Db/DbMvJACG8xi+pgK8oGcOzmaqwDtJdBp?=
 =?us-ascii?Q?Xb3fXVFujwcm3kh9P5DWSw2iTe0wpOBDbbP0NJTfQdTu+buEodLqRT12cWSG?=
 =?us-ascii?Q?rI2yvoUgiGCeaCbwU+iHgwV+8HrnJYUHMCskUOFP3XL4gXbWr5rTnA3g8uxd?=
 =?us-ascii?Q?yhJSThCWp28z/Ng7/dHLkMNAHbenUzmZyruHHaUUtqwINyeknuxbYWIMYRZL?=
 =?us-ascii?Q?CbllVJbNSGl57Pfo6o6xKqh5989c1dKsRBBVTlMyTpMHxigxIAqbTtBogeQg?=
 =?us-ascii?Q?ViuRX/gdHSIbhXUtErDo0T3AAK0tjjyn39bOUudmwLWrsNkclanNib8zQWn1?=
 =?us-ascii?Q?fEwAJOJCaUKqqrOkfSoTsfRPvwQs3bilohnvr8gco3wdsHwyS6MT/ABseT2y?=
 =?us-ascii?Q?fVrcYLhyuCDrWkWWSQQhb2lzaL6TSLoFrzETb7B0KyvT+n4iZEhzcPRJJ0Os?=
 =?us-ascii?Q?68uOmR3ZFRwBcEafWlFPVd5es43P58a3lVlKlmzJ2JzXeEDsM9W8QErk4uZk?=
 =?us-ascii?Q?Xe1hvGDa+dvgBtszdtIrCZOGSttSGiGZG4t6mfi3/P172mIpjtkx4MKLsHcY?=
 =?us-ascii?Q?8H/uWQpJDmk6MUPY3M/gt05JtkkAUNd4wNhWMeN1HabYe3vd+DXZP6rCzZwn?=
 =?us-ascii?Q?lFwHkx8Bd8QJt6Jva+piT/SuLv5aSUYUWwQjI39qhkiwFwo0k1dx1Y1oIOOg?=
 =?us-ascii?Q?5s0jOIVlVnUTksvdkyI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f69eee34-9be6-416e-84dd-08da8b439d0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2022 11:26:14.0012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5W7QVcXNmWk3n4rG8KuR+rT+/SjyAIr+37Oi3vMeAeSMn8U9+K+hUJaBgwgdd+Bh4OSFiOIoS+XO7qok1V8hpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5062
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Gavin Li <gavinl@nvidia.com>
> Sent: Wednesday, August 31, 2022 5:03 AM
>=20
> Probe routine is already several hundred lines.
> Use helper function for guest gso support check.
>=20
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>

You missed the review by and ack by entries that were added in the email re=
ply for v3 for this, and 2nd patch.
Please add them.
