Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8701F6DA6
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 20:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgFKSwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 14:52:22 -0400
Received: from mail-eopbgr130054.outbound.protection.outlook.com ([40.107.13.54]:48455
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726159AbgFKSwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 14:52:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lITrJ5L75QfQP7DlBWv7JWTq5deNVQgC4PwIYy5vr3AVXp1Vk6mMG/7vn1G7mOoz/EBDyFr8/HvHrh87vjyxwBkInKSNkZt5+5CKO4r7gO+JQYdmT3DUgGRhp6yhdkqxvlJ5XvxYhnS2D3e3FEilBZRYdpwXMC2Sko2kTn9KTU5tVxW4/FrNGslHyMhtGe9IXu7Mk3dTwOzREC1JJsY6eUicLVPZ4aRZoY9IedS5ax+YF0jBzFTmyFDCHrp/GqV4kam3Hky7xxgKrBgMIXPrN/qW6XplY05xt/d/D8jwkEi7YzeLXYGAiv48TtZmWrsJqXlEHH6gg35jO6HvWJOPbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oEcdJAoONQRqduo2eqND1bqLeod+BLHWy/NohQ1ycWc=;
 b=WVuqgQke0zN+AlzXVPuDY7SVaudZ/+uKPvoQC9Rl936r/VekXDAQB92l/lsUI1xq2CjsTbgQsjXjXGwHP2ucy1+m+Pby+xtylp2lXz5xtRqp9EhGiLfTTODIlUIJ8saZYTL5rMZ+JARbCuc4pDypbubOQ5fjFNfJlt0u9KGhz0l6emh9kwHZ/Q6iE+5N9dPuG68KY3dOyL44GIhUxEProKvAexg4tErXYiXpK0/WPvnyTysynNOCJZQYzXLvHRC6rRgw1Nh7krXqv+E11qx2Cw1gMrkp7MK5GfVSt3lGafdnfAoES8LjLZWq0bYqYwZHvUK2M/pBPMQv889G0gTeOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oEcdJAoONQRqduo2eqND1bqLeod+BLHWy/NohQ1ycWc=;
 b=h5QBZnRxdIVRKAhEBHclUKIfMH2PK9YumLE8wuCXwGkXn8OumBv78UHiox/c9nojMUS+3tilcjT1Wh4C1H45gyDiaESAybwVjuGH1oT1NJ03f6hv21AaBnl7k52L0Vc1eASSrWGass/TnyubqHXGI5xEifNwPOcL7fGT3E4GS5k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4260.eurprd05.prod.outlook.com (2603:10a6:208:58::25)
 by AM0PR05MB4354.eurprd05.prod.outlook.com (2603:10a6:208:56::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Thu, 11 Jun
 2020 18:52:18 +0000
Received: from AM0PR05MB4260.eurprd05.prod.outlook.com
 ([fe80::497c:34f:a99d:97dc]) by AM0PR05MB4260.eurprd05.prod.outlook.com
 ([fe80::497c:34f:a99d:97dc%5]) with mapi id 15.20.3066.023; Thu, 11 Jun 2020
 18:52:17 +0000
Subject: Re: [PATCH net-next 1/2] ethtool: Add support for 100Gbps per lane
 link modes
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
References: <20200430234106.52732-1-saeedm@mellanox.com>
 <20200430234106.52732-2-saeedm@mellanox.com>
 <20200502150857.GC142589@lunn.ch>
 <e3b31d58-fc00-4387-56a0-d787e33e77ae@mellanox.com>
 <20200611135429.GF19869@lunn.ch>
From:   Meir Lichtinger <meirl@mellanox.com>
Message-ID: <4e988225-1edd-1208-9666-ee31ceec946f@mellanox.com>
Date:   Thu, 11 Jun 2020 21:52:13 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <20200611135429.GF19869@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR02CA0091.eurprd02.prod.outlook.com
 (2603:10a6:208:154::32) To AM0PR05MB4260.eurprd05.prod.outlook.com
 (2603:10a6:208:58::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.0.0.9] (87.70.217.68) by AM0PR02CA0091.eurprd02.prod.outlook.com (2603:10a6:208:154::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18 via Frontend Transport; Thu, 11 Jun 2020 18:52:16 +0000
X-Originating-IP: [87.70.217.68]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 04f0ff50-b506-4ad0-295a-08d80e389065
X-MS-TrafficTypeDiagnostic: AM0PR05MB4354:
X-Microsoft-Antispam-PRVS: <AM0PR05MB4354A3C0FC6781EC1D6E60E4DA800@AM0PR05MB4354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kj6kd+nEP2qiJAaXtll172yerXTEEgRhfZqs/tuCHk5Bqp9DaLpPB9M3W/Ck7FhXCKI3BMPJeQ3DBQgS49jJ/BQ+L/veYbKvp3CgNeRCqbSDkfUOC+GO/QMHRw0N5YVuBe9lBU4LD691jl176HMsP5v9qYxzRZq4wnpy0t3cxlbN/BhxyisFOEPmXSYYJAX/qRF/jt+wgNA7NNM1J6WkSP59ZNo+3LoxCg+JyVaF6HnNnYmM5TjKGugh3eNHyrYiANWSKlbgRqsIspS8PHSJAuw71BpsJpmLpU4OZIDau8hsvWZzvOFlZ7GQylVJwM5Hf5swt3joT0DdtEuSYK1GbLkow7IkFzRLKlnDjcKWEnB++fg+RvcvWscJGb8whRw0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4260.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(83380400001)(186003)(2906002)(66556008)(6666004)(31686004)(16526019)(4744005)(53546011)(66476007)(8936002)(5660300002)(66946007)(86362001)(31696002)(26005)(6916009)(52116002)(6486002)(478600001)(36756003)(2616005)(956004)(4326008)(316002)(8676002)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nX2ojBnMo+4xBGiL0aeNLSevpNfHU6MNjfX0/EFspLmQrOwyeK/0hbn3mULKQl0bDnqOewZLlzhM/slfv9nYxfnEmcgOOqLAV1bol6ejRGtHK3UG1g5uuvb2AgL2f48KTkhNV6GDIDcPa967TnGP9lJWBWRYjgak/Cw+Enirt3MQvV55YggS+HQyPgBSnonHsqKiCEySoM/+Rhb5/AFUiUpMkkSSSIV7Ujua7DQn1QaaQvMKPf/UA6JQ1kKEXSjoqsBihr0ElOLlOkykJ9HcYYfaH9WY16yX9CaBYGXPZ6zylJAEc3DL0u23Ste63rw9wJLll/tTyyFPh3AYjoiykvXtzmFrnmefY3Nm3Z/FcwH5AfODXS5NJv+gj2ARStERAb0QLzB0DROA2T+Jp9B68r0oVdXYNDjwNqBevvJubYANH2Cqk7l+TMRCIa6OtM6yND4k7RU5JdM6MTXWVyqI8lHbBK7GUf7hB5/KhaId3LQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f0ff50-b506-4ad0-295a-08d80e389065
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 18:52:17.8040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BTifTctb2DJ11RyhHOrEhbD68O9tRuT4URZnHxFD5s4vwd4tnK2JP6yYkRA04kajo/EPm7Gljne2PFa+IyatwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11-Jun-20 16:54, Andrew Lunn wrote:
>>> How do you know you have connected a 400000baseLR4 to a
>>> 400000baseER4 with a 40Km and it is not expected to work, when looking
>>> at ethtool? I assume the EEPROM contents tell you if the module is
>>> LR4, ER4, or FR4?
>>>
>>>        Andrew
>> Correct.
> Hi Meir
>
> Do you also have patches to Ethtool to decode these bits in the SFP EEPROM?

Hi Andrew

We are planning on updating the user space ethtool decoder in the future.

If needed, user can use the raw dump now.

Meir

>> In addition, this is the terminology exposed in 50 Gbps and we
>> followed it.
> Yes, i missed the patch which added those. I would probably of
> objected. But we have them now, so lets keep going. But we might want
> a clear definition of when modes can be combined like this.
>
>    Andrew


