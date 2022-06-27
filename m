Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891B155C83B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbiF0LiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236503AbiF0Lhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:37:36 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C074288
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 04:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656329611; x=1687865611;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8SThV3Jp59C9/KdBCPlWEcbbixvJ14/c5KesKoHpdCI=;
  b=LVBgA+O7UuQtN/kR45+biKBvqrUOSwx56WAyJnjcQU+EMFtZSZ5fNLmB
   LfvwpB5FrWr7logpLd4+oZYAs6emnfISvPkRj5fjUA6jIJebgXZsjIIjE
   V4lb6oSnNRVZf5sL6HgPJh5kg+hZrdVUDxa3lFljwOyxSwvzKWEw+nfhG
   kAmlG2OgpYBaE4XJKw3dN07ESYdZCJMeiWIkqqP+TjoJUhXbOP4KYFi++
   1Q2ZWNtx//3gkSGv8vJUHKdov8ikIOlmPaD9y5dqnD6ARZ9Wc6lYnNACA
   0iJhTZwY5Vi/++z4we3pmY9qfaotybVUtdhYCDekUV9mfqXg/djhM19LV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="261234702"
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="261234702"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 04:33:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="594271793"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga007.fm.intel.com with ESMTP; 27 Jun 2022 04:33:30 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 27 Jun 2022 04:33:30 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 27 Jun 2022 04:33:30 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 27 Jun 2022 04:33:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8NHrAmmwzqpDcqqIXFV/d2mMgDQc3sF2xxdYxANxh35hHBxFdxlNIYbXTMySq1xpG0iSMc5juxTf1DyB/WhPVsIZZLsPmG7Iw6GQpNnxWDKx/M4xiKvyf3TqoJgJoaOHJLrfY4UDVtTMghPsfK1N50O34xJYCJbxTMlAAAcc+f81/CKfGTXLhQ3SURrNZjhbLDuVB+UNHYvrS3Uco4rDZT5M/41pmDwq0yctnqjWbU9P2Qr1u8Gjhydp1kAPgZdYiDAT6CkKX0F98lQ2jbiBjRSN08p5wowoeZyJMSoXyUdk6FsSuWs3Tn178ZxpEcW8Psee8Lz+0SAuwoWYFCQVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUeaDQHIVWzFCxYejhozECaovZkuAiuF/T5BgYl4BiU=;
 b=U1GszKk1cnxglwN+XOEE4go87HahpT5hRwbQa/JHe4CT6T1lR5Tj4jaC49+uyespAly0E2wccBvOLwyddR0sGLXaCS27Xjtv0ONCZRJmuifQ3OKOzNpk+PiQVWn1d23NgCw/tBUt9G/K50y70/A6doJfBpGwWrgEY5w7t1ORoGJPkonIuV0sACS5CeR5fzNgNTAVljiy4+vXVC8XyVw4SCqXH5WP2Qy3cRA5ctC3+4V0/pc43vr//hjWpT1rEAhfYkD0OS01cZKgHtqUbODKvxa+lt2fCjNiFQ1y7tXWTRc9/5wmcx8JH/xtqkDBwhP5WzEZ7FqI3QCEVUpRwGHFjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by CY5PR11MB6320.namprd11.prod.outlook.com (2603:10b6:930:3c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Mon, 27 Jun
 2022 11:33:23 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c%3]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 11:33:23 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "boris.sukholitko@broadcom.com" <boris.sukholitko@broadcom.com>,
        "elic@nvidia.com" <elic@nvidia.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "paulb@nvidia.com" <paulb@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "komachi.yoshiki@gmail.com" <komachi.yoshiki@gmail.com>,
        "zhangkaiheb@126.com" <zhangkaiheb@126.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>
Subject: RE: [RFC PATCH net-next 1/4] flow_dissector: Add PPPoE dissectors
Thread-Topic: [RFC PATCH net-next 1/4] flow_dissector: Add PPPoE dissectors
Thread-Index: AQHYh9BDElYAHuMNC0u6wODYDa8kZa1epuwAgAR7ngA=
Date:   Mon, 27 Jun 2022 11:33:23 +0000
Message-ID: <MW4PR11MB5776A0CCC369B018536F47C2FDB99@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220624134134.13605-1-marcin.szycik@linux.intel.com>
 <20220624134134.13605-2-marcin.szycik@linux.intel.com>
 <20220624150126.2386014-1-alexandr.lobakin@intel.com>
In-Reply-To: <20220624150126.2386014-1-alexandr.lobakin@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 559e29fc-cc6b-49e3-1ceb-08da5830d822
x-ms-traffictypediagnostic: CY5PR11MB6320:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m9UOZcp9lifiOUIG0YBqjfsIwmIGKVvzDIYJD8ndtUZwafypEZXohrKG7DYerOGkmyBITWV1gXsE6WfHkr2BksoknJRYEvbbM2DZuXd3EzLLsRiC+7RRP40pnvrIVzaPEtikaZqWPmV6MfKF190scaWcyaR5fsglKqv8n9zqXxxpefbArQIC+GotQHiSxsqSrSHMOzq/eVEzS7/v1/jW/TP+w3/ZqEYPrFJOExWf33FpVxSgTsfj3ponNQjydl3cpwbxwuodLtVWPXz+surjSFOFRHLN9ey28+Pb6G3gtYCg+RsVl6HGrdSk8/uREPlEcTCIX1hh+mjIwWleJYC5EhqkJWOP8ZcDqSw1RMNBLAa32WZqKAUL55M32ZsSxeQkvkrUO3UDr9Z2qNlRja8Q9oO7GlW1Vl7W3zgp2X9v/O/B/Vf0ZPGTczt4NDlnSVQP0xClxN8heHTlc76gsvUq8y/oWB2rB6FDcXQckQHO7AzLo6gw+OBiAdSfg6E1LdH5aVtZbsFB8XWA+WVfHW0NaSwUnqa0TCGjAYgqi1qGof8Xy9H4G34+NyWUikVmZjJDU34PSl2PNPDZDvl128rxonIwfgNO4RA6PwZevodRGxDlj6Jaga8hsScB6Io7E011PqKKU1RbPKO3CmU7LcwXpYFsiKExwUZmVbfaDn6vPxBS4plPsMgb44uFlht1k6FCoEWjuW1YR3nvzbdkHFtqG2ZHbJNLMFN9l2mQHkk6b2TvoYRv8MYJrKaiKYyu+zxZHViA7wVPp4eLshvZ2Nzqlvkorqs/KQCBm4UAOBWQ3UY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(39860400002)(376002)(366004)(346002)(55016003)(2906002)(53546011)(86362001)(7416002)(7696005)(8676002)(64756008)(4326008)(54906003)(66556008)(38100700002)(66574015)(66946007)(33656002)(8936002)(6506007)(76116006)(316002)(110136005)(478600001)(66476007)(38070700005)(186003)(83380400001)(71200400001)(26005)(52536014)(66446008)(41300700001)(82960400001)(122000001)(5660300002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?/24/0mhIgmUMQpZ0dX9tmmW/ZF7DPnDKogZu2jPBiPDkbr+EMpM+mbwjvZ?=
 =?iso-8859-2?Q?ZgicdJxqkX8BIJy1Rk4IyTybHSNGKHILJgPd5KmjNekKw4RKLilvsBAsK2?=
 =?iso-8859-2?Q?03naChNEi/un/W/cGUNY9kxCjvZr/tngn0mSU+1uZU6CYErG5SVVWAwozd?=
 =?iso-8859-2?Q?3OxaV3BpglblhLYqhl44taTBo4KWKCbCqdwZvw8YmNmB0xQUTVJaanajdu?=
 =?iso-8859-2?Q?F3AjkMB5elGj3/2uIpNGthniuuS+BOajpxNrVnFR78swZe4VTGJyx4VmR4?=
 =?iso-8859-2?Q?N23BzOqEvGB89hDDmkdLgvzKHADJcb7+FEWBC+EkuuPPuZfcwZs5/hcs5F?=
 =?iso-8859-2?Q?mzMylwXpQaXmYrnJoYZ1AQuaykG0WoehF6jJ2iMX+i1eVf4JF2prCLgFio?=
 =?iso-8859-2?Q?Xay9EC5m46woiNitSu2DOkNJFaon7xcfskySImJYoxPssKzed0cYzbK40C?=
 =?iso-8859-2?Q?yei9UJOtq9cjczUIWztU82KyVcrj8WSZrNQImtm9JjzEQ0usRde+G96J3Y?=
 =?iso-8859-2?Q?dSqZrhoYndTAizNNLAt5iMhhzVe4ctPcbVcRav/wOamRpyhzD8iegGcjXL?=
 =?iso-8859-2?Q?PoZG4VeqQEgs+zywZ26CZUg/Q7oQ4KABMOgkRknC00skQv7Pb7FBTXuQr+?=
 =?iso-8859-2?Q?/2dcr7klRlCaPTkhY5fSrAJkJPsPYrCNK9qdjxZQXNADdA5LM0OnS0xqG0?=
 =?iso-8859-2?Q?C75bD2HvLcSE8LUNAVYHxayO/sCv69bF6fWYcwnwO19z+eI978j9DyXiNX?=
 =?iso-8859-2?Q?0MW6/rEqXamP1Rdv9b3DzZB+BKI6mldTd6ZtXGwk75kabTrEHRx1ujSgsF?=
 =?iso-8859-2?Q?6QNtj4C+pDNhgWzVFz4QrwKOJm80DsaTL6PC9gQQDfx4NoPXgLrnzLRr3Y?=
 =?iso-8859-2?Q?I9OOsL1OaAb0gJKHQ9p/3krNSd3i9Ud1eALTsMhI4pNunau0+ZKmTZz4kX?=
 =?iso-8859-2?Q?ySbL2c067UhF8mWqswzshukBz4cYQsi6qAQftU6aIp3Xwm9rlKnizzrfdI?=
 =?iso-8859-2?Q?Cwfrrf/R3MmieSFDCnXgyKsjv039RNG9C5f4by45t3ZX+bjY8hHqDtUhn4?=
 =?iso-8859-2?Q?YB8fAOON2DFP2ogkEE4YiRCbN3ersnl/R9TOdbjjVJ22V1oMnIgMoESUMU?=
 =?iso-8859-2?Q?kG7sQFpGSkkT2fAY6xo6UOAK/E82k74qmktZxOoiBACTBsj4KGSgxV9//c?=
 =?iso-8859-2?Q?x6q/ayKd011pGNptpOEA8H0gMoJlVeGqwzBojK/VfkO+DtNpIfmnjm13Wm?=
 =?iso-8859-2?Q?lkPc/6b2/mvFTTY08lAtVDzFg7yn1ls7jQ4cuUG2YZ7LRNpqOkE3/aNStC?=
 =?iso-8859-2?Q?F0YQHXXY0yL1RToJv/lGnRwuMruSagASq5MJYgSRZFqSBwA5Irw55YDqvr?=
 =?iso-8859-2?Q?QJUQnjbwDDTwUyf+gHPqd5QMbOszLd0fBAbIcsJ7Hdpd8SmxqedP7WoRVD?=
 =?iso-8859-2?Q?T4drj+Ac6UiFtGkY2CueU1JzImFBGNi0Dr6WINdoSseI6N8slef1bmDzxG?=
 =?iso-8859-2?Q?yTQiYRfdeSm+vRNIr8KNnxIqsNbLs4p38UkmSF8ObnSFze2EzvHIDMujug?=
 =?iso-8859-2?Q?uc/Vonsa0z7BLmwYzOoiwnZMhk1Kw2io9TWCbgbYkeT4NuC5xLDLF48xKV?=
 =?iso-8859-2?Q?pZRz8p0hkw5rV+Lh4cfbDRLfIULSn85nnH?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 559e29fc-cc6b-49e3-1ceb-08da5830d822
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2022 11:33:23.3822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LkoZFjvNApUmPJ9byIgGV7JIKyLx4DB5ZmhPEYGJsbYarwZ5FtOFqnP8OXziU0kimSJkboNIV166gExJoOo25tFrrtE2eBhJtu5JkO336vk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6320
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Lobakin, Alexandr <alexandr.lobakin@intel.com>
> Sent: pi=B1tek, 24 czerwca 2022 17:01
> To: Marcin Szycik <marcin.szycik@linux.intel.com>
> Cc: Lobakin, Alexandr <alexandr.lobakin@intel.com>; netdev@vger.kernel.or=
g; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> davem@davemloft.net; xiyou.wangcong@gmail.com; Brandeburg, Jesse <jesse.b=
randeburg@intel.com>; gustavoars@kernel.org;
> baowen.zheng@corigine.com; boris.sukholitko@broadcom.com; elic@nvidia.com=
; edumazet@google.com; kuba@kernel.org;
> jhs@mojatatu.com; jiri@resnulli.us; kurt@linutronix.de; pablo@netfilter.o=
rg; pabeni@redhat.com; paulb@nvidia.com;
> simon.horman@corigine.com; komachi.yoshiki@gmail.com; zhangkaiheb@126.com=
; intel-wired-lan@lists.osuosl.org;
> michal.swiatkowski@linux.intel.com; Drewek, Wojciech <wojciech.drewek@int=
el.com>
> Subject: Re: [RFC PATCH net-next 1/4] flow_dissector: Add PPPoE dissector=
s
>=20
> From: Marcin Szycik <marcin.szycik@linux.intel.com>
> Date: Fri, 24 Jun 2022 15:41:31 +0200
>=20
> > From: Wojciech Drewek <wojciech.drewek@intel.com>
> >
> > Allow to dissect PPPoE specific fields which are:
> > - session ID (16 bits)
> > - ppp protocol (16 bits)
> >
> > The goal is to make the following TC command possible:
> >
> >   # tc filter add dev ens6f0 ingress prio 1 protocol ppp_ses \
> >       flower \
> >         pppoe_sid 12 \
> >         ppp_proto ip \
> >       action drop
> >
> > Note that only PPPoE Session is supported.
> >
> > Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> > ---
> >  include/net/flow_dissector.h | 11 ++++++++
> >  net/core/flow_dissector.c    | 51 +++++++++++++++++++++++++++++++-----
> >  2 files changed, 56 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.=
h
> > index a4c6057c7097..8ff40c7c3f1c 100644
> > --- a/include/net/flow_dissector.h
> > +++ b/include/net/flow_dissector.h
> > @@ -261,6 +261,16 @@ struct flow_dissector_key_num_of_vlans {
> >  	u8 num_of_vlans;
> >  };
> >
> > +/**
> > + * struct flow_dissector_key_pppoe:
> > + * @session_id: pppoe session id
> > + * @ppp_proto: ppp protocol
> > + */
> > +struct flow_dissector_key_pppoe {
> > +	u16 session_id;
> > +	__be16 ppp_proto;
> > +};
> > +
> >  enum flow_dissector_key_id {
> >  	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
> >  	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
> > @@ -291,6 +301,7 @@ enum flow_dissector_key_id {
> >  	FLOW_DISSECTOR_KEY_CT, /* struct flow_dissector_key_ct */
> >  	FLOW_DISSECTOR_KEY_HASH, /* struct flow_dissector_key_hash */
> >  	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_=
vlans */
> > +	FLOW_DISSECTOR_KEY_PPPOE,  /* struct flow_dissector_key_pppoe */
> >
> >  	FLOW_DISSECTOR_KEY_MAX,
> >  };
> > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > index 6aee04f75e3e..41933905f90b 100644
> > --- a/net/core/flow_dissector.c
> > +++ b/net/core/flow_dissector.c
> > @@ -895,6 +895,35 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struc=
t bpf_flow_dissector *ctx,
> >  	return result =3D=3D BPF_OK;
> >  }
> >
> > +static bool is_ppp_proto_supported(__be16 proto)
> > +{
> > +	switch (proto) {
> > +	case htons(PPP_AT):
> > +	case htons(PPP_IPX):
> > +	case htons(PPP_VJC_COMP):
> > +	case htons(PPP_VJC_UNCOMP):
> > +	case htons(PPP_MP):
> > +	case htons(PPP_COMPFRAG):
> > +	case htons(PPP_COMP):
> > +	case htons(PPP_MPLS_UC):
> > +	case htons(PPP_MPLS_MC):
> > +	case htons(PPP_IPCP):
> > +	case htons(PPP_ATCP):
> > +	case htons(PPP_IPXCP):
> > +	case htons(PPP_IPV6CP):
> > +	case htons(PPP_CCPFRAG):
> > +	case htons(PPP_MPLSCP):
> > +	case htons(PPP_LCP):
> > +	case htons(PPP_PAP):
> > +	case htons(PPP_LQR):
> > +	case htons(PPP_CHAP):
> > +	case htons(PPP_CBCP):
> > +		return true;
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +
> >  /**
> >   * __skb_flow_dissect - extract the flow_keys struct and return it
> >   * @net: associated network namespace, derived from @skb if NULL
> > @@ -1221,19 +1250,29 @@ bool __skb_flow_dissect(const struct net *net,
> >  		}
> >
> >  		nhoff +=3D PPPOE_SES_HLEN;
> > -		switch (hdr->proto) {
> > -		case htons(PPP_IP):
> > +		if (hdr->proto =3D=3D htons(PPP_IP)) {
> >  			proto =3D htons(ETH_P_IP);
> >  			fdret =3D FLOW_DISSECT_RET_PROTO_AGAIN;
> > -			break;
> > -		case htons(PPP_IPV6):
> > +		} else if (hdr->proto =3D=3D htons(PPP_IPV6)) {
> >  			proto =3D htons(ETH_P_IPV6);
> >  			fdret =3D FLOW_DISSECT_RET_PROTO_AGAIN;
> > -			break;
> > -		default:
>=20
> Oh, sorry for missing this previously. This switch -> if-else
> conversion looks redundant.
> You can add `if (is_ppp_proto_supported()) GOOD; else BAD` to the
> `default` label without modifying the rest of code (to skip the
> actual dissecting block you can add a condition there that @fdret
> must not equal BAD).

I could leave switch case statement but IMHO converting to
if else statement is cleaner then adding new if after switch case
in order to skip dissecting block.

>=20
> > +		} else if (is_ppp_proto_supported(hdr->proto)) {
> > +			fdret =3D FLOW_DISSECT_RET_OUT_GOOD;
> > +		} else {
> >  			fdret =3D FLOW_DISSECT_RET_OUT_BAD;
> >  			break;
> >  		}
> > +
> > +		if (dissector_uses_key(flow_dissector,
> > +				       FLOW_DISSECTOR_KEY_PPPOE)) {
> > +			struct flow_dissector_key_pppoe *key_pppoe;
> > +
> > +			key_pppoe =3D skb_flow_dissector_target(flow_dissector,
> > +							      FLOW_DISSECTOR_KEY_PPPOE,
> > +							      target_container);
> > +			key_pppoe->session_id =3D ntohs(hdr->hdr.sid);
> > +			key_pppoe->ppp_proto =3D hdr->proto;
> > +		}
> >  		break;
> >  	}
> >  	case htons(ETH_P_TIPC): {
> > --
> > 2.35.1
>=20
> Thanks,
> Olek
