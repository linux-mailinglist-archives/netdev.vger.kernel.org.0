Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8AE65D67A
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235221AbjADOrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjADOr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:47:29 -0500
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7C730B;
        Wed,  4 Jan 2023 06:47:28 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1672843646; bh=Yvt1N4qdMcKgEPhpZnAvSN+ob9zNyUULJ3ZU+8ssutY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=jfgrGv6YvJKDIfleebuLMKJuOgKX5H72/VQQEqEAptK2uLmZsduynHIX+VV4E8daa
         Ja3I0pb3yMQiZMSoP8EncvWY/p89evzlZe4RYu5bkGOs//VD6UlJzUlVt24ofaMrSV
         54VSNKjleKdXLLAYl4Hia07+o2kP5sQxV0MEe2/Z37KGXzYs+/vgyQiRkkj1b3MeDT
         Bm/7kGQJ4NoHL328VSWBvOHxV8oMbtweKDxclXJ3G6gOO8b1tWQaG9E5XRRx5L8nO0
         NGjvQStIoShpsK1q79/73ItmhrFGh0AnBdw9Egxktk2rIzbPCGESmYcdLDXWN2QpzW
         ytdxu1GZT73nw==
To:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+e008dccab31bd3647609@syzkaller.appspotmail.com,
        syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg()
 if there is no callback function
In-Reply-To: <20230104123546.51427-1-pchelkin@ispras.ru>
References: <20230104123546.51427-1-pchelkin@ispras.ru>
Date:   Wed, 04 Jan 2023 15:47:26 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87wn621hmp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> writes:

> It is stated that ath9k_htc_rx_msg() either frees the provided skb or
> passes its management to another callback function. However, the skb is
> not freed in case there is no another callback function, and Syzkaller was
> able to cause a memory leak. Also minor comment fix.
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-by: syzbot+e008dccab31bd3647609@syzkaller.appspotmail.com
> Reported-by: syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
