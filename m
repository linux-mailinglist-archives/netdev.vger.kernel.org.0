Return-Path: <netdev+bounces-11539-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF57673383F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:37:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D214E1C20CA4
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6BB8182CC;
	Fri, 16 Jun 2023 18:37:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7650101F6
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 18:37:43 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781CC30E1;
	Fri, 16 Jun 2023 11:37:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUe15wrO0eRTARS/HsdQuQ1lb/F0MRqgo2bo3rhwI3RhP9/H9vaBHjHUqVpylIBCxfw/s3LjABLiiNwsEbg8jZg//S+Im9XZHx+P16OYBvJB/554E/6SoZzThFin/duCL0Opn2qJCZcyMPUQQTRR669djXbcgEMz3a+w47SNiLgby+gwiKjr28m9ZzPxGuJr4E79Xy5ygC/dtImUSWX3t9RZOJtTgSX59K/Axkc+h+zjmwpYmWN4eDvc3FlNogMLn1chGUQ45IkiDapnM5mKa5nhTHdPxQ0qQ28bV1M39BYJSYhP7y2hnAliPrzZYVNcueoLhLqBpGdP3rqdPToyew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIH4i9xCcdvBNrs3a8VFHQVaArNA5beZTBkl0gpLgFU=;
 b=n2geDxL8qUc5ctlivDvcZQNDtzhhW8B8wgXqbgZ1VZnpSFfdMhDNfWfyBwhyigYGgY1vLaNrGzFZSoi/qE0sKac8rrH0d6pO1jIYKxbBc6nx8Bif713cZ9nZdMNMITa9dmaXh3QxC2G2B/XA5Wm93MCF3ilTIoWvIxJpWAbOkMHGxEjX7SSvBlu//bNT/+PJR5iPkNtwrhzLc4O/l2kUzQYg158gFUgzKNu3snBC6A0ln+i6Kj+iUuOUIo6cldI6fTgt+CZsZxxTpCkx6pNQBydZXOQ/hhYkdAAOdQsXp1Zsozh5j+VUyKaxZMI+6gg9rytg0xtBZkSCI7Y9b/0Ekw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIH4i9xCcdvBNrs3a8VFHQVaArNA5beZTBkl0gpLgFU=;
 b=zSf01zPA7l9x0BOW4y37h0pb9bKWWR3pVBzS0xeRD60A0R8JM6lk3aVK1WU7TVdD7z7YNIHnOx/W1UvV6cy8bLVLuBet+4w38oFSI5N1pQAt5LgzZloMJOpA/R5J1rXhRwbJo8BbjOo5qFSw+Ei7n0+OicpTi194IVUW+5ESW3o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by PH7PR12MB5854.namprd12.prod.outlook.com (2603:10b6:510:1d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 18:37:40 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e%3]) with mapi id 15.20.6477.037; Fri, 16 Jun 2023
 18:37:39 +0000
Message-ID: <50d470c5-360e-c350-ff8a-db93d70ac810@amd.com>
Date: Fri, 16 Jun 2023 11:37:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v10 vfio 1/7] vfio: Commonize combine_ranges for use in
 other VFIO drivers
To: "Tian, Kevin" <kevin.tian@intel.com>,
 Brett Creeley <brett.creeley@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "jgg@nvidia.com" <jgg@nvidia.com>, "yishaih@nvidia.com"
 <yishaih@nvidia.com>,
 "shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
Cc: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-2-brett.creeley@amd.com>
 <BN9PR11MB52765D6E90B38CEAE04128618C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BN9PR11MB52765D6E90B38CEAE04128618C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR20CA0024.namprd20.prod.outlook.com
 (2603:10b6:510:23c::19) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|PH7PR12MB5854:EE_
X-MS-Office365-Filtering-Correlation-Id: b0546e1e-9e2c-4653-b0b6-08db6e98c36a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HAL4V+CsveacO8e7KkSZax1PZ2thFlPQbq/LlA31ZgQ1Gzu80Cb7lY9Qz45d4g0yzkvpZoFV7w0vpi2xTSlBgcqQYw/Kn3qvSUcMjo5i58DTFlxqgmfnp7SyMtowFCGw6TxSsaMS3rztM873Jov2RPkFSJy/YDiJnPi0AmkAYvU5Bbb7bnGnTz6BRfY7qWkUcZ9wvIzu0pHQGSdG9JOzmGqVETGiYT+CQMJg2RbRanut4E8wA3hOJNJxUyKmL+KouvwzoglVIcaIG7EqrkEPaYvZL3WWy6be1jMID1K9eBJ+D9HvsMBY0tnzZF1b5FMIHXf+09ORmMG0Sh7/ko1hCSViuru1J1KdlqR7drYDDGNhzBa+vpsSgxBm4sJCpbkfe640qQDx+UmVLQveXcRsAkRbB/MadSJsxYFWGSizfjZGxfLSxVyqUQADDnM7qDAIPSwtOh2k5/xJEymRSoua0yK/5hv30vd5d3XEZiaU93+/wbByo3LkubIf+L/wkumK+KpiiGSVWYNVE4UAej94htOTf48Po6ZDhHyYx5QZq7vHi/cCp4ZcbnpiEGrQpBZFEVC4hTQHeeRADsnGA4n39JtxJpOqgsLfpdNe0s/X1zSKXriD/9rPoTMCaA3ScSWpzC7JsDeL0PG6iGrB4yrZbQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199021)(110136005)(31686004)(31696002)(41300700001)(8676002)(66946007)(66476007)(66556008)(8936002)(6486002)(316002)(4326008)(36756003)(478600001)(6512007)(5660300002)(26005)(83380400001)(2906002)(6506007)(53546011)(186003)(38100700002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWw1TGF6TnJDUEJhTzFXZGI1dGx6VUtpZU5TYUYwYUh1MDBScEkxZGlLNEdC?=
 =?utf-8?B?WE5YckM0Y2Q1NDZiYWVrWFVCNFRGcDI2eXhwR2ZTSHdHRWVCcHRFeXJCMU9S?=
 =?utf-8?B?M2d6dE5mMXY3UjBlSmxBOFh1Ty9qWisrcy96R2lLVVlyQ3Vyc1ZZM1kxQitO?=
 =?utf-8?B?bDJ3c3hWbUJGcURuZVN1OTRQNm05UE40SENTUEJGWGhPY0V4bzY1emJQVE9F?=
 =?utf-8?B?YXI1T0dMUXc4dWR1bFJuU2NPUnUzN3J5VTQ3dDF1czBYL0Q5bWw4QXZTZnhG?=
 =?utf-8?B?Ty94c083TEREa2ZZczhPb3RZcHFXdHUvcXd5UnJ1d1NPUTJUR1pZV0R5RFBY?=
 =?utf-8?B?dytwbEo0SHl2QXNQamxWRmtTZytXZnFERW1MZzNZTW5BTW93NlRBTFl0UzJh?=
 =?utf-8?B?Mld0RGd4ZjNUaU96anB6ZVF5TnlXd1JnVjk0ZFVuTWxNQW9aM0Q5OTQ1dHhM?=
 =?utf-8?B?VHAxdXVLM0YvTE1nODRoa0FvSHNoNXdzREdGTnlZNkpPSkNJWnFhamtuT2tU?=
 =?utf-8?B?bDZrVXNPQjkzVURmekdQK24zR1oxZHhvL3FzSUNNaGsrOXliaFdLa0ZqN2Js?=
 =?utf-8?B?Y3N4ME1WVHdmZ3BkSjVFelVxblRmOGQ4VnpJTk9rNldlSDdQMlU1ZGFPVzRZ?=
 =?utf-8?B?eitIOUVkb1ZGaEJhV29qMnNyU3NEUm1Fa1gyTkpMZmYzaTJORHRDSmovbHNz?=
 =?utf-8?B?V1prRFovT0F3Q3Rka3Z2WGRvWUFnUGgzMUdwNk9waFJTQitPbEpBYWpJdWJG?=
 =?utf-8?B?MVhFNU43aDg0ZU83eDVGQUlRaE1EdzZVR2RSSWU5bHl3MUFBVmJXY1AzVWY4?=
 =?utf-8?B?aC9pbkhvRHVVVlFiNm1NZjhBQjB4ek9Nb2k5ZGp2RWNUU05mRXlhUFpjUFlr?=
 =?utf-8?B?T1h0Mnpubit1SzFBR1pOT0ZSbjZqZlVsRllLclVtSzVZZFVzN1NyVTBXTzZu?=
 =?utf-8?B?cmNoL3ZOSGJqK0NjSnY5Y0JoSklFTkhhZnhndW5sNzJSS3NqVzB3MHVWTzNh?=
 =?utf-8?B?STh4NkMvSGtGRHlOb3FTdXJ4Z2FJQ09GTm85d3ppdDJPV3NLODFjMFhsZjdV?=
 =?utf-8?B?K2FISTR5eXU3Z1Y4NGlCQkg0bUVOMHBFY0hOdk13OWxvQm50THQxcGtiN3Nz?=
 =?utf-8?B?Vmw4OHJTTkVpT3ZleE40M2pRczhjY2FET2Jzd3pYTzZmcWJ4N2hTN2pnN0ZF?=
 =?utf-8?B?ckhDczZTR1ZiSGpXS1ZJdDlkRmc5NjVYREVWVTVVZGdtVHkxRERyRnV1eUlz?=
 =?utf-8?B?SlZ1R2Q0cFl6cXVEOGJQQjdlWXJBQzhkTWNoVnBNbEVnY0M1U3FObWtrbDU3?=
 =?utf-8?B?Z2ZGck5aQUFFdmdlcUJBOG5rSEc3Rk13Y2NMYnRqNVQ3TTFnOGV2TEUvcHA3?=
 =?utf-8?B?dEV5Zkp5alVncnNCUklFSG0wRW9RZ1NoZHJWSm5DL0UxdnZNaVRrd1JUYjZZ?=
 =?utf-8?B?M01BMGs5am9jZUFQL3JNaDQzazNDRHFXQWJKdG1nVDZhdmowN0w3blRLZlVT?=
 =?utf-8?B?L3FaYkx0S3g1TlNZcVBvOU5kalBzTlphcjRDeWtEWERjekZ2UDg3QVQ2NjZ3?=
 =?utf-8?B?OGduc2Jtem82UWg3dkJQRGxoZHdtQVhKNjJxRnVuQTZnbEhoYVBuQklpeEN0?=
 =?utf-8?B?NEFBRkcybDBoZ2lMYnA5a2lGRXgrRExtc05zSVJCMnZrZWZ6R2EyQU9obGJO?=
 =?utf-8?B?TUN4aGdMSnEvWEZSNHdkc1hZeE5jNy9VUzRCcDZwNStJZ1A4R2o2MWtpMnpt?=
 =?utf-8?B?emtqVVZIQW02U0dycmdsM2QzSS9mRVpBQWs2V1lXZjlVRjh1RUVZeGhkakdr?=
 =?utf-8?B?U3NaK0dvM093YU5pVWFuMmJ3S2QwVU1peUNFV0U0d3BMMWlNcnI3Rk1FMTdu?=
 =?utf-8?B?cXRHRXhRRnBzSnVRTE1PUGpLQ2pISTErOERVK2JlODRLbmxYUUUvTXhKN1hX?=
 =?utf-8?B?bUlVQS9uYUUvTnBIUFhUcHUzVW9lVmhqM21sSEpyaUtnN2dZSUdDZ21nQXBI?=
 =?utf-8?B?cERYTnlxbGJkTDFiM0lSNDNwbXg0NC84UmJzN1F6RG4vS2cvaEYvL29YcUhB?=
 =?utf-8?B?cnY0UnB2d3UycVhidnRqWnFQZ1g3ZURUdS9sZER0ejlrR1daQkdsWEVKODUr?=
 =?utf-8?Q?Norz5h18ah20l1Q5xtOK2WAQk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0546e1e-9e2c-4653-b0b6-08db6e98c36a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 18:37:39.6644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qpGgAEZqIGBztfd6SurrKphJV74y6au6tHaa3+TS/etegHy+0q8LEbUW/A5V/65h/LKLUmig8vAJCERhNQI3Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5854
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/15/2023 11:52 PM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Brett Creeley <brett.creeley@amd.com>
>> Sent: Saturday, June 3, 2023 6:03 AM
>>
>> +void vfio_combine_iova_ranges(struct rb_root_cached *root, u32
>> cur_nodes,
>> +                           u32 req_nodes)
>> +{
>> +     struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
>> +     unsigned long min_gap, curr_gap;
>> +
>> +     /* Special shortcut when a single range is required */
>> +     if (req_nodes == 1) {
>> +             unsigned long last;
>> +
>> +             comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
>> +             curr = comb_start;
>> +             while (curr) {
>> +                     last = curr->last;
>> +                     prev = curr;
>> +                     curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
>> +                     if (prev != comb_start)
>> +                             interval_tree_remove(prev, root);
>> +             }
>> +             comb_start->last = last;
>> +             return;
>> +     }
>> +
>> +     /* Combine ranges which have the smallest gap */
>> +     while (cur_nodes > req_nodes) {
>> +             prev = NULL;
>> +             min_gap = ULONG_MAX;
>> +             curr = interval_tree_iter_first(root, 0, ULONG_MAX);
>> +             while (curr) {
>> +                     if (prev) {
>> +                             curr_gap = curr->start - prev->last;
>> +                             if (curr_gap < min_gap) {
>> +                                     min_gap = curr_gap;
>> +                                     comb_start = prev;
>> +                                     comb_end = curr;
>> +                             }
>> +                     }
>> +                     prev = curr;
>> +                     curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
>> +             }
>> +             comb_start->last = comb_end->last;
>> +             interval_tree_remove(comb_end, root);
>> +             cur_nodes--;
>> +     }
>> +}
>> +EXPORT_SYMBOL_GPL(vfio_combine_iova_ranges);
>> +
> 
> Being a public function please follow the kernel convention with comment
> explaining what this function actually does.

I've seen many cases that there's no documentation for public functions 
and I don't think any documentation is needed for this function as the 
name is self explanatory. VFIO drivers can use this to combine iova 
ranges, hence why I named it vfio_combine_iova_ranges().

> 
> btw while you rename it with 'vfio' and 'iova' keywords, the actual logic
> has nothing to do with either of them. Does it make more sense to move it
> to a more generic library?

I think it *could* go into a more generic library, but at this point in 
time I think it belongs here. As mentioned in the previous comment the 
function name describes its exact purpose. If/when it ever gets more 
users it can be moved and renamed.

