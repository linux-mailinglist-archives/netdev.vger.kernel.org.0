Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F7E511B48
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238363AbiD0Ono (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 10:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238330AbiD0Onm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 10:43:42 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FD5340C0
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 07:40:29 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id bd19-20020a17090b0b9300b001d98af6dcd1so5162388pjb.4
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 07:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aV4SkJgzLHhRNXNACa/rCmPA9pes/WRJ6Gs4z7zFMik=;
        b=FByGDC1LWHfvYXDiWSxUTj7lyZwwzph9OMV2G7SD/aK35DyPloN/ZuUvWneRRNmu2O
         Wm7zs3S2y/Kj3K10dDFkHvV4+GXzmHvENs3bnbZKl1qHzSJpqHr+0zQnGggPSzh0nSJ4
         p0x92XL7N/ME8Oww0KQeGJdlMfhiFJpuO7hh68H0quKTZW6EZ08jXNoSOYkNIcbeya+W
         9ySRHbNZzqZj1ev24C9v3F3o3U7ElKoPIZW08/ieUfmhdmHEWpH3yJD9aBFIixkuJsZz
         ePiRdeAi5cx5oQKjq8/VibKEu7EJLrC6VoVzcyZ/e+aoMCXfNggC6MzzhqoPfv09AmRo
         Vx6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aV4SkJgzLHhRNXNACa/rCmPA9pes/WRJ6Gs4z7zFMik=;
        b=VrSPc5eJcR5fc/B8A3aN9G8CbEDKNmYK3LvhTJ6EmNbxR1G/LTK6uX5F7eV3YstBVS
         Ex/ZSHEceBtwXm/ARCdDSdMY1OD2YvG9uD04NBqT/hD7bEfL1HSl8Ax2XrZr4KMMZqw1
         J8SvxPei/uSLqIDXb4iSfuNrEZ2WJqS2D7n6bSG/ut83wo5Ls5ogByrQkNan34sWg65w
         ZYPlsNKcUgnAXh2o5kQhQWt+EqIhS34NihFLmOOC0pjEvAppr+xHSVd2UyxHM7orKHrl
         QIVbQIXuwYQPFnVL0kZjEz9oMSLNkRL02+gDwqRZ9tM/g6X77Th+y6sm2AdHX5hR6VFL
         LkMg==
X-Gm-Message-State: AOAM5307u5WN3l88mFSBpLsOQ3J2Pus1fsKhQobNvYkGNGEv5bYKlXkT
        QyskKz2hNQqCF64T/2auMMM=
X-Google-Smtp-Source: ABdhPJx1lSTG3JMK3sgn+p0ht49TI60upiuaZzXVtOjwlAweCDvLVZgwtV4BfdbNcjDxDCzHAGyrvg==
X-Received: by 2002:a17:902:e80e:b0:15d:4397:2874 with SMTP id u14-20020a170902e80e00b0015d43972874mr6801635plg.54.1651070428949;
        Wed, 27 Apr 2022 07:40:28 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id l2-20020a17090a150200b001cd4989ff3fsm3196787pja.6.2022.04.27.07.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 07:40:28 -0700 (PDT)
Date:   Wed, 27 Apr 2022 07:40:25 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next v1 1/4] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220427144025.GA23991@hoboy.vegasvil.org>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-2-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424022356.587949-2-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 23, 2022 at 07:23:53PM -0700, Jonathan Lemon wrote:

> +static int bcm_ptp_adjtime_locked(struct bcm_ptp_private *priv,
> +				  s64 delta_ns)
> +{
> +	struct timespec64 ts;
> +	int err;
> +
> +	err = bcm_ptp_gettime_locked(priv, &ts, NULL);
> +	if (!err) {
> +		timespec64_add_ns(&ts, delta_ns);

When delta_ns is negative, this takes a long time to complete.

> +		err = bcm_ptp_settime_locked(priv, &ts);
> +	}
> +	return err;
> +}

Thanks,
Richard
