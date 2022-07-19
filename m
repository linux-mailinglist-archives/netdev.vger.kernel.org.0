Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF20C57A43B
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 18:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiGSQgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 12:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238492AbiGSQg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 12:36:26 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30098.outbound.protection.outlook.com [40.107.3.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797C21BE8D
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 09:36:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7Vfz38du1F4btft0s1ghYeAWBTCXVrZvqSmf1lF02VvTMmhRjtWB9LT+Ny8A5mXvkdwp+GQuu2Ue98P0MX9uKmy2+Xg0wPvdTG9GMC4lddPt9mHI93UwvXh5eJXW+usGtSEtdscVjXv8vHTd3CJB/cOqFrlB6T+91RS5sk1IM1M6SWj/wRGxw+SJXeMmE/o5YdeoqjWJ/ESH4ce3TpNko6EPSJxr8X4OKM5glsXcdfcHxihaQwNJF1oGYDYvID41/0IsuqozlVbfTdtabdXsqhiRNDPC6kf4vPIWhGhDkBSR/DlOWKfxKhSclig4E0xHsylC9ykc2gbWihiQR1dNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UpoyXrOIiK8XU9IwOKuSuWSqljI+Fm5lUQxMO4gf0O4=;
 b=XVbCsYrQ1WrmSuKa7s1/7gNUsnnZXX4gRvzqL2aHEi53Cpe45P7JwXjbomW3+ctdP9X4CL0mdkj8bYWpkF/ZIGIKz0jwgJix4lMFgj/EqsDOyZwsQqTDkqnrs3PdNp0sK50dPrnpKci9RyWAD4e7Q0yxH5I8l6KJijqPpx9D2A5EMN4RJRQxREuF/ddq1pGZSVz0YziLZoIXWY2KiBwZPkMHKVMDUBSJPhbghbiFH2q1pSfvwQ0fAZMad+zqS+BuXVgUkcxjfyNFlXurUF+9x4ANjRkiryX000Gu6vCk+frFpt/0dmXPPd7Vck1+Pfm14BNKLjieWVrtY52QMKB1gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.com; dmarc=pass action=none header.from=kontron.com;
 dkim=pass header.d=kontron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpoyXrOIiK8XU9IwOKuSuWSqljI+Fm5lUQxMO4gf0O4=;
 b=bcmPTMRh95Em+UwvpVuHdm3j8Je7f63PH6AeDDsJEFxmDMNvcL5MphZ3bh5fYNMCClXinRsCxso7WGdeEswyVPKNTxFA3J1f23Od0eI4bL9+d5IClF69CTnoYW+1RtxneECoL1v/bb2D+IyAb7AuMN5UFHGsPt97U0+lLXwYjdM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kontron.com;
Received: from DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:3ef::11)
 by PA4PR10MB4398.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:101::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Tue, 19 Jul
 2022 16:36:22 +0000
Received: from DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::112:efcf:6621:792c]) by DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::112:efcf:6621:792c%4]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 16:36:22 +0000
From:   Gilles BULOZ <gilles.buloz@kontron.com>
Subject: Marvell 88E1512 PHY LED2 mode mismatch with Elkhartlake pin mode
Organization: Kontron Modular Computers SA
To:     netdev@vger.kernel.org
Message-ID: <3f6a37ab-c346-b53c-426c-133aa1ce76d7@kontron.com>
Date:   Tue, 19 Jul 2022 18:36:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: PR3P189CA0007.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::12) To DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:3ef::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7eb3326-4263-4760-56e8-08da69a4d097
X-MS-TrafficTypeDiagnostic: PA4PR10MB4398:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HlmRIjlSd4QE5WDX+2aWknSGjLkv9lHM+B3S616hlnRJxP4GUk9UyDwCwaDknBejI75gxF+d73rhiyqMimKegOyARzFYUqkaArSYvc6w/vTzhCJosAeuz65CvLvwO2rdMMO7uAK85hgScftzqPtL7C/OsUUO9ydZoU3Nl/bNXWy2+mm2sUt06rnEPkDsdZViOhOposqWHIEnJmhhUy8xz4Knv2UNxqNL8PAimLaM2NNkfJHCd9AySb4RMcRKxWrHQFdLKhAbtiR7FYPD/TyQf9L2GuLic7qbxxHj5D97+vP8+cPZUZo34/E1Q3j2tGm632AG5etqYCio92HCD/0r2G0GtnyDIJCDh4gJo5nzKqXsXq0w/UzD2ZACsCw4ANuQjWyCtdgsQTrNLsBrIc/nHHwoWY4bpKauDIHop5cihfKLZF+CrlLD7I/r8gLLV6JJYRdd+eiecueW0o85pqdcufNMSS7QpMTSVw5tjT8tPdPnQsjPivAoeTPpXiQIx99DuuxWSgOPoxR85WkohEyPA3zZagy5l4+slABPRIrkRGuB0g5FEsWMdVJZa6LOuecx2YrtRmmoNV0Dd2GCirO2wlcrbS6SiynGKEPk/2ekuoM07CWNH9XGSJ5t0bYxtyo22C40UOILJS1WEOGSIyC3tGsNPGkDRztAq7dJmRg/oMazGhjOSw3Jy/XcP/eLLaFKBNdumpm8wNAa1UC2Nrq2EAnvM5qwo4frVHu6ZXS7LrurctR72fOihRoZSC5rCAGqGK2IY8gdeRxW2FGkghh/PUdvd8SKwsP2VQJh5ygCZRngGpZtBTuaW1D+4dQW+73NDlju78v+FpXjcYqQ1QkEZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(41300700001)(6486002)(8676002)(83380400001)(66946007)(66476007)(66556008)(478600001)(31696002)(36756003)(31686004)(86362001)(6916009)(316002)(26005)(186003)(6512007)(36916002)(6506007)(2906002)(2616005)(8936002)(38100700002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWV5akN0UE1iQ3NNUHpDVldxSk52ZzJXWnYrblJKNEVYZkhXV1k0TFFiZVFM?=
 =?utf-8?B?LzI0cjJXb2I2WlZucXF3U3JjK0d3WklDREdZZ2hNT3hKZmtuTEhlSWVKRWR5?=
 =?utf-8?B?Z0VMaDRGSUhnMEhxWnpFZVhMNzMyWkRXN20weFVIVkxkbGdWV0FlakkyZWhu?=
 =?utf-8?B?TXpPd0lrWE5xc2t4L3dhQjRkY2srYW9IU3hlaGh2dWJXNTFhcFcyUUV5amhj?=
 =?utf-8?B?OHY4dzRtUmdRbW9UeW5BcUZqcUN4aGhRakhkT25BQWJuNFAvbFdiVTNjV3Zy?=
 =?utf-8?B?WnZSTFNINEVLOVFLTEp1eXhhbVh6c2tEM3BYSFIrVDROUWNhQjZrdEh2TFRI?=
 =?utf-8?B?cXREUHQwUkl1YUM4WEYwUm1oZGlXQ0xCTzNEc2YxemRRUlVSS2R3eDFCVnJD?=
 =?utf-8?B?UFpNNjlhSnpuMFRVdFhzTDU2ZlZjU3NDTHRVMlMrTmxsc0RIMzlITmVZTnZ5?=
 =?utf-8?B?cWJQYXZVOG9ablowNERuaWg0dmxUc3ExK1U0QkhPUUlqVDAxdlFic0ZxK0Vy?=
 =?utf-8?B?RG1DVTBnbUVnQ2RWd3R1YnhaVjVmT3NCcXUwemIzM2FlMFM5cGVEZzdieTNB?=
 =?utf-8?B?ZHdndkdHTjI3c0xJMzhqNjY5dEhHV28zQk9nZTRBZnAvZTZsV201c0FwTGlF?=
 =?utf-8?B?T3dkZzNlZWh6dlZ2eWpkUkpWYVR6NTkxZ09LdHhqTHp0cWhNNHhyZ1JzOGRW?=
 =?utf-8?B?cXhBcXVrRnhwVVNOa21qbGJaem1sSEszcUIyelduQzJ1bjRSL0F0YnNHeG1J?=
 =?utf-8?B?TFFhUUtMQmk1M3lIZ25UeVZKV1p0dWJwaGxvaHZ6bU1ZTUc0aWdpczIvdlpn?=
 =?utf-8?B?S3p1UVU5OWpFajRyZDFWVUdIQ05FOFR2UnQrK2ptcUNudE5WSDRjb294cEJ1?=
 =?utf-8?B?c0c4VTFyUHJZSi93WG1hU1BGRnN4TWZtdHBmNWpNN3UyNi9IenEwY05jbVlv?=
 =?utf-8?B?OFE1ZGpyWVVCZUJTbVhzbDZrRDNUOTZsMlY1SWx1RnY5VVZuZEJ3TWZWczUy?=
 =?utf-8?B?cjJDQk1tZnhtTURXOHJhamhxNktCcmxzRi9hbFE5S0IrQ0IwNUVPbHM0UVZN?=
 =?utf-8?B?dS9KSHdSYWttRlJIcENGb1NyOWExelF3THZIR1MrU1EyUXJtdUFHa2xsVW5q?=
 =?utf-8?B?WVJhSk1MZUhOTHZLbTdEemljU2NoRm95RW5GRHFoZDhPVkFBN3NjczhwWmF5?=
 =?utf-8?B?d0NpS2pETzVMek5rQ1NNN2dCMCtXRGo4TUNNTDBtSXVkWnZRL2hoWUNNUEh4?=
 =?utf-8?B?R0hHSllwd0JIcGxyNDVHMjkycHBMclJqMG91ckR0WUNkTjNHaVFNT0ZqbTFE?=
 =?utf-8?B?bGdlZCtjam1sbDJ0Yy96LzhkNE9iaTBQMjE3bE9DWGZ1NkNyRlo1MGpYSUtY?=
 =?utf-8?B?Smx3U0lJZmtJWHVZQTdaWnZ3T1Nydk4rZmRvUzJNSWpOWElRY2RCRytZYzFh?=
 =?utf-8?B?MkpQa2Q5TFpnNGVRUFI3eGk3RnhIRjFXZE9jTEUyRG5uR1FtZEdSU2NHMDNP?=
 =?utf-8?B?RkQ5emNBRFBleEE5eXFQdU5CWUZGZjlzZTJZaTRLNjJORTRqN1ZCWjgrVEFu?=
 =?utf-8?B?TFVhZTFqWW16RDJLa05EWm92WWUvczRVd3hXTkREN3NqTjlPekFiOHgvclhz?=
 =?utf-8?B?aVBXSTdwVTNZdmlDaklodmU3aXJ5QUFjQlZEQkc4OVc0RlJGdFdncjZTZUl2?=
 =?utf-8?B?cjFVR3pXRVBJU0dTK2dYemJRMTI3NS9YbExjdHg2ODN2M0g3YUZlNnViOVpX?=
 =?utf-8?B?Z1lkVEdqWTc5QVlyTjRmY2xQMWNlVlREakpRU2NEREpCUHNNV0tQSS9LTWdU?=
 =?utf-8?B?S3M1MllCV2E4UUZ3QUVRM1A3b3p4Z2VHUGJtb0VOa21valdVa3o0WGhNcXQx?=
 =?utf-8?B?SDZtZTFEZC9Oek1FeitDREFIY1hLbXBoTDFqelcvRW1iK0FUelhtSldXd0VI?=
 =?utf-8?B?ekw0RjlEZHBQK2ppWERtOUJDbEE3K0I5b09UMW13Z3ZwbjN5L1JXbUR0QURB?=
 =?utf-8?B?WWplVy9lQTJWQmFvL3RBK3dEbW9wQ0ZKaGtrd1g4bCt5a29qTHROOVZCakpC?=
 =?utf-8?B?b29IcG9CMmVwTVkzQVRueDhLOVBQUm5wK25CdWpGRm11T2JwaHJPbDU1Rzls?=
 =?utf-8?B?cWFhV3dhaFJHSVFOd1ZLdU92NWhxZkphdFRGcnRTOHV3c2RqVTBkbXlFY2FV?=
 =?utf-8?B?RXc9PQ==?=
X-OriginatorOrg: kontron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7eb3326-4263-4760-56e8-08da69a4d097
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB6252.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 16:36:22.3343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fe0DV8P7q+zI1UHZVuGCgCoEvZVPg48UgKzKK/wmlLCU7Ah5sO+D9Di3SZL9n5aGgSRH2dE5t3pXfYD8mAP5MwAmeKRztB3NBoUe6As/AMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR10MB4398
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear developers,

On a custom Elkhartlake board based on the Intel CRB, it turns out I have the 88E1512 PHY configured in polled mode ("intel-eth-pci 
0000:00:1e.4 eno1: PHY [stmmac-1:01] driver [Marvell 88E1510] (irq=POLL)" in dmesg) and the LED2/INT# pin is configured in LED2 mode 
by marvell_config_led() in drivers/net/phy/marvell.c (MII_88E1510_PHY_LED_DEF written to MII_PHY_LED_CTRL). This pin is connected as 
on the CRB to an Elkhartlake pin for a PHY interrupt but for some reason the interrupt is enabled on the Elkhartlake.
So when I shutdown the system (S5), any activity on link makes LED2/INT# toggle and power the system back on.

I tried to force  phydev->dev_flag to use MII_88E1510_PHY_LED0_LINK_LED1_ACTIVE instead of MII_88E1510_PHY_LED_DEF but I've been 
unable to find how to force this flag. And I discovered that the value of MII_88E1510_PHY_LED0_LINK_LED1_ACTIVE = 0x1040 is not OK 
for me because LED2 is set to "link status" so if I use this value the system is back "on" on link change (better than on activity 
but still not OK).

As a final workaround I've patched drivers/net/phy/marvell.c at marvell_config_led() to have "LED0=link LED1=activity LED2=off" by 
writing 0x1840 to MII_PHY_LED_CTRL, but I know this is a ugly workaround.

So I'm wondering if PHY "irq=POLL" is the expected operating mode ?
In this case what should disable the interrupt on the Elkhartlake pin ?
Is wake on Lan supported if PHY is set to "irq=POLL" ?

Thanks for tips.
