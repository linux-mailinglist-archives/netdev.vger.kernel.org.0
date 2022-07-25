Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087B25805B4
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbiGYUdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237172AbiGYUdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:33:13 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5339622511
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658781192; x=1690317192;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Vv35cfeinlcTEDLhv7VtiVneExr3OnE0PkBaTsRLH4Y=;
  b=I8X0AGHVChpLDJ8vszSrposHHLQfeT/RMFTyRYS1i+TV/42YJlobYLyW
   DwSexu01WWddWFCSwVohXIetlVXr89MWEEbH5Zux+XK3iRSh5Zqge+3Kw
   pDb53Mx9AFvph1ZZrrS2ZkTX7Meb/M6Q3cOo7leBFCmdC7pRkb7Uov7/b
   sLoV9sNLg6BsUNsABERzp7a9sT85wHKqUXtU+T4jWfaBE/DjfGL4hHtKC
   JHYAMHLN3fDd097H2/+N8DbqWsq6eZ8RbReSNWIAnEdTEfYXsZiKiMKTQ
   WCoHD4JUdNNczbayXwbnkIVcH+ECfEAe+Iz7rs+pDgTRxNm6mlt3vYqt3
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="268180596"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="268180596"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:33:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="689186660"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Jul 2022 13:33:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 13:33:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 25 Jul 2022 13:33:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Jul 2022 13:33:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BlOuLcbQw/4t6iNfiduSbmnwzfzHUvoyZrbT2I0YSWBizGmYa6wQwmMY7A0AzZpb51CJ88JHxG2JlNHAsYsEKxzdsq/iGDpb+j7fdpIYVCvULVZCZXs5HLGt3+1z6GDopwz9UpaCwOS5TCBbKCNjZ608uvGpl3O49el2d7BeekRGUspiaRRlc4Tq98Ou+RqaPlBKFmWLryuwuPx0ewy9mm+a8GZcLVCWnBdA/CPDnLAkmhMpHca4Py8Y5Nqv1NSYZH6ME983GgVNou33/Y3lYtA5s+7Z0kIjZo+vV83W6sxwHK6c8xplWfq1ZsAR06ixEz1p5itVlo0jyzqYlwo9og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vv35cfeinlcTEDLhv7VtiVneExr3OnE0PkBaTsRLH4Y=;
 b=SP/8WIrvEFRR5jK8snzWmSqFqXcVjZdKe8kSJFRKB25fgcNscwpITNvCFiojRQhaDgMqH5WaxgE6Y39i7aqCKpRD9dbOveaqCKYygBZ4TOAiY7mhOGi3xJCu+Pd9MAUmhoIRCpIrlVB14oDxzm7/l4dfkhCOlEvGmCIjZBzcpFYgW28lQTGNVVVDsgoW142sJTKN7w1ITmiDad/XR0x21JBXC2A99gGoBZ7rrT7fgc73sruv5YLUhg1UABF8tNQB1+FOBH34WHoCz4tYgcL9CVQ3D8qxm1KvLZaRxR+wqzlbum6yMW0schBv1NM0t0vwMPrKU0udfyzVhVjf+VeKvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by CY5PR11MB6415.namprd11.prod.outlook.com (2603:10b6:930:35::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 20:33:09 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 20:33:09 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Topic: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Index: AQHYnGds4JyoDr5oaE22k7ooTa/97q2IU/QAgAD0rTCAAKRdgIAA9+uwgAE35ICAA1xV4IAACoOAgAAM5bCAAAGEQA==
Date:   Mon, 25 Jul 2022 20:33:09 +0000
Message-ID: <SA2PR11MB510075C54D0A3A1087307E89D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
        <YtjqJjIceW+fProb@nanopsycho>
        <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
        <YtpBR2ZnR2ieOg5E@nanopsycho>
        <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
        <YtwW4aMU96JSXIPw@nanopsycho>
        <SA2PR11MB5100E125B66263046B322DC1D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
 <20220725123917.78863f79@kernel.org>
 <SA2PR11MB5100005E9FEB757A6364C2CFD6959@SA2PR11MB5100.namprd11.prod.outlook.com>
In-Reply-To: <SA2PR11MB5100005E9FEB757A6364C2CFD6959@SA2PR11MB5100.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1b26f41-05e9-42a1-9f44-08da6e7ce365
x-ms-traffictypediagnostic: CY5PR11MB6415:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: beXRB93QpkQJzgqPeZ5w/GL8WXcnOSGqnMHPN85/viGSdBYmGT7EZ63xdMSgoWNDMrqmVnlu54Ho/I2FFLb/zygZBAqNlF3GrXo0coIaAGwf0cYCeLCGnd3Hwbx/2KtqHnZe5X7BCPWgrtDbxPXQtfNdiQo2Hlhpup48bymuMoBPzse4KTmYolJ9sR+v05pVdqW6QT+jliCOv9VefCunsJQV6ZryfNl9l+8b+talrG++hJpX8nYw5Lq9X3kbCLbKJnVYnL4/NbiEDZzVf4RfFGkVk3L2/XsesyFUHE2T01vHCb1aSiJFqEFGH5xAMN49DgUpiEWrzBwGcuethgYs7oX/RXobZwyv9plNcvHxVfieAGjcRaOyDMCjsNkJ9VGQBgYYFh3LEzrslQOI8x2J2O4rjBbOS55OyQjHMV8U7paiDMbx0ZvW0aGkMxg9mI7PLYezIr+29J5K066QbIrTBk7tprU8cyJEeBxNpWOg9PWcoB5b7iwDZNpNckSzRhWSnJzWvToMyctWagFqhwB+9oCeSmL8LVY/qxXlUK2oG7JxiiNBSp9JWSLG3UODd99TYpDVFzixovb56WK0Gm6cnRPnBab4tROZ7Q4yRdFM+JNzaK+4eq7M/k+S2DwJGcK1giiqBALfR+f5VMhGlMD2E1akBbnLz/OM0n8BV671bqUpRZ1wEeu6So5lr67mAKgQYr5zb1HIZjrz0nLCZe+QfUUMGr9kWPRa9pd7GaeeLPHaE8W06rForRKfCfoaslRldkq7puxYcVPvbx2p+gkTwmCF6MP5Z+AcIub67sPKwhGC9NV/dbgopZlHlL1RybcU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(396003)(366004)(136003)(346002)(8676002)(71200400001)(478600001)(15650500001)(122000001)(4326008)(66946007)(64756008)(66476007)(66446008)(76116006)(66556008)(316002)(110136005)(8936002)(52536014)(54906003)(9686003)(53546011)(5660300002)(33656002)(7696005)(6506007)(26005)(186003)(2940100002)(2906002)(41300700001)(86362001)(82960400001)(83380400001)(55016003)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?praNfFr79iCtFEbjDuK7DbGEWjBu6otJ5l/U4qjCD/BruMqCBR+zFFFYG0xF?=
 =?us-ascii?Q?BbE3jg7QOe2uetz3mkqDBjUfDagOkQ3TIcpJIxMbG2CAqo5yaoRQfqpMGIbv?=
 =?us-ascii?Q?rKuLh0QME5g/9Towr//CJzPsmnnO3Htles92bmlBClqjSgEWOb8WNGLGxa0g?=
 =?us-ascii?Q?GqE0IMUUhm1bk6s5G//ntFFtsuxMbWPdN9vnBoDwVOUczkAba2yqn8RvtlPc?=
 =?us-ascii?Q?A0nAgnMvZkczTxS/GtlrodYMXeRRInxt4qPHg0qqf1pEWOWdjCIUaWpiIhLp?=
 =?us-ascii?Q?u+JHiN7WRbYdca5KI5rVHndYe6LCfRFuvG5Mf5g7CTOk6sIUpYDsKmBVVj+k?=
 =?us-ascii?Q?QfMrBRzEmkYQYSIQbW7AGO/xDAO7FhSCU9L8b9ymiHrbbV/N7Ad1Y1MlUpbx?=
 =?us-ascii?Q?Eemr6i5e76EzkthVmXRpx7BS/Y817cW3JuzwPG86SbrhkbpkXlJjqCr94DFM?=
 =?us-ascii?Q?25W6IxzOK4W6O1lu7V8AOAMvHv8DemolXENkHJ+RAQcgEd9nTUkQ+xlDbOHr?=
 =?us-ascii?Q?0mX/T4l0Vvyqyn2E+8HQGDoSlQlAl9XqFe2Vurws91MNrDdiDF4n0El6e0fr?=
 =?us-ascii?Q?EIxPAxtVWPWbsBj8u0ZId5lluGXD1Tmr3rj/+0EW8Urls4Hpw0Ol6Aol+kSK?=
 =?us-ascii?Q?SuR6qKE7mSWUAsTPMu6wgx0XAX1wJ3gn2OIS6zf4trxLsbZuo3Zm8rbce7rj?=
 =?us-ascii?Q?+SoNzAqBmyyIL/thCG52VDShshEiIhCIqNEaNoJy05Mq6cuRi6z/MCqNRaMW?=
 =?us-ascii?Q?5lJZW2J6lbrPf68wBnKFQeZHMRIRxYaw34Wp0O9eZ/0aG0cWS0c3YVg6JmS3?=
 =?us-ascii?Q?XB87LbwMf2tEy4sF7g2lkcgumwOyvBbrRaxsrdLiaf7/ngiVvBiyHVXXt6e+?=
 =?us-ascii?Q?UwR2yeO0OV5mddGcL9p7FEM0vIs9K3MVT91HdgoSHkLpfTTQezydh/I0rc/I?=
 =?us-ascii?Q?pFT7sfzpWh3745SXDk8jgCvKKECvEtNwBg84pl0GTIJe5pO6BtCof952g4i0?=
 =?us-ascii?Q?Ri3dZgUuiGx+tX4v0PzlcAGd7kEYGdUS8xXGpuRkJLv480pMwJKtCYUhiKHp?=
 =?us-ascii?Q?17+OlrS9uwswc11qr754dmNTxODTkb/MG6XyTlpdXlenQxOYOg3BkoCmTJQN?=
 =?us-ascii?Q?KjY/gBL4L9YSqk75X7Kufl5KWYC/Ph5x5bGV998BbhIsK/MYXTvLAWIHpqAc?=
 =?us-ascii?Q?1Nls1sADRDP16Dk95eWpJyUx8kWRLTNbRaKXbt9gCiVYLrzARXMP/0W0RGLl?=
 =?us-ascii?Q?iG9hzZPdpkqOeSp9CWTdcWpe+XtJ1u7IE1RVFcIGXIdM4wM0DffHd8vIF8MH?=
 =?us-ascii?Q?HlqAJu+kUrFBxw2o1eEyJ7/2hO8fkoG3k30A2Q8cBWSdqBRlTPBPOQsXLq4T?=
 =?us-ascii?Q?d9JOuTe9tQjTZohBMD9F8CV5Z4fscileMGrShrpWorVja4KGPLK4ETsH14jY?=
 =?us-ascii?Q?ctxKBwGGAFM86yktYwQ2vw8UVjPDdcorzoLHqB69H/uxA82DrDg88/oBkpl6?=
 =?us-ascii?Q?ccVtDQm+hH7aDJIGcR4fnNA0tzhikiI80sy7Sh4EFzymFAtnKdEkZQTvbYb3?=
 =?us-ascii?Q?JE71pFjYDzIlQlbe75qwF2nE8FSd4642dU+S/L+7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b26f41-05e9-42a1-9f44-08da6e7ce365
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 20:33:09.6278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L7iUDEyQho61G//nlgu8KydiGYA4BHC5GrmOulYsqODTF98aiIiE8DBPkYrXJr27U9NM+H5GsQAdx1hqM1ZDRWRlRWdKjvxFk0cZfINm/Ns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6415
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Keller, Jacob E <jacob.e.keller@intel.com>
> Sent: Monday, July 25, 2022 1:27 PM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org
> Subject: RE: [net-next PATCH 1/2] devlink: add dry run attribute to flash=
 update
>=20
>=20
>=20
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Monday, July 25, 2022 12:39 PM
> > To: Keller, Jacob E <jacob.e.keller@intel.com>
> > Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org
> > Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to fla=
sh update
> >
> > On Mon, 25 Jul 2022 19:15:10 +0000 Keller, Jacob E wrote:
> > > I'm not sure exactly what the process would be here. Maybe something
> > > like:
> > >
> > > 1. identify all of the commands which aren't yet strict
> > > 2. introduce new command IDs for these commands with something like
> > > _STRICT as a suffix? (or something shorter like _2?) 3. make all of
> > > those commands strict validation..
> > >
> > > but now that I think about that, i am not sure it would work. We use
> > > the same attribute list for all devlink commands. This means that
> > > strict validation would only check that its passed existing/known
> > > attributes? But that doesn't necessarily mean the kernel will process
> > > that particular attribute for a given command does it?
> > >
> > > Like, once we introduce DEVLINK_ATTR_DRY_RUN support for flash, if we
> > > then want to introduce it later to something like port splitting.. it
> > > would be a valid attribute to send from kernels which support flash
> > > but would still be ignored on kernels that don't yet support it for
> > > port splitting?
> > >
> > > Wouldn't we want each individual command to have its own validation
> > > of what attributes are valid?
> > >
> > > I do think its probably a good idea to migrate to strict mode, but I
> > > am not sure it solves the problem of dry run. Thoughts? Am I missing
> > > something obvious?
> > >
> > > Would we instead have to convert from genl_small_ops to genl_ops and
> > > introduce a policy for each command? I think that sounds like the
> > > proper approach here....
> >
> > ...or repost without the comment and move on. IDK if Jiri would like
> > to see the general problem of attr rejection solved right now but IMHO
> > it's perfectly fine to just make the user space DTRT.
>=20
> Its probably worth fixing policy, but would like to come up with a proper=
 path
> that doesn't break compatibility and that will require discussion to figu=
re out
> what approach works.
>=20
> I'll remove the comment though since this problem affects all attributes.
>=20
> Thanks,
> Jake

Hmm. The more I think about it, the more it seems that per-command policy i=
s the only way to make the addition of dry_run to new commands safe. Withou=
t it, we'd run the risk of a future kernel supporting dry_run but a command=
 not supporting it yet.
