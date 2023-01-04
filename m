Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B1665D51F
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239616AbjADOJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239539AbjADOJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:09:09 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E74632187;
        Wed,  4 Jan 2023 06:08:56 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id u9so83006472ejo.0;
        Wed, 04 Jan 2023 06:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=de0fsbDFK8Do19BQAR7aafoZxjpL1KzhidshGnF0gZI=;
        b=hkXjnBjx2cV4x4t6RbptpRZcCEXzz28rMq59Tp5Qi5iQQeE6gXWFwCuFeb2WEA2Veb
         rGXfl7qxCzdka8EIuS0m1+IXrZtmir8uB78XqnzjM11qjez4P+OB+4vLerAzZXZAR4X+
         IhQXuF6bmVvUlaEaKNy9vOWatcC7sUsvJ44nN99kYlh2mJEVToiSfayuZr1wvHuiaM+b
         u6uJ/f4wZGhTBDbcOX/L7uL9mYBLz9BeVWymKr3rWsDWfujrnGgvJ88Hj2vgV1p2lSEp
         alUog5ZwfGf53FCbpeWsIA5bPW/fOzDdoaAEot5bTYhPRnibjmIhrHxVQhtyjDJCFlKr
         qM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=de0fsbDFK8Do19BQAR7aafoZxjpL1KzhidshGnF0gZI=;
        b=2ZuQCs1GRHjwluNfpNRsZ78pUZvhCuL9hZOB1X5XvnQbc33ua8SLuVF1r03agsFbQ7
         QH/l6SWpiuxCKh1bUl63WtYGlj86oYybPRg6PEB4K9Az4GhcW06LQhA8wNPTeEjPVv8L
         8ZpROWNZUbmWCZt40vZRlCMVl6c6tMunhJFbztByXs1g1lP+728Q2TuLhxbOeERj5yTl
         wkCaUswclV451MPk3Brh7U2FvZJPlM/UuZYXUz4xcObnj/BkT2Cj0NUMxt8S2tbKoZlY
         R/jfwqmWXkj/167i24c+Efu4/rvYVjSn/YjSgqa7uvKDg6Th/1ahBOz9W3H5a66OXkQO
         T4hQ==
X-Gm-Message-State: AFqh2kr9tsmXZi1zy0ZmGfWEX94akZiH6Bq2dVYecq4If+5FLIy4ZZfG
        rJ8FxO7cfN/GHvL3SD9Dt+4=
X-Google-Smtp-Source: AMrXdXvChaiycOEaJuvlWECr4V6PAqjzANwLWq8swYldpTNxLcsS6m8WPn6qH8eLSkWb39GVN0vE6w==
X-Received: by 2002:a17:906:dfcd:b0:7ff:7876:9c5d with SMTP id jt13-20020a170906dfcd00b007ff78769c5dmr40458836ejc.62.1672841334817;
        Wed, 04 Jan 2023 06:08:54 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id g7-20020a17090670c700b0084c7574630csm9755283ejk.97.2023.01.04.06.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 06:08:54 -0800 (PST)
Date:   Wed, 4 Jan 2023 16:08:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v7 04/13] net: dsa: microchip: ptp: manipulating
 absolute time using ptp hw clock
Message-ID: <20230104140852.udslp3zjwfgbpq3i@skbuf>
References: <20230104084316.4281-1-arun.ramadoss@microchip.com>
 <20230104084316.4281-1-arun.ramadoss@microchip.com>
 <20230104084316.4281-5-arun.ramadoss@microchip.com>
 <20230104084316.4281-5-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104084316.4281-5-arun.ramadoss@microchip.com>
 <20230104084316.4281-5-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 02:13:07PM +0530, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> This patch is used for reconstructing the absolute time from the 32bit
> hardware time stamping value. The do_aux ioctl is used for reading the
> ptp hardware clock and store it to global variable.
> The timestamped value in tail tag during rx and register during tx are
> 32 bit value (2 bit seconds and 30 bit nanoseconds). The time taken to
> read entire ptp clock will be time consuming. In order to speed up, the
> software clock is maintained. This clock time will be added to 32 bit
> timestamp to get the absolute time stamp.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
