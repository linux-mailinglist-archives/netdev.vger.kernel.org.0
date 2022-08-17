Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6ED596FF4
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 15:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbiHQNdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239036AbiHQNdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:33:24 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7E498D33
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 06:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660743065; x=1692279065;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aaYuaJZbHgK4aLUt+Jn/aP0ZwTnxn61qwAwZ2eLx5+A=;
  b=R5Wja8UrP4w2UtbJ2fG6iLJlFuWk64GlpLgVlg7ADK77VmJ/QbLJRa4k
   rhN2VrTO2xx/VKgpyAB/LXWuFEUEhZvCmO4K4pXRW/HLtIsZmTxqvGgiD
   RipuSdkM5oqaCPlyyvCpyq6cbWJErBu7AyXAG5VeWZGDZB2u5kfwqftTD
   p66lI/4kPWVRB1DL+0umJOAWPwLpJEI/d5Ahj4g/waoN1dBKZWtMyjpY1
   e/GFfaPjunZwrkeIsD1t/mFApYTshxsSGN7ZcSy0E1TDyJYVeZsq/yUSX
   1YfD3PsThSiU0fjDBUUdgftGPWnWaZMHoj8B75ljm9kSuEjMQ268FJ8l4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="378782818"
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="378782818"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 06:31:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="583769092"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 17 Aug 2022 06:31:04 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 17 Aug 2022 06:31:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 17 Aug 2022 06:31:03 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 17 Aug 2022 06:31:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GaGopBruNY/6k4VePDdbnj0HeRYLGVhEYeV4m82YHlaUdm22szEHY3/OV/1raY6lZNiacld6fNhQGJkKsUhnwCUs+6gUPewl91tcn6vQDgB4aA/pHhGDKxaR98RpwWp1C/XdhtHQsQiw1pEV/J0wMqaU7YPgxJD9pnWmYEfPUNPv2r7CoBOLcgW8wiSQLgqP3eY3LZ6wM2bH7/X11j/xE093RDqLVcOh55GEGW5VOIccIQvnUtrb7b4SCLb9H9jh0bXNlhynhQpNnNV3L4GQyFqRm6ypfm/PVWg4fE88OaDFamaqQSWkbY5T4VHZO6J7KCLq2rmgf4QONBUEaWyaaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aaYuaJZbHgK4aLUt+Jn/aP0ZwTnxn61qwAwZ2eLx5+A=;
 b=mrYJKOJyeu1/wyMwq4ehx0AEeEmuWAOHnAPHDYPzAYIqj8GiqH53mQhEiO33M81XwaFy7RVzp0nRiLUG6x1tkAdqsUNDj1w5+JeN4dVEL0fhnYkTD8AUMlH6EnPYZE64fKFse9tfshsRyXNOH8bGwO+3bR8Gxs4PNyLfH5npqfSJVoByrP+1LVwdXvLlPg3wz8ohsNLrtYEF+e0n1Q3xq6tBoKcBLyxRLxdem/bPM0wLU9qNBzVbP8Iu+MkttxPK0wW7G4zWaq+1/Oc72m3DjjKLwHaGUKImbYcNmqxldKTQLIzofC/GCaIuvqAEM3+uAt+3O50vISU8v5hTCWVtcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9)
 by MN2PR11MB4255.namprd11.prod.outlook.com (2603:10b6:208:18a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 13:31:00 +0000
Received: from PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::c872:16c5:ac1c:52b1]) by PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::c872:16c5:ac1c:52b1%9]) with mapi id 15.20.5504.028; Wed, 17 Aug 2022
 13:31:00 +0000
From:   "Sokolowski, Jan" <jan.sokolowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jaron, MichalX" <michalx.jaron@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Jagielski, Jedrzej" <jedrzej.jagielski@intel.com>,
        "Szlosek, Marek" <marek.szlosek@intel.com>
Subject: RE: [PATCH net 2/2] ice: Fix call trace with null VSI during VF reset
Thread-Topic: [PATCH net 2/2] ice: Fix call trace with null VSI during VF
 reset
Thread-Index: AQHYraItZodpN5zhh0i0QVHU4zyAjq2r97eAgAcnw/A=
Date:   Wed, 17 Aug 2022 13:31:00 +0000
Message-ID: <PH7PR11MB5819695C8B5C6E5F7D0500E1996A9@PH7PR11MB5819.namprd11.prod.outlook.com>
References: <20220811161714.305094-1-anthony.l.nguyen@intel.com>
        <20220811161714.305094-3-anthony.l.nguyen@intel.com>
 <20220812171319.495e33f5@kernel.org>
In-Reply-To: <20220812171319.495e33f5@kernel.org>
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
x-ms-office365-filtering-correlation-id: b2756d49-80a5-475e-88b5-08da8054b9ab
x-ms-traffictypediagnostic: MN2PR11MB4255:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jV+HttOwxbIVyqEOmUuDrGd3u3xiAUjqjDzzR7dLeIWniOkbWdxyxg5hVh3IgXHvMHHB1v8D7xa6KnIfG/dRL69Jew2TTTE1R0gNdpNBCZ2nO1Vq/xsiVo37jxGoZaIT+FLMa8IfQ0QPHtQaO7m98o167m/g3c0soEQpOn5bmWbcxrRRcy+F3Y9e54GmX1eenYc1EHNIw/r/FmK0UeKULLIvptU844K0Dbz07UHltliPya5mjnANI8WgNFaUQIj4GAF7NdTw+sAd4Hx7HMZW22C86o1LNua0pAKteD1ssjVEVBZ76E9EYZtcnCcMTj4xucSuCgzZKH3c70SzJxhGxebc4J71dXiw+BH77n0nonGlCUBDfHq+YxcG0wxt36WetK7ciwNTsbS7QDYF2SMDSYDwgn6vl7U0RVUxOl7UjZyQCJ0d6bqbt8nOgMPDcfdN4JlEdfApfiJ42HqH8/Z8tCcNdZOqbntBXgeNiHnmaDSBpcUF6WDpx8n44hL9L+he2pfwiNzh4C8ETrjBSaOisKr7azEiIrJbYHkSOHU7gd9SWG0bAhgu1BRAklTufU10n7czEOo8NZLRR6xGsvqi8fIas9c9tlfL8qhk/T4IZBJ+gFMHrKrCecQMjEkzxlJY+uDUJZKnxB+/RgShbxFBLzqk+kbCg4vnHM+RTkoxYhJTA77RBgwmJgEKbkwr028e4HlfeyKEeMCLZ7wcH6zgVjm1wuPnfRWNdCOW1etWraoHIz6Fl8EXtBZ53QT46PymEyFcV1zJiXEVwBDB+iShuQmyRuN7KP5mzPWY8ozdqMlfzQAf37O/QR8Q7nUu1PAo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5819.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(39860400002)(376002)(396003)(136003)(38100700002)(71200400001)(4326008)(86362001)(64756008)(122000001)(2906002)(66446008)(76116006)(8936002)(5660300002)(66476007)(66556008)(83380400001)(82960400001)(6506007)(38070700005)(316002)(110136005)(54906003)(8676002)(66946007)(53546011)(55016003)(7696005)(186003)(41300700001)(107886003)(478600001)(52536014)(26005)(33656002)(6636002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZeVMbYKRshwlyDlo9/A5QDg0QdfZU4u6MUL0d7iS/6OAW/ye1gfRadW0z8gX?=
 =?us-ascii?Q?yZagftp/LJxRp8eEiGxkGu3cspT55Mt3QD5RYnMZHsjxqnbNhaMHXa7+Fhfm?=
 =?us-ascii?Q?uacKMnFIrVW4rLO2ZVTFRdtlj45pEK/AMSe9d759/nMENGl0yxbWNwrYbjJT?=
 =?us-ascii?Q?khnZwDMG/r+waP70V2gnmmjEZWm1gmrk5DQnypyaLqRqsxjv/g5pIuP8S1bX?=
 =?us-ascii?Q?n3pqc8AFBQbDnFTv88CEmHGLT10g61Yz94Cjovpq9YKEx+QhhoNxDnG2IVij?=
 =?us-ascii?Q?mkORkpOJgIW3oEVPExJj7JlOgLFyteKJETpaivfMpVuhjcacrh7rZXJvWYox?=
 =?us-ascii?Q?AHjewVz8E+Qq43Z14twqB4cEFE/1yfHiTQ8gHZ58PAZpZmpxHUs23kiXyYcQ?=
 =?us-ascii?Q?+HAdNeRXoPXS2wnH4n4ZFOmDoPH8vOTJAO9aFwhfmAunavkMfLQw6yhUu+ht?=
 =?us-ascii?Q?KYV6PqfZtxOfZLFDfb0/SWBHmzsnWD/kn+z7YyQ+NfVnu/GxFxpGPVmOODFY?=
 =?us-ascii?Q?RTBEpqDlRPYU+g3TWpdgHgrwS02efIlIg9a26GLN9zroftKSN6Ecs3Q7HAuU?=
 =?us-ascii?Q?WJfWelC2O5PtQJ6IqiJBZpQtGqqJOG5AQ+vlIpNsZmMeS70KU9xDQHp8sF4j?=
 =?us-ascii?Q?r03genS7QbvTIoked0yCbPrCmfcrg/Y0YRMGC8xElnemMYR1deP9Y2jCRmsS?=
 =?us-ascii?Q?qJzp/wkW3ehkyx/gLRUQXZ7WcYjQyMTqpkyLFrXamORXQcmpp4oxTbapCJMm?=
 =?us-ascii?Q?9xzyLJTxAg2X9bc+j/vr6h+n04faWo3GGDY4T8LbkY6zhTEsBfFUzUUZ3zmF?=
 =?us-ascii?Q?gT4RSipPnvv4krPJOwl/6mhQ/qvo3KEVRii9JyHUg6zGyGSzLfeOm30NhWQM?=
 =?us-ascii?Q?tGn7/5tIrFYsIht5cvE33uIvaX9mY+RHfaBH0SsITAz649TPLXYog0FG12x+?=
 =?us-ascii?Q?Xog+kCQYDrq8dffo9QAQ0s8HQvPeYr8vbQ3wr7X61a3+2jEvtm9OMcvnySK/?=
 =?us-ascii?Q?XG9KxNelhO89rAgbOk826sGWjiCXhg7EAd7+ML4Qg/U0b29i//5rzAT+XOV8?=
 =?us-ascii?Q?XhnSyNsoNceGOBHNKgPEtj5uhYPeSor65A6gqPF4+BKAb1Kz2E0oJc6yNnJD?=
 =?us-ascii?Q?eBjJEphiSNe02DpGBWhfEvi4z61Fg9N/CcEyNCzgVn8S+1QD5cmgxO1w/hQb?=
 =?us-ascii?Q?gUg8nJKqGy93H91jyp+lNXr/wU/L7SGzQIA2G3YuI7CyTMGAqxzu4Cn4WSLm?=
 =?us-ascii?Q?VQG8N1a5fAt4QFngIesWIUKvrWDjqP0jkwHXgxCp5YaJCZ7bsySzjX3FaNkt?=
 =?us-ascii?Q?WupatHeFdm5hlbuMtTU9OBYHzflCepfSjEeP4nc2E8tF4I0OLvVDTWuTY5KA?=
 =?us-ascii?Q?frV/NEjY3/lwy4sCZveZSt6bjtIllAbnQcv6x/OPgLwgEtdofVg06rTltoYZ?=
 =?us-ascii?Q?rzjtBoOh74GXUTK39XlVJky51XLKGVm1gWpbPSmBbhsIFZa1uKowXjYcM86y?=
 =?us-ascii?Q?NsKbkZAq8qnpPHm9GlPtnVhd/BEBQyHjgl/kZ/qHsYGCdaNprKJZPKW64Fmb?=
 =?us-ascii?Q?awJDlBCtYxHHPdmgPf4Gl5BpDDfCfZVJmYoQB+m3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5819.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2756d49-80a5-475e-88b5-08da8054b9ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 13:31:00.6356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aE1QjaE2BUXtkpCjIppbjfNa2J8vgYdExpA67GMySYZyK5eQ+ad/a9qd+Sy9RKY7lf7C2Mh5WjhqPkGUwr/P24Lei4X+GmssIsrskej6iLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4255
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

I'd like to send this response in Michal Jaron's name, as he currently cann=
ot respond to this email.

Generally you are right, it is better idea to try to keep the system in a c=
onsistent state than adding "if NULL return;" but I don't think it will wor=
k here. This "if NULL return;" is here because of race between two resets a=
nd I don't think we can guarantee that this race will be not present if we =
flush the service work before reset. The problem is that vf reset is called=
 in the same time from vf on vm and from pf. When reset from vf is called a=
nd reset form pf don't clear rings yet we must go into ice_reset_vf and cle=
ar those rings without triggering second reset. If we don't clear rings the=
re we may trigger page_frag_cache_drain crash related to writing data to un=
mapped queues. In such cases if there are no vsis we don't need to do this =
and this WARN_ON is not necessary, but we need to check it anyway.

=20
-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Saturday, August 13, 2022 2:13 AM
To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net; pabeni@redhat.com; edumazet@google.com; Jaron, Mic=
halX <michalx.jaron@intel.com>; netdev@vger.kernel.org; Jagielski, Jedrzej =
<jedrzej.jagielski@intel.com>; Szlosek, Marek <marek.szlosek@intel.com>
Subject: Re: [PATCH net 2/2] ice: Fix call trace with null VSI during VF re=
set

On Thu, 11 Aug 2022 09:17:14 -0700 Tony Nguyen wrote:
> This WARN_ON() is unnecessary and causes call trace, despite that
> call trace, driver still works. There is no need for this warn
> because this piece of code is responsible for disabling VF's Tx/Rx
> queues when VF is disabled, but when VF is already removed there
> is no need to do reset or disable queues.

Can't you flush the service work when disabling VFs instead?
Seems better to try to keep the system in a consistent state
than add "if NULL return;" in random places :S
