Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7DC6B7D6D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjCMQ1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjCMQ1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:27:06 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2136.outbound.protection.outlook.com [40.107.93.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987A7591C8;
        Mon, 13 Mar 2023 09:26:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4eqnrPKw/lvCcSZgMA0IbTlHBWjSSne3dQyQCU4myUSM0sFaHqVET6j/er0cjg5GTDYflRHgvG0iIQgJEw1IYgZHjN2I71/sW9cuTlAWFWMdauqB6rszeOXojAaHjTc7AftKEHQMHl+BrOt6rODW3j/nxiTh8l3bGm0go5YdoHcUHY/BGJb4q/DCjUCOz5kGGNLGh8JwQLo8Zog7U5cnDiZKVcOuAtlXnz1F4Ucr8QU+sXjvflDZb4xG5AoCyLkgg+3Hb9VLBVDPF242xSwlu4TkuUhqTgt5oouZKOrFqQeMk/ApozgcPUBfANAd0mNwfJNJdrWyjm4iq2SS6zFBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpyLIZ3MzX6cg779vmtovIBP8PYJFr2xJvd2lj8lsLM=;
 b=mwCjqKaiC9idfBibLfdWKUROKxS1jLmPBREV7zEwytZLdNUMWtsDESNiXHiSZ7MsajSlNzcgHi/j3nFCrkiRdVsyZSL4/gYuHuson1oVzoz1Z0pXGNWoC9eoRDxqmcQJlFQEPDUUdYffI7+zI0EWDISCzvevKOz5PGdl0Gsm/KGGTAYOX9HKIwf5KXzTjcA37DUF6Kb/mec89Lsd7+lkAfXYA2/+K8SG3YB+4a+lzR7USy2jUk8V5mgoq6FhiQa7mwsBpUoxZt9UOrES3yrmhKEjN/oeEu9J8lysr9xnIf7wP4atZ30L1Ecvf3k8rKkfaKLOuo/TlQZdIq3WzcA0nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpyLIZ3MzX6cg779vmtovIBP8PYJFr2xJvd2lj8lsLM=;
 b=g7XirsQRRD1ahH/nVoIa72IeC7zNa71VcZo7vDL0L6CEjPgsCCDQyIrSaPP8YfBH48W6y19IZnNVdu1cD/q10dxA7VnBq+B+jC7F9A0jvdwFfuWH2TyPvvWvzQCrh5qJ2yxtcrLpZu7EDWnG7ElaeP5160ciDgE7fJE5YqjFZc4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4936.namprd13.prod.outlook.com (2603:10b6:303:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 16:26:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 16:26:54 +0000
Date:   Mon, 13 Mar 2023 17:26:47 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] net: stmmac: qcom: drop of_match_ptr for ID table
Message-ID: <ZA9Ox786LXwyw5av@corigine.com>
References: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
X-ClientProxiedBy: AM4PR0902CA0007.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4936:EE_
X-MS-Office365-Filtering-Correlation-Id: 00a2220e-ce02-4294-f53f-08db23dfc1f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ccIwBgpRhyN+sEY5sPdNM72V4JM4kcsIUpgpQ/oHU1mmNDbyzFgfB2jEZVlvWMlKy3ZuANJgJzcFB3dIkAmpaO7EdA+Pm1BY+cmepEdHHRLAfpV6Jq9LGHoskZWqBUm+eO0693wAMIVWU+4gdcdat1ulrz1uLXRb29bt3qtEPlX1RqMH5uHMU94KKk0oX9mYbDNfH0Ye8vMtpr1SvO4fBE00FnwW+rADbQlMFSSFMaXAafYifivv5zAM9Q1HBtJvYgDiUqtchSnEAmfTyYaR9+o12Bg7M9rfXv/p3X9j0vN2QnNu2KOzaRDBDIOfnZmRIXEY+IQFpb1iQWErS8Tpn+KjWf8OmwyqN7wZddZN99RolJvUikXcxIyzaA7MEkNF3vT30+/je7BQ1YA2Bug1Fq5KDRI1YK45rWZ62NKwrymoGhEfhMTI38SFmWM/lFMKmp1TwYL7yD1ex6KJlNkvsaks6ymbEPvmEZy3NfnxEkAPh5dGccQJW57vxzKkKNp2fdF10/m0T3PkDDQBxwsartEAd0AUaMOF7J2yUcE/KjbXLBwpNO8DigkYBiAhbSSanurbrFTo5/haZhgeRcGJ9ZIA2vJpudCyc2CVmc/qwavGkmWdUAFmsP/uH9L5uoNCalh9mr3W3yM/Xp3xopKP1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(366004)(376002)(396003)(136003)(346002)(451199018)(54906003)(41300700001)(478600001)(8936002)(66556008)(8676002)(66476007)(6916009)(66946007)(4326008)(86362001)(36756003)(38100700002)(6512007)(6666004)(186003)(6506007)(7416002)(44832011)(5660300002)(4744005)(2906002)(316002)(6486002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Av73gneelTmBe2N5lv7hKw84MgpZOYDSFPns+rWYFYBh89nZHBtZIRn/zWXg?=
 =?us-ascii?Q?+G/SRIXTnbeAKHE/xHik4ETmRPNcl0nLJsljGk6JdDI2Yog8N9oBM34cYhs8?=
 =?us-ascii?Q?zAKayynTEY32VQEHhOyUFCKbFwwu/FEpwT+lxvfN7QIOZ761DM9LIs5iys3k?=
 =?us-ascii?Q?hEv5ncLEGKqdx4AShbgRoM/VbTqD6PgO5f0bZ15uxbzAWuO9D7CNllawkf4R?=
 =?us-ascii?Q?HWzubLUTSCgQTYUmsOCzy5oi0pcsFCzj/dR7TQlWwte+zByGjZ9YxKozJb7z?=
 =?us-ascii?Q?u1qjZeWYgAo16wg/NVvL2titV3uEk3m+OtQSSWqTT1rMK+lHHSchCOr5OdgM?=
 =?us-ascii?Q?jL1/PLwunehgFWyv3HQjX/zy7eHk6FmZ/EMPA4qC5tktvQfCLjTb+lRM0CuO?=
 =?us-ascii?Q?1wXds+AoxmI5gJMoxBL9oTHzi3yar2iBfABHm6fJR9812MoUEUouxPtAflkw?=
 =?us-ascii?Q?1c96DolGcUHXxnQjguikKWp5NBiav5EIuVG4DLhSjHcOSUSYhgxIDEIpY08Z?=
 =?us-ascii?Q?aRrhYXB1tseqs6MyCgyN2KdPK2amxctZHDYCpkgblV6BIxotJjm4HKErjHh3?=
 =?us-ascii?Q?SFK4FhDKjdTJXWULEauB6W3dmGwb8HnPtkRfu0dsXRw1LHyo/x3+xiJcubRI?=
 =?us-ascii?Q?Bjhe0PGOvC3cyAeeRW2SKG5BRM++o213Kp0DjAz8GJWDOqoBOjJgHYk/Khu6?=
 =?us-ascii?Q?PPHCWhSupeLTeKrZ1mwQ/SxTbhKA78UfYXdU66MobgY2vrvr3fJWBWeBUibT?=
 =?us-ascii?Q?jHjFKlQ0nxNHwFl48MWQPzGz/hp5YVHbQCZpkgAPkLs9RcE4+mhCPxqe4bG2?=
 =?us-ascii?Q?LrA4C+Z/xBK/NpixR+clElyrVUvGPhAwxgMPgyErZKey2IxE54LhnmtLSJml?=
 =?us-ascii?Q?NjOFQtrAJ4cBQv1bwUQO29lfxnCuqgajX3PVAkkMHps/74Wdmih/aCW+iA+1?=
 =?us-ascii?Q?Nwmo7yVi+aBFN4tpwMI2ximr5Pzg5dH6+TdNva6YZJHqUEdcI+DS7QuEoStY?=
 =?us-ascii?Q?kn3z5u4RwXxwIiVpXr7leJdCqrhxAz+MTMKLYMxs8VKpkP8/bI0p00iDlqmG?=
 =?us-ascii?Q?89Jg2DrVrw244aBWITBc3LXuDMAckG+xgMHHq63T3PmBwRO3jbAO9pFBcjY2?=
 =?us-ascii?Q?vNYATDvXL5P8U5eqxV3T8mE+EQ/cZCXI6q6r1TgXyiis7BVFmWDVfzPp361X?=
 =?us-ascii?Q?rMKGjpHFOEFACZezYEQsAcVWoRuhRREvVAHT41vDtByUWnMhoSVQnDbLYwI5?=
 =?us-ascii?Q?42K0NhrTXmL0BgCnmgfpOsX+g8EXvDWyMhS7I4O30WauU7+Z/kPbtIqycch5?=
 =?us-ascii?Q?e3rjhQrNrQKNLjuXG9Owwxk6rTuXgFSBNt0u31wIQXoaLBofdpUi2FXtNgNg?=
 =?us-ascii?Q?Mo+UddL9plug8Ht44DjsTx5925TQWj/Goe11hFyDFK6Uo1H0sN5fQVHz1Rdh?=
 =?us-ascii?Q?rLFhOHY2ZVn/DWO63fX0mRe8Lk9BHjucCa51iYT9LIFForR3RQ6/7rFf/A6o?=
 =?us-ascii?Q?yezib3QRP8LkMhkkCK24kmuZbSvQL8ajyum5a7rBl+E3qAwzEBumDPWmtv3E?=
 =?us-ascii?Q?YONlVCfViHK/oFhvQoRxx1Pub2NP4BcKJZLCUeVxpvYDd8EfXmmsmj2bRN31?=
 =?us-ascii?Q?INDzzmr7nW3GRcZxH1mmX02g3rV3kF6nRr+Xyimz4qzwuAToWRB3Nqr7z/mq?=
 =?us-ascii?Q?V+Ypww=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00a2220e-ce02-4294-f53f-08db23dfc1f8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 16:26:54.3616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8vjDyUF8I80r6BxTxxI0E5mFjIwhX1mQkNQ3V3t7sMKBzFzJ8fmkxlkeX+Wr1UMhai9GBn7TXPIRfCjlUENE5N9O1/2LQLoiDJs22zDJCok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4936
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 10:46:28PM +0100, Krzysztof Kozlowski wrote:
> The driver is specific to ARCH_QCOM which depends on OF thus the driver
> is OF-only.  Its of_device_id table is built unconditionally, thus
> of_match_ptr() for ID table does not make sense.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

