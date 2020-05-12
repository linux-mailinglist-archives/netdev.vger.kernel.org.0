Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77791CF7D7
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbgELOuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:50:46 -0400
Received: from mail-vi1eur05on2123.outbound.protection.outlook.com ([40.107.21.123]:55009
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725929AbgELOup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 10:50:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBKyIXXlmVNkLoUHksCCuuUVnU/PIbWsMD5+0LtN+fNIBgOe5HiXOxNk61HLkQdQfgjlX+rkmFLne9Z3Mm8gKR/S//R0MpiwwYXPm4tOuCc0ATPdSueioS7MJkpur2F1yxGIa/WV1jIUtPGu1veSKclbumnkLWFHnmYH9nDnr+E8Z3Fnjw+m9Rse+NXTMMTbfwwkBfRqCpHD7CHaKIF3E0nCNXYhnuBVpo485lypLUC3kfinGlwIBZWdqohjSo/Cov5qoVdfYgEb8whuIpfl3TuyX3nnMzcd3YJUO8efLHBjHPXoneJuOgausUzjg5rQXV/xubbv0svBosZftibDuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NA9SmOGeSAnMBsLcKkiIwuEWwYnKoZdAto0znQo195A=;
 b=dLB+J/wVywdggWQvNtYXwlORXzrBbkbvGV/VG+kHU4J1fIFO9A9zUUke8dwdExmdYe++oCowJBCK5e0YyvjeZ9P8x0B3GDMqX48r2c43IFklkUKaMn3pPYsfKfH5Z+WhenthWAitGtxWnNT4FGxMfwxG3UvXCo8Biv53w+LuICS7s+bIqIJfIdTi5Xr2rguorM7QbIl+DH60vPLeUKafXQN2yQxFkTXB6KASWu6F1OCKrq7gi62R6e2oBgMNojF9JsDM4Vnwx8+GFI6nei6v7JjUS0S3CBKc8jJoQwkewqNSu1oBxmXKgySdI1ZVZMSaJc6CEm5nvvGCJzz+uR1GEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NA9SmOGeSAnMBsLcKkiIwuEWwYnKoZdAto0znQo195A=;
 b=kpMK3Yu7GwcXNqIcxv2PdFpJK2P1RDNnHNXy8tF+/ZUxENdpz87CavC6Zrm6S8kVOVEjKJAC3Cfd8By8lnpRk/X5HjSKZYCq+xGHnywqzlxRkANSS4H7TkuElroYgWe+JMSNEffRLSq49dQW54d2Yx7dicdoGIROsN0OuTP7ijI=
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0047.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Tue, 12 May
 2020 14:50:41 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 14:50:41 +0000
Date:   Tue, 12 May 2020 17:50:37 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 1/5] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200512145037.GB31516@plvision.eu>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511125723.GI2245@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511125723.GI2245@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6PR10CA0034.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:89::47) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6PR10CA0034.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Tue, 12 May 2020 14:50:39 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82f8e87d-c09a-40ae-4076-08d7f683d754
X-MS-TrafficTypeDiagnostic: VI1P190MB0047:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB00474EA862D1444FC35BBE7D95BE0@VI1P190MB0047.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6a0pRVomI/6uw+6g285LUGIAQTTrL1kwlvzeh3cYjdfYrkuX1EygekehYpewOxSX6OYwd41O96yGOw0WgIRHdo14DiWxslYK0tBkRAU4yScSx9MjxtXnj58iIZ/RVMEXmtpKnXmQUqBovTbNHvBjl40iXgmZst+hepyZryu7qkRdhXKYftPkG9rhLrU/uEZ37XJT+gq5fN5j1K7RPUG1liDS3FxZJWwNWwt0bRcOIado8ZyRczUWUuxK1xTaWIIkglXJj47f+9K4Uiwmxz1rmL7rAs1/LFQqsO0mynvdHWlCTVKKKankoMIkGfWDPfRx7WwAuPd7VOejhFYZSfWn/LFRclosKvpnhjjPhASQEZCDj9TioPEDGPFIPYUkBorkrTt0WUeDVP02kJ6Yoq1kpSiDAM+tM4cQmv46F6/nP3gGVdMWu2lbkWO6sbSM5lfdnj03ms7vMaDfWh2uJSDj4ZNvekIcoPOvPnEufdu15PPmb1h67UJyA8zo0kK02Sg/Sc7PjlIMPX9jPVzt7rLSEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(39830400003)(376002)(366004)(136003)(33430700001)(66946007)(66556008)(508600001)(8886007)(6916009)(33440700001)(2906002)(4326008)(86362001)(54906003)(66476007)(16526019)(956004)(5660300002)(52116002)(2616005)(186003)(316002)(8936002)(7696005)(36756003)(55016002)(8676002)(1076003)(44832011)(33656002)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +gmjBoo0vtyScnH9nvwiTU4NMKzy5mcqABEvE8ujowTw6MBsNkwQII8UldanbXA91TjZ2c3aKSgxDN88PAEMuweU28FIkhH5l2Orga6vOr6pWXBahGV5cvuI3/Fh0aJ5k4oSM87Xmt4foGUVwu/yHeTHGJk/NBj7e621S292+ZrB9vip/WKhcPRqmgCn2nMONHgFi5+8+KnCmc82cq8UeFPYCndngdE/FCTPb3xhTrre8sjjvC7rZa38dzzt4kVK04GcHgaULqKFBikK7x8JxViFsYLU1NqogRcT8adF8TFFS9DRBXzrXgU+FxgIdYlT3/QwMd4ChcMdtd89kM+o1nW2kF4goft7zarOGGzkb/gZgNqbJ64dTQ5n6zHN+lS6RIqFK6J9BekOeNdWWqtL/19xW/8ih8FeIMUc6sNk+FIi8f8/5kVUsJloLtFsL8bV+1tWzkCXovDg5Msa8lUdzyU+teurCsSF5VnQvx9C8OE=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f8e87d-c09a-40ae-4076-08d7f683d754
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 14:50:41.2044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UQ/mlvR73aryKSMn8Pqp+N1JRAkjxRJsUjhrZKsgqd78viwy4R8y9AIwijXbCIY4C8RYRjO/W0AN8udfXT6uGouj+pmFsIZ/PmoEhv12aQc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0047
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 02:57:23PM +0200, Jiri Pirko wrote:
> [...]
> 

> >+netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb)
> 
> Why this has "rx" in the name??
This is just a following of a module prefix which is prestera_rxtx_,
do you think it is better to avoid using of "rx" in "xmit" func ?)

> 
> 
> >+{
> >+	struct prestera_dsa dsa;
> >+
> >+	dsa.hw_dev_num = port->dev_id;
> >+	dsa.port_num = port->hw_id;
> >+
> >+	if (skb_cow_head(skb, PRESTERA_DSA_HLEN) < 0)
> >+		return NET_XMIT_DROP;
> >+
> >+	skb_push(skb, PRESTERA_DSA_HLEN);
> >+	memmove(skb->data, skb->data + PRESTERA_DSA_HLEN, 2 * ETH_ALEN);
> >+
> >+	if (prestera_dsa_build(&dsa, skb->data + 2 * ETH_ALEN) != 0)
> >+		return NET_XMIT_DROP;
> >+
> >+	return prestera_sdma_xmit(&port->sw->rxtx->sdma, skb);
> >+}
> >diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
> >new file mode 100644
> >index 000000000000..bbbadfa5accf
> >--- /dev/null
> >+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
> >@@ -0,0 +1,21 @@
> >+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> >+ *
> >+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
> >+ *
> >+ */
> >+
> >+#ifndef _PRESTERA_RXTX_H_
> >+#define _PRESTERA_RXTX_H_
> >+
> >+#include <linux/netdevice.h>
> >+
> >+#include "prestera.h"
> >+
> >+int prestera_rxtx_switch_init(struct prestera_switch *sw);
> >+void prestera_rxtx_switch_fini(struct prestera_switch *sw);
> >+
> >+int prestera_rxtx_port_init(struct prestera_port *port);
> >+
> >+netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb);
> >+
> >+#endif /* _PRESTERA_RXTX_H_ */
> >-- 
> >2.17.1
> >
