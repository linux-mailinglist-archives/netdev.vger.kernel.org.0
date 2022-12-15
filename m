Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E4A64D90B
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 10:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiLOJwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 04:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiLOJv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 04:51:28 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2076.outbound.protection.outlook.com [40.107.105.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48156BC83;
        Thu, 15 Dec 2022 01:51:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9TTtbwi+uzuXLxepRG8vM2Q/fQpZWtUrGQB2dMT8CQyqGSnDcJYxoCX0Lg+4Tl497KkuYzKe+aqmnoDRoqxQxL+M63Z84hWvUPZ7ruvjH91gIj8MIRDc2XGBytG3LPuFtNT909lN65McPpVfZ74EITKrPIa40Vv7r/tiZieN1zRUcf9OmV8WPvwVCG55pfE8LZjvbut/m1tztNACOWHR6bFR5Cz4MWh6cOwFnqxGfebi1g+yw9sQbyyk3pq++SIMJK3hFGG0voezJl9bK8hUrwil4f/un3W7ahM50EiQeSEsT4vInd0CdqYND3BkJ7MCQS3FU8XOXW1NcLGxkCIZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1OCHej7GBNdfzFGHjQ/PYQAhOBAWjxB0dE2EFE0YarY=;
 b=J6ZfM2TL/NqpxZuEebZXXW2V/KZwI+ondT4WFSJ2/G7zNLKwAE77ZNolz+nnBuz8qES2Di5xQfgac6SdzC0/cOJFe5CXqN+yEbMbBbx1REesB+XDFjIq1Sgmy2adnrFiTnKcxm84m9RBuqkMYjt3c5yixV42S2J3Y2XefkelX+VWlWCVoKtKd0bEKtDKpozoR/Zti1B+6qemIrGYwM+rJw0Qh3LsNfOwbLJkPQekoU1BosvWE0U6af2ai7y9c3Vu90GZRM3jUaddg1K2dA+vwdM+QW4intx6Qp5JaSD+eCJXQUaeyvxoV25mPDqNXmsORp7uyDf7xGOmJbdIYjRfdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OCHej7GBNdfzFGHjQ/PYQAhOBAWjxB0dE2EFE0YarY=;
 b=krDNn52t5f9w5cWgAraeJ9puOxGO+1CAZPI/cEOAlf6jJDrt9p/dx7hd9WbNFMl76xZ8j7vwtrq5JVfUL5+HjHHbUKIq59sEkl3Hd5HNxQ5L4vPPezef4jtD5uCHi17PXKbjCuSL0CznwJjf90zDl9rClg4a7+E076TMhoMXDeZFYPwhrtnEChrBAjvNyQ33rGVWXWr/OQVkF90wpeXWhVantUt6xAP1pMUC0e6LW6b7QoAm4Z6qDVUFb4MYjdX+ot8gcquo9Y5sWc0aSsXdgwhefzVNEXGwNpSlvTiBLCTjdk/CYNnYYjJntbBDzFPIt2+esCa4QMG9ks2r9sBnUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR0402MB3395.eurprd04.prod.outlook.com
 (2603:10a6:208:1a::16) by AS8PR04MB7896.eurprd04.prod.outlook.com
 (2603:10a6:20b:2a2::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 09:51:17 +0000
Received: from AM0PR0402MB3395.eurprd04.prod.outlook.com
 ([fe80::14eb:6506:8510:875f]) by AM0PR0402MB3395.eurprd04.prod.outlook.com
 ([fe80::14eb:6506:8510:875f%7]) with mapi id 15.20.5924.012; Thu, 15 Dec 2022
 09:51:17 +0000
Message-ID: <0a361ac2-c6bd-2b18-4841-b1b991f0635e@suse.com>
Date:   Thu, 15 Dec 2022 10:51:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     tariqt@nvidia.com, yishaih@nvidia.com, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
From:   Petr Pavlu <petr.pavlu@suse.com>
Subject: Part of devices not initialized with mlx4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0053.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::6) To AM0PR0402MB3395.eurprd04.prod.outlook.com
 (2603:10a6:208:1a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3395:EE_|AS8PR04MB7896:EE_
X-MS-Office365-Filtering-Correlation-Id: 0082888d-c22d-4948-b951-08dade81e912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pzFAKDWnxLry7V5AlYm5xd1uXWWk6BJrS6ed3+szDkK6Nw/jJUWU4R28MaHPDiIgOOrLLbIdD7v3vzMUxov5DnwUqwDOAaG58af6JCfJ06AAzLv2OMieQ00vBt4MWmZggkrpGyNsup6A/rysi/jKVzjyha5qKcQEstS8EIj3GNJzoLO7ChvpXpbAVzLyxrLMAcYH25n2q6CWV2uVYpkHtHE6Ed3lUoXrdeNnjAQDMFRoe+g6ohOeLcGt5pOpIl38dcyDaxvj4JmBPylreIhVwoblTumQlbQCzQ92qeE/JjzU1SdR9eHPN3w+mqWs6kTq92IPllUZ7gfcx0H4tJ5hyhwfmxW0D70BpPY2+RYjSZfb2mwCity3Y2I/8rzZ3rHQ1EXc6nfzLNuexEUTBx/Z986NXMWZ6KVuW9Mj5n0+7lub25qolHNhKK2OYUmhT1qLnEgefhWveH4lLpG1ME37kWtF6rjO7PITRRRxdIsehMTXV2JITJBAGp2pijcr5hqx29CMKLHUAnXxGVAeamtebQLHh9mF/VAMrqvknag9KkFtERepmdpYsBGfivUodSOdWAZkWU7VS2DTRyF8U71YMpafPS989i8mujtRCgjA2wHVbpqH/fjAky8tljgY5seTN5JFBeqsc9tyj/hl336Mt3Yj+FvkE4GBEWwIBZu223wAe/wCTyApRIrt+dMyUA/hJ65i51QKpXw+2gBYNt8mC+VP3m0GUU089/19DOMt0jI+j0bi+3cFLSDb0PrCMsaZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3395.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199015)(86362001)(2906002)(8936002)(31696002)(36756003)(44832011)(55236004)(186003)(26005)(6512007)(2616005)(6506007)(38100700002)(83380400001)(31686004)(6486002)(316002)(966005)(478600001)(41300700001)(5660300002)(8676002)(4326008)(66556008)(66946007)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFladkcxdXJZekZ0TkdSdkVjN1RQekhSc2hsUFkvZWMybnJrbWZjTy81alpV?=
 =?utf-8?B?THFaeStLc3JMZGF1OXcweHlNWGp0dDd2bkdQUHMrUmJjRlZpYUdtdncwUEVl?=
 =?utf-8?B?SEwxWTU4Wk92cTY5c3FGLzNpaFBNZWdvNGhldVMxdWtXVU55S1Zrc3hWU0Mw?=
 =?utf-8?B?UVhUL0NyQTh3TWNTM2RFWWd2dElDdFFWNzVVOWhmRlQ3eG5VYmhPQjlEQWIv?=
 =?utf-8?B?ekpJVzhTdXU1VWRFRXdHN2FLQUVhK1BDU2lQUjBwTHpLODRWT2dncGNuS3FS?=
 =?utf-8?B?dU1wZnFYUXV6V3BucVNucmN5R3FBcWwwdEdQZHRnTkN1WmRxbCt0ZHRtTFVZ?=
 =?utf-8?B?Z0tuMCt0NDFkSE9LemxQSkZTc1JYMHQ1MXowSEJ3QzhQZTVPRHFrMHJ3NHdM?=
 =?utf-8?B?cDFOMm5RNzZtRGFoaWtiR3JZZUdmOE1RSkVaTVRGRm9qSkJIUGtNMm9jUklO?=
 =?utf-8?B?MFFoYlRCMDBNME1jdVB4RnBLT3c3RjRWaEJkMXBSYkVXckpMQ2xSbEdTb0t4?=
 =?utf-8?B?RlgxL2tKOVN4dTZwWXQ0QXFpUVI0UlRRb05NY1o5UThBVGl4U0IvYkdnSGtB?=
 =?utf-8?B?OHc2N216V0FSQjNXR3V2Szl2eHBLd0ROSmdpdFM3TXdxS211NkVDU3JZa1ZV?=
 =?utf-8?B?dTlZeTdtYWUvNVNtMWpOVjBUZ1R1QzV1Y3FOZjNYTHRWZ0NFdEtJbmc2bFJ4?=
 =?utf-8?B?L3dFUmZoSTJ4RmV5NURHOGo3OXVadnl3QjRDdWdEaWxpZmxXV0NzUldNbzBV?=
 =?utf-8?B?aXQ5ckNUaGVRdy8yaENoTFBramhZZlRYNnROT1lVQktDSzREMTI1ZEJVTzhi?=
 =?utf-8?B?TmRheEU2M2RnUUNONmFFbHhkSFFhZkpBTldPRU42NWloeEY4QXFJcU1GZnh3?=
 =?utf-8?B?NGpxNktmRVYyeUdsV0VFc0NSWFFqcWJPanhIK3QxU0Y5cTZ0S1Y0L2NlMUI5?=
 =?utf-8?B?TkR1SWttdXRXeDM4SnZtUHAxQVdkQ3VnRUtCUk9mU2xtUk9wMzFhQXMrUnVH?=
 =?utf-8?B?RlNqWU9yUkdxVVJkOU5ja2xaYUFLUHRES2VmQWxQMDJhMS93dk1UOG0xY2JP?=
 =?utf-8?B?OTFEaGZzVUV6c2c0S3I2RExQKzFGWkJhV0VHSFdqUiswdzdXM000ZFR6T3Rr?=
 =?utf-8?B?S0lQOGsvMDA4amJWcVJ4VDhnbXFXbzM0TU5ZNnZmM3hJZ1ljNEQvVnJaTi9v?=
 =?utf-8?B?QTNZU29HVVkzVzJycTBiTXUzemIwWVFFSHJCRC9IbWxIR25oYW9sSVVObTB1?=
 =?utf-8?B?V1BvZTBBc25ZdVluUGJpaVhGZEJhRWVTZ0hpRmFxTk91NkY0bXhFR1lldXdr?=
 =?utf-8?B?dGlPRXMwV3k2U290bVA1VUtNcnQ2Y3pBUXp3VG51bHNhYlVPTXQ4emdTSHQ1?=
 =?utf-8?B?TTZNdXNkL0MvYkZ4TWt1cVJTNERiZG5pRVQ0RHoyMC80cG40ZFZmOURjaWFo?=
 =?utf-8?B?Tm9jUUpHcWo5TVZmMGxTaTZEajJNVzZpOXMzMlgyaTZNWEpEdVpXSDNmNjA0?=
 =?utf-8?B?SmhYcHJoQkRNWWNVaUs2NE1IdTZJaDRSQWFZcGJkQ3NVS3pLTDNmMS9WYlFY?=
 =?utf-8?B?WmZXMjF2QVZZcjdDSmxCTERMNVoyTFJIeXplRk5KOHhpZDMxd0kvQ2xwQjda?=
 =?utf-8?B?MmVUcjEzc21iYVgyT2NhSjErT3J0NHlYMHNBQ21RZWZvRHhsVU90TzZFQ1Fl?=
 =?utf-8?B?blBmM3Jhc1ZKRXJDck1WYmFpRVBuR2kxaE5QYVZQNHJNTG9Zd0kxbTI1U1VX?=
 =?utf-8?B?VXkrN1Nrb2JwdlhtNXMyUGNoMW9LWTA2THFYb1YxNkJCek96OUFDQ0RGZVRG?=
 =?utf-8?B?R0ZrM3U5VkpBRmN5dWl6T1g5c0UvZldqL1VUMlVCa1RUU0FPSkp5RU5aaE5H?=
 =?utf-8?B?bHVPK3JxRXNsdHd5V2dTSFdKN0JxUXdsMHZiSDRreDVwckhJZTNFOE41QUF0?=
 =?utf-8?B?Z3BQWnp3TmlzNjNyUkRqYXd0U1JESHJYT3kxTXE3VUJzZFdHR0R3WTZHdklW?=
 =?utf-8?B?Y0tudWdVSDRJOVpnKzNyeFZSZkVpVU5lSzFtQjJ2YmlnUEtMZGdrb1JodXB2?=
 =?utf-8?B?a01LVjNzaENhWHNXU21lZ3pYOVhwUXZ2S2E3a25TNzJnbDZpaGhHSHhGRkZy?=
 =?utf-8?Q?EJ7RANiobkU0sryb1P8FrVz/j?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0082888d-c22d-4948-b951-08dade81e912
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3395.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 09:51:17.0687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /zqP9WIjs5ZVCJOcPupZOXvKON7nt3DeHGrI5sexaocwIv7mzehB9VpsRfFPYcgM6tHICHMXzQ8tzHYJnFAg8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7896
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We have seen an issue when some of ConnectX-3 devices are not initialized
when mlx4 drivers are a part of initrd.

The basic scenario looks as follows:
* A machine has multiple ConnectX-3 devices, they can be VF ones. The system
  uses an initrd driven by dracut+systemd. The initrd is built as no-hostonly
  (think of a VM image) and includes the mlx4 drivers.
* The machine boots. The initrd invokes udevd to start inserting device
  drivers until the root disk is available.
* The udev daemon inserts the mlx4_core driver, which asynchronously requests
  a load of mlx4_en. This is done by calling request_module_nowait() from
  mlx4_request_modules(). The kernel spawns a modprobe userspace task to
  handle this request.
* The modprobe task finds the mlx4_en module and asks the kernel to load it.
  The module loader runs the init function of the module which starts
  iterating over mlx4_core devices and initializing their eth support.
* The root disk becomes available in the meantime and the initrd logic starts
  the switch root process.
* Systemd stops running services and then sends SIGTERM to "unmanaged" tasks
  on the system to terminate them too. This includes the modprobe task.
* Initialization of mlx4_en is interrupted in the middle of its init function.
  The module remains inserted but only some eth devices are initialized and
  operational.

The modprobe task uses the default SIGTERM handling and so this signal becomes
fatal. Specifically, it causes the create_singlethread_workqueue() call in
mlx4_en_add() to error out. The workqueue requires a rescuer thread and a wait
on the new thread fails because a fatal signal is pending.

As mentioned, this can result in only a part of all devices being initialized.
It could also likely happen that the modprobe task fails in some other obscure
way as it has its root switched under its hands. It is a task that is
completely asynchronous from any systemd control.

Has anyone else seen this issue before too?

Note that some parts of the problem are not fully clear to me yet. In
particular, systemd also sends SIGSTOP before and SIGCONT after the mentioned
SIGTERM signal, which can actually in some cases prevent the kernel from
treating SIGTERM immediately as a fatal signal. I'm waiting on some additional
test machine to analyze this part more.

One idea how to address this issue is to model the mlx4 drivers using an
auxiliary bus, similar to how the same conversion was already done in mlx5.
This leaves all module loads to udevd which better integrates with the systemd
processing and a load of mlx4_en doesn't get interrupted.

My incomplete patches implementing this idea are available at:
https://github.com/petrpavlu/linux/commits/bsc1187236-wip-v1

The rework turned out to be not exactly straightforward and would need more
effort.

I realize mlx4 is only used for ConnectX-3 and older hardware. I wonder then
if this kind of rework would be suitable and something to proceed with, or if
some simpler idea how to address the described issue would be better and
preferred.

Thank you,
Petr

