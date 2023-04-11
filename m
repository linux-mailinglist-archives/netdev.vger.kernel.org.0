Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82B16DDE8A
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 16:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjDKOyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 10:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjDKOyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 10:54:23 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C35D2100;
        Tue, 11 Apr 2023 07:54:21 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id jg21so20762050ejc.2;
        Tue, 11 Apr 2023 07:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681224860;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ooA/O5How6wQvdMPwj1oVf9NjGnfxxmKWhsoBtFQ4c0=;
        b=qfMaiqu0EvyxBXJQV5iXyTIteNFwIp0kn8IXJ+o4Az9OdrCE9VDs6EwSVZQlWYbM2r
         0MC7x+fv9U9MFiDopk0B/XMmtjYn074RbaOslhcR817eOP5y6G+e3jCLW5S/OTraueQ2
         6iEd/czylPiPpA0BR19KncZbLxMd5pZ7xcuR10nXXVAaMWItAap1rtVrzdhj4uqXmtIQ
         EZNlbnJ7Xsp35jBwgYryuVnJhul2IksKBKhDqlS1B3phYWL0QHsyFWHPIzAUa1eaOUEI
         93U/JkwQ/rFKY5QY6p1Vd6Ue/VlqdBPmdrRywUO08v3i7MZX21EjCP4Lk1bkUASDTXEX
         uu3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681224860;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ooA/O5How6wQvdMPwj1oVf9NjGnfxxmKWhsoBtFQ4c0=;
        b=wZ6qSyysrlg+KbkI/H/CgC0EiCcXGI+K4w/REIE9mdGxpgZKeh7RemaVGVn49nFtfu
         T5XBTxHKYdIoVvyYfZ4be7cmY9WTBRx3cGkbhG0Ko4K9UOsbMK+ZIgv3lnKp6SLcGemi
         D6OXhiEov4AH7GI2fFyXntcYpI2OOELSnbcrK9ZvKXUsXgrOy43cM3cxvz+1UOZQvNyh
         zbmCKwsY7SpA+eMo/6j0h7qYuEBnPLkQpwnrV8ey6sOajRLRQ0T7C7UwzbnjYo95i8sx
         jtNAhSKtP4eHLBnYqveax5htH5wzbfv+N2aItNcL8V3YnoooPwvjeVZm5DL3H8/8AoX0
         AHMQ==
X-Gm-Message-State: AAQBX9cKyxk4Bcvn/C+8UiFwHR7bfJKL8oaIyH6Z4XcpiCIS/U5QGDU0
        gW1bVxCHF9fQdReG/CMwA1w=
X-Google-Smtp-Source: AKy350bG/mKyWotWt/5WTONtgPkIJlgfNGN0xCvfvLkEQA0SDIwmC8iy16B3Z2wDkS0Ug3nwQcT6gA==
X-Received: by 2002:a17:906:70cf:b0:939:e870:2b37 with SMTP id g15-20020a17090670cf00b00939e8702b37mr12602594ejk.70.1681224859587;
        Tue, 11 Apr 2023 07:54:19 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id z21-20020a17090674d500b0094e1026bc66sm975125ejl.140.2023.04.11.07.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 07:54:19 -0700 (PDT)
Date:   Tue, 11 Apr 2023 17:54:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH v2 net-next 06/14] net: dsa: mt7530: do not set CPU
 port interfaces to PHY_INTERFACE_MODE_NA
Message-ID: <20230411145416.kovyu3wb3dhtgbl4@skbuf>
References: <20230407134626.47928-1-arinc.unal@arinc9.com>
 <20230407134626.47928-7-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230407134626.47928-7-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 04:46:18PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> There is no need to set priv->p5_interface and priv->p6_interface to
> PHY_INTERFACE_MODE_NA on mt7530_setup() and mt7531_setup().
> 
> As Vladimir explained, in include/linux/phy.h we have:
> 
> Therefore, do not put 0 into a variable containing 0.

The explanation is unnecessarily long. I only provided it to make sure
you understand.
