Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E336DCDB7
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 00:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjDJW7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 18:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDJW7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 18:59:37 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976361FC4
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 15:59:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmCejKPuPTuYAosXFovzbsvLaETA2xsGTFOC4oBjeHymLYWCmU6zsf32qdTGizII4cfULIlRFlaf1OVawoWwcQbsxo5Q6mgQtv+9oTY9HnwxEJ+z5l94929DylvbYXHNoz7s00y6H8O0/BIFg7872rWWqLkY5Gzq+OihvKaiTzaPTVXLuyJx+c22SoaamB9+yqBmueO3ckB/LdgRNqXoAkZ19lS2OMxHQqtmmu7jptzKzh0g/plC8pU+X2taAZugfLrMKYAYqqGvGR7XSU6NclRWTIhsBbjAuWjUvMjjDFwtpRVi2avx9INE+nZzNXI9mBPPiKB4jCAQx4hUgjpadQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1SzAlGLck9gmkoF5JV3lAZHy8E7Rk4kEbuMygbWmLg=;
 b=X89yeRBX1H6hAEaUbt9SFL45l7GwUl80jq7W7Z8tN0S6W0sf6WLe86Y4s+jDvQvWyK+ScidGclimtpz6mxNsZM1Uuq7VFd/+J6xjqDcHXNf5X2ZEe3DR/9QIBhULYCI9KoxQBpCm1JptAn7N9VOj7gZ/Pk14KyIoyPszOePtsb62u7yZ/MJ0jqb0tXdl9pNfswZbjBxHEuIqWI0E38ni/cWdpeeXaaIEGkFeMxHvCV4HRSevNQkVcmRd6fCH6yZBPlzCLk4sCRmDjMo141v5yZ26Ks6qDybBC5s4igRjUcNNTaZzY6Hcpp+uIy2DNf0WOBVt7qaIbz/FiucmKUcY3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1SzAlGLck9gmkoF5JV3lAZHy8E7Rk4kEbuMygbWmLg=;
 b=M4fudrJ5XAajz1Es7y+XuDULMWT4n97xk+aH7X9KUJCn7gKv1s2e9HNXdCKZx/mHRnOKnoQW/sF+lJc3VeymqlV92JiFi1Uk0YLfkrcVAGDb8xcm99qtirBFDQUsaE3iskMbGztIaxJ3iGbiDnCK7cVmm550HyY/554NosZR6k8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SJ1PR12MB6099.namprd12.prod.outlook.com (2603:10b6:a03:45e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 22:59:33 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 22:59:33 +0000
Message-ID: <adc04ee0-4a75-71a5-ef67-a2851265e6e9@amd.com>
Date:   Mon, 10 Apr 2023 15:59:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v9 net-next 07/14] pds_core: add FW update feature to
 devlink
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, leon@kernel.org,
        jiri@resnulli.us
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-8-shannon.nelson@amd.com>
 <ZDQuxBlfH5foSEFA@corigine.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <ZDQuxBlfH5foSEFA@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0067.namprd17.prod.outlook.com
 (2603:10b6:a03:167::44) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SJ1PR12MB6099:EE_
X-MS-Office365-Filtering-Correlation-Id: 2da4c52e-c1d4-41c0-fbea-08db3a173fd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6MXduDEx3fPwNSQLZ2ezxIpkCTnnJb/AZSV27EQGhnh+FJne/ebjwKgk5r2mjqC2Q1Lu7a/GRnuWPigv5uVN2bcwAkT9Q7MzO2IsyD9gN8FQDsGARycH5wSrn91LZeLYBrXA3er98tXFcqcuV5NDMHP6WeFwo6Fub81WBrWzQNLXYhwd2tjZBPY4L3kqWtXrwcgX/H8+lXxiHfLG35YURn2ns7R1P8LAkRyTP+8BMAxAD31xKqhi7rpOVtVzBnWrr34DBfL0KosbIOaFW4HSOBwzxLsnQ1bPJ+dOh4/BKE2WO5jhLnYgxL47ulvoNu+hFV0qo3JU1y8c8xHTG0S9Da3FAvzLcICLh+/bWxNVEtaDoPeW11EqvsoBNYF8NE/jfwN0gY6Rv2qzQn2vzgL7L4hrI4/5sb1aPPwHkPhtImgswuGP/VyJZf2Ueki6pB6o8fIkppSoxv5CRnNrPigEH9+bNz9JMYxcBtsDQ5H0dbMyeEidejtV1sWhyRIywAAAAS2H7244fWsWEp/cuS0dJdQR0XuaT2p6v4b5KA16ijf7/ilvZwZcBiL4dq1IyhA6XMCHGPZ7AAZXfGq0XgTE8Sy7MXWUGuOzZRw/oioeHs/DfxsWVMzvzmp9eFzDTefr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199021)(316002)(478600001)(83380400001)(2616005)(186003)(36756003)(26005)(6506007)(6512007)(53546011)(38100700002)(31696002)(86362001)(6486002)(966005)(41300700001)(66476007)(66556008)(8676002)(4326008)(6916009)(66946007)(15650500001)(5660300002)(2906002)(31686004)(44832011)(8936002)(66899021)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEhha0xqb1B3RGFZVlo5aE1pTXZibEVQTlhXd3JuYkxXbm40UGM5a3o0dUxW?=
 =?utf-8?B?Z3VoTFRJUW9jY3NqWG1JVTE0bG9vTzBudjdIRGJUcm81SDJ3K3VhOSsxY2ZF?=
 =?utf-8?B?eU9TZDdvb21OeU9XZGZwRXJBZk5yR013cG55VzY5bXpnL3NJRDVTeG1Ic2or?=
 =?utf-8?B?b3RUaE51aS9rSkpDK2RKZUxZeEFnOXVpTHNXTW9SS053OHhSdXMxaUpkUTUz?=
 =?utf-8?B?VG5nekRpL0FjYzFGcUNZdFp4SFpWYlZlNHh6a1h3SHdXYXZ5MXlYTEJFQk1J?=
 =?utf-8?B?ZWh6ZEZOeTl6bkhzL0JxalRDVWJnNmg5RlZzS0Fxc2E5cWFwZ2ovaDJiZS9N?=
 =?utf-8?B?YWxORDE2UTBGWmZrVHIxczJxdFBGL0NrMitPNXd6TGFENmRJZ0prbmhSYkNS?=
 =?utf-8?B?SU9qdmtqZ3hYSGlhbGJaRGhzdVdSWVRDbmdrZ0xTSnFjN1ppSG9KamJMaUcy?=
 =?utf-8?B?dytWQUJFM3drMHpoRXJOL1VybWRtTVhNNUpSYklpZkd6YjFSbWk0RVc2L05a?=
 =?utf-8?B?VlNqRW8zM2JlMW5MbFZMWENnSDEyajM0OGdIbkpERUd5SnJjSlpWNEdOd25t?=
 =?utf-8?B?Lzk3VCtxUUxTUlpLUEUwd2hxdXRKVXBWRW9UL2VuN0FtNFd5NVBBU1crZ0tk?=
 =?utf-8?B?cUtGblNaVVg4eXdiYlJaVENtUVQvMlFiaHovWW96bERWQS8zbzJxeVNuSXM5?=
 =?utf-8?B?Y3hXTjVKTUJGNXVReUcxRko0Zm90NmZLQU52RGhOdjhzUXRjQzRxSEVydk8r?=
 =?utf-8?B?ZFM3WjZLckUzbWNBVXo1ZEF2OFJIeE1UbmlZQjVpNFpFT04rcXIxdVg1V1Nv?=
 =?utf-8?B?MFJhTzV4K3hmOU91RjdMQm5qMGp3MHF4YUZJenk0OGR6ZGRpSkx0YlJuazZX?=
 =?utf-8?B?RGk2WmtzVU94WE1GKzRwTlMwOUtaNDAwN2MwbjIvbUlJaWFNNFVzcjQ2QVVW?=
 =?utf-8?B?T3JEVW1FUlQ1VEhyZDVQNGNiVmU2MUlJc1VwMFNiR2RQTHRXU0dwMnFxUmhK?=
 =?utf-8?B?cHFiVHo5Y1YwRUVyK2d3OFV0S0lsVWdCciticC9SWnpJK1M4TlNyQ290UlQ4?=
 =?utf-8?B?V2JwRFNLc1M4cUIvM0x1RklYYmd6djdXb1pWSEtYVGQ4clpPQlFRMWN4cElo?=
 =?utf-8?B?L2RZZ1JleUl6Yi9WQVNPdi9xOStsYjEyMnVjRDd6UXp4MnVZNVVENlRTY0ZJ?=
 =?utf-8?B?anAvc0hFVTkzLzV3VG9yVGdzL2EyN3BHZ3orSnpaRmRmWUNFRDdTb2VnQWZU?=
 =?utf-8?B?cWxTR3pXeUZrQnlnakRRNkc4dk5wTnFTQ3lZSHhCMk1sMyt0ODdKZnN1RGx1?=
 =?utf-8?B?RUwvWUZTZFBtZHJLSytXYUkxdE10WmZoVnRmSXNmSlNpc3hBT1BYK0EyTDVj?=
 =?utf-8?B?R2tJcC95cUJUbk1ONmRiSUMwU1AvRkdrU3lMTnhCUnFGLzE1Ry9XeG1tMlhC?=
 =?utf-8?B?eFlxTWNLNTRPelFlUlZFM0tqd0dKZXFkT09ObUh4VGZiMlVvUlNCdnNxV2ps?=
 =?utf-8?B?WTBrYXVDU0o3YVB3eGRKV0pxTmdrdTJ3RkFZd3lQRTAySWhld3JoRnpuYW13?=
 =?utf-8?B?R1hUNjJESnQrWU5kT09uRFJFZU5JVXhIZ2h1WVlRS0tJT2tHTXUwN25mYlc4?=
 =?utf-8?B?UEMzTnlhWXRHRDk2VzRORHdQOUVvN1VBSSs4T3BtdWNXcjV2SXVJS1RYRWhm?=
 =?utf-8?B?UTJCbXVBMXFid0taSXYwSUN4WWxTVDBzUlFVNVIxZ3ozUDFKY1BQa25DaGNB?=
 =?utf-8?B?K0xETDNQWnR0SnRXSnFtZ25QUGhUOEFkT0lZRVA1UmdmemZDVit2NFhYczN1?=
 =?utf-8?B?Y3RBRDd1d21VNjBJc0hXeC9nbUtwclp4WHRZYzdLVUFRaWp0aXVjVmFxWUE5?=
 =?utf-8?B?YmJPdlRkRDBRT2ZEdnNFci90SmdIa1JvK3JuQkhNcno4NmFNRnA4V3Y0Tlpw?=
 =?utf-8?B?V283R2lkYmFiOGUrdldUV2ZvM0lsQXp2djN6WXpNWmtFeEFZT05lREV4a2lv?=
 =?utf-8?B?MFhPcExqNHZ1NW9WNjdQQzRmYkhTVFF1cnFsQ1ZtZGFQYUF0aGd2S2xlN3hK?=
 =?utf-8?B?TXUzZkJHdmFtcXR1OGFTMnl3KzFxTUNvenBVaXBVbHpPamplOUlmUkMzSDhl?=
 =?utf-8?Q?h1DOFxtZGFoAmLfyLV9xT243D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da4c52e-c1d4-41c0-fbea-08db3a173fd3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 22:59:33.4287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hbMMIMi+xEDBZCXo64OTVnCM3qbJ02mvcah+ILc2H7GcZ6Mv0tqvLZACqiEVNNt+Vig+52zWOkol/YEMz3T0OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6099
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/23 8:44 AM, Simon Horman wrote:
> 
> On Thu, Apr 06, 2023 at 04:41:36PM -0700, Shannon Nelson wrote:
>> Add in the support for doing firmware updates.  Of the two
>> main banks available, a and b, this updates the one not in
>> use and then selects it for the next boot.
>>
>> Example:
>>      devlink dev flash pci/0000:b2:00.0 \
>>            file pensando/dsc_fw_1.63.0-22.tar
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> 
> Hi Shannon,
> 
> some minor feedback from my side.

Thanks, I'll take care of these.
sln


> 
> ...
> 
>> diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
>> index 265d948a8c02..6faf46390f5f 100644
>> --- a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
>> +++ b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
>> @@ -73,6 +73,16 @@ The ``pds_core`` driver reports the following versions
>>        - fixed
>>        - The revision of the ASIC for this device
>>
>> +Firmware Management
>> +===================
>> +
>> +The ``flash`` command can update a the DSC firmware.  The downloaded firmware
>> +will be saved into either of firmware bank 1 or bank 2, whichever is not
>> +currrently in use, and that bank will used for the next boot::
> 
> nit: s/currrently/currently/



> 
> ...
> 
>> diff --git a/drivers/net/ethernet/amd/pds_core/fw.c b/drivers/net/ethernet/amd/pds_core/fw.c
> 
> ...
> 
>> +int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
>> +                      struct netlink_ext_ack *extack)
>> +{
>> +     u32 buf_sz, copy_sz, offset;
>> +     struct devlink *dl;
>> +     int next_interval;
>> +     u64 data_addr;
>> +     int err = 0;
>> +     u8 fw_slot;
>> +
>> +     dev_info(pdsc->dev, "Installing firmware\n");
>> +
>> +     dl = priv_to_devlink(pdsc);
>> +     devlink_flash_update_status_notify(dl, "Preparing to flash",
>> +                                        NULL, 0, 0);
>> +
>> +     buf_sz = sizeof(pdsc->cmd_regs->data);
>> +
>> +     dev_dbg(pdsc->dev,
>> +             "downloading firmware - size %d part_sz %d nparts %lu\n",
>> +             (int)fw->size, buf_sz, DIV_ROUND_UP(fw->size, buf_sz));
>> +
>> +     offset = 0;
>> +     next_interval = 0;
>> +     data_addr = offsetof(struct pds_core_dev_cmd_regs, data);
>> +     while (offset < fw->size) {
>> +             if (offset >= next_interval) {
>> +                     devlink_flash_update_status_notify(dl, "Downloading",
>> +                                                        NULL, offset,
>> +                                                        fw->size);
>> +                     next_interval = offset +
>> +                                     (fw->size / PDSC_FW_INTERVAL_FRACTION);
>> +             }
>> +
>> +             copy_sz = min_t(unsigned int, buf_sz, fw->size - offset);
>> +             mutex_lock(&pdsc->devcmd_lock);
>> +             memcpy_toio(&pdsc->cmd_regs->data, fw->data + offset, copy_sz);
>> +             err = pdsc_devcmd_fw_download_locked(pdsc, data_addr,
>> +                                                  offset, copy_sz);
>> +             mutex_unlock(&pdsc->devcmd_lock);
>> +             if (err) {
>> +                     dev_err(pdsc->dev,
>> +                             "download failed offset 0x%x addr 0x%llx len 0x%x: %pe\n",
>> +                             offset, data_addr, copy_sz, ERR_PTR(err));
>> +                     NL_SET_ERR_MSG_MOD(extack, "Segment download failed");
>> +                     goto err_out;
>> +             }
>> +             offset += copy_sz;
>> +     }
>> +     devlink_flash_update_status_notify(dl, "Downloading", NULL,
>> +                                        fw->size, fw->size);
>> +
>> +     devlink_flash_update_timeout_notify(dl, "Installing", NULL,
>> +                                         PDSC_FW_INSTALL_TIMEOUT);
>> +
>> +     fw_slot = pdsc_devcmd_fw_install(pdsc);
>> +     if (fw_slot < 0) {
> 
> The type of fs_slot is u8.
> But the return type of pdsc_devcmd_fw_install is int,
> (I think) it can return negative error values,
> and that case is checked on the line above.
> 
> Perhaps the type of fw_slot should be int?
> 
> Flagged by Coccinelle as:
> 
> drivers/net/ethernet/amd/pds_core/fw.c:154:5-12: WARNING: Unsigned expression compared with zero: fw_slot < 0
> 
> And Smatch as:
> 
> drivers/net/ethernet/amd/pds_core/fw.c:154 pdsc_firmware_update() warn: impossible condition '(fw_slot < 0) => (0-255 < 0)'
> 
>> +             err = fw_slot;
>> +             dev_err(pdsc->dev, "install failed: %pe\n", ERR_PTR(err));
>> +             NL_SET_ERR_MSG_MOD(extack, "Failed to start firmware install");
>> +             goto err_out;
>> +     }
> 
> ...
> 
> --
> You received this message because you are subscribed to the Google Groups "Pensando Drivers" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to drivers+unsubscribe@pensando.io.
> To view this discussion on the web visit https://groups.google.com/a/pensando.io/d/msgid/drivers/ZDQuxBlfH5foSEFA%40corigine.com.
