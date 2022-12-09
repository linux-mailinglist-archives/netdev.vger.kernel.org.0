Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813276484DF
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiLIPUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiLIPUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:20:03 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2368C86F69;
        Fri,  9 Dec 2022 07:20:02 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id l11so3513154edb.4;
        Fri, 09 Dec 2022 07:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xXNJjFfBBaJNhkFhtPLNRdA2mpzp23T0XAuYEKh5TuQ=;
        b=k3N4vqZh5GBtondRSKfFjNrkh4/4+6GCP7qzt9V7TYkYMhF3fYrX9acjKaO9+odkpR
         JyUKfneLWengdirHfa8brzTqNXwgh/UwIe/UlvtDt+uulvf3TP7TExvu787LFJ12NfvW
         jrzH0YJGFdR4TBGxotJplBssQo3O7PSSQQVwZjpSwMz7lJu1acuOTTecuw0voQsDFCQh
         /MF7bYFInYgPWWLZxxSMD8n7cGP9JGFH4/REueMVit6wP8VHpE39wgHnQFKyQCq7b+hi
         R1GECg1jPjFKg5YoBgB5Ghg96UASjnv5N76uWaoBvMifJcanWbNYx7QU/It0ZSSLpgbm
         kzcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xXNJjFfBBaJNhkFhtPLNRdA2mpzp23T0XAuYEKh5TuQ=;
        b=iQ8Kf2I137u8nzp39kqsFTyN4BKKMy1QQo/W/Ejbx9j638QqSzUpiCOMVfpI9FF6ZA
         HKwqwoXQ17uBRSJFsCdmVx/hoOs9GITImAPRJ5kmkmXCRROaeinalf9/W4BfCo014YOQ
         lVRUFL9457Ly2QSmIGzm0c85RO56/psjUnzuAOKv4kNYYZjAfmdoDnb5GwMv80Lj+ocf
         DLE28QFl3oy6jARK4e1Mo+6IHbyVrzqbJESLizhqo9L7+C1041DMpurN0TBkss99ISkW
         vea5celq12xSnsXkSA2dPb1wRi2mTqIV/yXn/NaZVRbMVYPzAdTBCNSgYWJkwuxlTqqq
         ff+g==
X-Gm-Message-State: ANoB5pnEPStAwORq8h8ml6RtmHXZ6LPvYpF1a7OCFUYjh4w9pTj5UvES
        fnse8uhM9qMLLegYobBA2EU=
X-Google-Smtp-Source: AA0mqf7FozdXR7N/YWSg435PNkpW4+4mp/3n/OqhCGtNCQA5iJJvd3H6Qni6mL8tGkpeHe6NNvdgyA==
X-Received: by 2002:a05:6402:c2:b0:468:9bc4:1c7 with SMTP id i2-20020a05640200c200b004689bc401c7mr7497822edu.38.1670599200672;
        Fri, 09 Dec 2022 07:20:00 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id d14-20020aa7c1ce000000b00461bacee867sm750208edp.25.2022.12.09.07.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 07:20:00 -0800 (PST)
Date:   Fri, 9 Dec 2022 17:19:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v3 02/13] net: dsa: microchip: ptp: Initial
 hardware time stamping support
Message-ID: <20221209151958.4zquauqbruthv74p@skbuf>
References: <20221209072437.18373-1-arun.ramadoss@microchip.com>
 <20221209072437.18373-3-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209072437.18373-3-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 12:54:26PM +0530, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> This patch adds the routine for get_ts_info, hwstamp_get, set. This enables
> the PTP support towards userspace applications such as linuxptp.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> 

When you resend, could you also do something about these blank lines
after your sign off, here and in other patches? They shouldn't be there.
I think that a blank line will appear between this and other maintainer
sign offs.

> ---
> v1 -> v2
> - Declared the ksz_hwtstamp_get/set to NULL as macro if ptp is not
> enabled
> - Removed mutex lock in hwtstamp_set()
