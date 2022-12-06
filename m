Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69879644DDC
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 22:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLFVTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 16:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiLFVTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 16:19:50 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99EB47331;
        Tue,  6 Dec 2022 13:19:49 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6EiUUo008466;
        Tue, 6 Dec 2022 13:19:36 -0800
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m9g83f0rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 13:19:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQG4MS8zaMlmnVNhWw8TfguKl2Ha/EmmaOSS/OmDJiVUaCFLMe9GCEZgI3e4CV4UR6ymbMmgIscmrSDn9m4f7WhKuqd3QYvEZ1Gecfg7BwmMVCbd5eUqNN68DJLLmYuVf93cVG+b3IFkY+ZRHylbdjydcHLsNTA+9oeEyjy34JJuyV9atrQ2/7PJHDuT7sTc6U+/Zt/bxJmbHAytGvY41m9vIUFHJYnejOV8XzZ2CK+vN6zvEECiB8c/W2n+a3FJhDeqANWRh/Vsdr8m4KE7eHEQzorl1QSCGAHjSRBUymWND9FZ6jvr/irOLY/wo0XzK1lZgK7+jmneKTyteLAW6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xzEu7mMsBq/JA0iGgiscJI1s/Kepve6r6R6OizHWLcE=;
 b=NiRqSllari90x2MfoYVp4XsfAyYW9rMVnGiKF0HeyHZTkcvlIGeImM2fvlB9WivMC1J+T2+T6Qx24wEJ487DYFXOA1kuCYpnW3DBXllCtHtKiWkparuFYpIcqWeAfJpG7V21sGcfpxnknNpzDVEju2XIMgMGdup99MJGWsut6AA3DE0EzDf5d1HRy1y8c117Ok1N6GGXs/w9Utz/DE59WULyYmh+bEQryU2OaBGSxT5MLRX6GJRgzMCBvkuzeQY1lDEHFSUv8iziOAEQyxYlDnIMhdMGrx9+c8c+K8yvw9t/jHGaufufnrhQzglIMsUavXIhVRRAVYbkhFdn1koDMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzEu7mMsBq/JA0iGgiscJI1s/Kepve6r6R6OizHWLcE=;
 b=gWfYG+WEkgAOJgRuT2WCA1vKjwgTVrxV10xl3evitc88YwaSD2PiAxFkQbg4+8h4utMgvSVjdfxmITp2y+ZHNcO/RfxAtcO9GH3BNdSyyNFh+nbmyTKUIgfaRRvWmkod9lKzItxhwZgo77GTUVSJ1grUM3GQL0fyHoS6Xy5tKHo=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by DM4PR18MB5121.namprd18.prod.outlook.com (2603:10b6:8:40::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Tue, 6 Dec
 2022 21:19:26 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::81c8:f21b:cf9e:df2d]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::81c8:f21b:cf9e:df2d%3]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 21:19:26 +0000
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liron Himi <lironh@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
 messages
Thread-Topic: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
 messages
Thread-Index: AQHZA/PZs+9RX6z1+0m5ZGIy8eBWva5XNNSAgABoFsCAARQmAIACoOYQgAOoOwCAAQ3cAIAAkfKAgACNHgCAABTMEA==
Date:   Tue, 6 Dec 2022 21:19:26 +0000
Message-ID: <BYAPR18MB24234E1E6566B47FCA609BF8CC1B9@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <20221129130933.25231-1-vburru@marvell.com>
        <20221129130933.25231-3-vburru@marvell.com>     <Y4cirWdJipOxmNaT@unreal>
        <BYAPR18MB242397C352B0086140106A46CC159@BYAPR18MB2423.namprd18.prod.outlook.com>
        <Y4hhpFVsENaM45Ho@unreal>
        <BYAPR18MB2423229A66D1C98C6C744EE1CC189@BYAPR18MB2423.namprd18.prod.outlook.com>
        <Y42nerLmNeAIn5w9@unreal>       <20221205161626.088e383f@kernel.org>
        <Y48ERxYICkG9lQc1@unreal> <20221206092352.7a86a744@kernel.org>
In-Reply-To: <20221206092352.7a86a744@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctYTZlMGQwZDctNzVhYi0xMWVkLTgzNzItZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XGE2ZTBkMGQ4LTc1YWItMTFlZC04MzcyLWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iMTY4NSIgdD0iMTMzMTQ4MzUxNjM2OTEx?=
 =?us-ascii?Q?NTc1IiBoPSJjOTkyaEhyZTI2MXI0dDkvaXFUL1JiZWFYYms9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFOZ0hBQURY?=
 =?us-ascii?Q?TmI5cHVBblpBYU91cDNNQ3k4bEFvNjZuY3dMTHlVQU1BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFCb0J3QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQTNUekZBQUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUF3QUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFaQUJoQUhNQWFBQmZBSFlBTUFBeUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01B?=
 =?us-ascii?Q?ZFFCekFIUUFid0J0QUY4QWN3QnpBRzRBWHdCckFHVUFlUUIzQUc4QWNnQmtB?=
 =?us-ascii?Q?SE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFY?=
 =?us-ascii?Q?d0J6QUhNQWJnQmZBRzRBYndCa0FHVUFiQUJwQUcwQWFRQjBBR1VBY2dCZkFI?=
 =?us-ascii?Q?WUFNQUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJqQUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QWN3?=
 =?us-ascii?Q?QndBR0VBWXdCbEFGOEFkZ0F3QURJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?UUFiQUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0JvQUdFQWRBQmZBRzBBWlFC?=
 =?us-ascii?Q?ekFITUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWkFCc0FIQUFYd0J6QUd3?=
 =?us-ascii?Q?QVlRQmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxBSE1BY3dCaEFHY0FaUUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFIUUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFCc0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJQVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQURRQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIUUFaUUJ5QUcwQWFRQnVBSFVBY3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBQT09Ii8+PC9tZXRhPg==
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR18MB2423:EE_|DM4PR18MB5121:EE_
x-ms-office365-filtering-correlation-id: 95bf4adf-d39c-4858-a81a-08dad7cf8dc5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ucdjya0xZHe1DPqFd6aecajUoS6z6E7/H9HBi9Dt+pKf6vapTkeXeW2IPAztmhqpl6g7/2xQ0FRFFyX6RqmzF11geFioWDGkRKZ/M+PnGTQ+S92IWVrQa+zcQ7bwuI2cpInvNIDvfcH9LlR6UHMoUY+NI79o0vd9hRsX/rZrXPWLGJ2tlUKaKe3g840sq82IRUYROP3EPIGZ76GXQuIrTxzwcgRC2ToTS2n0pBow3WrP+g56YbTu+P9NB2yt6OEtUEX6E4A1QErb3C9ixFmCQ7T8ueXoxr/0sizqpjUW3OWfTah0hr7IItI+/8wBnHKM9mL8RRdbKBljbXoVSEaiI8s0YZG3+JHvF79q88REqKTfPbpgeW0DTTQHMvbFTtADS7DgvgINTp/Aybdt74g9pv0Sr9aTXxeo6r3p9MXCttoycuqvYSRECsmqF//QCEUEW2utNcp2WsSoBBKIeWaKbGtBqAe3aF5Hy/eNlKxH/sm4zyTKfaOr28KwoHcGFUicESFaWoGJe7Q59UNyw9gVgob7EckR55UjD8oHxeWJG4XWl12n4oAxheiTrp1qyTIegLWjlp4+owajkDsHGNByBlC47InObTwjRd4+Nc56H8Lkl+2sTp9rZxfqnJLDtT0i79255i8jO9QOpRZLXCrmrDs1FANccL4xJQbmQ8kiWXrL0wzEwTQTjVBxhk/HX9iOn4joxgPh9lyZIyA6l+YrAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199015)(110136005)(52536014)(41300700001)(15650500001)(8676002)(66556008)(76116006)(2906002)(4326008)(66476007)(64756008)(66446008)(66946007)(316002)(54906003)(9686003)(38070700005)(478600001)(53546011)(186003)(7696005)(86362001)(71200400001)(6506007)(83380400001)(26005)(33656002)(5660300002)(55016003)(8936002)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?e4dNrare6eW0x7u59nZsFjx68zdE5GmJaluOHnc4CkVxJrU2coxHpIiiZVjb?=
 =?us-ascii?Q?6TrQl/oN6xTY31igswNPRiAzRH+sBAjphw04Hzi5pa71OkDgBVP59N9NXlu9?=
 =?us-ascii?Q?qJcliy5ZYbMpjMVypspav89nTRL9u/g0B18wg+b36G8zJVGtdQjmmuCWILLw?=
 =?us-ascii?Q?owH5wZfdTPk3pw9S4d4kPqPrPfca0A1Nj4Nc8koQnDZ/mHPkOhIYgtNbrtra?=
 =?us-ascii?Q?r86D9y4Hy9i7iMdIR88DPZ6BkW0TQk+EJNifJ5/HNWLe0VKvXWJLX5fqz054?=
 =?us-ascii?Q?BH77gHpurrJHjiSsm+/ixkKDDXXMkG3uLZrKL4erlavvmpxro9qp4IjYZZnD?=
 =?us-ascii?Q?5Pa4lGOg2uvOJHEMzxVPaINsh3N4OHLCcWTLCZ8BgfVH2h5Ba189ALlHivOd?=
 =?us-ascii?Q?ELv1jCU75FLwJtQdq50SJvGs9IdfT88wCDB3bWIlhZb3SgbTKYTB0G2A9WEb?=
 =?us-ascii?Q?O7rNgqHxnj5IguiQPJ1mceb4rawfjDRkTcf/+Lbi7NP4EQzInK0beojjUcmi?=
 =?us-ascii?Q?bl8xuYqQAOObMC0anvUBLBjlpAxEf/x0vvxilTfQMRHkG6awaQslN8tv7vng?=
 =?us-ascii?Q?MMoOcI7Xl5PMagdmFN5S2GsjWNtrOmAOOn7C5wyLfg7/bmGU5v3Et+0HcpAK?=
 =?us-ascii?Q?C07V6coEuQhJMtl+CmQFM4V6jQvupsOj28CS85ctyBAB3Es+qdWRfOZ+rYuz?=
 =?us-ascii?Q?kPLteePrJa+5ndPzctgCs9XFdhL3YxZ2Ncc3NpoEPt7HzC+MyW/o19hlbdQn?=
 =?us-ascii?Q?ACwpye6LW9mKP/814XGgM0ECufgxQTvCRblsd+U9EjloE3nkKqVC3hOxFKCK?=
 =?us-ascii?Q?Lk0fw/SBp/6wMaIZbcFfqIIA9EJapykwXYQR533hxi0mHmPWua7k1l6rtjTM?=
 =?us-ascii?Q?+Sxm1Y/DPN/dn8ajr3wAy2Qxf+bfPSKmkxQ1i5QnAsua0AgKrF4Qyw9GkkcR?=
 =?us-ascii?Q?oyWT00u7Eam3Z4gejy8VvnDuNihR56Wr54VE8X5PXtJqa02Nr5RQK6Tmvhw5?=
 =?us-ascii?Q?1IoU9pTj6+JrQT+kNi7eaR+Ap1FdtsIBNVqX/PzbrZTS1By2p0TnMEArra9+?=
 =?us-ascii?Q?b2S6KD0W4CHDnDxbrFXbdXIx+6fdj3G5ZiB7nZU4RxxNdUAwOddOpoHqTZpA?=
 =?us-ascii?Q?zNdRev4BJO04+4LcOrddir2D1S1IQV82+NxGXHVF/TrRcfIScCHjlsHlmYhe?=
 =?us-ascii?Q?Wq1szAq0q4jF73vWoIXhEvvP0jQ7zBIv8dxPCYXi6v9+bGkMAy7inVv9XIBE?=
 =?us-ascii?Q?npD1IyOKtDGc7m20e2b1x2zKi0PbhHe6VbwNQWe2bUCExfMepydorrThRC3H?=
 =?us-ascii?Q?0w43xpR5NiGRRHPCFZxxX3bHkvfixq/6LxqXsaoUDPg0kfvyEvT2CACwD0er?=
 =?us-ascii?Q?sYkAh+/oBRqdj2+wQc/M+d44Bnb6B4CURXg3z7eukHOZpqTmqAKhvMr7OOt7?=
 =?us-ascii?Q?wiQNp+YQRFWBOcMUyL37uEGtaOXaJiKpj+yFPawkGwkiIBg11voutgo1KK5A?=
 =?us-ascii?Q?o8NS2caNOIxFLv3IaF999TBB7CkphONe54efHWzM1nzIk1M8l4NEymLRlCap?=
 =?us-ascii?Q?MkmaxOGkfd4dnWDe7DI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95bf4adf-d39c-4858-a81a-08dad7cf8dc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 21:19:26.2933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T/Esszj+pVM36Q33Shi2v2uz6iY5Dxxjve8TBxZSO/OdbfHRH9LJw2Q3vl7d06Y5QJD9o47uWy0AOTi5BJK9+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR18MB5121
X-Proofpoint-ORIG-GUID: bav_4QXPtTI0V6__he9FOATR-Bxav7Xp
X-Proofpoint-GUID: bav_4QXPtTI0V6__he9FOATR-Bxav7Xp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_12,2022-12-06_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, December 6, 2022 9:24 AM
> To: Leon Romanovsky <leon@kernel.org>
> Cc: Veerasenareddy Burru <vburru@marvell.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Paolo
> Abeni <pabeni@redhat.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Liron Himi <lironh@marvell.com>; Abhijit Ayarekar
> <aayarekar@marvell.com>; Sathesh B Edara <sedara@marvell.com>;
> Satananda Burla <sburla@marvell.com>; linux-doc@vger.kernel.org
> Subject: Re: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for contro=
l
> messages
>=20
> On Tue, 6 Dec 2022 10:58:47 +0200 Leon Romanovsky wrote:
> > > Polling for control messages every 100ms?  Sure.
> > >
> > > You say "valid in netdev" so perhaps you can educate us where/why it
> > > would not be?
> >
> > It doesn't seem right to me that idle device burns CPU cycles, while
> > it supports interrupts. If it needs "listen to FW", it will be much
> > nicer to install interrupts immediately and don't wait for netdev.
>=20
> No doubt, if there is an alternative we can push for it to be implemented=
. I
> guess this being yet another "IPU" there could be possible workarounds in
> FW? As always with IPUs - hard to tell :/
>=20
> If there is no alternative - it is what it is.
> It's up to customers to buy good HW.
>=20
> That said, looking at what this set does - how are the VFs configured?
> That's the showstopper for the series in my mind.

VFs are created by writing to sriov_numvfs.
