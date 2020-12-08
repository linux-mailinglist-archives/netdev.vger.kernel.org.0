Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD00C2D351E
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 22:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgLHVUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 16:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729430AbgLHVUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 16:20:24 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6682C0613CF
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 13:19:43 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id f23so26712993ejk.2
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 13:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Uka+2onLr/hF/L1RahMPdiX9WOY0ncZlXCWRJl3wMho=;
        b=tZJD6H2UJyH1H8uxl2LGiKdQsC37miig9Cs+XOWAaIkElGOQH8KHlyEECZjigfn1Hq
         NjGmfS76eTMQscsbJf0kM/9lURDMTFapBdRo6EmXg1jPjzxFoXfBDk+VSEdmBV7xrBy5
         HKZzFoOEJgYVnHxbksPrqCYe6vzTG68Kxp/Ozqz4J6CYTiTyTGXx7MPeckwsBMh0ZoVB
         5XeG/qYUeHIS2F9hheDcae5FlS8No2k19Tl46ZrlYS7VHldJnOaHkbMaStwQqviV+SdB
         xB8TSRzMsguulFIgL9gKL8fdVIOUqPkUB+/6hGXk3u/ghe5xazeeoNOhFFSlVp7a10uP
         cuXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uka+2onLr/hF/L1RahMPdiX9WOY0ncZlXCWRJl3wMho=;
        b=lkQ2hi4jnz/4h1wqhQ7oHcPQ0NGlM4B3xTR75HkBzl4hBDsV2Oni2YiuRwoqfpN1oV
         d/iEglXMClvsl9PgZ4GWh7OeFBEODReDn3SVc4W7EPHEDPBsABBdJnHE3AMPgTIGklmO
         z1CIi2NhWV+AhNqCsT7vsLdZuSpY+HGiDHYbG6TQ9twxqKHpfw1k+j3FWAS2ysfIRPr0
         EjpHZgtWckTm81iarT8HzqVCN3aE2hN4Bk79rYhJsgyUfr5VZ0N6y9Mvi/q5n0WqHCdo
         wULs0vwg9zO1gUUQPDp3nSXB0BAAbI9CMFjeWe2sQjCBhrmrdQGEvL+AX5mF3SEupUoB
         0Ycw==
X-Gm-Message-State: AOAM532z//gDixbemKhTL56PnoMtYZWbeNMDCPl0pQ/O1h8UGmIieeTH
        dIM9sQ7RBOMhY8StoYSKLdo=
X-Google-Smtp-Source: ABdhPJzqouL6MJZAj0WHsQEsAAutI/cIEX1KtQKWg1qtBSojZwP2QP8JFihSK12g07fJYAB6ubrLGQ==
X-Received: by 2002:a17:906:6b88:: with SMTP id l8mr24998162ejr.482.1607462382650;
        Tue, 08 Dec 2020 13:19:42 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id w20sm37426edi.12.2020.12.08.13.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 13:19:42 -0800 (PST)
Date:   Tue, 8 Dec 2020 23:19:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH net-next] net: dsa: mt7530: support setting ageing time
Message-ID: <20201208211940.ep7lr7bvvuu2wqno@skbuf>
References: <20201208070028.3177-1-dqfext@gmail.com>
 <20201208205621.2xxscilegk4k4t4g@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208205621.2xxscilegk4k4t4g@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 10:56:21PM +0200, Vladimir Oltean wrote:
> On Tue, Dec 08, 2020 at 03:00:28PM +0800, DENG Qingfang wrote:
> > MT7530 has a global address age control register, so use it to set
> > ageing time.
> > 
> > The applied timer is (AGE_CNT + 1) * (AGE_UNIT + 1) seconds
> > 
> > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> > ---
> >  drivers/net/dsa/mt7530.c | 41 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/net/dsa/mt7530.h | 13 +++++++++++++
> >  2 files changed, 54 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > index 6408402a44f5..99bf8fed6536 100644
> > --- a/drivers/net/dsa/mt7530.c
> > +++ b/drivers/net/dsa/mt7530.c
> > @@ -870,6 +870,46 @@ mt7530_get_sset_count(struct dsa_switch *ds, int port, int sset)
> >  	return ARRAY_SIZE(mt7530_mib);
> >  }
> >  
> > +static int
> > +mt7530_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
> > +{
> > +	struct mt7530_priv *priv = ds->priv;
> > +	unsigned int secs = msecs / 1000;
> > +	unsigned int tmp_age_count;
> > +	unsigned int error = -1;
> > +	unsigned int age_count;
> > +	unsigned int age_unit;
> > +
> > +	/* Applied timer is (AGE_CNT + 1) * (AGE_UNIT + 1) seconds */
> > +	if (secs < 1 || secs > (AGE_CNT_MAX + 1) * (AGE_UNIT_MAX + 1))
> > +		return -ERANGE;
> > +
> > +	/* iterate through all possible age_count to find the closest pair */
> > +	for (tmp_age_count = 0; tmp_age_count <= AGE_CNT_MAX; ++tmp_age_count) {
> > +		unsigned int tmp_age_unit = secs / (tmp_age_count + 1) - 1;
> > +
> > +		if (tmp_age_unit <= AGE_UNIT_MAX) {
> > +			unsigned int tmp_error = secs -
> > +				(tmp_age_count + 1) * (tmp_age_unit + 1);
> > +
> > +			/* found a closer pair */
> > +			if (error > tmp_error) {
> > +				error = tmp_error;
> > +				age_count = tmp_age_count;
> > +				age_unit = tmp_age_unit;
> > +			}
> 
> I feel that the error calculation is just snake oil. This would be enough:
> 
> 		if (tmp_age_unit <= AGE_UNIT_MAX)
> 			break;
> 
> Explanation:
> 
> You are given a number X, and must find A and B such that the error
> E = |(A x B) - X| should be minimum, with
> 1 <= A <= A_max
> 1 <= B <= B_max
> 
> It is logical to try with A=1 first. If X / A <= B_max, then of course,
> B = X / 1, and the error E is 0.
> 
> If that doesn't work out, and B > B_max, then you go to A=2. That gives
> you another B = X / 2, and the error E is 1. You check again if B <=
> B_max. If it is, that's your answer. B = X / 2, with an error E of 1.
> 
> You get my point. Iterating ascendingly through A, and calculating B as
> X / A, already gives you the smallest error as soon as it satisfies the
> B <= B_max requirement.
> 
> > +
> > +			/* found the exact match, so break the loop */
> > +			if (!error)
> > +				break;
> > +		}
> > +	}
> > +
> > +	mt7530_write(priv, MT7530_AAC, AGE_CNT(age_count) | AGE_UNIT(age_unit));
> > +
> > +	return 0;
> > +}

Thinking more about it, it's not snake oil but is actually correct.
Where I was wrong was the division giving you a certain error, but it
actually only gives a maximum error. Other, larger, divisors can still
give you an error of 0.
If the number you're searching for, X, is, say, a multiple of 3 but not
of 2, and is:
B_max * 1 < X < B_max * 2
then exiting the loop at A=2 would give you an error E=1. But if you
continued the loop, then A=3 would have yielded an error E=0, because X
is a multiple of 3 but not of 2. I should probably go and refresh my
basic arithmetic.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
