Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3132320D2
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgG2Oml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:42:41 -0400
Received: from mail-eopbgr40057.outbound.protection.outlook.com ([40.107.4.57]:3650
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726385AbgG2Oml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 10:42:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcM1oyabSWWgnJv5Bkzh1upSRJzXc6iSYbtZNE1yhMoxJ5mKhPdOrlPYhY4wn+vKs0fztiEkVsIqaT05PwNEFO+PPFA6iKGLP7Xfnem2zxIdvL2kXXNTmAYaAutW8TEb7yGa101E49gw3Ifw3Mz10kouUJv1T8MqB7gLP61JE2xudGBi1Bn6uCozNw3zW5+EMmtE67wCBmD3RVVJzblSdkIjPKf+m5Xkmhg0zDbX+5T2VpGunRHsHjZeiqCFBQiswFZgut4PvXLMbT2eJcw1iwLVt9l/LnLkCLSm/AgzGzb7hjF5fOFh7p8dmWxLVZ0lQisrhJFqD3EzOT3jchR4rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NylM8yj2Im829xhMW13CdpLgBFNptlxCAFlvaAjnNZs=;
 b=dCCr7Lk2iPaG0ishkT7Q/2oLgZGWjJc4hhu3V8sGk2yvY4Z2/57qTDjf3a9NlQ2BTCTwnLQXT81f+Izi50T28uDPDrfM8BEkgPH9PdCVRz5fgCRdIJKDfshsRF/udckHcLrZrIHr9BQEBN1x4ohOdhajnzSbZipcOQUckYqzgqYi/vXaGlihy0DNCOuoj4tSXdza8Vgk2eWzMSuwLiAngUxjy0s17Q1dDsae/kv9xXJu6I+5cLgWFoTjEMMhj6u8LvjxwIifCcrvc68IPIzmnFEfvNswo9dQN9ti2TVcWO9Wr7+apFHl6QdAL/CUyVwlFTi7hOi/abFQ/g2GbXXMuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NylM8yj2Im829xhMW13CdpLgBFNptlxCAFlvaAjnNZs=;
 b=YeEmJpW2Q4IeuzUVPoY0jeqv6T6ehAuvLWKRuFUhybvOecdSvOwm+GrwY6tF/bGF63R+i1BU0XWAiCMcqVh3MVxTovyRNQEaKSXpiIErAAueVgyT5TVclDg3ejbSAxLgHzIVf308TmagAiwUgWjGJwfGCFiUEZzkCYhI7WNvZ/s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com (2603:10a6:208:63::16)
 by AM0PR05MB4132.eurprd05.prod.outlook.com (2603:10a6:208:61::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Wed, 29 Jul
 2020 14:42:37 +0000
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f]) by AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f%3]) with mapi id 15.20.3216.034; Wed, 29 Jul 2020
 14:42:37 +0000
Subject: Re: [PATCH net-next RFC 09/13] devlink: Add enable_remote_dev_reset
 generic parameter
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <1595847753-2234-10-git-send-email-moshe@mellanox.com>
 <20200727175935.0785102a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <5baf2825-a550-f68f-f76e-3a8688aa6ae6@mellanox.com>
Date:   Wed, 29 Jul 2020 17:42:12 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200727175935.0785102a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR02CA0029.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::42) To AM0PR05MB4290.eurprd05.prod.outlook.com
 (2603:10a6:208:63::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.20.10.2] (2.53.25.164) by AM0PR02CA0029.eurprd02.prod.outlook.com (2603:10a6:208:3e::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Wed, 29 Jul 2020 14:42:27 +0000
X-Originating-IP: [2.53.25.164]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e8ed780f-09c0-4303-10b7-08d833cda375
X-MS-TrafficTypeDiagnostic: AM0PR05MB4132:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB413248BF906FC274FE5411A9D9700@AM0PR05MB4132.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v43pRata8uWE6WUlWl8HLFD67PXWh9E/3UwdII2/f7d18Ng6gJlKqBUWKUUo+oYv9vX87jclojL9F1x601586un+vbH29iGNfGPTGSFzZbSC4bOmLeE18f+8kuatFgi8E+KmIGvSYYS2BBAvS06IX25jEaz8k+CPtiZo7VLhI/ex2RqXS9P7eVEN8cUQ1YE22QS4Xnrkq13AeFlnQnn9hLgjYbsiKV83ABv7RLy87jZPplGaajv7I/MfaoHxqoOAbkxn76dkt707O9cpeyNCkR+ZpxTjhmRKI6pzzsaVjFP6vQpdD+ipK+FdgoaJCT2SXjwWPa7nls9x4+TShalj50hgzSm0YSlXP9/UQYJtldVwwFGqyEXSWk2TVmPLJrcewQaO0Wge7d35ZnflExnPlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4290.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(8936002)(6666004)(316002)(2906002)(53546011)(8676002)(478600001)(6486002)(16576012)(36756003)(52116002)(4326008)(31686004)(31696002)(6916009)(86362001)(956004)(66556008)(66476007)(66946007)(4744005)(16526019)(83380400001)(186003)(54906003)(26005)(5660300002)(2616005)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FQHt+8j6OK1D8P1hP9VvT6KO7rnHrE7x0eJM4s/ZY82/G4fRO1x3tU6CfY71gafa3uTgR5XYuTFwvPpBUtNfbcoqJR5QEy3KM8hs0RYbjzV8dgukQ/XiAOHeUWr7i0n5EnuaAm1gf8HQnB0meZyDpknv8lAwVwq/G2C77pTlkzLRzPLzk3w4hhDEZrfOKXMslZsdtzXoVnrA/kIEI30fyLEuzS4vC35eU/+2s+UGiyCXkWuLI5WbHCJ4zjYDoHlvZg5CyIio8yw1GHK6L/uHAcVG2X+GiIlcOBmrUsh/TEEGB7gT/dM7M2/7ukd+VPkP85f/i/YCoIKnbeMr80s6e0q4cOnE8TZ88Vl3EYy+Ua4ttxb0SFTcuHc7oa3mSiFXscvjPy8Z6E3Y48CT8GoLKH55DlftQW9u99aK3osPPiFbNP5eZD+r/m25lVVP/8xXGuvOSh0Yi15sAHrRf4iZOQEpgtXrVhYRR4s2k/TjvyM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ed780f-09c0-4303-10b7-08d833cda375
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4290.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 14:42:37.8084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: opVhvuDpiVt5aoO2QNjp4mFoAM6b7Cb0fAAxaRIuhRgX+siK6lUUnmEBTvh1LKEQRudDxxkn9iUK19tvjspZ6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4132
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/28/2020 3:59 AM, Jakub Kicinski wrote:
> On Mon, 27 Jul 2020 14:02:29 +0300 Moshe Shemesh wrote:
>> The enable_remote_dev_reset devlink param flags that the host admin
>> allows device resets that can be initiated by other hosts. This
>> parameter is useful for setups where a device is shared by different
>> hosts, such as multi-host setup. Once the user set this parameter to
>> false, the driver should NACK any attempt to reset the device while the
>> driver is loaded.
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> There needs to be a devlink event generated when reset is triggered
> (remotely or not).
>
> You're also missing failure reasons. Users need to know if the reset
> request was clearly nacked by some host, not supported, etc. vs
> unexpected failure.


I will fix and send extack message to the user accordingly.

