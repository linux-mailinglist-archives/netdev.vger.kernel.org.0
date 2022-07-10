Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B4756D208
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 01:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiGJXyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 19:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGJXyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 19:54:08 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2089.outbound.protection.outlook.com [40.107.212.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C8D63D7
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 16:54:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnbCQ++qSYqHSm4MLo2F1/pjI5E8jkHkwRV9AyF18DhgxdeRqrkrL3cam09NqNzf85F4d74oV2fL6zM994/NpWLB7I83glBuvimdhZ2piO4KIQMmi91+kZQ407KiNeEuFxhjrbMXf1EiFxLfMEevwxqEhIhHoqpdH3E7hHsmviMPpZKnXz1Nlx23IhhYfWlxd5ro4bpn1zaazYmKYcq1d3srAUY/Qy3o+KEZ6mXJ6pNU2BpWc1qK5xU5Q4XGqw0SSJYwnVYgpsR7q5O8cegVuctEHg2+Sb4WaajsbBKdHrY0o1Uztw4Qx344ma5g/TUgQLuGAZ04+yDtIh/uC1legA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L0/ksnaZLM0utP73tqpAa4X/3ECEtsMqnISEsIK0VQM=;
 b=CD4nDsjhoONz/K37OHljl+SD9mYNDKLhJnL9sDEUz16doqAtp2meH5YW8TR/+3LLjsOZhRLEw2oTuWvadhsF02LbaNuqAsZaaAlcGdt9L1G5ghCJ+1EEsCaTM/Cvn19FYElLjrDwiGL/TQUKUjctJ9HuHr3EX6IWWvWP4sWbrpZL9cg5Ay5Ec9yWhRrGwcInQePdhbm81a7Fs4CiPIHSQ62ULeUDNUtFBu6o6nma8nEKgB4hfAXK0jtWfhYTKAsZpXEGYTtVhwSE1r5zx27W1f4d76F/5AIj46HMkUTSlxUHe4T9TiPuXwVHEz8Nn9Ey1dx+KFsOuC1xMh3JyEM/Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L0/ksnaZLM0utP73tqpAa4X/3ECEtsMqnISEsIK0VQM=;
 b=fqb6MuWkgo8oaSrTHq6OVPak+oeXbJrl4/PE51vU6gZ8fbMxoy3oGDTCTsXni7HypCga+Kl2oxtMnjYB2+y2jjtzrrAJ7dL9BnBE0wATMc/ONtHA5/eLDx9eQFvB36HTH5GFRam+s2SLJb+LwqTo55CxPJ7IKW29J3U2V22+obyHCroihHpK+NPmyQO6F/vej9iF5/OX8bltkXB63wGK2d57gtrIBR9gDi9tQ6QchC2iU6snwzbMDrOFcPJvZbziOsXW5H92DXoB4LOOr2pgaYfm044g1N4jEYHSL8+6aJ+cHUU9N82+Zgua+oPJmOs/v3et2Wmzh6ZjBI8wtY5p5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (20.180.244.72) by
 BN6PR12MB1396.namprd12.prod.outlook.com (10.168.226.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.16; Sun, 10 Jul 2022 23:54:06 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e9e9:810c:102b:c6e5]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e9e9:810c:102b:c6e5%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 23:54:06 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2 3/5] mptcp: Fix memory leak when doing 'endpoint show'
Date:   Mon, 11 Jul 2022 08:52:52 +0900
Message-Id: <20220710235254.568878-4-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220710235254.568878-1-bpoirier@nvidia.com>
References: <20220710235254.568878-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0050.jpnprd01.prod.outlook.com
 (2603:1096:404:2b::14) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de336888-4a7e-4a0e-38da-08da62cf7941
X-MS-TrafficTypeDiagnostic: BN6PR12MB1396:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 76Hd1Z07ZM2eSqhViO6tEpAaqiXG0TKcRoV4bNSBaQVthJ1bZzHfrre9/mgJdUjSxVPitHK7yKatWamSx5XfYqa9RO1U2bzvoKWPkiHKEOzbWGmfTJBCU7gsrQEccQIqjaszrNdlPm19rr2XeWgUdWjuShifqTRx+gcF9uZVMIzFH7DOeKyU39JkwgawAHAhzJ3hmFmgyiSFkhvAhSmNCkSA+3Inkmg/2s0JC0U5WQw2bA6msBnL+RZAI7/9MHzLQZz/V6ty/52Z+UgMQyOHHqBZs0DZVUM/SpZgwhamhZY6x8qKv74J/zMCBgqi+O72bB/4r82R4TIV5XNJAdTxHhe9fzPDN0d7NfIGn7LJrK8HqQVlfRcoAMrquYPbKmr/yq8jL1sF1aKWsZ5S1zXKjBqsQ86aMdoh72hzLfqMdzueHW8e03CFnjvXSstnoQ1KLhFDNfAFUiNi6jGhA+f2foAyryqI3ie4zi4LyHuqZ/ZUe1lK5hyoIVKQqQUjvF8dzFwrsonZYSgh7/vyjLznajm1q8rV79HqQKfLs+pOKjJChk72XQqkS3BdKzHzl9o5bsi+rmx4Je4SEF6vV3uTkxvyUCKj+zNm0JQCVEJhpkW6glL7bQ0oRb4NLE/rOBEO1qjKgzoEow9e33CoD7NVzPHu9Iqk9cWGSJ1iJgzpXoWsi9a5yXXQ4rQWDZ1lKW3rYPZQbZNr82R/Xcx822h/ICvmRn9nMaa+X7wmYFmQTTBjpI3DcBteO1ixgczjAcJT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(8936002)(6506007)(6512007)(38100700002)(2906002)(5660300002)(83380400001)(316002)(4326008)(66946007)(6486002)(66556008)(66476007)(8676002)(186003)(1076003)(2616005)(36756003)(41300700001)(478600001)(86362001)(6666004)(26005)(54906003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?86rbtI17iaFBU+lUC4iez7ujcHIh2iYs3SUfNVV7HHWYyL/ft/MYz6ABBmXB?=
 =?us-ascii?Q?v4yfoat6tJLgHY9Skm3uRoQd+crQ6lM++108XxArVadpKfAlMZPrtfLyc9yF?=
 =?us-ascii?Q?xC5UirpDuYQGeOJ34JrDH4fM5N0Ayuwt1PFo95+Xw4qeEVIKIR1tJfpOQhGB?=
 =?us-ascii?Q?/Xmw/aNVoQ0DYZ9MHg0oDTP1oentHEWAhTmaQ+bpQTlmr/Ye0EZROCCmMgZj?=
 =?us-ascii?Q?GQ6e4N2Ailc3Hgwi1q8vmJbYRPuAzG45Di/T5Y6fZs7459uja0rjxXz+XRqs?=
 =?us-ascii?Q?BDvTj8pZ8meuU5S6Wsbn6VzXameOgprjBERiEW2vA2XI+5vrAjYn9S7G8hTj?=
 =?us-ascii?Q?n7i6EN+mD17PUbGRASzgKAwm7sJ6CjlUNtYJ4eIJXgJjhTOiukWj82B/fafa?=
 =?us-ascii?Q?PSI+Lo0HagfW8f81qKGCY7H41musK8MQNSpXeBHPkJ1Bq0pGy1UaoefojNc+?=
 =?us-ascii?Q?kub13svFd+QI40iEyDCQBB1l5IDSMiljeexf3y1b8RrzA+L6E9pMSnJsXuto?=
 =?us-ascii?Q?Zv3z2n+hnJODRGsJTkqWDtzvOUjadnDWGXN8o/S+Da4m9qWKWuZ8Y+xDRSbI?=
 =?us-ascii?Q?F//1O3Udi1aiV1f8bzzqYfU1ExgojZhe+Y1PDFFWoGgeY0y45TzPTtV8wh4r?=
 =?us-ascii?Q?elPRL7MdYyvFPrq7N38L9YGVlObcwbixQNPRUnWsIkNAY/HWIWdd44lS4S8x?=
 =?us-ascii?Q?RVjTzPfMxsvmO8qz58WbX3/Raneh72aNRvQfRYgZrafRSj4TyS7YKPNn4o1/?=
 =?us-ascii?Q?8IsswU/TT/qsvQ2mqqKkwI+EtHpOGAAt36lBN83kfWniK9BFw85LNG5Xtu26?=
 =?us-ascii?Q?gP+2IzYiwBa4hTWJrvgadr3ZCDO8FGANvab74MrAXbSQiVXhwfA4RMs9NlY7?=
 =?us-ascii?Q?lzhlQVvrGzCKCTf3eGPy1Z4MTXmfFpMmqnTuUiNRe73tndYBoqd4Zc1mOD6f?=
 =?us-ascii?Q?N4sJUo182bsdiV5bqShLU8lEMtLJUJz4dOOQef9ntsIypsBpzs3M96Q5eLA8?=
 =?us-ascii?Q?iFHLdysca7zgF3ybkPVyQ24k3fBVElDa4nnZUrFXrBPtK0ltI9QAfzAjF7tP?=
 =?us-ascii?Q?9cKdrvCYgraxfEIhFd3qGbbefpM9ZNU1BPoaRuzSb9+p3OjwZuNS+Db87EHh?=
 =?us-ascii?Q?KC0ruwU8NhwjzfRyGtirbZ2723UzIya9tUTDLaDlfsma4+AWu0ASTM72wSYz?=
 =?us-ascii?Q?z+/UG/OAbZ7o/NAeVhEbC8/AmKHQmsIXuK0dWBYS/NWerY67HQBDWhWJpSaf?=
 =?us-ascii?Q?/WTJXB7g75+QtTE1/8uMgupdPBim96FLINXW48viKM4QZB7IBQDvC66yC9aw?=
 =?us-ascii?Q?Nixs+oRTGGkh+kyo9BYJ7EqKjkIKuyaHAVR8sP94sCl1L2UD6y3Sqd/J/9Js?=
 =?us-ascii?Q?nRB7JWi8Xj2KZe4xByw1MMPdizt2iheEdNH7cIi4zC9K9eXp42MADfrva9ec?=
 =?us-ascii?Q?Lf2W6/8Kx7fmXkyeyvkRveU0zd1/j6u4TsFbrDgtNaIso3zQ2tamrJ25WrA+?=
 =?us-ascii?Q?+bYIOQmd0rK2kmCL7Vzq3FOoHarLGnqzfrDDvpFP4eUjAPKZVOYLbKEV4edV?=
 =?us-ascii?Q?6xsXC4nVEHMOd/6+XrY1USdY5LPLRjqjH+u70KFF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de336888-4a7e-4a0e-38da-08da62cf7941
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 23:54:06.0759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l6IOeNn5NKR5OklzOCr8bNO5yYouEmb6BBvn3Xi39ghjVxQSZ0RGDJHzZxBjr9yTkG0jXEapOvW1YW8fwJtuwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1396
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the following command sequence:

ip mptcp endpoint add 127.0.0.1 id 1
ip mptcp endpoint show id 1

when running the last command under valgrind, it reports

32,768 bytes in 1 blocks are definitely lost in loss record 2 of 2
   at 0x483F7B5: malloc (vg_replace_malloc.c:381)
   by 0x17A0AC: rtnl_recvmsg (libnetlink.c:838)
   by 0x17A391: __rtnl_talk_iov.constprop.0 (libnetlink.c:1040)
   by 0x17B854: __rtnl_talk (libnetlink.c:1141)
   by 0x17B854: rtnl_talk (libnetlink.c:1147)
   by 0x168A56: mptcp_addr_show (ipmptcp.c:334)
   by 0x1174CB: do_cmd (ip.c:136)
   by 0x116F7C: main (ip.c:324)

Free the answer obtained from rtnl_talk().

Fixes: 7e0767cd862b ("add support for mptcp netlink interface")
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 ip/ipmptcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index 0033f329..54817e46 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -337,6 +337,7 @@ static int mptcp_addr_show(int argc, char **argv)
 	new_json_obj(json);
 	ret = print_mptcp_addr(answer, stdout);
 	delete_json_obj();
+	free(answer);
 	fflush(stdout);
 	return ret;
 }
-- 
2.36.1

