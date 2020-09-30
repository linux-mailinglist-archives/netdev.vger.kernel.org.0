Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9035F27E69B
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgI3K2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728500AbgI3K2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 06:28:39 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C93C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 03:28:39 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id l24so1228076edj.8
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 03:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lwMTRW6BoFX6PFJLAwI7KW93mhY9PjL0VO6roDQakQ4=;
        b=VQkUvaxrVaSLWbeMNGV4Z5R/udSt9x1jRpRQsy3ygDm4ctHYzRpZTvRjjT1eldBJsh
         iFF8UbVxduqIJy2IzWHIiOeF/ii+kNdi7rSUdrb/M+Y3rTA8wbPkernCkeoEAJ/IrTIB
         it/tYtpIUMwf4pPsiiyBHyL5x2qN8QP9KY+dWCHh3oLj4ZSrCkPNkUfgRxhMF6kVuzF9
         Rg7r3SpblQ4fRgaR1y/V2fu3yB1/XVAjwJeScTxyJhqCSmwlwvXLCxZ0l+FNUMww4C8S
         oepWZYMDb+SLurNkA1QgTQ3XGK/jihsaMGxtk1zx6FE0rl0FYY1DP5O0wm9jQ/4hHSf7
         yBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lwMTRW6BoFX6PFJLAwI7KW93mhY9PjL0VO6roDQakQ4=;
        b=t9PszVDncmAaIi8NXMzFmUDxfvLo3VvZK5WDSmKZr5P0N1m2ezLl+kMeWLvb0WQbQK
         vGeuKN4fhy26i/52uWU92QV1UUN+3Af0GvEB5OYKcEHOlBi7BBbp1FRa1H6QoUxBQE6d
         21GEKiF8FuBzy/qB/PrvNU1qNWKS1xQlhrVGNe4Fzjv5LakSoY1srpOSixk1SatWH15V
         b1Vf4dkbPphIL4iX5nsiMUrsb527VMhzbubXyhCYyWVChAOt4ntBRED9z394SHnZfwOF
         S11YeoQR6Sm+54eBBR0aCfYunY1f8fdTe2njqAtb+ezUr0nXe/Gs8qggoFIDctsYaY+R
         P49w==
X-Gm-Message-State: AOAM531qPryc83TLHY7b6h4La96+DO+oIOqbiNxh2UV/ghgLZyEBKpiW
        FS7J+nDNBeVB7ybF8EOlVocWaUU+98w=
X-Google-Smtp-Source: ABdhPJxDJAVWDMsEojnDXl29IqK0xB11+6QoqhreHKHzIdUZM03fma2/G79EjuMAG1bNgktfi31wmg==
X-Received: by 2002:a50:cdd1:: with SMTP id h17mr1995046edj.94.1601461717646;
        Wed, 30 Sep 2020 03:28:37 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id bx24sm1207457ejb.51.2020.09.30.03.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 03:28:37 -0700 (PDT)
Date:   Wed, 30 Sep 2020 13:28:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Peter Vollmer <peter.vollmer@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Subject: Re: dsa/mv88e6xxx: leaking packets on MV88E6341 switch
Message-ID: <20200930102835.4ee4mogk7ogom35j@skbuf>
References: <CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 12:09:03PM +0200, Peter Vollmer wrote:
> lan0..lan3 are members of the br0 bridge interface.

and so is eth0, I assume?

> The problem is that for ICMP ping lan0-> eth0, ICMP ping request
> packets are leaking (i.e. flooded)  to all other ports lan1..lan3,
> while the ping reply eth0->lan0 arrives correctly at lan0 without any
> leaked packets on lan1..lan3.

What are you pinging exactly, the IP of the eth0 interface, or a station
connected to the eth0 which is part of the same bridge as the lan ports?

Thanks,
-Vladimir
