Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03CC636B1A
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbiKWU0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235336AbiKWU0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:26:25 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43664C4978
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669234893; x=1700770893;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fx/gopgXHPpwVIfIDApiwlDHuIH/lx8zoXE8RHilfGY=;
  b=l17c/8tGre/tce7Ljm5IAXdMFw6wkw8tA9iyijCdNcIPY+QIqTN4g9p6
   z6yoNxHGHOnQLOuOrhBeLaxG7C9h4dCnfDlI7fViHXW4MWQv2EgVXkLsT
   uHcsxSrfqsZFV2GTKWx4+u9myI6cxAQxWT5JFdh3MWU7zkrzeiY8Wgjco
   RGn4wWa5HibSc/MY4iVTbr7QSbI1dD/Vth7bFHOt7aeiofxfpz90vuqvj
   hvBjv2DaCQu7yKWwkfMM/w66/+3ZEp9wx/qF8Au6CA4Fk0j7Ebvawp+nc
   S+H/EOq+UdMthWuxzLdF6QHzISOTd0ksLzIazv7FMJfegQ+yj1x/FPNJo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="341039995"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="341039995"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:21:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="816605839"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="816605839"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 23 Nov 2022 12:21:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 23 Nov 2022 12:21:12 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 12:21:12 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 12:21:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UujWf8UFu/dNpYQw0VtygnjExbY/4LUlFvzSDonKbhWjMMflcd8RZ+r4Plj8XWVURX+8fF9LdWhO1/vhRGa9Kp8zKJaQLntjKmqiR+FZA26qjH/lXRRrBIChT0SC2zVvIsJ7gA0InQafO/hMwJc5fm9JsCVieNkA18JbtotRcmzVDBNq8+QOoKziphp//3z2H9fdIEahu2Fe7sgByBbY4Rk2F1+WdqPxZtBvG+48Uy7uJZShU6i+At29legeBZnBBrLsqbZDqfcJAE8XlF7ECg2ELSAP8az0TyhUjTiy4/7glcn0jW8bcxnvleDNZhAPuAqnaR7GWOi+E7epuWol+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OOcdUucXvTGppW358texWdAs/auzuEeqk+IecDNewHU=;
 b=leNbmZHsmW8rnpprFCpX7C2405/2NILxTiY6xyYqIe04Xurm9dF9sPOw134Eb6OtA91qP1+NMPRBzsJs/jVhVR6rZtKwMA8Vt5C/IW7JuzFeDJw1SaST+YVOQkqbvZg31JYoZ1ca3cAvpkNcGXOc0DvgbT1LkBohCHW9MiGR9S8AiiI1uws0eMWqR/OyomI5/3qGuulEDAdoFUOK2A0ybAMsaLI5wJY0Hr9rNBpTgD/iEZw7o0KG/AnqT5HttKj/UZyX75cTZdDRXPdCYylWTzu+pWa3jto+df/MmHjxS+TPXcGf9UdaRZZzF388+w88+Uzd/IAkwpii4k7IPkQ+SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by SJ0PR11MB5814.namprd11.prod.outlook.com (2603:10b6:a03:423::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 20:21:09 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::d585:716:9c72:fbab]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::d585:716:9c72:fbab%6]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 20:21:09 +0000
Message-ID: <133d405a-2bf5-0690-5145-9061b6d441f7@intel.com>
Date:   Wed, 23 Nov 2022 12:21:07 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 2/2] ice: combine cases in
 ice_ksettings_find_adv_link_speed()
Content-Language: en-US
To:     Przemek Kitszel <przemyslaw.kitszel@intel.com>,
        <intel-wired-lan@osuosl.org>
CC:     <netdev@vger.kernel.org>, Tony Nguyen <anthony.l.nguyen@intel.com>
References: <20221123155544.1660952-1-przemyslaw.kitszel@intel.com>
 <20221123155544.1660952-2-przemyslaw.kitszel@intel.com>
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <20221123155544.1660952-2-przemyslaw.kitszel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0239.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::34) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|SJ0PR11MB5814:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b26f579-0649-4f76-575d-08dacd90422e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y4MuXG3GHNvMUPUMkQf7u8Fh9JsdCRrORIUWlTWYEpZwCxEBOCPXwXEM1SWwdwta84W6y/ei+huVgsUwoJX/RVKUTGcKG7zNSGtuCMNvLDQ3/3qrxDXQ5t5rzejmZDUtG2EwDzWmE4k1neYK8CssCAfdliUAjM8+wBBMjC2l7tx6om3LYAkVS1x8QSxVaw8hCJJBO7GjhIAvTdC261uECYf/vl+aw7bgoP/xIPkPQ6jrNHDVZxlZdVvh8yvoFKUvReIcqu7ghGWBApjrD5oJ3mmsvLVJiXg9IZZdaa7Yc7KZW8VkJ6HzYuribo4HFoMVbVkLbOJ1SwpGe85N0e1w0myEo/vfhlJiec7nPvJ5/gHDyWbQFJa37eBz9qjJYuJzlJHYc2WL191mrlMrWwsAhdoj+fs7VOzb1cTFEQJPkZYAhLU65v8nWp9iCkEc+rBkiIU31laRlB90I0nYa/8N5DbG6q6zUQ5CfRNByfHw+fzsBDvmT9jGhN3XWd+VvelmA/LVKIwbPuDN1JpE1lOKcXl8ChN/HmS4zYYW+sgthCSPjarozrUCjzLB2MuYbfvwioYyCbFWLb4rqSuinOypbbjoeLGcYXoQgJkAPbMFjPDqeYhFqXGPe77tPaWVe3Z4ivRNXUtaickjK1OuMAgmze4eGWqff6RCYa6DYTlvpNCuqwgQVI35f1ekWEs+qMG+ZJ6NiTS5w/ml8R6kp22v6V2+x2UHEvWs693MabkxoHU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(136003)(396003)(39860400002)(451199015)(4326008)(44832011)(8936002)(4744005)(36756003)(66946007)(41300700001)(82960400001)(31696002)(8676002)(107886003)(6506007)(5660300002)(6512007)(26005)(83380400001)(2616005)(186003)(316002)(6486002)(38100700002)(66556008)(53546011)(478600001)(86362001)(2906002)(66476007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alZGWC9TUzdlWFhsLzNuVzFkcUN3cmVZZXBTbzZ4WXl2dytXdHZQc3M1WWxZ?=
 =?utf-8?B?SkRUUHYwdU52eGhZc2tQTmJSdHB1Z3FGVUVZMzY0Ry9kL1p2S1NaMVh4bU94?=
 =?utf-8?B?RWtObnZYeWsxbnB5bnoycU5uRSszT0JOM3cvOVo5TDQ3V0dhajY0N3VPL29i?=
 =?utf-8?B?NXNXa1MxOGN0VTNHQys4R0c2VEdKZjBHdEg5ZXpvMXA5ZjRpY3kwVEhPQitr?=
 =?utf-8?B?ODJFN2JYQWR2allNN0ZERVpoa2FhYUduZEU5djNjZldJQXlQb3JxOTFoVkFY?=
 =?utf-8?B?bTJ4NkRrampZVVB5OHJPR1RlKzRpMjFKRENwdldCWitvWjVyRmJDajN0eHBz?=
 =?utf-8?B?M2pZUDE2Vk1iNjhSMEVhQ0ZObjR1UkQ0TUd1RnZLek5ORGxnRHNjYTFsdXdQ?=
 =?utf-8?B?cXl6dTlNVTBHeFBadFdzMGQ3aDhiOEJYV1RENFgwZkNIbXpkcTNCOVRxQkhV?=
 =?utf-8?B?MWtYYk5KeWViMk9LenR6anZMano3Sk1wUitrckd0cC9wV2JMWGFpRlhDd0Zw?=
 =?utf-8?B?UmczbTdXVkZzY05LZkgrTWZtcmlPQnphUUErZWpNMnpPMmtEY09FZWNGcnRR?=
 =?utf-8?B?Sy9tcUtIcmczM2JIMmlDTG92QUFIWWl3ODVleUhrRXlYM25HVDNIUTNkd3VT?=
 =?utf-8?B?UkhQN0NJemVEZ1lDZGZVT1Erd3M3TWZKR0lCa241MUtrMy96VHVpSEdVUEo2?=
 =?utf-8?B?U1Z1QkZwNmtyQnJCNE5sQVdObGlrTTZFNmRhWTFzbWFFYTR5Q01vWEJoc1lq?=
 =?utf-8?B?S2NISDVQNUlaSjRIVnh0ZXlaZFB2TmlKRzdCdEZZRE1QbUgydUJJTXNvbXg1?=
 =?utf-8?B?eStVR0FtaE04KzNmVU9iV0hKVC9rRHBNVmpiaGs2VG1EQlVza3hpUm1EY3A0?=
 =?utf-8?B?WkhyTzFLL0lVRDBXU3g2WEFqeEFGR1BIVndGSVRRR0dJVTY2dnRHcFZqVm9M?=
 =?utf-8?B?RVFKdTVUT0duQ3NscjlKZVlhVHRTTnNFOEl5bWYvem1rWGNOTlg1WE5RbCts?=
 =?utf-8?B?a0lDSk4rN0JsZjNIeHpqbVJkR3cvMWxVMHN0WkRzZW9DcGlDV2pUcWtjY2Zt?=
 =?utf-8?B?dWVhK0dneGxqdVBXQ1BSdCtPa3d6ZWVhMDZMTjNKTmhubTRDMXhEUkFqcXBM?=
 =?utf-8?B?aVVRb01oSE5LbGdWS0ZDU1hrZ0t0V0RYYmNneUxJb28xdC9WajlGR2ZSS2Qz?=
 =?utf-8?B?TTlQcXhhOFdZSkpDYkxkTHBjbzZSRnJtajY1Y09WUmdqM3lDRUlQMEhiU3Nr?=
 =?utf-8?B?bXk4VEw3YnZETzQ4Tnp6V2kxVXBaSXJYQWlXVDMrZWxWUXNGS3JhU2tZcGky?=
 =?utf-8?B?RVBjOE10QWZNZTMwSjE2QzNvM0FqWjVIMUkyMkhVWGJjZ05kNSsvd283L0p4?=
 =?utf-8?B?dHdRRnFDSCtsN3JibHl6S2JIOEJIcFU0N0k2VHRrUEM0a3ladFhVaXVneDQ5?=
 =?utf-8?B?RmxkNFhIdmVzUmc1em1ramVxUFBjTmU3WjJ5SW5Tb3VtWU9xY1RmamE4NDBI?=
 =?utf-8?B?UFJRcC9iaGF3MURoQis0OUtSTVQ4eG1ndjZQR1dxYkFabXArSnU2cHpaSk01?=
 =?utf-8?B?Q1BXM1BqNWdXYVdGWDRRYkxwWlR3bk9BMXlWKzR4dHN1MEZSL2FseXFKeisx?=
 =?utf-8?B?dVpTVGZhOEpRRlJBYm9XOVpCRzA5dWdnSWpzMjlCUy84UWlNNkg5Z0RQajZP?=
 =?utf-8?B?Z1JNbHVMUnJsbzRFaVBtTGVpdEk5V3BmbWN2NHAwMlYxMldCSWR5cEZINWc4?=
 =?utf-8?B?MnJXak9MRnJsQWRTMC8rNDMxTjJJMCtQaUlBWlZGTTd0K2RTbFdaT1ZUNG5V?=
 =?utf-8?B?c25xWHJocGtmSlBLbmFEOGU3eFdMcjhrNlhMV3B1a0djamN4QVJ3NlMrTzNX?=
 =?utf-8?B?TjAxQTFiS0FjckRUcm9QMUN3RThKc0pRUHNYVTdRREMvZDJiSFdOVGM3U3Jj?=
 =?utf-8?B?L1ZiaGZ4ZFpOaGkvNGJBVUFacXhEYkpEZDZSdGpDVTlidUhSeGYxTUdZdURW?=
 =?utf-8?B?OUV3WjJrTlA1MkFmRjFWd2U3TDR0M1BnTzdrRFBMaGh2VlBiTm4zN21qNW0y?=
 =?utf-8?B?dGk2K05yQk5OeVoyemUrZThzUVBpa3RxVHZoanV6MFN3bEliRzRYaWUrczRD?=
 =?utf-8?B?SnVwdXl1a1pCZ1V1b3FJQWhJNE5wMDEzd2pCOFViN1dKY0FwN3dKUktrcGth?=
 =?utf-8?Q?ADmlM7syYcbma2mXdut2pQM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b26f579-0649-4f76-575d-08dacd90422e
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 20:21:09.7382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HR2XRmzmJMbrFyGYcICHXipkgZrKX789tifVGs9hkgmsb+27c7XWwZTj69cWZX0wt17FAegfVTAlKDqd90iwZOd3m1bzZ7rtg37YO/DbggQBkTmCu7BelS+CIrTjGgQT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5814
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/2022 7:55 AM, Przemek Kitszel wrote:
> Combine if statements setting the same link speed together.
> 
> Suggested-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> ---
>   drivers/net/ethernet/intel/ice/ice_ethtool.c | 20 ++++++++------------
>   1 file changed, 8 insertions(+), 12 deletions(-)

Acked-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
