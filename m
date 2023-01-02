Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234B665B00E
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 11:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbjABKwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 05:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbjABKwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 05:52:19 -0500
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53695617D;
        Mon,  2 Jan 2023 02:52:12 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1672656728; bh=6RY7S+y0DfUAy1fUOzzhODWlfsBE1dPJ6/GMcHruOqE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=HGAfbwaPX15G6g+ykzFUphONZa6cHD4tmr++hWxlm1lwHgmXXniCKyADTnuxISCZy
         5z2F0DpyjMKdyNOBn5M+WIlTo2bK7wC59R+tsAfyyBfE4Ryc/4J5n8hhXDRFA5/y0I
         aM08txXOGPq5+rTxc1veknpYjo7aIg1Key8dQjOfJtId5vhMaBzpd42HMLXNLLKxQ3
         cZjskCGUplKAhv/H56+1G0iBlCbxXpCH+JwAFJq1aT9fvoiPn75IECMoR9xnc1E7gv
         YPm2tlXoWF9dEG0xJYdi1VQVyLuvcA6dnv5rG3Yl6mhYjy1GgMy3KJbRfnIxvQEBai
         PALSDZx9vUBCA==
To:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Zekun Shen <bruceshenzk@gmail.com>,
        Joe Perches <joe@perches.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] wifi: ath9k: hif_usb: clean up skbs if
 ath9k_hif_usb_rx_stream() fails
In-Reply-To: <20221228224008.146343-1-pchelkin@ispras.ru>
References: <20221228224008.146343-1-pchelkin@ispras.ru>
Date:   Mon, 02 Jan 2023 11:52:05 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87h6x95huy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> writes:

> Syzkaller detected a memory leak of skbs in ath9k_hif_usb_rx_stream().
> While processing skbs in ath9k_hif_usb_rx_stream(), the already allocated
> skbs in skb_pool are not freed if ath9k_hif_usb_rx_stream() fails. If we
> have an incorrect pkt_len or pkt_tag, the skb is dropped and all the
> associated skb_pool buffers should be cleaned, too.
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>
> Fixes: 6ce708f54cc8 ("ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream")
> Fixes: 44b23b488d44 ("ath9k: hif_usb: Reduce indent 1 column")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Is this the same issue reported in
https://lore.kernel.org/r/000000000000f3e5f805f133d3f7@google.com ?

If so, could you please tag the patch appropriately?

-Toke
