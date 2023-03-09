Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BA86B18FF
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjCICFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjCICFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:05:24 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A7E99BF8
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 18:05:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EuobMjwHiiqyYHb/X2MHwAvv5RYnUUPqn93tAHWDThDR2zOscnCvsI1X998yu2ddYFwvnQ/pe9qMVo2i5zkC0UnHGCLqFdMNZQnGCrtD/xMBzw4NuvXWrsEzU30m9vsaylg7dbQeBHjK2TboqJXl/P1anp7okzCQtCflTfHScwoVP/hWrIDHHTXNX37xUxr+2aMNn+6mbVysAVti1LoK1JQqUOasOoZr+2JAIKYYzuWGEbHxvwlctbf1u+sEIaL70DHO46/dmiDI5B5S8VW2zRORJE8AFWSso+dqKiIYGajN0D3lSdsX1kYtIAikq4OMJKoRXs4JkYd8i03p4UFlxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+dkcsWLmDVL8EbjVHWeUgr0T2jdjvuiF+F84p0GAtS4=;
 b=LXuRJ9HUCGMIQDNTD1I4J++jZNWlrGfDaNmWoPwB+LkxoFEsEoJA0ccZ6atQFYNlQVg5Zzx5YLMKMz2V7nw4W6C4xbMvTlE7P5thItRH0zIW2z37iqZlT+zapFDLumPv/4/2sy81JUYWi0fM5DxrHvRaQLMU8lhj8gmkLj4nE4/eHBQcHZE9JJmSVwKE1gjNRd7u/3OPbmB94O7FA5BiWS1XbPCvDZXoaIILmYAbfg/7mXeda3RE/fg4I6tWzf15oPyR/nRa9XahQ7lsGpj93eaTjItmNIV7QBtHKwHgPvUNWfpR/2xnc4tYL2UAUdd2l4kyJ9DpHeZObdI/g0pqzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dkcsWLmDVL8EbjVHWeUgr0T2jdjvuiF+F84p0GAtS4=;
 b=WXKN53FUV68HHkdm+mA4H+Z8ijCZTqB2Vd5JQ5CV5e5JtSwJhxRsmiIMh0Tn9gg9EVI1RAWAjTrfSkj6fureTX8H/8Dsu1DIT5h+9Mk/nHaWnG4xCs2R9g6Ede52XmRfi6mq2SaLx+/3+6XVrqFY2NojPdajcTBu6p9TWctSmxI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH7PR12MB7794.namprd12.prod.outlook.com (2603:10b6:510:276::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:05:16 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%9]) with mapi id 15.20.6156.029; Thu, 9 Mar 2023
 02:05:16 +0000
Message-ID: <02b934ee-edd9-08f1-3571-5efe7687b546@amd.com>
Date:   Wed, 8 Mar 2023 18:05:13 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH RFC v4 net-next 02/13] pds_core: add devcmd device
 interfaces
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, leon@kernel.org
References: <20230308051310.12544-1-shannon.nelson@amd.com>
 <20230308051310.12544-3-shannon.nelson@amd.com> <ZAhXZFABVgsVBzfF@nanopsycho>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <ZAhXZFABVgsVBzfF@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2PR07CA0004.namprd07.prod.outlook.com
 (2603:10b6:a03:505::10) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH7PR12MB7794:EE_
X-MS-Office365-Filtering-Correlation-Id: 70a1f526-a817-429a-8f2b-08db2042ba1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JG4uJBoTT2xjielPXjRVoCV5EfE+cpI4XUK/dqTh+jhnRdP9hhET8zROiObEVNTM74Glsy5UAV8F//kSpjdpggCoO1tW+T/c4vyyhPIcyFnCMiFV+qCjHiKZbiEO1f6XbB9twUx9Bal9PRivEKt71FGoiWqEB/3PQplHWWNfTirF7+28lF7kcv7vhx4miizlnkQnsYL2Jv6vqHlEgP/TSoX31qqEbgLlnNSTfcgfKh7IyZs4+eclKoSEcFILIRA0UmsNJy2QaWtyD2wLEvo4kj0xZU9x3LioEv19xT9RQAfUh9abnj8VWUajxe8WOItd+fbjxJbBXk82n4Ujf0uZYA5Qowzya1oxE/A59gRx5xCnq+KmH6VFuKJWxf4NszfhNSr4/weSKUAX7wXbclE5QVQR4hmTyi1g4u7DYOKH/CLdzo9ffaXaOuUw0OrclDjlLXr18Y8dlOKe3g8DwgQ4/6Ichu6qQUZ4QFAv8K4om4cn+J6+Y2b4IXUhm/AZuyGKQN1KTfk3VVuiH50uMh6dFWyAK5nkF+g3B4OpeWufs/ia+blV1FPaRBoYxVAPSCR5tRoIPnmRQ+uUA/E63ky3OXA1nDJs6DSx0dKT87gHY3S02VrY/R91Vcbt36HYN/zK9/EqVHC3RZPXH1rZaqZt9gHyuEaqKTkMVWxkkB6EyPnoYBqxcVDwM/7zWngZQ0GK0f6Uo8STFt3Sin4n2oxf9daHJmf4TnskIoNQ+4hvKEg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199018)(36756003)(478600001)(6486002)(5660300002)(316002)(2906002)(44832011)(30864003)(66946007)(8676002)(66556008)(66476007)(4326008)(6916009)(8936002)(41300700001)(38100700002)(86362001)(31696002)(26005)(186003)(6666004)(2616005)(53546011)(6512007)(6506007)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGRaTFlCaDRqc2tsSHJGQ1FlbHEvZEROajFGOEJ0d2hkRVpuR0pSRldPRHoz?=
 =?utf-8?B?a0xyRGhaTHNNeXFFSmNka2gvZWNZNE03aEtCYVBzTG14QjdRSm1aK1VTU1l0?=
 =?utf-8?B?TmtyN2JudjJsdnZuOVVkUk80c1V4QVZOU044YlMveGtxYUtiTDMzK25YbDZL?=
 =?utf-8?B?UmpLZVBaVjE5QnJGQ3MzYWJjWkdqUWdFNUJsQ3FmblZLUG55M3V5YWkydGlN?=
 =?utf-8?B?TjhncXFqWWRyYnBNV0ROZXZVWGtLZDlTVllwb3VXNDUvVFZNOXZES2Y3MlRE?=
 =?utf-8?B?MUFjVzNGN0ZvckNQU2JQNU5PMVM0cklqUkFHbkM2SEF6RTNYTk9rSTRuVmJI?=
 =?utf-8?B?dFpJdklUVWhSeVZETEV3SnVzK1k2NVRjUUhaNVRnT3Qwc2lzalJNZEU4Zzc3?=
 =?utf-8?B?NkZUcEVGTlVLUXY4Mzhmb085bUpCdmQ5eldISk4wRkJlVzByc3UxbExRU3g3?=
 =?utf-8?B?YTF1dnFDTXFMTDdOS2dNY1VEWlVVNFMxNGNkbThSaEp1WHVEcEx5R3R0cWdZ?=
 =?utf-8?B?bzRvLzEyU0txQkZJdTVDY01TbUpJK3k2VVYzb2dvdnlLcTgrMmg3L2NKVVRv?=
 =?utf-8?B?VVZHdXV0Y0R1YU8vNUtNUzVCYjFFUXBYaE1lREcraXdOSmE1THZTU0xRTFZu?=
 =?utf-8?B?V0twN3ZGc3BpZEIwajVwekZqcDZBeFVieG43Vm11ZC9UVmhHT0lLa2JKR2Nw?=
 =?utf-8?B?MmRBeFpLMnRCcjBueU80WkZuRTVtZEIvT1h2TTBzVHdpWnZQOHRRUG96L1Bi?=
 =?utf-8?B?N3RhbG1GSjg1L2NlbE1TMUZQZlA2R1hET3Bpd0hjdUdFczBONEoydGQ0VEZD?=
 =?utf-8?B?TzMzdDVzUlNPaXcvQWZoMDFyV0JiOXBEb1NMMHcvL1lZR09EMEhJUVNLbVlK?=
 =?utf-8?B?RXRnNFVmWCs3RElRN0s1Q2xOa1dvMzY2SVFTMjh3OGdXMGI3M09tRitva1Z4?=
 =?utf-8?B?OVZZSGxIY1ZnWW0yU1pHbzluWEdXYzRmeUVkTmRJa0lpZ3k1VzJzMzRiTVdm?=
 =?utf-8?B?TmVINXNOSmQwT0doTmJLNDdmdStPc0FsWG1ldmxTaUxSS1dpek94QlpEM2gy?=
 =?utf-8?B?L0JCRUtmSXpEMHBaS3M0Z1orblBhR0lJRU9QSHc4VVdSZkUxQW81MmhKb0g0?=
 =?utf-8?B?N3pwMEk1czdmRURIWUhYKzhBRjdwanZrU2NJTytUU21oVXdZUzByVUtidkZF?=
 =?utf-8?B?aTgwR01rVGlHOWxTZysxOWtsa3VnV092bkJYUU5VbFkzUDJQZjZtM2EyZ2pH?=
 =?utf-8?B?a2dJTHR1REptUXBlUEdTb2FIS2ZHaUUvZHlHVGQyUWpWd1pMUVl5NWRuUjNE?=
 =?utf-8?B?akVWbUxsKzZVT1dCS21vRGZNdEFzZGZ2R2daS01kYjRuREtheXVrcjVRVGpw?=
 =?utf-8?B?bEJsa09WTkt6SlZjNWtaUEFFeTZSeTlWcG9jTm0rUXlNTlA1SUk3YlVBRGRK?=
 =?utf-8?B?V2Z5OXFYaWhtM0F2a2ZNWlFVUXErckFvZURZT2tyQ1kwMnhIdlk3YUYzRDFM?=
 =?utf-8?B?QkVZUlkyeVJHWHVGbWdhZng4bUpTR3RpR0tueVorUktwWXptSHRoVktVcHlL?=
 =?utf-8?B?NFU1TVNZeGxYSk1nT0ZZeDFxL2VuMVh1WHVFclNnYThqYmQzUnk3dTJUclV5?=
 =?utf-8?B?Tm01aXlKVXNHNzd0VHB2c2ZuNkpka1FtbDkwVVJtdkVmV1ArVlpsRjhxZzFu?=
 =?utf-8?B?TTBMZEtnQVltTHV5ajhNMjlucjZieFFuRWk5UXZBY3h4L2tmZy9yVWg3dTNu?=
 =?utf-8?B?RDRCR2xHN0kyKzhKWTFuZzdJMUlMV1h4QUlqU2tkZlBpeW53MHBaMm92Mncy?=
 =?utf-8?B?aGtWaUJoYkRhWTV4Y3B0eVlOTVhObWpKWERxMHdZUjFEMXNKM3A3YTBWOWMy?=
 =?utf-8?B?b1VnaTR2RzZnYTVKTmtaZENXSDJLU0NCMHFJbWRBWnhEb0xsNmlwL3RPU2F4?=
 =?utf-8?B?V2JnZWh4OXhhcGNucWdxSWNFUWdxZHJtTHUxY3JIbTBKNDBVTEhCVnRMRmt6?=
 =?utf-8?B?Wnpra1JpVkNaNmFQVGF5MmtFcGVYWEtTVHVjWTF5T1k5Nmg4SkVsSFgxUUU3?=
 =?utf-8?B?QWVOZTZscXdSMHZDNi9ZNU1wVnpic0VvWUJaSnAxL1J0YkJSNTZhbDlBNXh2?=
 =?utf-8?Q?W+CPm2+v5yUTB84yk/6C5Nkl4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70a1f526-a817-429a-8f2b-08db2042ba1d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:05:16.7504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXvdLoNBF9eXnK2MEgMkZdJ4pFf2tej0TcPuTUsqPayIk+rA2ognH0xIyW6pNFVB3w8KwXqN9N3S53jzylHfiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7794
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/23 1:37 AM, Jiri Pirko wrote:
> Wed, Mar 08, 2023 at 06:12:59AM CET, shannon.nelson@amd.com wrote:
>> The devcmd interface is the basic connection to the device through the
>> PCI BAR for low level identification and command services.  This does
>> the early device initialization and finds the identity data, and adds
>> devcmd routines to be used by later driver bits.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>> drivers/net/ethernet/amd/pds_core/Makefile  |   4 +-
>> drivers/net/ethernet/amd/pds_core/core.c    |  36 ++
>> drivers/net/ethernet/amd/pds_core/debugfs.c |  67 ++++
>> drivers/net/ethernet/amd/pds_core/dev.c     | 350 ++++++++++++++++++++
>> drivers/net/ethernet/amd/pds_core/main.c    |  35 +-
>> include/linux/pds/pds_common.h              |  63 ++++
>> include/linux/pds/pds_core.h                |  52 +++
>> include/linux/pds/pds_intr.h                | 161 +++++++++
>> 8 files changed, 764 insertions(+), 4 deletions(-)
>> create mode 100644 drivers/net/ethernet/amd/pds_core/core.c
>> create mode 100644 drivers/net/ethernet/amd/pds_core/dev.c
>> create mode 100644 include/linux/pds/pds_intr.h
>>
>> diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
>> index b4cc4b242e44..eaca8557ba66 100644
>> --- a/drivers/net/ethernet/amd/pds_core/Makefile
>> +++ b/drivers/net/ethernet/amd/pds_core/Makefile
>> @@ -4,6 +4,8 @@
>> obj-$(CONFIG_PDS_CORE) := pds_core.o
>>
>> pds_core-y := main.o \
>> -            devlink.o
>> +            devlink.o \
>> +            dev.o \
>> +            core.o
>>
>> pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
>> diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
>> new file mode 100644
>> index 000000000000..88a6aa42cc28
>> --- /dev/null
>> +++ b/drivers/net/ethernet/amd/pds_core/core.c
>> @@ -0,0 +1,36 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
>> +
>> +#include <linux/pds/pds_core.h>
>> +
>> +int pdsc_setup(struct pdsc *pdsc, bool init)
>> +{
>> +      int err = 0;
>> +
>> +      if (init)
>> +              err = pdsc_dev_init(pdsc);
>> +      else
>> +              err = pdsc_dev_reinit(pdsc);
>> +      if (err)
>> +              return err;
>> +
>> +      clear_bit(PDSC_S_FW_DEAD, &pdsc->state);
>> +      return 0;
>> +}
>> +
>> +void pdsc_teardown(struct pdsc *pdsc, bool removing)
>> +{
>> +      pdsc_devcmd_reset(pdsc);
>> +
>> +      if (removing) {
>> +              kfree(pdsc->intr_info);
>> +              pdsc->intr_info = NULL;
>> +      }
>> +
>> +      if (pdsc->kern_dbpage) {
>> +              iounmap(pdsc->kern_dbpage);
>> +              pdsc->kern_dbpage = NULL;
>> +      }
>> +
>> +      set_bit(PDSC_S_FW_DEAD, &pdsc->state);
>> +}
>> diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
>> index c5cf01ca7853..75376c9f77cf 100644
>> --- a/drivers/net/ethernet/amd/pds_core/debugfs.c
>> +++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
>> @@ -44,4 +44,71 @@ void pdsc_debugfs_del_dev(struct pdsc *pdsc)
>>        debugfs_remove_recursive(pdsc->dentry);
>>        pdsc->dentry = NULL;
>> }
>> +
>> +static int identity_show(struct seq_file *seq, void *v)
>> +{
>> +      struct pdsc *pdsc = seq->private;
>> +      struct pds_core_dev_identity *ident;
>> +      int vt;
>> +
>> +      ident = &pdsc->dev_ident;
>> +
>> +      seq_printf(seq, "asic_type:        0x%x\n", pdsc->dev_info.asic_type);
>> +      seq_printf(seq, "asic_rev:         0x%x\n", pdsc->dev_info.asic_rev);
>> +      seq_printf(seq, "serial_num:       %s\n", pdsc->dev_info.serial_num);
>> +      seq_printf(seq, "fw_version:       %s\n", pdsc->dev_info.fw_version);
> 
> What is the exact reason of exposing this here and not trought well
> defined devlink info interface?

These do show up in devlink dev info eventually, but that isn't for 
another couple of patches.  This gives us info here for debugging the 
earlier patches if needed.

> 
> 
>> +      seq_printf(seq, "fw_status:        0x%x\n",
>> +                 ioread8(&pdsc->info_regs->fw_status));
>> +      seq_printf(seq, "fw_heartbeat:     0x%x\n",
>> +                 ioread32(&pdsc->info_regs->fw_heartbeat));
>> +
>> +      seq_printf(seq, "nlifs:            %d\n", le32_to_cpu(ident->nlifs));
>> +      seq_printf(seq, "nintrs:           %d\n", le32_to_cpu(ident->nintrs));
>> +      seq_printf(seq, "ndbpgs_per_lif:   %d\n", le32_to_cpu(ident->ndbpgs_per_lif));
>> +      seq_printf(seq, "intr_coal_mult:   %d\n", le32_to_cpu(ident->intr_coal_mult));
>> +      seq_printf(seq, "intr_coal_div:    %d\n", le32_to_cpu(ident->intr_coal_div));
>> +
>> +      seq_puts(seq, "vif_types:        ");
>> +      for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++)
>> +              seq_printf(seq, "%d ", le16_to_cpu(pdsc->dev_ident.vif_types[vt]));
>> +      seq_puts(seq, "\n");
>> +
>> +      return 0;
>> +}
>> +DEFINE_SHOW_ATTRIBUTE(identity);
>> +
>> +void pdsc_debugfs_add_ident(struct pdsc *pdsc)
>> +{
>> +      debugfs_create_file("identity", 0400, pdsc->dentry, pdsc, &identity_fops);
>> +}
>> +
>> +static int irqs_show(struct seq_file *seq, void *v)
>> +{
>> +      struct pdsc *pdsc = seq->private;
>> +      struct pdsc_intr_info *intr_info;
>> +      int i;
>> +
>> +      seq_printf(seq, "index  vector  name (nintrs %d)\n", pdsc->nintrs);
>> +
>> +      if (!pdsc->intr_info)
>> +              return 0;
>> +
>> +      for (i = 0; i < pdsc->nintrs; i++) {
>> +              intr_info = &pdsc->intr_info[i];
>> +              if (!intr_info->vector)
>> +                      continue;
>> +
>> +              seq_printf(seq, "% 3d    % 3d     %s\n",
>> +                         i, intr_info->vector, intr_info->name);
>> +      }
>> +
>> +      return 0;
>> +}
>> +DEFINE_SHOW_ATTRIBUTE(irqs);
>> +
>> +void pdsc_debugfs_add_irqs(struct pdsc *pdsc)
>> +{
>> +      debugfs_create_file("irqs", 0400, pdsc->dentry, pdsc, &irqs_fops);
>> +}
>> +
>> #endif /* CONFIG_DEBUG_FS */
>> diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
>> new file mode 100644
>> index 000000000000..7a9db1505c1f
>> --- /dev/null
>> +++ b/drivers/net/ethernet/amd/pds_core/dev.c
>> @@ -0,0 +1,350 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
>> +
>> +#include <linux/version.h>
>> +#include <linux/errno.h>
>> +#include <linux/pci.h>
>> +#include <linux/utsname.h>
>> +
>> +#include <linux/pds/pds_core.h>
>> +
>> +int pdsc_err_to_errno(enum pds_core_status_code code)
>> +{
>> +      switch (code) {
>> +      case PDS_RC_SUCCESS:
>> +              return 0;
>> +      case PDS_RC_EVERSION:
>> +      case PDS_RC_EQTYPE:
>> +      case PDS_RC_EQID:
>> +      case PDS_RC_EINVAL:
>> +      case PDS_RC_ENOSUPP:
>> +              return -EINVAL;
>> +      case PDS_RC_EPERM:
>> +              return -EPERM;
>> +      case PDS_RC_ENOENT:
>> +              return -ENOENT;
>> +      case PDS_RC_EAGAIN:
>> +              return -EAGAIN;
>> +      case PDS_RC_ENOMEM:
>> +              return -ENOMEM;
>> +      case PDS_RC_EFAULT:
>> +              return -EFAULT;
>> +      case PDS_RC_EBUSY:
>> +              return -EBUSY;
>> +      case PDS_RC_EEXIST:
>> +              return -EEXIST;
>> +      case PDS_RC_EVFID:
>> +              return -ENODEV;
>> +      case PDS_RC_ECLIENT:
>> +              return -ECHILD;
>> +      case PDS_RC_ENOSPC:
>> +              return -ENOSPC;
>> +      case PDS_RC_ERANGE:
>> +              return -ERANGE;
>> +      case PDS_RC_BAD_ADDR:
>> +              return -EFAULT;
>> +      case PDS_RC_EOPCODE:
>> +      case PDS_RC_EINTR:
>> +      case PDS_RC_DEV_CMD:
>> +      case PDS_RC_ERROR:
>> +      case PDS_RC_ERDMA:
>> +      case PDS_RC_EIO:
>> +      default:
>> +              return -EIO;
>> +      }
>> +}
>> +
>> +bool pdsc_is_fw_running(struct pdsc *pdsc)
>> +{
>> +      pdsc->fw_status = ioread8(&pdsc->info_regs->fw_status);
>> +      pdsc->last_fw_time = jiffies;
>> +      pdsc->last_hb = ioread32(&pdsc->info_regs->fw_heartbeat);
>> +
>> +      /* Firmware is useful only if the running bit is set and
>> +       * fw_status != 0xff (bad PCI read)
>> +       */
>> +      return (pdsc->fw_status != 0xff) &&
>> +              (pdsc->fw_status & PDS_CORE_FW_STS_F_RUNNING);
>> +}
>> +
>> +bool pdsc_is_fw_good(struct pdsc *pdsc)
>> +{
>> +      return pdsc_is_fw_running(pdsc) &&
>> +              (pdsc->fw_status & PDS_CORE_FW_STS_F_GENERATION) == pdsc->fw_generation;
>> +}
>> +
>> +static u8 pdsc_devcmd_status(struct pdsc *pdsc)
>> +{
>> +      return ioread8(&pdsc->cmd_regs->comp.status);
>> +}
>> +
>> +static bool pdsc_devcmd_done(struct pdsc *pdsc)
>> +{
>> +      return ioread32(&pdsc->cmd_regs->done) & PDS_CORE_DEV_CMD_DONE;
>> +}
>> +
>> +static void pdsc_devcmd_dbell(struct pdsc *pdsc)
>> +{
>> +      iowrite32(0, &pdsc->cmd_regs->done);
>> +      iowrite32(1, &pdsc->cmd_regs->doorbell);
>> +}
>> +
>> +static void pdsc_devcmd_clean(struct pdsc *pdsc)
>> +{
>> +      iowrite32(0, &pdsc->cmd_regs->doorbell);
>> +      memset_io(&pdsc->cmd_regs->cmd, 0, sizeof(pdsc->cmd_regs->cmd));
>> +}
>> +
>> +static const char *pdsc_devcmd_str(int opcode)
>> +{
>> +      switch (opcode) {
>> +      case PDS_CORE_CMD_NOP:
>> +              return "PDS_CORE_CMD_NOP";
>> +      case PDS_CORE_CMD_IDENTIFY:
>> +              return "PDS_CORE_CMD_IDENTIFY";
>> +      case PDS_CORE_CMD_RESET:
>> +              return "PDS_CORE_CMD_RESET";
>> +      case PDS_CORE_CMD_INIT:
>> +              return "PDS_CORE_CMD_INIT";
>> +      case PDS_CORE_CMD_FW_DOWNLOAD:
>> +              return "PDS_CORE_CMD_FW_DOWNLOAD";
>> +      case PDS_CORE_CMD_FW_CONTROL:
>> +              return "PDS_CORE_CMD_FW_CONTROL";
>> +      default:
>> +              return "PDS_CORE_CMD_UNKNOWN";
>> +      }
>> +}
>> +
>> +static int pdsc_devcmd_wait(struct pdsc *pdsc, int max_seconds)
>> +{
>> +      struct device *dev = pdsc->dev;
>> +      unsigned long start_time;
>> +      unsigned long max_wait;
>> +      unsigned long duration;
>> +      int timeout = 0;
>> +      int status = 0;
>> +      int done = 0;
>> +      int err = 0;
>> +      int opcode;
>> +
>> +      opcode = ioread8(&pdsc->cmd_regs->cmd.opcode);
>> +
>> +      start_time = jiffies;
>> +      max_wait = start_time + (max_seconds * HZ);
>> +
>> +      while (!done && !timeout) {
>> +              done = pdsc_devcmd_done(pdsc);
>> +              if (done)
>> +                      break;
>> +
>> +              timeout = time_after(jiffies, max_wait);
>> +              if (timeout)
>> +                      break;
>> +
>> +              usleep_range(100, 200);
>> +      }
>> +      duration = jiffies - start_time;
>> +
>> +      if (done && duration > HZ)
>> +              dev_dbg(dev, "DEVCMD %d %s after %ld secs\n",
>> +                      opcode, pdsc_devcmd_str(opcode), duration / HZ);
>> +
>> +      if (!done || timeout) {
>> +              dev_err(dev, "DEVCMD %d %s timeout, done %d timeout %d max_seconds=%d\n",
>> +                      opcode, pdsc_devcmd_str(opcode), done, timeout,
>> +                      max_seconds);
>> +              err = -ETIMEDOUT;
>> +              pdsc_devcmd_clean(pdsc);
>> +      }
>> +
>> +      status = pdsc_devcmd_status(pdsc);
>> +      err = pdsc_err_to_errno(status);
>> +      if (status != PDS_RC_SUCCESS && status != PDS_RC_EAGAIN)
>> +              dev_err(dev, "DEVCMD %d %s failed, status=%d err %d %pe\n",
>> +                      opcode, pdsc_devcmd_str(opcode), status, err,
>> +                      ERR_PTR(err));
>> +
>> +      return err;
>> +}
>> +
>> +int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
>> +                     union pds_core_dev_comp *comp, int max_seconds)
>> +{
>> +      int err;
>> +
>> +      memcpy_toio(&pdsc->cmd_regs->cmd, cmd, sizeof(*cmd));
>> +      pdsc_devcmd_dbell(pdsc);
>> +      err = pdsc_devcmd_wait(pdsc, max_seconds);
>> +      memcpy_fromio(comp, &pdsc->cmd_regs->comp, sizeof(*comp));
>> +
>> +      return err;
>> +}
>> +
>> +int pdsc_devcmd(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
>> +              union pds_core_dev_comp *comp, int max_seconds)
>> +{
>> +      int err;
>> +
>> +      mutex_lock(&pdsc->devcmd_lock);
>> +      err = pdsc_devcmd_locked(pdsc, cmd, comp, max_seconds);
>> +      mutex_unlock(&pdsc->devcmd_lock);
>> +
>> +      return err;
>> +}
>> +
>> +int pdsc_devcmd_init(struct pdsc *pdsc)
>> +{
>> +      union pds_core_dev_comp comp = { 0 };
>> +      union pds_core_dev_cmd cmd = {
>> +              .opcode = PDS_CORE_CMD_INIT,
>> +      };
>> +
>> +      return pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
>> +}
>> +
>> +int pdsc_devcmd_reset(struct pdsc *pdsc)
>> +{
>> +      union pds_core_dev_comp comp = { 0 };
>> +      union pds_core_dev_cmd cmd = {
>> +              .reset.opcode = PDS_CORE_CMD_RESET,
>> +      };
>> +
>> +      return pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
>> +}
>> +
>> +static int pdsc_devcmd_identify_locked(struct pdsc *pdsc)
>> +{
>> +      union pds_core_dev_comp comp = { 0 };
>> +      union pds_core_dev_cmd cmd = {
>> +              .identify.opcode = PDS_CORE_CMD_IDENTIFY,
>> +              .identify.ver = PDS_CORE_IDENTITY_VERSION_1,
>> +      };
>> +
>> +      return pdsc_devcmd_locked(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
>> +}
>> +
>> +static void pdsc_init_devinfo(struct pdsc *pdsc)
>> +{
>> +      pdsc->dev_info.asic_type = ioread8(&pdsc->info_regs->asic_type);
>> +      pdsc->dev_info.asic_rev = ioread8(&pdsc->info_regs->asic_rev);
>> +      pdsc->fw_generation = PDS_CORE_FW_STS_F_GENERATION &
>> +                            ioread8(&pdsc->info_regs->fw_status);
>> +
>> +      memcpy_fromio(pdsc->dev_info.fw_version,
>> +                    pdsc->info_regs->fw_version,
>> +                    PDS_CORE_DEVINFO_FWVERS_BUFLEN);
>> +      pdsc->dev_info.fw_version[PDS_CORE_DEVINFO_FWVERS_BUFLEN] = 0;
>> +
>> +      memcpy_fromio(pdsc->dev_info.serial_num,
>> +                    pdsc->info_regs->serial_num,
>> +                    PDS_CORE_DEVINFO_SERIAL_BUFLEN);
>> +      pdsc->dev_info.serial_num[PDS_CORE_DEVINFO_SERIAL_BUFLEN] = 0;
>> +
>> +      dev_dbg(pdsc->dev, "fw_version %s\n", pdsc->dev_info.fw_version);
>> +}
>> +
>> +static int pdsc_identify(struct pdsc *pdsc)
>> +{
>> +      struct pds_core_drv_identity drv = { 0 };
>> +      size_t sz;
>> +      int err;
>> +
>> +      drv.drv_type = cpu_to_le32(PDS_DRIVER_LINUX);
>> +      drv.kernel_ver = cpu_to_le32(LINUX_VERSION_CODE);
>> +      snprintf(drv.kernel_ver_str, sizeof(drv.kernel_ver_str),
>> +               "%s %s", utsname()->release, utsname()->version);
>> +      snprintf(drv.driver_ver_str, sizeof(drv.driver_ver_str),
>> +               "%s %s", PDS_CORE_DRV_NAME, utsname()->release);
> 
> Why exactly are you doing this? Looks very wrong.

This helps us when debugging on the DSC side - we can see which host 
driver is using the interface (PXE, Linux, etc).  This is modeled from 
what we have in our out-of-tree ionic driver interface, but I need to 
trim it down to be less snoopy.

sln
