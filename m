Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84BE86E7B4E
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbjDSNx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjDSNx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:53:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE08B8;
        Wed, 19 Apr 2023 06:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681912435; x=1713448435;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mIyuo8LNYEU7tDm/PYJ6UsW2ZjRNE4S3XeX7SAmNkZw=;
  b=J1XwrQokZ3fa1bSFesnGCX8eYq9fZ/1xuZWmd2dB3gqiJwGoYU3d5bZn
   ARQ1mhCG14DG1k+UML/xD6m9xaTUuKsy2ubZYW0RElrWRHKPS6/jI4ADh
   JAGFzbyWS/Xx/SDnfWdiYqgkGvxdMwbe501Do1b9WqbJvHRYMzjp53ZRm
   BXXkJ2o/Duw7+/4kXXikemz+0DTnjCEqHIhxB6bHB+vbbctfyoxgx1MUj
   qQnbCnl9XMbwY/SYJaHJRa81WQY7aZOn9GxmBDJBW7gRR0RyE1bb9K6mP
   Eetdfs3WgJMlK3xa4WNlv/sLgK9NQPqAOS2wgtmT0gAw37Py7JOHNF9rC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="345454522"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="345454522"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 06:53:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="780866720"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="780866720"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Apr 2023 06:53:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 06:53:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 19 Apr 2023 06:53:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 19 Apr 2023 06:53:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqsjNsyVGuGfGVwqYSsWAXFYzGmx+TCYipizIqd+/MgjNiS+UFV7DQ/PnJVdxDeElKFQZGOE3dFZQ6mPLjktxRGLAJujG/Q1q36aMrOy2XzOd8QjMaNPS7oCCOib4WwwcL2Zu5Om/Q1LgSn4avenC7IWu8yUZyFjSZtMUs0Nn2cf2MhmM5/1E3V3lCfoCFPdg3DvT2E+zC3doczWTRsMzYEiusz5j13lOXapgvhnHGgW/N1WU4j37jyocSrp+K8Qc1avTw86L+SKdzeE+N8OWB494P7bevyLDiynXv0XHHEfEJGdC8lIaEG9udNnzudO3FVm6HJpwh/gKh7VpxhxYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rjaw2qWmZA1u4298EavCf3da/Wa162uD00CgFE+wTeU=;
 b=N9rFMqH3fgZy9sebJtNwb38iGDfe7C3KNtTzzsZ2gWfbSe/Z2PwXFRc9843lS1HKdQATc2/vPi2Kzt9FW5ZmOWqnJOH3l/5dqzQkQbnTUletgNhAAIJkCQw/jXpgmZUKpZeKhFwBcGCa95v/IjKjVZjn05OrEgr++oVbb+r1zjGhJQzsjp9MA9SJqk6kvZ0daKIOyFpVq7rCbk4iEmbQ01//2eW3BYA6woxnFtcOSTyJYCGgmcVRqBqJ5oAdcHGRJWZappyrvRLGZUIEGASeFEqs9HVVw4uiwuKfWfa6SRw7wVSdOnU3ULudDqBbiaRhU5P3OjDOR0BO27++W+k89Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by BN9PR11MB5482.namprd11.prod.outlook.com (2603:10b6:408:103::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 13:53:51 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::5308:89ef:79f:35f7]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::5308:89ef:79f:35f7%8]) with mapi id 15.20.6298.045; Wed, 19 Apr 2023
 13:53:51 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Ruting Zhang <u202112078@hust.edu.cn>,
        linuxwwan <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     "hust-os-kernel-patches@googlegroups.com" 
        <hust-os-kernel-patches@googlegroups.com>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: wwan: iosm: fix a resource leak in probe
Thread-Topic: [PATCH] net: wwan: iosm: fix a resource leak in probe
Thread-Index: AQHZcckfOuYLABRYjUSFfguu+GlGKa8ypogA
Date:   Wed, 19 Apr 2023 13:53:50 +0000
Message-ID: <SJ0PR11MB50087AB2A36558365343EBC1D7629@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20230418073858.36507-1-u202112078@hust.edu.cn>
In-Reply-To: <20230418073858.36507-1-u202112078@hust.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5008:EE_|BN9PR11MB5482:EE_
x-ms-office365-filtering-correlation-id: 85405b3c-d079-45ac-368b-08db40dd819d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FZjTjzxGT1l7MgNL2na9phdvBrNa7QAYav+vRgl4uISUk9xv/+AAGHHitVHLHLQvMgFxm3EQtWqu6BjSWjSlzOVsZqMH8qxoe7/0xg7walI2XHUGn1iN/mZMjcxxgQ9TOjPb+uxVDfknS+tyZEm8H1c9iDEuGY/8d+YIoHbPOhZFAIarOw1iIy05kfy57pMQ+2MzjyPfwyD459PzAqVheo+wXgGjfe/z57URpg262TKRc0vgf18tneYDcG35Fz4ZImcvULs5N39qCVAtQP3iGtSykSb4LalU1DzX3lpTDZ2j4Jn2G85zE5fb/oMGm0pr8V/NPCbRoofpxRQPMK49VBm5Y8f45MNLHB2suzRcJ5YZjJ4ezTlUHZSS+2ZVZZwL7RN9LAtwzhOd5irzZnoCXfWVmtAOG+lEQEDMTgYM4A/kwBvbMMAWmGnaxDz1SiPvfBWew5uzs5JNlAmwuu4oEDyq3DsW3c0uvmT03TipFVQ0TpvLYTNvanXPAx3+s/osCUyJjXNEFQkvc8AROrIUTBUdREpaspzzSzyrgGWU3XSGTZKKB2Iwo4CJHmVJkIkA1k4LzjVs4jjsUsrSN40xs7zhQPFBx/G+gI2Fa9k4myE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199021)(55016003)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(4326008)(478600001)(110136005)(316002)(54906003)(8936002)(8676002)(5660300002)(52536014)(7416002)(41300700001)(122000001)(82960400001)(38100700002)(186003)(53546011)(83380400001)(9686003)(7696005)(71200400001)(6506007)(26005)(966005)(33656002)(86362001)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F2ygx7wH3QXIJb0B+nNk5Ba0L7y65Bts2S1wkIpSYOa6G8OewM7yc6zq3aQg?=
 =?us-ascii?Q?MaybcnAJQOgn48xYtWvMAVO+3VgYf6h7W0Jj+c0Xcn+S23KB2x6H2di1x6hB?=
 =?us-ascii?Q?7m//RfGyJx/WWzIyObx6HYobC6m5/Z4MfmPCW/q9wEbPWWiI/aFJAl2taATy?=
 =?us-ascii?Q?wJNKBRCqd+zh90XqsLIKIHK+cPXwm+TZydGkKUwPKoD7btjB8RkCJxq+Z/oC?=
 =?us-ascii?Q?IsqGafGpCqRmagjrGMChJG0ebuCTHQ6WvouE7nynDqT6wU6rRFHCwI6rdb56?=
 =?us-ascii?Q?IV3NIIUtk5xqJ1FomqIF1ZybRkupr/Xhj8mgKbrlNLVN+N6NtH2gvuq986ZB?=
 =?us-ascii?Q?2hcfS7cO7xq6HvUlsAn/ZN2sVv9Icj7c0Uk5wSUlh92naA3E6YxE/Ivu/4Pv?=
 =?us-ascii?Q?GYp+tYXVaBDDgja/zQqGLjMT5/fdrzuRAmJ7tnl93M2KykWR7gEZax35IbiP?=
 =?us-ascii?Q?06z3htjuz6i1+4PD7ijoi2Zd7H9wrSrhBmFTRgCzgjtIEhTXpF7AMk2iMxbi?=
 =?us-ascii?Q?WDEKtCeY0kEAzlekD2b7kc9bdZiJ8AAzHaVDPmDxO+0pORCqeLKGdO0SZQph?=
 =?us-ascii?Q?FZHzQHGfm7k+YY17ONIEV55UZrUQ3RIxpiwgHgp+85OY62F7X6jw/xwXo1QT?=
 =?us-ascii?Q?cRL0ZIoy3qR5VOH3IQXA+nSh+BB29CSCIfcsw60FoHI8YVYvEWC2VWGdnqba?=
 =?us-ascii?Q?5EQaXuWWqdusjFZInKbc5sQBHJeencxWEWsFB6oVr/iXmMNLJt5T+hqEDztD?=
 =?us-ascii?Q?PeVoTM88i99idyWTwXzfL2uO8Q4UR9jzFtRoQlTrtGkGxaaybqAhmmrd+d0Y?=
 =?us-ascii?Q?ABPslF9+jBEdI7aecNSvOr3jlhJBBvjrXzTrWEyjr36lDBK6EFBt86RHZrdo?=
 =?us-ascii?Q?TLX4hxsIn3CUDxWCPMmnaeNrQj46saoLFvQTkVHs95BTgWMXevluA/0qqUhN?=
 =?us-ascii?Q?p0HairaH7/LbkVF91qk7TI5PFWxNo0AXYRzvV5FrBJyXOd5lF26od1AsmQ87?=
 =?us-ascii?Q?kMbDSHUI+LTDTkAQBF3JFH6oP1LXbl3+7+m63d3HU7XrMSt/psUEmBGtaHNO?=
 =?us-ascii?Q?le4r0zMPQP6Xv4BaeV4sAu7ulcjd+lwJ/pThFsfyLPc7zzeVRg6t7/IZXXnU?=
 =?us-ascii?Q?hodJt60UKuqi6F+poyqIi6//jEjR8HCkeknU4/B8O/cBoLO3mZBnJBc3b7jZ?=
 =?us-ascii?Q?SenaRAN3JFqd3yaN3pRAG+7rziWtNRfSGslQJO+kwpehiM2+MusArrjZC9ST?=
 =?us-ascii?Q?tRlTmSUUBwgJ/4EMTTxMd8ONS5UUlF04l+iQBEFh3I/m5AaG6TXj19fViG4q?=
 =?us-ascii?Q?wsAy8DPXy+bBMTyj/tvhHcHOIVqMZ06B1OhRRkid6jvToirp+yH1XCNwRw/T?=
 =?us-ascii?Q?35vQClz3/1ApNNyh8g0HVZKEq0NEtzG1xah0GGGsyoIn1J5Kq7N697ADCmFj?=
 =?us-ascii?Q?wzAYysUii0/YRzG7ZbgExNz7Jp9kaqArDDpWJYMr9yvddzr0Owf4y1GvU+dn?=
 =?us-ascii?Q?nc8Gi9IDZnFXFxm3vdrnBwBgE7akAOv2QwzA45eldAc/b211ZDPZ6AadupI+?=
 =?us-ascii?Q?kdCrGlIl5DAHVQrhKUggaSDamdX7V29VZiDMAI+S?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85405b3c-d079-45ac-368b-08db40dd819d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2023 13:53:50.9416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FZOtC9w9wsLaOMhWSpi0CApREr3S0u3+7VeUgPZIsLhsQduprTQa9MRE4MngUWW8EuXvgaq7Vf8pye+HmRR+Bcgcye2zixT2IRqvmsAl9mE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5482
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ruting Zhang <u202112078@hust.edu.cn>
> Sent: Tuesday, April 18, 2023 1:09 PM
> To: Kumar, M Chetan <m.chetan.kumar@intel.com>; linuxwwan
> <linuxwwan@intel.com>; Loic Poulain <loic.poulain@linaro.org>; Sergey
> Ryazanov <ryazanov.s.a@gmail.com>; Johannes Berg
> <johannes@sipsolutions.net>; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>
> Cc: hust-os-kernel-patches@googlegroups.com; Ruting Zhang
> <u202112078@hust.edu.cn>; Dongliang Mu <dzm91@hust.edu.cn>; M
> Chetan Kumar <m.chetan.kumar@linux.intel.com>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH] net: wwan: iosm: fix a resource leak in probe
>=20
> drivers/net/wwan/iosm/iosm_ipc_pcie.c:298 ipc_pcie_probe() Smatch warn:
> missing unwind goto?
> There is a resource leak in this place.
>=20
> Fix it by changing "return ret" into "goto resources_req_fail".
> Fixes: 035e3befc191 ("net: wwan: iosm: fix driver not working with
> INTEL_IOMMU disabled")
>=20
> Signed-off-by: Ruting Zhang <u202112078@hust.edu.cn>
> Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
> ---
> The issue is found by static analysis and remains untested.
> ---
>  drivers/net/wwan/iosm/iosm_ipc_pcie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> index 5bf5a93937c9..33339e8af1dc 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> @@ -295,7 +295,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
>  	ret =3D dma_set_mask(ipc_pcie->dev, DMA_BIT_MASK(64));
>  	if (ret) {
>  		dev_err(ipc_pcie->dev, "Could not set PCI DMA mask: %d",
> ret);
> -		return ret;
> +		goto resources_req_fail;
>  	}
>=20
>  	ipc_pcie_config_aspm(ipc_pcie);
> --
> 2.34.1

Recently it got fixed and patch is applied to netdev/net.git (main).
Refer to the applied patch [1].

[1]=20
https://patchwork.kernel.org/project/netdevbpf/patch/20230408194321.1647805=
-1-harshit.m.mogalapalli@oracle.com/
