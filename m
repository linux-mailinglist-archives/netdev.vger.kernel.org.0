Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F3D6CC1E2
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbjC1OQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbjC1OQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:16:34 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F95ECA2F;
        Tue, 28 Mar 2023 07:16:33 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id eg48so50260900edb.13;
        Tue, 28 Mar 2023 07:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680012991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AgXQ38nFmCt03RIhoEWzT+O1IRQrnX5UaoYuVRV+Ngk=;
        b=UccGLVY8aF5GrsZxcYM4gYSkKtnsrizHORYCcD1SC9BNSCK8Y73HDUjAub1ECaS+l6
         rDtb0Vf6Z90VRRaotlbuCWeinvAPenWTEwlD0xB9Tj0Fs+ubQvCvQHlX46+3EFFTTtfq
         doWEX6OTOqQTQ8SzxPMfV71dBjgD9XQL6uwHY3l0/yQVrsMY0ATfTHCVYrlzaEoMGhCZ
         Tsyt9GJnSsXTVQAIm0YeqL6r7blXUVIJPpDpFLlJ6AYYOIAhmClYp2r9zN3rpcvYzaPh
         0p2wmqYdNTc/MphMvvr3S/VhznoSUYiTygm+1MEtvloYmEybAFbXFv9ihZugYWzS5gaO
         J6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680012991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AgXQ38nFmCt03RIhoEWzT+O1IRQrnX5UaoYuVRV+Ngk=;
        b=bpLSi5gtXDwwdhWlmV13dv0lwJZHgjCRFLymReYQb5ACZzNZqT3CvA9jC2Nd8wMa6Z
         yr0NGpWbNOGO4nTilrngCXcwnBCPE43z7f7lqSeikc7xCFGKWK/VjsntKVn9fCLyPXcR
         He5WANaFBWKIEtsPsLJ/fUSxvDdbcJUlwOMpMC/DH0aQzvfgtpuEfLqqpBQzCFqB1Vfl
         pQdGZ7/ttPPhMMKFdViTOvLTZvbMPq7rotiOldw5htFI+KQCMgnGT/iOus2JkA2KWyF/
         Ah5/rbEqummHPYCD5byh8azyfTRsVb/tiXcpEQc7XAf2M0EX7CmFTBJn5kTtZXBPT2zb
         9v0g==
X-Gm-Message-State: AAQBX9elwwT7cJ8fjuTqeZcz+IuM7JQ86zMb8JUxDUnoG/fTGxc8peaZ
        Qma0jL6JXXhVFYFNrwupejE=
X-Google-Smtp-Source: AKy350aJWYjsszzYhUL0PG8dKnI+Yf+TIxCMuHt140T1o8FjgTI3qFPkWjkkkVUq44n1faJ1y+AfoA==
X-Received: by 2002:a17:906:f6cd:b0:92f:b8d0:746c with SMTP id jo13-20020a170906f6cd00b0092fb8d0746cmr15874361ejb.20.1680012991394;
        Tue, 28 Mar 2023 07:16:31 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id h13-20020a170906110d00b009333aa81446sm13671380eja.115.2023.03.28.07.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 07:16:31 -0700 (PDT)
Date:   Tue, 28 Mar 2023 17:16:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next 2/2] net: dsa: mt7530: introduce MMIO driver
 for MT7988 SoC
Message-ID: <20230328141628.ahteqtqniey45wb6@skbuf>
References: <ZCIML310vc8/uoM4@makrotopia.org>
 <a3458e6d-9a30-4ece-9586-18799f532580@lunn.ch>
 <ZCIML310vc8/uoM4@makrotopia.org>
 <a3458e6d-9a30-4ece-9586-18799f532580@lunn.ch>
 <ZCLmwm01FK7laSqs@makrotopia.org>
 <ZCLmwm01FK7laSqs@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCLmwm01FK7laSqs@makrotopia.org>
 <ZCLmwm01FK7laSqs@makrotopia.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 02:08:18PM +0100, Daniel Golle wrote:
> I agree that using regmap would be better and I have evaluated that
> approach as well. As regmap doesn't allow lock-skipping and mt7530.c is
> much more complex than xrs700x in the way indirect access to its MDIO bus
> and interrupts work, using regmap accessors for everything would not be
> trivial.
> 
> So here we can of course use regmap_read_poll_timeout and a bunch of
> readmap_write operations. However, each of them will individually acquire
> and release the mdio bus mutex while the current code acquires the lock
> at the top of the function and then uses unlocked operations.
> regmap currently doesn't offer any way to skip the locking and/or perform
> locking manually. regmap_read, regmap_write, regmap_update_bits, ... always
> acquire and release the lock on each operation.

What does struct regmap_config :: disable_locking do?
