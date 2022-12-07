Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF01A646347
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiLGVcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiLGVcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:32:41 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006F22602;
        Wed,  7 Dec 2022 13:32:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSv015phYWWOE+aQvix0P6HmrHKqNMNA3CBx9urpLaop2oSZBBqVmka8XImLnRmSmmctUZEHtwBj6zIolVKhyjxi8wULgw53GHtDsm1bgYg6i2eQpkNh5RJP58WDxY+ZpFP9MC9WaZl+4QvdwRosWJRRxXrikd2uKBUoJKtPey+IORsMRvm8XXu1kDGRTjQ4c4nUibXc1VzzpB0E/dbOcIfHzK6aDwnAJ8el8mSIFZM5UbeT/7Wa2lXYdJhmsKOaJIuBclMwkTddeDxty49IQQs/+uUWalMokK2M0mFF/rnsh1tP+9tuolTkhRKeuNC5PViIt/7M0FzBHMnwgiPWSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qoe3iImiUnkyfdym6trLxTVngbYMfE9t8yZMRI0pWwI=;
 b=FqQ/27JmzzlmR1gtqnItDC1yrO7Wi1MJ7XqYzIde3fwF4ts64nff4SuHJjn9RbspxTVXBkVitsplWDQE0+HB75KrmchpaBM+64sSc7V9JsCIjhLp7CqlQz5//lj6xpwhTj9V4NJ9gaDsaCAPFJHNWgyxHWVR4nHR7xaCHgDuoBNj0QU3sqTugK//qXl1vb1XORRDCg2HxkumwRFQ/AnvR/e+q1nEI519XwSGq9UFG2finkccgu1Uho9SOWnYw+Nyh70ecDalPOSb6L1sIS4xsdbsnpOPTG+t09oX0+oTKhzdW+ubYLZJwGRSpG5nllwMxDSERPZE4IO6+9dj+J2amQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qoe3iImiUnkyfdym6trLxTVngbYMfE9t8yZMRI0pWwI=;
 b=2iqI0RDD3pppnY727CxDXTVfMwWGPbAf6hc4m4tMp02goYN81Z7AkFgwVQGEm7K5pwR+6WWqo72Jsr+7yOM5WH2fFZ6dXdfAywztUXP6QJ1S/CXx0ogph+4lN0n6S0RyfnIdsydpnieCVEmTDy3Czbrl2SilaeWhDhgLAroRJVw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1390.namprd12.prod.outlook.com (2603:10b6:300:12::13)
 by SJ1PR12MB6290.namprd12.prod.outlook.com (2603:10b6:a03:457::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 21:32:37 +0000
Received: from MWHPR12MB1390.namprd12.prod.outlook.com
 ([fe80::6fb5:a904:643a:4a5e]) by MWHPR12MB1390.namprd12.prod.outlook.com
 ([fe80::6fb5:a904:643a:4a5e%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 21:32:37 +0000
Message-ID: <a94d3456-a7cf-164c-74f1-c946883534cf@amd.com>
Date:   Wed, 7 Dec 2022 13:32:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH vfio 3/7] vfio/pds: Add VFIO live migration support
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io
References: <20221207010705.35128-1-brett.creeley@amd.com>
 <20221207010705.35128-4-brett.creeley@amd.com> <Y5DIvM1Ca0qLNzPt@ziepe.ca>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <Y5DIvM1Ca0qLNzPt@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0104.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::45) To MWHPR12MB1390.namprd12.prod.outlook.com
 (2603:10b6:300:12::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR12MB1390:EE_|SJ1PR12MB6290:EE_
X-MS-Office365-Filtering-Correlation-Id: b658584b-b568-4d37-6c10-08dad89a8f5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BNyDPiZ4QsfUIoKquOe36OQKdUf/2EVsqnRJdhhuVxWqdSmhj5xnS/ga624HcLvb3wctlV8QFtNgKBwzoEo6em09fdf0LK3eVzK1B9UKbsjb+qp5RTUm6hYGLM1hpwpsx2uXevYJZD+OiB1itmkzDAKGumT2m6ebtKigznsNjWpBAKjrADjcxZxHckipuEbFm61onu97/fjK/ghwSgGlB33N9241ULWEOuwO/ldFRhws4Vyq+REZKceUwH7AQ3dy2E0C/M0fcwNauyein6gbarnEwm0V6oXRBfAWXMMn98y0djf1xfTU7QI/Qc7NhkMHuasibbN8DoKfe5jSvexzVgxNqBIdvbcepPVrA3ypfsqKi3R5EcuC6o4bTxiBzxVX2hc1QdWdg7VQ3X63JL6DCHi4x1/LinJGm6XJeNfodfR2vy5dHOkQShWtNTuksQaDlACPm3DkVtNGTbrnYen3g1En0R+jP7iTDsiYoh7BbA2Vl27V+Txp93+vzBfyGCIiuo22KQvBlwTvt1s0EBl0Kr92FdyDbVSdmliznYWYqX20s9vrSSD4XiZtbCw9KvIXZefs9P5PxEOSZC/isZfrYJJ33vb7TwAwvAmZGkxP50FHauDAyeu9tLv5OqmPZu49iwR0JL1zUo4kmLBh+HAnGj4OTOPc4GZB9EMnutbQFpVGHp5OLEflsATyYy1gVCWktdOLUakmHC472awtFQdZggrCqmJ+0+V6qhH+82m6V+6CO3iBj6Xs1Vbe0M1OVt2Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1390.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(366004)(346002)(136003)(451199015)(41300700001)(66946007)(66899015)(31686004)(8676002)(4326008)(66556008)(66476007)(2616005)(5660300002)(316002)(8936002)(478600001)(31696002)(110136005)(6666004)(83380400001)(2906002)(6506007)(6486002)(53546011)(966005)(6636002)(36756003)(26005)(6512007)(45080400002)(186003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFc3SG1VdWU3MUtLSG5NSDdxR1VKamlZU1BUWFJyQjZKQ2lTUm5SUTNlS2FQ?=
 =?utf-8?B?NW1aWTBrTC90dEVUR3YxVnNhMjRXSWxaeVZDUzNjbks2eW5YOVFpdDdVTkNo?=
 =?utf-8?B?bTdTa0M4Z1FVc0R4bWdySXNrcm1RcWRFMUkrVUVuOGw4SEdBUWk5ampIeUhO?=
 =?utf-8?B?RkdBTzZUbG9NYUxTZXBpdFpyTGxCVHF0dFdGZlAzaTJSNU5tU0R4Umk5Zjly?=
 =?utf-8?B?WDZCaVRQaDdtRjFKaXo5T0YweHhqVUNsME9qMnB0OTUzQWFWOXhPU3ZuQzAz?=
 =?utf-8?B?Q0g3SXNVeFcxRHV1VnJoQlNvTjRhT3VERU1Cck1YU3dtbkVqajhzT3lNYUs3?=
 =?utf-8?B?REpyYzdTY0xsN0xKem1NTWlVbjFJSXg0bk5HWUsxSkRONXBPSHEvSjhyS2tz?=
 =?utf-8?B?S0NrKzE2Rjg0QWcxcHEzdjhOWHorcFdvQ3pBa0liTytHNU5oN0Fqd3ltbFhs?=
 =?utf-8?B?RC9NRjhmd1dCd3BLbWx6MS9nVU5mcGJhOFJkdGdTdHhmeERXY04rRGtxMUZx?=
 =?utf-8?B?VU9UTEhGSHVaUVNkYng4TS9YZWxNMmpwS0VLTzUrWnRJaWpSemxOUnFmVWlr?=
 =?utf-8?B?N0lZM29naFR0UlZreUNWekRqT1NvQkVsNmZBbTc4SFZacHUydkhhZUVsa3dV?=
 =?utf-8?B?VkxkSk9mM0ZiM2hPWGIwS0M3dnNHaGtHUnEwdTNrWEtGK1J2Q0VJUnc3YzJR?=
 =?utf-8?B?MTE5ZXRtejdaeVQzRzRZMDZRUjVhRGdtdWJRcVh3aUwzbDMwMVNlNEJieFpk?=
 =?utf-8?B?ZytiTHRUcDlkL1BaKzBudk16UzhTTFA3Yzl2UXVUL1k3dlM2WHA5SjJ1bTlL?=
 =?utf-8?B?L0N2RGo0U0NIeTNHemh6eFRIMWlqeFUzSU9KRlhsZWhpSVlmT2ZKQUJNSnZm?=
 =?utf-8?B?V2t1L3BSV2dKNDdNQzR4Y2NXcHdPUDZhMzdpY3BVRDRKMzQwQWlDSGgvQ0hW?=
 =?utf-8?B?TTcwbU4xa2F1VUpoZUVubW9DdjE2TnlUQVNRMUl5SWlmbDFwcDcwMXdHUVc2?=
 =?utf-8?B?MFQ2THBRblRrQTcxMTNkdlBHTEJIYkxoSE9iNE0wQmZTanJES2VlRlZveWdU?=
 =?utf-8?B?Wk45eW1nbjJFQXFFRnhNMzd0c1BHbk1icjh2ZmwrYWxGYmljMmt1TDFNbkJp?=
 =?utf-8?B?K2FSMFhaNFhjV0c3TlhxdTQ2VWpMNGk4bnR4THJPYURUdTZEaTEwbnhCRktx?=
 =?utf-8?B?eW1SRnZxNXhKdUtseTBMeExTYzllOFNQSTgydjFGVGc5QWhwdlhRUTJYNGIy?=
 =?utf-8?B?Qmp3cFNVazVUVTRGTVdVczEzcXFVb0tBN2t1Y2NsU3R2Ym04L3YxMHp3M3V4?=
 =?utf-8?B?ZmFyUUNQUjB6dWtuZ0toVTBBKzZCM1J0dGlYR3AwY1VneU9iK1lpMEp0N1o4?=
 =?utf-8?B?b0RqclRaVzNCNFJueWh0NHNLTWFXWlBuQXQyQ3h6ZS9CeHA5engxcFhUb0Vt?=
 =?utf-8?B?SmdIMWlLcG9zLy95bWhLUm16Y1VGQnlYMTRqT1VBbUZJQWNpcWY4RlFjenZu?=
 =?utf-8?B?S3BWMytIUHlLUFVLNTR1OFhDRkRGdFlnQTUzbWdBeHBsM2t2eENpeUtPbS9I?=
 =?utf-8?B?YXYrVGRNR0RNQjZQUkcvWEpJbTBjT0hyTUlkV0tlb3JseGZlUXIxTHZSMXg3?=
 =?utf-8?B?QnY4Nyt5aytWY1d0aDJBdjhLRHlTeDJaUmlzTktQandlaDAwSFhjL1lvNno5?=
 =?utf-8?B?YlNNSGRYWlBjaEdyNWUxVDZ3bnhuV2RFaGpoR0hQTExFSXJ2VWphamF4Sjlt?=
 =?utf-8?B?eVl5VGdHQUNuc1BlR01jVVRwUmUxcitDMnlvMUlPZmhYY0wzeUJaZDk3UFV0?=
 =?utf-8?B?cTdzWC9MT1I1WEJLdnF1SlVjMytsRjNXb0FLZ2xHOUxpYjRzQjVKMGQxdDR1?=
 =?utf-8?B?QUtsWjlQS3h6ZkVIOVdZSk5MK1c1cWk0V215UTBUY2hDVVlDcWZudE5hQWFN?=
 =?utf-8?B?MCt3bERpa3RJelJQNWJGNkl4a1ZOOW9ud3p3RVFqc3AxemdHNHJKSDNSSXUy?=
 =?utf-8?B?QXlzQ0l2clpuZU10ZUxnKzJQelBySVZwa21rSlVZMGE3VUE4dnJXaUN5bDVH?=
 =?utf-8?B?SnpCWU5uWDhxaTk4QmhIN2ViU1ZtaXVkZzgyM1djaTZ6a2Zaci9ROHd3NWpN?=
 =?utf-8?Q?EUAAM2oD+XG1RGsL52nlWlYCl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b658584b-b568-4d37-6c10-08dad89a8f5b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1390.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 21:32:36.9917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /eOurhES3ATbY5xMaGL0sL80esu4dlFcfOKzmnSNGcRaciJBPF9HEkEaYcSJTbVD5gifWhieaEIrWPbGOCpW3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6290
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/2022 9:09 AM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Tue, Dec 06, 2022 at 05:07:01PM -0800, Brett Creeley wrote:
> 
>> +struct file *
>> +pds_vfio_step_device_state_locked(struct pds_vfio_pci_device *pds_vfio,
>> +                               enum vfio_device_mig_state next)
>> +{
>> +     enum vfio_device_mig_state cur = pds_vfio->state;
>> +     struct device *dev = &pds_vfio->pdev->dev;
>> +     unsigned long lm_action_start;
>> +     int err = 0;
>> +
>> +     dev_dbg(dev, "%s => %s\n",
>> +             pds_vfio_lm_state(cur), pds_vfio_lm_state(next));
>> +
>> +     lm_action_start = jiffies;
>> +     if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_STOP_COPY) {
>> +             /* Device is already stopped
>> +              * create save device data file & get device state from firmware
>> +              */
>> +             err = pds_vfio_get_save_file(pds_vfio);
>> +             if (err)
>> +                     return ERR_PTR(err);
>> +
>> +             /* Get device state */
>> +             err = pds_vfio_get_lm_state_cmd(pds_vfio);
>> +             if (err) {
>> +                     pds_vfio_put_save_file(pds_vfio);
>> +                     return ERR_PTR(err);
>> +             }
>> +
>> +             return pds_vfio->save_file->filep;
>> +     }
>> +
>> +     if (cur == VFIO_DEVICE_STATE_STOP_COPY && next == VFIO_DEVICE_STATE_STOP) {
>> +             /* Device is already stopped
>> +              * delete the save device state file
>> +              */
>> +             pds_vfio_put_save_file(pds_vfio);
>> +             pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
>> +                                                 PDS_LM_STA_NONE);
>> +             return NULL;
>> +     }
>> +
>> +     if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_RESUMING) {
>> +             /* create resume device data file */
>> +             err = pds_vfio_get_restore_file(pds_vfio);
>> +             if (err)
>> +                     return ERR_PTR(err);
>> +
>> +             return pds_vfio->restore_file->filep;
>> +     }
>> +
>> +     if (cur == VFIO_DEVICE_STATE_RESUMING && next == VFIO_DEVICE_STATE_STOP) {
>> +             /* Set device state */
>> +             err = pds_vfio_set_lm_state_cmd(pds_vfio);
>> +             if (err)
>> +                     return ERR_PTR(err);
>> +
>> +             /* delete resume device data file */
>> +             pds_vfio_put_restore_file(pds_vfio);
>> +             return NULL;
>> +     }
>> +
>> +     if (cur == VFIO_DEVICE_STATE_RUNNING && next == VFIO_DEVICE_STATE_STOP) {
>> +             /* Device should be stopped
>> +              * no interrupts, dma or change in internal state
>> +              */
>> +             err = pds_vfio_suspend_device_cmd(pds_vfio);
>> +             if (err)
>> +                     return ERR_PTR(err);
>> +
>> +             return NULL;
>> +     }
>> +
>> +     if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_RUNNING) {
>> +             /* Device should be functional
>> +              * interrupts, dma, mmio or changes to internal state is allowed
>> +              */
>> +             err = pds_vfio_resume_device_cmd(pds_vfio);
>> +             if (err)
>> +                     return ERR_PTR(err);
>> +
>> +             pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
>> +                                                 PDS_LM_STA_NONE);
>> +             return NULL;
>> +     }
> 
> Please implement the P2P states in your device. After long discussions
> we really want to see all VFIO migrations implementations support
> this.
> 
> It is still not clear what qemu will do when it sees devices that do
> not support P2P, but it will not be nice.

Does that mean VFIO_MIGRATION_P2P is going to be required going forward 
or do we just need to handle the P2P transitions? Can you point me to 
where this is being discussed?

> 
> Also, since you are obviously using and testing the related qemu
> series, please participate in the review of that in the qemu list, or
> at least offer your support with testing.

ACK.

> 
> While HCH is objecting to this driver even existing I won't comment on
> specific details.. Though it is intesting this approach doesn't change
> NVMe at all so it does seem less objectionable to me than the Intel
> RFC.

That's understandable and thanks for the initial feedback.

Yes, no NVMe changes required.

> 
> Jason
> 
> --
> You received this message because you are subscribed to the Google Groups "Pensando Drivers" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to drivers+unsubscribe@pensando.io.
> To view this discussion on the web visit https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgroups.google.com%2Fa%2Fpensando.io%2Fd%2Fmsgid%2Fdrivers%2FY5DIvM1Ca0qLNzPt%2540ziepe.ca&amp;data=05%7C01%7Cbrett.creeley%40amd.com%7Cb5b743b18f054684cc3108dad875c84f%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638060297638789271%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3xXVIMNmYF7qFjhOiW9DDhbrzZklx%2FZ9xmEirgwodfw%3D&amp;reserved=0.
