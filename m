Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E045112C8
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 09:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359020AbiD0HsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 03:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359023AbiD0HsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 03:48:16 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EC5DC8
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1651045502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CNGYkO3ofJTmOssEMun7XiGIxBkqxfCExI9nLHQknzk=;
        b=SJ67jfBk835e5tHsM8AJc7aEUaWeaq2qmKk+bC010mti5U/VmARdeykG9R22xrVA7hXZHW
        3FjAOtYrPid74bS0hd0/oTA8PHsyqH5V+gzgAWU3iNWC1956RJuBNg+9rJdMrwFAHayFdU
        SZo0C5aYI8XBNpWQ13sg7tClnQbeexc=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2054.outbound.protection.outlook.com [104.47.9.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-30-8KHP-BWiNAGgr8eG-xq7lA-1; Wed, 27 Apr 2022 09:45:00 +0200
X-MC-Unique: 8KHP-BWiNAGgr8eG-xq7lA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CL54VrtsY9HFtVVHrZRsDVvKatW0U33Ovc1m1h8WTKbIYLm5k7oOgGXINES6PXl54XA07DXATMnXYnTTZrgdGiruWbbnVn+d5Et/Fn+wkB+cfBe0nilMoAmKuunVkzEgP1TsVVuxfMRvqmc9NOmiaeulP90sMOaND+Zpx1Wj3DLNT/Pi5emz1qtp2iWiIkGzsL+s4nllOIF2ptFpyJXs7yR4EpK4Hc6CfLV+XHIWzD/pd5iE2rnoT1a57vUBUC4YSUZlAbbTDPonhTlYHRpWybm/UuikbiERCBGJO9MP9vukgUFWoKiUnlSAQuwp6UBHc/R85pFBZm+V1fT6+S6+Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNGYkO3ofJTmOssEMun7XiGIxBkqxfCExI9nLHQknzk=;
 b=RoS7aaTHqIdD/JH05X/i5PYekPwmF1kPKZQWOM+ia5Kb9R3IDxoYS2vvKUHQNk8WF626fMqtN16E9E43GJHiRWJ5RpVM1v4vP7maCHsDeVYORkkgmIJj8+U7jMwbuiK7F2LSi6Yn9xR31VE+eQLrjojWLPPMbjZxcsiUnOJUCLah/Rkwihh6AvwbWDhB7micktP+WHg8f8pVACBWLH97SIskh8G3c2vq83MMkH4uI/jQnGSjSgxLXUlhbMGMRMoLy6ayGywE7OXczsDJKZYt6WXohqK/q0vNQ+SpLQhVSZlHvEp3lON5LNQInXITyagwsPSp7H+pmHnH4uv3jgvBmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AM0PR04MB6372.eurprd04.prod.outlook.com
 (2603:10a6:208:16b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Wed, 27 Apr
 2022 07:44:57 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b%4]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 07:44:57 +0000
Message-ID: <f332cdf1-90c8-bfd0-b019-a398b8f4e58c@suse.com>
Date:   Wed, 27 Apr 2022 09:44:54 +0200
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
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
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
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR02CA0017.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::30) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 861786d1-8efb-4b31-f51a-08da2821d354
X-MS-TrafficTypeDiagnostic: AM0PR04MB6372:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <AM0PR04MB6372F122FF62867D58698791C7FA9@AM0PR04MB6372.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ASKnlkhRXsYecjuzaXPXSUjfo4l4nhsKvNBoXkEA9Y1pF0s2Ouqgmu9d7s2+3oGsnD3zmDiN5D6e7qeG7+sPsok2Nzf1mhgcTsGygcH9idMSG19zoIcWKgg30+Nz/Vk6FgUWDSMB1xRdrmKSbUoQgEYXzb9YnZJQpTivmxBHmz+oXyEXx1/LWYP/YUoXUlzwXqXxFgOogQt/ZgzF4dt+L/rX3vAu600OKfEC4xh3ISmKtvyUALBxDlOrehE1IOCF2dvXn/WiGqKaBJn/vjutgIOLNI31FgRWLbZqXHfBTLrfYB6BgwIRN6PhI6XoyYoX/AF3a34ldwamc02eZPJr2yRkOnZvrJxu2S3gOjgjg6bUMsGoylHZOW+v7VYYQsU00TZjh5aUhHtY1Gbjzdm2hgkJ+B2NGtyB/IQm+CMKixIw4FAPRUioG7/fIHHKWTM+Wy+uIboFflayOB77FNjlRzp+QxN+I55KJa+egze5e0sNHxcrx+VwbEOp/pZzKLejWzUWCbKs1abBtluqSX7rRRHPH982uk8C0SQ5QOka1cQgfpR6LPt+AofGNM9+Jf9+mH2ICaAHrUu0T9aF8Xg89BM1EYeSPZkPf9jVUTzlRTxY/DS1TN9WSZDfjAt4hWbtAofzzudnqQoYBex8ZhymMmJZMGvB+zngYfzF3fV0TuaqFeRnzj4L3xm+fpqrte05IiXGDB/FiEKC/fKmOYnlfvtPU18t+5dBqbT2EBjO2ySY8h/4Zu6sAi41H9l8FxDDbHEx3xQ3mnMSLIrfLZhkAUxCEIxFIoItx6dWZLLDNeSfUZ5nsE4S1+numSNF/Hx4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(110136005)(508600001)(54906003)(6666004)(6486002)(2616005)(186003)(966005)(36756003)(83380400001)(31686004)(66946007)(66476007)(66556008)(4326008)(8676002)(5660300002)(31696002)(8936002)(86362001)(6512007)(53546011)(6506007)(38100700002)(2906002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHB6TlZvdlhBbW1Jems2MDVKN1dvVE9YRnpvWHFDL3NoZzUwMHpLZXgyZHUr?=
 =?utf-8?B?OVpwdFAyNTB5SUNFNGdqTjg1S1lPYk81L3ZqeEtESXJLc1kzN3BuM0wrUnFi?=
 =?utf-8?B?bXBhamNzOXV1N2dKa2hLMHFvMlV0VVRnd0pZVk0yeFhncVVVZ1JSRlY2OFpv?=
 =?utf-8?B?QVpURE9FS1pMaTdhUWhjcTB6dnlvbzY3OTh0eW5LblU4eU84WGczKzd2ZFdr?=
 =?utf-8?B?SUVGcVpRYlhGNEVDNVJydDN3ejNvRFhZKyswWUtxOS94SGVDZzA4TEtmcjJU?=
 =?utf-8?B?dzBsVllMR3JsSWZ2ZDI3MkJmbnNrWFNKQnpDbVBOelN6TFpqV01maUpRNUJk?=
 =?utf-8?B?Ly9HMHlhQXNzckNBTnVmdWJDenhtOU94M2hpSDJmWVc5bkJWOUVOMzRqb3Bm?=
 =?utf-8?B?aEtjZ0hkZXdKc0VMR1A0VGpBbGxyRGZhR3RqZFRJYXpDTjlqMUtJazZSbTFP?=
 =?utf-8?B?VzlwU2NKbjVmTTJBZmQ4TlhaSytnNVErcUtmSXhMSUFWYTVEMk9sTjh2Z25w?=
 =?utf-8?B?djIwRzU4U2hHVUtrUTUrajlHWS9CMUFoaW1wY0Z0MFJTWEFlWVNTRWNGRk9F?=
 =?utf-8?B?WDFyQVJTOHFzbXB6eHB5blVBVytzNkt1MURqUWhIb2t3cjk3dDl2WjZBSzNO?=
 =?utf-8?B?OVdkQk5KOVBiUko3UzRtSE9FTVJGcnA3cHFFcFRxM3h3WGJ0RElEQ1c1dkRJ?=
 =?utf-8?B?SEx5aUlrOU55c0hPbzFKaTNQYnFuNkdaNlZwZ0lPQ0x2bGRyaFA3UkRYa20x?=
 =?utf-8?B?eitnRlNqRWZ3TDdZSExrcG8xUTY1WEFSRURyaWMwWjhKaU8vdXRNWVczOEdV?=
 =?utf-8?B?a0UxOThBQ1pMdzdxdnd0Z0ttM0E4eUs1Z2daQzdQVUFPekhFbllhRFV1OEtC?=
 =?utf-8?B?VURWaGlpNmFIaFo4MS9pM21DK0tHTDBkVm5jUnZYaW9FbmUzbGxoVGd4MVlx?=
 =?utf-8?B?WXFvU0xDYjJYclk3RTRyRmtPbTlENEZNNXByUUhYMlFWbTFuREJiTDdYK0xk?=
 =?utf-8?B?MjBlOExaSUc0T1drNExCc0VzUzhOWUZpcGF0dTdzczZIZ25FTjlUSkprUzFO?=
 =?utf-8?B?UXRNbnd6MGNNaDRNc1RGOXJ0ZC9UdSt5cUQvRTNtSlZHWW53ZDdzVlUvQnY2?=
 =?utf-8?B?aDZhUGdpaVJvMEVYRlBOTkc4TXF2K1pyT3VsZ0thZUhWeThVTThsSFpVUzVX?=
 =?utf-8?B?Mm9mRkd3UGJKU0xWdjdUYk9BWVhRVGcyZHVjTVRTUVBTNTA1Mnd2aS9ndDhV?=
 =?utf-8?B?QW5qTmpMdUgyNG01WlRjMGdKQXNQdFp2RDNJOVcxQ0l1NExqT0tNSFFPK21u?=
 =?utf-8?B?aHY1KzUxeVVhVm4wUUVIL3dYcC9id0lnY3NtTzBKUlZjN3ZxK0x4Z3BSczNT?=
 =?utf-8?B?YW83UWNxRW1nVHBIam53KzBvN0o2MTRNeW9NQmJBTzVVVGdiem10Z2pUS05B?=
 =?utf-8?B?U3BBT1ZmYXYveVBBdEw4d0JLU1VuaCs4REJLRVRCTHZFRE5QZmxHYTZtZHYw?=
 =?utf-8?B?M2l1bjRYczNlM041WXZyQm5XUzZFZE83RDV6SlBhc0kvaEk2ZXVHakhoMEJR?=
 =?utf-8?B?TGFJL3dvVGZ0dnRkQ2R2aVVHWkJXSUVBVm5jbW9sUHFUZEx5dDhnTmtGL3l5?=
 =?utf-8?B?R0c0bjJZdnk2OWwwbThhS3lsaW9kdVY2dTFVVVAyZXBQRHFKazEwMGgyNnV2?=
 =?utf-8?B?MGQwRmFYQkdhRDduSTNlZk43RCtkaEV5YW9GRVFKb3ZjWlpOTjUrdWx3dFNn?=
 =?utf-8?B?ODBoditEWWVyVnA4NDlLYkQzYTc2aldsMkhoYnFtb1JCOWdnUFhkVmlyRDBT?=
 =?utf-8?B?My9haXBwRFdaMHlseERQNGUzazNGZitralE3V2tHZEJYYUR5WTM0QXdxcXB5?=
 =?utf-8?B?dnpCTmRxTHEzdWZWNS9mNlQ1bzJYYW1NVFVqNzRwS3NRdk9aTFB5dkNYNHMv?=
 =?utf-8?B?UlUxeDMrUFl4Q25jVjN5WStCaVNsQVpnVWIwMGJZaW40c0dpSlJXUmQrVkZS?=
 =?utf-8?B?Nzh1d1EwdGFoSTBtb0lNYXhQZVlrSCtIWm8vUlJrOHBiY1kvWFdRdU9jbHBk?=
 =?utf-8?B?RFRQR09oMFd0TEM1RlQ1MDJYYXp6UTVYQlZRNkNBTkFSdHFScG1BRjczc1Nt?=
 =?utf-8?B?aGN6Wk9hTTVYV003dzF6b1h3WVdpZFVQbGdMRmFWc3RYdVd4U1VLaFc5WXBS?=
 =?utf-8?B?bEhiUU1USkpNeFdXTk9OM3l5djJqdFgySDI4b0NmSW00ckVFVnBsUjhsRUVo?=
 =?utf-8?B?QnNZMXFHSTZOUzFwOFNrazVMc1lFWmVuYTJiWlFZbjRvOWlpcndIbFQreEI3?=
 =?utf-8?B?ODkwbFpHOU1FWkhqYUFpMHZmNnZPRnZOZVIxOU5hcTZlQURMZm83L2t2a2RQ?=
 =?utf-8?Q?n643RwDRwGnpYY29MGqUGYQnC3FO+hCLAOmSTc4wLWMEn?=
X-MS-Exchange-AntiSpam-MessageData-1: CRdC/W/4iN4p6Q==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 861786d1-8efb-4b31-f51a-08da2821d354
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 07:44:57.2813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rYL0Ad7yRau0/ohiXpg1JV2nz/2jXsjUHU4wCSzSCuSLKfy9fKwvK8MlsDVb6inAW5lCcEB2vMFEGQhXbQslnQ==
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
> It turns out that a different fix is necessary to address the issue:
> https://lore.kernel.org/netdev/18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de/
>
> So the commit was not necessary.
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
> in ->stop().
>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: Martyn Welch <martyn.welch@collabora.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
>
Acked-by: Oliver Neukum <oneukum@suse.com>

