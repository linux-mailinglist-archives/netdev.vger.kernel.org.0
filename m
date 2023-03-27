Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08786CA7AF
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjC0OaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbjC0O34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:29:56 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20724.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::724])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FD56EA7
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:29:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2Py2yIGPJ4TpToyAEZy4HWu0LOa+/fpdGheq0GwQ16vh692i3kGrpJ71Jh5EvpAgLCqoZREbGzFMYe5yLjPkxNCwtWwXhygheZ2dm57Ph/vrZ3/SQSvoXU8PGtRKAdHblEbVy+SuJ5Iw8zGbsUDNwaqJTcPxAQ4/iX2K5tbiFdKBFkC2K+H9OV3Qo+YO+ZzY6nr/wDoIDdJ7K6EFy1w7k1KF2Ss6Fj/K62iwUVhOFQRy3aJQBbXj2AoSUNFYWH2F6vRikhK5anBLw6fn3GTG8npafpUFW3K6cfNwwks1zZz41t1xIYozhGqpranNUefiU0glsfSrExYjQgta5Semw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=evQRz29Y1Ea2Lx31QZyX4KsQw1EJuoU1Q2XEHrDGBg4=;
 b=nvJEjCSOp513OlzTNp7XQVWi5fiz3rxP70zmSn5NMQRWiDFrZ+qOHk0vMt4tr0m+ScWIRorXoMSjIGdemWgrP5o9khuiE9D6hnjArx48xhRW34+gRZY7YCsusTg/Br7dPPBhcGMDoOS0naHfqXwaGHwo14XO5UPnQj9fH81R1aDUMeKMDCWwb3ZGyuCaYdNmtoDrOwLRTsreeiWHNGQxXJ0f6k9W+vtj8eBEYkUVTWnH49mrV5dM6WzVq61ZaxWgLnMpXvIKN4b4CJSrE3E/J2TuT0E8G62hcAz2vSTIyYCef3vilWhZ9Y7lnZo5Yz07QmPUNxzxcKfzNU0LoF+tKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=evQRz29Y1Ea2Lx31QZyX4KsQw1EJuoU1Q2XEHrDGBg4=;
 b=NQfyHz1GUla+Tke8GzP8/nKNXF6riDY2w5E6jvlpfSH3JKKsB4cUJX+FqfyVVRJLUSI1xcSpLp6JVE/6BGRFBEsDPY8XegEErDJ1/l5VEpiSde4DKKZITuzDJM0s1U2ahv9uYJaepPLAfsvijZU6klTZVM1ew2N8rEXhJO78HHc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5018.namprd13.prod.outlook.com (2603:10b6:510:91::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 14:29:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Mon, 27 Mar 2023
 14:29:00 +0000
Date:   Mon, 27 Mar 2023 16:28:52 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, michal.swiatkowski@linux.intel.com
Subject: Re: [PATCH net-next v3 5/6] sfc: add code to register and unregister
 encap matches
Message-ID: <ZCGoJIi+oEVoehAe@corigine.com>
References: <cover.1679912088.git.ecree.xilinx@gmail.com>
 <c232d6577a7beba24884cf4b05c3defe2b128636.1679912088.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c232d6577a7beba24884cf4b05c3defe2b128636.1679912088.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AM0PR02CA0101.eurprd02.prod.outlook.com
 (2603:10a6:208:154::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5018:EE_
X-MS-Office365-Filtering-Correlation-Id: 029d7ebd-d054-4708-1fad-08db2ecf9b5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lPZRzx5DM24lsrfEJ7JS/pMkIg7x6SjfTzQows/h6VPk5gOJhjF6X9PaARJyZMrLcDSsEZm5Sk45n9Wl1vvqN3hC3xDVPOqQngKwaMztQaFydYP/+yjMTiY6K+qZdIDo5kbMfmY9F1lgJthSrN9UElZCQmLPsX5R67Et0TVn0jrzk6Z0hU6ciNP4v3mrE56GaG5TYBozgNaNSgux/IVpywR371KdO7ASNIz4EHaP7kFLyzRgWMEJLfZSvAGpa/qRUd875CXj/uQotq91+4buYR2Y5SWl7SLEt5mQwTtpXNPcm3znnt/AsTWc6mQNqhOeD1Hq5eZl5JNFhmtW0ErjtF7cCNdX6pycFHTJmAgFfVK+NP50s+xPNUAywkQO+LXUdqXcqtUMA2rgn+TuYNhDRMl7c0KF/47tEeaM0YDG43cTDmMLMSCoqRI6CZNcC1f455wGRqjSxtCMVKv1AcZICmj5YgyWJ7mmoKLIGb4X6h9Dtp2KBvCh3AG6V32fyMMSX9UBA4MteJYjPSE6zpFziWM5U4mz20vUT8UhZR+KjSzKQeGvWiqolH92c+2Q5XfqR/u2QiotSt5mx5iyYutmb90mlGATDxbBxqkrPbHQ5IA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(396003)(376002)(136003)(366004)(451199021)(2616005)(83380400001)(41300700001)(44832011)(86362001)(36756003)(5660300002)(38100700002)(8936002)(6486002)(478600001)(8676002)(66946007)(66556008)(4326008)(6916009)(2906002)(66476007)(4744005)(7416002)(6666004)(6506007)(186003)(6512007)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+IpBbnbDqZKDF0WSOKquddt5cE/hpAcy7KaEPessNM1IVpDCeug1JxE81Vlj?=
 =?us-ascii?Q?rfwyCfGaR/EzMDiwMiADwlVced5Bxo7HuaCKqvkweJ+1N3oawZCJWAhej6wz?=
 =?us-ascii?Q?NVQmqnKHVeMJNJ8CAUsCMeRkvGIM0VdLlqEKCeQXqvh6KExJEOAkd8XkiPHI?=
 =?us-ascii?Q?S7jt10lQudPjWojuPL5DqGrLR6+wyaxp7O2eonKXRGS8gApLE18edzWnOheU?=
 =?us-ascii?Q?df4tMzAjtxZ5b0nkP4TZ7I4pWg+LJKj7Hbu+6bu6cAqk+v7yE1iwYFfokMjb?=
 =?us-ascii?Q?1cSGt0SkeKNmOhwsmO3aQtLRcwUWHfa0UdNRrMWNcEajOp2/EGocgmssmSak?=
 =?us-ascii?Q?ZLiX9qwtVefcul9XL8pETy9nR78zY3FZkfE+vboiMWRq2M2OTxyFgLLPxjbk?=
 =?us-ascii?Q?4NQMyloRxMdaHVqNu4KiY3ocNvi6vfhivhJ/ilUiXq30ixj9QE1RhPR25e7U?=
 =?us-ascii?Q?HN6u+ecKF4OQEPJfIpKlspiFJhjAL5lQrekF2aEi4F1PwTtD9LUIwbyuzb1w?=
 =?us-ascii?Q?g6solGvStYTYGZoZSyb40crONg6nBeL1BSHdZBo0s8nDDJumxh77qzMURpY2?=
 =?us-ascii?Q?4iVevnyiH0enzvQpuATSCkG4LPuzQzikdq0iT2Qqt67iPdLnkww8DstdrsP+?=
 =?us-ascii?Q?c7yZPTvaJ6qpFIXXbYPKWOANqImjsH0uDpFb2fly7TTN3ouEyyr/b9Kf6KgE?=
 =?us-ascii?Q?iO3ldWepS+hMquiBUPoIAivJnVlkON0/VgumrXuLyZx/DhqqPSn80O3zpv7k?=
 =?us-ascii?Q?4vv2CrJGAMgK5bwY32VfPgz6LdqHNtDjFv75EENqxobjhQIHEuPDrhSrtftE?=
 =?us-ascii?Q?OS8UmkbvaVfe6SMNK2rA9wXVu5ArnhJZyGNnrsu/RWtGI/H+RxHkeC0oKPOI?=
 =?us-ascii?Q?sta5sax0JWeXlkAUMG7GJrG3W/11rbvRZ+brMqspFyQLNMCcfKqUGXhpXJF5?=
 =?us-ascii?Q?y2CF6SeOBBkxBCUQDMApRU+5EtALruzuV7BxIsuOnRgMBBKGtRJQb97jXT9e?=
 =?us-ascii?Q?SUDM4NIwDVaQ79tTYbABfKrDbJzPN6eaUv5H6o6l6sI9GarUinN4co3qvFen?=
 =?us-ascii?Q?Lb8adnqUOAwQBhq5/xdwwpcxLj3iO6AJKw+AMYfs7ZFHPzcoZmgCQizXCmGe?=
 =?us-ascii?Q?qnrpFIKJT7Id8yTQQVF27hbNA4e9+nNuU99P/+ue9DUAbKGWdb+IwjxeTw4r?=
 =?us-ascii?Q?CVni3RIYMqg7qxLkUaYxkzUVwZ03JnBjrSbXb4pGazrxYlOrtJpKWKrfBV9A?=
 =?us-ascii?Q?w/xRLeQDp7xuE0f08Qo5KRboqFwn/5TGl7P5aysd8K1U7p+3u/eVu3fVC9CH?=
 =?us-ascii?Q?p8Yr6CjJ4DEnF3B2kz0x758s9pkOThUt4gDDQd6YLASjeZHdepJtZjcBSTg/?=
 =?us-ascii?Q?I7BjMmkeoJofTB8ISK/XIodZQhvtmUZq1nea/4Fu5NGupyyXHU8dw4QZ14xq?=
 =?us-ascii?Q?+sO5DufE9mTrIek3Je1PPxtL5scOiJhOoyXzQ5UHE7RT8ZqmckQEBp4qkMW+?=
 =?us-ascii?Q?eNSnAQ5NeoxF4uLoDWTrEIfVOwO16y4MOMl8qIKPNe/02AxebyWfBdz++TAl?=
 =?us-ascii?Q?ViJVe1TOepaRDa/io7D9HZnD6iDq72avBqmy1kkLFPuuEzYAHU3dYJRhWGra?=
 =?us-ascii?Q?pwSkiH4b5enA3h8MDX5yGSIUSeAy474XIXu0JvxV7nv1wFi6xKgLHaS1CbOg?=
 =?us-ascii?Q?BtIr+A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 029d7ebd-d054-4708-1fad-08db2ecf9b5e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 14:29:00.3816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dbsbi6MB7g14DLBNipEik6jMvLosMwGP6t8PjWce/eitNa5sQGD1lRk7ATiR38qFvJyAZ+I1TpLrysYyd/htvAURhDSsykmI5BHbI5kQmrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5018
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 11:36:07AM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Add a hashtable to detect duplicate and conflicting matches.  If match
>  is not a duplicate, call MAE functions to add/remove it from OR table.
> Calling code not added yet, so mark the new functions as unused.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
> Changed in v3: initialise `ipv6` variable (Jakub, kernel test robot)
> Changed in v2: replace `unsigned char ipv` with `bool ipv6`, simplifying
>  code (suggested by Michal)

Reviewed-by: Simon Horman <simon.horman@corigine.com>

