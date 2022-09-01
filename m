Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480D65A93B6
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbiIAJ46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiIAJ4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:56:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A301135D3A;
        Thu,  1 Sep 2022 02:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662026213; x=1693562213;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XtU3m3IJSt+naltWxPPMwX1WjN5dYYA9EOvoiHs3m70=;
  b=EDVK/PiTRO3nZMXBxNsy9N7A8bnH1nxHAdKchqEXq+osRYfQCbYH+yZF
   D9y8EkT0eKiFYRCPqeIE3qYw8GeyZkzW83PDZ2XAOXAq8ul55wznXOq8W
   l+Umc7ZP5C8CSdbw79SXbG2j73lYC0J9jSti77tRhk7Goj2ejKj8PvZu4
   qASH/kESQ7QP2pD5Rn9zbzgD10JQb+GMlPEoDamFGTjuhkOcnO7lyF5Xw
   0X8x3LUXqyRfOX03W1ll1o58prb2xePI7kyIORpOj9DUk0BBsaethwp4N
   z8kgqpVJGOPmAvaLB+xv9jCFnQ+n3V8cvnZzt+Iz/EZIDg74x0vf4tGTp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="275420538"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="275420538"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 02:56:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="788180545"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 01 Sep 2022 02:56:52 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 02:56:52 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 02:56:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 02:56:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 02:56:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cAlEjgUywZ71ql0t2wkdiygNOwEKig/YPsBIDdT3xH+ID4hxPxf+J8dOWxFIU5VaIHW//xtGP8bAnDJQx8YErAdwApg8YXkJsjsxeENZxYnzgwvf8XXF+hc9X+H3JMGfb5npx75SrYIvy2j4MxrlRErw26EsY7EZywp/AQwIRsI1VL13Zu5wPDK1OT3cAkDpTLpohcZL28z/qHe2A5k9maY7czVmgqmZ/+UOoF/b/m/gKWwSyXJZn37TRY/7hLtFzrZmurYLz4GUAJrZ/CHcw4xSpPlylFcjA0PJVaJR0MQd2fLEUScXrRARIF2/1sLiasaPwz8PM80PyYrc+hRgjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iPBjR46RmSohfmn3XPyRc2buztJF+7POjQVH7QkmbhM=;
 b=lHIH4oqXCs4vWXR2fHS/7moESz7gApBFytJoBAZ6fQobnP2M3ypVOeGXN8tAOlSzpR/qGfYGC8oLleM+uQjEkgFV14xQuLK7bMlZAbMj9guFI5zfRCoAP28TvbxkQ03N/Aahga5eKiobJfvKvv22ENntaI+AHi0FYHJSEw72yhPbsIwoHs/4g0He9z5Ug8qJvEEmGBJ40RMo1A7MUeqbS5diySAXeU68XVXK6cwgl0Ime5uWyU+z4C52xSRx1+xIvT5CPDh7LjaIezACyyFubgBDCBMbADD7gzJUqzWIqlMAlRTh80oBb62Fnr09FmC3vJHbG5aPlnuwkagdivsLbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB2983.namprd11.prod.outlook.com (2603:10b6:a03:88::22)
 by DM6PR11MB3577.namprd11.prod.outlook.com (2603:10b6:5:137::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 1 Sep
 2022 09:56:49 +0000
Received: from BYAPR11MB2983.namprd11.prod.outlook.com
 ([fe80::e8f8:5cab:24b3:1c8]) by BYAPR11MB2983.namprd11.prod.outlook.com
 ([fe80::e8f8:5cab:24b3:1c8%4]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 09:56:49 +0000
From:   "Dubel, Helena Anna" <helena.anna.dubel@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Piotrowski, Patryk" <patryk.piotrowski@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Williams, Mitch A" <mitch.a.williams@intel.com>,
        "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] i40e: Fix kernel crash during module removal
Thread-Topic: [PATCH net] i40e: Fix kernel crash during module removal
Thread-Index: AQHYsYx+3xIczkZuwU6Gew5dabQ5p63KbuBg
Date:   Thu, 1 Sep 2022 09:56:49 +0000
Message-ID: <BYAPR11MB298374F50259D6FF3C815B16BE7B9@BYAPR11MB2983.namprd11.prod.outlook.com>
References: <20220816162230.3486915-1-ivecera@redhat.com>
In-Reply-To: <20220816162230.3486915-1-ivecera@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aaa0d7ea-3015-44e8-d6c4-08da8c0049c2
x-ms-traffictypediagnostic: DM6PR11MB3577:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 76qi9tGAyogZmpedhla0ZvzbCa9dwmo30FJp1xsRMcusp0mY5JgqSWrG5VRwc/Iz7kwQQ1+ArmUdHOb/4jd63jjrPs3ShR0PRBiJf0KD2NnImgXphi81Dz8xfhGnGFdua3hgaUBOb4sKDtqSdzJ1BL2dhkHR9yiV9GIeZX1x4/uJ5R9WKcOKYfQR1FCsxzu0Juzp3RfB4jcnjV4BXbuGcBvU5++MklZdZepUA296G/b4gx8R/h2PpYmf4nUR6tiaXU87kHRBlc7/zH5ci9sYAL7nf4/qMVrAJzM1MRK/4BUNwq8a615L8YPfgq/BBEItcUgJqRK/QKPTQlhiPBobepUzRE023QdLEzXGnXMvgXQD8g89psow/ges542igpEVRcaYktiqLsE0/LSv9eOVNzqbdEuWCzp6Mc7wQDtu+LPdrwWhU8cnrrWTEPfjCEsDJGf5UYhkRJfekcnluj7vQGGsBXLSypQGFSRLDpUhq5dJhL50FfuPn2JpHGpABYErAG3ng9XilXqrmFPKc+RQ0xNNSZTCMlk3OxCaKP4iQeV7VdR8rEu9gDgE6jqynNJ+fr9dxudCPom/W85Gsxw3FkAzQMpxQBkfF++rn94hAJ0CPmoj2VZ/onzZeL9crCtcnDvvgqPnJ57pHOlCbo8ksRhkkQgaNv94qGH5uS7ohorhkkL79XwUKKUYD2v1VTkZeIQvSSEshjHd+KzD+wB1bltkUjGXjLjCqVNlcnRQdyItIUgYgsAy9KeeB1N5zVkHvYkzH7a7wmV2997TEKN1hA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(346002)(396003)(366004)(136003)(316002)(66446008)(64756008)(7696005)(76116006)(4326008)(478600001)(83380400001)(66946007)(186003)(26005)(86362001)(9686003)(8676002)(71200400001)(53546011)(66556008)(41300700001)(110136005)(54906003)(82960400001)(66476007)(38070700005)(122000001)(2906002)(6506007)(33656002)(5660300002)(8936002)(52536014)(55016003)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YYjCJiesmcyQndhAyK5pH0fuKn+Xmy6npx/pt1kYy6vZSfEV1T41e9i25R1O?=
 =?us-ascii?Q?WXyCBnFxVgi+Gkcduor6MdcmMavuehilpv7Q1iymigytcNYkztTjSs5uEQ+K?=
 =?us-ascii?Q?JRNVxI6ic6d0ea1j+75msfplrNL3/C/bZCjpvaxEs/MAhY+UyymMGWlLcF//?=
 =?us-ascii?Q?NSJ9RNWsbJe2mJVoOGI6Dsu4qhC64db96nx/C4YN57JCI+BMneDU3KHH9vCa?=
 =?us-ascii?Q?xuGM1T4TARH2bw6eiioPK64KVjkRChLk+u6fLVI87W6tLdGE9rEeL3BLcDqA?=
 =?us-ascii?Q?mMPYReYgTFLHN/xb0LY8Vs9Lm1131SsPf+aHNeWTR4vvbrnmuHKr3XgBWIrZ?=
 =?us-ascii?Q?95DsD8jNJK0N61h6z9BB2AS247L4eoeCP7hr3sFgidpJT08FvR6+i7aPyYuK?=
 =?us-ascii?Q?wUp53tvvLdl9IXNNIAZ6Uj2ZASGuWd++7f2AdZdWHnMGSVsBcAGVRFjx8P1F?=
 =?us-ascii?Q?1BICMomf6ggl2ADFUCD8junKj1EVA72xLXLFPfbuFjGYTJObEHONJcEAFx0R?=
 =?us-ascii?Q?ztfTgL6rL+VIpEplfBWI/Hf9QhjEph08vXVnJK1hNBnpfzM24Nl4/ubQk+Il?=
 =?us-ascii?Q?qWO3kNv8uVapscTgu7zlwmk1t/Dn5UgQ/3353H58ltib8B68m+6aWAqR6UpH?=
 =?us-ascii?Q?O0X3peew7/5K954WU3Rtaq3E9gguSTyE5dlHse4EYvR63hOFjpBSRYRhtMBe?=
 =?us-ascii?Q?/yj2cPC74LlCjrtze1Nzu0W6uUWS4w4Tk3kURVv7ig38T4bxI66I5h6yMoqw?=
 =?us-ascii?Q?41qPboQUtG6sNLhDEL9TsFB4yFYRcHWlm1k+lcZ49FJdNE8BIJzdbjFmu9LA?=
 =?us-ascii?Q?W1XH0X89crTFSMIXEmsulozyE8JP09Uwijn5+8m/6VZX00zyCh5E1Ly76kmz?=
 =?us-ascii?Q?ud9W2OIppCA77IrCL6gGwjLVIMCMGSKEwgtAuUdCHIyb0pP7Jz4WYjNno4ar?=
 =?us-ascii?Q?ez7qQU+Wzu53oveHbLmGGF2z177k1ZwJHQioKVHc3qEz4xmyh9dzN6rrSOeS?=
 =?us-ascii?Q?/o5WP3yFeRJ6kbnv/SwkpYc4xHyt2DcXSQR7PyfLVktxxfjcZNk4VsL88zLh?=
 =?us-ascii?Q?jL7GkyzyHHVDBdQ+JCY4o8SBJEha+icbPuoGfFFFTI63Kt4y+hy7Iv7Af7FE?=
 =?us-ascii?Q?kxXvij+2rvMuJXXeZENb0hsagzimtiPPXvzSIYqSnq+9ARn9tRzzFXvXOc7u?=
 =?us-ascii?Q?WOLxMx5VsNQRS59U/Gm/PJNaJ7Ns91nrBVzoVFmr7qXTsrpGHGhT72a5nZBS?=
 =?us-ascii?Q?XFJv2fwuqg1H8XJsqFo0c7vr2HpRzLEAmM9A1cOGfGtmxY4ma3ZCFqAzvX6h?=
 =?us-ascii?Q?nBxMmCUSjdXGAzgq67fmF+6SY/fryG1zAZB07EH5oTHOPZGn36GVYChUzXqV?=
 =?us-ascii?Q?gU0jTvSc7AhSubGd7LL2nO4XGhosWjkSaN9Hio04oTQ/bJ+3YryCdDWRNxAV?=
 =?us-ascii?Q?3LOkv2xoC6aN7vud/QHsXyNqA5x7wwVoXnpGQ1fgNcY2cJMvOQ1gKD2DMEQ6?=
 =?us-ascii?Q?98J855m16uTPkGrHJzH6aRpX/vlohD7hWlYlXqQ7xM/qpm3i6RxobE+r5Umm?=
 =?us-ascii?Q?F55Z079AN7KOC7kvD4XHnAmPp8w+VE8oiM9vOqpc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaa0d7ea-3015-44e8-d6c4-08da8c0049c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 09:56:49.1584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H74aaxBzxzG2+qQBt6csxCeJCgqO1sz2lWikVDe+WTAbJ3Cyj4Vf/j/SXGnkPDY6HC19rWrV2iPWfKyo7y7OmRnJoIqpafzGAHmoNEfDOAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3577
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: ivecera <ivecera@redhat.com>
> Sent: wtorek, 16 sierpnia 2022 18:23
> To: netdev@vger.kernel.org
> Cc: Piotrowski, Patryk <patryk.piotrowski@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Williams, Mitch A
> <mitch.a.williams@intel.com>; Jeff Kirsher <jeffrey.t.kirsher@intel.com>;
> Keller, Jacob E <jacob.e.keller@intel.com>; moderated list:INTEL ETHERNET
> DRIVERS <intel-wired-lan@lists.osuosl.org>; open list <linux-
> kernel@vger.kernel.org>
> Subject: [PATCH net] i40e: Fix kernel crash during module removal
>=20
> The driver incorrectly frees client instance and subsequent i40e module
> removal leads to kernel crash.
>=20
> Reproducer:
> 1. Do ethtool offline test followed immediately by another one host# etht=
ool
> -t eth0 offline; ethtool -t eth0 offline 2. Remove recursively irdma modu=
le
> that also removes i40e module host# modprobe -r irdma
>=20
> Result:
> [ 8675.035651] i40e 0000:3d:00.0 eno1: offline testing starting [ 8675.19=
3774]
> i40e 0000:3d:00.0 eno1: testing finished [ 8675.201316] i40e 0000:3d:00.0
> eno1: offline testing starting [ 8675.358921] i40e 0000:3d:00.0 eno1: tes=
ting
> finished [ 8675.496921] i40e 0000:3d:00.0: IRDMA hardware initialization
> FAILED init_state=3D2 status=3D-110 [ 8686.188955] i40e 0000:3d:00.1:
> i40e_ptp_stop: removed PHC on eno2 [ 8686.943890] i40e 0000:3d:00.1:
> Deleted LAN device PF1 bus=3D0x3d dev=3D0x00 func=3D0x01 [ 8686.952669] i=
40e
> 0000:3d:00.0: i40e_ptp_stop: removed PHC on eno1 [ 8687.761787] BUG:
> kernel NULL pointer dereference, address: 0000000000000030 [ 8687.768755]
> #PF: supervisor read access in kernel mode [ 8687.773895] #PF:
> error_code(0x0000) - not-present page [ 8687.779034] PGD 0 P4D 0 [
> 8687.781575] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [ 8687.785935] CPU: 51 PID: 172891 Comm: rmmod Kdump: loaded Tainted: G
> W I        5.19.0+ #2
> [ 8687.794800] Hardware name: Intel Corporation S2600WFD/S2600WFD,
> BIOS SE5C620.86B.0X.02.0001.051420190324 05/14/2019 [ 8687.805222] RIP:
> 0010:i40e_lan_del_device+0x13/0xb0 [i40e] [ 8687.810719] Code: d4 84 c0 0=
f
> 84 b8 25 01 00 e9 9c 25 01 00 41 bc f4 ff ff ff eb 91 90 0f 1f 44 00 00 4=
1 54 55 53
> 48 8b 87 58 08 00 00 48 89 fb <48> 8b 68 30 48 89 ef e8 21 8a 0f d5 48 89=
 ef e8
> a9 78 0f d5 48 8b [ 8687.829462] RSP: 0018:ffffa604072efce0 EFLAGS: 00010=
202
> [ 8687.834689] RAX: 0000000000000000 RBX: ffff8f43833b2000 RCX:
> 0000000000000000 [ 8687.841821] RDX: 0000000000000000 RSI:
> ffff8f4b0545b298 RDI: ffff8f43833b2000 [ 8687.848955] RBP: ffff8f43833b20=
00
> R08: 0000000000000001 R09: 0000000000000000 [ 8687.856086] R10:
> 0000000000000000 R11: 000ffffffffff000 R12: ffff8f43833b2ef0 [ 8687.86321=
8]
> R13: ffff8f43833b2ef0 R14: ffff915103966000 R15: ffff8f43833b2008 [
> 8687.870342] FS:  00007f79501c3740(0000) GS:ffff8f4adffc0000(0000)
> knlGS:0000000000000000 [ 8687.878427] CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033 [ 8687.884174] CR2: 0000000000000030 CR3:
> 000000014276e004 CR4: 00000000007706e0 [ 8687.891306] DR0:
> 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 [
> 8687.898441] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400 [ 8687.905572] PKRU: 55555554 [ 8687.908286] Call Trace:
> [ 8687.910737]  <TASK>
> [ 8687.912843]  i40e_remove+0x2c0/0x330 [i40e] [ 8687.917040]
> pci_device_remove+0x33/0xa0 [ 8687.920962]
> device_release_driver_internal+0x1aa/0x230
> [ 8687.926188]  driver_detach+0x44/0x90
> [ 8687.929770]  bus_remove_driver+0x55/0xe0 [ 8687.933693]
> pci_unregister_driver+0x2a/0xb0 [ 8687.937967]
> i40e_exit_module+0xc/0xf48 [i40e]
>=20
> Two offline tests cause IRDMA driver failure (ETIMEDOUT) and this failure=
 is
> indicated back to i40e_client_subtask() that calls
> i40e_client_del_instance() to free client instance referenced by pf->cins=
t and
> sets this pointer to NULL. During the module removal i40e_remove() calls
> i40e_lan_del_device() that dereferences
> pf->cinst that is NULL -> crash.
> Do not remove client instance when client open callbacks fails and just c=
lear
> __I40E_CLIENT_INSTANCE_OPENED bit. The driver also needs to take care
> about this situation (when netdev is up and client is NOT opened) in
> i40e_notify_client_of_netdev_close() and calls client close callback only
> when __I40E_CLIENT_INSTANCE_OPENED is set.
>=20
> Fixes: 0ef2d5afb12d ("i40e: KISS the client interface")
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_client.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20

Tested-by: Helena Anna Dubel <helena.anna.dubel@intel.com>
---------------------------------------------------------------------------=
----------
Intel Technology Poland sp. z o.o.
ul. Slowackiego 173, 80-298 Gdansk
KRS 101882, NIP 957-07-52-316
