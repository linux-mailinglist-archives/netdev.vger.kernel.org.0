Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BED668702F
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 21:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjBAUzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 15:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjBAUzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 15:55:46 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E226C93C3;
        Wed,  1 Feb 2023 12:55:17 -0800 (PST)
Received: from [IPV6:2003:e9:d70f:e348:e684:710d:4017:e1c4] (p200300e9d70fe348e684710d4017e1c4.dip0.t-ipconnect.de [IPv6:2003:e9:d70f:e348:e684:710d:4017:e1c4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 734AFC0149;
        Wed,  1 Feb 2023 21:55:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1675284914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uGlvaxqzCP2ruKAcDVPZwEiNy/UTu93VtnNJl+gzhN0=;
        b=r+LrehrW4KCkXAwI6PfPt4Hh96wkkTj34SwZMUKQl0qcyHMvi+Nq5SMIyVkRsZgcQFsOkx
        b5m9dJhBbA8ZlTq0lr5wei1Z5YIYwwxe+vUka1o4Qc+UxhPzou7SN4fMCEzGKO7BpNAI3F
        8rLzE0VgO81AhMOazkLvYhSomPA3RfxrljZN9f2mM5Y2k8OXgAS3eY4vhC2MsR7GMrjGrE
        Q0efg9Ctk68KE/IiFHlV+jbqoP8yEdAgasJftaVN2cJzUWD4RNpV5s8SajGYJNqOEJ1aYy
        nHx4aoPxHj+77QD3nKuvZWiJjljc8iM2UGA7vIhlYdUhOU2Q9C8QcJA4jJ/6bQ==
Message-ID: <1b4cc7dc-1bf6-b7c9-e9bf-eb9af74d27e3@datenfreihafen.org>
Date:   Wed, 1 Feb 2023 21:55:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/2] ieee802154: at86rf230: drop support for platform data
Content-Language: en-US
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alexander Aring <alex.aring@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
References: <20230201053447.4098486-1-dmitry.torokhov@gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230201053447.4098486-1-dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 01.02.23 06:34, Dmitry Torokhov wrote:
> There are no users of platform data in the mainline tree, and new
> boards should use either ACPI or device tree, so let's stop supporting
> it. This will help with converting the driver to gpiod API.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>   drivers/net/ieee802154/at86rf230.c | 42 ++++++++----------------------
>   include/linux/spi/at86rf230.h      | 20 --------------
>   2 files changed, 11 insertions(+), 51 deletions(-)
>   delete mode 100644 include/linux/spi/at86rf230.h

This patch has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
