Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC3A4F6D5F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbiDFVvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236021AbiDFVvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:51:32 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6E82DD5;
        Wed,  6 Apr 2022 14:43:43 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id y32so6372489lfa.6;
        Wed, 06 Apr 2022 14:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tQdULofGEXnLLkXThn3QLVn2+opvnb8m2rYcqZVj6ss=;
        b=c7S17lyahnFPWS103PJz1M/4xDG/JwVOeKR+bbLCLJIynT9xbElW1BiGLGd2K9aFeH
         HYXwM0S70vdUSeCAEm9SWHBgGUHL0AKot27lU6DfprS5Y7euD3frV7y11VN47XZP7bZW
         ejDCxT4a3msHLLLx939iviEisju4Yz0d3F2Bz/pqsmf3RTi/nPXuJDaGzWsoSLNDpNcr
         Q3VWcgDRGhZOiRIW6ePV6niUUKMHqrp2DUqSyeIp5XdMkuYrX4VPCAiVwPwJunpnaP1N
         PNOSLQI9I+iGWA6r29THe43vVx/+D9Om7PqCRZUayzM9wVpR6cjA2IjhDwK9u28CCO4B
         veOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tQdULofGEXnLLkXThn3QLVn2+opvnb8m2rYcqZVj6ss=;
        b=ACnjCaK6mwm6THNKlK1jYyOql+MVHy1HxlfKDVrqef8gkM3Oezzm61eYx00FvgFG6b
         F4ujStvpvn8trX6RksHiGvx13kcutdgpAzgmLKDZDucYdAvElqKx+F5Azk1xih1p9vLG
         DUBV3ovtwpdVI8dcfpZ6fT3t3l3ZUploWk7IBMvGHrBUMRB9H2FmtrpdWnBnqW/f1dcS
         lyW02CjfPqFMPPw6v3w0Ptdjgyu63leBXQnlYkKiqJC7mVK/mzy/9aLZgQcLvvs84sGM
         hIElZC/pOZLZj2wrwSlxJWywhj73RI+IJDfm6YTuRkwQsMb3oqBUJ2ahE0OsqfYQNzdT
         A3xg==
X-Gm-Message-State: AOAM531nuqOt/uOlWYELyKp2s2nAvi5TjWvGrE81SiK/varOp8N/iHTQ
        +HuzYI372wf/Ipc0VnHLFNIT8CJsjO8ESgdUJew=
X-Google-Smtp-Source: ABdhPJxi0168OqF4sYhO3s8tK53Ch9FuI2THHnMoFmPIM/6lRBOfXIh2USSQoWABy/t9w1yDacMApp4wFRO5R3MKgbA=
X-Received: by 2002:a05:6512:22d3:b0:44a:518d:c23b with SMTP id
 g19-20020a05651222d300b0044a518dc23bmr7339421lfu.21.1649281421215; Wed, 06
 Apr 2022 14:43:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com> <20220406153441.1667375-6-miquel.raynal@bootlin.com>
In-Reply-To: <20220406153441.1667375-6-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 6 Apr 2022 17:43:30 -0400
Message-ID: <CAB_54W53OrQVYo4pjCpgYaQGVsa-hZ2gBrquFGO_vQ5RMsm-jQ@mail.gmail.com>
Subject: Re: [PATCH v5 05/11] net: mac802154: Create a transmit bus error helper
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Apr 6, 2022 at 11:34 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> A few drivers do the full transmit operation asynchronously, which means
> that a bus error that happens when forwarding the packet to the
> transmitter will not be reported immediately. The solution in this case
> is to call this new helper to free the necessary resources, restart the
> the queue and return a generic TRAC error code: IEEE802154_SYSTEM_ERROR.
>
> Suggested-by: Alexander Aring <alex.aring@gmail.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/mac802154.h |  9 +++++++++
>  net/mac802154/util.c    | 10 ++++++++++
>  2 files changed, 19 insertions(+)
>
> diff --git a/include/net/mac802154.h b/include/net/mac802154.h
> index abbe88dc9df5..5240d94aad8e 100644
> --- a/include/net/mac802154.h
> +++ b/include/net/mac802154.h
> @@ -498,6 +498,15 @@ void ieee802154_stop_queue(struct ieee802154_hw *hw);
>  void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
>                               bool ifs_handling);
>
> +/**
> + * ieee802154_xmit_bus_error - frame could not be delivered to the trasmitter
> + *                             because of a bus error
> + *
> + * @hw: pointer as obtained from ieee802154_alloc_hw().
> + * @skb: buffer for transmission
> + */
> +void ieee802154_xmit_bus_error(struct ieee802154_hw *hw, struct sk_buff *skb);
> +
>  /**
>   * ieee802154_xmit_error - frame transmission failed
>   *
> diff --git a/net/mac802154/util.c b/net/mac802154/util.c
> index ec523335336c..79ba803c40c9 100644
> --- a/net/mac802154/util.c
> +++ b/net/mac802154/util.c
> @@ -102,6 +102,16 @@ void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
>  }
>  EXPORT_SYMBOL(ieee802154_xmit_error);
>
> +void ieee802154_xmit_bus_error(struct ieee802154_hw *hw, struct sk_buff *skb)
> +{
> +       struct ieee802154_local *local = hw_to_local(hw);
> +
> +       local->tx_result = IEEE802154_SYSTEM_ERROR;
> +       ieee802154_wake_queue(hw);
> +       dev_kfree_skb_any(skb);
> +}
> +EXPORT_SYMBOL(ieee802154_xmit_bus_error);
> +

why not calling ieee802154_xmit_error(..., IEEE802154_SYSTEM_ERROR) ?
Just don't give the user a chance to pick a error code if something
bad happened.

- Alex
