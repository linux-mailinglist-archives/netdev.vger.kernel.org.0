Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B859954B406
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 16:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356461AbiFNO66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 10:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355960AbiFNO6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 10:58:46 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B7B24095;
        Tue, 14 Jun 2022 07:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655218725; x=1686754725;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TDDLft0Kr21TuJWNrWdXdVBr+lUd7ZSR+CUPhZkxCmQ=;
  b=OMtYmqmIimtMAf1nAmPILiVyUzBDMmnM7p+O+o2Kuxa5eQQAq18FFeGd
   LMFxNfkgTV9ELvYu8d3/qliIVU3VZ/nxl5EPIjCGUFVEGjF1lxTILNZ7W
   msGj+7LAedTIqvcmcg6XkDoXlyyUtyWkdFLruRA24ispm0vjwiPK6nU7b
   ApsbXwVQ9s5qQn5Uh2qHO8fC8xf8R/Anx4IjhXJwXBld9Iy5XcG+knxK+
   qvK3jHkTR8yECY8M6GsiEsd5uNihgeHyDTSzD6AS6N5kJtHPBVXBGUQU/
   mZwrPsrMrlxSZbXeRcwGRSfacYrEI20IKAP6Q7x12/bkwq+TzSF/v917w
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="342604129"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="342604129"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 07:58:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="673934190"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Jun 2022 07:58:41 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 14 Jun 2022 07:58:40 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 14 Jun 2022 07:58:40 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 14 Jun 2022 07:58:40 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 14 Jun 2022 07:58:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQQztBZTFGuogOyVQ16YyIircoD7/PjJCCP8GSt44w/poesPmfdzY+VAoOFTESOmrb8Po9WrtpKqVPPJlpgsYAxTSBQzaoxMCHWz0CjHSqExphHLoLqiaEIaF0vG3KgsViWEI3I2Q9SI6TivL9yjHdAh/GmtXjG/cC1N6dokwufafKO+yMqavttTh+hyQ0C/wxKWwui9f69GEeQCSzeZ4E0xHsoFxp+LVG3zN5UHIb8JEY64eNo1CiERTmW8pa6DlFahlXlaoWch+tVSBDqDIjHfjBIKsYA/YW4i/zRKA1+B08W3gYTy+3bJEDEsGs1kDn5fRSE/ZFrN3mY1VjYUMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dNnCTtIBgn4SOE4bAxUPyYnk0mdQsCxDR6qNss0qL30=;
 b=BgCDY7HJQBr/y6TrpFncpXc2cxU/JcdXCGRpHRuo4y+7zREKDIBV7ZPcb003YTD9Q+AnrgyP9BAso2P7+NNMsZe4TZ+bcdC6sgX7qpUBvfi8PQ7HYrVfNz0MLLU+1wKI/owGDkRAij9OGna4lJoiO/j0pPvK0YY3JxwQOVIo2c68e49gjvdsLvEFdsX6xI2hy2JNu2NUyApU5uP9HFlEMYaEwfds4Vte20B8h0Z7jPN+tHTbcLg8bmW/m1AQlOHzI/ibm4e41mGdrQBgJSWbwdvDApCBBlnSXBrbJa6ycDTUneq3qnXs1yx8H4zErW8VfR4XdvVjCv1OmsWpKfurFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by SN6PR11MB2733.namprd11.prod.outlook.com (2603:10b6:805:58::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Tue, 14 Jun
 2022 14:58:37 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7%6]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 14:58:37 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     "Palczewski, Mateusz" <mateusz.palczewski@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH 2/2] igb: Make DMA faster when CPU is
 active on the PCIe link
Thread-Topic: [Intel-wired-lan] [PATCH 2/2] igb: Make DMA faster when CPU is
 active on the PCIe link
Thread-Index: AQHYZTLH7O+WKabN8Uu7HR6cpzcw5q0ZoKEAgADsjACADI/HgIAINwYAgB/fwBA=
Date:   Tue, 14 Jun 2022 14:58:36 +0000
Message-ID: <BYAPR11MB3367F52AD1B994757C91DC64FCAA9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220511122806.2146847-1-kai.heng.feng@canonical.com>
 <20220511122806.2146847-2-kai.heng.feng@canonical.com>
 <6246d753-00cb-b5dc-f5fc-d041a8e78718@molgen.mpg.de>
 <CAAd53p52gkv-PLRvEM3GunTwU1J=c+n0J6uD03AQJ4EnL2y4Kg@mail.gmail.com>
 <CAAd53p4h1-SJROvUghPYbBnh2Z9nRtgfNEagE4X6XtBwNg8JOg@mail.gmail.com>
 <BL1PR11MB528839B81758CFBF18B9452E87D69@BL1PR11MB5288.namprd11.prod.outlook.com>
In-Reply-To: <BL1PR11MB528839B81758CFBF18B9452E87D69@BL1PR11MB5288.namprd11.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82d0023b-dfe8-4aeb-7cea-08da4e165c45
x-ms-traffictypediagnostic: SN6PR11MB2733:EE_
x-microsoft-antispam-prvs: <SN6PR11MB27339778AF76DF367214332BFCAA9@SN6PR11MB2733.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D8WTonjWCSIpEFOkYn8sE7348N+bd1Jt5kF9DubmWsmMwjaOG+SWTOHBPntC0EmIY052hHbjXbb6QEGmy+z5cPCbFpsYYSGFW6HhxZljUMF7ildIPRD42jglR9PdUM13H8HOVIFdIReG9qA6O2nDbKR6v0biar0tU7sFwOlKq+lhJ+tZ9pYjw9EIYbdniH9JMSne6nRdsgMIlhdZwxVaJ/saWjKTCTVk7GK4V3azioSSpYqHSap4AuOjuc3YGDhHOL6/Nk6Fss82eltiedmprOAE5FyVsqLnz7IxKHAg3z1cwC2/k0zZxSpz60uzw7YSdSg8p8HN95q6fjdGE8OAtSBZOay60BuzDXSXgZfTKXd/w4LwKTmcsaF4PRg3vuLtIYq90maLPrcQKfp5eUrHc1i/0uNWomKIR2O/MpNlRhPMW0Grzb1vjKaTEf78ROgAmut7Uw/t55uTWMHzTXloGnRN4pO2ASAPIa2mepqXHMw0aK0IrtLGujeRezAboEx+u5o9rmUvEOgNJx/W1Hh6m6HSbo8/Clebdr6zuAh2Dv4uYippp9/C8190puPHdbisSi/9l01suZ6lNw449EFbBQiR8xc8RRxz5HiYQoRWbhJctrpogDOhn7xot0m/qhZ/SDbAXQWlRvs/h+c7RkUyBAj9vCvHJeKafjw3u/9NlHI0nNm9ChGBId1zQmgli/KbT5/1uwVq9BY49KuiHJQKqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(186003)(83380400001)(82960400001)(55016003)(122000001)(38070700005)(6506007)(7696005)(38100700002)(66556008)(53546011)(26005)(66446008)(64756008)(54906003)(9686003)(71200400001)(110136005)(4744005)(508600001)(316002)(2906002)(66946007)(76116006)(5660300002)(66476007)(86362001)(4326008)(8936002)(8676002)(33656002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?afXfclulAKGefSY2z4EeIVB/vd4Bf9qyaXjGFjXzFNFPJB+b+nWC07zqu832?=
 =?us-ascii?Q?G6s/BCmpG4X9h85gFHI/DPWtupYK+wEI4M8fVjuVNcHUNBp0FkA6S6cX5fV4?=
 =?us-ascii?Q?hZjLJBh6xgWP5RVCXYCjqXKy13pR7/Bbch/Eoupz5KjcpS9WvojOYJN0Tw9W?=
 =?us-ascii?Q?EvDZ60oDhsAiq7KwdhypFxlI5w6GfbsbCdkFhmezfe8kl+LP6xIemjJvBjYL?=
 =?us-ascii?Q?eD9Ro2HNHpDoRE1Qyz1RWz02kjYpC3lXRrrWLgNPIH5biFQ8BhjqCCEC3Zsj?=
 =?us-ascii?Q?naiQyNYgvJvU22y922d1hQjtfJWuhU7DjAtQD+teYavHDwykoOEzXsIkyA2B?=
 =?us-ascii?Q?MHfq5oyBugcgY33FGiU0CjnBpCzQHr9OMJ25U1eX9Yg/Kx731ep8w512OJZy?=
 =?us-ascii?Q?U9DLbesziySZmsu0T4q6FJtlEZMKAuTQejyr57et8ONufTZiE3l2I6YwiN+R?=
 =?us-ascii?Q?ScfkWiZdM8tuA1+rOfuUgTCQV82R/OLQzps8HlVjqYEDT4JbxZ9wAX5X92cS?=
 =?us-ascii?Q?xJG+FbUdvabdjwgWG/sjUTDvRLoA4mzt2jODeFy+geVqBFx0Y3jubSylinXS?=
 =?us-ascii?Q?FEYsopiO+6g/XvnecjiLTZBlG4+sfuZunzmiwRzyJlRM20iyQzMQyWs/bUQr?=
 =?us-ascii?Q?rHXLU9gG9GGneBlXR8fJMEm05Z+N/Oz2Ah/Ekh4XALJCEtFNyTJq8xZ6swRl?=
 =?us-ascii?Q?sicwS1TdcR3IKbMvQsLYMd5RR7jGyzuMd9+Ovs7koOW2BXnryKf9g5cxsV2+?=
 =?us-ascii?Q?HWY71HKb8L137yarNyUL7OzBCdE/s1hlfqEZK/aFu/O75rdBSuDA6bXJtBFs?=
 =?us-ascii?Q?vwnzXjJFhCTxs0zYAtNMqlB9hySNOaevytJsrKDP/tKufp5de+aTu9/DP81V?=
 =?us-ascii?Q?TZMEYz65zcitxyLzyJl2ex7bzo16LZbjvSklCBIqxE1RentY7/jZkHKHVqBy?=
 =?us-ascii?Q?S2MtCXI15eEXbkKuM4LA9Dv49NchgqH+Lul2qYYoFtokdhORBxe0A2ybN05r?=
 =?us-ascii?Q?PhmxeDbdXzKvqEhifnpCP4iSspFKdhw5fdkywuZAv4Mjh4i8QuiKIfbPw+wf?=
 =?us-ascii?Q?I46477tG1lhbOcbXfpR1pLQbC+5x+dwlO9vrkz7XGwWB+kTtvO8/U+E37I+S?=
 =?us-ascii?Q?v3IhRbZKuiosk9v3cQtw6VVFR4iB/JxWttXG8uEsz0Fjf+3NTrWoRlFvPqpq?=
 =?us-ascii?Q?x7tQjwbjvwfEfqe9XiYv4qWCgQvs9B1cR/QTvM+jL8rrfIGome2eig2XwkT8?=
 =?us-ascii?Q?K2v+qgSR/ETVfU2drgQwKO7HrbIiNm5LMjNAM9u8ECRRo38UhNXNvo5TOryf?=
 =?us-ascii?Q?iaZfr7OFKa3EviP2VXe78e8REMHEZmY04fzVtkhJnLOd/4qBcUMX/vVfhzCQ?=
 =?us-ascii?Q?XXlSyRP5AYQ2ts5IPIY0S9Sc7RQTFAV6rZWoJC2X4YupsHCCSNMGI2Xxi+/p?=
 =?us-ascii?Q?pKB/MI91f0ZNXqBVlpngd/JKn8QOCjLdAg6qpmq3QUL6Mk/VRrvuv/RFAY0N?=
 =?us-ascii?Q?AoRPXZWEe/UyBypxk0fvIwoaNKPnQ0qWMRi1Fsqlp3HIyVPlkgvmifoIc6tA?=
 =?us-ascii?Q?+vlgrjtfWPvG9GBctjLw9/jDqhSdI/8esyuKYR9rA8BEduUGVnHSXbj0EIjw?=
 =?us-ascii?Q?SsyQEXq/JNnRCaYfDGWECWvHNOyCVuJdJuAyGIjTWIQ9oSGZ9rBPKb9lLCOb?=
 =?us-ascii?Q?fnQg/BYDucoJ9h57Nq2a+PcYLN3W1rN5pe+IIHB0utPhTA83uBnb/d2ME2vB?=
 =?us-ascii?Q?ZdxDgEc22A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82d0023b-dfe8-4aeb-7cea-08da4e165c45
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 14:58:37.0338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0+HsAlzNO55THROwTLYlDZa5JLvDsVH86xyFJ2d711VD23XQkFG+QGHmBYTqerK+T9l/xKD6RXXdBdOfOSK+Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2733
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Palczewski, Mateusz
> Sent: Wednesday, May 25, 2022 1:43 PM
> To: Kai-Heng Feng <kai.heng.feng@canonical.com>; Paul Menzel
> <pmenzel@molgen.mpg.de>; intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; David S. Miller <davem@davemloft.net>
> Subject: Re: [Intel-wired-lan] [PATCH 2/2] igb: Make DMA faster when CPU =
is
> active on the PCIe link
>=20
>   drivers/net/ethernet/intel/igb/igb_main.c | 12 +++++-------
>   1 file changed, 5 insertions(+), 7 deletions(-)
>

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)


