Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF01E61968A
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 13:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiKDMuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 08:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiKDMuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 08:50:06 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C582F10052;
        Fri,  4 Nov 2022 05:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667566203; x=1699102203;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h8RSIx7mz3OKJ1Rtrr+Ut9XFIamZzkFO7bFYL31DIF4=;
  b=lnR1wPM2yiiDU+sSNnDKsIn7lMGCWjJV0qMspujMCbIaRoktXJHbe+8W
   DNocDT/0G7Icltjl/zvIdYlanNmqj7VUZ4UGyfc26Pc2t1TUQr5KKQB9C
   OW/Q45mcvcL0T5/Ruja1/K7DOH87i2U6BLj1MNBrKR/Nufw6mvO4JNq2Y
   SbpV2bW7p1WioBbdV2HtQxfv6Zs5lCnZn1QhHEKShM0KNoayJ2mWHK3x7
   VwikMk5s/HCkgmGtdRO4dUWWqUbxvRhV3cBUf//yd4BjdmYiHhV8dN53L
   R7anuCne+oA6ZDfwOcdXbWIEr1IvkLVZ9A2tyl2RBrj5vTg8VC4rHDE3F
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="311697955"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="311697955"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 05:50:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="964336023"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="964336023"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 04 Nov 2022 05:50:02 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 05:50:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 4 Nov 2022 05:50:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 4 Nov 2022 05:50:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUZLLEMjhmDG5DHBTXuhxoa1QAESr7qQxjmvrhsezQKJJgSK0NWrMdFYPnh99PyWz1f7h61ohP/phxzX4LKIwk1vyT57t2E+Rwk6EORhEefrsBaooL/pZBMfjcgrJG+TX1Fi2cgfgqHaIL2cFkx++OGPd5HKXEhrMCCgSy9ScRwWBOpKMKAHrDHbH/JDppLu8NqOj3lMjszQO5CZ6PaFkaSP0nO3rsYwv7NC00QnKye+35dOm6tlwOcL2HI37eFbjF6EBX3pwbTBcchGqDFsLVcztW9GYkRICqBBuAEKQYpzDHOSKchsAGhFOuKSeuretQZWD4rx/I2F8x5NqeFQhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mavVN+yaPg0ZKVgSPNXRCypMXetB0uoOndprcr13qMw=;
 b=f+Yv1xV7LS5ka3RZUMAaFyeldLqhfZ51W6RFcQgQuGAImzorIzOGjnuohnHltMXFgm44CwR3atld5uTPud+Zv6qTQOZ7+RbdfR2zjUgdycbq0sNJRTI2QhmKwV/XZFFnAbgNNdgZ3h46XdJnT2PIjhYMdWSQNx/i+XWEG4GUpFrb696yBjARMl1LjgExjezz3p7eClDuHNnwyZ2Lliewyo9QcVzNU36foCuHcPg0shCPRbdOKtGkZy2Y0KHzIQn6E1CsKPL5f9FB9SiFmh6QqZk5Z/EUH+m0S5XhZRpTZ1FdbINDCC5UsRqHK6oP1V4cZkdgXqM3XPDHKufNzAkXdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by DS7PR11MB6245.namprd11.prod.outlook.com (2603:10b6:8:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 4 Nov
 2022 12:50:00 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::cfab:5e4e:581:39cf]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::cfab:5e4e:581:39cf%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 12:50:00 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Louis Peens <louis.peens@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: RE: [PATCH net-next] net: flow_offload: add support for ARP frame
 matching
Thread-Topic: [PATCH net-next] net: flow_offload: add support for ARP frame
 matching
Thread-Index: AQHY8Emoobt5Jm60L0KRGicstU9Epa4uthqw
Date:   Fri, 4 Nov 2022 12:50:00 +0000
Message-ID: <MW4PR11MB577629A93F7EB795DF319412FD3B9@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20221104123314.1349814-1-steen.hegelund@microchip.com>
In-Reply-To: <20221104123314.1349814-1-steen.hegelund@microchip.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|DS7PR11MB6245:EE_
x-ms-office365-filtering-correlation-id: 379db1b1-a3f0-47a4-f2be-08dabe6315f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GWn8PfQN41UOLYkPblEW+0vROqwTnzV24Oz1SWiRWcI1BHxeLY97PGVl5yAurUKeZlOLioAghkqDN6gr1b4hhOxLfsC6h1v4ijg8cVmxg55qCWq7rxhSfexSrbh1qEMT8DFA0Lvl+TCTKK91td1gNu/0YncWEdxuZjSxmicw3ZO/83yGGoaEO9GN9VQ5IaVXIpI+NRbNKDBKG/X6zLyBq5MFZ1S/xHFf5DNuV770B0Eu90y9P+Un7mb+kiwOSEP9S5e9pd5Mc+MYl3XsJw8J8IEAOQ79B6GQGM00GEAlFBNryHhg8gzaSPiSy+rJPTOjl51zTDkUAwErAAB/2zX+EzABLbLF+9MqRKJOT73WAcnLS+rh8JUhYkxTbHuI6rnH/t+6bypopirAr/LkVUpulMns+ZB4Ou3nrgj39UUhPjxfoBiYSmC/p+e1CF4CldklKHrEpRp1rNgqMqngUX22KuQL1GlCMycNBQL0iodGE/e/aptxzXtliPcNKuGT2AR6EMkRVwEpm/LIhOEKqGKIaHHJ0jkTVB6nTjd3sGnqSO1G7ffky8nDDtV+THsZurYJYUB7V2Knp95upWAU0+oFi5l9L6ZFo6l8HIe0pxPZ+Nqu+n0TjV3RjhTmBP/3utZ3ShYkk/s7NZAoSmpLbZYMYzv39gTr1Wn3AC5A+APjii7JY0BzOMf7m0cduso6afXABbthVz0sFrftWfA6arxDZXnhSdXut2MS4up8E+g6RvSkepAupSt51jSh7HzvnxwPLXZH82FnHhjBvcmqLryuoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(136003)(376002)(39860400002)(451199015)(66556008)(6506007)(5660300002)(54906003)(26005)(316002)(55016003)(110136005)(38100700002)(4326008)(8936002)(186003)(41300700001)(2906002)(66446008)(86362001)(76116006)(7696005)(66946007)(83380400001)(52536014)(9686003)(33656002)(8676002)(7416002)(64756008)(53546011)(38070700005)(71200400001)(478600001)(66476007)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?Bss8l5wnL/RRu4sYgLQUBcm2L4IruCyVT9iiR+MBrmJXt7NFFJC5vYZ3Ey?=
 =?iso-8859-2?Q?HOHBTuLcmNywNnf6lLUuKkxIj46X2Ndhap5wKAtjnrjnOYPj5gOpN8FIS5?=
 =?iso-8859-2?Q?Cn6+lnOnb1XC00qw+ACgROhBdYC3/m58fnJT8GQdKIV+M8FezfmcJSekR0?=
 =?iso-8859-2?Q?+Ccv+x5XnHifympN9qcdLO5/2SP8NDA1pzt2NAEUdFQXdUFqacVRs1EnEp?=
 =?iso-8859-2?Q?Ev7ARgc4f65JcDjGNyNGnHJJukW+xRGRd536dmiI7Vx2V29G9P2tEc+RG8?=
 =?iso-8859-2?Q?GdURkSJNMzf7S0+MGU9lUo7G9zkGhKnEminbecN/gkUD6R2Ok0FdTtTPSN?=
 =?iso-8859-2?Q?Te3Si87RL68dKA4oIq002mi+0EEEvLO3mxIObvdZrTi+CTdUUKkyeftaIR?=
 =?iso-8859-2?Q?nIRMGmLR500CnDbXbhjbGyPYykSmIsnMwEzVO/PR8tHBBab0L791Q8WvfY?=
 =?iso-8859-2?Q?vQ0suF58AFRsER9q97HtZGw0MYG57sqGQyryQio9TbMzNYpGYu4DFM6lVm?=
 =?iso-8859-2?Q?Z+b1Pmgf6iXRjkximxuzZOHYFa+mtdfa1ZYUjy75dILQCm9prPvnUhjsGU?=
 =?iso-8859-2?Q?Tut0jZcIUCfFvvfJZorrWWEYUVIDt2Hh5MS7eOxivmtPcMwWV+o6cNf3Ss?=
 =?iso-8859-2?Q?m/mwJXnDByOUEkhiEobrtVmRcYq7ZkWck0ZeOy4aOd9GiL/XW/p6zVGaEp?=
 =?iso-8859-2?Q?S9ZooxyrWGCxbha7Zl+bV7B/cwVudAcJ45itrc9GTQ4O+saXq8h4Oj7mVL?=
 =?iso-8859-2?Q?DnxluKEAaeT0FFeFR6dEb46b3atcDCjPyil9s8Q0CGWY864NT/Dy8RyQz8?=
 =?iso-8859-2?Q?aK0CEeNRzAJE7gDYIVud96JPJg4fMgKtBgn+PSbttOnO4o5gY16L7znM0E?=
 =?iso-8859-2?Q?eS3hO2ASUXFQFzNgOGSTRzRDdRPVkujzgD86XloKBX0fStvdsnlQFcdTaW?=
 =?iso-8859-2?Q?YwZ7Q1aVExSOEsemq9CWNJGB+09yeekPhmA3w+rEDUH36lLgoWERTBT4ke?=
 =?iso-8859-2?Q?gXaR9VmvHFrmdBGG72qpt+DeVBe4ceVmzO1D6v5ybWm9+ONf+CpmQzVyLf?=
 =?iso-8859-2?Q?XjPQT+QkawpNf2O/o+j9ZpinweicC3i2u8Z1v0S8Ksra1yXkE/yRLGD4kM?=
 =?iso-8859-2?Q?oIDGcrhLIG/tleDP7piARFlwARxqU2PGWPFPXkUX3HvoNBRx27rCDgOa3N?=
 =?iso-8859-2?Q?ds8eZGspkQbJmIKqGkIMXDHbHSiglotQn7oIi9Eso55mtkueaXWNEdR3hf?=
 =?iso-8859-2?Q?AqlB76w6hKkgtW0gksMJ9dRwGMebe2Dv2xK3htgnBVSyKCM+NQlJmBAwDd?=
 =?iso-8859-2?Q?AGsAHNsqxY/tYbHjutQKx/HV85e+6hN+PBcX7hJG5uh8+1IX/7QxOJ8r4+?=
 =?iso-8859-2?Q?tZmHSLfgacTd9e1Yloy8HsgUxj/vmiBfUGCxMq+Ikb6JbJIwC8nXyBTe2/?=
 =?iso-8859-2?Q?gFiZUhiOoezzAv0efg8MMkuWl08ppY9dA+SPEI/sBa7WrtEGLj+L7scfUE?=
 =?iso-8859-2?Q?jEklLpM0uQisbof2/9mpgOLmkcZwGj0lGGKHiXhnE8seetgnwWa3ZyZOnf?=
 =?iso-8859-2?Q?Zg5iEs8UXGQkoqWm9LnY483I8kLZfK0AMFz5Rx0nAIhkLzg6bfoGS6KfUR?=
 =?iso-8859-2?Q?Arad0kHr78fTfL1uljQbzASaBIPHVLuuaZ?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 379db1b1-a3f0-47a4-f2be-08dabe6315f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 12:50:00.5317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nBzkHDKoNpMtPAtZwHM0KGmU2QieuAL2pa2sSrbRPV4nlMm5ZVxR+K4hPmHOgsD9xN6G58NbYQZA4akGy9d6YC8pq2mMlKZUfsKCUEUZlhg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6245
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Steen Hegelund <steen.hegelund@microchip.com>
> Sent: pi=B1tek, 4 listopada 2022 13:33
> To: David S . Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google=
.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
> Abeni <pabeni@redhat.com>
> Cc: Steen Hegelund <steen.hegelund@microchip.com>; Louis Peens <louis.pee=
ns@corigine.com>; Baowen Zheng
> <baowen.zheng@corigine.com>; Simon Horman <simon.horman@corigine.com>; Ng=
uyen, Anthony L
> <anthony.l.nguyen@intel.com>; Drewek, Wojciech <wojciech.drewek@intel.com=
>; Maksym Glubokiy
> <maksym.glubokiy@plvision.eu>; Pablo Neira Ayuso <pablo@netfilter.org>; n=
etdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> UNGLinuxDriver@microchip.com; Horatiu Vultur <horatiu.vultur@microchip.co=
m>
> Subject: [PATCH net-next] net: flow_offload: add support for ARP frame ma=
tching
>=20
> This adds a new flow_rule_match_arp function that allows drivers
> to be able to dissect APR frames.

ARP* frames
Other than that looks ok.
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>

>=20
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> ---
>  include/net/flow_offload.h | 6 ++++++
>  net/core/flow_offload.c    | 7 +++++++
>  2 files changed, 13 insertions(+)
>=20
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 7a60bc6d72c9..0400a0ac8a29 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -32,6 +32,10 @@ struct flow_match_vlan {
>  	struct flow_dissector_key_vlan *key, *mask;
>  };
>=20
> +struct flow_match_arp {
> +	struct flow_dissector_key_arp *key, *mask;
> +};
> +
>  struct flow_match_ipv4_addrs {
>  	struct flow_dissector_key_ipv4_addrs *key, *mask;
>  };
> @@ -98,6 +102,8 @@ void flow_rule_match_vlan(const struct flow_rule *rule=
,
>  			  struct flow_match_vlan *out);
>  void flow_rule_match_cvlan(const struct flow_rule *rule,
>  			   struct flow_match_vlan *out);
> +void flow_rule_match_arp(const struct flow_rule *rule,
> +			 struct flow_match_arp *out);
>  void flow_rule_match_ipv4_addrs(const struct flow_rule *rule,
>  				struct flow_match_ipv4_addrs *out);
>  void flow_rule_match_ipv6_addrs(const struct flow_rule *rule,
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index abe423fd5736..acfc1f88ea79 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -97,6 +97,13 @@ void flow_rule_match_cvlan(const struct flow_rule *rul=
e,
>  }
>  EXPORT_SYMBOL(flow_rule_match_cvlan);
>=20
> +void flow_rule_match_arp(const struct flow_rule *rule,
> +			 struct flow_match_arp *out)
> +{
> +	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ARP, out);
> +}
> +EXPORT_SYMBOL(flow_rule_match_arp);
> +
>  void flow_rule_match_ipv4_addrs(const struct flow_rule *rule,
>  				struct flow_match_ipv4_addrs *out)
>  {
> --
> 2.38.1

