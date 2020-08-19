Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D623249493
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 07:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHSFqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 01:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgHSFqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 01:46:02 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3E5C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 22:46:02 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a79so11101332pfa.8
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 22:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o+vKc4CQQyYSW3zCEgKa+Pv83aUX8pW+C0u+hputnP4=;
        b=nVnxWVL1ATKmyvnJHVd37014t5+XZL1NuUT6MGDBHvAsXGdhkWMfMOPjSFdBtq7U7m
         ojXmUNSG3tIIdlxuWDBpvbvK504Bdq+M70q0ycapEhCHW1xMb39N5VESA3BcY3v2cKmh
         YKR+gEhJbNKvwjEFAp6M9KaN9Z0TQ3TWPuie20gTDVPhLSHHIjCDPjM+DV7RNZmED3kI
         lWXjI1d7Iq5fEUDhwII4ZRV05jBhb2zezXeIqubwUztxASHUjmwh4vzY+ZXkFL2rLKMn
         8rTAu8U+ZvayCmom/hy8S22ZsMBpAV/c/z5gY6HtTUz2XtJO2ncTZblu3aVpfaVxHwJd
         R7uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o+vKc4CQQyYSW3zCEgKa+Pv83aUX8pW+C0u+hputnP4=;
        b=RojhSmzHNSq38y1dG13BZEPPNlx2iNrZhFwHYXa5vIwSSM7X501UKUcURcdRa5qnmY
         p6+2MFcfXoJDD+0L/cKqrqsPHOHx8rVWoId08Y0W02cmEQHBAPMAR32DrqCSJC10yOsz
         oiH5yOoo8s9/FhIl2qWL4xJUhlttjgZLzBEhfbu2lwY3nuaf+vVoRq6z0keOqILGlUrH
         WVCRUnDgKJfg9BP9SHSZViHUz7F3PpsgjGTmpJZRy6tDA9QYmHfHHq/hGkJoHo+r5SwR
         5Iqq7UgNZmZt9Yqrf6wnoU5BUyOPKK99k9XlIYQQZS2I3CyIW5/FI7kGItyHBDCaJ8F9
         ZDcg==
X-Gm-Message-State: AOAM532fWi6u7Y9nNqiueSzeGcIB9xuabHhrqguKSKXV8YxKJr4M6ob8
        ohfZ44TyTsu5H6BlnJ6rFLL5qQ==
X-Google-Smtp-Source: ABdhPJzQkWvTHlyXHMrxqbPTniBCavZPyHEf582sYtQFCnkSxK5sfzuOjT0XBQ4uaKrTrwe+QaOvig==
X-Received: by 2002:aa7:9a1c:: with SMTP id w28mr14484460pfj.116.1597815962103;
        Tue, 18 Aug 2020 22:46:02 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y128sm26693027pfy.74.2020.08.18.22.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 22:46:01 -0700 (PDT)
Date:   Tue, 18 Aug 2020 22:45:53 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wei Wang <weiwan@google.com>
Cc:     netdev@vger.kernel.org, Mahesh Bandewar <maheshb@google.com>
Subject: Re: [PATCH iproute2-next] iproute2: ss: add support to expose
 various inet sockopts
Message-ID: <20200818224553.71bfa4ee@hermes.lan>
In-Reply-To: <20200818231719.1813482-1-weiwan@google.com>
References: <20200818231719.1813482-1-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 16:17:19 -0700
Wei Wang <weiwan@google.com> wrote:

> +			if (!oneline)
> +				out("\n\tinet-sockopt: (");
> +			else
> +				out(" inet-sockopt: (");
> +			out("recverr: %d, ", sockopt->recverr);
> +			out("is_icsk: %d, ", sockopt->is_icsk);
> +			out("freebind: %d, ", sockopt->freebind);
> +			out("hdrincl: %d, ", sockopt->hdrincl);
> +			out("mc_loop: %d, ", sockopt->mc_loop);
> +			out("transparent: %d, ", sockopt->transparent);
> +			out("mc_all: %d, ", sockopt->mc_all);
> +			out("nodefrag: %d, ", sockopt->nodefrag);
> +			out("bind_addr_no_port: %d, ", sockopt->bind_address_no_port);
> +			out("recverr_rfc4884: %d, ", sockopt->recverr_rfc4884);
> +			out("defer_connect: %d", sockopt->defer_connect);

Since these are all boolean options why not just print them only if on?
That saves space and makes more compact output.

			if (sockopt->recverr) out("recverr, ");
