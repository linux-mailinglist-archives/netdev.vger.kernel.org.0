Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C1A485B11
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 22:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244626AbiAEVv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 16:51:28 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:37403 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244766AbiAEVuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 16:50:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1641419403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UNglLiJ9ujX90tZZw7fy9GgG6xXkUm8z4InZQQimEfc=;
        b=Ffxj/MTjD8dK9+jnmOHVajJ5WG1WqGnqeuxgwswdT3PjYO2UfKU0qgIJxvFqAeIksR2HoI
        wNq5zTzIEX+wGIcGZSIOtkpW5En/bwVwzBasbfBxFUe87tkVB8IyT6Cnbj95h1W7Z8+jKH
        qj9un6IyxiMdJ1K8PNMOnRYtBipgHsg=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2052.outbound.protection.outlook.com [104.47.14.52]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-11-hCSwGQ0kOI2Pq9rpxlNymQ-1; Wed, 05 Jan 2022 22:50:02 +0100
X-MC-Unique: hCSwGQ0kOI2Pq9rpxlNymQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQdAdQNm2UmnaxlDPZvCQJiDMG1fmw/asp3GN+FNGbWs4YVktINRyghGkE4dcgYULEnAEdBVuBk2CuBsEGKetUZIeDLt1b+SJhadnGPmYi4iYd8wKF0AhRYCjlmwgz3WYJbHmpkralNv90i+jlLL9DKzVHfDF7v4e03txnD2/GDXL46Xer/VCOUs/MAWqsGtpB4DAfrnXMs9fY9ZJt0ueorzu/eGWoyF8dNvO9IgdRV3gzsT0pXZgyaThYc/Q80giXyX7uDs14tsAsB8BTvQQAsdLuFgaG8hiuFDiuYHi/WWDw74D6vf4CyCxA8ZG41iUgBnoqYSEpNN1vxj4QnM4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7gfeDuAfKYKLgcO378LJc9t+B0bMqNW/dfSvF25nLD4=;
 b=civdlPGcfTcv3ArpCEkztPVwVumalhua0E5OBs7M2Y7UxotwHrQxaXZoxiPOdcEmlT371Tx3Uwp3ZmRpLuE+TQ/rZkxF1exCrb6PBzssgzXmB0seBgnUfSfEkfOPOYQ7FXGabIb0LTlbLMV14gtPWlEtBDQKKD86DpvTG6p2yr6RMF/Jcd+s1pRmehu8Q2BXiRQmfAHugtLKwnsIkIhgV9fenKte6MaT8Pi905PDdFTvgE8SAoU+WzpdsXOJ/hGRrFSW8tNzjKUXWNUrQU8105aLigkhW90+OiCPpYLHi3cASpGCJudLO+h/oxxq3gdg7xMZDVDhh51Djn1/ofV8+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB3PR0402MB3884.eurprd04.prod.outlook.com (2603:10a6:8:f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 21:50:00 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::e9d6:1be9:d046:af1]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::e9d6:1be9:d046:af1%7]) with mapi id 15.20.4844.017; Wed, 5 Jan 2022
 21:49:59 +0000
Message-ID: <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com>
Date:   Wed, 5 Jan 2022 22:49:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Aaron Ma <aaron.ma@canonical.com>
CC:     kuba@kernel.org, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        hayeswang@realtek.com, tiwai@suse.de
References: <20220105151427.8373-1-aaron.ma@canonical.com>
 <YdXVoNFB/Asq6bc/@lunn.ch>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <YdXVoNFB/Asq6bc/@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6P193CA0086.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::27) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 111ab59c-c479-466e-5173-08d9d09551bc
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3884:EE_
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3884E2A79C03B154CA1A025DC74B9@DB3PR0402MB3884.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w65jSlGXVRVY8b/eySdlWzOIdUOZ1nvLLgzmf5epfnOvw2kaqQj9ysQr8D7ZmAV7HHH/s9mv9lOL7bizzLrrs1NZI6Wyo6w4hxAZxEv1cpgY2IPH2jgZuw8LjWjbeW10yjPp2Vlwa8GI+ubeQARaK7BDOtIKSuevFlQpIqbgpJCS5oRCrLJFkPF6VA6R3+VsQR2+yH1Nk2wMmN9bmyzXlRQlPW0HdSOnKGYyq0hNYI+3YPVoQanBLbKof3hQcHfqKBFJT3qqTMl4w5D8o5xFdAyfbvxWvMjdZx4MirJd+PNM2i0PhQsmz9SAemxDACuaqFCbHpQ8bUCfm3f3D3LF0Vg550/U3r1SJ+f75uImmpDI1T3BAx5OKNeqrNQmSqEW5rxqHNdScvICrPkgkmwr8yYmOQ0MbQsVKcFsMGzXdJWfDTAdmefyhP64bduTQfziqofuHo2uDNnITZ2/ARbbIjDU6IYkG8WYK+K5vgoTlL5eqSJxiOTApc+KNntz0UAGwdoTeBbfNYaf87HMtNSjms14KspCGQHkSDxPBChM/ahGKaE+JEM5Re1vKVyGL2JHm8GbNhy0Y8H7IXxX/hZ5bvMWrDnC02301JVl5NsM4JIjM0yXwutJCEPSLsqKzZBbJl86YIE+ifHUR6YekdVjwsFo/l9N38yQEOG3ebL1J5z85kG8Txcqqkb8K/HF1xHDG0LtbRuhKDrt5CE/4E7/s3ChjVMTy3mgp2gJTNBu5as=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(186003)(110136005)(5660300002)(8936002)(8676002)(38100700002)(31686004)(6666004)(4744005)(2616005)(31696002)(66556008)(508600001)(66476007)(6486002)(2906002)(66946007)(53546011)(6506007)(7416002)(86362001)(316002)(36756003)(4326008)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3JuAMIrmzGyTu9uOjZeoYj/oam562EW1lb6F/fVRxtei9Lk4MhHmsVG8nq2+?=
 =?us-ascii?Q?6zNavuPTsbtQNumqKtYV9GklfaR4AmFT716vV9mPK5cRjdxWr6mLSVneA7UE?=
 =?us-ascii?Q?Ds9+ks6PX5hchuwc4BEniSlXtz0+E66nWNSFMfOh4N97W9I2PtNKI8F0BQAf?=
 =?us-ascii?Q?NS49psufuYfXyPeEWu0g2j56cL0Rg6syvVtMsU2X/BLN8hVos8lu8lPYgpoM?=
 =?us-ascii?Q?xpVzj/xAoF05yokF1LYlPaheLrH7K0gaQEXdqQRcu/l78CPwTQZV6QoyfzSD?=
 =?us-ascii?Q?0Ypmn/MG2YaPoMd7y+GEg0NUMzovV4L9nEFsIDbwo65YoxVf+hqLLYV0waaH?=
 =?us-ascii?Q?h09Y+0gc3d0bfozn9+iuzObknzJ3TMyGQPPeq59DEJ+Ayqqe/2u8qExTduFz?=
 =?us-ascii?Q?1iM5IZHOXbN+9Ygc9zY9anlYgDEcMNk+6lTJQeZKSkkMG3z5SGaZOMp+chpX?=
 =?us-ascii?Q?r4G8CgbkJAHsbGYkqLQTAt13znBvOOerRwl2w5ev/N00xXcCxOT3rtzQZVot?=
 =?us-ascii?Q?XpEeBvjaZrnadzjeZ/77Ka6/BEWw/kBTtGhdsIh2jw4b9cHZWOZsN7GbLcbf?=
 =?us-ascii?Q?e66EK/7c6R1uBPkyfHRmLnJ90Hk28ogNbr/sM/DUrynONIn6ZJj50OF4Lqli?=
 =?us-ascii?Q?ko3VG6gXeyoJvHJDG9B+a1Kwb4OBzHVOfcmva6WDvzwbOIVa+BS2Ij0hqKr0?=
 =?us-ascii?Q?dbuMpnj6aeFM8C8Rwd6VaIvRnbYE8YQ6NbQpqS+03P7gNsaeFqdXlJKaEa4w?=
 =?us-ascii?Q?LVRm8M4qR/RV37LccrR6OX5ZLw9AS9r5hO1hN2mWRT4X9vum40RzRyYCT7Kl?=
 =?us-ascii?Q?YbNQZxD1cQ/yfzC3yLJGpjgmBRwe1i3axMIxn9B2w1gKYZuG3rRAKywY8n6F?=
 =?us-ascii?Q?wbczyaTDise47z76M750Vy6P5Bw/yPlKePBuJtF1rkx44kQMDM8N1THVHu26?=
 =?us-ascii?Q?P1q7+CWTkatLlS8vMt2WMWY0ijBGZiba0xZi3eC/NLqKWB9qepxwaif0v+M8?=
 =?us-ascii?Q?eKOSl1MKYiqD3ACszkpQvn/Bze7RG2UtJJOC9MC3diydbH/XQX29wgDEQ3wL?=
 =?us-ascii?Q?TMRt8pCXGA/xHe0nycIPMmTtq5v7YhdNYGsTBjT48BW4KzOTDlQtywt+WCpg?=
 =?us-ascii?Q?DXACeASn92tuMbh+qCuYbLqBLy7em8xkjOif+iVXjJK+mdeUbRywoctE2Lr6?=
 =?us-ascii?Q?dFWBxfffP5AGCyl2epXj8RyvtdRiP7vmUabs8FuAw3LlDrYi2LO/XRgFSmyA?=
 =?us-ascii?Q?N7Gi2YkOCPFEBA/gohIhx6/eUg3hFwoLeHNJfp3T+pHpnRcCcsm6uBRe21vu?=
 =?us-ascii?Q?/beIXRogHe6Nv5zW40w4F6Pu2bn1tQZP+E4qolwh17X/bn1Ky1wcmHMRncRg?=
 =?us-ascii?Q?7EhfYIZydjvYVWiQtjOLfHQ/PYdMY+Yq5kqfeXUInQ7tuyiYTZpQmmWXk8Ew?=
 =?us-ascii?Q?PzHQEfJzplyOnMP+dDrN1C9GoRa1/YhGYnmV87yrA3771FeE2SJcC9XHcNVt?=
 =?us-ascii?Q?tOU7O2IgrZWWY8JPVugcGYQj+R3PHoZ+t9Upi308+osrnoPpd4MTHlUCvQb6?=
 =?us-ascii?Q?LhlmR12Jk5DRRuthZ8HrTSCJgMYp1Q1hDmwbY5f3aYoIx7zYFlErBctzT9kt?=
 =?us-ascii?Q?JdKU2Oo7oPbdqY3yKWLqJKwiP96YUQZE8x70YpijlwCOf0donVm7YdXGx1eH?=
 =?us-ascii?Q?NUlwD4aSErMjWvh0bAHqiIRBcIE=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 111ab59c-c479-466e-5173-08d9d09551bc
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 21:49:59.1855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AMRxcawe3JnETCh4fa8+E4KP0+YgHT+jHrb6Bz72p69wM21Q2C4DFBm74sujWWn+yCEdQt3KAVZ7wJPt3yc0Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3884
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05.01.22 18:30, Andrew Lunn wrote:
> On Wed, Jan 05, 2022 at 11:14:25PM +0800, Aaron Ma wrote:
>> When plugin multiple r8152 ethernet dongles to Lenovo Docks
>> or USB hub, MAC passthrough address from BIOS should be
>> checked if it had been used to avoid using on other dongles.
>>
>> Currently builtin r8152 on Dock still can't be identified.
>> First detected r8152 will use the MAC passthrough address.
> I do have to wonder why you are doing this in the kernel, and not
> using a udev rule? This seems to be policy, and policy does not belong
> in the kernel.
Debatable. An ethernet NIC has to have a MAC. The kernel must
provide one. That we should always take the one found in the
device's ROM rather than the host's ROM is already a policy decision.

In fact we make up a MAC for devices that do not have one.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

