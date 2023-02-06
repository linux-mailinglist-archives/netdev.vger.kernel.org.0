Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF44468CA5B
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 00:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjBFXOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 18:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjBFXOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 18:14:11 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65EE5270;
        Mon,  6 Feb 2023 15:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675725249; x=1707261249;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XeVQq1OwphYgjmgB+VwiEoukS6qXa5gamRi6ARKrqyg=;
  b=i9CgKLWctqDXkG3ym0D3MOmZGbifDLVxOEc4MZjv9i+L94zbOyzG9y2e
   eXJ1tCvWbrzEpLQylTqia5VGfGstycLyWl6SpM5mAb06OGAS63AmtWxzh
   yE3lhldqWM+uCTywaBIlODSj+AvzINB2Ez95Jt06wx/WFTQtOEAXdaaqe
   PHwwHlK4N5EXylOSwLC8zvWM91a4NWiF8AU60DAt0ur+65bZuijKeDWyk
   36THkzRBtSYSV6HYZQ/43LrFco7S3VYuQq/w0GU6B2mGmUmvoEmoq9pCH
   EEiIstL76MOKrgRfbl9V6dwIVdtcpF7lJNCHBShFjovzgUzqpUbWRz6+1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="312993888"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="312993888"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 15:12:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="644224231"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="644224231"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 06 Feb 2023 15:12:41 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 15:12:40 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 15:12:40 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 15:12:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzsjuVU5+7bn8tmdAZ3sADmIJ3PR0mCdF7e7LJ7Pz2fS6tRjuV2DAmsDKBQmCLPn+Nq0TIH5hHUqT8oe6pN37bOujnSCN2VIl0dtxD/j+eIUJt5hGwK+hQlws3WTMAsDvhoZ6M5iO7BsN/Bqy5c5JwkCQzBAeK6eMZnTkBNvqe3E/f3Avy3UUrCW1NhPrjgU9rj1qyjq6k+sFOYtggl0QzPOqw12AgPg5P445+KYvtlh0q5EcjWUzlGeHDPreB0At5qVT0CLEUFhe/8vEYhPOCWPq8LnJOogBKGLLt35xkVSLxdKfH5p1R0MnXDVAeA9cVz629HnQ1vVod1t2IQlvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0/xxLzPyGT8+VR3sVgj96GRweuoxi3OYKynshoFOzU=;
 b=CaJaYo4/0zp2PKh+YGEnDEtIUiQENrWfMcwA/xMjFQvMsRJgSl2PKysh3V/FFIOXOYJLRH/AIhwdm11rO1O7/BUXEgaukEbjZU4+14ZkkZmdBR9ZuPWimHk2tqjcI73qA9wnkbUnuAxP37bq8dsL9iHT06JAMcf0X47RK10cRReM/lPi2gPQOWknkzT91fUFy2mFZUGTaCQhbIcU75EROx57S/DP1uaez4X7p4GhcZTG17FYTLfviqpHQjqyDjMrHRUyxGhuCCjZa4MJj77j1toYx35z9J84f67XnDy5PuJci5IIRcyHpRbbMapiFJVwM24uzS90KBLoSyHv+S/uag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DS0PR11MB7333.namprd11.prod.outlook.com (2603:10b6:8:13e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 23:12:33 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed%4]) with mapi id 15.20.6064.032; Mon, 6 Feb 2023
 23:12:33 +0000
Message-ID: <cb31a911-ba80-e2dc-231f-851757cfd0b8@intel.com>
Date:   Mon, 6 Feb 2023 15:12:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net 1/6] ice: avoid bonding causing auxiliary plug/unplug
 under RTNL lock
To:     Leon Romanovsky <leonro@nvidia.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        poros <poros@redhat.com>, ivecera <ivecera@redhat.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "G, GurucharanX" <GurucharanX.G@intel.com>
References: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
 <20230131213703.1347761-2-anthony.l.nguyen@intel.com>
 <Y9o1wbLykLodmbDd@unreal>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <Y9o1wbLykLodmbDd@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0055.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::30) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|DS0PR11MB7333:EE_
X-MS-Office365-Filtering-Correlation-Id: 08714201-2333-4ca3-0c87-08db0897a06e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M2ly9P11grcP2927Fs02/Nk0ePRYINHCRPDNZWYtJIUnINPQyuITZQGwTclvaF/Veo9Ctnp/LzgWer+03klVVdNsa8QdKV6AphihrZBPyGDmmWnSspz9lnc1LPWW3P/D+N0TnX9U794obzFhWWbyCxjm2W4kgKH74tAD5bnR5MEufHx4yh/7aEQY4/ewVx/K5WicAmYSei7YshrKYXgTRWe6i4ec1FYL9e5c26Xo8QX/Bj6AMcQx9rYrZ4/eZDbAQyM80Bb0glrlOSVPj1EuP+ycOaXmPGQCCM9gMLCDOcgkihii+atuC9uk3XvY7ux4tvJozspL708AkA3rcJ0dl1X028fCeJrkZyn33WR8+N0TN6Q9eBcsfSbLgPL2LtUCDPd6ymNS9paUwu3OdlgPJSjnon4QiUkxg/7gnLEECl0lyedBJd62A15cQ21ChxvHgDvS6PCFK1TXpaughn7zi7gc7rFp7OEkgd65K42+XgoAtA0AJetZmebVQ3HRp/LD17AjZ4HHLiacyyY8DxqPvA78n9o7oyTaPkW9CwadFUUnPAIBsUldpCsFDkL08/ZeCVePKa7uMJ8LUCyv5JEAsG7YulWIp/bdnFlKgGSOH0RiEluCx02utt7cFzXVmd+oQeMsgZvqK9tbDzjPLgpB7aS0HIOrglRZNq3/kYfKedYFDp5W91HTQINoWg58+CVKbMtKNtces8K1uS7Nks/FscTVWhsBwC+M2aCpQvDm7IJZ7w33Q746cPdf7EpDxCVlbPV/+UH4cxTiYllzjDheEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(39860400002)(376002)(396003)(451199018)(6916009)(6666004)(6506007)(2616005)(966005)(478600001)(53546011)(6486002)(8676002)(186003)(26005)(6512007)(4326008)(66556008)(316002)(66476007)(66946007)(54906003)(36756003)(31696002)(82960400001)(86362001)(38100700002)(83380400001)(5660300002)(7416002)(41300700001)(8936002)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGV3cDFuWFFDcG9QNGZ2U2pNcjBZWjdRN2gwOURRWU44WDEwYVpjcDFzRlRz?=
 =?utf-8?B?TVhxR2xvWkFiWXRjTW1Cc0c3Z1cyTDRFMmxzQ1J2Y2ZCa09wQjBNSG14Unc2?=
 =?utf-8?B?VlJrS2YyQUErcG1HajJJSloyRm1TOVNkdGM2WEpSbEN0dVAxL2orSUdNYWdQ?=
 =?utf-8?B?aVRzSDhTcXNuTHplUXZwZytqMU9DSXRVZWdFT200NXg0NDhReWs5NjVmUjNi?=
 =?utf-8?B?aTk2R0habS9hcVB6QmR1VUZtM1BQMTR1cDE1VWhZS09sQ1hpNU5yVXlQbVNw?=
 =?utf-8?B?WkNDNTUzaGYxZVIvWnVDdGJEVGZwUGtzWG54NnM1VWE1cVNhYThWSGZNeWZr?=
 =?utf-8?B?WnFkd1RvVzFONUZFQmMrajkvalNEcFdpM0RObWxaMXA3ODJBWnVodTcxZ2lM?=
 =?utf-8?B?M2tyWGZaVlg3bHZycjY4TFp4TXpScFNlaG9JTEorcWZxUStycVpHdmpnd3NM?=
 =?utf-8?B?S2RpaEVtejBRQlVibVB2dU1Cb2tmNVBBakFOWDFBSXdDUjQ3c2VXVEZzdTJt?=
 =?utf-8?B?dWwwMUUxTHVKd3hFMUZrM0V2aGN5aE5pNWRvc1FhT3pLSzBKR3FZc0l0UDhP?=
 =?utf-8?B?MGN5SFIveWVaNzV4cGNhM3V0QzgxS1pxeW5rdjl4eVlhY1BGNXk2aG5kTXZw?=
 =?utf-8?B?VjFFZkpDN1FqbEJFdjZxUWxjSzRmRFVDU09WczU1aCtSUVVvek5PdkNXVUc1?=
 =?utf-8?B?d0d3OG5NcHMrMXR5cUpVbzNTTzBIQ3hiMDhJQ1I0YnVaM1lhcDI0TEZ3WmJm?=
 =?utf-8?B?N25LSEhra1ExTnEyL0xMU0dEQVYraks4RHorRVFJVWN1UTZTclRlaXV2Y1pa?=
 =?utf-8?B?dkJDZnk5TWhkSFRNdkx6MUkxTmRVS2VVSStxZVpnVE5aSkVIVDN1SXFlWFF3?=
 =?utf-8?B?ZzBXVTMzVG5lTmhYdWhEdG5yYUZBVHpUZitXVWE0cjMrVk16SjJndnBNSVZN?=
 =?utf-8?B?UGpqTTFuZW9iRGtCV3VlaXI2SHRuTFgwZk1yYWJrSlRObE5iNjRpU1V2VGlv?=
 =?utf-8?B?Q1ViY3pZUUhBYmJlRmhTL1g5M0RhTlFWRkUreFJ5MUVVRXlVYWxnYk8vWDVm?=
 =?utf-8?B?NzVFa1IxNmVjMTlFRlhFY09BZ3hNS1hvN1pCN2VyV2dUVHBHKy9CTG1wMy8r?=
 =?utf-8?B?K0k5SjJQNG1TQWFhdUcxSC9mUnFqMmU4enpTQTNGNXE3NmdTaXVlT25pb3Rh?=
 =?utf-8?B?WDM3ZGJqZ3poSmpYSk93bElTaUhSMk9pRXBrem1MaWROODRuZ0FUbVpISDBP?=
 =?utf-8?B?TDdxWEpuQWl2UzliNVFUYzhVOTVrT3ZMNUhYNEp1dGtvNW5HTzRiSldBbWhp?=
 =?utf-8?B?b3UxR2NkQ2FZM2luUnF1UnlwT1JxZC9ONkJmb0EvS25teW1ndTNyY1MwSi9M?=
 =?utf-8?B?bkY4Rkt3Z1haYWRnbTBEelZCNm9FTkRrUmxmdlh0V08yd2lXV0wwYmlJK0kr?=
 =?utf-8?B?TUxiQlVReDZsU2Fkc2dUVk5UNTliQVBNNVZ4SGtleGJmaGsrem9ueTg5T3VJ?=
 =?utf-8?B?cUxaMEVYRlU4RWc5Uko4UngveUMwcnVoRFlMY3duN2lXSC9PQkw4YVBtSWhB?=
 =?utf-8?B?TnVva1lMZWJ2QTBURVNJUko0RE5ERFZlTkt4QWF4bm5ncUtaTGw1T3dSNHJk?=
 =?utf-8?B?NWEvSHN1cjBaM2F2bXpVUjV1S0RtcXJEZTRVVmtFRGVaT0ZsUWlaRlBjMW83?=
 =?utf-8?B?bW13YjlaWW5QeU9aOXE4RklqdVViaFIzUVJhVWtHS2EwN3gyYTYyUTZvUE5t?=
 =?utf-8?B?OWFudE81b2ZDU2JQa25QdUU0ajVrOCtCZkpkZU9pV3NaclVhWW8vR2ZxQXJU?=
 =?utf-8?B?QTM1b2lZTDhZVzhVRGM4aE9sWnQ5UTJkUjVackU0RE9xdXREYnFhMnNnbktp?=
 =?utf-8?B?d3BVYzN5NXhHUWdHa0RUN0NTSnpGTFljUm1nU2QrR3dGRlJ3NzBYOFduZmhp?=
 =?utf-8?B?TDJQUHp4Y1JKNDRYbkp4UUJ6RXFTMVJ5bGZ6OEhsNzQxUWdndysvOTJLRnYv?=
 =?utf-8?B?dDdGL2ZJbDFaUVZxejhkTXVzREdSa05PclpFdU5EY2JUSk5UUlVYOFEzVURk?=
 =?utf-8?B?UGhIajAycFkzZHRhTW1SaGdOanpEd3ZKbHh4TlMyU3JVUjVyV0VWd2Z1d3Bm?=
 =?utf-8?B?UGVIYTk3S01IZTk1OEFYdzM3TDNRdmR0dlpxUDdybFFFWHQ3Um1ZZ3A0S2dk?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08714201-2333-4ca3-0c87-08db0897a06e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 23:12:33.0051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5+CPXR8l07XtGo/8Ecw4iCkgoZE7cj2dfkhAiUcPUb7e9NUdiohgoLOCIzLYJE3bJAPVS7Xbes2eyDhDETbcKj8ML+vgzpnQGq6fioO0edA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7333
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/1/2023 1:49 AM, Leon Romanovsky wrote:
> On Tue, Jan 31, 2023 at 01:36:58PM -0800, Tony Nguyen wrote:
>> From: Dave Ertman <david.m.ertman@intel.com>
>>
>> RDMA is not supported in ice on a PF that has been added to a bonded
>> interface. To enforce this, when an interface enters a bond, we unplug
>> the auxiliary device that supports RDMA functionality.  This unplug
>> currently happens in the context of handling the netdev bonding event.
>> This event is sent to the ice driver under RTNL context.  This is causing
>> a deadlock where the RDMA driver is waiting for the RTNL lock to complete
>> the removal.
>>
>> Defer the unplugging/re-plugging of the auxiliary device to the service
>> task so that it is not performed under the RTNL lock context.
>>
>> Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
>> Link: https://lore.kernel.org/linux-rdma/68b14b11-d0c7-65c9-4eeb-0487c95e395d@leemhuis.info/
>> Fixes: 5cb1ebdbc434 ("ice: Fix race condition during interface enslave")
>> Fixes: 4eace75e0853 ("RDMA/irdma: Report the correct link speed")
>> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
>> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>> ---
>>   drivers/net/ethernet/intel/ice/ice.h      | 14 +++++---------
>>   drivers/net/ethernet/intel/ice/ice_main.c | 17 +++++++----------
>>   2 files changed, 12 insertions(+), 19 deletions(-)
> 
> <...>
> 
>> index 5f86e4111fa9..055494dbcce0 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_main.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
>> @@ -2290,18 +2290,15 @@ static void ice_service_task(struct work_struct *work)
>>   		}
>>   	}
>>   
>> -	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
>> -		/* Plug aux device per request */
>> +	/* Plug aux device per request */
>> +	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
> 
> Very interesting pattern. You are not holding any locks while running
> ice_service_task() and clear bits before you actually performed requested
> operation.
> 
> How do you protect from races while testing bits in other places of ice
> driver?

I haven't heard from Dave so I'm going to drop this from the series so 
that the other patches can move on.

Thanks,
Tony
