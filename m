Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3333866CED8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbjAPSat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbjAPSa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:30:29 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151A75BB4;
        Mon, 16 Jan 2023 10:16:23 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id hw16so58106217ejc.10;
        Mon, 16 Jan 2023 10:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0kOKIRWpF9HuOzAZKrZQZpcRpAWjMLxyYQdRXeMnc+c=;
        b=Kyr7d9HQhTj9x1xmzYyrZB3d0rVHrJf8i53USWmrcDBJyxlpdTJVwYYSRvzP5nJRZe
         iTGDb78T6GxkSal2X547pTji9rOvN2E7XbXayq77KtCR5vzVyCmL1nKssju5eYmw9CHo
         uMjyWYumwhujA63MYpph3klVLmy3xCvCzn3JFntG0S6D2LSc+5hXs2eYoSpkVbQSr1xJ
         K22Jrho6ZCAkQXpMFZ/JTU0RU6NWgxxQg/AsmK2KsL1hGwdIdR6OSqbt61fwfQHJ6arv
         PPUFF8EtlXlYzgYVs8CW9R7AIoA4CZiijxY7xBGXARb5DZNaqB/AKV8kFEOeab2j9FWh
         GHdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kOKIRWpF9HuOzAZKrZQZpcRpAWjMLxyYQdRXeMnc+c=;
        b=sYTNsYoSDnaJRqngAH7CUZUzZGJ2auCEgyVizikgKsXfM0zfWufNPwGODISW/xpscv
         MO1oh5imBK44k+EOM5/hwwu2PqTdH5B8BUoaQpORR089YUzxRtllIfs25lF37R0pCq8t
         LIrcu9M6/S2EOxImt2HXa+C6Dq/ggJt33iwHQrfOGtH+96k1L0ds9+2uQTic1qHXv5e3
         yJcCNBWBb+3tPRRUa+GvWgCsqS9ma4fxgVDDQRGIOEOyxX+NRVXpcDS6XNUL+DaC+AGd
         vbxV9hnS8Fcb7uOApP9y8vCs7rKPv3p5mNc6S+oe3kUxLrs0LSAWR2LFo58zgA4ZXE1K
         Q0gw==
X-Gm-Message-State: AFqh2kpLShf1kPVBAYjB91t4eBjacRh0BuTlWFh8Lbw3kjMnz4+c3FEY
        5ADPzohh4NstnDepIWooJAQ=
X-Google-Smtp-Source: AMrXdXvmQKvVKQCixeZrgIEJeCLdwRT5FQvF0jau7jT0Nl1xt+V24BGYE/CueryjLU8tC3bG7QK0hQ==
X-Received: by 2002:a17:906:7188:b0:7c1:eb:b2a7 with SMTP id h8-20020a170906718800b007c100ebb2a7mr13030148ejk.13.1673892981577;
        Mon, 16 Jan 2023 10:16:21 -0800 (PST)
Received: from skbuf ([188.27.185.68])
        by smtp.gmail.com with ESMTPSA id r1-20020a17090609c100b007e0e2e35205sm12230589eje.143.2023.01.16.10.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 10:16:21 -0800 (PST)
Date:   Mon, 16 Jan 2023 20:16:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marcin Wojtas <mw@semihalf.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hkallweit1@gmail.com,
        jaz@semihalf.com, tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Subject: Re: [net-next: PATCH v4 2/8] net: mdio: switch fixed-link PHYs API
 to fwnode_
Message-ID: <20230116181618.2iz54jywj7rqzygu@skbuf>
References: <20230116173420.1278704-1-mw@semihalf.com>
 <20230116173420.1278704-3-mw@semihalf.com>
 <Y8WOVVnFInEoXLVX@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8WOVVnFInEoXLVX@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 05:50:13PM +0000, Russell King (Oracle) wrote:
> On Mon, Jan 16, 2023 at 06:34:14PM +0100, Marcin Wojtas wrote:
> > fixed-link PHYs API is used by DSA and a number of drivers
> > and was depending on of_. Switch to fwnode_ so to make it
> > hardware description agnostic and allow to be used in ACPI
> > world as well.
> 
> Would it be better to let the fixed-link PHY die, and have everyone use
> the more flexible fixed link implementation in phylink?

Would it be even better if DSA had some driver-level prerequisites to
impose for ACPI support - like phylink support rather than adjust_link -
and we would simply branch off to a dsa_shared_port_link_register_acpi()
function, leaving the current dsa_shared_port_link_register_of() alone,
with all its workarounds and hacks? I don't believe that carrying all
that logic over to a common fwnode based API is the proper way forward.
