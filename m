Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176A147B92F
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 05:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhLUEcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 23:32:13 -0500
Received: from mail-eopbgr80095.outbound.protection.outlook.com ([40.107.8.95]:21319
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229441AbhLUEcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 23:32:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BlTo08zWuzrZpUaHqKstplBZjsWER4GsY9/JnzKYSvfBqaT6Xgu71is/Jj+FDuQ0DMD7I/6jFHYmsIdP+UuiKII/FZVIpyvukv4p6gNkj2/3QjL+rDThmgKRp4MrgW7/F1GSX41YTuhJbq5FaSb+BRVnz+ftG1ZQoLgcwp4Y1sRrYwnkX4McL9WA7WxcraHzq0Yty6/UuDu9KL7kVvTbJ8qy4k92SnFXihIyhVz0F3pYSDedr6RPyHLBcMy5rtDh4+kTCVSdtm4MV8lSoUoCcGa++hF3RhwRYSU9lfJzT9PsgpD73q8Cb3/F6jKLcVOWYpJ4tZgbgJPhcl7SDsFdcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Gyv+gTd0AaUWtLvFmEtzmSFXyVaueDOzgJRZFE9Vz4=;
 b=UnQg0tEAlAQtNaR5ku5ymxKSLAdnGxFhRU31JCrZpGN2PCrWp+nMhBAlQ8Y1X3z9005kzjPOAIgYrVv8hGUmVQGzkeTmrMbG6Qx6HosKtK0Ct6GPAVKlBxkaZ0rot0es9y3Uy7rWi8p5Ymw41kt1xh/i+D+U/+khc1x++5iA12hzxRmhAmHyWgQikkpo5xRjYxwTQ+U9Aj0SwmJ8KWTIDf6XwU4ZVL5xGdFmBUoCPFg2B66ZWLfS98EmC1rrv0Ae5YnhGTq8MGtT0biLSWcRRDpGuAwmi97bp4rxBRZMniNAcs53HtXCocHNzp2k/TlbMrbmLL+O5yaLeoTxXmHpQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Gyv+gTd0AaUWtLvFmEtzmSFXyVaueDOzgJRZFE9Vz4=;
 b=ey7VEyyRlw/K219QRXovr9QI/4mzqJmvGDsgkKJupAYk7zhrTiW4JkIOy+QBEQpJSPZojhnOM9mCsQH0k181mMBOsmMq3b3pDsNArL6MFW6RUvv11kNgJD1Z9wn1sYb5sy4cteZHZrF0E2tQt/jYNp29DZR1QCHPNNMKMWXQsCE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1156.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:26b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Tue, 21 Dec
 2021 04:32:08 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 04:32:08 +0000
Date:   Tue, 21 Dec 2021 06:32:05 +0200
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 6/6] net: marvell: prestera: Implement initial
 inetaddr notifiers
Message-ID: <YcFYxW2aeTnVVapz@yorlov.ow.s>
References: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
 <20211217195440.29838-7-yevhen.orlov@plvision.eu>
 <20211217130325.305961eb@hermes.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217130325.305961eb@hermes.local>
X-ClientProxiedBy: FR0P281CA0054.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::16) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cca0340-2776-42a9-072f-08d9c43ad934
X-MS-TrafficTypeDiagnostic: AM9P190MB1156:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB11566F6D644E3AA02DBD5E28937C9@AM9P190MB1156.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:169;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D+FmT2c+O++28sahFmvcdjM154/CZN5Shnt/pI0QRxrMzamXiyApWjF/8pnuOM6fymssbggqamEmJnwahAvVYwj0MB6bjCeT+02Hnm6Bw7+Gt12FL7764nAFbqZL6imZz90LWcItR5/4Z01sN4iUrRq8b2DPLsfuKL9HEV8dB2CSyBjmsoWxy6/KvU3nvopuGhSM0incdi9fxlOb+RlZUAQ1OtwoyVnPXvLmTR8OdSsBddSpVr3BjaW9RbBocHy63WNBuZa/0NvWVVVsKtDCjiiB4xhVZxplsSAFLvskkhYzh9kG8fIpqJRFPkOVYv01Btj05tsjVQG0eAiU/AZOJFFrxt2ikZWPwn1INH6Pq4PuFfD8m1/W7ltkmr0KG/L+dlEtjOa2898J6zY+tS2KsN8y7Kzf6uPtGr3rhR68GqWTd4653bueYEu+Eq/gTBGf41eGMXyMqFrZGrtT+P/r1VnNEXTMIWqWgOi1zWy1I1mbvsNmB74TGWvlBz4JdA6VPoyGLbi42nfbJLES1jRWPrEDcBUZPFG3vhhKx0i3c8ABgwK5k7UjBucN6/FKLuHmcv01666CCnQ3J5lgzz9DWeVnJ6mFnxeMbHmX1ix4Xcc8s2Jzk7jRaYttB3TD/rWsX8G8qbE8/A5x4NUDrAZHQY20E5qlwXMAYwxL12DpQ+0Uyz7Nm85bWNhKUnNyliGwwkoFLLWPfgw9DIrm/Le0dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(39830400003)(376002)(396003)(26005)(6506007)(186003)(52116002)(86362001)(6916009)(8676002)(54906003)(83380400001)(5660300002)(6486002)(316002)(4744005)(8936002)(38100700002)(38350700002)(4326008)(66476007)(66556008)(9686003)(6512007)(44832011)(66946007)(508600001)(6666004)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o8hhHwddl+ZyyXcKl3YJv/u7LLQ3XAY1K1EPQZ9BqT+VVXKgxW1wJ8kLp1tF?=
 =?us-ascii?Q?2WghngmYeLEZgyjBp/b71nxqr96cj7D5KtEbuwcs8EfdLTmjBYIxyCVlw1XP?=
 =?us-ascii?Q?KS3bn+xArFnqRSyWQYKUNYqd3r9Q5uNIgt0y53JgmbXFRYnNPFYWWc9ba5lN?=
 =?us-ascii?Q?uL2ia5ku58Prj2oPLj+5wYogC2/Z58JOnM7qxI1KXvqHSktaeFglKreOwhrj?=
 =?us-ascii?Q?I0tNAL3yqsEw8SnM/NpnTTFs4xrzSkya0DxFaExIF8sutpjGqt0QyNYSg0W+?=
 =?us-ascii?Q?jfpsxWlw/+J6+nmE7yaxqkTSler+Wi7TJnRFrmUI2fq1Zkk1GHuefe5q1dDN?=
 =?us-ascii?Q?9cG5xNHueeximQXGdomGYdf2Hnw3GIB2E2Ty7exMWxB17T110BFOojO+4S/D?=
 =?us-ascii?Q?JgihZDzw+ecJbTVs+6W4eLTgbMJbMhnCwbE3JqVs8+lH1sEUOsa+52A6Gp/n?=
 =?us-ascii?Q?VI7G5ymTl4z+dbDMY88HhF1NG4y/Uhj/w99O2FIFsHJuO3fuMJv44S7vk6Xk?=
 =?us-ascii?Q?uT/GmD2sif172KMr9HzVwnNR4u6rQ6kjP4vuRV9nxJld4cKgsF3B6VabuFXQ?=
 =?us-ascii?Q?qCefL+TklUyodpAyuwwEFnCmVJ2q/bFje0+KR6n341l9b/Xssr965yzdJ9/d?=
 =?us-ascii?Q?52l5UlgdvnW7rT8TmywWcOZZ9yCk9BsJM+uXJpJiTQyD03FyCgF6v9JkLIHy?=
 =?us-ascii?Q?jpiKpC6gEX1tMTB4r8IryfG8hmLJRQ4JN2Ha+EwwXdpuhE8O1lyngfiSAIz9?=
 =?us-ascii?Q?w6Gueaqh0AheLNQZZVjWKjQMBkKUUp6eRRmIQC7LxoQzIucFXBnEefJwohdo?=
 =?us-ascii?Q?DLNfSKa3YjXaBzhjayEra9wisWdu+5yIHQqV79+sJpb8bKMISJSrSJY3xQUQ?=
 =?us-ascii?Q?3foB8f+LuvjdqfIL1jDJsqgaOwLz7bjTsb/eLO189dxh1N9S1bKkaLknd8Xz?=
 =?us-ascii?Q?Q53D0pGuQTe2zCpj2kkQ9I7JxOiAJE/63s4QUf5q2B9BG7Hzxm0gFBjHNwKv?=
 =?us-ascii?Q?cH5UIYi4HOy7yTuj9K74KPYQOAB6mO0Ari4gHX9r8mueqsVFYQ/KX9Y6Wgo8?=
 =?us-ascii?Q?wUhrvmCNsyy1GLG3V41cFRLRPvdHw+nysp2A1jswm7gS5AQNc6EclXQ/L9WO?=
 =?us-ascii?Q?XCqStjauN8D28kOSIfFqDWq4iZFuvU1HhSSKdDXRyRBEHUKhwJnzRORBhcHx?=
 =?us-ascii?Q?0qm5Xv4BTDpo/xbiNFLfOhT6sUIaiPUTStpHsrlw/GbI1liQ7LRlzJQHjAS8?=
 =?us-ascii?Q?B1IUoOzAnfDr3IpuISggEL1zsTXoOVIcxGjJDrdRyJwhXFkeEaqA0oppiH6L?=
 =?us-ascii?Q?3mBAUs+45WiQ+PuZQOJYk3V8SZNl9c9RvdEx1yXst525ne4yhNLYV4Y+n3OI?=
 =?us-ascii?Q?H88RVWYl1uXWH/U7x4xgZ0eOaRVBFOrGmXSP9k+kWWXN0GoIWDCfkhxnSS8D?=
 =?us-ascii?Q?GniVf89FEcluYa1o6tWudlmmdAsN6Dmx9ZV6aXAAD/LvjSY1iadmRuZJygkQ?=
 =?us-ascii?Q?6c36m/6cvL85Jo7MrpgMPsg6ve17xnYInP4LRdni/ygKBeNXcLRb0S7xFUCo?=
 =?us-ascii?Q?KueBAcYhqdKJ0PGYIYghb3ZjQ1CKWphkttNX4BzIBOql4a0vaNUOSo2b6cuE?=
 =?us-ascii?Q?DSlVWdixOm/4nIOUjefdXTJDW4aM8sc7Tj3cV8X8q6o2TZjqKUpffGvUZY3h?=
 =?us-ascii?Q?Nhm0UY31zA5m1FouHxbM/2qJ39w=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cca0340-2776-42a9-072f-08d9c43ad934
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 04:32:08.2411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1hqQHOi94FnyVUVhe1DV2m8geWdn+ZKTe+xOSLmFMlj7xwH1ICjmTcWLIAiXsz36L+CRGdQPRIQPpmpn+LYrt8Xn7pRWnRlTZ6LiZJ0lRL0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1156
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 01:03:25PM -0800, Stephen Hemminger wrote:
> How are these device references cleaned up on module removal?

Removing the module removes the port, and clears all addresses:

    __prestera_inetaddr_event.part.0+0x190/0x3b0 [prestera]
    __prestera_inetaddr_cb+0x94/0xb0 [prestera]
    blocking_notifier_call_chain+0x98/0xd0
    __inet_del_ifa+0x2e4/0x4e0
    inetdev_event+0x260/0xa20
    raw_notifier_call_chain+0x74/0xa0
    call_netdevice_notifiers_info+0x68/0xc0
    unregister_netdevice_many+0x4f4/0xa20
    unregister_netdevice_queue+0x13c/0x180
    unregister_netdev+0x24/0x40
    prestera_port_destroy+0x44/0xe0 [prestera]
    prestera_device_unregister+0x6c/0x110 [prestera]
    prestera_pci_remove+0x28/0x80 [prestera_pci]
    pci_device_remove+0x68/0x130
    __device_release_driver+0x228/0x320
    driver_detach+0x12c/0x1c0
    bus_remove_driver+0x88/0x120
    driver_unregister+0x44/0x80
    pci_unregister_driver+0x2c/0xe0
    prestera_pci_driver_exit+0x18/0x30 [prestera_pci]
    __arm64_sys_delete_module+0x20c/0x310
    invoke_syscall+0x60/0x190

