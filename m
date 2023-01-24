Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0FF679703
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbjAXLuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbjAXLuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:50:01 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1678C402C1;
        Tue, 24 Jan 2023 03:50:01 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OBIVwa006200;
        Tue, 24 Jan 2023 03:49:51 -0800
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n8gerftxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Jan 2023 03:49:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gbm8JsqJrIQmqZYYOg5FTE8ni2zprOcm3B+x7PKYq4jOYMaziI971P7Kla1sDfnX9URvSwG5noeapVatP25KWHfmt6AGQBjMFDpvYur9K7z8eWX+9XV0siZ2lESxkmuhId90y2YFymNdxlOk4+IPMguo9Bgn8rzPnDyoOa2AJ0C4qHJWQgyWA3fvE9Ws5GzXvYvZliGSHnzXWmHZU6b1O13bFBvfLVh0Bsz4RTLSubU/jzg8Rkk1ScFqx1UUmN++YgGEFCaw/cgS+Af+6ZojLRqKNtZoD37zkGz0m1MTpnm5HsRO1ZmPeCdb0qoB6jIMCIiodRqJ/q5T0gzs7St2QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qKgGPOqIhveCzochf/Q0ebLzCCb4KdYX0BYsQHp4boQ=;
 b=ZW70H/AAzHSDXfHLSHRsWr7F3ZrV0KIrKuu6zOSgBlr1hSnNRsztGUoy9ifpFUGaJQq/E5flvlVzBqh3GY+uOnKz7DVFiwiqqVYdWDpgVYNvuMscfX51ze7S/fgAFtvx0X1KIAO9axoXvSCUb+ubixeQgQRIQmhS8O+ucoAGnhf/FtlhmbS3NocoDbUDwr4EQOA/mUyDU/m89NNumxCYTKaN4+NkKPySDj58xWdDTx6IH9WXCA4psh2bCr2FwXPYPHStsqLH+iSDgF3SN4T8FfBimcZffIxdFU1Evg8xsH+JbaevuglDn7muvGOm9QXSAFZ0d3zJ/zoMeJgA5iBNTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKgGPOqIhveCzochf/Q0ebLzCCb4KdYX0BYsQHp4boQ=;
 b=BIKsodWoXyexdn730GnoC9MpPXwelJzJ7YS1t6VJCAVI24+RrNEBjDK9ihPekhFHjBIjGlXYqQxMy2cSMPRnXyJlC24iFCkEFvny2knj7iBv/SAZXSYzWVsbe3X4lAHjoUUeJ8JNutcNc0GSMGD8ILMI8PT5uA6m/zmgyUVVFm4=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by DM4PR18MB4222.namprd18.prod.outlook.com (2603:10b6:5:391::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 11:49:49 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e%2]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 11:49:48 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Maxim Mikityanskiy <maxtram95@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        "hariprasad.netdev@gmail.com" <hariprasad.netdev@gmail.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: Re: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Thread-Topic: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Thread-Index: AQHZL+n1iE8p6ldbf0mFARjxWm2brg==
Date:   Tue, 24 Jan 2023 11:49:48 +0000
Message-ID: <PH0PR18MB44748DFCCABCDC2806A2DC2CDEC99@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20230118105107.9516-1-hkelam@marvell.com>
 <20230118105107.9516-5-hkelam@marvell.com> <Y8hYlYk/7FfGdfy8@mail.gmail.com>
 <PH0PR18MB4474FCEAC4FA5907CAC17011DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y8qZNhUgsdOMavC4@mail.gmail.com>
 <PH0PR18MB4474DBEF155EFA4DA6BA5B10DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y803rePcLc97CGik@mail.gmail.com>
 <PH0PR18MB44741D5EBBD7B4010C78C7DFDEC89@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y87onaDuo8NkFNqC@mail.gmail.com> <20230123144548.4a2c06ae@kernel.org>
 <Y88Rug7iaC0nOGvu@mail.gmail.com>
In-Reply-To: <Y88Rug7iaC0nOGvu@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctMmY0YTZiNDktOWJkZC0xMWVkLWI2ZDMtZDQzYjA0?=
 =?us-ascii?Q?N2UyYjlkXGFtZS10ZXN0XDJmNGE2YjRiLTliZGQtMTFlZC1iNmQzLWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmI5ZGJvZHkudHh0IiBzej0iMzA4NCIgdD0iMTMzMTkwMzQ1ODEyNDAz?=
 =?us-ascii?Q?MTQ0IiBoPSIxOW52b09iZ0pJSFh2UElDRmNGa2FJRXdTTVU9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFOZ0hBQURJ?=
 =?us-ascii?Q?NDZqeDZTL1pBWDlVcVpKYzlqcUZmMVNwa2x6Mk9vVU1BQUFBQUFBQUFBQUFB?=
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
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|DM4PR18MB4222:EE_
x-ms-office365-filtering-correlation-id: d9964c2f-947a-40a4-ef8c-08dafe011855
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mpJfQEm8VasntIIuBJn9sNiCdGgAwj7JwpBVJEGs4LkhHIPA+JsCSEUZqHpBofEt2P2N+eCIoyHkhc88YTs2JpvZyV5Ck6aD59g7puzRRU7czb7xjyvDamXCVZo4xqbNy1NcL3Db9uqXpXG/wRpZtKVHZO9i/B08lyQ33gBPWRXOVAcUUDtmDCjpRqMdmC51xkNGIE1vanJdQb5mda8XkZKqXayAjhQ0Vxl4/QqcFT9jwXdehf3tFcoTKSlTk810riQRPjv4OQ9jeFFiKvXkiXziDYf4pAHrYbzOA9U5hgF1ZDUMwiBAbD1I0duNDlp1OpKptaKXScTFUAEfWOT92Q/NUWdTU0MW7xt2cPTSgo0hkJF3KI3cS00mn/C1peZi/3j9ayUNaW0ea/LnZJk4aiuOTcTXbcF7uetSKWIIK73deqqPRYHra7uwCTTVbUw8AjHx0j99WAUSUJ+YWs92o0kxzw/W1Kfz/nF5xGdRh0Y57TdKwxzBruv2/mAIyDwSLqyywtnO6/UcQRu4DkdxZVo25nQmBlr4cNmIlFYu1D9ORjpeQJbfK4RSGlSKGJBJNsMyY+D3pOq5SdacgOZ232t15+CKCoFKluP3fJoIFwmNHZrpxhgfwjcNLXF4XoPcUBMD9OP/Ev1C9q6/tysv30Ca0atduVaPY7Z/Xb5yiJbkNPjUPo5XtEdfudu16BXdAe347ux7XK6T2pYe/NhxOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(451199015)(110136005)(7696005)(71200400001)(76116006)(66446008)(8676002)(66476007)(64756008)(66946007)(66556008)(4326008)(186003)(107886003)(52536014)(9686003)(8936002)(5660300002)(41300700001)(7416002)(2906002)(6506007)(33656002)(122000001)(38100700002)(316002)(38070700005)(478600001)(54906003)(86362001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xydTHhS781fsIBoSGnWlYSVIbkbIcKYWbd+nOJAOJCYzmLu7D/2jo65YYSMa?=
 =?us-ascii?Q?gJB8aogBp4nJypHmwyV0J3An1KcN0hZp0P0ed5aYCdWgphgfNsxSs2zmQOjB?=
 =?us-ascii?Q?hdda+rxyoTXy9m6txthS89loZ9RLhs5irZxjGifx7VEL/y46jDhYF959pcae?=
 =?us-ascii?Q?8TzswoFGs0ylNIz+FIuN92oynPLo/0RpiXmyOfXyTN7cTmZT+88OnGY0Ov1A?=
 =?us-ascii?Q?3i7EngRSNBw+hDxMRnXymBaTmcaIWqczilKharnOZO0BdHe4k+GBMaJmMg3T?=
 =?us-ascii?Q?x/iZ8i+UCeueMYn9zwUNiG5QUt90/Zd1gVWBm0bIwOwe9QDwa4FT3v5efCnl?=
 =?us-ascii?Q?MKMKwvo/I9wY4dfWvcjSyLvTqPXz98jCWHK3spcW2XK77Bu2efMPeLa5ANNY?=
 =?us-ascii?Q?aThlFwS/MK8VF/8f4+UiUsahQAXHJQPJ9dKbUbC27AQyn3cRvvGkbUAjAGRI?=
 =?us-ascii?Q?RcS7ltIF48hhUjfbcxYbM5gbHsmXTM1PQw7HnZZFuB9CZ7mMGD9vyGLZw5J3?=
 =?us-ascii?Q?gq9bI/LYuQJzx8V5Z0Nt1rwtcOiz69WzIzD1C+6joZm6RADKscRQxJIMOEXn?=
 =?us-ascii?Q?UgSS/7VL/AiETlwcztczoN4ei6NLV7xzFSawux8/meqW3FGBYSMnUj3opkLP?=
 =?us-ascii?Q?4ZM9MyGFp0jskhwm/p0BuAq7fKYlndLvmAHVvDfFwXhZXiPt+F6YpjmpVZr9?=
 =?us-ascii?Q?DqhtA6a9t5XCPKPG2D6ipDgjkvmJ58Sj19nsUvh5JGoh1IigfWLIbqOGTA2m?=
 =?us-ascii?Q?dmhQ16YG8SStS4RGoKZAeJKgYuAezZZfGmct5qmuqtwwzc4Vp/LP+9jK5mDh?=
 =?us-ascii?Q?GNGpXqH6YRd2VD0OSDHtu9AbRkX9e8e0SWM2BRMuC6QGRgvLQuqL+E5/Bl5g?=
 =?us-ascii?Q?6e49zVNl4NE4RANnmpBH9rRwRmw4M1Jyq/dviJqH1ODSjpNh+YaVc7cOfW2J?=
 =?us-ascii?Q?PM/qemwMPmIcL14BGBlHlan0QDspVsmjnk5xVezrrMYdeEz+NEUjg7cYmBaj?=
 =?us-ascii?Q?qqYQW9g2aX3e7gULqHTYTp+0nCt4qA1OwVyBGm2OCziAzO28v+PplaKQv1Dc?=
 =?us-ascii?Q?FdnQZiEjtOgYfF618xUwGGF0R2FXakJVqPa/qUBIXzLgNCz1kUEpL1tvlgdV?=
 =?us-ascii?Q?+lN5i/boHdKw4l16AdyvnmNqxQMh8ZH1I5PjPi/oU/keQeck1Yucun+UiUzW?=
 =?us-ascii?Q?iBgZK7rWNkF/kvoaTjVyJDyZsaA0JAHxPuyczM7LIAH5Jdh90Wz0JC3aN4yY?=
 =?us-ascii?Q?7WxQZVktMSiPFTZ0652VzTsl4r2nUOhN24naDpkEto8ptCPF5B4mN252hWMu?=
 =?us-ascii?Q?M5XpZX+6MHfsr3Jd7DNJe1dEYtfQTMROSZZEWAnocE14eSsat7D1Z9AsrW0N?=
 =?us-ascii?Q?wzljoWZHfJf02vXLdhcAEybxdICPY6SBXQjvv/G0ueIB9RdfisrxJt4V9Hru?=
 =?us-ascii?Q?AGaPiF/UB13rhBgjj+fYebylPuYxyRTBlG5MhdyPJXKhmi2PNCssyysw5J8E?=
 =?us-ascii?Q?tPGQhedvv5BE6MJMCXCY+LKC+tqtjuMnTJD7p63GlEiWNkK6tnRuVxuhdIir?=
 =?us-ascii?Q?dFI+LMmVZe+yD3DA0ncSEtrgJ6X7RP1p75b8cnoTvdlEi4X/J/WyOR66l+AM?=
 =?us-ascii?Q?/bj9rXQdQ2zkYrz+aPWHg9GJsjMBPCwlF9F5/pHtZ64E?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9964c2f-947a-40a4-ef8c-08dafe011855
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2023 11:49:48.2429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R3Qwsok0PGAe1QC6dUIVl/XVx5pSOSIgUsPutPum2JwipAE6vuEiNHuk106qUOXOA3UMz/9R0g5uG8dOPAkHOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR18MB4222
X-Proofpoint-GUID: TDe45cSI4Wv05FTrXBf7ptq5rkHTeXWf
X-Proofpoint-ORIG-GUID: TDe45cSI4Wv05FTrXBf7ptq5rkHTeXWf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-24_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mon, Jan 23, 2023 at 02:45:48PM -0800, Jakub Kicinski wrote:
> > On Mon, 23 Jan 2023 22:05:58 +0200 Maxim Mikityanskiy wrote:
> > > OK, I seem to get it now, thanks for the explanation!
> > >
> > > How do you set the priority for HTB, though? You mentioned this
> > > command to set priority of unclassified traffic:
> > >
> > > devlink -p dev param set pci/0002:04:00.0 name tl1_rr_prio value 6 \
> > > cmode runtime
> > >
> > > But what is the command to change priority for HTB?
> > >
> > > What bothers me about using devlink to configure HTB priority is:
> > >
> > > 1. Software HTB implementation doesn't have this functionality, and
> > > it always prioritizes unclassified traffic. As far as I understand,
> > > the rule for tc stuff is that all features must have a reference
> > > implementation in software.
> > >
> > > 2. Adding a flag (prefer unclassified vs prefer classified) to HTB
> > > itself may be not straightforward, because your devlink command has
> > > a second purpose of setting priorities between PFs/VFs, and it may
> > > conflict with the HTB flag.
> >
> > If there is a two-stage hierarchy the lower level should be controlled
> > by devlink-rate, no?
>=20
> From the last picture by Hariprasad, I understood that the user sets all
> priorities (for unclassified traffic per PF and VF, and for HTB traffic) =
on the
> same TL2 level, i.e. it's not two-stage. (Maybe I got it all wrong again?=
)
>=20
> I asked about the command to change the HTB priority, cause the
> parameters aren't easily guessed, but I assume it's also devlink (i.e.
> driver-specific).
>=20
Currently, we don't support changing HTB priority since TC_HTB_MODIFY is no=
t yet supported.
The driver implementation is inline with htb tc framework, below are comman=
ds we use for setting htb priority

ethtool -K eth0 hw-tc-offload on
tc qdisc replace dev eth0 root handle 1: htb offload
tc class add dev eth0 parent 1: classid 1:1 htb rate 10Gbit prio 2
tc class add dev eth0 parent 1: classid 1:1 htb rate 10Gbit prio 3


> If there were two levels (the upper level chooses who goes first: HTB or
> unclassified, and the lower level sets priorities per PF and VF for uncla=
ssified
> traffic), that would be more straightforward to solve: the upper level sh=
ould
> be controlled by a new HTB parameter, and the lower level is device-speci=
fic,
> thus it goes to devlink.

The PF netdev and VFs share the same physical link and share the same TL1 n=
ode.
Hardware supports one DWRR group and the rest are strict priority nodes. Dr=
iver configures
the priority set by devlink to PF and VF traffic TL2 nodes such that traffi=
c is forwarded
to TL1 using DWRR algorithm.

Now that if we add htb command for unclassified traffic, at any given point=
 in time HTB
rule only applies to a single interface, since we require to set DWRR prior=
ity at TL1,=20
which applies to both PF/VFs, we feel it's a different use case altogether.

