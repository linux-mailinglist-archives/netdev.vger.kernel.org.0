Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AC256468F
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiGCKDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGCKD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:03:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6C12BDA;
        Sun,  3 Jul 2022 03:03:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/Ck7jUU9WPRWoB3hH8fLZpqmVUq9zKwqwnqdfCKd95wrZetkpENy+F5YlDV7WiZiFZ3fxlVVs2Ms84mZ4ZuqZNSi96Oe5jT8GTM2vC0a2tvlx7LYeB738SXaq5j25hug30mWgZRm1Y9p0h1yHSMxi/NWO2IgA7OSkaTsctGSYqn1M7M9YcO8munRS91jtXTPJqxPeIdvC0CYxzLUloSUWPoi1Cf74heZjrz/RuDlyaYCXxlAJL4urdiLyUgclFayAV0gAWm8A5Maq3+S8MI8TYRalknB+uOQPBL+6dtmuJEVctkqErRqMhsr2lxxF4BPXydYlTG+dBu4gCyPQUzTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRPzdHKb04PYvbsOo87Tg159ORK//d/ueQDvFdaxOiE=;
 b=ePPO9nswu4qNZp8FjKAETyipKW8xgRQ3xvecSzsS9Uj3h20qWPnPX1EXIvI7t1OSSJXDHsvRNwfiTyJivil73EbYlYrWtVf7iPjJMksQ77/L7J0t5aclQ56hmXC+hfrDviL262eyrGUA+BVtsn1Sp+b9xuRxYoZgosHx1glImMzhKDJoqR+zJafNcj0tyOgRAOF+FSbNxC4PAoGhiWHLgTpqVVMQOwTQnw8XtR8Rch4dtabBmJBYKoHPUCIgNuZ+ZxFmxc+LqvjF++y9dg9H4PpNk7kKtRAPxbN7D2ECXjc+eTSGZSX6Tvc4B+5ARzrOWUsJbDR4/ac/3PL741o5RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRPzdHKb04PYvbsOo87Tg159ORK//d/ueQDvFdaxOiE=;
 b=QFLXYjIfIAmRm6TphaLjKrytGz+7R4ZdRVavsKd8BYMwypY+nItRDoosU7JnNDC3Ri1TicuyG5QKOYt7rYMi8hxV7+4/oNHoWGIkAfKd+sKEhDkuDWD9+N2Esu4vDHYTwXHZg/BkPpuhQ5F2yBZ+Qpr0s4ffkFvMcVRpc+EJNat2bD43GbO7Rljw0Sgf1KKtNaaK5Eaq0wokdZZ9Pm6YocZW3+h6Q0PxE7C4THJHJMnOLEXAjafVnVY6lqt1gJMgfPdz0GnknBq2AQwy1eLIL7zxUflPetwPgU/8Vnrp5ZC1sjF85qV2KRl+4ZOZVaOdbmIZX0Ktkl3HxQ3hirbP0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN6PR12MB1778.namprd12.prod.outlook.com (2603:10b6:404:106::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Sun, 3 Jul
 2022 10:03:26 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.018; Sun, 3 Jul 2022
 10:03:26 +0000
Date:   Sun, 3 Jul 2022 13:03:21 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 2/3] selftests: forwarding: fix learning_test when h1
 supports IFF_UNICAST_FLT
Message-ID: <YsFpaf/Sk3d26Zzv@shredder>
References: <20220703073626.937785-1-vladimir.oltean@nxp.com>
 <20220703073626.937785-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220703073626.937785-3-vladimir.oltean@nxp.com>
X-ClientProxiedBy: LO4P123CA0573.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::6) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb057e5d-0342-47d5-1ec9-08da5cdb45a7
X-MS-TrafficTypeDiagnostic: BN6PR12MB1778:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JZ+iPsa2Qr7kYYfwamWk/5V1FzL4LVvW8MLbmEMZZS2g1R5UL/UGExy1Ur0mNKFBHMJa34HEzY4jiNZcXjFNq6dsLF0Dthn4npCEfGCc+WECl6f47IDhJoPq/e10VSGdacC9gAIdHvHoi218GV6f04q/vAVb7NjwOZU7ofzSbewflp4mdcYoM+Ep0kTgtgVDwK/6yzBaLM/Lo7ZPGds6Z/dPp5H6ODH/tKXYpsJNhmgqGmoU6gLyRmHV3SWlhxwPl2GdPRFT0042uVGMIpCuIEDH3Z1mA8xvPUvPWGypjaNgBuhEXDpFUWsEsiLpz4aLOp+ervfdEJOr/43YCj5YafoSSeFDukgjJrCL3hH/lVbeFR1EusPSDutVkxR64bhhY36rqXq9Zul3zmnNCB/EjrGbjtsaQQwM47lx7ZnxsmTQYhEAnWEoFEE/DADIMhrS24etjxf2GfjpXcMtw6F5P2LF990D1i2WQsRemsX4+PvwLP9ddjL58J7QwXK30RCOWL1K5Xebs0BeXPVgW6yVtnGykk+wD7px02TapVZ39qj2rfMLqteMCcGisrH0b8iQPrgS0e0Wze6ukmDOL6yS5iEp/6aSOZUFPxU9ZtuBozbVwtV2V6o+rG4WQqqeCBxcFMPSgxmmCOmVx2Wmv/c8LbC5dWGs/PINPPIbr82Sqn/bD5ST9GEroPTPkBBjsKFneijBvflXSpJ/Mp+QYG3UZvHWosRdLMSJ5f9k7dT/4U3qE4S6TzJbchXr7IHTOFN+fa4zzHKIKJ9MdK359AYwwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(41300700001)(4744005)(5660300002)(478600001)(6666004)(8936002)(2906002)(6486002)(6916009)(54906003)(33716001)(316002)(186003)(38100700002)(66946007)(66556008)(66476007)(4326008)(8676002)(6506007)(26005)(6512007)(9686003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?liTkUypkPrcx+YMba4h4L0+uqn0AW/8LYlZzylZR7RltnlBeyVep6vcD+aW3?=
 =?us-ascii?Q?uRxT+Op41uD7/+vGQtZY032gHUd1TMN5sVRmoi+OkL+5kh80OCTiNXdLAMIo?=
 =?us-ascii?Q?TQGVjx1XT6uDYRe0zF91zpoN2xV/pso/KaPEuh7MTOEfA0in5yQd6k+Qs83L?=
 =?us-ascii?Q?y++4h8wXmKV0KOGxTumtTQMu6+ynGS8rQAvqBKPdEGny/mLdfUMJls0x1Z+h?=
 =?us-ascii?Q?eRgxuwrtdlw8vigPWqXlnq50wZ7N7CPNUEARH3A4EPwd6WFALx5lBEKEtCT2?=
 =?us-ascii?Q?J/xZ0lZbF9lZoatQdvXrpvRexf5T8GdnAiHce7tg7N9EgV5OdK2c9I1dQcAS?=
 =?us-ascii?Q?9ZuJqY3AZwCzUHl27Wum0G7NA2ntv9k18/RCRiaAryEozZSglm+yI+Do0zNV?=
 =?us-ascii?Q?DjPDesTPDK2LCcXyhTBICK5dZTqlHvgWs5ceugMat6SXyPbFjPTjCyVBrWOW?=
 =?us-ascii?Q?Yqm7fwHL9SN3dk5M4W15gZs69rPZ7Lfp8iltx1d9QxYEsdYZcNELkqFx6qoU?=
 =?us-ascii?Q?lm0DzxhJbhb/j6V+8B0rD+XGlyiES33K720Ts2BYA0C5bIYjk6/CzH2dG8M9?=
 =?us-ascii?Q?0dVDVOIUU+r7R1aNcIUHyYj+BUCB1S+ol+RsvZrz0NANET0PuZzdktiunCzr?=
 =?us-ascii?Q?2snvVr3SpUB6R1ekw9TyqbdhubjNuHosplVIP6uuuC2fAzk+9CueYISsHBdc?=
 =?us-ascii?Q?tlmh6J5Hjf1Ub98zkAvU/Vym9LPdKkxDgMX3cxTO1W1ceKbmb1HbJ//ekUkf?=
 =?us-ascii?Q?k60D02eSbbPiYsmtzVYiPMnulsfkh/884Nipk0One+HIROd3KZEWIa05WRrJ?=
 =?us-ascii?Q?unQrlWPGJAn7qHn4XWJHwN64fEU2myhO28h2vj09zpuuIwc9AQrgin5iXCg7?=
 =?us-ascii?Q?w/dD00CBhnqJfCSJgIk1i9cmJUgg9YYGKWz4KwQTqZkZnAUkG+MWaJoQxdAl?=
 =?us-ascii?Q?zrwojvKdRBvBkmw2HjNJ957GZR6vz+XOUDS+zqNyyMJ3izzMApxJ1V0rIncd?=
 =?us-ascii?Q?0muKD2T9q399qyEh2No0ZeC9urLIdWFSpjqaV827MSDD+ZVBhz248KvoJwcS?=
 =?us-ascii?Q?tZA0xIjZyZjWwwovM3DxmTq/4sN4uFmhc4eBGN0M/LE4u15qqcMzgD0qXc+b?=
 =?us-ascii?Q?dp3tPjsXHG8dKEHTAmxik/rAQlEyJjOYqafbd/PupLc40hxooGmQv4pQDJdn?=
 =?us-ascii?Q?gw/mhJPDGCVG0YX1Y6j/ZcaW1BqIUSP5AlqtD/mRQDQ7+iCn8iUTa/uztHYR?=
 =?us-ascii?Q?J1HVlYYjt26y4qWaVXva9fkrmWROrtqdewriQ2buS6irdE8hidu3ygFNoaPs?=
 =?us-ascii?Q?JJIoxE32mID2Fc+mFANPdR3G4Ytb7qyB4AR9tjV0xyoGZVOwVGtyJoBYECWw?=
 =?us-ascii?Q?EDwfr3af/omCHdnu7mbxnCbPIzQTEjDqbAFY4w+6XEf27DGEP0E7El8DswK7?=
 =?us-ascii?Q?/btJa4P5ml4UxHHjFOKDDFKJu3y0q72/8WO6RY9fngrhHEzc8D4NKqlGnpc8?=
 =?us-ascii?Q?ORhgTBuZf7Zau326/mHd4+7iJa2aiS7/lAQFhcqc6P7BDG9MAkxzCXC/RZbL?=
 =?us-ascii?Q?AVv4OyMhtzizVRsZmylSZxM+Hm4m3t8h7UDHYhUU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb057e5d-0342-47d5-1ec9-08da5cdb45a7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2022 10:03:26.3612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J4IYhWe5b9vT6AgsbcX9d2c1yNMFidYqvQqz39Yfz61H+Fwc9t6OgxjFgBFmJieEt+1BaJnaxyIbngOGt4hBbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1778
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 03, 2022 at 10:36:25AM +0300, Vladimir Oltean wrote:
> The first host interface has by default no interest in receiving packets
> MAC DA de:ad:be:ef:13:37, so it might drop them before they hit the tc
> filter and this might confuse the selftest.
> 
> Enable promiscuous mode such that the filter properly counts received
> packets.
> 
> Fixes: d4deb01467ec ("selftests: forwarding: Add a test for FDB learning")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
