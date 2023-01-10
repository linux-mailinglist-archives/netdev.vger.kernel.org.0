Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFC3663A3C
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 08:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjAJHz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 02:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbjAJHzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 02:55:35 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020784881B;
        Mon,  9 Jan 2023 23:54:45 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30A2hr2Z008708;
        Mon, 9 Jan 2023 23:54:37 -0800
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3my94tt1x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 23:54:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wowc/X5JyUB8deRy4PRK1cGNCHvInjemnHN+LJS2Gzcc+MBrORigDyuVw7B7a/vrZS7cJmky5qw0NQmy2qbfrXY5mn51q/jXeChiZTXZ4aRhEm7ucwH0dfXd+sDC0e6/r5VVFR661xV9ITE+GTb7Uz9dkr/XKQDI0pReh2xMEi/BA/gDlbOke+ngkO2M5zIUXiMOMVZeB3lvEtWGEbkPV72xSZb27N56zWko/q0E9wJcTiWESMqQyJZ58diFwzY+sJZj3a7BP8qxnu5dW0DEsm3sY5a3mJ2EMRUTirxrMKxUaGYuGv/US2Dd//DbP0kt21UBBvJ5N4kcBjyXZl/YGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgNwFwA2XfeLe/rM9b0v5A/Ak+JljOmVx7ymmRRY4f0=;
 b=jDQAPMnRKx+LcK5rG0yYZnKgIgXhPAGrznafDzMYp/qpXE0nEubsCrKxYrNuvRzOF/NCETcbfhQY1DuvYJ3BdWi77bcMS6u86PvqVgJZKjorhdXa2yti7ORrcChkyH46odSE05zVjyr23twUmR3mnJFJl/3Q/9bLlvkI/hmdQyGceJcFe3Qiz1YwMS4gK5FtbzzjgfUmRY7AqvZAW7ZT6DZMVucW99h32JyuUnqjAZCOb8tx5LHIolM0K1oU0SYdx8VrjOrBE4rxlOrN4SAvGzV9qrfGoziVZpvIvMMFd5h/Qflj0bvtvE1Hy39w8quM9o+GrEGG93OcOI4WJwboxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgNwFwA2XfeLe/rM9b0v5A/Ak+JljOmVx7ymmRRY4f0=;
 b=YVC2q+iB0DfiOeZF7bctrCJ51Ke3jMYYoUre6zBlAnyR6Wpp1wTfUy0S0ZF14DJEy60mfn6Q2+5ltAuFWTWbt6k4OOFU3OVxmYJehnBCdCs/i2hQ3JzyMHKHysnJwwH7besR7sl3qQG6dIbiCUEg04NBKfEFoFWsRQ2Ni5aUPIM=
Received: from DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25)
 by MW3PR18MB3610.namprd18.prod.outlook.com (2603:10b6:303:52::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 07:54:34 +0000
Received: from DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::3cca:ec69:9827:a746]) by DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::3cca:ec69:9827:a746%7]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 07:54:34 +0000
From:   Geethasowjanya Akula <gakula@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: Re: [net PATCH] octeontx2-pf: Use GFP_ATOMIC in atomic context
Thread-Topic: [net PATCH] octeontx2-pf: Use GFP_ATOMIC in atomic context
Thread-Index: AQHZJMjHQXU1h4wUiU6krrAQOSBT1g==
Date:   Tue, 10 Jan 2023 07:54:34 +0000
Message-ID: <DM6PR18MB26020126CE7BB48D3C2AEC26CDFF9@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <20230107044139.25787-1-gakula@marvell.com>
 <Y7rAUVXiRNFsuR8y@unreal>
 <DM6PR18MB2602C7D1546455B12340D140CDFF9@DM6PR18MB2602.namprd18.prod.outlook.com>
In-Reply-To: <DM6PR18MB2602C7D1546455B12340D140CDFF9@DM6PR18MB2602.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcZ2FrdWxhXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctMDJlYzI5ZGMtOTBiYy0xMWVkLTk1YzgtNDhhNDcy?=
 =?us-ascii?Q?MGFkNGE3XGFtZS10ZXN0XDAyZWMyOWRkLTkwYmMtMTFlZC05NWM4LTQ4YTQ3?=
 =?us-ascii?Q?MjBhZDRhN2JvZHkudHh0IiBzej0iMzExNyIgdD0iMTMzMTc4MTA4NzA4NjI2?=
 =?us-ascii?Q?MTM3IiBoPSJRYkdCYlRPRThXc0FaMjlURzRLZnJQcjE2Vkk9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFOZ0hBQURa?=
 =?us-ascii?Q?bm0vRnlDVFpBYjY3NzB4aWFhU2V2cnZ2VEdKcHBKNE1BQUFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
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
x-ms-traffictypediagnostic: DM6PR18MB2602:EE_|MW3PR18MB3610:EE_
x-ms-office365-filtering-correlation-id: 4c81462f-1e3f-4ddb-1a0d-08daf2dfea0c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eLjZ2xJDICJUAYfMVHiUhLPOX10DgQcE/SnqrNJFuW+9+bHu+rUigpCPt4JZMLvyQy16nNHA9qblFKqsDc7ftpk+M88hHNUicbbAlL82wlCha4QCJIqoscvWEhhYbRwZgJlGOoFe2SW6BT6dgkRT+szSsjPgygCzeHcDYInHE+PpFxSl7YCTswVO1ePzJZwyIGTNY0P0OXqG6OSgPX4MqA2fBXKZhZjosWlsaxmFokh3kLEa4dU+QyjzhFXij2z3hDZe8Wul9iIaEU6STDyqpZOEyYeEbwsOFaZEW5ZTgD/fO2b0R27YgkYCUm9b4KjEYhkVfffKLa3+KHf84DfQRC9RSluXkzO+TiSQ6zWjtWGMN7MfIJFg/JGInHW7Tgw+FMf5077o8UeQSGe21wV4UUAZG/kRpXyx3g3xwgAHH32fAYwdPVRUgKEocumaCLD4BB1KMXIBPQ6f3j1oO6gg1YtHezlp26yBY0Ch7+5dU/fF4X6aDOXkt9R5EkXvfmjN8XD7eRplguTCQ4Bzbv2CertCAE8dVNiuGJvha0HScVqcON47aMcQV97zMY8eaqdTa/qtOnn+7Zn5b/EFY7e9qvU5kf1f/NAKRdlFTcBDHyvpt7fx8QdxmJ37OI8cxDgWOcUXEeWFwpzBx6Ne7dZkaPpydm4hhBVA84cTHtZAgIaZfmHY9T9fqlBkdEj71p3hLVnD4BO9tYl6Ymhv9Z30ow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2602.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(346002)(376002)(366004)(136003)(396003)(451199015)(6506007)(38100700002)(122000001)(53546011)(107886003)(2906002)(33656002)(38070700005)(26005)(186003)(2940100002)(7696005)(9686003)(478600001)(71200400001)(316002)(5660300002)(52536014)(8936002)(83380400001)(86362001)(41300700001)(55016003)(76116006)(66446008)(8676002)(4326008)(54906003)(66556008)(64756008)(66946007)(66476007)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wsBOLk7Z0y37XE132F8oMqgVpQyAj+X+HSVIdmRi0UMssxtUCernejfK955k?=
 =?us-ascii?Q?rEqNPq0zQIarFZTIKiiuOiOke8qdnA9WQov5YOgFs+uzGafEbEp1bkpAhUvA?=
 =?us-ascii?Q?GYPpKoT3tteiD4VscV6RGIKbIYYcDAx1C3aOFYPghBZXw3ssCe4/Bo2xlAKg?=
 =?us-ascii?Q?eMF+RdYmcN4qJAPAHBlXyQpuRY/UyreS/NZyAlQ/MhXSosCsryF4RiTxM5FB?=
 =?us-ascii?Q?QmkUmycTcB3eYhBm6vXxd41VbOW6BvpOlq/xhHuw0EFF/bFEqb3ursyndV2M?=
 =?us-ascii?Q?9g3f/RgYMWvhnOPd7dcSKsqLq1mOUgtgslexFjY2L19R+LK0dhMmOr+x1sJE?=
 =?us-ascii?Q?p4K8KL9jbPJ9K7nzEPW/M9Bsy43gfX3tENLAbhdlstD0owlydqCw4oNFC5Vm?=
 =?us-ascii?Q?/uZPWtjUqIh8lzTDk6w6wQN+0vhEEB21pFHqvZ+b7ozAdyh4q4VNNA1sQdEI?=
 =?us-ascii?Q?KpUmEBTcBnkQszyelhJ10c9qCZiSMubuiExQ5WJ27VczIBJslf8WQ/9ypcU1?=
 =?us-ascii?Q?WUxjoFTpJ5dRV69QnYyE35S4S0Ubf27KoFhOm6Vxx3er6cm51iWaWlJQHd9P?=
 =?us-ascii?Q?lire5WPiQBPJrcjzwcxTRiIbd7YNjnwVtpkdvPixT+5LgxAxBEHOre5OtjWT?=
 =?us-ascii?Q?a1Q3Yk8D0h/5za68MRYyTrUddi45QRbMmdT44S8knxAUKGD4mkLar7LSItdM?=
 =?us-ascii?Q?WYIGhQgUZuOIVy/19K1LyqOw9UbjSRlg75wwcRQjSUNVKRsONwsJ1xeJbPPQ?=
 =?us-ascii?Q?C3Y4kuuWIrKh3rA9Irlg7LmBjZxAiUUpYO2tXmtnZgCYlsFBeu4w9yTWUs8I?=
 =?us-ascii?Q?Xw1ZIvzXzm6fyeeD8/wNsqUI3L+2LbZVJDQ+vrZQZ5BXzJQ6fCQGS9QZsbYj?=
 =?us-ascii?Q?NQ88ot48PdzArsTPo19DjLcIUw4vkuliWoJVZg1c/FIoUwc7zvUVyayTEUNy?=
 =?us-ascii?Q?Outn8hx502twENF/uNHKfyqrH+0hFUOid3TRcFvvICLsXBNRuHTGVQWeusyD?=
 =?us-ascii?Q?y65F+PvHmxYl/+UR9z/M43mIhb/tsKZlt/xHt4pfirEIS8KgKn/vnYpmRUfg?=
 =?us-ascii?Q?di9ulYF6/0KaReZXngHFQqQ3FIItDYwK9c42c+DA5I3RTJ5AD9vbY4NyS0Gw?=
 =?us-ascii?Q?cSHuz8rtMTZ3vxzdI7Co0/a4hiZngwF9WnUBT+YJ+KUQMWSTiabMOkRDjsXu?=
 =?us-ascii?Q?Iewl5Bga/CYrTpxFg1nOzDSBRKG0Gr7PpDgiX+49Ggl2lJ1JzqneKVCDWSWv?=
 =?us-ascii?Q?0y7yUAu9tDWVabITT/jMfIEKpOTO5EUaA1ZGnGCjhNyaqi7YP5TXNoNiJxBU?=
 =?us-ascii?Q?xnRiEh+bRQfYlrGdpUuxqo16hRBnq71A+0EDUOGkwUyP/c2FG6MfLkthlIAC?=
 =?us-ascii?Q?hQTa7G2cRDTuQHflyFEGXlVg/dhDx3w238K1yn5L7aRLEEI50eWAHu8igbIk?=
 =?us-ascii?Q?o6Kz3nqr/o3cFzKRmVS8aZvMMhy27i0DGptGt1iZGKZmeToPdeQgWsnlCpii?=
 =?us-ascii?Q?/X39e/gtFGcdtIZzA17/0XbYCSju8XdEZNxu4dW67i8VDY8p8QIoYMDl9btm?=
 =?us-ascii?Q?IvLkf+Vgb/L470gSGTEZQFFXZJlm0EvQLSuIx4QB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB2602.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c81462f-1e3f-4ddb-1a0d-08daf2dfea0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 07:54:34.4324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BUHJcbdhfRh9iXMpx56yymIxMCoqMVQmDi8FNr/rw/PleSD9u5OLrX0J1ndOaKesH3JxSNIMcVCv6wTUV/8U3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3610
X-Proofpoint-ORIG-GUID: pp_kBbWSUw6Ot0Ok3rJpmbYa8iR81_42
X-Proofpoint-GUID: pp_kBbWSUw6Ot0Ok3rJpmbYa8iR81_42
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_02,2023-01-09_02,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



-----Original Message-----
From: Leon Romanovsky <leon@kernel.org>
Sent: Sunday, January 8, 2023 6:39 PM
To: Geethasowjanya Akula <gakula@marvell.com>
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kuba@kernel.org; =
pabeni@redhat.com; davem@davemloft.net; edumazet@google.com; Subbaraya Sund=
eep Bhatta <sbhatta@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>; Su=
nil Kovvuri Goutham <sgoutham@marvell.com>
Subject: [EXT] Re: [net PATCH] octeontx2-pf: Use GFP_ATOMIC in atomic conte=
xt

External Email

----------------------------------------------------------------------
On Sat, Jan 07, 2023 at 10:11:39AM +0530, Geetha sowjanya wrote:
>> Use GFP_ATOMIC flag instead of GFP_KERNEL while allocating memory in=20
>> atomic context.

>Awesome, but the changed functions don't run in atomic context.

drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
    1368         /* Flush accumulated messages */
    1369         err =3D otx2_sync_mbox_msg(&pfvf->mbox);
    1370         if (err)
    1371                 goto fail;
    1372
    1373         get_cpu();
                 ^^^^^^^^^
The get_cpu() disables preemption.=20

    1374         /* Allocate pointers and free them to aura/pool */
    1375         for (qidx =3D 0; qidx < hw->tot_tx_queues; qidx++) {
    1376                 pool_id =3D otx2_get_pool_idx(pfvf, AURA_NIX_SQ, q=
idx);
    1377                 pool =3D &pfvf->qset.pool[pool_id];
    1378
    1379                 sq =3D &qset->sq[qidx];
    1380                 sq->sqb_count =3D 0;
    1381                 sq->sqb_ptrs =3D kcalloc(num_sqbs, sizeof(*sq->sqb=
_ptrs), GFP_ATOMIC);

>> Fixes: 4af1b64f80fb ("octeontx2-pf: Fix lmtst ID used in aura free")
>> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
>> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
>> ---
>>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
>> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
>> index 88f8772a61cd..12e4365d53df 100644
>> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
>> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
>> @@ -886,7 +886,7 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 q=
idx, u16 sqb_aura)
>>  	}
>> =20
>>  	sq->sqe_base =3D sq->sqe->base;
>> -	sq->sg =3D kcalloc(qset->sqe_cnt, sizeof(struct sg_list), GFP_KERNEL);
>> +	sq->sg =3D kcalloc(qset->sqe_cnt, sizeof(struct sg_list),=20
>> +GFP_ATOMIC);
>>  	if (!sq->sg)
>>  		return -ENOMEM;
>> =20
>> @@ -1378,7 +1378,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic
>> *pfvf)
>> =20
>>  		sq =3D &qset->sq[qidx];
>>  		sq->sqb_count =3D 0;
>> -		sq->sqb_ptrs =3D kcalloc(num_sqbs, sizeof(*sq->sqb_ptrs), GFP_KERNEL)=
;
>> +		sq->sqb_ptrs =3D kcalloc(num_sqbs, sizeof(*sq->sqb_ptrs),=20
>> +GFP_ATOMIC);
>>  		if (!sq->sqb_ptrs) {
>>  			err =3D -ENOMEM;
>>  			goto err_mem;
>> --
>> 2.25.1
>>=20
