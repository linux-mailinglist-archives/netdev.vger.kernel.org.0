Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F6E4F76DC
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241501AbiDGHLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239870AbiDGHLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:11:21 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2065.outbound.protection.outlook.com [40.107.101.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F2F12AD8;
        Thu,  7 Apr 2022 00:09:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PW0A/YHzBYPeL7BCOyXJ1J3Ahw4kVsBI5cMEGVW59xm0lCCjquNh7CYLDlMF/mIH0oS4JJgHtuN63mnaL6THRGkRWn7tnHAMXHiHtc29dzN0y7b0pal3VgnI4Wvb64tt3Ykpz7dki7jCdC6n/W+h+REKeofAvNpAKrag4B1r005hTUrtbNvjmbJ13I4iMF4wnyYdkanQPI9tI5HJCiJwPtw6O81/GZ2C3LAP/QkilAGxz5dfg5vIFxkeWUt+DQbPf7kE1xX5fSLv/pYlrE6w6SitWT4ltz+5hpXfy6DfTd5VA9lPzwLZpD/DnbCI8RZ1IFYoMVoYo3YVmBXofBMl/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYtQXAnRz8hVNj66wWsS6i50deLzHBQxD7lOmqq22UE=;
 b=bp9sHpg9AulQ5YMLlHnHtusC1HkolAeyG1QlemUy7wjnZ2n96hL+W3mKIlecgEa14E5V1aXGZEErVtlbki7dCHOi6jlyOpVHS3HvaoNn9JHGCyQDUxVN5K9v2v4LXvbN/lis7thfXp6hJG53XZW595mZvtbxuiOS4iaG/w72cPxvu2zejqq2Ih2D1SE0AMNHvpO/lVlQ4ps0MtnQeEypVan58DiF3HEvVNB3xkf4wup3E1N/qkez1m7P2jz0r3gL57rlunk/bhpV0gVflh/etJWEQQvK63AIhmQN51lbBVNXhPzjQZEwgKhCMWtNnU4qahp3oMz3FQgeB9GbsOemsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYtQXAnRz8hVNj66wWsS6i50deLzHBQxD7lOmqq22UE=;
 b=tvwtIahpIHD14eVVoP0quiHwV/Mcvx1H9n99SdoiH8Edq7Z1njSghkXg6qwXzljpbYwk85+s5cDuiZ1fLCnkezW123KbO6DUVdGbxTI13d0GvAt+byvTeHWOLpR0hveLx0ABtXr8HW/jxF+ZCk+q5/sUSo+QzxC99/KbiesC2Pa9ELM6kbQAmwdGDKKFsuCmN8dNl5RLgJGzpua2gi/fCx10tg7RfHFZF184LnUtiZvuYOQYErt5OtIGRnjaNC0RKiqqqiemmRJclHlKhcWfodWavjQ2YBCjS4yJuk+kfeOUQhjGBTuMIm93arrcXwba2vtFENX5U2Wc0WNGHkmA+w==
Received: from BYAPR12MB3208.namprd12.prod.outlook.com (2603:10b6:a03:13b::32)
 by SN1PR12MB2573.namprd12.prod.outlook.com (2603:10b6:802:2b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 07:09:21 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by BYAPR12MB3208.namprd12.prod.outlook.com (2603:10b6:a03:13b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 07:09:19 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::313b:8981:d79a:52d0]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::313b:8981:d79a:52d0%5]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:09:19 +0000
Message-ID: <6f577f5e-deb8-b961-ef45-1aa31f440578@nvidia.com>
Date:   Thu, 7 Apr 2022 10:09:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] RDMA: Split kernel-only global device caps from uverbs
 device caps
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Ariel Elior <aelior@marvell.com>, Anna Schumaker <anna@kernel.org>,
        Jens Axboe <axboe@fb.com>,
        Christian Benvenuti <benve@cisco.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        target-devel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
References: <0-v2-22c19e565eef+139a-kern_caps_jgg@nvidia.com>
 <810e22f7-a48c-dd65-5665-8db757f3ae29@nvidia.com>
 <20220406215431.GK2120790@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20220406215431.GK2120790@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0451.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::31) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 649e3670-8af6-4bc7-7be1-08da18658897
X-MS-TrafficTypeDiagnostic: BYAPR12MB3208:EE_|SN1PR12MB2573:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3208C6F0420CEBA019C528A6DEE69@BYAPR12MB3208.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nBq+7/vtp/1itV6rH4ufn58CoGT67ONpLU8jXja1diTKxzy8UPQIvI6+oLn5PzwJXbzRoL/AP9kgzm9NAv/tIWd1NUYAV+h7jXuozAUAKU/BjmFof/aa4PFvavDSGnOWMLdGXH+d2rPda2z3Cc8aDm6p+yriasGYwNp0vf6BUtDHyI0o3qAQiJCPfP+4aEmyS2SCGtJ5V7s5D1zfAVS/ojNlAK11nemH4LSJOXdK9rNUnjonaWF2gUZPJqd9dZP5uE3bEov+PIkgVbSG1+SLzztBZRC9urNBSgivOjqQDKciLgZRQDkTBBy9JKwLmyTUYUmg6cl6/aVoCo1t6QKIEEyP9r3jtX+CCYUMvPNic8Bo6tyKclQRTrMwuDO3Mp+T4nIc31s74o8Lat0JcTOIW1A4HeFUgK7UYRE/Dxd/1GcP2DO2oFx5fjQz+CDTiI7nMzjfKH9wrqU5tNDUxsACN8B6uQoOZygKJTTCAuP04G/AEdmmN0mxLouIagGEF5tvED8xIa+O9WWPR7/Mic/nl2ffhq2ezgI+mL5RnB9aw4boMXTKWtmqVOfwU3WlXoaIGIsprG3DlIDlbOxIcYS8AGbv7Yiors55D2kXnhjfVNjKcYCL0Kbrzd6DxqrfVUY+3LHEuNahyG7cugC7+tHnYVWSr/r7QDzhbIEbBQhldFxO3/hOU/JUGR1TvVnXh4jFB7h01yr4G2tipHwmCj27O7/zl8+lRjljH+ew6YWi3zk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3208.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6512007)(186003)(2616005)(26005)(53546011)(6506007)(8936002)(2906002)(6666004)(7406005)(83380400001)(5660300002)(7416002)(4744005)(54906003)(6636002)(37006003)(316002)(38100700002)(6862004)(66476007)(66946007)(66556008)(6486002)(31696002)(8676002)(36756003)(86362001)(31686004)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHdsbnF6eGEyZlYrSHAwdUplVWFjTzFseXlDWk9kWGk5V2FEUkJFSmxodEJ6?=
 =?utf-8?B?eVRnb0FmUm5NNkpHcHJPWWNTZm1INnRIOXF5US9yQ3NHMDFEeHc3ckJYVHRC?=
 =?utf-8?B?RlBHLytCS3JUZnphUGdtLzlyVnlFekFjNW4zZVptUEtEdXhUS09tYWx2MWpH?=
 =?utf-8?B?d2J6a3RVbFl0MzRmY1ZaS0d6aGRydDdBMzBIN0p4eDlReEFLZHBuT1gxaFhl?=
 =?utf-8?B?RThsQi9CRUJFR2VvTVRYK0gyb0ZnNjRIQmsybkhMOUNndTI0dDJaczh5QmJV?=
 =?utf-8?B?N0NrcFkrd1krSitNbFRvYVROWVdPOGtVcUhETGRqWHZ6V3FVQ0pWaTQ5Rmt2?=
 =?utf-8?B?NDdIM3o3aUVxZG1yZDQyRVRlQlJRSGppanZRMWcvMy9kSWFTV2lTTTJCUHMz?=
 =?utf-8?B?bjJlT1JlRDUxcGNQYXNhVzBWR240aWpOK1lqQUJBMTFYUUV6SnBpSjZQRU80?=
 =?utf-8?B?LzVrZEN4VWNmWWhpRm83dDd3ODl0U3AzRlZoRTJPSUx2SDl1WUt1VnZ3NWM4?=
 =?utf-8?B?ekdCZ000YklxbUlWOG9QRk15czA3MjBDVTEzdE01OUpMakRISGpNd250WXhB?=
 =?utf-8?B?Q3BPbFMxNFRPM0FFaXBwN1k3b3Q3emZvU1dnL1IxNFRrazMxbzRGeFEvMG8x?=
 =?utf-8?B?SWh1Z2JFL1Nsa0s2RHN3QjhFRnJRMDhHQ0o3WDRrZFdQa1RLS1dwaVBIc0hT?=
 =?utf-8?B?QzdlLzNnYnVSZUdSN0Z3Z0hLNXZqa3djS0pYOEg2VnRSZnM3RmFHZUMybytQ?=
 =?utf-8?B?ckpNelBaU3hRV0RaQXhMcEdWdGluOTkxREZ5eGRaUkpSRi9HeEg0a2RTSkhu?=
 =?utf-8?B?Y0Nab0ZZbnNLVktmZ3Z6RXNzUzlOTkg2SkZZT05MVXFVOHVjNjl5U3RJNmlr?=
 =?utf-8?B?TDdCZEYvM1lvNWt2dlkzNkxXM2lyZjF6OU1QMVMwaEFGK1paNTVucklzbExQ?=
 =?utf-8?B?TzFUeXBGa1lyZjgwb0daeXVFLzhvcG8xQ1VoMzBYK3pHNFJxbVROWitrN1E0?=
 =?utf-8?B?SnhhQUd6Z3JvSDExTXNXZ0dKdkdVV0sxZlNvL09yVmFnUjQxTE1jRGpCcU9h?=
 =?utf-8?B?U2x3MFdkcmFTczNjZ2F4NEY5eTY3MlR4S3E1Q0JjRUI1TFZ6NHk5eGpHYnFV?=
 =?utf-8?B?Qld6Tm54UDN1NTFMN1luMWVxVWE4UnlVVndIUDdRNEgvQkMzME00RjQxUFRF?=
 =?utf-8?B?c0oyOVl0VGxVQ2JlbVdLM0hHZk9wVkV6aUVXTDBPTktDWDBTaDRaOG5oSG5t?=
 =?utf-8?B?dWFmSjkzbS9vcDF0T1ByalRzcWNVYXVucmdxR0toUjd2andVQ3pyZVRKbTFt?=
 =?utf-8?B?N3NneTAyTWlkYk1WSEM3djVBV3pnOU5XSGpEVm5KZkdUZXFIOWViYTlCNEJD?=
 =?utf-8?B?ZFNIOC9QbXVwYzRCd3lETmZFbUpzdTVwS296cE56V2MxYVVCQS9XNnRuZE5o?=
 =?utf-8?B?b0Z5b2RxSmVLMWFJd05nZE4vdWN2ZzVkbFhMZ2U4ZXlXNUNxTGVTU2c3T0Uw?=
 =?utf-8?B?VFRmeE1XTkltc0RGWG8valUyWE9wYUZCempTT01NUERrQmh6OVptdUhKYjRH?=
 =?utf-8?B?ZVRKMVdlK3Z2V1JLZUR3d0ZpUUoxWDJDRnlObGU3Z2ZuNFUzZTkwTHdlZTdh?=
 =?utf-8?B?aGlickRnd3NjTXlSV3lJZHphMFRla3VHeVVRR1VCY2NZb1Y0eXFLeENQOWRP?=
 =?utf-8?B?a0d5MFpXV2FMWUErenZsbTRNbDhQL0E5UFJiY0RUR0ZHMkYzTFk5cnJhUHdU?=
 =?utf-8?B?VnVGbm42QVErY1RvNTRaQW5GRFpobnAwSTR2UDN5OEI0N2x5dVhaVkdteG9P?=
 =?utf-8?B?cmVINXYvN0JUSjF5QkVTVytHTWVwNVRSdTNnQ2lHYTB1TDkyNWZFNFVxcFhy?=
 =?utf-8?B?Mlgyb3c2QUJ0a1VNSDNKSEpuSEpvSXYrWHNOQnJsaHc2WGtmMGxMeUIzL0Mz?=
 =?utf-8?B?SlZDQi85U3Q0a0gxbE44YXk0V2RicHY2L3ZuQXorNUI1ekZtVURUWG9wbDVV?=
 =?utf-8?B?Q1gvKzhvWVh6bnpGcWpETW1QMllEQ0Nnay9FNGszRlVWRUZpZVNtMnowYll6?=
 =?utf-8?B?d3Y0Mm9IdjJ6OC9MSWs3ZHRTVDBFK3hjNTFHMTk3WTdKSy9YMlNReHZseVlI?=
 =?utf-8?B?SE0rSkRXclJnd2Y3clIydzBUbGNDamZRLzR2cVU1amR2eWJmbjVIRzZ0bllN?=
 =?utf-8?B?MkdZbng0VnkyNFg4YTJacDRiZE5vN255ZUcycDhMT2VsVlk3Z3NJNElZaVhq?=
 =?utf-8?B?K0ltUjY4aDliKzYvb3Q3Y3dUUTBvSzJCeHc0TmxsME9SM3pRK0dvYzAxMFpJ?=
 =?utf-8?B?bW93c2dhV3pNVFpJYmZCOEd1dFhQYWlsWmd2ODA5bEwrekpWam5aS0daZHZN?=
 =?utf-8?Q?lb3UpYNVNNPfh6tw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 649e3670-8af6-4bc7-7be1-08da18658897
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:09:19.1863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q4DkZx6S4+lL3MTRYE0AWiLxNg+lZbWqRU++Cp0yePAhdZgXEBEIJ5udR04Lbil9XX48553gBhhQs3y9dGtaIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2573
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/7/2022 12:54 AM, Jason Gunthorpe wrote:
> On Thu, Apr 07, 2022 at 12:01:44AM +0300, Max Gurtovoy wrote:
>
>>> @@ -267,59 +258,53 @@ enum ib_device_cap_flags {
>>>    	 * stag.
>>>    	 */
>>>    	IB_DEVICE_MEM_MGT_EXTENSIONS = IB_UVERBS_DEVICE_MEM_MGT_EXTENSIONS,
>> MEM_MGT_EXTENSIONS is used also in the kernel ULPs (storage)
> It is not about where it is used, it is about if it is part of the
> uapi or not. Cleanly separating uapi from not uapi

from the commit message:

"

This cleanly splits out the uverbs flags from the kernel flags to avoid
confusion in the flags bitmap.

"

so it was not clear, at least to me, that some user flags are part of 
both the uapi and the kapi.

maybe worth mentioning that or split the uapi and kapi altogether.

Anyway looks good for iser/srp/nvmf,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>

>
> Jason
