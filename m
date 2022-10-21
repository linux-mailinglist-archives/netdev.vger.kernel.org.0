Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891D760792D
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiJUOFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiJUOE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:04:57 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D9F4E61C
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 07:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666361093; x=1697897093;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OGf9ebJ7nNjc0PRP70xlv8oA6tU51usE8UuYdYsQ2Bs=;
  b=NF/xyvuZqNZwpqJAU7Y2ttGe3TdwQFawrXJdPmIdPr0TWU9H3GyOK1Nw
   G1UgoRySi+AYhKY2YCKO7JAf6NrkDKdSyjWtEhgxIAGAbawkIdBwOguiW
   xsYGcBZ/8m3ajvJlaywbCzvbfqFkHQ4M5Eu8U2EUBJjZ8YoCs+PBYSy+S
   dkpJSstP2zcce+S9KW0hLEde8eRiA39c1XfiPL5jHwbZl4IP3H69wNake
   2ejVU5EEkg5ZwUGaoi33Oy2roHN7CTxzdOcrtPuKEFYpo1wTmu5ymq7+s
   MUBi++Y4YxFxqWx96fxF+J+irqbIBQSvaESD4W07VnZHiYSUusDfNnoga
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="305745516"
X-IronPort-AV: E=Sophos;i="5.95,202,1661842800"; 
   d="scan'208";a="305745516"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 07:04:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="630500101"
X-IronPort-AV: E=Sophos;i="5.95,202,1661842800"; 
   d="scan'208";a="630500101"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 21 Oct 2022 07:04:40 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 07:04:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 21 Oct 2022 07:04:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 21 Oct 2022 07:04:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bhyi7ktshhTeVnwV0Jb7RvZwU1EsMVBeTszBxrB4Cet3jTmqupeHWnT0KsTjITyOdkDGcCIiYYX6Lug8uiU1x+Tkcr20Je4pLWd6tKDrIDYGVBZJyAI7oEsbEqtQuvD1K8psFJRIheiMi0urSjebg6X7qbZRd1GbaCY4SBs1FQDf+0p+mactwXJoLGxfFEVVaSaW5mHShXpe5OFzagG+nZi0VwhtbuFmfC3u9yxiHnWmmrjVtOJ95N9lHOEsX66WHhsW635+KhHPC7mUE8Y1IXs0StEmqyLpsT8w4xM5PmSoDqbqJCEZxTPydKDu01++glG1q5j4P4iS7heVeVXBJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jl6tfaqLSNoNne67m7Dujojl+8o2YVDaZKLUPoR+634=;
 b=FIMqoU2qLqUe1LIqge7gexWNhJvzcSuyfBCp3jLrWvbfiAAVUSTJwitirnHsOZaN1py7FDZms2ckOvazA6S35iVj5hqsf0LT9QlJyKSEJyzHicccFAnLeSEFbYYSQctaJA4YnyYlznU4dPmRLLB6yWRL49CBWTrDTyTIKg5UXrEb2UxY59QcKPHYIka9TmCfjWsGPFfQ1A1jAbV8l5hsItyv+i63gn3gpbwW6M+Nh8XIQ0CeRX76oyIHl0CzVG5r7dXKGx1AGN3ngmzwRBjikdBC8tUx/yqbF9f1NeaNkwFS4RfL+lq8hmHXViESH9j03vBJq6cLmu3Ip5d7LNm8JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by CY8PR11MB6988.namprd11.prod.outlook.com (2603:10b6:930:54::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 14:04:38 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::c2b4:3f04:8165:bb69]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::c2b4:3f04:8165:bb69%7]) with mapi id 15.20.5723.034; Fri, 21 Oct 2022
 14:04:38 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Shane Parslow <shaneparslow808@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control channel
 mapping
Thread-Topic: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control channel
 mapping
Thread-Index: AQHY0V2Jt/u5ekZbl0uD3uGkntVHJa3zEKgAgAFNmQCAJKPJ4A==
Date:   Fri, 21 Oct 2022 14:04:37 +0000
Message-ID: <SJ0PR11MB50088ED0054BD0C497E16A3BD72D9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20220926040524.4017-1-shaneparslow808@gmail.com>
 <SJ0PR11MB5008658CADCDADE43C6B0D5BD7559@SJ0PR11MB5008.namprd11.prod.outlook.com>
 <YzPkeEE0rbCurF4L@arch-x1c>
In-Reply-To: <YzPkeEE0rbCurF4L@arch-x1c>
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
x-ms-traffictypediagnostic: SJ0PR11MB5008:EE_|CY8PR11MB6988:EE_
x-ms-office365-filtering-correlation-id: 4023d9e9-44ff-40f0-7ae3-08dab36d30f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rLQLz68sdLFAeGtr/bCrZaGoo+17PT5vaxR9A7XZ5Ro17t8uh/hDMVXWAGJGAL/Yrqm+2YIpMPa+Nlc8Cv+sToC8CRiFogE2DKGBtz19zXlXcrsSEALUKdUplQYyXamk5cnFNXabzQ1ae7EwslbW5UO4XTfMzSeO1j5GUe891ZFk7vtg2n7864Q4J0C8qA4XVBAVbogkszDUoBgORjIgQpY2TC2X4jmSKXvhG30i6tMZQUbBCNA8JoxfDmXKXcM347ilptDlGBJv8Ind0G0Q92j7WrgccOJixoUMPnLNrZ2gfuDqRNMyC7zNGn4SUtekAo95laQKVc8rFE7AgUw2FH50BO23Dc/ISnrfopvCo95t/vRXrq8rkz8cQ1wpTZ2859HZqSqXst/9584Pk0/XzOWYGhsKH1aJioE7m8txa91QLf+p0ybhWYIMPV/6MNH20ykpCIM9NhvxMxTIgE7E9Rpid2g2y4kllCZmbiOG42/GD/lXZCridQfc1xpzTpCAEXSf7nw7Z73SHIbRwTu0oGMv+NAiChEZ+vxtK3pDsWW0ENxFkpicZIuKnmzoU+tvOseBvMbGL4mO9AtrVYJgrmvyx/Ts0S7uCQOT55RCyDQ36UrZyhOxLo32ccKYDvBgfG1ejJWJy6vIJn4elBP6IieNLD1She8YBT30M8/9aYR6RvA7uxcn99mUTFfdnHPLlmMF200GgepvxLK519kbRmYZZHKSQEH5xlT8WwBFogRGi/NIqoeDuiFuCqc6tQFSiZ5rqtX768dzp6MAo9VrTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(53546011)(38100700002)(478600001)(38070700005)(82960400001)(55016003)(52536014)(8936002)(66446008)(71200400001)(316002)(6916009)(41300700001)(86362001)(122000001)(83380400001)(6506007)(66556008)(4326008)(2906002)(33656002)(186003)(26005)(9686003)(64756008)(66946007)(76116006)(5660300002)(7696005)(8676002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eRzjIzuy926+YCdzVfWCSyjGZMEUKQHoH2hkTvm4+/6+VfMvzQq0c2yCC5V9?=
 =?us-ascii?Q?PFTssSmsjXmiAQeTPMIuoFt6/9ERqcQY+mg7eOumzc8WxjdCkJtP5sHXF7Oz?=
 =?us-ascii?Q?8OKnvzBrLrVI4aY1l5geniivs8lvZsL341GjbMq7dqyH+tB50M1ScOH/irZ5?=
 =?us-ascii?Q?qfoHAHdbYttZvY8EkAgy2JbOZjVcJnx8jwptDvKpQLNw2p1N3KhzhMlgUncQ?=
 =?us-ascii?Q?MX2QT0xOGREWcvsQIvmIBXd5rEGdmaHOMJRSSpbr4prLES7OS8cUkE5Mwrix?=
 =?us-ascii?Q?m6jQsY4lTJW+hW/mdrIRVS6/JsIxwHpV27osww+B+3IN0pGv//6Qij0bq10I?=
 =?us-ascii?Q?uCi//QFcvjylozdAQXwIfxmhqnvmVvb/Q+P9N8T3KYxMhhClu2iIDUCfQ27K?=
 =?us-ascii?Q?jeKy3DRg3pwsUGAndBqmHY5YrhdgAGaB5Z+lTOHXZQESQmjEJf6ULbNrlTBk?=
 =?us-ascii?Q?WVQbFFdtVpxCg4Gs1xpAyjippRpuFNcCBR6mXf5w/2/VK14HCO4Iq0T39tfT?=
 =?us-ascii?Q?O+3NEJpLZubiNiLz0ZvjV6cKAZSTy1TlJDaIAdg7A0BhbJrKoevvOmDU92PM?=
 =?us-ascii?Q?V4ozN8f2njUqvwk/plhRU3ZIfYEmDRdDGjXCxI7ZkX/WhmT5eTfIe5Bk9aB3?=
 =?us-ascii?Q?WBqxGje330n5mklXpOtXsozptjauTMD9qb9yjq2jzNko7hJvCdw0PkpDBwXP?=
 =?us-ascii?Q?75QLXQjKMP1gJiS2eHOvffDU8bBAyI4y1F/qQWIJwHCdZe8JKknn8+kOgA81?=
 =?us-ascii?Q?wWdepSpvSqZJijv4fjSU/RtZ0OPdz12Vg43P/jOj/zzaTIPHwQK0AL/0+DHN?=
 =?us-ascii?Q?YVYE2005kWx94qUuxHQXohWf62r6qEIRPB26YKbkYY+GmwtJ6AJpZek9Ty0G?=
 =?us-ascii?Q?yKdJ3kKdEhP12RikNI6IuV90Qn0jQADRLVdmuiuIO4690O4/Ju8hnz72jZl0?=
 =?us-ascii?Q?GUzX6/skCjfhinJwXVdUnwtnufplLtzsJIhfT2oBjMSE3qNwcQJj2huJ/MGY?=
 =?us-ascii?Q?hCMJ6HzbWBTMZx/dapetEUs4XcLcxahDO1v7y7qv9iFUX1fVhH9ta3j9GsSI?=
 =?us-ascii?Q?cPt6X0GviYrNbFwJbdWgaCO/Yh3wlg/6oIPVz/Fv5j/cqo5amvj4MpKHY470?=
 =?us-ascii?Q?T40ByUQAj+ldWZA6A0ARszcKxgWoV6Vvp9JbjrNxdnENSfanUjI1EskNsOXE?=
 =?us-ascii?Q?wN6sfh8Bbdzbkes2iIUZi3W+VlL9W2UVV0XQ7LiMmrjprV7VEUHoSusbDYI8?=
 =?us-ascii?Q?o0poAgIiUvC+DRzjv3WLzpf6pHAgUsE4cEPWXvIc5lbwopYsdeky8U+X0823?=
 =?us-ascii?Q?AT1YzvAby9Nf7MU7ghMvgSh8j0/Aoknt6xXc1dEgBXjVAdoXYKvkvpLa7Xql?=
 =?us-ascii?Q?llVU2gs3HGKwZ/Jv4jOMnYtacoNSrg3HUnddmN9nnd7+/p1uG6qJo2w//aNc?=
 =?us-ascii?Q?si68j6as2Gdj8y4G3E9YAEDdYHikuXN+TZeQQtYM5xrOH/jVpSFcSsgnX2Yp?=
 =?us-ascii?Q?ydbZYSaAUvJzE5OrZ3+SPvQ1IpTbxwpyUEQDIh9i8ngtBU2sMqdn1lVtAHF5?=
 =?us-ascii?Q?M2VEYKkKycxK22wRSKiWHyoVqJI+t44B9vRn/RRZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4023d9e9-44ff-40f0-7ae3-08dab36d30f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 14:04:38.0260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xQGJ+YhrSoPGs3BFyciMvnE5sNN8CX2ENIl1jLm39j5rd9RwVfzRIN3nL0dUuDa8nwkJN7col7cpVl4ixbhNbRJHJWKDLyyOhVJUUUE5nbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6988
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Shane Parslow <shaneparslow808@gmail.com>
> Sent: Wednesday, September 28, 2022 11:37 AM
> To: Kumar, M Chetan <m.chetan.kumar@intel.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control
> channel mapping
>=20
> On Tue, Sep 27, 2022 at 01:43:22PM +0000, Kumar, M Chetan wrote:
> > > -----Original Message-----
> > > From: Shane Parslow <shaneparslow808@gmail.com>
> > > Sent: Monday, September 26, 2022 9:35 AM
> > > To: shaneparslow808@gmail.com
> > > Cc: Kumar, M Chetan <m.chetan.kumar@intel.com>; linuxwwan
> > > <linuxwwan@intel.com>; Loic Poulain <loic.poulain@linaro.org>;
> > > Sergey Ryazanov <ryazanov.s.a@gmail.com>; Johannes Berg
> > > <johannes@sipsolutions.net>; David S. Miller <davem@davemloft.net>;
> > > Eric Dumazet <edumazet@google.com>; Jakub Kicinski
> > > <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> > > netdev@vger.kernel.org; linux- kernel@vger.kernel.org
> > > Subject: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control
> > > channel mapping
> > >
> > > This patch fixes the control channel mapping for the 7360, which was
> > > previously the same as the 7560.
> > >
> > > As shown by the reverse engineering efforts of James Wah [1], the
> > > layout of channels on the 7360 is actually somewhat different from th=
at
> of the 7560.
> > >
> > > A new ipc_chnl_cfg is added specifically for the 7360. The new
> > > config updates channel 7 to be an AT port and removes the mbim
> > > interface, as it does not exist on the 7360. The config is otherwise
> > > left the same as the 7560. ipc_chnl_cfg_get is updated to switch betw=
een
> the two configs.
> > > In ipc_imem, a special case for the mbim port is removed as it no
> > > longer exists in the 7360 ipc_chnl_cfg.
> > >
> > > As a result of this, the second userspace AT port now functions
> > > whereas previously it was routed to the trace channel. Modem crashes
> > > ("confused phase", "msg timeout", "PORT open refused") resulting
> > > from garbage being sent to the modem are also fixed.
> >
> > Trace channel is mapped to 3rd entry.
> >
> > /* Trace */
> > { IPC_MEM_CTRL_CHL_ID_3, IPC_MEM_PIPE_6, IPC_MEM_PIPE_7,
> >   IPC_MEM_TDS_TRC, IPC_MEM_TDS_TRC,
> IPC_MEM_MAX_DL_TRC_BUF_SIZE,
> >   WWAN_PORT_UNKNOWN },
> >
> > I cross checked by running AT test on 7360. Both ports are functional a=
s
> expected.
> > We should be able to send or receive AT commands with existing below
> config.
> >
> > /* IAT0 */
> > { IPC_MEM_CTRL_CHL_ID_2, IPC_MEM_PIPE_4, IPC_MEM_PIPE_5,
> >   IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT,
> IPC_MEM_MAX_DL_AT_BUF_SIZE,
> >   WWAN_PORT_AT },  -----------> wwan0at0
> >
> > /* IAT1 */
> > { IPC_MEM_CTRL_CHL_ID_4, IPC_MEM_PIPE_8, IPC_MEM_PIPE_9,
> >   IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT,
> IPC_MEM_MAX_DL_AT_BUF_SIZE,
> >   WWAN_PORT_AT }, ------------> wwan0at1
> >
> > Does this second AT port (wwan0at1) goes bad at some point or is
> > always not functional/modem crashes sooner we issue AT command ?
> >
> > Could you please help to check the modem fw details by running below
> command.
> > at+xgendata
>=20
> Upon further investigation, it looks like the modem crashes only occur af=
ter
> S3 sleep, and are likely a different issue that this patch does not fix. =
Sorry for
> the confusion.
>=20
> I say that the channels are mapped incorrectly because upon opening
> wwan0at0, I recieve "+XLCSINIT: UtaLcsInitializeRspCb received result =3D=
 0",
> and no response to AT commands. The behavior I would expect, and the
> behavior I get after applying the patch, is normal responses to AT comman=
ds
> in the same way as wwan0at1 pre-patch.
>=20
> To be clear, my patch points wwan0at0 to channel 4, and wwan0at1 to
> channel 7. I have perhaps been ambiguous with the terms I have been using=
.

I cross checked the channel mapping. It is proper.
In the present implementation 2 AT port are enabled and are mapped to chann=
el 2 & 4.

	/* IAT0 */
	{ IPC_MEM_CTRL_CHL_ID_2, IPC_MEM_PIPE_4, IPC_MEM_PIPE_5,
	  IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
	  WWAN_PORT_AT },

	/* IAT1 */
	{ IPC_MEM_CTRL_CHL_ID_4, IPC_MEM_PIPE_8, IPC_MEM_PIPE_9,
	  IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
	  WWAN_PORT_AT },

The channel 7 you are mapping to wwanat1 is an additional AT channel which =
we have not mapped to/enabled by default.

I flashed the same version of FW (1920) on my setup and I see both the AT p=
orts are functional as expected. If mapping was not=20
proper channel would not have returned response to any AT commands and the =
reason why you are seeing "+XLCSINIT:" is,=20
in that version of modem FW the GNSS module is returning UNSOL command on i=
nitialization. This was fixed in later fw.

But one issue I noticed is, modem is crashing in S3 sleep. This issue is al=
so not observed with latest modem fw.

>=20
> To recap:
> -- The modem crashes are likely an unrelated issue.
> -- wwan0at0 is currently unresponsive to commands, and outputs
>    "+XLCSINIT...", but responds normally post-patch.
>=20
> AT+XGENDATA returns the following:
> +XGENDATA: "XG736ES21S5E20NAMAV2DEFA19223101408
> M2_7360_XMM7360_REV_2.1_RPC_NAND 2019-May-29 11:40:45
> *XG736ES21S5E20NAMAV2DEFA19223101408__M.2_7360_MR2_01.1920.00
> *"
> "*"
> "FAB-CODE:7*SDRAMVendor=3D0x08 (Winbond), SDRAMRevision=3D0x0000"
>=20
> I don't see any firmware updates online.
