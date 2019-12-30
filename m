Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1770C12D271
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 18:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfL3RTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 12:19:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43596 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727207AbfL3RTY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 12:19:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JZ9rQfX2tOmDDl9S4tJiNghTw2MpHUqrZGdgml1GwI4=; b=bPkQ4RY29qFPhW3hVPQ7pTfeeZ
        e/mb8oNjSJweJZV+Ub1ilf2+dVnWwYXPL0qOEHlwXBq9fc1Hk1AlUL9qKYvt1JVSadUo4KC9Vapje
        fgFfcuX/D6X8IPwBuA2QrigzOtSGgOMeshSRbgWOc3FT/4gg4IctjdmG8Hpg7Ge4nq7I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ilyh1-00049n-56; Mon, 30 Dec 2019 18:18:59 +0100
Date:   Mon, 30 Dec 2019 18:18:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 04/19] net: dsa: tag_ar9331: split out
 common tag accessors
Message-ID: <20191230171859.GD13569@lunn.ch>
References: <20191230143028.27313-1-alobakin@dlink.ru>
 <20191230143028.27313-5-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191230143028.27313-5-alobakin@dlink.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 30, 2019 at 05:30:12PM +0300, Alexander Lobakin wrote:
> They will be reused in upcoming GRO callbacks.
> (Almost) no functional changes except less informative error string.
> 
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
> ---
>  net/dsa/tag_ar9331.c | 46 +++++++++++++++++++++++++++-----------------
>  1 file changed, 28 insertions(+), 18 deletions(-)
> 
> diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
> index 399ca21ec03b..c22c1b515e02 100644
> --- a/net/dsa/tag_ar9331.c
> +++ b/net/dsa/tag_ar9331.c
> @@ -24,6 +24,25 @@
>  #define AR9331_HDR_RESERVED_MASK	GENMASK(5, 4)
>  #define AR9331_HDR_PORT_NUM_MASK	GENMASK(3, 0)
>  
> +static inline bool ar9331_tag_sanity_check(const u8 *data)

Hi Alexander

Please don't use inline in C files. Leave it to the compiler to
decide.

	Thanks
		Andrew
