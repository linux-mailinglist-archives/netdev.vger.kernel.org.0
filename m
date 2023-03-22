Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28ADF6C5534
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjCVTwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjCVTwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:52:44 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613D862843;
        Wed, 22 Mar 2023 12:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/q5e8NKMjlTtL0D+n/yvOpbvNl+BzKt1vnZDtCuPyRM=;
 b=p0GhG6cAKrmpRMUcQgoaDoMs7iifq8vLIzG3iPDttr3HIWcbLkKyUOCCJRX7t4Tn7GpbhxVDWP9Xmgar2cwMgCCxdLa78C7NI2ItHPPGezYK8SGYZmli5Z6noVTNwyH+hUll8nKYxW3UfwNs2WaKPYkgQLSIgmqm9nXJw/oGgXKsoRdRqs5+kEh+WEBktYUAzXmSb+y5ocTgFmteuLHR9C2T/9nIJyzd5ap6PA4BHXbwLArxumc1/CCrzgY992BCr/e2lI1aK84kQU/YiX2ZHLG0V6SN+DSt2wplSNf856h2eSARQygVGcaaTnDMiLfnHIpX65ddpCfW7p5nNKnpzw==
Received: from DB6PR07CA0094.eurprd07.prod.outlook.com (2603:10a6:6:2b::32) by
 PAVPR03MB9359.eurprd03.prod.outlook.com (2603:10a6:102:30b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 19:52:38 +0000
Received: from DB8EUR05FT060.eop-eur05.prod.protection.outlook.com
 (2603:10a6:6:2b:cafe::a1) by DB6PR07CA0094.outlook.office365.com
 (2603:10a6:6:2b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.17 via Frontend
 Transport; Wed, 22 Mar 2023 19:52:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.160.56.86)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Pass (protection.outlook.com: domain of seco.com designates
 20.160.56.86 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.86; helo=inpost-eu.tmcas.trendmicro.com; pr=C
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.86) by
 DB8EUR05FT060.mail.protection.outlook.com (10.233.238.218) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 19:52:37 +0000
Received: from outmta (unknown [192.168.82.132])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id 9992D2008026E;
        Wed, 22 Mar 2023 19:52:37 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (unknown [104.47.17.172])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 8435D20080075;
        Wed, 22 Mar 2023 19:42:49 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOhW4ENlk37ZQQvxW9+CbYnwZ0deeneYnRsMBFUwme8t1x4dXiy2RU1nyu4ENA6d+9LCBhXdvR+EH8O+rexs4rWakvuiJE/p9T6DsVr+XU0vQ9Rv4zjncHqdk6SwPMjNg4WRAEtbq+GS4eh5R++UXBUa3Qf4KLSZ8QLE9AdL42m6ntj10miS2B61v2tHzmOAKmU+wewQ/BAOF5cdDevNZy4LZtVJfheRaelk0/WUjpMTlW6OwU7LY8a9a4eGBqLWDP4u5R48snPya5Je2Jm8YLGcfcrJVlQQWG6Ux2cuB98NM99Fx1Xse/GgskEqapzgPvKALqJCflxgGPxmRvY6OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/q5e8NKMjlTtL0D+n/yvOpbvNl+BzKt1vnZDtCuPyRM=;
 b=VQ2ylNS1sElwHE1kD/bymbAqbW027t1zwI/dODOe0roIqYNGVAocIuaTm977O3wuuhPD2bof/PjXlrxZTHCXhPrBDt4dQfBi9F2nA0CznBIaegMJvIbd7E0XVnd6WZ9P8dNVq1uSh/O71Ndgkzy0ZZvrZ+VBxHqQ5F4I2Ve5YK8r9ZmENbHA5hy8Bv1bYSGtIzcaVap3A7pLCRm9r0aM6lCmfXFeJoHgnZ5hwXGUcIwUwIZpkvVW64NakbgBdZzfJpBgyABZGnuWB++Arw3AHkff9U7RdRQuX9HXEMLqYFI//pRkjEtm6meY+HerGifvKs327bMrIv/KMbMOtyXPsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/q5e8NKMjlTtL0D+n/yvOpbvNl+BzKt1vnZDtCuPyRM=;
 b=p0GhG6cAKrmpRMUcQgoaDoMs7iifq8vLIzG3iPDttr3HIWcbLkKyUOCCJRX7t4Tn7GpbhxVDWP9Xmgar2cwMgCCxdLa78C7NI2ItHPPGezYK8SGYZmli5Z6noVTNwyH+hUll8nKYxW3UfwNs2WaKPYkgQLSIgmqm9nXJw/oGgXKsoRdRqs5+kEh+WEBktYUAzXmSb+y5ocTgFmteuLHR9C2T/9nIJyzd5ap6PA4BHXbwLArxumc1/CCrzgY992BCr/e2lI1aK84kQU/YiX2ZHLG0V6SN+DSt2wplSNf856h2eSARQygVGcaaTnDMiLfnHIpX65ddpCfW7p5nNKnpzw==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DU0PR03MB8137.eurprd03.prod.outlook.com (2603:10a6:10:32d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 19:52:28 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%6]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 19:52:28 +0000
Message-ID: <e17fd247-181f-ab33-d1d7-aafd18e87684@seco.com>
Date:   Wed, 22 Mar 2023 15:52:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net v2] net: dpaa2-mac: Get serdes only for backplane
 links
Content-Language: en-US
From:   Sean Anderson <sean.anderson@seco.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
References: <20230304003159.1389573-1-sean.anderson@seco.com>
 <20230306080953.3wbprojol4gs5bel@LXL00007.wbi.nxp.com>
 <4cf5fd5b-cf89-4968-d2ff-f828ca51dd31@seco.com>
In-Reply-To: <4cf5fd5b-cf89-4968-d2ff-f828ca51dd31@seco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0058.namprd15.prod.outlook.com
 (2603:10b6:208:237::27) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DU0PR03MB8137:EE_|DB8EUR05FT060:EE_|PAVPR03MB9359:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d8ce1da-1f8d-4f14-ba0e-08db2b0efd23
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: kTHKhRR8EJRo+drE1xx5OPQToMNq5moS5RnFCVkZkWm/DqFhjtNZOCrKpuRoja/hnxROxfhFfvljycLcAYFzYPDM/FhgsODY6Pf8vUnoNUInvOOwtBK/a/WIkqX1/x1CprosJRCbYOQjpTPX5q2yPSjPC1vU8qyx9Ek4e9gb/ywVl8gafIOMwlPlSfXygP8c2ZWuxkKQ+rYBsebcnxhO7kMnrnuIZkir3mKw9F433Qb3bsiO44Hz68ahGZZ2GXrnBV+4l1iLL0azByteF/uhXFc+tDCLe70Id2TN0chZt4mrW2U3kjbbw+oO9WlvfrGr9bIXomryJikN505Tc2l55dVutTwltgF6KrlCh8pTsClwTlxANR6h9ON7XXvda6KvpT8TQZ1mA+O9HuylM7gxrrGksx9c5DvofYPPBDRVZEDomh06gyVjkSJbICpIoBqN1tGtU5Hi+v4zGLmUfhT26PGPfJGhjda/xbJ3bdV8j4c7EvVVmoiKMd3ykNavOIWZjJ1zwdvFc3tD9ZddQ6JHoadu0Sn2J8RSESJHSG/mQAqZiKtKVj79i4p2XGVdtYPBTDeHmT3uNG7dASHOrT6bjczrrm1oJLIvIV3DCHdO1hGSE9o3oeGjuornwqGhHiVmcO81Z/XlineeY3KLD/peRuWGGSuLWNyS0yNKuuGDDb5/PEk55LDd9hwkVHfB+9oGv/b6MRWcNJjKvrZyd7qUpwvxC+fU8L8YLgQZRMLfPM962xBXHM0Bt42uZgPCH+pUSd2M6Qw0b+6TApDDmkGaqA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(376002)(346002)(39850400004)(366004)(451199018)(31696002)(86362001)(36756003)(52116002)(316002)(4326008)(186003)(66476007)(6916009)(66946007)(478600001)(8676002)(66556008)(53546011)(2616005)(6512007)(31686004)(6486002)(6666004)(26005)(54906003)(83380400001)(6506007)(38350700002)(38100700002)(5660300002)(44832011)(2906002)(8936002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8137
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB8EUR05FT060.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: bce182a9-2f0a-40e0-b4b4-08db2b0ef71e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6wtvR17Xxe3QJ3c/JS4QOrVeiFj7rBw5oUCeOpte464Jk0szq++M3flq6UIONRqehMeXJgJRKaWRhubE/nci/nPda/Y3Bt3nrfI0hSjU9beQwuAdnkGTnrrI74efX7xPblOIVI9oqXcPoSe30XD8FozzOXnq5S5gzxfarvvbcgoPT3tsZl2Zw/3w/RBSNVxc83ejNEd7FAiOAtXA6toW4xutHRzulhyaBwJI/xd3gvag9TDpCtOhtKkVnPkI/GkDXQOA6VL2rEYfR9tLfnc9/BPhT2WobHuu0uS9qfKHZXwtb2kyuxJ5MHmMhvmzQTZYS/aqL1kmzTekQILQg7/rT02J4ftAOJDafnxRQeQ6G9Iacu7p49rFI+qRkRvTgG/utbJmtWh9tYuSJCYsHifb1zSsWv5FZiORspp0wIdKqkLBS8n4ttbEFQcK8nBUjDkqmP9Ru6nA0gXPx+OHzTvL0Z/+ZoHwlZxfgsqYsqqgwQ+U8xKYyDvCjLA/oWMNWMNk5/Cr9xKJUGZxCzvLTIgCdhBOlAYE2n/84bynZr/SUw7n60O9j4/0d7HEXdaH8dceo0dxnFXy3eJ0Vii5PfRlFWGVAfyqvSXiKa0keTtdGXj9hxm2ro4ZjcyE3HoMxUNVlS3yu3UuSjxWQtQPS91XgwjMjotg5hGcG4XT5frgZWZaniaOrgMFVgxb9yMR+oR2IlCq4kM/T5T8dMej66lRjSnBvYdbL20LibAai4EMg7wLqBs/sBC+bQ5FCQpohUPnRhLXtcjkNNQ5wGYeqvdkrg==
X-Forefront-Antispam-Report: CIP:20.160.56.86;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230025)(396003)(39850400004)(136003)(376002)(346002)(451199018)(36840700001)(46966006)(40470700004)(36860700001)(356005)(7596003)(86362001)(31696002)(36756003)(82740400003)(4326008)(26005)(44832011)(2906002)(70586007)(7636003)(70206006)(5660300002)(8676002)(8936002)(82310400005)(47076005)(40480700001)(186003)(40460700003)(336012)(2616005)(83380400001)(41300700001)(6486002)(6666004)(478600001)(6506007)(316002)(6512007)(6916009)(54906003)(53546011)(34070700002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 19:52:37.8633
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d8ce1da-1f8d-4f14-ba0e-08db2b0efd23
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.86];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR05FT060.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR03MB9359
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On 3/6/23 11:13, Sean Anderson wrote:
> On 3/6/23 03:09, Ioana Ciornei wrote:
>> On Fri, Mar 03, 2023 at 07:31:59PM -0500, Sean Anderson wrote:
>>> When commenting on what would become commit 085f1776fa03 ("net: dpaa2-mac:
>>> add backplane link mode support"), Ioana Ciornei said [1]:
>>> 
>>> > ...DPMACs in TYPE_BACKPLANE can have both their PCS and SerDes managed
>>> > by Linux (since the firmware is not touching these). That being said,
>>> > DPMACs in TYPE_PHY (the type that is already supported in dpaa2-mac) can
>>> > also have their PCS managed by Linux (no interraction from the
>>> > firmware's part with the PCS, just the SerDes).
>>> 
>>> This implies that Linux only manages the SerDes when the link type is
>>> backplane. Modify the condition in dpaa2_mac_connect to reflect this,
>>> moving the existing conditions to more appropriate places.
>> 
>> I am not sure I understand why are you moving the conditions to
>> different places. Could you please explain?
> 
> This is not (just) a movement of conditions, but a changing of what they
> apply to.
> 
> There are two things which this patch changes: whether we manage the phy
> and whether we say we support alternate interfaces. According to your
> comment above (and roughly in-line with my testing), Linux manages the
> phy *exactly* when the link type is BACKPLANE. In all other cases, the
> firmware manages the phy. Similarly, alternate interfaces are supported
> *exactly* when the firmware supports PROTOCOL_CHANGE. However, currently
> the conditions do not match this.
> 
>> Why not just append the existing condition from dpaa2_mac_connect() with
>> "mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE"?
>> 
>> This way, the serdes_phy is populated only if all the conditions pass
>> and you don't have to scatter them all around the driver.
> 
> If we have link type BACKPLANE, Linux manages the phy, even if the
> firmware doesn't support changing the interface. Therefore, we need to
> grab the phy, but not fill in alternate interfaces.
> 
> This does not scatter the conditions, but instead moves them to exactly
> where they are needed. Currently, they are in the wrong places.
> 
> --Sean

I see this is marked as "changes requested" on patchwork. However, as explained
above, I do not think that the requested changes are necessary. Please review the
patch status.

--Sean
