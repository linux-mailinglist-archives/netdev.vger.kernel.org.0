Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED5B6F274B
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 03:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjD3Bd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 21:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjD3BdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 21:33:25 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2040.outbound.protection.outlook.com [40.107.6.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF1B19AF
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 18:33:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEk95Hz+sKlDm74z72Fn9QAA5nNpYm5Cr4ocE9vAvr+b1UCAsbkUJnQywRDgsBAS3Vu24vlKYuXUCCr21/1pVqUcw0Wkc0A+EES1ECLBWMrEFeMHz1oQwmSKMgTjKk2a3UhxQu0PE55Q/D1qjBs06mccHXUdZUTyeLz/4alLYA6pYQdHbiOZdGcRm3dXbyel3zi9WOjnFvb35rvblnWpO/3Ncp3mQwJHTgoGZCX3iQfdPwNsPwVJiyvu+xXEPOrXbvVRAB5h2nf+geqs4XyrQ6koXhGYb4UnT0w8o38yo9a7cJHe4j4IDNW8GFSDPzGHX/0HLH3Z/RPkB3BsSWg65w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ha8I5u3F09R1+nZYgKkzuxTxRWAu76hfzDhi3CdOdp8=;
 b=PAGgF8WD7R5nrQmQreOzPoApzKw8r1TaXJ3iIG3PaYHoj61J/PdHpd6S/v/YpNXQexk/SIeE4o/zp0Y/BrOyuwxeLY+jlgEIDjlrnPZ8OG1gATnnSxAYbwPKul/1+gba2xqDO+DNQRSi8lMfy8+KKE/T8YEvaLEdQlYbM8Yg2UDusMAPFxC7HeQEBgp5HJ6pNGogXl767MPSx9VS5fG8BS2vtlUqXzg++OVsDjA+bE42QYqJZQ/H3+XnSufB/jvQHXSu6dOC6Yh1xaTJlqP/WDQ8atVp2koeYNMtuDVHg8l6OO444isnRRlgvM/nP2k2RIGvVmhnTRFMn/8ywHiDlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ha8I5u3F09R1+nZYgKkzuxTxRWAu76hfzDhi3CdOdp8=;
 b=RtqWvewy5DJHB/xXO933U0NlmB6rHn+3jaoJwCAifBsTeywc/IbmHZhRHuoGC3STWg1OZ4U36rtJQD0KvDRLyaIH03UgNcGfT/wgqFVOoOG2UIPuTPUG/xi1Fd2f1UMQukEeplFjRt7pDEPWxSILJ/9ivDgOc0hhPEMz2OiRiWg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7375.eurprd04.prod.outlook.com (2603:10a6:800:1a8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.27; Sun, 30 Apr
 2023 01:33:19 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6340.025; Sun, 30 Apr 2023
 01:33:18 +0000
Date:   Sun, 30 Apr 2023 04:33:14 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH v2 iproute2-next 09/10] tc/mqprio: add support for
 preemptible traffic classes
Message-ID: <20230430013314.saansheqqfn2j7wl@skbuf>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
 <20230418113953.818831-10-vladimir.oltean@nxp.com>
 <20230429174255.564a9401@hermes.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230429174255.564a9401@hermes.local>
X-ClientProxiedBy: VI1PR07CA0298.eurprd07.prod.outlook.com
 (2603:10a6:800:130::26) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fc96182-bb50-4568-aad6-08db491ae047
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AGsEZiX3nq1eCMxWFKFIkhvP5fN0YhhPBx3bibAXRXlb9uh45v7c9+KQG90kRF9ZPTtpyeSLn3kDnSiE5sbgXJ9SqYzDncXT4P5/5/TZgB1g8baQp+MYfBjsBySZTa06t+7GCbgtkkOXc5wjt3V6vgnXnSowA01A4I5HnfMLQil1RIUeqqN1bcefJ60kdLdNKWdtQBlpBnOC1xeupG2Spw1OHFSe0Yy6Y0jyLPGJoi0EirJ7JHxrdYYZuhOjoR0lwDO1HlpOZJhweSU/YDjCxvHANf/PBB/uY6nJTfJTR7NCoVgoqSrTiaNn5wKrhiEe1ODK2RpdK+7vdMe2jiTkjHitWek0Kc+N6BMO8WzdYlIm2XcTmb9X6CygKg1ehfh4vZKhBElh6FvxXI8hmMt8Mg7drwJzHSNxIDS+VRYOtlWCaDCV74JS/rf0LHtogBoylaF9kY1KQrTL6obhnBL9hRKk0g+gVkMrqmTU60DxjijPRMnErgX/yDfS9MjaBWr+zfB82CCs5l/OGT1Pc5/QQkuT6HLbR/epVnrMXYc0wkCbw3uSs+HvN0js2pqOmXxi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(396003)(346002)(39850400004)(136003)(366004)(451199021)(5660300002)(8936002)(8676002)(44832011)(41300700001)(316002)(86362001)(33716001)(2906002)(4744005)(38100700002)(186003)(478600001)(83380400001)(6486002)(6666004)(26005)(1076003)(6506007)(6512007)(9686003)(4326008)(6916009)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xC4tKgffm+mCz95BTHh2QbWYKHlakNOUlnximTdYDFUuA7TsdqLfpLr/QB3t?=
 =?us-ascii?Q?ZlztvNHkB5MRrAcLtfYpWqMwEDveVOfHRk92uqF/AHbm2Wdl/qv2Ih9h3A17?=
 =?us-ascii?Q?/pMmnVTV+g8Uzae1PvKnIdUpm7oNz0YsfIUq5oNd/UDkxTtNqxD5w2/6VHCy?=
 =?us-ascii?Q?TVbMz1Jx5H5tfYUYnxOTBZbdVA6T+HPRF4JWbsaHUhkPxxf28bbqwEGnEmgs?=
 =?us-ascii?Q?pJLm/ibkcDahdef57CCaM+BotcC0vOwSRWAQPHyKtFUx98OJx3txh38r5bmg?=
 =?us-ascii?Q?VRVvg8qMsskdQnZ7AR1BtDiZj8RCioKVvSrwQRneOiCm0DboLA8UJUeyZd/r?=
 =?us-ascii?Q?vIWnl3ZEwTYLxgRR6Wx2x/smDF3T5HEzysJB0TBMh37qjZzyoa54aQqGUKKR?=
 =?us-ascii?Q?phxpMb2zlZ0HeV5mGcMJ8mkYkkWV36A16R7K4cTYPdQPyJ7CJ1K50ZlqDVic?=
 =?us-ascii?Q?mBotiX4MWYHkFQf3JQmu9oa9tmxlPXl+SV00xqJrkMPm7ByBedC/V+moNnnk?=
 =?us-ascii?Q?zZIX07+PJ5tYoaZwJXYT5MgaeKOiipSVtRV8MxUx1KRscQ1wOM4l3BJTp+1G?=
 =?us-ascii?Q?v/gOBAwlfBSlZ+eM8RXv3G0azsqCmlhR3IU96pqZZUAnkVs6WP4Lqh9apifY?=
 =?us-ascii?Q?+Rs/5oLE1JBDxHiL9bccS0OVtj2P/vdMFPDN814EALTMBZ85aCrWsh3zbV59?=
 =?us-ascii?Q?X4fCEjNLQ/2YdX0H8+Y2/b7Xmk4J7v2iwgySnXO0ZKwOuBz20FmgtVK+z0Nz?=
 =?us-ascii?Q?mY8EWT8VBIN6xuVul6IFvOxWtq4FojnTUTrs4NWfV530RUYen2jhiC2uqZ8I?=
 =?us-ascii?Q?1G+HBC+BXlfDkCiFvJaotVbEkKh+yIiacTf+jsNdPOOc9O0gltiQJ3HMmngw?=
 =?us-ascii?Q?+84dFrn2BB9cyGJUAFegtVSAJygxpzITqPAud+Z2g3cZke5aVGK+KOseZ9B6?=
 =?us-ascii?Q?K7UT9ZoOEf4AhcyHN5Z/5581agLBJehmrW+RYUcf4B6MRWlC6QkxeudxcoBV?=
 =?us-ascii?Q?tKfflxAoFEtQLO7GwqN8/PnNVTT7jOk2dy/Ekf7ytXbkXQ9vfxcx/CeMRmO+?=
 =?us-ascii?Q?xnPVOSRUkRFe8b56AIIWRHS03Q6uNCNP9eWKD6pJyODSLLo0zAeAnYq5VaR1?=
 =?us-ascii?Q?/8LqFLCkZbgJxWF1omYoVftFNsmG2zYO1V0kJ9esHNGFf8t5ap1j2lDAPpa5?=
 =?us-ascii?Q?+FIpCn+KXq5wZti6sg5WIMKkUH9I7C6mcY36Y9Mz7G5AsqQHnSBlF7eQ7Jaf?=
 =?us-ascii?Q?LlFo1F4uhcUKWyOaPSxOrcWGyaEK3fz6xyLv0N8wpiPJBgpO0UTEo3QWJ+pK?=
 =?us-ascii?Q?N6ePGwF8+7T3VYZIzEehvBOdPtap47mJPWLfaczNuqlnXpwcgF/BJzOJ94cy?=
 =?us-ascii?Q?Oe/azM9UgSIdWv/zchaj8vp0VIi9BpqGyrwbLzHCgtOfYZWx4nE+CXZM40Im?=
 =?us-ascii?Q?nycrXwTfOin6LEsCyng1D+XrC9eEtlSVqC5U6pt/+X1gF26WZo2n/7JhxUcM?=
 =?us-ascii?Q?3w4qEmxoFSoCheZndpTJwOJq6G/aUTdXWmSNmPPgJWR7cPp7G5ap4E5uJOf4?=
 =?us-ascii?Q?omG8HexPNhMykxgiKMf2pk9zKOZbmWrMTmN3Sl4ws+8vBX0m9EeBsqBYZUOf?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc96182-bb50-4568-aad6-08db491ae047
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2023 01:33:18.5646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7z2Vpv+3+bJLZiseimL7Ui/my465VY59M+VBOyheBp5VCCysOB1brCuUF8/eGOs56tQcMn2ovcioF4DHLjZAZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7375
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 29, 2023 at 05:42:55PM -0700, Stephen Hemminger wrote:
> On Tue, 18 Apr 2023 14:39:52 +0300
> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> 
> > +	tc = rta_getattr_u32(tb[TCA_MQPRIO_TC_ENTRY_INDEX]);
> > +	/* Prevent array out of bounds access */
> > +	if (tc >= TC_QOPT_MAX_QUEUE) {
> > +		fprintf(stderr, "Unexpected tc entry index %d\n", tc);
> > +		return;
> > +	}
> 
> This creates a ABI dependency, what if kernel config changes?
>

If TC_QOPT_MAX_QUEUE changes its value, struct tc_mqprio_qopt changes
its binary layout in an incompatible way.
