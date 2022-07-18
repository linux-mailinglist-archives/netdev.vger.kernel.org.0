Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB752578972
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbiGRSUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234906AbiGRSUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:20:07 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6AD222B5;
        Mon, 18 Jul 2022 11:20:07 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r14so18312396wrg.1;
        Mon, 18 Jul 2022 11:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=omHvb86AMNYWSW2+ejzLgy/Ar5LcfEo6pWlg+HYKk6c=;
        b=T+GgfIrU+tM6mOLTHam4nv8elI5DxleBQKSNO8vamr2McenozEH3hviJyW91qU0wf5
         Qk/S+xnlrCbMM7+r/cwXfscLMzMhFI8zMSJuDhLjLQIAkR/xkPegMn+B4yc7/NvpdJSf
         tLTowpooK4IKjYNwVty4RV9LTE0inzIosza2KeJJDx8Z/MfKsebYvN3Rnho4Vw17MqVp
         gpI0oDtg/fOZZRiBhZkjLowL0w/pP3U0e+bUR4F++g1n9RHszJkBDK+sXIo46/ezjDuB
         XvRJlD3pKWQk5OeRgUYxJ2b/K+RMtrLtGsSLtrYw1U2iw97u36uy4PeR6ML98c2hNsz3
         ytjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=omHvb86AMNYWSW2+ejzLgy/Ar5LcfEo6pWlg+HYKk6c=;
        b=XYdf7a1x2oQf/MzngdpVV7hEyvISHI2Cq5/pLzDrUuuB2N0CugadINyeArpopLJ8jM
         mHsxL4KcxErXFz7lyl8qGcw3P6Y+I02QijSoSqTxnxRzOKCj4e9INNt7//yfSlESxVig
         gECgxFU8scQJmarGzVMcpzMbhebJGjsRsEbTEjYLZvEbhsO6Sz4S+V1pnqUrwGQWrIac
         RIZZ54Ds2K9pOdVRfRP9AFlxVJcjex1ZsYSqw8++0xKHYmWwgzSvTPVlt4fMh5bRc6in
         I9v+c1jPCaP8v63lSFdvlOeXjOALaA6zddpcwei/t3CJNoOb+0A/S1hu7bL6HC+O1kcH
         t2nw==
X-Gm-Message-State: AJIora+on3fSp2dRK4vcWS+EdJyHX0dLxYnP2eQ7aV/Cpc++1n+8sAdY
        uoqEI6zhK+WEco8LzU8hxEA=
X-Google-Smtp-Source: AGRyM1sHY7q6tOWxMsRJP6qgrOaKSsa02LyOxNBQu4s91PiKFshkIFNRzUnt1l+RJis4tJNufm+thQ==
X-Received: by 2002:adf:f20f:0:b0:21d:6de6:6f47 with SMTP id p15-20020adff20f000000b0021d6de66f47mr24498861wro.532.1658168405472;
        Mon, 18 Jul 2022 11:20:05 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id o42-20020a05600c512a00b0039c457cea21sm16314663wms.34.2022.07.18.11.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 11:20:04 -0700 (PDT)
Message-ID: <62d5a454.1c69fb81.18bd7.3d97@mx.google.com>
X-Google-Original-Message-ID: <YtWgUTXVqgbTXEB9@Ansuel-xps.>
Date:   Mon, 18 Jul 2022 20:02:57 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/4] net: dsa: qca8k: code split for qca8k
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <62d57362.1c69fb81.33c2d.59a9@mx.google.com>
 <20220718173504.jliiboqbw6bjr2l4@skbuf>
 <62d59b1a.1c69fb81.a5458.8e4e@mx.google.com>
 <20220718181559.lzzrrutmr2b7mpsn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718181559.lzzrrutmr2b7mpsn@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 09:15:59PM +0300, Vladimir Oltean wrote:
> On Mon, Jul 18, 2022 at 07:23:35PM +0200, Christian Marangi wrote:
> > Ok, so I have to keep the qca8k special function. Is it a problem if I
> > keep the function and than later make the conversion when we have the
> > regmap dependency merged?
> 
> You mean to ask whether there's any problem if the common qca8k_fdb_read()
> calls the specific qca8k_bulk_read as opposed to regmap_bulk_read()?
> 
> Well, no, considering that you don't yet support the switch with the
> MMIO regmap, the common code is still "common" for the single switch
> that the driver supports. You should be able to continue making progress
> with qca8k_bulk_read() being called from common code (as long as you
> leave a TODO comment or something, that it doesn't really belong there).

Ok I will leave a TODO comment and switch to the new implemenation when
the regmap implementation will be available. Thanks for the
clarification on how to proceed.

-- 
	Ansuel
