Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4315B0AB1
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiIGQzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiIGQzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:55:32 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613194C62D;
        Wed,  7 Sep 2022 09:55:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diHnti9OcKSVf6cYl3c0KI5OQEzDzWaHhDeT/7KpQu+jxRx11MyOljqw9yug+viwjCHhc7++V7hNI4kyGZUD7Xe0sJiaE+vmJWHVYlDhx3gzJpXBlw6Bn+ZV6/Bo8cNJB8wtiGdvkOGBOgXqVoaCSHr+77YVwrJKo7RbEV8s+/CUM/0fKhcWF29ed5asS5tJY6eUU1sQ7QKp2LDa8VUrSXalL4CkoQLKXTZ7JqZvcEX1n4h3lJamrqVecAQtfsnsSOAJC9dTu2hJjcXDrVKWSLjtp+3v1BftjpTzQqMKfv3bySwa2Hc2nveIOGU8ncJfQY63HQO9JwiIdEYxJ7HknQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K53fN9nH3sueZ5kpvsAuu9/13avB+PkrNo2ZO8rA1N4=;
 b=nz0/Jbkjv7aWfkPIT0ymVpZG6Bprtn3gwlQyP0/3QmwoUqzwlSQIQhoMi+zd2MCymYy4NBjXgSsWMjI0iNyfKVaNUANxtiHc3Ev9tfm40uGo/Oy6NA72TouPdXLZ55f1iafN9uDc62HWE5+8+jjd1pExnqXbkhwk4ZGXLAE5gcMVVqrmqDsrn+hBt3aAB9XcJx+gmu0FYzjTOXf3ks6a4u5jBS1L5lyCPw4T+SlCkDdeimXRT1Is5Yp4RDWo9Ydb8WKXsP3pVullkeWXpa39aSHMX7a4zjEdwD0Bhhb/7/WODivuv9zyFX7qhuihSZ227Gy4ea1PaPui1drMimiZRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K53fN9nH3sueZ5kpvsAuu9/13avB+PkrNo2ZO8rA1N4=;
 b=u4M13U3+Z9JCt9dKuzK9ED8Ze4JUFvFxxphO7wka71H5Ey1b9bMjP5r9rpvYHXWXcNSAYK5yCXdJ85Lb9AG6rSRBDYhtln1NSQB2eAVFuwmincr48cGpcCFRNY3mc4TfeAVO9QAPEY+t4zBbYPE7Ze3enqiGeS6uvXjOlhe639wvT3ZPa64Vnk3CUQBCvOK5hGsur91Mu7qPVCtWMScTKS7H9LAjU64rFpFZPfs/0ZV+By8MGHmtdg+BcNY7y2/yY1wJWPhWGzr9ay8jQysCAXckW/9hiYfAKiJ04zYIzo1FbW7tng66+XPtGLHGKEsO8EMD2SL7jbmTnfs64OBXCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM0PR03MB3841.eurprd03.prod.outlook.com (2603:10a6:208:6e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Wed, 7 Sep
 2022 16:55:28 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 16:55:28 +0000
Subject: Re: [PATCH net-next v5 3/8] net: phylink: Generate caps and convert
 to linkmodes separately
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
 <20220906161852.1538270-4-sean.anderson@seco.com>
 <YxhnaqCfKMKm5zFy@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <2e258a31-4ca1-c757-cbe1-cb352015ba96@seco.com>
Date:   Wed, 7 Sep 2022 12:55:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <YxhnaqCfKMKm5zFy@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0049.namprd03.prod.outlook.com
 (2603:10b6:208:32d::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba7720a9-d724-4d82-282e-08da90f1c48f
X-MS-TrafficTypeDiagnostic: AM0PR03MB3841:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q4tXNtuQrLR8uXt46gWM+AH8VFpVWPKH586OSKPsiS4ynOv4CFedCaUW5/YRIGObEJQpA3g9eZEumj62jFd96cZ2eOLAE4OhdJQclThsAnJEnxPoq0iuGMFaL6Wxk0w5cUyg1NA7I0soBgQbRzWPLlUJkTS+L/gHvV1WTB+gA7hc5wprirFY4p8Lyt3zHY2+bNIwJtG67x5KjixFTjEEoUcu0JGdmOvhXoOOav9Iv7JjITQQMjyza9VoXzwW1KWjljEOONsSY5BYqq+4KNn3bALN2bhQvRnb1N3aep3NwZXOsbKnv+Z8YrqMOLuHGomJCoM+lz3pXjO8GP8pue1wK34mBiJs0zPjp3y9mICiVHNRFjiIByz9LqE/SSp7TjwzzhNqzjm5yOzTd3Z9grjlWHjWpI0t4/TKTpRHvrXP746+/CwMLfliYSn6KSgmTYyAdIoVHOBYSqdmQVdDHZbH/eUKvNftA7rgGIEWag3bwxFtB1iZcfcX6dykM5l1xbQMLkDqw+vCcqeCSTV0ruVK304d0HzbtgEN+RCM6JR+6H4WXqsVw8G+usgbvQl11japnSqrkcmDABQe0k78n75030+sKgZeLjOwNHxt0rqzmfTXQvmZDZO9N/JoKTiKdQBxACzcG9Jy02MYjvV8Rla7Cu3X/y55IR+G5seOVlrXG6XQtIFyem36k3vmCUpyGwd8asdTlvp7d+YOhfdi78ZBQ/QT9p5CaS8prwKUcfamqfK03pyX7ukJ8g9IqtAHuMfNJh3vc3iLY4Hnb5YsoR0RfxwhLVBY7MTeIVFRF7koOSUUDDiNcbpGuJ4ljNCTm6ZNrO2J0cZ0engmJn5gQdMTVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(396003)(39850400004)(136003)(366004)(2616005)(8936002)(5660300002)(7416002)(186003)(44832011)(2906002)(4744005)(53546011)(52116002)(6506007)(6512007)(26005)(31696002)(6666004)(86362001)(36756003)(41300700001)(31686004)(478600001)(83380400001)(6486002)(4326008)(8676002)(66476007)(66556008)(316002)(6916009)(54906003)(66946007)(38350700002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NE5adnN6WVNYTWJ1aTQwSENmZWp2Q2JJWUtEZHJZS3ZtRlFOZzVlYThESHVC?=
 =?utf-8?B?UWw3VlJFTURHcTlEckhTMTRLRVh4bU8zRkx6YU5HTWMxZU00NXlRaTlyemtB?=
 =?utf-8?B?b21TQU0xZ2ZPaWpUb09XaWN5UTZuOERyRkg1K3ZiV3IvUms0ZFc4aU9UVExF?=
 =?utf-8?B?R3ZoZkZtYU5FTHoxdHZid1BoR1MxMlFhSysxVk1uM1pvRm1aVUxxelVwUGVN?=
 =?utf-8?B?L0d3eGJXR2xUUXduNy94M1ZCaGdSZE9LZGtzTFU5UWloYVNrV2h5NEtSZUth?=
 =?utf-8?B?YVVZQ2V3ZGdaSktKdzhXTjN6WjI3a2dLUmx4YUlJVGtKTUxBM0xYUHZHRm9N?=
 =?utf-8?B?U3RlcEtwZ0FkN29LTmxoU25zK25EMmJJSUx6dXB6cHhpZUN2RHY3d1R3TVZt?=
 =?utf-8?B?VjNobUwwdmpKMjdOSDVFSG81VkhZaVhxWWpJUFhTNmNHN0ZDNTh4Q1k1MDhw?=
 =?utf-8?B?WktyMFZlYlhUbnVsVU9xSEFDQ2pXUWF0NHdEMXpLaUhUaUZXRWZRa1h5ZmVi?=
 =?utf-8?B?aDlPTFVubGFoY0l5QnR4UlQ0c1pHN2ZUbklTampKSWxMUloxbzRtU01hR0Ir?=
 =?utf-8?B?R0FvMS9wTjUrcktjdm5CcGFnUFdVNHVabjRlUWNwdEVDNVFYR2xRZHVTWjdV?=
 =?utf-8?B?RERVbmYzbEhKbUEzcFdaRk05aEIvdnkvUkV2MjhQOGc0MndLVUo5ZkV4emFH?=
 =?utf-8?B?WTRreE52amVXcFNVQnpDQnYyWDF1M2pvQVh0OTFBYzZ2T2xra1ZwWk1KSklC?=
 =?utf-8?B?WDRNdjdYRkNWSDNHVDZKRGFIWlBTRW10a05NcjYrbGJOWGd0N1IwMVdBMU90?=
 =?utf-8?B?Ymg4N2Q4dkVweGhkbE1ZLzBLTmc3amNGc1ZYcVV3TXJGUUxmajFsQi9CT0x1?=
 =?utf-8?B?WXd5Vk9MMSt5bkJSZ3NTeG1Xb0tJU2p4Q1JYZFV1QVZQN1VrLzBOT3BRV0Fw?=
 =?utf-8?B?UzBEc1lLWGo2SEFneFhCc2FNQzVid2hLU2RrU3NrMmxMMkl0SGFlRERVbVNU?=
 =?utf-8?B?WFd1ZkhmUXk5T0w2ZmVNN0dkcytkVXR1bUlhL2NuWWRYSG5uR250bVJvQXJ1?=
 =?utf-8?B?eVF3V1BLRHIvV25yZW1qbVZpakptR0NQY0R3eWM3K0xRK3g4NzNydFNRSnZL?=
 =?utf-8?B?TU1IbkNCVzdRYU0yOHlUNTU5WVIzekRUQmxxekpJRnRzNUEzVW9PVUUzOWJq?=
 =?utf-8?B?Um5Hc2RuMVVwZUpXazgvbUZiQ29WMFU2blRpcHgyR0ZpWFlhK1dNK1RmVE94?=
 =?utf-8?B?eVpFcEtRelhkbGhNZUVUYm44ZW9WUDE0N1dBZnRGRWNsWTl1cEVvcXZuVXIy?=
 =?utf-8?B?WmJiZGhaUS9VRml1YkdLeStWUDZxNnQyWFZhSkhwRDRNS3kvVEJEWGJqNFpK?=
 =?utf-8?B?RDRvcW40WjZReDZVWmV5bEQ2TWF5SXZyNVdvN0NFc256RXhLanNUb3ZpcWRl?=
 =?utf-8?B?c1pzWjdWSHhVWVJ0dklnd0xhT0hETVM4MWV2c2FsK2taRHdTYnBnWUxMSzh3?=
 =?utf-8?B?NCtibUdpYTBrejloSmxNeWhsbjdiYUNKRUdmSll5dzJYc2k5OTI5TzI5T0Vy?=
 =?utf-8?B?U1kzOWhmajJoSzlIRHdVUndEY3VjbGlOL0wzRXZkb25IcVNkWlRZR3NMV3dw?=
 =?utf-8?B?VGtrNmdybFdsRVdDeS9qTEFqbXBObnFsRkJScmk1QVN5WEIrU1pNb3Raa0Jm?=
 =?utf-8?B?L2E5NVN6QmI0dnJpRmIwdURxYU84eUxRYmtJSUxXUVNUcmpTZGR1blNweVFi?=
 =?utf-8?B?MHlNYlZuOEdlTm13NEUyY2RFbE02Nmdvbk9vb1pycHVKaU0rWmFvaEozajFl?=
 =?utf-8?B?MTA0UEl3VEd1aWdwMjJ2aE1hKytwdGFUVXdPc05PVnIzRW84enJvQzgySDJL?=
 =?utf-8?B?MmMzdGFXNmFWYzNXU2pHeWJLYlFhTjQvbkFIVWg0YVNFT2dVNWlCY3ViWTRr?=
 =?utf-8?B?NHd4RDhqTzJCU0JWVHY1bS9XdUliTGhsRHBMeHBkWmJRZXFDTW5sY2ZZamNx?=
 =?utf-8?B?LzlrVlZkNWIrS0Rxdjh0aWQxYjRrbkZ4cUczWGI2WFJUQW5YaFIxMDdybWNr?=
 =?utf-8?B?UnB3dHA2QlBMM25YVkVEQ1V5Q2k1cko4SDNMY0NSaFVkcC9NS1dZSFN2THp4?=
 =?utf-8?Q?qrLNg18GLKVMBguI8vYKOurFG?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7720a9-d724-4d82-282e-08da90f1c48f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 16:55:28.7455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7DA6d1h3RkLG7eflbOcCCPUVaMX5TKhjwAw9OCUxfq0M29d0L6M/DTUNNQ6ZOb2/0FqhSUuHc5hQT5Lynf6r2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB3841
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/22 5:42 AM, Russell King (Oracle) wrote:
> On Tue, Sep 06, 2022 at 12:18:47PM -0400, Sean Anderson wrote:
>> @@ -409,11 +407,14 @@ void phylink_generic_validate(struct phylink_config *config,
>>   			      unsigned long *supported,
>>   			      struct phylink_link_state *state)
>>   {
>> +	unsigned long caps;
>>   	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> 
> net code requires reverse christmas tree for variable declarations.
> 

OK
