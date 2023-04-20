Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9B56E92A5
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 13:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbjDTL3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 07:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbjDTL2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 07:28:44 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::700])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4435D10A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 04:28:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXYhneSrXlGAlf8/hVeNgZuZuRVMGyDGRKoHiBsdfeK/V8Y00xTYCnGLOm+8N3nrj9KzHP0tUDEyWNWM5qVtlc2G8FvGVf9XtOzShQOcvNx/RJFoFfPUFIjgrWCSQJUXLAFRZ6omCbmwqL2t4pXV0+K/sEtChney243/YV6iJb/OuTN6z0aG6Au4UobYxJDNjj7tY/Ojy0ZwUwjLwUkXZKmxTVzwLZ6Qe1pUqX9BrbHPlAnafg4155bgYcfFGKaafaXvQntFM1vlHjTwnALdvx9KnmgpkClzmX18ZQeFkSCKn933WsNDbXptpk3ach0UKx/DXovUFA1tE7uPEc7kSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0RRFrfBJd05RxpwcUBngMZBWqVM/jrl5nqMLav9O4Z4=;
 b=FAEFb8CCk0OqngoanKZu1O8Lo7tEJYnFZlaCCJdcdAZPFklAG/Jd1bH78xKyZKJwK4VxlsmMHs4/KS1rL3toDfcBAusFR4rO0Z6651J9Zu2Fy0UTRbob/sqEf04/gGRxmjVo6V0CDWHL2CK4HHpI7pQigFbmB54e0KygLTi8Dk4HTg9NayAbs4m92vWjx2jrplhwhp4nSAmcceo1K3BB8U0npNumCpLC1dsTBl/eItIok1qr2HvYGDYY4alOCunslNzMWlO/2PB/mGFO6/SdAFP9cuqWkRSQWYHDNaR66iftNgF4N++K+d19BfOVKvBlhsWfZQKfeEKy3Ej2LqOVQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RRFrfBJd05RxpwcUBngMZBWqVM/jrl5nqMLav9O4Z4=;
 b=bOjgpBR5rNHO8To3jsFto+ML5At0/ygPW6PgTLOkHdK6mqryz6aSOpWMHwpqWD0Z1NANP8Ry8Wf74KYyjehBcpFtW4S9I2XjX0+G8AgbiFBLe3r6XMTLrkY97eslteLqBvRXVeMbycXJcbGGAthWvofnBCBH/hWbYyQ0HKVvdmc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB6013.namprd13.prod.outlook.com (2603:10b6:a03:3b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 11:27:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 11:27:39 +0000
Date:   Thu, 20 Apr 2023 13:27:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2 v2 2/2] iplink: fix help of 'netns' arg
Message-ID: <ZEEhnt4G76URbksh@corigine.com>
References: <20230420084849.21506-1-nicolas.dichtel@6wind.com>
 <20230420084849.21506-3-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420084849.21506-3-nicolas.dichtel@6wind.com>
X-ClientProxiedBy: AM9P250CA0020.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB6013:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eaae9e9-635b-4386-dab0-08db41923f89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XJhRz6HXcHqpEMa+ANMg4/J/Acy9asN419RPcVo+ynVjfAoL/vIT8LK1fHzxwdl3EBeM8y+zH6rnEPXSs3FCUSmrjiq32vDT2j6ziXntE1VhdAY6/394DvI/p+Z/ImpFwiD3rHOYER5Ej12FD17nU+t9Odg5u0sitUmJEyBowpwfQ75qqlob7V3QSDMuAWZU2u+0cQKlGbbBiutTUWZUh6j/z22IYlbKKY5fTeKKVVGaOaBazb35hlgY7CB8ZAAYErDxb1fi+Ag272K+yYcHCcUiKieXlLE6pAXR80RDAVWh8KTv8b1gZug4x84zVe/qti6Gc8y9QKUCYGDPk/sU6VEAcYlrOUth734fuBRUdX56OdI9XzBoQfkPqUzHSw/NZHZaUFJzQkfS1bp7bceCttZ+TFww0iYSyzL90rOfrZTJFJAMhFvDKGd/Bh1GLSNQ70nLqB6ruHXa3QeEB8j/na1DiIcp54aSapfmJBIwGWJ3n2avwqt1qCYQ3gsGyrx8e8CTsIs0uNbuRAxaHgsKtKDzi+dktLPUegYGJjb9l7prWrGblr/gTONtXiaL7tE5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(376002)(346002)(366004)(136003)(451199021)(36756003)(478600001)(6486002)(6666004)(41300700001)(8936002)(8676002)(38100700002)(66476007)(66556008)(66946007)(316002)(4326008)(6916009)(2616005)(83380400001)(966005)(186003)(6512007)(6506007)(86362001)(44832011)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YRslbCj7OrZma8uvw6ne+Ht1Hl/4KB4kQ0IyeTx29yfihI1nsfTQe9qh2cIf?=
 =?us-ascii?Q?HAjWxsqH3mIbKDQvlzzYgfuik2IKQJCNoC1fmOi2ZeGjzaopj8eZxDHdrM/j?=
 =?us-ascii?Q?2aTAETM4IPB5J6NlS8m3Inal/zNaMC5qtLm7lSM41x+JjDOrcvZVcVo4ekVv?=
 =?us-ascii?Q?0k82egJVH/gGoQ8dc1PO+D/4iU9r0M4wTsBJRE8tAmB+lqBR31F4EGC1D7BN?=
 =?us-ascii?Q?k9kb989TJTPcZ78H5LemKY+3WSDMJiNCzq1ZhHGmir89/xQdXWf1U1MM9PHe?=
 =?us-ascii?Q?E7rS6hjPtTe5bMsaealKTtWwWyYNay8IufqEE0W2XJea+LBkZjVLlCs4nm8i?=
 =?us-ascii?Q?tGAoQAaaDQ8ExatVnQkeIY2y1LD8UQPGgTCgb5LP3u1ljW9dkpQLDhDOMD9P?=
 =?us-ascii?Q?8oGyoHQ6kISBIAnmP4jFVLPxjU1vMEp86Cf9dIml3sYL9OUTNpQ6TITzDnyF?=
 =?us-ascii?Q?M2IentuAKoKb9MqeKRx0Tg6PZUghk/d6C2sFSqSAsf7VmTPZXLX2W7YBid6N?=
 =?us-ascii?Q?8ROADA6hBN2a5sc6XfAUGU61hXZXEmApVANMloEwjOMxZzf095i3BtHksp4S?=
 =?us-ascii?Q?JkADRcdfrF09CVAZm+67LHfjFga+e04hohLP69tdEYnT0t1L9S1wdGRSRboB?=
 =?us-ascii?Q?nZRR0d49shZ4cvTEHYH6qRQppEA2ZGLaqNJnSOA0A9gWv+DDesYiLW5CoEjS?=
 =?us-ascii?Q?RzNix77Uy7b/twKWnaLrmhKkpYQBhTc7l7Rt+C0FWG659iIzyMxh2ZiRNME0?=
 =?us-ascii?Q?w8YGE5XASg4H6zK0+wCQTBbTfHLdEM5s038JQEV19/YQBraVM23M8VPovfWA?=
 =?us-ascii?Q?3wPYlpjYEku80CgyPvAjLc6Dq3fqUrO7wrhZ8IzucCs2Fq6hXY3MdEFaml/D?=
 =?us-ascii?Q?+oLzmry6vAm16AuplvVRs7eD/a1TlfQebAdfSrQCQg0eEUKfzhQW2punwhpJ?=
 =?us-ascii?Q?3ltJgHTVWUUqKgLv8z9oCcSulsrTavtylfbutcVOY997vGs7eDLWbOvYmyuI?=
 =?us-ascii?Q?PI2Wi8wPJXDv8/ljX3eqhUYW8UP3eYmw2CHwn8JhAMHUD6mQReeBwe9suFg2?=
 =?us-ascii?Q?EBnm3TSMV5XjSCHK2UouSnFpfW9o/VYH/OWWhBBe4dC3W1ny+CX0/mFny+xY?=
 =?us-ascii?Q?dgCKP9LeY8oTmEkvrJzpJQelvRNU5iTZzEmYVoBCGE2OuzlNMO6F/qBu+4CX?=
 =?us-ascii?Q?rswXp01IVeW88s0OYz03JIiWqCIJyc5l9TZne57GygUoMwO8WIuyMLAZBnW2?=
 =?us-ascii?Q?7LUxToCke36KOSBXZ+SC38zcNjBQ4B3kFW8FUOw7uaOe6/54AJgixKKwfxD6?=
 =?us-ascii?Q?+pXKpm2YDwsYENRdQbOdesXL0yAUlKubzzuU5LPi/xju+0orqfXt7xVMoYz+?=
 =?us-ascii?Q?QgrapcHgvAhp4mq65v11Vxv+61zmOVYbxOXmVXMXA69u9KFUwQfnKqektBH0?=
 =?us-ascii?Q?VTUzyx5CHAoM+NfFCwpDl7eI2LtJwfsb+/5pI94FA8/5i5KLsSWvjfW0hNBQ?=
 =?us-ascii?Q?Z0A6CDilcIXLi0xRQs8RHowi2M0FnMKw9WiYI4SbVLAFUvd+k02naHZUJRDU?=
 =?us-ascii?Q?NwI5YV5rHZxITCnGHj5kdKeztHTS+eHAhaUz8715YOthzOXJvrJTIFYiNdYI?=
 =?us-ascii?Q?JUM65gy4F3phoIloXkt5ONY1iw6kc/W9Q10z6Uuiy0xjL+qeBeWTkXoeXlEp?=
 =?us-ascii?Q?XF+3iw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eaae9e9-635b-4386-dab0-08db41923f89
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 11:27:39.1831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /EgJxIhWzY0m7NAoUHzm6A629VIutbxgk9/rhcOINKQbwMAC00z1W3/Bm+9LRvE/jnlfQdQ71CbrN3MqgLMNr+4VFKufoKPx2X9objLzHGU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB6013
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 10:48:49AM +0200, Nicolas Dichtel wrote:
> [You don't often get email from nicolas.dichtel@6wind.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> 'ip link set foo netns /proc/1/ns/net' is a valid command.
> Let's update the doc accordingly.
> 
> Fixes: 0dc34c7713bb ("iproute2: Add processless network namespace support")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  ip/iplink.c           |  4 ++--
>  man/man8/ip-link.8.in | 10 ++++++----
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/ip/iplink.c b/ip/iplink.c
> index 8755fa076dab..9ac3b8cb2ad5 100644
> --- a/ip/iplink.c
> +++ b/ip/iplink.c
> @@ -63,7 +63,7 @@ void iplink_usage(void)
>                         "                   [ mtu MTU ] [index IDX ]\n"
>                         "                   [ numtxqueues QUEUE_COUNT ]\n"
>                         "                   [ numrxqueues QUEUE_COUNT ]\n"
> -                       "                   [ netns { PID | NETNSNAME } ]\n"
> +                       "                   [ netns { PID | NETNSNAME | NETNSFILE } ]\n"
>                         "                   type TYPE [ ARGS ]\n"
>                         "\n"
>                         "       ip link delete { DEVICE | dev DEVICE | group DEVGROUP } type TYPE [ ARGS ]\n"
> @@ -88,7 +88,7 @@ void iplink_usage(void)
>                 "               [ address LLADDR ]\n"
>                 "               [ broadcast LLADDR ]\n"
>                 "               [ mtu MTU ]\n"
> -               "               [ netns { PID | NETNSNAME } ]\n"
> +               "               [ netns { PID | NETNSNAME | NETNSFILE } ]\n"
>                 "               [ link-netns NAME | link-netnsid ID ]\n"
>                 "               [ alias NAME ]\n"
>                 "               [ vf NUM [ mac LLADDR ]\n"
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index a4e0c4030363..59deaa2c1263 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -49,7 +49,7 @@ ip-link \- network device configuration
>  .IR BYTES " ]"
>  .br
>  .RB "[ " netns " {"
> -.IR PID " | " NETNSNAME " } ]"
> +.IR PID " | " NETNSNAME " | " NETNSFILE " } ]"
>  .br
>  .BI type " TYPE"
>  .RI "[ " ARGS " ]"
> @@ -118,7 +118,7 @@ ip-link \- network device configuration
>  .IR MTU " ]"
>  .br
>  .RB "[ " netns " {"
> -.IR PID " | " NETNSNAME " } ]"
> +.IR PID " | " NETNSNAME " | " NETNSFILE " } ]"
>  .br
>  .RB "[ " link-netnsid
>  .IR ID " ]"
> @@ -465,7 +465,7 @@ specifies the desired index of the new virtual device. The link
>  creation fails, if the index is busy.
> 
>  .TP
> -.BI netns " { PID | NETNSNAME } "
> +.BI netns " { PID | NETNSNAME | NETNSFILE } "
>  specifies the desired network namespace to create interface in.
> 
>  .TP
> @@ -2188,9 +2188,11 @@ the interface is
>  .IR "POINTOPOINT" .
> 
>  .TP
> -.BI netns " NETNSNAME " \fR| " PID"
> +.BI netns " NETNSNAME " \fR| " NETNSFILE " \fR| " PID"

nit: The text in this and the previous hunk was and is inconsistent.
     Is that something that could be addressed (at some point) ?

>  move the device to the network namespace associated with name
>  .IR "NETNSNAME " or
> +the file
> +.IR "NETNSFILE " or
>  .RI process " PID".
> 
>  Some devices are not allowed to change network namespace: loopback, bridge,
> --
> 2.39.2
> 
