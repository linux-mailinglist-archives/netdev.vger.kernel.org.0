Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110285AFF9F
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiIGIwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiIGIwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:52:02 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259EC80B7B;
        Wed,  7 Sep 2022 01:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662540721; x=1694076721;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FUVzQauveVLNN6UzUqN1dYP021IcslsE4JEaP24KE+U=;
  b=nXMWUndnVPPGvSVBw1KUugWQMChhKOElwUDZQmJ55eLKxYwDGjIISJ9L
   SGOCtd6uXYqBSM5PY45pdZhihUN06TGgcJWZE4dXJWUHDTz75YN9xT1Yz
   CYTUie5QIPMXC7ify9k92POIabo5gE+smGSyBXSGv+dr+e5ZWCjA4VMWe
   H76eYqOOxJC6uuAYm8vdcFt8vD0bQZdGK3ljyTv+KqGuEAD+kRwFDM0QY
   +0kMKHY1I6u81Boc1b9IBqf03JzmstpYR6Qd4cYWHrS55lCLnhI2pwPOQ
   KxrKXEzKE2b/838kUPzjUrRM/cMsF3LSP+AWnCgMHKbjx/u0/lzsGj0qQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="295553951"
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="295553951"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 01:51:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="859566477"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 07 Sep 2022 01:51:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Sep 2022 01:51:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 7 Sep 2022 01:51:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 7 Sep 2022 01:51:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzSBo0Cvz3qRgTWS+UAvxPPcFr6238mw8IFrpeGs6HSQa/uJ+F5fiGEd7YFArkElQNgBMARLVajmJCERbNrufgj7vc7qrv4ftuBg3fvCEsgyvng1zqjYu1qIK0WXx++v8FLyNL9aXxZxNO7/ZmvfwDEjy/HgWUGFDyQ4nh8mTDpiTsCOUGg5lU8Zd/MlBqKRwsy4I94hvPOpg+w2QeXHizEqWsdDfCv4/zxTu68tE3v8UkCgb3TmdVtjmOcWfFMOa6MmrJQ1+/HoNdmsUr2oLWtprNv+oLVeO4skyJXc2NWKrjWQYQOm/1Y/riph5dUYovX3FXhCZNOomtdE/bxnDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y30USWO5im+LzUb4gMALuTSd5FKe/BB7haAmaRFzNIo=;
 b=KQtmiGMFd3lEn/DbYUKjcOJc0Xh5lyyicfRFgjqVnoYf/4jfNoFfNujj4IPYIqPUv0+sbvEkL56z4/cFAZugVgno4Plpghx7iFNBK+LcV3lPodEVQqe4dFjBs8oBm8AyjBijvTBRILh7T7w6X1TFS0XnR0ykd06GHuT4DbE/19Qgj2Q1P/LJhkh/R68z8CFXoSZKtYohgbzXJwB8gHaDCQ0fXKF2fqmXOYnhiRvQWwMrgaqoSNRTi8eDH1pi7Mnfhg/eFq4gw8jBLZCGzOJWdYphMQi1H1JExKxhFW5ZdKogrT/qE4YUtCY1pXWVzuITedymiIcBsfDQ7yYsNjm8kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY4PR11MB1320.namprd11.prod.outlook.com (2603:10b6:903:2b::21)
 by BY5PR11MB4086.namprd11.prod.outlook.com (2603:10b6:a03:187::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 7 Sep
 2022 08:51:57 +0000
Received: from CY4PR11MB1320.namprd11.prod.outlook.com
 ([fe80::e0f0:b1f6:4bed:a539]) by CY4PR11MB1320.namprd11.prod.outlook.com
 ([fe80::e0f0:b1f6:4bed:a539%6]) with mapi id 15.20.5588.012; Wed, 7 Sep 2022
 08:51:56 +0000
From:   "Zhou, Jie2X" <jie2x.zhou@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "andrii@kernel.org" <andrii@kernel.org>,
        "mykolal@fb.com" <mykolal@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Philip" <philip.li@intel.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: Re: test ./tools/testing/selftests/bpf/test_offload.py failed
Thread-Topic: test ./tools/testing/selftests/bpf/test_offload.py failed
Thread-Index: AQHYwnlSjM265E4AkkyO/WHWFY8XLa3ThXiAgAAjUx4=
Date:   Wed, 7 Sep 2022 08:51:56 +0000
Message-ID: <CY4PR11MB1320E553043DC1D67B5E7D56C5419@CY4PR11MB1320.namprd11.prod.outlook.com>
References: <20220907051657.55597-1-jie2x.zhou@intel.com>
 <Yxg9r37w1Wg3mvxy@shredder>
In-Reply-To: <Yxg9r37w1Wg3mvxy@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31b4d23d-ccaf-4384-b3b5-08da90ae3810
x-ms-traffictypediagnostic: BY5PR11MB4086:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RpD4e1zVoKczrHnzJ2N7gKXlUJGiH9SLKrWM6LeL05i1+9kMiB4u4dxLEP0lHyX29CYjvH9COXk8Wcp7VKTFFX7SrG3pLkz5q3Wz/tZGCzQPT8//V9gK+vE7Sxiw3qAQpoZIVuX3xgqAV9E0CaF3dgvTrhMmLzCXjXxxfIAzG9J8qzdSDmZAGyxi/ivwogUCDqu/DSrUrQ0tGroQ4rglatq5dGwBh/EkPWll5PmYfEbO6NN2BMtkhj9F2Y8Py7hxycYTVE7g3Kaaxy9u/fFth9lyMeyITOumHRxRyz27Wi5w7HVCRO3dGuda9Iqhse/hD8s/sUnOx5sw2/WWH4GbazemZiaysomhaVAMN4NkC636uvKAq+ZjbLWRP3gIVqrWl6Suk3hGKykKUNUKwln/S3gzCf7nZixVLtDRoUdjhhAI3v+0LaDqgOFOZqWopQ+Dz4A5THwQV6bizvKQLFOA2jQlwJVjO9uAjpJxbiRgXlzl/388h6mgAD4RD5YEHYO8H5XH9mEgUC12Pjpe7KDx/M0FEqHoeEORizSrjHk98aScYnTU4unpbmoThOWbVDGDpqVHX36Y4ICj/6FquCvIWCVPvM5no2ga14k5k2MkBS4Hqwl9YyM9TDdtHF4mAaGgLm44UBBuSkgTuAMKq2Enwr4r/TOMg7WmGRih2ifNz+Zd7qqe6Q63n6jcg2Gnm0Rdm+qkx78tlEFrvyOq1KLY4yWJGbjU2kFYeRRvieL0AmUBwu0DbVHgU2u2K5vHKlU1kLbqL6oLe0//oFWL9z4vIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(136003)(376002)(396003)(346002)(5660300002)(8936002)(7416002)(52536014)(2906002)(38070700005)(38100700002)(122000001)(82960400001)(41300700001)(71200400001)(478600001)(53546011)(9686003)(26005)(7696005)(6506007)(316002)(6916009)(54906003)(76116006)(83380400001)(55016003)(66946007)(8676002)(4326008)(64756008)(66446008)(66476007)(66556008)(186003)(91956017)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/de/unqMViuhr1tHzoLnhXxDN4UCzXQlbQ0aHQZfLWiiDwKt+LlLBJf88+Ms?=
 =?us-ascii?Q?MON4RiQKqRSAqisUK8emZgvkBX5rYkP/HAhI9gG39QCl+ZM80TEK/eDVQrdY?=
 =?us-ascii?Q?j55YGaSoLsUMPZcgVT4Y8Zn0orUYk+J6R7W1hRpm81xO1FdfrvGw5mew3w70?=
 =?us-ascii?Q?tAsGFaj9zrTXPU95iiaNPIDSY02LvqSffGv02xZKriS0lQJi4PyfToDdJ7aU?=
 =?us-ascii?Q?eQbgnWFxizuBFTBekguAcsEX7EMLrcyQsbMlOTzY0fBdugBh2TvnjUmi+gQx?=
 =?us-ascii?Q?aY2ce9e8RQPtdXmSRZZclnKNvDmwPXhUICYqCoAmRf2LLAndHj9gbv2Txu1W?=
 =?us-ascii?Q?iQ4aI+HliaFFgxthDcOhaCtkEepQMM+CsUP6hUZlgj0EUl0N5LRpDh1Yktpg?=
 =?us-ascii?Q?BHNWR06GgJPzYp/Gq+T3arALZjAAd4W/AJQyDPZJdajaEcZkNBTMwTvjVfSz?=
 =?us-ascii?Q?rWJqcD/ur33nlUNQS+38AiUdZbeC8qAslFSC/vIszyof/n6yJtep7cHXmSlB?=
 =?us-ascii?Q?2r/4Fh0lNCEBBmFEidzfzWS30btNjuK3G28dKNPcqZioE5i3N2AcHowpMqP/?=
 =?us-ascii?Q?dmMKlliHq1hMZ0GxA8hc4GTSkE/bVOuFYKusQRyG2KKAqITMo+yXF9nQbIJ/?=
 =?us-ascii?Q?3Egi7AK0aDhlBpRsX4cbMTlDGtey1DzjBtL78peRVbnmL2tQSGTpyEfZuZMb?=
 =?us-ascii?Q?RWNP2Jfw1qEgl7R3pk7hxkVHWfxQ5YQqccDXKJNRAMFMfqu1MWqV9XegDVD7?=
 =?us-ascii?Q?zaFo6cTd1yIQEz2eVputFfMPHSxR91ZtzNOsBYKD+hn16e6ozUq3K2u6Ypty?=
 =?us-ascii?Q?h3coiJ95K5z0qPDC/DmyCGSQm/cbY2y3fNzGtXr1HPYH3qgyMo9DtEqT8cdU?=
 =?us-ascii?Q?o0LGqILikSLqXoY+kkRZjRGu0ge6zzB37Rt7XPfaFRHcv5Ov9UeqHz5iACTW?=
 =?us-ascii?Q?l5GtMk4UQgytCIVXbckoNbeUwfX64uRAOG27AZ28jmLYCwQY+DMQ1at7k7tW?=
 =?us-ascii?Q?UQv3SvWgqomaUGPIlO08w7AM0LgeO6Zh1QlwRRD585+JNC6PfPlDQ5NAbSdp?=
 =?us-ascii?Q?S38U0ISHeBj+VYXpDKTLB3SEhnFxH9F29vGf6ig9h23baEJOV8tg72r+uw0H?=
 =?us-ascii?Q?Ccsk/FH5S2XtDHNJxniLk8EnvfHz2pGC11Zj6k9CsfrPaLfADjEF0sCQzCwt?=
 =?us-ascii?Q?/a3o/+D56MGAvNB7l5e/fqFcFeMlBhZ33z0+xtjsFGrXhdT+DBeScIIKIz2R?=
 =?us-ascii?Q?4EahAE2tr8JovgPRyzMHLok5h+OEXtMaePNeChRN3+5lUVxtSdGG+gconl2s?=
 =?us-ascii?Q?NEg5vk/ZYuEDUSBBSHNts0SBXcGOevP4wwIC6Y7fGNN/B+7x05IlDJ5UpYBW?=
 =?us-ascii?Q?tB4VspjEN++5dOEg8/JE1+E7fGd6idKyCeEkHtrYYbhV8pxxodYCuR0K7FoK?=
 =?us-ascii?Q?MZKlufnX+zze0etYJYziI/cpGvUhAYeFo2Ux4rd5yYhGxRD6u90yNLkTglFj?=
 =?us-ascii?Q?7Hb3BAJGggfCt+hunQoXncFwboMXQ7qSnltEkJmm2y8VwOHZdd8ngH2z+yra?=
 =?us-ascii?Q?cGG8NNzucRgNMR0O379N0lZXWiaxEH2EXSq0BLnE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b4d23d-ccaf-4384-b3b5-08da90ae3810
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 08:51:56.5049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +1/nw3eSmnFsbdQqIEycDyLagWqojuV6Vd9bWdlVww6je0yNVDAQLrLjoOI+5VnOHYzsW2L3fxJEfcFBpN5NkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4086
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,

>Most likely a bug in netdevsim itself as it sets the mode of this file
>as "rw" instead of "w". The test actually knows to skip such files:
>Can you test the following patch?
Sorry, I want to confirm that have you ever run test_offload.py test?
What is the output of test_offload.py?

best regards,

________________________________________
From: Ido Schimmel <idosch@idosch.org>
Sent: Wednesday, September 7, 2022 2:43 PM
To: Zhou, Jie2X
Cc: andrii@kernel.org; mykolal@fb.com; ast@kernel.org; daniel@iogearbox.net=
; martin.lau@linux.dev; davem@davemloft.net; kuba@kernel.org; hawk@kernel.o=
rg; netdev@vger.kernel.org; bpf@vger.kernel.org; linux-kselftest@vger.kerne=
l.org; linux-kernel@vger.kernel.org; Li, Philip; petrm@nvidia.com
Subject: Re: test ./tools/testing/selftests/bpf/test_offload.py failed

On Wed, Sep 07, 2022 at 01:16:57PM +0800, Jie2x Zhou wrote:
> I found that "disable_ifindex" file do not set read function, so return -=
EINVAL when do read.
> Is it a bug in test_offload.py?

Most likely a bug in netdevsim itself as it sets the mode of this file
as "rw" instead of "w". The test actually knows to skip such files:

            p =3D os.path.join(path, f)
            if not os.stat(p).st_mode & stat.S_IRUSR:
                continue

Can you test the following patch?

diff --git a/drivers/net/netdevsim/hwstats.c b/drivers/net/netdevsim/hwstat=
s.c
index 605a38e16db0..0e58aa7f0374 100644
--- a/drivers/net/netdevsim/hwstats.c
+++ b/drivers/net/netdevsim/hwstats.c
@@ -433,11 +433,11 @@ int nsim_dev_hwstats_init(struct nsim_dev *nsim_dev)
                goto err_remove_hwstats_recursive;
        }

-       debugfs_create_file("enable_ifindex", 0600, hwstats->l3_ddir, hwsta=
ts,
+       debugfs_create_file("enable_ifindex", 0200, hwstats->l3_ddir, hwsta=
ts,
                            &nsim_dev_hwstats_l3_enable_fops.fops);
-       debugfs_create_file("disable_ifindex", 0600, hwstats->l3_ddir, hwst=
ats,
+       debugfs_create_file("disable_ifindex", 0200, hwstats->l3_ddir, hwst=
ats,
                            &nsim_dev_hwstats_l3_disable_fops.fops);
-       debugfs_create_file("fail_next_enable", 0600, hwstats->l3_ddir, hws=
tats,
+       debugfs_create_file("fail_next_enable", 0200, hwstats->l3_ddir, hws=
tats,
                            &nsim_dev_hwstats_l3_fail_fops.fops);

        INIT_DELAYED_WORK(&hwstats->traffic_dw,

>
> test output:
>  selftests: bpf: test_offload.py
>  Test destruction of generic XDP...
> ......
>      raise Exception("Command failed: %s\n%s" % (proc.args, stderr))
>  Exception: Command failed: cat /sys/kernel/debug/netdevsim/netdevsim0//p=
orts/0/dev/hwstats/l3/disable_ifindex
>
>  cat: /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/hwstats/l3/disa=
ble_ifindex: Invalid argument
>  not ok 20 selftests: bpf: test_offload.py # exit=3D1
