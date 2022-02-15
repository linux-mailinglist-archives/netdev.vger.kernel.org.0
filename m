Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835954B6B56
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbiBOLnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:43:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbiBOLnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:43:10 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02461AF2E
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 03:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1644925374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=mwD6dlSE+1UV40ks1zLzbuHbh5/pN3ZAf0hMeuvkhoE=;
        b=Oe4pKN1MpL0dhtY9PORskoryXnM50rcjpeklJlOUYnVGhAJWyHBJX+0aiyKvPH3pAognow
        gpKBTcv8j2dyW0l829BORYQ7MEHJjD6lbomMwfxRoZRGsMFbvVKZ9pCsN7azfhMj4bjzv5
        3fRLPXIX364q6JfpCBrY8a2LxKWwK4s=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2050.outbound.protection.outlook.com [104.47.0.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-2-xx4NFi9_M5GQrnHBIQ0xdg-1; Tue, 15 Feb 2022 12:42:53 +0100
X-MC-Unique: xx4NFi9_M5GQrnHBIQ0xdg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdLkiGahTIX/vPXcE4OW+HgqSjGS/cSRfvwmUoaACKr3SvjNY/Or/pEDj4y6RYR8b59zJNDvH10/A6Sv6vs4PKnp860JzyPvzc2LrGqs7dB7oJmwM81IpZUO2FPTFHcW27awWb9+N1miNB+Y2IsDQIxcvzzVT3Oa2488w0MZEh83444t5Qg/JLJ18z08V52XX6Nz/t/CFKcYHc748VFF3bzOwXLV4ZzXEBT/G4gWpwu7V4wRUeQNPazwZiTvjxwlOGeNuaSiDR7+XS66+YOi1PxPatDL/m2vOUyNxPa/kveDQI5ECr0DMYtz/Hl5LS+ZCdJUCGAdPSOgKmgadCPPBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2R8vKsJixZKIrD69VGphfU0oZAQPuSUOLDseHmAZmX4=;
 b=i+JmZi0dEr5kfdhUxZgU52y0tC7pz/asxUDtIJEA4GcqglPdv3bJmyx3ofGlrYXU9kmgk1iZZSlcYt7I95dBHwrdu8qFirDYAdphfZ7qShNGlFLpBUi3rcYU8rTmGWcUtjU4THR24jYTBwP0E3RinhN1KvePpeJ/+OUeiXVoxUZ3xFGlgK3M7L5uxRQaQjw957uPnEYd8KCjcZXwXQgF+IjmOV8GygPnlu53MFj2ECS4zUv9AOh8U0KzMeFV2s3xHg1uC9yU8l4xHYbswBohcq6YL/tz+zL4XcmVVqSfZK19hSZ/KsJg8Tz4hPWfc4k14ZhQEtYn8T0+aQ8dpBFlRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by PA4PR04MB7533.eurprd04.prod.outlook.com (2603:10a6:102:f1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 15 Feb
 2022 11:42:51 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::98e0:cb7:30fd:254f]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::98e0:cb7:30fd:254f%5]) with mapi id 15.20.4975.018; Tue, 15 Feb 2022
 11:42:51 +0000
Message-ID: <2f2feff5-6460-63f1-6aed-553d8c8498be@suse.com>
Date:   Tue, 15 Feb 2022 12:42:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Ondrej Zary <linux@zary.sk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
From:   Oliver Neukum <oneukum@suse.com>
Subject: question on ca139d76b0d9e in cx82310_rx_fixup()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AS8P250CA0011.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:330::16) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22128f44-d229-43f4-956a-08d9f0784be8
X-MS-TrafficTypeDiagnostic: PA4PR04MB7533:EE_
X-Microsoft-Antispam-PRVS: <PA4PR04MB75337FFD823F7871C8962657C7349@PA4PR04MB7533.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tEZtmGdcP5fhyL1kmiqHZ++uscZqUf4BMubaGBhF4xkktDNCOdKUIBZQUneepnAs9miQzdb7CSdjMTfZIljc8oe456YrKJh/LaCCdWqE08a4CY7a06hj94rZHeQfWxnJ7sXyr6SH6hRixt0wFWmRIaM3Lel44A4Bp1PuQtiFi9njsnf//050E7fh/rswOa/Fobk1SkyvBUsLe01dakZtv8fAIMGxR4esqtXn29/yXduxJ5wMEMv0FaCBJm9SARKkXrfyPgleLwrq9OEAcs4o+P2bkzQNZXBayLTYEfwtQmctCigf6qa6fHYTcDlrrLpE+m7PmcJqQ7DXIl2svIU3IIEMiEzC/GNeViEJyjBrQObo6qoAbVrHXOSJdoPno2yOlk8u2p+DOIvhVmZltwioRzqhRVe23qzIjGfpLzEyUhdIBAK9YAzeZdOEn6GxrGEIJr2D077YrzZXKf1b6LsJXfMg6oyJ1W/QKLqOA8phhUyo6QjdhZEld9wfQo+XzSQ8+s5hX0Dc4yG5rNwo7E8YkJoKq91Q9/piTHmPLRDcmscvUxse0B+c1Cd3dhuBsiw5DACpizoxm85PTBvZrUgMsGWnBEgARX7QhbvSCn83qfE2rlXEVad2c4ZLu4294nCMF/g72TNuEAqk7KzKaq6XV04NMUP1tDIXiEj1Aa8BeYf8v+KyI335aCdhISrPovBoDkmtxSpcLwH0+2Uek/edUSUbGmZoIJ93P2eGCqGD/tY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(316002)(4326008)(8676002)(66476007)(66946007)(66556008)(6506007)(2616005)(6486002)(86362001)(31696002)(508600001)(54906003)(6916009)(6512007)(38100700002)(558084003)(31686004)(2906002)(5660300002)(36756003)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cTBcSvkEiie+ONFhUMfAvSOs5RGVil6J4nmtwgQjJW9snz1ojI5IxWXBm/+6?=
 =?us-ascii?Q?eT2NXN7BiSsVrTwAqskG8B+uX1ecXJ/96sQLKFCljmqZIKAe/EDwKYpu+5b7?=
 =?us-ascii?Q?oSCZnPS6awxc3/pafKr9rxehrXr+7dRbFoMpLE1Mx2eAsnztI3WkD8XEf+Lh?=
 =?us-ascii?Q?/De2DksawLzgwXap4hlAZEN5NNVxeW9PW+w2yuxnzL+eC0gaJrLIIerUEjY3?=
 =?us-ascii?Q?3HBzWoCJ3uDkEUP8Bme83x9cWEilgSL55C6GUmSA8oANeOSSnQI9VDzhd/1P?=
 =?us-ascii?Q?Ko0YCjWTl1AQHfSoyrOraa/nnYWE4mICfzaGUCMwppGXaz2awg9qmFx/KsDY?=
 =?us-ascii?Q?BxIt35MvGNXTK1EHxhp+xZqnNnl8XX06w2EjnRixxhwuL++PBpvrScNef5IZ?=
 =?us-ascii?Q?d2GD7B7POvgJHl0+76OdOyPPzd0InCddpzWI2HNrCMktWHvU9ME8o+mkCRGe?=
 =?us-ascii?Q?2k0tfQ0/SBHBcpHx+reqjwEbUuq+DPrgcpMKC96T4LGdivrD3uFHlPUw3vcp?=
 =?us-ascii?Q?/hryGUBL4Bg4IL7n7DZAQBkyWchM18vEff2cpV4Azq9DBoa4jLn5YzR6kPwA?=
 =?us-ascii?Q?9lTTbk8rKuJGZhsX/TGKoS/GaHL4CCxYOU0kjgHIKiScVZD8Gp8XiAwqB08g?=
 =?us-ascii?Q?o5blR74/4NjFvn8WnBnAXS2I71TD27mLtsF7X2HohAGepQPfg6jhZOt0k9TZ?=
 =?us-ascii?Q?vmRNf0UAltTUmSw2LpofMoZgW6C0Pt+Qd3n2+RHXf9NXfKJZw3ZXGac2H3hY?=
 =?us-ascii?Q?RKy5IdVXtlLcPUSiNBaqr8lM3+kAoy71zGMWD233xAUmHS19vO6bGKyMHU2Q?=
 =?us-ascii?Q?99uBfPHRM0GYMycWxMXmg1Ay8DUs3Rn3RFb7Y0UO2TiliY7XHGwIRqPYe6jf?=
 =?us-ascii?Q?DT0uuko1DakNxAIbsveSFLVNBiRxLMpRRLaDkawX68TXkYMnVFvf6+QsnabA?=
 =?us-ascii?Q?RElN78Ry6H8xma9BJENbG7kKhb4qhTneyUQKaYYFKL/ULxSoCLWaF8JScxSp?=
 =?us-ascii?Q?Mn9U/Wbb4ohdzzVOENT9L4+UtS7QyPPBpNL6WFqZjqFv9GHzDBR5cYGKRbJI?=
 =?us-ascii?Q?/PJh1ez69Es3eSXU8HG5d+RIf/8kxq3U7i7R+wI1ZoVkMUejAMo30cdnGZC9?=
 =?us-ascii?Q?yVLP2F2Dt4/GlAsxRYC9RK5vtvQAJTx3OhmelUT2gZzXJY721hrSJN6LcllJ?=
 =?us-ascii?Q?aX9o9Mgi9brAhiTRoZSqphpZvUuWAydKdWal2EAgK6NKRBtGBhEkOfxqQJ20?=
 =?us-ascii?Q?551RZQ93HqKskkeJSn2R039t+DNUpqK2dqgI1z5Uv0eAoQuL1NYdpVhoJ2dk?=
 =?us-ascii?Q?Ka/9kVgf8xux/jYMgLbbKcl6z54+EyuNk4B7yoTTBSBchvykveyHQYL1I+2m?=
 =?us-ascii?Q?Lg6OU510Vj/lMFnHI3VOK2wdRuawvMKdwmthOHgIQMS2DIxMH9qnnqmPqoTQ?=
 =?us-ascii?Q?kTm6SS7+xvbepB9k2lUO5ERUC0eT7mLunMISLD0Ig9BJn4cZS96l955YPlQZ?=
 =?us-ascii?Q?pZckpi+GOzK7m4akp0TPJLur1LnSgjzzZHTivB13+TTbpF/R7U+NwO0nzote?=
 =?us-ascii?Q?yc7lcHkwj1vPFVfoRmh8WeFNudLj8zlY8saO2DmzuHQChYXHWhHMANR8bVho?=
 =?us-ascii?Q?TQCgV9k7mTJt77YU9BXA8YtR6Cn5Ank3RTftQNwud2g5ydLPUK+LLUkWomss?=
 =?us-ascii?Q?xZ58ZyDn+e7zgnwSk0WiJj0kbzk=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22128f44-d229-43f4-956a-08d9f0784be8
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 11:42:51.2254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OxCOgwAGtV3eNYCR3Q5A3ebmjqL6cOTw5W4sYlPgH/zMe44WJZhm0kUcKQIec2SsOwQ7akGJd9XxjzpnB5RgDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7533
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am looking at cx82310_rx_fixup() and in case
an invalid package is received the work is scheduled.
But as far as I can tell the package is still
treated as an incomplete ethernet frame. Is that
really what you want?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

