Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD49A672ACF
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjARVqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjARVqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:46:33 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D26D4CE4D
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674078389; x=1705614389;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q47nHIAf9++URmhuBKiW8t4OnN1qgqGsglgX3vJEgdw=;
  b=k1+JMrXzPlLrGD+rtWE465L4rLy8bArjP6Hp67tdUNQghVBT9UNmswns
   cR4u+yhEuilBYQuAfa+z50o07QFLTiEnmODkulZU/ZDC4eSfWQYsg4UaH
   x/qViRqEvEXzMSm1YXG7t/bDZOBi9swfjlpRJuEep8pMvvUkTvKtUplCP
   r5KXqV2KAXs19KXGkLjynhAA5eL2h02uqV7GLX/mKv/QHBbME6XRpGlnY
   tGYkThRBX1LE7rCaVejT2PAhinaMK7l/vKv6FVLRPBY9BJiEiJYO2mtQJ
   dLiqkgHvanTIvEdvFldkqrglRNZ18P4JqyxQQVV9tlWN2uQsPK3JokOrW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="387461390"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="387461390"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:46:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="748640506"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="748640506"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jan 2023 13:46:28 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:46:27 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:46:27 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:46:27 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:46:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhCPf2p7+2+8CDHNsm95DLcSBEChfYIuu8bDuw6HZIehnptVinEA2QZruhAKnU7kHZPya/zD4m5ryrprZRpsSK/sW7oOOxdkhsJ8Bku7g+sVIRIMwz9aK/k4L/6/9/3kd7E9G/XJYSu/pQEHCGdEkF19ZY15D+3MLBQxGCbryLsF8ieuP7/6nFohg1x763Cgu/gd5IYRRLC5X4EGHsSAukRab/INKOK3vD4nVMZ8pMQ/33GdkUA5Fw1S1K5uHk+vpqXTsgC8gKM0b+7apzy+S/dxSuJhPlP5qNYiauq0Wn1Wc9BTsejb8pdmLgSDFZexIJq8AFFO+SO8A4dNS5f3xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CBLz43xl51g9QS6xgCUMnizd3XxIgchzZ7g+Y9H/o5M=;
 b=ErK+EGoN1fZlP9LaM3/WYiqFHOV2g21nrv1vGNhj0W/72bSyYSJOlwKbz7OLk+IyCCnHzAPUGPixjqlFhQ+CVFJSKU6Jvg/RJf0hpEz3mLMTciQbw+NK7pMIzUbWyvEtq3jFDCUJfut94UVEtAqjcHbhqTJobZrQFZUDvilb8TGJxfuhRirUMD6v0T/6feo92YNlgU5IvsR68Zib0rcs4y7uuW6Fun8dzsVR3AVXXa+usE9CyxUD1f9qwJUDA4j9q5bhMqOeSLFwSFRUBPBcHSzCq4tUIHNforY7TmcoF5eRLvxOVYCCLUEKd1TfJQ5+M7kT038zyw8vzKDezi5BWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW4PR11MB6785.namprd11.prod.outlook.com (2603:10b6:303:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.22; Wed, 18 Jan
 2023 21:46:26 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:46:26 +0000
Message-ID: <f40e2021-6e98-8655-3b0e-85036b85c6f9@intel.com>
Date:   Wed, 18 Jan 2023 13:46:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 12/15] net/mlx5: E-Switch, Fix typo for egress
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-13-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-13-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0045.namprd08.prod.outlook.com
 (2603:10b6:a03:117::22) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW4PR11MB6785:EE_
X-MS-Office365-Filtering-Correlation-Id: 55c79fa3-827c-42b1-344b-08daf99d72dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tdmrj5KhEF5tGL982H8XOM+AG/jMk8e8C9nZMiB6rezrRv1F4t7Z71z8yNG7ABm3mq4PDDPFpir1hkBKSp3JDEQYNtr2Myt+gQr8o3irGizItDnWW20HrHlmuSH0C5NqwCnG169hBVfqj+mTHwIZd0I6bajgNQzKoGAk2jhLgx4LGXuX6P08gjAq7Mp9unlsgJIsBXLQT72J4hBh52XCMECNXlVqj6lsaFCj5zSUY7jAnYJSkKA3IAMIRrWdWdlFV3Kn/byeSF5nzCc6W2vuT0IgHvHXW3Bzhw3fXsJd9E+hHmFtt2AE2uzyzAWMflVvYajlJhKDJtIP4iboUMgAGjU5g2AkQt4j5Xu6D/6CYdXjVFoMME0UuiIjFTle+aHa855LCYVJvnbVlRZgvN2W4X0Tyd8ERFe8ln2/o40U5lyNurywaPjuMsqrmiBWHg4XnJ0S9HsSbDGo8hGqhOYru/w7GMaBYcOv0s5roWH03dlXiasbv5amCs61YVI2pD7xVBuQAf3Mz/swr9dimIQ713RZkPLPSbM0EaPhw867ezRc35oBWskjm4dN4Jei2sCGu29jcm+Ayu6X+rUDYNESnNrg+L8IUyKR/TDoy8/GnL+v5y/0Y2WVa+6Kv0jvl/AnBRpYrFBfwXholCzC9HByqeLHoRxizjaPmbu3bjjYu05UcGVdVaeCrEUaY8cchGntt7lRg/Gbt0aapX8LfihHUsUjBmYg8i3PIDpiQ/YAxMQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199015)(2906002)(31686004)(5660300002)(8936002)(66476007)(4326008)(8676002)(66556008)(36756003)(66946007)(54906003)(86362001)(110136005)(558084003)(316002)(41300700001)(2616005)(53546011)(6486002)(6506007)(186003)(31696002)(26005)(6512007)(38100700002)(6666004)(82960400001)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTFuNFlKdTYxSHd1RytFZ3A0SURaTEZlSU5lTDIrZEpMM252SjdFRm1VMXVU?=
 =?utf-8?B?ZlNURm12K1dvWU1jYzZMWDNvdFlEbHozUUFQRXBHWFBwd2pUeTNVMzlKdGEv?=
 =?utf-8?B?eVpEUUlqdTF4R2FxWlI3Qlkxd3lUa2xDa2owdlVVUnRSdXJFYVpaT1RrS1hO?=
 =?utf-8?B?WFZNT0hibUdZUHMwZmlkSmxpbXJFNlNaMy9MSXp5NVNBTnRGZjBYK0M0ZHNx?=
 =?utf-8?B?eU1rKzlpd1d5WEwyTkYwVCtmL09YYnJmTjBWQjhzMjYxQVEyaWxnbFN4TjVr?=
 =?utf-8?B?eHVCU2xrUWplWGlzWGdpd3hvdGVxTlMwV3NTcU12VFFFT3BRYUwxMGtINnVk?=
 =?utf-8?B?VjcxL1FXZTBWcXBOMkx4K1JtaWtuM3NyTGxzYVRDZVI0UnRBSUpMdlBIY2sz?=
 =?utf-8?B?eFRqb3lTWVI0U2JpZTV5eWtYdWVDSW9mclI3OWJxZGJqaFJ6N2MvSmFmd1c2?=
 =?utf-8?B?UzZnNnZ5L0hrbjZZUEZrYXZNTkpmZG1KWElGY3lCOHV4UEl1dFNLVHVRa2pp?=
 =?utf-8?B?dWYwR1IzQVcxUVJleTlFMk9SdWE5djNLUGZ4OHdaZXd5bE9XZXRRcm9SU3ZN?=
 =?utf-8?B?ZU1Ya3RPeDB6ZTdIVzBzWFk2ZEIvKzBDelB4VzVKbmwyRkFKK1RkZWxLZjE5?=
 =?utf-8?B?aGR6VVFGTFhreXo5TVFxdnhQL016RERLRE90SnhOc3FHN1BBRVN1T1lnZVR4?=
 =?utf-8?B?OGlsa2lWdUd3Ym1RSzFTNDFhZmhqMjcxQU5DRzdvSFNHRnM4aCtYU3R4Qmxv?=
 =?utf-8?B?T2h2Q3k2TVJMamhBZEVWOVF3Nzh6bERHTzdRMHo1ODFhMTcvSVRJSFZqOUJE?=
 =?utf-8?B?cXpHZGJ4a3F4b3BsQjdjMWUvTWpkUVIzWEs3MDhNV2d4b21vRTZ4aG5LaGs4?=
 =?utf-8?B?aXpsZmd5ZjNPemxINHBmQk5Uem0wNzNsMlZ4Q2pIYUJxS3RNSTNQWU4wdEdY?=
 =?utf-8?B?LzBrRWkvcXMrTkhSU3ZPamsxY0NqVmRIb3Y0VHp0VTBTV3V5VzZUVUk3TEU3?=
 =?utf-8?B?SUVLZUc3R3RMT0FKVXRENkNGZ3c4cXBQUkNhdzRvRTh2aDdVRlJ6WlB1L2hw?=
 =?utf-8?B?TCthWHNGaDM3TEI1KzNYVWlEOXg3ZnRPakhiNXRzSy9hYjErZDBUbnhtb2sx?=
 =?utf-8?B?MHZxNWhTak1ZWmp4R3MvU3VRM2V0K08ydm9ac3lvQjR0eVBmWWFQT1AwZXRU?=
 =?utf-8?B?eXlVazMxZUxiOXo5djV4VzVMQmJZYTdoWFNoaFV0dUpSOFd3aW1ZRU5tSWZE?=
 =?utf-8?B?SVRYZnArMlNNSko2VVJTR1daUE9yc2pOeEtIbE9oV3FtMy92OVF5bVQ5VEtL?=
 =?utf-8?B?SEU4NWh5bzEzclpob3VIQXI3dm90VVVWSFlhWS9TK1YwdmdJbW52SHdlaVYv?=
 =?utf-8?B?Wk5pREkxY2Y3MWJ3UTc3YXh3T1RoWFdkVEZ6RllWcUp3ZHhDcXNmM0lSUUJr?=
 =?utf-8?B?WWdKSXFVM2lwSnI1bVJTUk5MOVprRCt0Q2JtL01tM1RTcUF1ODhlUjk3cVp4?=
 =?utf-8?B?cWpuSHU4QkRrb2U2YVNBOXFIRDhNQTNoRVgxT3NjVTI1ZE9IbUg4akI0emhq?=
 =?utf-8?B?S0VEN2l0QkkxMkRsRnNZaGZyNEFzU3c3OFRpUUYzeEtjNCtENnVYVm5mQXdx?=
 =?utf-8?B?QWRuTllSNUE5cjJCSVBwb216YXFqNUNLSlhyblpDNHdpdGpQemxmSGplZ3dS?=
 =?utf-8?B?Y25qbU1IWTVKQStLMXBDTnlQN09jZEFOZmZkSlVoVGdkVE96Q2xkSDlHSUZD?=
 =?utf-8?B?YU5mOUZhckt6cVY4dkRqc2R1QjBUNStSYzB1ekRpUmNDV25SL21QTVdBTXlH?=
 =?utf-8?B?MDlTdDBvdlJ2R0oydC9ReUtQV3hlaWtZdi9xdm1nKy9RY0YyeGJrNHlKQm9m?=
 =?utf-8?B?WXNqd0NSU1ZzL1EwU24vdW9XbVBsVENrcmpBWHZXT0hzdzg0WWF5RFovdlhJ?=
 =?utf-8?B?alpteTE4MFovWjVySXFNaDA3OHovb1o1SmNSQUcranhIb0V6a1R5cVNUZ0FW?=
 =?utf-8?B?YTRKWnpTYytOZUlEVEI0cW5nOTlwZnFGRjJScnZIQ1E5U1ZuNlpYTFk4U2ov?=
 =?utf-8?B?S05ySk5FS3lRbTBJajV5TG1BM0FUd0hUdWxBVW5jaHRZaFNNd0E3NXQrVGZD?=
 =?utf-8?B?ejJhMVh0NStiNEUyK0EvMy93ZENjTWRIbGRocWQ4aTRaaHUyZWtsVXg0MkRF?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55c79fa3-827c-42b1-344b-08daf99d72dd
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:46:26.0970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MdlVbfitH2x74C3TYxDVDlT7vy2L9wpWJ9Kb0PZMv02o6BdpoBTxAC47Dc87fJjnKpHWyuatAH1CmZTzDO8hXLAxdSl8/8fG9CEs+M7vRrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6785
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 10:35 AM, Saeed Mahameed wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> Fix engress to egress.
> 
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
