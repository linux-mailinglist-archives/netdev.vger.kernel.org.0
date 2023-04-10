Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D536DC371
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 08:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjDJGI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 02:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJGI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 02:08:26 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BAD3AB8;
        Sun,  9 Apr 2023 23:08:24 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 339NRrgX006899;
        Sun, 9 Apr 2023 23:08:10 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3purfs3j7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Apr 2023 23:08:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pxs1bAKoigMMZXkET2+UvigFVweSlzrlweg1lBhE+weibrvfgF/m96WgF7Jy5cNSQfNzblVPIgoromJgwMhhK5wh6OilajihYjbYaXH7Fdfi20O7U3HBwts6HPB1xnTk9Yj1yjymeVVFb8ELkHK1AMhka3J9d4Gv0SFPu6CqVTJbuNtGxGRQfpPGnjg9e2Js4wWFE30dpO3XTMd5aXmgvfPf4p3DqSe8n22KnkneAJ5r9AxFPQdj0dYH7PgKxgmRQylVPXJmOZjapa9mjcidlry+9zpcEDrpPtJPRO+GtlDeWtJvTRxCpnOIyOwYOyULu8YDsGVKjFTA3/02Quvfyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MqquYb9G/6oJhasbP6FGCEjEXS9cojlypeNpyS97XcE=;
 b=PDLl987r7C++8bLtDKi/4qrD+sIfaAT4Q64XPXC7ZVTEsGyxLM97+7DLJ/x/9D9IZIFYeP5hnECxAvzRmdcAS2TAnp3Cv2AZDk0d2b9vI1sesaDwIEy/OElAycajjlGR8V0KhzcIWZJ3euC/eVA26nstcJpa2ddr3NxejbCZo0n+2nmBQD8Qfdl65otCw9/CYGEMFFWnxjMEDeRuAgb8zHjb291qu56eHn2BnsOWViF7IAD1N47qqM2YeG+48QBE7tRWPY/mwD4txi+kSiUtZ3k9YXdYK2kMuDEenGcxDEZbU+429PKOSTeTJ/Vy7ZF12ITfdCAgJYO9lcES+Z3ZuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqquYb9G/6oJhasbP6FGCEjEXS9cojlypeNpyS97XcE=;
 b=O8BSqTEzcU3Nb5tAqFbvxOdVw8VOQ6ok4hcN7rmJ/p5fgrp8AfwytR0yuFvpfqzeQfv3r+77d5xe5Mduk7ut7a1xNohXBXQ/b82pok1Xh8Ej8xGwnSN+Y0V+DmqxiIaN7bHFwDew4wcmmmRqlIG038dRS2E2MpopFRFDPyg4M9g=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by CH0PR18MB5532.namprd18.prod.outlook.com (2603:10b6:610:186::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 06:08:08 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353%4]) with mapi id 15.20.6277.031; Mon, 10 Apr 2023
 06:08:07 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [net PATCH v2 3/7] octeontx2-af: Add validation for lmac type
Thread-Topic: [net PATCH v2 3/7] octeontx2-af: Add validation for lmac type
Thread-Index: AQHZa3LRnlELUOX5YEe4p+msHli3lQ==
Date:   Mon, 10 Apr 2023 06:08:07 +0000
Message-ID: <BY3PR18MB4707056861A499D736B1354EA0959@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
 <20230407122344.4059-4-saikrishnag@marvell.com>
 <20230409173015.GK182481@unreal>
In-Reply-To: <20230409173015.GK182481@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy0wZTJiYTU5YS1kNzY2LTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcMGUyYmE1OWMtZDc2Ni0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIzMzc4IiB0PSIxMzMyNTU4MDQ4?=
 =?us-ascii?Q?NTI5MjE4MTIiIGg9IjVqemwwbDF3NFFDMUM4a1RmOThZeUU3YzRZQT0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBRFVaWVRRY212WkFXcUZRYThQaXA5cGFvVkJydytLbjJrTkFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFIQUFBQUFHQ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFRQUJBQUFBMUZIM2FBQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFH?=
 =?us-ascii?Q?UUFaQUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4?=
 =?us-ascii?Q?QWNBQmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFB?=
 =?us-ascii?Q?Q0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VB?=
 =?us-ascii?Q?YmdCMUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJq?=
 =?us-ascii?Q?QUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFN?=
 =?us-ascii?Q?QUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-rorf: true
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdB?=
 =?us-ascii?Q?QUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhB?=
 =?us-ascii?Q?Y2dCa0FITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFITUFkQUJ2?=
 =?us-ascii?Q?QUcwQVh3QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYVFCMEFHVUFj?=
 =?us-ascii?Q?Z0JmQUhZQU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFB?=
 =?us-ascii?Q?QUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOEFiUUJmQUhNQWN3QnVB?=
 =?us-ascii?Q?RjhBY3dCd0FHRUFZd0JsQUY4QWRnQXdBRElBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFu?=
 =?us-ascii?Q?Z0FBQUdRQWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFH?=
 =?us-ascii?Q?MEFaUUJ6QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3?=
 =?us-ascii?Q?QnpBR3dBWVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdj?=
 =?us-ascii?Q?QVpRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0Fj?=
 =?us-ascii?Q?QUJmQUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFH?=
 =?us-ascii?Q?WUFhUUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpB?=
 =?us-ascii?Q?QmtBSElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBRXdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFC?=
 =?us-ascii?Q?akFIUUFYd0JqQUc4QVpBQmxBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdF?=
 =?us-ascii?Q?QWNnQjJBR1VBYkFCc0FGOEFkQUJsQUhJQWJRQnBBRzRBZFFCekFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBIi8+PC9tZXRhPg=3D=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|CH0PR18MB5532:EE_
x-ms-office365-filtering-correlation-id: 3949f8b1-42b3-4186-b968-08db3989f466
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6VYw3ANsOpzPErJ2TnmfaBQ5k46+m6wFEn5sxw62tOfHELTiWQPVrpA7DgUNpZgJPAnbYos54HxHNERIIdXi5hVNeQz/WEaD41PAZaBPpaykoZr8c4ssFfp+n+NPZUol0NQteM/YOPUP9MNT/1MaCwNzhJGX7V6gQOsqfFboD3Pv1KBY5CDRRyekHHnPv2DC4+BiUdS5AcnRx1a7CGT8/O0sP9viWJqsYxZ6JT/SbDbmyvHjEKD8Fz0cKozCpKcpBvRDHbQlcULCcTjmsQeWCTOogIr3yBkSkJMzKivpig6zkwtiX+nJl+dlaByKSsjKm0/4satqGyJCBO8e42thOuhFFqqEh9Fwlc3cGG+2BQ/QnPCXiOJSTIyUNrqQfCbD303XSfjnS5yWOntz7EwpZ7mVnNOW5wEW96Y2JEtL2e7ug4oIYQUVUIz9jbOY9SFSeAJXHvgGtgOMZ58bJK2vxCEGZ4QsbbEmMTadSdWfBWRR8+5A+Ltg7JF8f5u4hWNPmccb52k5u3ncGW1hP67wyMGXEzGsi6li8FbIUaDwQvBQf9kTT6uSzEQfcnt5Fc2q6olhw15f56vyiJImUlw6qH0ciCecyNE7kJxz0LwykANR5cuv68rt+MhbuzhTOUwT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(39850400004)(396003)(136003)(451199021)(38070700005)(2906002)(52536014)(38100700002)(5660300002)(8936002)(8676002)(55016003)(86362001)(33656002)(71200400001)(7696005)(107886003)(26005)(9686003)(6506007)(54906003)(45080400002)(478600001)(122000001)(83380400001)(186003)(53546011)(76116006)(66946007)(41300700001)(66556008)(66476007)(64756008)(6916009)(4326008)(66446008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g6kC+xTj4rBuBZWtccMLI9A7WU6CY1T79vTPV2m18ksNUQ8sw3DPGmPXFBFJ?=
 =?us-ascii?Q?m8GojT8P0Xgv6wYPntYNsIxfocuWeHHy7Qxg56rSaJCPd9nR1E2uORzAjyuI?=
 =?us-ascii?Q?o4VHh5MJuXo6StxOyI2G0IZZ0EXnvojMcXJNJ2JZk2yVpWF60bzv9VrdSOQ+?=
 =?us-ascii?Q?5TJKEehq9WyUowjnlBN+GWqeKZ5jMbuMJZqF60lordBRjLGb+f8a1ogNH5oL?=
 =?us-ascii?Q?zfFqKRipTaC3/qVQ2FMdrD3i13HlrI9r4A0OvhktCHyMickk4tPKI0VESswB?=
 =?us-ascii?Q?M7HukVDU3KdTZBAhYAystj0tB2uULPGoj0zgeQ+9ClE8qRbpUEH/n7u8PUCA?=
 =?us-ascii?Q?X7Sgnlt9y8To+dsR6hJnMQTa6oOqNbXHgANvFz6D8hHjMubfbl3Omg8pvD54?=
 =?us-ascii?Q?8C9ZcS+XwGDmEmCdCrTCniw8PGvDxgz05QgSBOxodv9sivdUq5hcSPXzPDrE?=
 =?us-ascii?Q?vEZjhIVdgpV+dIWqIo6ZOswJtoTzSHMpcG5sFrUbLhJ8RztcCrwRZZIIztTg?=
 =?us-ascii?Q?OkrmefY0+2eJqUWoJFXS7nrKvART6TUlix6BJo8Fr25BXxd/a333GTrHvLOZ?=
 =?us-ascii?Q?fPHOVP/aJbfAGKT8u7+XFwDCnUL/+GWxORi8UBkbn2DttE6e0McaJMklVXtF?=
 =?us-ascii?Q?QgfZb7aEoGmziRQN6wSBfPXqyYG4/aURG918EfjOD/lLm9gInn5Y7RgyURbg?=
 =?us-ascii?Q?OInpDZP4pX7uTEIC/4nJnUm6bPENrBGCQfP6PL5g4a9scRQnkTyVdPkIIJMA?=
 =?us-ascii?Q?2j4/THzVxm5tVOa5jNlpJ74K+jz+9k/xHUVU8MotDBOKUNe9hqvZeZcBCJhR?=
 =?us-ascii?Q?32Qu/oy65wO5gYH2hbv+6LhT5MXLJHdXEhO0Rc9uaBgOCzDQwXhIRkJwNj8H?=
 =?us-ascii?Q?JdMGhEwjDIv5TCJe3c9VjYzuOE8UqamhopSrnal0WAgKdxr+0A5Dw+MWP3Yh?=
 =?us-ascii?Q?K0kLTnF9tRoSJ658NYpU6cp5r3btloqMOS6dCGg4k4/kUOj1Y1k4fznntD3X?=
 =?us-ascii?Q?oy1bqXUNP1KPBLhYJzBIhNHf9AoMid/9Sqbj8+bvHqr/VOZ5ruZgPtl5AMgE?=
 =?us-ascii?Q?JKGUX04RVT3nQOKS0/m/tfL3oiPIekqFEwNm7Z89F+dUJl5I3ebkpZsF/4p+?=
 =?us-ascii?Q?bGno/H3XYK/6ZrxIQHamyjmQL5bW7/Oc0cRJm8RR02+yS0rGLjgmsUi4pZa8?=
 =?us-ascii?Q?Ci5FY4RoOaaqlj56ncifpPEKAeBLw4JH3kjCfLCp7giIQzk+T9v+7yKWh1Z8?=
 =?us-ascii?Q?b4s7biuK8dRwnKE9rbuqeFJ3Ge35l3SmLgiSA9E9zwM07pKM5DErvlDUa6LU?=
 =?us-ascii?Q?X6fsruYkSAl0GL7D1+QPSoppJiA4DhwEuZkN5YENjBbDSIUeZZ9ECV7ro6Yz?=
 =?us-ascii?Q?adwrR3mOAtDeedkQ5qzs9prSTGEGgmVU0AHqdKk8DEfAlZQTZ37d9Ld7b54m?=
 =?us-ascii?Q?kDsqichYyl5XRl1qoFliSlwqYs02n618u+Eairte+8itqU7hB05kBqjfkLMS?=
 =?us-ascii?Q?2ttxcNgInlQyPVwh9cPv2PK+/7EOh14hOL0hGWWt+zgmlclEu9VAyk58hPFI?=
 =?us-ascii?Q?6eS70cQyMwAKmAyWBw3UdYeBlgfEQhOUuzVEkwNb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3949f8b1-42b3-4186-b968-08db3989f466
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 06:08:07.6492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UGTkp5f3+JgRMaM4aPnI1FRYaiyhvUwF25AoG4rn2+a1zgvqBnf99SxoKhgmZcdwY2f7aia/7LNOPVJVjGwFtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR18MB5532
X-Proofpoint-ORIG-GUID: 1yNZ6lseqOgT3WIACCjtx9q-CoaYnMmS
X-Proofpoint-GUID: 1yNZ6lseqOgT3WIACCjtx9q-CoaYnMmS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_03,2023-04-06_03,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please see inline,

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Sunday, April 9, 2023 11:00 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> Geethasowjanya Akula <gakula@marvell.com>; richardcochran@gmail.com;
> Linu Cherian <lcherian@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
> Subject: Re: [net PATCH v2 3/7] octeontx2-af: Add validation for lmac
> type

> On Fri, Apr 07, 2023 at 05:53:40PM +0530, Sai Krishna wrote:
> > From: Hariprasad Kelam <hkelam@marvell.com>
> >
> > Upon physical link change, firmware reports to the kernel about the
> > change along with the details like speed, lmac_type_id, etc.
> > Kernel derives lmac_type based on lmac_type_id received from firmware.
> >
> > In a few scenarios, firmware returns an invalid lmac_type_id, which is
> > resulting in below kernel panic. This patch adds the missing
> > validation of the lmac_type_id field.
> >
> > Internal error: Oops: 96000005 [#1] PREEMPT SMP
> > [   35.321595] Modules linked in:
> > [   35.328982] CPU: 0 PID: 31 Comm: kworker/0:1 Not tainted
> > 5.4.210-g2e3169d8e1bc-dirty #17
> > [   35.337014] Hardware name: Marvell CN103XX board (DT)
> > [   35.344297] Workqueue: events work_for_cpu_fn
> > [   35.352730] pstate: 40400089 (nZcv daIf +PAN -UAO)
> > [   35.360267] pc : strncpy+0x10/0x30
> > [   35.366595] lr : cgx_link_change_handler+0x90/0x180
> >
> > Fixes: 61071a871ea6 ("octeontx2-af: Forward CGX link notifications to
> > PFs")
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> >
>=20
> Your patch missing --- trailers and probably won't apply correctly.
>=20
We will fix trailers errors in V3 patch.

Thanks,
Sai
> Thanks
>=20
> >  drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > index 724df6398bbe..bd77152bb8d7 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > @@ -1231,6 +1231,14 @@ static inline void link_status_user_format(u64
> lstat,
> >  	linfo->an =3D FIELD_GET(RESP_LINKSTAT_AN, lstat);
> >  	linfo->fec =3D FIELD_GET(RESP_LINKSTAT_FEC, lstat);
> >  	linfo->lmac_type_id =3D FIELD_GET(RESP_LINKSTAT_LMAC_TYPE,
> lstat);
> > +
> > +	if (linfo->lmac_type_id >=3D LMAC_MODE_MAX) {
> > +		dev_err(&cgx->pdev->dev, "Unknown lmac_type_id %d
> reported by firmware on cgx port%d:%d",
> > +			linfo->lmac_type_id, cgx->cgx_id, lmac_id);
> > +		strncpy(linfo->lmac_type, "Unknown", LMACTYPE_STR_LEN -
> 1);
> > +		return;
> > +	}
> > +
> >  	lmac_string =3D cgx_lmactype_string[linfo->lmac_type_id];
> >  	strncpy(linfo->lmac_type, lmac_string, LMACTYPE_STR_LEN - 1);  }
> > --
> > 2.25.1
> >
