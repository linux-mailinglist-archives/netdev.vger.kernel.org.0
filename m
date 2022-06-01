Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4DAF53A9EC
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 17:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355380AbiFAP03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 11:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354236AbiFAP01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 11:26:27 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC64996BA;
        Wed,  1 Jun 2022 08:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654097185; x=1685633185;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zq18k1wXu7TLaWYFif4QTWb20oYIYjwB9mDMAFjel7c=;
  b=c6zUbCjX27wLebG+wpPtj58vkc2/DYFZhxsr0m6JMYHAtdYA8AlX6UWr
   QoirmVkriExXA+b8I2TBSzR0Soll2NTF15dF75qL9ME2rkG6yt0ul72+b
   vR4q7gZ05FZaKCdoMKCqU3nE7h6gJHUktxvpG+IbpSssIc+9K0tvMPtnu
   0jEYkgha6cLeb+ZRbv1AVq1lOW2gF5y9AYU0X69LxfgksBeCSsP3YHS3O
   THYncUIXe6OyBz/7+bOAWk0KYmJnx3ZPrISEOj7X1dGtycnR4Kczw1Itk
   KRs/7NSyPY+pK/0NasPGDY2XO48Q7UNtfEQpt1ms2xC/aJbhOO/XB3vHA
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="275636297"
X-IronPort-AV: E=Sophos;i="5.91,268,1647327600"; 
   d="scan'208";a="275636297"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 08:26:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,268,1647327600"; 
   d="scan'208";a="667474818"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Jun 2022 08:26:11 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 1 Jun 2022 08:26:10 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 1 Jun 2022 08:26:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 1 Jun 2022 08:26:10 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 1 Jun 2022 08:26:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCPdS6G8MrCplprZeOEV/8zkfco4TH7mnu94ft09g5fCHjlX0jTrNMFnXIa4XkXnw1qyK5/TCFjjomGftdVmnEBDrNM9DmuCF0Eu+QfCGt/BC3fbdrPkDXPVP17z4uDhxMBGzgPhn22UjQ23rJVOVCX+HAmHnU8RDmlLIDA4+HkdlvNexZKUUDFIMQZVkhZHJ7C4I9Y6gXwLJ+FlzLDYM1mgbzl6nR3c9gZA3F4mvULM5GBUpRO7Nm+zf3wk6/mdJ42BKSFv/tDnkf7YbeLn1UY/RQBnrKz8V0WKcOph64ckmlv4UM03s3OXGaOVJy3Ya20w9QHo/RW3uuQIGpzk7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FSm4geWnfeVTRt8z4UhyXDY3RC22o1NrAtAAfPJRnE=;
 b=KxIhqheH4XsE/vhYv4CL0e3k/sotkcyqdPOalTjB978pOz6fMUjQj0lOU+eky6l2NVNtPfx26LVH9+qJhJfyqubPNcPeul/y93Cao3W9IF4A5KB86qOVssKgKd2DM7Wj4lL+MkajO0vjUt1Vvq/6BBKf+oq2k6RbQtWxwHl9XLi0H+1OrGeDi/CdoiI7LaqHaoBxrIBglYKGicRIFvSHZyyi2TYXrrhtu/B0mnWfHH8eBRNKXvlvL7l2+DDVpX94aPQQkiqchVBnxLgnPM4t1lEtp8oI4uqVEgM6EIv808NeHB0ruNfj9SiFMbOgDHDucx0LkUn9wHrf1wrivpZkLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BL0PR11MB3345.namprd11.prod.outlook.com (2603:10b6:208:6f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 1 Jun
 2022 15:26:06 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::317d:11f9:2381:a3a3]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::317d:11f9:2381:a3a3%6]) with mapi id 15.20.5293.019; Wed, 1 Jun 2022
 15:26:06 +0000
Message-ID: <96a94d61-6fec-7df7-4358-8e16a3e9b46f@intel.com>
Date:   Wed, 1 Jun 2022 08:26:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net] ice: fix access-beyond-end in the switch code
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <linux-kernel@vger.kernel.org>
References: <20220601105924.2841410-1-alexandr.lobakin@intel.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220601105924.2841410-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0017.namprd16.prod.outlook.com (2603:10b6:907::30)
 To SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69088f51-b6ee-4910-b8c6-08da43e30bef
X-MS-TrafficTypeDiagnostic: BL0PR11MB3345:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BL0PR11MB3345EC73DF5A88E5D879D8DEC6DF9@BL0PR11MB3345.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dU50pVsl9VvxAjHf0v2B0l9d8KVtIRxMpOGCG10M933gZaYNd+bAGSXTfS46sgVs7+0Ee+oaP7f67Tw0H2ec/Bip4TAG4qjQ+ke++AJ36kgD5Zggwwfo8TbsM2apCxwIi9j/d78xRgwNKIxCM3wGXg3fqntw72NjL1SY7vibN8P6NKqd57KsSWQgWov9FlifigDX7N8/GFiB3gZpreRAIPIqRk7tXIFRm91ZGAoxLBYrSIc9XnxK23O7QuacdfUMV9AYbbyGGVXJzR4NhSHTkM3/kAOrJRO8TTTxrF7mypmcwDuV5b7O4+WBzQrepDQrCemGuH3nhl72WSH2w71TVWx8qHDBsLsT9T497bfAkbVcnkMAdG9DvqWyz/kAioNfy9UOMeDpC7wgFJSRacfPvP+p8P3iqSxdmQjMGReelN6otV/QWuCZ1XUMPjWMP7uEeIpm4LCYxI/kmm39GN7IfUp7sLxzvsdy47ShoMXUzzATKbupUKmNpvqTQJJ4pLVgQcDFZDAj2P12Z6h/wVK0kiJdgxzPcl6SVVysdwr1AfRHnlKMS7akUbkOeZYRLibu/tvruUjwONCc5r770xZi3gYWfPowd8lg0HjopBpzqe5mu87NziFG18rqfOBafhzhYKp0O6xb75u62Ja1AutaZdtIK3gEBcnvjunvyyAgtr4GbC5VsiUHjQZ4E6Ej3xYtdsB0plaMfbD8sVAQm3lpqkmP7lREWx3XYKQ2KPAaZvo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(31686004)(6512007)(6666004)(53546011)(6506007)(31696002)(2906002)(508600001)(83380400001)(6486002)(316002)(86362001)(54906003)(36756003)(5660300002)(66946007)(38100700002)(66556008)(66476007)(82960400001)(8936002)(4326008)(8676002)(2616005)(186003)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0lwR3greGUwdlpRS01yUnM2eW5tV1BmRGhVL2lpUlZnVVV5aWZCNVYyZXpH?=
 =?utf-8?B?WDd3N0Qyc3o2K1B3V1ZOMEN5akx4U0c0RVU4N2s5Q3piNnlnOTQzcFdUMWpJ?=
 =?utf-8?B?RHErQkVzS1hwUk1McXprSFZsbisrWmVNeitvSGp0Z3hzdlUrQWxLQ1d1dVNK?=
 =?utf-8?B?alBpTFFWUUptOGJIUkx1bXRpMFBLcXVBZVcyNER4TDRTdXREOGRqTGVIWWZl?=
 =?utf-8?B?dndtV1YrRW1BS0twY0ptQ0JJdlc1S1cwdUxVR1JyNWlzbVpRSG5UR2cyRC9n?=
 =?utf-8?B?NzdmZlNrSktkbWR0aEIycGdsRDlZSjJjWi9PNXRPdzBCeHpiUStkZFlqaExY?=
 =?utf-8?B?VU1JSDdsK0VuanJOTFJOZFdWUldRbG41TlI2UzhNbGthYWtHR1lLa1JBTStv?=
 =?utf-8?B?V1lFTDQ2ZXp4N0lPL3didVNBNjRaZytEWVU1WUVjeXNGdzRCU3c0RXlFTVd4?=
 =?utf-8?B?RmtqWWNhNWZLMnNpc2d5UGZMUDhZSm5uK1BLK1V5M1V6OFd3a3VSb295YUVy?=
 =?utf-8?B?WEJBbnJUbmY5UldyNjVKWWZzVTFCdUluNGNYb2RLVW1URk1DNUhqcDdxU0la?=
 =?utf-8?B?cTYvd0NFSWo0MGNpZGM1UHFsZlJYM1FJVm1hNjdOTExHaC9OeGlHV2lVZWdH?=
 =?utf-8?B?ZlpzSi8xYWQxd0Y4MjRHYm16Z3YyVTlZaDVxRVZTUXBNOFpkQXpLM0drK1pF?=
 =?utf-8?B?M0VHWGlwam43bHpqanBJTVNVNVBZcU43MmZhT1l0TThrZFZXaTBmMXpOcE0z?=
 =?utf-8?B?NDNqRFNtSVB1a3lKdWFJOWFBQ0VCeTVzUDgrMkxXTEttYXhwWGdnU3F2bzhI?=
 =?utf-8?B?SUdUb1FJbDlJcXFXK1BRRk9HYXZocjlOZmpzQUtBOE84a3hSeCtoYVpkSEE0?=
 =?utf-8?B?RmNxOU1INmdBREJIUTNINzRDOGVGcWJ5R3NzZ3hMa2prZjVLZmU5Z05qeE1v?=
 =?utf-8?B?bExBYXhVZElFUTJ4enVqenRDRzkvNXg5ZkJyUlk1WVJlYjRLelFoNjd1alR2?=
 =?utf-8?B?V0psZ1UxYWhDSWNhOHJFZCtkcFhINXE2VElYazVWRG1IQ3UyWnEwOFVJU3kv?=
 =?utf-8?B?SVFTaUNCNkdSMld5MnVBamxwam5EckJ2NUJkVFZnMmlWaXM1cmFSTG5FQVZM?=
 =?utf-8?B?ZFJrdnlzVU56WjM1Qk12dXM4Wk11TDVFZWxpVmEyMFp5eEQ5RUlwM0ROOTRK?=
 =?utf-8?B?TlJweVE0aGNFWWVwUFQ5YThkakdxYmREUU82SGxDV2tyVEljRGxMSjBGZjhW?=
 =?utf-8?B?K3h1Nldja2l4MHZ2Yjdza29xaUY4Ui9DTXdPd3Y0OFdxWnBqdmdCcFpSb3JH?=
 =?utf-8?B?c3d4ekVwd0pxcFhpK3FaUWU0NFNxbWIxMTQwZURqL0JTcUdtN0NHR05sb3dK?=
 =?utf-8?B?RkJwTWFmZWZXSkttMmJXL3pKakZvT1RsUEFiVWJKZmJad1RzcTlpWmwvTExN?=
 =?utf-8?B?S2VlamlkVDcvMHNucVp4aTJCaHIyejdOWGlGOFBFMXNXdmV3MmVST0FFVDRW?=
 =?utf-8?B?aGp4ZG5oK2twOWlTa01mK3g4QWNwOXlhQmRZZVR0Z1RSOGpDZGRUc0l4Vld5?=
 =?utf-8?B?dTNPTFc3cEREYmN1cFQ3dmdybXhEYjdrWWVTeUY3d1F2ZlBoVktTU3p5eHpB?=
 =?utf-8?B?eEw5RnBDWWpwMENtN0l3ZEZWN2VWN3FFa290NHVMMngzUHkydTk3blE5dkNs?=
 =?utf-8?B?MlRqMkptQkV1VUV1WmprclpJUlM0akVBZExKOTF3U0poNVg0YmZjMmJiVUZM?=
 =?utf-8?B?Lyt4c1pYL20zV0R2WlM3Y2Y1dGpvUURpYXdydGtNMjJ6aGZEWGJGNzJmMElw?=
 =?utf-8?B?amZnUGR4U2NqMGY4SmVKTGx0d21qc24yRUpLaEtjMmF3YUNjTTE1djEremhl?=
 =?utf-8?B?aWhnZlplSEthVnUzMkdWT2RrKzdDektlL0tKMWJ0YStlQUdpbThYQlNXYzhn?=
 =?utf-8?B?TWxnZjE3RVBoRXh1azlkVFh5ZHZtSy9aQUtJck1TanVMY0VVdHcrN2xjb05o?=
 =?utf-8?B?a3ZySHZqSHJwYW1WbGRQbGVBTllVN0dZakZ1UXBwR0cxQm9jVGltekQzd3Ur?=
 =?utf-8?B?cmVwejJaekYrR3htM2llYjNjWFhhOVdDa01CVS9wTWpRc1FhNU9PdmdKNUtM?=
 =?utf-8?B?S2ZndkJSVWlRcCtCb1dZRGREdEt1clV1MVNRNEswdkVXZ1FtL0FoZytsY2JZ?=
 =?utf-8?B?VWxPOStQMVFNVkN5eU9MRGdkSWx6ajhGWjBkWGJQdnB6bDczN1AydnJPbWVj?=
 =?utf-8?B?WWRQUUkzOTVKME5mUFZtci9tTG9BSitXSEhBMFZxUGgzLzhYakhFWU5UVVNv?=
 =?utf-8?B?NkNnWk95Zjd6RHQxOVBKSUZGNHoxekxDeTJlc0liSnlxdU00RjZ6UmRnN3Ja?=
 =?utf-8?Q?ljiKnraoDC3SarOg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 69088f51-b6ee-4910-b8c6-08da43e30bef
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 15:26:06.5587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: igy8MQh5g/G4vNh9gml6+WfS3tQdGMEYfZ/ZyQ4Iu6ardG7unYVC3ZABhmxvMM2IO3md81+oQIOBjMupB7wx4YBC1R9k07FsLY1fHbxJ/IY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3345
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/1/2022 3:59 AM, Alexander Lobakin wrote:
> Global `-Warray-bounds` enablement revealed some problems, one of
> which is the way we define and use AQC rules messages.
> In fact, they have a shared header, followed by the actual message,
> which can be of one of several different formats. So it is
> straightforward enough to define that header as a separate struct
> and then embed it into message structures as needed, but currently
> all the formats reside in one union coupled with the header. Then,
> the code allocates only the memory needed for a particular message
> format, leaving the union potentially incomplete.
> There are no actual reads or writes beyond the end of an allocated
> chunk, but at the same time, the whole implementation is fragile and
> backed by an equilibrium rather than strong type and memory checks.
> 
> Define the structures the other way around: one for the common
> header and the rest for the actual formats with the header embedded.
> There are no places where several union members would be used at the
> same time anyway. This allows to use proper struct_size() and let
> the compiler know what is going to be done.
> Finally, unsilence `-Warray-bounds` back for ice_switch.c.
> 
> Other little things worth mentioning:
> * &ice_sw_rule_vsi_list_query is not used anywhere, remove it. It's
>    weird anyway to talk to hardware with purely kernel types
>    (bitmaps);
> * expand the ICE_SW_RULE_*_SIZE() macros to pass a structure
>    variable name to struct_size() to let it do strict typechecking;
> * rename ice_sw_rule_lkup_rx_tx::hdr to ::hdr_data to keep ::hdr
>    for the header structure to have the same name for it constistenly
>    everywhere;
> * drop the duplicate of %ICE_SW_RULE_RX_TX_NO_HDR_SIZE residing in
>    ice_switch.h.
> 
> Fixes: 9daf8208dd4d ("ice: Add support for switch filter programming")
> Fixes: 66486d8943ba ("ice: replace single-element array used for C struct hack")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Marcin Szycik <marcin.szycik@linux.intel.com>
> ---
> To Tony: I'd like this to hit RC1 or RC2, so would it be okay to pass
> through -net directly? Or via some quick pull request would work too
> I guess :)

LGTM. I'm okay with it going to net directly.

Acked-by: Tony Nguyen <anthony.l.nguyen@intel.com>


