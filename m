Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D23455549
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 08:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243728AbhKRHPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 02:15:46 -0500
Received: from mail-eopbgr1300100.outbound.protection.outlook.com ([40.107.130.100]:59840
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243650AbhKRHOs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 02:14:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTuDG6lG11PDbtwS2WX4X1tYXmxuwjPqIAIAkUsfiQJDj77bucYf9ZOtRYt7OgZw0vLEJtzAG0uiCd74b/x/xvw3zfkxCHGWr2yuZcznG2YNl/jrBC803O0JwibqZtQWviJFirMYbLKoHZZYyWDB2iHQlv5YBkEcW3Ut/o459zUULmfZK1XDj2WB8CumFgXFmMDa6/i+AQMHJWbTStqTUPTUSujQ7+pHPTFBeXCiuBg/Gn5tUpKY+ltXKp3DvjSuT97pzSIztuz4IXERLZzGDFbyKALK47cwtKWYmA40E+WFUkp1U4K0YFqEI7NohdT4f4778gWJ7bs6/VQ4vWrNNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xz4S2vwgc9spyHjppYLdM0fYGc5olDaIgqySHOWkIgE=;
 b=dkWdaYezdHc0cpJCxIIGfe3B4hkRvqP8hKqp2ua+4HXEfGYjN8wCh5yp78xm3BrtzhfyhIxZR7q4ChHW9n8USfRY2y4Vikc9UMHnSv7SmuJaffCvU4vL7qYtFeQjTwmlJ+w13JIONV8xspPxXkm7f9Dui79FvQqZ4dVBKullObj14t3vnU1WfWPg8m88XbiD2wlrLLwo62DBiMrdxp+78Wf1AiG4NpkrAGCW1NRhl4f8VrBTUnsHnKmtArSQSW4gZTE14z+vnb8XBLhqbLml+arrI0GV8GDuWiPsNu+9wVUnEMkkOyg3u47fuJicIUKYlZeeb59eC+X0sY+fHPQbZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xz4S2vwgc9spyHjppYLdM0fYGc5olDaIgqySHOWkIgE=;
 b=ILvHUsphdFHOVKkc2XUKpNtaMhdNa63nmm1f6kX09HcQv20YnV4Vqop22SAPOyrDIuJ+pqaG9HgNVKArYcstLIOOhnRhf//iCWrLjhaEdrKqFpf0Lyov+KZgewByK7BKEamid0z2Ze4J4s0e275bOTH97s8dtcbq9+GOK0nWJEI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by HK2PR06MB3427.apcprd06.prod.outlook.com (2603:1096:202:33::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.18; Thu, 18 Nov
 2021 07:11:42 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::814a:4668:a3bd:768]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::814a:4668:a3bd:768%7]) with mapi id 15.20.4713.021; Thu, 18 Nov 2021
 07:11:42 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     daniel@iogearbox.net
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davemarchevsky@fb.com, guozhengkui@vivo.com,
        john.fastabend@gmail.com, kafai@fb.com, kernel@vivo.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, songliubraving@fb.com, sunyucong@gmail.com,
        yhs@fb.com
Subject: Re: [PATCH] selftests/bpf: fix array_size.cocci warning
Date:   Thu, 18 Nov 2021 15:11:28 +0800
Message-Id: <20211118071128.13519-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <8f387f33-51f7-feea-d366-ceb5bbed0b51@iogearbox.net>
References: <8f387f33-51f7-feea-d366-ceb5bbed0b51@iogearbox.net>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0144.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::24) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
Received: from localhost.localdomain (218.213.202.190) by SG2PR01CA0144.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 07:11:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b5de4e9-9d14-4a22-add6-08d9aa62ac01
X-MS-TrafficTypeDiagnostic: HK2PR06MB3427:
X-Microsoft-Antispam-PRVS: <HK2PR06MB3427A0D02C50E0034AF9741DC79B9@HK2PR06MB3427.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q/v64AVQCeSBHzmNEgQIdMvUozES8BMQaO81CR/D9hVezXakqnuixBbGLwoU1rchEj+PPfUMqNDPZfwQrWLRsLeUXd7NoVviW4KuDQdqlzJ+0JAbwBs4uPluN9zpE37SibrtJS4zqOAZYgLR3aINhjahrYcAqkHkrzBJtVnwymA4D/UMtRaeb+rbRz3zGqJdlRs8k32TQ+9LS2p6KBFUzDe6qI37p6rKjDIdBePfpmCnlhWIAgIAXS5WG6BxOS/fP2+rhJNYUoVoE5HjGMwahL8Pf7Xk37rF+j8+jIl/SbswBwEXbKlTjOSNAsbdyx7kv0Z1OWolE3s+yiX7YzYv/1tLUTtBqmIEBEeq19e9vsVfGekmIbyrSlJU208JtUFAH+Tkr3B4zEKNN1cC+kODHtIuKdGjv/o3Eaxyj+7hjaoN3OEkP5/UCM0UpzjGcwIAqL44bdfAakYl3JIDpUbF/O/2JSow9r5/sa95hwldStMaSE/j3VVVwOtLBLIyWQe5lIWfHVkjDabFby4MO/GNJzxaI4n/4Upuk38yCKiMl+FiqIHMHVykWX+x+mh9KkXkIwo6HeSx6/xEWJxsuBmkS51ofIna/HMFvc00pz91YFPNXXmVNvSqZRX9MZUaIFh5LMVzOaUL92oTEWxqH7CtOvzlIow4KpV67OMknqp0I6/rkohpxeG8tHL+4PMdhC8+HzCKg7/8tIgnNwEFzCy8Fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(2616005)(2906002)(508600001)(6916009)(66946007)(66476007)(956004)(52116002)(4744005)(6486002)(6512007)(66556008)(86362001)(316002)(4326008)(5660300002)(26005)(38350700002)(8936002)(7416002)(1076003)(6666004)(8676002)(186003)(36756003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TAYE/r2fTuFIk2UYs2cdJwrnyaiBA8sMTw/eAPS74RZh3Ay4rLdJ/iFpgdrE?=
 =?us-ascii?Q?AnS0izd7nxDfJnU9kiZQ5Mnqks8xm8iWS1jM6WbKDkjuORtNP+3R7nzrdwT3?=
 =?us-ascii?Q?xpZzWOjuK9gZMHi87FRUleZCX4CsKi3TrspT7Fc2SnTv7NYaIzTtsKaU7tBU?=
 =?us-ascii?Q?AE8hO/Waf8wNaV7/0BW8jDoxeR/HZ9TtbYMTbSrOdQsk4zs+flne2Do23K2S?=
 =?us-ascii?Q?17zMYuUw1wjQw1hQ4NeBAmJ6Qi7UBiih/hexDVCTqQGwxZL1l4QjGc4HukYv?=
 =?us-ascii?Q?bRHdc0wma/MsZwjW3sT0ZtifuaMJK20i/b+L3WYHcm2587sw+YBlAvEjluel?=
 =?us-ascii?Q?PcN7GtVPIi9ba3sCR0Tz831OZBKnu9hJS/+o5kBmjYLzLmsMCowwNUVIE8Gp?=
 =?us-ascii?Q?SsgVMylPMDCbmV/847U9PFwK+EH8g+j7nRMCn4z7OA+Lvafwbnsizacut0oC?=
 =?us-ascii?Q?EC44FkDsU/qrteK6o1VmFsG71j0DaByuCjG6GY8Jrtm0M5NHrhiFW8xupEZH?=
 =?us-ascii?Q?CUj0Fv87rANDvbiq/+OpSdtY0/H3SRMLZM8KpQHnxR2W4FpW4YWoYjKCFei0?=
 =?us-ascii?Q?tYixohtSHu2P5/xhbrvzQ/QtlTXSEsxdWDYripZdLJIBt+wbdqZvOxkvhg6Z?=
 =?us-ascii?Q?01hYPTL87CNj+OwbMUC7T/qu93WfGCfvqhK6qgCaMW9tytjnVQfzXAOkjxxp?=
 =?us-ascii?Q?liQENC4XoSEHvFCoRojGU2N6fTeJkbZYE/3hAVbmyHYIIN0XNwV3/1IevZ2o?=
 =?us-ascii?Q?Qlfq+Ptl6rI77e9TfFrWT2NjYwO5k7Pg0ZWPuXo7rZSHiY9H2zFD6RA2XoFz?=
 =?us-ascii?Q?YUSx8oaBw5k+6a7q6q1Hs8kCP+JJM+LhB7MelYZDe387YWzglzyExXxId5Xy?=
 =?us-ascii?Q?wtupuUfjmakLHlHPRt+7aMBNWOA2N7+Xj8OdyIl4TDhcyh6TYfa49CTdeNjD?=
 =?us-ascii?Q?Aq/+ym93q6smcX8vB+4qb0Qfm2Riv87tzqw6TmUcuLEI7afLyj2sOfVTKOtF?=
 =?us-ascii?Q?tZ64SMkcuuUvlPLC4NLLuw31+ndG4m/A55T56MmLmgkcsdTvh0KyL/3xmeIN?=
 =?us-ascii?Q?cCHb5xhtQBDBoDQXwllt6nE/kFyWRDRvaVU1oSDnbVa6GA/ISWD3PkvdOxwZ?=
 =?us-ascii?Q?XSOEzBbipNKijkh0RGQaA9xR/fNqhaS51HpECdb+jJY6fkMCwwAKkJrI9jlr?=
 =?us-ascii?Q?SPT0tq/n+ZGSI37RVjdhH+7Oe9FLqmZL4f+2hcdWnY1XmzaIDIhPvLBz7JDb?=
 =?us-ascii?Q?gbHF3m9WBZBUqj2LbNznnbulnGUIn083G3r25EzKvdJacDCZXTYuFW2dAUDD?=
 =?us-ascii?Q?MoWtW8G41tWHxbIECOk47SSYb92A5ZUJwc3LsVh8yPf1GP/83tqKsPT00/MK?=
 =?us-ascii?Q?Zh4Mcf5adCVMYuNYJ9LG10beMdqWNECZYlPBlz2zmnceaiWiEd5biWQtNGoW?=
 =?us-ascii?Q?OkPUjSo8SX6QoMIGZM/VvdGJ7p/O9bGqOVLKlJ8dA+96c3GDHXVtJCVxo9JH?=
 =?us-ascii?Q?z0Sww7QTGEUgGDXUMqrVU0DFUuNjm+vSaJ+lNpzgl9kbEGp40l53taCq1TpU?=
 =?us-ascii?Q?M9tze/FGekaZFD9gCK0Kyr0UrPyCl5igOOp6eONhW4jm8UMglHUj2Jqh+6ow?=
 =?us-ascii?Q?+NFWW90HW5jCk7alkqA2hVA=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b5de4e9-9d14-4a22-add6-08d9aa62ac01
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 07:11:42.4091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R8dASP/AAiCD/f8T7QPbK22aWDqUiMO0/1M95G2UwhSvVKVAKlPiYJIhXDZYR4a3ssAUDfZzKbBOMicCROVqkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2PR06MB3427
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> No need for the extra include. test_progs.h already includes bpf_util.h, please check
> such trivialities before submission. Simple grep would have revealed use of ARRAY_SIZE()
> in various places under tools/testing/selftests/bpf/prog_tests/.

Actually, ARRAY_SIZE() in ./include/linux/kernel.h is diffrent from the one defined in bpf_util.h:

./include/linux/kernel.h
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))

./tools/testing/selftests/bpf/bpf_util.h
#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

__must_be_array() ensures arr is an array, which is better than the one defined in bpf_util.h

> here are many more similar occurrences. Please just send one cleanup patch to reduce churn in the git log.

Yes, I will commit another patch.
