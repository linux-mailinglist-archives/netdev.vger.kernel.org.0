Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5312B1B457C
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgDVM4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:56:32 -0400
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:5024
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbgDVM4c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 08:56:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQsLGPhCGSEiEacyhnkv9rOSkEBd834ROlBVJeaavM9mHruu3i/5B15bVG+LR9Z+62vkXSxmp8HMAWyp4N0722QBu94iluZXZ3WU0MX2xhEa2bkFGLmZbfVSk8pFD5VuIzGXqH5mNCtrpqlKaT2NNPy6djH+JnbXyxnWWnkAgiDt+fSfmGzJ1c+iG7pgG8MANXiHQ6qza9ASxh8ljJkREqFxXz6cUIzdOkOQIkVlNVaZC4L3K4Aflj/QzYaFW278btoru4U2Fz8Jy6leSGZxnai1t6dZ37IZ8+Ghf0pYgGvr5H6CMxcTYtDimtzg1zogc83ZuFdk7VI0Ck44aGFdOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rE0BEB3pZXts9uv4OeO2mPAsh0yse8QRABQC9NrfGHM=;
 b=WKCERYiza7K32ppcYeS6G5+/klTnquvlo2ZpwGfUidl8DGywAmtWcF0HjaidfECz35Gry9RDg1gJ01NFF4zFVXQouP+tkKZYx31bAsbhDFElkc/wfCCA+hDGyGIe+CblHMnP85M982/3WLwOgHMse9LYbWlfD5rvOGRQDo8XWu2V2WX5izdYzG22EmR4hFMiJ9n51yT8F6Y5XM0GfGqYPHvQhHWTcfYyxgCQzqMA4Fomou5OJZLsXDE6BPYv1Cv7G0cAjNWHl73IPPuXUdAp67Nrsdd+oesIibPRMyr/F21D5CT8keVqJRNiCLO/Oo5dR3rkMavffXpVaZf0GzTYQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rE0BEB3pZXts9uv4OeO2mPAsh0yse8QRABQC9NrfGHM=;
 b=KrcvqL6R3MLkqIcLr98ynj674pCABtdOhzTEjffo8k+uc1IoEP/2yUOGiIdMVBRI0+2z/w1TGv00sAexaDt1uzRQApnqPkzbvyrMqJN8P7p4KRze3p4g4SbKASnN+BOzfHWg4ZnxGPuwVI66iym+JNfiNVaz0KrVzDUyNsqFn78=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=maorg@mellanox.com; 
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (2603:10a6:208:125::25)
 by AM0PR05MB6433.eurprd05.prod.outlook.com (2603:10a6:208:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Wed, 22 Apr
 2020 12:56:26 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41%6]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 12:56:26 +0000
Subject: Re: [PATCH V4 mlx5-next 00/15] Add support to get xmit slave
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
References: <20200422083951.17424-1-maorg@mellanox.com>
 <20200422124638.GK6581@nanopsycho.orion>
From:   Maor Gottlieb <maorg@mellanox.com>
Message-ID: <aa7a1940-90f8-b0d1-b211-a5bb27592b5a@mellanox.com>
Date:   Wed, 22 Apr 2020 15:56:20 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200422124638.GK6581@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM4PR0701CA0028.eurprd07.prod.outlook.com
 (2603:10a6:200:42::38) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.100.102.4] (89.138.210.166) by AM4PR0701CA0028.eurprd07.prod.outlook.com (2603:10a6:200:42::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.9 via Frontend Transport; Wed, 22 Apr 2020 12:56:23 +0000
X-Originating-IP: [89.138.210.166]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 09228eaf-773e-4e8e-af9c-08d7e6bc914f
X-MS-TrafficTypeDiagnostic: AM0PR05MB6433:|AM0PR05MB6433:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB64335758978F533DBA194F69D3D20@AM0PR05MB6433.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5873.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(16526019)(53546011)(478600001)(5660300002)(8936002)(2616005)(86362001)(6486002)(16576012)(316002)(6916009)(31686004)(36756003)(4744005)(81156014)(956004)(2906002)(186003)(107886003)(4326008)(8676002)(31696002)(26005)(66946007)(66556008)(966005)(7416002)(52116002)(66476007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tT55VwECLkzlFPZ8iotqLs7kE9hVF7qF54W1ikvjOcb2/L5VvSas8kOFYd6CaLbKBBiqSda7u4FTXulpnweZ0pjcByvaU3vC0UOkKGp2fbJBDOLXgZn2b14dD8fZupEV+mQwP6PnrTsZX0Nc3aW/YIdd3kSQdABU7vG0GmABaPuBbLSaFzGXz+5dSoedim6YnHkFyYbJw1SmBcWoumHbSl3k5jyAM/k4WCZuLhP6C1QUlQgAFWiR1+smmdAewmaW/YUsEEFJcaPRyKaFhXGEhnK23JhuCroRAJMwm4/arCfdUDkMKjjPc4V1ta6nmIuBrpgPaCN+m+zCoGQgKwc2SdIZqD3kPBLw1EcPa0EDqy7cP7WEbwCsVfH1cxqehtfzB/DawqONaoTSLLBLq9T8GGnrHO2lzikza31vP7UqFueMolDFBCH3VpoUWWqo9zpIDdgD15oFn3ZDNjaBPxf0sqE6ndx8V2h/kXhwdjfE0CPI93yt+qKg36lgd7lRhQdqnvwnNIL4Lb40KHHHLmRD8Q==
X-MS-Exchange-AntiSpam-MessageData: nhQyspT3Gc8E/iz9FwlauRaP/xgv3JqwF0YyECuNjWWUiA68t9a3MhFfSuAebVHI4y0ZDulfpsSuWRkATZEsKzdSpAKcT7Xus0aWQ9oYZWT5Ath2pp7gMxWEe3BIVWe0UUn9eq/vC9Tz0NLp7iiAtA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09228eaf-773e-4e8e-af9c-08d7e6bc914f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 12:56:26.3782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vARa1qiSs3QSHYFIT56TVa+6B9uqRWmYNIddehlE3tsWmMC1Bu75m/q5K+cj5uis+RI8TDQUE0NoFC3zL3DysA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6433
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/22/2020 3:46 PM, Jiri Pirko wrote:
> Wed, Apr 22, 2020 at 10:39:36AM CEST, maorg@mellanox.com wrote:
>
> [...]
>
>> Change log:
>> v4: 1. Rename master_get_xmit_slave to netdev_get_xmit_slave and move the implementation to dev.c
>>     2. Remove unnecessary check of NULL pointer.
>>     3. Fix typo.
> It is really hard to follow the changes if you don't have the changelog
> per patch. Could you have it per patch next time please?

Sure.
>
>
>> v3: 1. Move master_get_xmit_slave to netdevice.h and change the flags arg.
>> to bool.
>>     2. Split helper functions commit to multiple commits for each bond
>> mode.
>>     3. Extract refcotring changes to seperate commits.
>> v2: The first patch wasn't sent in v1.
>> v1: https://lore.kernel.org/netdev/ac373456-b838-29cf-645f-b1ea1a93e3b0@gmail.com/T/#t
>>
