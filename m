Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395A4511FE0
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243598AbiD0Qw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243570AbiD0Qw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:52:56 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804C541BCB2;
        Wed, 27 Apr 2022 09:49:44 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id be20so2613672edb.12;
        Wed, 27 Apr 2022 09:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uYrRYcDclPs5USkIGIkU+s5cFDwTirfliAawnlXEeAc=;
        b=Cy8dvR/V4MO73neOKArrLa1Gw62YD3AVEhj17BEL+iybFOhv6DhJpqIuD1FZ16QehN
         QzLOYyu1XkMzRcanzv4wJB/F/QgDLGYsEyQE6zSbqbkO0wfAexHsDJJ+wVackuPYeH2m
         RM7k/mfwdA6ChK5Y+YzPN6dzpNtSYq/IGzeE5TPpbWnfORO3uinBUYIyxZuw2PZiZ6Zu
         tWgc1ykQQJtc1w+X5WcRj4ycepq08WaL5ZXbo9o1tqLgXX/vdYFT+JNFRSqGKxSAgRmJ
         aYRALPXv5rL3Yri3Pvtm9tn//CMwdc5HKuRj29BhomEE+JCtgyZpw3V6XAUS+HVvWwTa
         FMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uYrRYcDclPs5USkIGIkU+s5cFDwTirfliAawnlXEeAc=;
        b=160roBopynZ0qYSgE2JZgjp8E3UvQQgZcr4gTUNOMGJbOP/cZQ6gqC8wxAkPMAM5qG
         of3FNHoWeGIn45ZaQ4BOX2+MSfvBUgsuphgQqbKzsRrTs57w8PFJ9034DbwFYX3RZCgf
         evxp+6nYuMVXV3+VqXC82I7aoj25SoPeAB1yiz4FQcUZBjULZ9gc+NEjO3rlVcByL2nO
         ZAawCOiUFZbZ0pSrBY5dIc9QxSZuu7aN2pOHDiYtAuFpVYrg9zyNs7xu2LMkxzs/Qzwx
         wWPhe8giX1jcsB6+fffaDkPONbM+ahIV8/90S4adxKtvslRV8cx/NHCpwqIKH5Lokz9d
         gUIg==
X-Gm-Message-State: AOAM533MqX7wg9fi961A5HZp+AZqWvpsJ9hAaSSw7JgkMUPokkqK0cWa
        +nOOp+TaslPwNXql7NvmuDY=
X-Google-Smtp-Source: ABdhPJzClDoP060+TcJZDElU/E2muDSx4sM05nG50yZ/amSF2utNsq/2MwJBJ2bQm7pXYR1iOuMmIQ==
X-Received: by 2002:a50:d4d2:0:b0:410:9fa2:60d6 with SMTP id e18-20020a50d4d2000000b004109fa260d6mr31721520edj.35.1651078182860;
        Wed, 27 Apr 2022 09:49:42 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id p18-20020a1709065dd200b006f3b6c3bc8fsm2502852ejv.22.2022.04.27.09.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:49:42 -0700 (PDT)
Date:   Wed, 27 Apr 2022 19:49:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [RFC patch net-next 2/3] net: dsa: ksz: remove duplicate ksz_cfg
 and ksz_port_cfg
Message-ID: <20220427164940.tpznnm5mejwfmavk@skbuf>
References: <20220427162343.18092-1-arun.ramadoss@microchip.com>
 <20220427162343.18092-3-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427162343.18092-3-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 09:53:42PM +0530, Arun Ramadoss wrote:
> ksz8795.c and ksz9477.c has individual ksz_cfg and ksz_port_cfg

Plural (have).

> function, both are same. Hence moving it to ksz_common.c. And removed

Present tense (remove).

> the individual references.
> 

Small hint for writing commit messages. You should describe the entire
change, and walk the reviewer through the thought process.

Here, something which you are not mentioning is that the chip-local
implementation for ksz_port_cfg() that ksz8795 and ksz9477 have uses the
PORT_CTRL_ADDR() macro. Whereas the newly added generic ksz_port_cfg()
uses dev->dev_ops->get_port_addr(). The transformation is safe because
both ksz8795 and ksz9477 provide a get_port_addr() implementation.

I didn't know that, so I had to check.
