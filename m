Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDDF31D9AF
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 13:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbhBQMoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 07:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbhBQMnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 07:43:24 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB1CC06178A
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 04:42:42 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id b14so15858902eju.7
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 04:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oJPm2B/oNL3KwOlSQNUjt7Mntse6JdaGaAAqn/p87mk=;
        b=gG0+pDnjFoVRpaS8WgVTWvW/kmFl4eUmplDahBS+rwJ46BDZX41pxnKJ5JtEPTMKtk
         VDgsWwG9TdOlrJFcD0Phd2T6KcXqPqdwBPZmE/egrehKMEBuAvxTP454DMjhpiiPqV9X
         ey3mQcLCw7ZBCR59HlT/N+saYsAKOCLueRu304ta4XNuhpbERE4k+V3Gwu1yVNJcPVks
         hHUatdMpR8XLxEVBYzA+1zVcMFXJ2069+Z6+m2Clw5wgFD+QB5sBcBzXyNuX1hsk5ke/
         +Hm7N7Dn9b39i9KIGk1LDcfruNibqI8OXV5mIKjg3gYGp+jA/vCBcleE3gKBn5GZqwh4
         kkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oJPm2B/oNL3KwOlSQNUjt7Mntse6JdaGaAAqn/p87mk=;
        b=lj6RBN2KUQ9b5e+lNsH4gg0j12F2l4/pp9vQcHkR+BGehjJCchJLbXL2Xi+94ssH+2
         MQq+ug80H8iIPz0qL7KDfPr7cdTpEbs4RECMbMkpLmTUewwOZy/8Ic9aUTMAV5NmVn+L
         +XIOfvpdVEBCTEfhwVJpGDQbWOI9ul4P55hFtMcjoZc8XJggxoSU9b6zm/Lb7gmmTSqv
         L1IpqwFvr9S+w2EekEA55nnGt0aM0YfNXb063wgF01lEK4d05Z/X6cHY6y3pLWObNX97
         W1tSlIF4pZDN8luzJ/s6npFWvHCp52rMOhPDE11VXtKWJ+QP/1D1OHVaIyiiq010o5Sk
         zezw==
X-Gm-Message-State: AOAM533JTaZe5UKxfa5DABW0laaAqK/+PMA7TlsUmGoYVzzMp8SCaXOo
        IC8RGDvoOY/6AQeJV8clfuk=
X-Google-Smtp-Source: ABdhPJzde5IeuVBEf947PbMNcXc+Nf2/gLLGh26DFdv7nEDGGScLhmbFAlBg1e8epFxbbLhWM1WICw==
X-Received: by 2002:a17:906:a57:: with SMTP id x23mr24931999ejf.40.1613565761566;
        Wed, 17 Feb 2021 04:42:41 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id 62sm1101278edc.46.2021.02.17.04.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 04:42:41 -0800 (PST)
Date:   Wed, 17 Feb 2021 14:42:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [PATCH] net: dsa: tag_rtl4_a: Support also egress tags
Message-ID: <20210217124239.sxgkhow53vox7o54@skbuf>
References: <20210216235542.2718128-1-linus.walleij@linaro.org>
 <CALW65jbEjWtb3ww=Bq5WKrjpQ=fjrxCBKyxxxi0CGRAVAkdO7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jbEjWtb3ww=Bq5WKrjpQ=fjrxCBKyxxxi0CGRAVAkdO7g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 08:38:30PM +0800, DENG Qingfang wrote:
> On Wed, Feb 17, 2021 at 7:55 AM Linus Walleij <linus.walleij@linaro.org> wrote:
> > +
> > +       /* Pad out to at least 60 bytes */
> > +       if (unlikely(eth_skb_pad(skb)))
> > +               return NULL;
>
> I just found that this will cause double free (eth_skb_pad will free
> the skb if allocation fails, and dsa_slave_xmit will still try to free
> it because it returns NULL.
> Replace eth_skb_pad(skb) with __skb_put_padto(skb, ETH_ZLEN, false) to
> avoid that.

Good catch, Qingfang.
