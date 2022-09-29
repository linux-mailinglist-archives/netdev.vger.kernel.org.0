Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914B85EEBAE
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbiI2CXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbiI2CXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:23:20 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0058E10E5F9
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664418195; x=1695954195;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3Ja0RLNfOO6E9w19OKwnVDwJfFyeUuiOAtt//zvC4MM=;
  b=jXgjFW90ZfbBUhziMyUKocPQy/LFHg8ZblcidCozUB4bvQoxw0usb6qf
   BcCvQWu222mP5apAwJJbO4t62Ry4j2rdmKKvZ8emAkU43PFlec1vJG/dy
   bpORpmetKA1O7uN60Or+wkoQc5x8o+atRwqVFacyHIlIGZtPHPaHDCX2t
   9C1jCgGL6uFk0NfFsvJFTVEp0mti4EFMnJXXU4Ge/LowFOHmTRX7KfJD7
   YQfyQRSPxWGl5TelfjTv9GKFs6NrYc0IqM2DXiDqU5h2vU+KnifhjzpvG
   3IskSWpmrdBSY3sYfw9g16MAC26cqW3jo88ERijvBv6yLvWkvz0uxWu6o
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="301746442"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="301746442"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 19:23:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="599813680"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="599813680"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 28 Sep 2022 19:23:14 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 19:23:13 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 19:22:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 28 Sep 2022 19:22:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 28 Sep 2022 19:22:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCnuukrMT9LvSer3jPR48nA3AaQmEP7ptGykbi5bW5kvDvyf0B4R4O9zYMAfV+j+e0T2nksT8oOM+MTvT29vST8qnDaBZY8aA/E+h9olh0WrV7WllgzZp/gLExRneWtiBfB9GIdrmovHejW8V5I+Ee/EbyY/gjNMKvGNAEC3LzCpE8Nx+gi/zatiilcb6I2CediRi1g9pF7rbMO2miQM3YFBto58/KliN/b7OwYUvXmrzScquQ7OOyJMz+JybiaYOGGGv7M499ohQCbMydOExbQ3/jI9akMsd92Xh7LQyh5n9Q3GtLbQC/31WXHOWISKyFaPlf5WCAfdley4x22Pdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHMeCj2l7Tz+nmhE40sABu02tkCqpoSzL7uRZkhFTPo=;
 b=kADPls38j/R4EvZPTunXbNWGlTIlOnH5H7Ply4NDhdeDFn/R79hRS2fTUugQlDAnF9IS24wO7FXlfeI66OhPDTITwNu1ZdOzt4GmQuWBX/+SeSGUmfq+LrCb26XvMJWpb93USOSqLAW04uQU2axta1cb88Byfeb01rqYDPeykR/ZJZJ6jYjhJakh6XUllLspOREvOIaJH4HULRWnlIhBoxsjR2AIh/zq/qZSbEo+Mo6+0gL87PmE2Ce1CHnsf5FViWuDdF6tYUNhQ4SB+85EusLF8+lRqo/xdKRu+JvWzCjb4N3G6s1BtDVT1r30+W2pu1WVdndqXDxGmNynQA9HnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by CY8PR11MB6913.namprd11.prod.outlook.com (2603:10b6:930:5b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Thu, 29 Sep
 2022 02:22:29 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::7c03:1c40:3ea3:7b42]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::7c03:1c40:3ea3:7b42%5]) with mapi id 15.20.5654.026; Thu, 29 Sep 2022
 02:22:29 +0000
From:   "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "Ahmad Tarmizi, Noor Azura" <noor.azura.ahmad.tarmizi@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP packets
Thread-Topic: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP packets
Thread-Index: AQHY0nIwdgyUAXnuBEqr/9DPT40VFK3zZmiAgAJIAgA=
Date:   Thu, 29 Sep 2022 02:22:28 +0000
Message-ID: <SJ1PR11MB6180EFE995DC659ACB77120EB8579@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
 <YzMWX1xPC0NChKNl@lunn.ch>
In-Reply-To: <YzMWX1xPC0NChKNl@lunn.ch>
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
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|CY8PR11MB6913:EE_
x-ms-office365-filtering-correlation-id: fb8920ac-0b74-4506-45c1-08daa1c17506
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /mjbgUgby1vjTfY2PMgnAKAHmG7j/rvTSQhJaQ4mGdcB/17bL0UBY/9vRsg1YLONoD+JcEtKF2nLSMEhs+2ie4cPGavZLMZEj/r6FZCeJnBKqhIYJzsTfB7VXpCyCDPBw/RfgNY+Hh855hS7CfvozvRvVuX0Fz81JDjHwv0dr70EiyZ88Ay6QGi+D38rC+E9pA4uJGWgtkb5tO7ohmsX/NFWjgjjS9qNL4DX3OM9FgPg5z/6jGjfvfsk/Bjnuos1FfrqG1Ydf5t6P2vmmTK44+23Q64mSWFvLFyc5wmDEp6/Tx7RxZoLKIboxMT80AH9MV5S9kc5i+Fy8+qi5SWgwYhNb3QUnlrLfFT/IEZlZUGRtlDThxX7JGnji2akVRzEL4/Es+TkTu7UuMK8SePK2P5K0JYw7iPqyAN2PNi+lZoi1Nia3iaamLs4hvhyOrKCUxQ+inKLvbadHUvMok43ezr8d0Bt2WzalHdhBlRbBZ4j62bdTni5oYL0VqqyRjKgDRR5mDU4WDTtsAZkX6tdRVGxvlXu1HbvcGtXkA8TrWKv6KLBz079fZOhI9+Zk9j6bqbZbqEVEG3tGXAkx5TbNBLSAuEibcI/pFbwOyvNQ/EHcv54+Jmj/+pC3HNlmVU8nV0ytAVVjo9uxJDGUqxGCvr5UhyffW41YLtcdLFQfoQ1wCnV8SylvgIOqYHXhgP35FHB2qm+L2YzSKVh1C8yl2V/JXb1Dy452rhtWFjbswUg4dPM2cyBkbcLypDazzMUWb9qWsXzNx4M0SbKU3C3QA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(39860400002)(136003)(396003)(346002)(451199015)(6916009)(86362001)(478600001)(316002)(54906003)(55016003)(41300700001)(33656002)(66446008)(66946007)(66476007)(64756008)(8676002)(4326008)(76116006)(122000001)(82960400001)(53546011)(83380400001)(66556008)(26005)(9686003)(6506007)(7696005)(52536014)(5660300002)(8936002)(38100700002)(2906002)(186003)(38070700005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qw5rRy1minV3GE6Rpih3OV++BUj/uF9aEbWQ+bAfLS7RG5bc8uftqEK1vfN4?=
 =?us-ascii?Q?WLEhzYP8sgnkAyD+6EjlMtib4FyCZ2c9BRB8tT/fB06WfquQWJxaBSUjFfK1?=
 =?us-ascii?Q?yVR/271GLRPQtPyDIHSG/CEkW+myNAGkfj6DrMIFOyzMzZFJmo0ZRDW6mFlr?=
 =?us-ascii?Q?+IJxI1/XH4zY8TjtWfvhe0zIbvzxtVKTKRTLJUuDzrSXvgR5A6b9mikjDsaN?=
 =?us-ascii?Q?Sf7TdNTyF9+GWgjUbTRc8QEQQ0Umw8vOzX1sHghEhrkhSO9koGXw+gBqGdmj?=
 =?us-ascii?Q?cc+gt/0kCCmj7h0N1QbeN1GvsM3ATJLJy4M0IWqS1E0lnENCKQ/LNc79tbZt?=
 =?us-ascii?Q?y6rzk2pP+fPjgLYRKozW5MMmzo5y1kwg0OnsOaYW3YVILZ8zPC01CjdCEXv5?=
 =?us-ascii?Q?ErEprbZNisPl4sSHeZDxtKFxb0URddawUSr+KtRdDCY+k0/n6tf6FfK8PRY7?=
 =?us-ascii?Q?nB8QzEW9uRoXY9/d40dyfMBNN2cHo84pCuHDAWoDSRmoh1ilz4k8bc9Ub0YU?=
 =?us-ascii?Q?kRoP5IUs3YBRqH3bGpn0P8j1lBspxfhmD0z2kU+ZFPjE8sfpY525FzqbySv5?=
 =?us-ascii?Q?B698G16LWSpfjR+S6HcZCtaCyA+lzvgYWMTXw9xx+bqjAJDFqBVs8Pa/hGNQ?=
 =?us-ascii?Q?Cls85am4gesI+BBaHgFCBR4GPcX6HVN20ejQ9kHMT8WvCPwJh3R0yqJkjsXa?=
 =?us-ascii?Q?kFrYx9YWl69WeRFdxanmMVQJFfZRm8zVIhfhQSsNvR1cdX6SS0cRcbxOgJ1E?=
 =?us-ascii?Q?BrpCgVFsu1lm2NSNIGBGhH9pERTsCNFgtqQmN3OTfvnBiegHxKDTNu50cyqa?=
 =?us-ascii?Q?tmgZFBQoNUjb0/YTQSNAQuY/FOMTQar5k1gOS/FKzFVzQtNjWK2tMY0M6WQY?=
 =?us-ascii?Q?zwTENF9K01lXdwjOOvj8ivVCB7J88RzprHrKPzs6einXiPq8ag4xGdz6WX9j?=
 =?us-ascii?Q?5HzfTK+DeHF9t2TY7WI9YTdDbbiQN6C7qIZPOKm1AO9DVebV/9MDrbtm+Ocv?=
 =?us-ascii?Q?Zq2eo4UDG0E2adEiQ7R4aNJv/q7m7vu1NEb2WnQ3cfKr0RNCNTaUyEV43dCZ?=
 =?us-ascii?Q?MkVXX6IzQRQNVAKlN3GktD8YpSfKMcRo+wQxRpow6PoTx2rd5Jsn6Q3biLYr?=
 =?us-ascii?Q?L4og1Ejikdywqfwv9xO87dDfHM4PBamFO76BgTkrvVP0njWBjkFKAiFLOzO7?=
 =?us-ascii?Q?CG0PBFb+xWOdhu+6J4WrcPMmuxmGxp4Yu8CRofA8zNhtQ5MQXbF/GbqsYtVu?=
 =?us-ascii?Q?QWPHCb/NlWoHepbTz0GmEG090zO6gjpSvXkGplhp0Xsxj9BgMp+S5FGCC2Cu?=
 =?us-ascii?Q?OGyi6EDXYrwqrThoaJQbu2ATYYTpT7X05HKkuKKTOzae5lgbgOW9MKKco2ut?=
 =?us-ascii?Q?2Gv5ag9x2pq7wIFaqOgLoF/T62yMgulI3fWWybxtT2ycMOyHb2YLkRiIcg5C?=
 =?us-ascii?Q?k9tOND5CIVepd/4BMT+lW989ii3ErEm4ZQxdkqitR5Iis3QQiGsjDzlvVltq?=
 =?us-ascii?Q?oMNfAH3xG7FrIW2j0M2gCIu+1jtTOWt0r/P9dxIswUY1dkVrh5OqXN7VUWTe?=
 =?us-ascii?Q?kJj03CrwFxylfrICdqY9eWFhyj7XJ5Oby4xGGjhc5N6ngyZHDhkFlHESndDS?=
 =?us-ascii?Q?HrrINjEB7NhySWeay5bvygg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb8920ac-0b74-4506-45c1-08daa1c17506
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 02:22:28.9983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iVFpO698bQZKIkhkNxFgsGuJm1dSQrgMkBBOGRtR155Umr+dSRan/hnLFR3jUPPQ7AZ0Gm/cO1+hjizNLzkoBtaGRHa6R65Vd9+FpbYCAh37C0uxfeWt+pKEV9hCFttP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6913
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thanks for reviewing.=20
Please see my reply in-line.

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, 27 September, 2022 11:27 PM
> To: Zulkifli, Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>
> Cc: intel-wired-lan@osuosl.org; netdev@vger.kernel.org;
> davem@davemloft.net; kuba@kernel.org; edumazet@google.com; Gomes,
> Vinicius <vinicius.gomes@intel.com>; Gunasekaran, Aravindhan
> <aravindhan.gunasekaran@intel.com>; Ahmad Tarmizi, Noor Azura
> <noor.azura.ahmad.tarmizi@intel.com>
> Subject: Re: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP
> packets
>=20
> On Tue, Sep 27, 2022 at 09:06:52PM +0800, Muhammad Husaini Zulkifli
> wrote:
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
>=20
> Although this is not actually for PTP, you probably should Cc: the PTP
> maintainer for patches like this.

Thanks. Added Richard in the CC list.

>=20
> 	   Andrew
