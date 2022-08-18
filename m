Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26058598FC2
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 23:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241543AbiHRVth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 17:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiHRVtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 17:49:33 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABF8C6EAB;
        Thu, 18 Aug 2022 14:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660859371; x=1692395371;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tp7qh4ZQs4fx1JFigTDKLMk3Y0oR/plkAqThqI/GoCo=;
  b=Ofnn0S+qVzqdqZOfjk49SHRdJ/sZNPO6wjIpk1lnR6tctkTkMnc3f58X
   bHF//dNVEWWUs8HtyuVoJ5p9vjNaHy9oHW/0RSvSoR3Pn4eJ3ihzl5LId
   /riSf+/dEnoOyrlpTyqUcWlifjCv3KozfCaUC7jxEY/PJhJEltxmvQAnr
   RJoteuxcillFY++QHJUlrIct/nzy3fgbcphcan1oKJTEoUlv2HKl8BY81
   +8abUtsxuk4riv8xjRDM9GF2Fvmlq6i5QR0b8GCfpu9s9tuLSCF7wShys
   k8SGy5JDxUI95140Lc51sp7TZNbsy1uCKqhWr9p1XL0t7cSDG+313BgpT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="354616605"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="354616605"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 14:49:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="641024667"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 18 Aug 2022 14:49:26 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 14:49:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 14:49:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 18 Aug 2022 14:49:26 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 18 Aug 2022 14:49:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGqHuEIdyxnRo1wBdfwJYQb1zRpb7icowyXXpX4ooY0L/QTO11X3BnTah0C09/JHVb1eO4hYvpiFuu2OVfXOcmoiUWPmZnn7ouV4YkLspO4JI16FVpZ51UN4PydwMrO0qN+ihAljRM+MgxbZl4RUOs71Ov4KwO6KDYXP5p+ezlfy0od/qGJPa1zUCkaNE9MrOjS7+1tWL9Kq92zT35QlVaSU7I0L4lNYer+9y8lPPmR6bKxGu++Ml6K8omTTTwUCTJY/y0MWg6TvT/TA+3YCEZXI0FW1Pf1rXLdaROfPgVRHQVhwXH27ebGgXl5WintKH4E3A1PLH0XYObjhL+Qreg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iDC5aXBi0V43yAAhgRiScgbswEnzSC+HxD8Api/HnEw=;
 b=PdpVheEKx1Ai9OM5uX9xhsQMEWRrnkplgQtX2CiF+2Bz4i7wOlxaxu1tGhMLIlbu2IeoHbCMtmSEmCmn7hA7NcX90uX3P1nIIc48NxkL3KHoWk2rY2ZmWhufAQ+KSArgQu5Z59DzNQ8lYZrB0FwenA3Zq/jU4us1fiZUSzBXn22JdWq82Fcl3x34n+RIfxuzzu2b66KVzKgcPDsxyvl2BKaugRm+dHcl4+QmoT5efsZLkWk1iDfFTzfPtdz+k3j555Od5DCtZ3oWt92CE+EAJLU0i4byZ0id5jCP1iC+VzqPVC2rkzOFIvGnEMn4WmQ7K0JquRhW27J3wm9p6cZh9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN6PR11MB3518.namprd11.prod.outlook.com (2603:10b6:805:da::16)
 by BN6PR11MB0004.namprd11.prod.outlook.com (2603:10b6:405:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.19; Thu, 18 Aug
 2022 21:49:23 +0000
Received: from SN6PR11MB3518.namprd11.prod.outlook.com
 ([fe80::20e2:ae32:1f45:7e3a]) by SN6PR11MB3518.namprd11.prod.outlook.com
 ([fe80::20e2:ae32:1f45:7e3a%3]) with mapi id 15.20.5504.027; Thu, 18 Aug 2022
 21:49:23 +0000
From:   "Switzer, David" <david.switzer@intel.com>
To:     "Daly, Jeff" <jeffd@silicom-usa.com>,
        "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] ixgbe: Manual AN-37 for troublesome link partners for
 X550 SFI
Thread-Topic: [PATCH v3] ixgbe: Manual AN-37 for troublesome link partners for
 X550 SFI
Thread-Index: AQHYs0xhIC8jGX1fPUWGHZK9Mq9RXQ==
Date:   Thu, 18 Aug 2022 21:49:23 +0000
Message-ID: <SN6PR11MB35188E7EA01052437DFEDB50EB6D9@SN6PR11MB3518.namprd11.prod.outlook.com>
References: <20220721141104.4898-1-jeffd@silicom-usa.com>
In-Reply-To: <20220721141104.4898-1-jeffd@silicom-usa.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af9baabf-43f5-4d62-8b52-08da816383b3
x-ms-traffictypediagnostic: BN6PR11MB0004:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cE3GZT2LCLQTiqbk7aT0WC18Wdp7HQOsQnI7CWzLnpGXwUBGltiKu0mHBxdpoh/dJMt1bux3QhNk5ezpdJBpAIxiQ549xH17FUR2FEwNunqi8pAydkIdJdDBpRkN82EaS5lnMCOBaf52tgTnzbFGjPiBqfbw9NF2gMtn4dDvWTAbrmmVXEOx6QxEnSLtmGcNIYSBavnVfd+S+Cjv4jKhGholRRAg6FGKswhX39b70l7Xciy5Dv/HG31LB7upvCXhomCDhKDsivTZ9y9sngePsnQ6joxGjWObGzZlNJY1FDmbKXUpzvs7cdL7Xp5oJxqzuzuu3X3CXjV6RtfPBg0fzEepygXJJ+k1aqTlSq5wK6wrs4iMjIHNoXz/ovSBPSgK061+XE/4p2fSo8uJzDb94Bou/pGnwXg7oVhJAdwTu7eCj6Pp8LBhHPABDjzOxPkJLyATVerWLkBJUaJNxEo17HvKi/WnV3huUKdTT4JFrNNTb8kc2lrGq+6DorsloEZ0JoFwTDoejSLxYvHocTZchTOnKqpTC2SeafaBKD1MQJRSzlL5nIBHew+9CX5gs32p3Z0juSiMv3K07SYFslliuPMTjTLN3MlIIdH/gCj8XNiQgC8UhBUzV6GE4DYIfaYW1/Xx2ccaUHC++9iUQjALaxRtJtXd254UmswzjYwYrXAaimruffJjTlpQujqLADKSs4/Fgcf32O/Ew0yfb/oWuuqnc7vmM/dfPKOE4jqWMmp+CV50aliK0UZ0W33VpsaUrr3DfWXZoMuUkHX0qEyFLY9yPqdn3oCeR0+yB5bhVRYd7iE0fmcOXiaodRAiqUy4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3518.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(366004)(39860400002)(136003)(396003)(66446008)(66556008)(66476007)(66946007)(64756008)(76116006)(5660300002)(4326008)(122000001)(8676002)(9686003)(6506007)(7696005)(26005)(41300700001)(478600001)(71200400001)(83380400001)(110136005)(316002)(54906003)(186003)(2906002)(33656002)(82960400001)(86362001)(55016003)(38100700002)(52536014)(4744005)(8936002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fyzcl2R7qdheN64kWW1wtsPP7vywIeo+HHe++AV1VTVGijXQHwQQR9jsM70g?=
 =?us-ascii?Q?WwPwunN4gqj8jykF/O0Xjb25SSQ8j/iuM9KBigF+98RRFT1yhleEkgHQporP?=
 =?us-ascii?Q?YPbcTYUDxnsq2T4M3wv7qqUsvAaCAX0K8ON3ueCt+CDJlWl743E14tU6Hr1w?=
 =?us-ascii?Q?htMfTP/lMmgfvt2vFCWFqxOXpmMLsMpXgp0rwF6vO5kCHAs+slsRXazfr5T7?=
 =?us-ascii?Q?z7/ShmAJKK/Wo2EqnRrFj9ufMa4SIF03GLeHuu1lkVZWIPq0v/8s0TLaEwYs?=
 =?us-ascii?Q?kXToWBB9MvcmqMZF8Z8fIv9tJo2j559UE3RinjKDJ91odl7bw51Y2Dj+Jn/z?=
 =?us-ascii?Q?5ugzHlHsAejLBmuqY5RxDIbQ+OVGx27sUHF+a2Mye/sHubZuumlmv6zM4LxH?=
 =?us-ascii?Q?0T9gczx8Vpho8hQOhJSSVpXM0KEcxh6C2z1sdW2hj4gzNSto6KrbLjyOqBiD?=
 =?us-ascii?Q?wGIarFq6gNxScyMRE/HU+PdPz2ck/DzKOfIlnZ9nRplOVHohp27hEqAq+YbM?=
 =?us-ascii?Q?vJqnLNhQ6qGdQi1u9PlU41xM5vQV6Y15dGhtPNFn0i3yE6SkBETbFQ+dkuQd?=
 =?us-ascii?Q?0esjVGVirX+upDuS42X672WL7ds5NdOeD51rU3VuDTsVJOS4myAusAIuwya6?=
 =?us-ascii?Q?FLeNcpJLq+tPdr2gFW8NhWoI+8WC00xwzssXVl1aFqA8rP0HPAlidhY7pgMj?=
 =?us-ascii?Q?sHWnl+JKtsgygR9P8xDD+GqZ9hmQnJjZvD5p28n+RYYpxKe3AosxNbR2pbyX?=
 =?us-ascii?Q?N+cYC83v0wPZTqNKFUIJk7DYipafmNbu+l+HV41btbQlca++LYWpQEHPKHu6?=
 =?us-ascii?Q?Y9RfavS4tk2CSdH1B1PiCmh96qMBlNSt3WFXJt5LDCA1kD7SfwRQFlUpQ1iS?=
 =?us-ascii?Q?LQxf4kEm2dNtu+enXT9wO+Lbr6ZfhkbIYJ6spjchapdtMpO3IPLeKvZwcLXk?=
 =?us-ascii?Q?GZcdOz6TtJ2PUSQ8Up5+XwiZMXn9M31dchcfW9jdHnkaFrWTfKZUOgy1apKM?=
 =?us-ascii?Q?g+WjRDHZqspij/MU0TncZaVvBYRVAP5P/AUA/wlH9U61ASBQvw42W6nKMOIa?=
 =?us-ascii?Q?VJir/e0/I109wDosm7uZcpwAlSjBgIC6HmJN+Li5u0zgod5fesd2SMpGAe/U?=
 =?us-ascii?Q?I2rb7w2axfFFFJigRr+/eQpVMpHQXfQ30dyTAqcQXyZDEkxiRKRv9RJHWDE9?=
 =?us-ascii?Q?nV9JO78DKAPQ6O1wKjkn54mOcByH20eYSKshxt883d/SPwuw4DR4KvMDmTuM?=
 =?us-ascii?Q?1tcRPKECyfOFWaCC+Ou76y/Ejj1aYqvKaZmc/Ycnt5EHLvtl8juGNnPHWTCb?=
 =?us-ascii?Q?CUFGCHOp35mzaDOQ3e8mg/L/wDqq3FSvyjW+uLpErfiyI9NCGWu48N4eXBTg?=
 =?us-ascii?Q?5g7CLCExNHDj42TXtYOhLQnnLQu/vJuwnhRWvgguEp4Fbf4ZFfD03z6NT1+L?=
 =?us-ascii?Q?yldN4s0dLW5G1+Jauw3+wOrPAU4Jwoj4LBDVu5LzxNvXuR7tYXJxfJsTaP1k?=
 =?us-ascii?Q?MT9swPrjUElJ+lwpwt8QeTtt1nlSJ4HW79cab1J6zOYqd5nN5TkDhJgceNRR?=
 =?us-ascii?Q?zYkXzRnjUsvPfZlhDbRRYgGHWuHfuJS+ylkyjcvw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3518.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af9baabf-43f5-4d62-8b52-08da816383b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 21:49:23.7517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9iI6J635ygYj7Bm2p6SPzmyNappgZEH2jE9YyKVjS9NO1gdWQ8egCLuNd7FcjVaqpdIEwCPdczIlrnmQNWu+iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB0004
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Daly, Jeff <jeffd@silicom-usa.com>
>Sent: Thursday, July 21, 2022 7:11 AM
>To: intel-wired-lan@osuosl.org
>Cc: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
>Jakub Kicinski <kuba@kernel.org>; intel-wired-lan@lists.osuosl.org;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: [PATCH v3] ixgbe: Manual AN-37 for troublesome link partners for
>X550 SFI
>
>Some (Juniper MX5) SFP link partners exhibit a disinclination to autonegot=
iate
>with X550 configured in SFI mode.  This patch enables a manual AN-37 resta=
rt
>to work around the problem.
>
>Signed-off-by: Jeff Daly <jeffd@silicom-usa.com>
>---
> drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  3 +
>drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 56 ++++++++++++++++++-
> 2 files changed, 56 insertions(+), 3 deletions(-)

We don't have the specific link partner that this patch fixes, but we have =
verified that AN wasn't hindered or broken with the link partners that we h=
ave.

Tested-by: Dave Switzer <david.switzer@intel.com>


