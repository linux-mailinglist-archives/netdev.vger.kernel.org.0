Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C629A68E889
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 07:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjBHG4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 01:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBHG4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 01:56:32 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2102.outbound.protection.outlook.com [40.107.20.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E614442E7
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 22:56:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YksUDYctVip70y9hpL/l1fZeBZ82vEow9WSDUPtj7KfVWMyBhHyHvHCQmP5E4FtfftjrXIVrSJ7fZqoujESdZXQ/E+lnqatT30yxql24QlL2B7sE98XcRBEeA0kiLlvPpSl+eST2jrP+E97V5EMRh0ZTzjkIm0i4S9dz+QXPgylpRTQqXfN18QEixhVAYtFBAo+PdDETTT70FtUkp4bgFXbowbKWCCmok/mVYIEVqLwDPTQt7rUInhxI4BQj39iXYm0pnzuqGUrItspeHcgGqIfVIuAdeWAYl15k0ibuBhxYQ9/cr47o7egXZvMh6hWS48jCjt7Z+4dH/yAIH4Hywg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmxHHvyiSNoYLNelbJzcyRtnjajRQi/a/emK/DD8ZOQ=;
 b=SlwTBiUF44GfRf1Wu0G4u1+gPSz801pI7O9JHPaRDhVzMcCKz2qD37PrJX5MbVsxUqEFg1r2oC93AQqqIyX58dkXGdYuoGQcikk3TRbh8lEyPSNcomOCETGdK5ZyUfQqzjix+lRB7vMdYkbSSX/OmW5J/8YfhV3Q3Kbng7miuNgc5aaRNNzyr2rHT1WNsZabV7DJavJ7FWLluFDlehACGZf8kPE1oMCRo2NoVNdh9mHoJCqq9st80wgHSKLQvX0ET5/fbYfUdV5QZMSbkxwusEKjrAhB2hro6JmBDKyMYLX5AHTiJ/Ubr773Uyr/noxN4IL4/qUIxMK4X6/eSSXRJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmxHHvyiSNoYLNelbJzcyRtnjajRQi/a/emK/DD8ZOQ=;
 b=x46dCvqs8XZRw/MNNb96Dv6o1vLDWS11b6qgR0iFHEjSzw32s1EvB6eOttgaW5/KEHB+MmIoeQfNw3U/2qNYMIyXdU1KlG4IGSHG+haWM6Q6rddpAqSuEkMWERdF4/B1U4+Je+09d482SjgoXuymn56TAkaqJeWRiecnGZZM+50=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by AS8PR05MB8182.eurprd05.prod.outlook.com (2603:10a6:20b:338::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 06:56:27 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4%3]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 06:56:26 +0000
From:   Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com" 
        <syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com>
Subject: RE: [PATCH net 1/1] tipc: fix kernel warning when sending SYN message
Thread-Topic: [PATCH net 1/1] tipc: fix kernel warning when sending SYN
 message
Thread-Index: AQHZOpJwhgefIEBxLUuhxQ8uC2Fj567EiOaAgAAWcgA=
Date:   Wed, 8 Feb 2023 06:56:26 +0000
Message-ID: <DB9PR05MB90789DC75E34ECC441DFF22188D89@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <20230207012046.8683-1-tung.q.nguyen@dektech.com.au>
 <20230207213433.6d679340@kernel.org>
In-Reply-To: <20230207213433.6d679340@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR05MB9078:EE_|AS8PR05MB8182:EE_
x-ms-office365-filtering-correlation-id: b3b0f1e1-73e3-48de-4148-08db09a19932
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eu/4uyMbKzCY5ilpZObEnoOuobc/H/TnAVnemnEaRQFCNgOZeothTeMeoDV8evyo8pri4Da8ywHvKGxDJMZSlRlKaeh6tjZVrRWJhym66B2OBe9QyhDh4UwzraZvhyqPwNhpkJ9J/dQM/hMafMAeZN3i18oY4Ll7m7gnNqjQcYhQsjOriGYQ1XTO9AhcD49b8l3u/CSIAPecvQmtRHl4VaytMbM3KlDurHcZlZUj/Tq/pLUyWj4pytUKt59y4fRONC++C4U2+qHfN0jkGN/dreTLykM94SZe9uwSrfF+reEVD+9EANhsbF3e2cIBeX/CkFbOGgJpiGdQQvzMhwX+7puerXgOEUEsGpXQ/DBkqg6Z3Lg8QYUw/fs/HHroKqhI3dauSr1YqE/kBWy6mfpwZtG5eLBMArzv6Benv4ipv/lVQpsCXaDuFoWQNAjTQTiZ8XrKCZ4sdrBzjmbd1oE0fAokWDYek8o3qVeW7AvkX5SWGJGcPhV+u27WqLlJxK9FFYnM0Tm9eD2azRLTo4JgMPj9Xk0dih3SqbYSSWuREIiVkWvDow+r1ISuogoA/l8e1kWOcos1AWf09pcgqshwIs1mWhAmflFzmheu9+/6owm3BKMI05cx7pK8J5WJyLOfel5he4RDVWt21JuRySrtPlC6b0eBo18AC67DnWcaFJQ8DI8mkgzA9CapH+JPpdf7oTZkXfyIKSsFBrn0G6z1+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199018)(316002)(8936002)(52536014)(55016003)(33656002)(2906002)(7696005)(71200400001)(15650500001)(478600001)(86362001)(122000001)(54906003)(5660300002)(66446008)(66476007)(66556008)(66946007)(64756008)(38070700005)(76116006)(6506007)(8676002)(41300700001)(4326008)(186003)(26005)(9686003)(6916009)(83380400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AaJpNOr+i5GIuiwXgGgSxN0Bxw7lOx9hbg+UlXtrKgVnnZhO1Z1Q1UTpug30?=
 =?us-ascii?Q?4tlBGMnTjKQ+NXpI2DWfTACtI0dVkzbUys0oG+myt8HK0Wx8IINKU9uQ5Fu7?=
 =?us-ascii?Q?JpCP5pahy/VIPn6zd/S3Bgvs+mr5whICQXVDsl19axVQ3NT3zsGL5f371Ilp?=
 =?us-ascii?Q?coF1HnK1fP+1PSDjwRxbQchQruVU14HwmNumoQ0niZRNBg5aiaw8Wf012Scq?=
 =?us-ascii?Q?dgJr/FjGo2W6ARtSho4NzbYPyOianCCu3MBElraekcs60VW7QU0SXqyFAnUC?=
 =?us-ascii?Q?3+j4u3Z4cPYgnKPd4CEAnMEC/AljcNfF0EcaGDEY1qdyQYpPSjs2ud1lq1Gc?=
 =?us-ascii?Q?kMALRWXZAAdy16qk1mF6PggPtgTQL4Vac573ULVNHX2JBQ37NOQFCd5b1lM9?=
 =?us-ascii?Q?LM+uBq7B3Y6rUvwQ/d59iEpXbW3AAqVfG8t4VftX7XH0qoZ0k6lo5I6bJOaP?=
 =?us-ascii?Q?QW6JPbzhQYG/YrSjV9/qEp70WHlc+IDng2Bzw/G3ED0zYTfnZpmRTwW2/fE1?=
 =?us-ascii?Q?8tgPJjheCnUBG1eYUpSi/sVF3esvDkxKe4rU+NuOYKEQYK9n+KVby7ax9fYk?=
 =?us-ascii?Q?9DFcwXxMORGdzkHI6dHXJsbGB0Qm+1P/tBzfF6eZ7I1P81qyIBFUV9cVZ5KE?=
 =?us-ascii?Q?vHkmr627ihwgTo+HJDE33egtmKtghoi+QBKbtuUBUVygem8boeFX8utu+WEq?=
 =?us-ascii?Q?ypoEhNP7oQUI058nDXLj/gbY4c+1NC4WCvM1hX8oHAPIAvXAbkoj5b1gsBrf?=
 =?us-ascii?Q?GLi5O7AfB92PKOYWrkukdzOgvua3bDe0HMpR5bwdt6eq8mlcDM0GVgb7Dz41?=
 =?us-ascii?Q?ifmDXgOEgFguMXBEuYoKKh9KKB9WboLUjtgkdI+PKCeuDqDrK/RCA5vy/4QQ?=
 =?us-ascii?Q?Pbk7Kb7nitgIJKTM7orGzU/Uz3xC/hbEWQ3iQgI5qj+3Jd1uF6BgQYiTv5+T?=
 =?us-ascii?Q?u4OIrWADQaebIW63ubGrH3Y+N7rNAXngcrblf7u6xp3uwlBWc4OISYQs9Hpo?=
 =?us-ascii?Q?uCu0DpuY95EYQkL5W/Li0NhG3CxYHD4XxIfkOHs7EKCWlGfE2XB+fW7Jl2ul?=
 =?us-ascii?Q?vm1sRB9XWZtBsfyjFynATt4Gt5Sb0T2/sxVRFZXSQeoTGlqZBqSk9ho7HYdV?=
 =?us-ascii?Q?IHzcVW33BYTCRuaZT9dTVMbdj1z94H7ApylUeuPpWa0lHzMQnSNl6FA4Vzfy?=
 =?us-ascii?Q?UV2B204pg0dgQdIH3bVenExGkpk6GZmyFgZAQCRYEwYbgacOsIrTAlwm2P6b?=
 =?us-ascii?Q?AfQfMpP8sprGrBFpcMpEi4bmFtt3OM3d+Z7BPMvfqmOqWiSe6dfbcDS402/U?=
 =?us-ascii?Q?o7pMJFqlMumrg4dZoxhfqUamg3pUpMMDHK/aE8jd/25EVm1ovErnXQZ5glgc?=
 =?us-ascii?Q?0zXm356ABxWdkqXFnkcVXAC9vKA8bvh4QFrbJwVrFgDiWuhsuIoKX4Um9gN7?=
 =?us-ascii?Q?6YlkMz9EMvEg9Lrb6oS9CZy3mPBZxkxAH2XPRaX6MgtJO97ujX9OorwqLI1i?=
 =?us-ascii?Q?qeXxxs3arc78HATZhLI3OHLyUPjW6SSLhCzRg3thpbrANOZFzraH3E8Z3rfV?=
 =?us-ascii?Q?mhNuToN0/9wczlrp/7HiC9uOm/EkFndpt2eEBt5ndDBP+FMbqMgUozGPcK7E?=
 =?us-ascii?Q?2w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b0f1e1-73e3-48de-4148-08db09a19932
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 06:56:26.7337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 317xEq2kLsqbiOa22qL1sCdUxbZ+3Ydq9FkbjDT+hO+H2sBMB9xv2SRAcJCS/S6gE4AU4dGCoKJfaJes0VfMs+oWTVHAK7kFUnE2jD4ZJb4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR05MB8182
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Wednesday, February 8, 2023 12:35 PM
>To: Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
>Cc: netdev@vger.kernel.org; davem@davemloft.net; edumazet@google.com; pabe=
ni@redhat.com; jmaloy@redhat.com;
>ying.xue@windriver.com; viro@zeniv.linux.org.uk; syzbot+d43608d061e8847ec9=
f3@syzkaller.appspotmail.com
>Subject: Re: [PATCH net 1/1] tipc: fix kernel warning when sending SYN mes=
sage
>
>On Tue,  7 Feb 2023 01:20:46 +0000 Tung Nguyen wrote:
>> When sending a SYN message, this kernel stack trace is observed:
>>
>> ...
>> [   13.396352] RIP: 0010:_copy_from_iter+0xb4/0x550
>> ...
>> [   13.398494] Call Trace:
>> [   13.398630]  <TASK>
>> [   13.398630]  ? __alloc_skb+0xed/0x1a0
>> [   13.398630]  tipc_msg_build+0x12c/0x670 [tipc]
>> [   13.398630]  ? shmem_add_to_page_cache.isra.71+0x151/0x290
>> [   13.398630]  __tipc_sendmsg+0x2d1/0x710 [tipc]
>> [   13.398630]  ? tipc_connect+0x1d9/0x230 [tipc]
>> [   13.398630]  ? __local_bh_enable_ip+0x37/0x80
>> [   13.398630]  tipc_connect+0x1d9/0x230 [tipc]
>> [   13.398630]  ? __sys_connect+0x9f/0xd0
>> [   13.398630]  __sys_connect+0x9f/0xd0
>> [   13.398630]  ? preempt_count_add+0x4d/0xa0
>> [   13.398630]  ? fpregs_assert_state_consistent+0x22/0x50
>> [   13.398630]  __x64_sys_connect+0x16/0x20
>> [   13.398630]  do_syscall_64+0x42/0x90
>> [   13.398630]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> It is because commit a41dad905e5a ("iov_iter: saner checks for attempt
>> to copy to/from iterator") has introduced sanity check for copying
>> from/to iov iterator. Lacking of copy direction from the iterator
>> viewpoint would lead to kernel stack trace like above.
>
>How far does the bug itself date, tho?
This issue appeared since the introduction of commit a41dad905e5a in Decemb=
er 2022.
>Can we get a Fixes tag?
I will add a Fixes tag in v2.
>
>> This commit fixes this issue by initializing the iov iterator with
>> the correct copy direction.
