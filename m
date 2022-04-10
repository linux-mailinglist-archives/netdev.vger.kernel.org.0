Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848454FAD9C
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 13:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239651AbiDJLHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 07:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239744AbiDJLH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 07:07:27 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBA54EF42;
        Sun, 10 Apr 2022 04:05:13 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id g18so500264ejc.10;
        Sun, 10 Apr 2022 04:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=adPV1zp7diLsWHqzN1lHL+GqEnUieJZSmVlsIsbWwpE=;
        b=Ob9fiGsJykZtGsN1gXjaquKw6PFzWg+nAC9wYYAAVm0T+7rjzmVd4fHgzvgdWUEzE1
         IzoRprgjKGaibtKOR665kPTiuHm4XaxNgyFazf8YgKAK/IP73v+DzQ9p/9sh3tAXtUp3
         fSvOPsGAiCEXj8kfK6ZpEEOqRvKA6JpNLDs/TXeIGKtbEvHSJDJ3lBcY2OjMaLZ/3qBw
         ZYBRe93+F621m3Wlc6m530Qtchr9gPxYQTkWNjE+hv98s2zySf8n2Jznue1L++edra3l
         t1DI8PV5QY21yYt4rCT9hZZ3r5xoUfsk89RMCNA8/UiMOtJuiuny0aHB3XvgCf0D9aZ3
         hwuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=adPV1zp7diLsWHqzN1lHL+GqEnUieJZSmVlsIsbWwpE=;
        b=PgFyusd8e+EnpThWyrdsGPUj2UhLgsj9pxiO56y+5Y2Av4vmtXv9burGAMgWYFbkwl
         e0tTQxkpU4TUb05wR7awRgsZQAwwiZAeTNNEniD14cuxiJprIqyD2NuWMwEMbDotz+Ay
         D1ir1rCxwrQntd/SEDGo1MaS2WjbWPqDvujdWPP0mKxav1vhzWxzaES+da1qv+O7FWyf
         r68zrIMQ0tVg53q2PQF2f2CY4YpecTxhIRay/sOsfJePsmIgeSyn46aBgX+rWsAKZeLd
         X1B7CnsJbMbKT96xRBuE0KK/Sn9RWzOsbe0JIdYxdlXycylAFxE7aGXnrAFEynsXmyCu
         DqaQ==
X-Gm-Message-State: AOAM5337OZGblm5gC5VoIjcEG92oHSrAuTebAsBqYLw0AG8kUSjtfA0M
        zxz+Vp8CnkrOUhyR3qZSCG4Xk5K4cBE=
X-Google-Smtp-Source: ABdhPJy4CfP6h/f6jEve+JMMd5M6e84ocjd2vq2qNBHY+zBvxrBpJzRN/enhyyp3MUEvPBoaqyEshQ==
X-Received: by 2002:a17:907:7e82:b0:6e8:92eb:2858 with SMTP id qb2-20020a1709077e8200b006e892eb2858mr300803ejc.443.1649588711789;
        Sun, 10 Apr 2022 04:05:11 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id c5-20020a170906d18500b006ce371f09d4sm10596141ejz.57.2022.04.10.04.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 04:05:11 -0700 (PDT)
Date:   Sun, 10 Apr 2022 14:05:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Colin Ian King <colin.king@intel.com>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
Message-ID: <20220410110508.em3r7z62ufqcbrfm@skbuf>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-3-jakobkoschel@gmail.com>
 <20220408114120.tvf2lxvhfqbnrlml@skbuf>
 <FA317E17-3B09-411B-9DF6-05BDD320D988@gmail.com>
 <C9081CE3-B008-48DA-A97C-76F51D4F189F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C9081CE3-B008-48DA-A97C-76F51D4F189F@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 12:51:56PM +0200, Jakob Koschel wrote:
> I've just looked at this again in a bit more detail while integrating it into the patch series.
> 
> I realized that this just shifts the 'problem' to using the 'pos' iterator variable after the loop.
> If the scope of the list iterator would be lowered to the list traversal loop it would also make sense
> to also do it for list_for_each().

Yes, but list_for_each() was never formulated as being problematic in
the same way as list_for_each_entry(), was it? I guess I'm starting to
not understand what is the true purpose of the changes.

> What do you think about doing it this way:
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
> index b7e95d60a6e4..f5b0502c1098 100644
> --- a/drivers/net/dsa/sja1105/sja1105_vl.c
> +++ b/drivers/net/dsa/sja1105/sja1105_vl.c
> @@ -28,6 +28,7 @@ static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
>                 list_add(&e->list, &gating_cfg->entries);
>         } else {
>                 struct sja1105_gate_entry *p;
> +               struct list_head *pos = NULL;
> 
>                 list_for_each_entry(p, &gating_cfg->entries, list) {
>                         if (p->interval == e->interval) {
> @@ -37,10 +38,14 @@ static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
>                                 goto err;
>                         }
> 
> -                       if (e->interval < p->interval)
> +                       if (e->interval < p->interval) {
> +                               pos = &p->list;
>                                 break;
> +                       }
>                 }
> -               list_add(&e->list, p->list.prev);
> +               if (!pos)
> +                       pos = &gating_cfg->entries;
> +               list_add(&e->list, pos->prev);
>         }
> 
>         gating_cfg->num_entries++;
> --
> 
> > 
> > Thanks for the suggestion.
> > 
> >> 	}
> >> 
> >> 	gating_cfg->num_entries++;
> >> -----------------------------[ cut here ]-----------------------------
> > 
> > [1] https://lore.kernel.org/linux-kernel/20220407102900.3086255-12-jakobkoschel@gmail.com/
> > 
> > 	Jakob
> 
> Thanks,
> Jakob
