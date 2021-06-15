Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B718E3A8C66
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 01:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhFOXYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 19:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhFOXYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 19:24:52 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6F7C061574;
        Tue, 15 Jun 2021 16:22:46 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r7so112694edv.12;
        Tue, 15 Jun 2021 16:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FxfsBpDXBnHU5zWC0aXIVdC3YjeHh8EVfTtRxdU+aGg=;
        b=sjSTJKq02zbkrU6rL1kU1gbsiyIcbp7YshKXr1Rln+yriNXBnUnEGwJ0gf3m1e0K3x
         mzde/HHJLnQ4y5aOx6HZ6EazpfXGTWRAce0QsJ44DNcNhWbKdNLpjndJMp8QBfb/MaJQ
         Bx3YfJOk0B+Y3fSqxOq9ZALPJtU/nsGnpIIVHhgx8F6/xFlc/kNfoRkGUpfpDmG5K+Ra
         NyP6+TN5PJqM6NxTCnNxQJnHtmBcS+6LELdqn9AFM+8h4WS1diz4QAbggRQ2DXW3BuvU
         LgRoeVgCRfhrtEWyYDLJGhds+x5/5DCgRHikPAO7BKkMDbIjsV/VwKYWVKaJg3Ohx6ss
         4VUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FxfsBpDXBnHU5zWC0aXIVdC3YjeHh8EVfTtRxdU+aGg=;
        b=FCxxBg1yVu02s3VwyoNUsITM/6jAmz43pS06v/xGQ5URIn17kG4ZYd2Z1grYYy9mX8
         4hCXLGXGpBgWnP0bQ4tdRme2ed9ucTxFE9XFmNjstO3RKWPpDtgIM3SQNHfRN7JTVNR7
         RUwnKfaOJKTQSnEzoqyDe/6/jGHMk5fDRBy17T5Azpiygn0sl5lFY5v3lDGquXNCV9JH
         CRMjKv+WJ9Nf9oiFKGZW93wxLPvtNJh2dVnUSQnNt5AmO8qa2M6p6VN33N2qcYaYpyrv
         thTtLam9ATf3noeTchUfHu//JGeNrHCNQEVEepEG5IwakdRGgToiie1MWtFsYaYniuO6
         2IrA==
X-Gm-Message-State: AOAM531xJTMJ/TSSBSxaDLAKjv9bdrqxVVD9Gu6AKwUy/dGm7p+LmxLb
        XaYKeuFoGpnE7UoYhSm8TFc=
X-Google-Smtp-Source: ABdhPJxPjKML4MPDVGh68x1BOga5oAFqhAyU2K0DldjLOUXsLq5pStJ+EWA1elUobE2vkPr8xjCa+g==
X-Received: by 2002:aa7:d5d6:: with SMTP id d22mr647546eds.302.1623799364697;
        Tue, 15 Jun 2021 16:22:44 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id j22sm234017eje.123.2021.06.15.16.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 16:22:44 -0700 (PDT)
Date:   Wed, 16 Jun 2021 02:22:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: xrs700x: forward HSR supervision
 frames
Message-ID: <20210615232242.3j4z5irr7abfhtwz@skbuf>
References: <20210615175526.19829-1-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615175526.19829-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 12:55:26PM -0500, George McCollister wrote:
> Forward supervision frames between redunant HSR ports. This was broken
> in the last commit.
> 
> Fixes: 1a42624aecba ("net: dsa: xrs700x: allow HSR/PRP supervision dupes
> for node_table")

It would be good if you could resend with the Fixes: line not wrapped
around. There are several scripts around which won't parse that.

> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---

Otherwise the change looks reasonably clean, and it agrees with what IEC
62439-3:2018 does seem to imply in "5.3.4 DANH forwarding rules" that
HSR_Supervision frames should be forwarded and without discarding
duplicates. For PRP, of course the DANP does not forward packets between
the redundant ports, so it does not forward PRP_Supervision packets
either.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
