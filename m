Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89111674FC5
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 09:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjATIuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 03:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjATIur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 03:50:47 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FF6891ED;
        Fri, 20 Jan 2023 00:50:34 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30K7Nk2U016365;
        Fri, 20 Jan 2023 00:50:18 -0800
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n71cexknk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 00:50:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QxhvxKDtU2IxMZTUN2gc95cffywF5hXUV28U3m4Qk3rRCbAMxa8WypDPI58RxfKYPbsM/05ljXXmNxupi4mB08KrvBJHSpdQDJkXQoOb3Xqy1RpPQ0aPMFdKJW3FF4lFT0DJvklAAT7Pb4vMuLWzmTf8FtOFHBhKoWOGVhvWwUMcWFNWwbMuPYmWL0xifRGmfm6SenOzX/1C11oFXa2SmJgzDi5vfbNfK8yaTOn5MUv9Ns0+awpAp5GjGBYIrKoQQ64A7MEoLvjKID5O9wOIQ+fw9SwMBZeYDMo2uRDjPWd5FYTskPicNfn3kod6tKHVHYi6bczfODmqsEiHjwo/JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c0r+6iK1WPrbyQgNqu9/ZHHxg0xBx65MarE0msWT1xg=;
 b=U9aXnGAjxIaszAhSaz28hevrsO/iG3Zm4y89sLMuT+QGsTn4I8ga78aNV4sGxGd7XYGy6dLFGkfo4PhItzWAttU9Jh4CprkxqqLGlLQDBGHiBoIuNccW6fC3eMLqOdEgDa7ulw+IkpukduQB3ZRZ9H61zuO2k4QjGPcQc+5ZeKdgduSYwOY4XRGxSGvXbD9gjYHz2W119fCUtQ+aBFC4GMCne5GCOzGQTr8HibpCLDINz2W+QPK69KEZE9IM5g0hL7AyI1Mx8q3v3etwCWg8ldy6SnQzPeXovTpfxo106cIUARS3jG5bqMDyprOXNHJ67jE5vcLddzbKflp50rHVsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0r+6iK1WPrbyQgNqu9/ZHHxg0xBx65MarE0msWT1xg=;
 b=Vf6ikOBZ31jgRjZtfWIZQbDycxs4zyr4uaU9FQmLnpT6OzBasStAdZFJpo+Eeg7E8UXJuBzfc9+P1599WaFx+uof8lJaIHByIiCbA52QEml32nxQL3nQgZSqf+zq8GKG72Y7bNcbasi3UsqPZeJxCO283H7+uHj8GTSiyvOZq70=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by PH0PR18MB5166.namprd18.prod.outlook.com (2603:10b6:510:167::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Fri, 20 Jan
 2023 08:50:16 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e%2]) with mapi id 15.20.6002.027; Fri, 20 Jan 2023
 08:50:16 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "tariqt@nvidia.com" <tariqt@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "hariprasad.netdev@gmail.com" <hariprasad.netdev@gmail.com>
Subject: Re: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Thread-Topic: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Thread-Index: AQHZLKw3Ph/wPlV6p0Cw/IyBaankiA==
Date:   Fri, 20 Jan 2023 08:50:16 +0000
Message-ID: <PH0PR18MB4474FCEAC4FA5907CAC17011DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20230118105107.9516-1-hkelam@marvell.com>
 <20230118105107.9516-5-hkelam@marvell.com> <Y8hYlYk/7FfGdfy8@mail.gmail.com>
In-Reply-To: <Y8hYlYk/7FfGdfy8@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctNzMzZjhlYzAtOTg5Zi0xMWVkLWI2ZDItZDQzYjA0?=
 =?us-ascii?Q?N2UyYjlkXGFtZS10ZXN0XDczM2Y4ZWMyLTk4OWYtMTFlZC1iNmQyLWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmI5ZGJvZHkudHh0IiBzej0iMjA3MyIgdD0iMTMzMTg2NzgyMTI5MzU2?=
 =?us-ascii?Q?ODY5IiBoPSJpRXpZTjd2T2MxTWpPQkQvdGF0bXJROFhLZzg9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFOZ0hBQUJG?=
 =?us-ascii?Q?QUprMXJDelpBU3FQWE5SQTNSb2pLbzljMUVEZEdpTU1BQUFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
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
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFIUUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFCc0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJQVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIUUFaUUJ5QUcwQWFRQnVBSFVBY3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBQT09Ii8+PC9tZXRhPg==
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|PH0PR18MB5166:EE_
x-ms-office365-filtering-correlation-id: e0f2e6f5-e338-4dac-c903-08dafac359fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oCtlfAMmWjzR8ir9GudSd0+IdxniK9QrlLGVFL5EF+DdUvUxaOnD19/ye+cDhBIBV6kDkI/XEizq/hEjQVS0Itsxq85ZI2GSfGxGA6GbmQJp5iC8xagx1vZ7VxjXE3A2AP0Ia9bmbDjfz+yelqBwt7EQwvAsSaMISDoJHJelrPV3jBS3fyOpcxMdQnuunqOGxR3aMvV5QdiDeb484BS6ic2xRzxX06hW2mWeUHwq/s5zbLrHscs0KnSfC0DpCU7oUYeiLyJU/lnSjPuCjYY73meb0AjnVTdCIMppDxwMVDLKhMqgitSIxbxw8TGIXC1K3KgjcDOuxPxWvJQhL5p2Ejo0ZhPLOS6akcp1NiKoSkIv1/3oZYO818hozDPDlajh4PPP3cXNpQeHPifKGmL+HL8RizM12GbZkGPUyADOineNZxkHXPokYaruJevJr94bQjs7FkrLDtcgpQnq5CjDNTeXxo/Z7GfwhFGoOgaunh+Ju/v2fnqdS8aVca9ZnM24UX64h2+ih3QvEMaS9DT+3jwyHCyDQCxbfVOwX3LdY+jc5TmBtketQjellZdkj8XncJc46wJ7iQcba4zZfliV4fCE29NCjga3A+5AiQT1P9pnjqrxfiHWOd2yqvQDCd0WI6GTQT4ETr8l5Ub1oQBLeqZWI7T1kR56c/RujE0V7wnIQMAPgt5QZLE79dZM3HPi0UpabkIgxS/y99n38w7Bpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(451199015)(38070700005)(55016003)(66946007)(7416002)(2906002)(52536014)(66556008)(8936002)(66476007)(76116006)(33656002)(5660300002)(122000001)(38100700002)(54906003)(71200400001)(7696005)(6506007)(478600001)(316002)(86362001)(83380400001)(41300700001)(8676002)(4326008)(64756008)(6916009)(186003)(66446008)(26005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ADnw8G/4+tgljjauPzzX6CQGv46RLQe1y3cy3KTIofRG9duNttpaRs2OPKIH?=
 =?us-ascii?Q?WB5qAWQYFZUGrASKUZ7/cqa7LJjL7U8AYsuY0kbshVHLdUEvgwuS1wUcW4mZ?=
 =?us-ascii?Q?ugvGKQkgK+y1tCbNScnTWA7JuBbmqcZm4jkek+1r7Y7/P/Zx5DZKji8jxdnn?=
 =?us-ascii?Q?iH7sNVx+6rORiiD0ItpodOc42OkS6ctIlXCc9+bL0IDC2yRzxNIcs/k6LqEE?=
 =?us-ascii?Q?492Q9Yy13xxGO0n1JLS7HHJ+K6S5BSUqpHMkB0WZhhYd9wskrXcW/97hgXku?=
 =?us-ascii?Q?WpQY7tTtoZ/Rj59nSfHEWL5hoizzx0MkufkJKLP8RaUh525thosNxwrftShy?=
 =?us-ascii?Q?pKAQ+c8h28Skco3NmS5xwccykrMeGjoNzfpBhaM1GrpK0yqQtqDlgxavByZh?=
 =?us-ascii?Q?hpxEyhfmCSqFk5kLFA+91vv+V7u6WIC7/a7a10kMPi0cXDp4rR7rLc8Ka8JP?=
 =?us-ascii?Q?nS5QQ8+OChXW9F2hCSf9bR8589ks2YZ3T0kt9nVgLGXr+W282p2zrlVKyf6R?=
 =?us-ascii?Q?zUOKgCKKQXquvlCTBPZN1nbBi4DeZaYr+10Qcwn31Q9n7Tzlle/hejt/a21x?=
 =?us-ascii?Q?vxETT0Exi1bLvtJ6O2Ite3vxmTTlnr+Lonj6jGmXPbfvRb0p0IF3p+kxClUZ?=
 =?us-ascii?Q?zj3DxjssKA4f77LaTllxT/c3Zv9JzGu73HtkUOFRxmcH3MigbpO6JgEyEOrX?=
 =?us-ascii?Q?elCyX4ZvuNKCTg73piipYKg3l7oyDuagb7/Vv3CldGAnK42j4ReztL6P3eTr?=
 =?us-ascii?Q?mMqa4iesO2Azi+n3N98dyA1395lRZwVnVd06BmqqfOTNUqvwPcwgvWpfgnoJ?=
 =?us-ascii?Q?oW9EvP3WF8KOxC8gDYnSEZwmdbb/QV4egQpqX+KpDd5MMOmQfC19fZtci7VM?=
 =?us-ascii?Q?LeAyYlVylqZNHV6PlXd6Cpz44XxTjSckAfWkJJKU021vkdAadnMV7RWAKgrq?=
 =?us-ascii?Q?OF/b27/mf8bNiY+wIaMgKWHJtrBKhnI7eGURcKxPb5njb3yRSwqwjSrCAi4Q?=
 =?us-ascii?Q?zSsk4MUYcOw0gJTyUDVRHswJ1AWMj3X31pAeucT45PcZiRFONtnbHYOTkXch?=
 =?us-ascii?Q?rzzSw7bw4nAKLCxdVS0mEW2eriDVR5ik9nIUiQMMfm+uTJ7MW90cRJAd9jig?=
 =?us-ascii?Q?DdCywRiikGQg9LJ8UdCs7si2KwwNxEydcCkG2oxThBSsHKG1GvDgC/DXOOz9?=
 =?us-ascii?Q?Tbk5TV2A2MkVTKs9V8i3qz5SWGCm/GMu9sgItYf5NIqsLBl1Q9JJfF1q2kVB?=
 =?us-ascii?Q?eGYX6gfRE825tJlELxrkzkTXgqjoeUfe9eJSpaXDicjdgq9zdcg5Wp5z6r3Q?=
 =?us-ascii?Q?p/nDMb28UIvg7NwkVRK2R+nUOAIwmWIry57ISl2Fiba5l9lT5z03AQrI/QOT?=
 =?us-ascii?Q?hQIl/+B+vSE/A9sNaoN5QVwu3PMa+8zxGuGAL2Jh+1/Tx55ABib6ZMsZ45gT?=
 =?us-ascii?Q?LO0c77nRF1HSYYfcR/bt1sWyOebMoYR7ti+W+XtrEMnVrb501pVlpF9+4puL?=
 =?us-ascii?Q?dIqxIdrnRR7ws0HtLipRopRQqjvKBKGBM1PMYx641BzH58kZanVCRLn82n4U?=
 =?us-ascii?Q?NFqdM3GZkarG7cSqBBuO5rNC2Mn/jDQ6ohPhVlM+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f2e6f5-e338-4dac-c903-08dafac359fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 08:50:16.1248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DOyVS538A2M6Wof2Ryu11L3IlZzt7MCurY9MG9HnLlLL0DZpiUDGRfkb/uu0/SpkryXpx8VmQ05TTTuZo2jDPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB5166
X-Proofpoint-GUID: inTeMzG1Spxxvhhs-6TepmN6vEsQ4qyB
X-Proofpoint-ORIG-GUID: inTeMzG1Spxxvhhs-6TepmN6vEsQ4qyB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-20_06,2023-01-19_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, Jan 18, 2023 at 04:21:06PM +0530, Hariprasad Kelam wrote:
> All VFs and PF netdev shares same TL1 schedular, each interface PF or=20
> VF will have different TL2 schedulars having same parent TL1. The TL1=20
> RR_PRIO value is static and PF/VFs use the same value to configure its=20
> TL2 node priority in case of DWRR children.
>=20
> This patch adds support to configure TL1 RR_PRIO value using devlink.
> The TL1 RR_PRIO can be configured for each PF. The VFs are not allowed=20
> to configure TL1 RR_PRIO value. The VFs can get the RR_PRIO value from=20
> the mailbox NIX_TXSCH_ALLOC response parameter aggr_lvl_rr_prio.

I asked this question under v1, but didn't get an answer, could you shed so=
me light?

"Could you please elaborate how these priorities of Transmit Levels are rel=
ated to HTB priorities? I don't seem to understand why something has to be =
configured with devlink in addition to HTB.

SMQ (send meta-descriptor queue) and MDQ (meta-descriptor queue) are the fi=
rst transmit levels.
Each send queue is mapped with SMQ.
=20
As mentioned in cover letter, each egress packet needs to traverse all tran=
smit levels starting from TL5 to TL1.
This applies to non-QOS Send queues as well.
=20
                       SMQ/MDQ --> TL4 -->TL3 -->TL2 -->TL1

By default non QOS queues use a default hierarchy  with round robin priorit=
y.=20
To avoid conflict with QOS tree priorities, with devlink user can choose ro=
und-robin priority before Qos tree formation.


BTW, why did you remove the paragraphs with an example and a limitation?
I think they are pretty useful.

Ok , removed them accidentally will correct in the next version.

Another question unanswered under v1 was:

"Is there any technical difficulty or hardware limitation preventing from i=
mplementing modifications?" (TC_HTB_NODE_MODIFY)

There is no hardware limitation, we are currently implementing it.  once it=
's implemented we will submit for review.
