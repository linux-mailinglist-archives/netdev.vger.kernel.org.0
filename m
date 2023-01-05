Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1C965F405
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbjAES7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbjAES7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:59:36 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2082.outbound.protection.outlook.com [40.107.22.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802B35F908;
        Thu,  5 Jan 2023 10:59:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mlp01+0CT7ZbEKe6nuOFwVeZRkrkm4XGKYdvUchouAg0QZCMTl9lLFHkddCJyE+KTKg78hiae4QrCtpbxtVjCpS1fJDWsPhjCmFTpg2r7XgrLBiMcc3rHl7GFcB9nZmI/YgGPBPcIPyip4D887fMYztfvoscUcLI2xb3Whe8kJGapy82aQvAOqkDe/oFmfNSA2P1VbM3iCqug5O4qsUfVKARssku9mrWRqaqfDFbwfCxdSnPMFu8xqy7QAXHYut2XvGk+9guYfk0rEg+Duco4DyaubHrd/0r2EFzPeOg0QWYhpWopVRdoyUqJa2Jl2XDiHidlnAkj1maLooieB4V6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eR7aMp9FtcRRC1SfAIE5ghGF3aH42qx+VvItgUKByHU=;
 b=cbV+AsM62YJ6ZNanXPkBXkYuEAsmTf6Y4ife/ZZThS/YQxlp33rI1TT1+lZr/gixhuCE/nIkCWstWVXdFPOqanZ1JJh8U1Qhq6waRGRWM01gVymiEy8uVjR7QNEMIhNdihHjuXbrpXLsnjmq6nqQnUNuJoekdQl9aolK30Uu+B8AzvJHbJg8oa53bBbe6/1QwDSBIBrHEaI/CGGZ9YD5yHvljqDfQD8F1epM76X7+DdV8UHVD385weGnk6jWTTOv6lGkBTwK5zyFZCkJKQO5bs06VOWX6ykwQfvHC3hUhsrT2o/eoLa8KhAcrj21P4YwWYQkBCwxnk4w0WnX++nUsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eR7aMp9FtcRRC1SfAIE5ghGF3aH42qx+VvItgUKByHU=;
 b=w0nMD3D9ZIjsv958ekIyzWdbL220Ug+E8t+nrEFNRg7nnXTkwfY39JSHPu3DsneX4I7k35/gfiW0iztJi8uzlH0rdEg+FB+oPRz3gB6RRCM1uqItI/xubSiI1o0CxJHnqrpaYpnKG6Bka1PjHoCc4yRQat6HZGlRx5B9UbULLyo+jG4aYFrUL452iozfy1HAaR1n9c3lknwI7nXZTAKs8TksKl5IszK7yjmDZ2HTODULULSnvDnQSxs+JkMxJ87ePlyJgbgItdnxf+dsucW42fXrj26iLAkkLHQxURSBtSIAofl9c4MM/OZkyatFjlr2sE5uo+feoIVPPIYMZwZHRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AM9PR03MB7712.eurprd03.prod.outlook.com (2603:10a6:20b:3dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 18:59:31 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 18:59:31 +0000
Message-ID: <18453c4e-484d-5131-36fe-77d3e55d6ac7@seco.com>
Date:   Thu, 5 Jan 2023 13:59:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
 <3919acb9-04bb-0ca0-07b9-45e96c4dad10@seco.com>
 <20230105175206.h3nmvccnzml2xa5d@skbuf>
 <Y7cdMyxap2hdPTec@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <Y7cdMyxap2hdPTec@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::36) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AM9PR03MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: 17478831-6bd8-43c3-f1ee-08daef4efa75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d5iSYrx5sUGk9s0ThN9DigbuFRRcOKL5fNNGQ/5+c00zykZB31oIiWVSIuHXAd29RzGwDJBSxrKvCWgtxEAqzxsSQABLr3UPWUvGsBE4geUL+oQkv+v8w/qQ9wn52Z6sOaIxprQ/oupUCl2rRdAT+jzTckWU10+h91bGUP4ihAqIrpdoAT5jq4Zpwk+jV8tqgaqmT6J8+0151ohuq/fN2D4wXJYMhNb665q/NImJ4joKFGHsIJFVLv4DHHEQ5jEoaeO45DLlQ/tocQXh3g/o/BQIBkiruQDMyzdNpgrrSJvSfOOz1k4MLNT8B4x8Gi88aHHOfMe24ITGUTwUMENpP+XBTRqAjUBGVDhju5aLWuF7GOfTtmq5F0l1dU7GwxsNftXY32mXCXJ7w4L7FOB8hXvpq26tA4uJt9RutCOdXNVeGLTF6AOg+35QoLvY1PK+YH1sNdCbO6KZrJxiHBSDEj4veQcB95xG4p1xKjt+gqY6PO3NiPbZHgfFC4WIrIcNpIKp1sL+a/Omeui44lGlL2wDu1xXb0iIGsnxOJGW6Wud0xVpjLReMDa++Hsj8fIals+5WOXwMCzPuSaXDlAXzkm/MXBQWwKLHNU5Ym/9/SPMB9oiuvJzX9jlrnM2VUxIguoTU+J4tffir4dREeY2Fi23eIECbfSPH9mOEE0h2FLEW2IT5jtdQuEKiwtB+/UQJHszO2cwlA24vpoN3lmtO98lvryexH/DBl6cDgFKju4T0PvMnV356YwyXfeB9UEcdtl5GUKNCyOauQhdji5xGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(366004)(396003)(376002)(39850400004)(451199015)(7416002)(6666004)(8676002)(5660300002)(316002)(66476007)(66946007)(66556008)(4326008)(54906003)(41300700001)(8936002)(110136005)(6486002)(52116002)(2906002)(478600001)(6506007)(38100700002)(38350700002)(53546011)(6512007)(186003)(2616005)(26005)(31696002)(86362001)(44832011)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzlpTlhIblliKy9acUZ6M1ZUbllqTkgzU3Fpd3E1NTFNNXhiMjVWTWRySG5B?=
 =?utf-8?B?TU5lTGZkbW13clZNdGFTa3FsTXA1SG0rY2tnNUUxcUIxOGFVcTlQcFNQbWJ3?=
 =?utf-8?B?bDhjak5ERWh4TE9iVTBWZWx3dXhaM3RhWEUvMmZzbmdGWmxoMXhKTityY2Rl?=
 =?utf-8?B?dVlCdG5IM0doSGVscUZ2Z1ZPeEJFZ3lPc291L0J2S25GL045cW5YYkVVTERk?=
 =?utf-8?B?RXgrOXVLUkhUSFVDY0hpVEhDVmFsTEZUMUFMNEd2MVhYRUpGTTN1SjBZa0pz?=
 =?utf-8?B?QWJWdU9aWTNFWTRkK1kxcmM3UER2a3RTQ0w4dCtaWWJkUFAzdkgyZ0JPUnZL?=
 =?utf-8?B?R0E4UEZYd3YrT2c2cXYwR0l6bjZnWW1hakV2R1V0eWwwV1g1SFU0c3hGdjJy?=
 =?utf-8?B?UW94ZnphaHd4OWh0QlNxdk1WOGdkWlJUQzgvRElIcFdST2lRb2taeGR3T3pk?=
 =?utf-8?B?cGgwWDlBOTB0N0syelplVlBuaFFENDZKd1cwLytVRk9ha0FXd3RuSE4vbVRS?=
 =?utf-8?B?NHJjMmlIVElGNDNDOFdxeDI3Vmc2dlp3bjhidmJwOTF6V09ocklDajhaN3ZK?=
 =?utf-8?B?UVVNanBRV1Yrc0pNMmE4R1JEYUtMcGpzRnpHNVQrZlQ0S3pLUU1JWmtjRnNj?=
 =?utf-8?B?OUpVK3B0U01lbVFWcGpuelpWaWFHVDMzSTZJY2x4aDZnN2tocCtqbzdySE9W?=
 =?utf-8?B?OTBzZGRFTDRacHRvcTBRT1h6VFBwQmhzb1NFWXBEODlmbUUwOVFWZXVpbTV1?=
 =?utf-8?B?dGFBd1RIS09wcG45TXZyaFB1R0FqZ2RpYThzLy94bkQ5WExUdVgwRGJYUzNS?=
 =?utf-8?B?MHJDLysxcjRrTnhhMnoycFV6VEpqU0o1KzFobTZ6d3E1L3hOdzZNQkpjampz?=
 =?utf-8?B?Tk53Y09tWlJjaUMyZlBzOGRqUFkySXhYQ2YvV3dEMmtYbWJZc2lPNWNlMFRn?=
 =?utf-8?B?QlJ1UWJWMmF3SlpuN1cyOHVZcGxDZnd1V1FQNjkrMjllalByRnd6eHF1STBV?=
 =?utf-8?B?TUZORlJLTVVscEhWWGdLenFLOStIUStnU1dZMlg2VzBRQmtCa1dPQzFibVRo?=
 =?utf-8?B?YUN6RGFSeXVlcnBYN3YrUWErMWRKaHowNlJkRlVaZFNMRjNEMWFKY3ZxTm5C?=
 =?utf-8?B?OWZWR0ZXU0FjVVFkd2hHbGVzTFVYRkY1ZWgxU3pVclJjSERyRnk3cjE4czgz?=
 =?utf-8?B?aUxDbkJtcGZBZ210TU5PZlptcm0wMDRUcU1LWGlpcEFXOTFnSEFNZ3Z3RlBI?=
 =?utf-8?B?cmZBcUhHWitXLzMwUkVaTkQ1TXVEM2ZFd3BWMG5CVkZBWVVHT253OWRKMElz?=
 =?utf-8?B?NGlvZk9tb2hCMFkyMnYxaXhOTXRCWWE3V3hVUjJNWC9tMnFqN2JtWFNaNG1S?=
 =?utf-8?B?dnV5Vm5aL3FmVnora0dTRFdsRHh4MXB0cnZBd2ErQzdFM09vWkhUWEFNMExW?=
 =?utf-8?B?bTlnUm9nSllZY1FFNmViNUsyTEpoNHZLUTMyc1NUSXRCejNObEFnYmM1R2xI?=
 =?utf-8?B?VmxjOFFLcGxjNjlnWG9UYU15cVFXUk0rTWhQZEFVWHJPbWRnUXNwa0s5R2g1?=
 =?utf-8?B?YzBoTVhXTGREUWpibDJrb21IcWc1d053OEpUOXpYSUd0Ry9mRFNFNktQM2lQ?=
 =?utf-8?B?QjNNVlFOek1aK1kvZ3lQblQyUGIrZVRkOWxIcTZWaXhpM29kY3RScTZoR3lC?=
 =?utf-8?B?QVNUdzdab3VPYWhwNEg3MlF0ZWRqZUdReEZ2RmswR21VaUQrejltdDBuUk1J?=
 =?utf-8?B?N3g5UDlqNk8yVlJRK01PTHBZM1RKdFV6Q0x6MTdNenRoSkR6c00zOHFxbHBJ?=
 =?utf-8?B?ZkhVSkx3Qkt6b0E4T2lBeEk0TGhOckxHLytVMzdYMWdYaWxVWk5pdnM3WjJI?=
 =?utf-8?B?bVhzWkdGUjM3ZjN4b1U2UlV1NFpOTjZ4WkY1RkxsVVJNeXhwYlRjQk9jNGRV?=
 =?utf-8?B?VzZoY2wrbXhzdXlydUhYUFdsKzZ3eVJPbWtZZ3FROFNWc0pVVWVJcHpXM2RO?=
 =?utf-8?B?Rmxyd0R0d0JucGFlNHFwQW9sOWhBdjQ2cy9Way8rOWFNdGpKUjQxRDZ5K1FM?=
 =?utf-8?B?ekVjVWRBSEx6MHM2V21MeXlzU2UwOTdpendBSHg4RjRMNzNTcEtrajV6dlpP?=
 =?utf-8?B?czdMYncvNzFTbEZpSmhaemtJR05EaUdBeEl6ejh2ZUkyRC8zaGQwbTl4Qk1B?=
 =?utf-8?B?Wnc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17478831-6bd8-43c3-f1ee-08daef4efa75
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 18:59:31.6429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ag1hhk1vx1irUKOLwhRKN+gOMUNhrSrUvceL5g8alqCVKxvU8D0sP8siG28j7O2jmQUqrSgeH2jK2mTrVJ6k6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7712
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/23 13:55, Russell King (Oracle) wrote:
> On Thu, Jan 05, 2023 at 07:52:06PM +0200, Vladimir Oltean wrote:
>> On Thu, Jan 05, 2023 at 12:43:47PM -0500, Sean Anderson wrote:
>> > Again, this is to comply with the existing API assumptions. The current
>> > code is buggy. Of course, another way around this is to modify the API.
>> > I have chosen this route because I don't have a situation like you
>> > described. But if support for that is important to you, I encourage you
>> > to refactor things.
>> 
>> I don't think I'm aware of a practical situation like that either.
>> I remember seeing some S32G boards with Aquantia PHYs which use 2500BASE-X
>> for 2.5G and SGMII for <=1G, but that's about it in terms of protocol switching.
> 
> 88x3310 can dynamically switch between 10GBASE-R, 5GBASE-R, 2500BASE-X
> and SGMII if rate adaption is not being used (and the rate adaption
> method it supports in non-MACSEC PHYs is only via increasing the IPG on
> the MAC... which currently no MAC driver supports.)
> 

As an aside, do you know of any MACs which support open-loop rate
matching to below ~95% of the line rate (the amount necessary for
10GBASE-W)?

--Sean
