Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3694A84F7
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 14:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350733AbiBCNQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 08:16:18 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:35742 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346060AbiBCNQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 08:16:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1643894175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t0bAJLePcdGYk6kVK1wFGIIutK9iYBe2gVZ5EeZGyMc=;
        b=FDZV8R7sIGyYmRIFAwqxgw2S1//TpVF4Aw1aZNPD0y1Hpn9BGnNXlv3Uv0Ic7oDDfpHQBt
        pp5NYo7NrW4jE7Ae69kElsuo9bHdVoWhoY7GqmsA6Lqxmfw9+AyzwvHSbA1JzcKv9/QNTh
        kkJqyf0tGZ2uzOpKb2MGzhjm9aJohPs=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-32-xX2szb2sPUeDts6ccF-XEg-1; Thu, 03 Feb 2022 14:16:13 +0100
X-MC-Unique: xX2szb2sPUeDts6ccF-XEg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSLf3w6+edWquPfzZeZj7Zp/J6J4kYt9m0FCNrJfxpd55Qu9KJmj1Mq2hl5/enopQOTHKF2Dr7ndb3l8iKlhutWT1p0P6i2r83chwD+geRGry/dbusEtdve7XOcrEEDURUGTO0FdN0TIzyb1+LisYl2rc5jgDJHa7gD+EA+tygXj7eI7JCH4JG449KTT048mIuvyq9ssrspVR9V2ievQ8CItxQlapGWbIEg1hhtX5eT0FVduDiqVPhRPlFVkKJBOUYj85sUeIP75B3fb61TrE9NSme8vnWDPFR2dbilpwcJV+HXNc7KpVbJEDQ4wfGrM+oye+hw1TcXvPc/ABdJDdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z9CwvqmvrZiFXSyBnnQu52l+0zrpKgp3U6DTw0lIq/M=;
 b=JTXrjV8gpNWCs09plhXqlk3CDOdxf8eMHgUH4EG3mkHPASw/oMxUMkqcZyooqog6ydFmcCwszlXtOHIxxINgnph8rXTRvj4UJNd8ysq8Fe0xfpdFQjLUXhwYjpi5ut82XnxFkiZR2jT36fClsrCdqWlJScY4lwgFqh0zaMK3QXFbsDChdyUVlNfE4rBGPCZhmDuTwRCxNXmvbAMFQKu0kQWqti5N6Znukqmh/UrAFh3t9rQORmpEmnc05Ln0OO8HkJXzUew4fL5v9Q0FDKHd7vHZZ2OT5i/J1oyLTBRlSx8TuIuFEoohHE7fZ82yfNwPFtmzfadNwusgdRafYGfpKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB7PR04MB4380.eurprd04.prod.outlook.com (2603:10a6:5:31::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 3 Feb
 2022 13:16:11 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115%3]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 13:16:11 +0000
Message-ID: <39e8899f-f5e0-c57c-ebaa-f3303a716d0d@suse.com>
Date:   Thu, 3 Feb 2022 14:16:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v1 0/4] usbnet: add "label" support
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Neukum <oneukum@suse.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <YfJ6tZ3hJLbTeaDr@kroah.com> <41599e9d-20c0-d1ed-d793-cd7037013718@suse.com>
 <Yfut/RbMAoaIhx41@pengutronix.de>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <Yfut/RbMAoaIhx41@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM5PR1001CA0058.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::35) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7100e970-acc2-4741-75b4-08d9e71758c6
X-MS-TrafficTypeDiagnostic: DB7PR04MB4380:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <DB7PR04MB438038D1D4999BE5C6C2EB48C7289@DB7PR04MB4380.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOMRFlw0uFciE3+4aBIV/icxc8A/lVFqNAkduQljpsQx2Hmp8ePE/D/R0R0q+s/p+4foLopY2v3KhpSRULTLyjk/n14HEF4hXOcpuXQhZYIuXqv79MQztf7LZ9WX8FJbkZvSNIMELXYKb08tlX3/6cPKKERsvzXXprm1TO0VfiC+0dK2P98DkepcHBf6XyAhWFTkaVXMXfedUIL7ZgQhtZLoI0UH2aToKr73O4sfaRmRNiEcp3TkYJ1z5YqWH0+kTvKqG50Z+FMwi9sEWNXxOC9SmT2rp1CdqrQfI4qVygEWRVB4WP5QjoOL47p9IH+/0z9snnYVUAXmsm1U70Y90XHmOUFYxTS2L3pbYS9Q3cBJCngTI4mzLMB95fslP+mWCA0//0O89qNilq1jV0s9REYEO56TmhlaTefAnYx9AnpVtHWZzV/cA6nsasimMxrNiAmI95uaHidAuGec8POLtx1Fz+cE2zo3MgWB3pNl2VeHehDF0Wyu3ioSmBMAmcGdzIP+e3N2vZVdQZiSPxHJreZx2ZyWRQ5/4LL8BiF4MH/Ydve7X2Vg9mG5xhmB7453aUaXpolpSc45jtPdMUpv6OSkXxV8ZiayMqfdClW7qXrTazchyET+XeEBmTEKdwkNvlx3zuuyT7/VYF5GyHqdleid7IzEpt2Jx4VAv37wLWLzSZLOUo+rGvgsubj21orK+TyARNIpczs6vyxt/iQVPUkmtldKSeaviVk9ATXJeK31Zic5OafoIIjRXWvlgEP+mHdxSYKVFzvZaPyNhsiULwaPKRFQ5fCQROk6gG42zxm0gViZwZi13p7qPoOTQntL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(2616005)(186003)(31696002)(53546011)(86362001)(38100700002)(6506007)(6512007)(36756003)(54906003)(8676002)(31686004)(316002)(110136005)(5660300002)(7416002)(8936002)(4326008)(66556008)(66476007)(66946007)(966005)(508600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eaqRFRLtgnr/62zPvfpJj2TW5agAv+o8WsZP6LXV/IpSRC6c2pWJ8fmU9HBd?=
 =?us-ascii?Q?qD+lVv034fRMffCwBmxyI0PcQLG2Rh2pLY6t+0Jh5OJtfFIszbUoAfsv2z6H?=
 =?us-ascii?Q?66gJyfQLPTtpo2JlysnbOrkRMpxTyjCaXlituoSPmrsyA3/Vqo06bek+UOUl?=
 =?us-ascii?Q?Sh572Ao9RkXOz62qYx4Y2oQpQoayYvJ+MV7V8XY/zWALTzKsYwmjmwF8BJ06?=
 =?us-ascii?Q?dYWZLrezZRActmmxwNdwgl8IEGOEuPkJQ45N/01xAqvWM0XvW715oFhDdXzX?=
 =?us-ascii?Q?6w2jLwqzsOIcK6CKOXNj3SXR7zboKW5VVy2Sr8tAZGxoZ9L9NvuUJJKcE5Xk?=
 =?us-ascii?Q?NzdyGRqbI6Avy3qQfodAsyf5qhxgmROYJT4ps/TkUwjdre5RKHwRmN0psvm4?=
 =?us-ascii?Q?Yc9dVzmy4nlLP1Z/5u7DrAsXGpDzfKxD5QaWuv30JAQBXje5WsEVAp3ZiQAg?=
 =?us-ascii?Q?BqzVzL6KccLmaXwj+ookIB6ACPvtVgUSXBxYgRjODpb1V453PrIDD8QcJMlE?=
 =?us-ascii?Q?/KN7yrLNzaK1xgVbr4+1cowb7C3W0FHtyOtl7JNI+hOPVKiM34SQbRviSBQn?=
 =?us-ascii?Q?PMVf86nUBZY2OEN1oruMxSOyanUc0BLLC4Hm5z7jzCFyXtEObT9OzvF5sh0a?=
 =?us-ascii?Q?8heBnbl2+vgVhBml4DUqTBKB87bkcBUGmydYMezq9vDeuOAmtykefglz+ywG?=
 =?us-ascii?Q?i4spNpGxPWJVhi4XV44xEPdluTvhtrpzgQRsnYqyJuaGSBNCHh69j2jsgWUp?=
 =?us-ascii?Q?jIic8EBNtrFeIXVU+Q8qbkInJvjCGM9i4IMHbOLSLVCW26S1VWp9SfiAPZGB?=
 =?us-ascii?Q?rlcSUoCsg0Z6dgzzdhg/sF6dChKqukdINxObdOyIL7PbRlfr6N/SNL8Q0xO5?=
 =?us-ascii?Q?+fJPzuKncJXk/SFItuPEaLKTIjc4fJmrWv7j1R7SrbYAepse85toThgkwnzT?=
 =?us-ascii?Q?oae2VOtGRoDORPEIx+qsnynQyd5JPX7zzdXJmqT8ipg86xAVqwD/QD7j/pqk?=
 =?us-ascii?Q?tapC3CizRzG5Q+gDzJw9BGle/+VC57eohrgopexpmlRsuPK47IYg0WI7iEJJ?=
 =?us-ascii?Q?U3JF+wwmzRqNLiX1CknS92wdVw420X4jLrQMdO67BYT4Yd/H30yRnHTJmYkI?=
 =?us-ascii?Q?0O4WIej5T7/8ti7q/N4gw2fV6YN/iaW9QeF1y8Fpapbr+EM0xTByqGajwbOu?=
 =?us-ascii?Q?k9oJWiXYBTsDQB03787naQ+puhmcv1MR9NW8ofJveNnuR1n0EtziGXvq1Izf?=
 =?us-ascii?Q?hxoS+C6Vi7qeB87+j0wuxupUuBT2ZXCefpRzgwLTr725RLm4sZ4zz7n85++h?=
 =?us-ascii?Q?3F1NWfXoo9EACnFfyMvDfrNp97jtc7kQXB2/aWhpJu/EGFlh6NNYP65OM4Bf?=
 =?us-ascii?Q?7HuK9KO33ZNHvYTVPo9AFwO5uuBeNpwHMx1Jb2jihb6OQTVrkZOue50eYOEb?=
 =?us-ascii?Q?CF0XFfGGU5bAOMJ4LwnYVQYNnnvvMcgdBNOVgjsynFMDHRHBrw/uFLIDVbS5?=
 =?us-ascii?Q?m85lfV/TWMEhXRZ/4emrtJDJLj3hG/lnXnTDTYZ5ZWf7oBGEX3PE6yniE33V?=
 =?us-ascii?Q?8RAp1/1CGCn8t1G1xoO3VwuuolhSk/YYCx0xo4yX1X9T/dJPfDMjqVkxekCm?=
 =?us-ascii?Q?UOz7+K+jTmzAXM8vIxCFfDHigdhaiJmsP/Bjl9E1yGUNAvMjWUBtvxEA7/74?=
 =?us-ascii?Q?fQjWxbPCCMDkid/bvcaz38SUQqQ=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7100e970-acc2-4741-75b4-08d9e71758c6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 13:16:11.1957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q0cD5boQT+jTZ9i+JVsw+v6ZWrtbokvGuMdqEslUm/4iY0DKL/E6boyGyhLQnl0iK/QhUNrDM2XIYxBfJi7sFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4380
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 03.02.22 11:27, Oleksij Rempel wrote:
> On Thu, Feb 03, 2022 at 10:34:25AM +0100, Oliver Neukum wrote:
>> On 27.01.22 11:57, Greg KH wrote:
>>> On Thu, Jan 27, 2022 at 11:49:01AM +0100, Oleksij Rempel wrote:
>>>
> In this particular use case there is a PCB with a imx6 SoC with hard
> wired USB attached USB-Ethernet-MAC adapters. One of these adapters is
> connected in the same PCB to an Ethernet switch chip. There is a DSA
> driver for the switch, so we want to describe the whole boards in a DT.
OK, so you are talking about what is technically an embedded
device with a DT as is usual for such devices.
> Putting a label in the DT that renames the network interface is "nice to
> have" but not so important.
Well, this applies to your particular device only, doesn't it?
>
> As the DT DSA bindings rely on linking a MAC phandle to the switch we
> need to describe the USB Ethernet adapter in the DT, this is more
> important. See this discussion:
>
> https://lore.kernel.org/all/20220127120039.GE9150@pengutronix.de/
And this one irks me. The USB list is not the place to talk about
how to build switches. The question here is whether OF and
DSA have features that need support in USB drivers.

I am not ready to discuss the merits of features in OF
>> I would suggest you implement a generic facility
>> in the network layer and if everybody is happy with that
>> obviously usbnet can pass through a pointer for that
>> to operate on. Frankly, it looks to me like you are
>> implementing only a subset of what device tree
>> could contain for your specific use case.
> Sounds good, but we'll focus on the DSA use case, as this is more
> important. So patches 1 and 2 of this patches set have highest prio for
> us.
It looks to me like you want a layering violation for
a special case. Is there any reason for you not to provide
a generic helper in the networking core?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

