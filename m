Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C97670E49
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjAQX7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjAQX7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:59:23 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5D0A24B;
        Tue, 17 Jan 2023 15:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673997255; x=1705533255;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VKt9ybNufok2Hbo9kuSuQQ+4I8mQ/Zbk+QN+WP9pId0=;
  b=kXG/x7Zwezz7Jkko3U6OMF06vk3ST660cuQA7zSSVEBl5NB504g0TJEG
   Mjgl55aIdmcPyaxW+hLTyHxQx7kZr+60IfEG6AOdj2xHJ9BtBuGJPzFX0
   o6Ud/IpYRtP14Pg9soto7wKk1lvnS2cHp7Z15SB19NsbrWRUA2+ELZdgN
   K6yQOQO2+ky0j7pOY2g7QW1flcoMpY6jgi/l/iPI3I2qZwNuPokv44Fes
   JZkyZy+Ly7vfLc2flRpIirsncAucCOqmpIK95onhtB5NAZGGUYa+6OiPn
   uXAgt21cYehyKIXdV+tI4C4hBi8hEz27sx0tarhzFwePTrZAamsqIDQ2+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="352090419"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="352090419"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 15:14:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="609409820"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="609409820"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 17 Jan 2023 15:14:10 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 15:14:10 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 15:14:09 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 15:14:09 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 15:14:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iyb9it0i/Ou/+755VSHASjhNLefQbm5YypMvKmHjRICy664hFPAvjvsge4mx34lF4wTvg10WC5Ah7DUpgX2m9dMtNg5snb71WiM/XI2SFe64WU6f7xa7e5Kyg3GQkgb2YXHdyxahdZw4dDR6Nmvy+RpVVXMg71u4Y6Y4d+glR9N01yCiI0NhDxgrOdHqG16ntcpot9CcuLCLKT9r3UCH/KM+OSIxSIj8SpzX8Y8oAH3A7Jvodae0kQ9iVGAuYa64UzTBH9YbYf0NfVMrhNFoF/srRloG2vTgK7URyXigCb/6JnutkFiHcq2mbL49pD4zgy2BvCvN+xYdvlUSbeeFbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25OSUAwyqaI0ZDA1q1kyRgHyVtKOMpR9+TZH4lcTu94=;
 b=i7OTltUZq9ls5T1+V23Ti229F+AOxM6cASg4Im6H+BsxWoT5OoVamw/0hlSfAzjJF9IRSC3llUuIYUyxM/kBGoeG2aOv/+slASQ0tJdU4NhW5yrpv1Ov1soAbWAp2Jbkcy1dfEgXDZoSWZ1RYzGwN51I8mT02YlAiDzdHrHTf22hzqy+WUNnVHvn9loP1eaGwIBvwieAv8+PpuHd4wA29piZcGApOtIJ1vghQK5iLXWXz8rIlyJ63fDN1yfCWcgWDizUVJtloSEuUR3jlfkOHiZjj6S/m8qO9ip9guBJTxtlSFKC2DtY3lMBjXLO1sSMYwh3mYEx6vmihUQdDoh2ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA2PR11MB4969.namprd11.prod.outlook.com (2603:10b6:806:111::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:14:05 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:14:05 +0000
Message-ID: <22e207da-1689-520f-e960-133cb9fc2097@intel.com>
Date:   Tue, 17 Jan 2023 15:14:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 1/1] drivers/phylib: fix coverity issue
Content-Language: en-US
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        <mailhol.vincent@wanadoo.fr>, <sudheer.mogilappagari@intel.com>,
        <sbhatta@marvell.com>, <linux-doc@vger.kernel.org>,
        <wangjie125@huawei.com>, <corbet@lwn.net>, <lkp@intel.com>,
        <gal@nvidia.com>, <gustavoars@kernel.org>, <bagasdotme@gmail.com>
References: <5061b6d09d0cd69c832c9c0f2f1a6848d3a5ab1c.1673991998.git.piergiorgio.beruto@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <5061b6d09d0cd69c832c9c0f2f1a6848d3a5ab1c.1673991998.git.piergiorgio.beruto@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:a03:74::16) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA2PR11MB4969:EE_
X-MS-Office365-Filtering-Correlation-Id: eb4d87ba-42b6-4aaa-b684-08daf8e0874b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QBMBy+LE9inx7qvnqoBz6AxP3KYatv7RbWrny0FI5u/k2BX+9YdSunnfLaK9LTcACZpmp63cELkxsUtXtA1rmkQ4Qpw30Ku9OKkslITZf4zIEwjXIaegKiK4Eq1KtkUiGOQNIu/xrpsrTBkObPC70ZOkndHulQ6jNSTms1U70IdHPaWrsC5y6D81ABRFrwqFTCyj21Ti5hOdVogXwneAI8yY/ZUsbL4efLzRhGx8DAHwAujheE+GRF4+PA9OXeLp9oHYioElIhA4/cRtxqZ++yumZBjXeJzZxjnGab8OlQQBX2/nf10TiiNcTiegels9qtt5GiTvfIkQxtmqSwv6BN/qN90qgxk3bRRUl+ip12fHGnx1IgY9jESLQyFg8Fm0R7XciCfE6vu94E6c3QZTwGEREeQ5U3PZf8W5ASmXtgTTrN8mTBGiz70ViDm7FydnObBjMvkHYWkc4qyxTXE4IgiowaWRbMUN1duqAf1EVG4F9xUz/RM+CRRia4xod8/aEMPVkvieoz+i3EOkxxeP7xrGiFIZceBEms0/eVd34im+nYm0iun/kf5shFCnfpZyZdYzIt7c/DgUwlZel+KeETOQJZUydHV8SE0DLCydU3zZF6r7tK/L2fJqbA3neE/e3S3vNjaBrSFYwdirvkV7QX3XW6JxCMMcJ/ilTEPHR+YSxk8+WehJLEnlMXL3dioBI6Xbj6TIB5u/vLP2yw/UQ9bIVNd/73sTHvtAbjYK0H0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(396003)(366004)(376002)(346002)(451199015)(31686004)(2906002)(8936002)(5660300002)(7416002)(83380400001)(8676002)(66946007)(86362001)(66556008)(4326008)(36756003)(316002)(110136005)(41300700001)(66476007)(31696002)(6666004)(2616005)(26005)(6486002)(186003)(6506007)(53546011)(6512007)(38100700002)(82960400001)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vis3SXJhaUNTYnAwR2MvMWNicnBBTDdJOHNBZ3AyMk5CRkhybVdrWmZXUVFk?=
 =?utf-8?B?bEJMQ2dIZ055OFR1THN0Qmp5ZmFXeU5lczhaY1FlMHVUOWRNQ0JkN1E5UmFm?=
 =?utf-8?B?dTB5bEJxdjZMQWZyenhqbGVNVDZUSUJ3Y1VjQ3d4MXBHUG10dWVpemV1bWQx?=
 =?utf-8?B?Z1IxNmJGbFVhYWtVKzV2Vkw4OWE4U2tBb040TzhIQ3UvNVVTcElLOUlyVTAz?=
 =?utf-8?B?L1BjUTAva1l1RjM2M1dDVko3UlBzNjRJUHg0MDljRWVQTzdHYkg5QUhkWXRT?=
 =?utf-8?B?SjJZbUkzZUlmYXZSdy9WT29CQzgycEhjMXVvL0NxajJ4UFdkZ29mdUExMUNk?=
 =?utf-8?B?UWwxZXJWRXptTTFvQmJlUU9CNUlVTFVUR1YrUE9TMThsZVZ0Tm9RSGxsK3V4?=
 =?utf-8?B?czVHQitId3AvWWlDdHJsN25pbGQwdGk1Q0N3NllqS216L0hDamtHSlNHdVhk?=
 =?utf-8?B?Ry9RYWErdkFjS0JJb2dkbkVSN2hUM1FlKzdjaXBZRWM3a295ajZRRkdBNDdU?=
 =?utf-8?B?NkRHL3NUUVdpTFVkUkJaZTRuYWxyQm9ZSlFJTzAzakNoUnR3SWxLanBDdnAv?=
 =?utf-8?B?b1YyK2VyS25yNThsdFdGeUN3dzFaMnU1MlloNHZxVDhrTkpuWDloNWZTOVNE?=
 =?utf-8?B?N1pGYjVnVmhxTlB5aEpFTEE0a0Y1NVp5cjNXZENUMkE4Y05IVDIvNjF5U0U3?=
 =?utf-8?B?ckNSYTJxdkVjNm95Tm1DMjhEZWFBTHJnbVk2QURvVCt6VU9CZlE1Wm1wWlp1?=
 =?utf-8?B?a2o1di9SYUljcHgwNWlWNi96UDFpWlJ4OGFNL1d2NWNqYU40UEdBVjgvUllj?=
 =?utf-8?B?U3VMY2xwbU4vQkpJNVU3Q0xoQWhFM0hrYXV5eGNPQkZ6cTlMRFJ4NERGaVNr?=
 =?utf-8?B?LzdTRmlKSEdOdzlva2ljcUxjYWRtK2JJSjJpTllja2dNME1SbWhTUlNtZm5h?=
 =?utf-8?B?UEhFSldLTnJGNjV1aVVaeGNtditKRHYwaG9HVUZRRUtUZ2dKNGMvbHhtMzhj?=
 =?utf-8?B?MWkwMnJkZ2Z6UEl5V1hXYlEydDRzQnh4SUUvRnBTTngrOVVTUSt0OVlmeVFV?=
 =?utf-8?B?NzJkb2FCdmtrS1YzbG83azBHVm5oYXpIOVVDeHpMZ0xlZkpBdnltekZobmRJ?=
 =?utf-8?B?YTYrZndXT0FyMjVFbWtSYyttTWFQMndrNkVXWkVKNUlMdUZzS3FDL1BvdDF4?=
 =?utf-8?B?Z3I4K1JhaWpnQ20wNFJpdHNCcG9YYS8xb20remNhVmNVRWxoNnpBdFFrMVh0?=
 =?utf-8?B?MzdFcktpS0ZuRmFLbXZoZzFsazZGWTFMK1dPNGkxUmloV3JpbjFPeGxUVXNT?=
 =?utf-8?B?RDNMdEpydWF0YlBFWlBnZHYrZkEweFhha3ZmUHNzTWhiK0RhT3lqdGJkM2ZF?=
 =?utf-8?B?YjRJVnJHa2JqNTk2RGZMQzVUNWxMZjJha0QrYnExajBJdXZiRUtPVFgwdzBK?=
 =?utf-8?B?aC9TbzZrQkoxZ0dlNzZkbVcxeGh2UVRrMVNvWHRrRHdnSDN2UTVEQkZrL3Nn?=
 =?utf-8?B?ZFNFeTh4Ky81NEhFVitkY1RZNjJnZk5xU2xJZDhOZ3dNS3VvQ3p3N2llM2Za?=
 =?utf-8?B?MFIxL2RjVDIzcXRLSUdWaVZ6RDQvN0pleTliWkRQZGJOVDRKdG9UaGd6QWVG?=
 =?utf-8?B?NHRTZEU1bWptRm1TS3V6TW5aWGtKdTUrZFJFU3Rpd0liejNueUdZSkZsQzhL?=
 =?utf-8?B?N2t0S2lwYm5JMlA3M1NXNWVnM0NRSHlCdG9UdXFqdGY5bC9TdXlUSG5qSEJN?=
 =?utf-8?B?a2s1YmRDSXI0eDc2SVZ0K3N5SVBkOCtaNGxMU1VyanVGbllYN3ltM1hLbXVW?=
 =?utf-8?B?THVwRnRGQ3l2aFlaVFBzeWt3a0lsWTl3Z3pyb01xUDVwQ2RleWxsV01kS3dO?=
 =?utf-8?B?dE1EYkVpdjhtdUFFV2VxSk9qNHpYejQ3Q3hrbkRYU2JqOHovazFkTCtuc0J3?=
 =?utf-8?B?dTY2Rld1SUZCMHRCS0krMkVTVEdkc0lwSjJMU1VlU0s2TTJPM3I1U05BNGRZ?=
 =?utf-8?B?b2Rtd2ZLNkcyWk5ieHlmRXZuVjVQWlA4c1JLc2NMczVmRUdBQlY5Z2JBdDZS?=
 =?utf-8?B?bkNWd2Z2M0VJQXdhUFJZQXdsYU9PSUYxRlFBSHJOWStod0ljbVVPN09Fc3Ns?=
 =?utf-8?B?V3g2WlpSNnM5SjIreExQMDRpVGViUE4vK2V6Y25zdWswcHNUWVh6MVBEVXZt?=
 =?utf-8?B?b0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb4d87ba-42b6-4aaa-b684-08daf8e0874b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:14:05.4938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R+2Klk0U8TYERjWt/2OA4oSRvMx/B8/RhyRwc6uX3K0XjTZrLYfBO0rpb7Ym8UPkvA+zxRiwbfvqad2bqllJZrEcK4pL08zAZopTvoO5ELg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4969
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/2023 1:47 PM, Piergiorgio Beruto wrote:
> Coverity reported the following:
> 
> *** CID 1530573:    (UNINIT)
> drivers/net/phy/phy-c45.c:1036 in genphy_c45_plca_set_cfg()
> 1030     				return ret;
> 1031
> 1032     			val = ret;
> 1033     		}
> 1034
> 1035     		if (plca_cfg->node_cnt >= 0)
> vvv     CID 1530573:    (UNINIT)
> vvv     Using uninitialized value "val".
> 1036     			val = (val & ~MDIO_OATC14_PLCA_NCNT) |
> 1037     			      (plca_cfg->node_cnt << 8);
> 1038
> 1039     		if (plca_cfg->node_id >= 0)
> 1040     			val = (val & ~MDIO_OATC14_PLCA_ID) |
> 1041     			      (plca_cfg->node_id);
> drivers/net/phy/phy-c45.c:1076 in genphy_c45_plca_set_cfg()
> 1070     				return ret;
> 1071
> 1072     			val = ret;
> 1073     		}
> 1074
> 1075     		if (plca_cfg->burst_cnt >= 0)
> vvv     CID 1530573:    (UNINIT)
> vvv     Using uninitialized value "val".
> 1076     			val = (val & ~MDIO_OATC14_PLCA_MAXBC) |
> 1077     			      (plca_cfg->burst_cnt << 8);
> 1078
> 1079     		if (plca_cfg->burst_tmr >= 0)
> 1080     			val = (val & ~MDIO_OATC14_PLCA_BTMR) |
> 1081     			      (plca_cfg->burst_tmr);
> 
> This is not actually creating a real problem because the path leading to
> 'val' being used uninitialized will eventually override the full content
> of that variable before actually using it for writing the register.
> However, the fix is simple and comes at basically no cost.
> 

Makes sense, and its better to be clear, and prevent the introduction of
a bug later if somehow it refactored such that the value is not
re-initialized before use in that case.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
> Addresses-Coverity-ID: 1530573 ("UNINIT")
> Fixes: 493323416fed ("drivers/net/phy: add helpers to get/set PLCA configuration")
> ---
>  drivers/net/phy/phy-c45.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index cff83220595c..9f9565a4819d 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -999,8 +999,8 @@ EXPORT_SYMBOL_GPL(genphy_c45_plca_get_cfg);
>  int genphy_c45_plca_set_cfg(struct phy_device *phydev,
>  			    const struct phy_plca_cfg *plca_cfg)
>  {
> +	u16 val = 0;
>  	int ret;
> -	u16 val;
>  
>  	// PLCA IDVER is read-only
>  	if (plca_cfg->version >= 0)
