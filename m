Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784861D9EC9
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgESSG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbgESSG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:06:27 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4F2C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 11:06:25 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t40so32026pjb.3
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 11:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YWOuPR4PrDCRfaMivuTc8x4LL1AZb+i8za7lDbrGxyk=;
        b=zEar01uHVn4GDk/2XDaSDpDrh+xrfUketkpxvEUYRLtvssQiXKMMijutjAJyb0fTqY
         oe+1VS4W8sEebsRQb4eR9hZ/UbW5oAjOxA4pWpjKWZebgnJv72c6eE42+rZdwApRegxJ
         gFdUBP7aO5I/C+YOta4yW1RAg9o5PzPEMzGBKm54PElk6O0jJvggKs7PM92KJb7bOMP3
         0ycXMbOYtqGPal3EyEsYIXdyL8mV1juG4Jk26UbwPR3kz4sC/cDPnZrKvnD0Ajnc0Rku
         h+i2bgGoZPqb12D5gp009tQthzK44UhqZSkUx9VIx/Fa++n0IW9kiVvEFgmQkAPLo2dL
         6xkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YWOuPR4PrDCRfaMivuTc8x4LL1AZb+i8za7lDbrGxyk=;
        b=B0VvVlC/L2ikqSYL1hg+7bkWWvIa5CI77wqHfhAubxtNK5Uo+aEQmEdOmODaKciblG
         talw/IMzZ46B5FfMz+gpnzkZo7ANCVWz5B3hSnH7VwvMIiRr7/c+2qnbdIRPdGZmbz5S
         9CYAvkbI+7i0Qq06CAu1mvnVpOWEI2FOJ+ZGa8EKa2s6GDeQS0Z0FNtqGGbl+b5iBi0G
         tNcrzJYQk3f4xTtZE2LvBbbtuVWuhE3iFuqUwpQbJkDx7QITYNIOrVh7GwjkgYR9OUct
         azyaGuv81yJzb1iuQctfUoNVDTcxErBgBv5PpBVJSBns9TL7M7FHkkbfC0YdTKrs+JGj
         fRJw==
X-Gm-Message-State: AOAM532+R/nEvBYC+n3TH1MuPl9b13aWxj/X1eeOgv+Qm3lgU07Uy5dT
        3BZje9i2uE1YWHEJJlAhyyBvnw==
X-Google-Smtp-Source: ABdhPJwrEB3sjk3OrRJIEs3jt6X1sIjynnKRskWfR/+i3QZi4jA4bLOH7u/omN62xQbsiIiz+vZIJQ==
X-Received: by 2002:a17:902:d711:: with SMTP id w17mr723909ply.122.1589911585226;
        Tue, 19 May 2020 11:06:25 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q44sm196353pja.29.2020.05.19.11.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 11:06:24 -0700 (PDT)
Date:   Tue, 19 May 2020 11:06:10 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, kernel@mojatatu.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH iproute2-next 1/1] tc: report time an action was first
 used
Message-ID: <20200519110610.2c825a5c@hermes.lan>
In-Reply-To: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
References: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 May 2020 09:28:45 -0400
Roman Mashak <mrv@mojatatu.com> wrote:

> +	if (tm->firstuse != 0) {
> +		print_uint(PRINT_JSON, "first_used", NULL, tm->firstuse);
> +		print_uint(PRINT_FP, NULL, " firstused %u sec",
> +			   (unsigned int)(tm->firstuse/hz));
> +	}

The JSON should report in same units as non-json output.

If you are copying what expires does, it is wrong as well.
