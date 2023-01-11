Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CE26659EC
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 12:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjAKLVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 06:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbjAKLU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 06:20:59 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475433AE
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 03:20:53 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30B9a8Io016756;
        Wed, 11 Jan 2023 03:20:40 -0800
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n1k56t02h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 03:20:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+nNaK4NWAxb/4SX4XukKit1OfHmmNa/KndUUJ3SULU929/ZU/BDzHviEYyTi7Bx6syzkSnKAjRa6TmogEWOAw5o+RLgEFQ52Li1SWFuWtIkRhrtJVfrQl2u9TyRFQSiXFQyqvFxo8+uhSaYIlcR7yQnG2SsvXbxyjVLpF+3MaCUkJWJ/t//XTvBONmOku5FWnMxZ/RMZanIApsjfCRpxiCrXPNNzDRu5y/prqM/T2bI5/levUANwMDxj6O9Vpa6iaHHWKDB4UP4/xx5vnQwrrY2H0WGkI1xfZkqUlxr18bG55bWMDqRnXw3dHQzGfzqWbx6Dq1dUQClwYFNCDmK8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uY2s6u05+Vh+rXNlaWLBTwwRmHf8zAQqFia0YcVwgMY=;
 b=KiOYBgJm9ii7w2eZJf3Pv40HZ0s2IZxLK5fltyRQdyl3NVP66tB+RF/APB+vWtiZB8uoJm/7f+Wv9ellJkbsNVzxev3ckd5/RcaAAZd7t2ihhHHb1PuN/ITiSHYVfXMdOmgG58mT1HWZotoNMZpzveYS7SmsDPbsYxdsV8wRIFJ7LcdBKPJINLewTHnpp+UdRWtfofQRJhDfmH/RldBOfdoFDt95h0+RrSuM66m5zlLbvT28t8XB+A9DD8sZ2aPinuqUMr04LAnMVrvlOHAyQxfRg+viKsf+oB3ObBvhQ/QfOCSxo2jyif+czE3knun+ilSfRS3XCJ981nipLcSYUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uY2s6u05+Vh+rXNlaWLBTwwRmHf8zAQqFia0YcVwgMY=;
 b=CzEaQNb0PFP5JLj5sca72jDay2hhuh9yYxB0Gie3KO1KCuPet5N34SxgdmUxMbdTVl+JhSg4vINmboNyU52HwPgZ7uk0pA+4pyJlFU4NIqzednQkMbqqeklmgbgA9i9Sb+gdamfM2iuuYmo3zDeJpNXynR9PeUgeHKXH3o4ex7o=
Received: from BYAPR18MB2791.namprd18.prod.outlook.com (2603:10b6:a03:10a::25)
 by PH7PR18MB5202.namprd18.prod.outlook.com (2603:10b6:510:15d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 11:20:35 +0000
Received: from BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::d1d9:2ac2:1427:5c6f]) by BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::d1d9:2ac2:1427:5c6f%7]) with mapi id 15.20.5944.019; Wed, 11 Jan 2023
 11:20:35 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: RE: [EXT] Re: [PATCH v1 net-next,8/8] octeontx2-af: add mbox to
 return CPT_AF_FLT_INT info
Thread-Topic: [EXT] Re: [PATCH v1 net-next,8/8] octeontx2-af: add mbox to
 return CPT_AF_FLT_INT info
Thread-Index: AQHZJLwdlpBie112uE+Su+6I5RcC4a6Xj/iAgAGDknA=
Date:   Wed, 11 Jan 2023 11:20:35 +0000
Message-ID: <BYAPR18MB27918F023EA91C5925AF80F6A0FC9@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <20230110062258.892887-1-schalla@marvell.com>
 <20230110062258.892887-9-schalla@marvell.com> <Y71WBwIt6lKrlUV3@unreal>
In-Reply-To: <Y71WBwIt6lKrlUV3@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2NoYWxsYVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWY0ZmJiYmM3LTkxYTEtMTFlZC1hMGEyLTQ4YTQ3?=
 =?us-ascii?Q?MjBhZDM5NFxhbWUtdGVzdFxmNGZiYmJjOS05MWExLTExZWQtYTBhMi00OGE0?=
 =?us-ascii?Q?NzIwYWQzOTRib2R5LnR4dCIgc3o9IjEwMDYiIHQ9IjEzMzE3OTA5NjMxNDg4?=
 =?us-ascii?Q?MjU1MyIgaD0iQ2EwR1VYUlFpMElIaGI1RDVGRTkwN25zcktBPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBTmdIQUFE?=
 =?us-ascii?Q?NUtWdTNyaVhaQVdxaUdZTTRwSTA5YXFJWmd6aWtqVDBNQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQm9Cd0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUEzVHpGQUFBQUFBQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY0FC?=
 =?us-ascii?Q?bEFISUFjd0J2QUc0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcwQVh3QndBR2dBYndCdUFHVUFiZ0Ix?=
 =?us-ascii?Q?QUcwQVlnQmxBSElBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVB?=
 =?us-ascii?Q?Y3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhBWkFCaEFITUFhQUJmQUhZQU1BQXlB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdN?=
 =?us-ascii?Q?QWRRQnpBSFFBYndCdEFGOEFjd0J6QUc0QVh3QnJBR1VBZVFCM0FHOEFjZ0Jr?=
 =?us-ascii?Q?QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBB?=
 =?us-ascii?Q?WHdCekFITUFiZ0JmQUc0QWJ3QmtBR1VBYkFCcEFHMEFhUUIwQUdVQWNnQmZB?=
 =?us-ascii?Q?SFlBTUFBeUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCakFIVUFjd0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFj?=
 =?us-ascii?Q?d0J3QUdFQVl3QmxBRjhBZGdBd0FESUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?R1FBYkFCd0FGOEFjd0JyQUhrQWNBQmxBRjhBWXdCb0FHRUFkQUJmQUcwQVpR?=
 =?us-ascii?Q?QnpBSE1BWVFCbkFHVUFYd0IyQURBQU1nQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVpBQnNBSEFBWHdCekFH?=
 =?us-ascii?Q?d0FZUUJqQUdzQVh3QmpBR2dBWVFCMEFGOEFiUUJsQUhNQWN3QmhBR2NBWlFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZBSFFBWlFCaEFHMEFjd0JmQUc4QWJnQmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFRQnNBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHVUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FISUFaUUJ6QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSFFBWlFCeUFHMEFhUUJ1QUhVQWN3QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR18MB2791:EE_|PH7PR18MB5202:EE_
x-ms-office365-filtering-correlation-id: 11a2d93c-bda7-4722-954e-08daf3c5dc0c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yFd5gfO+T4tV3kwybU6COa8K48j/JgnaRVaiRw/ALmQlNoIl6cC3OB9P6RGDNvzb6xG042ZA3C5M1GpJX6M3lPLiAfSAiKunbHHnlGnxHiP0GW3rq5crvaRvtHqouvJHhug0bW9yfhRCixCvHYQGQTjD9QQEsem/njyk5b8zSsZ+1EGHVigLeTBszOiFfP2GfHvWOmsctSATSQVGB9iWI3LvZJGNb7oyuk1eqep2EB0pYp8GPxjShW284PjpPyhPc99EDNrTSUxrUsvkHIfCEuCJuE16L16bVMK9/u4et7L+gQOZJKPXYC4KbuRVA5uQjwqU4q79Cst+mU2+6DlMzGNTjwN2bGA+e+6y7Q5INulhbzK7Q8q2gSiLcsU2aWYs4Yz67BjnUJsZSsY3bJ2Dv7c6sBfZ1JgFLXLcBjG94IqX35K5cstsaVW3WXRWi92Cg80N/g4efndUXz28YoHasoGn/5ME7NzS21TYk9dhgDoT/zuT9Wwu9ldCZ+X5j9dVdmgI/ZgtywlxIR2OvLwWfE/+j7LZftxF288TtA6VMrMcnRAayyDaREBhm0hKNeyt3eAgg9aSTcurED8r2Nso9gtBLb6yP7VFexrM9XwLSPNep/DpX6wcG15A0QGiD9KwuiC4VS9yB8FMGvPTNEj0MJ/j15CiZk/nuGjfpVSTGg1x3OAfmZs91FjsBL/lSoF/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2791.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(41300700001)(4326008)(76116006)(8676002)(55016003)(83380400001)(66556008)(6916009)(66476007)(316002)(66446008)(64756008)(54906003)(66946007)(86362001)(38070700005)(8936002)(122000001)(38100700002)(5660300002)(4744005)(33656002)(52536014)(2906002)(6506007)(71200400001)(478600001)(186003)(9686003)(107886003)(26005)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/hZ5edYjagV+qvzjb2fx+aSH6WlQr1nF/iDFBO+lpc3IsngWr8cWi3gJlUpM?=
 =?us-ascii?Q?MUmHWzyXAmygLGLJdI9TbKCFOSnRXSsLBf/7shQPRP/VLsUoyN6kinpCO7l+?=
 =?us-ascii?Q?82HZy2ucrEAY1ycn5BEtMkl8xdQI/Zq7Bgue2hmwQqdt2Mbq1knDKReAv/Yd?=
 =?us-ascii?Q?Z94u0VJkjfZKohjMhpktGVnRYsd0MzkYa5kaH8iT2dgwwpypFL24HHfMSaaj?=
 =?us-ascii?Q?uMqpmPneXWWiH4IzyRTdCKJuzYXUDFdee5Pt/VAHUWWBm0jNBS8pDUc8zlBu?=
 =?us-ascii?Q?izbbT6VqawECF2PYD4cLHtY0KJRi2sZmTbFWfEdQ05w7KR7i1CKW+CZ/kMFI?=
 =?us-ascii?Q?+vjPEytArvffCjyPQH3sIo7XZUS92sZZYbTFAIRnEkJL1YMh7yoBTTCnDN1O?=
 =?us-ascii?Q?r2A9pAPvNalBwjVQWbQxUqON+v8QdIxHTkYtORYlAjlOLLMacZmLshqBWi2w?=
 =?us-ascii?Q?4yUIKEsNgGeybwbcMHW1TUauf9OzMGMwuhKPmCz2oQIGEzzW7dH8R85XTOwc?=
 =?us-ascii?Q?bejBz/fsX0NmJks8aywg9s45vzBzqoInYBJxneFpW2OBTd2NE16h+ne3uImR?=
 =?us-ascii?Q?/nW+Id5xWklNCuZ3Xc6qOMNTv+TRjFc3pCeuHCzqMUXkyNlriKYe5Kyb/K9z?=
 =?us-ascii?Q?DGSmuC1HvrudbPIxrPU1HoOtmeYDjXo6crqm4w2yxh9TOHIE9rWK7O3fMInY?=
 =?us-ascii?Q?IpmBNCY0az0OWmry63l+TqASdU1t4tE1SA8q8KxjXrYe+Qx2AdISelto4Su5?=
 =?us-ascii?Q?l3JoTBEjX1B5kLNBcCjAVt95yz/MnfFuCM4PkDQgxCdFKKtNhLvrspbx/SKV?=
 =?us-ascii?Q?HwtDgAsOoxLPOV10IE3rEo/njuMEbWSqOBejfAvNM7/VnAvk/f7tMwslG4yL?=
 =?us-ascii?Q?k5htujqbZg5391S8sZKAwE9D0pMZTO/Ad460+fRwIpzRxVW6Azx211oKEgNv?=
 =?us-ascii?Q?jzMxrJFyso3p8V1OT5im2A9zo91dAiZo5W2PR+zONgdBnwPQnY76B8MPR7uP?=
 =?us-ascii?Q?Mng+eMWu5Q4eDQZq1b0UAuQ3Z5rP2I27IPnoKUnUmI/sL6cMLZfEupZlZT/f?=
 =?us-ascii?Q?sRv45DwHuDMWpXWxQgWb1J2GxAn5FURf61kac47SJMdgXE/GnHHr00jUUB39?=
 =?us-ascii?Q?bUFd7RplTsYH2e2xkFxCUMcEyMM5DHBBuAvw/WtfyyH3IDZ9862hi6vvMKpi?=
 =?us-ascii?Q?hIUYgq87DQYdVM2HBE9fTZ4czrpmpKFOBFiWCdqMwR+h3riydHT//pJZUhia?=
 =?us-ascii?Q?FVR+9Xo4DGNS97QIVtO8084NLEstC5YwNkqVfqMYmWvyRiA5xkxeYEX+KzRS?=
 =?us-ascii?Q?Ee03zMLwxocTaAiQBqnj/u/qfrBxTLQdV2rwutwO2KI5XO6YDI8nyx5nsKBw?=
 =?us-ascii?Q?wwV7AopRfYgv+5Vmjonp+NaqAvvDYnqAikXSLjYqFMpVq3aLy8/b0YNQqthk?=
 =?us-ascii?Q?RiIOq8FD9JWOD8ZUrc3903GnQag+hNX5BSmWD+KhI6q25RtJCduVFvHhFjkl?=
 =?us-ascii?Q?IfTgBaEtiu29ktcNYjWd6ny313ZqOLuf0oTW3FWH7b8LOx5uoVsS83q5DCW6?=
 =?us-ascii?Q?Ujkzu6bW0P6xXd70wSc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2791.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11a2d93c-bda7-4722-954e-08daf3c5dc0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 11:20:35.1953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pBAi32ajHlDhdRXFcQCcFDlVAoPRiO6v7USD/loi7Z6ju23ubggAI3jgsQsqVhSAlwFsPPdZ9ABpTBDRiSvQTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR18MB5202
X-Proofpoint-ORIG-GUID: AjtTBeVhtHRFCwkZz9-j-7lSaNnqvlbB
X-Proofpoint-GUID: AjtTBeVhtHRFCwkZz9-j-7lSaNnqvlbB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_05,2023-01-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> ----------------------------------------------------------------------
> On Tue, Jan 10, 2023 at 11:52:58AM +0530, Srujana Challa wrote:
> > Adds a new mailbox to return CPT faulted engines bitmap and recovered
> > engines bitmap.
> >
> > Signed-off-by: Srujana Challa <schalla@marvell.com>
> > ---
> >  .../net/ethernet/marvell/octeontx2/af/mbox.h  | 17 ++++++++++
> >  .../net/ethernet/marvell/octeontx2/af/rvu.h   |  4 +++
> >  .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 34
> +++++++++++++++++++
> >  3 files changed, 55 insertions(+)
>=20
> <...>
>=20
> > +		spin_lock(&rvu->cpt_intr_lock);
> > +		block->cpt_flt_eng_map[vec] |=3D BIT_ULL(i);
> > +		val =3D rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(eng));
> > +		if ((val & 0x2) || (!(val & 0x2) && (val & 0x1)))
>=20
> I would say that this "if" is equal to (val & 0x2 || val & 0x1)
>=20
Ack, thanks.

> Thanks
