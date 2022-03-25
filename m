Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347E34E7129
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 11:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358847AbiCYK2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 06:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358862AbiCYK1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 06:27:55 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903D5A76C0;
        Fri, 25 Mar 2022 03:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648203981; x=1679739981;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1p8vDzFbrAPdzmFMSJwPu4WCuullQqcsUTqjD0M/dYo=;
  b=EMLVvsT3yc+JCC1Y3rvpE8vZdQtNbHSbbqGgHQcpUgq6RjDFBZ1xl9N3
   1a4NjRLphDYJATfbnb7T3JYmL+PCkXb+jlU1WQqMEbbRfUQeMsrqH73vO
   k2KwIq8bn4Qiq6crnaOMeXurAAVX7gsbo0PzdZ5cY4xWIVzv927heIG8o
   j3JUoNZ5Ye2nvtr6nYycE+aEIFCsa+zEZFGgXXSQuXSvokEaOzwAj0l09
   oYnHJWKXigzZEHYvBxMryz77/72N6VL0D5OjW7kSptBIvXChagbcGzWpm
   VKmeSACA2H6z6/AyLYVJs5FpeYdxQTqynkIxNpKxvMvjegDNY1WGdKO+R
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10296"; a="258572662"
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="258572662"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 03:26:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="825996703"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga005.fm.intel.com with ESMTP; 25 Mar 2022 03:26:20 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 25 Mar 2022 03:26:19 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 25 Mar 2022 03:26:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 25 Mar 2022 03:26:19 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Fri, 25 Mar 2022 03:26:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmkqVcQ0zFRnTd/L4wmfBh7oHJIOj8DytDHUBqI8qnml8rAWhRd7cSKJxxVX808izr99FHaQiE2MA4yiMardctd6ePJv0Di7uiuyoP9VoN5BDfo4BYWFwh5+JmbraiQMeoFR1WAZUianZJucc41389n2zf3HSlT9qMNmVcsvRBzKuX8eOFdZ0yOgbL5o1tBeFTWFRQP2FZiyA9tNty314crqAzE100n06IK7yNw3B6ICqyvs9qR7SRk/SILaBvIOeAIraOcIlL+v7kwSGtZYQx+hH7SePJMDyfilI2K8oQ44lytmO4jPbJbVgFT+tYbVHQzPcdxBAi99LzK0NfSE3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7plNfr9BQ+drCDETLy2PoL+fRrB8hCC5asLiSQcIhks=;
 b=b8n3hC9s/W2vvIfO64FIEdclnY+EUOSawHlVTRc+XkgFXvk0V4O6zwKcVLiaAfFLZRFHQkvQiIEjKjjPf9CJdQFejJNaMgnIAsbVMxVEffy0CWfWzJjvgqzYGcWln6VjQwoLkJDaW1TkAD8rK6dyAcPueyhk4oZTNIrIFGMoxuzcPXhJ6/IT6xf8qqOxHksx6jl7LpkgKTMiX04iI0WJO0uaQgYRod12WTOEvpBWMP+VSRZd19f3hBneDl1Wya7dsQJZ+0B96nPYEiHpOy2E7twVWH8l3DUEan2mg5LNHTW8h7MNRCWxyOKyeLordSXU/HvpVrmsTZkgrqmFb+hh+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by CY4PR11MB1624.namprd11.prod.outlook.com (2603:10b6:910:8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Fri, 25 Mar
 2022 10:26:18 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::55b3:8a73:16bc:77df]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::55b3:8a73:16bc:77df%7]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 10:26:18 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Szapar-Mudlaw, Martyna" <martyna.szapar-mudlaw@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH v4 net-next 5/5] ice: switch: convert
 packet template match code to rodata
Thread-Topic: [Intel-wired-lan] [PATCH v4 net-next 5/5] ice: switch: convert
 packet template match code to rodata
Thread-Index: AQHYPRMl/sWynVnOtUyZmikxQe9Ii6zP6z+A
Date:   Fri, 25 Mar 2022 10:26:18 +0000
Message-ID: <MW3PR11MB45541D2B0B26CD592841A33F9C1A9@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20220321105954.843154-1-alexandr.lobakin@intel.com>
 <20220321105954.843154-6-alexandr.lobakin@intel.com>
In-Reply-To: <20220321105954.843154-6-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0f4a36f-2c53-42ec-ca11-08da0e49e60c
x-ms-traffictypediagnostic: CY4PR11MB1624:EE_
x-microsoft-antispam-prvs: <CY4PR11MB16247E8507584E33E26105D19C1A9@CY4PR11MB1624.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lJaxTcbv4DsVZF1n3vOezeo6MEEu3389inNMLM4By6acj5bXDxnzMANZhK95iZao6tl4qJZ3XPabDv4+F7nUKKY4p72lmaIu+CbOmXzkCQBrtpNFlKKTQJp2V6IZ+h+G0NonsojFVwXEr2B07zktWWc2cc2iRbhMF3Az28W+aFkxwv5Wh4d/fd8vYGWPsSiN9v4TCU2a5fhkrbx4JKVfY6x6jClV6yWIUKL0HWLDSAnIEzze1PJiBJyj9srG/hNw1tKvyDolGcG8ZUKNJowts1EiF6Ax5IxJAgthFj7sF93+xX7i1bKrRZ031uAq8mnrnu3+NvNrqXccrxP/D26Zn/9yiwK3Qd4WVElY7qt6IfjzsrrJGk9CviPPVydoJ13bbNbRrxCU8lcl7huEdEFwbVSnHxag0SM/pmM5sOtv+edrCOCKtqQlyz9w4r/vhSpnG3OpwviG5ZAMQYODTRgRU/Z0bIkElHWfjJJ1FrFrxn8YyohX2qKCu40Iio+/bDjYAavQns+LzsWwd07tIPTF6+XMjWZil1j03n7OeRguP4K2eNXNEdNtxxeBZXS35Il9NNQIwMV+AFqoKxgUZD71sK/ficUEzWfO5i5acMcULl+Fbm81hXYykAUqq2BPaGoj0eLLgULq12RZw1qz2tc2taCrTWbeJxEsaDRzsKhtL1WUC/iBOdZb5otH3WhnDHeOgiw66KBXli12Y7ydut4QIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(66946007)(83380400001)(66556008)(38070700005)(71200400001)(64756008)(4326008)(8676002)(66476007)(86362001)(66446008)(110136005)(33656002)(55016003)(54906003)(316002)(52536014)(508600001)(5660300002)(8936002)(38100700002)(82960400001)(122000001)(2906002)(26005)(186003)(7696005)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/i/nnIgbKpjm00pAShExNSBpL603eeER/aS7cP5+S4OY7MAF7TaxFnEJiizY?=
 =?us-ascii?Q?4eGTp/xRY0iB/OTXsGBytNLQRjEW4VtowDbasylVeagQOpXpAqjiTHVAz6qo?=
 =?us-ascii?Q?/TZmn/a0ditksL4JHk+rdTmLk92LvBCWf26QV8t6PGD5HX1uj1TzhfXe8kqy?=
 =?us-ascii?Q?mwWRQ9Lw8Z5dIsHaXbZV5uFm5Qn6sH5n4Ba8Mc+nO1NIxeICr1ir4r+RCrkk?=
 =?us-ascii?Q?IK2iaPYvnF23uX2U7eSgbySnpA2ugVg47a9yWy4Hil8+ThIRNp0Y6C+j72BE?=
 =?us-ascii?Q?tFbYWytOQqP7g1iWGnegFvOaAZClo2mFdHRSGgRdTr1fSGHe2ihm2ujGOJ2q?=
 =?us-ascii?Q?gw5s3hr2oZwADHzSRmdkpPubT5iFiMEdRIg/bCDW9EbuJy5RCjCkOVZe5gXx?=
 =?us-ascii?Q?ciM5Lwbggb2Jl80G6VkomnO8wrUBIUD2Gf8VooytvxMFXDQ3p3O0xSgh7Bk7?=
 =?us-ascii?Q?10kfgudDaXPLsSfrUJGMYy69+oGJFojcKPsHCQSfpUs9oSOPZ44Ty6tCHmKQ?=
 =?us-ascii?Q?cDP4Kq1+ABxzau55Hg8KtFPMAOlz6RhtfSSbfesoKta+XARU2pbdeHLidg7l?=
 =?us-ascii?Q?GsHEa05JxFcl5h6Rh+GKLrjY8jglCmIVCGsKOxefe7xNE+xbBisBj5Fg2MF+?=
 =?us-ascii?Q?SLd//FNRCEZWaf1Os16LKb9D2cgFMjVEaHTKHeguCgT+KS4+ki+R/wAgtpkQ?=
 =?us-ascii?Q?Xa2Bdh0VxRGZzW9V8n3bh6bnEjsGC5JghVGtqUgA/Q3GD0bMws60SBHxvhcR?=
 =?us-ascii?Q?r0mALtgdLrx/XgkRKGi8Z6IBEYNTykytgPtAhOYAZhN5kXmaUbLrv6+qLQWA?=
 =?us-ascii?Q?P4LmD5DqkDay6EhxEHP2oHEcgqZmY+wY/f+FESi28taKgotNKcyRMwCBWhhU?=
 =?us-ascii?Q?dgU97KX5nih/DS8iDUueKOrxCxITzzEJKD5sPN2qoQU5uvJGREz/xpsgThvt?=
 =?us-ascii?Q?SAITuluN+zerhcTual7pCr8+iLACwQHaAQQytm8nOjOI92GN0daUqF3onNhP?=
 =?us-ascii?Q?QJvr0NR9+R+sUaUfXJBei2NEmpuOelw7Ss3wtna8UvyDVI/Yi+loYYRHsDLN?=
 =?us-ascii?Q?Xsz/6KYoepXL4Oi/bvgzNtsaO5iTXkQYcAPEcjQtqnQKt5Cd7bNYy61pDlNX?=
 =?us-ascii?Q?H2DylpJwXgFxLBIDGOVoGu24GZsASZCCEP9gBTqf3ubBoHtC46epnsZJlDWz?=
 =?us-ascii?Q?ftLxOooAo6mY0ReYt+ZNMSsW1xMLo+BhC2BASujx6fu2xJ6iJGOW4eqt/5yA?=
 =?us-ascii?Q?QUN01Lgeyo405u2csyID5+JsMb7/X/TsGR4xBYu3DGdoT7aSd6Tra1xS9vJW?=
 =?us-ascii?Q?bQfeozvtF1cuAQwZr577cjwW7u0rcgurw42QcR7pyNgQM55WcpEvUAdnhscM?=
 =?us-ascii?Q?pC4bgVBulRWN858+iYWsfWHi5d2hCouOq1YfSG0uKzb782wDvAwSey97sxPr?=
 =?us-ascii?Q?w84DSvHo6YHyfxAnz1SDguMDERlGIQlGKrmC4Mq9i0PBB4HgTUrCKm3bmd9W?=
 =?us-ascii?Q?MTiRSwAi0IH/y1q3R8yr0gKWhMtyLlyePUzufSJScHSOVOcQ2Boo94MkTgPS?=
 =?us-ascii?Q?+Qc6OUWCbboMziSBaegQlclGShuj76tROQaxY8bskdj6r5+YhkDg6t7hDl8i?=
 =?us-ascii?Q?v0aJxy95g6RKkHy4jdE86BwZmfiV+NbwuUAm/rLwHtFRU3QSd1R09ArIJyLr?=
 =?us-ascii?Q?ht9ZO08J4XmgPF9Ts6GepWlueC3XQKMSrzHo4jI5sgoiCPQBjNLuPRNXsCtq?=
 =?us-ascii?Q?gMBs8dDsbWHiDNo02JeiiUGKx28khuw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0f4a36f-2c53-42ec-ca11-08da0e49e60c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2022 10:26:18.0252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8nBwsHc6uYO43cjVe8SZowwsmyFz55BWyLl9FYhdmMrfUVHDCsktrcRuDjNA7SHQzPxvd1DeKK9gHdnagv7h4hwyhIfIDLwQKkjnj2lablE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1624
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Alexander Lobakin
>Sent: Monday, March 21, 2022 4:30 PM
>To: intel-wired-lan@lists.osuosl.org
>Cc: Szapar-Mudlaw, Martyna <martyna.szapar-mudlaw@intel.com>;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jakub Kicinski
><kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S. Miller
><davem@davemloft.net>
>Subject: [Intel-wired-lan] [PATCH v4 net-next 5/5] ice: switch: convert pa=
cket
>template match code to rodata
>
>Trade text size for rodata size and replace tons of nested if-elses to the=
 const
>mask match based structs. The almost entire
>ice_find_dummy_packet() now becomes just one plain while-increment loop.
>The order in ice_dummy_pkt_profiles[] should be same with the if-elses ord=
er
>previously, as masks become less and less strict through the array to foll=
ow
>the original code flow.
>Apart from removing 80 locs of 4-level if-elses, it brings a solid text si=
ze
>optimization:
>
>add/remove: 0/1 grow/shrink: 1/1 up/down: 2/-1058 (-1056)
>Function                                     old     new   delta
>ice_fill_adv_dummy_packet                    289     291      +2
>ice_adv_add_update_vsi_list                  201       -    -201
>ice_add_adv_rule                            2950    2093    -857
>Total: Before=3D414512, After=3D413456, chg -0.25%
>add/remove: 53/52 grow/shrink: 0/0 up/down: 4660/-3988 (672)
>RO Data                                      old     new   delta
>ice_dummy_pkt_profiles                         -     672    +672
>Total: Before=3D37895, After=3D38567, chg +1.77%
>
>Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>Tested-by: Marcin Szycik <marcin.szycik@linux.intel.com>
>---
> drivers/net/ethernet/intel/ice/ice_switch.c | 215 ++++++++++----------
> 1 file changed, 108 insertions(+), 107 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
