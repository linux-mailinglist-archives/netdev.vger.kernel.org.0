Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24EA66AD2EA
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 00:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjCFXkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 18:40:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjCFXkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 18:40:05 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02hn2241.outbound.protection.outlook.com [52.100.203.241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BB34B803;
        Mon,  6 Mar 2023 15:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+pfS5Sfa+7A+web4ROdcfowIv01BarXRJSdfB6kuKM8=;
 b=wZtvCjncm/4eHPEPitIBTaszwZVzkybw0rbGQyFmFB2YRu82KcD8tNwHEyHUs5BXccDTEvOuOkeYT0zBO0/cQWtBODiNMFxaonaKhouXmVp1qw7RxbxCRVsMxYMbmjt+Jv/fQUO1iZk04R9AkVsbnp/qycz4vY26T1aRdNzFgXkShvKzg+Wx2iabjuyYRRuUCzF6MFU07imllnDjQjh2CHT7xj+CBnwxNhLyyUGiEDm/uuPq6aZKY5xRZDPmOuzdILfkpVDw7tjII8+ItM/c6vS5M/vGe7EnxuOcqkrGcLTlynE6wIJ00if3vbJad357yJhPQfXBViDeV4Pj7GTtpw==
Received: from DUZPR01CA0055.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::19) by DBBPR03MB7082.eurprd03.prod.outlook.com
 (2603:10a6:10:1f5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Mon, 6 Mar
 2023 23:39:57 +0000
Received: from DB8EUR05FT031.eop-eur05.prod.protection.outlook.com
 (2603:10a6:10:469:cafe::ee) by DUZPR01CA0055.outlook.office365.com
 (2603:10a6:10:469::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28 via Frontend
 Transport; Mon, 6 Mar 2023 23:39:57 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 20.160.56.84)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Fail (protection.outlook.com: domain of seco.com does not
 designate 20.160.56.84 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.84; helo=inpost-eu.tmcas.trendmicro.com;
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.84) by
 DB8EUR05FT031.mail.protection.outlook.com (10.233.239.193) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.16 via Frontend Transport; Mon, 6 Mar 2023 23:39:56 +0000
Received: from outmta (unknown [192.168.82.132])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id 807652008088D;
        Mon,  6 Mar 2023 23:39:56 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (unknown [104.47.14.59])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 985C92008006F;
        Mon,  6 Mar 2023 23:38:12 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPYgB6jreTeGqKe4/pfMX03mfwDb1+q1V7oF7JdeFftnwiVCkd984v+uGNgDACoBV06BmPowurZiV7tkC5+F+Rq3WNPp4QJjvc2C52VOVDQFEj6Ug1fdRY79jSEozoks41VeAay187Fx2QWIj5s8/aerEqNk4NVtJy78ExX4SzMwUFqS4CkBMV5C49UALdDePnKjQ73lVLE8xeJl/hGmvQ9/RIPYPHvpmIOTVerY0ORN+l+cTaMwu54OEnTeSgUwkS/JrpHgxAdGqKhETHq5kNXEDeme6Un+Bgsu9QXjX+yF5UZMidHtKaiObBW9gfODvosT5+zX81qcgsTvRYLO/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+pfS5Sfa+7A+web4ROdcfowIv01BarXRJSdfB6kuKM8=;
 b=SRUXHfzWljac62ictofgou0PH9F6gin1bE2M+ObrPbmQefuzDp3i/mnGtt3M7kvNGgUwJ4Z9Ov9aSL4e5ARzIdof9hX5uNU4Rtlgfhu/wUEhjW/w7CskLvOZV3zU4IW36tMmoGAiFOlY3XRPE76ToHsbwYTwgpnMTCXkpxIskTqv79rgxLM/rFQcwTKCFVXqLnl8MWzRa8H/8rvcJduKpoUGN8qSmls8nK9XL0HFaiV4NZrhWA7t7h3uP8O6+qdeIvq/pR1zW8z7mlngC26huIiXrF7MU0CWnjBRafRtfLSt+CsPgQp8AA2CI2Fe2KGn3/t3QskahChlYAde5Deqqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+pfS5Sfa+7A+web4ROdcfowIv01BarXRJSdfB6kuKM8=;
 b=wZtvCjncm/4eHPEPitIBTaszwZVzkybw0rbGQyFmFB2YRu82KcD8tNwHEyHUs5BXccDTEvOuOkeYT0zBO0/cQWtBODiNMFxaonaKhouXmVp1qw7RxbxCRVsMxYMbmjt+Jv/fQUO1iZk04R9AkVsbnp/qycz4vY26T1aRdNzFgXkShvKzg+Wx2iabjuyYRRuUCzF6MFU07imllnDjQjh2CHT7xj+CBnwxNhLyyUGiEDm/uuPq6aZKY5xRZDPmOuzdILfkpVDw7tjII8+ItM/c6vS5M/vGe7EnxuOcqkrGcLTlynE6wIJ00if3vbJad357yJhPQfXBViDeV4Pj7GTtpw==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS8PR03MB9368.eurprd03.prod.outlook.com (2603:10a6:20b:5a0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Mon, 6 Mar
 2023 23:39:45 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%5]) with mapi id 15.20.6156.027; Mon, 6 Mar 2023
 23:39:45 +0000
Message-ID: <6159c627-b74d-0187-0969-936795cdac87@seco.com>
Date:   Mon, 6 Mar 2023 18:39:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
 <ZAZt0D+CQBnYIogp@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <ZAZt0D+CQBnYIogp@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:207:3c::38) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS8PR03MB9368:EE_|DB8EUR05FT031:EE_|DBBPR03MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: 32bcba2d-bc54-4c11-8bac-08db1e9c17f6
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: xVE1D95+maLIM5diTTcz5Ra92GROecZ3lEdm18+/wOYIJ8B1mCi6ri2Oahay9wNlusiRjUek4xfwb7PEhJQGYa3/42VC/C8EUq/uLYP3UO+yFi557SXfcRmMpqoGrHsj4tIwwuXJvDJouXI9f0jLWmVs34W54p79ad+1Fv8hH9mKgXELUGtsjWW5U3e/vNgPPQ9fyH9MaIqf/L6rQCglRtRrP4EWHxxjsDBPje4p0oZU8mXKqz9t7uhTwvmZ6uCDkUldchD6xAyz1mZ5AwEPkYRRzRSNmuaMWOx5l6wqU9QYtVUfBwewFGkYsmk3B3mJD3k3on1yLF6iqdm3Umn/267g+bcCjQgHlVA4eZBrAQXKnDhbRqxKHKYLZTjAnDRgY8KilHVnfLSHwkIE/pBEERsuROSYrOIQh53WIVekiQ65v10I3RuE34312FGrUDAm0OUMM6GKcjtp1gSMQ5FluVE4Ag6N0RpXW+0PBxwlej/tjYQuJzyT6QrGnlviJiL3uFYQliCsrgHS68ljaNy2gudqMERNW2akbofdXZcihwvzTRuJAdnCXp7cJ5/pNIW5R6Gj4xDqk9I8aMBGulgM28Cu8qDYdmJXxrA4Wp6IyYpIMg/WjgeUPnloRdHk7/kfi8QZ+3WGdovCr1m1vzM5N8PXETqfvcIl85ccMauW1WMKddsRLkdti7nV1BU+rMY63pMyd034tiaK52tD8II5j6d8KL3AYUz1GiyRakZXN7WU/4A1QQnX1yz79nKD3YAjL7Ec02UrJxnHGhDHlvfR+g==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(376002)(39850400004)(396003)(366004)(451199018)(44832011)(6666004)(52116002)(31696002)(41300700001)(86362001)(83380400001)(316002)(54906003)(4326008)(6916009)(8676002)(36756003)(66476007)(66556008)(66946007)(478600001)(7416002)(5660300002)(8936002)(6486002)(186003)(26005)(2906002)(38100700002)(38350700002)(31686004)(2616005)(6512007)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB9368
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB8EUR05FT031.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 5c9467f8-ab99-4bb4-adb6-08db1e9c10b7
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TnHRRODEXKgwiFEGSE7yuyQzoTopDWk/khI2p2ADYFVZhtyVec00KHoGhmYFJ+kpgYfbl9Sn4ji9HXh99WP6jWsDArWxa5p70bpsAT/30TH9G8V8p8yBwyNoiGeSPWLTOuZXeI9fyjuByxkHMAv3qLC9ksAxRdc4Gy0anNupSry4fJz8RTti1dZcMbUok3xCcmLxsFj6XVvSt/kTM3j+3JVywHtn7vd9VxCIWpTTYz7ln4wPBuuShjR1gcMwwnTVHRZg9VT9XlvK/kbDX1t6EHeviJ86/By0xGu4a1Dg8ufPcLdw2vFBNinmQQ6KOz6RQmy7KuVeSE3HqpGJmSUBS5MXYl0MvzUEegPHjTIeZ0A1ZsozTwBsg1P+sTymiFShGZfQ2Yxp1eQPcJZCbp+ToFzNjkui/6jBwnkIQLjfDJu+/tYC0Dj7GJZuf6n/D+ZKSm5JCnIjlPW79xpTm9MS0iWg5z6/oUP+W75jBqCE56/H9B63jgbTHcbMHYL74QIJaOo+4XZIMN/Hehi8rWN6GCuX+q5pvZi52fEDCBUx2DY7EB6MZeGJPKuM9/XKxikXMyfm6BMQEhFtJV3zeIxyOFSnoFd/8OAR7w+DOjsiodJ/JFLpdgBo/R9R4E5X0Cy7/BEfZCw70AUezt+emktwa6tZNKc6tMmJC+HnIhHhTGDRSRJpP3yv/1CwUs6ssHDfcPL6/PicppwrDCR8/alXV79y09KgwWy1Jk3IM0mOf8bYRCMrSfRLhRdFl/80vZeuidCKEvy4z50BzT43ccrc/Ag3zcm7onfcCuivQT3Eot6ryJSQR5NgoYkd0y/RmKL58mgYV3z8moTG8xE+wIXfDA==
X-Forefront-Antispam-Report: CIP:20.160.56.84;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230025)(136003)(396003)(346002)(39850400004)(376002)(451199018)(5400799012)(40470700004)(36840700001)(46966006)(70586007)(8676002)(70206006)(4326008)(6916009)(83380400001)(31696002)(86362001)(82310400005)(186003)(47076005)(2616005)(336012)(40480700001)(356005)(36860700001)(34020700004)(82740400003)(7596003)(7636003)(26005)(36756003)(478600001)(316002)(54906003)(6666004)(53546011)(6506007)(6512007)(40460700003)(6486002)(44832011)(2906002)(8936002)(5660300002)(7416002)(31686004)(41300700001)(45980500001)(43740500002)(12100799021);DIR:OUT;SFP:1501;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 23:39:56.7884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32bcba2d-bc54-4c11-8bac-08db1e9c17f6
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.84];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR05FT031.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB7082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/6/23 17:48, Russell King (Oracle) wrote:
> On Mon, Mar 06, 2023 at 03:45:16PM -0500, Sean Anderson wrote:
>> +static int mdio_nl_eval(struct mdio_nl_xfer *xfer)
>> +{
>> +	struct mdio_nl_insn *insn;
>> +	unsigned long timeout;
>> +	u16 regs[8] = { 0 };
>> +	int pc, ret = 0;
> 
> So "pc" is signed.
> 
>> +	int phy_id, reg, prtad, devad, val;
>> +
>> +	timeout = jiffies + msecs_to_jiffies(xfer->timeout_ms);
>> +
>> +	mutex_lock(&xfer->mdio->mdio_lock);
>> +
>> +	for (insn = xfer->prog, pc = 0;
>> +	     pc < xfer->prog_len;
> 
> xfer->prog_len is signed, so this is a signed comparison.
> 
>> +		case MDIO_NL_OP_JEQ:
>> +			if (__arg_ri(insn->arg0, regs) ==
>> +			    __arg_ri(insn->arg1, regs))
>> +				pc += (s16)__arg_i(insn->arg2);
> 
> This adds a signed 16-bit integer to pc, which can make pc negative.
> 
> And so the question becomes... what prevents pc becoming negative
> and then trying to use a negative number as an index?

We start executing from somewhere on the heap :)

> I think prog_len and pc should both be unsigned, then the test you
> have will be unsigned, and thus wrapping "pc" around zero makes it
> a very large integer which fails the test - preventing at least
> access outside of the array.

Will fix.

> Better still would be a validator
> that checks that the program is in fact safe to execute.

I think mdio_nl_validate_prog could be extended to check for this.

--Sean
