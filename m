Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E97628ABB
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 21:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbiKNUr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 15:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236990AbiKNUr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 15:47:57 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0E1101D2;
        Mon, 14 Nov 2022 12:47:57 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AEGLJeQ026407;
        Mon, 14 Nov 2022 12:47:45 -0800
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kus45s166-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 12:47:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdV3r/js63uUh8+kjvnfQzihTRmfK2WSY0uRXhRlItM6la+qTAqolV/gLTxrlJ+mAoUkK+1GQrxfrq+JnSlxed/I9DgNM8Y5b1Oeb2XKYU1dWqK8LnxVmY2McCdhYUhMi6bd9dSi55ZhSHAG6Or4ZBdEczkxB9RPnSO763bzCJSiwvELpEPnazpP8tPfqZaBINCoXT/Y8kUAFXi1EmjQ+IlzWbAKv3YrfxnIS4iAWrr9wrJeFkEthSsp0fIeNTXNsrkuBTp6Es6CS1iRFH0r703aLjVIzLHTyIbTgwCSptejtQYKuPxF7F2Kbg7zFdmtLmSzXfY+G++aijVe3wU07w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DspRwc+5L6IqvvT683112JnwWtjLKq/3mdeUeJ688FY=;
 b=AqxarByjfzeXBg5nwUIlGlCro3wRy6ODhVnsTZR3Lkd521EWD5pp293rLT36DvpvbjRREna93mwqvwO+quwAtMqRrKCWe3clLBgsf0XsiJd97P0RwwNFBsPtzOBXGYQiGR5RePO4QF7fg9FvV7mzqel8ain+Yssf5jIA9NPwIQNGhOOb+E9si1vQKeDm+NprQcwPyNV2m6P1o/u5Euozs96hLwFIZt3lovXkt7vapD93Mzi0LMxTzpGijBZfPFMRJEaHaL7yj3dHkTQGOVTqYDrIF7igyC6lpsH19ix+fDSh+ne5tOARrxtmcIbAL7Jcqq0Fao9WhgnoIMZkiUEslQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DspRwc+5L6IqvvT683112JnwWtjLKq/3mdeUeJ688FY=;
 b=pb/mFoEiq2hoae/5kR5/8Ee0QkQIaQlG4yLLuufrfOkxp2wcrnTLyFMWENhQHclvpPfSGsCj7Hm7YnRQov/fEnrM0t/HcdOWe7te5rCV9onxIP+e+Hz/8lAo5IH1Zd/089myXe9NXI4YCr6gzGxZStAwf9bLdmxLw3Yz6c+7piE=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by SN7PR18MB4047.namprd18.prod.outlook.com (2603:10b6:806:100::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Mon, 14 Nov
 2022 20:47:43 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::81c8:f21b:cf9e:df2d]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::81c8:f21b:cf9e:df2d%3]) with mapi id 15.20.5791.027; Mon, 14 Nov 2022
 20:47:43 +0000
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liron Himi <lironh@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [EXT] Re: [PATCH net-next 1/9] octeon_ep: wait for firmware ready
Thread-Topic: [EXT] Re: [PATCH net-next 1/9] octeon_ep: wait for firmware
 ready
Thread-Index: AQHY8npGhIOpGkF3kEWfQ40PmZgxTK4zHjCAgAu+zqA=
Date:   Mon, 14 Nov 2022 20:47:42 +0000
Message-ID: <BYAPR18MB24237D62CF4947B889D84BDCCC059@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <20221107072524.9485-1-vburru@marvell.com>
 <20221107072524.9485-2-vburru@marvell.com> <Y2i/bdCAgQa95du8@unreal>
In-Reply-To: <Y2i/bdCAgQa95du8@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctOTNkYzU4MjgtNjQ1ZC0xMWVkLTgzNzItZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XDkzZGM1ODI5LTY0NWQtMTFlZC04MzcyLWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iMTU2MyIgdD0iMTMzMTI5MzI0NjEwMzc5?=
 =?us-ascii?Q?NTMzIiBoPSJEUlBTOG1SdzJvbGRkclVXeEJ4RWEvelFYUEk9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFQNEZBQUFO?=
 =?us-ascii?Q?MzVaV2F2allBVDBlN3ZQOGs5Z1JQUjd1OC95VDJCRUpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFDT0JRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQStSRzhlZ0FBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFnQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1FB?=
 =?us-ascii?Q?YkFCd0FGOEFjd0JyQUhrQWNBQmxBRjhBWXdCb0FHRUFkQUJmQUcwQVpRQnpB?=
 =?us-ascii?Q?SE1BWVFCbkFHVUFYd0IyQURBQU1nQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVpBQnNBSEFBWHdCekFHd0FZ?=
 =?us-ascii?Q?UUJqQUdzQVh3QmpBR2dBWVFCMEFGOEFiUUJsQUhNQWN3QmhBR2NBWlFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZBSFFBWlFCaEFHMEFjd0JmQUc4QWJn?=
 =?us-ascii?Q?QmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFRQnNBR1VBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?VUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FISUFaUUJ6QUhNQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFEUUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBYlFCaEFISUFkZ0JsQUd3?=
 =?us-ascii?Q?QWJBQmZBSFFBWlFCeUFHMEFhUUJ1QUhVQWN3QUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR18MB2423:EE_|SN7PR18MB4047:EE_
x-ms-office365-filtering-correlation-id: 4effde8e-05a9-4f85-8722-08dac6817a64
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SIBwkwMz6mjoXh3uBCYTOEDEFcGN5PVwnnxY/N8R63CP2m31de2VLBO7E7jw3wem7eam1IydHbt+dCVdd8UIFg3nkCG/FtzrDVZFi7SDherv1xoqUVHkEivqy8jYe2tTQsPI8/1/6f333fPHDVGG6NWsE4aNsdpmd4z1I/EbBXV8mI3B1UlBK9wsx7SQJ2D/K3l2gXbEy1Zuo2u6hZotoaz53oIcBcmbnLMscUejrr+B2W0wkDmFmKXV9ZLx5JxjbsiNU8Tg9B8nly8OonX7B/VBh65jD2n2v4fqCYYwXO0xSV+0h0T+E+zF9RN9pK5xHnrKqYL6IAJqOke0o6NOzwGqVNCSH7uwJIuYepE2xibrrAZ2wiq2EZK9Rsb8wr+j8OAkseIaz5+4pIXkwFXxOsiqO1ryXacx3Sff8xr6IC0IMgmxwd0m1wrHpN1V00izoVxB2eaXpRx/Yh93mj9R06bu0hnTqtef8Z2GVVRWVvzdNylp09rlpsnpPHZY2vwhgbYULJrhktsjiQu29D2HDzGHCJ/oS/Pd02t1WQOQjCjrEtDEhwVOjKqjnlDSUn5/V7y771oH9wYNWx/o+DIiPVqKCYOoNrrNbnc4NRbzqkx87d1lMw9UFy0q/p0p+SVMeA0C63GblxkpDTEKsXaGYFLlKVYOZjmxxmhnbo09F69v7YJlFPBE6Y4DhAxrDzFulMSKVncCqJZrvJBeO/2uY5sl0o2wVgkA5ImCcuq96qmHZrTMA69sTabgeTdzPuxQ75FNJ4KQK2OXZ+xBVr7tCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(451199015)(122000001)(38100700002)(33656002)(86362001)(71200400001)(55016003)(66946007)(76116006)(6916009)(38070700005)(66556008)(66476007)(54906003)(66446008)(64756008)(41300700001)(2906002)(8676002)(8936002)(52536014)(5660300002)(83380400001)(4326008)(478600001)(7696005)(6506007)(316002)(53546011)(186003)(26005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5yKHWFBBrQCxbe8EjzK2K7PM7bGI3muJWj9IZQuFHYlOPFC5NNcaR8Sqw3J2?=
 =?us-ascii?Q?y+YYJnmM8XbCSnrGcqAsjmydX+2y6ymsbO672NyUnPbl5HVOfkAX/cXR3jv0?=
 =?us-ascii?Q?SLm33VPuNqq+LFg6mmEtKHn36pNoy1O+Mg+TfLCbovrVmqhsFB4rou9tC3t5?=
 =?us-ascii?Q?ZOo9ibqEEobNSElNLgBqQHJjjXnyJ/fiK7GtcBgKIOgDYT1/evZ4bcI7uOO8?=
 =?us-ascii?Q?hnpIsKVEgvSuZIe5juGWjwKrkOFHEgmLPV4dMwpup8j4WVWbS8+NGVMV55Sz?=
 =?us-ascii?Q?55ek4OYSzGnzQmkB0T1R9woLZmohmGAAbRjgu4WTXvyvusJwiItQLeLUWG75?=
 =?us-ascii?Q?MXIdnl4wpCTJTmeqroo3pSYAQLJ3kOFZc+r4K18u6NDQVN0w4mwCS1XAN8Oq?=
 =?us-ascii?Q?/KHNHgiUQ5ZszI3r604OyHBRvDYnyBKNt/+noQ26jdfSORzGCdMMyqudJHEN?=
 =?us-ascii?Q?GuPkPWnVBQx5z9bQABkWWbe8gZ1+1ThvMK588Y8zwtcWJsguK0iNAvQ08ef2?=
 =?us-ascii?Q?iaLqZyaRPcoM5rsoE7Rp/rgQaVldE2N9q5LC0CO6CKVuKcbtG67x6knFjfVT?=
 =?us-ascii?Q?wywDhdL2WSHv157COK78B6fBJ6LmSsPnG9LaN7D/ycGp9gZ+25EcjvqvwqUL?=
 =?us-ascii?Q?I7Mg/AW+ruu3B1+Bxx2MJ1xTEzPTsvaV5KPK0oM3Akp1fXpx0ZgXZ6zNspaB?=
 =?us-ascii?Q?EFOdVa1PmSkpo7z2gpxhMM2Sia2BXitXDxy5+7tqtaLvM0VYHqJ+2b0uCAmy?=
 =?us-ascii?Q?MXBI2hjOXqWTH1gEUgLCYggv3nF+Yh4phLk4I3sBv+fDtds1s865COdV5PF1?=
 =?us-ascii?Q?yv4orHRkNuQi+itJrpm2c+c8NolwuVGCKzj942PB8ZrHLYbBP4GXNO/SaomZ?=
 =?us-ascii?Q?V2bN4fLxoFJ7LovZaBlaXUiFylV+7U2YkqWN+vx6llbcQbdU21JUslDpsAMo?=
 =?us-ascii?Q?fe4vQW7FfdVtLj6VUk8HCl7G6pn1R0rlX1zNLL5MM55yYnbZZbZEFqeK4N1J?=
 =?us-ascii?Q?t76MXtFW3mgdOvkcIkuejBPD9v3umKPx03s4vnBZY7oenSh108JQGeK0ULCK?=
 =?us-ascii?Q?LMMaX+Q97tpTXm/Cl8cfcW2CUDliNvA9bO7c6mYYBLNsAx9VQazJTNx1byq0?=
 =?us-ascii?Q?6SmFR+m45esnKGeP4RFvwpIYW6O7MaUnusfeceoZ9edNFqwIB7rZo7wiGrAw?=
 =?us-ascii?Q?7CdCshEZloIQaW+Z8bLQB/TJMu2OUusSiSdpDZLi1+vdK6tYKpF5SMSJYDXk?=
 =?us-ascii?Q?SFdkttxj1Rix6IgkwLiFFg1x6K0p1coR+CzCYUBAknuKYwo2wfhB6HCAEk1l?=
 =?us-ascii?Q?Dv1aOjz1dj7h0jeBXtxpaQUJe+pJDHFsgNnx9V+uvP0vZb4YTrLZk8+ABehs?=
 =?us-ascii?Q?ucu2xFcSEiMZ0BaWdd+EoHaUjQYRXbou+4G3g7TX500C1eV66TSb57OZVpk3?=
 =?us-ascii?Q?V4t7inETcyamRvCTrtoo9V5TTOKVc+L6XICPC8hX9SXE6OF5j9bFR1fg1wZY?=
 =?us-ascii?Q?d2VPby36UF7gbtbP3ggTn44Ie9RCF5pcRpmfxndS7Fd/JnA4jyQRtc5GwKQb?=
 =?us-ascii?Q?aypknWiURbT8dbbNces=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4effde8e-05a9-4f85-8722-08dac6817a64
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 20:47:43.2523
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UhVPmlbp4OsjGQXMs8nyFikB5z7T1EcohU5L6NQLuSYUBMmyMZytjKjyDR0UY+v8ZLSZAe0l7nRH/jxvrikctA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR18MB4047
X-Proofpoint-GUID: ecBp8dQ9lL75OhLqvePm3ZEzJFkI9u4T
X-Proofpoint-ORIG-GUID: ecBp8dQ9lL75OhLqvePm3ZEzJFkI9u4T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_13,2022-11-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Monday, November 7, 2022 12:19 AM
> To: Veerasenareddy Burru <vburru@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Liron Himi
> <lironh@marvell.com>; Abhijit Ayarekar <aayarekar@marvell.com>; Sathesh
> B Edara <sedara@marvell.com>; Satananda Burla <sburla@marvell.com>;
> linux-doc@vger.kernel.org; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>
> Subject: [EXT] Re: [PATCH net-next 1/9] octeon_ep: wait for firmware read=
y
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Sun, Nov 06, 2022 at 11:25:15PM -0800, Veerasenareddy Burru wrote:
> > Make driver initialize the device only after firmware is ready
> >  - add async device setup routine.
> >  - poll firmware status register.
> >  - once firmware is ready, call async device setup routine.
>=20
> Please don't do it. It is extremely hard to do it right. The proposed cod=
e that
> has combination of atomics used as a locks together with absence of prope=
r
> locking from PCI and driver cores supports my claim.
>=20
> Thanks
Leon
          What is the alternate approach you suggest here ?  Are you sugges=
ting usage of deferred probe ? the driver initialization cannot proceed til=
l firmware ready is set by firmware.
Thanks
