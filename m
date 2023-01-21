Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51DD67662D
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 13:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjAUMWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 07:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAUMWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 07:22:30 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB464B4AA;
        Sat, 21 Jan 2023 04:22:28 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ss4so20043161ejb.11;
        Sat, 21 Jan 2023 04:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3SKaqGxlLTOruxAEfhyIE3tn2v6Jlg90vsjCQFpbrcU=;
        b=Ou7VsmQ4pBul8LQ3FzD/j2o5IFJqZiIgdLzrhIsZcOXkcCjHc7aHGbBPULdyQEC3kq
         XAEnnSFXCXMk+WI9lguSowglbPu4crp+5MZPKK31CQRQjAscFK9FMD/hug6O6Bt/xWaL
         RvOptZIVDYyvZm+jMr7emKz6bxmaxxEDc25hSzanMfsy2BCws/aO5tlePjqX6jmoamuP
         AoAa6LVWMosZwLLiWQJQFbmN2wlcDY6Bf/HlL07YXAcORVpheJfzPFOiYORfJfCAdjEm
         2vpqqVrJmTnD0Sh3rbOvdtviP7iodMaliX6IHCG6uH95Dh/DRp2N2/WRw6Q5W7XM+1AN
         p7wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3SKaqGxlLTOruxAEfhyIE3tn2v6Jlg90vsjCQFpbrcU=;
        b=ARDgwtZLAYRQTOjOSEnNQ3vPzpLq5JVihtPzw+Y8Q7GWWxVuE0o5NwM1ackxDbL+yC
         CknwxD/onbBEJjiskx3xsxCU+0TooNXMvKOeBOete1t8PmgKRXzUKrxzihAxwDANyT0D
         tePZQDeE9ePlbmz7qf2VMA1ohTdV/9+2Or3xPf+0gZVJw3C6emN0PR1pwhDRsaynJzpR
         EaoyQUkXPzJrZxoeMzTiUH4IT+EPCZKAEAU3hQfka4w6BuCiS6vypw+D8dOX04pN7Tkg
         WavAQodY/pSKYe18ACi5fmvCCqDexnRUf1o6mKybBllP2HPUg+II9ujLlcr0o9jw1nDh
         zewQ==
X-Gm-Message-State: AFqh2koRD3teyrgBVHLJzNZfZH/nHWM2kvHROm4Vbw8nG/u7756dRd+k
        QlrrnYEeT6s8DAPHk0PMctM=
X-Google-Smtp-Source: AMrXdXsajmpkNuxC7LrPk9WotGHpwYyIoVaF3tOPPVe5ros48xvQQNOuArbDkn0ZfeP8SUKTQpBcVw==
X-Received: by 2002:a17:907:a710:b0:7c0:f71b:8b3 with SMTP id vw16-20020a170907a71000b007c0f71b08b3mr19916732ejc.57.1674303746669;
        Sat, 21 Jan 2023 04:22:26 -0800 (PST)
Received: from skbuf ([188.27.185.42])
        by smtp.gmail.com with ESMTPSA id k24-20020a1709065fd800b0087329ff5922sm6679897ejv.139.2023.01.21.04.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jan 2023 04:22:26 -0800 (PST)
Date:   Sat, 21 Jan 2023 14:22:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>
Subject: Re: [BUG] vlan-aware bridge breaks vlan on another port on same gmac
Message-ID: <20230121122223.3kfcwxqtqm3b6po5@skbuf>
References: <trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36>
 <20230120172132.rfo3kf4fmkxtw4cl@skbuf>
 <trinity-b0df6ff8-cceb-4aa5-a26f-41bc04dc289c-1674303103108@3c-app-gmx-bap60>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-b0df6ff8-cceb-4aa5-a26f-41bc04dc289c-1674303103108@3c-app-gmx-bap60>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 21, 2023 at 01:11:43PM +0100, Frank Wunderlich wrote:
> > What happens in mt7530_port_vlan_filtering() is that the user port (lan0)
> > *and* the CPU port become VLAN aware. I guess it is the change on the
> > CPU port that affects the traffic to "wan".
> 
> interesting, and funny to see that vlan_aware on gmac is added, but not removed in else branch :p

it is... see "if (all_user_ports_removed)" in mt7530_port_set_vlan_unaware().

> > If this works, I expect it will break VLAN tagged traffic over lan0 now :)
> > So I would then like you to remove the first patch and try the next one
> 
> tried first patch, and wan stays working, now i try to figure out how i can access the vlan in the bridge to set ip-address..
> 
> ip link del vlan110 #delete vlan-interface from wan to have clean routing
> bridge vlan add vid 110 dev lan0
> bridge vlan add vid 110 dev lanbr0 self
> 
> how can i now set ip-address to the vlan110 (imho need to extract the vlan as separate netdev) for testing that lan0 still works?

ip link add link lanbr0 name lanbr0.110 type vlan id 110

Can you try the second patch instead of the first one? Without digging
deeply into mt7530 hardware docs, that's the best chance of making
things work without changing how the hardware operates.
