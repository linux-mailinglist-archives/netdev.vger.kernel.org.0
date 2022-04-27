Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3295112CA
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 09:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359033AbiD0Ht3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 03:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359035AbiD0HtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 03:49:21 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDDD6374
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1651045566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tflutroB1bNmqq3SPmC2o8mHJQpQTgXTxNIOfh1J09U=;
        b=dMgP5Ay7KBcHlOHzqfyUtuVJWbwyvQWxvuD7KP6VeY4Zjcy5HGJytYmNSrts9rq4tVW+jE
        tfCexf7q1gM0xexZNX2aG3pul65VXEwibudE4DSLa4oe17/o1Rox/NWpWXZIlrzYBG+xQW
        brig0sZQIbsdJJoco0DwgqhKzgfmmc0=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2053.outbound.protection.outlook.com [104.47.9.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-41-b-huEVWKNay7W6vwAqsjyA-2; Wed, 27 Apr 2022 09:46:04 +0200
X-MC-Unique: b-huEVWKNay7W6vwAqsjyA-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGWpGTb7RXFkvzUAHLu+QrcMzN4uFioyVW83jFki5fnZHIgbvlWyocgRtL2lrU7ZfhJyKb3xS14tCZMeb/gZ4TGAWjvo4nsJ4bG/9vi4X6mYrkUq3x8/0UvIAlK+zAQd0qwatV53Eb8OHChjyF8mhJuVnfbK0OplZFha5Yzz+9iFdx4n7Iie0sof/MTXWUjzsXvjbvCy/gSjrWeLstT16lVNScgamZP0aVxKB3hlmA1AB2ty6piumxJaYqgJC4D+IgkbpeaujgoI1QsvkvlZZoKkHLKctpqMLt63GrPF5O+hu/CqAs5/ttW/zLyHvXWfRg979/z7IiWM84vH7s0Tog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DP5iU6rNwK9LwsWxBdT02kfsKzfR9tH+AMojbqgpXVA=;
 b=H20K0hFfg+d8CAg4h4VJxKWWQyQqZfzfPc3ZWcdpEanmbyJAxuCYnVd8jcDMKXWZ2ya0hVBW3VLNislsL3obtqiIZp1hcDzX6NxOoYYN9eBHTdf+JFSiPnE5czTR+q44kryW3MLL6BD+LJXDYmXxraTN7mXZz4/7bfwpO2WIgx0SYppKy4P6y+QnRLqg8+ys3C6oWoRlZI3qx+PPuRo+CoiRIJamTevX1hxdwxi3hhvOHJDufhJrjY2l2WxlbitYKXx29owKKAjvcVVBdAf2m3dFL9NS6Ub7uhRTVKPraQA4sUIHVj7B+gpE5umTUTjP/0WhKDX90fQNvHWvER+m2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AM0PR04MB6372.eurprd04.prod.outlook.com
 (2603:10a6:208:16b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Wed, 27 Apr
 2022 07:46:01 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b%4]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 07:46:01 +0000
Message-ID: <424eb715-167e-b073-30bb-9d91b8501758@suse.com>
Date:   Wed, 27 Apr 2022 09:45:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next 1/7] usbnet: Run unregister_netdev() before
 unbind() again
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
References: <cover.1651037513.git.lukas@wunner.de>
 <ca65428c57c0b15ead00c92decb9b4a01a0fa81f.1651037513.git.lukas@wunner.de>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <ca65428c57c0b15ead00c92decb9b4a01a0fa81f.1651037513.git.lukas@wunner.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6PR02CA0033.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::46) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0ed9af2-2d61-4581-44ce-08da2821f975
X-MS-TrafficTypeDiagnostic: AM0PR04MB6372:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <AM0PR04MB63720B613A752F611C60DAB0C7FA9@AM0PR04MB6372.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +rtOg7lH6IojgvUYI1Gq9QFQTin6NiMwqym5zWJLGEuMVJJQ0BMdTrPPwvgT739nJFc3QFfOktaqJYpg0DxJekPkowuYjXFjDKPps/p5jk4BJHnPK7f33uyukK0b4btrKVhczVr9psmviqCRAbox3NSYQ/3pTElx56x7FdPEshtQEiSUSVxUZDO5FeC4RgIi3bXGrvcl/S28X8XBI4NIFUCP6S5A9JSyBsPBXVKj8BxRVx10yr8wPnxflyKrrTDAuWAy4HtAtHG7LpI0qGoJkGAhzOe0SZYIG1sqYHw3PKj1nOZMDO4JD1usscntKwKf0UhYtpCqfjBRi8DqcJ6BDXAlX+AbVitsaqFiG5k2fIWV4VcY/pacQOtlkfPfq1TxUzysXRYNsgqbke3DIGBQE64TNBLKV6Set6G1tQK1OvAWDjn2di7WmbLY3qw4VyNnGF1ALKuyJSxgbhNqxfR+HxsGSbTFn+IazJkKaJBIa62hv/iKAfpp0rJrlexddH1POhPduSMDjLt5cXxaas0ntOBO48gCKHoGxwnBRxyL2X8NCVf8sewBk3xR1v9SvVNNIgKLor3Cit5Uv8AxEWRusUCkh/c8af8uJ+jlirCKkbYPWUU5twK/PwZGNCd+VEBydq6C146+RLYTlEoMsKQ2Jnz+HlWYDLg13maBePTU9mqlqm1cDGO5cwXYPNS22+MWddlf/GIIePqA0Yn3EClzIOtSa5FS1KPFmEF02NwIM4Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(110136005)(508600001)(54906003)(6666004)(6486002)(2616005)(186003)(36756003)(31686004)(66946007)(66476007)(66556008)(4326008)(4744005)(8676002)(5660300002)(31696002)(8936002)(86362001)(6512007)(53546011)(6506007)(38100700002)(2906002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K2d4ahYnsWF2+BoxvNaXkfpn6XFA4Wulc51pNMkGdvRFXI+RTcvjkCrquswk?=
 =?us-ascii?Q?4t9TTJNOPI8AhYHIaTFPLRILVDH12Nsc0eTNt3b18HhyjRACOcKTFvL4rN4Q?=
 =?us-ascii?Q?lOc6XHser7gfAMTl5JAwAfsp2b6+wDNvUz72pfGsRXX5ZkHKiRrkezwmoDn/?=
 =?us-ascii?Q?sa9E/V07Z5nFdJKK0CvY8Q9A6WHdgCnMTP3t8WT2rLi/ry90EgNvWlr9nz9A?=
 =?us-ascii?Q?pFy+ocCT8SwhaNjU6dD+zKrQoe9PLrc28No4ffvp4sKx5nltzbbVv3r5Hm3c?=
 =?us-ascii?Q?G38HsmVc4OlA//BTH7aW3bXlNdXYMwAi0quI9HejWtWMqfBsKGY2TnEVJewo?=
 =?us-ascii?Q?cTaC5Ll3N9xZrFMHh0A/5oVR/x8XbDu+aFXOUWe/bO9Wu3ERyaLLWwF6PUni?=
 =?us-ascii?Q?IMX89oSA979JZISwzCE7gXdJQ44DgkMhK+eYYtTeyeVqA1CwBDx4hck4IAqL?=
 =?us-ascii?Q?GPZCvEA90LpT+rAYOCzqjQVKoUnIs3N+j5T93vlADL1faBGqhSigN4+8GGYb?=
 =?us-ascii?Q?DBV/B4nrDpaBI4GqRcwXdaYN7oZywjDUQ3e0oXtT8HGdB77PpG5haMxlvF+Y?=
 =?us-ascii?Q?/LXf7T/F4cCGqIMPjDi/UkOg8uIrJr8F8jFwDXvEKqkdRUsuO39Yov5EbyQq?=
 =?us-ascii?Q?KS6p4WKO2F3rzCjMVx4EHp6jfAHTFbYBIRsX5U1MHTi7mQ38BD6a6h/XEwmu?=
 =?us-ascii?Q?6zjEbLBhNM/d8yPlxEPw9ET7lBhR5vEfwqKciOKnpqQ0xpOZPSU7A/fRvt7S?=
 =?us-ascii?Q?RYlhtTu+bNS22u1PE2kZ+HjJr8po0L+1Q9kCzqNiSqP55sOoDNjjen7LOaV8?=
 =?us-ascii?Q?k/YFGwX/gZAs3jRDlysXfKYrR/xaX6o1L65qCXIGhm7G6dDtYggT8B38nPPs?=
 =?us-ascii?Q?/yNL29WON8H0bWbS3MlARTG91Z+L84pMXFZ6/7PQpRgha6ULdv+34EX31Pqn?=
 =?us-ascii?Q?1VdKmoGcohaskbFJtcZoGobnNV3pFeXmwu9tYIkhjUfHCibuSKd2cVkuSWQ+?=
 =?us-ascii?Q?aDW0RbriVF1rKzKtRikyAe6PRIEdnPwopvfWttV5SQX+qLoopZNsP92cmnBF?=
 =?us-ascii?Q?VowYdaKbFauizx4WkxFPX+S70a5iShi/zXATrYJvuL0Dt0ZGtou7x88Hv60m?=
 =?us-ascii?Q?/dgBEN/chPsVV5zzIIzLgQQ4zO3FHxNYddiGymF1tYOTJKwe/oRiKXMix740?=
 =?us-ascii?Q?vKnyLF1a73YEVBGJVbELQVOdqT7d4Qak/78FSmcSR1PtyobSxdhpdxOVVgSQ?=
 =?us-ascii?Q?Hd9ArOrKl26FFgtVXdJ9kw606jRV0wrGxmb2P/JPeX/+uqDd3x9vBfaVyuFL?=
 =?us-ascii?Q?h0aY0C3V3I0OBPDxc3ZojQT6zsufP6kwFNKEhRPZdhMJMtewaaern2wWQs87?=
 =?us-ascii?Q?jg75LTCOX9IvmOq0pzDFlD+EkK584fH2rY2+fdOu+ptexzVUoxOuAW43dI0K?=
 =?us-ascii?Q?zXmGOavstws96oDAiOQ/qyF5lplDw8vJaGngvFFaih+icCcBGHsdEcSIzAh7?=
 =?us-ascii?Q?2LmIT8bciD4HXhTCk8drmQlocovtiVsEWA7Dg0zxV7XngFdSXuxuvu9Az0p1?=
 =?us-ascii?Q?oDSDi0PrJlsi/c5snEr5K95spmLQToCPimycy21l98xE761iUIedLD9kSZpw?=
 =?us-ascii?Q?4CTJQ/VyxApOO/EkMEtFhxQFxRoR4WPv07yvUc8fxlULhV434NgsShbtrBku?=
 =?us-ascii?Q?tw23G+UgkiINUTo8fWTu/hJa+WImizvdbqTWEyMr+Uroe2iKOPqkvXo56/w/?=
 =?us-ascii?Q?BPhV0jDkX54hkF2XkzwieDtxUjQvbCpjV8P1pAX2rjV8tLI8hNledIXa2nH0?=
X-MS-Exchange-AntiSpam-MessageData-1: bpmj+bK666qW9w==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ed9af2-2d61-4581-44ce-08da2821f975
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 07:46:01.2465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +lAqONi+tD9cBazloKHNG6P+b8mtN5IC0o3d1Eyaqwjk8wTpDmXDWCAZQ9Bpfxm8cXfNG4za63ypmCbxZ1nhsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6372
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27.04.22 07:48, Lukas Wunner wrote:
> Commit 2c9d6c2b871d ("usbnet: run unbind() before unregister_netdev()")
> sought to fix a use-after-free on disconnect of USB Ethernet adapters.
>
>
Hi,

thank you for doing this. We have finally come at least to a partial
solution for this issue.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

