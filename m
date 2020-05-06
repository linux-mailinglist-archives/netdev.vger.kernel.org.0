Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124A51C7438
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 17:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgEFPVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 11:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729443AbgEFPVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 11:21:49 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945CBC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 08:21:48 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a5so1062666pjh.2
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 08:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l3dvl4KUVW6lOYjk9hPMXPvcXmJ6hlVZhKPWrOvasd0=;
        b=XsLCj3cbL0qXcpaGnYJ+pvkth0mpbhYdjiVyqlK1a4thH9KlvZQ6S9vg0C5M5uuMCM
         mASFpDbRVQRlfUdKJYhvC1nXCdOWvgwjWZ0X+QA/IJKG2AFDb9YKiSAF/ft4dR4pwuKC
         DlyUogAWlJAU6XfQVAfQIoC92KD8eYuzCQjM3vMVIuOajaWBVre2GEXpCCUa5MG6IU+0
         Hi3yXyMUjrPsa9S9QybHlcZVDBGptarfLfubZAzlGAmhQutDUJ3g+xLR0lc1KLO+28A2
         kmazSm1h1IKzKZCXYaTck5/J0d9yJ9HENYKVDD1uq1QrakTyxGNd7DqwBKdJcprUJBxq
         2loA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l3dvl4KUVW6lOYjk9hPMXPvcXmJ6hlVZhKPWrOvasd0=;
        b=Gwgu9u5Bi3Y6UvDX143oF3xj8DMa0hVc0lfdX19+hb+UX7NNzY9JkN2UGEtxKzEXjy
         4Rz8JihC3j2zpTidU53T47RVRtxH5ZMapMPKKrReLpfYlf7RFyvqW9qC3GFhqCCo3t84
         pyogVI1s3qVpTjohx4SQam7OgInBE8OycKUsMWlwLQhlZEuUUQpRLPt1Ua2OHVZXYVg8
         9SZyhrJIzw+1aRkvikplQHorGcAJac4Ht54zh1Z/XTJh6jDsKMA5I21+dgjlLJOfWz6r
         Nqmdhlh6bjudASHHarbpKxKt5HvHshJ6gXYNbnWs3g2JaqF+KPAl4dmJ9MJJGYrmLlSU
         AsAA==
X-Gm-Message-State: AGi0PuaR4Foa/1wJbdzrR4Fr1z/PmSlJeeTgQ18cjeUwqvfCQDvdTZYf
        XETe4g/iU/z0Se0hcC+84Ufe7g==
X-Google-Smtp-Source: APiQypIRqbdsbg6eMigkHYaGO2ldIooYnkYRCiQwznGcabDVCdyPDkuqXpty5XxiCeBTGEXP0X35Yw==
X-Received: by 2002:a17:90b:19d7:: with SMTP id nm23mr8124949pjb.211.1588778508025;
        Wed, 06 May 2020 08:21:48 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a17sm2190402pfr.24.2020.05.06.08.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 08:21:47 -0700 (PDT)
Date:   Wed, 6 May 2020 08:21:39 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Po Liu <Po.Liu@nxp.com>
Cc:     dsahern@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vinicius.gomes@intel.com,
        davem@davemloft.net, vlad@buslov.dev, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com
Subject: Re: [v4,iproute2-next 1/2] iproute2-next:tc:action: add a gate
 control action
Message-ID: <20200506082139.58dff261@hermes.lan>
In-Reply-To: <20200506084020.18106-1-Po.Liu@nxp.com>
References: <20200503063251.10915-2-Po.Liu@nxp.com>
        <20200506084020.18106-1-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 May 2020 16:40:19 +0800
Po Liu <Po.Liu@nxp.com> wrote:

> 		} else if (matches(*argv, "base-time") == 0) {
> +			NEXT_ARG();
> +			if (get_u64(&base_time, *argv, 10)) {
> +				invalidarg = "base-time";
> +				goto err_arg;
> +			}
> +		} else if (matches(*argv, "cycle-time") == 0) {
> +			NEXT_ARG();
> +			if (get_u64(&cycle_time, *argv, 10)) {
> +				invalidarg = "cycle-time";
> +				goto err_arg;
> +			}
> +		} else if (matches(*argv, "cycle-time-ext") == 0) {
> +			NEXT_ARG();
> +			if (get_u64(&cycle_time_ext, *argv, 10)) {
> +				invalidarg = "cycle-time-ext";
> +				goto err_arg;
> +			}

Could all these time values use existing TC helper routines?
See get_time().  The way you have it makes sense for hardware
but stands out versus the rest of tc.

It maybe that the kernel UAPI is wrong, and should be using same
time units as rest of tc. Forgot to review that part of the patch.
