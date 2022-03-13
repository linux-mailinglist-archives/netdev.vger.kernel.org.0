Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933174D7891
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 23:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiCMWM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 18:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiCMWM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 18:12:56 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E987891F
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 15:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647209508; x=1678745508;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TZeofnbt2llybiKQwwJ4OZkPW9RGhae4GoW2DAQY6Eo=;
  b=bX9nZohiWfQ6iO8EQQaa26qj04Tgi5P2GyLzBd8EiLyL8O5AaLqSbmla
   Je6WZF38t4RybvjCzwuNwpaSSiu1BQSs8X/uw7OJ30kd6cyUeu+6E3mrb
   CVbsG1W0+YUQ7B3wfPdUk4aDJSavNNgqjOs2Hto1mis4LoNMTb7hW7L0B
   UDxbcZoV31d4BXnu+ZyiCVv7+/158VP3N3SUIYPgpwNCnaRfhEfxGP1R8
   Z7xHqsrOXnq020/7jkEMERkRDkkFWNLGJaVuzEnOLPSL+zng5VQl7O8mO
   G/WzY/TisSG2qCsIowH0Zjvyir1LAJmWx8aMuNaS+mEQlCRf5i+B2dCOx
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10285"; a="238073225"
X-IronPort-AV: E=Sophos;i="5.90,179,1643702400"; 
   d="scan'208";a="238073225"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 15:11:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,179,1643702400"; 
   d="scan'208";a="497392995"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 13 Mar 2022 15:11:48 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sun, 13 Mar 2022 15:11:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Sun, 13 Mar 2022 15:11:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Sun, 13 Mar 2022 15:11:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5nT9e0/K3JdncMCzv3EuQC22/jbgCDm7RKpGSicCOPDCc+5cgli4ec7aab7Amr+cIQLlVP91AJJu4NOTNM45nlIxXSoQGr7+7ISVwoTXouf4W6PR+gdymOrDlTK7xCd018xsQBHKiiXM8y/uLIy5Ml1axjeeX8Nx5W9fHCnCSxVvPb+F+weibdl/Cw8vmLnXtJlSuJhWslGc0I9eFW5tkvqg4FqrEaaUATEAfrMqIlauupNqlXG4ZrAnOrUqsTLvK/Sv7Y8R4X/Zn61juzWjNaD38pyoWNLYLhNqfNXGhyTb2Wc/POqp38kBA0LMRghxnj0SMcAQXxJrzEMtyKxrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZeofnbt2llybiKQwwJ4OZkPW9RGhae4GoW2DAQY6Eo=;
 b=VQe2tFTq4x2PtX0nlydy+FlYU1jkZKve68OU6vTXo3GHqTl3ptZGubP4eRUMvntdFXtTYMH5WacyGm+ecbGTitY1xqD9k7azaizML+YAy4a5DUSSyotXj8yiljctTqLRDYrHBv3tY2dX+niGDAUKDw/eBfXGP3b+JVm+k1A60mKPNtg6OdmsEWL00DL/4svzDVt4scFv7r91L7zfm17pmlfmj1Joyqh7aLLwoQaGcfn/GVx6kJIHSokBlVT6oiNAprOfmqQgt5UMfbu8nH8o9d9VS+ukczIOY0hcRQIgyfqY/O9GcftF0EDPM7UFm3EwfdUpHsVLv+asPBwFdlR0AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by BYAPR11MB3686.namprd11.prod.outlook.com (2603:10b6:a03:fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Sun, 13 Mar
 2022 22:11:45 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::ed3a:b7cf:f75e:8d63]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::ed3a:b7cf:f75e:8d63%7]) with mapi id 15.20.5061.026; Sun, 13 Mar 2022
 22:11:45 +0000
Message-ID: <8602316c-2d0c-8d99-1d7f-135b7d808696@intel.com>
Date:   Sun, 13 Mar 2022 17:11:42 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 2/2] ice: Add inline flow director support for
 channels
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <sudheer.mogilappagari@intel.com>,
        <amritha.nambiar@intel.com>, <jiri@nvidia.com>,
        <leonro@nvidia.com>,
        "Bharathi Sreenivas" <bharathi.sreenivas@intel.com>
References: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
 <20220310231235.2721368-3-anthony.l.nguyen@intel.com>
 <20220310203416.3b725bd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <135a75f8-2da9-407b-40b2-b84ecb229110@intel.com>
 <20220311124909.7112318a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20220311124909.7112318a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::38) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0bc43b9-72e0-4b72-6da8-08da053e7634
X-MS-TrafficTypeDiagnostic: BYAPR11MB3686:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB36862EFC0374B0AD3CDB5E33E60E9@BYAPR11MB3686.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P6IvSlf97jM5Xb80uxxSK7haYshFEbyZiFu/WbqozkmTv1AuXappKjH+QuAejlJVZwOQxE/87N9hsWxrfqGRfmJ9vqctHAet4K9zgETsJDRWC57QH847KaxIP0O1W057NWA5Q9nlkt6JsYBySJNoKqOs0Roz5I9gjyBcKfa/0F8i3lUXzFAhaMfQGQbS1Sce4O+JyxJPiaUQWs8ebuRDAeRwIrhf+U1rkDtTTgzCem+iv0XPZwv3fI1Qx6AF1MsFpfTVDU7YoAiWYHBoDTcNj42oPsqVMCZHrfIa7MtU6RIi69/nn3QtGXzhOMbJvOLT611gjnX8wInN9VngM1E3OZ53B/nrePauYcthh3TIlq0Jq0zzxruAcPKFBQ1o73zrhkVCvprlEw2c89psbDgmt4pvq+AJ2opqVsm5sk4VeJotadGayP0rIlCDdY74K0krnPtxy7K7EpIscmdFp6ucn8KnRtLK/Cz9+SN+MccHY+a2R7zTAJjtyv+s30j3lWvRq5vCGEfKqCgckC9eF9poU/vz8dn60Qq/RZyFk2CBu7tMby6N5JnwYDxATqx8cQjtamjcfhYK6YN0jT63Ozd8PC/mHrdLue39msYRP+QyRmlFh5x7WpVHGy2/MmlneGbJCHZASgLDpClhVl0wVmbSWhM/S7WTQgU3j5chWp+G8dBNGiznjtP+BxZDn7Q4FDJpBdhK2zxZR/ZZcpWBYAZwNKsjWz4sQ/dKG4iNxS8cYxQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(31696002)(86362001)(36756003)(54906003)(316002)(8676002)(4326008)(66476007)(66556008)(6486002)(508600001)(31686004)(66946007)(5660300002)(38100700002)(6666004)(8936002)(82960400001)(6512007)(53546011)(2906002)(6506007)(186003)(26005)(107886003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0pyaVByU0VseEh1clBQOCtkdmhRa0t1VTV6M3MzZ1RNQVM5THlyQXZsdlhr?=
 =?utf-8?B?MFY4Q29YY2k1N2R0RiszRzhVYWdCRHdNdFl3dUpEei9Rdy9wS0oyV2c0dm05?=
 =?utf-8?B?NUVSSEx5RlVsdngwU2tUZXB3SE10ZDYyNjNXaEpnaTlDeGhPWHdHcU5JdDhJ?=
 =?utf-8?B?akxSbWRLQUl3Z09FYVFTR3FES3FqaTlDZjdrSlN6bEoxb25jb2pHUkFPOXFs?=
 =?utf-8?B?ODNITk96K2RHbHdHWk1WdjhQS3NXdFVwN0kra3lYcVJCKzFjTlhtbC9ocC9J?=
 =?utf-8?B?WkREaTNOOU83aDVSMklOZVpoMEtuZ0xXLzJHSXl2bk9VQzdrYWF6S3I1QlJV?=
 =?utf-8?B?UjNCZWNoT1hydU9ZVWJ4SUl0WUt6Q25SYUZBczVCOEpUaDJCSlR5LzhwektC?=
 =?utf-8?B?TW1zMEJaS2ZQWG90NEtYSmVaS2NKZkNHYzBYY2tDbXZ2SDMrSW9VSHZSd1Ra?=
 =?utf-8?B?R21zSVJtd3IyeEJOZVlHTDFYOHk5Sk1ja0VQZ2xXYklpZ0ZXM09BSFlvelJL?=
 =?utf-8?B?VW5aZVBXclc2b3lLV1lRc01qRzIvNUFPbGRxN1ZRUWtucE13YmFnallZenBx?=
 =?utf-8?B?Yi94V0lVUHMrSGxJd2dQZmp4RmpCVlpQT29yczV5N0c1eGlTVnQ4NTd1S1I4?=
 =?utf-8?B?M2pnU1k3Qm8vNDhVaHBvaWIvQTdQVWZQMjQzdkVvZWZMOXgrQlhLQlBzNkFo?=
 =?utf-8?B?ZjJqSjhpRVFnU25ta2RoZXo3WFl1YUp5Z0lNait0dzlWZjNMRGE0ellDcEJx?=
 =?utf-8?B?YzlhQXNHYjNSejh6U3p0VjNpUDdxNDk0RW95MXFVTmdLTXgwMnZnMStXTCt5?=
 =?utf-8?B?eXUrMThWczU0VVE3b3ZXdkF1VTh2ZUlWR2h6dHJCeUxvZ2dxVk5JWnAyQ2Q0?=
 =?utf-8?B?dXVxSnVkZ3gwSGt5bTkxL1hMRStEWHJvT0F1LzhBYkFwY2R0enZHajJqQlBn?=
 =?utf-8?B?TFhXZ0JvVnVWaEFHSGJpVHFrekxJdnhyZTBNb2dBZEIwU0hXaUMwVkplWEU1?=
 =?utf-8?B?UEZlOEQrTzhLN1BSWmNxK1ZDby81T0JUVzFTQjNMdjVCREJLR2REV2NYbThp?=
 =?utf-8?B?MlRza0lKbHFWQlRVeHVnZnBHazVpVUx1VGFmOWpXVjlZWlhDZmpjalNPOVVD?=
 =?utf-8?B?MjkybFZ4cWxsOVR5R2MyakRJdy9IdjNycmdTOTMySmdVMitEMitjN0h3UXBl?=
 =?utf-8?B?aWJoTHArQUQ0VzA1NUVCNkEwZVB2Y2xZVGdML2tqUXhTQ1NhQUJ4dUZWMGxy?=
 =?utf-8?B?U2czdmdZYkVoUlNqZVZ6MjR3aHhYNzhyeDlFL0FDZEYyVnpDTmx2bEo2a1lo?=
 =?utf-8?B?WnY5cUgyRVN1a2l2Mm90R25rcnBDV2p1UUdLOWpPSEVKQXpYUktsdnZCbDNB?=
 =?utf-8?B?RDJmL2x3andTS050VFdwNHZZVE5QYmNYc2xYRmpNdFBWY2tvNzNvZGtkUkcw?=
 =?utf-8?B?b21mdkxDVmtwcTFyM29laFdPVTF1OGlqZ0VjdHdqTXkzZ20xQVNZWjBhMCtP?=
 =?utf-8?B?UUVxZkVJWTQyMGNrYmVUV0svUVVxMFhmQnhIZXRtQTJVNUhQNGNlakQ0VUlQ?=
 =?utf-8?B?U2Z2RjY5bUExSnFGNW5VdGRrUE1Bd3o2bk5xSExoM0JzZ2ZCNzZidFF3MjNB?=
 =?utf-8?B?VmZ1RmQ5Qk1EL2p6alFsamFrTkg2dnFtQk1ZWWI4ZXBOQVkxWS85Q3RQd3V2?=
 =?utf-8?B?alpnMUo3M0huTWM4d1p5ZXVjc2F3TVdyeWphdFJGSkFMZ2xHMU9wNWZ3alE4?=
 =?utf-8?B?bWdURmVqd0Z4MG01aWZTd2hoanpHUEQrUGd1blZPVUJTTVI0LzdkWk94SWIz?=
 =?utf-8?B?NjZRTndHVEgzekxhR1E3M05TVlp5Q1RNUHZlY05rclBhMFNNMHRvRG85dnFN?=
 =?utf-8?B?NC9SV3R5TUI5WE5kTkRvWENDS05ucnZLcWUzT0U4TUQ3NDNOcldPaS9NVXUy?=
 =?utf-8?B?L09maGo0eU52NVVsWGNybTMvMHRBVGhDcGxMR2FXcGhodFo4WGh4dVkyOW5l?=
 =?utf-8?B?OHA2V3VZcFJnPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d0bc43b9-72e0-4b72-6da8-08da053e7634
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2022 22:11:45.7167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pZrT9+h72ptqgsBNUCmvy/0IMIfVOlF24QxmfDy6L33OXM/inKFvodMU3aa3iiDAwMocp3Ihq7GGEhkR2zSBRUzqaTgrVtsMxCmjAaBjuIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3686
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/2022 2:49 PM, Jakub Kicinski wrote:
> On Fri, 11 Mar 2022 12:36:55 -0600 Samudrala, Sridhar wrote:
>>> Why is this in devlink and not ethtool?
>> This is 16bit value with each bit representing a TC and is used to
>> enable/disable inline flow director per queue group or TC.
>> tc mqprio command allows creating upto 16 TCs.
>>
>> My understanding is that ethtool parameters are per netedev or per-queue,
>> but we don't have good way to configure per-queue_group parameters
>> via ethtool. So we went with devlink.
> ethtool has RSS context which is what you should use.
> I presume you used TCs because it's a quick shortcut for getting
> rate control?
>
When tc mqprio hw offload is used to split tx/rx queues into queue groups, we
create rss contexts per queue group automatically.
Today we are not exposing the rss indirection table for queue groups via ethtool.
We will add that support by enabling get_rxfh_context() ethtool_ops.

IIUC, you are suggesting using the rsvd fields in struct ethtool_rxfh to enable
additional per-rss_context parameters.

ethtool -X enp175s0f0 context 1 inline_fd on/off

Will this be acceptable?

Thanks
Sridhar



