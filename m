Return-Path: <netdev+bounces-593-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B3516F85F1
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:36:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E251B281087
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3ABCC2DF;
	Fri,  5 May 2023 15:36:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FA333D8
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 15:36:15 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9DB10F8;
	Fri,  5 May 2023 08:36:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fN8XdGKnyfVtagBwdSgqhjoVgoXiZgWJDsDH01wAehB/NMfx/L3Jnnb5AmtDbjcJc3u7w/AVp77VedwbKH7L2GftoYMx/NPDFDyRomTBxcptWTHCTJO56SnIsXZ3oqyUjhudQtO3siwlC/1jcBAWcY8dQmZI62MRDXLw/23vTeNnhtR7ljX+H8xK2jRQVyBD1EYgHLUD4kMGwYgOLP8VtJmcM/DKaJpyz/Z28udvov+/wSx0qSbl1/PseDZW/UOelU39jTepGtQ9rv34fMx3LlCd1/IJ2r8ffO/FbRSSkbQhXBOelTCl8NLWhodqb8ywhxQqldcFlf70CZtSxB/8Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HfzEwBkdgQ48nLvTgdmRCq0JfcAuai7NrVhHRYphhoY=;
 b=TCG5uOhUFj3qcXF+TiAMook861bgHywLelxLe/MChnCf1MeJDdbBYwQD8DFxohRAVmkDKPR0oFLoQQPXbgH71Ud9m8O7yV+1o9EFGK/FaWF81lSSRAsqzWzJ00kMTX45HcKULLA+Pqb76wd1t5Xut4Yp18I+jSE+B73mfsld7AevQ1+MzJttzZYcESSEMj1GPfd2Q2rjaN4P/woudhSVCahjjAzG0Gd3KHDW+nkR7c9Gyz0wFVL4uKmMEVhnPImjSVKhPh8C7aqtWgZObAdZa83aRAQ+ZJ/0M+Bxv5phHoaDYjiPJjXMlOud5jjsELl868vKTgFV5DMu+RTdM9Ofjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfzEwBkdgQ48nLvTgdmRCq0JfcAuai7NrVhHRYphhoY=;
 b=HxC2hacaebj5bR5bBbn/GuTAJR2R2mU/9d689ZKhCTQIw5db8Wv2ARrGp36RkG57vvudKpkJifK2yYkhPsuZozTaGOVpYOF7CFXBtaKXZRdkI51YLs61TBcC2bWY05VRQQnd4CRlRwHrrxLY6VG6+FPsVoP5r/mRv2wLoIKrbgc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by PH7PR12MB6739.namprd12.prod.outlook.com (2603:10b6:510:1aa::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Fri, 5 May
 2023 15:36:12 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f%5]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 15:36:12 +0000
Message-ID: <50c7fb22-5ad7-aede-e864-d0e3ad3bfea6@amd.com>
Date: Fri, 5 May 2023 08:36:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v9 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Brett Creeley <brett.creeley@amd.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, alex.williamson@redhat.com,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
References: <20230422010642.60720-1-brett.creeley@amd.com>
 <20230422010642.60720-3-brett.creeley@amd.com> <ZFPr9NWf5vr1D+Uw@nvidia.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZFPr9NWf5vr1D+Uw@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0194.namprd05.prod.outlook.com
 (2603:10b6:a03:330::19) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|PH7PR12MB6739:EE_
X-MS-Office365-Filtering-Correlation-Id: dcf07689-3c56-41d8-7548-08db4d7e748d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GCu8Be4BqgDgDaK5EgIS1nunVBIAz3fmeUsowhQmaOg7Cy5Qc+bUDXSXeJuO2xbtSR32llseDVnTECrBIfcxF9lLSWjEoxHYhgzN0H0Ka7/YolmsnvfDZqaMVaOlNUeElcS5rbWUGXiBGLXOLVctVUfy1tz5gDZWmZ2mSogP5I/aPUup508okOY0nKBw86/BZaRogGs/88VAjho3QMgQymx+AzuCqotUDZmF0HfNvy4e7xEIIj9t6fmqd4iiR0wtNFgg/jvcqwu03D1dPqHy7dSBwrNWy6KKP4taf/9Jm+GxSvjWnDt4aYlUuU4M0lSYnIcD/4i2sh4kTgXQgP8NJ7XykLzLCnbfDZGIUCOLhTMB3JaVYlxiiR63cYOKCw5YCBlvGkZo2obsdBeQDKVJ9bwQsecBhewW6TotVNcRF+punUkEiQmm1dPWmZrDkJomTv0JBQzujmkauarbVyXQnOGgLFFSLhBAfVtFGnlnadsHp9vLgvQ/4TVSA/9Q90b6aUGYK32xhEXPDhAQuV0p5AdVG9Iv0I/zx/o2Wb0x18ZKQlG6osREmm52zm5dArT2+2zoKH7mr5RsK1LavAtK4v3fHp8aU5hhJWJXHPIFdC8mClNEYhR1Mxl/2J5bLuihB7oFpBjhizQmAeDqstHsjg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(366004)(376002)(39860400002)(451199021)(316002)(66556008)(8676002)(5660300002)(8936002)(2616005)(4326008)(6636002)(66946007)(66476007)(31696002)(83380400001)(2906002)(31686004)(186003)(6512007)(26005)(53546011)(6506007)(6486002)(36756003)(38100700002)(41300700001)(478600001)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWdGRzFNUzIyTnQxRExrZXlpSE9ObURoTG5weDdNd0hBczZHL0xIT1ljS1My?=
 =?utf-8?B?dytmRXl2YStYOER3MGFGdjNQM2lIU0g4d3ZHSHZjcHZPSHVOSWw5Z2srOEFO?=
 =?utf-8?B?VUlvWS8xMW0yQ29ZNGdML01XNEI3VU9mcjVRVlRnV3AwVE1uSm13anZFUVYr?=
 =?utf-8?B?VXQ4YVN2b0xOY014OE4rWlR6UWF6YUlCVk53dW1adVI1SmFWUkZHUWdPdkpI?=
 =?utf-8?B?SUR3blRFOHgzTjM4bngvQkNZTmRIU3h5UE5hZ2ZvNjJGQWp5SDg0Mk1qTXdK?=
 =?utf-8?B?VkxpNVRQYWxPckUwWkd6QkVvOGN1cU96UEErZ1BJQThsclJydnVRa1I3d0Jw?=
 =?utf-8?B?TjA0Z3FNSUYzL0hnYWtJMDhBaFdrMVFyVUU1REFCYmJabjNoRXlwL29adVdj?=
 =?utf-8?B?M3FBSnRHajBGcWJmam9uaFdKQlF5Nm1QZDk5djkrRUFTanJrWFQzY2VlcGZu?=
 =?utf-8?B?aXhKWUx2UVY0Y0NIUjIvekwraHJvY1pjTU1KWFNwQThmVXp2VzR6K0dhbUZ0?=
 =?utf-8?B?ZGZOT3IwZ09Ya1ErY0hGclpESTVNajhFV29zMGV2ZW8rdDgxUjRzUFNKQWZZ?=
 =?utf-8?B?KyswbTJ0dkcxekwwRUttZmdqZTQ0VjBZc1JTU3hVZklNUE95Y2hEd0tic0NX?=
 =?utf-8?B?TUJoUk9vQTJZQW5kalRzL1pkM1VCNlB2TWgrOVlDVFpWNnd2YmVtRGNPT2pJ?=
 =?utf-8?B?T2IrZUFubTMvZTdBVjJ0Q1BMRENUdEt3TEJXNHY3bGdoOXlHMGZJU1Nzb3ZY?=
 =?utf-8?B?UjhOVjV4OTBQS2p4SytoWkxGZW5UV1lkT1FxY1hSNHRVd0w0SU5ySFAwbHdE?=
 =?utf-8?B?OTR3SUFKQVd3dExlNVNpN0V4Wk0rRll1cm41WENLVFBTL3dKVUNaSko3RjNs?=
 =?utf-8?B?aU5zYTJmZmVyeVBOR01RV2hlTzJZVWNiZ09hdkE0bkQwQ1AwQ3dkVEhlWlc4?=
 =?utf-8?B?eE5jc3NONjZocHFVaVlOM3hWbVl5M3FZanIxSVpsSEZtcXl2ejV5dlFFeGNL?=
 =?utf-8?B?N1lZT0k2a212ZEdXTFFGcXN5ektZNnY5TFBJMVhXNXBIQS9QU1JHd3k0S1RQ?=
 =?utf-8?B?ZXJRRmpDdmxBY093Um1Lc0RNVmQwNFUyQi9hTTQwbzlxc20xQTkvaDAzRi9Z?=
 =?utf-8?B?SzRCRUpGQ0UyVmJseGMzR1pYWmdyU3BQVGlnRXNOSVRvVFVXVmtiWFR4U1Q3?=
 =?utf-8?B?bEdLVXhRMk1hSnJXWkc3VTNkTmdEb29NZHFXazRDRndiTDVYTGpQTnNjcFNK?=
 =?utf-8?B?WjVOekFJUFVYWSt1bnpxUzdIVzUxTS8wTGJrcFJzN29PcmtzcGFIUUtxV05Q?=
 =?utf-8?B?ZzZWczl0N3owaTVGUXBKUHZKNU5qOUUvemdlVjl1bTkrR21paGlMMHE5RTBa?=
 =?utf-8?B?QmREUGFHM2g5K1NuSzlVT0JFMVNoUUhMWGovckhvN2l2Z3llUzNJUTNsQkUy?=
 =?utf-8?B?cG9Gb21JaHFBRzBrS0Y4WmZBRnhFSWlzb1IvUlVwQ2pjbGNQRE1HYnlaV2ZS?=
 =?utf-8?B?dDVxWmtsQUxodnFqVFo3dmVKdlo3QlRWTVRoYUk4Snc4SXNZWmc5Z2xZN1Q4?=
 =?utf-8?B?S2dVd3E3SzYyR29PbXFyamdERzVxMk8wcUp3YjBUZDR3czhtRjcwSnpBS040?=
 =?utf-8?B?Y0pJcmlwRlJsNHlVQnRhUlhjOU5teU5qYmhRSVM0aXRSeExKcjFweGVUNGR6?=
 =?utf-8?B?R0NPbWlvRFlkSnJCenc0VWdYYUpoU0FsN21tNTlJOTRvSDdKUU1FampIVkov?=
 =?utf-8?B?Zk0xYis1VEtYS1RhdXZtR3E3ci9xVlk1QWdxQ3VUeDc1L3FmQUpuMVorcFZv?=
 =?utf-8?B?L3RhR0N5NVVlTlVsNDBpcytpNk9JVm1WMEN1ZlZnR3BiSUJoSk5hbmIrNG5s?=
 =?utf-8?B?TjdMTytTajAvU2RYdEhzOUhSTW1JdjFFOStVNC9sSkZKTHRXdXlnRDE3K2Uw?=
 =?utf-8?B?cWFmMkZyOFdIaXc0Y1RBRi8xZFBlNld6ZUo2VDgvbzVtYlhKTkpxekZpdTdG?=
 =?utf-8?B?Y2dyRzZLNG9raGJlTE9PSTFXUitJMUhGb2c3L1JqMjdHeEZxYTNSYmJtampI?=
 =?utf-8?B?T1BWOUhFOVdnQWJCVGFTOUxtZGJGbkFyZllidkEydGluR1I3OUFwRUJmdXl2?=
 =?utf-8?Q?0HCJ/PhJR9iZ0MYq5YIgkL/5m?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf07689-3c56-41d8-7548-08db4d7e748d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 15:36:12.0634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lEJ10vMA/Kuc8nF1RCaW7Jv5fXpFfTXhxmeIoKDeZ9bmXfcKV/Im1nFMluWN2IHZLuwK6jAnid03YZXRnmjbNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6739
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/4/2023 10:31 AM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Fri, Apr 21, 2023 at 06:06:37PM -0700, Brett Creeley wrote:
> 
>> +static const struct vfio_device_ops
>> +pds_vfio_ops = {
>> +     .name = "pds-vfio",
>> +     .init = pds_vfio_init_device,
>> +     .release = vfio_pci_core_release_dev,
>> +     .open_device = pds_vfio_open_device,
>> +     .close_device = vfio_pci_core_close_device,
>> +     .ioctl = vfio_pci_core_ioctl,
>> +     .device_feature = vfio_pci_core_ioctl_feature,
>> +     .read = vfio_pci_core_read,
>> +     .write = vfio_pci_core_write,
>> +     .mmap = vfio_pci_core_mmap,
>> +     .request = vfio_pci_core_request,
>> +     .match = vfio_pci_core_match,
>> +     .bind_iommufd = vfio_iommufd_physical_bind,
>> +     .unbind_iommufd = vfio_iommufd_physical_unbind,
>> +     .attach_ioas = vfio_iommufd_physical_attach_ioas,
>> +};
>> +
>> +const struct vfio_device_ops *
>> +pds_vfio_ops_info(void)
>> +{
>> +     return &pds_vfio_ops;
>> +}
> 
> No reason for a function like this
> 
> It is a bit strange to split up the driver files so the registration is in a
> different file than the ops implementation.
> 
> Jason

I will fix this in the next revision. Thanks for the review.

Brett

