Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73086C1C53
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjCTQpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjCTQoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:44:34 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3945274B0;
        Mon, 20 Mar 2023 09:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679330350; x=1710866350;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IvrUFdZbgte0iYPQwUAurZNQZwK9MU8puDgdWXmtHQQ=;
  b=G7H9TrR9k9aZRpnvJB11SZNpMq9pkGNVgeSbKqPkAiaQFAO1rRfCe70d
   gwMI594nVrBbi289O5LiYtZsePviZwPNZ42T5OEPAzqEU5jKUUstF9utP
   RXBIaB/PlETiXnrpmSB2F/Zp9zofIqIaY3FERi44p9hwjOGKaK6jYIij6
   Qz7m2/VKubHbsDjlnA24RXibJK3YvhBbNHkSnu7PtqHXczTqRSYgYLbUm
   kmI3d+ycy96HCJe8Cm2sftHKYskJ16GLFOhGK5npBSrjAzXXTFLhTbTZH
   RuAkjPfBENWCYzGzuTBAvZkX0wMd/Ay5nB3FySHMdr97eq0Vvl3vWBZbT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="366431960"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="366431960"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 09:36:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="674453856"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="674453856"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 20 Mar 2023 09:36:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 09:36:35 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 09:36:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 09:36:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 09:36:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+/N0Z6eI/WqLXP4H32WRjwhSnGxnrTco1GvApgR9T726edv6jvChsaC/mcUrbak6AQFQFbjTVt4QYNpvYq55KMEN7yXWq/BII+oDlqKeLpnStUYTQ/gzI9gHWN7/vE3YrwKb3jEwlwTLQRCLCdCGQkMxd+XEVaqae6DgeNjZaGRJSPhEIR92NH3p79Y7j5BrhL15qUcvaBVdNAxZlOY0nrDbqFFEMqaMWkGJ2uLfUrEa/qQR58nNcanixSNwycyPbEqL7BgfGScYN3c3mNWC5zS32w4zSy+uOovMKz/5bHL+YvmAoXtQGEPsBwwDd/puXt4fc/Mftlq14tcTDQfyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UrXMQJIFYc+KnjppqtRei8OCIbS5Kqw0Hul6v2Jgngc=;
 b=Ey0mIgOLMXo6JWr1k7gLIWB1zt/JDJD10vUEdwkZfkiJAOVheYMoYn6Ju5OQ86U2y61gFUDJ/wTpqKJekHeo58B0qGRzQ/R2SsH3D97t4Om6xrhKjumabN/1iKUEjTAxKqOGaQfQgZJb/hgMYMjKIW8q1gYaPJcP7TN9L0NqDVSbJK0EaUh1ZKfMMb8FsItKdL7ZcVpEbBp4XKRdpD1Mg7DFXtV1GJc/ZLop8vgQPDpmxHm/FLCTI1Hskh/5RYd/RiW6raQInHhXT0kggRoch1awx+GttZiDF//a8E+PyxeKLQ5cf2kTA18jGxxVAdKJVS5vfT78bhN9QflnnXW6PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 DM6PR11MB4625.namprd11.prod.outlook.com (2603:10b6:5:2a8::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Mon, 20 Mar 2023 16:36:33 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 16:36:33 +0000
Date:   Mon, 20 Mar 2023 17:36:23 +0100
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
Subject: Re: [net-next PATCH v5 06/15] net: phy: phy_device: Call into the
 PHY driver to set LED brightness
Message-ID: <ZBiLh3RMRdVKnXCT@localhost.localdomain>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-7-ansuelsmth@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230319191814.22067-7-ansuelsmth@gmail.com>
X-ClientProxiedBy: FRYP281CA0008.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::18)
 To DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|DM6PR11MB4625:EE_
X-MS-Office365-Filtering-Correlation-Id: 21811197-3e0f-4220-6211-08db296143ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QUpszyl8ujMxHSpKiNCga+BUOp8cx7XJ/DTPQFNJo1W6xSh9JQnLCcnaDPn1zskL81mVycufLh+Hx825QE606VApTi715X2Uy3YQP5qL12p7iKuU9iMx9P2WB/1AGaw2wqhJQs5iAiCHJ031uCAE7m0OK/+mZlIiiH0CnkqxWb0DgKyeOeVm/MqGU5YmdH8e2xHU33miJPcV/9bv/CabsK7H9eJnHKewnJxa0BQ34KDVmXNePe6YRSzJcu+HVOrj/Yk2Cq+63NvoMyXJ+97bAEPcKMlCODynhk2zxHltXf+RBq9mgU3TghSQZq1tqESlNYVlwfix9ktYe1595a2cxF5DxgdzOwe2dhHMk8EImBZspyjeoJvh+Of60jr0CO7KHrc0cgnlM1JljHF6HDQig02cwaB0/XstBD/c3xoYnz54FD2NllSQdp8fQMdhOt9HXiMsfbNELYr7BQKstM7Ki+ocWCSFTiU9r0D8UBM9FT0dBaCMoTji96KjxdCDWz/5YrCnS/f3Hc8ZprswF1TYgWIhU6VHUnRtLnk4lbpkTlW1B95/LU9UVZTsAw9Xw+VbDsWpQzkqJpBIYccKLDC4rrEyIj4Vj4ylAFEItIAjJ+OD74dYMIStymjZMEFf00NGl99P891ldosOojme+01roA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199018)(8936002)(5660300002)(44832011)(7416002)(4744005)(41300700001)(86362001)(38100700002)(82960400001)(2906002)(4326008)(6486002)(478600001)(6666004)(186003)(26005)(6506007)(6512007)(9686003)(54906003)(66476007)(316002)(8676002)(66946007)(66556008)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sPBX/K6b6nj6Pb5Rl4AH744nPGcjnVHdu48xNBMEtq1rQQ4+W5YwRb5ufwF1?=
 =?us-ascii?Q?0ZQWXLshhVRlpKfzw46z9ktWUeb4sKzhxTIkzwGM4GGHILhDF9jEkpku87Tr?=
 =?us-ascii?Q?sgbdmO9wcu/QjUC9fCOqLRsNB86ogSXRZXgIhD6DDdHfTnChTuBUccPih92b?=
 =?us-ascii?Q?9ogJ80VrV+wFJSWq2HMn/f6GJVUdG/bT6dW8O/iw8lHegSJo9PaIP68r/I3C?=
 =?us-ascii?Q?PSAhlUx/Bp/DTBNTR6lOcpIm7yscDkqrtb/enq8RyrfDbEXSjfVFVvuGWJD4?=
 =?us-ascii?Q?Oth7i/UtNd71YZF6bMtQR01WKv67jB2VMdXq4eQZTaaSH43d/t4hNTFlitCt?=
 =?us-ascii?Q?z8D7WzRDCVi/R8yX5HWlvozajKYTyZPi1PqYSYsXEp7JxwedU8UTRwkHkB4o?=
 =?us-ascii?Q?9fx0E9jt7RqwIhdeLHCeXJsuZ33MU1JsrBXiWH1NptDTDGyNOFmLbRvA11vS?=
 =?us-ascii?Q?GQ/cDSe37IvZHR5qM38s0gQms67GYDGZbzaBpolNITYNhoMutkk9FKXXvaUh?=
 =?us-ascii?Q?JbkGqFMIsijxg/RRhrPitMkbeKaTvQy+dsdakA0AjCvhXl0bfXBOEEpvv/Hb?=
 =?us-ascii?Q?GHojIVCLZD4aP6eTZTzxaeYV067EnNqalbaydrGGo+q9bQSJ+TPKn8OAgT0N?=
 =?us-ascii?Q?C2movGLh5+LS6uaYoE7kcxJyvGddH9WD5GX8xK7iwQOEEMnP6tZq6kdvn9od?=
 =?us-ascii?Q?qeHfkrW9J0RXM0BPiOgAKSf70/fT4bMgQLElw6x+++JSQSyK1sfLCeWvwoE3?=
 =?us-ascii?Q?rQC3EIEBVwTs4G0LeMtZigWSseGcp7GO1x1kYnl7vYJvNeV13Qw4xEBJTgc0?=
 =?us-ascii?Q?U8IN0In5KSbzRA2pdTiJAC2pIb7aH3yFbaLE7Fkd1YDEO7YkzBckvShT3vmU?=
 =?us-ascii?Q?HUi5UKY4bMvk+HRkuOB9/9JXsJQ/8JDA262NuF/cCzZRXoZF0dXFfShH0HU9?=
 =?us-ascii?Q?NMI5YmAIiYAvuULaWeY8ivBIE+Mv2UQivxc9TmT96AKL35ZQz++iMtdKzwx9?=
 =?us-ascii?Q?gzYUoYgEDHtOVcnHn+eGyWFfKuS7nbOlkKA4Z5rxDYq+CBS6Jl1IngfqZ6EA?=
 =?us-ascii?Q?rQnzQ9eWcmML0QsPw3wzLi8gO+ckU6R0MezeSfAaPXGb4itVlLMJFuWqENdH?=
 =?us-ascii?Q?I+tAH6D4GPoLKdqUlvg5+WtP8lPU/xIDSaFOy7Gxon7sNvVt0knOGAj0WrB/?=
 =?us-ascii?Q?ZRuchXRxYIl+uF2ABQ4sx15vMr3VRMtAnddGvzuyMGPGZ5B2hUY60uvRoolW?=
 =?us-ascii?Q?hxBxD/KdwFxv96z6pJZaaOy3pLps0AzRb/iTKYFyAtECPNJAoojE2NZFRF+l?=
 =?us-ascii?Q?wWqcZXDc3fm86XhooCaVZT2jrtymSbY1yBZmNU3u+HMuJK1BCjq7q5cpNQTH?=
 =?us-ascii?Q?U2GuyIXHi6gwdKyuzEhREHrpehNFhnLZsd1pp5e3tigyCit8ZKRRy+7WBMZb?=
 =?us-ascii?Q?6XHYurSOvl1wobaJH7w1vGdsijqHGcwfRncmltZz0977MEpeIiixmkyvGskE?=
 =?us-ascii?Q?SGqJ1Nb4oMzNFtOJGf50mzQINQjtQ7ikGmuVxsuq1L15MUhdUFKDkrGoWo8J?=
 =?us-ascii?Q?klh1qXMYbbfI7LN4m/UyU6AdVQNrOOsaG0Su7mcGmMteJ5pqiNQw+LaHnHH9?=
 =?us-ascii?Q?jA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21811197-3e0f-4220-6211-08db296143ba
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 16:36:33.1036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 45/4pCBO+zy+OWLaDfQyIywNpg2CY4bVwBs0bLPH+0MpNnvxzpNFrpRfeny5ai5zcbNTaOThdMLGVRYyXEspqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4625
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 08:18:05PM +0100, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Linux LEDs can be software controlled via the brightness file in /sys.
> LED drivers need to implement a brightness_set function which the core
> will call. Implement an intermediary in phy_device, which will call
> into the phy driver if it implements the necessary function.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
