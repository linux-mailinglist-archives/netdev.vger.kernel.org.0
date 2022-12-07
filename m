Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8BC646140
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 19:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiLGSoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 13:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLGSoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 13:44:19 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13985B5B6;
        Wed,  7 Dec 2022 10:44:18 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id m18so14575397eji.5;
        Wed, 07 Dec 2022 10:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q7lOJu1WPtS5HJkLIbq/sEQYGKHyp4CuoT7q646l41A=;
        b=jW1dlCfVhcWak52j0XiXca65wMg0KvMF2k/W83S6waTC4kBCiRF/XK3nTjf2Cq6z9G
         Va5OYIDoBtvwYxoOQiZsXQZOmJ2Gca3ppWHj2igw4jpVp79NKsnDUqW3eEcfYPfmTv1B
         IMBFAVKdJnSJzciItY0GO2mBMFLpxmQofxTq8BPQu0Zg+xHvPEmAHztZhojRBUAKhjpC
         U2f5QcEDaiRnbCUv5FNw4Qzanbje1WO8Z/T2wyYZSbc8aK2DGuHoc7Ej8eKA1cKl4AuX
         Y3gViNRjFMxkrnBSep7XF2dlCrkU5QTxjhtDbTLQSxqGLTG3pkIzcge/7Y+d1Pe2HVw7
         lo8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q7lOJu1WPtS5HJkLIbq/sEQYGKHyp4CuoT7q646l41A=;
        b=qRPta+v8JySP+gXYc1tsP6xcIt0u8NeiQIgzuhiZsw9ArKL7B3TaMc8uoxEk2EFxTd
         4UaRNvGPfsMTzCQx6W4cSb8hXUFuOHkR5Qh2HN/6J3l8/weCDRjs4NEE6psOMiOJg+l3
         mJRsB/dwEQwokSPvir/z23imQJjDoYHbQl7GVwprwdl+YuC1CvoFyK4dkMJ3QtgsuGw5
         tz4yp1Ie4OKUqf48PtNxUoeJzlzweATig8lNlPInFUCMp21HlGPmEnVrCgHa6U+d2M90
         lx30Sk2J2BtQWkNFe5Oi1EgG0Ii37XQ3YzmKt0JO2b7zwQZhtvcb1vPXox1jeSCjVxA4
         PkEg==
X-Gm-Message-State: ANoB5pnc0m8XjfVosE1BaKhDQ29X3qvL5TkWx2Th8W8tWfVqNaKkAFdH
        CIh9p8Wf5jUZG/nmYqS/tZU=
X-Google-Smtp-Source: AA0mqf7Z5vI3zwxCkwcH3bMgWL0YvTLitiv072H4n2gvmI4Jh06v0Q2kcLogMCPMoYgS0q3JkYxGtA==
X-Received: by 2002:a17:906:9702:b0:7aa:5e6c:4b59 with SMTP id k2-20020a170906970200b007aa5e6c4b59mr65571189ejx.231.1670438657386;
        Wed, 07 Dec 2022 10:44:17 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id du1-20020a17090772c100b00772061034dbsm8839800ejc.182.2022.12.07.10.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 10:44:16 -0800 (PST)
Date:   Wed, 7 Dec 2022 19:44:29 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 1/5] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y5DfDYr2egl/dZoy@gvm01>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
 <350e640b5c3c7b9c25f6fd749dc0237e79e1c573.1670371013.git.piergiorgio.beruto@gmail.com>
 <20221206195014.10d7ec82@kernel.org>
 <Y5CQY0pI+4DobFSD@gvm01>
 <Y5CgIL+cu4Fv43vy@lunn.ch>
 <Y5C0V52DjS+1GNhJ@gvm01>
 <Y5C6EomkdTuyjJex@lunn.ch>
 <Y5C8mIQWpWmfmkJ0@gvm01>
 <Y5DR01UWeWRDaLdS@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5DR01UWeWRDaLdS@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 06:48:03PM +0100, Andrew Lunn wrote:
> > > And only return the actual version value, not the 0x0A.
> > About this, at the moment I am reporting the 0x0A to allow in the future
> > possible extensions of the standard. A single byte for the version may
> > be too limited given this technology is relatively fresh.
> > What you think of this?
> 
> What does the standards document say about this 0x0A?
It doesn't actually say much, except that it is the identifier for the
OPEN Alliance mapping.

Excerpt:

"
4.1.1 IDM
Constant field indicating that the address space is defined by this document.
These bits shall read as 0x0A (Open Alliance).

4.1.2 VER
Constant field indicating the version of this document the register map
conforms to. Some registers/bits defined herein may not be available in all
revisions. The management entity can read this register to provide
backward compatibility. For the present revision of this specification,
these bits shall read as indicated in Table A.1.0/Value.
"

Thanks,
Piergiorgio
