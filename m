Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D849E6EA0B7
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 02:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjDUAmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 20:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbjDUAmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 20:42:35 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2071.outbound.protection.outlook.com [40.107.102.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9471BCE;
        Thu, 20 Apr 2023 17:42:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5zFOUuHX65W3YQcdKERP1MWdQPMHdYnVRJwRQaeW5gcqKKGka36hfJnIF9hoyQ4Gp+PKCzOIaKU3pIfnJjYzbQMVuR30L3FmyXnhik3F3Nqslcqk+h+VoPNACwYA2ccEA5mcWH0ff+PCAwWz8K4aNmdZhUFY8OsxKU7ybCqYfYvtLMHJC50NrMc0aQTXz9jqjgUhLGdVjvXeC6tFgNC6Rz1Xkk8C4eA8IcB3yn/mCn83sOt989wCzlSDzpBfg5awr6xd2DvKmed+pRiwmMsua2vPEXfUcVlQuekpT/5pCyFY6RAgfbxSMwKpwZUo306LicND2+P+5ZtyHvbWOwp5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jpiFFitd6NwrVCXwIvp7K9TImBuloIXlnKnYttHcQBk=;
 b=nj0a1D/3Yj+AkKsTXEFYiydbmlYWPmrlmbiShq3MSs22eO4JO0bolRibVR3bxCQHI56PDygVmz12r1gnAOcHM/bBILRn6qlvM11Gig4Ecz4FZZs6cQJLWrR0108qhi188FQYVQ8RPaS1PwBqdcUb64nov0kpayru1R7uqkRbrxCkzayawGCRJq3jC8FXIf3inWA2U5sfQXg96Nge5u/xbOsMhPktvOyy2+GaU2twzAf1w0iSU8Vv3N8MovNGTfXdahtqGIYv+ZwlyA9WNRVgR0jeBxJMLmDS1+H77+03I2sUVSt2cwbvxswsUFIrxlQq1IemIZgsmUBl4wYWBGiKdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpiFFitd6NwrVCXwIvp7K9TImBuloIXlnKnYttHcQBk=;
 b=WerOhSUSl1SUoET46nUUOpSw+biio1GXkd9b8DR7QC9HaIG7WpJu7TUioO2TutEJQMHllBKsU8Dr4/+SuZPy9r0BM0ABpw5o+ZPeTLLWjCyUGa2Y0JXuYpW1a9Ze/iO7xCsp5bEXsXvzo3KhI6CjtYBiBFrklC2anDyqBm7QiF4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DM4PR12MB6326.namprd12.prod.outlook.com (2603:10b6:8:a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 00:42:31 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f%7]) with mapi id 15.20.6298.045; Fri, 21 Apr 2023
 00:42:30 +0000
Message-ID: <5008829f-76aa-1d72-fb98-43b678d4a9eb@amd.com>
Date:   Thu, 20 Apr 2023 17:42:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v8 vfio 3/7] vfio/pds: register with the pds_core PF
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io,
        simon.horman@corigine.com
References: <20230404190141.57762-1-brett.creeley@amd.com>
 <20230404190141.57762-4-brett.creeley@amd.com> <ZDlKj/AvVxwkt4sb@nvidia.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZDlKj/AvVxwkt4sb@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0128.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::13) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DM4PR12MB6326:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e4ce7c3-9e00-4b54-01f6-08db420149d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uas4mOXjuTqYe3zUeEOuW/W6lbquFGETEI+YiqWvagByI7FaCaEuvLrStlju5GO2bHCltXQ0B3iAOMMlsqxhFMG9VSVIcHCEqwpaAScjUd6Mx5m3Y9AUDLTvMai/rWeLOFNLgvKAsR8aEU7Oa4aStWSMsxWzJDCgOChQzzaP3XyGyfVWjNQtkCpNQylK3e4hkiL59ongat+IbB1RgVUiq/eNp6kwFB6pkayRpsKWBxXi6P+UdmHxaVyDKbI50VXFxD5hyKA4bnQcr/0OI6MmlPTAD54IZD2b1MN6DPE6rvmSLrIPaQS0L4WHyKemS2zMbRO8FdN0iOZxYXUTRt7m9QL06ZHOA2Vj49eCqfLGwgylqZENHqPQQgAnLEN9KNNbLtVWBhiu8LinbfPAj50Pwvzom8ty4YhtY2AhrTxMTFT/84pyg3uJSTDmLi2ZKFaN+FxqVKiVY40GdM0lEHQ259x+TE16cKyu3ooFt4i+I3/Ell3mPk87GQLKhpcFtQPXsekQ41w5URRD3wLNVWWnYrAOCA/UZnK+QJUkzXrTjXwv1vVoYZGz9+kmTJJHntPF30qUPyeBvuDqW9tkanBPq5LdHA6Tt6qmR8CxrcoFmRFIoXTLKuA/0Y5D8ytzyyrG5jZZgmc99QVt3O7h+Kd+9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199021)(5660300002)(186003)(26005)(6512007)(53546011)(6506007)(41300700001)(36756003)(8936002)(316002)(6666004)(66556008)(478600001)(8676002)(110136005)(6636002)(4326008)(66946007)(66476007)(38100700002)(6486002)(31686004)(31696002)(2616005)(83380400001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFhjaXluM2VQOHlnTlROejg2bm5mTWY3NVE0V054T3A2NjFldElRVjBhanhj?=
 =?utf-8?B?ajAvdk9id3VBaEtwbVZWUSt4cElUM1dlMWdDdWlDektNVHlzbVFNeHA2KzVK?=
 =?utf-8?B?cEpQNUQxUmY0Sng3VGwxakFEY3FZR3VKb0wvTFlTYWRlYVJaM2pLNG9HTWh1?=
 =?utf-8?B?VnUrSTMwa0VQbkRQR3pUNHh1VUtyVlZudkh2WEg5ZHgvbkt4NEE1QUxId3Jh?=
 =?utf-8?B?TWJmTDcxaDhuZldTNm5VMGhTUGU3Sk9BbVFFZHQvV1FZV1ZRcTBJa3ZGNzJ5?=
 =?utf-8?B?dFZuQ2JOcGUyS0V2ME96c2ZCcERGeXFsclpMaG5wVlV3VGZuQi9aWmNSRDdu?=
 =?utf-8?B?Sk0xOGdQNHNrRHVPRnJrUUVQQUhtelMvbUExQzhQVGg5cnhiN3Q0bWpVdEhI?=
 =?utf-8?B?cHBGNkJKalBRQURVNFVWSGsvcEd3WEEvVVh6RjRSTUJlWTFpdXdPcllPZjFt?=
 =?utf-8?B?RDdlOWljWFZhQUhKakl0ZGc1QXE3RG9HNFJucExnT0hTQ0pDR3h4VzArOGRu?=
 =?utf-8?B?VnhzekROMHZPVk0vT0VxWGk3cTV5dk9UYW5yN25yUG9DYjl5b1VCMDlBWGVG?=
 =?utf-8?B?bzhzZ2NKd3hQSWpTQ2N5eEE4MmxOUlcydmFJTTRGdVRjemV4TFBYMThvWng3?=
 =?utf-8?B?SmdpWE9kT2VXYkJhRE9VWUgzZThhQStZQ0dCSjE5b1hsVUtJSFdsVGRWVFFJ?=
 =?utf-8?B?MW1kN0o1KzJpNEhGNjZrMHBLNmQ4RUN1c3BrNFFkbm9mODFEcTkzSm1lZFRB?=
 =?utf-8?B?and5TlBFb1lQdmUxNXhFa01rTlNBV25iN1grQjBNT1MxdlN5UUZHYVJPdmo0?=
 =?utf-8?B?TzFKSFNMazRLRDdUZWhMTk1tSGpHV1RRRHNOOTkxcXBYeHhZSHAwd2x1MUt6?=
 =?utf-8?B?dm9vTFhoeEl1VTMvWnQrQmhza2ludVdSeGc5SHIrdGkrd3JhRVJjS0RLZC9W?=
 =?utf-8?B?UDVKWlluQ0ZsTHFyQi9hQ1gzV0txVHY5azZaU2czRWg4OGdPNlFONFBqYlZR?=
 =?utf-8?B?WTVxZU5rZlZoY1ovM2EzZ2VJSVhZTkhpTDFOdVdRb1BvektJMXhZODh0RFhW?=
 =?utf-8?B?dDR4N0MwZVFPR3hhNllnSDJtK1NxTWpKNTJ6aEF1cXl4eGo0V0VnUkh6cGlI?=
 =?utf-8?B?d3FzdytUMFcwVGlPblRGT1RJNnJGYXhwa2hXd1hjM1VoekR5a1Yya2FFYWhi?=
 =?utf-8?B?U1E4cytwMzZGeGtUOWJrRUtqV2EwZytvakhYM0lxdHpkSE1rZG1OV0IvYmtV?=
 =?utf-8?B?S1VDTDk5dDFiQklCNE00b3d3cEtQZkFkQUJiNmxGNXFpME1kSEVGd3FqWjlZ?=
 =?utf-8?B?aCtIYW9IYmlndFJEeXJBZCtrWFpYSy9xaFBBTno5NWtTMVZ3WC9hajloUFc0?=
 =?utf-8?B?OHRrRUNJRlFUeUYvQ3MzYzRTamlqTHNOcWhQV25ERGNITXNYMjhNK3RnejY4?=
 =?utf-8?B?REFiamxidktxaWZNVnZscWhXNUNMaFFuQWxJemRDWFFsMXVidVFhU08weWps?=
 =?utf-8?B?cVc2Zk1xU0tNb01MazJXcmRjZ1JJWU0zeDZNTVduSlN0ZzR4YXh3T2huYS96?=
 =?utf-8?B?WDFhWGFzZVBoTnF1OUMvb1g1ajdrS09Qc0oyUEpyYXlFWlJOTXdURC9ocTV0?=
 =?utf-8?B?d3g5ZWdUSGpFUnRZYWkyUzRwVnk3N2M4Q3dVdWE2UDlwZDZGbEVaK2VZSUUy?=
 =?utf-8?B?NS9XWDQxUmxZanF4UG1YZVhEVTJsUGNPOGY0eDNid3hXbGIrNmJhRm1GNURI?=
 =?utf-8?B?aDdMTFo1ZWtYNDhYQXhmeER4am1sWW5ObDVaNHhod21zU2wxMm9EN3NTRVlX?=
 =?utf-8?B?RkRIUER3aEJWWjdhbFpaRjUwWFR2cnJaQ3puYmlra3Myb1hmQWM3YXFkYitk?=
 =?utf-8?B?aGJDUWZRcnlab3RvTytRZTJDQXlJYUlISjNLVk5wY3pEcWoxMUhrTUpMWHVG?=
 =?utf-8?B?WWV0WkhoYjQrSm9JMDVvSitGNS9QWUsxZDNjU1ByTlMydTJqcGQ2MkhiQWlB?=
 =?utf-8?B?UnpFS0RpZDgySHBCMWRBcHFvZ3BrSHpGRHFlRG9CRVBnQ3NVOEgvSC9BZnAy?=
 =?utf-8?B?NzRjQTNxZlNBRm8wWmlqdVdCMFhhYlRFOVpUU1U0dTV2SEt3QmE3Q21WbERn?=
 =?utf-8?Q?jRkhmkxfNt6DSLfMqLaMItkMO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e4ce7c3-9e00-4b54-01f6-08db420149d0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 00:42:30.5557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o2BlI8ZJ46ZdkHXF5qVVNcxoXOir1JxogZaGXnGeisLd+NyNXckVHV8vUvdi0I+wAYOnRWBQxffjAvmRXfzLbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6326
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/2023 5:43 AM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Tue, Apr 04, 2023 at 12:01:37PM -0700, Brett Creeley wrote:
>> @@ -30,13 +34,23 @@ pds_vfio_pci_probe(struct pci_dev *pdev,
>>
>>        dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
>>        pds_vfio->pdev = pdev;
>> +     pds_vfio->pdsc = pdsc_get_pf_struct(pdev);
> 
> This should not be a void *, it has a type, looks like it is 'struct
> pdsc *' - comment applies to all the places in both series that
> dropped the type here.

Will fix.

> 
> Jason


Hey Jason,

Thanks for the responses/feedback.

For some reason Shannon and I didn't get any of your recent responses in 
our inboxes except this one. We're not really sure why... Due to this, 
I'm replying to all of your responses in this thread.

 >> +	union pds_core_adminq_cmd cmd = { 0 };

 > These should all be = {}, adding the 0 is a subtly different thing in

Will fix.

 >> +int
 >> +pds_vfio_suspend_device_cmd(struct pds_vfio_pci_device *pds_vfio)
 >> +{
 >> +	struct pds_lm_suspend_cmd cmd = {
 >> +		.opcode = PDS_LM_CMD_SUSPEND,
 >> +		.vf_id = cpu_to_le16(pds_vfio->vf_id),
 >> +	};
 >> +	struct pds_lm_suspend_comp comp = {0};
 >> +	struct pci_dev *pdev = pds_vfio->pdev;
 >> +	int err;
 >> +
 >> +	dev_dbg(&pdev->dev, "vf%u: Suspend device\n", pds_vfio->vf_id);
 >> +
 >> +	err = pds_client_adminq_cmd(pds_vfio,
 >> +				    (union pds_core_adminq_cmd *)&cmd,
 >> +				    sizeof(cmd),
 >> +				    (union pds_core_adminq_comp *)&comp,
 >> +				    PDS_AQ_FLAG_FASTPOLL);

 > These casts to a union are really weird, why isn't the union the type
 > on the stack?

Yeah, this is an artifact of initial development that allowed us to 
completely de-couple pds_lm.h from pds_adminq.h, but there don't seem to 
be any conflicts including inluding pds_lm.h in pds_adminq.h. So, it 
will be fixed in the next revision.

 >> +
 >> +	/* alloc sgl */
 >> +	sgl = dma_alloc_coherent(dev, lm_file->num_sge *
 >> +				 sizeof(struct pds_lm_sg_elem),
 >> +				 &lm_file->sgl_addr, GFP_KERNEL);

 > Do you really need a coherent allocation for this?

I don't think it is needed. I will look into this and fix it if 
dma_alloc_coherent() isn't needed.

 >> +#define PDS_VFIO_LM_FILENAME	"pds_vfio_lm"

 > This doesn't need a define, it is typical to write the pseudo filename
 > in the only anon_inode_getfile()

Yeah, we technically only use it in one spot, so it makes sense to just 
have the string inlined to the anon_inode_getfile() call. This also 
allows us to get rid of the const char *name argument in 
pds_vfio_get_lm_file(). Will fix in the next revision.

 >> +static struct pds_vfio_lm_file *
 >> +pds_vfio_get_lm_file(const char *name, const struct file_operations 
*fops,
 >> +		     int flags, u64 size)
 >> +{
 >> +	struct pds_vfio_lm_file *lm_file = NULL;
 >> +	unsigned long long npages;
 >> +	struct page **pages;
 >> +	int err = 0;
 >> +
 >> +	if (!size)
 >> +		return NULL;
 >> +
 >> +	/* Alloc file structure */
 >> +	lm_file = kzalloc(sizeof(*lm_file), GFP_KERNEL);
 >> +	if (!lm_file)
 >> +		return NULL;
 >> +
 >> +	/* Create file */
 >> +	lm_file->filep = anon_inode_getfile(name, fops, lm_file, flags);
 >> +	if (!lm_file->filep)
 >> +		goto err_get_file;
 >> +
 >> +	stream_open(lm_file->filep->f_inode, lm_file->filep);
 >> +	mutex_init(&lm_file->lock);
 >> +
 >> +	lm_file->size = size;
 >> +
 >> +	/* Allocate memory for file pages */
 >> +	npages = DIV_ROUND_UP_ULL(lm_file->size, PAGE_SIZE);
 >> +
 >> +	pages = kcalloc(npages, sizeof(*pages), GFP_KERNEL);
 >> +	if (!pages)
 >> +		goto err_alloc_pages;
 >> +
 >> +	for (unsigned long long i = 0; i < npages; i++) {
 >> +		pages[i] = alloc_page(GFP_KERNEL);
 >> +		if (!pages[i])
 >> +			goto err_alloc_page;
 >> +	}
 >> +
 >> +	lm_file->pages = pages;
 >> +	lm_file->npages = npages;
 >> +	lm_file->alloc_size = npages * PAGE_SIZE;
 >> +
 >> +	/* Create scatterlist of file pages to use for DMA mapping later */
 >> +	err = sg_alloc_table_from_pages(&lm_file->sg_table, pages, npages,
 >> +					0, size, GFP_KERNEL);
 >> +	if (err)
 >> +		goto err_alloc_sg_table;

 > This is the same basic thing the mlx5 driver does, you should move the
 > mlx5 code into some common place and just re-use it here.

I looked at the mlx5 code and even though the two drivers are doing the 
same basic thing, IMHO it doesn't seem like a straight forward task as 
the mlx5 code seems to have some device/driver specifics mixed in. I'd 
prefer not trying to refactor/commonize this bit of code at this point 
in time.

However, it does seem like a good future improvement once things quiet 
down after getting this initial series merged.

 >> diff --git a/drivers/vfio/pci/pds/vfio_dev.h 
b/drivers/vfio/pci/pds/vfio_dev.h
 >> index 10557e8dc829..3f55861ffc7c 100644
 >> --- a/drivers/vfio/pci/pds/vfio_dev.h
 >> +++ b/drivers/vfio/pci/pds/vfio_dev.h
 >> @@ -7,10 +7,20 @@
 >>  #include <linux/pci.h>
 >>  #include <linux/vfio_pci_core.h>
 >>
 >> +#include "lm.h"
 >> +
 >>  struct pds_vfio_pci_device {
 >>  	struct vfio_pci_core_device vfio_coredev;
 >>  	struct pci_dev *pdev;
 >>  	void *pdsc;
 >> +	struct device *coredev;

 > Why? If this is just &pdev->dev it it doesn't need to be in the struct
 > And pdev is just vfio_coredev->pdev, don't need to duplicate it either

This was actually the pds_core's device structure. I have removed this 
in my local tree and instead use the pci_physfn() to get pds_core's 
struct device. Will be fixed in the next revision.

 >> +static void
 >> +pds_vfio_recovery_work(struct work_struct *work)
 >> +{
 >> +	struct pds_vfio_pci_device *pds_vfio =
 >> +		container_of(work, struct pds_vfio_pci_device, work);
 >> +	bool deferred_reset_needed = false;
 >> +
 >> +	/* Documentation states that the kernel migration driver must not
 >> +	 * generate asynchronous device state transitions outside of
 >> +	 * manipulation by the user or the VFIO_DEVICE_RESET ioctl.
 >> +	 *
 >> +	 * Since recovery is an asynchronous event received from the device,
 >> +	 * initiate a deferred reset. Only issue the deferred reset if a
 >> +	 * migration is in progress, which will cause the next step of the
 >> +	 * migration to fail. Also, if the device is in a state that will
 >> +	 * be set to VFIO_DEVICE_STATE_RUNNING on the next action (i.e. VM is
 >> +	 * shutdown and device is in VFIO_DEVICE_STATE_STOP) as that will 
clear
 >> +	 * the VFIO_DEVICE_STATE_ERROR when the VM starts back up.
 >> +	 */
 >> +	mutex_lock(&pds_vfio->state_mutex);
 >> +	if ((pds_vfio->state != VFIO_DEVICE_STATE_RUNNING &&
 >> +	     pds_vfio->state != VFIO_DEVICE_STATE_ERROR) ||
 >> +	    (pds_vfio->state == VFIO_DEVICE_STATE_RUNNING &&
 >> +	     pds_vfio_dirty_is_enabled(pds_vfio)))
 >> +		deferred_reset_needed = true;
 >> +	mutex_unlock(&pds_vfio->state_mutex);
 >> +
 >> +	/* On the next user initiated state transition, the device will
 >> +	 * transition to the VFIO_DEVICE_STATE_ERROR. At this point it's 
the user's
 >> +	 * responsibility to reset the device.
 >> +	 *
 >> +	 * If a VFIO_DEVICE_RESET is requested post recovery and before 
the next
 >> +	 * state transition, then the deferred reset state will be set to
 >> +	 * VFIO_DEVICE_STATE_RUNNING.
 >> +	 */
 >> +	if (deferred_reset_needed)
 >> +		pds_vfio_deferred_reset(pds_vfio, VFIO_DEVICE_STATE_ERROR);
 >> +}

 > Why is this a work? it is threaded on a blocking_notifier_chain so it
 > can call the mutex?

I think the work item can be dropped and the contents of the work 
function can be moved in the notifier callback. I will fix this in the 
next revision.

 > Why is the locking like this, can't you just call
 > pds_vfio_deferred_reset() under the mutex?

It was done to avoid any lock ordering issues with 
pds_vfio_state_mutex_unlock() or pds_vfio_reset().

 >> Add Kconfig entries and pds_vfio.rst. Also, add an entry in the
 >> MAINTAINERS file for this new driver.
 >>
 >> It's not clear where documentation for vendor specific VFIO
 >> drivers should live, so just re-use the current amd
 >> ethernet location.

 > It would be nice to make a kdoc section for vfio.

It seems like there are already vfio docs in Documentation/driver-api/, 
but the kdoc added in this patch is slightly different since it's vendor 
specific. Which of the following locations make the most sense?

[1] Documentation/vfio/<vendor>/<vendor_kdoc>
- Documentation/vfio/amd/pds_vfio.rst

[2] Documentation/vfio/vendor-drivers/<vendor_kdoc>
- Documentation/vfio/vendor-drivers/pds_vfio.rst

Thanks again for the time and feedback,

Brett



