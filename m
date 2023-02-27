Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A866A4278
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjB0NTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjB0NT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:19:28 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A96B423F;
        Mon, 27 Feb 2023 05:19:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSiuwumqMcjeR7zzFl7Vj9gGFU1Z7HrAvZ2MVfnh9hHukx85n5sH3q+Gs0cZjYcDWt54HeWRwGUkcZBuzSXJHYbrMVtP+BuvouJGT30DbqUJkWhiOpWNEFpeeoNDs+rxFlA4pbr3RgoIxhJXe+1Ip8RAWIqsQ3LCwNByfvfJ2O9pZnsWqW70BpnAESqZPIK+Tt2mV68QolSRp36eWCQc7BjQ/VOpPyx6ZTrfoVJotS8PhKYguveO0fg/RRLBt5qMwXlYGa0d6NDAkQwDI2F5f8OdH/lwrLhQJ+0dMmnKQF3kDJ+U0gtNa4x9SqIqh0fkFrmymnUxpKGfrw0qmCjV5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHAQhy+zun+XoC5qETE7RbLiosswTr4V+STIxOO8Me0=;
 b=PuLBpiuhFAwHtbtZ0175wKR/RfWGw1dc6cA251fCtdeVAjsyKfQ6dqTndRYfBQufo0Bcr0I7g/SVAkw3i4yzlWdg0Afk6XHAkyUzdt6B207pm0vZzeiFFZBkZvpxGJ0RCYhCErIfPRbWhNeVtHR1Uwa1woAscukkMPHYNhiirG2EBH8bIGD9Dq3t8CqFj6E9ld4Qa/I57UvRWmkxQodPkF1cAeZi/AhAESZQlCC8UppTmTb9LiumhLRR8ovIG5sCT9I8fkhit/JISDp4sSFGnBh+09SRzLpWLNQatlCrmX+1GLin8yTvh/B5iJPYP/lmsYwbZSoQrGMHcuawTGabIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHAQhy+zun+XoC5qETE7RbLiosswTr4V+STIxOO8Me0=;
 b=3gJWeaveMzfSG9AoHfcraXhFBFsmpTQESzdSQJldmsgaK0Nvc5suHTS29/EMRyJGApzlS6i00/VFHMbZNTLhq1Ur/MznVWm0i/sw9YLf/7ZDKTJhBSo5Rg8GClwusYJnUwRGwKDaQpZAOfTBWzjDupHEFOeM8Jj7x4d59hDVBGk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM6PR12MB4499.namprd12.prod.outlook.com (2603:10b6:5:2ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 13:19:12 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%6]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 13:19:12 +0000
Message-ID: <805fe9f0-7dbf-4483-9281-072db3765ff6@amd.com>
Date:   Mon, 27 Feb 2023 07:19:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] wifi: ath11k: Add a warning for wcn6855 spurious wakeup
 events
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230220213807.28523-1-mario.limonciello@amd.com>
 <87r0ubqo81.fsf@kernel.org> <980959ea-b72f-4cc0-7662-4dd64932d005@amd.com>
 <87mt4zqmgh.fsf@kernel.org>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <87mt4zqmgh.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:805:ca::21) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|DM6PR12MB4499:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a4e424f-7636-434e-ab67-08db18c537a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iuaMJ0kC+6R1QF0ryxqD/Ehiwc18j0qGwPJHB1eGjlUXn7CzYdQcR8PmTPtI3n6oEGElPBLcGxOYNmHQKhYsUkZFjYmuawFOkEEpehNyBu0FHJE96zh/Z17b+cRkdPgZir/KGxBItyzxwP3xNM5iCUZhSYa5UGOg5tEA7YQn6bEaYAU3POYAim92m1aQv+hVHBLOua+rMR64ok+NdW5Pxt22XxalaDKRKhvSyLSzjC4S3swlFuS8YBuiKbzY5UpdEEn8luzce2WwO800eNfmGaa9yQTfQwMxgOQswQPuOkau0VDOHAbOtI1lxo3gbW5yum6WTXonOTdPto6P5N6rvnsVS16GPSDVQGILabJeKl3CR7bawNRoI07Qsb7vLd8QpfqhBooEgn3e7FTKG9eKras2FC0zylsdx9XXYyNe5qPBzxYu65ScWVhzapstWdofPwyQqKU+b3Mfj/nqMUXUpQG9ycnObuBOVTIaAo1x6ZLj8vfoxrD+OsBX4xxoOKgsoasoSVJgYq0yBvmsdEFlREexLmjjxdsZelkKsrTQaqFAWn9SfnChiKfCbyHVMhpe45ADGteXYYJcAsRo6sgXZz7YoGbC26YvTNAVPyANShxpSC2WcqXVYbxf5pFYa6Rltj9RutVTPX+NaqSn43Zi7WC7recu4KSQvxWBvw3CUYTNHY7UryxUl+D4Z84I4xeT44jVY6UzGl+bWWeOp2lo6S7/47XjcMmtTC4mYLnXQDVu29SoIjAHDpXowwQ7gei8hl/EgOlG1zxhccS69lzfPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199018)(8936002)(36756003)(5660300002)(38100700002)(53546011)(6512007)(6506007)(83380400001)(186003)(2616005)(31696002)(316002)(41300700001)(66946007)(66556008)(66476007)(54906003)(4326008)(8676002)(6916009)(478600001)(966005)(6486002)(86362001)(31686004)(2906002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnVlY3RNczZEamxkTmcxVG91NGIzSk1aMm5rWERjWk4wV3NWbjIvY3V5Rmg0?=
 =?utf-8?B?eFFIN0R4OW9xZjVKdVB1N1E5VEtEK3NGQndFYTBnS3dQSDc2T0dvUjBkRlN6?=
 =?utf-8?B?NFNmTW1TVkhGYk9JajJ5WG9NK1FwZHRyaWIraSsyQklnaWtITlM4WnlSbGRn?=
 =?utf-8?B?WXAzT1k3S3NiZWY4NXNuSmR1eXhWR3Iyd1FMdkpSZ3lMclNOQlRJM0RsOTRl?=
 =?utf-8?B?STQ2eXNzdmI0aHc1cmU1clRZWGZEaGJENmc1Y0hLbmRxQ05TeDFIZXE0bm5h?=
 =?utf-8?B?bnZFSm1EY2YzaDBCbmtmZXBxQXUrdE5XWU94aXQ1bHRyUnNwdmhiRFVaRTJy?=
 =?utf-8?B?aEluUXRrL0xXWUVoeFFxYU1nWTUxZG11Qkl0MUZpK2pJSkxHQmtHcTdveU14?=
 =?utf-8?B?MDVBc1M1bTJIVU9MOE11alJJemZGcUNpMHRxL1RZYm5mbE9JanVPUml3V0g5?=
 =?utf-8?B?RllGWHBQbUdFdDJXMlVpRXY1enBwTVNMUEZQTHVnOHhrRjFEaFNxaDRCVE8w?=
 =?utf-8?B?SFFKT3Q4UDhZaGJoYlRmMHczNXBHYnRvbWlidDREY3Q2VG9GVjU1SWZRZFVG?=
 =?utf-8?B?S0NGMlhTYllMOFNBSUJJRHQzZi9tUlRwekMwMlc1MFZ2RzBqV1hXaW5nZDMw?=
 =?utf-8?B?RllLSGdSUnJXRG92WS9WVU5vSTFQemJDWVdRb0owMHZ3VCthdVpwSkJnZ1Rt?=
 =?utf-8?B?eVNLdWdGVWpjVksyVTkwTGxLcVdhaWR5UzdkeTNnbkRqaXZ6NzBKZGduL0Jn?=
 =?utf-8?B?WFloM2lDK1JReDRyM3FXSFk1Z2RDQmlZMHVXbGFXNGozOTNZd1RNUzgyRmgz?=
 =?utf-8?B?LzZtOXJnSXVhS3hndDhEMW9nMGYxOUtBcUNudTdGemttVEh3QTRZZzVkdVM0?=
 =?utf-8?B?cjFIMUo2SW5hbkpxVVRPalJWL2IvYXZRN3FWOWwvRDBJcEh4aENubm83TFhS?=
 =?utf-8?B?MXBDb3g5aS8wSll1S2tZNlpKMGp1Z0ZOMUxkMDBHZjdKWVdncnBVNkRJdXAy?=
 =?utf-8?B?dWNpaXNxOGhhZXNWRldUQVBvcWwzeFlyM0tBWnI3a2hjdjRZaXJ0Z1pqRUpx?=
 =?utf-8?B?ZWhrdHZsSDRDZWNrL0pyWWFxa1JQaUZQZWRxczF5NGdLalFwN0dacGV3VVN6?=
 =?utf-8?B?WmUvRnFxamFpaEQrUG1RUlZQWWdoZkhBZzVMWTJlc1d3eStmbTJ4S3lTOXl5?=
 =?utf-8?B?TnR0akhRbHZHNTlvZ1h2V2EzOTJ1ZmFBRFVadGYyUnFnTWg5N0NES0wvVnlu?=
 =?utf-8?B?YWNOeWRtUjRDcy9SaE9YT0szdGVlSmZEbW4vMWtwbWEyMTUraHc2bEFwZDNC?=
 =?utf-8?B?a3QxMVVEQTZaNWxvdzBoUUk3Mi90MTdxMXdrcE13Z29UT3BTdVBPbjhDV0xy?=
 =?utf-8?B?MUJaV212TFpiSUpOY0tOWjg3OUJDdStmYWpncVhKMWh1dGZoSWRPMGtmSndo?=
 =?utf-8?B?VzNrcEtrVDZ5a2FiV3VyaWlML1BMdlUwQXF1REZXMTZ0QjQ1NHkyekg4b3A3?=
 =?utf-8?B?V25zdHZlVkxJVzRWSHprRmZYc09nQm9YeDN6R3Q5UVdhTnVKRG1ZaDJrbWJP?=
 =?utf-8?B?UHN3Y2Z3Q0t3T2J5YWlUZDZJRjA5QzVGUUJqKzNCdW5YMUVSTnBJNDBBM0tk?=
 =?utf-8?B?NjgzSlNqWWhaOTNIaUpOb21nc0ZWZTY1SFJRUTFENW5mc0o4djFXOTVHMkRs?=
 =?utf-8?B?TEwwa005QXNYRmdmSWUvUGlENmtlakxlOVF6RnErODZ6dElIOHVxalIyZzYv?=
 =?utf-8?B?YW92SGY5MWVRWjh3R3JUbUxIbENrR3d5VWovOHo2T0Naay92eFZnK2t5VWhJ?=
 =?utf-8?B?TDdzZUFjYThYT0JXRUw1bXFtRHpFSS80S0t4TStNSTJla0h2STN1M2MrVlhO?=
 =?utf-8?B?OGhwcHJ2WnMzcjZVTEJPRTlQUXJ5TDhyYkFNUWFKSnlZRW04VCtWbUF5bUdm?=
 =?utf-8?B?SEpVdHpVdWdnbW9YNktydHcvTy83K0hsdEdOOEwxeXg0Wk9JMVVKejArK0pT?=
 =?utf-8?B?ZksxSzJFTVdsQXJlME5uVWJjZVd5bUxTK1VKL0xGUHB4VjA4Q3U2YUQ0ZC93?=
 =?utf-8?B?YURoeEFIQTVoR3RvVGdiN1ArSEhuOENMSVdHb2UzOWQ2OFFFR3RUMUIrQ0FM?=
 =?utf-8?B?QVBFSHlWWFdRKzZNYnQ4OXN1Q01oNGhZZWRDWlE1QXZRaWZJSkROUlJlTEZK?=
 =?utf-8?Q?SSTb4qv61UQChx5NL8lYtFRXbff9BImgKsvz+kVOLl+y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4e424f-7636-434e-ab67-08db18c537a2
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 13:19:12.5169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eeJXQocNUZu0RxA9OOON0zvNPK2gi4KJ5DPfA4ogtyvbN4FlTud+tnfhoJWtQJyEQs/SJ8fgEA+DEY/oMFHudA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4499
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/23 07:14, Kalle Valo wrote:
> Mario Limonciello <mario.limonciello@amd.com> writes:
> 
>> On 2/27/23 06:36, Kalle Valo wrote:
>>
>>> Mario Limonciello <mario.limonciello@amd.com> writes:
>>>
>>>> When WCN6855 firmware versions less than 0x110B196E are used with
>>>> an AMD APU and the user puts the system into s2idle spurious wakeup
>>>> events can occur. These are difficult to attribute to the WLAN F/W
>>>> so add a warning to the kernel driver to give users a hint where
>>>> to look.
>>>>
>>>> This was tested on WCN6855 and a Lenovo Z13 with the following
>>>> firmware versions:
>>>> WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.9
>>>> WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.23
>>>>
>>>> Link: http://lists.infradead.org/pipermail/ath11k/2023-February/004024.html
>>>> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2377
>>>> Link: https://bugs.launchpad.net/ubuntu/+source/linux-firmware/+bug/2006458
>>>> Link:
>>>> https://lore.kernel.org/linux-gpio/20221012221028.4817-1-mario.limonciello@amd.com/
>>>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>>>
>>> [...]
>>>
>>>> +static void ath11k_check_s2idle_bug(struct ath11k_base *ab)
>>>> +{
>>>> +	struct pci_dev *rdev;
>>>> +
>>>> +	if (pm_suspend_target_state != PM_SUSPEND_TO_IDLE)
>>>> +		return;
>>>> +
>>>> +	if (ab->id.device != WCN6855_DEVICE_ID)
>>>> +		return;
>>>> +
>>>> +	if (ab->qmi.target.fw_version >= WCN6855_S2IDLE_VER)
>>>> +		return;
>>>> +
>>>> +	rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
>>>> +	if (rdev->vendor == PCI_VENDOR_ID_AMD)
>>>> + ath11k_warn(ab, "fw_version 0x%x may cause spurious wakeups.
>>>> Upgrade to 0x%x or later.",
>>>> +			    ab->qmi.target.fw_version, WCN6855_S2IDLE_VER);
>>>
>>> I understand the reasons for this warning but I don't really trust the
>>> check 'ab->qmi.target.fw_version >= WCN6855_S2IDLE_VER'. I don't know
>>> how the firmware team populates the fw_version so I'm worried that if we
>>> ever switch to a different firmware branch (or similar) this warning
>>> might all of sudden start triggering for the users.
>>>
>>
>> In that case, maybe would it be better to just have a list of the
>> public firmware with issue and ensure it doesn't match one of those?
> 
> You mean ath11k checking for known broken versions and reporting that?
> We have so many different firmwares to support in ath11k, I'm not really
> keen on adding tests for a specific version.

I checked and only found a total of 7 firmware versions published for 
WCN6855 at your ath11k-firmware repo.  I'm not sure how many went to 
linux-firmware.  But it seems like a relatively small list to have.

> 
> We have a list of known important bugs in the wiki:
> 
> https://wireless.wiki.kernel.org/en/users/drivers/ath11k#known_bugslimitations
> 
> What about adding the issue there, would that get more exposure to the
> bug and hopefully the users would upgrade the firmware?
> 

The problem is when this happens users have no way to know it's even 
caused by wireless.  So why would they go looking at the wireless wiki?

The GPIO used for WLAN is different from design to design so we can't 
put it in the GPIO driver.  There are plenty of designs that have valid 
reasons to wakeup from other GPIOs as well so it can't just be the GPIO 
driver IRQ.
