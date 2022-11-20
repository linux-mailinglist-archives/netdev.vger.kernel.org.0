Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2868631536
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 17:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiKTQnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 11:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiKTQns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 11:43:48 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2085.outbound.protection.outlook.com [40.107.212.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6251E28732
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 08:43:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpkfRjoDv3iiwD3spHUlu0v+RCdiP1BKX/lo4EXMI9cfTfmx/vOZViihnWCVpIGxX1goeE+PGpwGXFcKjaP0YFGolyqRtaiBvo3zP8UhhKqsrYvCpf1ERo02i1tlxfPqacaia+UZy9uJFJuWalTDr+yGOFSXCUToX6USWAJPrTpJAsFiz6RvEipbeDr21dJgEuhTmPU/2PI3MhPjSnWvFR7rpT+6ScBH9Ew97yRegn5iWGdPNvxwHXv3QFIAjc0xm78Q7UP1YgesEr8vTdX+L5hUBakuTMXTOnRLTuJycgO0EBm7+MWxOT5rhTx1MycRlU3WAyM6Ll4V2ancI6ObjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hNMr5JT2OjoLyF5+ACJV7GY43SP/WfyNNFTLr0W5E7o=;
 b=Z+jZqqN+kjzTR+bQVA+Dz2un4WHKW0rks0nVAHBtrHtOaHfcIeiaYgJ8WXnigIJyrloQONeHct5pBNgJTVwP7kyI4nOyP0Q5e7rU0jZVVUp9AEwe+IrhcpLbvosyOkbAVx8fe0tbGjvVmAJhEkEfXoljawxbaBx/n+7OowLYJ8z1zJ3MhEIRfs5cL3lErxg38ovWQbrt7JdK0ze10l7Ji/XWRV+HdlTgN+JoqzaXLwbAVDdtWp9vGwNDEAX0PaVLtuQj3nJ8NRuTBmv/I+nsZn01K5PRGfDvAcwizofH0vVIQ5mPyofFsLQaWptjC528sAqliNQrJxQRH8kKk72J/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hNMr5JT2OjoLyF5+ACJV7GY43SP/WfyNNFTLr0W5E7o=;
 b=PANbDM9v6r50OM6vdUHk/uJiaDAl3+qOh58Su3LEimGsgHUCqDaHvIJs+tVxCnDlm5R3OdKVcjbfVFOqa1LsDMqd1OUd+Rjws+dMYzRme/DI4EgKij1VkxFPWwGqOIvsygMcplXTBu1NLlcRsGj4KKkbf55aLddp0AyPxsx6JVPBuR6ke0Sa+eGVuVlKI3hd06+3F+V+OomuSM/1IGgBwOduJNc+1wWyLTm5APufrL6GpR8ah3CoKfvCXoWQFKgTIwsOGR2m0xOOQF/APEhYtQ4rt1mD/+aY+5GEl4L5rmK/NfDymOldO1F7jHILO51pmzmNNWt2TTC7cA8goC+ULQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 DM6PR12MB4467.namprd12.prod.outlook.com (2603:10b6:5:2a8::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Sun, 20 Nov 2022 16:43:44 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9%4]) with mapi id 15.20.5834.015; Sun, 20 Nov 2022
 16:43:44 +0000
Message-ID: <e1ccfefa-7910-ca96-9c7f-042df2265db6@nvidia.com>
Date:   Sun, 20 Nov 2022 18:43:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] net: sched: fix race condition in qdisc_graft()
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>, eric.dumazet@gmail.com,
        syzbot <syzkaller@googlegroups.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
References: <20221018203258.2793282-1-edumazet@google.com>
 <162f9155-dfe3-9d78-c59f-f47f7dcf83f5@nvidia.com>
 <CANn89iKwN9tgrNTngYrqWdi_Ti0nb1-02iehJ=tL7oT5wOte2Q@mail.gmail.com>
 <20221103082751.353faa4d@kernel.org>
 <CANn89iJGcYDqiCHu25X7Eg=s2ypVNLfbNZMomcqvD-7f0SagMw@mail.gmail.com>
 <CAKErNvoCWWHrWGDT+rqKzGgzeaTexss=tNTm0+9Vr-TOH_8y=Q@mail.gmail.com>
 <CANn89iL2Jajn65L7YhqtjTAVMKNpkH0+-zJtQwFVcgrtJwxEWg@mail.gmail.com>
 <46dde206-53bf-8ba8-f964-6bcc22a303c7@nvidia.com>
 <15d10423-9f8b-668a-ba14-f9c15a3b3782@nvidia.com>
 <9f4c2ca9-bc6d-f2bf-6c03-e95affb55aae@nvidia.com>
 <CANn89iJkdQ9eBkwmWMcf7uKwB=cY8hbwo2Jqdtwo3mpjswAFHg@mail.gmail.com>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <CANn89iJkdQ9eBkwmWMcf7uKwB=cY8hbwo2Jqdtwo3mpjswAFHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0055.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::14) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|DM6PR12MB4467:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c3fa5c5-49bb-4f59-1ffa-08dacb16637d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AoTk7YWio5psp6PGJAHFWX/QLQwTj3FdAQxaVU062xF06bCdibOdcLk8TTGzEP3DExoqeF+TjcY8chJBKROd2yq6066bRuVheb72Pw+iuCjJsXkC23a5/wVs8OZJo76Xb+pMN7DFx43K4lfH/xP93smHFoyhJBbyNtKhRgqdyQoX/Ja3wZVs0xmzq8sXQOD48HHrkX1VI5UgILhNTGUrabXJcLNdaTO7L+weGV6cBslRqygQ4mgzUpHsVnywPzaowG1hx3d4aBfQZW2XiLytdX1OJu6gpRMYPqD5nZkiS/wl9RVv3vjshDYE2/RHsOebOTUTMtwnEIhte1I6iK/zFDlWsrGICDAJ/6k4T3xjb9fB3VPpZSeESAMpBoswoN5s+fT6lXA1wYNDxuFlN78mbfkrqST+NZ1+1a5hkBCfiMSWnBLeUpgWFoQgBosnWOViutW7Oq39abw93OTROQ+wIaHqOlpBxogF1wcQTQOWPDYTQ0Fch8gFfjYeul8uF8OeLq4k/YPnPOFVa9gBsCuXltMEkmXYDPph4JuhTwjPAVptb2HVWyoyfdyGI6fs6qXwev0twqHzbuQiEYsYTsamSUFeUCbdddkwRAhYh6lmnd2tKQ4+6+B+5T5HHMR5JTZhWSIpYMfgD2lRl3m6YGwXKTyr/OfmnVXoIcQmDqlY902ljeqz8aRa5m9m8vOKFFjDilMBEfl24KMU5qiDtTzzZZ4dTbefxuY4caBr9LZZFIM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(31686004)(36756003)(6506007)(86362001)(53546011)(31696002)(38100700002)(8936002)(5660300002)(2906002)(66556008)(41300700001)(7416002)(83380400001)(26005)(6512007)(8676002)(316002)(6666004)(2616005)(186003)(478600001)(6486002)(4326008)(54906003)(6916009)(66946007)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVRVNVdqQmZLWXluVks2eE9MOE0xTGNtRmdsNTJ5UklSRkRvLzBhMzFnSnBy?=
 =?utf-8?B?cG9iOFJSNWtuMm9iVnFCbUJzRGN1ZHdadWVhcy9scjZLMnZBT0hSSDFYVjNO?=
 =?utf-8?B?K3ozSmMwQTNiY0cyYXhwVHpERHZwRlA2ejFpbHk5NkNmUnBMZTdQeHBXbDN4?=
 =?utf-8?B?VkhPeG1lR2F5S2lhb0Q4Mm53Q2EwZnFnMTAxVW5OV0ZlRGpCNTZWdDl3M2lI?=
 =?utf-8?B?WGs1aVdJZUpkMWZaM1NxUi9TWHo2R1VHTXYvZytydUlOejVpY2FjaUhqYkQx?=
 =?utf-8?B?bE90VElYaEp5NUJTNm0wWnM0VjZLbEhRb09RR2pjUUNYd3pRaUlxMFY1RTJi?=
 =?utf-8?B?ejhHUW43UWdDMm5hemJlQWQzd2tzQ1JkM2ZkcnNTbGVHUXhmQXpjOERFSDFl?=
 =?utf-8?B?TldvVU1lOHBPR0xRVXNSVlhQRkpvbkRjMm05RVdKTHNRV1M0TndOWldSeEdC?=
 =?utf-8?B?S3czT0hjUGQ3MzhMZXk4L1ZhUUhCT2pNcGcwMldiZzRQMkltYm9WM25tLytX?=
 =?utf-8?B?Umd2bTY4VS9kRkxlV3RMU1paOHlGdStOM21jNEQrT3EwKythMW4xcTBWVnhL?=
 =?utf-8?B?NjB4TFFseVZRd0hvTzFMY3pHYXNKVUYrRHp1eDdFYmxXVkU2WmQ1aUxNVHJU?=
 =?utf-8?B?ODZyQTFYQlNoOTMxdVRIbEZhY2JjdExkaUxlOG14azhEWHBPK2RYVDBCOXpF?=
 =?utf-8?B?RXJvQzlNMUV0aC9kOFhBd3FOODdKd2c1R2Y4Ly9qelRKRHFUQnlrUnFrOHRz?=
 =?utf-8?B?OU5pTmlmQWVTSHRpSFpUWksvd04xSkhCSmw5NUE4NWNoQjMyemV3MHYvOWhu?=
 =?utf-8?B?TmZ2ODBUY01odWVIMFR0eWlGcGcrMzBUT3pQUUJTTUpaTWVORTZBbVN4ZGwv?=
 =?utf-8?B?d29oczdMc1hJeVRQalYydWIyUXJFSmVWRUtwSU9hYTY2QWtzTmJQQSs5b0c3?=
 =?utf-8?B?b0Q3Z1pBVE1XQUJ6cVBGY01ldmRBSFlyaUNuQy9XaVdNdHJZdFRKS2tzdDZk?=
 =?utf-8?B?WnJiVk5lT2Uvem15SWtmS0tRcHBxVEYzblZNN0N2T0dvQmVHeE11VDM1N1FM?=
 =?utf-8?B?UGdNS0hDaFczVGNHNWNJVUFJc2Fjb2N4WUVJQnpYTDY3Rm1lOFh1ekRoRUxi?=
 =?utf-8?B?NUdQZjNNRk9jSUZ0MmRlOUo2cVprK1doa3BIZDZYNWNCVmJRNVF5cTlYTm9p?=
 =?utf-8?B?OGFCeGtGK0thMktmL09HT1BKTUprVUNzdVBjK3JpbGZkeVBrU1hkclRtZUZQ?=
 =?utf-8?B?TmdESkdXenl0ZUh1N0dlUE5mTlpMSXR2T2R2c3A0aVpacUx5UFhETXlRLzcv?=
 =?utf-8?B?L0pxNGdINjdqOHNCTVVreEViQlN5Q1RWSHNSZU14UVkvWlJIMW1wd1hXNVRN?=
 =?utf-8?B?N1dQbU4yUVlycGxwTnQ1STlpWndlUUdnTmpHRmxHZWo2RE1RUHorY3pmVlNs?=
 =?utf-8?B?RzJPKy9SUTRleXMvemlvaTNRanpWdmltamVpZ1JOUUdZTWZHNlJqMjFUU2Yw?=
 =?utf-8?B?ZzdLNkEvY3FoQ1ZqcC9sa3Uwa0F1UU1SdEpINGMvNVA2OWx5elRwWmRzUVAz?=
 =?utf-8?B?YmZmTjZGWmZQOE5EVVpLcjkwSFAvMm1kYVJWSVNQSjBTS3F4cXF1azBXUmRy?=
 =?utf-8?B?QmVvQTl1N1UzUXNjOG9uakxnTkZQRzJBbVdFWUgzVzNQVjNXZmJQNExoOWdp?=
 =?utf-8?B?VlBiSzRwTlRTREhMR1grL01iQU5GYk9NN2tqK3pKUGZ4LzNFMmZtN2VwYjVh?=
 =?utf-8?B?cHlWWWpCaFFOYzQ4YTAxNkpjMS9pRW5RVGRLMm5xVWt0dTlNMTFpOFg1Qnhh?=
 =?utf-8?B?bUFoYjVhSUNIUWI0RzBKQ3J0YzYvTDVVdHBSQ2R0di9lVE11QzQ5Mys2M1N6?=
 =?utf-8?B?WkE4YUV1N1AzODc5akl5c2RPTFJFQXpLYWFOYUNkRldXQlJpamNjMldPNlcy?=
 =?utf-8?B?S1JTSU9XdFlpMWMxdkVEVys0WU5rOG5BSDh4WGNzSHp0cEFEWG44b0d6TjAx?=
 =?utf-8?B?dU83N3hpY3JoSG9MUEVucjFMeDcwWGlmc1U3Zlh5N0hRdG9KUEc0UWVaemhI?=
 =?utf-8?B?bWo4dVY3cUxzN3MxcWxaTlhLbTNxYlZvVEZMOG80anpWay81OVVNZXRzSmtZ?=
 =?utf-8?Q?LrJZivzz4r0+rEyulQxtEiK7p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c3fa5c5-49bb-4f59-1ffa-08dacb16637d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2022 16:43:44.7240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g8DrllWxA6vjWkGK1op0CgQACWsH364mQkpLVCq7zpkYE72IvtVEHvWeKH/Vk0ah
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4467
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/11/2022 18:09, Eric Dumazet wrote:
> On Sat, Nov 19, 2022 at 11:42 PM Gal Pressman <gal@nvidia.com> wrote:
>> On 10/11/2022 11:08, Gal Pressman wrote:
>>> On 06/11/2022 10:07, Gal Pressman wrote:
>>>> It reproduces consistently:
>>>> ip link set dev eth2 up
>>>> ip addr add 194.237.173.123/16 dev eth2
>>>> tc qdisc add dev eth2 clsact
>>>> tc qdisc add dev eth2 root handle 1: htb default 1 offload
>>>> tc class add dev eth2 classid 1: parent root htb rate 18000mbit ceil
>>>> 22500.0mbit burst 450000kbit cburst 450000kbit
>>>> tc class add dev eth2 classid 1:3 parent 1: htb rate 3596mbit burst
>>>> 89900kbit cburst 89900kbit
>>>> tc qdisc delete dev eth2 clsact
>>>> tc qdisc delete dev eth2 root handle 1: htb default 1
>>>>
>>>> Please let me know if there's anything else you want me to check.
>>> Hi Eric, did you get a chance to take a look?
>> No response for quite a long time, Jakub, should I submit a revert?
> Sorry, I won't have time to look at this before maybe two weeks.

Thanks for the response, Eric.

> If you want to revert a patch which is correct, because some code
> assumes something wrong,

I am not convinced about the "code assumes something wrong" part, and
not sure what are the consequences of this WARN being triggered, are you?

> I will simply say this seems not good.

Arguable, it is not that clear that a fix that introduces another issue
is a good thing, particularly when we don't understand the severity of
the thing that got broken.

Two weeks gets us to the end of -rc7, a bit too dangerous to my personal
taste, but I'm not the one making the calls.
