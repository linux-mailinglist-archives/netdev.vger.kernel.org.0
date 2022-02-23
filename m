Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A304C0B23
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 05:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbiBWEfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 23:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiBWEfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 23:35:05 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159555131D
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 20:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645590875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7EQDx4kGUnFU5uvSRpkbSx1zYUaqHhJ9nBEcuD6BaGI=;
        b=PjffEnAoyPvsDN5YtpaS/W2m6KDWOp65t8T8NV9Rbn6yHyOX8xdj4vi4YbaVY9pbUIvPDA
        wBbdusU4YW9GkY/rQWMP/TJhcfjahrhijypQYzcbjp7JcvOO3BNl81fSFzXaSiUJFfhI3P
        vlByWbyR49EbYuTqcBgDtMuat/tx7sM=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2051.outbound.protection.outlook.com [104.47.8.51]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-23-gD2MAoX6PCu2RSXx_yf9kg-1; Wed, 23 Feb 2022 05:34:34 +0100
X-MC-Unique: gD2MAoX6PCu2RSXx_yf9kg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aeyM1Yb5GNb4YGUjK3ncIwuAj9Ee+aBTTARhm56D4U941gFX9xbN7Um/nHPOmO9gi7ujkp8BO3VorIzsmZrnDC9AhheAOcALyfYBcknnCsDwOOa7N4179NP54TrzTbV5nycPiQGC4kBB1QshYC6vJbIwRIvzcJ7odyJjzCBNrUcmMMqf2BiVn1/K8eNeKC/ZJYvL0+s1xFcRwfGIRRdksB8+Dz5GPXQiZPI7OLuD/0WTQB9pBz49OUZfNQQVp6edJdDM9mcOAl0s+wgcIeA/jE+3bNRMnPmK3688eX1jTVp4ICY86LP8iPfiQEctsx5yn2p2YOensDitNg93Ag+R4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jKupBj2g3cXZHO64LOL3SUd0szwX8lXoizXC+TsQiQ=;
 b=oBbbflB0BzTNN/CJ50Q8V//SMp1y82MGBn6CcB+kfx9jMXSf/riYx14AZhBxazyCtV9k7qe+I6iDPaQ7kR0tSYWOxENoqSkVnEru6OnNIK3TQECOgLMyOvgBjfCqcznrrrbjSaQAvH63e6hj5NMv9+ZJdyIYMpxfP8jnb8Hypq9pzZLtZdRkftg0Ndc7Brnwr6L6bns3VY8+7f7oAQDpjP25rF2JY89ni7/uQm4SPi+BuM4QkKHN/sjg81pkk1NnxM3eoBsBpQFVttA5uvb1B8BF3kEMXJj8hqmBJWvn7RvTsFT0XMw176NkdlR0pVL7SsxapAexwqIn298TOa6vrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 04:34:32 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::e1c3:5223:dd71:3b6f]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::e1c3:5223:dd71:3b6f%8]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 04:34:32 +0000
Date:   Wed, 23 Feb 2022 12:34:24 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Connor O'Brien <connoro@google.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal =?utf-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Subject: Re: [PATCH bpf-next] bpf: add config to allow loading modules with
 BTF mismatches
Message-ID: <YhW5UIQ5kf8Fr3kI@syu-laptop.lan>
References: <20220223012814.1898677-1-connoro@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220223012814.1898677-1-connoro@google.com>
X-ClientProxiedBy: AM6PR02CA0002.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::15) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2de6229-ff6c-49fc-4541-08d9f685c977
X-MS-TrafficTypeDiagnostic: VE1PR04MB6511:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB6511FCB362809B4BFC04F7C8BF3C9@VE1PR04MB6511.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 798xMHiGCPstFKeJeOnUEprCrMa+PREnBhTwBvesRPT1XnQLGECvfxtFanZ13bUHXDSJIGPyDSq1RwejxSI7u0LRqUOW1t4fl7zs1zw4xsolha0Iye8qASfPc/ShENZztgm2CeJbfi7Rl/gqFRR8GOfXHuyPcQIBwpnUVkHldu2+LNtxWWRWQgwQoowKqZwdN+OXmF2lyGPweGowqJDV2PvgT9E8UO14cii2H3qXaQZ9IlYzkEnr8VMv8ZWbCRlNW+yC6iPFQqFiDJV+yoUQnclPLeDNkiHi5J5wLCDsVmFWziAebdCbGa1GCLAGXUG0kRCTUiIBy09dGdL11kuMaOKegc2SO7uWvy/VAux4BX6H4NsmbimcrC2qnO3Ct4moEd3VLcuhwV9GO1XRo5pUV4dqdNCUEpzMDJ3iC3ebFy2FfQTzYQNBrsVjfXvRvJRIvipcUuk21aSfVbvvCvzMtu1XRBUCJ7q3vz4JyxLiABg6ApzrUQQWTMiS1yp674+HRkLWXO+7hQ0bfKG3O8z0KGoVNwmo4+ds635wW6DYmGXgDPs7eKNBBj0we4ERYdWoYNoFVbJ4zsLHgeo0T5oKIm5rmFid6EOXbaBWLLz9smf9tS2Cm8N7iXwaZHJ43RQYUH2WYET9HO50D+ARVKzognUk1TTi7GipBLrcfhB0BBpi1pL+TLQc0zofQ0OMaMfCVe1XSL+9Fr9hkbMl67N+zFXGVKLf+XCjvr18lH9orIk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(66946007)(9686003)(316002)(26005)(8676002)(66476007)(66556008)(4326008)(38100700002)(6666004)(6512007)(508600001)(36756003)(8936002)(6916009)(6486002)(5660300002)(2906002)(966005)(7416002)(54906003)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hyx4zvXUWZmNr2+6gv1YYNTpqrYqOGpoHiR4o+4PjwMnsOUlVFX4UzwWgNgd?=
 =?us-ascii?Q?mUu17HOy9NWfGkZxGu+fG5Im3HWJ/UpVP5wXiUonqOMUehVnUAgyny0m3xB9?=
 =?us-ascii?Q?TI+XD6X0kd0iw2M8FHT2lwbjxV2tcTDaZSCWwc8gWlYIhz5j78Neeh9b1qzk?=
 =?us-ascii?Q?AwlLCua/uXRWRAT3n60/0OS4UWRgvIH5oPI5SnsrfmiPK6lqLtl18b8Y3QCp?=
 =?us-ascii?Q?CwDKWAb3j6Wz99t3yd8pZZcFt/7g1+rJ3/OqCvfAgGlq56rljMNFsGYZHsaz?=
 =?us-ascii?Q?30roJtvwP9c3ANK6yiLd/uUdkBKeoeJc8jMMRTDtuUQW6TX5lfjQ9kNXgTDZ?=
 =?us-ascii?Q?gHSc3BAhHAQNLga9Dq8dfFFHzBxZj6vjWDME57OFFO8TCNIaRUw8AbOShLyB?=
 =?us-ascii?Q?iT9UGtP4h0ZhVak9+tH/hxiefgh3dl+S/kHoXQLCKaOWeMihzFqnl5/2NEgh?=
 =?us-ascii?Q?aZQruAU59UY4jAA0gD1dFCy2s1Y03NC3QkH2cAmz/TDMJalrka2vpJI80Y7d?=
 =?us-ascii?Q?cLMMeLyPSO1GHfD2iuiQ1VY/E6uv2ro0lWa5Q5h+/3pYLq4qEh77f6oAi0M1?=
 =?us-ascii?Q?cv3FxMyI8iySL39Fiw9PDIaKmGW7ksV28hEUl80z1rFLMWZA290DJacYi54V?=
 =?us-ascii?Q?c2M4Z7qt0lcBrNLav6lzmwMJB+zNV+XAusCiNlO04JopP3kWu3NkFsR9v7pw?=
 =?us-ascii?Q?Ig0gFtDMgCwd2zGyzHV4gRMt9n5HZmW/ItQIuwSq8kib4nRatKrR2xpiE/x3?=
 =?us-ascii?Q?oPECODOJO51mwCYBItXwZoNtgKoCigrw+xF1JuItAn5uVAm9yuqhl45nHpU5?=
 =?us-ascii?Q?DfirkGdvwmF5gDVeTLfCSWn+vBOKa21wwmXwL0s7l++44dYPV+7zZR0wjNlt?=
 =?us-ascii?Q?G0bDOw5Qab9ql0pbIYSSjX/txVBHO2WjOaSWF9lImB5SO9wKa0aIQVvEL7gc?=
 =?us-ascii?Q?609WX27yRa1H9kJrvHkPFLhCOTQgs66xl3xyrkTPjlUaG3OMVa/Q3wmYfMzH?=
 =?us-ascii?Q?YEAApbm8c7XpCsFRXk0c+EnsgFER5oMqAQ4I6piY4OxBs5W/Uge62RPsojIO?=
 =?us-ascii?Q?iLAtrygVBD2OBVND45NXTShbCpOr4xD0V/3Q8miKFc+YhrKcHsckQnt+IifB?=
 =?us-ascii?Q?Y2AGXV0fXYe7uQkk13E8VWQRKvLGJHOx+wvmrvYZem2kO1uy7SyoujMX1LPc?=
 =?us-ascii?Q?v+llWgIHm/ByiuBdlp68Y0KrpoXYKLxL2PWucZi1SDBmWLvvRs2HkSZ4orvy?=
 =?us-ascii?Q?K6D/OHdaohB/LoNX+E3erv6ygDtHXec8+UcmensQgYftl4Ft2FzcQpfO68HS?=
 =?us-ascii?Q?o80i+jnS4bmQDQXGWFBGJuYqYLLiv0OEUwo1w/inTV9FrslziqAXHjnTXe7t?=
 =?us-ascii?Q?nUP6YDeDJmENznoptxdzSkftHrxN9UeTzhT/XwX/EvSN5OQoWO8fo7JX2f7U?=
 =?us-ascii?Q?QV4qRMHZPaf9FSkbt+Eq9qy8r0SZRmELFuOn8KjDMXDEdKrXlepFqoyWSed3?=
 =?us-ascii?Q?KV0sUJHP0UtTgceTRN89MT7Sa3ZukDrdxCiafzden7y1XGh2ElBWS85FnOzy?=
 =?us-ascii?Q?0wEthqkL6MCy19jaNEpcntwHdOu5xaQa9/VjQtDXU0DsbFJdVdRNskYbdSaH?=
 =?us-ascii?Q?OjdNcgltcuMLedpHhy/Q29U=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2de6229-ff6c-49fc-4541-08d9f685c977
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 04:34:32.2786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hfr/N2vYozpkkUhEk/PnWtJp5VtaE1Thpd3tAWya0q8nuZp1xGDjBDRTA3x16wQwDzSU3pPLMbgZSokrP+rP6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 01:28:14AM +0000, Connor O'Brien wrote:
> BTF mismatch can occur for a separately-built module even when the ABI
> is otherwise compatible and nothing else would prevent successfully
> loading. Add a new config to control how mismatches are handled. By
> default, preserve the current behavior of refusing to load the
> module. If MODULE_ALLOW_BTF_MISMATCH is enabled, load the module but
> ignore its BTF information.
>=20
> Suggested-by: Yonghong Song <yhs@fb.com>
> Suggested-by: Michal Such=C3=A1nek <msuchanek@suse.de>
> Signed-off-by: Connor O'Brien <connoro@google.com>

Maybe reference the discussion thread as well?

Link: https://lore.kernel.org/bpf/CAADnVQJ+OVPnBz8z3vNu8gKXX42jCUqfuvhWAyCQ=
Du8N_yqqwQ@mail.gmail.com/

Otherwise

Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

> ---
> Hello,
>=20
> In the discussion regarding BTF compatibility & modules, there seemed
> to be broad agreement that an option to ignore mismatches would be
> reasonable. Currently the only option for handling this problem seems
> to be to disable BTF entirely, so this would at least be an
> incremental improvement.
>=20
> Thanks,
> Connor

