Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF1D6EA359
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 07:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbjDUFwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 01:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDUFwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 01:52:30 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37372109
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 22:52:29 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L330Ax008176;
        Thu, 20 Apr 2023 22:52:20 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q3djpjcce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 22:52:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsW7dNiIag6ueYFXRiSfz6HDgtNCJvo0wnjEZx5w6h6CB7of8U2qJbg6cEajK/6sAeE7NiYBE9o0L/ewghSiXSFl3L93YnivO6K+c0jgDQyoP10dJujZPcQ/SSc7d3xPTjU1Z54nv83D0wznpoVvVH95GRSJ4NNVTuxYW4xHZ12xzZ5WCWJHhCZIGAZ1N4507W+jVefjrycIFExfRuPl1Rs+iv1SeA6JPVvenrf3w3Usfar1iyKJJqYlk0JFtkNd5WZi2fO0IENFqczXjX1ot5aPmJjjT6rDasiLKnpCO76CcyNAIZfw3+Ua+/k4xhvEnZ0bJ/CcreLuPq3btkBP7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AizEFtFea7fQnOh+biQnT5loAWikKQcueN9bx9qYXwU=;
 b=VLrItmLgAP0k/5n4ZB1EmuwMuTLDCBLFaworOTlDqFt0kZfe9SI5rqz9gFUDjhjMxxPi2iimr98OTFcN0rLT4vyM4ez9ObuWUwgg74ujTWpDPwRuHYkuQWb/abr1kU0MHyFEal5EycyLUd1/UBybYV1FLStYcB/URr6W17fpRy/rGxddiUnZSbQLRtTP8/147GhSx5K+ez4NJJcjSQuJUzbif3U1fghkC2a+hjjRVJlt/1Cg8m0vgv5cMZrkxro07Gy9vQORaqRKZkUhm2baiA4gLmx0WGrFHSMyCeCxL231wGWb1cEJCXF6h4J3TDYZzJxdGYP7e3uCw8tDSkKmEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AizEFtFea7fQnOh+biQnT5loAWikKQcueN9bx9qYXwU=;
 b=LIcQOFhI45Fcgjdodwl1p4LOShZwr/QMzvWDgceaMseKvqAOFdTosONX2cBVzag5jNSEBAmFdu92wCMpfqbjrfNhWiCuAfGz18J/d7a/x62JErjI/jsucaJo/PSXBxnpauJcTU90EihjWm6CTIaaKzakFKY16OMIG6sOsQrzFpo=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by BN8PR18MB2817.namprd18.prod.outlook.com (2603:10b6:408:a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 05:52:17 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88%5]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 05:52:17 +0000
From:   Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To:     "ehakim@nvidia.com" <ehakim@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH net-next v7 2/5] net/mlx5: Enable MACsec offload feature
 for VLAN interface
Thread-Topic: [PATCH net-next v7 2/5] net/mlx5: Enable MACsec offload feature
 for VLAN interface
Thread-Index: AQHZdBSq08Xta57Bn0KLI9k5BFMMFq81QrCA
Date:   Fri, 21 Apr 2023 05:52:17 +0000
Message-ID: <CO1PR18MB4666FEE68ED17662E223196EA1609@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <20230419142126.9788-3-ehakim@nvidia.com>
In-Reply-To: <20230419142126.9788-3-ehakim@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2JoYXR0YVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWFhNDVkZmIyLWUwMDgtMTFlZC05YzU5LWJjZjE3?=
 =?us-ascii?Q?MTIxOGI3YVxhbWUtdGVzdFxhYTQ1ZGZiNC1lMDA4LTExZWQtOWM1OS1iY2Yx?=
 =?us-ascii?Q?NzEyMThiN2Fib2R5LnR4dCIgc3o9Ijc0NyIgdD0iMTMzMjY1Mjk5MzQ5NTAz?=
 =?us-ascii?Q?OTU3IiBoPSI3YzFvaW4zZmJjQUR6U0htMWNRb29WSm9Qa0k9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQURW?=
 =?us-ascii?Q?LzV4c0ZYVFpBY3NTeUFJN3AzYld5eExJQWp1bmR0WU5BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFBR0NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQW85aWpmUUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
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
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFI?=
 =?us-ascii?Q?UUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFC?=
 =?us-ascii?Q?c0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFB?=
 =?us-ascii?Q?QUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJ?=
 =?us-ascii?Q?QVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQURBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
 =?us-ascii?Q?ZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFB?=
 =?us-ascii?Q?WHdCakFHOEFaQUJsQUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0Iy?=
 =?us-ascii?Q?QUdVQWJBQnNBRjhBZEFCbEFISUFiUUJwQUc0QWRRQnpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR18MB4666:EE_|BN8PR18MB2817:EE_
x-ms-office365-filtering-correlation-id: 01627fa2-e3d7-465b-b679-08db422c90a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LVPmMcb55Xm3Fb7Key4ecny/cm2URnV85sa91XKTgG4UObjbPEXlOvYBXgk+2ch8EM7MvQnSgv6Ohyi1Oaq+4hOsJnRhjPUWVdZLaPsbDSxVUjDJFur2nNgLUjhki3tv/xAicA+q6PC6kALsMmmbYRlZ7ku/7G7iqGJ2h7IF/dzZ3tapjjgcNXA5taVMTDlF6StnGapCxb5b8ob+5onzLi1Flt6xmVw0wcgrvD42ucxsiG2OONWYCwwpTFupryCKQN+GczTVHEDm+TgpLB9Dl1e0WLIwZFSY8v2V+SvvNMEs1Bs8YehK0N7SRlhI8aZT3EKx8Is022yG+RGA1W6GM3lFqUhKqliIwfpKrW0BXOhhlbvLJu/VAV/fCIuZ/bllThdqFeAwlq0vNOGVk72/k1fl/0wbt6Ps2awN6PKXRKWAa9OAms3DlLovG/7hmaN5v431b2P+T0UvFLTI6k8nBNjNSYdxpn4+QRTC9W8pDZiwkm5QUGLsB1MPELTGsz5J0zHB2Q6c1QcoZTZVzOB3SlDHFihd1RiFFqCUS9ZI3RybDR4iTuPia5qExzltqSWf5J3tK1hF7D3fa/LxmPqv3YeS9CwiBFEQgW5DoL8VMcySihvTdPRFEBCKfyq+B93w
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(39850400004)(136003)(451199021)(33656002)(4326008)(316002)(110136005)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(54906003)(7696005)(478600001)(71200400001)(55016003)(8936002)(5660300002)(8676002)(41300700001)(52536014)(2906002)(4744005)(38070700005)(86362001)(38100700002)(6506007)(9686003)(83380400001)(122000001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+h2I1jWQ2RQv2GPW9rkW+N8D2tKvHW2Uh9p/fdmvkS5RAXYgP7T4UtQbg0n8?=
 =?us-ascii?Q?bQrvanmlAfyaH5P9fFbfeLo2RQwgK5k0VXDvT5feffAaeB/cYn0Cq/opCZ5/?=
 =?us-ascii?Q?1iozsEGEGTy1xcNiFcZTdHe23YahcGSgOAQMadtOCAMTV0rKjXXvedDqHlpb?=
 =?us-ascii?Q?PN8OsbTdL5lU1kspZNfg6p6tvsMdwhewkm9Fk1asBKj9tjPo+tCpoATdudAZ?=
 =?us-ascii?Q?tPSmKeyrWmy0l5+zwOW/CsJE6ABt3BMKKAxJxu0ahCU35Ux90HyyT/wm1M1z?=
 =?us-ascii?Q?xIGEbJ7p0G8ETbn9+PBWIHXDKmpjN9Mq8UliOWoxjt+Rxo+BWECX+/fYn57e?=
 =?us-ascii?Q?VOQAlKlq8AzoOZ8yaX1QTtB0HiGFkxOmKFSjzTaJD1lYKLakQWnsSBFM6o9W?=
 =?us-ascii?Q?OHXFlvxfd7Et0ROdxw1rnO/R+TWoWCo8gn5gFA0SppuEi4F0HPGbgfJRtUf0?=
 =?us-ascii?Q?FAx0qauRWpIdqmkOJFh0vdRjo3xvLaxK7jqCqZUAvQi7TSBO/jL0rRw/Ikfv?=
 =?us-ascii?Q?7WkeZucqeFVTaja2fG+RFsD+PEeYHX35KRa5KZlgnMqmPHLRng1PLNcphYbx?=
 =?us-ascii?Q?WoE//7/tUQFWYhywpSvGl9LimoBJkavf4qnGeQ0U9+iwYbEEQNWw2UmCGR0R?=
 =?us-ascii?Q?+6D5LjyPqNCqxx4ajWLnZK/2Hyhvu8ydsyZYNUPfbEHW7qZms6nEDOSQ7KUb?=
 =?us-ascii?Q?0SqOeUft0H5FxBH3Ba9qwZ7Z3Dyk08QvDIRWgwO0J7EwKswBPxzPOjfiebTP?=
 =?us-ascii?Q?AqfdfuG9EaWgTB5rxRfFamH78pfCaNhpc3EE/P88mD29Bx3IjfWhBRS4hWt5?=
 =?us-ascii?Q?f+AHda2cswhvoK64iBIlGmIvsetEGVRKvFssELOvPr5I8xd/R1iaTxbLOJId?=
 =?us-ascii?Q?jDsOJXdtJiHFKJud4Zi8Dtxt9z/rAAiy6tBLlgrZ5URV8g0SIh7vActnuiVV?=
 =?us-ascii?Q?xW6+hxO60vqsCmChfmOy1ZpHWszH2jHeHWaO+o7bPuxXWXGWLWSkIpijBNqv?=
 =?us-ascii?Q?CPMB1Ct+XxNNEebSa9bS1xQ3G6DYRb3st/q3z20q+rAFnGlq3HYi7eTyNt0L?=
 =?us-ascii?Q?tiQ/pfPR8Qpyvh7mdumWJoNNiDVgTVFJJe0izw+xYVPYgQPuxbeWqQfpHxgK?=
 =?us-ascii?Q?8lhziwv4Sp2enkSOq9OThsQgdtV4RSnP/EJHr7GCvU85gECLhSlkJ8OelJuN?=
 =?us-ascii?Q?cLmL8dE748HNVBHs1xpzTVInDp+SWju+31TxWLDBxKUN9vhilDGJ0Y9Awhfy?=
 =?us-ascii?Q?Cm9hsIcK76BoEQzN3jcamQLB4kIS0EtpUutps05gfLVaTk5P9JLJ8gIDDKuG?=
 =?us-ascii?Q?IkoNmi8j2stLBpG6S4zeO2vlfYnpHDCL6gmL730VCUonCDY/4B32S6XTY0sz?=
 =?us-ascii?Q?KlP9U5V22euNKhFPDFvtCB5t2bLasPGckVHLNoC2Zr1n6YF5BiuVAq+OgVjF?=
 =?us-ascii?Q?/qM01dOeRmwktZEvCfLL3iKN3LwSNc/P1pGITQ+4O+3Aqt5BIR9aKVE7MhG5?=
 =?us-ascii?Q?aYP9N7AldwOTjx8Za38YtM+C+cx/X4sp5vZZfSwcbjLFincGlu42iBfFP7w/?=
 =?us-ascii?Q?XMJ77c4TqTVoIP+8dciLet3/VPVh7odVpMk7fbp4GsYn4L2pErtejTRUObRj?=
 =?us-ascii?Q?7/vIp7VN89r/+Bsg+RtHx5hII9SQ5ClZ57ifNo52T4pH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01627fa2-e3d7-465b-b679-08db422c90a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 05:52:17.5060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qi9RjTuRuaOcesSLRwLL8wAql4HG1oWi+VxEhgJlQNQo43boFWiPQLnd08nUi7nfOnfhsuek7boSung1ynbVeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR18MB2817
X-Proofpoint-GUID: qTEEE0-pJGzkqlOr08vRmrB2CaQNR7bL
X-Proofpoint-ORIG-GUID: qTEEE0-pJGzkqlOr08vRmrB2CaQNR7bL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_17,2023-04-20_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Emeel Hakim <ehakim@nvidia.com> <ehakim@nvidia.com>
>Sent: Wednesday, April 19, 2023 7:51 PM
>To: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
>edumazet@google.com; sd@queasysnail.net
>Cc: netdev@vger.kernel.org; leon@kernel.org; Emeel Hakim
><ehakim@nvidia.com>
>Subject: [PATCH net-next v7 2/5] net/mlx5: Enable MACsec offload feature f=
or
>VLAN interface
>
>Enable MACsec offload feature over VLAN by adding NETIF_F_HW_MACSEC to
>the device vlan_features.
>
>Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>

