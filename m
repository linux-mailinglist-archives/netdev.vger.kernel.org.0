Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877D66014A3
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 19:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiJQRT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 13:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiJQRT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 13:19:26 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF9AC4A;
        Mon, 17 Oct 2022 10:19:21 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z97so17028545ede.8;
        Mon, 17 Oct 2022 10:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rMglibETToQb8dPBGbxr6FHH36nbwiMc9pZGdb7n6oM=;
        b=oveX0QP/1N8fJTSTxdiHHnuTEpvHY3UoN5/Ttgaqtdr3V1PKGHIJ1p7mzauGSspEX5
         U3MZwy2+ysRYw3K/b7UI3LJTG3uPNJ6EbrYkts/lmuU+DhcC6Sfx2u2kzdw74mj8a/ms
         NCsDdLSxxR2CstXwWD+rq1uHqfdCufrm99Pg1owPBIANoOdiI63bgxmKmwEB4/uLPuoU
         BLIdGM5QhWH0JlQmJLtKKOcWchP7n8fJBmItH+ijHhl6hDwuY2wG2kIcFdxXmHllda+c
         AWsXB18A2C2i6kGBB4F78Cxf0oF07+++WAQzLbGPV8poYaKDun2+DIQaGYhx5claJrpY
         Rc8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rMglibETToQb8dPBGbxr6FHH36nbwiMc9pZGdb7n6oM=;
        b=KBbtuHo/bGSLF8+cn+kPXRF+A9t0Dg3AN9otGdsuUZrb5iAAxLiM+qLmAdQBPcIP10
         n0bcfg5Nl/ZNqxK9nxFzT3hIYqY4UffROy5aLClwG19MUKSMqx4PQEy2XYJasiY+PXO/
         80jro/zhZ/JZu13dirIiyrCqxkoKIozl5lelHXTAHqqWTrVwjZ55Gco/WhiEz8EqdShh
         YsaZeqyqIvFuIKZ0Im9esS98SUaJ+KDrEGsZvCVf6BJD4bGAvUizVR5J4JH7c0GWISlI
         DffB/1FyOxtSRnEzjGJ0ojZvjqvhkA6v4yQxWkC8wgTi9Dj9329gEsv9Em2Ln+j3pWTI
         6LFA==
X-Gm-Message-State: ACrzQf30Ha1/i0Jo0l0zZUyBtB/nYeJqIR3/ezwp6YuKyHts6fseWGKB
        yPeyyoz/UwfZ17ftcdmxYYuP1UjQTOc=
X-Google-Smtp-Source: AMsMyM7q5L8G70qX89ejUU9HnhYARrJxMRcNM7opEgbDiC+f1m6kauangYtrOL6XhA6NklFlg2uzgg==
X-Received: by 2002:a05:6402:320e:b0:45c:ae50:dbca with SMTP id g14-20020a056402320e00b0045cae50dbcamr11321231eda.104.1666027160328;
        Mon, 17 Oct 2022 10:19:20 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id q7-20020a170906540700b0078d9cd0d2d6sm6564554ejo.11.2022.10.17.10.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 10:19:19 -0700 (PDT)
Date:   Mon, 17 Oct 2022 20:19:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de, b.hutchman@gmail.com
Subject: Re: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support
 for LAN937x switch
Message-ID: <20221017171916.oszpyxfnblezee6u@skbuf>
References: <20221014152857.32645-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014152857.32645-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

On Fri, Oct 14, 2022 at 08:58:51PM +0530, Arun Ramadoss wrote:
> The LAN937x switch has capable for supporting IEEE 1588 PTP protocol. This
> patch series add gPTP profile support and tested using the ptp4l application.
> LAN937x has the same PTP register set similar to KSZ9563, hence the
> implementation has been made common for the ksz switches. But the testing is
> done only for lan937x switch.

Would it be possible to actually test these patches on KSZ9563?

Christian Eggers tried to add PTP support for this switch a while ago,
and he claims that two-step TX timestamping was de-featured for KSZ95xx
due to hardware errata.
https://patchwork.ozlabs.org/project/netdev/patch/20201019172435.4416-8-ceggers@arri.de/

> 
> Arun Ramadoss (6):
>   net: dsa: microchip: adding the posix clock support
>   net: dsa: microchip: Initial hardware time stamping support
>   net: dsa: microchip: Manipulating absolute time using ptp hw clock
>   net: dsa: microchip: enable the ptp interrupt for timestamping
>   net: dsa: microchip: Adding the ptp packet reception logic
>   net: dsa: microchip: add the transmission tstamp logic
> 
>  drivers/net/dsa/microchip/Kconfig       |  10 +
>  drivers/net/dsa/microchip/Makefile      |   1 +
>  drivers/net/dsa/microchip/ksz_common.c  |  43 +-
>  drivers/net/dsa/microchip/ksz_common.h  |  31 +
>  drivers/net/dsa/microchip/ksz_ptp.c     | 755 ++++++++++++++++++++++++
>  drivers/net/dsa/microchip/ksz_ptp.h     |  84 +++
>  drivers/net/dsa/microchip/ksz_ptp_reg.h |  68 +++
>  include/linux/dsa/ksz_common.h          |  53 ++
>  net/dsa/tag_ksz.c                       | 156 ++++-
>  9 files changed, 1192 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/net/dsa/microchip/ksz_ptp.c
>  create mode 100644 drivers/net/dsa/microchip/ksz_ptp.h
>  create mode 100644 drivers/net/dsa/microchip/ksz_ptp_reg.h
>  create mode 100644 include/linux/dsa/ksz_common.h
> 
> 
> base-commit: 66ae04368efbe20eb8951c9a76158f99ce672f25
> -- 
> 2.36.1
> 
