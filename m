Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7E36D6A97
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 19:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbjDDRag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 13:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236638AbjDDRaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 13:30:19 -0400
X-Greylist: delayed 8451 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Apr 2023 10:28:52 PDT
Received: from 1.mo550.mail-out.ovh.net (1.mo550.mail-out.ovh.net [178.32.127.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA46576A2
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 10:28:52 -0700 (PDT)
Received: from director2.ghost.mail-out.ovh.net (unknown [10.108.16.216])
        by mo550.mail-out.ovh.net (Postfix) with ESMTP id C858025618
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 13:52:22 +0000 (UTC)
Received: from ghost-submission-6684bf9d7b-w8j8r (unknown [10.108.20.236])
        by director2.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 8B5A01FE99;
        Tue,  4 Apr 2023 13:52:20 +0000 (UTC)
Received: from milecki.pl ([37.59.142.106])
        by ghost-submission-6684bf9d7b-w8j8r with ESMTPSA
        id i9rwFZQrLGQnBjoAD5RYWQ
        (envelope-from <rafal@milecki.pl>); Tue, 04 Apr 2023 13:52:20 +0000
Authentication-Results: garm.ovh; auth=pass (GARM-106R006b254dd21-eb0e-4ea1-9abe-a29ccb002460,
                    DB032E9DBE4651C075F5A290BD3CA612568BFB46) smtp.auth=rafal@milecki.pl
X-OVh-ClientIp: 31.11.218.106
Message-ID: <002c1f96-b82f-6be7-2530-68c5ae1d962d@milecki.pl>
Date:   Tue, 4 Apr 2023 15:52:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH net] bgmac: fix *initial* chip reset to support BCM5358
To:     =?UTF-8?Q?Ricardo_Ca=c3=b1uelo?= <ricardo.canuelo@collabora.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Mason <jon.mason@broadcom.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, Jon Mason <jdmason@kudzu.us>
References: <20230227091156.19509-1-zajec5@gmail.com>
 <20230404134613.wtikjp6v63isofoc@rcn-XPS-13-9305>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
In-Reply-To: <20230404134613.wtikjp6v63isofoc@rcn-XPS-13-9305>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3140697793314597755
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeiledgieelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtfeejnecuhfhrohhmpeftrghfrghlucfoihhlvggtkhhiuceorhgrfhgrlhesmhhilhgvtghkihdrphhlqeenucggtffrrghtthgvrhhnpeeuleetudfgkeevfffggeffveevleeutdekkeejueekveevtefhhfegveeggefhudenucfkphepuddvjedrtddrtddruddpfedurdduuddrvddukedruddtiedpfeejrdehledrudegvddruddtieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehrrghfrghlsehmihhlvggtkhhirdhplheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehhedtpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-0.6 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 4.04.2023 15:46, Ricardo Cañuelo wrote:
> On mar 07-02-2023 23:53:27, Rafał Miłecki wrote:
>> While bringing hardware up we should perform a full reset including the
>> switch bit (BGMAC_BCMA_IOCTL_SW_RESET aka SICF_SWRST). It's what
>> specification says and what reference driver does.
>>
>> This seems to be critical for the BCM5358. Without this hardware doesn't
>> get initialized properly and doesn't seem to transmit or receive any
>> packets.
>>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> 
> KernelCI found this patch causes a regression in the
> bootrr.deferred-probe-empty test [1] on sun8i-h3-libretech-all-h3-cc
> [2], see the bisection report for more details [3]
> 
> Does it make sense to you?

It doesn't seem to make any sense. I guess that on your platform
/sys/kernel/debug/devices_deferred
is not empty anymore?

Does your platform use Broadcom Ethernet controller at all?

It seems like some false positive at first sight.
