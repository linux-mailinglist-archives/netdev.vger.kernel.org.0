Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7FD694B65
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjBMPjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjBMPi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:38:56 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AB41BAD9;
        Mon, 13 Feb 2023 07:38:47 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id z13so9002434wmp.2;
        Mon, 13 Feb 2023 07:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQlTtxIUYEHa/ubjSbDgZDFaflLT7rKtPF2clbJjFdQ=;
        b=IkuG+5VXy1/buVb/yG+3jkuR9GTYgVMLQgivQycLe3nT6NbscEvMR0zVbWKuyyFIqE
         75CzWiDBmX3R//55dD5CMZHLO35nawl+F7eAdRAHMFbcgwN54o6N4RHSZX4DwDQJtYcX
         9v/YivZnQp5fuX1YNDvvREKvfYPLpUa9U7YvF6daDlaXa6qS/mKeL0Eejuuv5Hml/8Sf
         ofNpf/8pOKGtPLP0EP5s2RVfqADQXT8K5zw68jC/AcXS9ECSbOPPoDtQn3mh9M1LGrdJ
         mE3TXz+ANs4EgOWqeKy6V5QlPDrVpJ0KYhCieuEUtma6DclnGWpM0Ben4PjamNyjLVnK
         ZFBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQlTtxIUYEHa/ubjSbDgZDFaflLT7rKtPF2clbJjFdQ=;
        b=2s+HuRWKyO2t7MniOWFRH6uf8GZqJGGKCgGaKimFbmYg0GuPotZBi5w4LZNpfyfw1m
         C/X9yGI7FIbIoNZe+akJoSUvyx2aUl/4EQXdfW2fl0uggwz+t2WbzojF/GvWWZF+KoHy
         2Z3J3HUcwFieZaHjvvPhuLoe1LaPxeBYtigDsYlJ4IxP9LF4U3NbTJLjgXs4jLFKwn5K
         I/FI00jh7yjYsGVYUqwFHmX+V21OpCFYICKzr0FKW3qsutXTlEcHihLxif8TWHI3FOtk
         VCMmO17Dtt1rxG/SAN73OHhrzkGH11BXjq/Kckgl80lYSfC7AthoS3G25pZjsIXvVA8S
         KybQ==
X-Gm-Message-State: AO0yUKX1Ew3VPT7AIPu2RxRMVyta2lnA7Gc1cCaji5BQvvIKc76UbUq9
        8Xz39PS8rQrgiVvi7r5qL7A=
X-Google-Smtp-Source: AK7set/zTcHr+nUd0IzYxEeesl8wx99P2JYnFPRqebR5Ib4Tk7OFyUNhjuNSUh856w9HUz9D5ZSr2g==
X-Received: by 2002:a05:600c:2e87:b0:3e0:1a9:b1f5 with SMTP id p7-20020a05600c2e8700b003e001a9b1f5mr19081636wmn.28.1676302725704;
        Mon, 13 Feb 2023 07:38:45 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id f24-20020a05600c491800b003dc0cb5e3f1sm13408900wmp.46.2023.02.13.07.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 07:38:45 -0800 (PST)
Date:   Mon, 13 Feb 2023 18:38:40 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next 02/10] net: microchip: sparx5: Clear rule
 counter even if lookup is disabled
Message-ID: <Y+pZgFMDNrxxaSS9@kadam>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
 <20230213092426.1331379-3-steen.hegelund@microchip.com>
 <Y+ofJK2psEnj9QNh@kadam>
 <c5920cb1f3db053c705a988cf484bbbaa5c3dcfa.camel@microchip.com>
 <Y+pR4RZ8wJYFgSHL@kadam>
 <54791f7d5e4211b03a53e890a5d8a678039bec6d.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54791f7d5e4211b03a53e890a5d8a678039bec6d.camel@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 04:32:21PM +0100, Steen Hegelund wrote:
> There are two writes to the 792 address as the counter recides with the start of
> the rule (the lowest address of the rule).  Instead of being written after the
> rule, it is now being written before the rule, so the test array that records
> the order of the write operations gets changed.
> 
> The is2_admin.last_used_addr on the other hand records the "low water mark" of
> used addresses in the VCAP instance, so it does not change as the rule size is
> the same.

That explains it.  Thanks!

regards,
dan carpenter
