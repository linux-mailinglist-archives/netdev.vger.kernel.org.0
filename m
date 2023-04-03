Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C406D42E5
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbjDCLFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbjDCLFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:05:08 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2073.outbound.protection.outlook.com [40.107.249.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59168769D;
        Mon,  3 Apr 2023 04:05:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vh9VOlWLE50AaZRqdevcjYJuERTo3iAEKiejRx2jdToSJgNSthJpwnDScI+gnvwg5rwSbZ9Ep2Lu1AIdi+PJiPOqDXkjq5K6mCACz//7iduKrhZVaWUkOogQh9fJLjCk2iswGBPOrsq67V1mEmaRVite1KxRLX2dG4FlgEo2h6dXtGwpgMsuqICGVZNQqOIFFAGZ4EGOccRwHrQEnXGOViHGoD64a5RQdmsQ2UrUM/BwlmmNF8/sPHDGkxmaFnQlgp4BqdkzFqXBqnRgIM8J5iBoyIbjQ+z/VIDur7j7I0PbMoanwtvhErT84tr3nlfj33k98XEkXN/MXsL6Xl9I9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qePb3mAdegQkxsvT8czxbk3ODWx4CXX1knMMp7eU14M=;
 b=dvh2rQvl0VHq4h7mlNmW2BUkHl+jsfkgj8V8BPsANYEs5DGrA0qp7Odd5yJWw2bs9n8d6fax4T6XPlMD6/4k0rLuluR95ep1nRbTOV++1p30fg3Ny6POU4e5+ivnSOj+AoUqEnHCqX7r3vj6VlciDjbhA1S5OM8kLwrPTuClS1m278YxNep3/5AhaA1rRdhDthBdGZqcRKC8vGD32rp4uhKJybnBQeYCr97VUdek8zVheAAUnMVVmjZ+6PMAhE+YXFosJrpEX79mp9deGOUhOHeX5dwUQmetpEaT5C3737Bjg/q7/oCiu+qh1hItrVKM0zUxyO8bfhPnI7OdHrLmcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qePb3mAdegQkxsvT8czxbk3ODWx4CXX1knMMp7eU14M=;
 b=jIbDbbR2Er1hVE4fwWC+ELm91niCeDEYdERkD2v/+yrI5hOY5uVecyHhzJ0EMBx3E4e6RzogIQaE5Yn5+cZB2cpj0vjsowBq9Xs4Ds14PebJHOrvkQVAK5xZWGVO6E7uJnmtn1z8b3ewJyIg7UBZo2KaMWM8ikuZGtTKMLD8zZU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8905.eurprd04.prod.outlook.com (2603:10a6:20b:408::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 11:05:03 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 11:05:03 +0000
Date:   Mon, 3 Apr 2023 14:04:58 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/9] Add tc-mqprio and tc-taprio support for
 preemptible traffic classes
Message-ID: <20230403110458.3l6dh3yc5mtwkdad@skbuf>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: FR2P281CA0019.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::6) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8905:EE_
X-MS-Office365-Filtering-Correlation-Id: df02f785-06ee-4b09-03c5-08db3433462f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dkmXrsmiRL4l2Ml3ySpOoMFYr2zEZAMH3Ks5ZIskLO/pzxTgSU8rBoMeiIR6kv8qFdfaMqon/AwLUiX7EHIPAg6s+Ne2UYj/s76QMgAbmQJHkeFbaLKWFS+tUiiSjCA8t97igK2gYqm8ijVbvUHrZD9909E7WI5S6sbcGetWrTi9cHsPYQTLVqPXHSZk0BwpghEo1f+EH8o2+DWFzNMg9mTooxCXwYZmlKjxRwvNB/aXCDFY36XKl6EYQuFRRkhH/0FCg3NJm44kwQyGpb/bSp1AMiUBuIIZq1ERlvme2nhUEq9ldQ68dyh0aDZPoOVsCI57RWb5TONHccU0kHKq1QvdWPRj0XEwRpxRyOVUXvH+yEFVrjvJxFKsMO2VULfSJi1HdvW2VIJEVKZ3EZ3p+CZbH15vWxlKetdJzDbClFs/X91PSpR7/dn8bzniOWTF9ijIAFinCW2OkNP4znjcLh/mp+hUw6HT5FIJRuMPAiQTtZrV7Ii8QxYvmrVZ5d1gzCWy9WQAYp6hkmWUeFQ2s4SepPlxu9jyeszVINEph1SAxZ/g+2Lz1RQva7XDcOpTGTmnDZa6F9d5n1oVKyaClg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199021)(38100700002)(5660300002)(7416002)(44832011)(83380400001)(110136005)(54906003)(316002)(33716001)(6486002)(966005)(186003)(478600001)(86362001)(6666004)(6512007)(6506007)(1076003)(26005)(9686003)(41300700001)(4326008)(8676002)(66476007)(8936002)(66556008)(66946007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h6XdGftYXUO9PvmxLIaxseYgh0NZrNTJaP1/CQ5iRFzXT+zCFPuLUZEF66dN?=
 =?us-ascii?Q?CG+XZ+iJV0FNdlHUjnezPD73nCTOfXOcAjsz9Mrn+G1Hv5w/ulESIwn50tv8?=
 =?us-ascii?Q?TtkBjBONbG+0udex15bep5sbHOFAjz5Ya1gLSO+fKL7VBzRVY9cMlwQ0x9nS?=
 =?us-ascii?Q?OxPyYLIwINhHZelDyae8H5hxC9Vc50tD8rUdXVEl9QJQdQBrLY8k+7BVcZz2?=
 =?us-ascii?Q?t0yBeRyAS2f4QX4i8O0CgJtqt5knLxQ2/EffSGluVSleHpkZhecfDxjd4SnB?=
 =?us-ascii?Q?IQeAcl903NcWXikrn4RHAIsm+tIPhZJiDZo3o5Qlu2pFv1AyxCQRjH1FtBGZ?=
 =?us-ascii?Q?wCKRu5RRVuKZp92P7xXyQIOMgrIQHlcO2yUen05SS/CpUL/CMg4eoTdSQJ+a?=
 =?us-ascii?Q?UQWuTNxo+GIsTrilDfDOx9eIQtO8dMi4knvZkUJhU5HazhWd2BsA8l92Jln1?=
 =?us-ascii?Q?6MeaiNxtdQl4FWIx/BiRW9hJf+F1AWV1SgXNzng16Ygy1sYCgstQ/iJp4qbY?=
 =?us-ascii?Q?4I/WPIyN2DcUnO0wObqVy/KRFPyvPgmrKtQkBf3hbhDUaPBJF+4Y5dnZKfIt?=
 =?us-ascii?Q?RpFdmNxysdTaznbykjT7SOqqtY7h2ADKWfw3H1XD6nglMLVP4HF9t2Q+DKye?=
 =?us-ascii?Q?OCqs42F1QeGTngQoRqV5gXRnVeIMZygF4kyxK27oCq9JSVTHl+W1F99eMoEV?=
 =?us-ascii?Q?33aPdip0pL9eI9LQcDDgfuLsXuP+yfs3JhCY+31naN9x0ds9UAutkVf8RP3m?=
 =?us-ascii?Q?GrIiZ6g3/iWq74bn/EV66QHvf9aZkB2dm+yuOVZHVtvznAgaMu3nCvb8VA6I?=
 =?us-ascii?Q?OWPBfGknyqizpyNeMUZ48wQC/Sf/HPGqqT4gRqBgr97itOn+/YR3HPSFI34b?=
 =?us-ascii?Q?WHOvxHhpVlOEIuZFT9njvRsvrAzJyc9yGRwBhbIPS+p3HkEkxLxGJ4wLTgwr?=
 =?us-ascii?Q?2xboiESZhoGymfq0jZnXiwXxvGgtquINOUmUlyzkAoLdTwi+KEdxjF+6CRz1?=
 =?us-ascii?Q?LvhId0C9cG/O543TLE4mrybA09GV7wHr1g2UIYbeqL27hkuwzeQsTjFoWF2Q?=
 =?us-ascii?Q?yLwoXxgbM4fK7ioNg2hYz6hOxFKmP/ElWY+db57IihjghLldhqS7k/EVZX0P?=
 =?us-ascii?Q?JlkoLoyZlc5oalvM/9Mx5TB8InS8QlI/tH6eiwuAH3dhL7Ld1nZhEHzftKhJ?=
 =?us-ascii?Q?lrSB+PkfXR62sxxSv09vfXAvb29M+UBZo/jYdUcA9y6RzwFsabjgPOWNylCO?=
 =?us-ascii?Q?C4RUf0sDRj2sunP6wUDnK/8Rv6wVwQI4gx5hHTdNO5aYNNOK9BG5VXacrrte?=
 =?us-ascii?Q?Hyugc4SBFmfmBd41xQJBbDa4uwonFv9yUTichmmCdZFbncP1b6PUYdGeQnXa?=
 =?us-ascii?Q?f6X3dzmYXsJztAVKps67Wm8RQuk5iytZBaHBGNRI0a8qvx+Ho4Qdq/jvnHkt?=
 =?us-ascii?Q?Te5SuNYpcikRXSvEcL2IV77t9RvPilJG6w/EEmpFJOrZi/DLGW2q6NFv/SQA?=
 =?us-ascii?Q?PG9g91lS0i/5fYbrzC2wDHytjRWQV5hhoFMg9/ERe/vLz9vs6hJ6jy8RH/UD?=
 =?us-ascii?Q?/QxI2tiOkzFtIDLu7iYkp4XzF61LLOypkFjWzRJRJ/0U5FPGvIjwA/MBZC9V?=
 =?us-ascii?Q?Xw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df02f785-06ee-4b09-03c5-08db3433462f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 11:05:03.0278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYo5LbuqCa4HhwFza6+jLszC70cmw+GtRz4UyE0trTWE70EoH/8Tr9rGP+pC/fXIK71KtsuUf163nm7vqGVGnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8905
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 01:34:31PM +0300, Vladimir Oltean wrote:
> This series proposes that we use the Qdisc layer, through separate
> (albeit very similar) UAPI in mqprio and taprio, and that both these
> Qdiscs pass the information down to the offloading device driver through
> the common mqprio offload structure (which taprio also passes).
> 
> An implementation is provided for the NXP LS1028A on-board Ethernet
> endpoint (enetc). Previous versions also contained support for its
> embedded switch (felix), but this needs more work and will be submitted
> separately.

+Claudiu. Sorry, it wasn't intentional. I removed the DSA maintainers
and the Felix driver maintainers, forgetting that Claudiu is a maintainer
for both Felix and ENETC, and thus, his refcount should stay 1 :)

On another note, this patch set just got superseded in patchwork:
https://patchwork.kernel.org/project/netdevbpf/cover/20230403103440.2895683-1-vladimir.oltean@nxp.com/
after I submitted an iproute2 patch set with the same name:
https://patchwork.kernel.org/project/netdevbpf/cover/20230403105245.2902376-1-vladimir.oltean@nxp.com/

I think there's a namespacing problem in patchwork's series detection
algorithm ("net-next" is not "iproute2-next", and so, it is valid to
have both in flight) but I don't know where to look to fix that.
Jakub, could you perhaps help, please?
