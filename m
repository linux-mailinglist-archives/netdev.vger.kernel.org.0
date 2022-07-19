Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A6657A063
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbiGSOFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237987AbiGSOEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:04:54 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DBC5F52;
        Tue, 19 Jul 2022 06:18:24 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id fy29so25977982ejc.12;
        Tue, 19 Jul 2022 06:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yc+h+ul4h9s6uUBRLUaqssxlPjgr6BM8cJCIGFPzipY=;
        b=J9eUykm76fIdNj3kRL1+JyFpVIW499oT+DRmOXXFEDM7q+PEyc5jM94oOtz3Qz4wVX
         bF84Pkt3xnsHhC4JEf4msMEOq+7Iy0SMQI2PPCGnJuVCqQ67FQNMHxK4SOndT/MvYfnK
         d7bTsIeNPc9K/piu4RUryH0XTvKEDO+SeQKxNQWKdasT1ViiLcXdtf1CVEEPjdz0PYca
         iTajalmvPI+9+JLxtQKf7IbzfgbbNh8PquCA4mN+C7xVbgmXOR1HbpzOyRXs1KtB7GrG
         Y+6HLARwLGrVt2gPH/MhTC0Zwx+KmMZ2jDmrYSCDJU3XHmYobLzbi6dy+50GkdhDVdgX
         PWEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yc+h+ul4h9s6uUBRLUaqssxlPjgr6BM8cJCIGFPzipY=;
        b=zWSj9iHz36IfRHOAoqgQ9TZXqdzFLBnhkuWYqR12w2VhjvTewXOvx8XDFvkxIHP+EP
         x/ejw/kAD/4Q14FKfrMT+lv98BFefG5ggJ6QZwvk+KZNdXL0/DCU8Kv0GGAE3R7KRN4k
         FNE4LRqEK/KlWdoRWk6jQoMDsmB5uEWJR3KEb+RI6rN1Y0gH3hSZx7d+ZBKqnYboRXHv
         mxEoQXURF7FvhXNqPTwPMFgHz0grXMP/tmOsz2RzfTAQ7aywovJkjXc5fM22t3r72VvR
         EQnGMhZxTlH2SJ8moB8KygnP8z1wN68MstjDvp9FdzHmdfL9Me+VrFBfiqWuWQGVC+yV
         QUjg==
X-Gm-Message-State: AJIora/OksKE7jHBaF9vqbngjNNK4EjF98ORjbGB6y1uHdOlGauNI5d2
        trZS44Tt8KGTXd+kwwbQhSQ=
X-Google-Smtp-Source: AGRyM1vc3d5ELKetSkvOgAd0hKsuPKWP4OeyXYnilUZDc2oB8n+LsY9tZjW49kh9c6fQjZYjNdGDaA==
X-Received: by 2002:a17:906:cc45:b0:72b:313b:f3ee with SMTP id mm5-20020a170906cc4500b0072b313bf3eemr29551339ejb.362.1658236703117;
        Tue, 19 Jul 2022 06:18:23 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id c9-20020a170906528900b007262a1c8d20sm6715846ejm.19.2022.07.19.06.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:18:22 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:18:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 06/15] net: dsa: qca8k: move port set
 status/eee/ethtool stats function to common code
Message-ID: <20220719131820.7qs3w635sa6skaca@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-8-ansuelsmth@gmail.com>
 <20220719005726.8739-8-ansuelsmth@gmail.com>
 <20220719131451.5o2sh3bf55knq3ly@skbuf>
 <62d6aeab.1c69fb81.5d5ce.23b8@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d6aeab.1c69fb81.5d5ce.23b8@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 03:16:24PM +0200, Christian Marangi wrote:
> On Tue, Jul 19, 2022 at 04:14:51PM +0300, Vladimir Oltean wrote:
> > On Tue, Jul 19, 2022 at 02:57:17AM +0200, Christian Marangi wrote:
> > > The same logic to disable/enable port, set eee and get ethtool stats is
> > > used by drivers based on qca8k family switch.
> > > Move it to common code to make it accessible also by other drivers.
> > > 
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > ---
> > 
> > Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> 
> (considering the ethtool function will change, is it OK to keep the
> review tag on the next revision?)

As long as the removed code is identical to the added one, yes.
If there are problems with the changes on the ethtool_stats function,
I'll leave my comments there.
