Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245996BA711
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 06:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjCOF2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 01:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjCOF2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 01:28:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24496199C2;
        Tue, 14 Mar 2023 22:27:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7234B81BFA;
        Wed, 15 Mar 2023 05:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6A2C433EF;
        Wed, 15 Mar 2023 05:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678857994;
        bh=E5Dp6jeYL9pBo43fNB5EtdOzQpg0eX7PymVqFdhu9SE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LwlKdRxCSI9M+Q8pd4JodBuk2Ew7lZAcHmxp4bA2tYWxrJRdQ+BE4KPSy4BtuWgM4
         CA2/W4MJKCv4xgoOtPzc2XzFIcArTs5bc9iHh6R8+T/p/O+2fTT1LZGUUTWKq0uwUC
         T3zZh70uM8fEMXcLyARIRIUW/9cYxq1K9IVVslnQ3aNlKcYENaGmxfsQRsdF2aSdm/
         M/g8zqq8xZCCdn9mdkQhpi6KOtT64PcQeZqdWXDtNwgqcsw2s6KK5nWrwRjTM5Dmyw
         A3AZ/jqffj54kQqS2F2k1HjLvlIStZtZIYnAcvo9lFLl8f0UAxKo9b/CClKfLcrzUT
         +gwl7/iFV7OtQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jouni Malinen <j@w1.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 37/38] wireless: add HAS_IOPORT dependencies
References: <20230314121216.413434-1-schnelle@linux.ibm.com>
        <20230314121216.413434-38-schnelle@linux.ibm.com>
Date:   Wed, 15 Mar 2023 07:26:23 +0200
In-Reply-To: <20230314121216.413434-38-schnelle@linux.ibm.com> (Niklas
        Schnelle's message of "Tue, 14 Mar 2023 13:12:15 +0100")
Message-ID: <87o7ouwpog.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Niklas Schnelle <schnelle@linux.ibm.com> writes:

> In a future patch HAS_IOPORT=n will result in inb()/outb() and friends
> not being declared. We thus need to add HAS_IOPORT as dependency for
> those drivers using them.
>
> Co-developed-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>

Acked-by: Kalle Valo <kvalo@kernel.org>

Let me know if I should take this to wireless-next.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
