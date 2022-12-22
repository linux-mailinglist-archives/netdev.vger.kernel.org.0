Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38DC2653D91
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 10:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiLVJir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 04:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234636AbiLVJip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 04:38:45 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1AF2791C
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 01:38:45 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BM7MSRG015436;
        Thu, 22 Dec 2022 01:38:43 -0800
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mm79c3ubg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Dec 2022 01:38:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbDW/Yvua00H6pEuvGnve0E4qSpii/CAbFlwuFkHaSQPA6CVRrdB+Ihefo4/BizjtFbLi388X/vnHImx9XCXAm0Z45bB8DVoCYhLtKnp5QcSPKRkkX0hGDQ1YesYs+qE/gPxAK6vM2bTa6YlpghaBjgXifpXruSdDPvlD4rxr4gBcncNBB3JlTWXRDzsKaVLwMaAvJmD1zO+O0g9k4u38OFDlSBJlmXcmGb1/ua2PpEkoySu4DHsytuUWqblsJBmAUVVYxG8LlQsQ+OK+gYik3hBFp+V+iB6UNlEBQhhq8Xv4WbuT5avr/FOFqKrRj7ImCnsYmGhsB+w8MyJcyQiMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBhR/MurNWhzIl2qhlOGrfWeg2P6ajRtJ2ZyGWrHeLM=;
 b=BBlGhbhNQGGDcqUHgoVXVqhpDclZGQAvCYwXS9x1PQGWOCRT9JDSrBsxukAhSS4IozPRckKhyCY0QKexuTZlI7bt2xpibSYDsl5YsWYq5OJpeTCRkNjxnrGSS0Nc7vFAyeunBHxjFU1Kwlb98Ws4Vt3p2lmw3SGfs/ANG8ccaKbZ+R7tlcNuxhjWk6NzAnhFavOAIYUqEKJBK0Qyo26puKQXYCXa579nXGicriUVl4/JZZWRCWF04qirq48UKJr6Ib0EJXj5++p/osxhU/O4JCI3ieEn4Cncn/XmwjOsyVICON9ki8lwK4syeJxXNXhskHUjI0sfbPQYtrQv1Xi/CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBhR/MurNWhzIl2qhlOGrfWeg2P6ajRtJ2ZyGWrHeLM=;
 b=leQTFb9Wg9HSPwuZfI/3dXCikolEX+6IvfPNDBAD1b3NJgLZ28RyrzRbWenGMCAJFykX0uM2ek3h/xUk8kCkZr6IDeW9NjCIYAcRpp6l++Wj7+94Zsbaue53ENQ3z77WK6iK37whE+vw2bHY0eRoun772zB5GR6xzjcupZe/UG4=
Received: from SJ0PR18MB3900.namprd18.prod.outlook.com (2603:10b6:a03:2e4::9)
 by PH0PR18MB4574.namprd18.prod.outlook.com (2603:10b6:510:ac::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Thu, 22 Dec
 2022 09:38:41 +0000
Received: from SJ0PR18MB3900.namprd18.prod.outlook.com
 ([fe80::45d8:a287:d7c2:f0c7]) by SJ0PR18MB3900.namprd18.prod.outlook.com
 ([fe80::45d8:a287:d7c2:f0c7%4]) with mapi id 15.20.5944.006; Thu, 22 Dec 2022
 09:38:41 +0000
From:   Alok Prasad <palok@marvell.com>
To:     "csander@purestorage.com" <csander@purestorage.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "joern@purestorage.com" <joern@purestorage.com>,
        "csander@purestorage.com" <csander@purestorage.com>
Subject: RE: [PATCH] qed: allow sleep in qed_mcp_trace_dump()
Thread-Topic: [PATCH] qed: allow sleep in qed_mcp_trace_dump()
Thread-Index: AQHZFektnqlEfQ0lNkG2Ck4p1WYkBQ==
Date:   Thu, 22 Dec 2022 09:38:41 +0000
Message-ID: <SJ0PR18MB390077BA38838F7BDA2C57C5A1E89@SJ0PR18MB3900.namprd18.prod.outlook.com>
References: <20221217175612.1515174-1-csander@purestorage.com>
 <PH0PR18MB516573B4C93F1A0CC27D5818C4E49@PH0PR18MB5165.namprd18.prod.outlook.com>
In-Reply-To: <PH0PR18MB516573B4C93F1A0CC27D5818C4E49@PH0PR18MB5165.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccGFsb2tcYXBw?=
 =?us-ascii?Q?ZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5?=
 =?us-ascii?Q?ZTM1Ylxtc2dzXG1zZy02OTI0NTIwYi04MWRjLTExZWQtYWQ2NC04MDhhYmQw?=
 =?us-ascii?Q?MzRiNWVcYW1lLXRlc3RcNjkyNDUyMGQtODFkYy0xMWVkLWFkNjQtODA4YWJk?=
 =?us-ascii?Q?MDM0YjVlYm9keS50eHQiIHN6PSI2Mjc2IiB0PSIxMzMxNjE3NTUxODU0MDA4?=
 =?us-ascii?Q?NzIiIGg9ImtWaHh1cm9HR3B6TXQzQzVOWm1vKyt0dTBhRT0iIGlkPSIiIGJs?=
 =?us-ascii?Q?PSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQU5nSEFBQW9U?=
 =?us-ascii?Q?SDRyNlJYWkFmVi9QbTRDcWttTTlYOCtiZ0txU1l3TUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFIQUFBQUJvQndBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFRQUJBQUFBM1R6RkFBQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFaQUJ5?=
 =?us-ascii?Q?QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4QWNBQmxB?=
 =?us-ascii?Q?SElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQXdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
 =?us-ascii?Q?QUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VBYmdCMUFH?=
 =?us-ascii?Q?MEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJqQUhVQWN3?=
 =?us-ascii?Q?QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFNQUF5QUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-rorf: true
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFk?=
 =?us-ascii?Q?UUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhBY2dCa0FI?=
 =?us-ascii?Q?TUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcwQVh3?=
 =?us-ascii?Q?QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYVFCMEFHVUFjZ0JmQUhZ?=
 =?us-ascii?Q?QU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFB?=
 =?us-ascii?Q?SUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhBY3dC?=
 =?us-ascii?Q?d0FHRUFZd0JsQUY4QWRnQXdBRElBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdR?=
 =?us-ascii?Q?QWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFHMEFaUUJ6?=
 =?us-ascii?Q?QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3QnpBR3dB?=
 =?us-ascii?Q?WVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdjQVpRQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: QUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0FjQUJmQUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFHWUFhUUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpBQmtBSElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQ0FBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhRQVpRQnlBRzBBYVFCdUFIVUFjd0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFBPT0iLz48L21ldGE+
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR18MB3900:EE_|PH0PR18MB4574:EE_
x-ms-office365-filtering-correlation-id: 6b77cdc3-2393-4780-8b82-08dae4004f88
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: negRp1Gr1ayj+0Ubs5nYvh+Nogn5xQRTKDxUh345r35y2KuSqkgzagNw72q8Yf/GvCenvY3Zd4QLoh/VoIuKWgTaKQdjs25ABy6SsFCLz2JO9iJolt2rFBPTKMFtl+Ay/G9JIyoiF272z7kKxZLipBtS/yCSB1XNntrhd9P6g51Xxy0XBPkVAbX8N9yzl14MluzHrKRmWdKiWbyko2/lY8IfaBbERWwHH5cJ4U2d/NSiv9iyFLiNlMjA/TDIpbaUOwxV7OpPQcJKdDWXYXpz1Axm5uzLsN2SarNreLTYPTW6OmMLQIqx+dNxOEOP75B5+7tWmchGW9f27DmrCEwh4+7/boTrUmRdxvyd3zJQk3IclAGVsaJfGBvj1gIXVOb0nAzdp0tE/gpMAXwWxILMY8Rw47TcGIwy/OJtXZH93CbvU1K6GHK5hjtNI0208gJMOk+Rgzi5YbIX2n1fOMAhgJh8IsFOxBsfMweI4O6erGPuUfjg2lDae/Bmm9LwghQPG+ewZEpUXnv1Iydu6y6sG2oqNaaiYLaWqRbWYiD5N/WQK9T4mLwKST6xGto5MAYpsE4fr1oceH+a5oDrjj9UkIu1VWu1bNEwLHvEuKzCQBaZT+A9ODH9V7NpKWV+7ER7fA5xJAKEpUadh6i9atA9jFEzJ36j4PiV0mBQW9MyhrfSB6Qqhl2khAav0K62NBvXc8Dgr0biIzuDpO0wv7oD0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3900.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(451199015)(66446008)(66946007)(66476007)(64756008)(66556008)(8676002)(4326008)(110136005)(316002)(76116006)(54906003)(8936002)(41300700001)(52536014)(5660300002)(186003)(478600001)(2906002)(53546011)(55236004)(7696005)(6506007)(9686003)(26005)(55016003)(83380400001)(38070700005)(86362001)(71200400001)(33656002)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?19pl2xByzYd0AcDtE7t4o+VErq7oVtHK9kEFFhYhCMneAz+B6c9LMFt8djOm?=
 =?us-ascii?Q?stw+qK0Tn5j9pj3MemCETl60DxzE3SrJKxDHv/Hb8WcVXoE0EJlXsbIODjvx?=
 =?us-ascii?Q?qOsnkD7TD1Myrkb7Q1T+3aUPlQIOZQ2gljkeGA4rJaRVTB/FIk+8XcGahBdv?=
 =?us-ascii?Q?90BvAmQUfWhZsXgcH82YEBsH+dUQMAIQZJ2K5+sWgUbeIE9AgPRMBbZTNrpV?=
 =?us-ascii?Q?kQvNVOAdIX8vBXM2tq0BFKSuJl1jWuF8eXAQTfo5m85F7JcgrfBmnNG0Nvr5?=
 =?us-ascii?Q?IEXOJYvFlpyQmAZJd2vdFxm5z0IXCpPN7iOhVGtKGjXCtft7VZoKzDUbsQCQ?=
 =?us-ascii?Q?TJscBIXpk2uLv/Snw9wdnJSN1YUjYGaBHmzJcr2l+j1P6yA9uhJfOKNijeUG?=
 =?us-ascii?Q?YbDIfPifdaURAWlwx6wH9UdYmUQ98qwO2TxpkXZl79u9o2s6GLYpOJawa1+h?=
 =?us-ascii?Q?s8nfb8in8A0/IwUqFNLnyR10EYmYSesxNl5wegk8p/YqAcWkn8XloqbGKL65?=
 =?us-ascii?Q?bDMGQTqFhCVYd7OIYKLkDisLEAaKI3e2XELk36gS+JkBV6bVX7ouDb7QVBzR?=
 =?us-ascii?Q?xqT3DqWsjQMhLfV4I6G36Tuv85fouNrg7+24QvSMrelmLSqPh3IMVw7x+Gnp?=
 =?us-ascii?Q?GWsh2XMnKvV1Py7I+8C/pMB7fO74yEFuHo5y+gmMvTN27sYyP6owMOaGrCUy?=
 =?us-ascii?Q?3PpZqF/Drh523LwyRacxJ2PZ8QZ5GmTNdfgQhw7mhYj4VCvqje9gwOIHMPbe?=
 =?us-ascii?Q?fpZUgjCBtw9ypVTndrFqiVVql0jwu0tNPks1vupsQL2cXfePQvLhHbQNtV/6?=
 =?us-ascii?Q?Z/QGq7qN/TCEyz8dnMfwM9HiiC8ziNeEivv9QDEHVJNHUyHT/yRgPxO3HO6j?=
 =?us-ascii?Q?2NMuYySH+RHFvFiU0BAu7BrS5iVaZ4AhnNmc54Ke219AP0b09RsojEn1scTi?=
 =?us-ascii?Q?6fVUeGVoEoUAbrMNb+5eBhMP+tOv0S1kocrknYOO4BSIrfhQMucdIleY3BFY?=
 =?us-ascii?Q?17/YLGByRu4SGuBtiGp4vBRbX+nDdx2sqkr45bpOieVsn5Q3ZgIRGYJ3gpp9?=
 =?us-ascii?Q?qufIJuxihIkPpKTVvzcFtmLlTVNKMpdiPGPIk+MTbokiUlYnj6GJ0ELiCe4v?=
 =?us-ascii?Q?XAAcFwSlTAYgC0ltUdACnI4FVpTyAX/Aef5/jNA1kdeUNZ9uunFbeKx7wZ66?=
 =?us-ascii?Q?qEdgtnUdaqUrWQxu3ka5upp999w9ehy94TDPykLZu+y+1S3PnTfVNVDvHYDB?=
 =?us-ascii?Q?7Jc4UcmNmK8X4wwpZkkFUT9fgc6cIUOATFUUPDPKWJYuzh0VFYguCOntIJoj?=
 =?us-ascii?Q?A++ZAVHGUstEJspTsow0XKVsGEfbd71bDPt1ZdE4bX/6i4rHfFIkBcMZrC9Q?=
 =?us-ascii?Q?MDdCJwrLC/ZsDqsW9R4r+zIOsVY8as/c6DGMUJEpicx/IzcZwlWDiYqjOV0p?=
 =?us-ascii?Q?Uzng6WeC3Cd8PnOBcszkZ0agNWETdKekaygrr44Of8JtnnWSdo6HyCaTcQHL?=
 =?us-ascii?Q?DQLzrlHBdpmkHDnGyixI9xsKVE0+RaV+Is71L/mFjtG60EJF/FQAZ7oAdoym?=
 =?us-ascii?Q?nxrSrvpfn0KSMzzayvY69cBWTjfgj8IW1MjGit+t?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3900.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b77cdc3-2393-4780-8b82-08dae4004f88
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2022 09:38:41.1671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1w6jeK95JyBY0+qtR1Ir9bLsHaBBvBMT/EjcHlnQ/pSGoC+KGMenp+mksPT8+LThNfUJtWYsFqZ8BfH+FNKedg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4574
X-Proofpoint-ORIG-GUID: zhF71blP9314zKNRYzpEScHPeF37XsHv
X-Proofpoint-GUID: zhF71blP9314zKNRYzpEScHPeF37XsHv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_04,2022-12-21_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Caleb Sander <csander@purestorage.com>
> Sent: Saturday, December 17, 2022 7:56 PM
> To: Ariel Elior <aelior@marvell.com>; Manish Chopra=20
> <manishc@marvell.com>; netdev@vger.kernel.org
> Cc: Joern Engel <joern@purestorage.com>; Caleb Sander=20
> <csander@purestorage.com>
> Subject: [EXT] [PATCH] qed: allow sleep in qed_mcp_trace_dump()
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> By default, qed_mcp_cmd_and_union() waits for 10us at a time in a loop=20
> that can run 500K times, so calls to qed_mcp_nvm_rd_cmd() may block=20
> the current thread for over 5s.
> We observed thread scheduling delays of over 700ms in production, with=20
> stacktraces pointing to this code as the culprit.
>=20
> qed_mcp_trace_dump() is called from ethtool, so sleeping is permitted.
> It already can sleep in qed_mcp_halt(), which calls qed_mcp_cmd().
> Add a "can sleep" parameter to qed_find_nvram_image() and
> qed_nvram_read() so they can sleep during qed_mcp_trace_dump().
> qed_mcp_trace_get_meta_info() and qed_mcp_trace_read_meta(), called=20
> only by qed_mcp_trace_dump(), allow these functions to sleep.
> It's not clear to me that the other caller=20
> (qed_grc_dump_mcp_hw_dump()) can sleep, so it keeps b_can_sleep set to fa=
lse.
>=20
> Signed-off-by: Caleb Sander <csander@purestorage.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_debug.c | 28 +++++++++++++++-----
> -
>  1 file changed, 20 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> index 86ecb080b153..cdcead614e9f 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> @@ -1830,11 +1830,12 @@ static void qed_grc_clear_all_prty(struct=20
> qed_hwfn *p_hwfn,
>  /* Finds the meta data image in NVRAM */  static enum dbg_status=20
> qed_find_nvram_image(struct qed_hwfn *p_hwfn,
>  					    struct qed_ptt *p_ptt,
>  					    u32 image_type,
>  					    u32 *nvram_offset_bytes,
> -					    u32 *nvram_size_bytes)
> +					    u32 *nvram_size_bytes,
> +					    bool b_can_sleep)
>  {
>  	u32 ret_mcp_resp, ret_mcp_param, ret_txn_size;
>  	struct mcp_file_att file_att;
>  	int nvm_result;
>=20
> @@ -1844,11 +1845,12 @@ static enum dbg_status=20
> qed_find_nvram_image(struct qed_hwfn *p_hwfn,
>=20
> 	DRV_MSG_CODE_NVM_GET_FILE_ATT,
>  					image_type,
>  					&ret_mcp_resp,
>  					&ret_mcp_param,
>  					&ret_txn_size,
> -					(u32 *)&file_att, false);
> +					(u32 *)&file_att,
> +					b_can_sleep);
>=20
>  	/* Check response */
>  	if (nvm_result || (ret_mcp_resp & FW_MSG_CODE_MASK) !=3D
>  	    FW_MSG_CODE_NVM_OK)
>  		return DBG_STATUS_NVRAM_GET_IMAGE_FAILED;
> @@ -1871,11 +1873,13 @@ static enum dbg_status=20
> qed_find_nvram_image(struct qed_hwfn *p_hwfn,
>=20
>  /* Reads data from NVRAM */
>  static enum dbg_status qed_nvram_read(struct qed_hwfn *p_hwfn,
>  				      struct qed_ptt *p_ptt,
>  				      u32 nvram_offset_bytes,
> -				      u32 nvram_size_bytes, u32 *ret_buf)
> +				      u32 nvram_size_bytes,
> +				      u32 *ret_buf,
> +				      bool b_can_sleep)
>  {
>  	u32 ret_mcp_resp, ret_mcp_param, ret_read_size, bytes_to_copy;
>  	s32 bytes_left =3D nvram_size_bytes;
>  	u32 read_offset =3D 0, param =3D 0;
>=20
> @@ -1897,11 +1901,11 @@ static enum dbg_status qed_nvram_read(struct=20
> qed_hwfn *p_hwfn,
>  		if (qed_mcp_nvm_rd_cmd(p_hwfn, p_ptt,
>  				       DRV_MSG_CODE_NVM_READ_NVRAM, param,
>  				       &ret_mcp_resp,
>  				       &ret_mcp_param, &ret_read_size,
>  				       (u32 *)((u8 *)ret_buf + read_offset),
> -				       false))
> +				       b_can_sleep))
>  			return DBG_STATUS_NVRAM_READ_FAILED;
>=20
>  		/* Check response */
>  		if ((ret_mcp_resp & FW_MSG_CODE_MASK) !=3D
> FW_MSG_CODE_NVM_OK)
>  			return DBG_STATUS_NVRAM_READ_FAILED; @@ -3378,11 +3382,12 @@=20
> static u32 qed_grc_dump_mcp_hw_dump(struct qed_hwfn *p_hwfn,
>  	/* Read HW dump image from NVRAM */
>  	status =3D qed_find_nvram_image(p_hwfn,
>  				      p_ptt,
>  				      NVM_TYPE_HW_DUMP_OUT,
>  				      &hw_dump_offset_bytes,
> -				      &hw_dump_size_bytes);
> +				      &hw_dump_size_bytes,
> +				      false);
>  	if (status !=3D DBG_STATUS_OK)
>  		return 0;
>=20
>  	hw_dump_size_dwords =3D
> BYTES_TO_DWORDS(hw_dump_size_bytes);
>=20
> @@ -3395,11 +3400,13 @@ static u32 qed_grc_dump_mcp_hw_dump(struct=20
> qed_hwfn *p_hwfn,
>  	/* Read MCP HW dump image into dump buffer */
>  	if (dump && hw_dump_size_dwords) {
>  		status =3D qed_nvram_read(p_hwfn,
>  					p_ptt,
>  					hw_dump_offset_bytes,
> -					hw_dump_size_bytes, dump_buf +
> offset);
> +					hw_dump_size_bytes,
> +					dump_buf + offset,
> +					false);
>  		if (status !=3D DBG_STATUS_OK) {
>  			DP_NOTICE(p_hwfn,
>  				  "Failed to read MCP HW Dump image from NVRAM\n");
>  			return 0;
>  		}
> @@ -4121,11 +4128,13 @@ static enum dbg_status=20
> qed_mcp_trace_get_meta_info(struct qed_hwfn *p_hwfn,
>  	    (*running_bundle_id =3D=3D
>  	     DIR_ID_1) ? NVM_TYPE_MFW_TRACE1 :
> NVM_TYPE_MFW_TRACE2;
>  	return qed_find_nvram_image(p_hwfn,
>  				    p_ptt,
>  				    nvram_image_type,
> -				    trace_meta_offset, trace_meta_size);
> +				    trace_meta_offset,
> +				    trace_meta_size,
> +				    true);
>  }
>=20
>  /* Reads the MCP Trace meta data from NVRAM into the specified buffer=20
> */  static enum dbg_status qed_mcp_trace_read_meta(struct qed_hwfn=20
> *p_hwfn,
>  					       struct qed_ptt *p_ptt,
> @@ -4137,11 +4146,14 @@ static enum dbg_status=20
> qed_mcp_trace_read_meta(struct qed_hwfn *p_hwfn,
>  	u32 signature;
>=20
>  	/* Read meta data from NVRAM */
>  	status =3D qed_nvram_read(p_hwfn,
>  				p_ptt,
> -				nvram_offset_in_bytes, size_in_bytes, buf);
> +				nvram_offset_in_bytes,
> +				size_in_bytes,
> +				buf,
> +				true);
>  	if (status !=3D DBG_STATUS_OK)
>  		return status;
>=20
>  	/* Extract and check first signature */
>  	signature =3D qed_read_unaligned_dword(byte_buf);
> --
> 2.25.1

Thanks,

Acked-by: Alok Prasad <palok@marvell.com>


