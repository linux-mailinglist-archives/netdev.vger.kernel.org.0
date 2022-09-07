Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794945B0AE9
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiIGRCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiIGRB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:01:56 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20071.outbound.protection.outlook.com [40.107.2.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A7BA1A71;
        Wed,  7 Sep 2022 10:01:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eiNU95Ye+00s6vrCoKIThYs9kXW1WRAMNdhVcgrQS3jAkC8Gfon1w6hXMF3UYXjtHPiIhy46wDNQGgOyRvl2SQRsD/dnwSJY6kusfSKYgRMDM4lLYV8y7owwfr7YuYXTFvkZ4480R0AlSFbc39dg/PJ11fsV9lfCuNOoEjbc3Zn5AX02l7pLMCa5ynGKht4H2UYsKUXJ6lbsL/czdo0C/p0Q+bE+Ia7WONsT+jq0UOEGPwwQfFv+XY21j4U4RJQVM53CjVA1ExiZl3FbwSZzS4AgdmL7mTjG6cUg/SH5HDbpanHOVo7d2OBlZ8/apEe0b9UxSv2VErk4mJiwCHw/SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AuUbo11UhWlxr1/egPSGRykaDTIKDvUFzO5YNzY6tlA=;
 b=Hc9pxdrHanfKcLCRQ9YIUFjBoCf8qhfyMnVeI9w8fVdsfQ2Yegj3xgO982hTiA7iGMprtHQ2LOyNXY/n3DfDTWufBya1WTTsxa0+3anlJC0CRyLJlft1LHrDXtXr58XnupJRyza+d0Cqm3HXaADdlLt/9ngl/P8EpgGfOaeeOWbq95sQXfKBRYgZ9r6PsWj40TcW1/grHT1kYK4F1HOJEO863XLSU56EccnjMODldsL9TiQbA0+35XdZulWPKZ1him5yQPKDcvj6gmaKtzBy8ofmh4UVGvAwinpcfjrrfE7pCJDppaQqh5x8saeBLFRUlBcFkxLqcTSfS+2qki/ALQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AuUbo11UhWlxr1/egPSGRykaDTIKDvUFzO5YNzY6tlA=;
 b=MzxKH224fVtqpqbnNeNE4Zn18f+U8ROZEQUCIB80HPOrrBY54ps4WO5/Rfr6A38l+JUU/KhDn1I0hVM3TnLtzm9nRcQmIsxQLlyfW9aP4liseySlBpsatuDYQPcMBvwNY5wS912pZN4flH/q4a6x0qnT1EF/L6qpgSRVx/deh0UemyvXLkhlWAsWn4AfkrccgwdDp1w5Fz1rIlYCjNILakqiLhvmkE9boOmbWx+MMwkAwHmfyde1/cGFUAwIEM+yHrrynlDwRR+Wzbd/wseErMjtxwha/Q3A0m2GI0hFiDZ4Ei3aOUswj3sNm6inq7YvWlgD9xkQMsDxPob60JuKiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DBBPR03MB7004.eurprd03.prod.outlook.com (2603:10a6:10:1f5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Wed, 7 Sep
 2022 17:01:52 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 17:01:52 +0000
Subject: Re: [PATCH net-next v5 5/8] net: phylink: Adjust link settings based
 on rate adaptation
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
 <20220906161852.1538270-6-sean.anderson@seco.com>
 <YxhuMjZsBb7wCBFy@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <f2c15d18-23c0-463e-775e-f99e42cd4a69@seco.com>
Date:   Wed, 7 Sep 2022 13:01:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <YxhuMjZsBb7wCBFy@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:208:32a::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e30ec5a8-ef7e-4bd1-bb79-08da90f2a96a
X-MS-TrafficTypeDiagnostic: DBBPR03MB7004:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G+dabDR/Ot3ARoggZGA10fRZcTbrFYtPkP8COeP8zDwUwh5B2QWdGphdqwTMHTYE9qEPeFD/OWnWfJieM2wu7Pac3olJcBnpqiDhjRiR5r3gbJgMYjsmUQEq5eKrxH8sTkIKug+jdA8PCxl7r/oYUoze5TpoGfa90xNOR9HwduXCq3ssxLXhyYgtvt3c1z8rIcEdwODZx7Tb9AkkNLvtgR77J6yyNUIZ0xCSMJ5Ho3l43CyNgd3qeKXmhoHV6Zy+HynX0/EOO05FSw/33BLhkJPRHl6FPLTSrdEeCU/H43Ozhhb4APkz97YnvUjWImAQmO3o4h2EhfI5EqUmd7wnB17OgAxe8unqGCug7tXxOL0wZ5B2F0ldE+vwHrxa5GS9wW9lOBzTXtxy/ZFmEUqX9YTbVtmzCY8oh+DyjA+mrl/WOKQemEE7t3/2ln5xkNaqKgBKJwCGPTXHxb0zujUYz1WIKRdiiXKkNmiTX39gNorlzklZ6NNUukIW8u38bE04PQDXW4JBLTF7uvpO7MV3Kt2yBajM3LLjR26lLQJ9dU98ExWX2AzPDAF7zlaFexoii46MYcx3oWOh+5K4tfGq8FEhsrkmpy6fq95x2JhNTJJjaN9Yb5FBkOUnul5f8L1HaRGomM0zMvQjX4y68m1JTKiLvLMtFIueYN9OHcqzP8mXcGK8gektO9u2NWYFbdrD998/qbDQ2P/tNMJIJiAUnKM7m5VsLCE4BTBSF4slIHTfzs1gp/kjRwTMEsUM7FEMp949rjmO9L0h6ivWtLTvSqgugv/JZ0Gg2T30SdBSMlKpWkQrPxNYlhiSwwnTAYhTsUK2CCbcFeknMylLjYcUeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(376002)(396003)(346002)(366004)(136003)(316002)(38350700002)(38100700002)(8676002)(66476007)(6916009)(4326008)(66946007)(66556008)(54906003)(83380400001)(2906002)(44832011)(7416002)(5660300002)(2616005)(26005)(6512007)(53546011)(52116002)(478600001)(86362001)(6666004)(6486002)(6506007)(186003)(8936002)(41300700001)(31686004)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmxPbE9BWU9pU2ZaZTA3K1dDclhkRW5GRFRQVTZVQzFvYkhVb0lvT2JjdGpn?=
 =?utf-8?B?L0FoNFlPUFVoSXlDQW14S3phclh1ZE1uWklPK1RERWZKMVkrS0M3cXJZdk9r?=
 =?utf-8?B?b1BmZG9GZjBBdUt2NWNXQXhSUFJEelArbnpUODZldzNoZ0tjK3I4U0E4WWdX?=
 =?utf-8?B?QUd6M0xZWGRlUWV0L1NFQXJFN0llQkkzSXpuallNcUJrTFJBazRBaDM0V2Rr?=
 =?utf-8?B?VFdUSy9hSUxZNU5rNzg4OWxOZm82VmgrTFpwWDZnbjkrQzRpeUlHV21wZTlM?=
 =?utf-8?B?Sm8raWVkeDU5dDQvVDJxUURHKytxdXZHL2ptSU5BSnBOOTZEaDlxcVpFSVph?=
 =?utf-8?B?VFdYUWliZXkvZ0l0cHRsZWxUTERpZWNYTG5QZ2tXTnFITjFZSjBBdkgxVTFm?=
 =?utf-8?B?U1UrbnlMNVh1dFcrSGlhNldrN1NlRndxUkpLNm8vdHUzNmJuWkJHV3UxemN4?=
 =?utf-8?B?WW5DZDZQakkwL1ZLNVdDcFF0OWp5RTBkWityRVpHSUQ1QlBwUjIzYzgyQldO?=
 =?utf-8?B?K09ISjFkdTFKSjlkYksxU3krTTN1Zkl3OFgwNi93OWNONVFTYVlVQ05aVU50?=
 =?utf-8?B?L2xLeHk5ejZaU1oxNXpSMzJndEw0TTBvNmtFem9sc1RXZ0NtWjJvdHhaSWxw?=
 =?utf-8?B?Z0ROVGtxKzRTWFBkTk5nNUdJck53b0pzdFh3L1RWYmxOc1dxN3BtbTlUc3Rr?=
 =?utf-8?B?SHdZY1VSOU1CU1dKb1dKc1Y1aGZsVmdNaDNSNHgxQjJkZWx0NzNvb244R0M0?=
 =?utf-8?B?TUEvNldZc0s2Mm92d2xLOG03YWo5MjZWZUEwZEE1dlZsMnJ0aURJeDMwcXFk?=
 =?utf-8?B?UlpEOURkbTZiWjV5bE5vOGYzbkI2Qk55eVpENUtCRkcvQWRlUjQ1dG9hNkUx?=
 =?utf-8?B?OHFBSjN1dS9leGdwZTFpNHhRUmNBWS9nbTlYbFRzME5XU0YveWpvK1A5emR1?=
 =?utf-8?B?SjRMQmEwN1dTS1U2YlhuQlljc01raGlianpKOERBd3pRMXFRVVFpakF3SnpE?=
 =?utf-8?B?RGdrOHVnSUxJZXBnNi92cy9wQjBXYjNUT25JRjZZMmRHbXpQT3lHQ2dLZXg5?=
 =?utf-8?B?WWpMclpLZHp3b3pKaitieUREb3FldWdTK3hlWklMWmZLR2hIdzVhVXpRekpJ?=
 =?utf-8?B?ekRpdDdOUFpvTXJTNzNqR1FEMzZoMFdLV0NUeER1R2JhcSt1c1NsemtBVENw?=
 =?utf-8?B?cVBlNzJua2VxdVJZeDFWODhRMkV5NHJhQ3VqNWpjYmE4QnNEYU9PNEdqZjBj?=
 =?utf-8?B?SlpwWjlxMEk4SjhSdGFoZTNyTzhDalJ4RXVMOVFsTjBFQzBWcHQ3WFJzNGxB?=
 =?utf-8?B?LzVPd0QwZ1lZSlRoYUJxWHNNL25sZ3FoK25lK29lMXV3dHQ5a3NoOE8vZjBI?=
 =?utf-8?B?c3Zuc0pUVTBEUXdIMWJySmpmSHp6L2Q3OHpDU2Q1cnRtRTBxRDkvVnVDdEox?=
 =?utf-8?B?clY4TmJTbXZPdGdKQzJiaXVnOUZEVUZ2cWJNaG54KzRqcFdWZDNGVWY1SUJr?=
 =?utf-8?B?dDFmS2MvN09pcXp5M0hScE5ld0NzQUFqeXVKR2pvWDQ3WGtWRlZRYk0yakpk?=
 =?utf-8?B?NHVuWVorU1RKU0thQ21uZ1BrNHRlbTdHSXpQSEJMMHpsb2VMbXlua08xQzRy?=
 =?utf-8?B?MzZJMlBINTNFVXRsU2hOV1FUUWY0YjRJNm1Bd0NudXFyTnNXNWRLejllcExm?=
 =?utf-8?B?U2JTVTdKR0tlMVlVazF1TXdxM0JxSGEvMjZ3SnpCem12L1p6d050U2J3VkNP?=
 =?utf-8?B?YldDL2JYSXA1QkxYelZ3dDdJUGlsSEttL3NxcGFKNjAzc1JuNkxEUmMydWVC?=
 =?utf-8?B?RW9hQzhtSkRQcE1GSnVEOEp3dDd6a25YTWNSbnlHbGZ6RDM3UXlzRlVkYUZw?=
 =?utf-8?B?MW9GMyt6NTlZZGtzOW1zZzlaUzhuQTlUT1FLMXJzR2NvV2RvZFc5N3V0aDRj?=
 =?utf-8?B?OG5RT1pVNmFSY0ptaDhaeUNsMWovVmFvSXo0TzdoR1dLWmRwRXVWVHRlbVVO?=
 =?utf-8?B?Y1M4b3pROHVSZzM2MnljVjFzdjJ1ZlR1NU5sOWRNa3pYOFVobFBDWnVMZ0l4?=
 =?utf-8?B?S1V4WGxmWFNway9CcVE3SlZBeUg3eWkxYXNQR2p6K1FkREdiQVhzZnJVMW9R?=
 =?utf-8?Q?aEmURYyaKVCqWd/XtOeRWQtQP?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e30ec5a8-ef7e-4bd1-bb79-08da90f2a96a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 17:01:52.6113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCAzZHUo27p01pmgQAGQaPGeVTaAttVZMCf1h4g7vifToyU9gQa68jwgscwNzYFx+YrwYbC0YxoN+gydTlkpsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB7004
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/22 6:10 AM, Russell King (Oracle) wrote:
> On Tue, Sep 06, 2022 at 12:18:49PM -0400, Sean Anderson wrote:
>> @@ -1015,19 +1086,45 @@ static void phylink_link_up(struct phylink *pl,
>>   			    struct phylink_link_state link_state)
>>   {
>>   	struct net_device *ndev = pl->netdev;
>> +	int speed, duplex;
>> +	bool rx_pause;
>> +
>> +	speed = link_state.speed;
>> +	duplex = link_state.duplex;
>> +	rx_pause = !!(link_state.pause & MLO_PAUSE_RX);
>> +
>> +	switch (link_state.rate_adaptation) {
>> +	case RATE_ADAPT_PAUSE:
>> +		/* The PHY is doing rate adaption from the media rate (in
>> +		 * the link_state) to the interface speed, and will send
>> +		 * pause frames to the MAC to limit its transmission speed.
>> +		 */
>> +		speed = phylink_interface_max_speed(link_state.interface);
>> +		duplex = DUPLEX_FULL;
>> +		rx_pause = true;
>> +		break;
>> +
>> +	case RATE_ADAPT_CRS:
>> +		/* The PHY is doing rate adaption from the media rate (in
>> +		 * the link_state) to the interface speed, and will cause
>> +		 * collisions to the MAC to limit its transmission speed.
>> +		 */
>> +		speed = phylink_interface_max_speed(link_state.interface);
>> +		duplex = DUPLEX_HALF;
>> +		break;
>> +	}
>>   
>>   	pl->cur_interface = link_state.interface;
>> +	if (link_state.rate_adaptation == RATE_ADAPT_PAUSE)
>> +		link_state.pause |= MLO_PAUSE_RX;
> 
> I specifically omitted this from my patch because I don't think we
> should tell the user that "Link is Up - ... - flow control rx" if
> we have rate adaption, but the media link is not using flow control.
> 
> The "Link is Up" message tells the user what was negotiated on the
> media, not what is going on inside their network device, so the
> fact we're using rate adaption which has turned on RX pause on the
> MAC is neither here nor there.

OK, I will leave this out then.

>>   
>>   	if (pl->pcs && pl->pcs->ops->pcs_link_up)
>>   		pl->pcs->ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
>> -					 pl->cur_interface,
>> -					 link_state.speed, link_state.duplex);
>> +					  pl->cur_interface, speed, duplex);
> 
> It seems you have one extra unnecessary space here - not sure how
> that occurred as it isn't in my original patch.
> 

This corrects a spacing issue in the existing code.

--Sean
