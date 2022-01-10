Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834C64897A9
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 12:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244896AbiAJLke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 06:40:34 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:21596 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244850AbiAJLjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 06:39:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1641814770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1EQySXWWSFPnBohhHPxzEnZjmif8I6WWYBXTGHdD7WA=;
        b=mePcGh0ixvPn+jRlqezl25zWV5WCgsjF3D8ak2bnuOYXwoCnTOBnCBYXg71Cd0nSdKnyR9
        zWsG4g77JhZmZiWKzUVUsf4xQjns5NG/pzLrEjqy7C3bZ1sUhXSTxCt6EVYYJW8KSSXxda
        1QKfVc9lj0gvYvKlAa6YdQls7e7m2kY=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2113.outbound.protection.outlook.com [104.47.17.113]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-12-Sek995rbPPiFQTDbXfyPZg-1; Mon, 10 Jan 2022 12:39:29 +0100
X-MC-Unique: Sek995rbPPiFQTDbXfyPZg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdQ8s359Rdvo+TkSAQ5SPvT/hvME2mwlaQG1KuV7ljOgTV25wYWfDXFFx6+oFJtFtRgoADxETUTxoeqzfS+BjSU2nmkuZRnvcxsJWX11HvDnZSdK14IIgNBbEMGeFfg4+ptipuT4dgH5CiJsiQIEpzl4EjWRWnPxaalY99goUmS0JP/5fEWy61U0bmP8mSscgQhxTZa62F7U+sRqq6wAezyM3AyznKY7ieMJJuNK4w26AO5a/koOvzVban4Gy7wxihZ1wvTghW+f0oYxJ986K1JW7PlRbNCvMl2eF0tffk7qnbvQhmQYxnlSPj2+OQBk+nldo8DiMWoN/tcGlfYgSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+PU0aErKYduFdgVkK62TLx7aqIr19exLJgatuTIGWY=;
 b=hdeDHTNnJM9pGaufzE/NmlTOCuhcgbkKPSp+kCxcllTsFmgnkX8gbV3yq8CRjBC+3sHDM1BL0ZmBvZbavsOdUmHLCC14zl6S5HdpJhcOmpc2ns/48cu92r9pXTIzd/HcqMAxepsWwaEmoR0Ov6pgP3iCjrVOjhnnpOm7opr9INYYb1dPmlsLOCk1VGzNb+LTL+FN5YaUd/aBbEqi+OyXhw0Vh6dQDC6F7SwUGNvfdKcHXRejIn71pJyWoUQ0NTI4iy0T2ad1N1DertvWiQ8TiTl4CxPYhvy2O4tV3JqHjtGVLGMclZiM0PMDaJlxffc8WWauRpwSB1pLPInfZnY7ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB6PR04MB3238.eurprd04.prod.outlook.com (2603:10a6:6:e::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Mon, 10 Jan 2022 11:39:28 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::5d43:fa3d:6436:acb4]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::5d43:fa3d:6436:acb4%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 11:39:28 +0000
Message-ID: <3f89059b-13cd-d632-1ef0-489e698d7b12@suse.com>
Date:   Mon, 10 Jan 2022 12:39:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Content-Language: en-US
To:     Aaron Ma <aaron.ma@canonical.com>, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC:     davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
References: <20220105151427.8373-1-aaron.ma@canonical.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220105151427.8373-1-aaron.ma@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6P194CA0068.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::45) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2524d520-9fff-43de-9bcd-08d9d42ddbd4
X-MS-TrafficTypeDiagnostic: DB6PR04MB3238:EE_
X-Microsoft-Antispam-PRVS: <DB6PR04MB3238426170D78BA00051CAC8C7509@DB6PR04MB3238.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RL/MeSOXC12k1nXoWPl+AnNdqTvUEZ32klPpRj7D8LNi9QhhgjfKhNO6I0jTkP/BkfgdTMcZf4zQZbQ2+a9oA5cW/tmpsVCjtROxV88O25qNEoU43tGlQf/kbjBWAh4FtJhWciKi/JyXVJVHalAMmMUD6eTwDu/9SBZtlSaFPDgN1Lfq9ABD0G0m+WKZQCEOoh4DqdGrqIjDqvbXjb2MIsEAg/iF5x0CvC88a+QhEe8pxVsOf6R71XvbB7AO+7ojkizun3GX9UX39aE1De5oea0RxQu+kP1jwwC3aeuGhOSNkXSgKYEOLwO0SX5EcIUA7XsKVy2IwSrH33A4RRaR+Xk+xhbXEdbmD+Wa6wRJoD9XX6EuI0zZQeGZHHAPXG+n+7u4HemYyxSkT5bN8B7Z/ajc1F+DzE864zgyIMY1mGzNUPqnS981Tm8yZnS8vXvrAxbV5SepZIfFcq2nSJq8qXcLe0mslTyO8TBT/DPg9lEZbzyM4UTp1hYgTnFY3Yw7Jb6cSEMQK8QAbhzeD826fEm0ts8PAbXFuucqOMDo/Lj59HB/BBmK2//K220J9yBTMl2J0h6p5XZR/lUdiyWRidCxG5ocBz2MhDvSnq0xGZfWXBMnx7nAmp+XSaC+U4j34oWvccXPjTp85tUggc1fjzZcw/7A76imFBLsSDvqHbwRpdhH7PGG1ki56buu2QXcqRFJ5tbdLa++yDsKEVEPHqwQsJy7TXqwXVL1mTILw5o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(86362001)(66476007)(31686004)(316002)(66556008)(8936002)(6666004)(8676002)(83380400001)(5660300002)(2906002)(31696002)(38100700002)(4744005)(186003)(36756003)(6486002)(4326008)(53546011)(6506007)(6512007)(2616005)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HYYpBLVFz2yPghxpVT62GuU74H2yPW4m5anHURt0aO88dWpJ6dtka26ECT9A?=
 =?us-ascii?Q?qKCJE1tElOderrU++z/Lv8pwkIGx0Ma1YYYQNKp3MeFOf9GQX75EDSraXeSQ?=
 =?us-ascii?Q?RJhIq8kmvJyojNJCLFCO+uz6fzv/vu8Cc7yKWlwVKwZ2z5wQVeOr7tyj2qUo?=
 =?us-ascii?Q?dYqERcLXRr0X4+iZfb7SbsxlLNh8NPic0RSWv7LWkutqDFP5jeAYOsXcfZ7u?=
 =?us-ascii?Q?7PZFvFqktr8/F70trMlcRrrvm3GupWQJyBiY8gDYHXz0KshwG5eiPOf/0Vur?=
 =?us-ascii?Q?q91KTTdQCiaH9z+iQZSVzYRFToDmytVcpRDdox5hEnF/zx4cfBXaTNV1BB9I?=
 =?us-ascii?Q?ssOwbcOOUL+mg/yzZreIv9he+Y05KC55eXx7whyhGcS9POJbFS6iMIQyGHEO?=
 =?us-ascii?Q?T5Z8zTkDmqwLfgYZy2huI+eJbsbMX2ZAJQQPhMiPqnJ9JyTYa7DCrAoaw7rM?=
 =?us-ascii?Q?cjraIrsk6FoQnKvCulDYa8ug9Hjk6svuPT66KuO5c4S2mQs4mVXt+zk0SN2O?=
 =?us-ascii?Q?gFRJ4ZZC94BnxUBtRE5XHhUtfbLXhJ2ayNHYd5Ni26RU7XrxcUFWbTxDRu4R?=
 =?us-ascii?Q?D/tIHMql/jrcnTazXyvoQ21lkWQN8utKQeqLdjQEPAkDIZlVyPIBYK89fdFc?=
 =?us-ascii?Q?/ipCyA9xdZacZ8SUN5fVx+x2nGSNtmYH4O0SOFGLM0pC6FsEnpHwkalcYiQj?=
 =?us-ascii?Q?AvRpgHxMRREsObXWPSUmJTLjazvwgAQPvmFw9bWynY9fRBEjYS38K1MSe1Ik?=
 =?us-ascii?Q?QMXiQ87Eto+CAqZhdyZ8ZMvIWXnvyxOuzsTjWRepyaIq9+6m/3L059e7lPou?=
 =?us-ascii?Q?wMPLoSPGc9vNrXg2wMx425n5jJGhYkCSAbuCqlR3b5RwsF+W/rHjuOPBAD8O?=
 =?us-ascii?Q?pW91I+IrC8UB/oC2EVhBQatZn4MiBvPEbgyx7dej9qjBclgahisBl2BCfWTO?=
 =?us-ascii?Q?zaIVluCJIHHMAr1P6WaAc7OOyCUlQNIQfbyOVNEB61W5j+EvHWADPa52ZIJf?=
 =?us-ascii?Q?aHjymeitk8NQeN8v06QEArD4sI2aHZKrd0K/aleswAJ+s3x1ZkbNFTuj7l9o?=
 =?us-ascii?Q?t3goPc2Tl7yMolCxY/XIRrCNncYJiA8pWFv2WlO3SsXewqCGcCe1BOzNto3O?=
 =?us-ascii?Q?6ytZOCLzm/hcV7qBibHaCNRo/uejAXiRyw6lPXxQJKSz74K2e2uJZ/hadmLE?=
 =?us-ascii?Q?5h71gw03tqq+8fVPyhjkGCWnWjZf9i544ZVWgGvrcAsl9cKK+MEr5bGbpGNo?=
 =?us-ascii?Q?Zs64TddhQUg+Fny4UkW+9pmqRCLumyuPMT/r/R8DBZnXxsYUaMNul+Ob0q0l?=
 =?us-ascii?Q?57GSjL8cfUn3NZmQT2FnqX8nQ2k+yX5MPSIrP6sp4u9FdVy3whz1bWo2SO9C?=
 =?us-ascii?Q?SUZQHD+yq6wSVo7GigdJ3I5ABtgdCZxz7XiSzRXOY0jXadtRJ/55aIth0rXI?=
 =?us-ascii?Q?3oMB2xRfXOFKufGVT4P+2BZ4VH3hXRMQqgC/HbwBE9YBni50miqdMoP+70UG?=
 =?us-ascii?Q?+9mwni1NMJNl+txhNL0kR8eS0uU5CuQ7rNcdbW77R7nsaSf8S66EFifE7hKh?=
 =?us-ascii?Q?pktadJmAjsXabY+hYnyWBTMHpOETEvp/TueoJs2Dz03p5wfjplt+Oxs1+x4q?=
 =?us-ascii?Q?Gi4vlcFjaI6Z3iE9N9zrttI5ohZckafJJPDM8WEBkzaeLli5RzsS8eemlhHh?=
 =?us-ascii?Q?KWKRt7Cg7nFxWLj5sgVUXgeUwVE=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2524d520-9fff-43de-9bcd-08d9d42ddbd4
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 11:39:27.9521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b9KA1WfFNjre9VDnIoD26p3o9zXcLkvpiFs6vF7rFex6CvsdoKs725+zg8hWtPg286qYyA6JI63NMWVqrhAepQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3238
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05.01.22 16:14, Aaron Ma wrote:
> When plugin multiple r8152 ethernet dongles to Lenovo Docks
> or USB hub, MAC passthrough address from BIOS should be
> checked if it had been used to avoid using on other dongles.
>
> Currently builtin r8152 on Dock still can't be identified.
> First detected r8152 will use the MAC passthrough address.
>
> v2:
> Skip builtin PCI MAC address which is share MAC address with
> passthrough MAC.
> Check thunderbolt based ethernet.
I am sorry and I may be dense, why are you comparing
MACs? The pass-through is done per machine. All you
nee is a global flag, or if you want to be even more
formal, a reference count.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

