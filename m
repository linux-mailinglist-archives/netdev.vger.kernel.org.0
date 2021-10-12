Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731F242A93C
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhJLQUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:20:46 -0400
Received: from mail-eopbgr30060.outbound.protection.outlook.com ([40.107.3.60]:22599
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229510AbhJLQUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:20:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SI3EoGepvv10JgRTWOHBYfQ0f29YIw1J87php4OVmLuT7bepPJr+Nq/9M5Sc/TlaGXoFq6rfP26MjxgFmezDDaw7CQD066nOV/I8g5ucijYR10+b51BvDT7f3BeZDehR9d6i0G399DSBSyx6dcyTf+ugXhktkkm+KxqCJ8qvleIVEMpm/y0mQ1z0tsTc98PJNh/PzjQJxlY9VsFMyGlmyEi0SEeXkKAArL0UX6tPnHKes352J0LFKjpjvXTkqs+6XbKALbVLF59+00t7LchxJe1uwN4731kMS1gp4GOx83oLKuEIBGkODbNutikTHcb1U5Rd2k0P2tV4UGH3FKA6eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tqQY/xuGZVhfhv0Uim74kNGU6BfRlh3oL+pvIiJ2Ols=;
 b=mmF06/vGLLHqwBGS+RJWQ06wDH78ha+qTt5e8PejRHpaxSAT9Ud9J3bI+v6YtwY7oAOJi9rV7aFp+RYPcbRbc7eeROnBVVyj1qswhr8QAMyidRIO+qBjU8Th4aUqutHgEALTgjaGTn5apa7FmxMhL5FH7AWZ3MriGXM0z6H+l4ACH1yT3wHDt00Zh9ilOXDnqP5v5Y/EwW8JeYL/4CHK9wwYYBiCwtvejyQjucSZsoaoUVSzYa4RhfcsuN5NfhNPQYhVaYxweDYGaC9C2SA8bgEwnRl4+BS9m0RQ9vRDiN4LDxtqZ+jH9aAi3buyciCzA9pWGGlAy28PupnU4bWtXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqQY/xuGZVhfhv0Uim74kNGU6BfRlh3oL+pvIiJ2Ols=;
 b=H5pREq2xqP6+SSfeeQejR0oAnKMNw56iBOZd/nDTMVlF27n90AI514Bjo7mDfbEHhsdQ6yNj2wt9y+KVBdEq89meDiYMU+99lR+6A4VXpxgQPz1srb8M2+4nbBMbOR7dmPSK12fdvJpDo4oEdP8diOxsa0Y/AqQE6ENeWh1oQMo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7243.eurprd03.prod.outlook.com (2603:10a6:10:220::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 16:18:42 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 16:18:42 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC net-next PATCH 01/16] dt-bindings: net: Add pcs property
To:     Rob Herring <robh@kernel.org>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        devicetree@vger.kernel.org
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-2-sean.anderson@seco.com>
 <YVwdWIJiV1nkJ4A3@shell.armlinux.org.uk>
 <YWWKuhn4FfgbcqO/@robh.at.kernel.org>
Message-ID: <2e5ebf4e-bc97-1b8b-02e2-fe455aa1c100@seco.com>
Date:   Tue, 12 Oct 2021 12:18:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YWWKuhn4FfgbcqO/@robh.at.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0018.namprd16.prod.outlook.com
 (2603:10b6:208:134::31) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR16CA0018.namprd16.prod.outlook.com (2603:10b6:208:134::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20 via Frontend Transport; Tue, 12 Oct 2021 16:18:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cddf713-d576-4d19-583b-08d98d9bf4ef
X-MS-TrafficTypeDiagnostic: DB9PR03MB7243:
X-Microsoft-Antispam-PRVS: <DB9PR03MB7243187C7C7EBB29009D60EC96B69@DB9PR03MB7243.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WxwV5H8MBismDEm2xhlcJ/BBN22vsoI7Klp1GrTzYnay7Sb/RqNYLUJNBdSa0/9zc1+lwJ2Fy53MD1U+9wnIIJTWLAmB2QBLQ5JA9GW3y0HsqEtU1BS43v2nta1yCHUs5rtRDxTpEL8ndGt6twN1Bhl/Jv68pqiOD4ms/B72rSyQr9FvrKfuVJTcWhssi4CQvzxhrZw5FTPkoE54swB3GYnn2gurr0pIPF6Hbcq7SoWd8scVd8T+NFT4+Wki/RGGqvN9aa+lMF3nO5+UU9rPbXJ2VQn3jz7iDrGgWOYC5pxmXsDL0lF9jQ4HQHr+RJtu7J5l8yujCou9ZTPCCvGeacZPdiQnGIplfjbM2PGARQgyuFWixFoYpipFese1QQ5eA/sEq78tMC+lrLzu3k/OygwyCpSC67z5ADRmZP4ABLrW931E1RJu3Htb18DreI7ZKLv0qQvA3KktICK1A7bpXz/Es2vtJROYdGOAAMmXbM2NHF5lbA0AB5R/3Nj3vGyPIrTCoyIjcGfbUBzfHmzkdsubDuoCyMUDXvaaQtXECUDlzmmFe77eAr0huUQnmxVfySSJH0EBfGrvNhy2i9tr+FayPUFjAVgXK9UrPz55luAd2AfMA+EsuB5QYWM1y3USmm+ZuGuhzzBRSJTL8GUsacXza3jKTu2aAMrxmrOz6Kied8CzwZDym+zo6kUeULbQ5Y5ughp4I6Jjztgr9Cm6Tfp4dB5KgVwakK9IVvrqFlaUalfVFwQv0rxMDRC+iXGgPQf+5DoHeGHYVUJ8VBu7Cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(8936002)(956004)(66946007)(31696002)(110136005)(86362001)(6486002)(2616005)(66556008)(4326008)(66476007)(83380400001)(54906003)(316002)(508600001)(5660300002)(26005)(36756003)(31686004)(6666004)(16576012)(8676002)(38350700002)(38100700002)(53546011)(186003)(52116002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTMveWI0QklXTVJwQWxta21DQyt2ZFVQSUdoQ29zNG9NaHFHQ2dERUJMaVV0?=
 =?utf-8?B?bHFRL0JJZWh6dEJBemZTODY3R2hCQnlvZTJ2cUVkUVZpVkd3NmQrcVR0QnVJ?=
 =?utf-8?B?OVFkbFhma0ZSMDFzdGVhcFQxN0NVYmw2ME1tZGNpTHFQYllXb0dyZGFsSU9J?=
 =?utf-8?B?UWlPcEtqcXVxZUhrMkY2YUt5Skp5a3FHUXhKcTJqb0pTaVR0Y0VhY3JkR0RQ?=
 =?utf-8?B?NGFCU0JPeUJ0STFFK0c2SnpYakFZZmV1WVQzdHc5OTVNSmYrK3BpejFSZ3NH?=
 =?utf-8?B?b0t1Y29FM21iVjdEaXBDblZmV0hrdE5QeXlaSkhXK0QzWGtFVTVEb0lxOHNX?=
 =?utf-8?B?V2NYNC9vei9OdGhuNmtmTHJlQnlWQkVDak9FRVREMXVtMkpiUC9Ra2tEM3No?=
 =?utf-8?B?YnY3cytDbnJyTGhaVzBLZ0lLbTEyQ3hzWWRhU1JsdnhuWEhZWDR4NkkzN1BK?=
 =?utf-8?B?aG83bEg4WkN5Szg4ejVxL0tyNytVcFRhN204aEkzM01LL3c3d0NOQnhRS05w?=
 =?utf-8?B?R0trdzRXNG1iV0tNak0vVmVPMWVrRkhhdjMyZHczZkJHVXhFaFBTV0F4Umd5?=
 =?utf-8?B?YS9WYXF1M1FLSW9rZEh0R3RmcVRKSVdIQ1RjdWFHREEzaDZjOVFWaGdsWXor?=
 =?utf-8?B?NTRHMUppZGlOM004ZVFqMloxT0hsUjlyVzVwMzBmQmtxYzQrdkNLODUwV3Zv?=
 =?utf-8?B?NXVaSndQd1ZBcGtUaklVZnlmZEdBZG8yVEJNMFRJSk1Sai9sWTZNVDQvQU9n?=
 =?utf-8?B?N3BBOFZ3WWpoa1cxVEZrOFhpVHpjUFN1WUtMVDJnY2RjTU9nUzdpVHZKS0xW?=
 =?utf-8?B?Rit2emhmQ1JXMkpEUHpVRE5BYzZjMWxWRUV0Rmp4OWRkdkNWdEtLNGgyOFIx?=
 =?utf-8?B?d0lYYmZCMjM2UzMrV2h1Y0loRGZJQkVFcGIzcFFpTm8vaVU5OFFReWM2WVlH?=
 =?utf-8?B?bjl0SlJRTW9XK2RsRHJWN2lVbjNRQVZCRHdHK2VKMWdmaU11S3R6VjdyQlJ1?=
 =?utf-8?B?L3FtRnpKYXAwMTFWUlp5eEtlWFpoUHhPQjA0M3RueURhbS9tR210d3ZPM3U4?=
 =?utf-8?B?WG0yWE41WWptbWd4alZZUCtpbW0zL0pPRmJCTlpPZXpHdXNza09CNGtOSHJW?=
 =?utf-8?B?bkNEaEdsQXh1N3VoRy9SYjJoc2FDT3d0S1lIWDQyV1dsMll6NFdVWGRKb3oz?=
 =?utf-8?B?Z3BEQmFUUHIwaWYzc0xBcW1POXFRWHIwQVF0czVYWDZSc3h2RWtLQTVXQ0Zx?=
 =?utf-8?B?ajNzWkhVQlhoZHBjZHNpUHFUVy9Ya1FpSytjWWlvS3Zxd0p5aGsra1REYWI5?=
 =?utf-8?B?TVV5ZUszVVZYQ3pRTFhvbW51OHNRRTJUeHlEdDQ1NE5KVVJraWhTaWp4U1E0?=
 =?utf-8?B?WS9Od3hSVjdPQ0V3T3MyUXNFMGtqeHB1K3gvM1JXalJQaW9uMFNyWU5idDlC?=
 =?utf-8?B?YnR5QytwNnpsUXJKU3BGeXlwVlozZXd6amhrWjE2Skg1UlJqbjZ4Y0NHTUdX?=
 =?utf-8?B?emUwNlRtRkRIaEFuR2MzeDN6V3hSZTRpUENiOGd0ODA4YlF6TzBTRkVETjli?=
 =?utf-8?B?LzF6dmhGbW5LYXNMV2M0d1NoemxLaHdlcmZtSlowWTZMaXcxaWtEVXd6emFC?=
 =?utf-8?B?VnFkNUp2TW1hT1d2azBhMkJwbkw0OHJjY2lQS3lSSmoxQWhwKzFvWllyNnNR?=
 =?utf-8?B?TUdZVWNLQVR1RzQ0dXpOdnF4amYwaEhpa1RNYzdzM1Z4V0w2R0ZIRXUrYzNO?=
 =?utf-8?Q?LvMmnsg9HLmHV283PP4deXQl7P87n23YZmiIm6J?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cddf713-d576-4d19-583b-08d98d9bf4ef
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 16:18:42.0018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ilwFpmjRArSR2eBOD/we7ufL1TFwV+Y854dyU1Rcp8HrTRXu+aKS+upUIXANrEr0X+yKfJ+BzKTnm4oFH65aOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7243
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 10/12/21 9:16 AM, Rob Herring wrote:
> On Tue, Oct 05, 2021 at 10:39:36AM +0100, Russell King (Oracle) wrote:
>> On Mon, Oct 04, 2021 at 03:15:12PM -0400, Sean Anderson wrote:
>> > Add a property for associating PCS devices with ethernet controllers.
>> > Because PCS has no generic analogue like PHY, I have left off the
>> > -handle suffix.
>>
>> For PHYs, we used to have phy and phy-device as property names, but the
>> modern name is "phy-handle". I think we should do the same here, so I
>> would suggest using "pcs-handle".
>
> On 1G and up ethernet, we have 2 PHYs. There's the external (typically)
> ethernet PHY which is what the above properties are for. Then there's
> the on-chip serdes PHY similar to SATA, PCIe, etc. which includes the
> PCS part. For this part, we should use the generic PHY binding. I think
> we already have bindings doing that.

In the 802.3 models, there are several components which convert between
the MII (from the MAC) and the MDI (the physical protocol on the wire).
These are the Physical Coding Sublayer (PCS), Physical Medium Attachment
(PMA) sublayer, and Physical Medium Dependent (PMD) sublayer. The PMD
converts between the physical layer signaling and the on-chip (or
on-board) signalling. The PMA performs clock recovery and converts the
serial data from the PMD into parallel data for the PCS. The PCS handles
autonegotiation, CSMA/CD, and conversion to the apripriate MII for
communicating with the MAC.

In the above model, generic serdes devices generally correspond to the
PMA/PMD sublayers. The PCS is generally a separate device, both
on the hardware and software level. It provides an ethernet-specific
layer on top of the more generic underlying encoding. For this reason,
the PCS should be modeled as its own device, which may then contain a
reference to the appropriate serdes.

The above model describes physical layers such as 1000BASE-X or
10GBASE-X where the PCS/PMA/PMD is the last layer before the physical
medium. In that case, the PCS could be modeled as a traditional PHY.
However, when using (e.g.) SGMII, it is common for the "MDI" to be
SGMII, and for another PHY to convert to 1000BASE-T. To model this
correctly, the PCS/PMA/PMD layer must be considered independently from
the PHY which will ultimately convert the MII to the MDI.

--Sean
