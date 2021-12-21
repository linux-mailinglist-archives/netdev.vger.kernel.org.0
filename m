Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC1147B92C
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 05:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhLUE2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 23:28:48 -0500
Received: from mail-eopbgr30096.outbound.protection.outlook.com ([40.107.3.96]:18239
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231983AbhLUE2r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 23:28:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9B8BbtOMMCWgl07bkB+LL9xEmzNM63dCIBJvJXprk7tUPCLJCnTWdrEgnZI9OiQzSFB1w+YWlCQrV823KXt0QnupvtBASzC5ITksmW8ZtkcG2x52+cw2qHxUuQRRsZL0n1FkZ7LASxmSXkp0NK+6v3wxy7q9hgEn30ApdDft33rZ8plaYH6iwVkf59BAI84lu8IY8buoNwAV842n6smiJhnEAPgKX7oFeaBn8P4nZatbp2mGJiinwGEt43Y5yt/Wxrjq2GBSwci8rhr1j8N6ou6EgTQNELeJknsm0SjXmoYoASzHhHUZU1mgCeIrfoVSLOXUxwqXTv91QC01Rul4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yvvmlDJoJp06RvIUxasxibRagO5yDg5zdOrh9jvJAFw=;
 b=kH9lfVOSoXz42d8N5xDZT3WlNIFSk+ow2LGm65/NMKGpzRSsxkXOblnf7FDpVuL30ThaP1xSo3qWeo869exQQREq4slMZjnV9eXSHyjU1QJR6Nw8r3R8KE3jRhclP1bXNibOp22QlJ9xzQ7QRELWJ2YPODGMJo36F5aRh0zoF1U/DZJ2rlKgZXhTOR15Fw5HKn2kQgbl4cw0d5KN1KqLoBwg/mb18ddZlsSiNE78iZEiWTOik5xRT6HJnMpNy7D3uWgb4Xw2PoSc0TF347eip72DDcugfXda2udcwPt2jX0ylZfgVOmUqPFMAyAqu0c1KVXFMvcS1kZrn/w7eN4Ckg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvvmlDJoJp06RvIUxasxibRagO5yDg5zdOrh9jvJAFw=;
 b=CbPC2R72VQgStweOooMIcmGgM36BHa+7yLLtHIjRgOcpYrYFFk8kpunnHW8qwz7ONpdzW+SM1mKrA8LBwCik6M8OOdoYbqUbbjGGLma3hLiXQbznCDEG0v/2SP8HLi4ZB8KEFbLKS6RZZI+jmFA+1WYCFV/bbc34p3zQOEbhaHg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM0P190MB0642.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:197::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Tue, 21 Dec
 2021 04:28:45 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 04:28:45 +0000
Date:   Tue, 21 Dec 2021 06:28:42 +0200
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] prestera: add basic router driver support
Message-ID: <YcFX+mDgMZFS+d7L@yorlov.ow.s>
References: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
 <Yb4R55w1mq+NXOwO@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yb4R55w1mq+NXOwO@lunn.ch>
X-ClientProxiedBy: FR3P281CA0020.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::21) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d34c86ce-53c7-4a4e-0c70-08d9c43a601e
X-MS-TrafficTypeDiagnostic: AM0P190MB0642:EE_
X-Microsoft-Antispam-PRVS: <AM0P190MB064259F889FD2B6756F6C6D4937C9@AM0P190MB0642.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nYjUNqP7tkLvykVxcl/4SAiizyP4bgmHxYR/TkD2JhCTErMpkKntdDL9baMWCXJB3xrn2bLRQM+d9ojcUYkjs6bjKjIMbHAR3B2rNCQZndc3PJ24FxJwymRyrTLjjni9wjtRT/MMeYBEAd5SE5ch6MeNl0W7xkIHbB4r3gNUM1k5/Yz222qDfSsZbfZf07GxLX8xf1gCtZ45YDr/T9E8YRXoqo4pu3XTN2NKmD2BHhBboGbgJ6CF2w/V3dS077mEA3SUS+bJn4G4/2hgKyG1mo8qpTtQNd8iTm/KoUKvV71xvlSzK6ptjtdwPbM8dvca9Cli+lRL2pyAKB5GEWfMyQULosukq+NwN8ZYXVRdff2CDGTDSp76WYzi4fIqcpG+cKcpFLG39h7+tA21ThPXgQAtDwgTHVG3fV7j2+H7Ul0cF0GFlgxy/pyWGb/mpEqJY2pJOWBPVfQ8jZjYHKHNPx1ykfPUEvx2vOgI08yu9mMciZvwOGI/Xb2RGaO2D4miiiuj0g8dlBBh8E5JhYYUPtPqiSo4vTunjGjPn2SWuLinCdKmxg7BhEOS/ZZJOt0TPwwntqj551JFH44fkAsu47lIvnFLlmFhbHr+pciNpvKEzJFrFSWHw9+QzmT1H6FxGWt/EV4+0JmrgWCJhDt/lHevvocFLWQTPdvl24klz6IKSGqFOfBgtv8Amk4VkI04
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39830400003)(376002)(346002)(6512007)(44832011)(66476007)(66556008)(2906002)(9686003)(54906003)(316002)(6486002)(8676002)(186003)(26005)(66946007)(508600001)(6666004)(4326008)(6916009)(5660300002)(66574015)(38350700002)(52116002)(38100700002)(86362001)(6506007)(83380400001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?igIgENbSf1ooMX7ZcC52J2qxBN55TFRELckip7tMOOegGp0CcrLwOvtHf4cw?=
 =?us-ascii?Q?qBSGFJcbyFUeXlDvJMbb/dAAEHEuNlgrwdZOBVRclwVxSpm7U265NDMytrCg?=
 =?us-ascii?Q?3QY7Nz27TrK2QCakRb0RDEnvrK9BKDIBThZidLj8EL1iGi3FekbJnpUNEQR7?=
 =?us-ascii?Q?7dIiPRqa73ZHjt0qi/CYGR7igZHRXoUKF/BCvN33qHTiQOEXNd5w5Z8gfGLo?=
 =?us-ascii?Q?FpFTO4u5WeV58OtCZ8hVPVklDCKLdWnnhFi09pZC7ROG9bN6Fcg+2jyjdbMh?=
 =?us-ascii?Q?yKCt+A+agcI0oWbH1WcBZHG99b7iQAO5425MurYl70w3UZtHKdV3uRsypQPf?=
 =?us-ascii?Q?QpIrkOIPKVD4dH1lBpvuVbFwJgW32vp0W58XbVZZIUrt9ffrpTAcc1vtCFcp?=
 =?us-ascii?Q?vYfOYY+T+zweHZYWaAjHxvvNagrpDV0Tm+pUWmrV3zgLmtTbLkbQJm79oYX+?=
 =?us-ascii?Q?bOfoX09h4/nYZPgILnEwlk30LUYolFiN+nOoBNCwUo1djWX2LUgu+TLXMm3+?=
 =?us-ascii?Q?z87XI3sCQ69al1mglUbq/tl9LlcMsv7G37RuDDKBzAaup9KklcHjBGPGpS6w?=
 =?us-ascii?Q?GsZdRrhpKbIqYavY2lskBZDXeIt42RsexcWHmXQiA5Cn4ZrZSevcYQpBu+ra?=
 =?us-ascii?Q?isxRtWYkzLQNkld0SZlMS7V+072BsiubDyNEcAqpv/d9u/gORg4NNbJkT3lI?=
 =?us-ascii?Q?omkHcfLlg2Um2xwFb5aGN/oTAzONJrB90OJ6Ktw8q5f7Dvs7en9Pv174K9k0?=
 =?us-ascii?Q?lMCKcitzBmJRO3L9Mm7PqEx7DXAlsvKfBwy+CVz8zJpIHAJJCSKpqRzFyu13?=
 =?us-ascii?Q?3m/tlmMNVUcwApl4OjM9KO0kDOxdoS6o74ZO3JDM4p3KQSuKvYbPuKfpfBAH?=
 =?us-ascii?Q?o30COOvBhC0YK6l4l269yUD2wrqhi5WHTX4kWF2gSOAik+bRgFwm6Ct0ZAel?=
 =?us-ascii?Q?rp4XbzwCOQ+IyyQaSfei+V+AlziFTVXBbdC8AZBRByR1XLxWnaacNC6jR15m?=
 =?us-ascii?Q?3rKlaVsjyQJdPcRymp1EaTFWjmVw6B86vxPok9CmlPXxKtA1FmYtb4NIv2Vy?=
 =?us-ascii?Q?jDy8VNG3IoEB51SjartNRBXlOAtQWE6fkXm/cI0aK5FZR8ZB+6oT4+386Wla?=
 =?us-ascii?Q?MFwVxlOf5mmVBEIJsCIXkCP3LjGiFTvSv1lDHITUxYScPOz1XE6nq5np43VI?=
 =?us-ascii?Q?rmjdu5QOwW86UOxoL0mfW4nx9v99esfEamkes7TNIo8Bg8BacaRTr2p3KBI2?=
 =?us-ascii?Q?ISOCSxDnEw6Pa4AAJURnXP7gy1bw8eXqeMfa8LRt17JfuJ4Jn/1PuAXVIym5?=
 =?us-ascii?Q?tM+FcVvfoGgoVAb082IGCL1dfae1/Ogmmp+pv2sepz88Ad5GuYCE5pi1eJ7K?=
 =?us-ascii?Q?I/wholsSQtIHmlfZcNklHRikTYd5bkcZTrymM0acRur9WjrI+8lJBC7dwtpe?=
 =?us-ascii?Q?IZCuYwL2T1wXntmxnN4RU18BNT224fDNaN9/jpnj+3kn8ikIPLX9oKLGiiKN?=
 =?us-ascii?Q?dkGtBnoRbZ33kw7IMGf10yH3RlqWgf6O4cgCNdtkXabKqD9iSMb2zXYBZE6c?=
 =?us-ascii?Q?gOfQ/dPC6tiq7dkcAURbY6NnlX22nbL1mPkJdAOSVopTc0t6BIF1R8lpGQHi?=
 =?us-ascii?Q?s+I0o5GRIcCkkWXZktq5vaGh63VtOGJDq5seWwCjmpqAu0kxPf4rej6RL7AW?=
 =?us-ascii?Q?QS7dNg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d34c86ce-53c7-4a4e-0c70-08d9c43a601e
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 04:28:45.1864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lga582zcn6c9DsXiM4/JQzX8hGJ4UTnUyqkOokdWJJd0FYdKzHnHEZiS5zyOLnHBkL4KzctzxFWYwDgqCUWIeeP6UvH46t1vrbg/VAcJSFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0642
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 18, 2021 at 05:52:55PM +0100, Andrew Lunn wrote:
> On Fri, Dec 17, 2021 at 09:54:32PM +0200, Yevhen Orlov wrote:
> > Add initial router support for Marvell Prestera driver.
> > Subscribe on inetaddr notifications. TRAP packets, that has to be routed
> > (if packet has router's destination MAC address).
> 
> I must be missing something here. Why do you need to tell it the IP
> address in order to perform software routing? All the switch needs to
> know is the MAC address. Any packets for that MAC address should be
> trapped to the host. The host can then decide what to do with it,
> router, bridge, or consume it itself.

You are right. We don't pass IP address. Subscription is only needed
to enable rif. IP address is not used here.

> 
> > Add features:
> >  - Support ip address adding on port.
> >    e.g.: "ip address add PORT 1.1.1.1/24"
> 
> This should just work already. If it does not, you have something
> wrong in your current support.
> 
> 	Andrew

Yes. For now we has just enabled TRAP's for every port. This is good for
software routing. But in order to implement routes offloading - we need
to control, on which port packets is routed. So, this patchset
prepares infrastructure for future routes offloading implementation.
