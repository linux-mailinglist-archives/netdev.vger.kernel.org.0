Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CBF3715C7
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 15:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbhECNMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 09:12:40 -0400
Received: from mail-eopbgr50099.outbound.protection.outlook.com ([40.107.5.99]:63815
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234029AbhECNMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 09:12:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VI/oZuFkTEu7BAW56+3IDXRdftYTg86nyl9bPe2H8h9039nKwxDolIHjs6jmXOj2eJDYHDPbSHy8YMPKwyT06yTI4zGpJPRFHyk4by3BQTeWsiUT0iwySv2DQpGvDj3atNF9lzqrFvg8OMe4f5ishx6FxfE13eVvz8lj5Kk0mlcrcR5NHIPf2nYa0XGFDndf93eSt7WNb+Q7ghjpd+kDAIrfApgOPKzFGdIUUE/TJHBVVJOKP73Qjfv8GB+9GUJ27wWgZg1x//MPQwRC9JJ9P74maBfQoWePvA9Bk2Eo3yhRTshdOFb9Tw7ZiYkkN6iN2OJBlOdURSb/XUVP2+zxTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jATvpZeTQ2y8iQdYPbHyCvbwgHGaFRRVtIadmHqC4uM=;
 b=f20O112tFAANHlZJIqa8Ywj9aQiEUMYB0vqV7qMfyU2NptrnwdyPcYouKrgp6TdNX+jr4fvjhFxIPLoCJtzHVGaG/ZceeCcOxlnUk62vIRG4YQ2njEKaiYPAAAu6QbMWI5iLSVX3VZ9eqVVITPfgtgJXxyjffobm47YWCzrhFrTBhe2xzOHBJuosREtYdYLhk8UFZu2/j/0s7/MSpUUR4JeueX/LIwSUZgwkjKDFpVYKW3oyVJ2L6xRqZ5Ohd6+wtMxRjjSXsHWFUfScLZBoD+yLP09Mz7vKxvRv8IfHtiaoLsJ8yRJ/IoPmYHHEXmiKYr6UePPeuA4U58OnEll28g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jATvpZeTQ2y8iQdYPbHyCvbwgHGaFRRVtIadmHqC4uM=;
 b=MmO0MAQTBEP0VNNsaKsMef8vBGGDWwVBWcku0DAMmTjZit+NxcYe4GvEnSfoh+0tRnS81dtSyb7s8wLlSg/fhRUHBy43WLTdOS7xdYMt7qkJqGCYWhs9/6j9Cni0zDQ6SNV2+AGgFym4zv8VpSOJCox4Va6tl075SWMZCir6JQ0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB2481.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Mon, 3 May
 2021 13:11:43 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4087.044; Mon, 3 May 2021
 13:11:43 +0000
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        =?UTF-8?Q?Timo_Schl=c3=bc=c3=9fler?= <schluessler@krause.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tim Harvey <tharvey@gateworks.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Null pointer dereference in mcp251x driver when resuming from sleep
Message-ID: <d031629f-4a28-70cd-4f27-e1866c7e1b3f@kontron.de>
Date:   Mon, 3 May 2021 15:11:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.250.134.29]
X-ClientProxiedBy: PR0P264CA0285.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::33) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.27] (109.250.134.29) by PR0P264CA0285.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Mon, 3 May 2021 13:11:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dedab1b-ccf5-48d0-2739-08d90e34ff10
X-MS-TrafficTypeDiagnostic: AM0PR10MB2481:
X-Microsoft-Antispam-PRVS: <AM0PR10MB2481B3486FE7D34C4C0ABBC3E95B9@AM0PR10MB2481.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y/n1a5B+z9j6pNRewflbmVIPiWDAxukZDZatHhna/6x5HVFdrX1ipBz+U458eueqPfCK+ufrTwDUk05n4jcHKdikvAKcChpYSZoRgKsFijuRLS6xYOohl2mPskbZIcLMCSCpXncQVbqftZ+aXWsn4TrGCAyH2Fmegs4PzWGg+ncDO26vJQOjxmAPm2lhoEZvhITfahT/H5OHbK3tuqOqW+GLJtHKa4IvrEGwyZVsAWXPqUlpurqXFibwC/vqFnVeuElnD/EjkvSKIZcsBgkt7I+zpAZTDpBnbUI7fJUGMW8gsHCwb/Lpqoi/FipcWmy5NpVOvkCzyL+KLrsBhyQDQoRxLcr1muz3Z4KbJPsdlTfkeheWgeWlhTbN4lKu1kPT1jdLEbj7f6khXSKJ7ONpgLnxuO8jGlQJIrlPwgjx6iAbyddGRC61lzXAs3U+7tbP3ZYPQb3BtHQbxCPOmSwAhkFY9iT3rvgJMsVEUFG41VdCiRnO2pZXKVr4ehDAt9UsuxuxvOjj/H9YLtkrF2Y+VK8WtUZ2MHOkJQqrv/8TEt3kXZdnATE+T7TxrhJtPtBK5AgypepRrxqYahk553uECzQ5A2LZ3jOe5NsuRYVrdXgFbuTUhLQGdtnFLIRKfW7mTH+FoiudNSzD6BDFDnKmNwLMfzSO5e8odPe6JmtZ33pXWclLmHMiqamM2xs7I29w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(396003)(376002)(366004)(136003)(186003)(16526019)(36756003)(38100700002)(7416002)(956004)(5660300002)(26005)(316002)(31686004)(16576012)(54906003)(86362001)(478600001)(2616005)(6486002)(2906002)(44832011)(83380400001)(4326008)(66476007)(66556008)(31696002)(66946007)(8676002)(8936002)(45080400002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NGxTQVVpMHhTZFZjcUl5RWgxcHVFNjBQZUF5Y2x1VUhPanlIVVNneXkzSm1p?=
 =?utf-8?B?ZWg3VHZiQTUzL2gzczVvTjdRZTFlbGlRcVNLK3VvQ2pmUEJJeGYwVU5ieG8y?=
 =?utf-8?B?WG9yNWNYU0I4MjJpeFZxdGhGQXJNc3FBVGtjS3JFaGZLazBsR3FXWmd3c1l2?=
 =?utf-8?B?SWJkUlRiT2xxNFpkOWQ3b0p6aWdkc2dDZ3puWFcyTTgrajFqQjVBMXBzbzBJ?=
 =?utf-8?B?ZEVidUlQMjVBcWs4WlJJTTNsajZyUWNvNVhlbnFKbTVsN1d1ZzZZb29QaThl?=
 =?utf-8?B?M251cFpKSXZXOSt5bzYvU2hURVpMVUdqOXNadGxDVnpJSkRiWWRod0g0dVho?=
 =?utf-8?B?Q3BmdDZzWmZNYktjWm9lb29sOVIyVEoyRnNCcUVzbG0vK3BDb0R2MkMzY2FN?=
 =?utf-8?B?QXIrUm9GL25lTDhIQmNrUTJJSGNBM3NqQlE5QzRhMFFObVRpdytONStvOHBy?=
 =?utf-8?B?NnRVd1R1cVovbk80bHluNVV5VzQybURBM1ArVXlFc1VndVRpcHdMbi9hcmVs?=
 =?utf-8?B?a1lZNWpGcWJEQW1BNWpYTmdidDRhVzIxRVFiVnZHRnlkODY1eWl6ejd6SStJ?=
 =?utf-8?B?eHNvSkVvSTVJMjJveDFPRnpmV2drd0VrL20xQk9NVVU0YUYzWWJGNDBwOTdC?=
 =?utf-8?B?aGk4RHpxenBvdXhTUldXTnhQbTBoTGh0OXhCRUxrWEhXMm5UemswT0M3RVZG?=
 =?utf-8?B?UTlWMzdPK09nNTNiY0dvUmJDVnpPbWhOTEFmdk54K1dlalBRaWFKRy9qRWZQ?=
 =?utf-8?B?Tldqb21iQUZHekRNdEd3bnR1QXQrZTNnd21PdThqOTRROFdSNWRHcFJqa2xE?=
 =?utf-8?B?MWlZWUswTTQ4RC8vNjc5b29FVWFweG1xcEpNWjFoQ0xPK2w2Q1lRTUJtR2VL?=
 =?utf-8?B?RnpJUUdXSk5DVkU3a1ZjM1d4VDcrVGtZa0M3ZlVqMGJrNWQyS01iUGUxTzJE?=
 =?utf-8?B?K1NDY05VZkdJaTJEbkFmWTZZTnJpYlh6bURZYjVyekJ2dWplY1FBODdwaG9w?=
 =?utf-8?B?c2swN1pFb3NHS09HRURjLzZCN3UrRW9aUU4wMjhJUXdKckdlajY2R21YSGIv?=
 =?utf-8?B?NFJOL0d5dEhuMC9Fd09YRUg5ckJ3amllZjJpWWFoTUtTV0RQdVVBSUV3MEly?=
 =?utf-8?B?MDgxNTR1anErSGtnNFdFYk16cklMM3BvSkt2THVkSndEN2FjN29kWnNqdTdz?=
 =?utf-8?B?UENlOVNib2tnTDVweGRKbXpZb1ZKcnVDSVdQcFJRWSs2TUZIWFhyeldHVFRL?=
 =?utf-8?B?TldMeTZSYVROYTMyTnUvdWRJRTMxRE1aUDJYZ3NMYnVFMzFkNFZtRkd5MHVs?=
 =?utf-8?B?VFE4OE1kMVV4eHRoUndXUGhGMmx4MmdqLzNvRjB3djhqeXgzazFuNTh3b1Ja?=
 =?utf-8?B?QVlYRkVyRWFoU2hOcUVTbGkrTlhiNTFjekNmQm44L1BnWnk0Z0tTeTlKRGth?=
 =?utf-8?B?Y0pScG9FU3JGOG5oUEh3UjZPZjl5UFgzK01FeGg3M2NQSTlSUElCS2htTlRU?=
 =?utf-8?B?eUFCUWI1TE9IL0NxQk1maFQzeGZDbnJ2MTdKendmVU1wVHZzSDIvL2hQMlYr?=
 =?utf-8?B?U29mTHpGUlE2Q0JLNUFtbE1maVJZQmQ1aDZLbHZrSzRwNUdURmlTWFhJWmtN?=
 =?utf-8?B?QytLbDgzRzNJZ3BTcEJQN25XeXVoRkR2TGVOZk1UcTIwUmNxR085bzJxRmZH?=
 =?utf-8?B?bWVYMGRhdW1yUGh6RlBqeXhud2grOFdDTUpaTDJwY3ZCQzNCaVdBc0QreFdF?=
 =?utf-8?Q?ZsbXIJ+FsyHFGey8czyDJFq285TvAXXfeAUZrMQ?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dedab1b-ccf5-48d0-2739-08d90e34ff10
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2021 13:11:43.1202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AL1R2xvKZH5sQbG6/jLS42WM+zyh2cf1CIzWF6Y/aivln9QChWFJK6PJJPJgIVZOS1vkL86QrbNkQEwFHWFKoBESx0v9Ufz/+59PgNATcpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2481
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

with kernel 5.10.x and 5.12.x I'm getting a null pointer dereference 
exception from the mcp251x driver when I resume from sleep (see trace 
below).

As far as I can tell this was working fine with 5.4. As I currently 
don't have the time to do further debugging/bisecting, for now I want to 
at least report this here.

Maybe there is someone around who could already give a wild guess for 
what might cause this just by looking at the trace/code!?

Thanks
Frieder

[   32.626311] PM: suspend entry (deep)
[   32.630030] Filesystems sync: 0.000 seconds
[   32.635031] Freezing user space processes ... (elapsed 0.039 seconds) 
done.
[   32.681296] OOM killer disabled.
[   32.684542] Freezing remaining freezable tasks ... (elapsed 0.001 
seconds) done.
[   32.814861] Disabling non-boot CPUs ...
[   32.819277] CPU1: shutdown
[   32.822002] psci: CPU1 killed (polled 0 ms)
[   32.827052] CPU2: shutdown
[   32.829772] psci: CPU2 killed (polled 0 ms)
[   32.834859] CPU3: shutdown
[   32.837582] psci: CPU3 killed (polled 0 ms)
[   32.842362] Enabling non-boot CPUs ...
[   32.846629] Detected VIPT I-cache on CPU1
[   32.846653] GICv3: CPU1: found redistributor 1 region 
0:0x00000000388a0000
[   32.846707] CPU1: Booted secondary processor 0x0000000001 [0x410fd034]
[   32.847202] CPU1 is up
[   32.867394] Detected VIPT I-cache on CPU2
[   32.867411] GICv3: CPU2: found redistributor 2 region 
0:0x00000000388c0000
[   32.867440] CPU2: Booted secondary processor 0x0000000002 [0x410fd034]
[   32.867777] CPU2 is up
[   32.887937] Detected VIPT I-cache on CPU3
[   32.887954] GICv3: CPU3: found redistributor 3 region 
0:0x00000000388e0000
[   32.887984] CPU3: Booted secondary processor 0x0000000003 [0x410fd034]
[   32.888328] CPU3 is up
[   32.912371] Unable to handle kernel NULL pointer dereference at 
virtual address 0000000000000100
[   32.921186] Mem abort info:
[   32.923980]   ESR = 0x96000004
[   32.927035]   EC = 0x25: DABT (current EL), IL = 32 bits
[   32.932349]   SET = 0, FnV = 0
[   32.935403]   EA = 0, S1PTW = 0
[   32.938545] Data abort info:
[   32.941425]   ISV = 0, ISS = 0x00000004
[   32.945261]   CM = 0, WnR = 0
[   32.948229] user pgtable: 4k pages, 48-bit VAs, pgdp=000000004310b000
[   32.954672] [0000000000000100] pgd=0000000000000000, p4d=0000000000000000
[   32.961469] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[   32.967045] Modules linked in:
[   32.970104] CPU: 0 PID: 624 Comm: sh Not tainted 
5.12.1-ktn+g807a88195d76 #1
[   32.977158] Hardware name: Kontron i.MX8MM N801X S LVDS (DT)
[   32.982820] pstate: 00000085 (nzcv daIf -PAN -UAO -TCO BTYPE=--)
[   32.988830] pc : __queue_work+0x28/0x3e0
[   32.992767] lr : queue_work_on+0x54/0x80
[   32.996694] sp : ffff8000128c3a30
[   33.000008] x29: ffff8000128c3a30 x28: ffff000002798a10
[   33.005327] x27: 0000000000000100 x26: 0000000000000000
[   33.010644] x25: ffff800010fc2408 x24: ffff800011371a7c
[   33.015961] x23: ffff8000114d5178 x22: ffff000002739880
[   33.021278] x21: 0000000000000100 x20: 0000000000000000
[   33.026596] x19: 0000000000000000 x18: 0000000000000010
[   33.031913] x17: 0000000000000000 x16: 0000000000000001
[   33.037230] x15: 0000000000000011 x14: ffff800010d2e4a0
[   33.042547] x13: 0000000000001002 x12: 0000000000000011
[   33.047864] x11: 0000000000000040 x10: ffff8000113e2068
[   33.053182] x9 : ffff8000113e2060 x8 : ffff000001c00270
[   33.058499] x7 : 0000000000000000 x6 : 0000000000000197
[   33.063816] x5 : 0000000000000000 x4 : 0000000000000001
[   33.069133] x3 : 0000000000000000 x2 : ffff000002798a10
[   33.074450] x1 : 0000000000000000 x0 : 0000000000000100
[   33.079767] Call trace:
[   33.082214]  __queue_work+0x28/0x3e0
[   33.085794]  queue_work_on+0x54/0x80
[   33.089373]  mcp251x_can_resume+0x94/0xb8
[   33.093388]  dpm_run_callback.isra.0+0x20/0x78
[   33.097839]  device_resume+0x78/0x160
[   33.101505]  dpm_resume+0xc0/0x1e8
[   33.104909]  dpm_resume_end+0x18/0x30
[   33.108573]  suspend_devices_and_enter+0x23c/0x4d8
[   33.113369]  pm_suspend+0x1e4/0x268
[   33.116861]  state_store+0x8c/0x118
[   33.120352]  kobj_attr_store+0x18/0x30
[   33.124108]  sysfs_kf_write+0x44/0x58
[   33.127776]  kernfs_fop_write_iter+0x118/0x1a8
[   33.132223]  new_sync_write+0xe8/0x188
[   33.135978]  vfs_write+0x254/0x388
[   33.139384]  ksys_write+0x6c/0xf8
[   33.142702]  __arm64_sys_write+0x1c/0x28
[   33.146629]  el0_svc_common.constprop.0+0x60/0x120
[   33.151427]  do_el0_svc+0x24/0x90
[   33.154745]  el0_svc+0x24/0x38
[   33.157807]  el0_sync_handler+0xb0/0xb8
[   33.161645]  el0_sync+0x174/0x180
[   33.164968] Code: 2a0003f5 a90573fb 2a0003fb aa0203fc (b9410020)
[   33.171066] ---[ end trace b4f771b250a07a74 ]---
