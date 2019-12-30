Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E071512D481
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 21:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfL3Ugp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 15:36:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43844 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727667AbfL3Ugp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 15:36:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SXdGQUakfHybtX0jGG9d+Xw/HkMyol+MPHYTh6dQ3U4=; b=G6sDaIa4Z25UB8aomFAcrsYCxZ
        sHFxTi0i4H9s4qWhRn4C48sxjLww49Qqy7d0sMS3bqs9wzaNysXFjyhJJ1HsaMmC5d2mVBuQrMqCY
        XMAh9tp2x8TJRQRtngzHnGf9Eu8UdH6/Xkq5/TXmMV21bzOFORXZO94hq7H1fSecWwj4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1im1lw-0006Vp-L5; Mon, 30 Dec 2019 21:36:16 +0100
Date:   Mon, 30 Dec 2019 21:36:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Alexander Lobakin <alobakin@dlink.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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
Subject: Re: [PATCH RFC net-next 05/19] net: dsa: tag_ar9331: add GRO
 callbacks
Message-ID: <20191230203616.GA24733@lunn.ch>
References: <20191230143028.27313-1-alobakin@dlink.ru>
 <20191230143028.27313-6-alobakin@dlink.ru>
 <ee6f83fd-edf4-5a98-9868-4cbe9e226b9b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee6f83fd-edf4-5a98-9868-4cbe9e226b9b@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 30, 2019 at 10:20:50AM -0800, Florian Fainelli wrote:
> On 12/30/19 6:30 AM, Alexander Lobakin wrote:
> > Add GRO callbacks to the AR9331 tagger so GRO layer can now process
> > such frames.
> > 
> > Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
> 
> This is a good example and we should probably build a tagger abstraction
> that is much simpler to fill in callbacks for (although indirect
> function calls may end-up killing performance with retpoline and
> friends), but let's consider this idea.

Hi Florian

We really do need some numbers here. Does GRO really help? On an ARM
or MIPS platform, i don't think retpoline is an issue? But x86 is, and
we do have a few x86 boards with switches.

Maybe we can do some macro magic instead of function pointers, if we
can keep it all within one object file?

    Andrew
