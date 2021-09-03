Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6A03FFF5D
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 13:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348966AbhICLs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 07:48:28 -0400
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:11425
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233462AbhICLsY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 07:48:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmO4St/3LGCR7esyyM2MJanuXjETbxsKCQ2DDiBMN8x9E7JmcMg42BN76zTlk05TEgkX6Q0fa6e67e2znSyTuGbjBl9WkrwHLGoe9yr34kpJmMuWA6QgKF/akLldVAG2lRXE7In6WA2yMYrX8MCA6n6dCunnisYULyiof3EYMcSD0e3q5lBbU2Gbk6q65pz+6t5LhZkQypWSr35cJNrbGYjZc6Wcz+g9TaubdYMU2Qy9yg5elY+e4V9Ie4K4KuTY/IKvrBPTKRe8flNGGOeEpB0Z8/UUR7eCXVJsj3mZRhSXjYoQfOOprONJdusRdSHQ52ysgM6gqLGLhjConW3Hag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPt8VrMrbL4mgZExAQeWUV6gm5gc+UY8BvtMWzyjT0k=;
 b=cELOMwb+6ciQBq8DLD0n9ppnDx+ieEWlFt0+nQhatGnoSiLSFxOO4iSoL0BpScbXuFWPsbTRxNDS43ioDK393wDCRZWebACNTf2zGM4Rp964jjQ4Jvqw9fPKct1pwqsSKR5FGfu55o3uMCwdTPrx1VzG3UEaHwfxg1sEASpago1TaX/dC/UlKH2HxFq2yRDJQh5VTSMuPWnsGU8lAGX2JCutM1o0NMPokFnw1T7aDfGt0Fp41TDtriGxkGEhh1EKO83wjjvoK3vvSc9sARds6eZLr33b9jQ4wCXAOuJtnPYctlI060z3RAg9xLiS4WWfDjjKH3S8dZg+A16q34z0VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPt8VrMrbL4mgZExAQeWUV6gm5gc+UY8BvtMWzyjT0k=;
 b=I9dCwdsx+wru7b0+aVrhfHs3QiWq+WRS2lfRdK1jVjAxbf6c7OTNMAI9HaFt9CFuMJQOXhsHBF8+GJbk7D0eRrbCp2H/uSfGyO7XgjA7bwX9Rk5z9wQ6rMKO1YNvUWw56jlg7Y/uU9e4XWp2j/Lb8q1yOw/20DLKDzV2BfOYKs5mkpInDkIp12mj8LFdsHvTWbuorwfxPWkUUS7EIFaS1JSU0yT6sSpnbtqIdbAZQ69XDbaz02QhEphDV+Hy0vsdNtcVqqjfL4YRPF3045Er7gxlAzD0vZ6r6h7Ic1r+n4YfkFdNtTHTkFhs8ai50sN2jhQEtKrhQJoXkxZGHrbjag==
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL1PR12MB5271.namprd12.prod.outlook.com (2603:10b6:208:315::9)
 by BL1PR12MB5364.namprd12.prod.outlook.com (2603:10b6:208:314::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Fri, 3 Sep
 2021 11:47:23 +0000
Received: from BL1PR12MB5271.namprd12.prod.outlook.com
 ([fe80::6947:8a3e:27c4:c9a9]) by BL1PR12MB5271.namprd12.prod.outlook.com
 ([fe80::6947:8a3e:27c4:c9a9%9]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 11:47:23 +0000
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in add_del_if
To:     syzbot <syzbot+24b98616278c31afc800@syzkaller.appspotmail.com>,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, roopa@nvidia.com,
        syzkaller-bugs@googlegroups.com
References: <000000000000fdb19d05cb15c938@google.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <4c482173-e2fa-4533-13e0-f8eeb6218eb1@nvidia.com>
Date:   Fri, 3 Sep 2021 14:47:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <000000000000fdb19d05cb15c938@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0001.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::11) To BL1PR12MB5271.namprd12.prod.outlook.com
 (2603:10b6:208:315::9)
MIME-Version: 1.0
Received: from [10.21.241.78] (213.179.129.39) by ZRAP278CA0001.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Fri, 3 Sep 2021 11:47:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 960f6b51-2871-4cb0-0b2f-08d96ed0943a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5364:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53640022FE07D5BF80462B8CDFCF9@BL1PR12MB5364.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:370;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1C4wYKdNQkgwsgj9fH3dGq52y8oBMee4INIpJH02A7zkauCD3j2Aa/8cCSIv84PufDQuQS9jWi0GtZDjfoTgYEEzMl2wDIM5nrY0lP8LNpDLsMlhLf60EIlkPItfyAvwqFtQrCl25lF5B4bXd5WMPpE/2aWTT+6XHmtEraadisiCWzs/dxEHbMo8n16Ke6qAtkEqGNgi6mHrPP5ZZvRkoDEQffMSO1jxO7MW5yX/mEHKUY6zYRh9Tf3La8J5bx8/Kn3ZTEdo8vearuty1tCBmyK5RaEoaJlCz4Skp61YHkrdcDv0kI2fEL4Rn27p/aLMZPaAk0nH+GBElKgyWDbtFbhQ83cvGm1sVPAGx7REU41Jz+I0MqWtCtWZe8zy2gpDYAFUfD/ZT527593UfRmWRf0WUAOmSTBj0K3+RE7hrWEZfLRNf12T8plKS1UJ/fN4BDMsYGpzW2Hadn/jWRymxzJyIKwTW0idOw3+tcOu7Od88ctFNvlpU08oorItf/I7ABJp33h/soh+jyzrk1ECCoNLTW+DGhuligB/2sOZ0caYTZ0kjYzulWTAgwo5nRgPdBWxnwEgrzPCQB0hpEJcjzSZwEnITzjdkys/URNlzs3aU2SijnH3wxxQqMW4v2f1U82pXqatbXG2mMBHsDOrWIJGepgQK+TP3pEDrtUGDhyBw2e8OguQ0U6e8PAADDaAvDhgS1h9XXn6FTJfWNdPWmztIoQIR+HJS3QHFpqZGrJsHAYbIXvoht001MJJDZ7iLvrIbhPxkLOa5J9LA1TqcZ2Be9cBvQLRZ0ZvI9A+uC/PfXeKQOf46/ZDD7o0g/zVPGchuVioSioXo26n/v/pqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5271.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(376002)(396003)(346002)(6486002)(966005)(66946007)(38100700002)(2906002)(8676002)(8936002)(31686004)(5660300002)(4744005)(316002)(36756003)(16576012)(6666004)(31696002)(956004)(478600001)(2616005)(66476007)(26005)(186003)(53546011)(86362001)(66556008)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTg0UkRhNEUvajcweEVab2t2NEYwSzRTcEd6aWpCQnZYTkI2K0U5S2lScFlq?=
 =?utf-8?B?eEhSL0ZqMkwwa1RlWVpjbEhQNm53a1UzUzY0MUtpTDhaSXkzOEYrbXZMNVgw?=
 =?utf-8?B?akxyV1hSRXF2YldpaEZreGR1Q2RtOTNjY0JsODU3Nm9pSFVqOFNRUyt6UkJ2?=
 =?utf-8?B?RDNsSDF2US9lMjU0dWEvdmUzcDZ4NU52azRHOVVsZzFGQVZxUmo2NWNRWmtC?=
 =?utf-8?B?NVAzOW05QWVwUzFOQ3RqNFhucHJ0MFNwY21QUDlZOFA1OUlqdkpBcnE4NXZM?=
 =?utf-8?B?VkxuM2pkbmVOQUkwZ0xQZDRXcG5wRzU2SzRlaXdUbHdHMmYrS25paEJPUlZ5?=
 =?utf-8?B?L0VlVitKWnJkeVRDVU8rMHVqS0l1emtVYm9KeWpvVFlJOTd2VDdFRWtvVkJG?=
 =?utf-8?B?Ti9QbFQxcllZdmtRSHZwQm9oaytyMTYvSXZESG0zcXV2NGVzTGhsdnBZV2o0?=
 =?utf-8?B?cG5ZUmxoYzJ6bE5Eb21uUlM5Zk1tUVhuYjdqTkoxelJjRStFem0vdFNGUXpC?=
 =?utf-8?B?RGZRejNxVTJlTXBnRHp2bE9qbVY0QVUxSW93R050bXRWcW9RM09tQ1NOS0xz?=
 =?utf-8?B?bXBrQzVqNjk2UzdVM1ZhZTJPSUFvOE5xS0hEUjU5S1orSUViYTN3aXNJTUVY?=
 =?utf-8?B?eXBmd0tqMHFDK1Zqd096Vk1MSS9MRStLM0hLNUc4elZVdjJJNVBRZkJaRURT?=
 =?utf-8?B?dGozQkVHM2xVVFR6VjgxbjhaTUYwbUdVcGY5dTZUMENEOTNhVnlSdjZWQm1i?=
 =?utf-8?B?QjJyUDJGa1lhalVTcWFtWFJIN3RrRmVJMnJxMXlGV0lIWFFGNXIyQzlGR3g1?=
 =?utf-8?B?azQ5ZEFCeXl2RTQ2aDNhRVBlZVpyU2tiS3gxUjhueHFzNVdGZGFvL3NmeUlO?=
 =?utf-8?B?bGg1Y1c3RjYxMnhQVkZqcld4ZDdxMkdTOVljb1N4ZFNlSzlnTXFSaFQrNWlu?=
 =?utf-8?B?d05Ua0dNbm9BeEsra0tjT0hscXJUSDFNLy8rZjBvOEJOWThENWthQkpiOURF?=
 =?utf-8?B?WmJxZW5CYTRDTVFIMHQ0OGxjdEhYN0ZoY2diWEppN3FOK2t5NFZ5cDlDZDc3?=
 =?utf-8?B?cXlIbGw5SGxBa2IxRlM0Z2Y2b2Zab2d5d290L2JtM1B4RGpwNlVFbk1PQTBu?=
 =?utf-8?B?ekYweHNkZnZlTFNkTXhNRnlHUHQraGtFNThGSkR1WHpyZUVMZjluYm93V0Ev?=
 =?utf-8?B?Zko3dGpQRXJwRm9yYzVZUmJoaUk5WU1WajJSYlFVMTIwNkJ4dE96QnVTaUlG?=
 =?utf-8?B?NnA2L3pNRjhMa1FJYzVLNlI0Z1Y5Ulp1UDRoTHFrZHJqdHVpQjU5NWdZaU1t?=
 =?utf-8?B?Z3RBRHQrK1RJOE00TmNDMmk5VHJYYUxjbXRJdzBLb2ROWUpaK3ZzcktmVkpF?=
 =?utf-8?B?ZXViMEVPTThSREZiMlhDN0lhVDFwd0tuWitiTFRyYmNlQ2ZOTFhsei9Jdk5z?=
 =?utf-8?B?OTJoSXBmR2JoRVhmY0gzL2RGVGxCQ3IwNE13ckQ4MDVUVzdxdHhrWUFqRTly?=
 =?utf-8?B?U05RT3R6TmJSZkRwUWN1YlNjcmJIMm5FWUNQcWl6TTJBeFhWZjYwNkc5aXV5?=
 =?utf-8?B?MEJwVEpjcmhMRVhZOXNTWWhnWUh0Rmhpd2xyM1JvTmdaQ0wzallRTW53VG5a?=
 =?utf-8?B?NFBRVDFMdTZZcHd5SWJpd0dQTVBNZW9jR2NxdU94S2ZJV2VXZDd4OXhTbHRL?=
 =?utf-8?B?UXFSMFh3OU1vUGpyTEZjbWoyaVlQa0RLK2tWbGtidXd4REl6Q1ovdGkrRVZS?=
 =?utf-8?Q?G9ihlmhgGgheMztoLSAr8XKTElgmAb5g50Td3Dl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 960f6b51-2871-4cb0-0b2f-08d96ed0943a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5271.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 11:47:23.0110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CUArQldMfv7LLjZMrB5XsQ82ifMIR7pfTyptEkvRouE8pJf7XwQXuXdM3qFnP+1AOtugDQ8sOznXhHw3nTGUZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5364
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/09/2021 14:42, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-and-tested-by: syzbot+24b98616278c31afc800@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         d15040a3 Merge branch 'bridge-ioctl-fixes'
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
> kernel config:  https://syzkaller.appspot.com/x/.config?x=aba0c23f8230e048
> dashboard link: https://syzkaller.appspot.com/bug?extid=24b98616278c31afc800
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> 
> Note: testing is done by a robot and is best-effort only.
> 

#syz fix: net: core: don't call SIOCBRADD/DELIF for non-bridge devices

