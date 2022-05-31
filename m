Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A615396BF
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 21:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344175AbiEaTJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 15:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiEaTJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 15:09:13 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2086.outbound.protection.outlook.com [40.107.20.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B10198590;
        Tue, 31 May 2022 12:09:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGjtu5E7ro7qVqPp6cfJdHn38GnSHHXKgQYmmjt1ytIj9FmaXENdZVkEG6IH10mr0YmeX7C/V9yjFUmjX6v+z+jVuBV8py6klsEA/wr99GMNDRl0JGDFFeE9SHB2HKlORTtj7m+EOPk/NnMAn3tphFEpezfj9KJ6kA1M1om1eT1C1Sc4EepOG8n+gf6zvQWVkr8kpOvvBt3mu9K26Qbdeo8aHF1HgJRfnBr/rDMfT97UuPCyOQHu7rAumIsf/X78Y7GivON3Nt/SLQY6BAh146NZom5/aPVRls/S6nUke8yyFT3CBjh469SMymZmozpUhewpWZSlrVbH2FZjWp9tsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6TiWCS/bJw86FgFuRTTxOULzSnPblXjqjjaS3DaLxI0=;
 b=Mz6Q08r+M4tesi18dpqhWlKiilmvIiFvGW862vgCH89kIt4ZUP9aQwdZrj1DRVC8QSV2D8S28QIQ2QJrbjOcvOEbraG4ikJQr8pShIAuoeNRW4b2vHIxQzNNxZrilpW/NXKX60E47rkZbTXi1zqKN6NQkjI3gWSUqWCNHMA+v5kvgRj1ZyolSUj+iwmUn8vRqk3lHtqifyk/Dw4DrYkTulgv0OaSf6FhcyXLmM+apFOVy7COe+FyCEmXlMHQuLoOXK6iVyXFggqHrDyElZklbmAkBR6sT7l1255Sz3s9M/IIJU+u0oVXIHwTaiIUPSny28MR+HrIGvprLub488nkSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TiWCS/bJw86FgFuRTTxOULzSnPblXjqjjaS3DaLxI0=;
 b=AMwBwHwtb5iNiRyyRvK0/ad7WZzrwfjO2iEIuUD2Bid9Ht1wgilY4nj+DMXFz9Ve25wiVGyN+bz+Vof9mznKL3yeNhzq27Ji7QJmqGXC1fB5lrNOTyymvU9dQtZ8uRnJgBiD4cAd4Qwt34WYaHxl1CXA6Rp2jCT6xmwz03iWfOn7OXcclqsBeFPKT/MV1IbKwrEKKe7Zx436y+J1tqaImsk2S8a0xvCIhLGxnwU9nkicTQQIWzKe1n7A2uzr5gJcOqO0Il05PH/em01RPVuy06Iyj+fEYK1weKHgAu26wEjwGV7zF8bysvJ31UCirgfA67hAbMjuEWIeZNhogPPToA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB3973.eurprd03.prod.outlook.com (2603:10a6:20b:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Tue, 31 May
 2022 19:09:09 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::c84e:a022:78f4:a3cf]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::c84e:a022:78f4:a3cf%6]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 19:09:08 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: net: fman: IRQ races
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        netdev <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florinel Iordache <florinel.iordache@nxp.com>
Message-ID: <c6c6f425-d12b-3a16-2573-4c70b9c48b7e@seco.com>
Date:   Tue, 31 May 2022 15:09:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0108.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40372178-de31-48fa-bff0-08da43390a0a
X-MS-TrafficTypeDiagnostic: AM6PR03MB3973:EE_
X-Microsoft-Antispam-PRVS: <AM6PR03MB3973AC6FF747D3AE5693906D96DC9@AM6PR03MB3973.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0jGy5nUResodcUi74gIJWsibEI0FhVRrDS9G81ttzzghLHQl6i8vPF7rGJNL3Nr1KUE1UZbjJI5/cic9RCpFyHEgeyVB0vkqDCsGmjghdMK3pxUek0yDFxHZQejgtlnoQ4GjisZVOqBTm0+I8FfVDKym8g9cBFIx/bKezOGaIGacN9T2/tA/hKII2X9LsXzWQH9faNtANM0mEGwuvH++oZmXySZaclis1+LOGwajye9aaG8bKQulA/bHDM8+qpeuA++8+ukbGf19RMv2aE85lGK3GxDSwUz52WfFxlqi83iAfYbY2ie+0ficVr96V/YPn+5pguSdw9LdScwgzgrWPgQekMWCuG86GjD/NRmDI2m88zW6h7dxzhTVlOUHPP+sw+/72jkZsxOkj/becGoRLZ3AdZ/cDzxwD6WK0WKqmll+/oG4iYABUscyqbPN+WyWZggefHMQTaHRpegnScyxlcQa1veeYmHrLXf2dsRETITRBI3FSDrca4QgtZWSdLW4n85z7pq52iegE6PaeB9FnQ7OGRPk+km5hRO1Ktb9oGBXYjEe7RFs9ChpzcToLUGeJ4kvcTOS92PSjOEjJbA6hJUbZN8YVI+iE0qK+3VmFmInz1Qmz9QTszbR4sCPmyibDCs0sqJBKafUoken2/UlpTPdwxNZITtYiV6ce/nN8Lfr8/YH9Ffm6haSdOCCBkuHZ5C7ha7AwO7WW80yjpua6DOO3fbTzlwO7QgKkDOQjQ44YXOPTNYW4jOWsziZ2f0E4uO9mPL5hW55/uQW+0836A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(8676002)(4326008)(66946007)(6506007)(6512007)(38100700002)(38350700002)(2616005)(31686004)(66476007)(66556008)(26005)(2906002)(36756003)(508600001)(8936002)(54906003)(110136005)(6486002)(31696002)(5660300002)(6666004)(86362001)(186003)(83380400001)(316002)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWRvMDVVSEtuV2ZpZEllZ24zSGY0ZTA4NEtyaFV5TmJ6c2FyRXJsTmxxWGJR?=
 =?utf-8?B?TmFVZXZINUdQMkpDVWVpZ3luZ2VHaWdxa2xmdWRrSmFxVyt3Nmx5L213aVlu?=
 =?utf-8?B?RytLUGl4Q3c2eUZaTTZ1ekFZNDlPbnJIbTEwL2Jpa3ZlM0RZYUlwdktaR2Mx?=
 =?utf-8?B?ckhvVEJaQkhtT243bUtCUVRSWCtwSDR2VVlFaitNSmFxTGlhalZiWTY1VlZU?=
 =?utf-8?B?MCtPN1ZhL2F2TlU5MTc0Z2NBNm1LaUhaNEJNV0tPMGo5NWlXdVhqeFlhMGZP?=
 =?utf-8?B?R0xRNnI1cGZ1ZkR5eVozYTB4WW93QTFGV0doNDlkQXBIcE1pQUxaZnZuMGMv?=
 =?utf-8?B?eVE2N2dHWDVWcE9WdjNoUnVSVDhRc0tHTzRKWGNLcHBsODJXRWpLVVRSOS9K?=
 =?utf-8?B?NlZjSnA2MUZmRzJoci9NbVRVVXJoVjdacnQzaUxPRC9jb0VrdW1uTFRwb3k5?=
 =?utf-8?B?eElLZnRwTi95U0xjNlVPWVhZd2lsRlB6ckpmQlNpd2Q3Z2RNV1pYRU52cTZ3?=
 =?utf-8?B?cThra3NzdWNUWXJJN2RwMHJjZ2ljT0U3eTRUWGhsbkJNK25CYnRyeTRTeFZo?=
 =?utf-8?B?L2pZVnFEcFlSYTh5STlMYlRaYWtSSHB3R21mTkdud3RlRWE5eVA3c3NjNVU1?=
 =?utf-8?B?V1RvRGo2dFN2NldJYVRHZzNYWWczMzFBTHBtWERzL0ZjbmgvTHI0YkIwaHF6?=
 =?utf-8?B?a0xKeDhxVTJ2YlljTEUvV0szTFFJVC82VnBBc1dKU2ZoN0gwMW1OWkRnM0J4?=
 =?utf-8?B?d0xKQkZ4R3lKT2JYUFFLZnVra3AwVUg5OU4yNTBkWHU1eTdraEhrNHcvTWRr?=
 =?utf-8?B?WDhLa1A5SzQveWV3SDlrWFl4MWxCcjhBMGJ5TUc5emhhMnJaaFBtcjRRYWZ5?=
 =?utf-8?B?ZXZKS1JoWDZWNWlXYkdsVk5mTkwxU2lWWXRnOUhReG55VzRRSlBaTUF2UXFW?=
 =?utf-8?B?NFlCb3BzeGtRKytQS0tDbUVaMzFTVmdqUlhGRlY1TnovbFVycG1PUDVjMEo1?=
 =?utf-8?B?b0RlNmtNVmcrMlg5bVdxa2l4a25vUGxLcWlsSERnR1R5RHVuemZJRGplaW90?=
 =?utf-8?B?OVRHbkxFeFluc0drdmVxN0lJbWhQbmd3d0t1TjJZRVFuV3Blb0JySWdIcXo4?=
 =?utf-8?B?L05MNVc5MHE3cTFrN1FZNE5iTENWZ0lRdkZzd2lIbG5pN2k4V2FibzdwUjJJ?=
 =?utf-8?B?TlVySlhlZXVKY253VjZGWDFkam9SeExubVhGZ0RuajhMbmxhNVJuSjBDd1h0?=
 =?utf-8?B?TTJkSG1aOUtJTkg0aElKYjZpVFF5VVVrNmUzWjRUcnBldCtjRDA3WXVyVXNQ?=
 =?utf-8?B?Rm95cW1TU3NwQURHRE5HbFViVDZHZHhRWVF4Yk1NZE91eFp1Z3ByUm9rdWV4?=
 =?utf-8?B?SWkwcVRuOEZ4a05rTlFqV1l2WDBGZ2xaQXVhTUhSa2l1ZkpGTXR1NzNuQnFN?=
 =?utf-8?B?bWZUZzBJaUFaRERTR21CaHF3YlNDWVdLNnZuUEhSTFFQcXNiZkZVQkRNbkM1?=
 =?utf-8?B?bG5laC9DWGxBR1AzYUE4cEVBeU5KVjJSa3ZQWDJVM1cweW9QaTBZT2dFZUVW?=
 =?utf-8?B?ZTI1cFFBQVJ1bEFXLzg3eElzMnN6UTZKR1pNYkd0YitpRW5lQ1V3bFVzR0p4?=
 =?utf-8?B?TVdjQUZ2QUV4T0ZTMGtEUE9mdndLMTgwMDBxcTRRbEtrQnBWT010UWl6cVpv?=
 =?utf-8?B?TWd2V0cxWU05QjgrMHlQbkdua0ZPdjhROEtqM3pZTGppcVRtV2dxVXAwRmR4?=
 =?utf-8?B?eHpoSG1YQmNmVzRGUHRRdmplWVNDUTQ1WXhselpIY05LZG5neWltK3ErTVhF?=
 =?utf-8?B?UUF4NW5WN2M2SzJNYXJrR2J1aEZ2bHAwMGFxMUhWK2JwK25jcEtSUlZmcWx6?=
 =?utf-8?B?VHZoK2tUQUFqSEZnM1A4d25jcmtpbHFHeThPa3d4dkErSytWbkoyRXNza3hM?=
 =?utf-8?B?eFV5YUZIdzVqMnlQT0g1clNVL21iZlp5TUZGcE9tVjZxY3JXazNGTnYwZFJk?=
 =?utf-8?B?ZHpmUkRrUnF2NkQ4ZVZXYnlPQjFsQXh5TXIrMHR6OFZrTGN1aDRXN0dQT2Zz?=
 =?utf-8?B?YnRPYWVmTVNoc1RZcnNyWnp0d2hUQXlYMllkSHljK3RiWUU5eUxrRHhtS2tF?=
 =?utf-8?B?dmMzZUQ3QUs5dkZWdTI3L1puSFFJbWxWSzVTVHBlRy9PR0pya1ZkY2UzR0Fy?=
 =?utf-8?B?Ry9OTzR3MmFNYXYzSHV2enBoTXF5eFR4MzMvNDZETHp0MlR4eUxDaXhDM2ly?=
 =?utf-8?B?NmpUaklUNktkZy93a0o0MCsybGRGcmNITWhGamlSa1hHcE9kejZDYUZpTzNj?=
 =?utf-8?B?Z1ZGOERNVmJUZFZwMWdDbndLUVFGcTJ6ZXlTVHRPSllhUnozWjFmM0ExSUxR?=
 =?utf-8?Q?CAfMg50Cdkyf90WM=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40372178-de31-48fa-bff0-08da43390a0a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 19:09:08.9207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X9ZQV4MRpJE1T1SgnxFq1YTTMXVAMKhFCLkdxVnsprtWwm44J+oYLGECSSgXnQOxWrZW9Pj37weo3Kes1+WkzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB3973
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'm doing some refactoring of the dpaa/fman drivers, and I'm a bit
confused by the way IRQs are handled. To contrast, in GAM/MACB, one of
the first things IRQ handler does is grab a spinlock guarding register
access. This lets it do read/modify/writes all it wants. However, I
don't see anything like that in the FMan code. I'd like to use two
examples to illustrate.

First, consider call_mac_isr. It will race with both fman_register_intr:

CPU0 (call_mac_isr)		CPU1 (fman_register_intr)
				isr_cb = foo
isr_cb(src_handle)
				src_handle = bar

and with fman_unregister_intr

CPU0 (call_mac_isr)		CPU1 (fman_unregister_intr)
if (isr_cb)
				isr_cb = NULL
				src_handle = NULL
isr_cb(src_handle)

This is probably not too critical (since hopefully there are no
interrupts before/after the handler is registered), but it certainly
looks very strange.

Second, consider dtsec_isr. It will race with (for example) dtsec_set_allmulti:

CPU0 (dtsec_isr)		CPU1 (dtsec_set_allmulti)
<XFUNEN interrupt>
ioread32be(rctrl)		ioread32be(rctrl)
				iowrite32be(rctrl | MPROM)
iowrite32be(rctrl | GRS)

and suddenly the MPROM write is dropped. (Actually, the whole
FM_TX_LOCKUP_ERRATA_DTSEC6 errata code seems funky, since after calling
fman_reset_mac it seems like everything would need to be reinitialized).

So what's going on here? Is there actually no locking, or am I missing
something?

--Sean
