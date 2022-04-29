Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BDC51591A
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 01:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239907AbiD2Xqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 19:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239891AbiD2Xqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 19:46:34 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A32CDAFDF
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 16:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651275794; x=1682811794;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DuqWnl8w/mXrCco6WRhdmMdBJYi6nmVQnOqwux5aNWM=;
  b=cK3r0hLZ/gTFSW8HvBUjershD+lnSzqDLoaocODl7zx6vQI2dd2t+bKK
   4fRTjcaD9ve8+K9HArFhqoJm9zy+15xxtnTd+wR1WQwjSoXCtsG2p+SNG
   pWgMLFa8dwO1yGbFioDMPkhtRM2ZCz9mRZhy6R4nfR12TyuyoPffbmn2S
   +hSswWel+etCOui+KFJKQw0OWyX8T+L+5YXwSYnmKGWW6bo4iDNGA8v4v
   iZLHwlAPo7+Rlq8nf2OP7Iz5gwb8zSuIHpah60+XMvXi9O7licGsDQ+/i
   xP6cdJdMMUis0kF3enVZMsl2pCRjXBzfYy7ao/vUxRvk8bqdHJdsjKEMp
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="291975031"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="291975031"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 16:43:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="651971784"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Apr 2022 16:43:14 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 29 Apr 2022 16:43:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 29 Apr 2022 16:43:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 29 Apr 2022 16:43:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lR+Vk11OwKnQFt0JECerHpyXOaIcSU6kjxTTqE6Cxwnz5esd3OmW+aM4fQiOlhJySpq1ogRGrp/e2sOsrtIiIsQpLXwnLT/YKxkKM3n2EkS7YQdg2K9ZhoW6/KMaaI5GsbY/6Q/AiRa0qrEAl64dLAkqoDWTupvEXwuLy+YpQ8RToybs8VEmicB3FzAaoAdoMvQucPbWB8AQByEOx04PDXF8M6udn9g4HLSGE+kICJIqIRjjhd5qlvk5MR1fmV8kMgxlZO9wvH0G8JoRjXq9JIYDhcJNEyAomp8h8Mw8/pEQFUFqoB46JoXTZN+Vr/U5EYZgW6u8X4rBEaWnkbdP0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xD5ZSi7KEFajTw43eiBC4tFX9Kjxg19Wdr7Np8+IZzU=;
 b=oebbBkI+sZI13eSI+3Oip9I6xtUhUIqJdHOqiNzKCj4WXCeenyrPXm+aEJGHLKDYrQZC6tntMCho4gJ6RvBSKB6A4ekD1EmNhyFWiK0ZsHPv8fl6fOzihchf/IQ7VB5BKS8RbGmPl3l0F4/GJXEFJX9JC3gcsbiqtE59Bk+W9zmgwB2AlVCSrhKve4aaQ1zi0SbY9JJl/852sSkCDChQfDC4XLzUZEMMfVnwDrIbSU3aXapJQj0XrSSDmhIWcmApztJkEkLgWBNSD4pzK0tHCylNxw5ok+0EbzWjI4ZY2UmKknsKc+GosGGAj8FMm/VEOfIBUemKOarrCBNsMn1W/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by SJ0PR11MB5005.namprd11.prod.outlook.com (2603:10b6:a03:2d3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 23:43:07 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::5839:bffa:4db3:cc6b]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::5839:bffa:4db3:cc6b%11]) with mapi id 15.20.5186.023; Fri, 29 Apr
 2022 23:43:06 +0000
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Sreenivas, Bharathi" <bharathi.sreenivas@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: RE: [PATCH net-next 01/11] ice: Add support for classid based queue
 selection
Thread-Topic: [PATCH net-next 01/11] ice: Add support for classid based queue
 selection
Thread-Index: AQHYWyU+3sAH6JN4DkyuLtGetMwV2a0F8kQAgAGT6HA=
Date:   Fri, 29 Apr 2022 23:43:06 +0000
Message-ID: <MWHPR11MB1293C17C30E689270E0C39AAF1FC9@MWHPR11MB1293.namprd11.prod.outlook.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
        <20220428172430.1004528-2-anthony.l.nguyen@intel.com>
 <20220428160414.28990a0c@kernel.org>
In-Reply-To: <20220428160414.28990a0c@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0403c426-f54d-4d50-b5e1-08da2a3a02c2
x-ms-traffictypediagnostic: SJ0PR11MB5005:EE_
x-microsoft-antispam-prvs: <SJ0PR11MB500553993E65C76F09A7A781F1FC9@SJ0PR11MB5005.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TUWm22EORVjs1jFwex9dq9i0C5iBkGkdWuw4IAdojOK7KqAYVTwY4VOjFrVfnuXauLIP0OhvSy7ec97aXbR3gDybIPsi6QAQlyiEnSPiQF/qlWnsv7zvGcL1/HtuqnnCUlSnbtk4jTNC2rdhknNGD9VthHhhYf/xJEKE+ktAqaehuPYn1yKoxkjbTPdZoo1CPliygKeGmgcCsQm6ev4Wly5QB9sCj3wLS/TQudJa0bnSxcDL3Dlz5Ck8XCxKiHXuaYk8YzB64zPmYBGAxV20ta1jVDShvCS2cQxBcxpbN9Sv/fevxfSjrDby7AYYuPMR2CW7KUDAbfsim3EVKTbWWsRsVSaSdZdRbVPVZNj3+Hb4bBGTf35nPSQJm5qJwcVpjtkASYmiuV6VqxmObnY10rlDeO90ftt0bf40LXQd+om5lCm9Pov86YlbUntLO5PwP2RLKKftyltV7VYlKgVSeY19dQ5Ds4oyniPK4pZ8UQCERdsO92SSj9MryXfTwBGuqdIllOiGVVkh3yCVul5XxSph14ABhph70w5MJlYeZ9HuMoAGu1aWmP6JKROqNO7YheSiPjZOMv4wqlpvBmAW69b2oWciuM3wNK6SGO/L5gMaPVY5q8d1e+k+cFg8ybdNZChav3IU65F6IlufiMBHsQNXsrl3Pxe7zC3jgJKlzuq5pEE+VEj9icSltW+NYw7cYKHKdlI6SMqZLPZacCbIfRB00rRFvQT5jeTAh/eI7VsnvbqNbF5ErAwmBMX/tthpZ5MdGyIZXev/LODMKDezlV3o2l7wmUmcgmg8XLTjTt8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(86362001)(66446008)(4326008)(71200400001)(38070700005)(66556008)(9686003)(26005)(6506007)(7696005)(2906002)(966005)(122000001)(83380400001)(52536014)(64756008)(66946007)(5660300002)(8676002)(33656002)(55016003)(508600001)(8936002)(82960400001)(316002)(186003)(54906003)(76116006)(6636002)(110136005)(53546011)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?C9UDhpPcpZKz68pJ9hIjUCMVx4JDbIQp1ruFrPtcFezIAzlw+KXjW5p7lv0T?=
 =?us-ascii?Q?YTlYUQ8pu4tGMP/vnKfTUgpBR+hxhncsGfG2jB6IrPjlRu955dNXsiFpwfrf?=
 =?us-ascii?Q?FFvwC68wrbVurQYb6y1PlH1o7sueI8UN8nTucH9RHp9qwa4jhYiBNt0CMPen?=
 =?us-ascii?Q?Y5LacOulFdQGxQ/CnZUU5UOq6RMbT3y4AiDBHuZ18HVlOh/8HIElMr+YQdMq?=
 =?us-ascii?Q?O8Ai5+D89wWuh5H/4bBClA93SsG0dZFI1QiGbR2l7wYCrrDMyt54zOdEa1lr?=
 =?us-ascii?Q?MuciDjRHP0wSw0jOkDUzrSAK9kHuRdw2LrWeTZgWHEYU+fpsTU+fNI8Mu2Uj?=
 =?us-ascii?Q?hFEQ7B4nI/0GvrVhBGChQZMPKespliDWpQbC5JBSmdLmJXg3UWulkli03olR?=
 =?us-ascii?Q?PiYrhWp+TTKcw2j42zWQByUsM990JFHUt/i49YBR0ObqNI2ghbFwr0jV4mmU?=
 =?us-ascii?Q?4cfO7QaCR9PmDbW6b3VuovyaFfepKwWpiI+5zMvbdxq2Lyws2zMeMjHaH61y?=
 =?us-ascii?Q?SP6Iv8f7D/RJL2bmLgbVMczVm8q+1oJ1ZJW2yHUVVQ4oDyKp1YQ8Dkb4XMuN?=
 =?us-ascii?Q?Xr2Ai5Xaqnhbd60ZzCncN/n089Y6zlbpcvi6ntlUykVaRQl/5CD8d79N0b37?=
 =?us-ascii?Q?R4HCM1QMO+MQTv6YgXNSC705udxX4RN6HJ+8DYb4ad/HGaMpJS96211EADsQ?=
 =?us-ascii?Q?12PrDcFjdbOvLlIBHgfO0KFBbDgfLoGPG3tHRor6mUneXnmmepJssvNAd/g1?=
 =?us-ascii?Q?jDgy6Z/juHZoahJLDudRuq78kY1wZTn30XYabKUG/nLUxRS5d4mmP7+GrRCZ?=
 =?us-ascii?Q?Iem/I/eqPzzdCJ/lXJY9qBplLp3WOdGUd3EUcL/5YrSrzDTs33UKYHs9v+Bs?=
 =?us-ascii?Q?CK8GXpIbk4d95hJWJ1YbZLIk/ssDrnyN3sKdJzayZERVPsOhDPDZqJNYU5I+?=
 =?us-ascii?Q?27NmRqYjfPmiaUGmn5scVXaicTTv1/U9K2+hV0aqhOryXO6zqIZTajBMcqds?=
 =?us-ascii?Q?DSSCGSu66T8uAASdjaXumK7rq7qabT42O4VdadSPZngyEG5DmhGS9+/4h5qO?=
 =?us-ascii?Q?XvMVuvgD5C6Ga8a9RtdW5d3v5Jb/9lWeFkY0shMSiQ8rtvSQl6ul5vMwiu0Y?=
 =?us-ascii?Q?X4AbeG055bEjUNbPeI9xlOwHkYMXMcG6G9At9TTRfili4rcS5xbxb2ZqF494?=
 =?us-ascii?Q?V8BtKh5H0LBU5iOBfTlZcW0568OMox/n1dGDoQXBlfQXaTo1eUFMvkursQMv?=
 =?us-ascii?Q?vpgwOfM9yz6BMZBNq7SQD2M+i2HdnG9rOX+d2NNFAq8sS5qKiwumP9oDMmuY?=
 =?us-ascii?Q?vLigq88KuXfL3ha6GSt5K1VdjU9PqM9CgvhTnSF2BIFbGT8OIqtfB4swTBYD?=
 =?us-ascii?Q?GqhhvBbUQvON+vX7LivyQt3J1Mgj6OaCPaQQGY3lSpaEXFoh2aOiSquZ2FzJ?=
 =?us-ascii?Q?CpRz69nm7ir49Yeb4lT15eLkDAOG0JvJapyfPMCk1Efvrnq0IW6Q7UxU13v2?=
 =?us-ascii?Q?/jnVv+uCInzbGwfw3uLEusxrALC7bfbUSl2lTTAQXnM70o8i5feKEP1dXXh2?=
 =?us-ascii?Q?JpwgDQvswPYyvOh0rLhCg1Wt6U8xyG/tSJsQ6AZ30BnlvlfuKIO/8coqVouE?=
 =?us-ascii?Q?ZMrKGj8poocvfLbzYU0J0UqYdZ7VfQfc7jnPkL+DFsCyHrlt45/AEroGYDvm?=
 =?us-ascii?Q?5q2549NP1cpMhjgxjyqDu/UMCzluM5JivPCtHywqF20qMc852uytsjVx6kaz?=
 =?us-ascii?Q?fO3+XFQG3A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0403c426-f54d-4d50-b5e1-08da2a3a02c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 23:43:06.8975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BEbVmP080Nilszke59XSg8XLpIyM2HOT1rPseSLSD3LJyfYLjbrnLqZrsUT1gK6VsGB4vPjL+mDjuyyx1xideBmCizRURHs903dApuasWKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5005
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URI_NO_WWW_INFO_CGI autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, April 28, 2022 4:04 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; pabeni@redhat.com; edumazet@google.com;
> Nambiar, Amritha <amritha.nambiar@intel.com>; netdev@vger.kernel.org;
> Mogilappagari, Sudheer <sudheer.mogilappagari@intel.com>; Samudrala,
> Sridhar <sridhar.samudrala@intel.com>; Sreenivas, Bharathi
> <bharathi.sreenivas@intel.com>
> Subject: Re: [PATCH net-next 01/11] ice: Add support for classid based qu=
eue
> selection
>=20
> On Thu, 28 Apr 2022 10:24:20 -0700 Tony Nguyen wrote:
> > This patch uses TC flower filter's classid feature to support
> > forwarding packets to a device queue. Such filters with action
> > forward to queue will be the highest priority switch filter in
>=20
> You say "forward" here..
>=20
> > HW.
> > Example:
> > $ tc filter add dev ens4f0 protocol ip ingress flower\
> >   dst_ip 192.168.1.12 ip_proto tcp dst_port 5001\
> >   skip_sw classid ffff:0x5
> >
> > The above command adds an ingress filter, the accepted packets
> > will be directed to queue 4. The major number represents the ingress
>=20
> ..and "directed" here. TC is used for so many different things you
> really need to explain what your use case is.
>=20

Sorry about using the terms "forward" and "direct" interchangeably in this
context. I should have been more consistent with the terminology.=20

The use case is to accept incoming packets into a queue via TC ingress filt=
er.
TC filters are offloaded to a hardware table called the "switch" table. Thi=
s
table supports two types of actions in hardware termed as "forward to queue=
" and=20
"forward to a VSI aka queue-group". Accepting packets into a queue using
ethtool filter is also supported, but this type of filter is added into a=20
different hardware table called the "flow director" table. The flow directo=
r
table has certain restrictions that it can only have filters with the same =
packet
type. The switch table does not have this restriction.

> > qdisc. The general rule is "classID's minor number - 1" upto max
> > queues supported. The queue number is in hex format.
>=20
> The "general rule" you speak of is a rule you'd like to establish,
> or an existing rule?

This is an existing rule already being used in the TX qdiscs. We are using
this in the ingress qdisc and offloading RX filters following the explanati=
on
from Netdev 0x13 session presented by Jamal. Section 4.1 from
https://legacy.netdevconf.info/0x13/session.html?talk-tc-u-classifier
"There is one interesting tidbit on the above rule exposed
via the "classid 1:1" construct: the accepted packets will be
queued to DMA ring 0. If classid 1:2 was used then they
would be queued to DMA ring 1 etc. The general rule is the
"classid's minor number - 1" upto a max of DMA queues
supported by the NIC (64 in the case of the ixgbe). By definition, this is
how tc classids are intended to be used i.e they select queues (in this
case hardware ingress queues)."

