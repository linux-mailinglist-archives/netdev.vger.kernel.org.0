Return-Path: <netdev+bounces-7588-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7747720BBB
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:06:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53695281B2E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7955EC14D;
	Fri,  2 Jun 2023 22:05:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CDA539C
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 22:05:58 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBFAE42;
	Fri,  2 Jun 2023 15:05:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=imcNEkVBC4VjmEiWPNNLWKDLl3t/sUZFYrT0+mbEvi4A8SjrbriYjhiUxlGuXWUQCEylweHxgxHwYRNmTeWkbBlQJ0/aE7ehUZhgJidA39dXeK/6DlugGdIEphS5WbbYRj0rydmqsdlM3r3+pfPFPI6vy+Fca+MK2A17iqzOwxGfSVrNwxU5/SkDyYRnoxeyyninZhR7ORXvIKWMpFDFaFZipyFjtWe2cN9QqE6D0G9dOyxk/jxqkG1k0xoXv2G2EeMDK1hB1wKTVikEp9RiZ5bcpkE8W54eZmUThac81kkA8n3Qosktq6PZAaFLvH0pTj9tvnQeXgNZNCXib/CItQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jEs7kbMMOgsT4t7lFIwIukhHWdFCNfq6s549OjIOc7w=;
 b=e5UiJYfrJLYQ2tSGdKot2YSeTsQpGi8+Yrff0Qs45ttvmkHK8yzDSzBsr/8jIBARYG8n5DqlQv9WrisUNVCL4gU31Ci1aWr8GiET7j26ju64oxunh4TS+89OtKg5CC7xLArwQIeyjSlRDN3S2oxwElde9bHTwHhsHg0cLkVW0HuTgTpskoK9jYXceAY9j3UBxOj+3aJIZZmyaRIW1lVx5e93PbXb/oYb1Z3vS9zW+EhTsbkoHAqSXIy3DQ7qaRWOBzRPOspD2VQeC/ZBAPgOFlICxO4CgiTVRH413rgEq9rbRu3IrzlAsbz/vkhsrmwmKxPFdJMckOtjbfaxOX5Q+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEs7kbMMOgsT4t7lFIwIukhHWdFCNfq6s549OjIOc7w=;
 b=jemYjLy/OlzWzKRWq56fq+FYjKObx8rN9SW50anPd/BU3CFL8MLPwNTK6FpAFUW0oER5AU4BLeENkwDGa95LgkiEc2//AKz9/GmihddVa1aDXPtJNOKUgcj1S5a8g3JDZmUEOCDZC1ZC/mDK58nYJfITume1ROnjpCtD4ItMGjM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by CH3PR12MB8910.namprd12.prod.outlook.com (2603:10b6:610:179::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Fri, 2 Jun
 2023 22:05:53 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f%5]) with mapi id 15.20.6433.024; Fri, 2 Jun 2023
 22:05:53 +0000
Message-ID: <3520b43d-ae3a-5c22-232a-5feedd7576e9@amd.com>
Date: Fri, 2 Jun 2023 15:05:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v9 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
To: Jason Gunthorpe <jgg@nvidia.com>, Brett Creeley <brett.creeley@amd.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, alex.williamson@redhat.com,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
References: <20230422010642.60720-1-brett.creeley@amd.com>
 <20230422010642.60720-3-brett.creeley@amd.com> <ZFPr9NWf5vr1D+Uw@nvidia.com>
Content-Language: en-US
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZFPr9NWf5vr1D+Uw@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::17) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|CH3PR12MB8910:EE_
X-MS-Office365-Filtering-Correlation-Id: 909eaf48-1a7f-4930-4625-08db63b58896
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	I96WQpP1NNn5xd+zFXGiTlvc8wmRj9nVf37TSzy6fC8Mt7LEvirkK+Su2VBgBGiTNIyWSlFQPZikPOJeyisJRZ4pE8Nny+1fRv5WNlOEYSb2anFMGN3vIdR/85DOOdUExZHOIVEosOLOVhsBcLXTljNcBwM0EXZTc79dqWCWI2nV6IBhS9bfEyw6g74D67R7mQ4zMccYBEpXIMTzkyY5GXpOcgT+sGBFI6WagHWX2Q93s56QkQegl6EqpUeCeNNpLuwalu3UqHe+zhP7BrKnl1ss6kLlxrcw2ko5Oop29FpjjKZ0Fqwt3mVKbp8Jnp13vIdOpk/5HSieXxHxYtjUmkxG8wS6mZYPDiXyLwwk1Am/6lJ3xHhtRhazhDVroW/+VOgj2Ks3fgkzQnCEK1fF1cMinFKKn6L9sC4RWvsttMbGTWyXfoegr9S7rO0MqA8nTrv+pekQAuTGCcjVOGLAp2VmM8qPdFqeAEMf7TRXgdZZklLbEp/6V9FfbK5qVHCkAibWesGe4D2fMSEJzHsjLbuz5k93+v6vFx6Z8DnFLK6eEYhF68VrD4V5HtMRUua5m9m38Df8n2Apec0JgkoJBb0o/HdQTFEhzc0dTKS9VblDD93JeUbZfJYGiqPdATSZns9xh2ywbW597Ig20bdymQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199021)(478600001)(110136005)(5660300002)(8676002)(8936002)(41300700001)(6486002)(316002)(4326008)(6636002)(6512007)(53546011)(186003)(31686004)(66556008)(66946007)(66476007)(26005)(31696002)(6506007)(2616005)(2906002)(83380400001)(36756003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2FqbElRYXQyQkZmN1d3b3ltOFUxMUYyaFgvUm1FbVgxOUxhOHBSWDB0OHo5?=
 =?utf-8?B?S0FYUy9QNm5CRjBoYUdQS1lVS3ZGV2VjcnZiVDFsSUJOYUpJSExtWS9rVjZq?=
 =?utf-8?B?TXRMaG5UQ3I4dzVFRWhVYVVHSVowWE1DRVIwV1JLaHUrcHpteDFLTEdKQlpo?=
 =?utf-8?B?WG4zSUxqdGkyaHZyKzZxT2lUUklxeEtma2FtNVRPdUxOVWVyUGhidVJlU1py?=
 =?utf-8?B?SG5PNnhDb3NNYThpUlRIWVJlTmgwVmNPR2tQRklSQTJ0SFl1WTBlOEZaZFZ3?=
 =?utf-8?B?WlFYbGkvOWMwcjNpMHZUOHJCc3hLeHpkRmoyeWlCL3lxMVNlcTA1ZjMzejRy?=
 =?utf-8?B?OVRiazBwTmlTSU5uVG5FeURqTzRBdHRlVWdKTE1qSnBaUEEveU9EOUd0ck9o?=
 =?utf-8?B?aUlsbDFmQzdYZHFTQ3k2NnVBUG5DUkduZllmZ2ZLU2JVN1ZqUzJ4Zm0xckFj?=
 =?utf-8?B?Y0Z4ZWUyc0s1QkduenFtdzNjZjNVRHNCZkFMMU80cVJlZ3kyVEZtbzVqa0JY?=
 =?utf-8?B?V0V2Z3VtU3VmVTJrQlpUbm00OWNQYUR3TVVoTFVaNkVuQ2ViVmlrWGNiVllE?=
 =?utf-8?B?MHljTlpPcllBYnNXcUoyRUxVRnExNUpOODVTVElsR29KZVhDdEE5WTRIQi8y?=
 =?utf-8?B?STRqeDh3eWp6MXd5a1JXUEM1VlNCVHR3Qkg2QjlNcUQ4bFI5V3ZuUytjOFVn?=
 =?utf-8?B?UTMyMTFHOFhiMVMxS1p2N1RTNGQwTHk0U2tLb2pzaW5kYmU1MkNXekM3YU9J?=
 =?utf-8?B?N1pSdFB5cC9zeG9aNERSdk1mRHdvZEpiakpyUzAwK2p5RjQyeGFWZnFjTWgz?=
 =?utf-8?B?Q29oak85WUVGVFVranI0RkdveXN2WEprQnl1ZXNzL3A3Tk8rWjZBMkZPc3pC?=
 =?utf-8?B?OVlCR0QybHBUU3pIdFB1Vm50bENibEo0QUJ5OWJuUDhJMVV0S1BJOGluRmV2?=
 =?utf-8?B?VnZoazJreU9lK0JtdFlHbXNncnNsOERkL3Jzb2ZsWXN4d2JPRTV6RzFmUHdv?=
 =?utf-8?B?dE13RExpQ0ZHdHpBaTkzZjcwQXlNVU1ndzc3ME0zS3dhZEZUUEpGMEJiSG8z?=
 =?utf-8?B?STNseXc4TW1JQktXenBzbHJXeit2VVZTT0FueFdDWStRSUxIQ3QwWWptMXRE?=
 =?utf-8?B?NU9vb0poZE5vL2tMM3dqb1d1TXp2UVdqekY5ZS9BOHgvM1U3d00wVWxFeFk2?=
 =?utf-8?B?QjdLM3BLSTcxQkZFMkRkK3k1WkU0STYrMGRTNytkUGZ0ZllSbHNvbGJiL00x?=
 =?utf-8?B?K3k5ME4waU1KM1RBMWNiRGtaODJGY1BxM2F3ZGZJMy9EYVdoL1BjbGVtQ3g3?=
 =?utf-8?B?OFp5YXY4a1p4VlVHYXd0VG5vT1BHdEtRRVhNWTRhSVNxVHRFZjN1TmE3REFi?=
 =?utf-8?B?SmF6U1doRmVLL3BtVHlOVGtsYm1aRW5FVFJ3ZENLakI4Q09ZbzdsRkJWZ0Uy?=
 =?utf-8?B?Y0FEYzRlenBKN1VkaUQ1d0Q5VUZiTEZ2OElqZCs2KzBONUpXanliMXo3aUlt?=
 =?utf-8?B?MVI2dWVGWnZOYmt6alBhOFRYckgrY05SQUZPSXpXMzBwQzB4clNsYTNVQmp1?=
 =?utf-8?B?YncxMHByS21nU25XclJIVCtRWDJuUXRQSDlOa0twZ05IYlFLUUNiVDFGMGFK?=
 =?utf-8?B?QzAzL0FqQ3ZualYxWWVMS0lKSW9YK1VZTkJZWVlCSFVNZGNIbk93OVVyUHpF?=
 =?utf-8?B?cWtkTXFjVlBaYzRuUE9paWdOT09OWE15VWpyekdDM0lXQlloRzZWbkYxcUJ0?=
 =?utf-8?B?cVVjR0x2QWl5L0hKbVhnR2VMdHdLWU5kRTVHL3oyaEFJdExjZEJjVTJ2L2w5?=
 =?utf-8?B?cjk3RkZsVDFldHNXQ2g5a085Uzl6VTc0MkhOQmY2bkhOcVcwNmFLQU53a1hM?=
 =?utf-8?B?dEE2MGNZUGpORmJ2M0FqU00zbkw3aEU2cVRVeVNaYjh3WUJBRTF6ODBJUzBQ?=
 =?utf-8?B?TENobzd1U0swUUxFd0YycjVuVTlFUU5WWWpoRDl0VFVPallEcjFpaHdpdWdI?=
 =?utf-8?B?TlFSOGZCb3VPZDdUc1ZRSzZjYXdXR0VtbWRZVW5aSE9vSXptM1VHMUFEK1lI?=
 =?utf-8?B?cFNLOE02K2IvNDlFbXcrK2ZVa3oza0c2YmdrRjN3RFE3ZFpMS3JGSzM3SzRy?=
 =?utf-8?Q?Mmcs3Ou+Cz0p2tOQar0kUQ9nL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 909eaf48-1a7f-4930-4625-08db63b58896
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 22:05:53.6334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y6xIe+WqjJJa37SA6vxoQ+l8tgeH8lXT5/VpLTPLULbk/TsSBEG37YwJVftJsOb5qQrt68b4ANLpZJUmp57CQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8910
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
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

The reason I did this was to separate the pci functionality from the 
vfio device functionality. There are other similar examples of uses like 
this. I ended up not changing this for v10 because it was intentional 
due to the reason I stated above.
> 
> Jason

