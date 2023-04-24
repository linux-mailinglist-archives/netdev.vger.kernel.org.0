Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267E66ECA51
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 12:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjDXKax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 06:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjDXKaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 06:30:21 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8333C10E9;
        Mon, 24 Apr 2023 03:29:12 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33O7W46O027062;
        Mon, 24 Apr 2023 03:29:06 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q5nfb0hvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Apr 2023 03:29:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2z5+Emk+hJZkOS/zmj11j7ePq2yDwDAORaO+ShRIGqA7AZakzTVUOXKnbPc3btd+KAUWyCRGdWas3gffvrMk6Uq7byqkEx/q39BGlGRhwX5AxTuhhXquthE97kjAbWKStxJ1auIw5SDRNHsSZDxePQrx/ZKLRRblw/ampqFJsxIa6OuKnzp7ahwe1KTWJId3zeIYIzZDTjwljs5zAWDTuSxey+XilIe1xqb82Tuwp0JQjUl8mHnPIxmKQHRZji+fs+Ua19AcOrE7uJCFfQ1WhzPlVqFiuKZxLQGE5DKQ0e0q2Fe1C8Mo9gsmRgrASolJ0rywFeJsD47bsQO6do2jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBdVqmFz/JrkkbkNAbxyQBuRQf5rJxPxRvAfzkOw7Iw=;
 b=PoJ5OlNicWahSt+33ZKFE1n9NmB4cFAT8cpQNNCqljWfBhjxPHLDpWXpjNrHaIc3WobulRW2EdGjp3Nv6j0iHr8S4nXQTZkuxyl4LBo/iSzt3BomEuKgLx2TK9QCtjBmp/xB2QMrtVSQ7OlU5IFjQX+pf4gJMEY6jDwWp/xgH03oSBpHZGNUW589ZUDn8V+glVfg3riWV3psG+BTMKt4q0srl6eyL5NkIKb1voqLUP2Mitlcc2ryfbUPhPTZpYB0GhwjRiSzVZTjxlIrUFfhrUvccV8RHvFwWLg+9fbOPv3zH/4RWX0C/l9jh04fiF7/BysRC3V50pxPA+tIJWFMAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBdVqmFz/JrkkbkNAbxyQBuRQf5rJxPxRvAfzkOw7Iw=;
 b=D2ghNeSi7OI/ruTNkYgk/4T46M/VPndP5p5j5EglAU5O0ULeFj0qq/VqKw6LznOkukUj113+FN61rmx7NHDkCpa2r9YL6NaJOki0+LByZS5vsIsi3b5k3UFoHULxIEKZR2+LXw0D0qrKdyKzPXeEtgpMWWNjHfb2fJ9PrqO0Img=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by SN7PR18MB5316.namprd18.prod.outlook.com (2603:10b6:806:2dd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 10:29:03 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 10:29:03 +0000
From:   Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Geethasowjanya Akula <gakula@marvell.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: RE: [EXT] Re: [net PATCH 5/9] octeontx2-pf: mcs: Fix NULL pointer
 dereferences
Thread-Topic: [EXT] Re: [net PATCH 5/9] octeontx2-pf: mcs: Fix NULL pointer
 dereferences
Thread-Index: AQHZdcm4UJQxQd8npUuKPSkZPc09I685HCSAgAEmLgA=
Date:   Mon, 24 Apr 2023 10:29:02 +0000
Message-ID: <CO1PR18MB4666A3A7B44081290B37E375A1679@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <20230423095454.21049-1-gakula@marvell.com>
 <20230423095454.21049-6-gakula@marvell.com> <20230423165133.GH4782@unreal>
In-Reply-To: <20230423165133.GH4782@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2JoYXR0YVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWQyOGI3ZGJjLWUyOGEtMTFlZC05YzU5LWJjZjE3?=
 =?us-ascii?Q?MTIxOGI3YVxhbWUtdGVzdFxkMjhiN2RiZS1lMjhhLTExZWQtOWM1OS1iY2Yx?=
 =?us-ascii?Q?NzEyMThiN2Fib2R5LnR4dCIgc3o9IjUyODgiIHQ9IjEzMzI2ODA1NzM5NDIy?=
 =?us-ascii?Q?NjAxMSIgaD0iY1dNTWl0b0xRbzVxYmlvQmp6bXI0TmpZWEtvPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSFlJQUFC?=
 =?us-ascii?Q?Ym8rT1VsM2JaQVZkN2pmR1o1RXowVjN1TjhabmtUUFFOQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQUdDQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUFvOWlqZlFBQUFBQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY0FC?=
 =?us-ascii?Q?bEFISUFjd0J2QUc0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
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
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZB?=
 =?us-ascii?Q?SFFBWlFCaEFHMEFjd0JmQUc4QWJnQmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFR?=
 =?us-ascii?Q?QnNBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFB?=
 =?us-ascii?Q?QUFBQUFBQUFnQUFBQUFBbmdBQUFHVUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FI?=
 =?us-ascii?Q?SUFaUUJ6QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFFQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSEFBY2dCdkFHb0FaUUJqQUhR?=
 =?us-ascii?Q?QVh3QmpBRzhBWkFCbEFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dC?=
 =?us-ascii?Q?MkFHVUFiQUJzQUY4QWRBQmxBSElBYlFCcEFHNEFkUUJ6QUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUEiLz48L21ldGE+?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR18MB4666:EE_|SN7PR18MB5316:EE_
x-ms-office365-filtering-correlation-id: be8f96e2-e20a-4720-57a4-08db44aeb98b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EAsVNYU4uX2oUdFhjon7LZPTlxU+lDF1aOy5ER9Bs15+rs/QrEw0XuXINn5VQPrwVkhACFlR1qiVekSpvdJaYt34GPYeYBOIsTDrNy/hjrga2XFdm+aC/c6IERRzowOotxIP3kk0z1h0JaiKlHrmUVrni8rbnXLw9vZXmd0vCfrnjFu7+dmOs9iiRiiT9KSwV9n6BlD2k5mt4TpjqqEqWrYJus555cmzuL4yM3bqKacAeSCOQ7mLlkgWv/Nq06KuSFWdQ/rxydhGLdX1lIOvsJku+iS29cXy4+aCxuAgFeDpksa1sWuOLH1Po2Chu+6QiW1ELMiKpv/txZb1+grRGl6s5Wo68ODJIJojk0eowDiNBVKu33sPU8IjpBaIB9b15E0PFtCLt+t+IZk/gUxGhSRhOx0SnTv5l3xxZxClCyNb/DvQ5v/okRzMoPmPKZsZOVDCDtlnoiSxRFiE73RQupe187PhYv0Yf81CjOJywzOLAfkeedELjLZGh1sgGs546LcfqwriNkQleJG0AUrghq3SAx5LN56U96e2tJLv5TcbNB9HT8Idr7fZUlekd+GzfdFUrohqJ2rLJ64ZR+sefRYNaJoWv2hqW702oWR7ciiY+sBjr+SavF1IAEVeG/J+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199021)(107886003)(9686003)(26005)(6506007)(8676002)(8936002)(4326008)(6636002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(54906003)(316002)(110136005)(41300700001)(478600001)(33656002)(71200400001)(7696005)(55016003)(52536014)(5660300002)(122000001)(38100700002)(38070700005)(86362001)(2906002)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jovuQPW2BZIfyl4wqtpNaJkfOZ4TlnpEIXDk2rNu2TQo2tVSEc+FGnZRjBFZ?=
 =?us-ascii?Q?J+5gKzC0lVMbfoB9iO/4zmuocZ9hP/aSNiJEXsrIw9L1UWoy5/JTEnsufSJ1?=
 =?us-ascii?Q?d9csUK1SF3etDIK4hc+kVxtHJib5/IW1CHpATLbWMJWfjue1Yw7GtHghUHBp?=
 =?us-ascii?Q?+H7pXOlSOefNT58NymDQthHjBIjBn1YCMCKKj5lTWYjXoCvnGC0BADjsu/1Y?=
 =?us-ascii?Q?ujLuoWtMCLCtqU47+LwjaSyYMPxYb085TgaeZRBUd1oBlEbDBvtFz8wkMopE?=
 =?us-ascii?Q?5hwoZJPTLtxsKNjkcv1/Xvrpeb+Zwqs6fS+c4T2ZgqOfscXP+fNMwPDg2jHK?=
 =?us-ascii?Q?iaQ4/dchjpXbjRBd3SFh7EVGe1SBKVIEraABBRypJCuYPXFFi3bTO/DAPPwY?=
 =?us-ascii?Q?bBplu3WMon0Iff8cAdhX7q7EpfYCBMeQBWqEf7HIL3CE6ZKg6ywZ5N+GB9hU?=
 =?us-ascii?Q?44UJZvhQsjToFJv2W8RAQuDqOXvTFIxYiyUb5R5FSuMeGassZpayBjB+wVRj?=
 =?us-ascii?Q?h46CRpvIl9HZePVcaDEdCy3TgSLffJNvDeodEsacNF5fIjuP1xJx+F6G8YBs?=
 =?us-ascii?Q?fn/JpqYlFI9f1N9m3aMJtfA7F38WkKMuliDebuWGstQsN8z/XjzCpXwIvONd?=
 =?us-ascii?Q?cwpMVFPf4xTLVBKKlSMAwTtJ+VtZcp3vS9zK6b7/foYwJNidEkyYiBvDX5lF?=
 =?us-ascii?Q?IXCuvLla73OJ5X5NIYJSMBVWgbXRLG2vUhRoKuCsYij7IMWbK5ReC7oY35Bk?=
 =?us-ascii?Q?zCJA+LvHRhHqEbAzb/OnCzdHQy4iiwbnmM/8vt4SeSYU8IEyeKQj0FVhNLrU?=
 =?us-ascii?Q?B7WbGPfLt3gLF/sg3vlLsxOdTYrny75kAaMsXcnUpnTiIcUPUGRujfk26b8N?=
 =?us-ascii?Q?p4Ty62ctMQ9gg26RWo7FuyaaqubvsWWqJoBK06iTyEQjF28VMNza6BxtKbAl?=
 =?us-ascii?Q?1R6fFYo1hbqifwf4uR4jD5h1QZdVzEP+RN2OWL6M2lLWpIgV05UlsYvC0mgg?=
 =?us-ascii?Q?KFQZXybaPOZ3yamdRK4rET+mUpNRrwXolktFoO7PbXKhttP97CtvyPD1kBp3?=
 =?us-ascii?Q?F0NeEmyKn4XZxs2ysF0if1NMM2F9ixz30h3ZQGKkM+xKW3y+aG3Nnnur1rG2?=
 =?us-ascii?Q?L4apNsxJyFBS7Kdx0Y2DzWofNHPjnPqHAd6pxvT+1HD/DBzHxkjcgBjdbB3V?=
 =?us-ascii?Q?WObshqVPKVWRXgi0B/hcOF9Me/Xbv9szGvaPMCVhKkduMS39Mfa3IrqV3/4u?=
 =?us-ascii?Q?gRm4M8XjPQKBFPxqNYcbF99mXcpwioJdOrMZerDOX6O9GJUCfO1Ju8Gld8k+?=
 =?us-ascii?Q?A2bEBQGxbQ9y/ixKWww8A/ZBBTEek9fXUzEJ84tVK7m5n6u7CwcboVRKWUn2?=
 =?us-ascii?Q?Ju/lH0jIA2z5nyIFFW3spwphOcPVQhcF5h2enwmSK8MforqToRdMXcuP/Usp?=
 =?us-ascii?Q?YbI8Y11zgLeRiXubXhprYs5WrSTqIvHIATzIKckiWHI+2+6rl4UzvqOYTn4s?=
 =?us-ascii?Q?ZyDgj4GVTv4zsD7yweRmP5kATHKVyRPvwPkp+b/M5K6u/Bpz0Eda94k8FCog?=
 =?us-ascii?Q?WZzdkABHlfvOd9iXqyeKwSbQ9Pd6Yx2SiKSttfa4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be8f96e2-e20a-4720-57a4-08db44aeb98b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 10:29:03.0727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vQbKOcYlNjninmW5Lh/Y3tisIAkfqQDAhs1unRJuBNmuZXoT+PYRHc5D1RSquKk7iws09bMMmCizlbO8gFR3Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR18MB5316
X-Proofpoint-ORIG-GUID: e9OWYF6khUfLUTOBe5rggORIKmAse2FY
X-Proofpoint-GUID: e9OWYF6khUfLUTOBe5rggORIKmAse2FY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-24_06,2023-04-21_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

>-----Original Message-----
>From: Leon Romanovsky <leon@kernel.org>
>Sent: Sunday, April 23, 2023 10:22 PM
>To: Geethasowjanya Akula <gakula@marvell.com>
>Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kuba@kernel.org;
>davem@davemloft.net; edumazet@google.com; pabeni@redhat.com;
>richardcochran@gmail.com; Sunil Kovvuri Goutham
><sgoutham@marvell.com>; Subbaraya Sundeep Bhatta
><sbhatta@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>
>Subject: [EXT] Re: [net PATCH 5/9] octeontx2-pf: mcs: Fix NULL pointer
>dereferences
>
>On Sun, Apr 23, 2023 at 03:24:50PM +0530, Geetha sowjanya wrote:
>> From: Subbaraya Sundeep <sbhatta@marvell.com>
>>
>> When system is rebooted after creating macsec interface below NULL
>> pointer dereference crashes occurred. This patch fixes those crashes.
>>
>> [ 3324.406942] Unable to handle kernel NULL pointer dereference at
>> virtual address 0000000000000000 [ 3324.415726] Mem abort info:
>> [ 3324.418510]   ESR =3D 0x96000006
>> [ 3324.421557]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
>> [ 3324.426865]   SET =3D 0, FnV =3D 0
>> [ 3324.429913]   EA =3D 0, S1PTW =3D 0
>> [ 3324.433047] Data abort info:
>> [ 3324.435921]   ISV =3D 0, ISS =3D 0x00000006
>> [ 3324.439748]   CM =3D 0, WnR =3D 0
>> ....
>> [ 3324.575915] Call trace:
>> [ 3324.578353]  cn10k_mdo_del_secy+0x24/0x180 [ 3324.582440]
>> macsec_common_dellink+0xec/0x120 [ 3324.586788]
>> macsec_notify+0x17c/0x1c0 [ 3324.590529]
>> raw_notifier_call_chain+0x50/0x70 [ 3324.594965]
>> call_netdevice_notifiers_info+0x34/0x7c
>> [ 3324.599921]  rollback_registered_many+0x354/0x5bc
>> [ 3324.604616]  unregister_netdevice_queue+0x88/0x10c
>> [ 3324.609399]  unregister_netdev+0x20/0x30 [ 3324.613313]
>> otx2_remove+0x8c/0x310 [ 3324.616794]  pci_device_shutdown+0x30/0x70
>[
>> 3324.620882]  device_shutdown+0x11c/0x204
>>
>> [  966.664930] Unable to handle kernel NULL pointer dereference at
>> virtual address 0000000000000000 [  966.673712] Mem abort info:
>> [  966.676497]   ESR =3D 0x96000006
>> [  966.679543]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
>> [  966.684848]   SET =3D 0, FnV =3D 0
>> [  966.687895]   EA =3D 0, S1PTW =3D 0
>> [  966.691028] Data abort info:
>> [  966.693900]   ISV =3D 0, ISS =3D 0x00000006
>> [  966.697729]   CM =3D 0, WnR =3D 0
>> ....
>> [  966.833467] Call trace:
>> [  966.835904]  cn10k_mdo_stop+0x20/0xa0 [  966.839557]
>> macsec_dev_stop+0xe8/0x11c [  966.843384]
>__dev_close_many+0xbc/0x140
>> [  966.847298]  dev_close_many+0x84/0x120 [  966.851039]
>> rollback_registered_many+0x114/0x5bc
>> [  966.855735]  unregister_netdevice_many.part.0+0x14/0xa0
>> [  966.860952]  unregister_netdevice_many+0x18/0x24
>> [  966.865560]  macsec_notify+0x1ac/0x1c0 [  966.869303]
>> raw_notifier_call_chain+0x50/0x70 [  966.873738]
>> call_netdevice_notifiers_info+0x34/0x7c
>> [  966.878694]  rollback_registered_many+0x354/0x5bc
>> [  966.883390]  unregister_netdevice_queue+0x88/0x10c
>> [  966.888173]  unregister_netdev+0x20/0x30 [  966.892090]
>> otx2_remove+0x8c/0x310 [  966.895571]  pci_device_shutdown+0x30/0x70 [
>> 966.899660]  device_shutdown+0x11c/0x204 [  966.903574]
>> __do_sys_reboot+0x208/0x290 [  966.907487]
>> __arm64_sys_reboot+0x20/0x30 [  966.911489]
>> el0_svc_handler+0x80/0x1c0 [  966.915316]  el0_svc+0x8/0x180 [
>> 966.918362] Code: f9400000 f9400a64 91220014 f94b3403 (f9400060) [
>> 966.924448] ---[ end trace 341778e799c3d8d7 ]---
>>
>> Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware
>> offloading")
>> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
>> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
>> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
>> ---
>>  drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
>> b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
>> index 9ec5f38d38a8..5f4402f7b03e 100644
>> --- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
>> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
>> @@ -1065,6 +1065,9 @@ static int cn10k_mdo_stop(struct macsec_context
>*ctx)
>>  	struct cn10k_mcs_txsc *txsc;
>>  	int err;
>>
>> +	if (!cfg)
>> +		return 0;
>> +
>>  	txsc =3D cn10k_mcs_get_txsc(cfg, ctx->secy);
>>  	if (!txsc)
>>  		return -ENOENT;
>> @@ -1146,6 +1149,9 @@ static int cn10k_mdo_del_secy(struct
>macsec_context *ctx)
>>  	struct cn10k_mcs_cfg *cfg =3D pfvf->macsec_cfg;
>>  	struct cn10k_mcs_txsc *txsc;
>>
>> +	if (!cfg)
>> +		return 0;
>
>How did you get call to .mdo_del_secy if you didn't add any secy?
>
>Thanks
>
It is because of the order of teardown in otx2_remove:
        cn10k_mcs_free(pf);
        unregister_netdev(netdev);

cn10k_mcs_free free the resources and makes cfg as NULL.
Later unregister_netdev calls mdo_del_secy and finds cfg as NULL.
Thanks for the review I will change the order and submit next version.

Sundeep

>> +
>>  	txsc =3D cn10k_mcs_get_txsc(cfg, ctx->secy);
>>  	if (!txsc)
>>  		return -ENOENT;
>> --
>> 2.25.1
>>
