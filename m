Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925CF666E14
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 10:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239893AbjALJ1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 04:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239942AbjALJ03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 04:26:29 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2054.outbound.protection.outlook.com [40.107.102.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F2F1EAE5
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 01:17:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lctyj971VEQ1r03qj8A15sYF5JZzI3qYlmJEfdNF6ZPQTtasO4oYWgQNWs7YDQ3zTY1s/s2yzmlDCYFjJXTF8KLvj63KEDgT9whMCttpSBzMaU37Yrl9uOhnYCGcJdMbBaQu2JbA2sgF5t5AKMuame4x20NP7+fUpIdzsPfZYtYMlfPZYySWsibFVOFFOwsnM5B6UlnNcpcgRPfVuHn93saloyWXCGldaSePpbIadff6jZXfAIbhh34QjQmD5kXK3fh7eBNElu2QcI1r8FF0m8h+mzb/bAS1see3RbDAt+kCGYQ5f1eZx7C1ZX/K+b5FcWdoWNuOY0Kr9vXbSlJbSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVeaqGQGsVfeEp6ZJfntRnhaSzIa0X5kIajXAnuQ9vU=;
 b=c3OPxxBeN5r4ZGgfSLAXfZDkrZ9Ss9mwmTnyZbgFrVrDzGNrY8FGarxeGA7UMrH9qkfs/JN/bsCXmQf2VOJUyXURAvxWHA4ft83q61cb2H9SzlVYFb9KE1sPvKy5nFWX1aKStFLhks5Ppr0R2X7AuoGGhzz/7dekuxsenRCvG8STNL3jJl3j9oDdok56E1dzOzfJSIZrGKFNL+5Rct56klb1N2ROfUz8va40e41aSxJ0iqoHsW4w5mHc2fY1CBwso2bn5m9H7k0EmE/HHVJFeTXSxjWkiiR+Sad44MAcc5Q44vWUWhCTOldO5H/62gh6MbnrExtoNvxX9/nrmqrhGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVeaqGQGsVfeEp6ZJfntRnhaSzIa0X5kIajXAnuQ9vU=;
 b=hhZojUeBSzYLqskTk5eBi0uHLl/CGbtzok3jEvpU4b0e7Bpr5RXe7JeSr8/pf7DJErbwdl4p5iVnnqNE/9MZnvZaphgznVFXf1MdJKdtlYpnkF7lgXhiHaXoN6HOgdoUpGRmLpgNQyKC8uNz6L7hF5J0hOAmf7ItlOWoBQK+TitqaUIDdTk7lsNFBh8zjOk5rSOwG4+BmOHBqK6ZGRe57IiwYJAkEgDeAWUMklWupKqpOCs/nceR5X/Bcig5qkB/3iXBaskLrincGLWzwd6N5lZzpEyyoeMDcB8IdKONYOKJNC1ir22n5LrnO34c61za+9zWYaaULMNF9qinQwdocg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 CY8PR12MB8364.namprd12.prod.outlook.com (2603:10b6:930:7f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13; Thu, 12 Jan 2023 09:17:16 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9%3]) with mapi id 15.20.6002.013; Thu, 12 Jan 2023
 09:17:15 +0000
Message-ID: <f10e0fa9-4168-87e5-ddf7-e05318da6780@nvidia.com>
Date:   Thu, 12 Jan 2023 11:17:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 08/15] net/mlx5e: Add hairpin debugfs files
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230111053045.413133-1-saeed@kernel.org>
 <20230111053045.413133-9-saeed@kernel.org>
 <20230111103422.102265b3@kernel.org> <Y78gEBXP9BuMq09O@x130>
 <20230111130342.6cef77d7@kernel.org> <Y78/y0cBQ9rmk8ge@x130>
 <20230111194608.7f15b9a1@kernel.org>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230111194608.7f15b9a1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::17) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|CY8PR12MB8364:EE_
X-MS-Office365-Filtering-Correlation-Id: 73f8b1bf-9827-42ac-7db9-08daf47dcbea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZRyiBjFtQAXHB8l1gj9TXR7IHIfZ5oc2moamLi97IC3zI2atZvChXGRyyezvcP2ldhK9YPSDFi9PO24e7iqnGElHS2DjJWU3Ab+ONqj86LgjNiLRA3AewCOdf16hfHqj9yCvlLgAsXgmbAWo2VlmkPoW14GphHtpnVV5QTfIMpfTNO4FfD2m55LXmsjDQTzyjhJtPDXCUeUN4qLgJyGNDnEL2ZrLj4IEnCE8rpumO5mU95pmAzg3jij+MgmSRtci7B28MJ6EBOL/CGNkDHMaa3SlQMnBr/u8x14HeZhWYqGFqn84b6mSoi82gx9mAdMYCxYdBYTzbXPuoGwEcsiHabQqmAEHuVbYNRMfRmjpYV3XyMu0i4sv58AuOsuruiOEnA5KvuC6gezS3HpBqbUtS5uv2J/3q1VucL5PQSthsf0t5WhxFqy0E0eLYuTPk4FawUEPnJUchyH6QsM4axGk8ILEbNGZEow6Q/LNXxQviL/uU6zvy0gIGCQQyI2FCgd/Qj3A9JT1yj/pKkMJg0MwnMr3WZqHSHNp2DF3ufvUA/rXpKTVg1wDAbFECgq1K49eygFWb6nZRXmQXyITK2ceu95cXVlDwPinsUuLH3HyAETAXfiHTko9rwTD3ggqtSXCVSRTf2mQd3XXrYJs8hevUeQ/nW07EFfRu/s8EsMf9UR7FSNwZLqIyqSLbhmnDoYJzQtQXc82sP87AcWoGx3zmRI81cpuahOF9BVNZwX3Do=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199015)(6506007)(107886003)(6666004)(2906002)(36756003)(4326008)(5660300002)(53546011)(8936002)(83380400001)(4744005)(31686004)(8676002)(38100700002)(6512007)(478600001)(41300700001)(6486002)(66556008)(26005)(66946007)(66476007)(186003)(86362001)(31696002)(2616005)(316002)(54906003)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEJSWkQ5SDY4OW12d3dFWEpGSVdwYWoveGt2bFlBNmQxK0c4bEpSVHNJMm9T?=
 =?utf-8?B?cmxST1lXb1QybGJNSkRTbmFLNTBZNnU1UkJURFlGOUhIaUN3cFZvTllFMllv?=
 =?utf-8?B?OVlkNGlFaHZiYVM0b3hVWWFIWTRqLzRjOHN1dlpKRVdYVTlKNWFicGg0QjA1?=
 =?utf-8?B?RjVoOHBQMVlTZExsR1dKK2wzTHNrL2x0UFpOVWlGU2grUjl2WVhucG1HSHdv?=
 =?utf-8?B?Y2I4VHR5WkVMa2cxNUVqQ2YvVU1uNTFTMkQxcFg5Qng0VU95SFdkbndQK2dZ?=
 =?utf-8?B?QnA1Z0FMbUhZYzcvRWQ3UUdjdllRRGlud0VqMm41REVVMGlORnZrWUpDNEw2?=
 =?utf-8?B?Z3BEUU1WQndKSGZTSTdhS0R5TW9tc3hnTjR1RzFQcHhNTnB1eEtOM2hwb21x?=
 =?utf-8?B?QTJQa3JPYXI3cWhGdmJqM1RQVFBoWm4xelJSNWRaQzUwTEVYNDM2N2VIdHZp?=
 =?utf-8?B?V3FwVEdtUmdhcW9nYnhDTFRkS0J0Wlh4akJQYkV1ZEJ6U2VFdXFEVXlkZlA4?=
 =?utf-8?B?dlFLUXU5MG9oaXIrMW10WDhkOEtwZENWaUV5SnVmcThYTmx5RkZNenJ5QWpE?=
 =?utf-8?B?b0cyRnk2dG9iMGNWT2VCMndJQStsVWZ3NjFMamJVV0szVWxMeUJFeXpHMWgx?=
 =?utf-8?B?ZEVPRjZzOEQrUDlSUi8raDBzTEpGQi92NTdpY2VYK05vRVN2ZGdaUms1U2pL?=
 =?utf-8?B?NTNDSmwrS3FlNVJDd0k0WlUycWZaNHZYeGpjTTBFOU80NXBjdUxiSGJsbllk?=
 =?utf-8?B?VnFSRE1TekZnSzh5RXkvbHFiKzFvQUUwVkFaWFFvTHRHNzNuNDNnLzJxRFpE?=
 =?utf-8?B?MmJWRkIyY0gvL0NTb3hoWG1Ic3hnd2VZV0tNV0Z4Z0N4anBIbHNZQ1pjRXpa?=
 =?utf-8?B?a1FzYktQV3ZsZGlVQTk3cnE1Q05YTTNTU2xSS0hhdmw5WlloMzdWU3ZTM0I3?=
 =?utf-8?B?ZFBJaEtGSkMvYWhmaGJnZlFKYUtyTUZMMFcrWkVVdngwZ2dWaXRrM2NQVndw?=
 =?utf-8?B?Yk9kQmZQeCtzNGdRd1M5bnNBWEY5V3NUVi8yZGhtL2xrdEx4NkVjM2JPd00v?=
 =?utf-8?B?M3VDbHVRaFhzbWIvcHJ4VlR0cnh3VVN6bVFkU2V0UTlwc1ZVbGpuR2ovK2ll?=
 =?utf-8?B?M2lTb3VIS0tMeUhvMERLdCsxMzNqcVhCRTg4YWg3Z0xFeDlKalhsSjVaUzFz?=
 =?utf-8?B?Y2VoS21GMWJEc2cwcHZYbUttSjl4V1lPb2dKR0tGNHEyOUhseStQT1ExeDh6?=
 =?utf-8?B?K0pCR2pPT3lZZXBZOHduZFRLNGVUcldqKzQzMHZ2WktIYktaSS8yTDV5SDRm?=
 =?utf-8?B?RTFlMER2bW05czZzVDNXU2oxZ2VLTnJrQlhVaGxxL2dYVHp1V3Q3eUxNYzg4?=
 =?utf-8?B?WVlXRUo3WGZkTVpsSHNONTZsY2FoRmhkMC9NV042cklTWXFRcGMvNWVUWS8w?=
 =?utf-8?B?LzlUQnBBRkEzak03bUIvMTYyb1RLQ0RxRDFPS2pWQ01QajE2MnNTODBIbDJX?=
 =?utf-8?B?UjRjY3F4ZlhvZTI4RlEvSFdjNnN5QUNuWkMybGFjS0toUUZoYkNWZ1RsTkVF?=
 =?utf-8?B?bmJQcWFHRXpYSkJ1a2krMlZZSXFReFZTZmwrQ1VIOC9HY1lWd1FxVkNWWmFH?=
 =?utf-8?B?U01UMHlVczRyOGtqWGpucnJRNWYvV3laTStSVWVoT3p0a0luK3NncmNQVW5Q?=
 =?utf-8?B?U0J4dDE0VFl6RVE2TGJRT3ZPZkEzTEVYbVd1cm1wa21KYmNQOUdUd2NLa2tZ?=
 =?utf-8?B?L3QzUEpYUkdiSnhrZkNnNmtDeFNvcUlMdms0WTRaOGVnNTdMbncvRXVieG5r?=
 =?utf-8?B?MFhJNSt6b1lJZHNFdDFlZ0FDb0tnTHdOVW40NlUxL1pGUUc0NXphVVlpR3JV?=
 =?utf-8?B?OTFFVzJEMnRqSVFoSmJaMHV5M0NpeTBaZXNZT1dxV0pWbnlMcllGSTJ2dktZ?=
 =?utf-8?B?NXp1RURlMlN2em9mdXVneWZIbzdHRUZLamxvLzJTam83VnBsKzkzZTdDTWI5?=
 =?utf-8?B?WTYxaS9Ma2V0TVRlM2k4R3ptanpIMHJtQnEyTFN1STFEVGpMQ3VCblQvSmtn?=
 =?utf-8?B?S29jSERVc0VybHNtZ2lFbER4eVpheUFidmZMUUsxWkZhSGswdzExMWIydThB?=
 =?utf-8?Q?CWf4bFXpJZhiS55uA0gvoC8MM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73f8b1bf-9827-42ac-7db9-08daf47dcbea
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 09:17:15.8234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4UxuJ+URgxrB6vm9+GcYaQvcBBAutd5Ued2d+1BBZs6jPcpXvUGWyQsKM5AdrwsH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8364
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/01/2023 5:46, Jakub Kicinski wrote:
> On Wed, 11 Jan 2023 15:01:31 -0800 Saeed Mahameed wrote:
>> Sorry i don't have much details here, Maybe Gal can chime in.. 
>> but what i am sure of is changing the hairpin RQ/SQ configs comes
>> with a risk.
> 
> Would be great if someone could chime in..

Hey,
As Saeed said, we discussed different APIs for this, debugfs seemed like
the best fit as we don't want users to change the queues parameters for
production purposes. Debugfs makes it clear that these params aren't for
your ordinary use, and allows us to be more flexible over time if needed
(we don't necessarily have to keep these files there forever, if our
hardware implementation changes for example).

Devlink param would work, but the message conveyed is a bit different
:). It makes it seem like this is a knob we want people to play with.
(And we have to support it forever).
