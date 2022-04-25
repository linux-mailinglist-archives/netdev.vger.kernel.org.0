Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3650050D9F9
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 09:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiDYHXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 03:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiDYHXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 03:23:02 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8C46420
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 00:19:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuLnoo1y1qRP9F5g1OT7GRbPfsNw8FT/2+f+qi8srgivhXOrVX+ODIaXy4G87IFwO+9QmVCz+fslncpDitroRpCmCU3KeDIoLp7fOEhXt0IPyYTFSJtPbW/hMDnCpXumRrdG2C83l8sythgN9jbDb/eqZOT++i5sEg/7QEI5s3JhIptkK6qhwi9A3+3GX1DfBx+TGqtFRpnHpNWpBDin1LbX+b9iAxE9JWCrexBvjqobS6GJ/h6OHXujCcVhPXzHT4CeZWJiTCxCnlufDhBkKe6BZvUUqTlaH51kC5+vtWDd09iUvyIFS+wzU4oO2lpfbu7OZqBqFcGm5/M9hugtCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iUzGqJ+IBDCWcLFJfRBdaG1rhctMauuv77+MBsNIeuc=;
 b=YtS0OGEwhJvsZFFKsLq5AnaFMzCo1DDI8vpFfQB1swTM+ZIV8jsnOy1cEUhZox8WOhsJg7gZERwm8D3gUDCRWuR+WTnHoWnfdC4uCbjsjldEVRNwm+nHvEF1gUbAOG1RaAbYxsLBBb1qS0TTqm7rvr17nwgfr3UT//43gjshNTs71ojPa5fH33nNls4LfWM/KC3jgfPjuhMmRJjisqBVV+1J+VHbgMt4Q0rlMnR4G9ZYMr0bBit2GKqysi8glGCBUFjh/KloRoz5TpM7POCD93jQ5QpY0zmbwpMVmy5EhlPdGEkFfEbfAPd0cUx6Stgxnmbo2jm8XOllhZ1jO8memg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUzGqJ+IBDCWcLFJfRBdaG1rhctMauuv77+MBsNIeuc=;
 b=I9O2eTka2KE3XPNLOu9D2OQ6pWc5S4zQaZmeqOw4UqMD0iw+wn8r6yqxm/fJ/udI/d2coiroJre2xb4QbJnGLWUL68yBkOR6B5Gk0xGEQLtpCJMN6HeZgCdqVh1G/6isnWWLup4KBjGrYWY9Nu6XzUYGv3NLX5GrQZ/jOwyR8jTCIpSqdlM3QdU+kACg1iPclsi0kwZOURuvWXEaDYwJYJWODIUor8ylWPoDaAUZ15AqncNn/QNiRBQ9Ffyyz5qUfdCiukFujlETDEcMEWeA5+Darwj4M7AQeWzTqXRcnxR62HGp0J0FVhCb4Lq6r3QnVLXtHhfGeD9RbaQ7EToDyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21)
 by MN2PR12MB2973.namprd12.prod.outlook.com (2603:10b6:208:cc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 07:19:57 +0000
Received: from BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::dee:5e8a:62ef:3d21]) by BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::dee:5e8a:62ef:3d21%7]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 07:19:57 +0000
Message-ID: <01081d46-249f-a081-f130-e0a09180d4d3@nvidia.com>
Date:   Mon, 25 Apr 2022 10:19:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next 08/10] tls: rx: use async as an in-out argument
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, vfedorenko@novek.ru
References: <20220411191917.1240155-1-kuba@kernel.org>
 <20220411191917.1240155-9-kuba@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220411191917.1240155-9-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0325.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::25) To BY5PR12MB4227.namprd12.prod.outlook.com
 (2603:10b6:a03:206::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 108c4fa9-d7d9-4aed-fa04-08da268c0068
X-MS-TrafficTypeDiagnostic: MN2PR12MB2973:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB297325AC5FCA0A408EE7D2F3C2F89@MN2PR12MB2973.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LR7NYA1kVYKQXIOH7gsx2xBot6lFr3GX1oX5UunmoXYx1u+rjSxEPJzNgjAk28oL73BRDGDbMKWcnYEakcY4l0YrYsX9wa41FEIhI4hDwm/6QRrl3XV0FLY+wmvVvXJHY+qlwptja7INie+D7OGAwj/xTPUzTtRXzM9ti+vJW6KDzPH00dKjyPXVLwlHvnU++aItwlTi10PfQCotW+vC59M5VHPVZzM0rZ9aIY/yw/OaNB8Wlx9kOXnAQd1tcDsdFhOkkIC6MyDmaNBgb5hTcVr0fAoHF73PJ1bSXuCfZXkbfQcKC7Zz7g9ObLYoWcJHmSWCbp7KlNYGBYjcM/2H9SDdhgMbkdUe/aQn5GJj7N+KwUiQjXIrF6ycvkkuQBZOpyuwA5khG3qjyn0HkhK9VP3BoD6Eo/GVbQNm9v7km6KHiTPH+2QyRqiwIAx2LzcNV62138PUkn+g9z9sTC7W6tOMzksMOSJ3RQ5u1NvsXp/wrwIuM8d72LOsDhlRymUUm6bl+nuhgAW0SUt5ugo7e7yPGlk6BLts4WJdFBXed4uFEYxJbzsZbe8uTkPDdTbA+xdITqM7dI+O0hxP6BH3mFOy1bZdpyKk9h+GsOlooO39Jv+tzbhg9ZoIUOz+hIDKiUGsOE4KtAKHK7ytiq8//beHA289VN7tjvYBi4QlMDyWogQYOm7vrs7yQJGVe8pNu4QnHjENlQZS+9nuRHZ9XMT5daohjW9K0QCI5oHF6Rc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4227.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(2906002)(6666004)(53546011)(5660300002)(2616005)(186003)(8936002)(36756003)(4744005)(26005)(6512007)(31686004)(83380400001)(6486002)(508600001)(4326008)(316002)(38100700002)(66946007)(66556008)(66476007)(8676002)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUJOdE5jRlNKT2x2NjdPb3Jaak9ESERPcVVRblNjOWhHNk1wL2pHdXZDOUNI?=
 =?utf-8?B?RG9wRFFTMEltT2ZlZ3VBWjRnVGtCanpPVndFeDRYTjR4c2RqZmh5YVUzbU1U?=
 =?utf-8?B?MEptYW5IZ2prcjA2SEtTcG9hUE1jYjRTbmFkSmN3UWZyQ2FGeUxKSUFmRnNM?=
 =?utf-8?B?T0x1UlFPa2JINkMveVB0QkFnN25TL2lESGVQeUUvdlNwTWxtaUxib0pabXA3?=
 =?utf-8?B?SWFkNFJsem9xdXA5Mytjck5YTTIwV3NiSEY1dDV1a1RBaGtlbS9ScER3Qm5h?=
 =?utf-8?B?c2lzOVpCcGJ5VXdXdWRKSnhnUjJKTnRzMk5ZMHQrc3o4Zy9aYktUemg1QmZ0?=
 =?utf-8?B?cHpFMmIraDRMTEE3Ym5HdFNwS09kNlhsYWIyOFVUWm80QWRla2Y2YWVXYU1I?=
 =?utf-8?B?aDdDT2dGK0lmRndGZVJxOEtxbGlWM29kWkxCaFFaazdsU1FRWmFKZDJUdmsz?=
 =?utf-8?B?VzFEL3NQV2lhSHBHU0pKMmRjUXZiMUdsbGp1d1JNWG0rRjRHbENuTFhUUitj?=
 =?utf-8?B?b2V6MnMvVTg4ejFITXBpVUllMGtiQmNBdnBBOFNxSzlKV01HOFVjUUNjbWha?=
 =?utf-8?B?WnFSMEloQTJOcGhlUnpZMW5PeTU3T0lIQ0VaSVNxQkdURWpPUmoyU0NYTEZN?=
 =?utf-8?B?WUNBZkxhYmsvT2IvZHMvY0Q2djg0OW52UG40NC9FNzZKcitMRmhLY1dPYmpv?=
 =?utf-8?B?U1Bmd0NKQmx2Y2ptRnhFdFV5V2E0anRjRHFpbDJGR2o0Yk01YU5HZ2puOUJs?=
 =?utf-8?B?MDBGL0dBMndxOEhpb0ljYkZXd3c4cWp6UEdMM3ZucnFhaURreUsrNStYb3Q0?=
 =?utf-8?B?OWtPM0lHdVpVV2FsclZDbFBQVFozZXJ1U2xPTEcxaWFJTnpTYkptZmRCWFBE?=
 =?utf-8?B?TVVnVmxscytYVmkxY1dnL1FUcmVPc0RHSDBBcUZOejB6VzNmT3hpc1RycS9p?=
 =?utf-8?B?eEp0bEZESHEzRmxHQW9lVis0L2VxTTR0VWFoN3BGejNRSkQxS3RuLzRZdURC?=
 =?utf-8?B?dzNMKzZta012NmxqMWFCQWo0ejVHem42WDlySXhDSEdWczRQRXhOYk43NEc5?=
 =?utf-8?B?ZDBKb1pTYmE1b2NHUkdyVmhhWFhOMzkzQTdxNUdPbFpCaGdiV1N1SDZURjBS?=
 =?utf-8?B?VDYwSVo2M1dIVlY0SXJ4eVJLYmtqNWQ4SGUzSUtWUjVpQW4wMjE5VDFPSVFQ?=
 =?utf-8?B?ZVI3UXlRUnR3NWU1aTBTRUN5QzNobE1PTjVCSi9JWWNMNnkwaVRWb016aTdj?=
 =?utf-8?B?OVlEaGRNSTFCVis0VitLbXdBYzNOUElpNiswMnJ3MlIybGNpeHV3Vnd3OWZt?=
 =?utf-8?B?MlNiOW91UDBDb2I3dkh4cjhJcnVTUTVzWUMzdXJ2enFuK0xqdlZvK2t2TG9k?=
 =?utf-8?B?YnU3V3ZEZUdUKzV2KzBtOEQzZzBxZ2FhZFJJdVBSVXBEdndRaW5EUEV0Sk9Y?=
 =?utf-8?B?S01URHlSOGFTSXo0OXpMY2xKcGx4ZmJJKzRpSGxCc05lbHpQdURXTitEYmhQ?=
 =?utf-8?B?dkdqZm5JNHFZTklCTzMvVEd2cExKQWp4d1JzU0U2MTFIa0JwSGd0Zm5vNnQv?=
 =?utf-8?B?U1ZBRTVuejF1RmREZUcvQU9TZ3Q0RUpBQ2ptOG5FTVhSR0k3cEYzYXhMZDJ5?=
 =?utf-8?B?a3ROQk80ZmtaUjRzYnFrT1JMZDdJVE92MGN2T05uTVFmc2FtRnpWNDNUK3NZ?=
 =?utf-8?B?ejBOVUpDSk5reDZhT1JpZ3lkTzBEVE5GbE9Wb1BzOVZIWHNBdDlqbzQxc2hJ?=
 =?utf-8?B?WTNFamRyU0Y5ZEVqODY5S1QvYjRhQ25URkw4MzNSOHNCNG1ZUlAyazNNT3dO?=
 =?utf-8?B?Ykp4SW12cXQ2VFozejN6aHVhTDI1US9meHkzQnBEenNXREphUDFURFQxQlp4?=
 =?utf-8?B?WkRacG1jK1pka1lWeHVQZ0xJRHdlWXdsN1hIb3BNSXJmTGFxZUV0MW45Rlo1?=
 =?utf-8?B?ZWZJZTE4d1FwbWtvVjJjcVE5VjlROVVzL0RyWU1wUTduNDVSNkx6TEpXRlRQ?=
 =?utf-8?B?N0Fla0plNVRULy9ZUEtqaGFCMzhSaCsrY0syUzJYMEg4R0hnRkdCalpSVFRT?=
 =?utf-8?B?b0dLTUtqeEtMU0RBRGdPYUpOb3gyQ2lIMjJQcW1LUTdINVE0Y05UZmRxMDlq?=
 =?utf-8?B?ZGdMNS9nMnhiWEcxSXJibExxYmFHVUowNVJ3a25aMm1wMUdYb3ZPZU54N1pn?=
 =?utf-8?B?ZFUwdHlMeXo4azRYZ2t6RU1nU2pSTEZyL3h2aXlEYndXTFV0ZkJWRlErY3h0?=
 =?utf-8?B?NURKd2lGYWMxTlZEbkY2aHRpZjVVVEtTUE1yTjFDN2oyTm5rL2ZjZUhOamVr?=
 =?utf-8?B?RHpZeSs3bDVxQmwxdXNTL1A3a2RhU2d1WkVCb0txODRudW13L3BJUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 108c4fa9-d7d9-4aed-fa04-08da268c0068
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4227.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 07:19:57.4877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eh793wDJudzWk3L/C43a1g06RwY8I/xay85FGrWzlld06XeYUu8xGofj8O5frbkl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2973
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/04/2022 22:19, Jakub Kicinski wrote:
> Propagating EINPROGRESS thru multiple layers of functions is
> error prone. Use darg->async as an in/out argument, like we
> use darg->zc today. On input it tells the code if async is
> allowed, on output if it took place.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

I know this is not much to go on, but this patch broke our tls workflows
when device offload is enabled.
I'm still looking into it, but maybe you have an idea what might have
went wrong?
