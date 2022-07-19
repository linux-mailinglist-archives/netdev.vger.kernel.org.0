Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4584557A0F1
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238521AbiGSONY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbiGSOMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:12:54 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B9D57249;
        Tue, 19 Jul 2022 06:36:12 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id m16so19588268edb.11;
        Tue, 19 Jul 2022 06:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TwO0xXJN/4nZY9nXpVGlesXW1praZaXOe1MBOwVVyog=;
        b=HBKwO1N6WxcRulIdJfRAH5wqZgWViZBkfpypStXJ3JaR+1fdQvB29mZU4TpXX3kRwP
         74FJAZur3fS2J+fHUkh57s4wnPW5f+iwjQJ1j3MBa/xe270TQknINnmehXsMqw9Idy0x
         L6rrei63X3nYRXNDVfiXiQSLTSht48Y5JS+SCu6F+Qzh+vYygMIxUFYYgbUXuZNiUFQx
         5+3EBrw3/K7PIYhOcr1tw45edLkmNUr6fjkJ2dDGk1zwkjEshymGYzwjQJF7+YdanIFJ
         sktWYJn6laJ9fSm1hgRyfpgUtB7UiHLMSaJHW0jk4ZufV1XL09qLR6mOnI7+pfxz2+io
         Nz5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TwO0xXJN/4nZY9nXpVGlesXW1praZaXOe1MBOwVVyog=;
        b=ewkML495+hXB1n7cga8n0hKmwXP+LpfA2ioDMtspfeEvk9omC2yLGq5UPiBzsofd7t
         uqInlTqBNHYwkS67RgT5m2sxPfB/7ZzVMP1YTbM1/8w3/+kXLQ0PI7kxY1/YxFgEH8Yz
         6u3iebE6V0SqjA4Bc+32TeqkezEEFfFakorrgK5KFHwqhBF+mjxnPgQAg/n2/q3B1Qf/
         WU1Mt2AbcEp1FcNKygy10PgVqQlS6n68BaqSL41Ib9j6g08wqxaXBGRkRNQcfrPS2dXe
         OxlkKgmodIsPZ/TlH+Va8PO74nxGP+SpOMe19nU1zhdVS6PKMSlsRDgSsOUDmmi3D7VX
         sFCQ==
X-Gm-Message-State: AJIora8Y3TRVyfn7Fe90bg60ejsUpaeNELYlXO5T6n1gWq8f1GDUbZxL
        gpYTP9P6nVSMBb7sgr835Hw=
X-Google-Smtp-Source: AGRyM1uE12P+tPguqunm9z6AP7su6PtjmW+QimCtwVP9cjKHg0mo3+09PLxwLYXDvaK8PVmihDVaYQ==
X-Received: by 2002:a05:6402:847:b0:437:62bd:bbc0 with SMTP id b7-20020a056402084700b0043762bdbbc0mr43523247edz.285.1658237769365;
        Tue, 19 Jul 2022 06:36:09 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id gr19-20020a170906e2d300b0070abf371274sm6691788ejb.136.2022.07.19.06.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:36:08 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:36:06 +0300
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
Subject: Re: [net-next PATCH v2 01/15] net: dsa: qca8k: make mib autocast
 feature optional
Message-ID: <20220719133606.kesv2uz3k3v3vvld@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-2-ansuelsmth@gmail.com>
 <20220719005726.8739-2-ansuelsmth@gmail.com>
 <20220719122636.rsfkejgampb5kcp2@skbuf>
 <62d6a3ad.1c69fb81.8f261.32f5@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d6a3ad.1c69fb81.8f261.32f5@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:29:30PM +0200, Christian Marangi wrote:
> Ok makes sense. Can I make a patch drop the use of
> of_device_get_match_data and then apply this on top?

Yes, that would be the idea, thanks.
