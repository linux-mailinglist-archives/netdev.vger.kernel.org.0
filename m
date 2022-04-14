Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65375006EC
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 09:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240350AbiDNHee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 03:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240284AbiDNHed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 03:34:33 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A163EA84
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 00:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649921524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gVImutVb0wHT6NKTDuwicXwgyj3wuviGkyRuhky/xH8=;
        b=A1Ng5Lfxe2rn5cdYlQIzjzwNxrUBsBWobhj4Vmj4ua0My0StGTKc+/Ehd9Ks4xBntmJtOt
        3u5587A73ebBBdF2AhIedLG2A7K4I9Zp0Aom0BEXBOO5TGFi2TAHdYQDUcJ3dZClJIrWcm
        qA0DziEdGK7Tntm27kuVMlq8d/mARfs=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2170.outbound.protection.outlook.com [104.47.17.170]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-40-SGFuA0LVPTKQSoTsMadHzA-1; Thu, 14 Apr 2022 09:32:00 +0200
X-MC-Unique: SGFuA0LVPTKQSoTsMadHzA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1VU+nIJO7qgSO0+dRM9+10Ti+5oYbf1+1lrdsRuvDYaCDeMs+F0KtrXruhPxoSPSRFBYHYyiJ/kFKKPn9Kzvrw39ko8ADK7cdgjtSSScaWgAWHLR6LHZATq47bWD8TgcjtmwWH+3/IAUHtt7maeTaW/Q9dDe4F/rbYO+VA3oMy1yMf0HcxHuBDlfqMexbw+NAV9R+ZfZbbVqTn9/IsqVPA/vcTDOSUPWOZnN2n6I96EVkW0LeUt9BnfnqN+Jn6Q24a+ZaCdFMrr5vgV85AfEu3hJ9Q6wcVVL2HaL0TfDykxYDUCOVb6nkW+Emy5TVMXenIv4ca5+MswjHhOMjQ3dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zW4Ob799XM+/PeDzQyTCw2EjJNFPNtt2zGeWfJDC07Y=;
 b=ckj0IUhMtjfsmAKO4j7x7pasFYPqImVdBbLLtnwYc99Oyb8z5JWpxYFDaJk3Re14SrebssLObVUgqlTqoOWQxCYQD4bjfSTjI9h534k+CUXYDde1ZqPL7l1bCHX5gktTw9BgJtupkNKkSdzZqoxGQyU8/Uozh/+sQd7CVSHb1doRZsp43WVE+vZc9+CYmqnXS4Xp2G8tUdEDCvUrsfwuaZDv00FoRMygzTXFLcsppngPhoTla6hqpmEe3GVuNDld9PEWnuwoK81krjrZ0YxPlW1djW0OscUBvZ1mtoSq/RlYL5fJk7o1PzD8etJty7s5HvJxzaVlgHbEYwSGiS6CnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AM7PR04MB6871.eurprd04.prod.outlook.com
 (2603:10a6:20b:109::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 07:31:59 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b%4]) with mapi id 15.20.5144.030; Thu, 14 Apr 2022
 07:31:59 +0000
Message-ID: <523330e4-cbd7-62a6-9368-417534ddb0b6@suse.com>
Date:   Thu, 14 Apr 2022 09:31:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        David Kahurani <k.kahurani@gmail.com>
CC:     netdev@vger.kernel.org,
        syzbot <syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com>,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Phillip Potter <phil@philpotter.co.uk>,
        syzkaller-bugs@googlegroups.com, arnd@arndb.de,
        Pavel Skripkin <paskripkin@gmail.com>
References: <20220404151036.265901-1-k.kahurani@gmail.com>
 <20220404153151.GF3293@kadam>
 <CAAZOf25i_mLO9igOY5wiUaxLOsxMt3jrvytSm1wm95R-bdKysA@mail.gmail.com>
 <20220413153249.GZ12805@kadam>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220413153249.GZ12805@kadam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6P193CA0051.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:8e::28) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 128f1fbf-f423-4419-8cae-08da1de8dbfd
X-MS-TrafficTypeDiagnostic: AM7PR04MB6871:EE_
X-Microsoft-Antispam-PRVS: <AM7PR04MB687144933265747096ADB6F3C7EF9@AM7PR04MB6871.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1vSqKUGdlKU0rMqcevwxIu/usGgh6D7BklwUsz0Y3TyWp+Th7JncUzReoX+ky0c44u5Cs5Xmlk4WFEzuUsrJH/MaIdhTX88PlmR6Uol0jQAYLg7jfjsAWLqthwzvI1u9w5XceaHXBXSi04q0JZtQUlSHm3zuMKQEgc0jAM9ntXrdm0DS2FJvGlrR3CYEwBKe4DbBoVxhJpI4dMCSZbgcYutqnucepMgsCjlJVwimAAn62gwceg2l6/RqFcew19QkWLrbs4kdi3Y5Yvjf0/a8bSQjv4uYaGHjuHG07j++5Rnjlx4lB3Hg9pBeoYSxx/S0aviEM9nneTYdKPMSJSsCiGGgiJb2IAIZhxhmkd8+Vv5/HPcNojoD3WeLL2swZr9OCnG48cEVt1cLApvruYfhZkcLf/065LYbOxzFXN2ISjhxIesE42w4xJSm83X1UuwGDxMK2/5UgMFgx/u4H7xwZXs8YYEzNIOZJg+GQR6rGSYXcLhK7f3M0/IykgK0nqtS/EYruRU3PE8yoUAE16kuc/3XBtxJt1os0KU7rSt04/Di1Fpz6fmx1Lj0wa4uPJ8IeMykLatZMcUeTBWMagZCC/wdh84jaQy2IlFEXmvGO257e5msvkB0O4HqpCtvrl2IClj+3uFcw4RADsBfi4y55XeFe+c8CfOAXviRehWZtDCphN6icOLt9QRjBi6T+p0cnCrNt8dp5F3GrNBXk7JUxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(5660300002)(66556008)(6486002)(38100700002)(31696002)(86362001)(6506007)(186003)(2616005)(6512007)(4744005)(53546011)(8936002)(6666004)(4326008)(8676002)(508600001)(7416002)(2906002)(66476007)(54906003)(110136005)(316002)(36756003)(31686004)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z61Lw9Qj+isS4NYfidFeg+UNbQZvrRgOLLhUhqd86W37VMm8KvSgqgJ1Eo/J?=
 =?us-ascii?Q?rkOH5Z5vIffzII96yfHsRI+djQAMFx4WOe1rb5i444lJxeJd1i3qWX3zYejw?=
 =?us-ascii?Q?Iz3dvbC2RvEXLLAQB4QGLY0+tn5NHzO33hF3DGNeYevfnT3B+niDkcsidULV?=
 =?us-ascii?Q?7YcEyZxE/B7eOUpu/O9NXskq4+AA8n+AwGK84w4xEAlq35c1mjJnlk6SeajE?=
 =?us-ascii?Q?Ex9rp9OXGms9YLPTlNTkTcca2ICn6g6vNhHFwW4Kd/SQs/WNLQhpUzxJbHZA?=
 =?us-ascii?Q?jdCZB6LlU+703WeoHlN/ppKl14+F+mM+a/AZDw+dBdPNI30W2VK7IsfFiAwb?=
 =?us-ascii?Q?eFTh+rM17PO6oABJ5Bnqou2G2DSBoVY2w5V/RYruxl3YAzxUUwaiMvzJh4Fa?=
 =?us-ascii?Q?yXR7HhOxH3mzJsBXMN+aJ/y8NwfoZ9sGb3rC/eVsSesn4nxP3ZuSwP2mOyVu?=
 =?us-ascii?Q?Xsjxhru51Rr8e9mUdCgbgYC4FltDOH8EdDe33kLBVXoz8xwpaUNGaf1SHCgu?=
 =?us-ascii?Q?lMWo79ddVAtAzUaez0Hznhfe3bxnna06oYRUS4JPOpOJ6dAHcdozMEckiIgL?=
 =?us-ascii?Q?gwW5xPZUy0qvTUIOwLMb8lTg3CPFd8lJbi8a3Ep2RWDkgpvbZfStZafnpo+n?=
 =?us-ascii?Q?atKgKONWss9TG7h7iiVSGveFwEEoq1pqNdVw/5dfwqmSKfSOM8dbvz/0rp8O?=
 =?us-ascii?Q?T1XlBL6YOL4H6TbRKOt8Qa2WhaqkB6kKXR58Z9+CI8gISewes51ntKkruak/?=
 =?us-ascii?Q?FXHIzZymmGilr3dR1FGwMfvqzTnVLlsnGJhPE445/fSeHs9u6LZduWBKrHUa?=
 =?us-ascii?Q?c2UVpkjvlZARP7N53aNvpKMXAfuQ88qfa4kE3+0PC1plcCpBsmSv3Q20HCNM?=
 =?us-ascii?Q?BV/HE5tCjwO4MVv2YdB6KSIr8plynrXhwtXXQKWJj9oKr+cqPlbDQHnrA2oQ?=
 =?us-ascii?Q?3baceL8eL3pg/RLlThcGjM7ixKTxifmr+lAH05ExJRHaFWDc98IFa0EPPyEs?=
 =?us-ascii?Q?5xbj8ZMYbhFeQyDzzvhrnQLpNprupiyArJuVGCU/WMGLPZ34MuuuaAi5dUNZ?=
 =?us-ascii?Q?Qlw4U4EcSoHTDyGnVFrrDF6D6ZA2rMxFk3GXDMCHq6zpZUcVEvwJyWRvRYy+?=
 =?us-ascii?Q?Qs4aeLFGWGj7JadB9IwyyFvlIk76QRo8NGfDNWGNO47Ch24xeRaLTRobACSx?=
 =?us-ascii?Q?BtzbQAeN3frBTVPAByYLui8PC0yok6aVJPOQoAfFFnfhRLbJdttuC+mwirTk?=
 =?us-ascii?Q?bJFx//tUacr8oKzEwdsEyRFvWnsCsOAoxcKrZVY4foXuNV8DqPJRlLNRQAp7?=
 =?us-ascii?Q?crh22nzrYfM2MbDYXf2gPHzwlmjnCBHzStYvIudi5Dr3A8LLV9ewL/OcZYI4?=
 =?us-ascii?Q?itGEmp71kvAYqdjDkl8MtLkq+8yuWDEjUhW+Imv9aFxAzgNC9MAFvfVEdY8P?=
 =?us-ascii?Q?9zcRgub2gbycVxCTLkN4hf3UjvvQcD+UHAxArIeL5rCLRT4s3Gio/NUuIMrT?=
 =?us-ascii?Q?uQPhiAuEFB1p9Sg9Tz8HzjfjWY7PVmN4HLo4vLGs8WrseTZ7PiMHxIvOEiX8?=
 =?us-ascii?Q?beRO4CKrYhbi3QDFaQB0RPz4qXuwNyfUnr7uJrERm+CaTrSopLG2kffHZZpk?=
 =?us-ascii?Q?xLlopSsLPIhcK91dSkzRBetI3ldsrnBkYBfK7boEY/nFC1hXhffewsp6FaNv?=
 =?us-ascii?Q?otslaXXfIzBVpCkvQKD3EVaPde9NtlSBAfGtJx9E87AO0ZaSbirq8UBIKy2X?=
 =?us-ascii?Q?Hxw5r6uKjJJmg28dyIiBP4iBtonF5GGnQrJB926DVVo5r5CFQ4Y0YURd3yS1?=
X-MS-Exchange-AntiSpam-MessageData-1: sJGb/Tb6KV9/Lg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 128f1fbf-f423-4419-8cae-08da1de8dbfd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 07:31:58.9447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eaXBCjRT88LRz09wYfJjN9TA7Z+JX2kf2jGpOjyFMJaiO3tkqxVHKkbUtrnVBMt6mdt4L2lqTbEtXqHZWM9hLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6871
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13.04.22 17:32, Dan Carpenter wrote:
>
> Bug: buffer partially filled.  Information leak.
>
> If you return the bytes then the only correct way to write error
> handling is:
>
> 	if (ret < 0)
> 		return ret;
> 	if (ret !=3D size)
> 		return -EIO;
>
You have to make up your mind on whether you ever need to read
answer of a length not known before you try it. The alternative of
passing a pointer to an integer for length is worse.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

