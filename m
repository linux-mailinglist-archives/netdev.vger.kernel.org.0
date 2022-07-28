Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DA6583933
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbiG1HE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234776AbiG1HEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:04:10 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36D45F9A1
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:03:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8Vlhd7oeuBXwx5WqHbD3sCr4l2qg4CFxK0igceHs6XqcP+GeCSD3/keNvUJntv89lzgib6vyMwIGVoigSPSS5VP5EPrSBOV59NjrXqR0IjaOdjx2z6Lr82cuVRQPKN3844+4RajgHf7SCV2PMimASzwkijgq9DLQLxZUhDmDhqYoRMKBEopRaA3yJ7g54Idm35vHOVrYKAxP04JbfGqpHrWJphVwfmY7kZyMLRsoXFOoOD4ELfjh5c3cN0g+yhrFZuAdNRHUJRp9qIHaoQ3KbibId6OBZRzIsYlYI7AevmfeqNXbXxvUXoYTUBxVox2jcYJOQVKiko0Z8dMtg+Pag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WBZ2FQqTVbaW2X34SczyGpnPRfWoUvRAt6g5nL6ff18=;
 b=c/JjkA+H0/qCHvkkMV55j8vga9yDGr4I82V7gOWcbdITTDTYG7iNu4rMyDojYDN22jAkksWB6HpNKgRy76TnozrfbZClKfaJNLSiSf0puGrnw0ZI6DbMkZnyQ/EJF5lWLFD7TY9HC7QFHICQ2LECgkAa6GjR4BF+IfXtRcZNKSpAKC3BV9afdgufmOqDPgNMQBR6Oldh/V/6Xw7wz9HrbtM25tFtBTMVcQQsIiwUyiJYn5yKfehZngI3XnDxvkxxkowE74WcaO0+xjfZ+YdmpU2rFAai/I/5229CNSaAYulbH2q38Mtjv6Lm7yIrNGwi4PnoilErE4jzHRU/6fjjYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBZ2FQqTVbaW2X34SczyGpnPRfWoUvRAt6g5nL6ff18=;
 b=cwE4g/mrp+LeJTKtG2GOvM+Yfb2SwuwibdQCds4EbshGj/c1vPdpy1h0WPky2RTit361CZus/C72hC80Qg6QABLKJ8/ETuqXsTOsPRwEjG8w9NXaNjTmJA4JEPI6GMpukzFbxHr0nSgwm0bf5Wa99UiyQ0u6y9F9O1H4OUvHWe/SkABJ9Cs/732hpYCNhO8qUbh/1tNeGkkt1mT5T25HISLnJVQmYzsVIbwhcSzTmbgJMxBUH0EsFSAMDkvs1cdwCdV2ce558kwXpgUnFx37V4DjmTurmLth0b3rwtRAx7iQRr1pToPBQbYOVeIGSpR8/NJeqBN/SwE/ufp9SyhO3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB6111.namprd12.prod.outlook.com (2603:10b6:8:ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10; Thu, 28 Jul
 2022 07:03:24 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2d48:7610:5ec2:2d62%4]) with mapi id 15.20.5482.011; Thu, 28 Jul 2022
 07:03:23 +0000
Date:   Thu, 28 Jul 2022 10:03:17 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 0/9] mlxsw: Add PTP support for Spectrum-2 and
 newer ASICs
Message-ID: <YuI0tWAXDBE5joAl@shredder>
References: <20220727062328.3134613-1-idosch@nvidia.com>
 <YuFIvxvB2AxKt9PV@hoboy.vegasvil.org>
 <YuFPYS10iXdco5rM@shredder>
 <YuH9+/7OrCLzb8vJ@hoboy.vegasvil.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuH9+/7OrCLzb8vJ@hoboy.vegasvil.org>
X-ClientProxiedBy: VI1PR09CA0176.eurprd09.prod.outlook.com
 (2603:10a6:800:120::30) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffc6fbbb-f334-4cbb-ed1e-08da7067431f
X-MS-TrafficTypeDiagnostic: DM4PR12MB6111:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHf1YzKVyjl4QIvDlZo5E4CJTQ9PhkhmGErbBxXK9LxKgJYAkME2bwKd8ICjzWd4tmEXgMkWxecTGQnthdgjW09xBcNeUsPu+ia7qooIVJpPjfuUuBsNw9NhAEwMtcG+8T2i4cXyenZneywUWW97QydAFl4RnYbys80aB14qSG6k/cP4kWr1soZYDd19xMyIeecSMayk+xMP9sGAmDPAhLAaQNpMcoYO8yla5TuwH3is7wKMCvIj52vAMA5ZSYAxNufDeCz2ImwQpgZhTFk7TofGviYkhP12yEEyrqDSvTTkNvgArVH5FADAtfDtX+ZULzR5nxX7/qfVS10QzITHlVlZB4IYAsRTeZG7MoJntU94jtdT/J2seXxxP7mM94TYqJT9Enw9LBA2JbiX/xmmsrUVQbKoD3aA1Fddb+it/hrkb07HXtsEXPDRrE4nxprkEGF8Z82oilURp7Z6+pF2nTOy27VgCyasF0ydR0XrxbDoItN7k5UqSv3JbJIwx59LEbfNGX4nvqfD56ndOetKJv2UzzEEkOaD6lnCnlivsexUiBGHzGK6cscmhGx7LtsGmGvZgqHGLQ029hgxo9Exw7aVi6YxhjsS00HXNZeeyL4fPpYcTzKQjBuJlwvWhbw5BYC/sCstn6KkMXoNLKxSm8E9yqJnL5G/cDCfvpnCRddxErJqH8usJwgvrpHQ0cvlL/k+U96gGIXsolXAUoPdUSwBrsxbmImUKJA+3fw2Ok80Y1Dva6mvgvAiMZAyy7q3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(6916009)(316002)(38100700002)(33716001)(8676002)(4326008)(66556008)(66476007)(66946007)(41300700001)(478600001)(6506007)(2906002)(9686003)(6512007)(6666004)(26005)(186003)(6486002)(83380400001)(8936002)(86362001)(107886003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yQxUa0i0xOOSKs1oxqLjTy78sf1VsTtc3bHuBPRPmWxwUkvaDhF9liuzzS8c?=
 =?us-ascii?Q?NJmsraH7MxPEGq9MqpbTCulADuf2psF755M+9akW+kmZ6zDDU6/BzeZqq0oQ?=
 =?us-ascii?Q?aeSxM5gduLV5Ja/SAMlNwn1SMEynD0jV4VIyxRqUNjs07KMe21E5ThoJGC/Q?=
 =?us-ascii?Q?W44HfhCG30lt/BL+paBWflx5wlJa4i2uhpbyF/FH2gYYAhtBMsyU4SipxNpW?=
 =?us-ascii?Q?88KlKcuHOOwZ+9dI2tdGdKdbmtLamMVweCRyvNter7zYiJzUwb5vfXkDYNKB?=
 =?us-ascii?Q?q9f0XUbV/qnRBNzHfm6d6WY50oNchowLR5FV9Idw7KE5S0lXvv1Oq5rTMO8x?=
 =?us-ascii?Q?udfpXyEZY/5K2Uc7EWEearN9eBWa8R0c4MnVV9LktToZVkoMYFQ8FE4hBLpy?=
 =?us-ascii?Q?/xypaF2/qUm56jwryoQJkTDBb7jALAJsTfi6rV5HD2uicjcDnqoHix0ikfp+?=
 =?us-ascii?Q?u7u0pXorxOlBa4akPOJLzThRYoetZJdvsJgbGWX2xWGE1UXbrpG52X4pooaX?=
 =?us-ascii?Q?sPX2b22sRRG7uvON+mn80udAtPcyyA+J858Fyk5KXC7BXGJbkqY2MfM35Fo7?=
 =?us-ascii?Q?713ml/gAV/b7cbLjIDACg6nCLpwpUy3grFoHoGGvOLynI5OGzwQbG5WJczSo?=
 =?us-ascii?Q?G1G0VHpWvwa+BdCPeo+6zbS02kgY5vJE1Pr9LwvdFRlfcbCeE1N19+6Uj2KU?=
 =?us-ascii?Q?5IqjdBcQBfwZdkCi0VQkW50xfwyVk+H4CTWaBkUdka0WzLCabCRCVYcGIyvJ?=
 =?us-ascii?Q?7OS66PyHXXVd1r/6ZgnZAAZhb2XLV/khcxk4GAbJ3hcrFMbgoCfDbuWgfsEu?=
 =?us-ascii?Q?LgC2BMZYVnJfT4P93d6uV2whfB+/ABN80vJeZ/waOs+YFx9jm2ODFMNFBg9R?=
 =?us-ascii?Q?lvJo8SjlpsvgyKaFEajCDRkhkFaE0LzIDrW6douYJ4PbSO6O4ptuLIO+y9CY?=
 =?us-ascii?Q?Q73kOKWJhoxhBw7AfgwJ2p/CSUhwkTkWj33msahC3CjY/kppKoutrGKXsCrO?=
 =?us-ascii?Q?CW/Mq9pLT5T3+a4g7Jr/vYiq7mM39x47kgdiBXy8wzwqm381H6iO39WwJIX4?=
 =?us-ascii?Q?nWjYP1Zz9n7JR3cg8JdWsYVwHxPzEzSV0RCN/57ZIYQordxkD5j2c51wUYAh?=
 =?us-ascii?Q?3sYphO7BW/HfYwNxIO1pYKq9xTY22VUVdwVHHvotqD8rRo3MJHrhIsvzQZoP?=
 =?us-ascii?Q?4pjOWodObJerkNm2hQ+fZVsAQJ7T7J35a2emUt3tbM1oyHZUhjFlz6PqTmJo?=
 =?us-ascii?Q?i/R4NFAzeyHZx0JossJkylntfF63haBgr4WuduvB7N4sc4Yv8gJ2F0icv6Lv?=
 =?us-ascii?Q?0sTwpr4OANbkhD+T7OdVBxSDJ1F7DNBL3yUB8lNfZIfDoDELfoOIYsi+4/FH?=
 =?us-ascii?Q?ZkmHUwaEJh9Kum15xbGmTocLyA4gH/HsgSNfIvdm7hhc08EQke3nP4tK3//C?=
 =?us-ascii?Q?k1Os+QD7LzZ9jGh4E0u9IBsOrOplbbjU+gqBunw7RvcuVnUvG0lnxLHRcPiQ?=
 =?us-ascii?Q?R7k2Gl2ZDH9OO5ONFVdmjogFEewa6VsCM9YTWk5VaEL0Fm+Qka9r/KFBN05L?=
 =?us-ascii?Q?d0/8N3N9oHbB5IwnuP7+lFG/tlO+udkdn5CHa5mb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc6fbbb-f334-4cbb-ed1e-08da7067431f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 07:03:23.8017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tGmI7E8wikflcxFbxgqm5++f5Hu4z8oqbHZeptwwKYfhM6v1NusM+o6puTriqGmkbq3LCckdcfWz2t7nJ6drEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6111
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 08:09:47PM -0700, Richard Cochran wrote:
> On Wed, Jul 27, 2022 at 05:44:49PM +0300, Ido Schimmel wrote:
> 
> > Right. The hardware can support a TC operation, but I did not find any
> > Linux interfaces to configure it (did I miss something?) nor got any
> > requirements to support it at the moment.
> 
> linuxptp can operate as a TC, but it sounds like your HW does E2E TC
> without any software support.

Yes. I believe linuxptp only implements a two-step transparent clock,
whereas the hardware supports a one-step transparent clock. Like I said,
I'm not aware of any requirements for that at the moment, but I imagine
we would need a per-netdev interface to instruct the kernel/hardware to
adjust the correction field at ingress/egress for specific message
types.

> 
> P2P TC does need SW support, because the ports must generate peer
> delay requests.

Right. The hardware has the ability to add/reduce a number of
nanoseconds (that it gets from software) from the computed latency on a
per-port and ingress/egress basis. 

> 
> Thanks,
> Richard
