Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F7262F755
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242314AbiKROaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbiKROaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:30:19 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AEC23154;
        Fri, 18 Nov 2022 06:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668781818; x=1700317818;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PLFwIyiY5Qf+yJSO+YcOKlYAIK1RUl5lPaWeH2a3GXU=;
  b=Tk/3zGcYB76V8eiEQ2yQ5uE3MfSGuttEr1Hqp2Ea/RiUdr1QST0LsRHp
   6hpDhtD42pGWXu59cyHgk8XFlWISu6XdyEce/x4+xZ3og3RL6pkrcWNkn
   L7nGmyRPc8UzpZU8y0II+W5t5zUmGFcjpX753VfTncNlaQzfmk+DSS8l3
   7kVfnglba2pAiqqi7yyRIzBVOC7aYgOdsCtCga2weIIsxCp+nFDlbAGsL
   QPxChMXV6BIG+BQWCCtfZ42KyGQaAkGri8nDQLuONIhCQN7gYqHlkSlsn
   9vKqspDV1Aq67gsqz35FteZxLqseB0jLWmna7HhHqZWnXFmPX5mSNncFy
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="292844955"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="292844955"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 06:30:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="885319158"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="885319158"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 18 Nov 2022 06:30:17 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 06:30:17 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 06:30:16 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 18 Nov 2022 06:30:16 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 18 Nov 2022 06:30:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBmFBKGsLv70/bsQJZhCZch1XzwHeBsWIQ2zni/aXa469v5NSCMfbTtjNNGPgIG+D2oE3LOdD/UAN7Z0Za4/QO0gjbKEoDXwUszzfSQTVfCYr5i6dGoH/961WzOlUIzVmuDIiqTq7X6ylK4XNtmIBgAGHSgVBMr2ISDzLclp7FHddzk5Wam4V/ifh6LXuvTTbbAn6pOE8dP5rvoHMNW9VtelDO7AxBPJ6XATAFa5AUtifEVi4OFRoRMJs6RK/+wcCPFLfDZR3ZYT+YLgJj0flXYyPa8FlCBujJ+8c5DBZS8/Fyv6jeGsM7Q7oy6TLK/622KYQWTgLTI4oy0wjILDIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KXKSleEmLV8zA/hGy7q8dmnSatL8xMm6MHkKK74QB6g=;
 b=PdZR//YUEBPVD4aCayAhNrTZQa9Ll87dtEEO7GaGIVQkMNMSeoIy6wtO7B74W2pEaF6q6xVxijJcepPKrXm1QzV5RKrcsNa49ntilv55p2r9eYEmolSeQKBOsSbE4OBEKaUJX1/MzV9ZmwuLDycInwRvfXSdw6XCYTQwopucAyOiNvs+3VQc/9JfCMv0mckCJO0da94xnBPFQa/WU4W3pQ1Oye04WyoVTgFaHtn8/cKKtELkXAEjVmCeQbGlxtLUwr71idyZIzlrhL9xdgu04q2FllxFeq9ZEIQCOMBz1ZsphCKfkypE//ldGMV7336JvToEjhDHKQnpugNC6DbcEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 SA1PR11MB6735.namprd11.prod.outlook.com (2603:10b6:806:25e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.19; Fri, 18 Nov 2022 14:30:09 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::9f29:9c7a:f6fb:912a]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::9f29:9c7a:f6fb:912a%7]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 14:30:09 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     SlawomirX Laba <slawomirx.laba@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [Intel-wired-lan] [PATCH net] iavf: Do not restart Tx queues
 after reset task failure
Thread-Topic: [Intel-wired-lan] [PATCH net] iavf: Do not restart Tx queues
 after reset task failure
Thread-Index: AQHY81xxx2lHPg1F40icZaVs18UPPa5EzbBQ
Date:   Fri, 18 Nov 2022 14:30:09 +0000
Message-ID: <DM8PR11MB562191CF011875AC0E707096AB099@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20221108102502.2147389-1-ivecera@redhat.com>
In-Reply-To: <20221108102502.2147389-1-ivecera@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5621:EE_|SA1PR11MB6735:EE_
x-ms-office365-filtering-correlation-id: c9ef2861-1e07-4226-cad9-08dac971651f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uD2UHOAvdlXXsdE2D/M1H0Z+F4nJSW73UfBh44gzOgIAx21A3O+IB99dNW7lX9Ns+QM2z0P6+KDkwAQ+927p6V9+2oAJAg3w/3VfPM6kOz2cXLTn0e0sMwFGtWv/Um4zvszuQbwQyzCfZRisLK2n3ZCzF4rZE4u/esS7KgDtJwJh+wWrI+jMG5M7dgfFd75GUwJufdr/5T1LxYkrHTbhWEiopjXeS2Xq7oiGnfs6AQ1DiCjma66Ve1h+gdoy87PRwurRm5jXpPO9SC+YTb/SBWzjLHYabbKhxAQd7D/mTMMI5AmIVAZ+yvGsolJYqhiSIQK0KT028UMIs05WAUz0aK7ZNKmIoNtPWUs9fN0cI2ksSZPmuT+Mb5GgVK2jzir3DtoYIY1WO2Wh92BPC83KgtozqgHhLYlt8g6oCwHXxQ3ReOLXMgN6DGBWZOUuGPEOlKWOXSHi23OrdWA7ebFbBh9Y8TXEPk33qEvE5wcyX3Duwf7qEAnuIe1/WafJbbfQlyujxQSCCBsNt9Atu0PW5c9l3aGg+5sUMwuOLooiaQ0wWhArKStS5b2LXu5pvRDwqHzP+0AMpDRTKB7gESj7rfyFbNH5fctzHlW9niWrflDFYilbgfXrJmV5muM8NfU3y/WuR4BXajNDuIREpGlqqaYw1EErNzFC6+ThkmlOpWwfhdC+y837dTwsNWVsfS3GlmWFvEyMvOW3XE9dwYL8Dw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(346002)(376002)(366004)(39860400002)(451199015)(38070700005)(38100700002)(8936002)(122000001)(55016003)(52536014)(5660300002)(2906002)(66946007)(66476007)(64756008)(66556008)(53546011)(83380400001)(41300700001)(26005)(66446008)(8676002)(7696005)(9686003)(186003)(86362001)(6506007)(71200400001)(54906003)(76116006)(316002)(478600001)(110136005)(82960400001)(4326008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?C893DHN/at1o/a7sQGfyclUPih6bNBDjVTcjcfJfbzCJuehWeNzlfaN9WbHl?=
 =?us-ascii?Q?u/iM5qPJYJzNl7hVvYyecTisO8ug0QV2eLykrkEPbnrgY2t26Bo+PAK9jQ5y?=
 =?us-ascii?Q?YCgNIUMP2CMonq+5UiSOOkeK9/1s9VCVkzaVa1Nr35pprc0xsA90yL/vjVW/?=
 =?us-ascii?Q?dx2fxIgytRj+mB8Ac5aRWiEiI9PAz929jHtNd72FahntmY2QhMQGl9jCai01?=
 =?us-ascii?Q?cg7FXK6Bazi11alZa74Rk3ASs+n2qCdVNgTyJevr9EwSO1PCRwc0sF2vWwzg?=
 =?us-ascii?Q?2uLLsch+ZbTxMN/l/LDrf6nmdjIWTvnn6T38hJ/q2S4H8WIiy4vT2jgfNj+n?=
 =?us-ascii?Q?II99C5djY687p/YL/7JbvGgi9l15iWncpsdc3QaDD9BCk1ih0LX6mUx559SQ?=
 =?us-ascii?Q?sftMpm3n510viPqLtiz3wPaZRfdEdwb7/QEqFfP9sygJiAuyq3TFRgR6CSFX?=
 =?us-ascii?Q?ixBBIuMVIDS6QLv0vgiRFLsX3K4TQSklTzkZdXRtY7tuwzy6g3m83nZBc+O2?=
 =?us-ascii?Q?lLGjd1n7TnGiIfBIatt8LV64OiDFWylivIzpHqjPUaixg5k0+HC3iIkjPqJG?=
 =?us-ascii?Q?fMg8K8pFDhkbyYqAQiaAm1IckkqJ928RD6UYSw1GzWzz5yoiX+PZmJgBUKxx?=
 =?us-ascii?Q?OT9JqwOsj2/nCbiqd2IjGthZ+7k1xUfecJ6mgmS/8/mJ6qEfrsj4pdmJtDqA?=
 =?us-ascii?Q?+SHm9Cs+NJeCkggEJgmnuIDHG5w++dfXiquNvSF7+xZoJT4rX5zdxWyVEBRz?=
 =?us-ascii?Q?N5yAQw3o6/3ZesyfLcs+L+aWhKAu/Ou7hx2qjvThijHsz/WnNcAUUhEhRnTx?=
 =?us-ascii?Q?Pda1k654jXCXtTGISMdkrGmy/vWAz1Bp14/G+jyGn3JLXCkQ7FepInfkT/vM?=
 =?us-ascii?Q?oHxJFc4fGWeNLMEWih2WFeqJeh5eHijKws+3GPYzr3/fTXKGhrde/P/sjW86?=
 =?us-ascii?Q?kcFKK8+/DRTzYaAXV5bTiyg2vmn/yuQ8Bc3LyT8wUmD3TRW4J05lNh9Apwha?=
 =?us-ascii?Q?N4XJIH3j10fBqCqkbxuCBJsW3LqUyY/vDW3XSdWZWarqUtoLwtxz7VNCV6Gk?=
 =?us-ascii?Q?WeoTOyUOJuwfaoEK6XXTXhTFTE7RHmws7cmFEInGs/gtAaYCEJCa75pt/b+t?=
 =?us-ascii?Q?k5TOsin1jZWKomrgOzegfXmZCnTVzU3Vj/9h6nx3w3z/ySyvxpJk4qHdP9j/?=
 =?us-ascii?Q?aTG4G+Mb6BKayHwGVwQHDSq1DfcaBUK7f4TDeaAGjmRTfjz9QFdZ/OgmYHSu?=
 =?us-ascii?Q?FlL78ERzGqr+TQG+pPNgoIY6S3QjfUfn9gESKjRr916WASPFnNLpUjv1WzmJ?=
 =?us-ascii?Q?DYl8Lx/nDoTUDoOWk1fLLc1LKtHa5kC7f8TLZSvhOMwdniXaIvLc7CP2aJo2?=
 =?us-ascii?Q?LQuNwNzceaBHNX2uAvyGNoqFOWXDkiXHZM9B7mEry7vHlAqLA9BsQtVanS6v?=
 =?us-ascii?Q?aRSXoPw7F1QFFLPutc1AtbV0Ldgfg6NksFbNjfCK17RrQ6r1H3ZaCVNo/awq?=
 =?us-ascii?Q?kUR5gwhF08nKHzj60nQBigYZCPYbWYF6i2+2mlbw6LalkDZ/A7DVMQ+/s4O5?=
 =?us-ascii?Q?h/HTfyWI+u5XKfuieZqT40tO44GOfqSN5j0532OTNms+0nWYNpgmx7txFdF4?=
 =?us-ascii?Q?2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ef2861-1e07-4226-cad9-08dac971651f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 14:30:09.1103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iPsdIKhSAXmzp2b6dqHxS2qwr6K5iV1EzvZiqRsouu0WoYOO4BTLF8G5f5xRJFrepr7yUiB/CYSxR9JBUx/0bXLbjTBUK26ASUZz0mz+jw0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6735
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of I=
van
> Vecera
> Sent: Tuesday, November 8, 2022 11:25 AM
> To: netdev@vger.kernel.org
> Cc: SlawomirX Laba <slawomirx.laba@intel.com>; Eric Dumazet
> <edumazet@google.com>; moderated list:INTEL ETHERNET DRIVERS <intel-
> wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.org>;
> Piotrowski, Patryk <patryk.piotrowski@intel.com>; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S. Miller
> <davem@davemloft.net>; sassmann@redhat.com
> Subject: [Intel-wired-lan] [PATCH net] iavf: Do not restart Tx queues aft=
er reset
> task failure
>=20
> After commit aa626da947e9 ("iavf: Detach device during reset task") the d=
evice
> is detached during reset task and re-attached at its end.
> The problem occurs when reset task fails because Tx queues are restarted =
during
> device re-attach and this leads later to a crash.
>=20
> To resolve this issue properly close the net device in cause of failure i=
n reset task
> to avoid restarting of tx queues at the end.
> Also replace the hacky manipulation with IFF_UP flag by device close that=
 clears
> properly both IFF_UP and __LINK_STATE_START flags.
> In these case iavf_close() does not do anything because the adapter state=
 is
> already __IAVF_DOWN.
>=20
> Reproducer:
> 1) Run some Tx traffic (e.g. iperf3) over iavf interface
> 2) Set VF trusted / untrusted in loop
>=20
> [root@host ~]# cat repro.sh
> #!/bin/sh
>=20
> PF=3Denp65s0f0
> IF=3D${PF}v0
>=20
> ip link set up $IF
> ip addr add 192.168.0.2/24 dev $IF
> sleep 1
>=20
> iperf3 -c 192.168.0.1 -t 600 --logfile /dev/null & sleep 2
>=20
> while :; do
>         ip link set $PF vf 0 trust on
>         ip link set $PF vf 0 trust off
> done
> [root@host ~]# ./repro.sh
>=20
> Result:
> [ 2006.650969] iavf 0000:41:01.0: Failed to init adminq: -53 [ 2006.67566=
2] ice
> 0000:41:00.0: VF 0 is now trusted [ 2006.689997] iavf 0000:41:01.0: Reset=
 task
> did not complete, VF disabled [ 2006.696611] iavf 0000:41:01.0: failed to=
 allocate
> resources during reinit [ 2006.703209] ice 0000:41:00.0: VF 0 is now untr=
usted [
> 2006.737011] ice 0000:41:00.0: VF 0 is now trusted [ 2006.764536] ice
> 0000:41:00.0: VF 0 is now untrusted [ 2006.768919] BUG: kernel NULL point=
er
> dereference, address: 0000000000000b4a [ 2006.776358] #PF: supervisor rea=
d
> access in kernel mode [ 2006.781488] #PF: error_code(0x0000) - not-presen=
t
> page [ 2006.786620] PGD 0 P4D 0 [ 2006.789152] Oops: 0000 [#1] PREEMPT SM=
P
> NOPTI [ 2006.792903] ice 0000:41:00.0: VF 0 is now trusted [ 2006.793501]=
 CPU:
> 4 PID: 0 Comm: swapper/4 Kdump: loaded Not tainted 6.1.0-rc3+ #2 [
> 2006.805668] Hardware name: Abacus electric, s.r.o. - servis@abacus.cz Su=
per
> Server/H12SSW-iN, BIOS 2.4 04/13/2022 [ 2006.815915] RIP:
> 0010:iavf_xmit_frame_ring+0x96/0xf70 [iavf] [ 2006.821028] ice 0000:41:00=
.0:
> VF 0 is now untrusted [ 2006.821572] Code: 48 83 c1 04 48 c1 e1 04 48 01 =
f9 48
> 83 c0 10 6b 50 f8 55 c1 ea 14 45 8d 64 14 01 48 39 c8 75 eb 41 83 fc 07 0=
f 8f e9 08
> 00 00 <0f> b7 45 4a 0f b7 55 48 41 8d 74 24 05 31 c9 66 39 d0 0f 86 da 00=
 [
> 2006.845181] RSP: 0018:ffffb253004bc9e8 EFLAGS: 00010293 [ 2006.850397]
> RAX: ffff9d154de45b00 RBX: ffff9d15497d52e8 RCX: ffff9d154de45b00 [
> 2006.856327] ice 0000:41:00.0: VF 0 is now trusted [ 2006.857523] RDX:
> 0000000000000000 RSI: 00000000000005a8 RDI: ffff9d154de45ac0 [
> 2006.857525] RBP: 0000000000000b00 R08: ffff9d159cb010ac R09:
> 0000000000000001 [ 2006.857526] R10: ffff9d154de45940 R11:
> 0000000000000000 R12: 0000000000000002 [ 2006.883600] R13:
> ffff9d1770838dc0 R14: 0000000000000000 R15: ffffffffc07b8380 [ 2006.88584=
0]
> ice 0000:41:00.0: VF 0 is now untrusted [ 2006.890725] FS:
> 0000000000000000(0000) GS:ffff9d248e900000(0000) knlGS:0000000000000000
> [ 2006.890727] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [
> 2006.909419] CR2: 0000000000000b4a CR3: 0000000c39c10002 CR4:
> 0000000000770ee0 [ 2006.916543] PKRU: 55555554 [ 2006.918254] ice
> 0000:41:00.0: VF 0 is now trusted [ 2006.919248] Call Trace:
> [ 2006.919250]  <IRQ>
> [ 2006.919252]  dev_hard_start_xmit+0x9e/0x1f0 [ 2006.932587]
> sch_direct_xmit+0xa0/0x370 [ 2006.936424]  __dev_queue_xmit+0x7af/0xd00 [
> 2006.940429]  ip_finish_output2+0x26c/0x540 [ 2006.944519]
> ip_output+0x71/0x110 [ 2006.947831]  ? __ip_finish_output+0x2b0/0x2b0 [
> 2006.952180]  __ip_queue_xmit+0x16d/0x400 [ 2006.952721] ice 0000:41:00.0=
:
> VF 0 is now untrusted [ 2006.956098]  __tcp_transmit_skb+0xa96/0xbf0 [
> 2006.965148]  __tcp_retransmit_skb+0x174/0x860 [ 2006.969499]  ?
> cubictcp_cwnd_event+0x40/0x40 [ 2006.973769]
> tcp_retransmit_skb+0x14/0xb0 ...
>=20
> Fixes: aa626da947e9 ("iavf: Detach device during reset task")
> Cc: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Patryk Piotrowski <patryk.piotrowski@intel.com>
> Cc: SlawomirX Laba <slawomirx.laba@intel.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 5abcd66e7c7a..b66f8fa1d83b 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
