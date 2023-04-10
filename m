Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531D56DCC84
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 23:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjDJVBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 17:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjDJVBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 17:01:21 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA863E6F
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 14:01:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2KxI5gIcm45RH1gAMvN6x8gnbWj6j8SALxafttbFiCMQYb9u2n+NdNp/2+LR9jerNpxz9y//R6fZx5dF8y4t/m/5ggTSNwMLHQo/leLhoOfvLFWlXnUsyHC215SXn6B6Hd1Py79gNbDGXOzjjNXJYVskHYSbY3OAVPueZ3alr/U0/H99/8X3YY7xLV22dvyQwUlPqb4uYZHrq5+nJJtCidzQ6OAUi1ywXskMfOJT0pYA03oSvqLA2wBxS5M6YQZNRQc/1pefoWur2rbA0ZOH8HsM7T/mEnrdRGNFqT9zA6u0OXf4qgq0WnaZCFeIDDtoy3aJUJ5CfBKixLu8FNjbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFFbjUYY0m5ByAOyo1fZAcGi2YyUZHH6nlxBgTWqeAE=;
 b=cm8Kp7nh63z+6B/TCCsY7ZO7tsKIDn4zj2/SV/DL6EHydFrdinPV3CM0ahtpKQ1mSF/fTGBkYqCLZyaz0He2pn80/sQKwni0tTaIEQEGH9L45kPpcSO64A9F0zy8hefuBpLBku0E1JVEa0zACUVI2xgcAXg4d6wjCSCgap3ChtfFa4WUndUsTDDcshqBHw/gVOGq9IlRc7lp162Xb1A1shewINHB2lOUAWzN6it3amTZu+/xW/ne8c0a030NfFk4NjM2iUQV94qQ+clM62G8rLCzOaONbFKz0BnxU4kcrsYV7T3xlqFUxy1ZDLVYtaDxynoHYtJIn26O8tVVRvxXrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFFbjUYY0m5ByAOyo1fZAcGi2YyUZHH6nlxBgTWqeAE=;
 b=uD4EJp1LKwM+HTOrWOPNiGdO53IDuskxQBkzliAn01lZiPLyihRPauhbKqRtm9up0XT9KsR3ETNxHJrB2oYuEiF7thlABEztx8EQvViRFFEsTpx+MvGp5l7BCkA8Smz3WqwH2PLDABKCYg2f/qMr2PqiK4b+o/TsG0OfB8HSIJw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH3PR12MB8259.namprd12.prod.outlook.com (2603:10b6:610:124::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 21:01:16 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 21:01:16 +0000
Message-ID: <f5fbc5c7-2329-93e6-044d-7b70d96530be@amd.com>
Date:   Mon, 10 Apr 2023 14:01:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v9 net-next 13/14] pds_core: publish events to the clients
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-14-shannon.nelson@amd.com>
 <20230409171143.GH182481@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230409171143.GH182481@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0074.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::15) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH3PR12MB8259:EE_
X-MS-Office365-Filtering-Correlation-Id: e4713d0e-1939-4ed0-8d02-08db3a06b986
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Gaq72NJQO7DYUCjwl09inxWOrHwM6XuFQ5Kwbk9m00Vdz02GNqgq9Rir5aJKKqIyeY3EYK3nRXf7lSsHwW6SjLuYKQlIN0KBLMHqjArXBOYNrQdpXyAcg0Jlz3Ea1VAt9gGaYM2VQsCbzhsHFjeaNM+ERSADzKVbo1XU2xh+OSC4IXVr/EgjwBS1I3cYov8usC8otOQ3hm6mtueVBznGlkl0R152ZBik2PGoMO4wMFQY7DY7sOEOIGF6iskSWEJ9Fr88D0ucESLJEnS+cjAZDstoVI1XFt1qpoQXdvrWSoTEIBGQp0pbsrJ/hR8UIiaoSvb0pLAGF+347NOJ3cHBieLc/vKF0e/e49s5ZiiU5zJ80piz+PQqIrwurupsf4EVekpp8CC6VZ84B65liT8Lt0LutYQthiBsMAbHU/kYBoY6OgokXZp9oYD1Zhbv2CKDpdo0zwK6JJuq4HFgEiM6lmvunisM3UIVgtOXqVVVKVxL3inC29OCtISIgdJ7e32gdHGWMTvFC2yVVuivArIzPJdb7pVFYEjwfcjXSZ8AMOGGH2YUjQPE+84xZZHgeNk587nSiw3xT/CwKacoJQ0/Oeh2DtwaMzENmcUQPAYZCkyk+W9YDqSI7L1N2mI+ay9WSjMkWXPNEo7rXZN8+7u/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(366004)(346002)(451199021)(31686004)(478600001)(31696002)(86362001)(83380400001)(36756003)(38100700002)(2616005)(6666004)(6486002)(2906002)(316002)(6506007)(186003)(44832011)(53546011)(6512007)(26005)(66476007)(8676002)(66556008)(6916009)(8936002)(5660300002)(41300700001)(4326008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjUzUjFZZjJscWhuQjRpQXpjOHNVLy9NYndNcmlndEFYeDQraFpZc25HcjYx?=
 =?utf-8?B?Q2lWMGRYVDczK2hMKzhVaDJHWWxoVVNFcW8vVjVldC9BUWtvd0Q0Y1phZ000?=
 =?utf-8?B?VTBTcVRWUXgzZ1BUSkhvaHZjZ1BwUVlBM0YzNjdSelIwRlRRcHZQL2l3NjZC?=
 =?utf-8?B?bS9xb2xlNjIyTVF6RjU2SkhFcXE5bmU4L2RIOHhjUnpqQmZmMEdYTlYwTlhH?=
 =?utf-8?B?Wk1GVEdrZWE0bkVjbWRqQXVqUVRiNFltL2ppRllDazk0VVg2RVIwcVJ0ZEJG?=
 =?utf-8?B?L296emNtUnNWQ28zb1lGRnBsMXdHUUJKUEQvYkRhanlpdFpMcjVaM29FRXpq?=
 =?utf-8?B?ZmlUNmxwMFlLcXFWM0ZZd1ZoVnppNHJqSEZMMlFReitRYnFxdklaMGt5KzJa?=
 =?utf-8?B?cVp2WTBOUUtpNkJQU3BjR0RGcmh5bUw5TUxTMCtFWmVZcUs2S1VxaFBrWHJE?=
 =?utf-8?B?M0tkWnBZRGN2SjJTTGI3cWpBMGtIdlF5WElPTnFCUXZWWE9uK3NXWWxjVE9a?=
 =?utf-8?B?OHBNakJBQ2NCWVZuYWNWcWNpYkcrUlU2eEhCS3d0cVpldUtRMWJSVXpjTG90?=
 =?utf-8?B?dTR5Skc4QkRmQ1lNWXp6K3pSaEJtSTRzVjdBWDlFWFYwbWlLcGgzTFFuTnpJ?=
 =?utf-8?B?RmVTQTQyOW1Nak55c0tKYVhkcC84ZTQ0SEdXTHN0SGY1L2d6eEJOR01Pcmw2?=
 =?utf-8?B?YWtsZ3FSWnZZN2xrbm9BTkRvSnJWSnkwTnlTS2pJNnJ0VTc1RzFQbEhhRkNQ?=
 =?utf-8?B?dkZpVjZIQndxWEs1czV6UFM5Y1FsMWhtMVgrTlovMk52SWR0Q2kyVVF6MGx1?=
 =?utf-8?B?bmd2N1IzRXh1OG5hWCtlYjdCMUtTYW5GUUN6YmRsOXpjUy9MWmF5RDZsQ3ds?=
 =?utf-8?B?VGNFK29vQW5lRFh4R1VvKzVlM1AxaFE2THFZc1NhOWZ0RzlJZ1c1MTRRanQ2?=
 =?utf-8?B?aTlQU1RRRVc5UmpYSVoyLys3SldJREtzVTdHTjIwNXNLaFN1dzl4bmFPaU1J?=
 =?utf-8?B?Uk40NUNwb2NJL2pXZTh2YzExajBxTWZ2aGZFdGdCcTRCZHBVYVgrcmpPSjhv?=
 =?utf-8?B?cHNUWS8vb0xkUm5mOXFKYXFZWDQ0aW9MU2NPNktYQlFrM0NkMzlYMm1mb09P?=
 =?utf-8?B?T2I4SnFqMm03MnpFT0R2MjJrSld6S1JHa1lRN09aeHVvWVlSR1FRaDBvY1Nw?=
 =?utf-8?B?U1hpSUdVbHpxUlQrajBXUTNnOFNpKytET3FKUld1cExSNVNWWDBoSm5ZMzBD?=
 =?utf-8?B?V25lZFBCYUUvYkZmY3pXTWlGek5pdUFVaEpHbHJERURjTEtiaGtERitZTnZX?=
 =?utf-8?B?TFVhM3cycGpsU3RIN1FweDlVcytqL2d5NlgxVkJNczRKMXhKdFNXbkJ5SEVs?=
 =?utf-8?B?cUthS1cxbEcyVVB3NEc2MXo1SUpiZDJnNXhXY0l1RUNrTkxBbTJqSUk5QnBH?=
 =?utf-8?B?WHJ5OWNIV3ZrVnErYlBkclVUbTVpWDd2MDVPQU9VREhPN3VldFk4MnIwN0Vp?=
 =?utf-8?B?V2JNRXg5eGZNbDJINkE0eXF6SEJ3dTd6eEY4VWhSOVdoSDY5SEkxTzllVmZs?=
 =?utf-8?B?MFJhcTZIZmtpT3lnMHdudVA4SEpwVHJad2psQU54bXZ4VGhMVExUTXhQbk9X?=
 =?utf-8?B?U2xibnB2bHE2b2JlQVZwYXBTV1lDTEd3QWg4K1lJMlozL2NKUUJxSzR1QnRm?=
 =?utf-8?B?dHB0K2tyaEwwSG95SjEzK29LYUpvMGNvTnMzcWtEVTJkYzhKSDNuSStVZWc4?=
 =?utf-8?B?MU9ZNkt0ZXZXUjY4UFkxaWhibWRHY2Q4Nmh3WGZsbjZtT2VFMFVEZjI3dlhv?=
 =?utf-8?B?M0Z6RTh0c3JKSzJ2aGVGZWNtczRrWXRZMmpBbElNNkdvQ25xRHlhUVdaVnN3?=
 =?utf-8?B?dHNVS1FTKzIyVEM5QU1QYm5TVmNVbUNDeHlKUHV6MHpYNGxaNTI5c255MWVE?=
 =?utf-8?B?eWwxOTAzUm13RU50cnhtemlwYUg0ZzJjL2Y0ODhPa09HbnloRTh4TjNMcms0?=
 =?utf-8?B?ZzBhQkJoQk1LQ3ZCQzZOejhtVXY1YmxPNXIyNS9HVHVoanNXYytBRExCMmVo?=
 =?utf-8?B?NVZvWEpVdjVVQzNaVXVuTGRFOXFzOEVQQ2tpajBFbko3SDZDWG1PUGtIdlFP?=
 =?utf-8?Q?BorDUXq4nMRGR5h6EqRjIh58F?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4713d0e-1939-4ed0-8d02-08db3a06b986
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 21:01:16.1619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ic8WPNhxUPKstjBvbn6PHMowCu99GyvubMTmNTv/kFMiW/2LnvEL5yukD8TPqIXdH66/dZNW68U/SEiaUaI/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8259
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/23 10:11 AM, Leon Romanovsky wrote:
> 
> On Thu, Apr 06, 2023 at 04:41:42PM -0700, Shannon Nelson wrote:
>> When the Core device gets an event from the device, or notices
>> the device FW to be up or down, it needs to send those events
>> on to the clients that have an event handler.  Add the code to
>> pass along the events to the clients.
>>
>> The entry points pdsc_register_notify() and pdsc_unregister_notify()
>> are EXPORTed for other drivers that want to listen for these events.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/net/ethernet/amd/pds_core/adminq.c |  2 ++
>>   drivers/net/ethernet/amd/pds_core/core.c   | 32 ++++++++++++++++++++++
>>   drivers/net/ethernet/amd/pds_core/core.h   |  3 ++
>>   include/linux/pds/pds_common.h             |  2 ++
>>   4 files changed, 39 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
>> index 25c7dd0d37e5..bb18ac1aabab 100644
>> --- a/drivers/net/ethernet/amd/pds_core/adminq.c
>> +++ b/drivers/net/ethernet/amd/pds_core/adminq.c
>> @@ -27,11 +27,13 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
>>                case PDS_EVENT_LINK_CHANGE:
>>                        dev_info(pdsc->dev, "NotifyQ LINK_CHANGE ecode %d eid %lld\n",
>>                                 ecode, eid);
>> +                     pdsc_notify(PDS_EVENT_LINK_CHANGE, comp);
> 
> Aren't you "resending" standard netdev event?
> It will be better to send only custom, specific to pds_core events,
> while leaving general ones to netdev.

We have no netdev in pds_core, so we have to publish this to clients 
that might have a netdev or some other need to know.

> 
>>                        break;
>>
>>                case PDS_EVENT_RESET:
>>                        dev_info(pdsc->dev, "NotifyQ RESET ecode %d eid %lld\n",
>>                                 ecode, eid);
>> +                     pdsc_notify(PDS_EVENT_RESET, comp);
> 
> We can argue if clients should get this event. Once reset is detected,
> the pds_core should close devices by deleting aux drivers.

We can get a reset signal from the device when it has done a crash 
recovery or when it is preparing to do an update, and this allows 
clients to quiesce their operations when reset.state==0 and restart when 
they see reset.state==1



> 
> Thanks
> 
>>                        break;
>>
>>                case PDS_EVENT_XCVR:
>> diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
>> index ec088d490d34..b2790be0fc46 100644
>> --- a/drivers/net/ethernet/amd/pds_core/core.c
>> +++ b/drivers/net/ethernet/amd/pds_core/core.c
>> @@ -6,6 +6,25 @@
>>
>>   #include "core.h"
>>
>> +static BLOCKING_NOTIFIER_HEAD(pds_notify_chain);
>> +
>> +int pdsc_register_notify(struct notifier_block *nb)
>> +{
>> +     return blocking_notifier_chain_register(&pds_notify_chain, nb);
>> +}
>> +EXPORT_SYMBOL_GPL(pdsc_register_notify);
>> +
>> +void pdsc_unregister_notify(struct notifier_block *nb)
>> +{
>> +     blocking_notifier_chain_unregister(&pds_notify_chain, nb);
>> +}
>> +EXPORT_SYMBOL_GPL(pdsc_unregister_notify);
>> +
>> +void pdsc_notify(unsigned long event, void *data)
>> +{
>> +     blocking_notifier_call_chain(&pds_notify_chain, event, data);
>> +}
>> +
>>   void pdsc_intr_free(struct pdsc *pdsc, int index)
>>   {
>>        struct pdsc_intr_info *intr_info;
>> @@ -513,12 +532,19 @@ void pdsc_stop(struct pdsc *pdsc)
>>
>>   static void pdsc_fw_down(struct pdsc *pdsc)
>>   {
>> +     union pds_core_notifyq_comp reset_event = {
>> +             .reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
>> +             .reset.state = 0,
>> +     };
>> +
>>        if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
>>                dev_err(pdsc->dev, "%s: already happening\n", __func__);
>>                return;
>>        }
>>
>> +     /* Notify clients of fw_down */
>>        devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
>> +     pdsc_notify(PDS_EVENT_RESET, &reset_event);
>>
>>        pdsc_mask_interrupts(pdsc);
>>        pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
>> @@ -526,6 +552,10 @@ static void pdsc_fw_down(struct pdsc *pdsc)
>>
>>   static void pdsc_fw_up(struct pdsc *pdsc)
>>   {
>> +     union pds_core_notifyq_comp reset_event = {
>> +             .reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
>> +             .reset.state = 1,
>> +     };
>>        int err;
>>
>>        if (!test_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
>> @@ -541,9 +571,11 @@ static void pdsc_fw_up(struct pdsc *pdsc)
>>        if (err)
>>                goto err_out;
>>
>> +     /* Notify clients of fw_up */
>>        pdsc->fw_recoveries++;
>>        devlink_health_reporter_state_update(pdsc->fw_reporter,
>>                                             DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
>> +     pdsc_notify(PDS_EVENT_RESET, &reset_event);
>>
>>        return;
>>
>> diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
>> index aab4986007b9..2215e4915e6a 100644
>> --- a/drivers/net/ethernet/amd/pds_core/core.h
>> +++ b/drivers/net/ethernet/amd/pds_core/core.h
>> @@ -310,6 +310,9 @@ int pdsc_start(struct pdsc *pdsc);
>>   void pdsc_stop(struct pdsc *pdsc);
>>   void pdsc_health_thread(struct work_struct *work);
>>
>> +int pdsc_register_notify(struct notifier_block *nb);
>> +void pdsc_unregister_notify(struct notifier_block *nb);
>> +void pdsc_notify(unsigned long event, void *data);
>>   int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf);
>>   int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf);
>>
>> diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
>> index 898f3c7b14b7..17708a142349 100644
>> --- a/include/linux/pds/pds_common.h
>> +++ b/include/linux/pds/pds_common.h
>> @@ -91,5 +91,7 @@ enum pds_core_logical_qtype {
>>        PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
>>   };
>>
>> +int pdsc_register_notify(struct notifier_block *nb);
>> +void pdsc_unregister_notify(struct notifier_block *nb);
>>   void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
>>   #endif /* _PDS_COMMON_H_ */
>> --
>> 2.17.1
>>
