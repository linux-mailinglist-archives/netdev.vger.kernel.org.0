Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991184EB008
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 17:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238365AbiC2POg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 11:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235294AbiC2POe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 11:14:34 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1C823C0CD;
        Tue, 29 Mar 2022 08:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648566771; x=1680102771;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sdRhRixenv2UvaWjGKI12gt2Pg6OBK9VSJgutLPFqIA=;
  b=kuJUlIziyez6ylQSlRJ5tPmylpLfWryqmhM1rN+UB+CW5QUqMx/WgueZ
   2E8P5HLi12lLcJ4aR78W94r8y67xZ1jxE8NOy3oqeJvQKmahJTmQmGfjk
   koBbKs8ptm7CjbJyKckVDty52gIgdu78kIPITzLtq4DjzOpbW9d+hVUtO
   M5jttC0o7heJVJao1xdS0239HYinfuK3bT9knSvUv2mxLXUEX52dLR4SO
   P6DXWX1VrCVyRV49V7s0kxfvcz6KSdbGsZJisXI6lrB3+ggVQoKABpoaj
   7de13m9Czt/CsrsVmPqG+TZIqniPwnG8v9cM9cVRpbTBcRA0vAxGZerw7
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10301"; a="241426802"
X-IronPort-AV: E=Sophos;i="5.90,220,1643702400"; 
   d="scan'208";a="241426802"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2022 08:12:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,220,1643702400"; 
   d="scan'208";a="719560449"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 29 Mar 2022 08:12:48 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 29 Mar 2022 08:12:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 29 Mar 2022 08:12:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 29 Mar 2022 08:12:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zz75UEMDTlE0H6TpQOV2WqJYF6O/YQ+DVD/VCg8lHLyfSDh1bbwxUBzOsC7sAvbhrjU6/lDOB/nmACfcuF0JAuNKX/5YEFw9igUhZi6xTHDCS6ArkHZFZB5AEZKbOTdxUD8vj2U+pn77UBEh5lHKERJCJdMgj8avr7OJaCzwchE5xNIKDx9+8Adp53cpwRzYjziwYsQ7CWgKvNaQ5eNEQgONyca96TDkTEi5zIDsnKs9Sgg0K0u+tFkWnt27rF+KLkNyUhBtbsQ3vMnWa0PIl7uIFMjAvWUNWC0Ac6JBHOmM+2jFPrpLf2J5vXZDKn80ToXvYE/tHEqDGKcvhqWbKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Li7Wh0kX1ceh0EK+VmjsYjv67jlWAMVn9xzCXC22290=;
 b=Atnas3jQWefVgk3ByyD20N2103GQA7prfNUW4SiQVjBTzgLrZytDKxlc6kQQZ0HEOM/yUVLmmp7lt0JjjstYKL74/myqkOq9KWVNvgZOLLuKXJr8Es7SnC1U1DNGXfkZfT0P0v9oSLME1qk4hLHyAyUUUYD+WFNc2w28ZgBr9FQ1/E+qmGePmrMQ5oLrT0Bwp4zpkNyqADhzHs18ntYeqGk+h6si/QZahQODvJ7tEFeclwexO7jCkVfHvBiUtf3sO3Sb2XqMR99oElSNd01aTlO58iMV+1xb8GjieG4NgRZ55fkfBCJm/891VgIByjziQgQllTHD7sbHC+CZCQR3TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5782.namprd11.prod.outlook.com (2603:10b6:510:147::11)
 by MWHPR11MB0029.namprd11.prod.outlook.com (2603:10b6:301:67::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 15:12:44 +0000
Received: from PH0PR11MB5782.namprd11.prod.outlook.com
 ([fe80::d05d:3959:c1a5:3186]) by PH0PR11MB5782.namprd11.prod.outlook.com
 ([fe80::d05d:3959:c1a5:3186%2]) with mapi id 15.20.5102.022; Tue, 29 Mar 2022
 15:12:44 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        "Szapar-Mudlaw, Martyna" <martyna.szapar-mudlaw@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 net-next 5/5] ice: switch: convert packet template
 match code to rodata
Thread-Topic: [PATCH v4 net-next 5/5] ice: switch: convert packet template
 match code to rodata
Thread-Index: AQHYPRMJ92+1NW32A0exEsBYMS8inqzWgzEA
Date:   Tue, 29 Mar 2022 15:12:44 +0000
Message-ID: <PH0PR11MB5782637EA9771D3ED4E56012FD1E9@PH0PR11MB5782.namprd11.prod.outlook.com>
References: <20220321105954.843154-1-alexandr.lobakin@intel.com>
 <20220321105954.843154-6-alexandr.lobakin@intel.com>
In-Reply-To: <20220321105954.843154-6-alexandr.lobakin@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d46217b1-cd13-4015-885b-08da11969380
x-ms-traffictypediagnostic: MWHPR11MB0029:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR11MB00290B3061BEC0338DDCB993FD1E9@MWHPR11MB0029.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zv41LSkOPGLIqymDehi5AJUcZFpPNc5CdYTgsjFu1eQaQMfXXRiSSA889XSqr+TCck4+VtNiTGpGPOo3ziTY5ABdV/HnKsxQVPTUh+CqT8QG3myOMsiDgiF7G67VW2gMQBsXNf20uJGslbR7sW7LMxJr/EC9t6OdzqhQuMBETwLB6TiAvym46XIvIteldq4aABJee3Obc4EyduFicjeonBHBjJRWn0okLtvKzZ91WKyPlUrV+ynxesOKdaKDF93K4cGDXNSLfiPalm+pg5npEp5kgYhP13c7ngEm1cTMuekYnv3yykUW6pWjwqGLqpZeAg8sVAaxN0oth7AqsdY7OlXtQJqY6do+4iOJvBvwHgMnYxemfQe8a4TEwB71UmXQOQwKuYWne33j+qS+Cj96nPzgzXN5NjgJxE9gxyY5m2HJJq6wYPeIGZ0yjlcl1lU0WSvX7bsO61eX2NEMz/O2bcvzJNz5AAORLIhF8+Ozg4A2JcZotAI6oRdaxtBiEz6gibbnzCerFQDjHZWJ7ZeApl9KAM/1EDzV0rw0O+Xoskscz/fphLr63IlXvpmLCJyCKpZNczZz5FUkuJcI/k8QtIuVrA2Bj5rHJFBDiYuSquvqqTMnT7fyBxMVCVjPWOdDr/lFVereoHqxHdcaqpfdmzyDTlE1/2madem0+AuU21tXRztSMz/GxpQDvzfBrBEfDIDQZu3Ds3W7qvepLLfqbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5782.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(8676002)(66556008)(55016003)(66946007)(66446008)(9686003)(64756008)(66476007)(4326008)(7696005)(6506007)(110136005)(316002)(53546011)(122000001)(33656002)(26005)(186003)(54906003)(82960400001)(52536014)(66574015)(5660300002)(83380400001)(8936002)(38070700005)(86362001)(38100700002)(508600001)(71200400001)(2906002)(30864003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?h4PHv/vvsayCCYD48F44maLDzq5jmHbf/LZfy7uMUEzyuAt1hTo/bCBuUU?=
 =?iso-8859-2?Q?ffoPZV9ZpbgxmTZ4lwvN6l2AB1blxedu0SqXxoTfa1pieK8ssLyo0orza1?=
 =?iso-8859-2?Q?FvN8nCtMhasDNy+W2b1Lr4na6lqlNuN6X+RsUhSgnPoKKFOisG3MeRvrBK?=
 =?iso-8859-2?Q?5mv2+45wIhc2GyuzAZFtzCTawBS5lLsJBi10Ux4EheLVkZwn9Pog7185P+?=
 =?iso-8859-2?Q?KKdXQ1Y9So+FiZIzpydSibeYIPm4GhO/W9ufYGo7yvSs/xwsFvNXQ1JZvW?=
 =?iso-8859-2?Q?N58v1d8LgdtdSYYsjUQ9ruauisi3su64J/k2duJOzELafatHDrvJ+fCCuQ?=
 =?iso-8859-2?Q?WovTrrsL1lyjZzTr6PFsWFzMdY2U74uhSC1mU4qUheIRQpTSzbiurmtcd3?=
 =?iso-8859-2?Q?bzCeWSY9+bEYm1lSKID8hMiakAvO5TiV/mNPlan4aNztEU2Af/5wab2Zy2?=
 =?iso-8859-2?Q?01LTHFPl4l5tvf11a2I5rVxB4bkI+lhYindT8JI6/W7tVLxUXrS8exQaXf?=
 =?iso-8859-2?Q?J83ozhDeIJakv7j7VvfOAAulr+egI/ey7RQ28mxIR7JIyZ1zdZb6QBgaAP?=
 =?iso-8859-2?Q?TmYuyJzma4a46QSK8DBgE3VxIx3UQxZ4hDjyTCsS10Y1cD/uA80eVHf36b?=
 =?iso-8859-2?Q?K+TWqVXQyfRVudX3uHLG+LCjB6zzZVFbB0Bp51+ne9lUvwC8nY+7qXpV+7?=
 =?iso-8859-2?Q?P6YbipcYshvN1uErDzfKGm/j21aXEDhfsgXkPpmWtyAnF0sWtXQZlMBo2V?=
 =?iso-8859-2?Q?2A1+IlFBjrfH6izQGdESxLjwoL/6g6hh7UV3kNuF8GS7j2cngJyLq5dqRt?=
 =?iso-8859-2?Q?O4dt8N3/AaUac8gknwMs7ngZuQ3cuD0c9nMoEUgy9s6bbPlec2xtpGKFOG?=
 =?iso-8859-2?Q?dgsID6avV9ttvjRqSLXf9tC8v0z1ZBjNGaq9iKqUBzFZ0U4wZvQhBp5IIx?=
 =?iso-8859-2?Q?AjWJdj7jcQTBpd9CVAHitOR33EW8XjYU4JdgDdin/OznKzYSeNuNCOqeUw?=
 =?iso-8859-2?Q?TIm4UubDu1gQrAYWATsxcMLzyGNH4qs6d6kPkL7myTzbTpymH011PYNvo7?=
 =?iso-8859-2?Q?G9ugMINZOp81vMhWOvD3dI+ZWcTl/jDCHEB6KwPK6Ko9OOprp1IunwmGnn?=
 =?iso-8859-2?Q?p8iqjfzB4lEiMgf7BB1uHu6vMgoIO4joeQr3QcKwOHSkQNiVUXtcxLr2ct?=
 =?iso-8859-2?Q?leP/M6XeARBp0f0NIPtl94rVqnmLU30sDrXWVgLm2pmj9Ivd/7r/NWhHis?=
 =?iso-8859-2?Q?3cL5ukCkVusEr8Sge3evxM1SL7Hb2xR+7/w/n8eYW3IMuiVkumnJwk2wmF?=
 =?iso-8859-2?Q?p6W21VX4SIo/hbiuLLCaLs127edoK7b3S9xiZrk9Nz1+RETtJTVvKKf5eB?=
 =?iso-8859-2?Q?qTH5raXf++Sj73c80D4Jkw8qozu4kfRwPqvNv2AUv8MfXgZIUWEfpXlLb4?=
 =?iso-8859-2?Q?Hfwe9WMMY6LDbg2Jfpq5ynzytn7tkbefmzLC6f3lTXc5cqyikU74MtdDpe?=
 =?iso-8859-2?Q?s9VqVR7rplMVx84nqhFU6fb23FLSWo8B6bIkrgkYgCtK0sJGMskXEhatgX?=
 =?iso-8859-2?Q?BkSDFZlzZXd4ON86Oozt4gDDQiXVJzNeqY71TmR1na43xggJeKM4ZUKYWO?=
 =?iso-8859-2?Q?+WIPGH2Xlf3P5B3e7a9eZ8VYKhmN3PrnKXPTV+185cGv6B3nAO73PLUXRq?=
 =?iso-8859-2?Q?uzayowgcRb10ufZImUfp6IVvljGDsdTeeTW1BVngI3ghyuhK02w3TRb4E5?=
 =?iso-8859-2?Q?TStuTNZeUPuLImt3Ky/v4uH2jYCuolH/SQ/2WKBlLN2qzeCqjtOG//7wEr?=
 =?iso-8859-2?Q?LNW2xPgV2g=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5782.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d46217b1-cd13-4015-885b-08da11969380
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2022 15:12:44.2693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XATaCUoXqT27RrCy/R8O4Ua5P4aGxMSLl0EkbTTg9/3jyBwkIXrIhdoxolyrCrmrOaJW71Z9CTAc88b1mSJ8GlPd2pltkIvPtscQHS678CY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0029
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

> -----Original Message-----
> From: Lobakin, Alexandr <alexandr.lobakin@intel.com>
> Sent: poniedzia=B3ek, 21 marca 2022 12:00
> To: intel-wired-lan@lists.osuosl.org
> Cc: Lobakin, Alexandr <alexandr.lobakin@intel.com>; Fijalkowski, Maciej <=
maciej.fijalkowski@intel.com>; Michal Swiatkowski
> <michal.swiatkowski@linux.intel.com>; Drewek, Wojciech <wojciech.drewek@i=
ntel.com>; Marcin Szycik
> <marcin.szycik@linux.intel.com>; Szapar-Mudlaw, Martyna <martyna.szapar-m=
udlaw@intel.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pab=
eni@redhat.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH v4 net-next 5/5] ice: switch: convert packet template mat=
ch code to rodata
>=20
> Trade text size for rodata size and replace tons of nested if-elses
> to the const mask match based structs. The almost entire
> ice_find_dummy_packet() now becomes just one plain while-increment
> loop. The order in ice_dummy_pkt_profiles[] should be same with the
> if-elses order previously, as masks become less and less strict
> through the array to follow the original code flow.
> Apart from removing 80 locs of 4-level if-elses, it brings a solid
> text size optimization:
>=20
> add/remove: 0/1 grow/shrink: 1/1 up/down: 2/-1058 (-1056)
> Function                                     old     new   delta
> ice_fill_adv_dummy_packet                    289     291      +2
> ice_adv_add_update_vsi_list                  201       -    -201
> ice_add_adv_rule                            2950    2093    -857
> Total: Before=3D414512, After=3D413456, chg -0.25%
> add/remove: 53/52 grow/shrink: 0/0 up/down: 4660/-3988 (672)
> RO Data                                      old     new   delta
> ice_dummy_pkt_profiles                         -     672    +672
> Total: Before=3D37895, After=3D38567, chg +1.77%
>=20
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Tested-by: Marcin Szycik <marcin.szycik@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_switch.c | 215 ++++++++++----------
>  1 file changed, 108 insertions(+), 107 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/et=
hernet/intel/ice/ice_switch.c
> index cde9e480ea89..ed7130b7abfe 100644
> --- a/drivers/net/ethernet/intel/ice/ice_switch.c
> +++ b/drivers/net/ethernet/intel/ice/ice_switch.c
> @@ -30,6 +30,19 @@ static const u8 dummy_eth_header[DUMMY_ETH_HDR_LEN] =
=3D { 0x2, 0, 0, 0, 0, 0,
>  							0x2, 0, 0, 0, 0, 0,
>  							0x81, 0, 0, 0};
>=20
> +enum {
> +	ICE_PKT_VLAN		=3D BIT(0),
> +	ICE_PKT_OUTER_IPV6	=3D BIT(1),
> +	ICE_PKT_TUN_GTPC	=3D BIT(2),
> +	ICE_PKT_TUN_GTPU	=3D BIT(3),
> +	ICE_PKT_TUN_NVGRE	=3D BIT(4),
> +	ICE_PKT_TUN_UDP		=3D BIT(5),
> +	ICE_PKT_INNER_IPV6	=3D BIT(6),
> +	ICE_PKT_INNER_TCP	=3D BIT(7),
> +	ICE_PKT_INNER_UDP	=3D BIT(8),
> +	ICE_PKT_GTP_NOPAY	=3D BIT(9),
> +};
> +
>  struct ice_dummy_pkt_offsets {
>  	enum ice_protocol_type type;
>  	u16 offset; /* ICE_PROTOCOL_LAST indicates end of list */
> @@ -38,23 +51,23 @@ struct ice_dummy_pkt_offsets {
>  struct ice_dummy_pkt_profile {
>  	const struct ice_dummy_pkt_offsets *offsets;
>  	const u8 *pkt;
> +	u32 match;
>  	u16 pkt_len;
>  };
>=20
> -#define ICE_DECLARE_PKT_OFFSETS(type)					\
> -	static const struct ice_dummy_pkt_offsets			\
> +#define ICE_DECLARE_PKT_OFFSETS(type)				\
> +	static const struct ice_dummy_pkt_offsets		\
>  	ice_dummy_##type##_packet_offsets[]
>=20
> -#define ICE_DECLARE_PKT_TEMPLATE(type)					\
> +#define ICE_DECLARE_PKT_TEMPLATE(type)				\
>  	static const u8 ice_dummy_##type##_packet[]
>=20
> -#define ICE_PKT_PROFILE(type) ({					\
> -	(struct ice_dummy_pkt_profile){					\
> -		.pkt		=3D ice_dummy_##type##_packet,		\
> -		.pkt_len	=3D sizeof(ice_dummy_##type##_packet),	\
> -		.offsets	=3D ice_dummy_##type##_packet_offsets,	\
> -	};								\
> -})
> +#define ICE_PKT_PROFILE(type, m) {				\
> +	.match		=3D (m),					\
> +	.pkt		=3D ice_dummy_##type##_packet,		\
> +	.pkt_len	=3D sizeof(ice_dummy_##type##_packet),	\
> +	.offsets	=3D ice_dummy_##type##_packet_offsets,	\
> +}
>=20
>  ICE_DECLARE_PKT_OFFSETS(gre_tcp) =3D {
>  	{ ICE_MAC_OFOS,		0 },
> @@ -1220,6 +1233,55 @@ ICE_DECLARE_PKT_TEMPLATE(ipv6_gtp) =3D {
>  	0x00, 0x00,
>  };
>=20
> +static const struct ice_dummy_pkt_profile ice_dummy_pkt_profiles[] =3D {
> +	ICE_PKT_PROFILE(ipv6_gtp, ICE_PKT_TUN_GTPU | ICE_PKT_OUTER_IPV6 |
> +				  ICE_PKT_GTP_NOPAY),
> +	ICE_PKT_PROFILE(ipv6_gtpu_ipv6_udp, ICE_PKT_TUN_GTPU |
> +					    ICE_PKT_OUTER_IPV6 |
> +					    ICE_PKT_INNER_IPV6 |
> +					    ICE_PKT_INNER_UDP),
> +	ICE_PKT_PROFILE(ipv6_gtpu_ipv6_tcp, ICE_PKT_TUN_GTPU |
> +					    ICE_PKT_OUTER_IPV6 |
> +					    ICE_PKT_INNER_IPV6),
> +	ICE_PKT_PROFILE(ipv6_gtpu_ipv4_udp, ICE_PKT_TUN_GTPU |
> +					    ICE_PKT_OUTER_IPV6 |
> +					    ICE_PKT_INNER_UDP),
> +	ICE_PKT_PROFILE(ipv6_gtpu_ipv4_tcp, ICE_PKT_TUN_GTPU |
> +					    ICE_PKT_OUTER_IPV6),
> +	ICE_PKT_PROFILE(ipv4_gtpu_ipv4, ICE_PKT_TUN_GTPU | ICE_PKT_GTP_NOPAY),
> +	ICE_PKT_PROFILE(ipv4_gtpu_ipv6_udp, ICE_PKT_TUN_GTPU |
> +					    ICE_PKT_INNER_IPV6 |
> +					    ICE_PKT_INNER_UDP),
> +	ICE_PKT_PROFILE(ipv4_gtpu_ipv6_tcp, ICE_PKT_TUN_GTPU |
> +					    ICE_PKT_INNER_IPV6),
> +	ICE_PKT_PROFILE(ipv4_gtpu_ipv4_udp, ICE_PKT_TUN_GTPU |
> +					    ICE_PKT_INNER_UDP),
> +	ICE_PKT_PROFILE(ipv4_gtpu_ipv4_tcp, ICE_PKT_TUN_GTPU),
> +	ICE_PKT_PROFILE(ipv6_gtp, ICE_PKT_TUN_GTPC | ICE_PKT_OUTER_IPV6),
> +	ICE_PKT_PROFILE(ipv4_gtpu_ipv4, ICE_PKT_TUN_GTPC),
> +	ICE_PKT_PROFILE(gre_ipv6_tcp, ICE_PKT_TUN_NVGRE | ICE_PKT_INNER_IPV6 |
> +				      ICE_PKT_INNER_TCP),
> +	ICE_PKT_PROFILE(gre_tcp, ICE_PKT_TUN_NVGRE | ICE_PKT_INNER_TCP),
> +	ICE_PKT_PROFILE(gre_ipv6_udp, ICE_PKT_TUN_NVGRE | ICE_PKT_INNER_IPV6),
> +	ICE_PKT_PROFILE(gre_udp, ICE_PKT_TUN_NVGRE),
> +	ICE_PKT_PROFILE(udp_tun_ipv6_tcp, ICE_PKT_TUN_UDP |
> +					  ICE_PKT_INNER_IPV6 |
> +					  ICE_PKT_INNER_TCP),
> +	ICE_PKT_PROFILE(udp_tun_tcp, ICE_PKT_TUN_UDP | ICE_PKT_INNER_TCP),
> +	ICE_PKT_PROFILE(udp_tun_ipv6_udp, ICE_PKT_TUN_UDP |
> +					  ICE_PKT_INNER_IPV6),
> +	ICE_PKT_PROFILE(udp_tun_udp, ICE_PKT_TUN_UDP),
> +	ICE_PKT_PROFILE(vlan_udp_ipv6, ICE_PKT_OUTER_IPV6 | ICE_PKT_INNER_UDP |
> +				       ICE_PKT_VLAN),
> +	ICE_PKT_PROFILE(udp_ipv6, ICE_PKT_OUTER_IPV6 | ICE_PKT_INNER_UDP),
> +	ICE_PKT_PROFILE(vlan_udp, ICE_PKT_INNER_UDP | ICE_PKT_VLAN),
> +	ICE_PKT_PROFILE(udp, ICE_PKT_INNER_UDP),
> +	ICE_PKT_PROFILE(vlan_tcp_ipv6, ICE_PKT_INNER_IPV6 | ICE_PKT_VLAN),
> +	ICE_PKT_PROFILE(tcp_ipv6, ICE_PKT_INNER_IPV6),

I think that in both "vlan_tcp_ipv6" and "tcp_ipv6" we should use ICE_PKT_O=
UTER_IPV6 instead
of ICE_PKT_INNER_IPV6. We are not dealing with tunnels in those cases so in=
ner addresses are=20
incorrect here.

Thanks,
Wojtek

> +	ICE_PKT_PROFILE(vlan_tcp, ICE_PKT_VLAN),
> +	ICE_PKT_PROFILE(tcp, 0),
> +};
> +
>  #define ICE_SW_RULE_RX_TX_ETH_HDR_SIZE \
>  	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lkup_tx_rx.hdr) + \
>  	 (DUMMY_ETH_HDR_LEN * \
> @@ -5509,124 +5571,63 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice=
_adv_lkup_elem *lkups,
>   *
>   * Returns the &ice_dummy_pkt_profile corresponding to these lookup para=
ms.
>   */
> -static struct ice_dummy_pkt_profile
> +static const struct ice_dummy_pkt_profile *
>  ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
>  		      enum ice_sw_tunnel_type tun_type)
>  {
> -	bool inner_tcp =3D false, inner_udp =3D false, outer_ipv6 =3D false;
> -	bool vlan =3D false, inner_ipv6 =3D false, gtp_no_pay =3D false;
> +	const struct ice_dummy_pkt_profile *ret =3D ice_dummy_pkt_profiles;
> +	u32 match =3D 0;
>  	u16 i;
>=20
> +	switch (tun_type) {
> +	case ICE_SW_TUN_GTPC:
> +		match |=3D ICE_PKT_TUN_GTPC;
> +		break;
> +	case ICE_SW_TUN_GTPU:
> +		match |=3D ICE_PKT_TUN_GTPU;
> +		break;
> +	case ICE_SW_TUN_NVGRE:
> +		match |=3D ICE_PKT_TUN_NVGRE;
> +		break;
> +	case ICE_SW_TUN_GENEVE:
> +	case ICE_SW_TUN_VXLAN:
> +		match |=3D ICE_PKT_TUN_UDP;
> +		break;
> +	default:
> +		break;
> +	}
> +
>  	for (i =3D 0; i < lkups_cnt; i++) {
>  		if (lkups[i].type =3D=3D ICE_UDP_ILOS)
> -			inner_udp =3D true;
> +			match |=3D ICE_PKT_INNER_UDP;
>  		else if (lkups[i].type =3D=3D ICE_TCP_IL)
> -			inner_tcp =3D true;
> +			match |=3D ICE_PKT_INNER_TCP;
>  		else if (lkups[i].type =3D=3D ICE_IPV6_OFOS)
> -			outer_ipv6 =3D true;
> +			match |=3D ICE_PKT_OUTER_IPV6;
>  		else if (lkups[i].type =3D=3D ICE_VLAN_OFOS)
> -			vlan =3D true;
> +			match |=3D ICE_PKT_VLAN;
>  		else if (lkups[i].type =3D=3D ICE_ETYPE_OL &&
>  			 lkups[i].h_u.ethertype.ethtype_id =3D=3D
>  				cpu_to_be16(ICE_IPV6_ETHER_ID) &&
>  			 lkups[i].m_u.ethertype.ethtype_id =3D=3D
>  				cpu_to_be16(0xFFFF))
> -			outer_ipv6 =3D true;
> +			match |=3D ICE_PKT_OUTER_IPV6;
>  		else if (lkups[i].type =3D=3D ICE_ETYPE_IL &&
>  			 lkups[i].h_u.ethertype.ethtype_id =3D=3D
>  				cpu_to_be16(ICE_IPV6_ETHER_ID) &&
>  			 lkups[i].m_u.ethertype.ethtype_id =3D=3D
>  				cpu_to_be16(0xFFFF))
> -			inner_ipv6 =3D true;
> +			match |=3D ICE_PKT_INNER_IPV6;
>  		else if (lkups[i].type =3D=3D ICE_IPV6_IL)
> -			inner_ipv6 =3D true;
> +			match |=3D ICE_PKT_INNER_IPV6;
>  		else if (lkups[i].type =3D=3D ICE_GTP_NO_PAY)
> -			gtp_no_pay =3D true;
> -	}
> -
> -	if (tun_type =3D=3D ICE_SW_TUN_GTPU) {
> -		if (outer_ipv6) {
> -			if (gtp_no_pay) {
> -				return ICE_PKT_PROFILE(ipv6_gtp);
> -			} else if (inner_ipv6) {
> -				if (inner_udp)
> -					return ICE_PKT_PROFILE(ipv6_gtpu_ipv6_udp);
> -				else
> -					return ICE_PKT_PROFILE(ipv6_gtpu_ipv6_tcp);
> -			} else {
> -				if (inner_udp)
> -					return ICE_PKT_PROFILE(ipv6_gtpu_ipv4_udp);
> -				else
> -					return ICE_PKT_PROFILE(ipv6_gtpu_ipv4_tcp);
> -			}
> -		} else {
> -			if (gtp_no_pay) {
> -				return ICE_PKT_PROFILE(ipv4_gtpu_ipv4);
> -			} else if (inner_ipv6) {
> -				if (inner_udp)
> -					return ICE_PKT_PROFILE(ipv4_gtpu_ipv6_udp);
> -				else
> -					return ICE_PKT_PROFILE(ipv4_gtpu_ipv6_tcp);
> -			} else {
> -				if (inner_udp)
> -					return ICE_PKT_PROFILE(ipv4_gtpu_ipv4_udp);
> -				else
> -					return ICE_PKT_PROFILE(ipv4_gtpu_ipv4_tcp);
> -			}
> -		}
> +			match |=3D ICE_PKT_GTP_NOPAY;
>  	}
>=20
> -	if (tun_type =3D=3D ICE_SW_TUN_GTPC) {
> -		if (outer_ipv6)
> -			return ICE_PKT_PROFILE(ipv6_gtp);
> -		else
> -			return ICE_PKT_PROFILE(ipv4_gtpu_ipv4);
> -	}
> -
> -	if (tun_type =3D=3D ICE_SW_TUN_NVGRE) {
> -		if (inner_tcp && inner_ipv6)
> -			return ICE_PKT_PROFILE(gre_ipv6_tcp);
> -		else if (inner_tcp)
> -			return ICE_PKT_PROFILE(gre_tcp);
> -		else if (inner_ipv6)
> -			return ICE_PKT_PROFILE(gre_ipv6_udp);
> -		else
> -			return ICE_PKT_PROFILE(gre_udp);
> -	}
> +	while (ret->match && (match & ret->match) !=3D ret->match)
> +		ret++;
>=20
> -	if (tun_type =3D=3D ICE_SW_TUN_VXLAN ||
> -	    tun_type =3D=3D ICE_SW_TUN_GENEVE) {
> -		if (inner_tcp && inner_ipv6)
> -			return ICE_PKT_PROFILE(udp_tun_ipv6_tcp);
> -		else if (inner_tcp)
> -			return ICE_PKT_PROFILE(udp_tun_tcp);
> -		else if (inner_ipv6)
> -			return ICE_PKT_PROFILE(udp_tun_ipv6_udp);
> -		else
> -			return ICE_PKT_PROFILE(udp_tun_udp);
> -	}
> -
> -	if (inner_udp && !outer_ipv6) {
> -		if (vlan)
> -			return ICE_PKT_PROFILE(vlan_udp);
> -		else
> -			return ICE_PKT_PROFILE(udp);
> -	} else if (inner_udp && outer_ipv6) {
> -		if (vlan)
> -			return ICE_PKT_PROFILE(vlan_udp_ipv6);
> -		else
> -			return ICE_PKT_PROFILE(udp_ipv6);
> -	} else if ((inner_tcp && outer_ipv6) || outer_ipv6) {
> -		if (vlan)
> -			return ICE_PKT_PROFILE(vlan_tcp_ipv6);
> -		else
> -			return ICE_PKT_PROFILE(tcp_ipv6);
> -	}
> -
> -	if (vlan)
> -		return ICE_PKT_PROFILE(vlan_tcp);
> -
> -	return ICE_PKT_PROFILE(tcp);
> +	return ret;
>  }
>=20
>  /**
> @@ -5963,8 +5964,8 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_=
lkup_elem *lkups,
>  {
>  	struct ice_adv_fltr_mgmt_list_entry *m_entry, *adv_fltr =3D NULL;
>  	struct ice_aqc_sw_rules_elem *s_rule =3D NULL;
> +	const struct ice_dummy_pkt_profile *profile;
>  	u16 rid =3D 0, i, rule_buf_sz, vsi_handle;
> -	struct ice_dummy_pkt_profile profile;
>  	struct list_head *rule_head;
>  	struct ice_switch_info *sw;
>  	u16 word_cnt;
> @@ -6036,7 +6037,7 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_=
lkup_elem *lkups,
>  		}
>  		return status;
>  	}
> -	rule_buf_sz =3D ICE_SW_RULE_RX_TX_NO_HDR_SIZE + profile.pkt_len;
> +	rule_buf_sz =3D ICE_SW_RULE_RX_TX_NO_HDR_SIZE + profile->pkt_len;
>  	s_rule =3D kzalloc(rule_buf_sz, GFP_KERNEL);
>  	if (!s_rule)
>  		return -ENOMEM;
> @@ -6096,7 +6097,7 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_=
lkup_elem *lkups,
>  	s_rule->pdata.lkup_tx_rx.recipe_id =3D cpu_to_le16(rid);
>  	s_rule->pdata.lkup_tx_rx.act =3D cpu_to_le32(act);
>=20
> -	status =3D ice_fill_adv_dummy_packet(lkups, lkups_cnt, s_rule, &profile=
);
> +	status =3D ice_fill_adv_dummy_packet(lkups, lkups_cnt, s_rule, profile)=
;
>  	if (status)
>  		goto err_ice_add_adv_rule;
>=20
> @@ -6104,7 +6105,7 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_=
lkup_elem *lkups,
>  	    rinfo->tun_type !=3D ICE_SW_TUN_AND_NON_TUN) {
>  		status =3D ice_fill_adv_packet_tun(hw, rinfo->tun_type,
>  						 s_rule->pdata.lkup_tx_rx.hdr,
> -						 profile.offsets);
> +						 profile->offsets);
>  		if (status)
>  			goto err_ice_add_adv_rule;
>  	}
> --
> 2.35.1

