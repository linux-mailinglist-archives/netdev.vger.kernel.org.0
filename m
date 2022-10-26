Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AE360E535
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 18:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbiJZQGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 12:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbiJZQFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 12:05:53 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CEE5F7E3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 09:05:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcK7ziWk0+R8AR17H4lSEBPgtTDjnwc+vaPRdX2UbWCpMhLfyUinzvD+yEFufwIJHLvx5NTjDoWdonPpUG7TS0cSyXSL1LbnmGcZefqOn+kP4xZiHf5IgVtkhfwavMpc1HkKqaVcsWVbhHNIrDwlDuMgyJXHCzu7ZTqgh5+fd0IDSakiTjjYSviwk+jSUHwcj6FtuWInaMtF9C8GrFIG+++crpDM7vetsvsHfeK/hHsSkPv7oe7giz572TlwWIOvDvuuI9bVEbUtbbVvCyytiCYnyHXABQVBZmJduPjqdcGG1uCXi3KFGtCemobpdwbLIzOPf3pY9fGGKXywSON/wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xXsaJoHP5xqucGjaZTxGYx89HbLeyFSoJYd5HqmPdic=;
 b=VnorOsQLv7XSwIDTMthRUeaKUSLfVALgTj8UHPXSXuZFYF9aNqSoCw+3GyV4Lvmzd4TunWRjCtW9M0b+KOx3R1HRk+YcBsZ6OJgLlzPsvmmr6puh+tzUPpHePbWNJmY59C8lriW8uqOKBimeOI7LcN+MD2WBlRX0HzrB3UMq/+Dm6fPHEZazgDTB+WrvGyZThNWr0mD2Ih37OonJWVX3Hwsr4s/Cez0jzHbHFWIj+d3Zc4sQA8/09sa2SN5pI2HZ/YF0hyHKhxONB0EgB/K2L84v2EpBdZkH/BSVJQsIXbVrVktkseaKhttRiIDEXRYhw99rciBqbXoIcCQmNJJxYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXsaJoHP5xqucGjaZTxGYx89HbLeyFSoJYd5HqmPdic=;
 b=r3LbdtOIVnV6mLcXY7sDZ1gXTHDuy2/iCNHzBmkZCGyGwuAJnv41BHsAyOd6z89PDEU9Te7m/LedyDMjrikLYjpPMLVc7waZBDuXIfuhzafn300eKp6fFdEyoPjY72X8l/7yN9SGOnk8jP8JuAoEB88eODKuzeHJSB903GjgCz26OZSyspFe3G53cJ61R12opJaMbFsr1BZODS3z1Up6d36pDBGzizx3aG1wZn27YQt6EJ6w+g7khWgJ9BEiDHCgli4a5O+CGyiYuSqzAeDEN7ZuQNRT1uKkiz2aKLjlA8/8Wjcw9wysdwb+OUKh5yAeC3dKC5trjBOlKiHhM1Pgsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB7332.namprd12.prod.outlook.com (2603:10b6:510:20f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 16:05:48 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 16:05:48 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, smalin@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: Re: [PATCH v7 02/23] iov_iter: DDP copy to iter/pages
In-Reply-To: <20221025160159.GB26372@lst.de>
References: <20221025135958.6242-1-aaptel@nvidia.com>
 <20221025135958.6242-3-aaptel@nvidia.com> <20221025160159.GB26372@lst.de>
Date:   Wed, 26 Oct 2022 19:05:42 +0300
Message-ID: <253czaezi21.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::6) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB7332:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c20d391-3b85-40dc-54d4-08dab76bf25b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 92uWdsm6hvHpm5ZVkZmq+humQberJwU5tIPHEgh4LKP7luMPN8W4r9MXhc4C7GnUmA7U0yAYKqKWu5/4hoDQM8oe2YwdgxOfTgAShA4JK2QySOBoZT3iZiS9hlqficv+jKPvZLomlYFw7m+0Y33pTzCtfBuqhdZ9yktZ3339RhtyEtBvO2dMYbeyettLTYw44xpmfEBIGw0e5OucMTWuQHBq0nusEKC3O/MGlaUrIOsZZmSmcszDkEMdFH7Jpmrlr2l7mf3uBEuBb9DQdCIDSHYUrZy86U99G5AK0223lA/YmUUlsqQH4m9zisMXs47iUK07Ma23n0FwGly3b5E7LXkazOCwgo6CK/yLG8bWLHh3d1j6Jql5xNh5kYzCGWC3nFDnFxtOyGvSW+BKP6grhAfueIAgp7w5wyUdTzqK8QZ/otu0+/RQY23gCkTSxsGbE3Gmnrp51H5qXsddrwFDa2Xsybo4eL02jj5XXoE92/GbZqg0iUkGiB3V+WYOvG7BSQadiMKyyQ1/x7VQLrVLSH5TiajcIgY+WcVNaQ2rDPYAEyseoHeZa5l3deWGfpfWxsqlCgN8fwyo6GqBqgHPBchwcLhy1dQYJ4gizXgUI2e+z2xikaUMkERiKU/75rSR39aQlI7wJ/SCeCoBs/B3z5ftsRkCMML7Se4jkTffLXRhVZ/ch0b6wcW6KOhqlQN9SuwfMcYbdNbvgiCAo46G0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199015)(2906002)(86362001)(41300700001)(38100700002)(6512007)(8936002)(7416002)(4744005)(478600001)(6486002)(5660300002)(26005)(316002)(6666004)(66946007)(66556008)(8676002)(4326008)(186003)(66476007)(6506007)(6916009)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C6tzgzQFFhm2gOdf+yhIV0XqNHoEnnw1Q1PmiR/OgVU65mOyGy1UYsSZ8oya?=
 =?us-ascii?Q?Q/70SlcEzN+CLi5u5d/Qwq6VEmYEFL0s1vgzw55VFiAikip8byqkdV9bo56+?=
 =?us-ascii?Q?eMyGBaSS4o0r8UoNM17pn0g/UcijsGCcoBMZOFqx8lZaNvhFAl/WvVouTVXx?=
 =?us-ascii?Q?6++xDHoji8oN+JsmaqjVX1sWWcm6QTTNQNnbMGwqVyVIIXIeT6mhpbu+sv5D?=
 =?us-ascii?Q?hf09eVMDqDwG6p6t4NrW4y1n0FgxSCmkp0Kf7evzJ5ZUy+xYkqHYgkOLqarn?=
 =?us-ascii?Q?khyKGgkoIxeIzTcmvYHKA2cBrXPOxtRcWtL/BWio+ARy46WhrcYn8ajpcJ9K?=
 =?us-ascii?Q?myuA5aouamDRcBYYPhTr6CrOtg7ZErrGZvSua9dB2crDeeCfFNPExJ5zVlr0?=
 =?us-ascii?Q?99HE8OQWdSYQdohZIs7h3WVyML3PQOIfpLq4cClVPPD0lXo4LgvPrrBEcID5?=
 =?us-ascii?Q?ZtP9dtJdLNIEvAtKpUbdNUC76WznxE9ovelKoxVOXLMwtB/8mOKX0p2UfiV2?=
 =?us-ascii?Q?/8O1GP9i0BwLDd6+Qwoi2uTyty1XxPlJvZVK2x92L8o75IbMZDwQASeduEt7?=
 =?us-ascii?Q?ChATCgCWqjwS7Bo8IMYjGIsmGYi/MhLqtloXOd/ZwXwutk2IS+5w2AgFg3rs?=
 =?us-ascii?Q?HnDeDl9siVZUTnMYd+ukpRoPwl/MQp8qcY+nf3PgsBsGKZuVAM2kZAkKVnti?=
 =?us-ascii?Q?wpos4P7DaGYnhsrmipbZ+0hUX6Epio63rKMh2tqOX1EZuT02/C/nTeZfs5os?=
 =?us-ascii?Q?7YVdJmH4fNMiwW6akzUInHRsSFHyfntK8qCu1511fe8QzWA5ROn3qgjVifgo?=
 =?us-ascii?Q?uCfMY53yNdAo0i19Qrn/jxUggCu/f1hjrehVXQrooO9O0fUIk9Jt7kyQTNRC?=
 =?us-ascii?Q?JM1FU+xxi0S/I0zNSGHBZqMx0vuBZt8qvmm8NQbbzC6y79Criafkssevsiyl?=
 =?us-ascii?Q?UFZDfH960YSe4vSVb4OHxoNkiBFE4RBt2t0d3yWDzwCThuXeE15dCUKafmpf?=
 =?us-ascii?Q?uoj9FmgE12F5Dvh1xx4kgStBKvqIz/kRTGhIWswBKvZVBAsZ/7HA3AYLq78o?=
 =?us-ascii?Q?yNiJZ8LdXbpanxhxCT9yZ8bQtWaYzgI/ROqfUq0oY8nKh/wrgcEc3IZUi4Vo?=
 =?us-ascii?Q?wixLJkl4QbqYCk6VWDAm+Y3D7O8z8WOv/h2hQynhbMYMeY4W6fQIquy2BcpX?=
 =?us-ascii?Q?NBZMEUc6DvJ+SgdMrVXNW0Vj9a2kwgaMMo7sQVLUkm2WgyVM8b6HB88/lojF?=
 =?us-ascii?Q?man04uyiG9zcTi6YLDu76KEgFSSXkzcHG3z/eNzFmvHC1BLEKykdGJjgWEfM?=
 =?us-ascii?Q?qaejeDzpMqAUi1rt8hQzC7NeviMhWqOtyGR+N7MATCklXQI8LqFSxK3hQ5Iu?=
 =?us-ascii?Q?IeKHosPVVNc3yteCozM2w91UgmKwORNISEZW4dm3qIMxe3kE0hYEMxJ2sz+R?=
 =?us-ascii?Q?w/4ilo+8M4dg4mTNPbd9DavUX/79S7rYzth85Yz+jinkJWDzEEr+qAnKGPFl?=
 =?us-ascii?Q?bil6IwhpfE3/MTF10qqMjztuwHJ6Dk5GlpJIAKKb8LMAq1wcOciHbog2BsFd?=
 =?us-ascii?Q?u4w7nMgRkMhNuo4YKr4Qn0yhcgbcQetScuSRr8h6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c20d391-3b85-40dc-54d4-08dab76bf25b
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 16:05:48.4144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ve7CNnMOfI8PT6uRhNHnnzDzRQVjQnwoSX7TQCj6ogGtKmSNJOir97TJLlq5MfFhJsuojIZHjQSbB7cpWJuSoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7332
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

Christoph Hellwig <hch@lst.de> writes:
> I don't think this is a good subject line.  What the patch does is
> to skip the memcpy, so something about that in the subject.  You

Sure, we will use the following subject:

  iov_iter: skip copy if src == dst for direct data placement

> can then explain the commit log why that is done.  And given that
> the behavior isn't all that obvious I think a big fat comment in the
> code would be very helpful in this case as well.

And we will add the big comment.
