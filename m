Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBC16E8B7B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 09:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbjDTHcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 03:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjDTHct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 03:32:49 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECFA2727;
        Thu, 20 Apr 2023 00:32:48 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JLfRYs006574;
        Thu, 20 Apr 2023 00:32:41 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q2rebts4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 00:32:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ns7gZ7qwRtEbIr5xAbGnHb9pwGMJ5oabxeTeHFOl9yZOEVL5YPeP5s4ud3Eh58c/IEUe5I7BDUln+Xh1zy8h8N6SX7KNaMRxuOELl2uqVhAlxI2xxuRMkXqNQg3mNGI1NZGa+eJvDPUdAzkLajIafK3hwUT8bZgXSKVtl3Ftr8B6kGGwsjBGgd4JJ9Tx8WLo7E7rvdNUcYWABa0LB5AGFS3VE2TE5X9SLbKGeY8D6J9LJMi+oauh5IAZ36jEDqd22jGyon3+Rt1HtvRIgtkPz2ZzxZDr01dtktH/Y6+zr9OTZO0Aq7DHwOU6xJK5da1R0j5fnr/O5ar9zQWdZmghxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elp9lDs+SXNJ+F88mUPSMPVRATiyHzKmvGgNjw42MEI=;
 b=EWIPZXvyNGZsNmeirTr/RkkejnPY4+dgCBYVAhQfsnWcRCSwiqI6Bof/RLo/wP6sR+OsT8SUscCpDeV/wflOiaYeRrALTPnfbcjrNXTjvLT97wKa35sEBAiQ60M3ctHwzjXeoRU4SBKcVcyMk+Wu6lObRXZkNm89dN4k6CupFWWTtvOILMy9E3/tMsO/gsxdOroj1UJoAfDb4ChcMFTFi++Ls2ScWxUUEzbH+fABuNPEAhm5BNP4Qu1e8TKiAbAmXruNd2ChonSsD7ys5/NDNgBh9Xq1a14T1OxdUVAkcWt0sDVotiEtVKkSCk7+7rTJfCwZxttU9HVSxiBEGWYZnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elp9lDs+SXNJ+F88mUPSMPVRATiyHzKmvGgNjw42MEI=;
 b=ZpY3D+DNiGuTMxALtGpLsNnEA0LCzoQd+Uvu6lNajiBJBZceWUQLFuD1FT3biw5T23hqR72o7Ly1i0qdZXg0WW9XE00R5U9A0YcSWIa0xzjNqXmbfcfGmFUkao776g/snptNbLnDifPv3qAt8MjElEMUPGcIJmRV0zg9bO39cQU=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by MW4PR18MB5107.namprd18.prod.outlook.com (2603:10b6:303:1b6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 07:32:36 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353%4]) with mapi id 15.20.6319.021; Thu, 20 Apr 2023
 07:32:36 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v3 02/10] octeontx2-af: Fix start and end bit for scan
 config
Thread-Topic: [net PATCH v3 02/10] octeontx2-af: Fix start and end bit for
 scan config
Thread-Index: AQHZc1pH8Fceaq+veUyx9OFpGBUhWA==
Date:   Thu, 20 Apr 2023 07:32:36 +0000
Message-ID: <BY3PR18MB470755330B9DF76944DD1493A0639@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
 <20230419062018.286136-3-saikrishnag@marvell.com>
 <ZD/D7j+LPRIbP80J@corigine.com>
In-Reply-To: <ZD/D7j+LPRIbP80J@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy04NDA0MzA1Ny1kZjRkLTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcODQwNDMwNTktZGY0ZC0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIyNjgzIiB0PSIxMzMyNjQ0OTU1?=
 =?us-ascii?Q?NDg4NTM5OTYiIGg9ImxzQlBKMkRNaEtLRHlqZXpJNUY1dUI3bldMQT0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBRHNibHhHV25QWkFjcmNucllwS09pSnl0eWV0aWtvNklrTkFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFIQUFBQUFHQ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFRQUJBQUFBbzlpamZRQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFH?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBRkFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
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
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|MW4PR18MB5107:EE_
x-ms-office365-filtering-correlation-id: 9f869c04-b893-4588-ba70-08db417169d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oHgXO+Js++CyXtBpOfk5Vv1EbV0VU+qKx1q5SqF6Hsu06mjdXGqo5d7M7tPvHdGfRDEvBCMO8G4A3NKhz39gGrq8cV2DnItwH5C0XGD5m4md29KbZ+Q3JKDfgsGF19pIJU4RlLBMhQxGbUJoDYzmnWmeWu7RTbDn0Qh8svzR1siVlGZorT8achDNAoZAeqg/HT/Y8WAP1W9ZrzdbE2ZpJn9K26sJatX9GvoiE5fChzjoGAU668O+S5EBRbdEjOEVwKXnyb7T8f6413FErJ1SHQoV/ipKXIdvhXClS8HbXEahA+/8NJBgvGUAIXzJBckxe5oXAwVpYiktkCkFndU7Hrz9bUbPGnsy8txMKGMdXM1b6W+FRNm7ujWEcV0TJ6IM7v92zQ0+vAIog0rcxnaj8QabxtRxcGKvwbreHBgNYF04rrYDPy9uKBD2e9Eo9YCtY5EE8LD0KIPt1zz2ws7TNHE6AvnL9/v4SGlJQ8IRCEAyHC4NhljIhuV98RYawQjuPMW5zWSxE75yNezdim8X/i1TBKGHhAHTLoDAN9wJDLB/wI2YxB+zbhMKo2cqJ+elPSFdeIP5qdF2DXJ9OXmuukG7onH6FR7yMjp/2r4vNZN4kSLm1XZXfqmJVKdKCbOG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199021)(8676002)(41300700001)(8936002)(55016003)(2906002)(38070700005)(5660300002)(52536014)(83380400001)(54906003)(122000001)(86362001)(478600001)(26005)(6506007)(9686003)(53546011)(7696005)(107886003)(38100700002)(33656002)(186003)(71200400001)(316002)(4326008)(6916009)(66476007)(64756008)(66556008)(66446008)(66946007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?12NKMF/5kBKeF+nVR5vPJnX4fbZt4L8dB2fnPGqB/6b2YFE4m1Td++aMi0df?=
 =?us-ascii?Q?/3PQtjYWLwrYHe6NJeek5EYKymwLowzYKGrWtpwsHbdU14viZPwVTc1rpESg?=
 =?us-ascii?Q?/oHg/q2LszLPJKiOY3zVr0jZPF6BK571vzZD2xfHMR9OZ9Vwhy6cuQS/p07g?=
 =?us-ascii?Q?nkgjqfJhoyuO81h9SD0NCSH3SuyyQ2lK5+bQMUg28jG7MfhjnA+1lFnquwgH?=
 =?us-ascii?Q?EW0BRhzoE2xytR1VcMKWHaEEeHqpoFOFXB5jlkVwo6p2nvfIHJanhgqe5i2n?=
 =?us-ascii?Q?jdpH0BgDrfRZ7oxj9L7uyviqkI7LsFJGXC60ZLHnms8YXmPJvbLYwFS0MZBD?=
 =?us-ascii?Q?4uVQerSAYMGV8r5og8P/NNnTTyDRBJXSZH4WzJiD+Of2MQG1tXWsXn6OTOWX?=
 =?us-ascii?Q?5gktfaX0AY4rP6OAjh7XPGV/C8yOocloPfg026imXKH9oM/z6xyaAuOUT4OH?=
 =?us-ascii?Q?9b2hOKS53DkXW+juyvm+H7lSqLhzASRlPktke0nU9Wyt78QmM9Q9vCASS+Si?=
 =?us-ascii?Q?K5ZzfStG64VkfnZvN0Qpfycda5g2T4yAz92PRycA98uMgD0RnZowhg+u3DV8?=
 =?us-ascii?Q?2Ezu3sy035V61w3cmNGQuIqW6uqKZ/a3sItXiZBd+XgPucggCjzBvZS2RJ1t?=
 =?us-ascii?Q?OislAuLuNghidO/+5nXxJ5VBHzGhAe522sZuxzhIzHT3sXgvDcdjsy2oU9D9?=
 =?us-ascii?Q?oi9X9bwbjiyd0eeAU8m847uSKIxvo6fKoUDlVeasyjrXkRa5P03Keb1OAjjp?=
 =?us-ascii?Q?t86vMW2YXTWxT2kyhnkU2EUwamCFB8v3eC0cq+OLoKDEtYvITmIsDtMun45E?=
 =?us-ascii?Q?ZuHP3BQj3WaZ7tzWFcFsUFrkQJyR8VKTpTIMa9SMMh+LSxTP1u4mmv2w4XkE?=
 =?us-ascii?Q?4VD36N2Eo9r1auBhbWrDT8BLFxgFUL7Z3p5OTvl3yqaw5fXFkyVmlKJTVU5h?=
 =?us-ascii?Q?0o6qj1AAP1rtbqoONickgvPy7e+QYCK/Hdeut7rnluJhGm97kTSsiAw8FnhX?=
 =?us-ascii?Q?Cgow9WEzrX4puJDtzRFda1/0FczR285OgyB2sk+geUWsOggwaagQRNME+kgc?=
 =?us-ascii?Q?kV7OrNgyQAHEh+6t+FpDe1+jAUDltPXrd1CsJ3l8O4Up0f5QAmXknN3GbGIb?=
 =?us-ascii?Q?ixri2kHCQOmLkWit+yUgWYqP+Im6TzGXoSgKzNJ/rQELMjnBxqYTW+vSRHJk?=
 =?us-ascii?Q?AbuaEl4OcNdQZiSp3VttzizyasCPCBRA1mtuu4mXE4eR3qbc1hY6Ug8AedXK?=
 =?us-ascii?Q?HqrgNFl9g2q85MtFyGwGWv7ymTtZKsTBF3GSSIYklpdNOhnd14Z+ToHAUspy?=
 =?us-ascii?Q?yzggwcp0g5lNmg7mfr/+3k+n42/XAjUHTKEDRep3GTCYJwny5/vXYHB3vhFL?=
 =?us-ascii?Q?IjSTtELNjODpIt0jDZPSdOOu16v8EtWObX3MaveisvYkUbWP0QJhtVNmlNL/?=
 =?us-ascii?Q?OxfrwfuVmmeXsOqhRGSLzp8lOs2TQWjH9QxiI7UJud735GI3gO2gUIrxbr8K?=
 =?us-ascii?Q?fFdNfjnA8kK1HbYZYnGhmcqmQ63AWas6wMJEWnl8USGxHBNuexfKB0h8ZLa5?=
 =?us-ascii?Q?9eDTQRJb+rbfB7fv8HaBbwcBzXWOXVA35yMFWlUd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f869c04-b893-4588-ba70-08db417169d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 07:32:36.5773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /GtJ9S/LHh6f7dR9/LLz/yzfnyNPl0ilXUD2BDui9y70+syOuM5XYsVby8ofFc9IKjCrOnLvqpcLteh7md8w7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR18MB5107
X-Proofpoint-ORIG-GUID: CaLtHuHAYdp3G06zVaFquHaFXcv6XCqY
X-Proofpoint-GUID: CaLtHuHAYdp3G06zVaFquHaFXcv6XCqY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_04,2023-04-18_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Wednesday, April 19, 2023 4:05 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; leon@kernel.org; Sunil Kovvuri Goutham
> <sgoutham@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>;
> Linu Cherian <lcherian@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Ratheesh Kannoth
> <rkannoth@marvell.com>
> Subject: Re: [net PATCH v3 02/10] octeontx2-af: Fix start and end bit for
> scan config
>=20
> On Wed, Apr 19, 2023 at 11:50:10AM +0530, Sai Krishna wrote:
> > From: Ratheesh Kannoth <rkannoth@marvell.com>
> >
> > Fix the NPC nibble start and end positions in the bit map.
> > for_each_set_bit_from() needs start bit as one bit prior and end bit
> > as one bit post position in the bit map
> >
> > Fixes: b747923afff8 ("octeontx2-af: Exact match support")
> > Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
>=20
> I think it would be nice to explain why, and what effect this has.
>=20
> Also, TBH, I'm unsure why the start needs to be one bit prior.
>=20
Will expand the commit message with explanation of why, what effect of fix =
in v4 patch.

> > ---
> >  drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> > b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> > index 006beb5cf98d..27603078689a 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> > @@ -593,9 +593,8 @@ static int npc_scan_kex(struct rvu *rvu, int blkadd=
r,
> u8 intf)
> >  	 * exact match code.
> >  	 */
> >  	masked_cfg =3D cfg & NPC_EXACT_NIBBLE;
> > -	bitnr =3D NPC_EXACT_NIBBLE_START;
> > -	for_each_set_bit_from(bitnr, (unsigned long *)&masked_cfg,
> > -			      NPC_EXACT_NIBBLE_START) {
> > +	bitnr =3D NPC_EXACT_NIBBLE_START - 1;
> > +	for_each_set_bit_from(bitnr, (unsigned long *)&masked_cfg,
> > +NPC_EXACT_NIBBLE_END + 1) {
> >  		npc_scan_exact_result(mcam, bitnr, key_nibble, intf);
> >  		key_nibble++;
> >  	}
> > --
> > 2.25.1
> >
