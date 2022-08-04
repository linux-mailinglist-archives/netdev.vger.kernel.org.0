Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993D7589BF6
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 14:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbiHDMyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 08:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiHDMyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 08:54:15 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02641EAD6;
        Thu,  4 Aug 2022 05:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659617655; x=1691153655;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=55gLq/Evz7860X870V3xMl8C7NdTHRdmbsUo5zw4ovk=;
  b=BxFOxpgPftN73a/yzsKDrkPCHXfhTGLFxv+DzkVJXenRWXI7Tu+V1S/g
   dx5aiHx6Q/r/VNFFCRUv4vG52BHj+OPqOQjoNOHnq7Yz1YzmizAS7YKk7
   2O6QLal1JBTJG3dwVzSG+Q8B6z5+61vDZYj1TUCIeZLGzFqvz1gQsZhr1
   13xoxXB+pVmlEN9ijKFZgLQjLGr+43FKyfZL7sS5u14igO6RNyfdMk1zM
   XsKLFMf1ojELtlPsG8Lo+LApn7h2QUyxGdEgX4TxTHy4XXAce9fZruVHz
   fWedL2Hs41sSX7DH1Yxb/kBDkO/mb5+dK40BrXgzFQfS1sXcgBc4/vcc+
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10429"; a="290698145"
X-IronPort-AV: E=Sophos;i="5.93,215,1654585200"; 
   d="scan'208";a="290698145"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 05:54:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,215,1654585200"; 
   d="scan'208";a="729579380"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 04 Aug 2022 05:54:00 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 4 Aug 2022 05:54:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 4 Aug 2022 05:54:00 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 4 Aug 2022 05:53:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QygraVTch9Rbe2F4c2smufCHxJBXoHCUYs0ACd5aoihlluczJX1B8eI3MAgMphr5FDOQkwVKfiePsciNpKS5Z9HkSAzopHaWNHsxfv+ZZYUriQIHsfqwucJeiIFIFooCKj+RFSdC2Hi3oOXxeyUqgARhCZMKQuCUtC7XFLpoYaB6vpkR+oqX/lCT/utZ/G1cC6+RsJTpIUcy+EIIxarbpxWnlzyet1Y9iFXAH9m0VG9Rl4oBW51Ur8Jw+DkILRWKnJfA3MK5ZRa17rTBmpTvSt4Nt1YUE8k3Uo3vOka0f6s18GwNM3drAdbvmRcCuFBuq9jiYCTnR6oRRiMAzH8+Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hAN9II9paxihWFFejoGMNnBI94A3JTRLhu0h2kZ1N1I=;
 b=BHx1KcGmbFEdQRXsdqBKHYmjPVDhEue/nHmK4HaXKu5K0jT7aj2BFyZl+elm9UJ+eJnYAA6YEdaq2TQjV1+lFoh9YAQH9BFfZCCKjgio4Jyvyl2ENAbFGOmfS5pxtijnS8lN4danLELXQFl0QxDe5u5luhgvzjWZzIj86THUt/xPGMFALJBgadlNg77Ny5bq2rV4TGsF2d9NadJZoB+MJ0bXMs6wxKB93tjx8FkGVCbdBqITWOF8wI8kAzX/txTx7kWjmf4K6aYm0Pfh1M5Q1eZZqfAwhp1fB8ldNGYDqzjughApNjhfzBA0epu3KUaWDiBCTVymFKx7pZEyUdAt2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BL1PR11MB5239.namprd11.prod.outlook.com (2603:10b6:208:31a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Thu, 4 Aug
 2022 12:53:57 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::682f:e9fd:d1d7:f3b9]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::682f:e9fd:d1d7:f3b9%4]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 12:53:56 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "Weiny, Ira" <ira.weiny@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in
 ixgbe_check_lbtest_frame()
Thread-Topic: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in
 ixgbe_check_lbtest_frame()
Thread-Index: AQHYi8qqEhC7uGL1skKc8LIYqnadyK2e6oNg
Date:   Thu, 4 Aug 2022 12:53:55 +0000
Message-ID: <BYAPR11MB3367DD6AC06593E589092ED2FC9F9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220629085836.18042-1-fmdefrancesco@gmail.com>
In-Reply-To: <20220629085836.18042-1-fmdefrancesco@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 174daddc-a627-4616-304c-08da76186444
x-ms-traffictypediagnostic: BL1PR11MB5239:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /zZf3VwlmargIlCXWeQDHWYkRmHY+Py2jzzO1UAsENlxmbE9VjOjtmIllKlU96G3NbQjetPEnF2fD3IVkXwSAanGYP19IPVeFv4SMErMgH5QoB+ozAqKHpMavv3z482ZvI+LwIbamp1QI1ZiZxNnIbs0gI0vJiLPeVndkB00yq8KxyqQnZZQABzBECybqAM6ID4qIN1XVYL3kOQ+Mbnt38MzTky9uyowWVe8QZEturAVgrHWCFHkgtwkcgN/9kFMhCOkbu3TX/MLkS3r4CYsmohJan90J28pATpwUwe/W6VLIXg+7nUudjmo3mRB74zLYcCVl8UJiQwabfTP7/CYXtWyXk8CN9/QZ9W+quxqJFiDA8ihTK35fEFz4vcG4PHtuomSh6BbMbUwsSXGlAo9ZG2T4NCiTbpP9+2gqWSWVkvIIh/Arr/7uFqsT3paBNJ4avS2Exx1wMC6AqRsV39VLvG4G9C02l5MIn4IQLtqz91NQzrkdPXcN1Nnd235n+dOmwiYLNQtzJU2EsA2UgWP/q7T/1dHakOkKu2cp7WoStcKytxaqXBCngKZW6kzxSguIqVLRe/Z15tJSZX2FtuMpIu6R+F48kifaxrjsAMiC76vM66yQTLTGUJzBsoneQWqZDxf+52dqGSi0NXGh6TL8uWzXO8ykXcjm+e/teFc0c1f6nyg8Zzlj8wcq7NqF35Le6HjMGQc/+usBI6tucCT9uZBBMxLxrj37e7sqRLs8zKhwtstZOeHyXUV0Z/QkqDRNY6EWbKkNXVvlHDalbei6PWYxKIeSO/StDO4va8XNL43a7jOOrGVeo4WD7c+zaRMdJcURMvhfVHfLm25YE0vTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(376002)(136003)(346002)(366004)(122000001)(71200400001)(38100700002)(186003)(107886003)(83380400001)(2906002)(33656002)(5660300002)(7416002)(478600001)(8936002)(921005)(55016003)(316002)(86362001)(52536014)(110136005)(9686003)(7696005)(6506007)(53546011)(26005)(41300700001)(82960400001)(38070700005)(66476007)(66446008)(8676002)(4326008)(64756008)(66556008)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1tJ8NSnRHfEI6B0bZwq/nRzj3xqG/RdCB3ysuaPasA1iQljSv7T8uFH8jNPi?=
 =?us-ascii?Q?8B1qTvFkRUNlKU9xGPKka+i3LiqhzFpolOb8A4bHlzXd2idwUPoL8x7LXjjA?=
 =?us-ascii?Q?4UUKPdR59yc5oq2Gtfz7XFRSo3rstsnJxGBsW3322YK/0ViYp3rrhzTYwRcO?=
 =?us-ascii?Q?qBGYwnoh1xfE0BXlwuvfqsXTWNEjmMvDa02K2ZSfxiL9AW4F73/6ErfprGoo?=
 =?us-ascii?Q?H4fZz2dK4ycQz989RCXGL/qz3M3EBBRg/PCrGV/jpFQgvDnL7THV7eEtYAr1?=
 =?us-ascii?Q?9x0Jprhsr/zL+RvabJyjnAvQWLjv9uLIFrgqbu0SXaUOo/c7eMqv/K9Tj3fV?=
 =?us-ascii?Q?IYkdNQUD+cXyHjrM7FMqi1uR3PLbrsTDP9nNpWwv73RQhXgekBaxNbp+VxvA?=
 =?us-ascii?Q?JMzR8F2+phQJaF0WyOEG6Akn1qx77LSsAgyWVYmByc3X4AFa6AWblyrXIIG5?=
 =?us-ascii?Q?nrhDEA+doQoQ41T6lL4tgPv/WFEJy5lOb0O4BbiS8ffDeKfw09JSygHX8Nqt?=
 =?us-ascii?Q?YDg1Kgqkak/yiQRxPdQZMN6iAPJFevxfbjUlBKTZuCqCtrFMOcX+iOkwafAj?=
 =?us-ascii?Q?RQ6Bv79D4YE4Xq4aKiET9AF73ZXZ3gCDl+zH1Z95ZW1rinjyhPKy2hw0K+w8?=
 =?us-ascii?Q?0q2wDXq3ET3M+93SjJaRK6gVadcLebzN3WVmiSSwze8yALPQJ9TsbGcYG30y?=
 =?us-ascii?Q?SotGFDmrw21B8TbDtorOyL/zGsz88kM1jIX4LX4RozGoS/lHX1w979vPTuwk?=
 =?us-ascii?Q?xPsJBCpZGcFo3Ew6uc/k2s47FON1SGOi59SHWhFQc3NC8SCeY1+p2E/fJDCp?=
 =?us-ascii?Q?cWoBRj2f8qkh2E+dauTutjmDlSqDzEVedB5dWjO3WcUTffmGoV2VLTajXgFc?=
 =?us-ascii?Q?u5ftB1LeONPlW2HuRMMaN5PtyUNhREvM5YlsJHYdcZFPaV2HNM56o0GgJw7D?=
 =?us-ascii?Q?3j2n5Kj4Pfffh9/whlTOhtFanKzpVmyuKIJr5Ivqo5TZN0kh36COMFTcDaZB?=
 =?us-ascii?Q?hCRhBFk8u5++KaHcsAAs4an8xNw7znVu3Nn/KwVPcQdi/IIlnSJDPFpb4wNQ?=
 =?us-ascii?Q?PkIphM28deZL0/Lzq+ZKtU7rbAyP7N9WiirGNwgpgp24P19TzBUmL7R8tcVA?=
 =?us-ascii?Q?040vYNU6h6xIJhT8irm1nKujW5YN31uNCXoHnFrpZe8TCTJO5OY+p8+85TBJ?=
 =?us-ascii?Q?O/S9qmUgNlMlpOVLoO6eSsMb7Vge2SxwsIg8DT4MqfhecPV/D961zepPjtyC?=
 =?us-ascii?Q?1M6QztUgXzI+AKjbhhlIZQOJf9+C+r5afR3M2sXXD/+NTAygeyK236fISw6d?=
 =?us-ascii?Q?CT7Bbx2dLGMRnXD7gYsSewJ5KYSAM90/NPV9lCav15/GaVg3gwv35QY+xj8h?=
 =?us-ascii?Q?Wg+laEkLV8t6BcmdxQANK20M2cMAmNomRS5orsLzFf2Ah6i2m3gK5dO+PaOH?=
 =?us-ascii?Q?pfuS0naVTt1giY/yr7sx+x5gzh60P5O5l7G40crpV9WzpadrtuRrvGreu/qL?=
 =?us-ascii?Q?iywVHumGJwa7b7dA8/NOYut2jLgeie2foDRDj1xGGinPf7i4PoV0WtMYYQAp?=
 =?us-ascii?Q?i5ffnwGzZwPCqVFByrJM3pbUJf4Gq/wVplML0w4H?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 174daddc-a627-4616-304c-08da76186444
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2022 12:53:55.9517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 71gLqE66xnscU00lFe+hYE7w3qqseyJWXi5OESpVq+SMn/atNLfHhqXCg0MsvsGCwm2bBoqW98ezFoSzgasO3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5239
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Fabio M. De Francesco
> Sent: Wednesday, June 29, 2022 2:29 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Alexei Starovoitov <ast@kernel.org>;
> Daniel Borkmann <daniel@iogearbox.net>; Jesper Dangaard Brouer
> <hawk@kernel.org>; John Fastabend <john.fastabend@gmail.com>; intel-
> wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; bpf@vger.kernel.org
> Cc: Weiny, Ira <ira.weiny@intel.com>; Fabio M. De Francesco
> <fmdefrancesco@gmail.com>
> Subject: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in
> ixgbe_check_lbtest_frame()
>=20
> The use of kmap() is being deprecated in favor of kmap_local_page().
>=20
> With kmap_local_page(), the mapping is per thread, CPU local and not
> globally visible. Furthermore, the mapping can be acquired from any conte=
xt
> (including interrupts).
>=20
> Therefore, use kmap_local_page() in ixgbe_check_lbtest_frame() because
> this mapping is per thread, CPU local, and not globally visible.
>=20
> Suggested-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
