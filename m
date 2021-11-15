Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B34450705
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbhKOOe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:34:59 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:60489 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236544AbhKOOeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 09:34:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1636986670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z1Tj1pKl+HW8nZjJt6edjKYQKjSzhOcjU4rKRNuV6gI=;
        b=L06ssx/djln09Cuud+HhXz6B0koPMgskRQA4r26Ey8Z7Ytn4XVBze7LfKV8WlgpKqYDd2g
        99uj8xLXpIVSZw79YQvEeBghW36P4Jfr5Q6VEbXCwXP0WVABx+dKkyCYoL0z3xuNQEyM53
        ptslPrnB1QEZVVLenjKrsuRxN6dBKVo=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2056.outbound.protection.outlook.com [104.47.14.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-hUyUvj3yNEORGLJmkPjDcA-2; Mon, 15 Nov 2021 15:31:09 +0100
X-MC-Unique: hUyUvj3yNEORGLJmkPjDcA-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGq3UR+X+DertoOEgX5mTMEcYRnIlnobNKaGWcT/7lUJOj3c9tkiq2aTKdsbcZbh9DR5tVlYIoaqDB6mDQFYZ/blRFeFS4SHI0zhHgTX9HrMATCAlKl2fS1aJdspGdgTx1VcsyK5Pf4/dajn+3y+U6lv4PKeOImUO5Vuj3IYFjyzSZ9EVaRgOwNYZgeI3g/7uO4lRvpYqP47j157k5fStGezK4RZvy0bE9JbzkCG9CSMuBNyee+JXYaH//FYOK9ekg2aa7o8/8R0S9xxSPq2bR8qHosyW5T5X3mlcRApzPIhulFVZ7FiSSEL7qX+oxdaQcw+E6BliA3lceRLxqH7iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nzbb5NQB9kg8OzpfNh2c4a9P1v4HjvHX6JgJxmIddGQ=;
 b=gVZ+HHJ0hp0QNAVaURiUMhb7jVrIOvmeD4DqLSAnJIZHX/BEgtc0u/SIlxnaUwV56HV6asKGrNcded1wskYUGKsL/NGPowPFzhrUH3u9CfH29ST74bJxT9wUepYgSGkSAX+xF26RKKoFUMi4oUJzMsuayDFqi879viucNSxaIiiS/kMfxGyRlFBNc5lmofD8FtZ0rKY5XqYhfPiWFeB+Wc5hZSPwk2K+1+2KyAn1Wz9AkNMVJvGKJ45CzaO9BJPXEE+r5/JDHbS/lIm0Yyv6GFkaIPsU7sPwL5FqFyv5dBZzekPrMdr9HRCFGdUNvMDRpn6RgCeMKqRUQbe+pqTmxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB9PR04MB8284.eurprd04.prod.outlook.com (2603:10a6:10:25e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Mon, 15 Nov
 2021 14:31:06 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::498c:7447:2e17:4a42]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::498c:7447:2e17:4a42%4]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 14:31:06 +0000
Subject: Re: [syzbot] WARNING in usbnet_start_xmit/usb_submit_urb
To:     syzbot <syzbot+63ee658b9a100ffadbe2@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        oneukum@suse.com, syzkaller-bugs@googlegroups.com
References: <000000000000a56e9105d0cec021@google.com>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <042900c4-7758-bb90-bac1-c01b12df49bc@suse.com>
Date:   Mon, 15 Nov 2021 15:31:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <000000000000a56e9105d0cec021@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ClientProxiedBy: AS8PR04CA0025.eurprd04.prod.outlook.com
 (2603:10a6:20b:310::30) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from localhost.localdomain (2001:a61:425:1e01:ddf3:4162:d0fe:1b62) by AS8PR04CA0025.eurprd04.prod.outlook.com (2603:10a6:20b:310::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 14:31:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b891262-41cc-441a-ad16-08d9a8448f4a
X-MS-TrafficTypeDiagnostic: DB9PR04MB8284:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <DB9PR04MB828470E072C9D6150B1569F7C7989@DB9PR04MB8284.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EqOgEXtANqsH9FKooohf7gUS6B/GNQ2uXxOe0FR3Nt0XCnStWoXvLLAZQ4uaO3ilHD0LgsOdW+x72CDSDRjjrMNpSRfW3xw/sXsJXxYJVKIHZX3rwvzD1ScvAGBaDrYEM0Kv8JHL1RqSB9FH7CrUjhnx9oFeGoYbWXhslOHPn0WV3MTgKLbJ6nedE79VejC8Vx0wD/s2O6TZmyRpyfXpBbUC62sFA3Rin29nFgZwsthLiSSTH0KKRxJzi6NMYf2FCO+ssR0bvJs/nHY7f8MS8aeJ1G9QPdStWFYotHNqXDcNQ3nU9d5O2sL9/rnj7MwAE56E5hY0MXEIvJRcakoEPuUr5jAvfJ9C+2eo2+yy5fPA6cu3PVS0ilVg0BEhd5eL2MUR6ZuB5mWoABYHbQDYzZHeEgEkIfmQIJtKuFYeKIv+PpTZpQj0dA8ub0di9lax0HMxTyBmTDbYOesEnh1D0i7dFyG7Vlz3xvHLurIWZoCFEbMz2LChyqtktSbomYrbrv0fOVCMAmrZMkH0G5m4tD6Wp6O55adixJhCUSYUWQxhy1eK4LCDXzMd+JvmUtnc5jTYDOy+cVhn1w4tNnZkXmG6Ru4f20ZAtfCCSPIXbsygFx9kliUX+tfqxFn0lZuJ7Dp0cWuVp2x5GZumQfN06C/bwNN9Kr5bJGqX44ee5WlO/0PL9wScqyhsfeC6vaw+0bwoxxojr60BM9ZYCdrRnW75+oLwhMWJEARVQaEaBGd4ZJgIJnEoaVTKC8kp36oLzjKqr6nYyT2+5UmCp6SL5p+oQ42HMxENLQODvgT4QFk/dhrcjX4JmouFn88G42kqBYJA13GEyTd/EDquQhSxZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(316002)(5660300002)(83380400001)(38100700002)(8936002)(508600001)(36756003)(6506007)(53546011)(2616005)(6486002)(6512007)(2906002)(86362001)(31686004)(31696002)(66476007)(186003)(66946007)(66556008)(966005)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wnG8xXXgJWabLA52hY8o3uGEC9yWQE7sCAgch81d4uY7IW06QgzYYE7fTN9c?=
 =?us-ascii?Q?lSVqC975/0lxIZ/fjzpH46W/K6/iNuTAXn7XiWw8zZSWB0AcN04seY2WMnSH?=
 =?us-ascii?Q?wIxUuVkUxhn+j8naieBeBmuE6+AWu56XlHsKCG0KYFrPoRRbR+odYJuo/iwK?=
 =?us-ascii?Q?XpEstku0nVa8XFX/8zbfKNc/bU1WNK1nmLsd9ACAydFzdZkITBpTUpXzPf7C?=
 =?us-ascii?Q?Qvh2p0Y1hpxgseydCm8656+iqNlmQ5F3hL1+LmMlfCsXxL4AkfKeyhmRUFCp?=
 =?us-ascii?Q?u7O/VffGWQsLhpuhcU1X1JSRhzAf1CmERCizbc3YZ0/KHmiCxq0dTYtu7o+v?=
 =?us-ascii?Q?mp9D+eRjXNNKDVkg0oEsZQTHCEKL6be/Axph/Lg343PFzOUbYVj3xFWKTBoT?=
 =?us-ascii?Q?EMpKZ4brRXs8d6ZIraRdRVioZMOxQSSsa2TVSxhI+n2tYn7l3OiaW8XB515g?=
 =?us-ascii?Q?es9YFeQhoywZ56tyPpf+cuCQLGfHOi3BAI3cTyW9Pc4MMqOtah+eGQq9ipMa?=
 =?us-ascii?Q?3+JXWHf8fTUjVijdWlcqAJM1Cxo2X2elhQwjMO0uH4k0dAn2zBsCz/3B3lbP?=
 =?us-ascii?Q?M9lh8hF3mXbJxgQpgMV+2bzMZ5HMgVQI6presLavwVQp6mRBTdBkqDcZTUQl?=
 =?us-ascii?Q?7bkaS4u2TlCLSviQv4OnoYfA2n5RaEJy6LTUbi4HnqEfd57kGOHPPMcZ8iCN?=
 =?us-ascii?Q?iBcwSeY7a3yH8fAwxwR6UTlDGMj67d30LnEo2BDKydEpPhAMGul2TOGHv6Ut?=
 =?us-ascii?Q?M61em6ikRBo3aG8iLfNBXkmiKNm8lXKGw0tds7Mx2te1+zShBUJ1nMqdcXdE?=
 =?us-ascii?Q?fAmOErCmU/bst2p52S1bzwILzSClF5AOArHhJhwNwBAYk93oax0WSJH5vwCw?=
 =?us-ascii?Q?cU44r8rmBl7b36kXum4QkxVHmmt84i2SntGVhpuE8rZUFirspbtjC/ZVffQk?=
 =?us-ascii?Q?mB417v0/nP7nz4slPeCLdDDwPUlBU+8ToQtXMDEcEbpdow6B/RzsavUbgPTR?=
 =?us-ascii?Q?zXtF+6eRsWdhN1R4NF7DsluYbf2lFAFhcBQTNooI7FpV+Y5gqHofpkgJFI4w?=
 =?us-ascii?Q?3v34ouecdQQQ5Gwk+yUTTstduRHBi/RqYMm7qIiXUmK2Wun2g0n6hWJaJjlK?=
 =?us-ascii?Q?ti4jskbauMit71iRQPFE//nulV1tGHEbacrCPleCssxR9haIxIjakqBu4vbP?=
 =?us-ascii?Q?pOPUEmHw1iXmtsPmIj7e9y2XMW+9Pd5Wt9ZbY5cw/BNydn0bWmOM1BcAZzfu?=
 =?us-ascii?Q?FLV82iR3bsarTs73tHZTrFFAK13FkGLAsBVGAiuebKbhmYR5ubDUBFReXE11?=
 =?us-ascii?Q?2ARTljOQaQRQI4BEtujMIYBNYOm0ljlEZhq8+L6slSj8OGstFx8yr98/PTr9?=
 =?us-ascii?Q?9Q+SEivDO4mloyAPFIQCLVszM5zJmf9juX+LxP2nwREXKvDv5lDYwJYKsoHF?=
 =?us-ascii?Q?v1erLmSaU5rRctpIKNMzCmu/t/AohVOwInQqj5gRVuPyNP/+niZiW56m7hGJ?=
 =?us-ascii?Q?SbvfBaw96WrZnMYLo0U9HV0QqQ5EXT1PCyocp6Liar4LoZcJq5Pw64cJd72K?=
 =?us-ascii?Q?6tBsRdK5AlzCl5dx3uyXcqRdMBAXvRJMwljCyo17nt0DYmT/pwTITWTGTLIX?=
 =?us-ascii?Q?ZkhJ6D2MNmaYVjkknHkQ5tPkoAuriCKfCtsSrwtZw4tMfs01i+zjJGivqrkO?=
 =?us-ascii?Q?3brQZ0EInilDtoZA4JJ2pU5Yqxs=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b891262-41cc-441a-ad16-08d9a8448f4a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 14:31:06.6683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hBe5lesLSI1fCEAMeHTOQW4NB140FhDx611WW3MA56kyG9+fSSkRx/hUN4cmn4erLxQ1kZAOb/R+i8/Pd/3IgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8284
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 15.11.21 08:28, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    048ff8629e11 Merge tag 'usb-5.16-rc1' of git://git.kernel=
...
> git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/us=
b.git usb-testing
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1480ade1b0000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dd6b387bc5d3e5=
0f3
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D63ee658b9a100ff=
adbe2
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binuti=
ls for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1313cb7cb00=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16a2f676b0000=
0
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+63ee658b9a100ffadbe2@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> usb 5-1: BOGUS urb xfer, pipe 3 !=3D type 1
> WARNING: CPU: 0 PID: 1291 at drivers/usb/core/urb.c:502 usb_submit_urb+0x=
ed2/0x18a0 drivers/usb/core/urb.c:502

Hi,

here I understand what is happening, but not why it can happen. Usbnet
checks the endpoint type.

May I request an addition to syzbot? Could you include the output of
"lsusb -v" at the time
of the error condition for USB bugs?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

