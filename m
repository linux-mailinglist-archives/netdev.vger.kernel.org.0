Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB0963EB44
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 09:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiLAIjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 03:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLAIjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 03:39:15 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2070c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::70c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAFA85678;
        Thu,  1 Dec 2022 00:39:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CR7qt9q/b59GIJcOyePxNipz1RFytsjhJpc6B2T2QB3ofPT4iYd2bTW3mXgeJSFezO2fvTHGCouuhD14OmkhZtfDg2YYDFnMHAy47s645LjIWJiNWKsJCN6s2Zb1VpRu+0RyBFAY6obXWh/xzoncFc6tk65LwvlWKIdm88XG9pd9i3H2YPuJms/XI97dpm0DZhLyk52hpACg7GrfkUt7Fua+ZnZKF0zC5kN8k4ch6ZfFisHQScqW+6wHngknjzgIRO5Eks0K5mIr0p023qULTT9OQiMGpZR9RIFQdXBBFjfbd9EVlxOCOwdbI4zgnJ3O9flskkDh2BeBc6uB4d49tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gxGPXShbXFRyn14efca9jduZq7jEUerWihs7mhfEeiI=;
 b=jB0F309qrbC1+0xveAmpGGonHBgh55F+MkDSvn8MYQTTEorBmV1ULW/imluqB2FcP+WsfXA6pCmXdFFFuOcqnKUjX47B4RBh8BrgzbVo/l84m4ahvjEvU8n8xOv2KPPIAAsSHWo5HfbsMwrhfXWpDFXs+yKjAM2Rk7tEFAtrl4sWI8WnkwYa2ML+8obWyATS+uUhRCo6Ni1ms2+a27ydILYNbZ5MH+dgnR8pJbPAOMvOp3OJLl10RA9ICDS7wP5m0C3LxZm3okIwgRV219fTfTxV8n7UgQbWkcPPRMtmwqO8NfkZLfMefUIG1K8AZwLXJJIrJhAdGS8pnDm7eX8L5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxGPXShbXFRyn14efca9jduZq7jEUerWihs7mhfEeiI=;
 b=rQC1I0CLjReJGpt6LB3N1gRapTNTJlG4ZxdWhefioFvIcfw/+LhQm217FWeiK4nVwsw10dzv9qoVSn74z53mTgS8U99S0MXjw2R9vcKhlLzSB+XOP5E9b8tAnMJ4VQVGsZBtDn8cpFPc51wZaexCUYFRTrE1bG34J7dUqaisP9w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GVXP190MB1990.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:4::7) by
 VI1P190MB0751.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:12a::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8; Thu, 1 Dec 2022 08:39:09 +0000
Received: from GVXP190MB1990.EURP190.PROD.OUTLOOK.COM
 ([fe80::bf31:7027:5543:3e42]) by GVXP190MB1990.EURP190.PROD.OUTLOOK.COM
 ([fe80::bf31:7027:5543:3e42%9]) with mapi id 15.20.5857.021; Thu, 1 Dec 2022
 08:39:09 +0000
Message-ID: <96e3d5fc-ab8c-2344-3266-3b73664499f1@plvision.eu>
Date:   Thu, 1 Dec 2022 10:39:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] MAINTAINERS: Update maintainer for Marvell Prestera
 Ethernet Switch driver
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Elad Nachman <enachman@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>
References: <20221128093934.1631570-1-vadym.kochan@plvision.eu>
 <20221129211405.7d6de0d5@kernel.org>
From:   Taras Chornyi <taras.chornyi@plvision.eu>
In-Reply-To: <20221129211405.7d6de0d5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::12) To GVXP190MB1990.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:4::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXP190MB1990:EE_|VI1P190MB0751:EE_
X-MS-Office365-Filtering-Correlation-Id: 38db9404-d8bc-4845-da03-08dad3778396
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AbuZ9nkUgCw3dCJ1aPdR5b+kuguYtXLFxSa0ZL1xHQwgQ7QhTPiZucTK6e3TTuUGlalAWEW3kTmoxBELtUSv9VzUIjj1wf2mUP1Xckc4ozflNemrjOXSiZjZbLI3treNvgxotsntvdBC9Bbrrlpu9gBZmzDDBxGrrrIY50yMDSfu9FmfPF4pH1Q777TasTDLDvDNzoDH6ZVyOVVYxAUDsI0X1U5VjdnrhKoeJxjj+lIw9KkryoUHB65kZsQpav2PPkxuVNzMcHEfj+LWOR8HrXpE0aNl1YaRqozHlu2KHip69SO5s8X2XP7FT8R45q1QrmQ+wi/8IhkjMJpb/6bkhlmPgvHf04//ATAm6bayKQdjBLytLNF5vsUyf9+VG8iYlOYZ/1USMPfM0mb9TvS5I/7SpCfh/Jy3M9R6azdqV3HweInGjnBrmkcCsBN8WEiDkKqdHJA/43RqaSLdVoExoV3B3Atdm1aF2BYxJSOwFw1qPtEpnzYV4BLHVOsjt9lzgSvYSdKxnlnCr4Q5g2yRCSo1LNt7RqSa0UbF6SvPyZOEbdSz+UCMpRPVKzm9HWmjpwirv0yw0Cu2RrGC0snBQpmk5dYS5+rtW4tse4fWDkFsp5xroCCnLjYaUluFdeXdTNpScyy+MkLf0Jbhdl2uDUbUn9gdwV9UdNACY4FruIvHng04/Oq2A5MjqDTVEPvqVsa1JNJkc3sZKC1tTvCv155ZgYywx0iogsSus+NcBM0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXP190MB1990.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(136003)(39830400003)(396003)(451199015)(66574015)(66899015)(31686004)(86362001)(31696002)(110136005)(53546011)(6512007)(6506007)(36756003)(6486002)(38100700002)(186003)(83380400001)(2616005)(44832011)(5660300002)(41300700001)(26005)(478600001)(66946007)(8676002)(15650500001)(66476007)(4326008)(66556008)(8936002)(54906003)(316002)(6636002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0JWRk9UVEVTSFdkWW1OTnhCemJnUzVGSStKbXVXMmxCWFFPSGtCZWs0aUFn?=
 =?utf-8?B?TzVmb0M5b3VFQm5lemtPSzRQUHRKblNjTEhKTVlIZERoTXJ6Y2plYVRBTWJl?=
 =?utf-8?B?TTREdFlXMSt5TWtsRlBBMXhQMjVKUXpBaFl5VHRKNFJBdXltUGtsUnpwOWxR?=
 =?utf-8?B?NWc4ejVqSitYWnZHRzN4UXZ0aVVSbHFrc3pGcGFLcSttQ0V1SklWd0liSWZ0?=
 =?utf-8?B?L0dQRzB5VXZZZ25oSVpVTjhia1JoT1R5REhnQjArSGJVM0xSRlpXSlgrZno2?=
 =?utf-8?B?NHpxcHVRb21RQlhZaTZLOFZidkNiRnp6QXhaNGNSQ212UlY2Um11Y1FETTlG?=
 =?utf-8?B?Y1RPcG9wVHJ1Mzc5S0ZUd1RURStKNVdBbTFrL3g5SEZaRWxtNlVOOHRpWHNS?=
 =?utf-8?B?bVdreHVhK3dUa3oxRjB2bnVKTDczMm9wYTdOak5weVFiKzdST0lRdS9HU1g3?=
 =?utf-8?B?OC9PdmFjeHgrQUJleW9FTGxhRloyYXdhTFJ4SXh0K3lCamQ3cUZ4d1duU0M5?=
 =?utf-8?B?L1Q1dHZCcXBDTTlRQWZRaG15SG93VXNKZkpwZDR5anI1V3EzaWR1Z0dsUEtk?=
 =?utf-8?B?THlwUzc4MkxQeXdZb2FyaU9QWm5BZTZqMzd3YXhkL3RmMGVqbFBCQmRKQklP?=
 =?utf-8?B?WnFGN3JjbHpFdWw5dVpBM1dUZEhPVmJ0UzExQmFzWXhEU3NJZy9RNjZpbW9E?=
 =?utf-8?B?WFpRNURQanNQUUdZc2IxQWlvUTFUNHFuVklQY29xRXRHRnRuVi9PTjRKNVRw?=
 =?utf-8?B?dCtCdUtPNDg2cE9yQ2lLM1FIeTVvMVFRRWJTRFRoQWxXVU9mMmpORDhTdXRo?=
 =?utf-8?B?eFhKc2hmYm1RRUdnSVNMSlkvSm5EeDEvM05wQUJVeEo2M3MvVElNcHpxcEox?=
 =?utf-8?B?RmtmeGtJbGVRUlNWUU5teG5rS2ozVFh1RWE2SHlXODhEdUplL1FHb2s5RTNz?=
 =?utf-8?B?cmFQZTF5VE85UmdsQVoyc1lPUCtxdERkOHpjLzBHbUE5WFEzbnM5a2FOaW5Z?=
 =?utf-8?B?aHlLSEI1SWhVazJ1RFIvY3RZdlNtOGxaMndnalYwbUtDMVNVTi9VQzlqVk9r?=
 =?utf-8?B?SHhRa3plRE1kSkpsbWd6ZzI0dXMzV0k5eXRDMG4vZ3RacnR2emxqR05SYTB1?=
 =?utf-8?B?dWpwektIYWhnT2pJRDlUVFllcmUwU01VNEVsVFJjRlRmWTdVYVRpN3pXZlI2?=
 =?utf-8?B?dWVhd2tTSFphdmoyczUrWDVuT2hrOEJ2VjlTWUhHdHJmclYwQmNDNkwydUk2?=
 =?utf-8?B?NE1xaUxiSmp6ZmxTNHhzR0daaERQTDJnMis4OC9UUE5ZNUlZd0x0dkMyaEt6?=
 =?utf-8?B?c3MrSWNZY0dQdjFSa1hkVWFDbnR6V05sSzNPbkVNbW12NXNPZmJBNXdIa3pK?=
 =?utf-8?B?a00yY25ZY2FXa256eGo3UzRPc0YrbXZFY0wzTXpZVTBoUHNjYlp1ek5MY3h0?=
 =?utf-8?B?amhOREd5Rm4vcmVpYk4xSlNjeW95cTBBbXhTMy9WSFZsUGJZRCtZVmJUbTNC?=
 =?utf-8?B?enhVdmRBbzdiRG9oWjVvTXF3N2lpeVNPRTVTcDFFcnRSem9xb0EzdnVBajZj?=
 =?utf-8?B?akdFMCs3Tk5tZG5Wa05iTFVtdnlCb05velpMeWYxVGt2VGVqWjI3UGhvQnFi?=
 =?utf-8?B?YUkwMzUraDZGWmpRRVdYcy85R0xpc3FHcTZoWEY4THRzczQwWXNqcWgwbW03?=
 =?utf-8?B?ckhYdnpkeXF5aVhaY2p0S1F4RkJtS3RIN1hwanc5blZqM1JDVHk4ZktFaWNT?=
 =?utf-8?B?RGo4RG5BY2tBUHFMRjFWckdXb0NzOGtqODloamdoR053MXF6enR5QUU0Wktq?=
 =?utf-8?B?V280TmZ6MEhuWWdxVHZPSWNNb0xKbGphWm4rcWhYQjRFU3hCdGwwbk1BYXZo?=
 =?utf-8?B?RVdsTVpjMStmeUhPUDhnSVpYVGo2SkE5bnhKVG1GWkdNeUpWdWtOMjJhVWxW?=
 =?utf-8?B?dHRGK2hLRW5wRitLRUFzREpQWkwzeHA4SFY4emV3TjNraWRMVGNuQXNxaDBE?=
 =?utf-8?B?Z2k1bEtLV2Rpay9ueEc2cm80TXNSWW5QZ2M5VHUvelZCcTRmSjJNZU5QK2dt?=
 =?utf-8?B?ejJMazhGVVVrREMwWnFoYnRLVXlCcG5sK3dSVXM0dWtIUDNUZnB4VU8ySDRv?=
 =?utf-8?B?U0xPREcwV0tyRnpmcndjZUhhbTVEZWMxZmczRFpwTnhwWGk3dkJRYk9DVklP?=
 =?utf-8?B?Nmc9PQ==?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 38db9404-d8bc-4845-da03-08dad3778396
X-MS-Exchange-CrossTenant-AuthSource: GVXP190MB1990.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 08:39:08.9866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kb2hmtXrREf8F2T0VRjsCeMMuDz+em0Hcb0tK24q8Mc2KrdupwFgEA/sUuXiJ0qnw+Tg5TNEpxB+kgIELiIJgHt31FjhecW5mn8lnSaYjQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0751
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.11.22 07:14, Jakub Kicinski wrote:
> On Mon, 28 Nov 2022 11:39:34 +0200 Vadym Kochan wrote:
>> Add Elad Nachman as maintainer for Marvell Prestera Ethernet Switch driver.
>>
>> Change Taras Chornyi mailbox to plvision.
> This is a patch, so the description needs to explain why...
> and who these people are. It would seem more natural if you,
> Oleksandr and Yevhen were the maintainers.
>
> Seriously, this is a community project please act the part.
The Marvell Prestera Switchdev Kernel Driver's focus and maintenance are 
shifted from PLVision (Marvell Contractors) to the Marvell team in Israel.
In the last 12 months, the driver's development efforts have been shared 
between the PLVision team and Elad Nachman from the Marvell Israel group.

Elad Nachman is a veteran with over ten years of experience in Linux 
kernel development.
He has made many Linux kernel contributions to several community 
projects, including the Linux kernel, DPDK (KNI Linux Kernel driver) and 
the DENT project.
Elad has done reviews and technical code contributions on Armada 3700, 
Helping Pali Rohár, who is the maintainer of the Armada 3700 PCI 
sub-system, as well as others in the Armada 3700 cpufreq sub-system.
In the last year and a half, Elad has internally dealt extensively with 
the Marvell Prestera sub-system and has led various upstreaming 
sub-projects related to the Prestera sub-system, Including Prestera 
sub-system efforts related to the Marvell AC5/X SOC drivers upstreaming. 
This included technical review and guidance on the technical aspects and 
code content of the patches sent for review.
In addition, Elad is a member of the internal review group of code 
before it applies as a PR.

Finally, do note the fact that I will continue to maintain/support this 
driver, but I would like to have someone that I can share the effort with.
