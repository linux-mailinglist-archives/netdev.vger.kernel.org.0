Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3AB6D45DE
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbjDCNcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbjDCNcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:32:07 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2070c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::70c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474E7EC66
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 06:32:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LD81AStjQt+AbMkc7xghD6YDxQQqMyOGeCmoZCcmwgCr9EP95beG96VfkWKtDeoV2nlJB5SAdNN3cI2fTuaiqDafLBrjWCR9tWNumlukG+YBkXdOktjeHtnYQXb6gQtGKCWLDXyp3oG5P7YLjQkVqC5towGZVAm/hRUYWT9WK0P2gLSJEmPf6nSZiMXNTOIKYurZT9BKDC2uDubJ29HzTgaQG5YBXSPE6Grmag1ElmerMDlszVma+wg9nzcM4L/d4yY2lXiPczRb7kZ43Lh1IF8rxpUVGnliBj0cm4Jnfv9vB2hAu7yWNbi/sWibNcg5I8Tika7qH3acUmqkJXqnzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DjRr9gamG9JL0nmi9wSSQllI4eaxsTCMkS+gTmqGhRM=;
 b=Irr1XkI5/JbqShdi/dc51PSvgZ1yAY1th0Q0bSlfheMYutON2i4wwsAopF9mq2Xb2CUm4byIpbNtWjyH77dT8laxqPRk46+Xu4lqLjev6LA0NOg7KH9RuBf6aDpNsry1/1+0Qgdhg7D7Gub7v7pVN7kPGUW9ne4LMHZkuXUPCnga/ou51lxWJKtRvG8/vhgpqbIRCfXUB7cr9xVIaVRigDZodMOtBFaXxBypSfqPQSAYkLBriE46sIJckoyJywfjDsyjzLMiq9GkMEWv/95O5H2Hw07QS1FmVqK+HNrwsNBb79gsfq7/OJ0ld52eKuH2dIUQpIRxRaRvY3A3wKOCvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjRr9gamG9JL0nmi9wSSQllI4eaxsTCMkS+gTmqGhRM=;
 b=wO8Mpi9out4xt9bQEIQpV0mXc38mI+NMfOy1r7AFdI+2k3wqVGiS+X8h3ZTc/5YzyLr41ihkcAL76HUqQgnmgMKhOJT4u5V6CeEm+aSzC7yH5XV+6D1D+rX05Rz5eM/jCy42lP/+E9rW/KJ/qyDUdri10hSEQlb9axI6vySCwHY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5075.namprd13.prod.outlook.com (2603:10b6:208:33e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 13:32:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 13:32:03 +0000
Date:   Mon, 3 Apr 2023 15:31:55 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Zahari Doychev <zahari.doychev@linux.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v2 2/2] selftests: net: add tc flower cfm test
Message-ID: <ZCrVS0aDDx831JCY@corigine.com>
References: <20230402151031.531534-1-zahari.doychev@linux.com>
 <20230402151031.531534-3-zahari.doychev@linux.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230402151031.531534-3-zahari.doychev@linux.com>
X-ClientProxiedBy: AM0PR04CA0097.eurprd04.prod.outlook.com
 (2603:10a6:208:be::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5075:EE_
X-MS-Office365-Filtering-Correlation-Id: fab15796-a5cb-4a6f-eff5-08db3447cefe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2BLMEWlMNQIh5JTimqHewBesgdcSkfSJ2Qa7FibWErhq5nf+1eZ3NKS406OIrQJYPhtUOeH/+Rc0Tp0Qg9WQvIWwp2ZtDDOtEWdHTxq3J6HxwJhqiN7xUa2HaXxHBwE63TedAt4NLy8RFtp+dytY0NjAbQVen6BepKqhtCrPWOotX3tePRPaDnpyjoiIOkK2tfRWbZmG8Ch6rlPdBQSfKCuaKuxpibzISWwwS69iiBUE6fltZyzVIffgFxIAC9FCRlaOTcC8IAhPLJmAQuucYz634YDKWLOpe2y5a3A5IoiYHDoF6Ra4FkVeXX+fbdsIq9xUSYkEmqGIzy7hzfEXrGOgP1+Bhw5vVS0MYbEdShi5ZbYXTLX6DajiRmOe9j+e7e5l03cNJEz/GEItkqmGpMaxs9LpwICnN9exo/A7iC4AuC9u2thkc/fzJFHF+u1+ZPyn0zTt7N8LFTgljoYIA7zbQlf7D4EtrZ2dmUIDtMGO3iN/k/LGYDsBMOUsszTPOl7iP0ZQosbUsFr030Z/fzOopTN5jQBYYRVhXADBs0otUi1VFxv9eHcLwZdMKnZ7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(39840400004)(396003)(366004)(451199021)(36756003)(6666004)(6486002)(2906002)(4744005)(41300700001)(6916009)(4326008)(6506007)(6512007)(2616005)(186003)(66476007)(66556008)(66946007)(8936002)(8676002)(7416002)(5660300002)(478600001)(316002)(44832011)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mlwr+Aw78mwL4pShbLMDIDMfw1uJOvMKZnPA1SAqub8Kp3w6U3XaFq8VgjYh?=
 =?us-ascii?Q?QQ+WDsHttXsJ3u3zP0jqljkG6smoixnCatRYPnFP5sJwuu7HQ59DZ6OP011P?=
 =?us-ascii?Q?vJ1H0EHdij8QJtYcVt+e/IZu9a3hkWHrSOGoWpwJYepxm7TGUkEMGIgY6UGW?=
 =?us-ascii?Q?81z+ci8nHK6InBxooC7pmGpyvjnXNHvnxx5ZZrCfUAu8h9K4nhLeURkyj1gV?=
 =?us-ascii?Q?Apf06SCp9GRLFeHi+hn4plZplHKcRvjONs+kv6zB5vcm0ubJQZoz7Nu282kt?=
 =?us-ascii?Q?qjP3B9JgLfVe19PuO3MZCPRflJcPld8mKA7ZK831ph2bSOHH8e2ADs1m+g7T?=
 =?us-ascii?Q?uUxL7v2Y2SGuRPuN9GzMZZuKisZaFGZkkQiYVOIZeao1bhxk0n6GYDWTrWuM?=
 =?us-ascii?Q?L4ApGm3pMnAxyes8FcifD0E4KE17e4N2Lvm3VbkeYJ/Y3OWk4s8L2mi92zsg?=
 =?us-ascii?Q?MWMmjyFVRn/awCQutHCaRp7dXtKkNAcA0JYGtonl2+pIosTtSQzT5Bqcpanp?=
 =?us-ascii?Q?jdsZVaSi3LNWwfRRZJUk211iKM3mt77BZUCaEfNfM88t2yUB8p6dgmmn/6LO?=
 =?us-ascii?Q?SRKLJZ3k3DIXYWMSN490qR/Lk91lsketN2bwYigmQhn6eJlDiwz5kVWyyfjs?=
 =?us-ascii?Q?elMo5xsLoQgYxh9bUNOU60IBqQzYHF/ELQyQeDqDi0q6KStcHsOVaLl3X2Um?=
 =?us-ascii?Q?pWwpwKaAizdAP7Yv3yAL0dK/D0QF5zJUt//6cvvKCdXlmrhswl3lziH6FZrF?=
 =?us-ascii?Q?FhMPtuNcwlV9Lnu19ZgpJPe/EED3boOtHOpyvIc/dBwbadM39vyShNd0toHj?=
 =?us-ascii?Q?JhCSSID4gxB+0ws7nZKoURsmq0TB3rgurpN9QHMPikOGF5b47UrLbTMiZwwW?=
 =?us-ascii?Q?JwdtuTU9HAyTchDFWiNs00UKSKHTVLuSBrKgVYVGORMoftSsh5pG2iarz1Fi?=
 =?us-ascii?Q?jCsVL6fy4reQpsybnTsPJFdVzeVSwhS/odhmpgcRd53MXJ766n7TyA2+2oV/?=
 =?us-ascii?Q?+SiKjBtDDGV01/NfMaFy1qEVUcA77HAwm2vo6n5g3KKjXB9zhqxWtzPGJ22O?=
 =?us-ascii?Q?MhaWgCt03IsDYbxkz3CARkUP33DnvDOVIffx60UDZxVqXAB079JaHJbF7TeT?=
 =?us-ascii?Q?6Y/Afd74Jy1vUl6+LYg8LYE1qzuhv1SqkcSZlJqtyMru5ADS29PcizZhec8w?=
 =?us-ascii?Q?dCDJDOH2kQ3TNryaDhrbhl1DoS/zWbIXy10TkIiu9xH8k4KL27BAgyr0e3jP?=
 =?us-ascii?Q?NADlVhRC3ha8ZC4KVlqYXM71uQRBgO2v5XHdYCeFe4wyXayuZl1KqYU47pHP?=
 =?us-ascii?Q?tDGa7XkhXbxfV/J4oWleQZTD7FW24F4oEPTFCd0VIKVcXPE+bbBAXM8I3zzn?=
 =?us-ascii?Q?43ah66O9cCoNXo+CPRqebCLrb1euwjwlGYx5rjoI9ewqVMtear74eDwFCDKo?=
 =?us-ascii?Q?La8k1r92l5co6e7ipEmZjc6oo2bYp5QXTdkkcv87F10so9rFizKGhfJD1KuL?=
 =?us-ascii?Q?U4nNSZlkF1GYX+StlWWzWaLrjYhUmkSdWExXzSoNCeTQqBnvjlbpnp2L6Sb4?=
 =?us-ascii?Q?1u1GZRlLuAkjBZs7WqPxZNiv2cB+Zkp+dkmo9DH2D3FDQjg0i1h1Rq7t47AN?=
 =?us-ascii?Q?oqjpqY+PLZw3/M7w071jfioUNA8zWavUnetIrxtyhJtsssfbF3xlloiBquAg?=
 =?us-ascii?Q?8LF7dA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fab15796-a5cb-4a6f-eff5-08db3447cefe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 13:32:02.8600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2CHTI4p4QDKi6OAnXqqowFPEjisdyPZF2zBi0qJno+LD4z5L/GXmmK6dpTEN4ocwkfRXZFkS89YtdK1QhCOq3QGWz2TzxZJXKjgYahHQWF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5075
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 05:10:31PM +0200, Zahari Doychev wrote:
> From: Zahari Doychev <zdoychev@maxlinear.com>
> 
> New cfm flower test case is added to the net forwarding selfttests.
> 
> Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>

...

> +	tc_check_packets "dev $h2 ingress" 103 1
> +	check_err $? "Did not match on corret level"

Hi Zahari,

if you need to repost for some reason you may consider
correcting the spelling of 'corret'.

...
