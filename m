Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6FA5EEBD9
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbiI2CgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbiI2Cf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:35:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B79115A5A
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664418937; x=1695954937;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oqKSxhIOHnyc47gWDPWCI7ztv9YZNNJdIQvRPIVZdCk=;
  b=Sl2d7z1FIgWTb8m/kXCjxMS1W/AbvCCprQ9TENJ093bAc6FWSgZkI5K0
   ZSXpPduQr/6tfMrlVOpivwJEGV2e/7bDWnW7f+Qgs/xhATtuou0w8mGRr
   /yWpt2eiw61Nn/Hyq/7YEqHMOZep5ILPU6P7W4uTZ/YCZux4iqlW1GM0n
   K9JbTZMz/qDzwGvP3VQ092wEFUOkUzENHzRMyE+O7gATb+cHCaG8Kk/bc
   7xghUzVhUaRvNdIO++nVOYg1JT/KjvcHUCYvjjK+ehVcDAm0RbT50lXFY
   0sQzTTlvFa5FcoByKZeS0LiD8qGxZWGgfbnXygpdMFch1VyG/2J4KHrRD
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="301749454"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="301749454"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 19:35:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="573281496"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="573281496"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 28 Sep 2022 19:35:33 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 19:35:33 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 19:35:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 28 Sep 2022 19:35:32 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 28 Sep 2022 19:35:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9mJTo+SEvJ24+eAtKzgQHVd/5O7E6lUBfoVFq1gvZA6907qZVu+OBDmXbVU6qqIzG6KeYEpe4WcBr7k48YwHDCsw40TnlGjEv9qTJp4ivPl3jicmuZLB5uqURWAxeq2ohIW8uUwCYGy4kVybwwtY+HKdbWDNt0NdmvDNZeda85kBeBg9bUQBkVLZVOWVUmfg844UeRX+3/rDIYg3+UGmLDtTrY5u1BTaRTgwD0StIcgMNLFTufolP5pnQUFT/2Pi8gV5c4e2L8c1+a1Y7STifCdN7mRj4h9s9B/DiStcTv+JHwimSRqvAMyV0BLJrcq1i7SdZ/+QcjR+c7xineUQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqKSxhIOHnyc47gWDPWCI7ztv9YZNNJdIQvRPIVZdCk=;
 b=fX7SZTbbfWP8uMew4nMkK86PCBrLT4zy3ZpUZimDSN3W9gDlMPiUJzMCAuhs16ywHXzBLmqkqoFZvU4wU+sA1Pt7Uy9aIn+bsi7U2OzRVzbkof8CHbR/+iGtyn7l8Kt8W+/OUGZ+mV7AppFYfJ+5drAJExTOjKBLXN5OotJtb3Fmwn0gesZM1zNgjvhEklQnLvXREdtWbpC3lB2u1KzRw0221b+08v8d7HzQVdiTbViPJfBYAo7UqlAA3quuQbSXuf0raPpqIRuLUBtf1Xe0ErNG8mu2GEiq31CIdHW1N4I9lO7uyAqx3zpRcg2JzueA+QCSUUszIvxn1t2wnQZ5SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by BL1PR11MB5398.namprd11.prod.outlook.com (2603:10b6:208:31c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Thu, 29 Sep
 2022 02:35:30 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::7c03:1c40:3ea3:7b42]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::7c03:1c40:3ea3:7b42%5]) with mapi id 15.20.5654.026; Thu, 29 Sep 2022
 02:35:30 +0000
From:   "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "Ahmad Tarmizi, Noor Azura" <noor.azura.ahmad.tarmizi@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP packets
Thread-Topic: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP packets
Thread-Index: AQHY0nIwdgyUAXnuBEqr/9DPT40VFK3z+DeAgAG3sRA=
Date:   Thu, 29 Sep 2022 02:35:29 +0000
Message-ID: <SJ1PR11MB6180CAE122C465AB7CB58B1BB8579@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
 <20220927170919.3a1dbcc3@kernel.org>
In-Reply-To: <20220927170919.3a1dbcc3@kernel.org>
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
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|BL1PR11MB5398:EE_
x-ms-office365-filtering-correlation-id: 8e131834-7b33-4f85-e19e-08daa1c3468a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZUmOLC1riAIYURq3bNjUwXGWVh3Qj9U0JTH2dxvVN5YDbAYMatekcfjWL48w4UZ98M5qbSK+K3i/yNS86149bclwUTkpiFyewddwjsSy6zBvWxn1nsAHDwCZKbHZWj8W3XiHjLDYnS691b6GHP4MIA41+F7mZJXXzmuoBZHnXid0frzPO3KV9EcAXpjJfzP3ZrgFSO3wcrLJ3zI9O1bzxP3JB8my1BSPgfviAmB6ydFHvaUtWvL6Ex1bIXL1elDWWNWZ+y4/w1J+25gCcjb/B90DhUtCraLX8LECrbFwVxzxeOVRrDmgN4PdWODPYkpAShsx3zRhe4lnibANqxzFeSYxuzxsXxNOiuGq4a6/KF10O6UOY5eqktJWWht8/9fXE+XhT+j1tiXiiily7i2nqiycc6CgqX/gyaCP8gAr/oz9fiGNuHaopvuPSPYg9vkWX0OR+6xYgJkOT3RzZVZBqr6TvPDCFx5rS35lM16ao+MBhpiYorjaMbmdgGw9G04cO0jRFTCK+udKxnIyxgc2cy+6UVOqMJX5abBeSHG0W9VRMssX7fpNQiFe2m9wj6pr0fiC/ixt1wcqe+9vf8Ae9igkjNv6wqX8qRACB3KVmghF/UOXapbKKFnJXdDxdiAaPup2RCx8BJ9Ue0fRxNB5vIfV+sbeao3+bbFS3AuhCJ4E2SwQLDwOB7WkpKOBaNBlIxZTAAnPfxCJw2UXEL0G6O6Ff7J2t1vTyWJdAwFJNo0Veb/b7xzyVPC6AlzMiYCsRWp2LSv6rtUelFFenAjhtg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(86362001)(55016003)(71200400001)(54906003)(478600001)(6916009)(316002)(9686003)(26005)(53546011)(4326008)(122000001)(5660300002)(6506007)(82960400001)(2906002)(8936002)(52536014)(7696005)(41300700001)(38070700005)(38100700002)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(33656002)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jOMf34zFfGN4BRtlU3tIjM82K+ZtzLCtrUCRctgOIclHxZ8lHyShaDHkZPrg?=
 =?us-ascii?Q?oJ5LSel+8hPEaWOXQNK4labqKIylJc98ukM/sezNKM81d403ptWlUR1p3EvT?=
 =?us-ascii?Q?0JA9wTxO2G+CytkI2/pvvfi4YK08sqK/y9MdwPQghdIu8B4IafCP5JBbUSc/?=
 =?us-ascii?Q?1IbAHwxZeKpFHZbFCBbtNLNXlKDIzEdGwODj6zMSbiPrtwrPu816TaDStb3h?=
 =?us-ascii?Q?j6sicZk5RHfaWTcJcVIiXS7+xoOdMypxGfVRk57SwYBMiBiPFAdRYLm+///V?=
 =?us-ascii?Q?ecRLagYStfGx3ec0jh6X1RVTaRVnjB4nY9gQk90Jcd0sMdJlrjhAR0du47YW?=
 =?us-ascii?Q?bwDHDpq0PcMdkoROQF0hJlbZJRlMrelis87zQTwAokuCtHbsMb87i0ZFZIte?=
 =?us-ascii?Q?jGCeeMT48h0uUiOfIL6vFbavaknjBk+9u6ZlLL2WzWpXK/33ZEAdMuAndfdZ?=
 =?us-ascii?Q?+HT6EKEWsPHsA2OTH2gnmqLomWtJpLWwBfDJbDlEot2Bb4tOI0Z5jFWqOldG?=
 =?us-ascii?Q?zkDeLEnJhluX0rAvaO+0EgZBYG7DfkPfCtkgzdwbbjqelpPmhgGWCJGVwJLZ?=
 =?us-ascii?Q?CyL4uSE1LOEXtl0OWDYXj9PPwwE7sV5EdRe5HrADoOP5VCSCgNQ9Q6WcdU5c?=
 =?us-ascii?Q?9p9S+jdanitLue7Wr2vcRYeFpMju/Vnth8sbP7GlKt/68sEqYXKa3/ufu/Bo?=
 =?us-ascii?Q?GJlEsjZ5FVFopQC1IYvq37Eusz4j/G9MpXB5zet35C2/fql4LRK69WeBXLI7?=
 =?us-ascii?Q?CztCMnYmhUTWT1DZVe4uTa4wI8Jy4INEsd13s6dd3gBv0iD0sVkUwR5+nfJ+?=
 =?us-ascii?Q?J4izsajQnaHrBbBwZjlGJzaJ8R20Jss9EqTH90V0YVd84HHeGMoTjoKkV3N0?=
 =?us-ascii?Q?pIFO42Sk1n5kgFBpmGeyEoDM/c/SD03HE8HIupitavw35UMBHNQv2I4GdEJX?=
 =?us-ascii?Q?YZs2ifrxjvyuCH4JnHDhIWVJLb2ez/EF13y/WJssl7vGf5ImpsFkvj1ce0+/?=
 =?us-ascii?Q?Rt+P1+y8EfG6Hb1c8R+Ntx+fpunj/9+YjAT7EakSzF+p/pMdGiE6eF51nTLQ?=
 =?us-ascii?Q?vvDxEvKw5JSMVyGnp1DunwHWWfLVr6k6AK3V6vWSk6ZvYJdEmByeCyCYgeI0?=
 =?us-ascii?Q?dX7NsF590+tj2ClWyVF3dLS/E3xRrnTOOBZk8n45qk/LYl/yuLV4RVdoaDB+?=
 =?us-ascii?Q?fkRyurH29NzKavGXu55txBNBoGZlaDGLVT7VYsUReKu9tKxm9gp9K0gawILt?=
 =?us-ascii?Q?4CG0IGRmxd5tCZmTjCCEgQ7Jwa99LaKR7AiSAbyZwAUFPSB03HAy6GZqjAuG?=
 =?us-ascii?Q?zO5WmK4lkIZ0Zn6rJktjvQUp2yYosAWSaTDO5WMxddmdTqG8fHN2x+Lm3EQ4?=
 =?us-ascii?Q?1tOSBZLsxjHAL0au8ZnGDQVaVRffUp9UzfA3sfLdsZJRQ4o0kR4nL4dl7bDI?=
 =?us-ascii?Q?G5fhosoxVKp5SZ8afAWqgRJCaTrX3pG9A1osyPqXB3DN5VCJmhG54n3ZZIJp?=
 =?us-ascii?Q?hKbi5laDkxZdTSI/1pCIcB7KZjJ4AKvbHuI6v7EER+CkbJAsrog0PJRfqHsk?=
 =?us-ascii?Q?CDgV8pI5vRoaHJwnjs2bpQ1GENxUCHtAgOYs/JQBcDZ+s8kMIxPNFMGYTZOI?=
 =?us-ascii?Q?P83TszNtkaUUWpEDjIEaIMI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e131834-7b33-4f85-e19e-08daa1c3468a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 02:35:30.0079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VaoAdoqXub5DCCd38LWDdnF9VjX/tg0fLvtZsk46JZ8KMVyXzCeVX10WMXFlld+Qha+Ia9AOJL9icq/JzO1VUT060D6cteq9aR8emb0hkl3KSjViOXtq3GYqVwbCiLkc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5398
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thanks for reviewing.=20
Please see my reply in-line.

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, 28 September, 2022 8:09 AM
> To: Zulkifli, Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>
> Cc: intel-wired-lan@osuosl.org; netdev@vger.kernel.org;
> davem@davemloft.net; edumazet@google.com; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Gunasekaran, Aravindhan
> <aravindhan.gunasekaran@intel.com>; Ahmad Tarmizi, Noor Azura
> <noor.azura.ahmad.tarmizi@intel.com>; Richard Cochran
> <richardcochran@gmail.com>
> Subject: Re: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP
> packets
>=20
> On Tue, 27 Sep 2022 21:06:52 +0800 Muhammad Husaini Zulkifli wrote:
> > The HW TX timestamps created by the NIC via socket options can be
> > requested using the current network timestamps generation capability
> > of SOF_TIMESTAMPING_TX_HARDWARE. The most common users of this
> socket
> > flag is PTP, however other packet applications that require tx
> > timestamps might also ask for it.
> >
> > The problem is that, when there is a lot of traffic, there is a high
> > chance that the timestamps for a PTP packet will be lost if both PTP
> > and Non-PTP packets use the same SOF TIMESTAMPING TX HARDWARE
> causing the tx timeout.
> >
> > DMA timestamps through socket options are not currently available to
> > the user. Because if the user wants to, they can configure the
> > hwtstamp config option to use the new introduced DMA Time Stamp flag
> > through the setsockopt().
> >
> > With these additional socket options, users can continue to utilise HW
> > timestamps for PTP while specifying non-PTP packets to use DMA
> > timestamps if the NIC can support them.
> >
> > Any socket application can be use to verify this.
> > TSN Ref SW application is been used for testing by changing as below:
>=20
> Very glad to see this being worked on!
>=20
> High level tho, are we assuming that the existing HW timestamps are alway=
s
> PTP-quality, i.e. captured when SFD crosses the RS layer, or whatnot? I'm
> afraid some NICs already report PCI stamps as the HW ones.

Yes. HW timestamps always can be assume equivalent to PTP quality.
Could you provide additional information regarding SFD crosses the RS layer=
?
According to what I observed, The HW Timestamps will be requested if the ap=
plication side=20
specifies tx type =3D HWTSTAMP TX ON and timestamping flags =3D SOF TIMESTA=
MPING TX HARDWARE.
So it depends on how the application used it.

> So the existing HW stamps are conceptually of "any" type, if we want to b=
e
> 100% sure NIC actually stamps at the PHY we'd need another tx_type to
> express that.

Yes, you're right. Are you suggesting that we add a new tx_type to specify
Only MAC/PHY timestamp ? Ex. HWTSTAMP_TX_PHY/MAC_ON.
Sorry about the naming here. Just so you know, the DMA timestamp does not
quite match the PTP's level timestamping. The DMA timestamp will be capture=
 when
DMA request to fetch the data from the memory.=20

>=20
> Same story on the Rx - what do you plan to do there? We'll need to config=
ure
> the filters per type, but that's likely to mean two new filters, because =
the
> current one gives no guarantee.

Current I225 HW only allow to retrieve the dma time for TX packets only.=20
So as of now based on our HW, on RX side we just requesting rx filter to ti=
mestamps any incoming packets.
We always allocating additional bytes in the packet buffer for the receive =
packets for timestamp.=20
It is a 1588 PTP level kind of timestamping accuracy here.

