Return-Path: <netdev+bounces-3053-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B885D705420
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7570B1C20BC7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B5FDF55;
	Tue, 16 May 2023 16:39:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA4D2F46
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:39:59 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C206C18E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:39:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHnJy/aCgNzxNX707a7v19MJe3qNdQSoC49YHQ87PoEC/evmV7uaS2hSsDI3LdQI/N7MQygfnmaxCRSW9885wwVbxcDk+DQKwtRNdc0RnzkQZG2vtRG01nxQqa3ZZ/MsnxQ6XpSlCWXXkW4c3WTl85A1FNRkhELXVZfbzfnxKvkZts+sV7K+3GtDzD4Mj5EO7I2JTrQUT/J2fmVOT1J2LnDt8t8InYiKmTlh+nXhgkxxD7aP2VGZk3r+QsoJUZEZNSuCy0dc36ZDRwXrKw6Xgb5rmzkMuy14W4tY9c7Izf6DVfYDKXtOrPdMUaeIl0ByvJiVNjBAtha2chSrBvmwtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2k+P3RrwyLjGCuJMgHcm8Il2pge3xBCMJtvswSkhx0Q=;
 b=eW0XcmMcLfSUJd3FFD+H5iKMatOQyqdfMhqW1X7dFc32qFCwvT8o9KYcx/5EWgLns7dUBpYqwMsuNVDzzD5OBQteITVKN1xQW2oVteQNdhARHCVef9OtqgYb/HWyUTsJYBStyNYvyy0ez2JWmwr6vigJuPgtM/IYf7UHKESvZ5Hfxvj2AwWuXGOM7YYIsbVhhAt+HuyGgmffBdy+a9tg9elksoqoIlZuyOeQrFnVrhzSJ8N279l73n5sfXfYiehaMx6So0wzURAju659eX1CUtghhI35/Kw2CiYCPi1X26FYatSGittMYXMo/fVeb0hffQpc/2csj95Yg+1h0W8Q2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2k+P3RrwyLjGCuJMgHcm8Il2pge3xBCMJtvswSkhx0Q=;
 b=EoFTp32Q7oYGoazJ0g9zvpLGfz89XmnZrRWSyYxgxlb/a3hIP3C0gJJKfYtQJ9ZF0nuV2kfovHs4RPDcbUhDe93B3zMW/5AqliNeW1Jq5j2+ZJ4fo7nPJKsR8fG+7bR7xS5N2r+DrFdynd6gaKkmqfL5kiW/NoF/KSjSNC9it4k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DS0PR12MB7605.namprd12.prod.outlook.com (2603:10b6:8:13d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.30; Tue, 16 May 2023 16:39:44 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc%5]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 16:39:44 +0000
Message-ID: <98bcc38a-2cee-3bba-3ba6-5b414e816c49@amd.com>
Date: Tue, 16 May 2023 09:39:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH v6 virtio 09/11] pds_vdpa: add support for vdpa and
 vdpamgmt interfaces
Content-Language: en-US
To: Simon Horman <simon.horman@corigine.com>
Cc: jasowang@redhat.com, mst@redhat.com,
 virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
 netdev@vger.kernel.org, drivers@pensando.io
References: <20230516025521.43352-1-shannon.nelson@amd.com>
 <20230516025521.43352-10-shannon.nelson@amd.com>
 <ZGNcZHUAC21S+uSK@corigine.com>
From: Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <ZGNcZHUAC21S+uSK@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0162.namprd03.prod.outlook.com
 (2603:10b6:a03:338::17) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DS0PR12MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: ffa6b999-c1fc-474a-b7e1-08db562c2727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1EKYsoV1fQvE6PBGwRqQF48hkrd/G2DkTNWxDIEQ+kaKBSjWdQzAGMqrH92WZZlvcOoRQ2HUbVclQlxPiN5qIVblsa3a6+0tIXTnNUxXDRAP1qtzEDpDX+NYYQTURfR5CpYvcXQhzbAzK0hQtfZrSgr17bshRP3N+s2J275bb5x4A+LrmmZJvUHII5OThZgDrugqI2Mb3wbnPxQUj/tEVyFgNuDYrW6X2rFDC5xy4CSKDm+JHlTgBYUNXqUsIB9IBd2g3amzcd20yyuzl/cLiFwJ5uJAmGqVVcilxOk6vnc8/rhxxGevXXpBoGguzZEG/eRgL1Q9YwcvJEqYy7jshanZiauYwHQEqZstkkKdEbZt3CKAwXQ7QEzoQeeclsP6Jg5R8Bixeg261ebexZTgNQPVH82LzOVV20IFgu5dozA/ZoJYkJBji8FpSSLsJqwyNrsMfWlvT8x/CUQW1TY8JI5qVXwOC7IpM5MHmE571bKgAT301YGL/yfRle/N7BTeTa4nfLwfQ3XMP7Il+CITrR/PXefUgTuiOHlPSDK8dajycNVemfV4XH46hon8lnsDopaMPLT0lCvcfrQ1JMG4vQoRUux6aOvo1x+k4ayZdGCFUkkzAHDlnDcy0/Jj02Mv0Olj7vO1dkHKDavjLSBU6A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(39860400002)(346002)(396003)(451199021)(66946007)(66556008)(66476007)(41300700001)(4326008)(31686004)(6916009)(6666004)(6486002)(6512007)(6506007)(26005)(38100700002)(316002)(2616005)(44832011)(5660300002)(8936002)(83380400001)(2906002)(8676002)(478600001)(86362001)(31696002)(66899021)(53546011)(186003)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGtDbHg3cGJ1R0ZuNFZzK2duMWUxK2xZeGZaSXUxR2lHNFFvdFFkUG9oejhD?=
 =?utf-8?B?bWZwRlgrMXd5VEFvUHZ0QTNtWFZINUZRV0p3dHZTZlN6VjNneHVZSVRJcGVj?=
 =?utf-8?B?K2p1NHJMbGgxZTA2Sm1neWM4VFRJZHJNakxVK0dJRXc3WmVoSG1FQ1JTS2FN?=
 =?utf-8?B?NkFiQldwWGtIYlN1YzgxdjZNODFvL1RxQ0RWMXZMdlBaRG83Y1ZyVS9rNHh4?=
 =?utf-8?B?b3llUFhkeU1GSTV5NEYrOFpBZ2d2RFEzamtmNTdWUFFFYzlRZ3hnbDI0TGxH?=
 =?utf-8?B?cG8zU2pqTk1maHJUc1QxSWxMNmhyTTM4ZS9EeHZ3bnd3WlMyRE41cjZCN0Qv?=
 =?utf-8?B?OWQ3T2VsV1dhUjVGUzdtYjdVZ2NqcjlDRVFoMU45TUU3dFlWWTZwTEJHRDFO?=
 =?utf-8?B?cjJZZmxja3c4WTVmZndsTlhHc2l6dGtLczM5Y0hBTUJBMko1VXZDUVlpRDIy?=
 =?utf-8?B?T1JsVWRqRm5Xc2JWR1pMT0Z0VW84ZHNrWDgrTVFmb1N0U3plRjJldndkeWdH?=
 =?utf-8?B?cWFJaE90SHc1UWs4NHVjS0F2SzIvZ284Lzhibk5RRHdhcm5mTW0vTG9RbDlx?=
 =?utf-8?B?ZS9VcmdrOXdSbU0wZ3ZFcm02T0dZUnJoRk5CQ0JaOElaRHk0Z1VhRVZSb0xY?=
 =?utf-8?B?SS82VWFMNnFtMmlxcmlLRkpnQWxjUWl0dkR0THhrSnprTzZvei9tQURsT3VE?=
 =?utf-8?B?eTZHK0cydi9zN3FiV2gyQmFrSTk3OEtRUW9oc2RDUDBDOU91UHVEcnhIcGVN?=
 =?utf-8?B?STJ0OUFNbDI5RVhBR0syWjVKU2dZSitRZElMRkhSbHl1RlhzMFpJRzBRd3Vp?=
 =?utf-8?B?SnIwb3cvcDJzcVFpd3c5eXlsRVg3c0thc2cyYXgvYWo5WGlCWHRNQmxKYjcr?=
 =?utf-8?B?b3RleGYxVkJuUUxzZGxKMXR1Njh2MzNaNW55QmVud0pKaEVlK3k2S0xHRU9t?=
 =?utf-8?B?UkhiQ2dBMm8yM3ZFRE56Zm5WdXE2NW8yRXdLM3l4dHhpblBLakFHclZXaWF0?=
 =?utf-8?B?ME0yMWg0MVlnY2xuNHcvbFJFMUIrMFN4SVQ0ZmU2NkY0M3lrdGRLSHNUM3d5?=
 =?utf-8?B?aXpTTlc2WE03aXV6c0NST29ucTZjV3Z5MjBnSE9pK1FwaWtCc3ViMHdZQzJK?=
 =?utf-8?B?b0YvRlNUY2IwaCtxUS9oaGNrL0w1WDd3aTZFa2hiQ3JnZldQRnBwZUx1UzRP?=
 =?utf-8?B?cnVrWWRBZHBtN0pSUFpYMkhIdmliajdhc2VYQXcxVFF1SStTQWhtbTVobGJq?=
 =?utf-8?B?V2xTdWx1cVFRVnV6elhYVGpuU0RNUmlsaTQ4Umk4bmkxZzlCWEVmUm1paTBx?=
 =?utf-8?B?UmFSUkRURXZBSmlpZ1pBa2IwbC8xamVmVmN5NGdnY0YwMHdBQXNuaDNGOVpR?=
 =?utf-8?B?cWd6RTFJcjlvWUt6NFh6ODlJbW5kMkNoQ2Y0ak5OVEVzeGEycE9qaStwdnIz?=
 =?utf-8?B?amNLd2VQOFkvSjc4N1lDZ2pGRkUwMU9scE5EczUwa1pYOEVsald6RHJxdXUx?=
 =?utf-8?B?SSs1Q2dnZ0hrY2ROSUJTSjcxbVAwMWlLNlRDazNqR3YydmJmUWdYcVFmR3Iv?=
 =?utf-8?B?U2JTUHJmVGh4L2pXTWFkYitNaTR3TE9PWTZ2MlpnZ0JlaFVzWHB5TC96dXlJ?=
 =?utf-8?B?VlBqNWxKb0pVWjBKQWZqdW9FckJUMVk5RnN1WUl1elZYRDF0WHBiUXozQzU5?=
 =?utf-8?B?eDVNOVQ0akpteXh4a1JnbWJYdENTeW9FY3VwK2pDWGwxUGhHR3RGNk5VUTE3?=
 =?utf-8?B?Rlo3a0FFMmNRUFJDL3lmbERldWJnUXYrcUhXcm4vN2lrbkZCVVJqZGptbytp?=
 =?utf-8?B?dXVrZFpJZnp5RW5ONDdhZzJ2NVZCZmlJZlk1RmFxbFllQjNLSE5PbnUxUHRL?=
 =?utf-8?B?Wk8yRjQ0Zjk5OS9ob2h5aEh0YjFYV1lmSmpjZzh3Qmp0STU3RStzTnB1OWVP?=
 =?utf-8?B?WmJrY3I1cUwrYlhORVQ3Q3JiQ3FzRXdUSzl6bXZ0UzFGbG5ScXRRaTJVaTZu?=
 =?utf-8?B?REtSSGx4bDlDUDNhTjBuTTlEb1BKUjdXM051amQxRHU1WFh4TmhCWXhzaFVx?=
 =?utf-8?B?YWJvYVFSR0MyM0dmaHBkSWZ6TmR6TUw4UlNkYklWSUNobzg1TjJQS1gvUHhs?=
 =?utf-8?Q?bI7lQ9kFxoDvDSeDbQZifAoV+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffa6b999-c1fc-474a-b7e1-08db562c2727
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 16:39:44.0159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FN3N8QvSJjATa4anH7/31/X1wvZLCp81txW7dxG4p0QInjV2z2LMzcG0aWACkcBvV4Qulv1UUGWg3ak1Ig7FPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7605
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/16/23 3:35 AM, Simon Horman wrote:
> 
> On Mon, May 15, 2023 at 07:55:19PM -0700, Shannon Nelson wrote:
>> This is the vDPA device support, where we advertise that we can
>> support the virtio queues and deal with the configuration work
>> through the pds_core's adminq.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> Acked-by: Jason Wang <jasowang@redhat.com>
> 
> ...
> 
>> @@ -21,12 +479,156 @@ static struct virtio_device_id pds_vdpa_id_table[] = {
>>   static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>>                            const struct vdpa_dev_set_config *add_config)
>>   {
>> -     return -EOPNOTSUPP;
>> +     struct pds_vdpa_aux *vdpa_aux;
>> +     struct pds_vdpa_device *pdsv;
>> +     struct vdpa_mgmt_dev *mgmt;
>> +     u16 fw_max_vqs, vq_pairs;
>> +     struct device *dma_dev;
>> +     struct pci_dev *pdev;
>> +     struct device *dev;
>> +     u8 mac[ETH_ALEN];
>> +     int err;
>> +     int i;
>> +
>> +     vdpa_aux = container_of(mdev, struct pds_vdpa_aux, vdpa_mdev);
>> +     dev = &vdpa_aux->padev->aux_dev.dev;
>> +     mgmt = &vdpa_aux->vdpa_mdev;
>> +
>> +     if (vdpa_aux->pdsv) {
>> +             dev_warn(dev, "Multiple vDPA devices on a VF is not supported.\n");
>> +             return -EOPNOTSUPP;
>> +     }
>> +
>> +     pdsv = vdpa_alloc_device(struct pds_vdpa_device, vdpa_dev,
>> +                              dev, &pds_vdpa_ops, 1, 1, name, false);
>> +     if (IS_ERR(pdsv)) {
>> +             dev_err(dev, "Failed to allocate vDPA structure: %pe\n", pdsv);
>> +             return PTR_ERR(pdsv);
>> +     }
>> +
>> +     vdpa_aux->pdsv = pdsv;
>> +     pdsv->vdpa_aux = vdpa_aux;
>> +
>> +     pdev = vdpa_aux->padev->vf_pdev;
>> +     dma_dev = &pdev->dev;
>> +     pdsv->vdpa_dev.dma_dev = dma_dev;
>> +
>> +     pdsv->supported_features = mgmt->supported_features;
>> +
> 
>> +     if (add_config->mask & BIT_ULL(VDPA_ATTR_DEV_FEATURES)) {
>> +             u64 unsupp_features =
>> +                     add_config->device_features & ~mgmt->supported_features;
>> +
>> +             if (unsupp_features) {
>> +                     dev_err(dev, "Unsupported features: %#llx\n", unsupp_features);
>> +                     goto err_unmap;
> 
> Hi Shannon,
> 
> clang-16 W=1 reports that
> err_unmap will return err
> but err is uninitialised here.

Clearly I need to expand my toolset.

Good catch - thanks.

sln


> 
>> +             }
>> +
>> +             pdsv->supported_features = add_config->device_features;
>> +     }
> 
> ...
> 
>> +err_unmap:
>> +     put_device(&pdsv->vdpa_dev.dev);
>> +     vdpa_aux->pdsv = NULL;
>> +     return err;
>>   }
> 
> ...

