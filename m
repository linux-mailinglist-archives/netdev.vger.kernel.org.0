Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EA54C1443
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 14:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238580AbiBWNe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 08:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiBWNe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 08:34:28 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130128.outbound.protection.outlook.com [40.107.13.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6328B9BB83
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 05:33:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0xciNGnyc1Vr1C1n7A7MhZ6tNF7b3LQi/jH8cAmJ3qkciDBTHwHGrf6W5UIf+D0sAtRox5Vl9cCd/wIJmiyvTbWQLAeVxEx3t1R6guUxE4I5bzWjCvGQKRhq/E51WoOliGQYrM9v/pNHd97H3gy/uUj1uHxS6ZYyLTf1+kyMKIsJMzoBzSkBPKYBZad7AtDu5xbqizATDf7bu9z/F+u/lacye1dx+OWDwcBKhAhCK9RA4HSsv2jojbEPykI0cVrL8B4D9LzmACNaWnlD2Y45UobV+K8GVRYDJEOpEvw9aYrhJZpgRzSyTby/Om+c8UyIRBS6AhoIJCFXvj5lWQr4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7Pk5JfFYV2C3nB5qm/uodcEfnQEHFGCJ5uE1NZp0Jc=;
 b=agm97jL5Q66byKt9fKUYvmMjOApwm83XiWJP+P2eJj9DXNIpqBx4X1375pj/vADnzGpau+YF9l6NfJK1epRwA5eJjQMU8gP+3PZefGlCBSSGNIcdcF6CVHTY+zgcqnB4PhLWjRQ75yv0tsN0NsZC6k3clVO2g5a/is39W4A3VMGFrOJ6WwkTAFDIf9Uei46RLZ9ogI+ko0btqbAjc+tpj+trdZguB1kIUmlV7lvVc6h4tpyXOglOWKHWZ3o4zaGMqScVOdwhIpVJtDbkVy1r3CNW2uwYjrXQI9qE3XyTg4I3CXOlcmFrtEVSO6LbZXjlxkPqOEk+jULYU4cUafUITQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ugent.be; dmarc=pass action=none header.from=ugent.be;
 dkim=pass header.d=ugent.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ugent.be; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7Pk5JfFYV2C3nB5qm/uodcEfnQEHFGCJ5uE1NZp0Jc=;
 b=geAUadhjFeNOjWQ8xZgvxcKbXXYMTchitWwE9sXIKjwgtEZzAYShVE679JkpFgelkTIQd98iHw4hRRoJRj9OcDTiwwpNCqJOHuDzxKDoQ3sTeolKIX3rqejdRrjMFIHn+G8w21CWQMLvqLSZtoMDoBt/FTk6hEzhhH4CwbMgqLU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ugent.be;
Received: from AM0PR09MB2324.eurprd09.prod.outlook.com (2603:10a6:208:d9::26)
 by HE1PR0902MB1753.eurprd09.prod.outlook.com (2603:10a6:3:f3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Wed, 23 Feb
 2022 13:33:56 +0000
Received: from AM0PR09MB2324.eurprd09.prod.outlook.com
 ([fe80::fc49:e396:8dd8:5cb9]) by AM0PR09MB2324.eurprd09.prod.outlook.com
 ([fe80::fc49:e396:8dd8:5cb9%5]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 13:33:56 +0000
Message-ID: <fab6f644-6bb6-675c-3573-2ad5faa2d8d3@ugent.be>
Date:   Wed, 23 Feb 2022 14:33:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] ipv6: prevent a possible race condition with lifetimes
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
References: <5599cc3b-8925-4cfd-f035-ae3b87e821a3@ugent.be>
 <20220222164317.4c7f6bcf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Niels Dossche <niels.dossche@ugent.be>
In-Reply-To: <20220222164317.4c7f6bcf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR2P264CA0029.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::17) To AM0PR09MB2324.eurprd09.prod.outlook.com
 (2603:10a6:208:d9::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a72d4a59-3f5c-4be2-d53a-08d9f6d123c6
X-MS-TrafficTypeDiagnostic: HE1PR0902MB1753:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0902MB175378B4F4AA06A42E41BA44883C9@HE1PR0902MB1753.eurprd09.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ul3EdPKp7YrtgSr/SVY7HpaNwN750aGEppxGcYywxtc7NPgJdP7HEYwyVfHr9YP6Wc87FCyz0vHDvyN7RnySgunxjUWOjGJ2hjlUlsrN+7WHjEyvX6ZpA3FHigesKqCNajfKB05QQeqrEr4eIjB7eKVxXhzhVIh4dLRMEp5FVLpChS7ZT/dvGEisSIeZ0WFOk2yp9dGtgIdXcb+bW4buomlHnQiGhBUQlEf6bg1F6DZLbmXo475GhAh9r2X56Mce3siKs2PkNPvE+gHX/Bo8VwL3BQgPi/RGXROSuFBzg4NqFLiKgDe1USd0nARtd5XQQOg4Y9bxG5/Yx2tiFdLNctu4YIhY3yFIv3RsyFRJWWPsD+3AHHdzGhgpmXLiZXRC8Pe2tiUyZs6Q02Y59TOEPcaKH5ux+eNSD8m0LIa2zRe/Ps7CVzNf7lux2cePITKZIhgxNe8hye9vug1UUECTKcYkvMVxhrE+xZzHUhjo4F1QCdSB9zrnFD88ObnA0k5DYJrN5z95hoM07WUQr3vYF9fIxgs+2cu1TtiyH8Kom/23QE5hzs4tltVWD9VjyL0fQYUzqTuyqw5Wa2M8EoQOzu86Q5VMNydaZq+TWUyop6JOPjnIUGZyLnuSnvcf1nEu3MmPjtZZN8TBuum/l0etxwlxTCLfLMypQJgzJuXftpq7L3d+FcfzvgThRc8XpWv0gGgebZpONy/S6H58tQ1TST7giR8HyXcDVKbmxzraJGU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR09MB2324.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(6666004)(6512007)(66476007)(66556008)(66946007)(54906003)(53546011)(6486002)(6916009)(31696002)(786003)(6506007)(316002)(508600001)(86362001)(2616005)(8676002)(44832011)(83380400001)(4744005)(4326008)(38100700002)(5660300002)(8936002)(31686004)(2906002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXF0b2tjM3FIWStHRThsRWpqY3RWR1ZQVkVRdXNGQml4QmRwTVBqWmM2QmE5?=
 =?utf-8?B?R2hUYjFyRU1LUUY2SVBMOUUzOTg1R2Y4L1lrUyswT0hSRVNJZjd4NVJncHcz?=
 =?utf-8?B?OWQ0MGE2T1ZqZDJzRU1ua3NPZG4vSHhlaE54NmsrdFVGYmZFTWlyV0pLVUEv?=
 =?utf-8?B?bGc4OGhpSi9IZk5UUG85MVppRE9PL2tsVC9iSmJZVlRKK2FaS3ZkcHRERjJ4?=
 =?utf-8?B?UzdhSTRGMGFFTjNIdnNLSmJQZzl4YTA4RTJobzJDL0VyQ0JQNnc5cGx0MS95?=
 =?utf-8?B?cWNFRWhBVHM5R3MrdVAvaktnQmdQVEQ1TGN6cE5ENWVBUUloczhyUmd4dmtN?=
 =?utf-8?B?bzN6Q0xpYnpkYkllWGNiNWxnZjRXYXE1eVp0MU1WTWo1L0RlNTI4QVQwdnB3?=
 =?utf-8?B?YnVUai9lbTZNUmQ5QWFVRHRKTjIzRFFuWkg3Sm5XY3djZDIxTkdSclVPY2Y1?=
 =?utf-8?B?eU9jRmNpaGJIV0Vwc3pPc3I0cGZQUE9DTTl0WU54cGp3NHpsQ0dXekRrQllk?=
 =?utf-8?B?cEFGeDVITkp0dk5pT0MwRzBpaFVNUGQ2ODRRMCswU2VqMFZXVGw5V1dGS0lp?=
 =?utf-8?B?Qlg0bHJQQlJzUmxtN1luMGJpRDNWeGVCSkRJYkJZN1AwTlpIUExXaGdLZ3RS?=
 =?utf-8?B?cjVuTzk3YVVpM3JOb3Q2S0Uwcm51U2Y4QVcrUENkWGpuQlFyekFHYUhDa0s0?=
 =?utf-8?B?Vk1HTzVOZ0t5a2JvblpzeGVobWhEYkI2bEdPR3NnTExrM1docDJIeWJveTcy?=
 =?utf-8?B?TkhrQnhhOU15MVRsWEpRS3Nram5ZSzM3SG1aSnJQUUo3V3lRNExGR29kemJn?=
 =?utf-8?B?OVBuWkx5YXJUbGVFZFZvVGNtekJaRlY5ZjdFYWd6Y2I0cU1jVXBoVDBwb0V5?=
 =?utf-8?B?WlF3dnZ4QmNQTmJ3b1E2VG95ZmhWQlhkelBGR3o3K041VDltQTB1SG5Gbmhk?=
 =?utf-8?B?L3FiMitPWGQ2MWtzTG5PMTRzaE1SaUpiYWVXQks4OEZKMExTdm9tSHc2SDVh?=
 =?utf-8?B?ZXp0TUxWZWRqZEZPTDdueERkYmEyc2R3eFQwNjdxaEVwTlZYWTcxcmV5UlVL?=
 =?utf-8?B?bkE5WHlSem54VkRYL0tqbmlXK2Y5cmgvakIxL3IzV3VFbWd1TEZ3ZGh1anRK?=
 =?utf-8?B?RDlyR2hnQ2ZBc1QxUmQwQ3JIaStpRWNhRXRtYUlHT29JTjAwdmpPYXExMm1r?=
 =?utf-8?B?L0luYmdkdU9RNVNITEpLa3FVVm5CTXVGbnZkV3BDSmhON3JtSkhMN2thOEZV?=
 =?utf-8?B?Y25La1MrWndYMjhtaUdhendpb0dGYVB0SWhGS2NmN1dwZzdnQkFsZ0M5TFo5?=
 =?utf-8?B?WlNTbXJhWjFBSkNPZ3EwcmZKWERhRGtYc3Y4OU9JckoxYVRDUk1uVGlCMkcv?=
 =?utf-8?B?Vnd5dnpoaTh0N2ZQN2huV0E4cmxjWm52WHZOOG5iaFo1Wm1YR0I5eTF6VWZp?=
 =?utf-8?B?VmFxa3Z2VFJ2NmtqZWVvUnB6cHBPZUR5MGtUK1BwY0JxOWxCTDdwUFIrVzVV?=
 =?utf-8?B?UXFSQUcwRyt1b3pxQ1RQbHBoQWFma3ZRWjlnT1l4S2ZnZkxjQ1daTElKSzNq?=
 =?utf-8?B?b3V4NzJCdm4rUm5LaGJsVlFZUFRVUWo5UHkzdk1USTlwTUxkOWdrcGtlYTNn?=
 =?utf-8?B?UGRvNW15cGVsdXliMWp0WTF4QzhmaTNSZTltdFJXQWtveThJcDJEV2s4OUFQ?=
 =?utf-8?B?YnM1VVQ5dkExbFdOeDhqZEJ6REZDNHNKYVNoZ0lnVU5TcXVUK3dXUXYvM1ZK?=
 =?utf-8?B?b2RmSmxLekxxQ2VoK3FCTktlRXJTZEFmeEhvenZ6aU1OZVNpOEhzMUtHcVMr?=
 =?utf-8?B?L0pDMU41M2JLRUFOQnB1VW5Qb05pWjU3eTdseXpwc3M0ZkUwdGhibmJOSHlV?=
 =?utf-8?B?Z1FLK3lwNlpMRlpPTmNxR2JjdlpzSUpxU3FPb2VqZHIxVXI1QzAzK25CM05T?=
 =?utf-8?B?QThpZkRGOHNHdm9lUDVQWlMzTE9Wb2tsd29FSFg4alc1TnZMajcrcldvbjdB?=
 =?utf-8?B?K3J5TjlXdHFnanpiOTdiWkUyNXFpRmNvMUJRTXBIS2VNUUd5M3M0MWpCdVNn?=
 =?utf-8?B?Znh5b09DM20xc0dmUit3WGZyYTFoVTEzaUVxVit4NHVmZDM1cExEWU5JdjJW?=
 =?utf-8?B?aXZoOFVKWnJRM0QvZjRyWWpmNTZqMjVoenN4VmNoVGkzWFdXUmUyc0E1NDFE?=
 =?utf-8?B?RUlTb1VCTTk1TUUyZHZxQVFaSmFnQURiRjg3cGxPTXFaV2VlbDZzOVRvZ1lM?=
 =?utf-8?Q?EirZE2sGk8DtXtskK8DLeTrYSaQb/7eSQgGt35zo8s=3D?=
X-OriginatorOrg: ugent.be
X-MS-Exchange-CrossTenant-Network-Message-Id: a72d4a59-3f5c-4be2-d53a-08d9f6d123c6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR09MB2324.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 13:33:56.0029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d7811cde-ecef-496c-8f91-a1786241b99c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9iuBzo2fFfuR18Q6NsEQfeVOfeNxPbL/dLwRkMlZ1t7BcEtw5iKsT0yGD4RkHIKeZF1jFlHBJHQoKoJKiN8zaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0902MB1753
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It appears that the mail server of the university is changing tabs to spaces.
I will resend it from my personal gmail address, since that does not seem to
change tabs to spaces. Sorry for the inconvenience. Thanks!

On 23/02/2022 01:43, Jakub Kicinski wrote:
> On Sun, 20 Feb 2022 18:54:40 +0100 Niels Dossche wrote:
>> valid_lft, prefered_lft and tstamp are always accessed under the lock
>> "lock" in other places. Reading these without taking the lock may result
>> in inconsistencies regarding the calculation of the valid and preferred
>> variables since decisions are taken on these fields for those variables.
>>
>> Signed-off-by: Niels Dossche <niels.dossche@ugent.be>
> 
> Looks like your email client has replaced tabs with spaces, 
> so the patch won't apply. Could you try resending with git send-email?
> Please add Dave's review tag in the next version, and the subject
> tag should be [PATCH net v2]. Thanks!
