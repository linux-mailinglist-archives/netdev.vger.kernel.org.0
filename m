Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9001ED400
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 18:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgFCQMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 12:12:51 -0400
Received: from mail-am6eur05on2047.outbound.protection.outlook.com ([40.107.22.47]:2529
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725834AbgFCQMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 12:12:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBYNnJb5IIs329ZvCEhDIPUJU4ky3MPOkaosGZGucMOeDqOuJC0QvhC+eP2WdLp+lFzur0+RxDzTmH9V233DcD+WnKGbqx3YyDgQu3lzc+pAR58N3jZeG5MLvX4KKF4Zj8q5bKB+U4F9lvebbm+mxJI5kEl3CVgETtnurEYU85xZ9XQtQcc4IJnXsIpqsuQrQLgs3Nlptopwlk0YQPzeuoTnPSIkwS6xbQpuX6VX93uHkVX0KkciUiICZgiE4c+QXV8aTldkROWZtG8+L9qnLKKgJgJcHqF2AA4yPf8mb86+L3t67clYH6P6deAyCbLPlbp0yO80MpwhwBQGgsCY/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GgNiBPhxRktFwyhi+zTOPiGdIjAqDXq3PGXGcxWLaDE=;
 b=I9+Gs8uFs5eZbN38QesdfJC1rz8+2QbaxoJi43Eo+5KiIxrC89mJMgeTQ1dQINV+Vrg7ljjWWgle2c7+tg11WO7F4UR7BoqHWlVMA0ynWOy6ZPm4UtEFhRrFC9TF0xQJtdwZVfDAjj9QCm+CCNicGqtVqHBs6GszquaH0r9Xn7uws2B5xjGF8Wt5coSw+iPvmjFKqLmBGWX0JrtasHq/gOOljHCWf05eJ2006AWmN1VPCKNg0+y6jMHyL2Xs21XRdOfUAExAS2fDgO4Y9mHyisJ4fW97YXVIFRsgZ0bwfu1xNio6IzHmJv2o2V87tSeT7hL+qlR4OUBmB3EtDIVd0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GgNiBPhxRktFwyhi+zTOPiGdIjAqDXq3PGXGcxWLaDE=;
 b=XWu9orLTS3RGRyViPwyWFLJLDbZAw/GCUnDNh4nxQ9tkg9roR2JxAgAMjRE6krHs8H7vdQoRqxX8qARUmA9LxBLRrEe6ejmIqacw3mkAswpIoAZ2IodTVO9NFHPPfM0IoPcsnVp7xDOlfVmPo8go8urILJB+45UgtlbSb6TiT0o=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=orolia.com;
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com (2603:10a6:802:69::28)
 by VI1PR06MB4397.eurprd06.prod.outlook.com (2603:10a6:803:52::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Wed, 3 Jun
 2020 16:12:46 +0000
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c]) by VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c%4]) with mapi id 15.20.3045.024; Wed, 3 Jun 2020
 16:12:46 +0000
Date:   Wed, 3 Jun 2020 18:12:37 +0200
From:   Olivier Dautricourt <olivier.dautricourt@orolia.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] net: stmmac: Support coarse mode through ioctl
Message-ID: <20200603161237.GA26729@orolia.com>
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
 <20200514102808.31163-4-olivier.dautricourt@orolia.com>
 <20200527035509.GA18483@localhost>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200527035509.GA18483@localhost>
X-ClientProxiedBy: AM0PR04CA0054.eurprd04.prod.outlook.com
 (2603:10a6:208:1::31) To VI1PR06MB3919.eurprd06.prod.outlook.com
 (2603:10a6:802:69::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from orolia.com (2a01:e35:1390:8ba0:9022:c6c:b638:21f8) by AM0PR04CA0054.eurprd04.prod.outlook.com (2603:10a6:208:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Wed, 3 Jun 2020 16:12:44 +0000
X-Originating-IP: [2a01:e35:1390:8ba0:9022:c6c:b638:21f8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1bcf5fa-ce5e-45cd-1321-08d807d8f3a0
X-MS-TrafficTypeDiagnostic: VI1PR06MB4397:
X-Microsoft-Antispam-PRVS: <VI1PR06MB439798BB85C3EEEB22AD8ABA8F880@VI1PR06MB4397.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04238CD941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dIR7QYalNEFgCJHvI9RiH7IHrS8vw9kYHxV0QO3R4sknYzxI8eBkBC1Js9z0QsuWlbMmSl+0Ot7OLDOmv9QItd2A0r13S12BZBufpFCEQPCGQWtMstNnhWsftmoedxntF3STWWdRPqwlpQd4yBFtqq+o1UG7EWf/2CI4Htm3BEP4oAOV5/tQ2jUB/8Vg5IkaUF1DRPNT/B5zuV9/JCUzIsP3PUed/8uYZqNeJyKuDJ676zcFiYNOnovl2yyorKmpV86seeK+3IdATUYnrj2HcPlXTHiMRKa8pd72nOSjH02gwTagl2VYvt14qGzcqSYKV7W0kwoAgBSTTgmQO+UV2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB3919.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(136003)(346002)(396003)(366004)(376002)(66556008)(316002)(54906003)(66946007)(4326008)(6916009)(8676002)(4744005)(1076003)(52116002)(478600001)(7696005)(8936002)(16526019)(66476007)(55016002)(186003)(2616005)(6666004)(86362001)(2906002)(83380400001)(36756003)(5660300002)(33656002)(8886007)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: q9DbIq6WhrHMZg7bUGzjvldA/PEz7pSnGLfGcjwvXuJ+Y/67Y20jA9PJG/bPnaqD9KmLWcns+v8+1TbMyMj2f7Y85Xmy7igTpQORiZKJddvGxBFgESdln/Zf3EptuiKdnxvbF0nVMNC++CkqYgjJjAmZeP4Gy1uvI7m5bZZqvh56CeOlDHtRgvuF5BDOnns+esE8WCol2YEHppD7ZvcmNTLziln6uYD8/ZeVRrz7TplqAgSKiu9qe3LEyT0RvBhax/zpkM11ykrfh6S2W/B1jqNV3XfzY9bTMxhvYomx+5xK32qlfWRt1b7KLH0jhu3ISzgARsJt2u+7laKKVn59WE+Fpqg4cHErT6TWwf2q0MEv/yVCtX2vsb2QtP/Id5baxlDuSNbUgRueNxLFOU8uUN6CXy9VZnp7Pkj0N/y0ESkNBU3nnkGGYLL2PqO0G3JpHGTxW69pm2AWkw7V70LymO4LZWH0wmeGCAXNhdcSBUiGp9A+Zvjkq8sujmv8SajjZZhOrWcsBKrCERd6oB8dQ85wdtsmveJ79Ck4PlVfDBk=
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1bcf5fa-ce5e-45cd-1321-08d807d8f3a0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2020 16:12:45.8807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSqroQHItwYKHZjaK6//c9j+r+IJUMADuRB4mlYLjDGWZm+coRHEFG7EY9dPsXLIOvihyxOacjaJ6ijze7wwmz/bt99ik+/l7ClNKa54t+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB4397
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 05/26/2020 20:55, Richard Cochran wrote:
> On Thu, May 14, 2020 at 12:28:08PM +0200, Olivier Dautricourt wrote:
> > The required time adjustment is written in the Timestamp Update registers
> > while the Sub-second increment register is programmed with the period
> > of the clock, which is the precision of our correction.
> 
> I don't see in this patch where the "required time adjustment is
> written in the Timestamp Update registers".
> 
> What am I missing?
> 
> Thanks,
> Richard

This routine already exists in the driver (adjust_systime function).
This one is called on ADJ_SETOFFSET in both functionning modes.
So in both modes the phase jump is done by setting the target time in those
update registers, set a flag and waiting for this flag to be cleared, that
would mean that the correction is effective.


Regards,
-- 
Olivier Dautricourt

