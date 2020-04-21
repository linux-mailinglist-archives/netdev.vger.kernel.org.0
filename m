Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87EF1B1E48
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 07:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgDUFnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 01:43:33 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6142
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725385AbgDUFnc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 01:43:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/CjNW3AZOR35XU/AchnyRrDonNPrYReG4vjJPEZkLHic9YsvMeTDpnpW11+JIbTfaVA3ZNrWBr5DHS6DJOyOZn1xdp63pQI1nF3y3f0n1Mm38hpLrBR0mlpOcxyjZ+/G7zHgEeeGP+7GkLGCOgUILN98bmMYd9wggGuvl9HHrt/BsFujUOWC7iHCc6gPksCVfGoIBaS1ZyRQdm0Wyn2xCLR83jHHD8tW7Hu7Mc9TM6e+QsxsCeir8fDG4Lm4/7NGNIbJ0QjFj/DMdB7NjIKOw6alsCCnSQLbXpmVVQIPTe1MWNlgBaJkVp2QHYsKWLaHQsawuZES9xSeBwdm7p3vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/M/yIwTjCWlBI1EnCIoDCpZ73bPdYQAoLHoNUifeyA=;
 b=Ty8pE4y2FN+xGZAGCUSpXZ1yTlWk5zitVNCrjcEX9BtvrjkT966pa6XSkiaeybEnd9Lx78gkND91CP9ZNPctcZGdGVEOTYssCDdwneNFuSEYE4/VqMXcY9Oe9+hmHUOf0EAb81wGYPbj+Rf1HBwLyZ4pSwLLknSRxjhm1HDcktnQzRY9ooXjMOUgol09XFiHQLPOEDcyyq0y0/Q4+tIAnZMUby1WuvLwJunzTQWx5JguwQWieGZIw0XkBP2H6K1LxduV1LhyF9M7cfBA0f5gwOe3TnHGMLEBB6OBhcE5ZAsx8+g/2oKuxTYFCFjGItbWR8Pc3uBkf4UFmCUyU6qiaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/M/yIwTjCWlBI1EnCIoDCpZ73bPdYQAoLHoNUifeyA=;
 b=eGQkeiV2A85bz7zRlpfo1npyUOFnZFxt4WBDSwZ00jNDNvwhQ9jCtDDU3MdaP2a6eTkVmQ+qC1g8QR0K0H/OpkoahDp3L3hVRmi/EPIF8LP22XenyU+vffZcWgM81+E1ITB0+slDxNZNdK3U6vjo4x1LCY3CCeveZQV/tNIises=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=maorg@mellanox.com; 
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (2603:10a6:208:125::25)
 by AM0PR05MB4897.eurprd05.prod.outlook.com (2603:10a6:208:cf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Tue, 21 Apr
 2020 05:43:28 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41%6]) with mapi id 15.20.2921.027; Tue, 21 Apr 2020
 05:43:28 +0000
Subject: Re: [PATCH V2 mlx5-next 01/10] net/core: Introduce
 master_xmit_slave_get
To:     Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, leonro@mellanox.com, saeedm@mellanox.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
References: <20200420075426.31462-2-maorg@mellanox.com>
 <20200420140118.GJ6581@nanopsycho.orion>
 <a9e00f31-2f4e-1dfc-2464-d3d25376a4b8@gmail.com>
 <20200420175421.GU6581@nanopsycho.orion>
 <916ab047-3b50-7104-311a-6dcf604bcf6d@gmail.com>
 <20200420180144.GV6581@nanopsycho.orion>
 <75dffa6a-c14f-45c9-44e1-bf5b5c650a9b@gmail.com>
 <20200420184811.GW6581@nanopsycho.orion>
 <60467948-041c-5de1-d365-4f21030683e7@mellanox.com>
 <46f77bb5-c26e-70b9-0f5a-cd3327171960@gmail.com>
 <20200421053744.GX6581@nanopsycho.orion>
From:   Maor Gottlieb <maorg@mellanox.com>
Message-ID: <3a6ac4ea-bd8a-af43-fa99-fdc9f65fa761@mellanox.com>
Date:   Tue, 21 Apr 2020 08:43:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200421053744.GX6581@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: FRYP281CA0015.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::25)
 To AM0PR05MB5873.eurprd05.prod.outlook.com (2603:10a6:208:125::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.100.102.4] (89.138.210.166) by FRYP281CA0015.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Tue, 21 Apr 2020 05:43:26 +0000
X-Originating-IP: [89.138.210.166]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 15af35bb-81eb-4bf9-823b-08d7e5b6ea9f
X-MS-TrafficTypeDiagnostic: AM0PR05MB4897:|AM0PR05MB4897:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB4897470EF402B2B791072EBBD3D50@AM0PR05MB4897.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5873.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(2616005)(316002)(2906002)(478600001)(8676002)(7416002)(81156014)(8936002)(31696002)(5660300002)(956004)(186003)(16526019)(53546011)(86362001)(110136005)(66946007)(52116002)(31686004)(6666004)(16576012)(107886003)(4326008)(26005)(66556008)(66476007)(36756003)(6486002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: unMh1xcFcLFTUFdEaGw+23IDh5TcjnxpHKi7/uujG5tpd7CQWBHKJMaOxJprxZWcTeZw2L29hK0tJh6StQDY/XT8PtsaSIdVQn5cJtXdJHhRu/+7O54D+OXXgztqKfCMWebKjIRtlD2g+6JjziECFdK6guy6zyyZBiEChHBv7QzADMerwOVXHsLLm+mLs1ypGHPTI9XHU5/U5/6UKKXi1+ARC3IWkruC47Ki4Xf1JI6g0Rkw+H6wwBs8t0W1bZNS8DFCrY1OLJhVPrzJpzxgrLo7j3CfQaB5dgFHoM4pDOrYrxMQH8MUejjYMtuwXrvQN3viej4biGq3bOeg67vZFS8EBt3oPr9Pn9lOvZ8ecb+xS/kypD5iIu6UlNhxGo914+YmUdbTb/V8pNaB02NVtwFks/05XMQ0pvhfPQKcC1C7ystVFFGd2H8s/ZlDAayQ
X-MS-Exchange-AntiSpam-MessageData: Ie2hCVF5mpNLE8zAPdoJ1ho5bSpWMskS+6yQZBnc4/0mJWZM5QlICYxXNNQCY2EG06c5hxItTjBcrNMRk/X7ZEwHC2AH6JveDQuAuPOhnjdZrtBynXqRirTZIznut5nP75+wmvLmV8MFS231BJzo1A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15af35bb-81eb-4bf9-823b-08d7e5b6ea9f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 05:43:28.1174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bo2xE+oDHjWkGiebFDWhEEoYipeE1PPZF8PEcnnPvft7GdnhQ6OjeY/mcRDgN/YYiChtcHGqHJQ3DMfCh+vfSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4897
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/21/2020 8:37 AM, Jiri Pirko wrote:
> Mon, Apr 20, 2020 at 09:02:58PM CEST, dsahern@gmail.com wrote:
>> On 4/20/20 12:56 PM, Maor Gottlieb wrote:
>>> On 4/20/2020 9:48 PM, Jiri Pirko wrote:
>>>> Mon, Apr 20, 2020 at 08:04:01PM CEST, dsahern@gmail.com wrote:
>>>>> On 4/20/20 12:01 PM, Jiri Pirko wrote:
>>>>>> Generic ndo with lag-specific arg? Odd. Plus, there is a small chance
>>>>>> this is ever going to be used for other master. And if so, could be
>>>>>> very
>>>>>> easily renamed then...
>>>>> core code should be generic, not specific and renamed at a later date
>>>>> when a second use case arises.
>>>> Yeah, I guess we just have to agree to disagree :)
>>> So I am remaining with the flags. Any suggestion for better name for the
>>> enum? Should I move master_xmit_get_slave from lag.h to netdevice.h?
>> IMHO, yes, that is a better place.
>>
>> generic ndo name and implementation.
>> type specific flag as needed.
>>
>> This is consistent with net_device and ndo - both generic concepts -
>> with specifics relegated to flags (e.g., IFF_*)
> Why there is need for flags? Why a single bool can't do as I suggested?
> Do you see any usecase for another flag?

Currently no. I am okay with single bool.
