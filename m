Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7BE2627178
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 19:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbiKMSIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 13:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbiKMSIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 13:08:11 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F101144F;
        Sun, 13 Nov 2022 10:08:05 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ADHqguP001617;
        Sun, 13 Nov 2022 10:07:48 -0800
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3ku48gr5yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Nov 2022 10:07:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvLEdqEavpWJj4lTS4O3M7TUuK9iod1C9FZCTA2Do1OgBZz5x68qpx9U0KdoTI5oObkZ/E1mN0N+wNFcyrhutk6CzWARR+2sY/kdU76cXqRtonoGVTzJI0ggh8PbMJgi3huMAzlpcHkRgevL8qWo9GKf3RdxcB0FVVPBHiaVQWNIFfhTGbEaBHyDbky9OIOr9foVM3z7cn0ug0rBCFfjzT6cBSvv2tNZVp5l6MS8f9GvrVfLMder5CF+K8V/qT0E4soM1w3zz9JKOy1+/lpaitm6mtvDFdZAr9a8vZoREtBB+PHSF+sS0Opf0E+vgBZSn7STlrG/PidotJeCQ/9tOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NymZBib0qTd/8nzVsWqhbAChqZEiHvYAd1gunLJkZNc=;
 b=FCPRcANYHDPBI6KXmVjEqU5ReQdsmq0UaEt4g6KUtJWVlBeKT7B1/d6CVYkH5sj8KV0e1Ef5b9CVlRObXNge/2gNoLRZ/Euo/x/7Xc+eQrkpSKw7b6rV7xyAhFmQ67sKzXhtcf+wn0wvJUld+k34GKo19rslks5dZ61+HENEhkFHlmy45SopHUdACMTktADg0AP0BtQkfKTa+RrnLam0tkir1BuQlNzwhMgJQQAtsKfiZLvBwBmr8izZh4Ufb68inlKYN/Nq/dcRbMy9/SmhiFXBwY/Nx86An1URVx6OTxILYMjChrEYBNKnSpMkmyZLYHHsUdyoFDEY4wdUABVcCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NymZBib0qTd/8nzVsWqhbAChqZEiHvYAd1gunLJkZNc=;
 b=Wc3++EMcI2S9fn0MyYuNmyYBWzuCb1pAA1GM0USMjNwbJsLf0e0eRjfSbAPHZ3x5ebZEchbwLdBrB3NEBxJon62Yt4IqjWLC8PzRt4otTcMl5aohJ4o3djSoLAqqdQnFPVo1fGsQL9zWZS49Oi29v/rRMb2WDkdlwg8GSc8Tpno=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by CO1PR18MB4617.namprd18.prod.outlook.com (2603:10b6:303:e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Sun, 13 Nov
 2022 18:07:44 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::c182:14c1:71c3:a28f]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::c182:14c1:71c3:a28f%9]) with mapi id 15.20.5813.017; Sun, 13 Nov 2022
 18:07:44 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [net-next PATCH 0/9] CN10KB MAC block support
Thread-Topic: [net-next PATCH 0/9] CN10KB MAC block support
Thread-Index: AQHY94rTbLKBlT52k0irVb2RSNQ5hA==
Date:   Sun, 13 Nov 2022 18:07:44 +0000
Message-ID: <PH0PR18MB4474E9CFE1E1FBF8EAF71817DE029@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20221112043141.13291-1-hkelam@marvell.com>
 <20221111211235.2e8f03c0@kernel.org> <Y2/nhhi2jGUSk7L/@lunn.ch>
In-Reply-To: <Y2/nhhi2jGUSk7L/@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctMGYzNjNlNWQtNjM3ZS0xMWVkLWI2YmUtZDQzYjA0?=
 =?us-ascii?Q?N2UyYmEwXGFtZS10ZXN0XDBmMzYzZTVmLTYzN2UtMTFlZC1iNmJlLWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmJhMGJvZHkudHh0IiBzej0iMTY1OSIgdD0iMTMzMTI4MzY0NjAwOTI1?=
 =?us-ascii?Q?Mzc0IiBoPSJUNjdsdzJMalhQdUNDQVVuWVpyN2RwaW9BVnM9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFQNEZBQUMr?=
 =?us-ascii?Q?SEpIUml2ZllBWXFLeCtpNkxDNytpb3JINkxvc0x2NEpBQUFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBYlFCaEFISUFkZ0JsQUd3?=
 =?us-ascii?Q?QWJBQmZBSFFBWlFCeUFHMEFhUUJ1QUhVQWN3QUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|CO1PR18MB4617:EE_
x-ms-office365-filtering-correlation-id: 8e73febf-082f-46de-c3bd-08dac5a1f677
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PvLGOZdHVcrVsoL6FrQUvrmYIgLQYFh2Ie30L47GT8EuRd/NtSZOJdr5FVNZcbqyB1U6RVBT9Xtuspp/qdeqNFrWTinZOWOObLjq44SK7B9Vcj7AzPZ0f5gcpoN+U8279wT5AXV8MJasOQ63oGtUeoRnB1VkgLIsadQO1CQeDEFdq4nKeXLs420slokw1isf5oiiJU3psei2+n3tDTVpM4pnuwrtM9a5hyLzqUmQAdzf/L6sM+qt45/FPJu6UYc4auyMygOSlcQeCGMno6NozOoed1FHTpBJWxXoxGoJa8zyHGAzibyYfhJc2YB7TAvDJbIjLNLV8nKCkJvasU87Du1xg2G8KxP1Ord17pz6tzjDvdZKbfuB0JgYvHI5lZL/96LEn9P6a1APD6+HS2OeE0vK7FoGPuCosDYSUutwbg1de2s5BdxXjIIGBMgqtxH0yKEGhL/lN3aNcb+FMwFrW4zZr5M1r1yHGS+q0wEan4ALlM3pdpCx1g8b6cAUFl9cYVezmY0FEhC2fbCYee55xXHlR2puZjQBAb1WkLXc4yLYqTP38AbZ0fJTNZJa+sMoU2ADSdqxUR+67XQs8Pzi2EwsrkaeScdRM6rlV2LPOJT+rFqiZdTqOJTvc7Zbp9/TXpoEyAZSFucMPPOH+O2oUvkg/KtHZyolG8EHP7lwR6/W52uw7Ld8gHhjO24zPNDbvquZfQ6fq8Dw5W0zKqkpWaDB0byEbb9OGGr+/zZ/etP8HzHKe1aeJhAacNdasBKk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(39850400004)(136003)(396003)(451199015)(110136005)(107886003)(7696005)(9686003)(6506007)(64756008)(316002)(54906003)(26005)(76116006)(66946007)(66556008)(66476007)(66446008)(71200400001)(478600001)(5660300002)(8936002)(8676002)(4326008)(52536014)(41300700001)(186003)(2906002)(83380400001)(38100700002)(38070700005)(86362001)(55016003)(33656002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BpSTuxv2UzEHGK2u0IwAPmnBGmO8LMRg3u48Ujllvb9sDrdzHPKYRX5ADKs0?=
 =?us-ascii?Q?2pUa4LXZJiMzAjf39TuP3Cf303vtnCXuBcBXhsCBdHfMvFhIyuoJlpm87LAV?=
 =?us-ascii?Q?OIWR7sPR64fOHMExsQyJFRBumtRV5ruk/Zv9zmvLCjOEHT36umLw9qufNh3l?=
 =?us-ascii?Q?tPJvWd93JdNdNqfIQZe4YK0lnVe4UIAWeVkyvw84SRcpYrTMrgSQarAogrO8?=
 =?us-ascii?Q?iFQkyXX1plh9dkyEpP2PVPhO0A9/t04MP4pPKSQhXgw/971vg7oa0OS6eMcA?=
 =?us-ascii?Q?80FhWuZmwUUFrZigXb+c3Bi9vjWeZ4TkPNqL+04Hq7czuo6QSQJhvdjAZrOG?=
 =?us-ascii?Q?KQLYcaw4UQv8lDGwI9HD1ugje+bO3U7Pf5zcdMK8hV0bbSY7LTLWQc24JfZn?=
 =?us-ascii?Q?MbFfPMSl0LjeE6QVMfQOqSx2FATJq/t8UBp4s1gBkCKBm8ijOkegllGTxRIq?=
 =?us-ascii?Q?r51DI8skpOQRdCBiOypr4x50xrdtAO+N0b2Ca086QGwf36gvcVofBJaEObaW?=
 =?us-ascii?Q?KFGA8r/wUZdr3zmXZTxOq/vs1fK8RXU80sPIxxCaO+cu4kr+al17HnAhDi+u?=
 =?us-ascii?Q?qt6nz0c1bTLbAkzu3/df2Pp1kcnNNlCp8+sPYih6BnMJMPkfpXIN4Lsqjg3r?=
 =?us-ascii?Q?cMme/O+tDYTTe3KDa4j7UPHYlPr6ghS7Qlt3yua7+OZdKOzlAQZcHNXdjp72?=
 =?us-ascii?Q?Hvllhoel/5iOvLCOrDTa0O+MigRjTJNXvBH7Hq/kwuKzKb3NQLfAqx0mh7sr?=
 =?us-ascii?Q?bo+7RD4Us8GhKqWFAoP+nNXutop+kA9p+U4R+T9Ib2OMqDOy6T13K+rwYGke?=
 =?us-ascii?Q?DvNKPvEygwh341xUiuvOVardskIxMNKCxEA1MPRBtbIDAgy8Zw4FeJ30a22I?=
 =?us-ascii?Q?m+GBtWkH/8ohxTZUUtkzaQH9qFfQ1dNUFiG1RnDRoPtqm9LebTTycfZ8mxBM?=
 =?us-ascii?Q?Dij74OOmGKtxacycvuh4vF5sgaYdAmcI/jqBH48wme+1ynUOvLTdMqxEo+gh?=
 =?us-ascii?Q?lUwguoZT9qIPcMaukqvxwSZN2YFHyWe4ECPiRjsh2iJbq2twihwp3aIFvjyS?=
 =?us-ascii?Q?HxodLIymDAVaqXL1vhxbM3QqZyxmtZQJpgemUZolmm3BKa37Spi7pr2j/zLF?=
 =?us-ascii?Q?TPoCMmuQH9hjmXJIAhoNC8qurAF9VI7HWJ4Y12cL9pqtwA8LNRsDDrmf+QnT?=
 =?us-ascii?Q?LKAWUkgh6jrqpOSppM3odiLzR3TEh25RUstoYgZ6zVZrUgY9QmC1gS6KSZJ0?=
 =?us-ascii?Q?9UcVKp9LTOh3JbXKjWDdLEWlmGmin21taDcYV8uUYS+etE0oz9S+ZU/ULsj1?=
 =?us-ascii?Q?6bjD+Cuk8OuHtBkTDeOhEmW7F/O24OAxwgKB+9uWvl8aMUjHG9p5NPl9ud0i?=
 =?us-ascii?Q?jxAuSrzgLd63O1Q+B/SHKWmzGGAJGGvuyQKF/lVYvNdayMGg6gAcaAR2JaZH?=
 =?us-ascii?Q?Je9JburTbyZOi84JALEfwBi9PINkA8W7jFCouLq8hRnGTLjFxAel30IjGDpm?=
 =?us-ascii?Q?9LiHcPQ4UpY2JemYik+bGRRc2Uh/cSNPX9iZ9Ry4KVMAuq9Ce6LB8Jmixjqd?=
 =?us-ascii?Q?NlmwWNdLwdNYYvcoeRg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e73febf-082f-46de-c3bd-08dac5a1f677
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2022 18:07:44.1484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ZYega6DwmCf/TbONyz+2wm2hxkMSrD4vQqjUKsoxmmWHOGUJeDWx1aSbbf/IMJNirtGjVqiVwYZGUdN2e0KrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4617
X-Proofpoint-GUID: njA3zQrfqTvxzfpYpaoaT1AXVf7s3GD-
X-Proofpoint-ORIG-GUID: njA3zQrfqTvxzfpYpaoaT1AXVf7s3GD-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-13_12,2022-11-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Fri, Nov 11, 2022 at 09:12:35PM -0800, Jakub Kicinski wrote:
> On Sat, 12 Nov 2022 10:01:32 +0530 Hariprasad Kelam wrote:
> > The nextgen silicon CN10KB supports new MAC block RPM2 and has a=20
> > variable number of LMACS. This series of patches defines new mac_ops=20
> > and configures csrs specific to new MAC.
> >=20
> > Defines new mailbox support to Reset LMAC stats, read FEC stats and=20
> > set Physical state such that PF netdev can use mailbox support to=20
> > use the features.
> >=20
> > Extends debugfs support for MAC block to show dropped packets by=20
> > DMAC filters and show FEC stats
>=20
> I personally see no reason for us to keep merging your AF patches.
> Upstream is for working together and there is no synergy between your=20
> code, other drivers and the user APIs we build. Why not just keep it=20
> out of tree?

Yes, see my comment about the ethtool .get_fec_stats. Maybe it is there, hi=
dden amongst all the code, but it is not obvious.

If you do want to stay in tree, may i suggest you move all your statistics =
in your debugfs to official kernel APIs, and then remove them from debugfs.=
 This might require you work with the community to extend the current APIs,=
 which is the synergy thing Jakub is taking about.

	Andrew


This patch series adds two debugfs entries, one for FEC stats and other to =
show "Dropped packets by DMAC filters".

For FEC stats will remove debugfs entry and integrate to ethtool API in the=
 next version.

For  "Dropped packets by DMAC filters" did not find any equivalent APIs, so=
 will keep it as is.
