Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532B66E9CD7
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbjDTUHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbjDTUH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:07:26 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2052.outbound.protection.outlook.com [40.107.247.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF131524B;
        Thu, 20 Apr 2023 13:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKd6JB5Ad3xyTSGfLb9W2m/RVnXOQ3kCD+DMuu4CE80=;
 b=vYIz/jqdZzNbuulGtvVUtFVOQCoaC2ngPftzgzkVWLVJEMdf/BLvEgVuZSiUXn7tefK83Iu0WfXYKI1qNGMXDvep12MqT1lP9HjYi3/E72SFY5Fli4QFThsAk/eDWaUlsPasbLgyShUTa1mDJOKUfrwgyW049aqQw55sTOjIHYsIKRQoD7DgtVdWE8O05vvbPTi72QHiUUKWHQhYVa0IGSPmCFDVEfBBqYhplsQm14yhjGgNbb3s1zp7U2qTyY0rv8/wO754pBrJmlAhRoMIIMGV4Vm1fWjumN6iJi+iduNugTQeSld8XDm8YvXo+43vDCZK7Tnaqv0VQSj6oQh8Dg==
Received: from AS9PR06CA0449.eurprd06.prod.outlook.com (2603:10a6:20b:49e::29)
 by DB4PR03MB9411.eurprd03.prod.outlook.com (2603:10a6:10:3f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Thu, 20 Apr
 2023 20:07:20 +0000
Received: from AM6EUR05FT023.eop-eur05.prod.protection.outlook.com
 (2603:10a6:20b:49e:cafe::1e) by AS9PR06CA0449.outlook.office365.com
 (2603:10a6:20b:49e::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.24 via Frontend
 Transport; Thu, 20 Apr 2023 20:07:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.160.56.85)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Pass (protection.outlook.com: domain of seco.com designates
 20.160.56.85 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.85; helo=inpost-eu.tmcas.trendmicro.com; pr=C
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.85) by
 AM6EUR05FT023.mail.protection.outlook.com (10.233.241.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.25 via Frontend Transport; Thu, 20 Apr 2023 20:07:19 +0000
Received: from outmta (unknown [192.168.82.135])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id C2C1020080268;
        Thu, 20 Apr 2023 20:07:19 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (unknown [104.47.14.59])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 5F6CF2008006F;
        Thu, 20 Apr 2023 20:08:50 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WNCdUnlSIM2hho1IKp3teHy8JiVOFGSAKjQNijZf+W5LO8FrbT58cP33oWXvbIZqRCk0FuzGjNKL1bRrd12Y6Gf1yADVSZXg6c+gVmhUbYvILcwAuUGIJI2OX29+6bM9Z2qGnk52ezHpLzLhKi6wKJytqng3tgH1ES9mungLIPbz5RY28QJLC986pUiJwqCt8bqWVWPTaWFAZ/UC824l1HCovkPcwLRsBy7+B8zsrCkEW2vqhaWNFvpFh9dwmo6LEOfP38i6+cmtcHXxbbNVWKgfJrThNXFRR2x+4zJcOluLdDHyn9bwANTYYZHSRMJl8xtp28DUSWURISz3DwbKdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RKd6JB5Ad3xyTSGfLb9W2m/RVnXOQ3kCD+DMuu4CE80=;
 b=AnNtAAwwWiZ3/S3aACpqWgtb8N4efJu8QGyzcEmle+n3jtNjvddDiJs6qfZm4+QeRGCVu/8/DnnjKs3a59HAf73/dcFGrJWY6TeMwa+iIJK0A6LJygsOJS734CgHP6EZ4GYqRMA6y+8hdEcUnyVUWdF02ZvGVffXIk0mfmek0sGeJ9oEWq83iBka2YyoP61FTLeRwc8WPiYhvlsaSUxwbEEQEfM9cag1Lxes6CaBNi34sSdllAe0zp+SgdbMUx7s+UiQlfizWrr/DI4JDPPRO2u4o+lEM5/4jTpsiZKk3pQelJJF9BbJu4aJNigZMzqwqhJfRrXFC31jHcuPRMAnaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKd6JB5Ad3xyTSGfLb9W2m/RVnXOQ3kCD+DMuu4CE80=;
 b=vYIz/jqdZzNbuulGtvVUtFVOQCoaC2ngPftzgzkVWLVJEMdf/BLvEgVuZSiUXn7tefK83Iu0WfXYKI1qNGMXDvep12MqT1lP9HjYi3/E72SFY5Fli4QFThsAk/eDWaUlsPasbLgyShUTa1mDJOKUfrwgyW049aqQw55sTOjIHYsIKRQoD7DgtVdWE8O05vvbPTi72QHiUUKWHQhYVa0IGSPmCFDVEfBBqYhplsQm14yhjGgNbb3s1zp7U2qTyY0rv8/wO754pBrJmlAhRoMIIMGV4Vm1fWjumN6iJi+iduNugTQeSld8XDm8YvXo+43vDCZK7Tnaqv0VQSj6oQh8Dg==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DU2PR03MB7845.eurprd03.prod.outlook.com (2603:10a6:10:2d0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Thu, 20 Apr
 2023 20:07:13 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2226:eb03:a8c:a7e5]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2226:eb03:a8c:a7e5%2]) with mapi id 15.20.6298.045; Thu, 20 Apr 2023
 20:07:10 +0000
Message-ID: <2ddeba18-9e11-5a87-4f44-d739d23ce5f5@seco.com>
Date:   Thu, 20 Apr 2023 16:07:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net] net: dpaa: Fix uninitialized variable in dpaa_stop()
Content-Language: en-US
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Dan Carpenter <dan.carpenter@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
References: <8c9dc377-8495-495f-a4e5-4d2d0ee12f0c@kili.mountain>
 <AM6PR04MB3976BDE554983C8AF164A680EC639@AM6PR04MB3976.eurprd04.prod.outlook.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <AM6PR04MB3976BDE554983C8AF164A680EC639@AM6PR04MB3976.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:208:160::22) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DU2PR03MB7845:EE_|AM6EUR05FT023:EE_|DB4PR03MB9411:EE_
X-MS-Office365-Filtering-Correlation-Id: 875d15b1-4993-4449-033e-08db41dad8cc
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: wFw4Fu4U7FCZrhZIL443rHK3SyxlzWk/Nenge+yumZ7LPBB7cVQIO3EMqisd62EUs4BBXtCD54W75bQNO2dp0YYW7wWPtHxDbLO0WkQyYR4tToe1FOn1nmRnCyP4+i/dqadWLwJgqxjZ+yNy3gwIvDJrxkGkrq1Y2cqUhO7zppdK9vpVH3xhawFoBdfdrxq9e+r9rVuwt8/eTEapNYPAnEHCebZ6JjIoC77RB5qoiOVja60vt/ujI7vQyA2IyrfH8G6GVZ9A3ze8Kx8DLJteO9r+x14r1PDkhxaJyK8vCoZwEqZ5ZAXUX25R0Jig7icMGzMOt6VKNIto1V5XHnDKynuCI2YI2YteGNalvviCQP7bjaSKNMHEyuKsIF1aaCU0q2y0DYHyXvq5vfYiAO13B7II/qIVwP6ujIWHVc6TJrG/Xz0gcowUOedEJF625Zj0rl27J5zGpzM1HeKIw8aySl3ncAXt7TGQoFVDBYEu+iw/wlXds0HplooBPzm6/h4N76U6+krIWx/5Z//0F+GG6rGe4wEio2tLtRxsrvnGGQzPQhCn97qf7YKs78qQJBYj3wUI5igD0xI2dOI96ONosyw/g4Hqel7zZDEssUKJsalD77+C8KxDCN1KnQ72ieJ9FJ0l1OsU39t+L28Hi1VQzbWPNQjYqXq8eq2vlDJI15/1azT2KfXP5lz0o1XacyTa
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39850400004)(366004)(136003)(346002)(376002)(396003)(451199021)(4326008)(5660300002)(44832011)(86362001)(2616005)(52116002)(83380400001)(53546011)(31696002)(6512007)(26005)(186003)(6506007)(38100700002)(38350700002)(8676002)(6666004)(8936002)(54906003)(110136005)(316002)(6486002)(478600001)(41300700001)(36756003)(66946007)(66556008)(31686004)(66476007)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR03MB7845
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM6EUR05FT023.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 4452afbd-0387-4991-4d63-08db41dad308
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /pRERsgxh2UAiAqZLiaIswQd4lgxhbhOv3OPdarUuLeBmCFJmY1yMbULp3CsyvYiJPZRZQ8FmOoFfgh45xA1aGgjnOTzvb1Uze1Ob3MKjhCpnnVFgJy9PY0kywALi4rMX9fHtyu2uBgXWhkyJ1iSiiNOUbJ8T946gNUbni29M+ydmOm0ucEtvcLrpzIAbUnXw/SluZSXOU0YOKeHtL7ci3WZxAnf+j9eUFeLap4dOuM5KhXG/IDUyQtc5t1nHz+R0QSt/Vscx1J1eVA4/fe7FIBJnTTY7TCdonwz+yCM9wNBPXs/dV/zRchY4lRJk+Jjb/fuW1vonLnhePa4nwEsR+mOKUoQJmAiN9IHiL3ousEcwKYwx/iELa/gTgEtkvAz5/bFihyZKLT2aYdCFv3b8Khl+rPxOqcBVh3g1FwbhKKKMBdJ2h7bCDgH7cw5of5n0yYCp9z4op/CzbwXbsN0m2zNBIxURyOwm8UKoZifkEQsp4WpHfDMudgymHFKislDxWfpJADXJTvjlTpXoyu7QnnjP9TjrLox9aX3w010Wk4UxpzZRs5gbJz/xpv8qnnvGNJI25CG3X7N7SwWAilj7IIkCCzOQOK6zlFAmCyxsOs7p4Eq9u6Bfzk0kSD3T9ob/IN/7WeZQnYczCfnyG178w0G8DXG0W9Rzf1/M8BAhKwk56IY0nefkyxi147Lt4AiAq2ESVHMFF4oh7TDQAAvh1ZqwjiKa7CgJTl5FKCaKhc=
X-Forefront-Antispam-Report: CIP:20.160.56.85;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230028)(39850400004)(136003)(346002)(396003)(376002)(451199021)(36840700001)(46966006)(7636003)(2906002)(8936002)(8676002)(41300700001)(82740400003)(7596003)(356005)(44832011)(5660300002)(82310400005)(36756003)(31696002)(86362001)(40480700001)(31686004)(478600001)(54906003)(34070700002)(110136005)(36860700001)(2616005)(6512007)(26005)(6506007)(6666004)(186003)(6486002)(70586007)(47076005)(70206006)(53546011)(316002)(4326008)(83380400001)(336012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 20:07:19.8513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 875d15b1-4993-4449-033e-08db41dad8cc
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.85];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: AM6EUR05FT023.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR03MB9411
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/23 13:02, Madalin Bucur (OSS) wrote:
>> -----Original Message-----
>> From: Dan Carpenter <dan.carpenter@linaro.org>
>> Sent: 20 April 2023 15:36
>> To: Sean Anderson <sean.anderson@seco.com>
>> Cc: Madalin Bucur <madalin.bucur@nxp.com>; David S. Miller
>> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub Kicinski
>> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Camelia Alexandra
>> Groza <camelia.groza@nxp.com>; netdev@vger.kernel.org; kernel-
>> janitors@vger.kernel.org
>> Subject: [PATCH net] net: dpaa: Fix uninitialized variable in dpaa_stop()
>> 
>> The return value is not initialized on the success path.
>> 
>> Fixes: 901bdff2f529 ("net: fman: Change return type of disable to void")
>> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
>> ---
>> Applies to net.
>> 
>>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
>> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
>> index 9318a2554056..f96196617121 100644
>> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
>> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
>> @@ -299,7 +299,8 @@ static int dpaa_stop(struct net_device *net_dev)
>>  {
>>  	struct mac_device *mac_dev;
>>  	struct dpaa_priv *priv;
>> -	int i, err, error;
>> +	int i, error;
>> +	int err = 0;
>> 
>>  	priv = netdev_priv(net_dev);
>>  	mac_dev = priv->mac_dev;
>> --
>> 2.39.2
> 
> Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> 
> Thank you!

Reviewed-by: Sean Anderson <sean.anderson@seco.com>
