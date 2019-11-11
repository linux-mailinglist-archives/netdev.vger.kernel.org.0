Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 511C1F7770
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 16:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfKKPNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 10:13:00 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:53086 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfKKPNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 10:13:00 -0500
Received: by mail-wm1-f43.google.com with SMTP id l1so2345443wme.2
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 07:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B0SKQVMaBiazT/Ub8cwg9vpH5k+7aSukWaFMu0C6vBg=;
        b=y+NNWiJ0R1XNto2SbrNIDaVAis7uPwNejRf2PaDKdARqsVNq8p4PdiXT3GS2oFrRNo
         LFYzPFGC0RzPuwfqw8EiTftB2ln3YmcddLXovb6LaqGETTBtfer8ZelMb8MhFgkd6TzS
         0RXS/dD0mreuD/AqMWaIOQtcJi75u9ab9O/F50RwlDW1vfoOo/bKcRg5B+QFVFAWNzLE
         0YTahywRyrsItODYzFaK6rqfP3TJCTiynJnwpHUzpCaqPbKCG8rGhIQ4b88Sclc5CBgi
         GPI4w+YS/qPigQ60hndaoyMcn7BlMYVqblgz3viIozPAdiM9VVHjTWw8q5m6sLlcwf0v
         OUHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B0SKQVMaBiazT/Ub8cwg9vpH5k+7aSukWaFMu0C6vBg=;
        b=Afdtn/73revH9Wp2XdB31SbGrbHgyErIMSxU1xo2n+w94NhwgKcCV5twn6aXPMULXa
         V6JdjA2O2H2d3L8XLExT2eV/WavlCDvT46Lv9/4XxKIsRW6H2PtkKhRkaiAhwfKuwIyD
         UaE9ItfoQCDyVpUXYfLyqr4SWpXS6fIla4mL/MbAKdg1iaXOJj7sH8+D/0OOeq8ocj9x
         dGH2C9SM0iowWgySaQCAY8sbH6WtA12AlmzYeEm0mWrVOmQ6OPrhT4fyZwlu9aGdI84p
         ntiglo+94G5SqaGrkHZvZ5pdiMF5VY+JPisN6aL+CYlIX2qVDUalvBGQTNyRH1dWeqoz
         ZU9Q==
X-Gm-Message-State: APjAAAVSA3QRggtX4+FUTDBI+PcA6lzvdbjOgzwMvoxnTmPxzM5OjCcl
        kgM2HiPSbg//4Di2R1qJVk9yuo1Og7I=
X-Google-Smtp-Source: APXvYqx0xVsJx9vZX4vKPlKvvmMI+EmhVA+LEwTaykrXjiQsfR+9qHrE0zc+4K4f7eHxEcj/W80S+w==
X-Received: by 2002:a1c:4c15:: with SMTP id z21mr19366559wmf.132.1573485178252;
        Mon, 11 Nov 2019 07:12:58 -0800 (PST)
Received: from apalos.home (athedsl-4484009.home.otenet.gr. [94.71.55.177])
        by smtp.gmail.com with ESMTPSA id 65sm32725886wrs.9.2019.11.11.07.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 07:12:57 -0800 (PST)
Date:   Mon, 11 Nov 2019 17:12:55 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: Regression in mvneta with XDP patches
Message-ID: <20191111151255.GA3614@apalos.home>
References: <20191111134615.GA8153@lunn.ch>
 <20191111143725.GB4197@localhost.localdomain>
 <20191111150907.GD1105@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111150907.GD1105@lunn.ch>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 04:09:07PM +0100, Andrew Lunn wrote:
> > looking at the dts, could you please confirm mvneta is using hw or sw buffer manager
> > on this board? Moreover are you using DSA as well?
> 
> So my reply to Ilias answered the first question. And yes, i'm using
> DSA. But that should not matter, mvneta is just receiving frames which
> happen to have an extra header after the two MAC addresses.
> 
In theory (famous last words) DSA or not shouldn't be affected by this. 
The driver was already allocating a page per packet before our changes. 
We just allocate that page via page_pool.

Thanks
/Ilias
