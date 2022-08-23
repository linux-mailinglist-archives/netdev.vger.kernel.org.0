Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302D559D1F5
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 09:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240212AbiHWHYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 03:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiHWHYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 03:24:48 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2059.outbound.protection.outlook.com [40.107.212.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253B962A94;
        Tue, 23 Aug 2022 00:24:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGvRJH3UrJCYJxJJ7ishAFycZZEJXGaK556+I1QT66Hk+5h7Eo1B476/XQNpj+wO9qFiojYGrFUcOh89kIQuNftJ5y5zy4Rnn/OzXkvbtO3Or7A7PZwqixHilb4t/7TaYnp62SnGEjE4bqvXvNFa1311EmXifD3QzLK8IZtUMuVrrhjvd0g0QKTB4gLNGZ747Ai/2Vfs1nAJ3MjCWQLf55l5EVsQIdyB2s2to+UFtmn4rGGBuyYkhuSw/jUR1xHTJuOMRQUkhp+10cVYIba/AyZ409YS+GWxTDDIqs1j1V7f17C+mHLV/83zieviRqe3+3JPGKmIB6HNi2tBRzn4rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+sEku82Dbcvg5O6a4FBAiTuhF4cRolUjE0Q0ZzxIAe0=;
 b=OoOKtPxIui5fykbrleoBXYnmltF8h/ABUbEgzyJQez61wciA220EBIaGt1CrbLJZaz+Z/9TTlper5ExAfEc+V1A28Y5nBXK25Rohh12eE8AdaBicC5jH2+4A+KRj7H8casTbZRxAst3OGPLiyeNs8uxgIbOokDn8r3j33MdqU0f22tt6nDeG3rLDBZcoiCIMH7Z70NgRaW7pdV8K/2xJCeNsWmMWsrC1sOlWx7/znrJ8o0m8ImpuYCubPA5IWHr8O9eQfk8ElZqZ6Gf9TY+jQQd9sxaqS/g5/AePIvIyxzuZJogKVQdhCmkwuGEyqg+5yICoX7iqKHCbm2alSbH6SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+sEku82Dbcvg5O6a4FBAiTuhF4cRolUjE0Q0ZzxIAe0=;
 b=KRUFwJDvmysHH5Eo2esSGeYAr/gS0mGplQsIJnH9AQ48U7MZJsBvkJ0KPFgUQ5klnmquvRKd1iBTPEPsLMgkNaAJlnX4ynJ6zweztWVPlnSdnsVYysP69lpdHgc7gbsq4J0awsNKETxGehqsmWvkDi674mQfCQxoLHtft+DAfDBvhsaCPI6zmv7oikOzC2Mo/KgOpxa/04+pAJuCtml4h9gP/HayiPjGt5C3IOUE9fIlCPsYz7zhFGi5TNDqCIBvZErys3FC30gCDlNlfwvjxCRrrAidOczX8wcbmlpcrWlx5FA6sZENUwjqf2/Db/ZrHOhuAZgC4oA22t2kGN4bRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by DM6PR12MB5519.namprd12.prod.outlook.com (2603:10b6:5:1b5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Tue, 23 Aug
 2022 07:24:45 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5546.022; Tue, 23 Aug 2022
 07:24:45 +0000
Date:   Tue, 23 Aug 2022 10:24:38 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <YwSAtgS7fgHNLMEy@shredder>
References: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
 <YvkM7UJ0SX+jkts2@shredder>
 <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
 <YwHZ1J9DZW00aJDU@shredder>
 <ce4266571b2b47ae8d56bd1f790cb82a@kapio-technology.com>
 <YwMW4iGccDu6jpaZ@shredder>
 <c2822d6dd66a1239ff8b7bfd06019008@kapio-technology.com>
 <YwR4MQ2xOMlvKocw@shredder>
 <9dcb4db4a77811308c56fe5b9b7c5257@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dcb4db4a77811308c56fe5b9b7c5257@kapio-technology.com>
X-ClientProxiedBy: VI1PR0302CA0023.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::33) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbcc84f5-cef2-4458-90ae-08da84d88dae
X-MS-TrafficTypeDiagnostic: DM6PR12MB5519:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gH3x8iFrPG27IEkLVJ9itvXOZ4zRBxnP3z4g76eNuqz3YZqjl5OHnmsy4xzQ1e21SpybeUV7DOxrhNtXbPbuqdDx/k/tQkhuZkuoSZH53wg1Y9bfel/Sk+nH+fdnKEpQLQyvZXpkqEP92Sgdi/SLNxhggjHvbf+QL5cN15cdbz+9FCKKiQ7kyL+tULW7uK3QssKSW6nz9ppUvQyoW6KFQPRKdNpP9p6iqbpoA+5xyOL0D3nA+6+OZ7/EI6pD62d0YT8n4EPIKZ19CbjQISPSZQ7r7GyEqbqIkJmy6l8DifqwKUK9t6ZYbQsqZHJCRcDZYCuzEbMqJWePHrSVk4tYarL/1STu4tt1LBUy4XhJQvyf0vPV0bl1RpcgnxcPOjBxRkM6eXbIRvKK+sgOofpiO2WmxXc669ovr5e7rmSew9RAw6eNLTNVU+xH1VSE0V/xsIbWSIkAa5jzfdhyR/PN7NbV0y8vvMTkOBaDc9DajgCAWlt1/zNOazqRaAT+YZ2jwn4iiZgbmToPSihQGArnfL0wcKpjC2BvY3uHnq2sUnLXyW9AQbOMoR2b1AFFhJRlPfCC/ITo1eX5vb5c2G+koujfBcJGeeoXcDmgf1JexC83/TQMc1etGc8bnK1lBlz3z4IwOgZp8uEXbR1MwHgZdQ9iEBUXJ7eCDd7QxXSpSFLQTQJN94H+XB3iCLcfWxSQxGEZQibE4sMG7PYsbM4yRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(2906002)(5660300002)(33716001)(8676002)(4326008)(66556008)(66476007)(66946007)(316002)(6666004)(6506007)(6916009)(54906003)(41300700001)(9686003)(53546011)(478600001)(6486002)(26005)(6512007)(38100700002)(86362001)(186003)(8936002)(7416002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?25TaRi5FLTw7hxUwP8haF7NTwS3vfZS0Wh368T1dOihphSO2Uea0dVOfc67o?=
 =?us-ascii?Q?Jw7kjdFX7pslWaI9OhSHuB3SS+Lb6PoxJ8l+bpmHgw2N//czQ7kl/RgFwoIz?=
 =?us-ascii?Q?MDy6OSuVFAu810bfFIJhxNKuyD4Wpd6j6DxXpXku3Y8Cupc/OYdJBYdBv9gt?=
 =?us-ascii?Q?RncGw1h6M6ToTAPEZ3RnUmRFXJUgciZV+uSWWD0hAVFkbyeYebme3JJx+bx5?=
 =?us-ascii?Q?X3RV2PW+UL4cgNqaA5b0LAFyKR4gqOameQsT9WDTW2GOXbnSTI8jXlHOEHkE?=
 =?us-ascii?Q?FXKu7+3vpoXulM06U7tTFMaeMd6b4qO3xsi8ezw5K11G6bUJaNdx82RWnLbR?=
 =?us-ascii?Q?BS1dBOmPx1DrqFyduwt6fsDzHQIuLFvmIpvI0KnibyJNceczRh3LAwyiU37O?=
 =?us-ascii?Q?w4QYIiZm2amUkDn+CwZRMKAQLV/tXlpjWo2h5NCkQhSPJmFm7pAO0av7Ihs3?=
 =?us-ascii?Q?GGjxhSRRcfDcYYhRoU08rF/9Gi8s9FMNRyxTVa8o/62JT4SnETfwrqLzqw7B?=
 =?us-ascii?Q?nJFKeZJyOc8b95r5RfbwWQqwSHAo9yW4pmTw4tlYabLtYBk8p4WBxniODbnc?=
 =?us-ascii?Q?zUNPAn2tZJG4Oq0VuQ7qVQYIBS/afn5mhJh6YhEXf1WzFwgE4OabdOwc4yEy?=
 =?us-ascii?Q?RgglLjHRFSKD9yPKri/lNn1qGEOFfbr8HgikWBoJWjON6wp5/BZ5YewCqI8U?=
 =?us-ascii?Q?ggUJbnrd6swBH56GWOWm1OLPkZOQcWmsjMmmS0Q+7IkV3mnqffTPltkU9PEj?=
 =?us-ascii?Q?ljOX5cbgW6YKRC8PL9tbmJL4mBZ374INUNP5Q7poK0UDO7izJYYqI79ckDgs?=
 =?us-ascii?Q?Ye4PtfhiZkWzCKfzy7DW9nRhwg/fMhYKrlAu5QzKQkhGqcF521x5F1lJHbK7?=
 =?us-ascii?Q?U0LuHDGQZVLx0v2lp/hHnz5JbfZso1sqiw6AjlS+g2cCGhf9w+oHnYW4Fsf9?=
 =?us-ascii?Q?VJoa95TisqUwtrvz+93zGGwIsU+VeSztmT12avSMYxCf8/ChN8ZvHpa3MNn4?=
 =?us-ascii?Q?nVsaFT+9qvhtYF9WIxUgQZwTXHrgqtYEjeJWZfQQtQGeUEk0VckC11WXsmqO?=
 =?us-ascii?Q?3ohsaHyz3N+h24shuAs3hNvZkl2/zvcjpM0IjFDb6iD3DOVH5fSXiQWi2oVl?=
 =?us-ascii?Q?xCjHA/WppxRN1COBJGwzHxpwMJcBftBiroTJbnU21AuuSEfV9edTDdYcvhcq?=
 =?us-ascii?Q?cK2i4Rai2uwLiOXnWf30Ad/UTPyGAgz/7kCQe2kj2o/Pxvhfezl8WXALApBU?=
 =?us-ascii?Q?tWd32U81I1czKyueiieb6yrtrw5C3tFfCg7M3meGxZaOtkxSaQzumBpRNmCB?=
 =?us-ascii?Q?s49jA0gUmEqqftPkPL78SgI6eHKg72xYz7bf77Z5z4kmlqayw3nt/OvirnSE?=
 =?us-ascii?Q?/9ePAOSxEKhTs/KzLzzD1KNpb8HcfyaFokzzaIAH5oZqJKhLu6MYJIkLTts7?=
 =?us-ascii?Q?caAE8xKb5xAhh9D+gzTfgpKyPQ74BEsFGbZPH5v5tPd2tTv84puASKxym1AA?=
 =?us-ascii?Q?DCJVODqrduLKIuEhU0MVHe6I9BkHTgoG11SGDGKLkstGuZpeNG+6pJjDnr/8?=
 =?us-ascii?Q?+676ctdIWoc1DscctfgWLEyihXTif+lfDlAU9gK4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbcc84f5-cef2-4458-90ae-08da84d88dae
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 07:24:45.2907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4ZCjY8QCRaXFlYKcmV5wNcfkP1IvsExmprgcLgUMDAQ8Hvko9W6/1sNd3PPmoTrr5CzlbsHWi5idYnD1gmbnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5519
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 09:13:54AM +0200, netdev@kapio-technology.com wrote:
> On 2022-08-23 08:48, Ido Schimmel wrote:
> > On Mon, Aug 22, 2022 at 09:49:28AM +0200, netdev@kapio-technology.com
> > wrote:
> 
> > > As I am not familiar with roaming in this context, I need to know
> > > how the SW
> > > bridge should behave in this case.
> > 
> 
> > > In this case, is the roaming only between locked ports or does the
> > > roaming include that the entry can move to a unlocked port, resulting
> > > in the locked flag getting removed?
> > 
> > Any two ports. If the "locked" entry in mv88e6xxx cannot move once
> > installed, then the "sticky" flag accurately describes it.
> > 
> 
> But since I am also doing the SW bridge implementation without mv88e6xxx I
> need it to function according to needs.
> Thus the locked entries created in the bridge I shall not put the sticky
> flag on, but there will be the situation where a locked entry can move to an
> unlocked port, which we regarded as a bug. 

I do not regard this as a bug. It makes sense to me that an authorized
port can cause an entry pointing to an unauthorized port to roam to
itself. Just like normal learned entries. What I considered as a bug is
the fact that the "locked" flag is not cleared when roaming to an
authorized port.

> In that case there is two possibilities, the locked entry can move to
> an unlocked port with the locked flag being removed or the locked
> entry can only move to another locked port?

My suggestion is to allow roaming and maintain / clear the "locked" flag
based on whether the new destination port is locked or not.
