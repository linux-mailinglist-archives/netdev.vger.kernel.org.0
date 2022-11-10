Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29551624CB5
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiKJVOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbiKJVOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:14:04 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4D559875;
        Thu, 10 Nov 2022 13:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668114842; x=1699650842;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UwuIBgTMSCcg2ZmvkWd832ADNBMA1WvLZt+bLqlHMfM=;
  b=as2fHsduvj8Uf1inI1P1EKxHLHDD4xmbYiBl2cYK/b0H+X2q5yslGZaQ
   /penSQileZ4yhhL2LzamNyZZk/XZvJ3r+M0h30n7lralCiA7rAAB0GiPk
   ey8tnwVIQLIGicsjTVsvcaxsOYiOChhziZQ1oGecpulEY0TDmZnjx3tJF
   QlxTY4iSv1hmZnREwW9mDDlf5iSEVVYh+eiyr30CoXK58WLAwao1M7XMU
   WfmK67XhF8JACCLV0fqDwZMXZb+cdijrqVd5I5rzOJpHuCqKeBDhRUtwS
   INAw7bDbFdN3hEw846aU8QzS/aS0GCqnNVaHsMFdn0WarbGHdqkUPyRlX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="397741861"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="397741861"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 13:14:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="882517046"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="882517046"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 10 Nov 2022 13:14:02 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 13:14:02 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 13:14:01 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 13:14:01 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 13:14:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWzOiTCqJtlnSGo01MqpYkEVBufjKcMDBqxfYWLfMkpDLYBlyJanqRlI6hW6AdxKqnOM0OeGkrHiKZZVmktVmCUJY4udRgcv2Fm0DHCRjiWP7jUndvuz8h4JU3sooUtgxAVNbMVaYATCWv4SkAJvfVNyCPhTO/RFlLrh0brWji0cTBYgIXcAPymMSeaKEGbfEJ53b3kHw/Ux5zmpt8Q6naoNUnWaJizIQPxUjKnAj68C7JKhHQKU7As4l0RXutdwDR0PPVdBdevRcPbJSbJCheyOr7YgTLh3euua8w9wlmaNtfSnWMSqpf2GYeZ75dRMV1YfFJSPeM5vq1t7Z7+evA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UwuIBgTMSCcg2ZmvkWd832ADNBMA1WvLZt+bLqlHMfM=;
 b=nya6waQcxgyqTqhbts1x1dHGVqt72dXMdmHi5V20rnMITn9eVNvqr0I/Gak0wbCTbTjaD4vxgeBihaX38Lb6J2nGCzFpMpRenJc2pMNnayvGY45JQgTD7v8oN83xzBJf4lMAmvfcLX/EHul1vm684TQBUeHPOJqqoC8D0r0hFUD6PdlOzq2V3wZLvFJNjv4EVUU5tA7gPVnAyl8omG3uUe//XOVNs5OQ7Lgk1ybu44Nvk3uNDdu/VO/uY8VasM3sj1OEfP3l47yGaCfgG3RIW8oRXguK6/kVWGJpIxvqIOcYcmA8b22U82lFqB0O/sTwEDFW4haDRAZjDrKp7uKLCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN9PR11MB5435.namprd11.prod.outlook.com (2603:10b6:408:100::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Thu, 10 Nov
 2022 21:13:56 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 21:13:56 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>,
        SlawomirX Laba <slawomirx.laba@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] iavf: Do not restart Tx queues after reset task
 failure
Thread-Topic: [PATCH net] iavf: Do not restart Tx queues after reset task
 failure
Thread-Index: AQHY81xt1U/+TsWFeEauMLnzqEhDea426S2AgAAeHmCAATnmgIAAJckAgAA3HgCAAAwHgIAAASmw
Date:   Thu, 10 Nov 2022 21:13:56 +0000
Message-ID: <CO1PR11MB50894F87FB9571AD4C2FF4A2D6019@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221108102502.2147389-1-ivecera@redhat.com>
 <Y2vvbwkvAIOdtZaA@unreal>
 <CO1PR11MB508996B0D00B5FE6187AF085D63E9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20221110155147.1a2c57f6@p1.luc.cera.cz> <Y20vtqd6raqg8iwy@unreal>
 <20221110122418.32414666@kernel.org> <Y21oCUjEHEMr9HGb@unreal>
In-Reply-To: <Y21oCUjEHEMr9HGb@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|BN9PR11MB5435:EE_
x-ms-office365-filtering-correlation-id: 8e7abdfa-6fa3-4048-ee82-08dac3607a85
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j4XOgcKRrSSbecD+v/ZcgB2ShZviWggaPp2CV82Wgra44xfte2vmdNw7I6m5G8jGiv7GRdtLUUIVbtWufdTxxrTwI9+AbZP8O3QWfQ+BPOrScnybTla095VB20E44mx/jQOsyQ5sJ4bB2Dju9WW1SXX55Z9iUu3ri+qjwbudF7I45XUh0D39UhmYK5quZDu47zkyM1sXGIwkHykUuf/dt6cnnMpKIrnSHb+WvxTrRFWk6SJd1Ch4XQLpSoZ52yV21YGnBArfIUBMGxw+dP8yU7cpdek3Ds1YCeyyZuN9XJOzEvN8V0CmxSw8tVznjnueNLqH5BHG3kYiFKVS2HvJ39dMQgRj0YxqE5tTiivqY2J5k129oCbMsr2SEH6idiWly8kXeEoi3IqcUoaxOoJUNu6T/2NihQhp7G6CgELhMk9bDWLwdkCcaxCEWUNh3g5Afo3EHWDMUesHa+G++NC+K4burP5/5KxxKpB15UNKUca4HCcU2JJrulTx6AHsBjQStWBWjjwzJSrIRl68MUKauNUMOSIRRAOEVzxtT4qbCGMXdboLtxIwRFDMin/hLFYHpKKTLNfXeieoHZNri3WF1KNfwIDnLKsXmFi7G+0Dhrm7MTwtG1jDVgNA/rkGuEruD9zdZH4wPlFzi3bSxvkqayqiCAtX/Uabfv9BYGYmjHDPRmfzfBK3k7PhHBZV7iHNPp0l01kR1CgGjMCas94y7RIgqqsKua5aQAnww5xB84QPqXGKlOeSPQTWE2dK2RfyRIlHCBVaRZM6GrKsxpap7MF0c09FW8K1T2/fBdCjcYo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199015)(41300700001)(55016003)(7696005)(6506007)(53546011)(316002)(38070700005)(33656002)(110136005)(86362001)(38100700002)(122000001)(76116006)(66556008)(4326008)(71200400001)(54906003)(9686003)(66446008)(64756008)(8676002)(66476007)(26005)(66946007)(82960400001)(52536014)(966005)(2906002)(186003)(8936002)(5660300002)(478600001)(7416002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ccfwCCE8OE4UEM30WqO/tbF2O3rl4LwVlKcLGAxWbenMpdQgzHjx6fL1rBAg?=
 =?us-ascii?Q?FGR8lHgDzDh6KZRCEbOCfFz9D0iWH/9pcpyn0J+9WsI/FSCf0JjkW2EmSQT2?=
 =?us-ascii?Q?jmgDD9Q6V6dfBQcp98Ed1fd2UcFQ9VGt14vBXYD+JKgdNcFFQYeI1fw/ZcD4?=
 =?us-ascii?Q?eX+zxad6Ew+jfoBd2plSy0ouZolmvEyXw/NJPKhyUD3h9W7AIjUlQmVSZkH9?=
 =?us-ascii?Q?YGYyRPexM8/5VvVlCamxuqyySXzXiaEuAoUV21M+wISXXO+j9DQWxPWGghAM?=
 =?us-ascii?Q?VYrRAkBdcxFku8+zKyvVayjB3zXeuuKDniDj5kZVsqsh5fAux7erJTlGnGz5?=
 =?us-ascii?Q?YkWCZvKZqERlu4LfQL+RmKyTLTkqZtfYsW+varIlynl6JcxKWF3jlq4KhQEI?=
 =?us-ascii?Q?if2yRX0vhRDCfPxExYpY9QOjAKluvgV9F8Aw/2ll6YNGj5DQau9suCy7uAbz?=
 =?us-ascii?Q?1gMAR+rGmujWj0PQv7LPSKFqIO/FQFgZJLejD4rWDK1RuO4WSAfNKdl/wVYn?=
 =?us-ascii?Q?NhNM1MxC1f8DadKeT2+aJzE7Mmh8BGVCB0EzP15IkwD772EzrJA8/mtS5jMw?=
 =?us-ascii?Q?a17mEACdCtoQCY+SLcZ+S0+WzB3S3VhnUdhwPhuLINFYiM/qbB/1qgxbUYJf?=
 =?us-ascii?Q?oL/IVT5VwQweRIaAxqk2nrkyxbRUEdKrwMkviTIYAZfWj/sRyW1geYIDHVpT?=
 =?us-ascii?Q?ALJq3j6YsNfs+i+lZMJAMLcW8iUOih7fy4HkALo8QOwoNpoXBfqa2tV7JHrw?=
 =?us-ascii?Q?dNdbChZEj75jjDLrs1a3TPOcRUu/rBvVb6UTuZOi2M0OQxBYYL/cJnqPpgMi?=
 =?us-ascii?Q?4srW0+mxvbCb3idNm+clfO8RXWJusygsq5d3L5Px94ey8ZokNArSkcTduTNT?=
 =?us-ascii?Q?nkfnC2k49z86+4/4W2c21IwRc4Fc8Qa3WGHsjTUtziPC66OTJWG9cvLjYWaq?=
 =?us-ascii?Q?MqvLx4k/NqXXXb12TbYf+YP7YyswFQfv/80ldumaMO07alKMjRsescr+tzZ5?=
 =?us-ascii?Q?GzeRtuOp3Cpzgn5Uwz2C7Cf82aXi+Aq8eqwKtA3ZKXB808sKxR78fRFdnitT?=
 =?us-ascii?Q?K+QN9MKhqW5vU3ldlrSxqcx4IiM7uZAlxqNarEnuzLHtbVN00rQHX21bTrbb?=
 =?us-ascii?Q?5EDdjr2+ar3F3SqovIaiAnU41cZ4v5c5GTynl3W+va8c7L6XEe3y1RxHEvMm?=
 =?us-ascii?Q?kBHPjmt7WGnHkMY7KZvTXVF2eO8K93oEfbvDVvoltYGSiG+muUGOaHq8Nwik?=
 =?us-ascii?Q?tInQDKH9n3CnsBZBHVMfySPZT+gAAolt7UWGqRSTUfrCbUBtNSg+i60zlNAK?=
 =?us-ascii?Q?fT82SpNWoCW9xkUedwO64VuQVCzIawT4TlmrtaqPq7tbR5oJujzALuzSWwfc?=
 =?us-ascii?Q?S/x263Z+8nCHAPU6vQIpX5bYXYjLtSZXqI1XWaEsynB0JK7XI/rtBymSqxbT?=
 =?us-ascii?Q?Xv7DbBSKwcOeARuErwc3foHvWFB5jGz0NO0QQP5yk73b91RkWHjkNZkd5H2K?=
 =?us-ascii?Q?2bSDmklCi+DKPKjHXiPDPRkMNQZwNAeza4B56AJuUfiQEO+lHKuqbVy4xFWz?=
 =?us-ascii?Q?uArWsZIqolYYk6ZyNkg2VSWMEpiFHil1RGB2cPB+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e7abdfa-6fa3-4048-ee82-08dac3607a85
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 21:13:56.5752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JeG4ae9iwmZXy6RFO38awoLiXk8O/lE0tW12zL/+3lOO8fzgGZAuaHw9QEBDAOMUUlE7UyX/wJSYW2xoBYvJHigtUvgWhQorbV6xrsnLgSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5435
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, November 10, 2022 1:07 PM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: ivecera <ivecera@redhat.com>; Keller, Jacob E <jacob.e.keller@intel.c=
om>;
> netdev@vger.kernel.org; sassmann@redhat.com; Piotrowski, Patryk
> <patryk.piotrowski@intel.com>; SlawomirX Laba <slawomirx.laba@intel.com>;
> Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Paolo Abeni <pabeni@redhat.com>; intel-
> wired-lan@lists.osuosl.org; open list <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH net] iavf: Do not restart Tx queues after reset task =
failure
>=20
> On Thu, Nov 10, 2022 at 12:24:18PM -0800, Jakub Kicinski wrote:
> > On Thu, 10 Nov 2022 19:07:02 +0200 Leon Romanovsky wrote:
> > > > > Yes I think you're right. A ton of people check it without the
> > > > > lock but I think thats not strictly safe. Is dev_close safe to
> > > > > call when netif_running is false? Why not just remove the check
> > > > > and always call dev_close then.
> > > >
> > > > Check for a bit value (like netif_runnning()) is much cheaper than
> > > > unconditionally taking global lock like RTNL.
> > >
> > > This cheap operation is racy and performed in non-performance
> > > critical path.
> >
> > To be clear - the rtnl_lock around the entire if is still racy
> > in the grand scheme of things, no? What's stopping someone from
> > bringing the device right back up after you drop the lock?
>=20

I think the reset flow uses netif_device_detach() to detach the device befo=
re reset. Is that enough to prevent other calls to dev_close outside the dr=
iver?

Also, perhaps we should avoid re-attaching the device if the reset fails...

> I want to believe what there is some sort of state machine that won't
> allow simple toggling of dev_close/dev_open. If it doesn't, rtnl_lock
> users should audit their code for possible toggling right after that
> lock is dropped.
>=20

I think the key is that normally dev_open and dev_close are done by iproute=
2 netlink messages? so if we close it, its possible userspace could immedia=
tely open it.. though I think that isn't allowed while the device is detach=
ed, so we should stay closed until we re-attach, at which point dev_open ca=
n fail by noticing the VF is disabled...


> Anyway, this discussion reminds me our devl_lock debate where we had
> completely opposite views if rtnl_lock model is the right one.
> https://lore.kernel.org/netdev/20211101073259.33406da3@kicinski-fedora-
> PC1C0HJN/
>=20
> Let's not start argue again, we had enough back then. :)
>=20
> Thanks
