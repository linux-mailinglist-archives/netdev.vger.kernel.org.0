Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542CD23AC4A
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgHCSVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbgHCSVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 14:21:07 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08893C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:21:07 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z18so31531339wrm.12
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 11:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9lln+X27ahigaDRPkWx8IhF9zH1QQYOcSFvVHfhViDs=;
        b=S1I0ZfV2c5FWVCyFIQqKXzGCRxpr+JvH/Rx64mi0Ht5HPBszKztTeP78NIRVaUaZ/8
         iVw24Cjzyy5PYDY5O0up0EbVKiiBe8QFAduE75fxuX2AOMoqCKrt71WuXPY/EiBmsD5J
         szgJt0J5pVaYFxp2by8IwxOxqZZYGWMsCzc6LA2SQxvjsa68pSG+yNQ73HkL0LNdVnTV
         PAgkXmnwsOMBDisgaeCVgD0tHRqC7mPi2pDiuKBS6qElEC4CU7gfpeOwBq4y1HsB9g/w
         YKtMmGZupEGgMAN35tFbVW+3GQCUp/iv6+x1Q9Nb6sSUEMY1srDQRdcNQMilJS4vyKPv
         OzsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9lln+X27ahigaDRPkWx8IhF9zH1QQYOcSFvVHfhViDs=;
        b=X4HMGlGrkkD+QZ+KiFRkZ+eym8+2OfIfilp0UX4MBi8zPwRY9CSGios/4R/aDaCVsF
         2KF3aKEQyPcvpDt3U+1bL7WsdVKaCi2HOUBrexFKTHhsdcCeRxv5WsJNKaUmTPTKft14
         4Gp4KuBPk7XPmj60TpJjDuRswgliBsT/AZNNOMaamqnbIGIvY2+Ee02o18Tfnu/kzl5p
         p4OVPH4WCOmsAnSiWYYyPh/Qz4mcMeMiZVrHPGdVutYRsra9i1okO9Yz0SZktt/MNAda
         uBOQao+HhOiOgjmJFnG1VdQWY0B/X+QtODzsHcsU+i7NOEAdp8MebtgSe7DGa6nYt5vb
         qm2Q==
X-Gm-Message-State: AOAM533Lf/NYzhWE1CxNh+zJH7nmxzaWu37Z9bj3wCSIBLdYAHcLTpUF
        ziKsc+za4ekS7yP9v3J1pzA=
X-Google-Smtp-Source: ABdhPJyrdQD32bb7VZQqI6tgkpF6/Fh6Rjoplog+TbAN2hggtf+1SLeq43jFkbuv3UdfgjcU5+u2Yw==
X-Received: by 2002:adf:fe12:: with SMTP id n18mr16106038wrr.295.1596478865750;
        Mon, 03 Aug 2020 11:21:05 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z7sm670926wmk.6.2020.08.03.11.21.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 11:21:05 -0700 (PDT)
Subject: Re: [PATCH v4 07/11] net: dsa: microchip: ksz8795: move register
 offsets and shifts to separate struct
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel@pengutronix.de
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
 <20200803054442.20089-8-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <33431f48-d3f1-9821-3106-ec86fef76d5d@gmail.com>
Date:   Mon, 3 Aug 2020 11:21:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803054442.20089-8-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/2020 10:44 PM, Michael Grzeschik wrote:
> In order to get this driver used with other switches the functions need
> to use different offsets and register shifts. This patch changes the
> direct use of the register defines to register description structures,
> which can be set depending on the chips register layout.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> ---

[snip]

> +
> +struct ksz_regs {
> +	int ind_ctrl_0;
> +	int ind_data_8;
> +	int ind_data_check;
> +	int ind_data_hi;
> +	int ind_data_lo;
> +	int ind_mib_check;
> +	int p_force_ctrl;
> +	int p_link_status;
> +	int p_local_ctrl;
> +	int p_neg_restart_ctrl;
> +	int p_remote_status;
> +	int p_speed_status;
> +	int s_tail_tag_ctrl;
> +};

It might make more sense to define an array of registers that is indexed
by an enum token, and the array type be say, u16, such that the compiler
can tell you if you exceed what the type can represent. Then all of your
conversion looks a little more trivial to review and look like that:

-	ksz_write16(dev, REG_IND_CTRL_0, ctrl_addr);
+	ksz_write16(dev, dev->regs[REG_IND_CTRL_0], ctrl_addr);

is more readable and easier to review IMHO.

All of your masks and shifts should also use unsigned types since they
are unsigned by definition.
-- 
Florian
