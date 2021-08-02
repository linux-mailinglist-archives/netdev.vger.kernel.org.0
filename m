Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D853DDCF8
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbhHBP6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbhHBP63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 11:58:29 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215F4C06175F;
        Mon,  2 Aug 2021 08:58:20 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so613579pjb.2;
        Mon, 02 Aug 2021 08:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=j/6mZKAL/+WSq3mfqkNpkYP79XdM38PqBABGWDQQ3Tc=;
        b=uPu1JMpbUOnujaJMHE3tqoSBZiQu+U+tfiCwG6diQYVG+wnzWcbV5DQ2WMjyVS0Izv
         zxhoEGILr9vgkzsvyCTZEGPFv4rQsXTCVoD2/2+QDoB3Q+IcChScDUviEdgutKRfmmX2
         YQy3IfNrYVD2gbowIC0CxY0Kr6MdS3csAFQhoYYWhPmdOei78hlIz9hTN2yxadbKofaQ
         odBWtZf1n1ur979EDvr/kbt9XXMfieH2r9aDhTT2PRXAc3nfZVosWNxKvbX37xJXpYrs
         +dSl/hvoDI/vemELrP64NgUwyDYCt6rIA2liU8JfBAyUSkWjI1y0EVC/S1ltegIPbxwp
         0v6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=j/6mZKAL/+WSq3mfqkNpkYP79XdM38PqBABGWDQQ3Tc=;
        b=ENBioMVuuD0jRxQDB1/NTG7MF9P2HzF4R/iOYY9kpJYW+Ajw10ScqK7urb3bonMp46
         LDbf3pOVVEc+xd0XWjbHUvIyvgnj13f3GQ0F2fi02S6L0o89BHffAnWJXuBzZjY2/zL5
         b+jzmpeFW6I3m6YuHTK+Lw48idYQSQH5SBz+Hxc0I9NLUeu0g5rQ66Ui0TmG5UnSv1CQ
         D2PTG5jYR9ZQKNlk16MDHGQUb/Y4umZKdq8YEnTcmTMPq+6r01kyMzqQyWKJY+FGgHx2
         eOLfo3Iw/2JbXIVGWj9MT+ZVxo/3tW4s5pE8FqxqMO7U2QQqLOUWxwZ5/xNagwp0Fv9H
         aTxg==
X-Gm-Message-State: AOAM531qrrXxNrP1+5HopGMx9k5eyqKYDv4C4g/q8kvTiuGCCFAj8ney
        fE7ljVuTdo00p0uvbckTWPs=
X-Google-Smtp-Source: ABdhPJxV5fzd9jTejpnEU9RSAAvhHJVdgaNwKVpW8pVdf+bvLYPCkyyaLI/CAHF22yEkkNhAqYlpTA==
X-Received: by 2002:a17:90b:3b47:: with SMTP id ot7mr17429240pjb.149.1627919899741;
        Mon, 02 Aug 2021 08:58:19 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id i1sm12097169pfo.37.2021.08.02.08.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 08:58:19 -0700 (PDT)
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
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Woudstra <ericwouds@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC net-next v2 3/4] net: dsa: mt7530: set STP state also on filter ID 1
Date:   Mon,  2 Aug 2021 23:58:10 +0800
Message-Id: <20210802155810.1818085-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210802154226.qggqzkxe6urkx3yf@skbuf>
References: <20210731191023.1329446-1-dqfext@gmail.com> <20210731191023.1329446-4-dqfext@gmail.com> <20210802134336.gv66le6u2z52kfkh@skbuf> <20210802153129.1817825-1-dqfext@gmail.com> <20210802154226.qggqzkxe6urkx3yf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 06:42:26PM +0300, Vladimir Oltean wrote:
> On Mon, Aug 02, 2021 at 11:31:29PM +0800, DENG Qingfang wrote:
> > The current code only sets FID 0's STP state. This patch sets both 0's and
> > 1's states.
> >
> > The *5 part is binary magic. [1:0] is FID 0's state, [3:2] is FID 1's state
> > and so on. Since 5 == 4'b0101, the value in [1:0] is copied to [3:2] after
> > the multiplication.
> >
> > Perhaps I should only change FID 1's state.
> 
> Keep the patches dumb for us mortals please.
> If you only change FID 1's state, I am concerned that the driver no
> longer initializes FID 0's port state, and might leave that to the
> default set by other pre-kernel initialization stage (bootloader?).
> So even if you might assume that standalone ports are FORWARDING, they
> might not be.

The default value is forwarding, and the switch is reset by the driver
so any pre-kernel initialization stage is no more.
