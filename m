Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A15A3E377B
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 00:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhHGW5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 18:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhHGW5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 18:57:43 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7508C061760;
        Sat,  7 Aug 2021 15:57:24 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id yk17so21966293ejb.11;
        Sat, 07 Aug 2021 15:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bAB/mxzRlPN4H2PV3HfzaxEovbIE8S5dGqJGBfd7Zls=;
        b=VopAP+4WVTbT1UZVZMuW8G9J7jPBByif3Rsw39voK5DF3cnX//3nVnuHMFtRWOHrwY
         QtWaoZ6SoSUE006xsJovaKWO4lQqUa8z8xOTd1KghKaV1tc/pCoTykqp0qJL9F74M4VW
         rK5BwqOyIL8pgiHVoxbv2iXR6PddRmi4vcueDnOv3BUrsRzpDFyxzsCxpQjyrFE9cKom
         awwpXu8DcFKRldq2aHBbHmOeivBblnXKzQ5ViqVxbRjNhPKONl8e3kGM055PRGZU/30F
         TpIlAHd50i+7vgN2NRIf8OXNOfx8lhId15ntD5/gZhZJNZYrBSlLUoudPCr9pLPfttTc
         fWMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bAB/mxzRlPN4H2PV3HfzaxEovbIE8S5dGqJGBfd7Zls=;
        b=prufYNMquCDMWZkYsAIxWEfXN3WkvsuLfnpIuumsoQaUrbx/30AK3tMDzFnLVy/f/W
         gZcCkkQGVnCdO/c0d2+tgrlhP5s3RJUAfGtozDEs5hxqe5uMkVrmUOndDbGkriq/G8IA
         B4TMwVsK4t2O6qOcTeVfnXKVleRnSjTgf5JE9Xa3rJKKBe3vbwoDeOmWV6M//8Uv2KLf
         TX6WDsGg6BVpTTWaOT+vwOy0xh2u2nfXbAg2ZYDUStV2Bp8t5gpte5S5I4l8j9X7efme
         uX1xo+Km+uiQzAJz0OiLllalyG+oYD9HL7qhFW74UBl8P04smyNzw5pM1X59jCB2+zKl
         AxoA==
X-Gm-Message-State: AOAM530hvmVGuj+er2kTRI9UeQS1y2uTVQmkfgoNpcN5/s509o9OvM43
        Xuc4IFdIXxk5GlN29Z3qqO0=
X-Google-Smtp-Source: ABdhPJz6iyG94oZnr/TAh9z90F6yb25cOgVsfbGAJnWfPI7M5luOluoSXZodtimWYIuFwg9s9kMqig==
X-Received: by 2002:a17:906:43c9:: with SMTP id j9mr15800594ejn.57.1628377043320;
        Sat, 07 Aug 2021 15:57:23 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id g10sm4198210ejj.44.2021.08.07.15.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 15:57:22 -0700 (PDT)
Date:   Sun, 8 Aug 2021 01:57:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>, Hauke Mehrtens <hauke@hauke-m.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        Michal =?utf-8?B?Vm9rw6HEjQ==?= <vokac.m@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>,
        Xiaofei Shen <xiaofeis@codeaurora.org>,
        John Crispin <john@phrozen.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Hannu Nyman <hannu.nyman@iki.fi>,
        Imran Khan <gururug@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Nick Lowe <nick.lowe@gmail.com>,
        =?utf-8?B?QW5kcsOp?= Valentin <avalentin@vmh.kalnet.hooya.de>
Subject: Re: [RFC net-next 3/3] net: dsa: tag_qca: set offload_fwd_mark
Message-ID: <20210807225721.xk5q6osyqoqjmhmp@skbuf>
References: <20210807120726.1063225-1-dqfext@gmail.com>
 <20210807120726.1063225-4-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210807120726.1063225-4-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 07, 2021 at 08:07:26PM +0800, DENG Qingfang wrote:
> As we offload flooding and forwarding, set offload_fwd_mark according to
> Atheros header's type.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  net/dsa/tag_qca.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
> index 6e3136990491..ee5c1fdfef47 100644
> --- a/net/dsa/tag_qca.c
> +++ b/net/dsa/tag_qca.c
> @@ -50,7 +50,7 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
>  {
> -	u8 ver;
> +	u8 ver, type;
>  	u16  hdr;
>  	int port;
>  	__be16 *phdr;
> @@ -82,6 +82,15 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
>  	if (!skb->dev)
>  		return NULL;
>  
> +	type = (hdr & QCA_HDR_RECV_TYPE_MASK) >> QCA_HDR_RECV_TYPE_S;
> +	switch (type) {
> +	case 0x00: /* Normal packet */
> +	case 0x19: /* Flooding to CPU */
> +	case 0x1a: /* Forwarding to CPU */
> +		dsa_default_offload_fwd_mark(skb);
> +		break;
> +	}
> +
>  	return skb;
>  }
>  
> -- 
> 2.25.1
> 

In this day and age, I consider this commit to be a bug fix, since the
software bridge, seeing an skb with offload_fwd_mark = false on an
offloaded port, will think it hasn't been forwarded and do that job
itself. So all broadcast and multicast traffic flooded to the CPU will
end up being transmitted with duplicates on the other bridge ports.

When the qca8k tagger was added in 2016 in commit cafdc45c949b
("net-next: dsa: add Qualcomm tag RX/TX handler"), the offload_fwd_mark
framework was already there, but no DSA driver was using it - the first
commit I can find that uses offload_fwd_mark in DSA is f849772915e5
("net: dsa: lan9303: lan9303_rcv set skb->offload_fwd_mark") in 2017,
and then quite a few more followed suit. But you could still blame
commit cafdc45c949b.

Curious, I also see that the gswip driver is in the same situation: it
implements .port_bridge_join but does not set skb->offload_fwd_mark.
I've copied Hauke Mehrtens to make him aware. I would rather not send
the patch myself because I would do a rather lousy job and set it
unconditionally to 'true', but the hardware can probably do better in
informing the tagger about whether a frame was received only by the host
or not, since it has an 8 byte header on RX.

For the record, I've checked the other tagging drivers too, to see who
else does not set skb->offload_fwd_mark, and they all correspond to
switch drivers which don't implement .port_bridge_join, which in that
case would be the correct thing to do.
