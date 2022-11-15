Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C012862AE8B
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 23:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbiKOWrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 17:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbiKOWrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 17:47:05 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2072.outbound.protection.outlook.com [40.107.103.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A641F623;
        Tue, 15 Nov 2022 14:47:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmgGRuOwO0Q8LLHgGpsgmnewRg++egMLw53PUV7NrWaBnqv6azzlsPqUzwj39LBOMlVVPu0GlS3iQEHmG+C3lJ8kB7krqrFUHl1LSWSojmVGDBWERTVjgrrjiOdrNEb47fin9FV7eRqVBXJtOeO8XJJNuuJWa/3PQTb5WJxn0oZDiz5N6jGwiCyOuxHlm40vfHY137xFjgY4FcBHgI4OUoki0Bqb7FM5HnBy1E9derKmXgBP4i/3z8rjH7H6kjel4peKx72lp0QredmzLDYXj7P0LSHbKUE5Px4HlMoZA/Rd9sNyGbR8tp1lNHhP4j78GbQXFtCJ8VfrarUGac6Ung==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIJCjUYikoZnaJUmD/oS23+7ZFraEHzOXYDBWrNhn6M=;
 b=fXwNPaphJ4bWOGSc+hltnDo+ow/0N08g4CZeKwq1rgvCbF6iEbwgU8zwG22Gas8Gf9wrAmSOMhICflHcMXvi7zbIWcLvZ+FVR80O+9EldWSLFc4rn0b9twHVnlsIvMR5bycj1LcQGkgAbnAZmupWfsxYJ5XOKoN7sYIs5lelIKMZUDNSDHe4dzeFoJAnR12AdBuo67sQ/pjGBz4pkT9foZFJKTgHryEl3rWDZWb9LooV25+Dmhc8qxdDPz461BQH8ZzLcZMGdTqIIhLUnHbBz2wz7otAuLuCChmVGRt8XT6orfI8uojJr8fW8o0ZnuXVdOw+MOdofreHAX7Y+5lzxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lIJCjUYikoZnaJUmD/oS23+7ZFraEHzOXYDBWrNhn6M=;
 b=eXqopvpXkyzx7xLwTsN56IlHL0p/5BaCVrbNraupZcOVvCjM9uPV9Z/34rc0+00lq/VwuqEOpVnw1UrCMrHR7kVEUiYMg7R9ZNT7IXz7mzko7ryiNcCzpe8TC0ttAJ++7ozChH/INd7kNIjU+Zgfe6TujRTx0kGtRhBHeRgepCxrvIi9jHq+o+J/48icNQ8rlYrhg6ur5Vpw5N9XJ7LcoCN8D6DH3mnlhNrUfuQGfCx6TXndKCpnEMN3yX5xsJz5WRt1AMMajldf2BLiNoMCrUukaa6f1DYp3a9yQejMrsW+FmvXhHlbF9K29D0IpX2+yURSMZ/NQOUPRfr0FX0z2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS2PR03MB9347.eurprd03.prod.outlook.com (2603:10a6:20b:579::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 22:46:59 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 22:46:59 +0000
Message-ID: <3771f5be-3deb-06f9-d0a0-c3139d098bf0@seco.com>
Date:   Tue, 15 Nov 2022 17:46:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] phy: aquantia: Configure SERDES mode by default
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221115223732.ctvzjbpeaxulnm5l@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221115223732.ctvzjbpeaxulnm5l@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:208:fc::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS2PR03MB9347:EE_
X-MS-Office365-Filtering-Correlation-Id: df95cb65-bc6a-4ed8-b263-08dac75b4dc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3EIYibbVWY9/yujQOev/0Ba31hyWK2CJqyVKAaRZuJk1YriaHxWWGTeEKWVPcmyDnJcwmTw1v1JWh+yrqB2Lu1ZZGsJT7zVFGqU2sXu1c40nZAaoKfMJWKnPHZrG3oUiOlHXk93c5WxEr/FItMFXJJ8GP15MPgNTQ54NsKcU3C5SSNbmE496zFSQ6buOP0AeJE8Y/2WrAjy/kVHz4JaYgRsVwcIf5Lhecyv1O94EcPYGrWNASuyAOGxdU8yUxfUB034otZ3T95h4g1Myiw4Y2vZ+97p3ROIZ/uyXhad+DPaF/wSY7wrvh2tkMcct58kS5IiAzIorVcF2UCpfSQ/6aFU4w49nu1Ox+ELa4ACQGTAJRi1FnE2KvIIky8IyZTQK/LNPcNolJObVh6b+zNijWPvnYTTKHWWkdJMb2/MjGtu9g2W3C2hWju6HM1qw1llnoIoc2HlvaCU0d9S7A5QSXLlwZpSq+gLLxG0ZCfzzYwWk37EoNtoOHX4u1M7+nSNsb33XwLYRTWqR3a9OyFT5+ICqUFlmioEhXvZ56OG0Hp6Pqw83phK1Z3vC6Nmkev13S3WuJ9JP/sKY9GUs26H6Ovoy9GlF4jT9Zs7yLtLIt/+vg0ODPjEcR0YOZS9RWRukSNmqj+eYdW+k+QoYQM+nKLB9hFdTBOTAylYq2GAydKMA0DvOR509zcbOvHREQmFzuuy8zWzr3bs7q20b+0IXwYeFz8gqamyLIJXzJGCc0caT8QtFujA8wLKRkMcyHPMOe05iG32k9yeU/4oNYuf+7eY7Gx8pwraEDdKh5wv8KsKvjr5C8CPvsSxYzL1Wv4FM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(396003)(366004)(39850400004)(451199015)(478600001)(6666004)(6916009)(54906003)(83380400001)(31686004)(6486002)(8676002)(66476007)(4326008)(66946007)(53546011)(66556008)(41300700001)(86362001)(6512007)(38100700002)(6506007)(8936002)(2616005)(186003)(52116002)(5660300002)(316002)(36756003)(26005)(7416002)(44832011)(2906002)(31696002)(38350700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2dyZk5CNGZ0WWgyRk4veldidmlDWU9Jcjl6SVdab0hiSE9WdytEbXBiejZQ?=
 =?utf-8?B?MzdYWnZENjBZeFE4dTBVUWFURDR5L0liSXE0NVJweUtvYzVTSWJZYVM5a3N6?=
 =?utf-8?B?UWpobmxXRkZYQ2l1T3M3OVd0TEJ0VFFoU1dnWGRrc0lhVDlyZVgzTTAvZWIr?=
 =?utf-8?B?eEFIQkN3MnBUUHBOVXhrcVlkOFhhSllYT3kwMG9iQXdPRUc5TjJXYmZJc1oy?=
 =?utf-8?B?MCtndGZTejdZQmlRL2xSZFcrNTVRWFVlTmUxYnFJMTBtZisvQkR2RDc5SzZp?=
 =?utf-8?B?Y2R2V3BQM3pHNWUwbVpCVjdQUWRNQVlRSVZYT0thL29TRzNNM3hjWjNJcG14?=
 =?utf-8?B?UzJrK3JTblhaeHo0WkwzZ3J5aEhWaXlDa0JSZWxSbjRUNGZHOExpNE8yL0U5?=
 =?utf-8?B?bUhabWVYMS9HMkhOZGtWVVh3ZCtMbzlESHVUckdzSGUrRWZxWUhOQ1liYlFp?=
 =?utf-8?B?T2JzMzlRQjh4aDNsNFpSeDM2LzZ0djNNcjRhOTVkR0tJOUh3VTlrdFFqekFm?=
 =?utf-8?B?ejJ4YVRSSnpjVHZ0a1V0Y2xmMHBGc3hYd0l0TW1HbE5rZnVJTGg3SjRUem92?=
 =?utf-8?B?TC9JMVByeTFiWkJLL2RudktMaG8zVGQ4TnBmRjZOcUJaWmZzcjJBdUlaUjdH?=
 =?utf-8?B?N2d6QlQxUktvOVZWRzNBT2FkNEhVSUVDeUxuemJpLzlqYWlRY3dvaG1hT1Nz?=
 =?utf-8?B?T29kMzBRK3JuT1ZGVVlaNEE1OU9vbTFRVVVVOGVRM040bThsNUVNUTVyajZs?=
 =?utf-8?B?d2s1SEQ5bDFqOXlDRGNkOWdWNlhzZ2NGV3FucVJEM215YlNtZHExWkNGbFE2?=
 =?utf-8?B?OS9SZUZiL0hiZGtjQ2hmSHhONW5TdlFOaTQrMVZrUUNHMWRPeHRBUWlSTEhh?=
 =?utf-8?B?SmFQOTNKLzl2d2hYaVRWVHk1OUk5WjZYRDBidVFvKzNtOUVjWitCN01XRlJx?=
 =?utf-8?B?MVhhZldZd0kyclZpSk5ka2JFL0NFUCtGenluRFVPTTdCdGlqMittdE9NMTBo?=
 =?utf-8?B?anUwN2RkRVpoK2Z6bXdNR2k3WjU2STgvUjBaWkVUSjNoTHZIUWM2amQzckZN?=
 =?utf-8?B?UEpMU29PclZkVm1XZEpLeDQwQlBZRWlYUjdES0ZrakpNSDR1OTdJWTAzdUJZ?=
 =?utf-8?B?ZTVTc0FseTIwaTBjMGZLdEwwWUpnV2hidHNYQVhzT2JoUmtyeTQ1R2krMk1z?=
 =?utf-8?B?c1Vqd1pJVlhSQ0xRNTFKdjZLWENNZmlTREE0WTNxMjJXY2pTN1dtRENxUFcw?=
 =?utf-8?B?dG1DeUxuTHc0VlY1bC9ob0pZZ1dDa0U1U1NUMDBkMmtUOVNOckRRWklBRnpt?=
 =?utf-8?B?TlRtbEhOZmhYRXNXOFRLSDR5alRxQTBkWTBJSHdlY21nN3VsTXE0eDAwT1pO?=
 =?utf-8?B?eUowQUl0dXJZNTRhN05QYmgrbi95a2JQN3dReTZQQmhWb3NjQ1R0NmcyVlIz?=
 =?utf-8?B?V0g0eHRPVC9paHBQTDdDZEFNaHFiWW8yblF3bEF1QTd6MEdwVU94T1NCbWcv?=
 =?utf-8?B?cUFuL1VlR2Fyamc0ZlM4MldxeVdGdUZRWGorSGJSMFdWVWlvVktwZXpodWVj?=
 =?utf-8?B?SkJRaUlVdlYrVFQ1akJ6NFBFVy9uRStjL0RaOGxxR2huK0t6UGVNYUNxdlZX?=
 =?utf-8?B?Nlh1TjNiSFRNL1NveXE2dEs5UTc0MGUvWnI3aVNQTDBEZkkxcTg3MlQ4UmRB?=
 =?utf-8?B?RG8vRVZaVjdTZFp3MVFtRnBmMWNtWEFoMS9LZFJiWDhJRWJuTUpGb0FYMW9R?=
 =?utf-8?B?MXdrY3BJWm1zcHg0THRwVlIxbFFPS2NxU3ZVb1gxL04ram5qUVpxby81bm9o?=
 =?utf-8?B?eVUyNE1kVnppNU41OGxXTTFUNXhybE0xM3ZUeHJvdE4yT3FNLzVHWStYRFlM?=
 =?utf-8?B?bUQ0bmFublhzWlh4M0wwRmR5bmhsMnpXTEJBcUo0V3NrNHdPQUFhQW13dFJ1?=
 =?utf-8?B?NDd0cE9tZjIrem1CKy9MNmFpb0FVNUh4ZkM0YVVFVkpOQVltOHJmTmhENWhD?=
 =?utf-8?B?QkdXcGt5WG5OcDlpWGFzY3V1RUlDN29Famtqc0hNMWRibkRSWlBxUk1uTDlr?=
 =?utf-8?B?ZVdlcmVIVnZNeGZic3hPN25FcUZhem1NMTNwb3g0bmFOS3pneW1qYnRJMDFZ?=
 =?utf-8?B?eVp4LzRUdzVJVzFaajF4Qmx1SE85Tmd6ekFGVnU5TXB2WEp6Z3JIVWNtTTQw?=
 =?utf-8?B?K2c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df95cb65-bc6a-4ed8-b263-08dac75b4dc7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 22:46:58.9261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OKyS/l+26KbWmXhjIsw6QasQQZmh2sYFQNZBNhbRHWAFyMngDiLUyYn5p1Xy+IN4yVYpB6LXpvJJj6XTNsHRtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR03MB9347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/22 17:37, Vladimir Oltean wrote:
> On Mon, Nov 14, 2022 at 04:07:39PM -0500, Sean Anderson wrote:
>> When autonegotiation completes, the phy interface will be set based on
>> the global config register for that speed. If the SERDES mode is set to
>> something which the MAC does not support, then the link will not come
>> up. The register reference says that the SERDES mode should default to
>> XFI, but for some phys lower speeds default to XFI/2 (5G XFI). To ensure
>> the link comes up correctly, configure the SERDES mode.
>> 
>> We use the same configuration for all interfaces. We don't advertise
>> any speeds faster than the interface mode, so they won't be selected.
>> We default to pause-based rate adaptation, but enable USXGMII rate
>> adaptation for USXGMII. I'm not sure if this is correct for
>> SGMII; it might need USXGMII adaptation instead.
>> 
>> This effectively disables switching interface mode depending on the
>> speed, in favor of using rate adaptation. If this is not desired, we
>> would need some kind of API to configure things.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
> 
> Was this patch tested and confirmed to do something sane on any platform
> at all?

This was mainly intended for Tim to test and see if it fixed his problem.

--Sean
