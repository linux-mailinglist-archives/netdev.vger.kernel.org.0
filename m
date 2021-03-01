Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B5D328030
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 15:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbhCAOCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 09:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235804AbhCAOC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 09:02:26 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2BCC061756;
        Mon,  1 Mar 2021 06:01:46 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id mm21so28076395ejb.12;
        Mon, 01 Mar 2021 06:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vyxGkIDx2zfZM/7QCUBJLFsBl84322Wri/ex0wFZW8o=;
        b=t1blD6gqsFR0NLoQ88sXysLMIwy9lobm2Doakcvu3a+QbGJLoSnkTRfpQA4GIzHIy1
         XSJfCAgNn6qsB+9HsOPa4JgCoGiDtji0yoUwqW33kKBAQZq3e4uC8rn1USWrYkxpo6yn
         YPfuybsv05PMK55YQ00j7QegjiZmBRCn8brcJQHGs6MT8gE2ycjHdqCXmwd0dxL80eZt
         KYfKHht71vgrKL3maUtd1LkJID3F/ylg2imMAMhykn+NM7DcAazAfoJ7A7KCqIR6spHQ
         D4dPU/V9TEnRLPpzdJIClt5/ZrRZPYgedHiVLaGH3L3SRx2IgbEwa0Fr6oP9CzGp1YwN
         w1fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vyxGkIDx2zfZM/7QCUBJLFsBl84322Wri/ex0wFZW8o=;
        b=RE/LbeP+/uyOZvM7AhHUubp8vEF3jKLHv02RqbficcalFkYZ03T2HsUhD/zkMnlzQJ
         XGNtW+GA1hXHpFl0edbpBcb22vaTtYvwSx6jP/sJBL7N0ckQR0V7Bg7PtEbkqAF2KUvL
         Bm4AYtg7fSnqiVrId0mubHeXn+7OKwpq1hyAl197So+ajpXJncs5BIl3u+x5kG3Y0f+K
         PaF6G3spT4thsqU+xUwH6eMvGIjrtrCZv7bNOWoyciB4lWrst5T9H6Gusrk5MqYU2cuG
         vqmJ4EX4XlF2KqISrrpoWnCOf30HVSxxk+F/E5qDXP9xfUodQ5YCdrRbLEPUNloXNL1k
         shAg==
X-Gm-Message-State: AOAM5334QQgcxVD7Z/mX0QTRSsduRna5QI2XqZHTAFTf1oN7b5KWX9KO
        nsI3Lt/U5i7BC415GequU00=
X-Google-Smtp-Source: ABdhPJyUEdWMuhwhuSqIwJjzwJcmPwv1NMI/8o+x4LnE9x3wGqj7VfcjtToskCC/3mp1M0Zm6iqWag==
X-Received: by 2002:a17:906:2bc2:: with SMTP id n2mr15722656ejg.381.1614607304724;
        Mon, 01 Mar 2021 06:01:44 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id y8sm9386587eju.31.2021.03.01.06.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 06:01:44 -0800 (PST)
Date:   Mon, 1 Mar 2021 16:01:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: tag_rtl4_a: fix egress tags
Message-ID: <20210301140142.5ibwjjypilrb3s2s@skbuf>
References: <20210228170823.1488-1-dqfext@gmail.com>
 <CACRpkdYpO6xXkswSO_wRLJNeeO6LZtT_W+KN-ECRyCc+ybU7VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYpO6xXkswSO_wRLJNeeO6LZtT_W+KN-ECRyCc+ybU7VA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 02:58:59PM +0100, Linus Walleij wrote:
> On Sun, Feb 28, 2021 at 6:08 PM DENG Qingfang <dqfext@gmail.com> wrote:
> 
> > Commit 86dd9868b878 has several issues, but was accepted too soon
> > before anyone could take a look.
> >
> > - Double free. dsa_slave_xmit() will free the skb if the xmit function
> >   returns NULL, but the skb is already freed by eth_skb_pad(). Use
> >   __skb_put_padto() to avoid that.
> > - Unnecessary allocation. It has been done by DSA core since commit
> >   a3b0b6479700.
> > - A u16 pointer points to skb data. It should be __be16 for network
> >   byte order.
> > - Typo in comments. "numer" -> "number".
> >
> > Fixes: 86dd9868b878 ("net: dsa: tag_rtl4_a: Support also egress tags")
> > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> 
> Ooops I send patches before properly going through the mailbox.
> Oh well things like that happen.
> 
> David: ignore my patches to the same tagger and apply this instead!
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Yours,
> Linus Walleij

Last time I checked, performance/timing sensitive code is impacted by
netdev_dbg calls even if dynamic debugging isn't turned on. However,
neither your patches nor Qingfang's have removed that netdev_dbg line.
Is there any good reason to keep it?
