Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B314C205B
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245115AbiBXAE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiBXAEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:04:55 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0002458380
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:04:26 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id bq11so628640edb.2
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k3E3owO5jAgNxAnKygoiudxItlhS95jxkp0Afx/AE38=;
        b=UvtUAYhcbqEDaVr20rfQvsplzRJgOz4TWEh/TYbH/7FDPyLUetyhqp3JEh9oi5Kk7Y
         qwZDNAP16doAeApFuvl6hKjUZfOHMEpYViKvmDIkUpPcxjJ7SR+FHeknyK77KBcni0wX
         rCbpOLwFiYVRQKknVSL9pbRUeJ5f/sLt1U1mfMeqtGeoiKtIbt0KdXUxvdOAeUSMPr74
         t5hDGDTJki5EVkW9qRX68zbYtrJnCO8KFMc7We8MUx5lvA5eylfojMDgCnEtamRyqtX3
         K7hciDxfsNxFfbiMxWIdCRodoDbSJgetbMErgJTzlFnE0ygIZUVvxTflYtgVQkhmRn3m
         WRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k3E3owO5jAgNxAnKygoiudxItlhS95jxkp0Afx/AE38=;
        b=iUIcIdDOmXu4+xytbhFQD19Ijlgpmrf6SxBqUIYs4IWPpfT/mCKCsaK7q4SsM9YuHR
         cNPMMmc6vzPxBUi8Ac/13x0Yl0zg2bGgxr1SjPSsTP+s4ouVaaozacdFM3AQgczJjRTK
         GXSEpEY5WHVsUDwk5x2vubN7QSrAEbHvqtDAHRbKl2kE/haOvNx/o029HYLR0+LGjcAf
         y936Uu1G+1h2zFnkaeD9qwSdYcU0ac6058AoQXB+8P9N2Gd0l1ivXwzR5mPu5dgq+jFE
         hvUFbW9evOWpXxdWRngsp0CBOVdrPzepX5iu4mInTL0p9nKeEu8qSSNGicfNicIdmGhk
         /UFQ==
X-Gm-Message-State: AOAM532bg7z+iAD4ECi0BKIlkYTrkCmEZQ8j/OUBHNS38KIfrg+5LCW1
        YnkLt+Ao4wOBOZ/Zn0hvJzM=
X-Google-Smtp-Source: ABdhPJxg7nGrRU1F4ECKCxcbui03gP7AUX/Yil9aUxb3skz1R1Io0rjqM9ZmPiDOhYb5frfmg/dLOQ==
X-Received: by 2002:a50:9d06:0:b0:410:befc:dda7 with SMTP id v6-20020a509d06000000b00410befcdda7mr13966ede.443.1645661065514;
        Wed, 23 Feb 2022 16:04:25 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id go13sm465376ejc.190.2022.02.23.16.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 16:04:25 -0800 (PST)
Date:   Thu, 24 Feb 2022 02:04:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
Subject: Re: [PATCH net-next v3 1/2] net: dsa: tag_rtl8_4: add rtl8_4t
 trailing variant
Message-ID: <20220224000423.6cb33jf47pl4e36h@skbuf>
References: <20220222224758.11324-1-luizluca@gmail.com>
 <20220222224758.11324-2-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222224758.11324-2-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 07:47:57PM -0300, Luiz Angelo Daros de Luca wrote:
> diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
> index 02686ad4045d..2e81ab49d928 100644
> --- a/net/dsa/tag_rtl8_4.c
> +++ b/net/dsa/tag_rtl8_4.c
> @@ -9,11 +9,6 @@
>   *
>   * This tag header has the following format:
>   *
> - *  -------------------------------------------
> - *  | MAC DA | MAC SA | 8 byte tag | Type | ...
> - *  -------------------------------------------
> - *     _______________/            \______________________________________
> - *    /                                                                   \
>   *  0                                  7|8                                 15
>   *  |-----------------------------------+-----------------------------------|---
>   *  |                               (16-bit)                                | ^
> @@ -58,6 +53,28 @@
>   *    TX/RX      | TX (switch->CPU): port number the packet was received on
>   *               | RX (CPU->switch): forwarding port mask (if ALLOW=0)
>   *               |                   allowance port mask (if ALLOW=1)
> + *
> + * The tag can be positioned before Ethertype, using tag "rtl8_4":
> + *
> + *  +--------+--------+------------+------+-----
> + *  | MAC DA | MAC SA | 8 byte tag | Type | ...
> + *  +--------+--------+------------+------+-----
> + *
> + * If checksum offload is enabled for CPU port device, it might break if the
> + * driver does not use csum_start/csum_offset.

Please. This is true of any DSA header. If you feel you have something
to add on this topic please do so in Documentation/networking/dsa/dsa.rst
under "Switch tagging protocols".

Also, s/CPU port device/DSA master/.

> + *
> + * The tag can also appear between the end of the payload and before the CRC,
> + * using tag "rtl8_4t":
> + *
> + * +--------+--------+------+-----+---------+------------+-----+
> + * | MAC DA | MAC SA | TYPE | ... | payload | 8-byte tag | CRC |
> + * +--------+--------+------+-----+---------+------------+-----+
> + *
> + * The added bytes after the payload will break most checksums, either in
> + * software or hardware. To avoid this issue, if the checksum is still pending,
> + * this tagger checksum the packet before adding the tag, rendering any

s/checksum/checksums/

> + * checksum offload useless.

If you're adding a tail tagging driver to work around checksum offload
issues, this solution is about as bad as it gets. You're literally not
gaining anything in performance over fixing your DSA master driver to
turn off checksum offloading for unrecognized DSA tagging protocols.
And on top of that, you're requiring your users to be aware of this
issue and make changes to their configuration, for something that can be
done automatically.

Do you have another use case as well?
