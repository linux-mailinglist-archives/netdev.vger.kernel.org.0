Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718405B2B28
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 02:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiIIAoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 20:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiIIAo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 20:44:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350DB25FF
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 17:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662684264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hnbfrm0fxnkfT77pKRHAtoPoWp5IuyuLVIfwMcIRkQ0=;
        b=gOqdX84FnShXWPO52ABppmB9fbRHlCKkGRoX0H7dFbWh+g5heomkZtpSY2a2w+NGe4FUk3
        WtAb2YbqTvrMn3rOMIrBf1PAoVp/stduG7Hgh7KWdqLMXWxBsfSjVs3x4z4+2ZXUSPVvyM
        TFssPFI9KWsgbXCLeQDljn0tMMxevis=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-37-nVwhKz-aM0mG6DRbHMBOMw-1; Thu, 08 Sep 2022 20:44:23 -0400
X-MC-Unique: nVwhKz-aM0mG6DRbHMBOMw-1
Received: by mail-il1-f197.google.com with SMTP id o5-20020a056e02102500b002ddcc65029cso107463ilj.8
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 17:44:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Hnbfrm0fxnkfT77pKRHAtoPoWp5IuyuLVIfwMcIRkQ0=;
        b=HLjKNG3692GNFvm3jOMFSeqrpMUQ8iHNt9zxiUN8xOD8TTh5iKqC7Ry5BMZGN28eT0
         zrC5HL0TTpCov8g0+H0HXkkMoVC3hHS9D4oGurO5bl7RyAUDTNuo1RYqza5JIzcAVEhs
         uFuSlnCOGs+Bp9Q6agwo+T8JYKBiD4IdMlzq4GAhzbCNy5ftm8TVEeQ8LEnVSldj08mE
         FZ4lAL7XcXEMQHwmY+sLEzZMMH5tQ/dTzh1BbqyBX08ubJGFy6kZlQMpc4M6UQRjLQH7
         VvQ0DOUbp+Jvp/aMHL8z/Y6lIEHlvuuu77BmxISghzEaftri5a57qORwPxNf2jSm0Dba
         Y/mA==
X-Gm-Message-State: ACgBeo3CsiZfxFeOtDJW/2ZNW9QHfw+tjaod4nejl+HTUXxNL2lBvlVW
        Pg4Q06fDPaLBYdrIHuQBq8Wdxe4yPibx8PqSy3UQEtNPBvfGlYmzw+xwNkqYmvYxRQznlzDbwHa
        f/aigJuWaQE5xZ4HrvrTI8apnDWSJbtCt
X-Received: by 2002:a6b:b296:0:b0:69e:70d9:a58a with SMTP id b144-20020a6bb296000000b0069e70d9a58amr316911iof.88.1662684262579;
        Thu, 08 Sep 2022 17:44:22 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7bxFyBqaxrihSG3S/0/TvBXfHZzFcdIrOhoVHqp8uTuYE1VkHB9WX/BOq7Uh22lBCYAERSCOEFtMEJ8Hq3wys=
X-Received: by 2002:a6b:b296:0:b0:69e:70d9:a58a with SMTP id
 b144-20020a6bb296000000b0069e70d9a58amr316900iof.88.1662684262378; Thu, 08
 Sep 2022 17:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com> <20220905203412.1322947-7-miquel.raynal@bootlin.com>
In-Reply-To: <20220905203412.1322947-7-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 8 Sep 2022 20:44:11 -0400
Message-ID: <CAK-6q+h_Qwx7heyoEm+BW85bhWLRb+BotN9qzpuRycp+gJNuVw@mail.gmail.com>
Subject: Re: [PATCH wpan/next v3 6/9] net: mac802154: Add promiscuous software filtering
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Sep 5, 2022 at 4:34 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Currently, the promiscuous mode was not as open as it should. It was not
> a big deal because until now promiscuous modes were only used on monitor
> interfaces, which would never go this far in the filtering. But as we
> might now use this promiscuous mode with NODEs or COORDs, it becomes
> necessary to really forward the packets to the upper layers without

no, they should never deliver to upper layers in filtering modes where
address filtering is disabled.

> additional filtering when relevant. Let's add the necessary logic to
> handle this situation.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/mac802154/rx.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> index bd1a92fceef7..8a8c5a4a2f28 100644
> --- a/net/mac802154/rx.c
> +++ b/net/mac802154/rx.c
> @@ -196,10 +196,31 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
>         int ret;
>         struct ieee802154_sub_if_data *sdata;
>         struct ieee802154_hdr hdr;
> +       struct sk_buff *skb2;
>
> +       /* Level 2 filtering: Avoid further processing in IEEE 802.15.4 promiscuous modes */
> +       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +               if (!ieee802154_sdata_running(sdata))
> +                       continue;
> +
> +               if (sdata->required_filtering < IEEE802154_FILTERING_1_FCS ||
> +                   sdata->required_filtering > IEEE802154_FILTERING_2_PROMISCUOUS)
> +                       continue;
> +

I am confused about using "sdata->required_filtering" here.

> +               skb2 = skb_clone(skb, GFP_ATOMIC);
> +               if (skb2) {
> +                       skb2->dev = sdata->dev;
> +                       ieee802154_deliver_skb(skb2);
> +
> +                       sdata->dev->stats.rx_packets++;
> +                       sdata->dev->stats.rx_bytes += skb->len;
> +               }
> +       }
> +

I am confused about this change here.

- Alex

