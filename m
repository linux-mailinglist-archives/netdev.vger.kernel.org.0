Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373F14BD080
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 19:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244470AbiBTRzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 12:55:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244402AbiBTRzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 12:55:10 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2114.outbound.protection.outlook.com [40.107.20.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469F8527FF;
        Sun, 20 Feb 2022 09:54:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3bbNcM8QxvvXg4yroduJrbo53+A+0lzAvZMGzWyp9u3SOCkitRMZ/rLockgkzY5J3Ukj1VsuY0w0vZAlb7oLGllixyry0WlsWIH3UfV8tYq+EsKcJCwJfX4w1dVo1s+qLJn7xJPSgSlKa8RC90V/Cad5Zv5KntETACkgVNs2zxe/BbiCaVQtJHywath33U2amk7jDaAiLetHvEP5+u2sHjT++MsxCuY/9LwzFn+Ke4wX2s2HGTgTrVBz2rE9tJZJUlVg3BkiLuNBdmd7gs1NK6jOD4QGddlvyKeGAMoCFnmWncm8aXyB8Ce+g7UmHxZOZkx9X5+mXjq9k+hL3ocHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZU6NZpVKzpwiErg2MN6PkgdVRBP096r5RbZEXAX6foo=;
 b=AnSqZkWfdT1QQEBMfjT8aHULey1gVBYaIEbBGLmzXryfOYcLtpB05TLn/p73GS9A763bI5T3EeqWVCceqvVukPiK4VJoDOT9MUgJ7yXDXNL3spXoZCRQBGG0o+T6464DP+1sVz+ZucIHY7OPiV8t8ZcfJ4vs+Jy0xichSVvlN0s7sXQ7XTn68/xPiNsBtOd7mcsGoJEcTX2ddFwiTORIVsY+CebZRTP+XQwZppDT0Yi28DJyo5Geoe93NumNT6bccwyqchLFYUFOP6dgaSM8W9RRNOy/+vFtyUxUnpimHS7enXr5+q5UHiINg0bl36Vwhj023HTCr99t1LsdC3HRqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ugent.be; dmarc=pass action=none header.from=ugent.be;
 dkim=pass header.d=ugent.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ugent.be; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZU6NZpVKzpwiErg2MN6PkgdVRBP096r5RbZEXAX6foo=;
 b=CJ1M4VsGA7Q2uPQiGuTyGL/MqfcdIsOYigms60yEqM6R8QpeLEDexQDpSe+l3Tlsgl3clmA/v5tufy/Sy4qoXomtkZa5F6d2SLldrPqmi+5ZIHiQV0cphJnilMgxnWD+esEkOJTpxicv8/YrVoIDnxBLNszt2V/yfS7S8QSky1Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ugent.be;
Received: from AM0PR09MB2324.eurprd09.prod.outlook.com (2603:10a6:208:d9::26)
 by VI1PR09MB3760.eurprd09.prod.outlook.com (2603:10a6:803:132::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sun, 20 Feb
 2022 17:54:44 +0000
Received: from AM0PR09MB2324.eurprd09.prod.outlook.com
 ([fe80::fc49:e396:8dd8:5cb9]) by AM0PR09MB2324.eurprd09.prod.outlook.com
 ([fe80::fc49:e396:8dd8:5cb9%5]) with mapi id 15.20.4995.026; Sun, 20 Feb 2022
 17:54:43 +0000
Message-ID: <5599cc3b-8925-4cfd-f035-ae3b87e821a3@ugent.be>
Date:   Sun, 20 Feb 2022 18:54:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Content-Language: en-US
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Niels Dossche <niels.dossche@ugent.be>
Subject: [PATCH] ipv6: prevent a possible race condition with lifetimes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PAYP264CA0004.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:11e::9) To AM0PR09MB2324.eurprd09.prod.outlook.com
 (2603:10a6:208:d9::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e1e11e7-36a2-4096-0343-08d9f49a1343
X-MS-TrafficTypeDiagnostic: VI1PR09MB3760:EE_
X-Microsoft-Antispam-PRVS: <VI1PR09MB3760C503E09D2D3449B0900788399@VI1PR09MB3760.eurprd09.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QIH8HrAaggv8QQbbB9ZQARJolsNaHCshKMg719eSgW8UJHUytjRp2OkgmttYg88JG0M8Y2Vz+u+ujmHNrfWOs/O1h2Jp56qOui8oB2P2YtE4ZpG3bPFpwADNsmvxh5N0tQEPBwDK1ftqpAIcHitXkCwUkXPca/VAw4WcpFVYVo+MFuc8H2sB1zhy2T4ikB7D9pAC25cwCSYVYEWPfzKqKhnnZU+SLMY+FVMqkFZ5eBM7UQUDj51aV59ZUug/dizoCT31pvw7hmcenr4ztxm9/hcc6wd/jSgxxN2kUDtb4hvmppOjodCck1gbiCruNJpwzmO1055z7qAtBdqvvBZyAcQIx8BUEQQgYELHgyc7CEDzQCrOz9gSdSD0dFBkTo15g7x2imDUicc4OrECDXLRWHULsc/uMMeg4GW7hi1S13xOas81NPBbPHA4TZ0mgjHFG5jgLamGL6yklOXbdlW01IXf5GWznKREt4Lq7h3EbbZMEswP/EQhTAhKqKTTnfsRy2vFIsqs1tTpngOWz9QsAoQ46KMj6HFMKdi3db0vgQiRk6c5SyfRRiIAX+ktBHlZVqRIs6j8QJ1akF15y8aDUqs7IDy8vKWqjLDl5cz45OPPAOc6vXlD2Bh1JRpUN6DWhhYs4C9gqwD46jKI9gyfecnWby0N5Og68hqfIFySwuROkxZwnZ9YHDhqBB28J7Uvk70ZV45ZYm3UOOwyZLQiZwicm4sdzXznpM4swvAgbCA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR09MB2324.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(31696002)(110136005)(5660300002)(786003)(316002)(86362001)(508600001)(66946007)(8676002)(4326008)(6506007)(66476007)(66556008)(2616005)(44832011)(186003)(26005)(38100700002)(2906002)(36756003)(83380400001)(31686004)(6486002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlBxUnBGUmJDcU5ka05FY1NHU083R3JPNmtCN25zUzVjUThJTEJ3MmJmN25K?=
 =?utf-8?B?cHIwWW9COGc0V3FGRFZGTUZDNlNQZmxDSjVFNktnQjRmODRsdjRFKy94cUhO?=
 =?utf-8?B?Z2R4a1NNMmJFSVBMSmIwY1RjTk11R2c4eDFFK3krK2FXMm41SVpFTGUyTzc3?=
 =?utf-8?B?ak0rYXorbEsxNGsvQTlzdFpEankzUHByOTRtUmljZGJUanRrY2JoSUpkQW9W?=
 =?utf-8?B?YVY0QU83OHVIT3lYRzJ5ZU5ZakpoWmo4SnBmakx6Qis5QUFORDZQT1N6Mzg2?=
 =?utf-8?B?Y3BnVnpmLzlNNmJDVDZ3RlZpQzJDZXdrcGZHZVJBanQvMU1hZGNlUkR4aDdy?=
 =?utf-8?B?TkFnQzRUZjBjS1Z0T3QxOWl1ZEZTQXpKeGh0U09ua3IyaEJyQkQvZUFDQzZR?=
 =?utf-8?B?OHBlaXJBMkZ3a1N0NnNUaU1zVEFta1VuUnNpdk9mYkE5NHVNVFQ4bHNyQUto?=
 =?utf-8?B?Z3FhbXVucWF4SXZHYjkrbnNaaTFwbHlNbHRjMk9UQVp0VUdITVNZNkVVUjJS?=
 =?utf-8?B?Z2V1QnNFZGxFSnpIbWZkY2daQzVXblNIc2o3a3F4NThNV3JrejM3a09haWpZ?=
 =?utf-8?B?NDBuNHRubEYxRGRrQVdRS3k2OE04VUp6NWI3UXpGVmZ2Wm1qK2xVN0NrUERr?=
 =?utf-8?B?cGlkTGUzU2NNSjd4eEc1QjQ1Y0U2VHNYRGZaVXhFeVhYakYzM2dObzJkZkFz?=
 =?utf-8?B?WEtnZ29BYXhpdUFTQThVb1h4c1BTZFVVTnE1bjkzQ2o4ZnRNNDhBRnhlRHo0?=
 =?utf-8?B?OHJMSzR4cHhYQklOWms3T1F0dW8rckpWMWJNdmg4aFFsQVdwNWd2aTRSUzlK?=
 =?utf-8?B?K09qVUdubHFWK1JvZjd2RCtrTGtJRXExNVBUSlFwcmxORGFVZ3N4ZHEvbXRF?=
 =?utf-8?B?c2xodXNRK0VtTjdYR3NoRUJYSkJDejJZdTg1WmVxU0hvN1lyK1pwQ2JEbFZV?=
 =?utf-8?B?aXl1S0NpMWNUYmZWcnhCcjdsTTJFMllZdjNXaUN4M1lRZmhvdjlkVUFMbVc4?=
 =?utf-8?B?dExEOFZmVHVQRnFOZ0Zzd2lUeGdyK3E3UWtJbTIyZXllV2M2UGY1dzdkbVh2?=
 =?utf-8?B?RDQ4YmFkQ2NBS2tmdm5UK0x3ekJpeTYvbUhyTFZQUzRObkpYNjNJMFBOS3JM?=
 =?utf-8?B?Um1TMkxsQi80UXdISi92U215RS8zclVqTWlZbmY5YmtqZ1BVNXRreEc5V2pz?=
 =?utf-8?B?a1lKT0xQSFVnSUJxV2J4ZUladlI2NUxqRUZEU2lXaUx1WGUvUFd6Y1pwdWxR?=
 =?utf-8?B?SnNkeTFZTnRSVzNHdWtNRmZ1VjZYRG90M3dXSmRMNitkOC91YStTU0xOSkN6?=
 =?utf-8?B?N3M5NHFORUJSOElEQzJ2b3lmVGlueC9uNm8rTmREdlRsaDFkeVpRTXRTSjJk?=
 =?utf-8?B?WHZZZy9IOTdDYm56VGxoRi9BVy9MclVQM0MxTVBDUXo2R0RBQkQvMFdmeGFC?=
 =?utf-8?B?TmFjL1FUQlRxVGpLelIxWlhrODdSTi9PWk1GQVh6UU9vZ3BtWWNFT3U4WlU1?=
 =?utf-8?B?bWZRaGJHbXMwVXc4dE5hcU1zUWJ0VWRvZzRQV05MeU1yc3NzbnpGekhPczF3?=
 =?utf-8?B?dW9SbDVPOEJpbGZiMWxWQWR1RjEyYjB1M3NSN0N5dTZ2U2hrOVdxaFgwcEg0?=
 =?utf-8?B?a2w3WllUZXZ4MU5GeFd2MFhDSEhZajN2TndTaDcxUHBKOU9Oc2dNMS9SSVZU?=
 =?utf-8?B?Y2YwU09IZXdPV3pXVFkzRGlHVXpRcnVqUkpUckpsa2F5Ky92OGMxeFNXbWR2?=
 =?utf-8?B?QjUwNzViK25RVCtYUjBFSVRyc3IxckYySi85OVJkSzh2dEVBZ1ZKTWdselNp?=
 =?utf-8?B?bThlN3lQNVM5ZGo2cFdWL0J1Y20wamxueHlucHM3QnUzbERUNzBOQ0JlUlhy?=
 =?utf-8?B?Z3R3N1JjMlIxZ0wwcDRkcUljd2FWQUhUNFh0M3BKb3VvQ05wTzFpKzlQT1RJ?=
 =?utf-8?B?MC9sdnFxMmFZNTR3RnRqNmFVd1QwbmxzQnRSdzFmcFJWMkF2aGNQdzB0UkVv?=
 =?utf-8?B?eE1nYnBTUWltN0V6SWlncGFxQkZQczhHenpYcnBpVWFTYk9xMnJ4OG1wbmlE?=
 =?utf-8?B?eldrQUlzTDY5Y2FzNmUyMHNqTnF2TjV4UHZHMkRoN2puRW5TYXV3R1lrbGhF?=
 =?utf-8?B?SFZRL1FtQTB3ZnFta1Vma0RpZU5saHUwWXhBd2NtcTBnMlUvQnBvWHo2Ky9C?=
 =?utf-8?Q?EfR1u2c0Ago/h19Tevo7yYE=3D?=
X-OriginatorOrg: ugent.be
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e1e11e7-36a2-4096-0343-08d9f49a1343
X-MS-Exchange-CrossTenant-AuthSource: AM0PR09MB2324.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 17:54:43.6654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d7811cde-ecef-496c-8f91-a1786241b99c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VaHK8WcnJ7HpIYTUm4FrJyXYoXImPmHVmWXgIZ9MNsWhUFm4kiZvJ+udmqUKAvgL8omJ+VP/Jam+HRTNvEToeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR09MB3760
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

valid_lft, prefered_lft and tstamp are always accessed under the lock
"lock" in other places. Reading these without taking the lock may result
in inconsistencies regarding the calculation of the valid and preferred
variables since decisions are taken on these fields for those variables.

Signed-off-by: Niels Dossche <niels.dossche@ugent.be>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3f23da8c0b10..6c8ab3e6e6fe 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4998,6 +4998,7 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
            nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))
                goto error;
 
+       spin_lock_bh(&ifa->lock);
        if (!((ifa->flags&IFA_F_PERMANENT) &&
              (ifa->prefered_lft == INFINITY_LIFE_TIME))) {
                preferred = ifa->prefered_lft;
@@ -5019,6 +5020,7 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
                preferred = INFINITY_LIFE_TIME;
                valid = INFINITY_LIFE_TIME;
        }
+       spin_unlock_bh(&ifa->lock);
 
        if (!ipv6_addr_any(&ifa->peer_addr)) {
                if (nla_put_in6_addr(skb, IFA_LOCAL, &ifa->addr) < 0 ||
-- 
2.35.1
