Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022F43F687D
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239641AbhHXR6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239532AbhHXR6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 13:58:01 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82530C02B92D;
        Tue, 24 Aug 2021 10:32:48 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s11so20432682pgr.11;
        Tue, 24 Aug 2021 10:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=g9LJhggKHy5VJtMaJ9R8dOKVVlo3xEJqmgw1Slxeh/4=;
        b=Fvh6g+4bT66GQtkOkpVzPme6rUscGPaqEpRt4v7/FxlsWdaeM6Kfrqed0YuPBjI7F7
         66Lg9gXRDyDEH4YyqnuZCTZQ97wW/7KACpAR+RwHWpqT5L7kxAdlRAwtUhJ8h8nO/C7Z
         aRzjxqWBgxT180W6zc+myoV7znLlUfp6LD0qqs1go7wd80mbgyWCTdTTtEn3hgr7Wer1
         rhwRCmsJUyVbBhU3n9WL+eYf1Qvw8QWYwBSIqAL9yzgck+xGhIKZR7nGNVnT5mIsenHu
         Y668D7vt+wTs40JDT+OkqwHIb8/N2QqOCym1DWt4KQv7Q+tTenxw4ohK/KMOexP+16T9
         IgAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=g9LJhggKHy5VJtMaJ9R8dOKVVlo3xEJqmgw1Slxeh/4=;
        b=Hr+anlqme/fy6f2qQiuUc6GMM6iPHXoO6uQxe4OL1/Bp7Eyi4NCTssRCH/WRL3Na8E
         cgXVTfYu181UuegBsjjF95Uy50R2AUpsgiaIAqEljuWv9eabnozPpw8MAxfN60xcstrL
         +szLNq+td6SHciEAE5cIAj6Q+UanGO9D7iV1dlodPYjii0KPO8w2zwWmkNxPumDi+XNZ
         r3KCH901BcysAp58CvaszfqijWLNdCO4lErKVaw0XUD23x/mtwFw+S6Xh9OmofWZgl0Z
         ZK0CtWzdsF6Mj1kg0F8so73mdrZVK0j9s8/tZT0uzD91sDq9WTL0XN2HmqYvosMdpmlx
         desg==
X-Gm-Message-State: AOAM531Ge9XV8EwfREwkC81Jp7U6/hs/9N1ng5OnLLSs7Lr2y7tSOJNj
        eMhyG7LK0yPle0mSK5T3jbE=
X-Google-Smtp-Source: ABdhPJwrP2Y1h9/6wAw1h0wgYRixs3rnIJtHaZT9iSxCxCh4eYqcTRpzqWDAqRb+OBEtlgFo/maFdw==
X-Received: by 2002:a63:2047:: with SMTP id r7mr20577260pgm.398.1629826368075;
        Tue, 24 Aug 2021 10:32:48 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id w76sm17142028pfd.71.2021.08.24.10.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 10:32:47 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        "open list:MEDIATEK SWITCH DRIVER" <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mt7530: manually set up VLAN ID 0
Date:   Wed, 25 Aug 2021 01:32:37 +0800
Message-Id: <20210824173237.1691654-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824165742.xvkb3ke7boryfoj4@skbuf>
References: <20210824165253.1691315-1-dqfext@gmail.com> <20210824165742.xvkb3ke7boryfoj4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 07:57:42PM +0300, Vladimir Oltean wrote:
> I understand that this is how you noticed the issue, but please remember
> that one can always compile a kernel with CONFIG_VLAN_8021Q=n. So the
> issue predates my patch by much longer. You might reconsider the Fixes:
> tag in light of this, maybe the patch needs to be sent to stable.

Okay. So the Fixes tag should be 6087175b7991, which initially adds the
software fallback support for mt7530.

> 
> > +static int
> > +mt7530_setup_vlan0(struct mt7530_priv *priv)
> > +{
> > +	u32 val;
> > +
> > +	/* Validate the entry with independent learning, keep the original
> > +	 * ingress tag attribute.
> > +	 */
> > +	val = IVL_MAC | EG_CON | PORT_MEM(MT7530_ALL_MEMBERS) | FID(FID_BRIDGED) |
> 
> FID_BRIDGED?

What's wrong with that?

> 
> > +	      VLAN_VALID;
> > +	mt7530_write(priv, MT7530_VAWD1, val);
> > +
> > +	return mt7530_vlan_cmd(priv, MT7530_VTCR_WR_VID, 0);
> > +}
> 
