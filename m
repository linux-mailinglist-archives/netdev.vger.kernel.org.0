Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7DA355063
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 11:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbhDFJ43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 05:56:29 -0400
Received: from mail-eopbgr20108.outbound.protection.outlook.com ([40.107.2.108]:23172
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233842AbhDFJ40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 05:56:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCP3NNuMM/STuhghwPH57RAGOQEbsgVUviGiKuWDtb9ddaijUw2BwI8PyRkMDJ4HKpPmaPkeWP1DOXUMX2WQgoS3C3DoizNt79+2WjaYDnG3jdwJzUPKODcTsc+3TZT3XTP4cIYow6y9mDAkBUxaA9OfM4gATipMEzCyhjFVB+2ntgbxc8Dyf4HeWvs5RaoGHIiRh4emZPnGJX1ZQ0K2//mc45rFXiaPR3x0HFCl4lchD0On6G8OINYaEul1g2i+vCMDzyaRmxu77g4femcHxRfa6spFrX/uHG1cKBhbQDfBioeHxGyVNvfJmUE3sKHsYItOLZCC5etVM3DeCVnOLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrHC77jPg+JJ4pFsVEp+tTOjQFI1hKTuEbka1xlPnvw=;
 b=mbAUe/PftMs1zCBw7+IcA+8mrJcQZyHGpAY8rpQRJ07s4YH0Qfoht8xUYJwPJTlBooWP7zq05jIUBZCqQ+vfqSEuHAL/XO9eOvkVUiQTm5vsouIF6jRe1mtQmS6WACJIfVqRQqIfKj2DVkbdxknxce20DA7rHZqsDVfetykNxiYAO2jwMg3qB6A+D39NHAeUIbeXDFgfcH7+6xp4SPNzIyXV8jd3x6+1yJeJfF1wpDWixj/U5KkHJbqLGfMKTSGl+usipDSCZLcN4P8M13sqdlEV/XLL2OfhuAsjimXKFA1syiXzMoS/qawX1nHu++FT6SdMYMCGQ0Fd50u2KQpUNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrHC77jPg+JJ4pFsVEp+tTOjQFI1hKTuEbka1xlPnvw=;
 b=hlsOV7EovGblSX2kINA7mgif/eCGD4Srupe+BJ5HhswZqSVmDHbc1xzgspiFlvEONXCC07gL3fRduOPHegM4eQlM0jlP1NXAZ+QOtfNi4AGRylIcX1P/eIdOjwMmTOE2wNIaZXP76CFjIHuZaPPdNRwy6z4P3edOhiDeO5sU7GY=
Authentication-Results: geanix.com; dkim=none (message not signed)
 header.d=none;geanix.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2770.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:130::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Tue, 6 Apr
 2021 09:56:17 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::edba:45:89f8:b31f]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::edba:45:89f8:b31f%7]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 09:56:17 +0000
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Esben Haabendal <esben@geanix.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: gianfar driver and GFAR_MQ_POLLING
Message-ID: <ff918224-ce0c-9bdf-c5f9-932cb5d31e0d@prevas.dk>
Date:   Tue, 6 Apr 2021 11:56:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [80.208.71.248]
X-ClientProxiedBy: AM5PR0701CA0051.eurprd07.prod.outlook.com
 (2603:10a6:203:2::13) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (80.208.71.248) by AM5PR0701CA0051.eurprd07.prod.outlook.com (2603:10a6:203:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Tue, 6 Apr 2021 09:56:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6d42f6c-d97e-4259-0ecd-08d8f8e238a5
X-MS-TrafficTypeDiagnostic: AM0PR10MB2770:
X-Microsoft-Antispam-PRVS: <AM0PR10MB277002B9915810D8D60751D593769@AM0PR10MB2770.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: izzO0qvlRdjybxbpzyeUY8kou1LF4wa5xr0JIdahMklrVREh2OiolK8pcLbBdaPkPbGWdccoA4wVHO1dbmy96laJIaL+oMn/up9dkVLq4gaae7yipqBWBGzjkb9gfB3hYsXYrVBduZWixvDYypzg1lV7KuHgfeIGe7iL+N19DeB+x+4U8/igeax4KW96kOPCKqu/Qg3mVP3OB1nAYU5s45YMHmj1Vz9O6XIbMhbmnMet9V4M8E+mpiQodsUHeX1wgS2gFtuy62y81eWfDL0njAfFuZF1YxVTD0/peXqLGQpUHLsKoH1UWY8IfW6axnocQSs34d3s3932Sx/a4FBO3GCsAl4a9pIsPHhQtKXgyF0EqnBoxammwqt9yG5qgWMn7oDplNeAS4/ZCS1inzoYf9AepJAf+rdtX12jL1f/oPmRKTTIzmz2gaHsynHFDreyFJrkDMSoIo8+EaBMu6YoBG6UC3V0STv2nVQNlGib/6eLOsjueSi3tmv2WThNfCtrGStxHMX9GFUiyT/yiaE4DihzvjR65G1U6gsqKDwv67Z+rGxCTM0O6qsvRC7j68s2X1OkLdvRYcJPqbnxCFGCKhKJzkBQhvrMPldT2E9+nqOMDE6SJVVAZiayjM/eA/+SXtPQLmBWkHXemddDMiGHSdlkI2zKMHTK4U77fAa/wJhRp1Mc4JIUDG5HRu6eySG9YdbCXJSiaINN/HItdEY6L/pHi0jF0+J+LISiS/m7TqCi6U9sY5ojF1oAuFTEbkx1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(39850400004)(346002)(366004)(31696002)(8976002)(26005)(38100700001)(8936002)(66946007)(316002)(16526019)(186003)(16576012)(5660300002)(54906003)(83380400001)(478600001)(44832011)(52116002)(6486002)(36756003)(66556008)(66476007)(2616005)(86362001)(2906002)(4744005)(6916009)(956004)(31686004)(8676002)(4326008)(38350700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?37V723EYdqyaIgTUKtQzAskoJRxNcdrIeMlTgidbTTKJoIycD1FmW2Xn?=
 =?Windows-1252?Q?+uKA2yr5BV4IsaWij2ka49ifUjji4wg3hGQ4bGP5Ki06QD/czERw9cCe?=
 =?Windows-1252?Q?rABxjkswXe/NE6ZkdmlvmFy6nY57oNxEIi6GcM+d/dlU4bLKdiGqDoU3?=
 =?Windows-1252?Q?wMVZFqOU4/LooSlXcglfsTQMYJSOHEMf1wKtTviB/F/G3WdCE92z8a5V?=
 =?Windows-1252?Q?xf2H7k7jtTHkmFXsHuV17bAZR+4LiTA2K8UzV/AFKRSM3R1W+/gP4vmk?=
 =?Windows-1252?Q?nhuVJaAy6gFD0JHI9pxy2weSKJzPD6pk1EPO5tVXMpfORcUETu+L4Z6y?=
 =?Windows-1252?Q?z4mXvA2xtaNATT0tZ65d0+Vv8NnAqU0FDxbfngTw3Td5BnQDLcs1BIty?=
 =?Windows-1252?Q?asIuTlOtdhQxOFxHN6VHvzz6v0ETnhY55t1dfGt9/Kc5DYPsk+g7ED9j?=
 =?Windows-1252?Q?WzQZxXy9apyqkgB6SI5HJJAzlgmW9A59kV5BHrcP3cgBp/8hGOkw565P?=
 =?Windows-1252?Q?Ye9MN/ciBoDIgl9I8aV08C2kbWNQr/h8GNx1JX7KooOcrXj2FRb+BA72?=
 =?Windows-1252?Q?Oj3iAx2jPlil2Cn28jBraLlkjZ9Jhj3SK3i/datXcpYemAIueW3lwZzD?=
 =?Windows-1252?Q?0H2Dx46SNuxfagWDuW5gNTEVJCOPsFYrZIypV7M6a2GSh+RIHJYCuPwy?=
 =?Windows-1252?Q?oLk8mLIUC/fjgbiml8LOJYYlU4Rfih4kbryy1xEuQwkD+ZNHpxX4GNcR?=
 =?Windows-1252?Q?fvlrSZ9IzSRQjlt1rhfrG2vquyPogJD+NpFYcFWdTI+kcXeVmK5Dr0W0?=
 =?Windows-1252?Q?sWRZ1dwg4iCK9+PIy80Xzor4Ax/XoDxxKR3TevA/RUGB3u+g+mMix/R+?=
 =?Windows-1252?Q?cjHNc6uKLRKdUR1dNj/wqbIdYRURiw3sPiuejZWHMLBMXMUfFm/y5tL4?=
 =?Windows-1252?Q?l5HgqNygY8kuIceoqJ+bI+EzKtAKgCRAPjexz8hXu8hajynAvEdviu2h?=
 =?Windows-1252?Q?JsFJek+aIizjs/5Mai8oVAMkWVq3aNraFplkQ+o70RtkUMmTtCX05msJ?=
 =?Windows-1252?Q?1ZRTCaW0wCmhiDqlkgiLTQimqfyiXPatGo/aSbatsSDIUMK1X1mhpY1G?=
 =?Windows-1252?Q?7i8T9gtrv+bY6IAfTIYCs6BUTBA3HkFgorz4JFUT1WBU1Pr1wLSJPjr0?=
 =?Windows-1252?Q?0R1hVahafhQPYrCWZEbNR1vTL5RjGfuY/TkHDwLLt6rA85c8X2VaM8dE?=
 =?Windows-1252?Q?2Qcs3aP7mZ8akG9lN9+vOFqURFzV7w7ElgcO9dn3S2g0nzmURfO53nh2?=
 =?Windows-1252?Q?B5W0sVmUKs9HDhXkEnTRBHniivg/2o0QnHHuX6nVj2SaLs4HOU3LeeK+?=
 =?Windows-1252?Q?CkbNo01FlwD/Zv/Cut3rlRnWEXXyx9FybMsfuyk61/0bnL4wc/+nBITH?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d42f6c-d97e-4259-0ecd-08d8f8e238a5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 09:56:17.1342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5spH7DUZ0nThcNh8JNMgmXks2GANyECXsPP5YgnpE4E2IdrFm9g8Z9Gm5CJ6kn9GpNm83M+ADL8czmDzVJ0HLv1vAoJZ3ldXCY3R+nD9nGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2770
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I noticed that gfar_of_init() has

	if (of_device_is_compatible(np, "fsl,etsec2")) {
		mode = MQ_MG_MODE;
		poll_mode = GFAR_SQ_POLLING;
	} else {
		mode = SQ_SG_MODE;
		poll_mode = GFAR_SQ_POLLING;
	}

i.e., poll_mode is always set to GFAR_SQ_POLLING, and I can't find
anywhere that GFAR_MQ_POLLING is used (except for comments). So it seems
that everything in the else branches of the "if (priv->poll_mode ==
GFAR_SQ_POLLING)"s, including the gfar_poll_rx and gfar_poll_tx
callbacks, is currently dead code.

I'm wondering if this is deliberate, and if so, if the dead code
could/should just be removed?

FWIW, some quick testing naively doing

        if (of_device_is_compatible(np, "fsl,etsec2")) {
                mode = MQ_MG_MODE;
-               poll_mode = GFAR_SQ_POLLING;
+               poll_mode = GFAR_MQ_POLLING;
        } else {

results in broken network - ping answers the first packet, but then
nothing after that, and ssh is completely broken (and if ssh is
attempted first, ping doesn't work at all). This is on a ls1021a-derived
board.

Rasmus
