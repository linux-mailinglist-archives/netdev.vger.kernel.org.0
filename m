Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355546771C9
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 20:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjAVTRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 14:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbjAVTRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 14:17:10 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F5F17CF2
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 11:17:09 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id v3so7544885pgh.4
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 11:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dPUMxJc47QvVSrh7IXwvzeiCcvh7+i5hg0R4yp+BOcA=;
        b=p6lOcXaQ0b3ir7xP/ILQjbf9rsrYhEyJsxw6oaoxpHUvqTMAwZjJ34Ey1PgGfwCs9M
         cwovxNuARe8QhVa8lVr8KXsVuQCaHqKg/AGTdRpq+wTYzqnyCjZ200T3LjP2+Am3JAWM
         oj7vUyv+24NpjAVJHeS4imzZrq9FrWkSCzJDCsRsxzKf/msG5gK7qJU1uojs7F5sLpgH
         x8hMFoHYPv4f+85CCb8M2UJISXGrRgBkb4r1DVbYEDY240MzvT7flz1X8EVbu936TX88
         vYxW+gj/RiisCscLcfJkKZBbaSsswjFJnEOTfLIkDPGw0UdTl3hJX+42CdnLjUIiyNfB
         QD8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dPUMxJc47QvVSrh7IXwvzeiCcvh7+i5hg0R4yp+BOcA=;
        b=Th8WdGs5CHlCxQWkkKMb6CMVgqgLkAreLmaKsq5j6cLobkp2qSjOs5VkcpAxtQgO88
         WqbAAkSYlQJNIhqmKqh/Yrwf22idj3DPBfVSpYclRHlCHa1bKM7Yy/Bsl+sK+1OamzRO
         5wtKH/TS34LfEyanjWo1beFMAUTV77SEn5qYl3Scag2ars8ePy1fX86ykfr8xeSk70un
         di8BeLwOTDHL5qnKrJipjPgqPahFmWaLGxm3MnJICVrStMx6I+kJO7jdzFUzRsC19C6F
         yEiS55QEdE5O/fI9O32W+ddY8kV6oJNlSpQgf0MHT9WLFSpUBc3JwNPjnqjhPObVKS44
         1BRw==
X-Gm-Message-State: AFqh2kqyd59CsOw0YGPiKX6A8beRDjUHfNnjO1QyX8rIaiLQ00fjwiU0
        gr+86ZiRb5UG1XeiCzVM9CXBlA==
X-Google-Smtp-Source: AMrXdXtvdlKkUogp3q1umzSyPiq1qbZCFPdtOdMswPpylGEoFpyViORCbyaGs6NqBaQ+mGksQPXzmQ==
X-Received: by 2002:a05:6a00:705:b0:58b:ca40:cd03 with SMTP id 5-20020a056a00070500b0058bca40cd03mr21546688pfl.15.1674415029114;
        Sun, 22 Jan 2023 11:17:09 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id t25-20020a62d159000000b0056bd1bf4243sm14767842pfl.53.2023.01.22.11.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 11:17:08 -0800 (PST)
Date:   Sun, 22 Jan 2023 11:17:07 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Diederik de Haas <didi.debian@cknow.org>
Cc:     Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org (open list:ISDN/mISDN SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] mISDN: Fix full name of the GPL
Message-ID: <20230122111707.68ddead6@hermes.local>
In-Reply-To: <20230122181836.54498-1-didi.debian@cknow.org>
References: <20230122181836.54498-1-didi.debian@cknow.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Jan 2023 19:18:36 +0100
Diederik de Haas <didi.debian@cknow.org> wrote:

> Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
> ---
>  drivers/isdn/mISDN/dsp_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
> index 386084530c2f..593bdb2a7373 100644
> --- a/drivers/isdn/mISDN/dsp_core.c
> +++ b/drivers/isdn/mISDN/dsp_core.c
> @@ -3,7 +3,7 @@
>   * Based on source code structure by
>   *		Karsten Keil (keil@isdn4linux.de)
>   *
> - *		This file is (c) under GNU PUBLIC LICENSE
> + *		This file is (c) under GNU GENERAL PUBLIC LICENSE
>   *
>   * Thanks to    Karsten Keil (great drivers)
>   *              Cologne Chip (great chips)

No, this is not the current practice.
Instead replace this with proper SPDX header.
