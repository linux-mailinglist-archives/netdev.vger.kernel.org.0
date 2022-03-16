Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966884DB818
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346110AbiCPSrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239276AbiCPSrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:47:42 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43F63C4B1
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 11:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647456387; x=1678992387;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4+wC2f0cqB8i9mG+07ehGGnkpQqOlI7IjgdBcfvKVBc=;
  b=P8vUwkj7KEThk7V+GJuwzw1D+Pg/ThFyuqYNlC1AujLDSC0AsEpcPaFs
   vZyxRoClAB7+aWXHsDAtOAffMt2O7FxKMtiGN/0SPO0AB5xt9LxRQy+6x
   mZhmMSF07FZnwdEUOJvgd0YVuveBuhxmN/Ff42i5M6zUTh6nkoo3E4uQw
   BAvPVcxM+WL1JhObdwJJ//UZsUhd25KAvB5Ez7A/Cm3xCLMUiPAeVIyW/
   kvpf+rIecONcd1lGsRrbRauTH1hTe7WvHogW0TeyNP+G37MSPn1eW6eQy
   njQDVSj2JdrPvyFTy+Qq7cO+tUoZM5Qn73LHxGdBfzbX0Y3F3dMM8bupG
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="256413466"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="256413466"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 11:46:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="598827708"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga008.fm.intel.com with ESMTP; 16 Mar 2022 11:46:24 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 11:46:24 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 16 Mar 2022 11:46:24 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 16 Mar 2022 11:46:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJNl7J+SbvqD3H3PkA+65saMFqLOeBwcNYlA5kK4NKA5viMzaXTdxUyjfsbEsKcAbP4nDl18NnochywW8URmkbe+IWRvoWCZJFNlSD9IbdN3AQ+RPVKrYfdKLa/JleWN6oLJHRecV/eU/jp4455PcSz/wL67/m6psk85ZF+LcZi3m5s2kxPnnmrd8ByBNKlzbz3kvUe8ctPs+3hpcU/mC410YY06sbKKUklbTJDDSfIkTTNFzFKfcJxXLBQ0TbTkab4S3RSgyOT038fuV+ZvadYKYWRo6YP/xyLhhhhUxwrMjAeQQwLqdQpnwhdqKAQaC4dMGMVfDjuqm9cX7EfuDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YE9j+85PhW33DQTan5atfrpwYjP3QH1j2D8jjHRKRK0=;
 b=TN+LKJAP6YlzPY3PkoWmGpEnftLfSVt1O0yW8kC3O00djeAHiTZMagWDcXyFFaQRyVu49KABHwYwei/89Hbuys+SBMBYmoREYPPCVS7jybBdgdgqN1mz43bx8x5VvR1lObC0lkWOB1TiGSk8BLzFnmQQuQk9R5cVZvJ3ocoV40D/DLU75JIQCkguHIBg7TEGzFO1ZiFoaYV3l7bWNn3XyJ1W7uUAIdkSUXCluFvz8qmRgkmIzFy2TZ/yrMsZGJJGj/mM2V/g9+iQdNb+A1cjbr9wRr18/lHecXRJwILjwqilJtFk8H4YUTw8JC/4fVe/X3CXb6qC5aBnIotnBpbMXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BL0PR11MB3121.namprd11.prod.outlook.com (2603:10b6:208:7e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Wed, 16 Mar
 2022 18:46:15 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81%6]) with mapi id 15.20.5061.028; Wed, 16 Mar 2022
 18:46:15 +0000
Message-ID: <994d8ead-bbbf-bfbc-3074-3594cc0ff537@intel.com>
Date:   Wed, 16 Mar 2022 11:45:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net 2/3] ice: destroy flow director filter mutex after
 releasing VSIs
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>,
        Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
        <netdev@vger.kernel.org>,
        "Bharathi Sreenivas" <bharathi.sreenivas@intel.com>
References: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
 <20220315211225.2923496-3-anthony.l.nguyen@intel.com>
 <20220315203218.607f612b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220315203218.607f612b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1701CA0001.namprd17.prod.outlook.com
 (2603:10b6:301:14::11) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35631cbf-dbee-47e7-51f0-08da077d3fd7
X-MS-TrafficTypeDiagnostic: BL0PR11MB3121:EE_
X-Microsoft-Antispam-PRVS: <BL0PR11MB3121BDCC1233D05F7BB7C4ACC6119@BL0PR11MB3121.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kuYRPlJhep8kMuatLzIsM5D4sK3whWOetMD4yi4C47WBkx8XzMWzPJyqtwVo5UG8o0fedQcbkusDNbK1SdsldZ3Z/IEtPImHOnLrE5AnyF4pwTphujD/KNxchhLkauvd5qmkjYcZoJmGp/XQUA32GlpP0/5E3kRl2wdtRdVdWerp8LKw2wAAvbXtef7Ij/OkRxDovQBezHdibRIlr3iMRTKDp42/ZQz9Hkjp40DTwUaTuqlC/9ZbDZZGcBQOTP1PdEplgWvEE9Q+Tfo2XYwqgjoAUQUY9cpuCdHAFg1NwzoLWfgP5MjGcKbMBcKOdDsjVVMWE0oPT0xSvV38idp3mwx+yM1X/Sf64AR1HFQOOOrox9aZqnetBeBBH3pWyUtOhWqNrWLAF16hoJvNQAW7M//UlaCYCkdgGs83Dybb6s1wW46IS817sl+V8AQ/857rNo8EALqrVw1YrE+dGL9VQ1JZtbqyPQnloJ5t7nqMiinOhv/He0iGvmF2vvdwHQe5DtFhVFoA7qpyEW8NJ24mIGYaxJ+QUtVHhypYRuPpjh20cZf4MxBThsdOkESocX4H2p3y3FXwHpsfHU+y2s8KAEuF8j3yk1X8UDY1LSYp3SdVtlgDaIFxO7lPvdQqG15ASy47MJ1GGDFBIUwYLb6I0K3RgfR1PfdIAPOVk5WAfiY3pU0OIM5eAfpUKjaYughFGDAaBTnZ2MzZMGvOQfHjCtfg4aQD0wv2recLm3+xdtpUWN+ec56POmTHl4M7QwDg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(2906002)(6916009)(6486002)(31686004)(316002)(36756003)(83380400001)(508600001)(107886003)(26005)(186003)(5660300002)(38100700002)(82960400001)(6506007)(6512007)(6666004)(86362001)(66556008)(66476007)(54906003)(31696002)(66946007)(53546011)(8676002)(2616005)(558084003)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zmh4RDhIQkoyNDdyWSsrKzc1RnZUVy9oQ25FUWcwN0J5ZXdBOGhkRktjQWdx?=
 =?utf-8?B?RTA5R1pzNnkrVWlKNlYxckJ5eHhOUmhQaXZSVzZHSE10WlhTZXp3amc4WUc5?=
 =?utf-8?B?ZXZSMXVtSHk1b3dKNHo5empBY0lvU1FGVlYwZXJrUzZwSzh3TTExT3RJZjN1?=
 =?utf-8?B?VCt6RHlJbGhuZEJJKzF4VFBFREhUR3JQemVKRCt1cHoxMDdNWXlaQTA2Mi9K?=
 =?utf-8?B?RjRlSXhBVm53OTNJZkRYZmdDMlFHQkt3RXc5SlJRcjdTZTBPVSt3S3liSW5m?=
 =?utf-8?B?N3BpNHlXdjdRTjZiVDVqZ3FUSzhzRXhPVUxTQmRIQVRlanFEdVhSY3A4Z1RS?=
 =?utf-8?B?NWNJdXRkaVhRNjVabk5WNnBGaXBtcVh3RGIxcktoNldwSFd4Mm84QitTUXVQ?=
 =?utf-8?B?amphV01YY0tqbDN1R3g1MU0xUUF5emtKNzltY1VoVXZoS3ZyYWx0Q0MrbHJH?=
 =?utf-8?B?ZHpXZDdjdmUxcUF2WlJ2akltd2hFUENCNDE3Q2ZNT3B2VDdxcVdLaVdyWk1Y?=
 =?utf-8?B?WC9iK0lvbjZKOTFQQ1QyTDlKbkJGdGJBMjRPczhwK3djeGw4ZEZCaEtWdkN2?=
 =?utf-8?B?OXU1RU9OOU1kZER1UXdJdjVxNmZ5QXd5OEZKWEhuYktpcjN3c3RVQXI1eGR2?=
 =?utf-8?B?ZjA2MGZWTEdBaDNaYmJTUTlRQ1VPREFoWGVLSHRRQTIxTjFFNERQMWt3bGMx?=
 =?utf-8?B?eUhCb0k3djFGT1N1U2tQckhMdmFaV0Q5T25YTGxoNExEME9yY3ZHc1JJek5C?=
 =?utf-8?B?bnpicFYvdFp4TnZqRXBYNGcyZktwRmRTWkpGZzdmWmFaNS9FQkxqRXZBOGI5?=
 =?utf-8?B?dUhLMlY5MHJUMlVScmpQYXlGOGF5RTlqM2hoNENCZzVkN00vdHZJUzdiZUNu?=
 =?utf-8?B?VmVlZXpDUXpuZURJcHdCRjJZQnBEMXZuWDVuazljZVZOZjNRS2hXcXpPUHlt?=
 =?utf-8?B?TkdpQ09kdHhqTXFpbFYxSUJBRnVkWlgwSy85SGJWUEZKMVJaNUEvdGd3NVJP?=
 =?utf-8?B?Z1g5RXNYYWZQakw0ZnR4SDZpbVNXczd2N2ZpYm1DSWRoNmNOeVozRkRyRE1F?=
 =?utf-8?B?TjZqMitYUHc4WGd4c01oTVRNQ2ZtMjhoMlpFK0dOR0RRV0EveG9LRmdZdkJy?=
 =?utf-8?B?K2VsSkdSSGpyM2l1RnF0QkRPanNiak81Q3hhTEpRU2JVZGJ6MUJnSFk4RTll?=
 =?utf-8?B?NnR1RXZmQkF2T0cyelBBVzNXSmNZSkdmRytvS1NzSVg1TGJBV2hlTE1rRzV1?=
 =?utf-8?B?YytCb3pKelFaeE4rc0FhcDRhKzIzYXhFVkx2L01BdnZPb2JTdmRxc2x5UkVV?=
 =?utf-8?B?T1ZxU3cveDdWR3JJdUNOcXExTC9IUll2eld6dXlZbnJuK0QxUEwwSEFwUDN2?=
 =?utf-8?B?UE9leHJiK3VuaitEb3JGa1RINnRXaFNhbUE1L0hiZlY5SFdkYXVib2VLZk92?=
 =?utf-8?B?UlBaYnR6TFFHeHV6SDRaVzdzOXJWLzdxVlRaRFZFZWpWejFlYnVvWlB4S2dH?=
 =?utf-8?B?Mi9kY0cyNGZLVG1oY3FsMGJGSlFTWFo4MENQUWFYUEhiOHdsbEpDcEt6a0t6?=
 =?utf-8?B?WG45RWp0VVBLMU9MWTdPenRjZFJkamEwS1NxQ09rUUdIOHVCMVpCcGRSUUha?=
 =?utf-8?B?T1A3NXVwMlZNaHVWUUpkL0czLzE1Ry9RZzA1bks0Mzl1UmM5NlV1MHdFVytr?=
 =?utf-8?B?dFFvL1AwTnZCZUVmZjFJbXI2QUdiTWF5TDYyV1FiVlRwcmpzQk1BR0ZnOU9M?=
 =?utf-8?B?TTFjSWhaNUY3NFdWd0t1cEJmWW5tcEVLNHBzR3JxeG5ZWHdYT3plSWdJYmNm?=
 =?utf-8?B?V2cxeU1IZ3RmOVJLWEUyaVk1WjV2aGpFSEtFKzE4cDNFVDdVMHNIRCt0c0pu?=
 =?utf-8?B?eXVYRjdKOTYrcmFTcXM2TDVsWGpKUHloK2I3azhuSEdvSHV0YlYzdnNyQjRF?=
 =?utf-8?B?WTdGK0Q0V2MrWG1mcjZ1RFhmajVQSGN3cG9pM2Rpb3czd3VncWpWM0dSVlgz?=
 =?utf-8?B?ZUF2M0cySnpnPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35631cbf-dbee-47e7-51f0-08da077d3fd7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 18:46:15.1916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4SGx5G9ntjVBegW7R1hU29kO+47yg8ByF0+qVwurhczRNNaj7gKQGCw1cTEN/ZjyblrZN8BWP6w56+Crf+SuIGvroJj/zt1R7CwJ2p/bQPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3121
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/15/2022 8:32 PM, Jakub Kicinski wrote:
> On Tue, 15 Mar 2022 14:12:24 -0700 Tony Nguyen wrote:
>> +	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
> nit: maybe uncrazify this line while moving it?
Yea, will uncrazify :)

