Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCADE6DE258
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjDKRV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDKRV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:21:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494C5113;
        Tue, 11 Apr 2023 10:21:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RLC4A63TM5wKsZeDxCFchlQGtX6J+uLWLukSEwgEfp00dbNN/Ot2WY7RbFUvdK7eyx2eNisn36t+k/5IiGgMYvIxKyC74PZLYV6Du05Vz9JItL4qdyrTVzZprZ9hJVLprldLvkzPzdEFT1Ru48KaGbHV1XHdg6Fo9+sJc08DTgFNKNZU2RwHTAEjnEq7qJKEEsiYBkqQ75kMp/FYyA+TzCd/fYdxtBQfE/b4mMboEakrEzUO1Mtr+p33g0FN0E8wpKzQaHSzx/qEDCcIsl9YPGRmc5kC6vqHDHcdy0nQXAS7UARBo1gT628qyI30offEntyAw19JAnU0f+cl2huDkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cxiJGp/NdLTe4p3vbVmFrr/bAbGRQnuby0WtJv2e9ME=;
 b=FPEJPM87vogWVvN34lAwVELcH4KltcqIagtu57QxpwmZuKrr/CdZQrZO6tk+5VmspL07jEuQ5ZxQ+dZ1z8OM6i7mah9pYnKiuznTF5I+nSSCDeDBHKPblQjM7nvCXgMiGnGHmqa1F5zLdSgOViFL5rJ8T/9446jPU8n44W4Nlh2gj2Qh1a47uf0MgXoSN/2mSCRG0FwANClc4vbUm2ZijI3K/LnY6YQgYhPROs52Lfn4xf1FCGcC4Q9tCXnaIKORYGBugb3vP84Xnl0IG+NESMGG++S9p1NG/EEyQB3SFJ4n658+9gdTSB18B+44QF+eYN5dk9MtKYrj1b7b4hDtHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxiJGp/NdLTe4p3vbVmFrr/bAbGRQnuby0WtJv2e9ME=;
 b=bQ4fbfF2+h/2JBhD+lBD9DyAI4OZC6UuqZ+YAE1cIMXyA25yEIywCVkgctWRuIYXXg8GVMO3LhgKLQ83MeMK4ivdRm1wVl0gU1w31O9BlSTaePOBUgEjJszckNdHkYNk5lv86zkgmQTkv2RX7jaoosvakQ7Sd8+FYgwkKKFNrIg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by MW5PR12MB5649.namprd12.prod.outlook.com (2603:10b6:303:19d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Tue, 11 Apr
 2023 17:21:23 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f%6]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 17:21:23 +0000
Message-ID: <7ac39d55-8ab1-a8d2-3476-97895519133c@amd.com>
Date:   Tue, 11 Apr 2023 10:21:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v8 vfio 4/7] vfio/pds: Add VFIO live migration support
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io,
        simon.horman@corigine.com
References: <20230404190141.57762-1-brett.creeley@amd.com>
 <20230404190141.57762-5-brett.creeley@amd.com>
 <20230410160538.35c1a5a6.alex.williamson@redhat.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230410160538.35c1a5a6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0074.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::15) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|MW5PR12MB5649:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a29f12d-5dc1-4a2a-4d05-08db3ab12c6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IBWrGBcTRWNkDB1WfdBuy2tSXAp5879ZDg/7dpgaom1ZDY5ycT7u3sQ79Q5txgxEQoi8zg5bKB5NTcu94ZN+6rd1eXXba/xAkl2SEkFnV2ydBQ48XhbUMAV8JZlRbs2u53vS61xllUThLcU7ByqBIq68O76k2+ah5z5vBAg1FgWUy833sfSaaM+2+Wtc9bq+CuIlAFMK2Cccl1IEBug6KWgsDyZ06riX12hv3EnXqHAhZ6BkC2HswO7ehOflJZWFqCt8rXv6w81pSwhaN8uRmA8vN3oN95ADCz1O/bdCNQrAvH9DLBQ0OAW55HXF9yCfvd/l1ViPqPFGFgAlps7XuTxfr2b7lI1C5EXceoeAW3WybpKW78OAC3FOgXvVthVTKfi2l8drRvDZFTX+WUrFv/O2StlXcJwzaER2cg+14i31T+STP6sPtoeFXMOLrOcAK0COysiRes98BdcDVZ9h24qzE1zT9gcgn2N6Xcz8lEIE9d4UcQ2+LE5h6TEtoCbN+PM07UlhwMWxXCn9QVxoHOS9MU3eYoMU5/0viASgcvY+yM298m35zLt1tWjfJOfT1OOdVqBeFezkQe7PBKGilnrP8MpCI35kwMh7etlGzSwdpMnQEql9qTDp1xxfKOXVemHBW7zpWkeIgunaukxUCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199021)(6636002)(316002)(4326008)(66476007)(66556008)(8676002)(66946007)(38100700002)(2906002)(110136005)(5660300002)(8936002)(186003)(83380400001)(6512007)(966005)(6486002)(2616005)(53546011)(26005)(6506007)(478600001)(31696002)(36756003)(41300700001)(66899021)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzJiVEZXL1pteUloR01saXdZeE5FRUtwQ2pSZS9SdE1TWGx6N3BqdmQvSUNq?=
 =?utf-8?B?N0FIeHE2cWd5aXFHMzJGcEdqU1FWZVlQbVpXMTdGZ3puRjFkZUxQbkFsaDc4?=
 =?utf-8?B?WUxXa2FWQjdPdFZ1Y3RLa2pJRWl3a1YraUZWcjFPS3NTUm9xWVJJelpEOUFz?=
 =?utf-8?B?M3h6NE9Kb3RYTWdmVkF0WU81bmF6MklVYlZrSmVvWnVPbWg4N1pDdGtMZ3V3?=
 =?utf-8?B?RnlSdTJMNm1zM2hSaUE4TnhZUGUrVFhlVXlFMnR0aXBPR1BWdnhxNDRtbXBZ?=
 =?utf-8?B?dFBveGZVMUFKQXRJWUlvVDFJMUtPVFNqLzVoSUxScTd6eFJCUEZxejF3c21Z?=
 =?utf-8?B?Qy9QMm9kL0FwcEt2OTEyVENjYlliREs4UlZUa1FpWXBTWXJ2cUdFbFcyQ3RG?=
 =?utf-8?B?RW1oUldBMHVxQUwxRWc1WHlHaDhObmY4VE5MTmVzWkdsQ3g1TnFCMWFBY1l5?=
 =?utf-8?B?eW9nNWNPM2J2RmtHOXRCdW1ib2dpU2JuWk9ER1M0alUzTXZYOVVkK0lnT1hN?=
 =?utf-8?B?ZzA4QUU4T1QwSzNmZVFrbFJ2c05mKzBneXhnV09wS0NITlZUZGR1VXhiQ1Nm?=
 =?utf-8?B?am00aFJodzlsMTBpNUhsM3BIeFZhamtkZ3VwWVprcGFIUkVmUmx2a1hoTFNj?=
 =?utf-8?B?VjI0UmhJOFpyNGsvdlR4NnBKeXNQSHRFdHJNWVFIMkR3U04xc2pFNUkwWHpk?=
 =?utf-8?B?bitKQWVLYkJoaEJTUlBzd3cyKzFRNWlLS3FDMTF2bEIwYW5XUnpyWm14elU1?=
 =?utf-8?B?cWpVMkw2ODNPbUh4RlFYa2szMXVSVFBLNm5scUdKNktXKzZCWHdIQ0paM3ZE?=
 =?utf-8?B?UTZNYnk3bXJrbm1WbVhNME5xZUZtMzJocmJrWFRMY1UwaWpSN0daeEJBTnVD?=
 =?utf-8?B?QWZ1Q0txNS9CUzI1c1I4QXMwVTJLdi9JUm91ZFo3K05UTUlMZFFmVlFQRU9r?=
 =?utf-8?B?dVRYNE43cWhiT0JVQWlNWVV1ODJsNkdpTWUySnh1dG1FU2tYditvSFZ1KzBs?=
 =?utf-8?B?dUhCcE1pN2U5bXp2TFlCT2xUc2FJYUlVTUdhK1lNMVRBLzMycmUvd0diV1Rz?=
 =?utf-8?B?TTg0SUJZTWRyMWJpTCtLdnl5UkQxV3V0aE9McHI4eWsybHdjVDFmZmpQN0JP?=
 =?utf-8?B?Rm16MHE2ek9xaHczaFROVmdubGM4aWxEbFZ5eFB6THE1OUZPZWRjTlRNZHZN?=
 =?utf-8?B?ZmdLTlBwSkltc3E2cy9hdHZqRG1jcEtQb0FJUGp5ZnlXaU84WUxxK2d3aE5o?=
 =?utf-8?B?L1ltQ0Y5OWlJaTJ3dk5KNUVZOXZ5K0JDYXUyRk9Ka2FJWGpyNmsybklhNnZa?=
 =?utf-8?B?YUp6cmJTMkgxYzJqNlNmdGJvczFFNVhZTFF3ZXdrQk1Bd3RxRjF1anVCOVlC?=
 =?utf-8?B?S1ZEZC9KVy9XWGRQNDRxMk41OFRzMnZ3dThmYzlPd2dWRVM0WFFTVUFmcGtM?=
 =?utf-8?B?bzhVcCt2QkFoVUE1SVdDYkhiS3JYVC9pVkpOUXhpZUFDanVBNml4NXRCaVlw?=
 =?utf-8?B?N000emFvcHBKT2xrQWNqSDhSajYwTzV2eW01MzNVK3dOZ1BVWmpqZlpHT0tZ?=
 =?utf-8?B?aTM2RUVYdkdYTE5tSWxOQVo1NGZLc0VwQTFZczJGekV5blFSRHpJYlErTU9z?=
 =?utf-8?B?TThTSnFFSDRRMkJhSStzelFicGF1NUFLeHE5dUd4eWdLSnA4OVdsaGs5aGtz?=
 =?utf-8?B?WTdMcWdISytEb1JlRlZnOHNxVzR2N3JpeGpMQldNRHE1dy9XdlBMSEpyWjJ5?=
 =?utf-8?B?RWxaajQ0WERPbHVpbHNLVlF6TTJ2MURoRldzQ2R4YnZaWXR6YUZXMkNaRmV1?=
 =?utf-8?B?cklBd3ZNRVYxVk5ERlNUSjcwM0swV3ZVTUhhWU9mcHdhY2NGaVloOWtMVUFz?=
 =?utf-8?B?WEc3S3NRREtZVTVBUUN6ZnI2VEFucVZQS0pURW9LOGdrenVETmhwNFNXdEdZ?=
 =?utf-8?B?WWM3b3VlbllyNE4xUnhKeU53MFNyd1BKN0VsWlhSaFV2QitPd0JRdEd4RE9i?=
 =?utf-8?B?UUlJVXJnR21hT3FXeGpWMk1BWC83UndvcVJEa3hKYTdOM2l6Ym1hL2dla0hH?=
 =?utf-8?B?bDlmVGtEM21zdnNteE4xcjR3WGpYc2JZcHE0TmRnNFN5TmNDamNkNDFqc3Iz?=
 =?utf-8?Q?rkhfK7C8qIioV4WSrVaeHlmg9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a29f12d-5dc1-4a2a-4d05-08db3ab12c6d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 17:21:23.3526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sy/dDeGhDFYtypiFhujOPGcqBmk/j8pmYP51z82p8gKMiD9XU/lBiGh2RZK4zL8FRQZWv8AWwEJlHz0fGrCRnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5649
X-Spam-Status: No, score=-1.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/2023 3:05 PM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Tue, 4 Apr 2023 12:01:38 -0700
> Brett Creeley <brett.creeley@amd.com> wrote:
>> diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
>> new file mode 100644
>> index 000000000000..855f5da9b99a
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/lm.c
>> @@ -0,0 +1,479 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>> +
>> +#include <linux/anon_inodes.h>
>> +#include <linux/file.h>
>> +#include <linux/fs.h>
>> +#include <linux/highmem.h>
>> +#include <linux/vfio.h>
>> +#include <linux/vfio_pci_core.h>
>> +
>> +#include "vfio_dev.h"
>> +#include "cmds.h"
>> +
>> +#define PDS_VFIO_LM_FILENAME "pds_vfio_lm"
>> +
>> +const char *
>> +pds_vfio_lm_state(enum vfio_device_mig_state state)
>> +{
>> +     switch (state) {
>> +     case VFIO_DEVICE_STATE_ERROR:
>> +             return "VFIO_DEVICE_STATE_ERROR";
>> +     case VFIO_DEVICE_STATE_STOP:
>> +             return "VFIO_DEVICE_STATE_STOP";
>> +     case VFIO_DEVICE_STATE_RUNNING:
>> +             return "VFIO_DEVICE_STATE_RUNNING";
>> +     case VFIO_DEVICE_STATE_STOP_COPY:
>> +             return "VFIO_DEVICE_STATE_STOP_COPY";
>> +     case VFIO_DEVICE_STATE_RESUMING:
>> +             return "VFIO_DEVICE_STATE_RESUMING";
>> +     case VFIO_DEVICE_STATE_RUNNING_P2P:
>> +             return "VFIO_DEVICE_STATE_RUNNING_P2P";
>> +     default:
>> +             return "VFIO_DEVICE_STATE_INVALID";
>> +     }
>> +
>> +     return "VFIO_DEVICE_STATE_INVALID";
> 
> Seems a tad redundant.

I can remove this on the next revision. However, it is nice to be able 
to see the state transitions via enabling the dynamic debug statement in 
pds_vfio_step_device_state_locked(), but maybe this would make more 
sense in the layer above the device specific VFIO drivers?

> 
>> +}
>> +
> [snip]
>> +struct file *
>> +pds_vfio_step_device_state_locked(struct pds_vfio_pci_device *pds_vfio,
>> +                               enum vfio_device_mig_state next)
>> +{
>> +     enum vfio_device_mig_state cur = pds_vfio->state;
>> +     struct device *dev = &pds_vfio->pdev->dev;
>> +     int err = 0;
>> +
>> +     dev_dbg(dev, "%s => %s\n",
>> +             pds_vfio_lm_state(cur), pds_vfio_lm_state(next));
>> +
>> +     if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_STOP_COPY) {
>> +             /* Device is already stopped
>> +              * create save device data file & get device state from firmware
>> +              */
> 
> Standard multi-line comment style please, we're not under net/ here.

Will fix. Thanks.

> 
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
>> +     if (cur == VFIO_DEVICE_STATE_RUNNING && next == VFIO_DEVICE_STATE_RUNNING_P2P) {
>> +             pds_vfio_send_host_vf_lm_status_cmd(pds_vfio, PDS_LM_STA_IN_PROGRESS);
>> +             /* Device should be stopped
>> +              * no interrupts, dma or change in internal state
>> +              */
>> +             err = pds_vfio_suspend_device_cmd(pds_vfio);
>> +             if (err)
>> +                     return ERR_PTR(err);
>> +
>> +             return NULL;
>> +     }
> 
> The comment here, as well as the no-op transitions from STOP->P2P and
> P2P->STOP has me concerned whether a device in this suspend state
> really meets the definition of our P2P state.  The RUNNING_P2P state is
> a quiescent state where the device must accept access, including
> peer-to-peer DMA, but it cannot initiate DMA or interrupts.  Is that
> consistent with this suspend state?  Thanks,
> 
> Alex

Yeah, these comments are misleading. Our device in the suspend state 
does meet the definition of the P2P and STOP states based on how you 
described them here and how they are defined in the VFIO header file.

I will remove the comments here as they are redundant since the states 
align with the documentation.

Thanks,

Brett
> 
>> +
>> +     if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && next == VFIO_DEVICE_STATE_RUNNING) {
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
>> +
>> +     if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_RUNNING_P2P)
>> +             return NULL;
>> +
>> +     if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && next == VFIO_DEVICE_STATE_STOP)
>> +             return NULL;
>> +
>> +     return ERR_PTR(-EINVAL);
>> +}
> 
> --
> You received this message because you are subscribed to the Google Groups "Pensando Drivers" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to drivers+unsubscribe@pensando.io.
> To view this discussion on the web visit https://groups.google.com/a/pensando.io/d/msgid/drivers/20230410160538.35c1a5a6.alex.williamson%40redhat.com.
