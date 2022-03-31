Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3B84ED76B
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbiCaKBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 06:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbiCaKBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 06:01:41 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22B957169
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 02:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648720791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w/BiBiP/2Ao3hDghEXVuNRaUTRaOzkVRlqz5lDFvGqI=;
        b=Q266EWpi5phR0iAF5Ntw/5FnpCiYbeBJvVQbbbs+VARCH/b6laf02lB5BzqkKNUpuAhBp9
        eHNMsZGkD2/O9MDf/bvWHNSNZvexo2XL/uqHnzCOhEHZ3gVAH7HuFFszj75LLCJlKf8WIw
        yNlgdKs9eR2Jxb19A3T0MtKCMNIpiEA=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2055.outbound.protection.outlook.com [104.47.0.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-40-_bre--9WMYG7_OvjkmtKtQ-2; Thu, 31 Mar 2022 11:59:50 +0200
X-MC-Unique: _bre--9WMYG7_OvjkmtKtQ-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRHOslw5gVF0sOtmuO9WCs79DwPGdPh4fpUsHmeKNoyvtGFBc2KvY5aYXdcU9xIYZiMx1bOtenp6eGPRgB/tLgF5APdTfxzHepGQe+V7e59FGQGqk+Mlds4frckL+WT1l+pGZyPQiW+H4p76/1PtWvJ/7Cur5S9YNVFR3+dZZfHtztpYENAIStv44RbOPEEi++bA9WIrginLke2boVd7KHHmT0DaVco2mLClLERWyb99mfT07/ZgEwr4ytTgh3D/WYI648ezBGw6P8xJzBXfVT34r2PHyAvzV7XT5MBZB7UBylSd7OKZxTqiclpZIB4LI4WWCLaF8j4EE2ITAnBqzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=azHdu/rv7ZY33bGgxpOpVwYLWhh1UCo53xFDX9SrCcQ=;
 b=XZLsESUmzvJuy8szEwreabxs6NsgV/SvMo5ukqhC3GBVI/UA0mwUcgvyfgbX5Cxbjzxp+mQb7LQ13nX6HMkvrcm0szi/WCzIO0MdeFyi7j9QYZvNY/FYxbQZYmRjbLnDrbw988Ga6yOyxidbvYBCGYUfZdaTHTQTZTKV2X6hcY/mI6UjyCLgQkDMyEwKb4KeIfO2sEN0rEEmKzsF+8ejDRwgFRLVYVpVQxdcXq9NLXWJxTLHjHI67dmOiLI5dkkmW2ZY8g/AInzgzwcBc5ljxKRPfBY71AL+5ThzvJhNtTYXPzi2Wh/pbHyxMhbw/hsXCX9lUljGPFi1bk0FuPmLUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by AS4PR04MB9410.eurprd04.prod.outlook.com (2603:10a6:20b:4e9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Thu, 31 Mar
 2022 09:59:46 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::dccb:257e:76a7:c42]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::dccb:257e:76a7:c42%7]) with mapi id 15.20.5102.023; Thu, 31 Mar 2022
 09:59:46 +0000
Message-ID: <8f59f82c-e1eb-f8f5-a646-189c0eac94cf@suse.com>
Date:   Thu, 31 Mar 2022 11:59:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>, Oliver Neukum <oneukum@suse.com>
CC:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20220315083234.GA27883@wunner.de>
 <20220315113841.GA22337@pengutronix.de> <YjCUgCNHw6BUqJxr@lunn.ch>
 <20220321100226.GA19177@wunner.de> <Yjh5Qz8XX1ltiRUM@lunn.ch>
 <20220326123929.GB31022@wunner.de> <Yj8L2Jl0yyHIyW1m@lunn.ch>
 <20220326130430.GD31022@wunner.de> <20220327083702.GC27264@pengutronix.de>
 <37ff78db-8de5-56c0-3da2-9effc17b4e41@suse.com>
 <20220331093040.GA20035@wunner.de>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220331093040.GA20035@wunner.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM5PR1001CA0047.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::24) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d46aa0c4-a005-4b62-886b-08da12fd2fb7
X-MS-TrafficTypeDiagnostic: AS4PR04MB9410:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <AS4PR04MB94100D8A8A59094B69AB8E8EC7E19@AS4PR04MB9410.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DyIAHfeCrrdxBHQ4ltHJoJtU6eUkmI56E97R2n9HvwYQ96pmvFb9T29MMl30RySc5rTo7CD4KbKxKfPxaW6ZzEjH0t5Yx2drrGIOnXVwGprUw1TDD/ZgRNy7pJduqRyFvmGawLrCoiHhQwYsQ4+lY7E+5Tg3I9eWlz26jZI9AdSaEFT15nx6bfU1QWCaeDAzkiMpbQ5xjfl65ZmMlRli3KKU+AZo8Z8+TQq+O+Mq4QvOwac3XkreU8o5ZMnIikc7zvmiYy9rp+JStvKUvFi4sSphJioYGH4ygI0ssyZx9v5oxsyVitV99om4O3HWDfpxTGt+ucyy6brOXifOqzeJo3/RtPy5dCLVp5mQvYh24u9PB6QnXmwzwbvJT7mcQGGyMB/fiAPQTgi/woa3re6ZIWZuIcmO6ZdESrjnEQJLoeF17q1dZGwSSFlsqoRazpmOggjfKxLK8NPnzfv+gK4fEscZHnslZIQpK7a38kpRY5KDb1wmbkReN1UoABsF82MyxQOTN+RuEGj5jdrdR3KD7nqE7pOaEfL4Zrwm/jW3K+Ucl3/X/6KpTaz7g7Tph2Xjd/btdWgfghJ8i0ircoG4sXEFNTh7Tbl0Axnk2lg0L2u60D/etaWS2QUoQ4L8PPOLU7bkoyD+tbLqZg8hwtUt3gm8CG7oSwL7fvZbyLpnWl+VeWncaBCa8sKbLY57vikGCV/hTe0F2SntigyA+vMWNEox63wzpymvZWQ/1TizuzyiIcXVy3XmAEGyHCeXJgMuIMYecrTF9gUVU70ybuFvlU1aof5U9TtPkFBjgXu7jv4GtrkrhwGf28DtR7+3hXjU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(966005)(316002)(38100700002)(54906003)(2616005)(36756003)(6486002)(31696002)(508600001)(31686004)(186003)(110136005)(2906002)(6506007)(53546011)(66556008)(8936002)(66476007)(5660300002)(86362001)(66946007)(8676002)(4326008)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?06Kf1uX9HUrOict/mMnN4rHtA5hNtZsWnlpop5amsyY5+iQSs2MwYKUN1wfk?=
 =?us-ascii?Q?pwmCNAZWYjtsCu2hH1S3ZeUGSmB8ncd0p4inV0XdrAOnfl9wp8qLwu7+rNET?=
 =?us-ascii?Q?O6RfUemLF8wmd5/vhqF5vDXdrp3Y9mdEG5mNTzlNjDjY3qkfSeThDpw9DFBm?=
 =?us-ascii?Q?DGknpP1IHKM3sE725HoZKdLb51Br52FwJQMfcngmTIwSQpooulPJ8WJm1Xbb?=
 =?us-ascii?Q?XX4PurSMw9kqaF/bfLh+V7ryIWGkjGrqEdKqrbmCwOZhOsendKhVq7Y61uFW?=
 =?us-ascii?Q?pxGCUFh0hqUrqdDfUfrsWiu4Yc4KcBSzJTSRNBVo5WlKVMIQlAB0SfKdp3yv?=
 =?us-ascii?Q?V6wKipDLD1C3tHZmImmWq5kqNQeOK+EMLRlCMqITrefxGpXfm9JSenjXl/B/?=
 =?us-ascii?Q?/xtKTQRZXIEz/Mcd34ItsFx1iF6zFUYhamwhVriKpoRgslOceVLC8Ba4/LI1?=
 =?us-ascii?Q?Lez41mAhzpgpkFE/HN73GEXky0YQNbz4lAgEidUxTkmtY4oZRwSPEzNrJfeD?=
 =?us-ascii?Q?0li1kAuDV3SMP+f+WIjD8jh2lBs8AcOFpyII29AKCLxq4jW1/SZ5dlOH8Dva?=
 =?us-ascii?Q?V/pgtHW5rAwnuCyLOZVGiLkHVncmjLIIQnlq6eDsraUdGs1cLk/Dmx9dgFoy?=
 =?us-ascii?Q?rSmoLVNAHDmEItlXKu4pwpt35UUFrLYOJBMjaQoxmax5FVt6qmY36liKCihC?=
 =?us-ascii?Q?w9cJUDSKOcc4nLCKJ+vK5Pp2ZiGSKJChncBj4lBH08Zw8x2uYHe3kKM5wPel?=
 =?us-ascii?Q?jmdCJVDWpnmMk7l+COwHgOTnpV7vgMFZPA4tKlLWr+OUg+ZCnkF2jI3zSkUp?=
 =?us-ascii?Q?o6NgeYIMb2XQETjKURxIkik6JScBWZI4cSau7VRHzRaQ5oM6erQlubn3tlKJ?=
 =?us-ascii?Q?Ammb0bRLi+lt0NyeltQcqS7c7O/pq8a9CnmtJClKGElpvpxjgceH33DGXfrg?=
 =?us-ascii?Q?Ip9Cx1lDJ8HKqmwleg4DR7/mz4RsZEmpMfuOFFbDzfLib6A7mNVhIyQiWXpv?=
 =?us-ascii?Q?QcjsCp1swcRG78NeVwMRZ2CgHKdLqqH9dsCvVUBsxZTPVjSNbOpEZdG374dK?=
 =?us-ascii?Q?fSUzt55M8p1EAb7wqIwHaGrvFFSw+cZx+cy5g60SEx4zvBt5QWSJUbA1g22p?=
 =?us-ascii?Q?DTX0J8EcJKJOWMlCZfcv7w9X8LYNysCYfuozU0FcLIcrbHvrZUqoGb2JN4bb?=
 =?us-ascii?Q?GaZZkQMLj91EppgiFt6L/LqLsPCb2Mi3ZEYCdxZ+5nWMAUDVFVPfD0Ir+Ab9?=
 =?us-ascii?Q?S7c4mmp0Zc2sYl791WZ0GIVLqD7Qjt+PFXyOA1HfO7WwhwSEjhA+UMH9D+vy?=
 =?us-ascii?Q?JEnSbLVhSjYQOMVKkM2A57WGwD/Z/NoaPJOVWGBYMfc2GFTtaQRWBriPRZXO?=
 =?us-ascii?Q?zKUynX742P9gSWqDwPRc4aMEcUkTtwB7/I193hrJsqDzLXeNEpP1lpfhAe+G?=
 =?us-ascii?Q?o+/mysTGt/Nxdcbr6mXEy2/ZFxB6D1AoysfUgZVvELN6hyUujkXf3PuCZj+6?=
 =?us-ascii?Q?ViSmxZtJDLlYYlkvldXc6wTNAtxknqaC2mwv10cYK5ygSoMR1V+IaMG8gJ2y?=
 =?us-ascii?Q?03/sCKg31M0DUMo3PpTCkZXRhgVIwxfBlzM2CORY2Kj3g0MrAiJJO+nSQ6HZ?=
 =?us-ascii?Q?ejL5vAiZbJgmWiaCSne8vof6GFWVOO85HwH7VQPDgghnvfN4l5R8cpBqx83G?=
 =?us-ascii?Q?Rncw3hN9UlK3qIvBsXgdzSU2ryZRrXnE1SVfs2yI3I9QChdTqBQ19P5ZZ7Ol?=
 =?us-ascii?Q?JvfP6c6o6FADlUqptEjzdCDtXtnJ0314oGURUo4kUX+lz8UU2/B4QeyAXVji?=
X-MS-Exchange-AntiSpam-MessageData-1: hvenA+TuTrB1dw==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d46aa0c4-a005-4b62-886b-08da12fd2fb7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 09:59:46.5116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6uT26FjjquSPICD6uSJwiaaeUEhGnjwI5SDktMN78I2o1EHrgYBIZMo6hd2nJlwh+NyIhoXvDI+nrTiRqKDgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9410
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31.03.22 11:30, Lukas Wunner wrote:
> I propose the below patch.  If you could provide more details on the
> regressions you've reported (+ ideally bugzilla links), I'll be happy
> to include them in the commit message.  Thanks!
There is no bugzilla, but the report can be found:
https://lore.kernel.org/netdev/CAG48ez0MHBbENX5gCdHAUXZ7h7s20LnepBF-pa5M=3D=
7Bi-jZrEA@mail.gmail.com/
>
> The commit made binding and unbinding of USB Ethernet asymmetrical:
> Before, usbnet_probe() first invoked the ->bind() callback and then
> register_netdev().  usbnet_disconnect() mirrored that by first invoking
> unregister_netdev() and then ->unbind().
>
> Since the commit, the order in usbnet_disconnect() is reversed and no
> longer mirrors usbnet_probe().
>
> One consequence is that a PHY disconnected (and stopped) in ->unbind()
> is afterwards stopped once more by unregister_netdev() as it closes the
> netdev before unregistering.  That necessitates a contortion in ->stop()
> because the PHY may only be stopped if it hasn't already been
> disconnected.
>
> Reverting the commit allows making the call to phy_stop() unconditional
> in ->stop() and also fixes the issues reported by Oliver.
Very well, but what prevents reintroducing the isssue this revert's
target was to fix?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

