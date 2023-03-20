Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240126C1C18
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbjCTQkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbjCTQjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:39:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F3310DB;
        Mon, 20 Mar 2023 09:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679330047; x=1710866047;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OFee6K1ch0MIcwNX7js+XWVNzKXs9vkBluhHmvBxOUs=;
  b=K5RhgkuGaH+Cv+ZRjoFmEAJ3a8ujiZv6cTEqfF7KNQcPVW3/U5VFVOL6
   BYwKiAaNFaW2Nudh8dd9I/mnqf2wAw7Vff5xq9Yi/KJSh+/ejgOS/G1Dc
   8B8kEFmoW3aCLGM4e8xI5TleToNq1xW8MTAdGpOg/dYRI6b4qUY+JxYGZ
   EuUiMiuA6pfyyeCtgsAYgOurrI89588fvCedlBy7Pc630s8J7H9EkRse6
   ooKivIZEtNfVNcUqpZ1W/+o0W5sg9+dtmueeFPytiqlyTI0u0VF0w0WLJ
   X3y37XZ+DnIGPKlijtW/XYyUYnOjHqDYbKWHyaC5AZCThTdLxtEsINGwJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="337429425"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="337429425"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 09:34:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="855323792"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="855323792"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 20 Mar 2023 09:34:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 09:32:27 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 09:32:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 09:32:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 09:32:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjsmLFxuLjsfBVqM6VgKxK5/jeklB80tScso6jpqnmMy+ReaAUZIVGzhIOqqw50E1F/knnEzdviOqYZD6o8WBSdUWzjo1gw9wJmzuFiSsV5Zr1rKIIINTdIODOfQtfYuED1TF2L5Bn0yZ+DbyDGcTEyVX9a5MttN+PQJzcUqwqd8jETnPcM4japNaaclxeawMKX2f7xeCT0uKDaGTuzDhxRaweJsSdjBMIpxy2ViG5OYfiuE/aih47kOrp5u/UnY9oY5NEpNrGdGKFO8IEsC6LSoDjqf0uneoYQdfoI6w+SgyzStB1zktgN2RZR49jsQjGM8CAtdH7V0OWrNO1uOTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PONhenOwYSEuHixiv6S9xrfMszxsRzXz0PD3NKeSrCw=;
 b=Vi2zrb89KMPihg+9kopeVW+z1ugXN0EXwFZj3YhwHaVF5AKcALjbgJxTO8ycVA9TJ74yahBys5UqNvSl2VQLk+LWpzAAu/9/Dm+ui/J4OUQ6cwocCaKUvqmtMryurlOB9XfqrFENe89AxOtjIn+6TE47n4IoDMx4RKsrfLiZ8gVb3I6wVubpVCDAhQwLPw/g66iixFnz/ACPA2oonXaV+U3WxwUS/IIStneDOQqqZJ8sS/9S+xq4x80qhffmmDCy5Rffe223si0phFHtN7sPkJ97LiIKsrfyK+VBgOs3j+fSQQTdAVSc41RQwI89V+1TeD9DffzBKFel5AJ3I8LqvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SJ0PR11MB6718.namprd11.prod.outlook.com (2603:10b6:a03:477::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 16:32:24 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 16:32:24 +0000
Date:   Mon, 20 Mar 2023 17:32:15 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: Re: [net-next PATCH v5 01/15] net: dsa: qca8k: move
 qca8k_port_to_phy() to header
Message-ID: <ZBiKj4B/XuqTkl+N@localhost.localdomain>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230319191814.22067-2-ansuelsmth@gmail.com>
X-ClientProxiedBy: FR0P281CA0258.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::10) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SJ0PR11MB6718:EE_
X-MS-Office365-Filtering-Correlation-Id: 25b79109-c527-46da-60d6-08db2960af44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UdQtKeWS952zE//9v4cIZijDHrDvEth4u40vGzetZni5B+mscq+IRgrr7mp+RlTbhJ1wXDGXE8BlSxdE+clcqEBOcwCvjrfgG5T6kJ3uARMhTCHRVYfGdj03vkM7m7MWG2RAsUEc62gHSSuO9HAQmD4InsxywPQCdWJ4pebO7UNv1afMD68xLsgG8YQMV6hArZbpKDPuuds2oG/I8fm66yoWnbWREoRCeULBUuP8Lr5dr0Xx9imxFr9ZkSZNJSmfobaVVjSN2a+/SXBpc0zQIrSdT2SqmNkKYOy9Je/KUSFhovFyXrkuKpKa8k37rMZZ/AclzfsnjbJkCNHLZB/NFzv1+rAQTXyzHtIitOziQk1UHXOrdEmg+9XQZJXCeHI1o3oE5PGpxV0W0DX5o93FkwROgQBl2I889gIRR+2AwXDwDlBC4GHIHJv1FvRDOCg3au4DOHxfEmAm6V+CDc+zFKPJFqUEXYJtfMPbcBzBduY7sD0iRk74LMLuo8hgdA2DhHIjSfs8JSitmpTsPtSH+yVpFxrJwDrNpAEeNToR49pY7rdtSsOXHJmDrYl/Poped8HHOBxMjUB4zNI/mizF13VddXtToFEYNVMumlG+izS1F8ovJw+PDf30H9QQaAU9/m/6Z5iFBWowQY+a76fwRv+pfniENc3SB15ruC0P0t1vlm3ZP5rgMbsnCu1i652F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(366004)(39860400002)(346002)(136003)(451199018)(7416002)(41300700001)(44832011)(6666004)(4744005)(8936002)(6486002)(5660300002)(82960400001)(186003)(2906002)(478600001)(38100700002)(66556008)(316002)(6506007)(6512007)(86362001)(26005)(54906003)(4326008)(9686003)(66476007)(66946007)(6916009)(8676002)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GRFccqhI5Ftzr+1IfYIrqeMCldtvY4hk75Kdcb+LsW7QM436z8m2x5pELker?=
 =?us-ascii?Q?+0cKgBGR+9akk7KJlzpxEj4DIdJmm8Nn/kxfiBRNRK8KYL/SeTQdxiYA3RcU?=
 =?us-ascii?Q?7HK7lEyyScVj4fdlIDzZpZqa/WcMh2mH3IdKDZZNVgeSj2b4vny3AVBBn9hq?=
 =?us-ascii?Q?FR1Y0cOo8zD40m77zArfrBtZ7Y+sCZfvJjOFNSYJuNz0XcvkgIznF4QnV3ac?=
 =?us-ascii?Q?OS9/5E5T4+jW14UbBe9ryGdT/eH1Mfc2/8NuqNre155M1cPVIQ5nCztNf3pI?=
 =?us-ascii?Q?Xe/QzZGodA5bQXgii/DR1ZNg2C/OTujx1gz8bC7fqvqZ8clqkKdFXz0mkKAx?=
 =?us-ascii?Q?6f/wTsYBpJ+q+tSPZxwDA/z4S0xTrz2+sx0/zaJxRLm4FkcwdRQAW++0CZ+a?=
 =?us-ascii?Q?0YSmPROsHBa9cpD1UGOsbLFqsZO1uL4x69z9gEtWkHtGvN/0d4yJwK3gSUSq?=
 =?us-ascii?Q?7+pQVuFpZ3EyzsyN9orWXPC+usCSDxF5tUE6HhemWM8NMMOtIHFKEuSE0WxR?=
 =?us-ascii?Q?XDEeyCDc8jcjzP8vDRGy/8PnbuArefZuYTYCuKSau6ufyCb6/ndYLugQWPMF?=
 =?us-ascii?Q?KvvmaH3sZtMOOBy1QrF00oclFR+1IfOiCAdt16oOX5SskGH3bzjvHOqFp8Rm?=
 =?us-ascii?Q?sPg0jwq131ok/V7h/2oy8z+levrszqWGPc46cd5zETmOKIP3dPmEGdMpNKU/?=
 =?us-ascii?Q?y1iYpZgtumCTnaf0+55ani7u5EesKH65y1FIgxmlKc04S324KTfEIHr+Qkzj?=
 =?us-ascii?Q?bzbtYG2t2GlT4nTLR0+41WWgMjDsx3UoxFF1Cxk8rEid/sgZqSYoHOJMRpKv?=
 =?us-ascii?Q?inwp4ejgARsMrY1g75RsLdwYmV87dD/ZkEdQRqnkLCmANw/QKCcyaR/4ZHm7?=
 =?us-ascii?Q?hIH/CJWjvxEThKNjeLnFx11SPEX8TUzIhHhVI8joOkBMTnMkPXwjrFd1xSau?=
 =?us-ascii?Q?OlzI9WTDblZqEKcmvh7Fu9MV/U887vqLQ0ST/p748dNVHXi2i7xcGgMyMc6l?=
 =?us-ascii?Q?5eOpfdnOuLuP7HOpEELbpx8I8jwQriLlfuUv6M5iVIZLXVLsqYts4S3ZpIu6?=
 =?us-ascii?Q?cvULRX5IIhTAM0N1hHhYY5v+h6639JWtOYOBZ7andkmEvfN5Wl1Ib07Alpyi?=
 =?us-ascii?Q?NQLVv9U2BRHzOYX5IXhnXqADKhl75Y/9lj5fHtDnUTam1o+mvk9VCARERke9?=
 =?us-ascii?Q?smBnYXa1+wH41mScf/2lxP73L7cgh10hIbO0XLLsIGYBrsasud7Vgu4e7wTJ?=
 =?us-ascii?Q?Q83pwDJ9Szs0QBes7vAze8rDsnP3Glbma2ZGireWx3zYNMgi1vgtoQgVqNpn?=
 =?us-ascii?Q?8il2azpXg3ImqLgd/UpBki5oodFkYZ02j4wXOoLbTGb/7hIIFW2WPJ3WbYEw?=
 =?us-ascii?Q?FUuWZ1vhkO6j7hvZ0qVXv0nXZcdq6VmFM0OVmsNXKQyP4puhUeIZW/vHBng2?=
 =?us-ascii?Q?LIIO+T2iGqhMtely/f4gA47ob+vJTGDvVSdXbFr8o2cXS9Xm2mk7x5K/91WW?=
 =?us-ascii?Q?caqJG4O6Po+qeUnr0YOeWw5LxDu0oBuDO4/e7viDwoCrPaAnayVRFlXQ2Fyx?=
 =?us-ascii?Q?qKX8fbZl/NHPX84Yx4Jqgh2iQa0hZBLJ8ZPs4HZFufWWPSkmRaLRoo5257v5?=
 =?us-ascii?Q?WQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b79109-c527-46da-60d6-08db2960af44
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 16:32:23.9181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UYR+1FA9u9YJ6LxlCz93HLF6oORHlIkihYDeAzeRYgH51qUOaNBd+QmQxuRy9RpqIWXVylxM7PZ1wJNfHmgU8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6718
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 08:18:00PM +0100, Christian Marangi wrote:
> Move qca8k_port_to_phy() to qca8k header as it's useful for future
> reference in Switch LEDs module since the same logic is applied to get
> the right index of the switch port.
> Make it inline as it's simple function that just decrease the port.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---


Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
