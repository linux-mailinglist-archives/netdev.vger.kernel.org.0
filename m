Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EBA50F35D
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344436AbiDZIJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiDZIJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:09:55 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2053.outbound.protection.outlook.com [40.107.100.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF18A4617E
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 01:06:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kCV8ZO54t/1pSNFk3TKaP/KAFk3ZJvOjyMWBzRtAZ/o5F1hIYDViLpYxmPTXnthMs8fDe1qfvXzs+AKmrSZen4lFXHEopyLXtD3y8cyyEv29qarw2JgetVk69RTbhijMeyTa1afxNF9etPH0X7+CqL593dzVKAhDnrMDaKY/vhb7dKKnJtxaDHvnB9F0IsIQdsER4IyuuDvW2qWy0WZ+hwY9LMmwfe+IPMAB+HINsPzlDuD3JunnN1yJJGOwvyy2biTkiHtDohR4EGKYiiIU/trRv/nF5KGL+IcWpVWt699YIZ+LOhJUylUxh6xGR71i6bkh6PSztQdZZbRm082lmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kNvEzuAdO8OR/N+5Qsji/+FS4St43Wx/ZlGR8PPj5Wg=;
 b=OvQngMgg0NP9vEM+8E8B84+YbtKZMTVJTyZDUaTJlU0zO0+TG1rdcQkLgnNcnBQlkjovffS7fljjIhkMtpriISo3VAgi0PvpL0Mzda/APCt6JdgWxDMPBSE/jRzwhMLpIn2c8+0P/3+2N7hK2udyvj477caumHZtsmaLcoa59DEij+gH4jG0A3dvbW4kFP6U+jI4bZ8PVMNwWmhmeiZpLjlMy91b+Au7zqsjYAxltIe/b4Oec5iFpEKXgOxQo0lDetrueV/PnGfpZ7j5gVwpTjhi4qDIodMLq2moQ5j6beg43oR08+ahR7xnTFT1PUTX3K2KfZ/iEERYrKyhyj3OaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNvEzuAdO8OR/N+5Qsji/+FS4St43Wx/ZlGR8PPj5Wg=;
 b=UyzST+C6xgeCIcbXnlytkEUW9+6wRoTSQV5M5eNkg6qHLecK9Cl1bmCqMWHYtc9AxzXpCj9wfrwqKtd/+7ptz4vd3iNWwdZ2pvHHJ4npSLHik4W6DFNRg/WeLCdFit/oloGbZfJUuOw5rPQqIwX1z02iZNX30m4rb5HWnflcv8G67XrpP9QiCxDpmR9xj91EuwkJyZHLV9Jo4EIGKqBTs6Zk3xjZ2Lf9MJZ7Y8mA5XPcZDgN9RUXhMLwjnHJFsRtDri/sU021vzzVZlMCBFwQwgXIYnVoL7foVQ4YHjlGzEb9imGIrkxxQy7waTH4ahDEQTtMJEaB67M1KNsh3vTRw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21)
 by BYAPR12MB2870.namprd12.prod.outlook.com (2603:10b6:a03:12d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Tue, 26 Apr
 2022 08:06:46 +0000
Received: from BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::dee:5e8a:62ef:3d21]) by BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::dee:5e8a:62ef:3d21%7]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 08:06:45 +0000
Message-ID: <1cbcb520-9b6a-02fc-fc11-84d2a541f851@nvidia.com>
Date:   Tue, 26 Apr 2022 11:06:37 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next] net: tls: fix async vs NIC crypto offload
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net
References: <20220425233309.344858-1-kuba@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220425233309.344858-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0024.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::19) To BY5PR12MB4227.namprd12.prod.outlook.com
 (2603:10b6:a03:206::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb2803a9-a042-40ec-75c6-08da275bb4ba
X-MS-TrafficTypeDiagnostic: BYAPR12MB2870:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2870527726B5B093B0D79318C2FB9@BYAPR12MB2870.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X8pYHD+13p33MaqdkZWdb//IEBTzvlcLlXIIdHey4VNRm3+cLgh+HH9VeiFeA7gD9WcAQa3WL+Kh1+xo5oYRt6GFhKqX0unSkN3FYXSA6CcpoTM3Rsh3jQIFnYS8mMIWiedgB6BuQqMaTTVYJoBRdzz3HKV9NQjAbGtDciKZdh431BNnmKRZ8QBzeli+8attasO6WLLNzEfjlg0IC9DNu8FA8lFqsoHLF/ddkFa08ZukTnazd+/GB2jonei5xoteKQUxm0ityhsNUbAxuL+95E8HE4KtHREsUVUfd2MUNi1z9h57gkV89vw5ybUrOa1GdcPaTgTbHWcjgBOyyyISjBtKRriwO2Jg1bpiHwVWLaeMBo0gIE/sFz09FOKxjsfzEBoT7FerYrOdLzWU5cxmvhnIGoBIjVPslweGhNuFe3q1+k155HxGko0OTtKIF+Hk+RYFlzgw1W0s/kOmYIoARA6EMlKCuAJ4eV8TB4i4Jubcz2HnZ0nPiHHsbJ7ArpvzY4P7K25Lz1hp2kq+vUiwWOuVyeZArOrTUE9mfgKkP1UOycBB12y9fT5b/NgZ0Ai7UTO7HIqlxid5kGRQn9FFTWS+qCZcQ0mplfomKRh7KnMGVPA6fB71jqqwwiVim1LpeKXxxSa+y3nqp+xatufp9ryByog5BfCck9TH56gh7aYHpEclnpSHjsW6aQdb2aR2G0uVtd5dQMEf49a4oYriBCj+Xpsokk6woBVAxBtYRMyim2RVz+WV4x2a7MFZMqap
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4227.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(6666004)(53546011)(2616005)(186003)(6506007)(83380400001)(2906002)(316002)(31686004)(31696002)(86362001)(36756003)(6486002)(508600001)(5660300002)(26005)(4326008)(8936002)(38100700002)(66476007)(8676002)(66946007)(66556008)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTRJSUxaMlJqRmV4SDRWR0VhQzF1bFVSZk5wU1BkRmJCRHhBa2docGx0cXJ4?=
 =?utf-8?B?UmFob0E2L0JvSllpZjFmMUp0dWxwcEIvb2xQbnllNHkxUTgvcEZkWnFoTGNK?=
 =?utf-8?B?UXVqRHJYTzZ0c3JrNWNvWHNXNHFqKzlXZkxFWUpnMHN0b1lSZTFMb0FjcGVM?=
 =?utf-8?B?UThxUjg1VFBjSmUyOUF1eWFzY3FLRUlEOS9EMjQrOE5CeHJJQ3NFa3h4V25S?=
 =?utf-8?B?Q1oyVjRPOGpHNkZWdGx6VWg2NmU5SGdyMkw3WUpjMk5qWU5TQUNlcGE3NkR6?=
 =?utf-8?B?eGNMcEZ6Tlc1S1lJdlZvWmJnNDdSME44d0dFTzdaeVFYMTdaM2VIRkQrdGht?=
 =?utf-8?B?NUZIRFF2TlJjNjJ4Zm5ISzJWTjV6SUYzTUVQYzlJZjY4S1RJaU94d25icUlw?=
 =?utf-8?B?NGZQRDJKUzZLSU5CeTVOaUxFcDhuSE5ZNUtrQ25FTmt3VCs3THhpdjJBRXEv?=
 =?utf-8?B?NmNKcUo3TWlSbE5CKzdDSjVWeUpadk5zZXBPSlVsbzlJS21nUHR0a3pKYVdD?=
 =?utf-8?B?UTU3YmsrK3RlT09sY3graWtiQWswSDRaQjlLUEJxOUx0dTRWdENNSWFqVi8w?=
 =?utf-8?B?UXZoN0wzRld6WFN3U256K05zbnNOMUhyQ1BXUjRFcUFsVm1mWnhyNVB5TWdJ?=
 =?utf-8?B?WmpjejBqYjBVbjV1ZTNoUkdSM3hxV2d5a2RYM0h3SWdEL2ZzR3NSYXlxMEJC?=
 =?utf-8?B?c3hFK0oxK2ViS0NkbkxhQXNqdWpoSmtIRXE5TnMyclZQbmJJODVBdE9pTkx0?=
 =?utf-8?B?MzdZZ2gvSzZmNWI2dVFiRlBnVXZoNTRxVFIxeXRtZVBzSlNzSUlXQzk1cCt0?=
 =?utf-8?B?aUQvVnJseWM2TUhybW5VUFN4blcxZjIwclVzK1FvbGFsM3U5SjhmSERwZ3ZR?=
 =?utf-8?B?ZkcyYlFUQWZ4QWZaOGhUOVRTcGxiaXQ4aEd4ak1jZWpBM2tvRFZ0eS9GY3pJ?=
 =?utf-8?B?Q3Bmdjk5S09JRXBzRjdmQk10UzdxYzVDZTZ1QUxqdEdGS0pBRlZycFZXZFhp?=
 =?utf-8?B?RU5hNERlMVptL2NTd3F2THU4emU4WGdScFplMVFCRy9YMFo1MGU2TTBkbGdG?=
 =?utf-8?B?eFpCY2hPei92K1Zpb0ZxMmorZS9qdXNvV2dHcE1nS1B5VzlRTlRITkRnSm9Q?=
 =?utf-8?B?WFptSGZ6SnlOR3hjTnllOFFSd0s0TUl2enB5ZHQyVTYvcjVMRHlDeDlsZC9Q?=
 =?utf-8?B?cFYwTnYydTBhRjNEUU9YNFpjVXVLNkdTQ2pIZmJsWE1qL2ZjTjhlQ3ZEUTZK?=
 =?utf-8?B?QXYrSWk5NnRQZFFSZ1drUHR5WE5PaG1hNktvczYvVkxhNDhrWXo3NDRVbENV?=
 =?utf-8?B?NzFvTzdxRmd4ak8zMmZDQS9WcENLNHYrYllCcG9HcmFyYTZBbGorVHdhMnpu?=
 =?utf-8?B?dm5PUTF4eDBhdUdGb3Njdm1weG9ZYi94eEVxeWg1RmNOck0relBqck5qNHow?=
 =?utf-8?B?ZE5HZEgxMmdlTHMvZC9BMWg3cndLbldiY0JzMEZCVlBLd2RWR0pLRWk5di9W?=
 =?utf-8?B?U0F5TUN3L0RnTGJNZWpPV1dHNlJQMzRXdE5BRzJLSjcvQWYraTd5TTkvUVFR?=
 =?utf-8?B?K3J0eDVUK2phRWdXVEN6TXg1U1BtMjRSaHc3MnBydnJDVkpSR0U3K1FPL3pM?=
 =?utf-8?B?ck5qL3k2SmhVMmJIUjRtVEd2Y0dJV1JKSHM4MDN3NXFnLzVoQlhCTXRmSk1T?=
 =?utf-8?B?RkFCWSs0dDZuckt5VzViRWpmZUdmZGdDNnhrZUttOWY1Unp3WFhlS3BVTEFq?=
 =?utf-8?B?NVN5N2poZjQyaDVWSWFXUkQza3M4UGtjdTdZdk1uSWg0TXJDS1d1QndvOVdB?=
 =?utf-8?B?V0RiRjVrVm9HQmZwZGNRMTZwSk9hbWhVRit0SGQzd3FvV1cyd0srQmsvNUc0?=
 =?utf-8?B?azlhNkh4NXFVS1lZUXl0V3dHR2VGWFcwVlNUcExJc1dpQ1N1N1I1NDYyK0RD?=
 =?utf-8?B?MDByR1VTcEJxV1EzS1JqWDN2N3phRGtSUzJEVkJQcE41MmZ5U0lyeTk3V2VC?=
 =?utf-8?B?M2RSNzd6TnZrbmdwWjQ1L2UrN0lPZXY5dUs3Uk5IKzF1RXlHQy92RGxORWZG?=
 =?utf-8?B?RnZlVWV3dFhwU0FVWXJJL0s4c3gvU2FRMGFCN3dma1RVeEFyb2h0ck5LZHlr?=
 =?utf-8?B?cUtwS1dGeFRTSmJRbWVBQyt3aXM3TE5qMGdlb0hFOXh2RFlhcittaFUxUWhU?=
 =?utf-8?B?SWw3UlVpaGhFbU9GMS9sejJEZGZENTE2a3dxS2piZkYydGQzY0V3MnVJSE50?=
 =?utf-8?B?S0JXc3lmRmJFZXhpTnZDa0RCT0FxODgrWjJCcHQ1K2c3UTJ3UVY4ZlFhUEFY?=
 =?utf-8?B?NzJ0V254bUFGNUJHZC9Gbk1TeWpCMXdCWUdscUVPUkJUU0ZEUE1GQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb2803a9-a042-40ec-75c6-08da275bb4ba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4227.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 08:06:45.8023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MUYwYEMZ/NAP3fZ9cB/d9Fw0hBJBsh5q4F2EA2BTIE7vCHMG1zcX6Lo7+qmuf+Ev
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2870
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/04/2022 02:33, Jakub Kicinski wrote:
> When NIC takes care of crypto (or the record has already
> been decrypted) we forget to update darg->async. ->async
> is supposed to mean whether record is async capable on
> input and whether record has been queued for async crypto
> on output.
>
> Reported-by: Gal Pressman <gal@nvidia.com>
> Fixes: 3547a1f9d988 ("tls: rx: use async as an in-out argument")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Thanks Jakub!
Tested-by: Gal Pressman <gal@nvidia.com>
