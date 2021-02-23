Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F2C32271B
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 09:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhBWIbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 03:31:10 -0500
Received: from mail-vi1eur05on2076.outbound.protection.outlook.com ([40.107.21.76]:54624
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232201AbhBWIbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 03:31:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GILjkwfr/nRLy0+68Dsrjefg5O34tSsL4qitCwNI/ci/vDxXZgTQri4YlMpLEqqICzNAG6xF/YyPdExKelaSuSmpZGRadVpVFlt/uMctRsW+Ildqu/K8k5RUIDrSR/5Lg2s9BomaLLEAyIF3x8y5gHlHk6e1sVhcDuxIKV0Uz5ul7ZrQM9bmC6Hi+G5/256kuRm40E133OoodZDr9yBrA6Rwa8gNeEpyGMpOzkGiFBg+/DZLHpXYNDTcc7k3QNImTqJ6hBbOU+LYYrBOBUal8y40yu6z14p3fiayG2BKlhMQowGJHv7jCiMnX0NcKBVT3jzeRB5h6AOWPacc+OZSZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jZwi4U2l2p5e5rYTtFGutJKrabMizmwqdYk8rOCRqs=;
 b=g1RWfEFusWt/19it7tYZSBGfSM5Ja3GlNPS2byz9VJnhRcXG4TB/kMQAAmRrPRadR2/Yw+uL7ptvhb/L9Cjt0WAAjUvhcpVQP4FYfZ4Mcqx07oxOPfYKXu3ygpAfziaWeqIxk0YLesyRhzEXKDunrnThlJpAeaKzCaENQ2tRi++sdkFW4d6491ZWVsn15ceeSXW64BIypK7HHt343T+UUAqm78NbakAQtEKzGSWxoxnyYCCvA3Dou9s2VOmw+UcHTsrY1QoxCcgPYlaqHXfAKBuhMXiQ7zbJEJ2jbAv3xAb8RS9aDiZEPFPM1wgdFAMclnqEd79G+H8FfubXWpCQGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=t2data.com; dmarc=pass action=none header.from=t2data.com;
 dkim=pass header.d=t2data.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=t2datacom.onmicrosoft.com; s=selector1-t2datacom-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jZwi4U2l2p5e5rYTtFGutJKrabMizmwqdYk8rOCRqs=;
 b=dcWDr70t0Onp6ZjbpP+5PfcjyUqdYC9k1ky131jx9Yihr6xRg/MLf6VS/bxSSuJBdWJCax6487UQEWG+uWsnAvqHoukZ1jEhUckF2ajfa5X6aGGXy6zoUBN9MPLDMm8mYwqgduYqwuf7YH6gloaGGDcfVenAQtqCncgFi+s4mik=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=t2data.com;
Received: from HE1PR0602MB2858.eurprd06.prod.outlook.com (2603:10a6:3:da::10)
 by HE1PR0602MB3323.eurprd06.prod.outlook.com (2603:10a6:7:20::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Tue, 23 Feb
 2021 08:30:11 +0000
Received: from HE1PR0602MB2858.eurprd06.prod.outlook.com
 ([fe80::a40f:7a6e:fca8:eedb]) by HE1PR0602MB2858.eurprd06.prod.outlook.com
 ([fe80::a40f:7a6e:fca8:eedb%8]) with mapi id 15.20.3868.031; Tue, 23 Feb 2021
 08:30:11 +0000
Reply-To: christian.melki@t2data.com
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org
From:   Christian Melki <christian.melki@t2data.com>
Subject: [PATCH v2 net] net: phy: micrel: set soft_reset callback to
 genphy_soft_reset for KSZ8081
Message-ID: <c1adb83f-57dc-9a97-f10a-c0853cdd8f09@t2data.com>
Date:   Tue, 23 Feb 2021 09:30:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.234.39.46]
X-ClientProxiedBy: HE1PR0102CA0008.eurprd01.prod.exchangelabs.com
 (2603:10a6:7:14::21) To HE1PR0602MB2858.eurprd06.prod.outlook.com
 (2603:10a6:3:da::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.7.217] (81.234.39.46) by HE1PR0102CA0008.eurprd01.prod.exchangelabs.com (2603:10a6:7:14::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 08:30:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e70fbef-e62a-4eeb-5310-08d8d7d53c4e
X-MS-TrafficTypeDiagnostic: HE1PR0602MB3323:
X-Microsoft-Antispam-PRVS: <HE1PR0602MB3323CAF9CCF9A6922A6AB89CDA809@HE1PR0602MB3323.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tYk3+lvnMdJdhHP2tnQ2y61W1TueBMllaz72S2PRDn+T2zFJZHIlff1UR1LXBhhr0eI2vPyhloPLirETklxvzfB1fRpA8krI8SILUvqeaOp2fy0yMFZmdbT6LuLFkkyrR60g2SvPzZk0aY8A5CepRDOUljXvkRhbgmpbRupFy/pA1nPZGNi+llI3C4y2JCtwV4Jpruu/lU5SJBt+dbW9tAMRgYN7aXIoo36z+a2GneEXTI9RYDGqYt5tiLrJ8LqS/mjkomKE7Qj9ZRz1CH6Fx+U0BJXBZ/O4kPkKJjIZemnS+4uSWo9gvQ7OeypDZTu/ZM4fvatrrDcLTLY2/bdsasoJGBL9c2ZZAi224wWp8llLIFZpmLje7C+k+SEfAai2z6UYt794AcauAhmBnndO2Iv/RmR2S55nK9GsUypoNdGxcA/P60WUR9n3EmtNeTKEzNZHA0fnZq9T1igN/N+dh9PvT5FopWXr1dasj+shw5MtPkoFEvDAM8ScYbhrfDxNH/o127uRJ3tz5t+5cF5N13genXBgO0oysDw9uz6cl67nMsvCCRSBGi6luT3587Alou1NSIrShlo0q+1v5N4uBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB2858.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(42606007)(366004)(39830400003)(136003)(396003)(346002)(31686004)(26005)(16526019)(186003)(36756003)(8936002)(44832011)(2616005)(956004)(31696002)(3450700001)(2906002)(86362001)(316002)(52116002)(8676002)(16576012)(478600001)(6666004)(4326008)(6916009)(6486002)(66556008)(66476007)(66946007)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bkVRZW9tak94Smd1b2p2cTB2TmJBZGgxbjFNTWFGSUtDeWkxNDZ4MlVnakJR?=
 =?utf-8?B?T3VQREJRV0pod2dkSmRPU2tESnYwVFVZSmovVndyc01GNm1RVzhHaFRnK2tn?=
 =?utf-8?B?UHVlOTFONTYvbWpRVEQydG1kd0tXdGQ3USsycDA3L29PRHpCS0ZOMG53YjlJ?=
 =?utf-8?B?Q1dtTlFvMGRPdFo1WHh5alR6TjliSzVmdWt5ejMvZVhHa3doMStNTHlLM2xG?=
 =?utf-8?B?akVJMWdrSTBxSjIzWWFVNzY0bGxSTFZrNlJTV1ZRQm95eWwzckU2SVlEdkRS?=
 =?utf-8?B?aGlTOXB6U3VKR0swR1BJVHJJMzdqRlJ2NkJHRlBBbnBoUkRGZG50UXh3NitP?=
 =?utf-8?B?YVFJMmhxc3NjMjNxT0lKNnNYMDk4U1pSOTVIeEVzdS9GWktkWGxEdWFSU21E?=
 =?utf-8?B?QWVyeUV2UmkyWS85WVREUzBmT2NOZzJIYjBFaHJhQi9IL1dKWitraEJOM01u?=
 =?utf-8?B?ZkN1bHhvVHNSa2I1dDRqbThpNzgvbW15d25Rb0RPbDU0OGJqZkg3MnRIeitr?=
 =?utf-8?B?QTZ0bk5zRGdwRG5YdXdGdCszcHlQdldvRmk0VUVDTnJkK3VGZDhIM2Nqb2V3?=
 =?utf-8?B?ZlVzM3ZqajZBWmI4Y3B2ZkVvYVVxeFVZZ21UZUU3L2N4OW44NzBzN1czd3c1?=
 =?utf-8?B?MDcwQys0ZnhUb3JuNG5LYTJ1R3c4ZGJYYjRzaDd4ZFBVL2dmUGlOUkM3VDE2?=
 =?utf-8?B?bVI3S1RQcXIzMlRhOXZXNWF4bE9kcjRkditCV2Q5WWlnUWJFYnZUZUhlV3hk?=
 =?utf-8?B?T2lPK0h0VWt1aWtzd01najZzSkpWbnp4bmJCdWwwVHA5R3FZNDZ6TEpycjNw?=
 =?utf-8?B?U3BCTTUwTzlSNnBWRVRhdUdva1hUSVJka0k5T1dYbDVBcUN1aWhBOXdIZVN0?=
 =?utf-8?B?WkNHYUIvRmU5VHpjMFhoK2VlY1NKOCtXcDJMYmZNZHpXTmVxT0QxcTFWTER0?=
 =?utf-8?B?UkNtWTdrUlRqU3pSQThwbkZhNG85dHpVSElzUXRiNjBldUlLMFJWaFhUY2Qw?=
 =?utf-8?B?THY1QWVQcExhaDJPdGR0K3dtcERacmxOaVkyOG0zaVR5czhjaWQyTTFyNUNB?=
 =?utf-8?B?dXlkY2RtL3BTUDMzVGVZaitHVE9MUEdYRnNtL3pwd1UzUFZKK3dUc3BwejZu?=
 =?utf-8?B?MEdUSzlzMCtXWko1UzNwd2tmU2k3SVY5OEhjTm56d01JQWs4U2s5YU1ScG8y?=
 =?utf-8?B?ZUIySWcxTUw3MldLb2dmTTRadUUwblJDWlN6KzRVNmpURmJ5MEFjVURlMk1r?=
 =?utf-8?B?cS9XQmpHNlFDTXRWYW1DR0g4d1RTajYxK3pYYmNJUEx5eHJGQUVnYkZ6OVRY?=
 =?utf-8?B?eTdmRTA1Qk9YSittRGF4TmtJYU43N0g3a3NmY3VkbWVZUDBORmlFeVVUSkxB?=
 =?utf-8?B?TnFjdDB3cmFhdURkd1NaRmlaNlg0K0ROcG5sVmNoaFo5QmF1Qk1WMG1zMGZ4?=
 =?utf-8?B?ZnVsOTc5ZVNZSmhNSnpQOG9KOE9McGcvWFdIb2tVUVlUVFRJMkdNR2hWL1JD?=
 =?utf-8?B?VEtDb0pSZGg0SUFReWx2M0thZnRlZ1dzSWdjdmF0TC80RnAwSnJSajRoRUMz?=
 =?utf-8?B?TjVvTVlPRWdKY3Z6QUFrYmhDdm4xenlDZFZJMURGSWxDQ0gxK00ybWxFMnJr?=
 =?utf-8?B?d3lMQnpwODlhUkRsbVZWR3g1ZTFsK2Yxd2thaWMxL1VYOGh4WlNvN2JOUWFs?=
 =?utf-8?B?UWw5WWs4RzRuOVVXMStTdm02dHdZOTRpcEJCd3B3STNReFA1b1dGRlpDZFRi?=
 =?utf-8?Q?/EfqY7hXi1cEkJc3vnKqITy2iunnSElZ5TK+oNL?=
X-OriginatorOrg: t2data.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e70fbef-e62a-4eeb-5310-08d8d7d53c4e
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB2858.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 08:30:11.3896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 27928da5-aacd-4ba1-9566-c748a6863e6c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MzkFAa81G5XF2nHWQJ57t9nU78IsLbwsbAAm0ggDDHVDC/GGlQ4+VYkmyxvTY+9zBqJWdTSUENtL1dfRFCpHSKIe8dWYCXq08DIcqns1Wyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0602MB3323
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following a similar reinstate for the KSZ9031.

Older kernels would use the genphy_soft_reset if the PHY did not 
implement a .soft_reset.

Bluntly removing that default may expose a lot of situations where 
various PHYs/board implementations won't recover on various changes.
Like with tgus implementation during a 4.9.x to 5.4.x LTS transition.
I think it's a good thing to remove unwanted soft resets but wonder if 
it did open a can of worms?

Atleast this fixes one iMX6 FEC/RMII/8081 combo.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Signed-off-by: Christian Melki <christian.melki@t2data.com>
---
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 7ec6f70d6a82..a14a00328fa3 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1303,6 +1303,7 @@ static struct phy_driver ksphy_driver[] = {
  	.driver_data	= &ksz8081_type,
  	.probe		= kszphy_probe,
  	.config_init	= ksz8081_config_init,
+	.soft_reset	= genphy_soft_reset,
  	.config_intr	= kszphy_config_intr,
  	.handle_interrupt = kszphy_handle_interrupt,
  	.get_sset_count = kszphy_get_sset_count,
--
