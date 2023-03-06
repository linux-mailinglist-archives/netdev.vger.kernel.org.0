Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4026ACF01
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 21:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjCFUTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 15:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCFUTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 15:19:11 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E4136471;
        Mon,  6 Mar 2023 12:19:10 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id cw28so43791671edb.5;
        Mon, 06 Mar 2023 12:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678133949;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5X1DrGT/RW1/r+Y1HGheUCUnfXToPi6qBpvnHsE+fKY=;
        b=KwWvKclEUngSB3nCut/ygs51cOep20WW/PM6mVMbVZXU4Jq3uV9+8XJ7ifEeag9BOp
         N9ZqWkEr8ULNgEe4uTwk41dQM0cdtf4lBv9rwMmCmPO1dslhJGEmysV/Vp7wE9BG8XLp
         RL/5cwv64oNboXwBVBBUQObpvv+Em1yepOS/wJjy8TSpCiN2clXjuXBqTUei8h/kxdOd
         OllmhYEvTQXL4jIkUCwHVkPzVBcDMNa02KliH2dNm8f/1SyAIdAsJPcb+Aip6UUNmoE3
         9ebRHY6JmtjrONDS3qQduWBtHriIzGnc+rWRQP6MP6btnwVQCFgmQvgB8/DlH+I8WGQg
         xtRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678133949;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5X1DrGT/RW1/r+Y1HGheUCUnfXToPi6qBpvnHsE+fKY=;
        b=bsZVMfrOKnF/n7XrMhF6h37ykQWyVXRlZPuqm3Aa96h+ryIWew8rzICrIckYNHXefi
         O3uA5jL3Bd7Zm1eJ2CpFNcuM42LoV69WOItg799X7ikwuyaQDCbp5kkU4/J4sGZNR+Bx
         eiEd7TiTF3WlMgOMlTKJw9J4JgLLx99u3gHH6ttZdLebYFsV5KP/c5I+HXMaloUF84cC
         feLuY96kYxAVhIZLrAH5i7OMZKKsdx/mPz7dY+CdNTfAswpU/5EZeOdz7WZUQ7Ks9bjZ
         28/dtikb3SMrpbjq9GD1tl1RhrFwY9VkwlWoHmawqlqYTgBh7XU4fLQOTZ96oe35r5M5
         iUXQ==
X-Gm-Message-State: AO0yUKXIsIsu0RoOragLSWtJ1k7iX2JOJrmKxfVuPEKVOAAOpf81nKfe
        Qj7EV1vxZDSRnvw1OxQ28Kc=
X-Google-Smtp-Source: AK7set/BFRz4eNs5vXIC0za8DuHe0GFhkdvMDwTsUhlweCkvilsfm48w3UUydiQdzAItTNdw5vmLLA==
X-Received: by 2002:a17:907:a0d5:b0:8b1:319c:c29e with SMTP id hw21-20020a170907a0d500b008b1319cc29emr15022639ejc.74.1678133948607;
        Mon, 06 Mar 2023 12:19:08 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id n6-20020a17090673c600b008c607dd7cefsm5027776ejl.79.2023.03.06.12.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 12:19:08 -0800 (PST)
Date:   Mon, 6 Mar 2023 22:19:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Alexander Couzens <lynxis@fe80.eu>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH net] net: dsa: mt7530: move PLL setup out of port 6
 pad configuration
Message-ID: <20230306201905.yothcuxokzlk3mcq@skbuf>
References: <20230304125453.53476-1-arinc.unal@arinc9.com>
 <20230304125453.53476-1-arinc.unal@arinc9.com>
 <20230306154552.26o6sbwf3rfekcyz@skbuf>
 <65f84ef3-8f72-d823-e6f9-44d33a953697@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65f84ef3-8f72-d823-e6f9-44d33a953697@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 08:03:54PM +0300, Arınç ÜNAL wrote:
> Looking at the Wikipedia page for Media-independent interface [0], the data
> interface must be clocked at 125 MHz for gigabit MIIs, which I believe what
> the "PLL" here refers to. trgmii needs higher frequency in some cases so if
> both CPU ports are enabled, the table would be:
> 
>     priv->p5_interface        priv->p6_interface       ncpo1 value
>         gmii                     rgmii                     125MHz
>         mii                      rgmii                     125MHz
>         rgmii                    rgmii                     125MHz
>         gmii                     trgmii                    125-250MHz
>         mii                      trgmii                    125-250MHz
>         rgmii                    trgmii                    125-250MHz
> 
> [0] https://en.wikipedia.org/wiki/Media-independent_interface#GMII

Wikipedia will only tell you what the frequency of the interface signals
needs to be. That is useful to keep in mind, but without information from
the datasheet regarding what the SoC's clock distribution tree looks like,
it's hard to know how that interface clock is derived from internal PLLs
and ultimately from the oscillators. I was hoping that was the kind of
information you could provide. The manuals I have access to, through charity,
don't say anything on that front.

Since I don't know what I'm commenting on, I'll stop commenting any further.

> > right now, you let the p6_interface logic overwrite the ncpo1 selected
> > by the p5_interface logic like crazy, and it's not clear to me that this
> > is what you want.
> 
> This seems to be fine as p6 sets the frequency either the same or higher.

(...)

> This looks much better, thanks a lot! The only missing part is setting the
> PLL frequency when only port 5 is enabled.

True. Although with the limited information I have, I'm not sure that
the ncpo1 value written into CORE_PLL_GROUP5 is needed by port5 either
way. The fact that you claim port5 works when ncpo1 ranges from 125 to
250 MHz tells me that it's either very tolerant of the ncpo1 value
(through mechanisms unknown to me), or simply unaffected by it (more
likely ATM). Since I don't have any details regarding the value, I'd
just like to treat the configuration procedure as plain code, and not
make any changes until there's a proof that they're needed.

> I'll test it regardless.

Thanks.
