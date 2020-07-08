Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8011217FBE
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 08:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgGHGoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 02:44:09 -0400
Received: from mail-am6eur05on2058.outbound.protection.outlook.com ([40.107.22.58]:6024
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726174AbgGHGoJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 02:44:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYvgFpgozfAjBNuWo4+YYZd+yg+dWIORmhCcCAKUWxGX9PMAVYOyvFU/2+nXqNa1+fQinSjrFdD52lQz9QnwV/xSLJCW1TcA3ffWu+XK2KmOPas0otMS651ixhBsnDTbsZMvTWe/1glElkRs2NawhVUsNRupuZPtduiK5Jxd9gEH4CcWuQv6npMLeotaxRlUt1R0rdsxoWch2u/TVuHqwwBFKlSpzsLlrY95NMzcDjOPazFRedTer/xRob+22R2mSUhBdFYZPwjXvx+zgun90ljxeMkYfVoX7Zl1JzL8K1+g6LPfewxGFY1lkQfgxxzKcfQ+ZHNfjmcQbYVctwBQNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HrFVdzzqTaJI64osuU0VOiHu+1+IrpQ29Ew8/kCqIYQ=;
 b=k3M3VkyVyylYJfVo2+j/JtxCCTC3NC+IxxPeTFCI/GcBA7Fi+9MZcpg6qXWDeKZDXQtfz02zv4o3q3TJ0wlrXWvUF7RR8UenCySOhvIY7JDfuN7L55CPZnfCSK99E3dNSCdKMJ3RjTBv8MGVPI5XUeHNuVGss+gv099RPdf31J+LWJAskFr/WOnK+TpeM830nDPjWiA1GFb8B6PNgmk/wHXweu1kpLNrbwAI4Hsma0TPr8DfhuN+apijuSP602VQKZcOdEHpKjAby1+xf8fLltTNbNy7RjUfFsoS8A+SLAaYnPnoZtigDSeoMufl01/Ida8HHk85NX5ibRIIojT5Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HrFVdzzqTaJI64osuU0VOiHu+1+IrpQ29Ew8/kCqIYQ=;
 b=CcA4H9xrfnY7gDuZ08WwCguNZDyHNk8bETasaBVdx2PgncCs6EEpggDZlxPbj196Vl+jOLZlxP7HpqRJ/FwI5aFtTak2aKUHqcsZRDyHIDHGT5nddIU4LNqBKsOxa4kg6hnqp0sdCEVzY+aI6fxxJZ0bQx29c+4auHsQW72IvHw=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR05MB6398.eurprd05.prod.outlook.com
 (2603:10a6:803:101::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24; Wed, 8 Jul
 2020 06:44:05 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe%5]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 06:44:05 +0000
Subject: Re: [net-next 09/15] Revert "net/tls: Add force_resync for driver
 resync"
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Boris Pismenny <borisp@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
References: <20200627211727.259569-1-saeedm@mellanox.com>
 <20200627211727.259569-10-saeedm@mellanox.com>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <4ea0a2c2-be2d-e99b-3fa9-6339640219b6@mellanox.com>
Date:   Wed, 8 Jul 2020 09:44:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <20200627211727.259569-10-saeedm@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR05CA0002.eurprd05.prod.outlook.com (2603:10a6:205::15)
 To VI1PR0501MB2205.eurprd05.prod.outlook.com (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.126.93.183) by AM4PR05CA0002.eurprd05.prod.outlook.com (2603:10a6:205::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Wed, 8 Jul 2020 06:44:03 +0000
X-Originating-IP: [77.126.93.183]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0c5105df-a6f2-4953-fe9c-08d8230a4e88
X-MS-TrafficTypeDiagnostic: VI1PR05MB6398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB63988D0548C32DF92CE8DF3FAE670@VI1PR05MB6398.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:357;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L9/BKzGuh4ItJPFPZa095XPH+TXUgxEud5EPu+bktA1a249sY+aWABHomnR8W9M55h9nqjUmhQI82m4bfPYVz/9O3vcaSHDs2DhzVAZYTQLKNLO7lKY66M+nGqWYCKb7z3gknyd3OzktGQa3E7ACRIvyeDnuTjJHhEr/Tb7a5djTOdtP2pTMobHRTaCjwZVpVnNl7MLIaau/MsxTLBwVWd+XlmVOis7NGPziRHRVCbMCkWMRY5XC/jfumwhPOEqwy9IpucfxD+aQqLKp2m9rEohWUcJLJhwI/0XHysm7Y6IGYHHyl1HVXrIce7xhyOhjeoJweBnJqLjneOykt+N21o1bvFprNZOuMjrhhIl56tFql1SxCZiLBzlLzbru2WEP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(86362001)(107886003)(5660300002)(6486002)(31696002)(186003)(54906003)(83380400001)(16526019)(2616005)(110136005)(8936002)(2906002)(956004)(31686004)(316002)(16576012)(66946007)(8676002)(26005)(53546011)(4326008)(4744005)(36756003)(66556008)(478600001)(66476007)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VpQtRz4uHma2V0ZUtN+B82USMP7m6W0sLC9Lqo4odaOblOFn8KkR4gOIer8LZ2weJgYfa9gVxtwXpmYHztygGqzGTsmu1YpVuYESyCKg0Zd4mfI7HAPUJMp2n9NfDLvopRJH6j8Y6778lTWnrViaFwoXMb/HHf1kvbsYQBfqrQZJ7qIxp2IXZ/ojNFuhmWL5oEB7YC6vgRmKaPphQ91IKqjehhQHosRzB0benzdLyVy2bOE2U0un4Lo7eXIMdS305tw2AETFfn2D/Gaxqlx6wkiSsLa+oCwWUYOKPOSefK9DwE9274JudACjOnab8uYNJ8QuU5RjnMFYkCa9ZixvZwDzi+CNSyn4foLzr0Zmke+mGy4ZoOsI7QegnBj+YehdaFX9J81fVgUD9hsivtVDQDMs9n3ujTbIoLNOuziE7VSx4Z7qGw9SNbI+H1idc/RbENqIAKASF0qRVSzNjVJhmNF6m/UrhzeBaj9QY3BaArw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c5105df-a6f2-4953-fe9c-08d8230a4e88
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0501MB2205.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 06:44:05.1829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5O0KaB5++gusi2qxmMdehu1ReNPkDK5t8UEZB1gaNlhirElbDo0imqKvlv6t5zHuya5vHtUSPKY8s4Fn/XgHiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/28/2020 12:17 AM, Saeed Mahameed wrote:
> From: Boris Pismenny <borisp@mellanox.com>
> 
> This reverts commit b3ae2459f89773adcbf16fef4b68deaaa3be1929.
> Revert the force resync API.
> Not in use. To be replaced by a better async resync API downstream.
> 
> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>   include/net/tls.h    | 12 +-----------
>   net/tls/tls_device.c |  9 +++------
>   2 files changed, 4 insertions(+), 17 deletions(-)
> 

Hi Dave,

Please cherry-pick this revert to net as well.
The force_resync API still exists there, with no usage.

Regards,
Tariq
