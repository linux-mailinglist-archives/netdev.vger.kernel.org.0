Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7EEC4BC935
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 16:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242518AbiBSPqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 10:46:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbiBSPqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 10:46:18 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1099C606E0
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 07:45:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h220DiputI2uYaMqSEn9RkIlGKjzQ2fcdHy2hvvy8BetzWtLUMCZ7XLq5M/6vl90/ByIshpqLRe8sGmdUtcCekSIQbhsAcEnHU7JeOsk7KMy/dVzeZtX2HpOMjqdkBOg/3/RE+xSw/PKui57jAcm8BnOHqvYSn46aQuPZDPQ1jLXZ9mfBbZ6M3HyXL5rOwNLTDMSaTZq9BBJWI95ydOEncri6E/Syvwj9p9mUuYQJ1sG21d1ApNAN4v//LlBOGqBhDyq3BIGIddkHXS/n2np3T6uQUj30e6JxjILy7xIgT1RcsTKqoOlxD9gbPzBZDgygCMtRy6Z/VN7iq0LJUNslA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0rxVJL8XaTjOJTFwFIScdU1LFnLRewc9Ixq1mQ5B79U=;
 b=aeYhsz7o/1hO7NYZlkVTajNF88rpfgBXM+ixk9KCB/281s9uijFRpqDniTOAWnaX/QmQgmknRSUixYj5Ga18Tdd/qGJ7NjqMHCAFm2azzt3nXcZqZy+k/wtB6Cxvc/hA92rzodiba9mv2SQ39sH8Ap022CU/ZWQ9LFVq0RA6XGSblAthfFfoG266z9NRlWnTAlJVas7Vll+EP5WSPgJLdUpIrM1O/zTwiseO5gWacovmjQRfS574LC/FPcb5ZbRosLHe03LIGVly0L2TH2hWO1AYax2CaQ9ifdTEMapiyHMWSbcjNdCNi1MstxWIM4uXWZWhGUJVnOtaaP5qI3HA4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0rxVJL8XaTjOJTFwFIScdU1LFnLRewc9Ixq1mQ5B79U=;
 b=Xm9zjDuw6XRRptkR537NgDAEg/Ptl990SZ35rHLxagUWzyyaXHqouXcXMguPEJik6ZUiANOcFknjRlptDC07NLA6J1xI7tO7nOXc0VHB80wtAIJYq4bRvxkcUNmzbkIgyKQlgDEY6mNYRs1nN49C9KrhhGQYRfammtDoEGjVPJZS1J/lQ3+p35nSlNdJFWPLUz3lpyRKNPgrljIo01dO/NKhsdGJV6kfK1Go8rT63/7XU4Q2OsOXGPo0eJ7n7pvN22VR9G37wRwd5UdViY2cSUUPE4eRs6VPxxYu1pI01SFu9kU+qF2K64lPgqb/jyCc51DnyYSfUXDPuLwWs4E+Zg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM6PR12MB4340.namprd12.prod.outlook.com (2603:10b6:5:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sat, 19 Feb
 2022 15:45:57 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%5]) with mapi id 15.20.4995.024; Sat, 19 Feb 2022
 15:45:57 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        wanghai38@huawei.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/2] ipv4: Invalidate neighbour for broadcast address upon address addition
Date:   Sat, 19 Feb 2022 17:45:18 +0200
Message-Id: <20220219154520.344057-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P189CA0018.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::31) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b33dfcf7-ee06-4415-8c06-08d9f3beebb9
X-MS-TrafficTypeDiagnostic: DM6PR12MB4340:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4340D90F6C57617773E81ED7B2389@DM6PR12MB4340.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oeE4k2ydrSrgs0HdbDhxrJ3I7Y2AT6IbPHOdMlGcmMZTRcdbnHwGB+oc+hHvrroaI5O7yZTeeMrwZjQHV+57pfZNEwNxyhjmY5bNPxNAmTPYyixFjLmKqLmKpTSl8/sy0Ne/z7/gnofi4fW7ZJSMzSaFzXx6/MCreU/r7/baeYf8LuSE8kbEs0kvQ7B2HTLDwEY8NQxDSOh92N0GsGQn5GqANvR2UUTH9T1WccadAHY4G2NvaASDI5yfE+EVr+2ii0x/ljrTB13oMlM0Hkz8vrV1OPOMlqs/zyGEn9S2dnGYBgxrPsf57xR2fn8NBevWP+R8A1//qF3SHn1x0b1uKTzow62p8ufDzsnktcabutg8OJ94a69YRUGgwNDpwq4UhsDouvrasZbAeBoYGceCkha049t+efVwXqntS2EwUcxW0NMW+6nbG2jTCPTi2d8AFTRs5juvXRh9RZQZr2XnLoiQwe3VLX4wFaNHawf1aMM0nOz/H52EOmkNGbo2hx2r3ziKDPaelrWwqABuUjYdUb66O4X93ALp7Jg3ZYDJZa1VMf15R2g2fi+hK5Iwm0x/nxA/jEksPfb/pH3eYZCRvK4YQmCCVwCdo6ljXwm/l3rPg4qJEYJYqm75/TPNo1hCFGDB5V5jyV4skLPAKwa+HJ1gSg6wIpsptuJxi9QUNqWLIndy6uZeBGTntOyBUbBFEFSrC4aDzmJKTbPonq0BHlWlpqvkBWaRDdg2Na1Ug8U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(86362001)(38100700002)(6486002)(966005)(5660300002)(6916009)(4744005)(8936002)(66476007)(66946007)(2906002)(66556008)(4326008)(8676002)(83380400001)(107886003)(6666004)(6512007)(6506007)(508600001)(2616005)(1076003)(186003)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yt47Hr7gpWpkqJZ7rH8Oec8BNUwl6UrvPw4CcHhxQmth3vBZvwXF9ice+7RA?=
 =?us-ascii?Q?wxSUuO0NiosL1PHMDz8Dw5f22qjME66KH2y+H6LlxlbR2j72/fGwSx48fBj4?=
 =?us-ascii?Q?vUFTQOIp5p8eHwCqoNmnI5/tlVC3gBchy0afPlwUuZebvJuLN6m088HA+iCa?=
 =?us-ascii?Q?LAqw6NH1GZ6NDjlG9ueWWt69ueScx5+dwBiH+sZKOwwNTm39PllmFkUPO8Jb?=
 =?us-ascii?Q?9lTy00F83XAMWg5GF+6FgG9zPRsHc8a1g/FcXit6ArKoodo1HO3R2Cfe/Efd?=
 =?us-ascii?Q?RQVXHgjfl6Kya4yYsHB0gAOumt91cQkbktDuMHWgbdhhcpqwf0wMzFLYSzhn?=
 =?us-ascii?Q?3iAUBxi8pzSx27PCZnk2saNdZLMwDiZTiZsUQyo7sUpcHv4M+CjmPH62aa9d?=
 =?us-ascii?Q?RKPmmvqhkOYenRhoid9mSTg9kR2dmPEUw+4X5fAjoC0jieXxxtcV5Fc47nfK?=
 =?us-ascii?Q?rMW+XDVLGVNhpYZRzfMFA1+8htWgl0t9GQCnJ+yNjGB/NVBNRezg6k99fdyb?=
 =?us-ascii?Q?faOE4Sn0ApPHtr2HoMei9P1ImayLI+MooouK3j9Bclx2a/oS+M0akDzoKemT?=
 =?us-ascii?Q?pnl3Sx6WqjXwo9+ESOx+RZbyWubY+YcwVxiTpjDGQflUG1EfMwuusFuCchys?=
 =?us-ascii?Q?BpmlvAdsHU3WjDm2iQwik2oE/WKdfAr1NAqyrEm53jo+m45YkFWDj8jZ28Je?=
 =?us-ascii?Q?MSHFRGE6TIwkeCFF4/MTz8sx7O8nMx0QJONQ1HidG/zTZB40+ijoHw2YZ60R?=
 =?us-ascii?Q?BcYmgb8effjnYgx7pmp3uYuO2ZYoEBX6FlgabJ+M8XDe/HLUSJq1mzXN55Kv?=
 =?us-ascii?Q?EUMBN3grHGshYMduTXHPViAnarWakw/qHD2cxbVPkkwq4oasLzjZxtJKnUdr?=
 =?us-ascii?Q?I0hdRWNr0GXTJNqKj2OjtLgFFQCjr3AJzMf55JR4zzXzlk2LGJ/GmGF0/tzy?=
 =?us-ascii?Q?Yzql6w6WSZuKa0q93gfHNR3qtCBrJeEUoC16StlVIkWW03JnDvkequE0wHV1?=
 =?us-ascii?Q?2QlgtZYq9pxKYFbMF1gh8/cYsb/51pn3KC/MkMUTQHAsKqHxZvqGBgU1m61f?=
 =?us-ascii?Q?50VL+EiDDUuQPqzihY/6iBijGWduPoTTJixvkh+TmH6LtY47jPYQdkCEhTx2?=
 =?us-ascii?Q?RnqXf1sy0/vtBXsIFVsbIA67FiuHzmyA1YoPoy/BjpdX7syYukQyZWQdKkIt?=
 =?us-ascii?Q?baPc56/wD5tZzoAi/pN/hpyspHU26WmyRScJQViJpFAnI0GWeEF1ykEw71Ls?=
 =?us-ascii?Q?/FKnMkrMSjqz3nPueHVS7OKMraQbMwYhEy45TR3oM4chdcsM3Lp4iCWLIm/Z?=
 =?us-ascii?Q?TLIYPif27tz34N8toT1rI71pUZ5PiaEqX/n8sjBf4UkniW7nBL1L9vlQrNv0?=
 =?us-ascii?Q?DFpOwm/942m3m9O3X/6cxqaxvujQ1FJ8y7gd8GIsuG6o60Q3EWWqWeQcLETQ?=
 =?us-ascii?Q?NIDH8PxbG4KeHkDIXOpcBCn0XCHtYSy+UZsqzMVA73xmx9NOZCb2iWyhorHE?=
 =?us-ascii?Q?Lh+nDJRlecq1t9X2XQX1NrZDHiMiWQ+9hXgLoXtiglPHfRJGqdOtjoaUZOzu?=
 =?us-ascii?Q?hg3fg24ym+CNezcT/lSS+Kjunowy5/PBzYRA2yT9JpTXSVWwA66IYYpobR5v?=
 =?us-ascii?Q?VJSWcc6pmbROjw7W+9i0ElI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b33dfcf7-ee06-4415-8c06-08d9f3beebb9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 15:45:57.4870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZhvgZhjsBKu8izs6+gF0xkci7hLnEEgjLHtCmGrlbglC0ek/KvmcMbCwYJm0PGvwYPWVY5fGQzpzMbeJrRUDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4340
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #1 solves a recently reported issue [1]. See detailed description
in the changelog.

Patch #2 adds a matching test case.

Targeting at net-next since as far as I can tell this use case never
worked.

There are no regressions in fib_tests.sh with this change:

 # ./fib_tests.sh
 ...
 Tests passed: 186
 Tests failed:   0

[1] https://lore.kernel.org/netdev/55a04a8f-56f3-f73c-2aea-2195923f09d1@huawei.com/

Ido Schimmel (2):
  ipv4: Invalidate neighbour for broadcast address upon address addition
  selftests: fib_test: Add a test case for IPv4 broadcast neighbours

 include/net/arp.h                        |  1 +
 net/ipv4/arp.c                           |  9 +++-
 net/ipv4/fib_frontend.c                  |  5 +-
 tools/testing/selftests/net/fib_tests.sh | 58 +++++++++++++++++++++++-
 4 files changed, 69 insertions(+), 4 deletions(-)

-- 
2.33.1

