Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B6A63B59B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbiK1XHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234689AbiK1XHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:07:12 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2045.outbound.protection.outlook.com [40.107.101.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145232B26B
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:07:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQNLklWCjLUG2rT0RadJW/psM0Z/EH61rCvdLoZlpbUdglnY4yQK5u5aDpiSISo+Dqf9YIETjg4chQKxMzOg43Pr97L6JyPDG1yYt9ag4+whjMZlvSFlgRxEV09TFmWutlBoRrTK8f5QAR7tBbLiKTsGD+uUfi9/zDd1eXXU6ax9z6KaVuc+YLoYLDBcYTxO8TzSee5ABBN0IbehuJzxMQd9oPWVIiIftKF+diMrmP/0FscKXJSAqdoG7GPlYByXEgm6allJ8mfUgheAUIjtn9QIfnHWhZez8Ms4s/4StZS0SoHMiHWXs0WCyYO7VjAKo+hkTr7E6FhfYjCSAU72kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwDC3jg58Eh2igdb9j21KzDzmVIgUYHeydp/PT2u7cY=;
 b=f+FrsCPROkCzac7utpuYMH0+wX1wsQMSacwBEqsfp1cIJmhI+ntLqzKoo9V1JF7Pniem9U6ixsKd1X8CnK5YJfVR0bdvUTXY5naTsIrcyPQmgjNzVVGqnYbFVxpB2NCVFpfDvDGxxwvaPm0fsZOyDtDi6cb9+WCkwzdNw+WW4uJpEW1SMYBC98yq34H9H44gXJWozgLfJrNWAfulmTcbrNfvnChLyEHiBE/NLfcg56c9oihUZKS13v4+P+q5hEPlcTStDv6UwZsyjuc5WNYPLALmmQxjueWq/QSfW9TyPPWNI7mlIeleJzOp7UPTMtYEMjlpkPv3/RZL1vQh46LB5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwDC3jg58Eh2igdb9j21KzDzmVIgUYHeydp/PT2u7cY=;
 b=uBoYL7OlvR2LExfBdNJQVFwRtJulEwy7fDrGU1spnzU8lHBYarniPxbiD0PJJyP1yjXxc5S2m4eZ1s5c2wOoMqgbpA8eomImnyLhCW+sMKG5y7GgrffdylQurmFR4uk6eN9AuyzPMjqpIJRrJPgoVExuaUe6qNTDHzuj3pBHqeI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Mon, 28 Nov 2022 23:07:08 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:07:08 +0000
Message-ID: <43eebffe-7ac1-6311-6973-c7a53935e42d@amd.com>
Date:   Mon, 28 Nov 2022 15:07:06 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [RFC PATCH net-next 10/19] pds_core: devlink params for enabling
 VIF support
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-11-snelson@pensando.io>
 <20221128102953.2a61e246@kernel.org>
 <f7457718-cff6-e5e1-242e-89b0e118ec3f@amd.com> <Y4U8wIXSM2kESQIr@lunn.ch>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <Y4U8wIXSM2kESQIr@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0132.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::17) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH2PR12MB5001:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f53c241-013d-4907-6e08-08dad1954614
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: weaPNfMcIX4LxUn4okyubPvYz3N6kmVIqrsnx4DkBWJnRXFmP1U34vLmJLI+IVnCuGJjuz9f3UrTjMoK1Dc3FXiA7sUX8SHUOIkQiV/E4vxTlXvi9JK0byuwwQ5ytTLOuhYV23K/+4j/X0eGDmRmbWB06BEYwPfhksywTrnpoWe97mOlUsUCxq00S7CcUnTaDzqcpqC/UMnBmUzDM8FdIEbwJ3Uxjjj+0CcLw0EKNWYi0eMmyranIxtqFE6RC5S03V2asj1Ki0zY5lpFsXMzZhj9G/6oxxwA7FJMGEWCjTi0t+5/B4752mDwwukYlp4k0WBKfT6IlxLgGOu9EMGCHD7Ngo9UodtOPIMMO7HoZpTVnrUj2398MhwBQcY4UbZjolc8phsSmlN9EQkD2lGLWxdb7YzPcw84YBszQFwHZn6h7jwJGj6Ujs5VFRUm0GMFalhqvVK4UKzeLm8HnBtARqesC2SY61hcGo0PCJAkXR+4b7v9Kmzt8OoktOLgJtWQwPsZ3h9f/VlsmsYOiCLfGC9/WriAvBhaJENP4S5EUBPcb6AsoBZIeCgTG72OHNKqfJYudF0e/LPrr7CMgLB/0zuHTtyclNu4aZZ4jpYJW3MkfFB4ZjFjrdhuWhiZSfMXvc1zW2OjZ50Y5aufkGy6rPaMsUZeys3zcJ4qp0ObCbUvb1JYsv/umSZMZK5mXY06d/e6mPG5awcs8Xfvyn7gvwHHa3pcZyQMA8IssgiksVY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199015)(31686004)(83380400001)(54906003)(6916009)(6506007)(6486002)(36756003)(6512007)(31696002)(38100700002)(26005)(186003)(2616005)(66476007)(8936002)(5660300002)(53546011)(8676002)(478600001)(41300700001)(66946007)(316002)(4326008)(2906002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a052WUErQUhUOWprYTA4bndvSm1KMjl6eEhuaCtraThHWm9iSFhid3dVbm9u?=
 =?utf-8?B?aWpnbXBqMWxsS1p4bWlxdnMxOFdIQXVsL3VwZkw3c3ZaZlY4VlpEajBIeGdM?=
 =?utf-8?B?UEdwTXphdXduOWNVbEowYmczTVc4QTBpREZpUUpmOSs1bG9TUnVDTFJuSGhJ?=
 =?utf-8?B?SnN6R2xlVmQ5YktpZGdxby9iWTBFN3NBWmlUTm82S2UwOE11Z3U5RnJJTDJX?=
 =?utf-8?B?L1FVMEEzNkNwZ2x2akVsT09MYlB0N0JMb1NNcVJOb1hTTnBXWCs1aXpqU2J0?=
 =?utf-8?B?YlVpK0twMWQwV2lkTkZoWlhiVmN0bkVxNk91b3cwQ1haOWlDeG9tUThFd1lw?=
 =?utf-8?B?MmQrRlArZ3ZmbDkxanZ0OWVvZHFFRWlVRDlxZi9IZDhwRlQxSGFnYy8xbXdR?=
 =?utf-8?B?SUN0bHpSN0puNHR1bFhiZFA5YXJQbDhDbGZvdE45RjVOTTBjejVhK3pwOFJn?=
 =?utf-8?B?YmJ0cm9xWS9kbExVRkk3SW5VMEQzSFc2ek9nd3p4ZXlSUXNEVTIzZkEzMVBY?=
 =?utf-8?B?bmJMWlllZ0s0a1FRTWxkQStyVndGTXV4YmE1K3VDSmxOQWF1alFtQ3doNERJ?=
 =?utf-8?B?SlR2SmNnT2hJclNIZE5DMTRDT3RnZndFUmdVVVZYNmNzbndoMm9lUHVoaGI1?=
 =?utf-8?B?b1JBUmRmdnAva3hMYW4yakFKSDlYbEcwQkRqc1dPeGZMdUJMWDJkMkFLY2hJ?=
 =?utf-8?B?NC91TXd2UVhicmZ6N0tFRU5laDJrMHQwVis1YmZVZVl4ZlNzZWhaNUVQTk9T?=
 =?utf-8?B?R09lWHJqR21wdGJxdEdUcVVQMW84OTNwRGRpKzlzMkpRcWFNWTJWd2Y2dDFJ?=
 =?utf-8?B?d3VneDdtZGtTVGlXWkxVeFNwWm44dVFEdk5ldzhOeCtTZnN3bjNSTzVCSTNz?=
 =?utf-8?B?MWp0bFF5eW13STNXb1VLbU1LdGZNSlZvclZ1VmVxUHNwS0N4SGxWS05GL3ln?=
 =?utf-8?B?aVBqcW5DdXF3QTQyT0I3bXNEb0EvL01YeVppUUpicmVWb1VEakViTFdZTkRz?=
 =?utf-8?B?azJlK1prejI0Wi9iSU9kcWhFWHlBR1MydFV6Wm1kWmRsOHV0d2J1aWVUSTI1?=
 =?utf-8?B?Ym5xaHRRQmV6eVZJMmZ1YUZsUkxkK3RlVzBRMnlScng5QU9pVEcra2Z4S0U4?=
 =?utf-8?B?RDRiWDdTQkZWemN5ZXROWjJiZnpLMDdsZkRIRGlReTh6UnNlUFlBVUpnOUZ5?=
 =?utf-8?B?dEx3eExZZnZBRmpVS1YxdCs0NGdlclFRbG1vZUxzRm81WWhOYzZqd2xTVHpH?=
 =?utf-8?B?aVJpcU1OV09oRUoxYVRXTWJhZm11Q3FMV3lmQlQrVDljQVVBRFZmbVdkRFF3?=
 =?utf-8?B?dmlybjZJSVY0OVBWYXRSNHBnZTMrc3RoWDlmY2p0L2ZqRGZ5eTM4R1gzYzZU?=
 =?utf-8?B?M0ZoTUtiZDlhb2hRL0VHVnVZZ1FURzQ5aE54T3Q2OU1uMUZxcDZwNVRXVlFx?=
 =?utf-8?B?TlVKdWJ2a3B6MW40dHJpdTV2YkU5WlZPK2lYOTNHMU5mNkhra2daeDVIelNx?=
 =?utf-8?B?dHBSdC9wMm9IUDcwcm9pcmt5V1RNNEp5WWZVeUNHWWNhMlBlQUp4aWtRVWJY?=
 =?utf-8?B?R1hXeFEyVFh2WUxKc0NVeHllUit3WUs5bWg1U1dxMURlMS9HTGU1d3JkSEtQ?=
 =?utf-8?B?S2N0RlFoTDBiUFVrNVRwampVRW1XQThheXVwdTF0anRqR1lpMEgyRXREZkc0?=
 =?utf-8?B?eDg1K1Jra016YnlQQjUrc3BNRDYzMFFYb1NYTlZTdHhkVkJ3Z3BTYnIvczgv?=
 =?utf-8?B?ZWl5UzFLVDlzV1NSb242WjNocDEzU0xMNnc3T1hHTHNUQmxzZjNUTGtMRHlO?=
 =?utf-8?B?WkFqZmw3bzZmbVdGUEFQRW43SHFwdWRYem1ERmVnYUtDeWtrQUsvQTY4Q2Yx?=
 =?utf-8?B?S25LRThjUS9VZmRwdWdCKytpU29zT05ISys3TDhKMldGNHRvN2VEUzFSVldE?=
 =?utf-8?B?SjJJM0EyYUNYMHlYQ29CVXAvZ0txQkZDQkZqb0UwZjV4b2JDYlNUMTEwRWh0?=
 =?utf-8?B?RWcxTzVMOTBVUkN5UDJodWdzdnYrK0JpQkNTOXM4RllQR0xlWWtOd2NUREIz?=
 =?utf-8?B?MSsyRFl6cTBEL0tHQkZRQ1A0RGFNZ0VFWCtIaEhyRHRnNGJpZDE0YlhCSDBG?=
 =?utf-8?Q?bIScfywfhGFJzfrIfhmQy0hFe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f53c241-013d-4907-6e08-08dad1954614
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:07:08.3518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JB3YxJxKM8OTOnL5cJBRE2qckLBjhIxqFZ2xBuxArmyp0vJPUH2MVXjNc2xWSLSca16evn0GE/MvW5F3TN4f9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5001
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/22 2:57 PM, Andrew Lunn wrote:
> On Mon, Nov 28, 2022 at 02:26:26PM -0800, Shannon Nelson wrote:
>> On 11/28/22 10:29 AM, Jakub Kicinski wrote:
>>> On Fri, 18 Nov 2022 14:56:47 -0800 Shannon Nelson wrote:
>>>> +     DEVLINK_PARAM_DRIVER(PDSC_DEVLINK_PARAM_ID_LM,
>>>> +                          "enable_lm",
>>>> +                          DEVLINK_PARAM_TYPE_BOOL,
>>>> +                          BIT(DEVLINK_PARAM_CMODE_RUNTIME),
>>>> +                          pdsc_dl_enable_get,
>>>> +                          pdsc_dl_enable_set,
>>>> +                          pdsc_dl_enable_validate),
>>>
>>> Terrible name, not vendor specific.
>>
>> ... but useful for starting a conversation.
>>
>> How about we add
>>        DEVLINK_PARAM_GENERIC_ID_ENABLE_LM,
> 
> I know we are running short of short acronyms and we have to recycle
> them, rfc5513 and all, so could you actually use
> DEVLINK_PARAM_GENERIC_ID_ENABLE_LIST_MANAGER making it clear your
> Smart NIC is running majordomo and will soon replace vger.
> 
>        Andrew

Oh, hush, someone might hear you speak of our plan to take over the 
email world!  You never know who might be listening...

On the other hand, "LM" could be expanded to "LIVE_MIGRATION", but that 
is soooo many letters to type... perhaps I'll need to set up some 
additional vim macros.

How about:
	DEVLINK_PARAM_GENERIC_ID_ENABLE_LIVE_MIGRATION

Cheers,
sln
