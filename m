Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE7D66B6D0
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 06:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbjAPFS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 00:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbjAPFSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 00:18:54 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8FB7EF0;
        Sun, 15 Jan 2023 21:18:53 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30FMhaav018627;
        Sun, 15 Jan 2023 21:18:36 -0800
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n3vst4spg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 Jan 2023 21:18:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+FcZzM8VRSp/ansJKvRFQcPQJ3Og/n75p2tPGyldmmMrNQPBaDU4pRtHEMKG85Mvrscrex63MSPsNPWBZPTqO/QkTM6LWOwMpQNiMGdXNQoZ5Nn50VfUC+a3SJGQK7iFDUMp4wkUAgioTs2ZV+ZqCsKz6EeLMN9XT9djXwh8mzm43YL6eVFhiGFyTEpcna8HHr0OOiOuC77cb4Xc1Jy1JcPiNfCFBzx+xjXWMUmoa8QCpK57nsJuaxBvFxqobXW23a8QLeqVRh0Pob6rsaH3ZhwEh5Gfwntm2OjLjdI8OrEXNEoGHQJdYWTGP/TRk3BARI30WMdb8MNbkm3W52LPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=biRpyacCCuafmcxZs8SIgXYZ14Az1CAPnS14EaghC18=;
 b=Rl/iDQICgg9zrD1c9c426QtnUfQWY0rPTFxWjK6vvNQDyME+grdn4f4P+8+MnZdzcWDBRlRrZZmmKhkGdU+jnzW/6j2QKLVBY5rbfWec7kx2Rk7fpdTqdroK6/BoQRJ7XdXKT1Kjeb8+9jPpk+mQNxZ0jAIeRoIIfQ/gwbNd/AltFY5N1U18XL0oXw0pMZbHoqNmEi/rIg6b71VcZF8SHx/xvLLIG82mcKTEg56TjrnUxgkBA8BQ9pb0+dKHICA7b5s1rCHOEJXd/M3lHNmaloHW9a46sS5l51ElHhp6hbxkueyrmvYbfqvY+DakpFiDBU9OFltg3YYgOiiJvZNA5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biRpyacCCuafmcxZs8SIgXYZ14Az1CAPnS14EaghC18=;
 b=hn5uY+7nzw59GTPVFdQzOloOwNvROBrW8tbEpuRS35fEpHFp86BE5MGeKJSca0+KFOxUAhXLTPWPF9Ne4KGN4tYtHd/vrHIpAn/Zje6KAcvDIr2deqR2fW3A8sMUooDDUkMZQV+NpRCld0JUZzIfFbbhE+rW4rHbJzkLwMw3//E=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by SJ0PR18MB3804.namprd18.prod.outlook.com (2603:10b6:a03:2ab::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Mon, 16 Jan
 2023 05:18:33 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e%2]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 05:18:32 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Maxim Mikityanskiy <maxtram95@gmail.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
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
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next PATCH 1/5] sch_htb: Allow HTB priority parameter in
 offload mode
Thread-Topic: [net-next PATCH 1/5] sch_htb: Allow HTB priority parameter in
 offload mode
Thread-Index: AQHZKWn6E5zldQI9eUOIw8cmhRCnkQ==
Date:   Mon, 16 Jan 2023 05:18:32 +0000
Message-ID: <PH0PR18MB44748B397A3C1BCBFD57D9D5DEC19@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20230112173120.23312-1-hkelam@marvell.com>
 <20230112173120.23312-2-hkelam@marvell.com> <Y8FMWs3XKuI+t0zW@mail.gmail.com>
 <87k01q400j.fsf@nvidia.com> <Y8IKTP1hf21oLYvL@mail.gmail.com>
In-Reply-To: <Y8IKTP1hf21oLYvL@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctMzU5N2U2OGUtOTU1ZC0xMWVkLWI2ZDItZDQzYjA0?=
 =?us-ascii?Q?N2UyYjlkXGFtZS10ZXN0XDM1OTdlNjkwLTk1NWQtMTFlZC1iNmQyLWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmI5ZGJvZHkudHh0IiBzej0iNTU3NSIgdD0iMTMzMTgzMTk5MDkyMzI3?=
 =?us-ascii?Q?ODQ4IiBoPSJHalErUVdDUVorc1V5R3FMM2JpR2JqemYrc289IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFOZ0hBQUNv?=
 =?us-ascii?Q?eGZMM2FTblpBY0ovY0ZBOFZ2ZWx3bjl3VUR4Vzk2VU1BQUFBQUFBQUFBQUFB?=
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
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFIUUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFCc0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJQVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJRQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIUUFaUUJ5QUcwQWFRQnVBSFVBY3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBQT09Ii8+PC9tZXRhPg==
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|SJ0PR18MB3804:EE_
x-ms-office365-filtering-correlation-id: 500d13b6-bd24-4844-06cf-08daf7811c8b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MRAPBb5dzPqMF+xW41Iqz4x1aekwVxCTYZNLYzr1iTY4D+4Rrs4EHxA9tfNqO6jAYY2QFltUTxVenies9K/miLwk745J91RW6ogwDejayzalqtfTtEno3NgqjgAxcuTJvjNyJaKD1sYCZw5XC2o5dByWoSabYImJPHZo02HxPRTe75ZgfqU/2DXexN8JvuebX/ClYKZYoVQOdfecoRsnceIleZ5IYzEUc8xA2m3/KVP25IDlOjIW+MJpx40SVhhEMDnLtHPF8PQibe7Jj5ebObWHTnNnp1idPgazzfbVV+XcLI6kkjeBelGkclD+xmUiT9o2i8NqXC/iDpkmlOpccCceFo9Qu+GWiaJ2aOOmhOqtRnF/WLnkDhSZh51OaQyXAWfOaMHTWjcnHl0LrwRS9Y979yM+0vr4ROxJn2YARRNlmbT4MWf4yZ2M2rHsOp1xlLubGz0Un6aadnfkRhJioFAtwcPymyZ5egctbuLei+UpBKd/uMqxGxzEJuoCZMZl2J7wrj8FXodhi+8Z6w3en1G6XBcpzewcrvXOI6BnHwNXj9mAwl3STkfHPlmvkDa0/YB5Tlz1/tKVuF4QvPZn1KR23yROLs+/CdQueNgDt1tLP5ZsHYecnvVnYvMAGOKngHTC/+pLye0vp5hVNzLRffdxaud4GHd/XUVXtDcSaQ1z+YDuXvj8ml9JHaFIsfcHPuzQEkkipuOBqpu2yj/E0pI+T3evuUzxxbCddaD+3EFJAacrfH00KpC+5HmQWni4JJunmInHAFjXOi8+1n/jCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199015)(966005)(41300700001)(478600001)(38070700005)(38100700002)(33656002)(71200400001)(86362001)(316002)(110136005)(54906003)(186003)(66556008)(66476007)(66946007)(55016003)(7696005)(26005)(76116006)(5660300002)(6506007)(2906002)(7416002)(8676002)(9686003)(66446008)(4326008)(64756008)(8936002)(83380400001)(52536014)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5Ln0rhJDPvAXkic6BwTg4f/BKRaMa66k76VNvzhjZuY7BBnMLwdl8cYbixeA?=
 =?us-ascii?Q?rQsxrj9ZmgGs9BevVXyT7NRGRR3T/uYRxyTO4eqdQyYH/I4uL54bUxOvLg0Q?=
 =?us-ascii?Q?3YdQJ7wiXB5TPkJ8KLGJIdZkRdXx/KRalw621rjPa3yFLjqP7FBKh8672E0C?=
 =?us-ascii?Q?vzaAzkKysfLFwnd4w4SHf/9nDZ9z1FVgdRvYLqsjIKM0lvBHy0RVKmlcv3jx?=
 =?us-ascii?Q?y/L6L5EzsK8Htr8Z6SBMDmM49fcumWZcDH1DUeSUEpUc376VMu7FphLNNTvY?=
 =?us-ascii?Q?+PnkYSidcC+ZaBPutKWS7znyBlJpRqSaaYyRqsJaEughz1l4GSMIlVzOXYfl?=
 =?us-ascii?Q?OgaXYhshwyEyy5ZsDorh5Ft2f8+XJJn5UEd4pbbjsj2YA3HyKfdPjHXRv2HL?=
 =?us-ascii?Q?48ylArCPuaw38aw721mc8voa9eqggT2qLu0c2lLFsC/Urw8WDLEcfP58bc5W?=
 =?us-ascii?Q?4HSSzICez8bJS9fEoRJGi6BbGXKoj1CqxyFgwDeAZh1IiSuW5Swgio3L8lL+?=
 =?us-ascii?Q?3tvIV/oVa9t6hYn46Nx7wANSZ+vKd+14VNEy46QlzhGwpX/TLGrzQZadpoXz?=
 =?us-ascii?Q?l+DAYvAbamQgKRXPLEK4f7+RWt8nz8HDC1icpmCqG2oKr9Bf2vbUEQQlrjr8?=
 =?us-ascii?Q?Ljf7Tl1V/kHOmLrc4RgdmG4wUazkEbiHN3Bo7p9D6fiInYBWBgnXdFLsxYJI?=
 =?us-ascii?Q?gBR8zxtBXgNw4dHZMZd2YzMtVTubUz3bvNgTAVw63wXrFWjh94e4n1HXF16V?=
 =?us-ascii?Q?xT6we6CqMDUuagZNyMRDztIw4EQRCQEttIMUYg89jaE4OgGA0QTtIVM0vZ9X?=
 =?us-ascii?Q?VDBXEBmsy4cG+y6kX3l1MGB7vESV+2XZelTDY3IRmpBVqDtxu82iBlTKupgf?=
 =?us-ascii?Q?cgtrHH4+qdgvYnE/YgtK1Mtf6GXVsKc23qK2d7KCNdRmitArzCXrtpKuNvFp?=
 =?us-ascii?Q?BDekELpraZM7wRaevxDQVmn1YsLwvynfvRJ/Rbl1e3uJIqw59XviqULaRnhH?=
 =?us-ascii?Q?6rkxAlTicsV6dsJGmGMNg40+pmpsRdBpNZ4Uekt28KDiaD59d6DJi40T4CxH?=
 =?us-ascii?Q?z/pWdMl1B32XVV3JXx9bAtXuXhBu1ceYdEi6jbRsTRxLDBQfS+kgZ9O3eXoT?=
 =?us-ascii?Q?kbtNF9F2/du46fRh0+QluX58g8Gb3wzIRZCgoB6CQQh3cSM7QXwBsnfQZnAL?=
 =?us-ascii?Q?RMRwOZFkHM3LU48OdiCr5ec5Ue3OgppJ9SNFJANs53IONP9pahrB9SRuwqp2?=
 =?us-ascii?Q?jYjKaa2aYoa9NBHaXj7mw/2H1/pPYJeJ2cK6EiaOyr5ksIAiXxXuJcEp8XzH?=
 =?us-ascii?Q?xadtMClSUFPlQumhrc3oJYuVlpRF3Jm5LQNGM4PkPDm/oVTx/32v/MX8as7j?=
 =?us-ascii?Q?A7dDur/Jx+aEYAzYUs8Q8qgouwmEjYSc+FiHZbH1oGXNyI2LWuyC1ScHSOp/?=
 =?us-ascii?Q?+tFxA6eAqhqIMmczfqZBRnpat7PGKwZwCnVpXhbyVZt3n4feBsPBAls3eP79?=
 =?us-ascii?Q?/QU+FDMAbw9YyK78tfFfSXSsIDkf5MlA4RMpdFa+yOaxEVbvinMDGlRJvuSb?=
 =?us-ascii?Q?UH715CqAbXhL6qii4Gw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 500d13b6-bd24-4844-06cf-08daf7811c8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 05:18:32.7749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q4MJpp5xW8QL3s3lPFtk3mmwyb6glSxqeh9D60lcpqN0f/Oec2M9eLBQxtrqGQ+aEUgQt3nldbmyfro/wn+prA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB3804
X-Proofpoint-ORIG-GUID: x73xDzeMtYFK_dEMSx9L45KMw___F4Vc
X-Proofpoint-GUID: x73xDzeMtYFK_dEMSx9L45KMw___F4Vc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_02,2023-01-13_02,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review,

>> If you extend the API (for example, with a new parameter), you have to m=
ake sure existing drivers are not broken.
   Sure, we will add checks in existing drivers for the new parameter.

Thanks,
Hariprasad k

On Fri, Jan 13, 2023 at 01:06:52PM -0800, Rahul Rameshbabu wrote:
> On Fri, 13 Jan, 2023 14:19:38 +0200 Maxim Mikityanskiy <maxtram95@gmail.c=
om> wrote:
> > On Thu, Jan 12, 2023 at 11:01:16PM +0530, Hariprasad Kelam wrote:
> >> From: Naveen Mamindlapalli <naveenm@marvell.com>
> >>=20
> >> The current implementation of HTB offload returns the EINVAL error=20
> >> for unsupported parameters like prio and quantum. This patch=20
> >> removes the error returning checks for 'prio' parameter and=20
> >> populates its value to tc_htb_qopt_offload structure such that=20
> >> driver can use the same.
> >>=20
> >> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> >> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> >> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> >> ---
> >>  include/net/pkt_cls.h | 1 +
> >>  net/sched/sch_htb.c   | 7 +++----
> >>  2 files changed, 4 insertions(+), 4 deletions(-)
> >>=20
> >> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h index=20
> >> 4cabb32a2ad9..02afb1baf39d 100644
> >> --- a/include/net/pkt_cls.h
> >> +++ b/include/net/pkt_cls.h
> >> @@ -864,6 +864,7 @@ struct tc_htb_qopt_offload {
> >>  	u16 qid;
> >>  	u64 rate;
> >>  	u64 ceil;
> >> +	u8 prio;
> >>  };
> >> =20
> >>  #define TC_HTB_CLASSID_ROOT U32_MAX diff --git=20
> >> a/net/sched/sch_htb.c b/net/sched/sch_htb.c index=20
> >> 2238edece1a4..f2d034cdd7bd 100644
> >> --- a/net/sched/sch_htb.c
> >> +++ b/net/sched/sch_htb.c
> >> @@ -1806,10 +1806,6 @@ static int htb_change_class(struct Qdisc *sch, =
u32 classid,
> >>  			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum pa=
rameter");
> >>  			goto failure;
> >>  		}
> >> -		if (hopt->prio) {
> >> -			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the prio param=
eter");
> >> -			goto failure;
> >> -		}
> >
> > The check should go to mlx5e then.
> >
>=20
> Agreed. Also, I am wondering in general if its a good idea for the HTB=20
> offload implementation to be dictating what parameters are and are not=20
> supported.
>=20
> 	if (q->offload) {
> 		/* Options not supported by the offload. */
> 		if (hopt->rate.overhead || hopt->ceil.overhead) {
> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the overhead param=
eter");
> 			goto failure;
> 		}
> 		if (hopt->rate.mpu || hopt->ceil.mpu) {
> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the mpu parameter"=
);
> 			goto failure;
> 		}
> 		if (hopt->quantum) {
> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parame=
ter");
> 			goto failure;
> 		}
> 	}

Jakub asked for that [1], I implemented it [2].

[1]: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kernel.org=
_all_20220113110801.7c1a6347-40kicinski-2Dfedora-2DPC1C0HJN.hsd1.ca.comcast=
.net_&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3D2bd4kP44ECYFgf-KoNSJWqEipEt=
pxXnNBKy0vyoJJ8A&m=3DBHYls0vs10PjYQd-g7Lv51bPiN5Ay-x1lca_mGg_S_tH2pfwR7uADD=
ykRTMmtVcU&s=3DFQPgPEhy6I2JRBqOmbyX8xAU69oNnUrl33ZR8QY8ZuM&e=3D
[2]: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kernel.org=
_all_20220125100654.424570-2D1-2Dmaximmi-40nvidia.com_&d=3DDwIBAg&c=3DnKjWe=
c2b6R0mOyPaz7xtfQ&r=3D2bd4kP44ECYFgf-KoNSJWqEipEtpxXnNBKy0vyoJJ8A&m=3DBHYls=
0vs10PjYQd-g7Lv51bPiN5Ay-x1lca_mGg_S_tH2pfwR7uADDykRTMmtVcU&s=3DwHguR00zCQG=
Iop1-2XwsXa_PWXD-J8hMRKhtIuWXjOE&e=3D=20

I think it's a good idea, unless you want to change the API to pass all HTB=
 parameters to drivers, see the next paragraph.

> Every time a vendor introduces support for a new offload parameter,=20
> netdevs that cannot support said parameter are affected. I think it=20
> would be better to remove this block and expect each driver to check=20
> what parameters are and are not supported for their offload flow.

How can netdevs check unsupported parameters if they don't even receive the=
m from HTB? The checks in HTB block parameters that aren't even part of the=
 API. If you extend the API (for example, with a new parameter), you have t=
o make sure existing drivers are not broken.

>=20
> >>  	}
> >> =20
> >>  	/* Keeping backward compatible with rate_table based iproute2 tc=20
> >> */ @@ -1905,6 +1901,7 @@ static int htb_change_class(struct Qdisc *sch=
, u32 classid,
> >>  					TC_HTB_CLASSID_ROOT,
> >>  				.rate =3D max_t(u64, hopt->rate.rate, rate64),
> >>  				.ceil =3D max_t(u64, hopt->ceil.rate, ceil64),
> >> +				.prio =3D hopt->prio,
> >>  				.extack =3D extack,
> >>  			};
> >>  			err =3D htb_offload(dev, &offload_opt); @@ -1925,6 +1922,7 @@=20
> >> static int htb_change_class(struct Qdisc *sch, u32 classid,
> >>  					TC_H_MIN(parent->common.classid),
> >>  				.rate =3D max_t(u64, hopt->rate.rate, rate64),
> >>  				.ceil =3D max_t(u64, hopt->ceil.rate, ceil64),
> >> +				.prio =3D hopt->prio,
> >>  				.extack =3D extack,
> >>  			};
> >>  			err =3D htb_offload(dev, &offload_opt); @@ -2010,6 +2008,7 @@=20
> >> static int htb_change_class(struct Qdisc *sch, u32 classid,
> >>  				.classid =3D cl->common.classid,
> >>  				.rate =3D max_t(u64, hopt->rate.rate, rate64),
> >>  				.ceil =3D max_t(u64, hopt->ceil.rate, ceil64),
> >> +				.prio =3D hopt->prio,
> >>  				.extack =3D extack,
> >>  			};
> >>  			err =3D htb_offload(dev, &offload_opt);
> >> --
> >> 2.17.1
> >>=20
