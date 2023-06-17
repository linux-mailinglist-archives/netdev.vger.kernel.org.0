Return-Path: <netdev+bounces-11670-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26663733E0C
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:45:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 652CA281928
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 04:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28348137F;
	Sat, 17 Jun 2023 04:45:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159D67F5
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 04:45:25 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6203B2D6A;
	Fri, 16 Jun 2023 21:45:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fd0GAZ5D1IrzhJ/O7N+WM/aI1nTlRmC38+MyQ5U28A4QBxMX7MllcwWE7C8BS7lxPYlD67cqNFUinl91UoLgQoC8PsOvPPeY2G05bFQ6/Ovf/t0WwCK3CaTgF8Leh7Mrd+T+YBSbP1dvSRJ6tbp7YlZKoPGBmg2W7TT6GnG2QcARoqbP6dQ6qdfcbI/G/WkzR5QeXTgL9P2yI1S0/r8CWzZduTYpJr9Ubm8QNRo05HSVmIGic8S5p5gM4lgTpc9ix2SXq2ct/Tv5HYtHr/DiJHQUWs0V9aXfnCLf8ioNU0jDO0xRWaheDfY4l59Zue8A6cIRiWXQRWAfhAGV65iaaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6eQCW8WNh1+2BW++fiV+WPipyuXVsAhjL+UQ9ZXD+M8=;
 b=iTbDXZm8KV4yfXqLfoIl11vllxZpF6kLww2AijJpfUomI32pvgNR6ZQLdtMO9EWAHuNEkR8GLQQ6hVhy07OxgReoMH8xbTicLSidM9xd1Not2kHc+xXnBoarzBs2PeWSooBPMUzU9IW4Mo1xaIhy4YI6lR5ici9+e8YbMOOgyscwUQ3ScS53eBqn7RazR1WVrdGk874xLS5X7MdKSgNz6c6SKEY1MiA9pxdVMdPZZIt2SlEFC/X1EvP19orZYrBqieYzO4XM8RoEZJohgKZGQzdasWHK2PbBPy/hzQErWmMVX/pj5jx3xYrFm/tj5n5+BAZ9a42KQjz3t6INpcNauA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6eQCW8WNh1+2BW++fiV+WPipyuXVsAhjL+UQ9ZXD+M8=;
 b=zaBksCrq8kfm8pZ0piz3o/4px/SOgmLvd5fqNTQ/m4sJM3BX4e/t/euHjModp5JPvVb6IUCrgV5WUVynXlJFkM+98DU2C9HQiC427Fs824aBfH/a2h297RDkZCDeFFAS44NZZfH38kPbVLSe6l7UvvaW5lZ/2xtpac1lBsAiQlg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DS7PR12MB6286.namprd12.prod.outlook.com (2603:10b6:8:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Sat, 17 Jun
 2023 04:45:21 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e%3]) with mapi id 15.20.6477.037; Sat, 17 Jun 2023
 04:45:20 +0000
Message-ID: <f1d31c66-4914-b5a4-4092-5e7a3f74ee76@amd.com>
Date: Fri, 16 Jun 2023 21:45:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Content-Language: en-US
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
 <20230602220318.15323-5-brett.creeley@amd.com>
 <BN9PR11MB5276511543775B852AD1C5A88C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BN9PR11MB5276511543775B852AD1C5A88C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0130.namprd04.prod.outlook.com
 (2603:10b6:303:84::15) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DS7PR12MB6286:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b780fc9-8303-47ad-856c-08db6eeda7b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	q0n0V2SK4OJkS8Chb3NwCMLD2F4C4W9Zlf8D2PcJj00nsFDujzISXDXc/wSQRr6ZLEz69YH+xvB/9lC9m7whwiBa5UGMU69ujGFZHdyWTHLAOlBxgzbO3ZC1P+WYwgFqr+/2iM0feqIwHhoUPu+Xo6FCO7xXU8LqpvtXX2XwKikTaB1XltN6jddp8NnSMEAg4qMQUqyxTK8uEkp++MzPhNluivBOKo8lyVwbQhH7wpsc7xTx9nPaF7nQ/P3IJ3qFiBvpyb24StbI7EeEOVfhny3Xidtmp35hQAcpBAMlbQGLxET/qdq2fWb5j4e9GEeQPRs4c/cjvoPZaQ0znpj2uCPrUtaEb6uAp+h0rsnuCTlu/i8EDwMCHuSbDdIl9ydKrfTYj7mbBH2SbNDROQdizk2eSKvknbuwJv/95m6lRorATwutj4uJl4vzc0xymKTEl5sgND8ujAsPf8Ggkjpn9aJBto6hEmrt72LRK2mPCg/0kGwrWIWi5VwnHHz5PyMVh8NMx4HW7983wnBL7ZPN+6E4Zqh5mGKrVMLqNcAfUwRo4DANTGDLeBX1+gydJGnhFCatwU+qGSGYwg0UZ4HsZXHVz9EVnSR/ADp6FtshsCTjo5adwnmke+XQe+PfVhCtfbhJElG5Wk/M4Ua1wa9PFA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199021)(5660300002)(31686004)(6666004)(2906002)(41300700001)(8936002)(66899021)(8676002)(4326008)(66946007)(66476007)(66556008)(316002)(36756003)(110136005)(6486002)(478600001)(2616005)(53546011)(31696002)(38100700002)(6506007)(186003)(83380400001)(26005)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NytyQUJTamZXNjIrVEJMRjRVdjRzWU9XM3AvalNTeEd2dnlvT3E2TS9HQWox?=
 =?utf-8?B?UEU5WVVzUUhCUDdJcVJGRFNCQzJFUHh6TjBtS1lLaElQN2ZNeFhxbXVLUUQv?=
 =?utf-8?B?akN4Yk1HR2VxalFrUmJIUWdGNkVXTmcwak5ja1NncVdHTE84QThldDdVWngz?=
 =?utf-8?B?cUc1Tis3aVlXdmUzcUwvelFtaUpWaTVFa2I4RkhkM0JrU3JSTmN3N3hSQWtZ?=
 =?utf-8?B?OHI4QTQ3d0JYdXZUSlN0QW9iaisraDJSWDJhSDFuWVQvY290aHBEeTFnUU10?=
 =?utf-8?B?cmtSZ3JDSzB6eXd0SnBFUlpwVnZLTzdqdTV0R1RhNUNWTTNaajFlL3R0eG9V?=
 =?utf-8?B?RFpaZEUya3dVZ3NwU0ZEYUVYeWRyTmp1c1FMeEZnODB4RVoxWmJsMWtoUjJs?=
 =?utf-8?B?ZEFRZDZSQWFXY2V0VEtGWUsvRjlCZWplWEFWMGxWNWlsNjV3b2dhbm5pQ01k?=
 =?utf-8?B?cmtKY1h6elpWOHhFMUZXdGx0U2VUakw3dFR1QUphdmxmeVdtckhWZUk0cDdI?=
 =?utf-8?B?MkRJYW0xRWlQazF6TktWWkhzeFdjWCtNOWtuZmNKbkZPSGZUekVja2JvV2lu?=
 =?utf-8?B?dHhHLzhGM0pia2IrS3d4MzhrNGFWbnBWTjhxUnR1c05VNnl2OTU5aExMV202?=
 =?utf-8?B?RC94aHYyK2JuNEVNWGxub0dscWdZNmlTRW8vbmpQLzlyT3o5Wi9hQThabzRY?=
 =?utf-8?B?VVphbWtkcDhzN0hQdVBrSnRNYTdia0NXaVByWEp4aUdyZkJMeWd1eWRHcVAv?=
 =?utf-8?B?NEU2ZnFjT2xUNGtuaHUySURUTWh4dWNCbmZzVjk0QXg5WHV2MXVkLzRzQm0w?=
 =?utf-8?B?aHpJa0JoaG9WNEtKek1NbkZHek1tYWt4QlkyZEdrZXJGa1RuTTBCdnBOdnEv?=
 =?utf-8?B?V1E4SmMxUTBFd09EeWpFVGRMYndHWUVONG9QZ0hwNXJlK1NhVmNWL2NJYlM5?=
 =?utf-8?B?bXlYQUJsRDdxSW5Bb3NiaTNnaWRQTzZjRVUyaTIyY2NkWktXaGRjTXZiRWdz?=
 =?utf-8?B?dlU1UG1PTUFCNEVjSW5EYnlZNUFWU1hWRzNpUHk2bEx4RU9NRWsvMGNDZzA0?=
 =?utf-8?B?UmhlbHlwb1ZvS3lRYWFMQzQxdFIvZTNmVjMzQWhkWk9KZTBrOG5RWjlMT0h3?=
 =?utf-8?B?K2hmbXloTG5VS2g4TWNlL09hTUkwWWpnMlBubGVOcE5oNVdaTERBWlBBMTJq?=
 =?utf-8?B?K0V0TkxXV01RZTJHc2c2RWtmS0pXSUlzMGR6Vk82TlNrK3RjSkpQaFJxMXJI?=
 =?utf-8?B?eFFEb2JDaHM0WkxTVytsZ0xoMFJiZThrTlVDZ3hYSVVNRU9kcEZBcUJoNTF0?=
 =?utf-8?B?VGZzODFySFhsNFNwUWJlMG1mS3dTZEx0elhmMEFkNFNTVHNJL2hwNU45QWwy?=
 =?utf-8?B?YTh6M0xVMThrR0REbG1SalNzK1FFZXFlTHpqbXFEdENJL3BnOUhkN04yRk9s?=
 =?utf-8?B?YUt5Vk0vM21GL2lkTzEwTlpIU2VSeFRmeENnTHp1TTA1U0w0aVVyamwwT0Uz?=
 =?utf-8?B?ZWpUUnZaS3NVQUROM0JNQWpoQkVhTEZlandabnRLaU5RUTExYkNQa3ZKWVNI?=
 =?utf-8?B?OUxaQWxsWVBpbHZIOWppanBNVnBEa1FuNHFES0UreGxRY1NUbWRWVnBibXFY?=
 =?utf-8?B?RGRGYXRDVm5hVDd0STB5REtxUG90S1pBd1ZBbWNjcTd3Vm1zWXFJNVFBMW1n?=
 =?utf-8?B?djVzTCtDcmh5alV6SVBnQnNhbC9xOEZRSU5xdlRLakVXU3VlYVZFM1dKZ2tI?=
 =?utf-8?B?dlFpOHhGaENmSVdTeEF0NEtFSUYrdGZiSXpDNXBXNkhQd1hGcnVCN1ZTYk41?=
 =?utf-8?B?TFdrZ25pV2dWUUl6cnZUcWw4dlJTN25JT0NMdWZGbmZUeEdRQ1RBZ1pTb2Vt?=
 =?utf-8?B?cXFQc0ZrUDB6ZjhOaVU5UlQvcVdrQ3pBSmhlZmRLSmVKb3Blckp0dXM5eDFN?=
 =?utf-8?B?M2lqdlB3QVpCcW9xUyswM0lhZVhqeEVzQXBZZzgyQTVyNVhYOUNRdm9rbnBS?=
 =?utf-8?B?T01SOWpvcHZOZ1JBcllxVTl5WXo4blhxbW1TRlpUVk9BcFpYR3JWZC9hSFh0?=
 =?utf-8?B?RHZUZnRicFVkTnl5QWhudTdwSHN4K285Nk9VRTR3R1RGVjZTTS9OOW1rYm41?=
 =?utf-8?Q?ghBUzjqMwK2m7wwB/nYnL9xJK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b780fc9-8303-47ad-856c-08db6eeda7b4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2023 04:45:20.5577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EJ07EYGrbQM+pJdWDVPFiC06IBt+BV++zmEGY2KIL3B3cH69e/c1ug19gKcGM6Mn8ZyXZsoDRaOlwGR6PJWcEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6286
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/16/2023 1:06 AM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Brett Creeley <brett.creeley@amd.com>
>> Sent: Saturday, June 3, 2023 6:03 AM
>>
>> Add live migration support via the VFIO subsystem. The migration
>> implementation aligns with the definition from uapi/vfio.h and uses
>> the pds_core PF's adminq for device configuration.
>>
>> The ability to suspend, resume, and transfer VF device state data is
>> included along with the required admin queue command structures and
>> implementations.
>>
>> PDS_LM_CMD_SUSPEND and PDS_LM_CMD_SUSPEND_STATUS are added to
>> support
>> the VF device suspend operation.
>>
>> PDS_LM_CMD_RESUME is added to support the VF device resume operation.
>>
>> PDS_LM_CMD_STATUS is added to determine the exact size of the VF
>> device state data.
>>
>> PDS_LM_CMD_SAVE is added to get the VF device state data.
>>
>> PDS_LM_CMD_RESTORE is added to restore the VF device with the
>> previously saved data from PDS_LM_CMD_SAVE.
>>
>> PDS_LM_CMD_HOST_VF_STATUS is added to notify the device when
>> a migration is in/not-in progress from the host's perspective.
> 
> Here is 'the device' referring to the PF or VF?

Device is referring to the DSC/firmware not the function. I will clarify 
the wording here. Thanks.

> 
> and how would the device use this information?
> 
>> +
>> +static int pds_vfio_client_adminq_cmd(struct pds_vfio_pci_device *pds_vfio,
>> +                                   union pds_core_adminq_cmd *req,
>> +                                   size_t req_len,
>> +                                   union pds_core_adminq_comp *resp,
>> +                                   u64 flags)
>> +{
>> +     union pds_core_adminq_cmd cmd = {};
>> +     size_t cp_len;
>> +     int err;
>> +
>> +     /* Wrap the client request */
>> +     cmd.client_request.opcode = PDS_AQ_CMD_CLIENT_CMD;
>> +     cmd.client_request.client_id = cpu_to_le16(pds_vfio->client_id);
>> +     cp_len = min_t(size_t, req_len,
>> sizeof(cmd.client_request.client_cmd));
> 
> 'req_len' is kind of redundant. Looks all the callers use sizeof(req).

It does a memcpy based on the min size between req_len and the size of 
the request.

> 
>> +static int
>> +pds_vfio_suspend_wait_device_cmd(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     union pds_core_adminq_cmd cmd = {
>> +             .lm_suspend_status = {
>> +                     .opcode = PDS_LM_CMD_SUSPEND_STATUS,
>> +                     .vf_id = cpu_to_le16(pds_vfio->vf_id),
>> +             },
>> +     };
>> +     struct device *dev = pds_vfio_to_dev(pds_vfio);
>> +     union pds_core_adminq_comp comp = {};
>> +     unsigned long time_limit;
>> +     unsigned long time_start;
>> +     unsigned long time_done;
>> +     int err;
>> +
>> +     time_start = jiffies;
>> +     time_limit = time_start + HZ * SUSPEND_TIMEOUT_S;
>> +     do {
>> +             err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd,
>> sizeof(cmd),
>> +                                              &comp,
>> PDS_AQ_FLAG_FASTPOLL);
>> +             if (err != -EAGAIN)
>> +                     break;
>> +
>> +             msleep(SUSPEND_CHECK_INTERVAL_MS);
>> +     } while (time_before(jiffies, time_limit));
> 
> pds_vfio_client_adminq_cmd() has the exactly same mechanism
> with 5s timeout and 1ms poll interval when FASTPOLL is set.
> 
> probably you can introduce another flag to indicate retry on
> -EAGAIN and then handle it fully in pds_vfio_client_adminq_cmd()?

That's the entire purpose of this command. It uses 
pds_vfio_client_adminq_cmd() to poll the SUSPEND_STATUS. IMHO adding the 
polling mechanism in pds_vfio_client_adminq_cmd() and using it depending 
on a flag is just adding to the complexity and not offering any benefit. 
I plan to keep this function as is to separate the functionality. Thanks.

> 
>> +int pds_vfio_suspend_device_cmd(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     union pds_core_adminq_cmd cmd = {
>> +             .lm_suspend = {
>> +                     .opcode = PDS_LM_CMD_SUSPEND,
>> +                     .vf_id = cpu_to_le16(pds_vfio->vf_id),
>> +             },
>> +     };
>> +     struct device *dev = pds_vfio_to_dev(pds_vfio);
>> +     union pds_core_adminq_comp comp = {};
>> +     int err;
>> +
>> +     dev_dbg(dev, "vf%u: Suspend device\n", pds_vfio->vf_id);
>> +
>> +     err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
>> &comp,
>> +                                      PDS_AQ_FLAG_FASTPOLL);
>> +     if (err) {
>> +             dev_err(dev, "vf%u: Suspend failed: %pe\n", pds_vfio->vf_id,
>> +                     ERR_PTR(err));
>> +             return err;
>> +     }
>> +
>> +     return pds_vfio_suspend_wait_device_cmd(pds_vfio);
>> +}
> 
> The logic in this function is very confusing.
> 
> PDS_LM_CMD_SUSPEND has a completion record:
> 
> +struct pds_lm_suspend_comp {
> +       u8     status;
> +       u8     rsvd;
> +       __le16 comp_index;
> +       union {
> +               __le64 state_size;
> +               u8     rsvd2[11];
> +       } __packed;
> +       u8     color;
> 
> Presumably this function can look at the completion record to know whether
> the suspend request succeeds.
> 
> Why do you require another wait_device step to query the suspend status?

The driver sends the initial suspend request to tell the DSC/firmware to 
suspend the VF's data/control path. The DSC/firmware will ack/nack the 
suspend request in the completion.

Then the driver polls the DSC/firmware to find when the VF's 
data/control path has been fully suspended. When the DSC/firmware isn't 
done suspending yet it will return -EAGAIN. Otherwise it will return 
success/failure.

I will add some comments clarifying these details.

> 
> and I have another question. Is it correct to hard-code the 5s timeout in
> the kernel w/o any input from the VMM? Note the guest has been stopped
> at this point then very likely the 5s timeout will kill any reasonable SLA which
> CSPs try to reach hard.

This gives the device a max of 5 seconds to suspend the VF's 
data/control path.

> 
> Ideally the VMM has an estimation how long a VM can be paused based on
> SLA, to-be-migrated state size, available network bandwidth, etc. and that
> hint should be passed to the kernel so any state transition which may violate
> that expectation can fail quickly to break the migration process and put the
> VM back to the running state.

For QEMU there is a parameter that can specify the downtime-limit that's 
used as you mentioned, but this does not include how long it takes the 
device to STOP (i.e. suspend the data/control path).

> 
> Jason/Shameer, is there similar concern in mlx/hisilicon drivers?
> 
>> +
>> +int pds_vfio_resume_device_cmd(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     union pds_core_adminq_cmd cmd = {
>> +             .lm_resume = {
>> +                     .opcode = PDS_LM_CMD_RESUME,
>> +                     .vf_id = cpu_to_le16(pds_vfio->vf_id),
>> +             },
>> +     };
>> +     struct device *dev = pds_vfio_to_dev(pds_vfio);
>> +     union pds_core_adminq_comp comp = {};
>> +
>> +     dev_dbg(dev, "vf%u: Resume device\n", pds_vfio->vf_id);
>> +
>> +     return pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
>> &comp,
>> +                                       0);
> 
> 'resume' is also in the blackout phase when the guest is not running.
> 
> So presumably FAST_POLL should be set otherwise the max 256ms
> poll interval (PDSC_ADMINQ_MAX_POLL_INTERVAL) is really inefficient.

Yeah this is a good catch. I think setting fast_poll = true would be a 
good idea here. Thanks.

> 
>> +
>> +     if (cur == VFIO_DEVICE_STATE_RUNNING && next ==
>> VFIO_DEVICE_STATE_RUNNING_P2P) {
>> +             pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
>> +
>> PDS_LM_STA_IN_PROGRESS);
>> +             err = pds_vfio_suspend_device_cmd(pds_vfio);
>> +             if (err)
>> +                     return ERR_PTR(err);
>> +
>> +             return NULL;
>> +     }
>> +
>> +     if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && next ==
>> VFIO_DEVICE_STATE_RUNNING) {
>> +             err = pds_vfio_resume_device_cmd(pds_vfio);
>> +             if (err)
>> +                     return ERR_PTR(err);
>> +
>> +             pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
>> PDS_LM_STA_NONE);
>> +             return NULL;
>> +     }
>> +
>> +     if (cur == VFIO_DEVICE_STATE_STOP && next ==
>> VFIO_DEVICE_STATE_RUNNING_P2P)
>> +             return NULL;
>> +
>> +     if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && next ==
>> VFIO_DEVICE_STATE_STOP)
>> +             return NULL;
> 
> I'm not sure whether P2P is actually supported here. By definition
> P2P means the device is stopped but still responds to p2p request
> from other devices. If you look at mlx example it uses different
> cmds between RUNNING->RUNNING_P2P and RUNNING_P2P->STOP.
> 
> But in your case seems you simply move what is required in STOP
> into P2P. Probably you can just remove the support of P2P like
> hisilicon does.

In a previous review it was mentioned that P2P is more or less supported 
and this is how we are able to support it. Ideally we would not set the 
P2P feature and just implement the standard STOP/RUNNING states.

> 
>> +
>> +/**
>> + * struct pds_lm_comp - generic command completion
>> + * @status:  Status of the command (enum pds_core_status_code)
>> + * @rsvd:    Structure padding to 16 Bytes
>> + */
>> +struct pds_lm_comp {
>> +     u8 status;
>> +     u8 rsvd[15];
>> +};
> 
> not used. Looks most comp structures are defined w/o an user
> except struct pds_lm_status_comp.

I will look into this. Thanks.

