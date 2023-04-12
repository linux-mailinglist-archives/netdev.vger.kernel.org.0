Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB0F6E022E
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 00:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjDLWxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 18:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDLWxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 18:53:09 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF328109
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 15:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681339988; x=1712875988;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zj2/ctb3F/t+2vxvELAJUoK9eyUDdV8kMh96taA1Ues=;
  b=kbmWwmGh3nLhBkPIXHkvew8Nj6Y2AUSJ/oOKK14efNfSuGkGKFB36nIO
   d00oQT8v4oleVm8SaS+yQJ/GWrsP6J9gPFbHRjOttY/ytnbNL3BEq9rio
   Wyi52MBghQS7ApVVFBWwjQBBXXW+igys9NBfeeddRml3GOHdKMs0R8/Jk
   BVVsv5pJAgibTz5WNAIWzqSOxSBRlOe3Q0ApJ3Rmz6S8eHM7GgUU9GLqJ
   as+3s53WNYKK5F1yfOk28kCOW5OYgAz8UvlZGs4QcK/MV3hT4gFE1iocZ
   HGfJBfE0xXYecZIHxm62skZtmGJ3zPwf1hpe/j0KoTQNweIBgXUnrf/sq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="346721290"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="346721290"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 15:53:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="935297190"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="935297190"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 12 Apr 2023 15:53:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 15:53:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 15:53:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 15:53:07 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 15:53:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgksAdxUGcVzwqVVjeDc/NLIfOXaZEoIvfCKwwDvPdRNHT8GDfJTyLAzsQH2k6Mn38pEUzKSqpABK04+V59QfRe3OKINr1ekvVwxg+r1ph0a8apHpeCw+j28KRwL6fLDvitt2g89VaP3NyVCjEp+eWhrZgmUOIjBlemJtVzOI/AL/xuzsp5hU6W3DT/nxu54j4WJjF7a/j5EGM4/lK2s6qTN7CGt8b/hpx+8mU4kCIlyZkcTV2OEwa3SLAJhWmxbFFif9SvCndC4L8O3IrL8egIVgssM7/loYPtENbdZhsRmwngiSqmpucvNzSA6NzR5iXSdMWlx+MHO5O/Qjz2/bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DERZ5YzgLZGIsZUpPpqRADxmHXKGnRPIu39Wj+8qem0=;
 b=kvC7B3hXkZita85qpBkbgoFGBC3RsmFkGHR4ZiW6mKKwMEJv0txm4fNllfMrYIdvImUmbCYIuP2GEKWUnwU/jbRpfHI9WV4vewJCkO2GqN3MZkQm2//NwgK1cYT4cKu39qm12l7+ejnfl/QgbP3w4X+zPFKGe1ymb6yG4tz2NdsV/iW9PNyXjDP3e8xJM1JBE5nqimCYU0xGRsaooMADbQZGyst4kQGTECxeyNVx5rP2JtTCfCWUPyUwp9yxRWlIBpmWh6lEPm87drC7XZyXZiir/gmO/Qy+LbiQYMNlWa2ycYNU4FjwqrEd5B1yi3dHFX7j9bU6BNTP28kzKFvchg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB5043.namprd11.prod.outlook.com (2603:10b6:303:96::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Wed, 12 Apr
 2023 22:53:06 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 22:53:06 +0000
Message-ID: <6159f9cf-919a-54a1-0b35-d25fb1d011be@intel.com>
Date:   Wed, 12 Apr 2023 15:53:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] net: ethernet: Add missing depends on MDIO_DEVRES
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20230409150204.2346231-1-andrew@lunn.ch>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230409150204.2346231-1-andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0030.namprd10.prod.outlook.com
 (2603:10b6:a03:255::35) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CO1PR11MB5043:EE_
X-MS-Office365-Filtering-Correlation-Id: f76aa997-e256-4000-e866-08db3ba8adaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yTv5hBiHX92ODx8d/FCeoqHgoOS7dkYQLte+axiYxezwNciCVP8gh83QTHAdsqksAnWLPsA71DjRUaRbOHk3YWDb/Y6gvzWz5vc/lwRFFI0BeRLzsKwbvajAdri2QG+DTGBEiDcDgaEpjPK36rOSTraUWfQSVo/k6I3eN5wPyQv1cRdoIda+7fzU4HSnPusC4c66MSjVWiUTcVAP3Um64F+RWPe8W6AmYVMSJKqugbfcLRGrhNQR81N6cgN7SKG8lGMKwb6S6mi/nxXq1GDmTm5Uk/MOoi3O37zCwT7hcsxi8cqow06rPb3Zj8RNaCfjDJ59MAMsaL701Xcgb1CJ6jbD1Qxkhd7y8PwxIrzvxNPm/QXTmRlAuAr3EoDdlhLIRh6Bt2d6GidJNbGKCp9hoYuG0QCWrQQ2PbV1mCJT/i9lvYmST6vsEma2HcfpxJkdT97qX6DrJaJTncXTIpxykoXLcBWYolJcWBoWvBSAx06L/eImoA8oIOAFfdHRwYQmlhNH70e2lLeMRLb12WfTaNf1zupnmLV+GkboN4VEIAR8PxZY+a9buSuq9Dz8x7OMOkmi5Nsi+SP2O6qrHQnOv2YEVFQjQB4YbkDTXdiKWlmKQFRwl1kRlXj0xWKXOjD4Q404AP2s2VrJbiNx0FsScw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199021)(31686004)(66476007)(82960400001)(38100700002)(5660300002)(8936002)(316002)(110136005)(2906002)(66556008)(54906003)(478600001)(8676002)(4326008)(41300700001)(4744005)(6486002)(86362001)(2616005)(26005)(66946007)(31696002)(186003)(36756003)(6666004)(6506007)(53546011)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzhxTWkxb2U0R0E1SGZCQmpZcHdPNFUrenE2SHdNRUxCalNrK1ZoUTF3OGZ3?=
 =?utf-8?B?dnBtRDNVelZFR3E4ME9jdDBPS1J2L3FmbEtxTE9KNlkwT2NBdSs3QnR1V2x4?=
 =?utf-8?B?cExZM3NIdWlaZ1RkMlJzMGl3bE9aQ1VoQWR0Ujk5dHRKdGpUWTdOS0hlbUtz?=
 =?utf-8?B?YXVLS0lOVkFFc3AvcVZ2VDFiM2ZRK0dMLy94MjNCbHdKeGxxYVFjanM4TWI5?=
 =?utf-8?B?YXJkdHdMOTZvMTkvQmFROEMweS9xWUZyZDBKRXU4cW4xK3FGU0hQMDhZVm1F?=
 =?utf-8?B?bDJ6Mnd2RnY4T3NpaiswdjVIb3NOMnFVbGxrcmUxdTNzTFh4YUUyNkFCQ3pw?=
 =?utf-8?B?RjlzOUhMMU1JNGVFU3RPYTlUQi9IU25zVFozVFJyTkVYN2ZyY1k0eGwrbStj?=
 =?utf-8?B?UWNRanpUVFQyTWVUK2RUN1B0L005UUk4UlRvVHpySUZlOVFvSGdPV3lHMkRZ?=
 =?utf-8?B?dGFsWmVsQ2wxZFlIK0x2Uk9Ld1Q4VWVzN1pBc0Q1RnUrMWVYTFlkRlVIalZ6?=
 =?utf-8?B?KzlveElicGFhbjhXWlM3ckhLbHcyMVkxZTlVYlplNkxSSkRkVWF1Y1dDL0dM?=
 =?utf-8?B?SENRM1dnU1hpSktBQmxKeTVBMVM4QkVxNGpydUtDSDF4a2pobWZYUFV3T2tn?=
 =?utf-8?B?Zm9lUDhXKyswUUhQK3pIT1RyVHp5VG1rNGpUK2dybzZlYlJtbDdtaG52ZklL?=
 =?utf-8?B?REEwUGo0MXMxYWRIOHAvYzBaV1psWkRsUUJNNWhmTFBjay9XclgyNVo3VGlQ?=
 =?utf-8?B?T0ZKWU9JMldKMnhkTlorME5ZMHpwb1JnNHVhTzUvN25nU2xQV3YrQnNtRmxq?=
 =?utf-8?B?SzdDUkZMTzBrQkI5SGdPWjlNQjhkMS9jaTBoYXdQZXpVUzArdmkxWlVaL25F?=
 =?utf-8?B?ZmZDd3JZejNWSDNIU3d5ckc1T25uclByQkRjTTRsbytuWERyS1FhdTBJcTFj?=
 =?utf-8?B?MnB3VXcyNGxMT3Y4bnh6aFhiRklBank3MXdDWmVseGh0ODlSZTA1N0d4TEs2?=
 =?utf-8?B?c0UwRE9vdWROamRESStVY0dPL3JoN1NXT045Y01jem04dE9Ec0JVVG9TQkY3?=
 =?utf-8?B?WThWSGlNN3hMQmpCaVNMUmZJZHBDME5pK1NlcldOMkFCam16aloxSndNb3RJ?=
 =?utf-8?B?R0Jja1FzK1Z4TCtIWXYrMnVtVDgvY1crd3BjS0F4cDAwVWtDTTZtZGpicmpE?=
 =?utf-8?B?Q0RZMndNOVN5U3gyMzlzWGNpL1daRExpUTZibVhxL3M2QTRWRmRhMTZ2djdM?=
 =?utf-8?B?ZUtudzZCTlNQOHBhS3c5WjJyMVBKUURQN1pyMXNYMDhxam1uWkJlWHRsQ3Q5?=
 =?utf-8?B?d1YxdTMzUlVzZi9mN3BVMGZqZFhiaThibHdzSEFGSU5QVW45ZFJvVGFJbUhk?=
 =?utf-8?B?dy9DNnRRbGNpbk5kd1dFY0ZFTHY3ZW1vRWw1enp5aUR1Y1pITmVzaStqcG5R?=
 =?utf-8?B?WHdkeEFER1JveE9nUW44a051amFLanhUQ0NOYVgrN0MrN3dadVI1L3k3cUpU?=
 =?utf-8?B?V3F5eXpVa0FyTjFsZ3RkVHd1VTdHWFZ2WC9XcEl2L3dzVGZ1VkVYT2JCRzJ5?=
 =?utf-8?B?cGZYUjdsUUI0dzJnTHVxNnNHYlJxckNLalB3SVhjdmFHNlp3WE4vTjJSZ2Ry?=
 =?utf-8?B?bE5NN0VLVUJaZVpkTTVMTVpUVmhQVHZPTmtNdHZVTWpTNHc4RWREVlFYTjRP?=
 =?utf-8?B?U1BvaU90cTRKN080dXdwOVYyOHQ3NUwwcWwvWHVaYW5rYXZzT3llRlQxRnlH?=
 =?utf-8?B?Y0k2SzhMZnF1Qml4MzQzb2NjbXEzRzcySEZNc3BZblJ0VUw4ZXlBTnc2eFZD?=
 =?utf-8?B?N3E5U1pyREN1anBUenJWTTlEZlFRblVmVGlUbHc2eEIrVkZKSzFxbEVabFF3?=
 =?utf-8?B?ZTRCZkR0eDNpcHU0NDJKRVJSeUFBMjJNdEd1SlZ2VmtiVHY3SnNVbzRwM3hy?=
 =?utf-8?B?L0puWDM2SVhwOUk4cGdxbUxzMXEzWkNpL1J5VlMzSmpoMkM1RnJIUFhCMlo1?=
 =?utf-8?B?dE1QQ2hiaHZDNXdVRjFkRWplL3c0aXB0SHZhcmRMVzkyeloyV0FuU2ZpcUps?=
 =?utf-8?B?clpncXQ0bTI4RHJjd0VzaldsQ2xHaUVFSkJqV3F3NE11bTI2Z0xkZlpwamJQ?=
 =?utf-8?B?bGlBL2ltZHZBWjk0OEpoVHVBblcyTkdFK2JMZ0hCRkpwbVBCbENhMGxEL1lj?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f76aa997-e256-4000-e866-08db3ba8adaa
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 22:53:05.9532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uteh9mgf7Y+8UG7mFBLvaFUOE34xRNb1PL3Mr5+LqgHjeiDlGh1FwYVswLESTXEBXGatrzzgVk1xsYEdt+KDj8H2kT3iT12N7H+o7rY+igU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5043
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/9/2023 8:02 AM, Andrew Lunn wrote:
> A number of MDIO drivers make use of devm_mdiobus_alloc_size(). This
> is only available when CONFIG_MDIO_DEVRES is enabled. Add missing
> depends or selects, depending on if there are circular dependencies or
> not. This avoids linker errors, especially for randconfig builds.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
