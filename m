Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23D06DCAE3
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 20:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjDJSla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 14:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjDJSl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 14:41:29 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204B2E63
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 11:41:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bO8ErRzaXpdNqKY8l6e4FA7d7MQmJPPsM2IKnPVncgkgaZQ7neJ3ccj7JNCMDTlaODkVlJWQFJBMAnxXV1ZhSwcO0hrbMHM/ZN1pOYZD8r74o680JctBuqmsQt+kuOQpVl7N/Jgf4t00ahrrUl02P+UGeQcwsYzLeuEeu6noW32JXdgRnLNy9psdtwqLkcBd1QFn+WJpTSuFRoPuc3LbHcAuw9STznP9D5O9C6H2oAbWi7nNqpe2709iuP3aax4ChMTO6Af4303dPskTTIfrkshFQpH+pJv/W4zn8ZQ0OWN3oKx/xiQcazbm5uAM50F/pdIunkcfbVb7mmIlUU7THA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Br2FR0Jj53YZQZfRNOCAus9nqbXg38tPBQMFxJZvybQ=;
 b=HS0TC1lxFCtl/4Slw02Swf1nCHRyx0rzYFhQ6L2vlMHKGlGAo6WDphp5qNMPmPKRH6Atu/gkx/WiTeGrzHPB/5205WEh9zEhqB9X0C0MAHXMjwk9UEPEeHKhTgZHUQZvckDrnfsLKjb0gecTS4WDz7Wx/lCG5YeQQysclQedn2DJgoftzbdgDsyEZXxvHjC+CM+BR0xwkPPdWd3wMUDir8Cv5aQwe2lPRUMhQrMFi8xeFdnPC7EqP2Kuu3fYW1foEzaM7lY5DHkQMRpwu8NCzqPVyn/hCEqRW+odYdBFRGxxRidBqp20422v3+jRhkABgRWtm4EbU6pUhawFUlrZ0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Br2FR0Jj53YZQZfRNOCAus9nqbXg38tPBQMFxJZvybQ=;
 b=hRfL2lo/yo4irL4yEgE8qC1ExXiR6h3cvzL8eLsaQyWqZWfjUKflr5ZBQ5nmcg3ONQmN0Mj3OwgFXikjEst5TjrPwdpQgdT4k1JpfV7Db4T1h/Gc3ciFeF+zexxJyp6VES53EVwUu/E9bTfkHx35XnbuRtzyaF691GdIvHAoL9c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SN7PR12MB8435.namprd12.prod.outlook.com (2603:10b6:806:2e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 18:41:25 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 18:41:25 +0000
Message-ID: <d2d0b09d-4c16-ccf6-2cc5-00f371db0c58@amd.com>
Date:   Mon, 10 Apr 2023 11:41:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v9 net-next 01/14] pds_core: initial framework for
 pds_core PF driver
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-2-shannon.nelson@amd.com>
 <20230409112645.GS14869@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230409112645.GS14869@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0083.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::24) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SN7PR12MB8435:EE_
X-MS-Office365-Filtering-Correlation-Id: e1d6c433-3ab3-4245-1df9-08db39f33053
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V8rcLhZAnnl8wmTaijqcUuKix71Ph1LNQmG+XVEHBfuvltuE+BO3TMm0n9rqij7FjcdjP5h7xON3T9lfh5gADGaNI/qKY8eUa6SEV25sCe4adUcW4ypfEn39QhDpt8SavMXY8uuP9hAzT+p67OYTaewCUQPnVgefdnWYXNCLI1ApO3UzLdW0ZFRYJlfkNlJAXUi9r9xt91Gx4bx6omyrmRvi9lRJ3lzbx7jf9KtYzBD+TvjjoRD1XDpg2k661ma8w0HpRbYdrFTTKk2pcm2ULSumPW46oKWVK+y8dLB42ji10+FMGFCImf/n/y1cfxwu8ucdTJ1tmOdmHzTDZzLFw601I1ohSQbdx0sI9+I75mjhWFeRdi7szJEUQYJm2bxnOUxapS9TUbDWYtZN0u938sb4cWpweUbdErozE6yhp+DOIrUtMQNJ5lMTWE5Xs+M8IXtyUxXKWZP118tCaemW4iPfP7ho6bR+oaf1locU8+F+zyDMCS0oeIbiftD9O0vvleXrRoHrqGOGFNXujhcpyroysXMd5yfpzqaPLzhc3ehxfhxtvtL3ZGTq4jeplUOLbkwKZdsX1+lPqiqtE+LN2IlakdIItet2rvneWL5Yq+quVKSamI6So2gul/WpNtxvMuKp2UUV8vKaKqTURj4qBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(451199021)(2616005)(478600001)(6512007)(26005)(6506007)(6666004)(6486002)(41300700001)(316002)(66476007)(66556008)(4326008)(6916009)(53546011)(186003)(66946007)(31686004)(38100700002)(2906002)(5660300002)(44832011)(36756003)(31696002)(86362001)(8936002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1hoZzZZRFR1SUsxcjRaZEJINTB0cnRtYVNUVHZ2UlI3eU9hcEFKbzhCRGd1?=
 =?utf-8?B?TXRyeGQwYXliamw0akFaR2pXMHloU0hiMEVzY3Juc0R5cE1qTS81bGtOVytw?=
 =?utf-8?B?Y3Q1NjJDanJLM1J2OHBGbFFWZzNKc3ZudGwwcXN0MnpSbm1Od3hFZFBhVmJJ?=
 =?utf-8?B?WGx6TVNZVVZwaDFnV0E4Zy9iejVnNUZSQlN2ZUJEaUJxaHNBUWVqSVBCeGRw?=
 =?utf-8?B?dS8wZTUvS0ZnTTdlNHZvUEpVSkZRZ080a0w2KzM3NjlFSWI3Rk1wak5kdm0z?=
 =?utf-8?B?eHNCY29FaHkvbVpiRDAwdFJxdDNYem9TZEorVllydFJwNXdRMUh0MmtMN3V1?=
 =?utf-8?B?UC9XdWVSZHE0ZTR6ak9LVEFZQTVGYVJqTmRrdDhCRENKWXhtZkhJOGlmZzlF?=
 =?utf-8?B?VGpVcGh0VzUzSm04TWhRcTJFb0FURk5BNW9JTEpLbkVYdHJ0M2Vxd1hZQzh1?=
 =?utf-8?B?ZUJXdWhxa1k3aXNzQWxaUnBURDhXdjFVNWpEZ0N3bE1RQnRsdXFiQUdqWG1M?=
 =?utf-8?B?UWFKZUJlVWhLVDlNLzJKRzFzV3lTdmViUjlDbzgzcVVXM09mV1gra3dDMm1m?=
 =?utf-8?B?VjdTcnBvbldyQzY4Q3Z1L1owanZLb0MvNUJ0ajFmVFJrb09CQXZ3bE95THE5?=
 =?utf-8?B?RFlwNmQxd0c0a0RhbWY4a0JqYUQ0MUdCekNJazdpZVNIZ2V2TkMwRjFHdDRl?=
 =?utf-8?B?N2l4WmdiV2hiYW5uRVNBU2VuaFl5bHBFbFBEelFtbU80cG5pNXhWSWZiU2Ix?=
 =?utf-8?B?R2FaaGdMZE05WE5CV2E5ZkNNRHNuOW5ScDVURmRnVmNtdkxmZmRPNTljeWRW?=
 =?utf-8?B?aHdUK0tZbXNIcDd6SHFIVStrYkpMaStpNldjeE5Oc29qOXNyd2FmY0Fuc3U1?=
 =?utf-8?B?K3BreS9wOFB4TjdQUDg1REdPZzQ2SUZnVEN5K2dhYTZUZ2RGbjVpeXA3RGNu?=
 =?utf-8?B?a0hKZjh6WFhEMEVVSStPaHp4ajIxSkVnVHR0dTBDcHVxVWMrMUliak40Mmdl?=
 =?utf-8?B?ZU1OTkc1aFVpTjRhdkVmZ29TTVJOMFZSTVVld3pPd1oveXVnb3ArOFpwcVFL?=
 =?utf-8?B?b1g3aG9TK3FHT0NLejErU2l4NHU4anIzK2tmOHhzeE1xaFA4MHhSZ3RNcmww?=
 =?utf-8?B?ZWxZd0NwRmpHaTk3UzA4VUZHdmxTdmpMNnh4WWFaQ1ZsQ2crQ29hME1YNUQv?=
 =?utf-8?B?ek5INzk3M2lNVTBncFRKcWVwSVY4ZFFGUFN6akVoSTlSQ1NpTXFUWm9HUFli?=
 =?utf-8?B?SHRzUG5ZUThXY2MwcE5rSkdLT3N0ZC9uTDY5WDRyenZUWUJ2WW9ISGJWRWd0?=
 =?utf-8?B?K3Y5RGhLaThWbmJ2WG8rUStFRlFwT21rTkhWNWlvMHM5R3ZUNXpRNDhkMnU2?=
 =?utf-8?B?eDhXOUxRS04vMFNSdnJXQzYrR2xwWmFzbGxqT1A4LzN0bzErUGhlMWFxaXYv?=
 =?utf-8?B?MTRrQnpaUG1NK25peHk0RXcvSVNEckhVWmM2WnlLZ1hMQ0syQ0c5V050clM2?=
 =?utf-8?B?WDFCalVBSkkvMm9DbTIwMXA4QUY2Y255RlpDY1RoTEQ3a1dtb3FrdzM1QTRz?=
 =?utf-8?B?RXk3SHJNK2lMQ3U0Sm1JSzcvUWJaQmR3SnZIRXVMSHUvdjgzVEpRUFNxY2pz?=
 =?utf-8?B?UW5kakxTZDQ2WDQ5ZWpnVzRZK21pVVlXWS9FcTJOa21uVktLaEtUdjVETlVF?=
 =?utf-8?B?VU9ja1FVNzZmRWwwZDlpU0MvUTdaSEJ5d3B1eVJXVWVuMHhjSjM0SmdaY0VU?=
 =?utf-8?B?eTdvbHdsbW9CaVpWV0xZaTFZMEgwdnBFQitCZ2xLTnJiZ013K1JQamJodVFQ?=
 =?utf-8?B?WVlqNjNuTThkZVlkaWFybmRqWVptYS85YmF5cHFlc043YkJnb205UUFOS0JN?=
 =?utf-8?B?U3hxS2dzK01YVWlJdnBYOVhYckpKNkY0K1ozVmhneTR3QmtlNXBCdk5SZjlz?=
 =?utf-8?B?bzRiNGdEcjMvVldaRkRFcjkvbnJwU1lXUk9wSGUraSsrMWFRU2pIM3ZXcjVT?=
 =?utf-8?B?STNyK3laUWI4ZjZHVTJVZ1Ara0tMMXIwNFVudGVackxreWpMb0pUSi9TbGdo?=
 =?utf-8?B?S1NRejQ1UUZ6VUs0T1dGMEhuRWVBL0lSTmNTOXRHbzdQK3J2ejlQa2ZuWUpQ?=
 =?utf-8?Q?KFpJRXRcRQyH8fr8lYAUjMeEc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1d6c433-3ab3-4245-1df9-08db39f33053
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 18:41:25.5789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gU5iI0d2jBJ7BVVyy3bXpguvGcGNl1N6DJPn3XDhtOsa+mOU8x+YNCI4teE9ytg6vbS60yowR1LUWkGmlYDkRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8435
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/23 4:26 AM, Leon Romanovsky wrote:
> 

Thanks for the time you put into these review notes, I appreciate it.

> On Thu, Apr 06, 2023 at 04:41:30PM -0700, Shannon Nelson wrote:
>> This is the initial PCI driver framework for the new pds_core device
>> driver and its family of devices.  This does the very basics of
>> registering for the new PF PCI device 1dd8:100c, setting up debugfs
>> entries, and registering with devlink.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   .../device_drivers/ethernet/amd/pds_core.rst  |  40 ++
>>   .../device_drivers/ethernet/index.rst         |   1 +
>>   drivers/net/ethernet/amd/pds_core/Makefile    |   8 +
>>   drivers/net/ethernet/amd/pds_core/core.h      |  63 ++
>>   drivers/net/ethernet/amd/pds_core/debugfs.c   |  34 ++
>>   drivers/net/ethernet/amd/pds_core/main.c      | 285 +++++++++
>>   include/linux/pds/pds_common.h                |  14 +
>>   include/linux/pds/pds_core_if.h               | 540 ++++++++++++++++++
>>   8 files changed, 985 insertions(+)
>>   create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
>>   create mode 100644 drivers/net/ethernet/amd/pds_core/Makefile
>>   create mode 100644 drivers/net/ethernet/amd/pds_core/core.h
>>   create mode 100644 drivers/net/ethernet/amd/pds_core/debugfs.c
>>   create mode 100644 drivers/net/ethernet/amd/pds_core/main.c
>>   create mode 100644 include/linux/pds/pds_common.h
>>   create mode 100644 include/linux/pds/pds_core_if.h
> 
> <...>
> 
>> +#ifdef CONFIG_DEBUG_FS
>> +void pdsc_debugfs_create(void);
>> +void pdsc_debugfs_destroy(void);
>> +void pdsc_debugfs_add_dev(struct pdsc *pdsc);
>> +void pdsc_debugfs_del_dev(struct pdsc *pdsc);
>> +#else
>> +static inline void pdsc_debugfs_create(void) { }
>> +static inline void pdsc_debugfs_destroy(void) { }
>> +static inline void pdsc_debugfs_add_dev(struct pdsc *pdsc) { }
>> +static inline void pdsc_debugfs_del_dev(struct pdsc *pdsc) { }
>> +#endif
> 
> I don't think that you need CONFIG_DEBUG_FS guard as debugfs code is
> built to handle this case, so you can call to internal debugfs_*() calls
> without completed initialization of debugfs.

Old habits... sure, we can pull that out.

> 
>> +
>> +#endif /* _PDSC_H_ */
>> diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
>> new file mode 100644
>> index 000000000000..9b2385c19c41
>> --- /dev/null
>> +++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
>> @@ -0,0 +1,34 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
>> +
>> +#ifdef CONFIG_DEBUG_FS
>> +
>> +#include <linux/pci.h>
>> +
>> +#include "core.h"
>> +
>> +static struct dentry *pdsc_dir;
>> +
>> +void pdsc_debugfs_create(void)
>> +{
>> +     pdsc_dir = debugfs_create_dir(PDS_CORE_DRV_NAME, NULL);
>> +}
>> +
>> +void pdsc_debugfs_destroy(void)
>> +{
>> +     debugfs_remove_recursive(pdsc_dir);
>> +}
>> +
>> +void pdsc_debugfs_add_dev(struct pdsc *pdsc)
>> +{
>> +     pdsc->dentry = debugfs_create_dir(pci_name(pdsc->pdev), pdsc_dir);
>> +
>> +     debugfs_create_ulong("state", 0400, pdsc->dentry, &pdsc->state);
>> +}
>> +
>> +void pdsc_debugfs_del_dev(struct pdsc *pdsc)
>> +{
>> +     debugfs_remove_recursive(pdsc->dentry);
>> +     pdsc->dentry = NULL;
>> +}
>> +#endif /* CONFIG_DEBUG_FS */
>> diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
>> new file mode 100644
>> index 000000000000..1c2f3fbaa27c
>> --- /dev/null
>> +++ b/drivers/net/ethernet/amd/pds_core/main.c
>> @@ -0,0 +1,285 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
>> +
>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> +
>> +#include <linux/pci.h>
>> +
>> +#include <linux/pds/pds_common.h>
>> +
>> +#include "core.h"
>> +
>> +MODULE_DESCRIPTION(PDSC_DRV_DESCRIPTION);
>> +MODULE_AUTHOR("Advanced Micro Devices, Inc");
>> +MODULE_LICENSE("GPL");
>> +
>> +/* Supported devices */
>> +static const struct pci_device_id pdsc_id_table[] = {
>> +     { PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_CORE_PF) },
>> +     { 0, }  /* end of table */
>> +};
>> +MODULE_DEVICE_TABLE(pci, pdsc_id_table);
>> +
>> +static void pdsc_unmap_bars(struct pdsc *pdsc)
>> +{
>> +     struct pdsc_dev_bar *bars = pdsc->bars;
>> +     unsigned int i;
>> +
>> +     for (i = 0; i < PDS_CORE_BARS_MAX; i++) {
>> +             if (bars[i].vaddr) {
>> +                     pci_iounmap(pdsc->pdev, bars[i].vaddr);
>> +                     bars[i].vaddr = NULL;
>> +             }
>> +
>> +             bars[i].len = 0;
>> +             bars[i].bus_addr = 0;
>> +             bars[i].res_index = 0;
> 
> Why are you clearing it? You are going to release bars[] anyway.
> It will be great to remove this zeroing pattern from whole driver
> as it hides use-after-free bugs.

These are from old habits of cleaning up when done with something.  Some 
of these kinds of zeroing are useful for checks later to see if 
something is still valid, but you are right, not all of it is really 
necessary.


> 
>> +     }
>> +}
>> +
>> +static int pdsc_map_bars(struct pdsc *pdsc)
>> +{
>> +     struct pdsc_dev_bar *bar = pdsc->bars;
>> +     struct pci_dev *pdev = pdsc->pdev;
>> +     struct device *dev = pdsc->dev;
>> +     struct pdsc_dev_bar *bars;
>> +     unsigned int i, j;
>> +     int num_bars = 0;
>> +     int err;
>> +     u32 sig;
>> +
>> +     bars = pdsc->bars;
>> +     num_bars = 0;
> 
> You set it to zero 4 lines above.

Will fix

> 
>> +
> 
> <...>
> 
>> +module_init(pdsc_init_module);
>> +module_exit(pdsc_cleanup_module);
>> diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
>> new file mode 100644
>> index 000000000000..bd041a5170a6
>> --- /dev/null
>> +++ b/include/linux/pds/pds_common.h
>> @@ -0,0 +1,14 @@
>> +/* SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB) OR BSD-2-Clause */
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>> +
>> +#ifndef _PDS_COMMON_H_
>> +#define _PDS_COMMON_H_
>> +
>> +#define PDS_CORE_DRV_NAME                    "pds_core"
> 
> It is KBUILD_MODNAME.

yep, will fix

> 
>> +
>> +/* the device's internal addressing uses up to 52 bits */
>> +#define PDS_CORE_ADDR_LEN    52
>> +#define PDS_CORE_ADDR_MASK   (BIT_ULL(PDS_ADDR_LEN) - 1)
>> +#define PDS_PAGE_SIZE                4096
> 
> Thanks
