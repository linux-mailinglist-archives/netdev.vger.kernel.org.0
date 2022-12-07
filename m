Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373F764580D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiLGKi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiLGKiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:38:13 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BE04667A;
        Wed,  7 Dec 2022 02:38:12 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id i15so16092116edf.2;
        Wed, 07 Dec 2022 02:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/vdOUq/hueGf9q04U2z4nVzVdAzw30oN6SpxZVu/XGc=;
        b=UD/XNwZFSHd5Nm0bGWgegEzUA2p7zIX4KEPlAZ5edg96CM5eayxHGUz+0AeXiIHsU5
         fB3ybtWHYakn9OQGNON8DUC/yIbxekcNiiBT/Dd9mPGf+jOZvvxwq+X75yy9iXnEzBLO
         P0GnIr3etA0EddcMY1DMqHff3camCmf1mtih3EPNiilBr8n1HERTjk+mLgblpwlrDAF5
         4aMj/EGakQKwuFvQSvmvXzEktO+cOI890Ig7Gv/Ddo2iC120Sfq2H7XGAsQ8ug7ZoGDS
         nwBipkeoYbDKbVQPR2tlB5oATI5P/2QnKD/uUtoVRC2geNOdbX4HvWNWjjAPgiv7iA9O
         jIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vdOUq/hueGf9q04U2z4nVzVdAzw30oN6SpxZVu/XGc=;
        b=Ae4c4vIBiq7NtQmH+z4jq4TQAvQVjkqFPGP9uZtBaUOQwrMdo4ay3J+3AlJ6XEkgjC
         iMXQNHMqD1TC3iePYhe3DKlIOxrp2wTL9HVSSnyLROQr+HwSyPMfKuFx+sanoVPWwvjo
         GF29yr/Rh6HCyi3c8pKi6RbsJvPmiob/ZQUZwQd9CNb3rHBN/Fe2GFvvjwGrzAcw7qXL
         2LNTkhBt+BL7+CEqdGxOMKJIX0g7TgZpEH9CldvRWOHYjfprJap2p5+AfIAvmLNYoGcT
         MFqh36gwyWGS8Vxl2WPTvAzQTlAZ9ucDtAxX7eFcDo/5yGWvRQzeCHzMZl7SR018S8zD
         y4Dg==
X-Gm-Message-State: ANoB5plY6lMk62ykLFQJLzRpJidQ3PrFJrTylGwXmkTtI9G4pjo41ylu
        H0FrzEMT8WYZfxJhsgOtvsw=
X-Google-Smtp-Source: AA0mqf7NZM4xj8rhfnuTtDvE+jQMy5TIAydlmPrToDuKD3X5TcbbG+sHDo6w1ElOA8B8q3nadQiQRg==
X-Received: by 2002:aa7:db90:0:b0:459:aa70:d4fd with SMTP id u16-20020aa7db90000000b00459aa70d4fdmr78260533edt.162.1670409491255;
        Wed, 07 Dec 2022 02:38:11 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id j17-20020a17090623f100b007c0d0dad9c6sm5431418ejg.108.2022.12.07.02.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 02:38:10 -0800 (PST)
Date:   Wed, 7 Dec 2022 12:38:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, ceggers@arri.de, Tristram.Ha@microchip.com,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Woojung.Huh@microchip.com,
        davem@davemloft.net
Subject: Re: [Patch net-next v2 07/13] net: dsa: microchip: ptp: add packet
 reception timestamping
Message-ID: <20221207103808.nfkvr2hwv5yud4uc@skbuf>
References: <20221206091428.28285-1-arun.ramadoss@microchip.com>
 <20221206091428.28285-8-arun.ramadoss@microchip.com>
 <20221206125344.rwheovbxdoad2duv@skbuf>
 <148ee662f8def0e63b81d9164d2fd7c0f7029cf7.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148ee662f8def0e63b81d9164d2fd7c0f7029cf7.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 06:00:27AM +0000, Arun.Ramadoss@microchip.com wrote:
> I looked into the sja1105 and hellcreek rxtstamp() implementation.
> Here, SKB is queued in rxtstamp() and ptp_schedule_worker is started.
> In the work queue, skb is dequeued and current ptp hardware clock is
> read. Using the partial time stamp and phc clock, absolute time stamp
> is calculated and posted.
> In this KSZ implementation, ptp_schedule_worker is used for maintaining
> the ptp software clock which read value from hardware clock every
> second for faster access of clock value.
> 
> Based on the above observation, I have doubt on how to implement. Below
> are the algorithm. Kindly suggest which one to proceed.
> 1. Remove the existing ptp software clock mainpulation using
> ptp_schedule_worker. Instead in the ptp_schedule_worker, dequeue the
> skb and timestamp the rx packets by directly reading from the ptp
> hardware clock.
> 2. Keep the existing implementation, add the rxtstamp() where it will
> not queue skb instead just process the timestamping with using software
> clock and KSZ_SKB_CB()->tstamp.

Search more, you'll find felix_rxtstamp() which is closer to (2) and to
what you need. There, reading the 64-bit PTP time is done in NET_RX
softirq context because the register access is over MMIO. That might
change in the future with the introduction of the SPI controlled VSC7512,
but for now it is a good example.
