Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747E55AD7DD
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237442AbiIEQut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiIEQur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:50:47 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2005F6E;
        Mon,  5 Sep 2022 09:50:45 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id kk26so18134868ejc.11;
        Mon, 05 Sep 2022 09:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=x1qtOMya/oPRTMAYmEeO4ZE/bmiboEfhEM1DemxV65Q=;
        b=ATUiFwNW46HOdVSJyFHmmmcHEReJG5By7GSd5ZunN7/bNkWBY1+F4LcLMFb74uhpMf
         gx++7P8IhEYJezl8pnbd0GZizmGkYxJeg6cWrnYXIE8fqyN6NmnWLkaCDUCLY644s4GH
         +bCojZ8rpd2PhPhROZCCeuEH9tHr3OrzLA8gut4wI0G4yDIruAvboZLAv64CKyXaQxct
         HNzCeY6Hl4xLaLdpSJjlUmm9ydHbEc3TxOI73/FM1Le0wRIt+aupHmneCEE3wuXupvvt
         K9xTIbxv52iNmd0rlRGIyjgHvMbYqQFAULd6uQmSg3p4O9wSkdgwrSSs4Om+7wWF0cYM
         3nGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=x1qtOMya/oPRTMAYmEeO4ZE/bmiboEfhEM1DemxV65Q=;
        b=sLUGJjvNI2A5Vn1FSW+qzxYK4edlV1Kssvk5DfLzUyS31srl0mOADM6PUOHfs1jU4A
         6SS0Jc8MF2QIo3XPIpLCQxfuVcHAJc9j57vJA6VCO7f9b0mG4eLMct8AlJdDCmk5BxME
         qzPb9pBCWMa0EYjYh77PvbLuPKOUOK0sIP3qQ/L6LxZMxvfERbH/D4mXf0/HqXLXncAN
         WJUxsA2AcFlOyrw5lzZg9M3eLngt2n7wZplDAZ1fyHylpWisbtAYwkMwACelHG9KSev5
         OQnjslfabgIHOT/40G3Ze/zKSzq4MAw7nBuNVhJwWkql56xfm0nHRn6itG15vawXYpmJ
         Tnpg==
X-Gm-Message-State: ACgBeo0SrxrYhYjNU/C5jxbH/xRrqPb8n8cztbYzBpsTZGf474ZPFv1l
        aPNvN6g1EE1tDhDPZcY3eFQ=
X-Google-Smtp-Source: AA6agR63U60Yg4qrPja/oKGHkyrgXNvByUp0Sg2AOfxcyZ/lzV2O5OZtmC+MOOBx1QD5YGo6s7LODg==
X-Received: by 2002:a17:907:c318:b0:73d:be5b:273e with SMTP id tl24-20020a170907c31800b0073dbe5b273emr34770198ejc.339.1662396643863;
        Mon, 05 Sep 2022 09:50:43 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id f6-20020a0564021e8600b0043cc66d7accsm6669630edf.36.2022.09.05.09.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 09:50:42 -0700 (PDT)
Date:   Mon, 5 Sep 2022 19:50:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net PATCH] net: dsa: qca8k: fix NULL pointer dereference for
 of_device_get_match_data
Message-ID: <20220905165039.vcgqwjpyoy2eqlsp@skbuf>
References: <20220904215319.13070-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220904215319.13070-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 04, 2022 at 11:53:19PM +0200, Christian Marangi wrote:
> of_device_get_match_data is called on priv->dev before priv->dev is
> actually set. Move of_device_get_match_data after priv->dev is correctly
> set to fix this kernel panic.
> 
> Fixes: 3bb0844e7bcd ("net: dsa: qca8k: cache match data to speed up access")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Did this ever work? Was it tested when you sent the big refactoring
patch set?
