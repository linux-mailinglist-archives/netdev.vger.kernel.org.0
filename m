Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2DE6F20B3
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 00:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346605AbjD1WIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 18:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjD1WId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 18:08:33 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19F5422E;
        Fri, 28 Apr 2023 15:08:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHv/C6yQdb0n+z91ZzcPgyXbYnF4tb2Te42IdGIJXWGRg8EZ9Zx/mUDP3wCn7BhtBjU0DGD7g31i5vNAceoDVCef0lF55tdpJ8ThT2yAHBNqTJxGdiih1dpuB20yXsFUCIdMlgjNek1WWyZxgYkTZ6uTkevk63qnDWKzAsr+F+dvpJzKph1LWlUfa+C09+kt1o7lRF502RHaOmXLjLbDJ4fbvlO/1VOw7yU5DyXAjHKzOS1bTCTIjPO48ATk5eowmf6eD9YA8XFbShWvzpF0CDznSz7scPlUmHh9G+ib7JqJzyJnZpRAz/9GTQL/iacAHHNUlIGlgXtwTlULDPOyEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5z8TJXwyb3mnXizR9c8Id6btlCGOcsfw4G9rX7t1O2c=;
 b=d9xUlemCE6MlWohJigTsTnKxKnl1Jp/1vXeo8v+SMx4GedaAMLcIPJU7iFLGAjnm32YWhWs9ryLeZ/xNtIaXS9iMLLskxTWV94or6RW2EE/BA6iJ/nxQO5k6wGlPWHtzEIZ1MDs86kcbjj+AG3I1D1bOU9zkwOXzvDNO9DMQ3MWaK5Qh8nX2QyqA7eHZe4KtNgZA96y8KpyBXXzk+MFL0OUd9kRuM+Zj6ZK2MyN0xf53VGzLFTCIRvJtJLnmUKjveeG8eJt7D16IdNf6KE9Fc4uwaxvffJg5A/iw6K8Sc3tkgVo2Aq+a+SZkMMyONg+4DFWF8KplwxJ5Mu1MBdygDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5z8TJXwyb3mnXizR9c8Id6btlCGOcsfw4G9rX7t1O2c=;
 b=V7HJ2EXogOiSnCMignZAqxKqi/z9HG0xr3o0mjPF8elgC1oBKwdYMPJYtP1VbK0msuQYad8ATXVxYuizHpUdhCgi0NRCBD/uEahAoNlUKOb2zLiX7n2JQYM9VQWAm5PNkPZ82K4qMZY+QYYyc7wrhOk+iReV+NsBkJUinGI0GYg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 MW6PR12MB8951.namprd12.prod.outlook.com (2603:10b6:303:244::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.24; Fri, 28 Apr
 2023 22:08:30 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc%5]) with mapi id 15.20.6340.024; Fri, 28 Apr 2023
 22:08:30 +0000
Message-ID: <667f3a20-aaa3-edd6-8769-7096649c5737@amd.com>
Date:   Fri, 28 Apr 2023 15:08:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [ANN] netdev development stats for 6.4
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        netdev-driver-reviewers@vger.kernel.org
References: <20230428135717.0ba5dc81@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230428135717.0ba5dc81@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0169.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::24) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|MW6PR12MB8951:EE_
X-MS-Office365-Filtering-Correlation-Id: 586ee5c1-9f6e-4194-f4f0-08db483519a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mI3yG/vEWE5GVEmJ9QRm4SBLMa084Ct8xQFoQoLfr7g9B1DoJ6jBLOMr4uyw4Q9DqwkqCivtY5t+7gqmjDNZt9hbffyWVLppl3vYXsjP6nPsPWm6hETB0gOZ97/LAZmJPoaZ7Ou9XE6g53Z1JmOgTuldKzret0WVag//Fzf6smQrBCvrVDXUoarLb1do4yeAQiVHTgV9CxSvXLnoO6o4GjnmJimd9eIDmZUW8S6L79ogthqygngurFvKSKrSuKqechhmVR5sr7w8LysAccXm/aN4cvLQuawgok7g8sWoKIGTd3zJmT2TTuYMOU74S2wG4O4E5yf5+vY6+vgkAbCVWMXMIdyO1dgQsAxJCdmG9ouWNWuSiURZ3yDCIKCC9QReXnFRWVHkK4wRIKoplHDQtd3IFRaQ6OVreTkRWTblFNXn9TGBAC2LgBtZ4Dt9WJ2I6yeqGaAo+pLjMqJWEMdIX78ZGi6SI7l8BPH2+DufxUlMB+FCBYt7dCVyNFCcrIGYinQ+/mnn80gV6Kv0+fyrLNStQ/ntPRsVSIT9iiIV7knmPkIiAjEyC8MFr2ROawio2q/kGKjR7YsxuDvFzMlwnUdRX5yl4V0jRu+yNmir/sHPip0bT9tGhSDdepwnPuzs9HdLezfILPtYAup8N5KX4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(376002)(366004)(39860400002)(451199021)(8676002)(8936002)(41300700001)(44832011)(316002)(66476007)(2906002)(38100700002)(66556008)(5660300002)(31686004)(4744005)(66946007)(2616005)(6486002)(186003)(31696002)(36756003)(86362001)(6666004)(26005)(53546011)(478600001)(6512007)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1Ird1Zta3NBOEFublVyLzZoNXp0dExrQUZDcU9ycGk0TEhwbVorUWVnamhz?=
 =?utf-8?B?SkhOUmJSM0hXN3lJK3ZzOWd5MmVuMlNoMFJ2T0h4c0JvVnRpSlRxMVhiV2lK?=
 =?utf-8?B?a0wyNklzQjdzc2NDWkNNUytLQkw5U3FyREx6bmZaL2dBVC9rVGFUd3AxRzVQ?=
 =?utf-8?B?RnQ4NUtDZHJLT0FvZTVUNU1ZejM2ODRzZkhoeDNiZTRLajVxakloNGtZZzhM?=
 =?utf-8?B?b1pjSGhxMC9MdFRoTHdIY1Z4WFNTZWEvQ1BJMGo5UWZnTUZNd1lQRUdlZmox?=
 =?utf-8?B?QlNrWk90SzhGQ3VqRytkUXkxWnd3cmxRUzEyMFAydjBQcGoySzdubEV1aUZZ?=
 =?utf-8?B?QVF0d253bzgwUmE2RXNocndkcmdCdHMwNDBRUGxJU3dJMVhjdVp4aTlFaFVC?=
 =?utf-8?B?dUVMbS95ZlV5ZTYyYUorYU1QeTU3REwrT3FtSyt6c2pBdFU5aThFVmxlRE5o?=
 =?utf-8?B?cDZiRFE0ejQ3OHdiN2J3ZVNpTVdEMi9uQlBzN1NwN2VRNDQxRGFFRUptampn?=
 =?utf-8?B?TWQ4dlNCQlJnVUI2dFAxd0EwdzZrcU5OanpKUmVlU0o0K2MxbC9QbVRYRXh3?=
 =?utf-8?B?NE1zbEx1K2plRGJ3MXVLejNmeUhqdnNUTGZQaFZVa1I5R08yRWNNVGFDeXdU?=
 =?utf-8?B?WC8yYnErVGVtc2djSXo3NHpZVjJvOWpvK0M4aHZqVjdrK3RBQm9xZzhwaThi?=
 =?utf-8?B?aHFoc1FnRXdFTkpQNmE0UG1zMjlSTWJHN3FTNHhIS1ZNQTBHcElHWFhscjhU?=
 =?utf-8?B?RDE4ZEYwVWVBbzlPSFMzRGxtemN0SUluM0k0YmZ3WWJFaEdDNzB1YWJOZmZF?=
 =?utf-8?B?TjduYVNtMXlpU1lhWko1WC9yb3prUWNTbmdmUE8wK2JFVW9BWHV1SGxGQWpG?=
 =?utf-8?B?czU2UDdqYndWd05MTXdvUHMwSHJCZml1MVprWXhSV2E2VFdoSXpXZ2lHOHZy?=
 =?utf-8?B?NlRFTXQ2eU9UODNVNHRQMnl6dS9iK2FweGNyQXRaNVJIWjBxWStOcklicDRn?=
 =?utf-8?B?WlBxREp5SEN2RU1pZnFlRmI1Z2lnU2RnRDQwK3pYd0NGNUZhMnBaYzdrVmU4?=
 =?utf-8?B?MFBhaHNJK051WTArcTdDek9wN1d0VGtDdjFsV1UzeFV1YTVGWmdCQ2NaTW5L?=
 =?utf-8?B?c1hnc3Y3ejVFN0ZqR2RkMWoyb0FIaEpGdEd0WlQvWm51SGRBT2FYWHdvTXMx?=
 =?utf-8?B?TnNxbUZnN2hWWjBKbWxkVHJMUWFERksvaWhvR3JrNzYvUXR0MWJMdlpIZllC?=
 =?utf-8?B?Vzc1dXhyVzBDVHQyRzZDWUticUQ1WEdyNjhvMXhKMGRBV1dzeHZEOVhZN25E?=
 =?utf-8?B?RE9NeStBL1FkL2RUTVFkUVhsOXBZaERFSDdyMU5nZUEybURwME5ITGJPU0d6?=
 =?utf-8?B?a0Q4VDBqdmJkQ0VOVFRhWEx2cGlaNUtKZVo1ajlxOS9uQnlETE5tR0YxZjZp?=
 =?utf-8?B?SGgwRDN2dEZrOEo5K2hmQW1rK25NQmMrOUd6c3h4eWd5NktwLysyaDBST1B6?=
 =?utf-8?B?ZGRRVVh0ZHljdFhUekdlVEk3TmRnaVZsTHpMZVBDZFA0MVFmMXBVNWxNY3Ew?=
 =?utf-8?B?ZXZGczlqdnhHTGRWMUljby9USTE4Z0ZPb2J2TlpBdjREVVQwOXdyMU9ESVM4?=
 =?utf-8?B?dVBwMXpCYkJ4elRvcFlaRlRwZWVSTk5pNGc2RUlqSXVtdzNkOGpsclc3RXpj?=
 =?utf-8?B?Vjl2ZlhTOUl5Zm1vMVVVTTB6aWdHMHpwU2lGdUI1NlM3UHdOam85WlFhMVRm?=
 =?utf-8?B?aldNMVZaR3NXZFJVcnd0UXhXaXpNY2FITTRESkgrcHY0QnBwM3dGNE1WdGxv?=
 =?utf-8?B?aE1NQm9QelJWYzhaR1lDMkFkVnhWV0RnaHZiTVFrUU0vaUpiVExXeUdKWXc1?=
 =?utf-8?B?eFl6ZTUySXpFNkJVRzVuV1VDVitXSU9Oa3RiTzNoTVhPSndGT09hcnEyQi9s?=
 =?utf-8?B?VGhqYmYyM0xSeVdyRHdFL1NQR0QrSjNQTWg5SHRQZ1lQdGFLRFR3N2NpVWta?=
 =?utf-8?B?eE05aFJUSUVFcnpPYVkyTm5rL2o5b3U3aTZHWWZtQkFVcURYT1Fta21RcGll?=
 =?utf-8?B?U1U5L3RjS2l1a3grMVQ4azlOWkI0L00xQnBGclVNaXNIUmYvYWdJVE1QMWxB?=
 =?utf-8?Q?FerX290aBnDcnTbPSG8USiQOd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 586ee5c1-9f6e-4194-f4f0-08db483519a1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 22:08:30.5508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lb3PPW1tYxx2fncWRL7hvYxNrPjPnKRA8chQpqH+WOnfIFCMqTDWhcDgsLfsVDflMljiq7giFB5aMwGh4V7Z4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8951
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/23 1:57 PM, Jakub Kicinski wrote:
> 
> Hi!
> 
> Stats for 6.4 are here!

Thanks, Jakub, it is always interesting to see an overview of what's 
been happening.

[...]

> 
> Top scores (positive):               Top scores (negative):

[...]

> 
> The positive participation scores reflect the reviewer activity.

[...]

> On the "bad" side the only constants are 

[...]

Can you give a little more description of what is being measured in this 
section - is this reviews versus submissions?  And what are some ways 
for a company to get out of the wrong list?

> 
> Histograms!
> -----------
> 
> I was wondering about the distribution of "tenure" in the community.
> Are we relying on "old timers" to review the code? Are the "old timers"
> still coding? Do we have any new participants at all?

Is this relying on the .mailmap for finding longevity?  I probably need 
to add a couple more entries here.

Thanks!
sln

