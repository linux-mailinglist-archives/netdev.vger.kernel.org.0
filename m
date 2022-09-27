Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DB15EC4C8
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbiI0Nng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiI0Nnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:43:31 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C3BE3ECA;
        Tue, 27 Sep 2022 06:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664286209; x=1695822209;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=45T6hhQvQ7vJAJT5HtsAkkeFvOgWuFYpInNvWjQFi60=;
  b=AoHl01tucINvK0iWHNojNo5bxgfV4MrOMyVXN/R+kPlBWEsF/NkqyyL9
   eljNMTEllYADB4Z6NpP1XQlA0NyFWv4MLkAE6qdsUSX4W1qkoExloGOAJ
   QWNTD9M7dzCmv/wn5Y6jlLxhKDm6tQS7+907Vg8I78AiCfk+NvbxP/M1/
   Tb+SUuRnLoXs9ZTPLP5/Masj4jGvv2pxwdEwnMMSkmy9esx2wXCIw/OOP
   hxTKMCIB0w0RNdxd49tLBatCYhUoA7P9dkbgD1gpfY3Mmhn2I5YGpV6ER
   lz0GPlIkBUavaLd1THp1R1sxTxyWd+8TRPI5nx5oCR3zlEmiNImfEMD9y
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="302229579"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="302229579"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 06:43:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="763880949"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="763880949"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 27 Sep 2022 06:43:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 06:43:26 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 06:43:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 27 Sep 2022 06:43:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 27 Sep 2022 06:43:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W23JBG0fJcpx8STqCmyyDVXx2a1Zq95UeXZ4pgLH8t8vT98eNHqmvKl3+CkSd70Ljdn2oxV42BDkKhzYN79DDUOXFndl9w/gnoz2X5T7NfxaVtHYriKd0RCNkD1jA9PeM00z28ToucNcH/A3S+v0u0c1q09iRArusQO0JdAUommQffKQqA5Lhh4Uer319B5NJLOE62F0AMzmP6Sw76mfzzZHTgg7w52BfhFmdt8syBCk35IJFhlBrfEOWrhIN1bD94aL5mbhtBrzA0nOWLsaM5gZZuNiD8heUw1V0gEHJ373OFByOcfOMLQGCjCx85H6aDxY7HFMqLRsmr3sjvxT3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=se5rrGP6mp2CKI9jOPZ1FZdebuD0puY6hu/vNAhcMOc=;
 b=OcT+n5jp48bnTlF09HMqM3hozIDwdWBuITe2edAJXKd5rvRowJc6yYqhVSHNf+XMAFlEFCMAa++VmvennTI4z+J3hU8YeK6+ULCLFpv7zHmbxumzJ/kbFHroWA7fYNHnjtcyExU6NcECYpneMHHmiqBRSXMV8QBLTrmPh0q5ULqi083dzRPmAmUm6EXxhmdKGJOpGsuve4m2j9YPRcCfeHMy9SAJ0uWBogUOtLF9xYT/yH3HBeZ+OAk+uxhjg4T9iBjvVNpNjaSdzKocFymnhc4b1jzmTHk3OL2zOh2MjJJY6wkwOUZaS01e0wCU/WdgHIyokwtyvViXqoigEQhXEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by IA0PR11MB7281.namprd11.prod.outlook.com (2603:10b6:208:43b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 13:43:23 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::c70d:ba8e:c2da:e24e]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::c70d:ba8e:c2da:e24e%7]) with mapi id 15.20.5676.015; Tue, 27 Sep 2022
 13:43:22 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Shane Parslow <shaneparslow808@gmail.com>
CC:     linuxwwan <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control channel
 mapping
Thread-Topic: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control channel
 mapping
Thread-Index: AQHY0V2Jt/u5ekZbl0uD3uGkntVHJa3zEKgA
Date:   Tue, 27 Sep 2022 13:43:22 +0000
Message-ID: <SJ0PR11MB5008658CADCDADE43C6B0D5BD7559@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20220926040524.4017-1-shaneparslow808@gmail.com>
In-Reply-To: <20220926040524.4017-1-shaneparslow808@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5008:EE_|IA0PR11MB7281:EE_
x-ms-office365-filtering-correlation-id: 35ca5a57-6404-43a4-ec22-08daa08e3ea1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ezFGA1dAPNj+nWV4fdiHZFAQbFP5qoZTiWyqwGAajMymIlWU8PKypWIBOt5nsrfPAbyPrYy78vLEUQdHFCVMf9swC6+egZrG1Wk+xliHz5wkpso2+ANBrdZ/YD4etwXWX2Zhd3m+URbBnaHV9m7x5McTJ0uY7Hs+zIgE+L4msx6k0Gw/eNQVgZuPB8JnqAojmpf6r93EXOPTlQe/IWH0PdX/ij9W0cpKTMtLKzG5muuATqDA10k67bzAkQDQKCKPzqwn1nSerDE9MWF4QKaRLEiTT3IIcowMzetTfmR5/NSQTc2f+hBMEP+kh5k7CGxqFyeu7xnK9uEygNBij1pMSLylZRj74lwvv6SMzwvq39Ex6Z4EUzOnzvwAXLRpAIm4Uku+FvVdVHRp2z4FeA3f5F4PLFHSk3x1lriWqZo4d45/Xkqo0vo36nRmy2SGGLgn7dXxA9zkuix+nJs+6JQsxCrjre9L0ad7A7GVyPVW+iexWw3MsnGZNwlgCF9Lk6EkIYcbGJdi6Ya7vVNt4U0wIbqVIqoTFJku5BGXqjvwazoIaBUHC+mNYo5R2l2xR+6y2/Ev0kMm5Rkwlv0HuObcEbvFmkf471oO0K7+RT8Lti3jY2fpKhD87sQ2kDUT3zrAuVTc//nYkZOAMIoKvI2KDrht2Bg5+g5LrkvuS2OH0nxJ+9VylrgenAFyL1RR/V/PwRbkrUspz0s8qMlLcGxVXdrt8M88TL6a906fNftyvY2GA+Coo3ZGxF7Zos1785BwKm0VL9fm0gvKP4ot4cjKKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(366004)(376002)(396003)(451199015)(54906003)(33656002)(6916009)(316002)(86362001)(9686003)(7416002)(122000001)(83380400001)(186003)(82960400001)(38100700002)(2906002)(53546011)(26005)(6506007)(7696005)(71200400001)(66556008)(76116006)(66476007)(66446008)(64756008)(8676002)(52536014)(4326008)(66946007)(478600001)(8936002)(38070700005)(5660300002)(41300700001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q1tFZIPGmmcejUs5GeO795T0HEHAuU9KGZiWslYtVuqsobb0i0BhcsMY7E0d?=
 =?us-ascii?Q?zPVjkL3mhysDMpdSl/V4KVLypBgeeDMQTTNoWSsCvdfFrvGazYOVRGIIPB9L?=
 =?us-ascii?Q?Mg4oOYnOjEOz1WsUF3LrFnZjhSKa5lOrwomlInSScnprMoUUC30fkvT5KMl8?=
 =?us-ascii?Q?QQqDROyiwffToUjll/X4F18YEO/ka71HfJwJDrqyozN9cB7wRmHaeen1mFlR?=
 =?us-ascii?Q?L8MdMBsZmwY6X0Z/5NQ8FAwAUXomY5ieLzYekUgrz2928UI7IpwM5Ds+c+WY?=
 =?us-ascii?Q?AUUnM0VblINc6kk3gjPQdG/Zq6wS8jj5fIdhhkLsDGWbHbbG6ZVPZ2xWvqvB?=
 =?us-ascii?Q?k6Gij5erk95QKy6iaYr1CwFghKoKmYbqYksxSV0AXjT0rIv+vKCzPEpxx7lN?=
 =?us-ascii?Q?EDsIH7Tkr6o5uh37/8Lxrm4Nt6JZEspFC4bMV34up3MRuIllLa+M9m2k6uRh?=
 =?us-ascii?Q?XENcdhq76MINLgLCW3YNOkQfKhAXSVuGh1WiUbouy9bwaYvIfINsp2zPXuA1?=
 =?us-ascii?Q?lPx7lJNlwSJTBmcECckt3NGr4J37WxiYwDFnc/uol2Lghed0+ahX43+VUh83?=
 =?us-ascii?Q?lqsJ72yDePsMAlqbfwx2J8Yg5dvPHPpFElspDVdswngDr3JC5m8pTAma44Tv?=
 =?us-ascii?Q?6h8t+Q/8MpMClbWg7bW6T841yQtC5zyb5fs5Vu2MGxePP9Q49VNzhdqG32s+?=
 =?us-ascii?Q?wwFFnieNXKnwpEb3c4ms/0EwZBOSWfXx7EXx5Yu2cZAJkE09lqETSdDEI0gT?=
 =?us-ascii?Q?VysD22AO7aXIbQb+NbxcC+yExZ46BHXYIUrfN1Necb9GuOPY0iq8KBONIhud?=
 =?us-ascii?Q?LKA4DzSGZWKT+89/eEG94PSS2aPWardEpEdK5ctx0E7XLT0UXRYNULD4YDJL?=
 =?us-ascii?Q?EmVS+LNAD+PYZUM53ozjXJUmMdENWRrk4nUqMHjAIKW/ERT01GADZJ4OAixW?=
 =?us-ascii?Q?JDScR2pcL2fEWLm3mAf0545/4/OdcZ33JOEIcXZQjlrlTkqhXoK3WQyIZDuI?=
 =?us-ascii?Q?3CNnj9eZSJDioIF5kSenJpZQbR4iy8iU4QY/DIhSp5COIuW8DVigBWPLCsxK?=
 =?us-ascii?Q?adzsyw36ub1lQfcMhJt8zqRumHZyr7AQzhSE5z19xVD/VtonH6MWnRJ8H1ph?=
 =?us-ascii?Q?8ky0uoehr8Rs2G1k219uD3iQreMDpx/eKgvELwVurOewMLapGBxfo8jku/AC?=
 =?us-ascii?Q?g9Vvq6JtKotOat9rNO/MzMWzOR1TWKcVsCiEcm5tijiEmozVoXjXEInusFyQ?=
 =?us-ascii?Q?S2Zw6vUtdHa/pJbKHcItH/xzo7VYw8TEhA9GxkFbMJCaRt5uXybg00J2bWtR?=
 =?us-ascii?Q?R7+H67/eQjrutyykbqrSuWqBajicdsKXbzKbWDZubKZh7gbNrNKmdLyNmlFw?=
 =?us-ascii?Q?iTRetm6QS/JcssCzs2Kb1aBFPWbxf2NkUEJtDW6DaINm0jy3HRsDlPkWnMHM?=
 =?us-ascii?Q?vgcmYAN77YCell78dgueq5LXPxf3QHHIEAEuh/xgzGQvv02bcpX07yAc5ZZI?=
 =?us-ascii?Q?XQjsadD9yR0JJqJtljaE9gWYpt+utU2C98Ftsm6X842J9TU+10iLktH+UgaI?=
 =?us-ascii?Q?edyGjWq0XL67t+TMTfidz0XvrgisGOKue1tgQHKh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ca5a57-6404-43a4-ec22-08daa08e3ea1
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 13:43:22.2632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XbXYVRH12mECW12ptrdVN4FNwH3mYkB1Tzr796GtnxZ9ULBLNIGxzHCNoB/hmwCfnvGh8QJN36oL8o1uUQt9U98BbZKm++Zas40tJ09gOJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7281
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Shane Parslow <shaneparslow808@gmail.com>
> Sent: Monday, September 26, 2022 9:35 AM
> To: shaneparslow808@gmail.com
> Cc: Kumar, M Chetan <m.chetan.kumar@intel.com>; linuxwwan
> <linuxwwan@intel.com>; Loic Poulain <loic.poulain@linaro.org>; Sergey
> Ryazanov <ryazanov.s.a@gmail.com>; Johannes Berg
> <johannes@sipsolutions.net>; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control channel
> mapping
>=20
> This patch fixes the control channel mapping for the 7360, which was
> previously the same as the 7560.
>=20
> As shown by the reverse engineering efforts of James Wah [1], the layout =
of
> channels on the 7360 is actually somewhat different from that of the 7560=
.
>=20
> A new ipc_chnl_cfg is added specifically for the 7360. The new config
> updates channel 7 to be an AT port and removes the mbim interface, as it
> does not exist on the 7360. The config is otherwise left the same as the
> 7560. ipc_chnl_cfg_get is updated to switch between the two configs.
> In ipc_imem, a special case for the mbim port is removed as it no longer
> exists in the 7360 ipc_chnl_cfg.
>=20
> As a result of this, the second userspace AT port now functions whereas
> previously it was routed to the trace channel. Modem crashes ("confused
> phase", "msg timeout", "PORT open refused") resulting from garbage being
> sent to the modem are also fixed.

Trace channel is mapped to 3rd entry.

/* Trace */
{ IPC_MEM_CTRL_CHL_ID_3, IPC_MEM_PIPE_6, IPC_MEM_PIPE_7,
  IPC_MEM_TDS_TRC, IPC_MEM_TDS_TRC, IPC_MEM_MAX_DL_TRC_BUF_SIZE,
  WWAN_PORT_UNKNOWN },

I cross checked by running AT test on 7360. Both ports are functional as ex=
pected.
We should be able to send or receive AT commands with existing below config=
.=20

/* IAT0 */
{ IPC_MEM_CTRL_CHL_ID_2, IPC_MEM_PIPE_4, IPC_MEM_PIPE_5,
  IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
  WWAN_PORT_AT },  -----------> wwan0at0

/* IAT1 */
{ IPC_MEM_CTRL_CHL_ID_4, IPC_MEM_PIPE_8, IPC_MEM_PIPE_9,
  IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
  WWAN_PORT_AT }, ------------> wwan0at1

Does this second AT port (wwan0at1) goes bad at some point or is always not=
 functional/modem
crashes sooner we issue AT command ?

Could you please help to check the modem fw details by running below comman=
d.
at+xgendata
