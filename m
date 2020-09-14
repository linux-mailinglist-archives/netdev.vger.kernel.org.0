Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31583269013
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 17:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgINPej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 11:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgINPeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:34:07 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A12DC06174A;
        Mon, 14 Sep 2020 08:34:06 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a15so75289ljk.2;
        Mon, 14 Sep 2020 08:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6QGIaljRH231VAywJdapvuATziOfA42BJnpSHpoIEVE=;
        b=RSn2RJzblwAHTSK+plrf24n4vXY7/p/jXtG+T94xADRsRUBY8CHEBNgnMf/kQyrnxy
         YieEPQGTw3bOqSmW8AmGOLLdGNA7YSDJLGbEMo+AGcNWh2pxH6XRgNcz8Cs5uCOpKkzC
         gQyRsPyGfUidZAcBfjITy0I3uSNrMpc1xEktaPuU1N5ohOzXYJc8kuUdIFaZ6+PLkH1j
         ej79ZdbMIfsu6iduHBqVwRFdln66PldWiNNCVGGJ8TfEu+jWybTfxA05D2VHpJvxymYA
         bWH+DdU6BYBQ8HP2CiwI9zxdkYMl9jJc8yEPZeyVx3GZKr3H03N+EEitFWK+0KohnbKI
         Gy2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6QGIaljRH231VAywJdapvuATziOfA42BJnpSHpoIEVE=;
        b=YeYWECqoKGgbUSdB7xoMSOD7SkTRDc++YfYAp4jk2pcoR4iYbHtzsBxOMMgZAAkNIO
         8QtdEuJPnlwOBQpkNGad07r0lsOxpKt1h2+UZ6i/kHMRtFHCAjel0r/VHQqr7/FtYbAe
         tuG1V9nzlm84tLTlUTgV0QsgfadauDyZrs4kQmrzDhELpX9kRusWxY/R+w09JbzqL//8
         TYkG0uoblChY5NtJ0UNIh+/C3iH4CPRt+4ThnH1eB3Vd9C4HM1RMAA0bqOKwZDTSwBwh
         C48ANhNXerj6QSjh4FHIcX9eV8JXMcoF/jlBJK9h8vTDa7iPvTC9mCY2bplQ9NeFWN3p
         W44g==
X-Gm-Message-State: AOAM533/5JLXyTteFDb4tICppE4xrIsfS8mNU4Jh3XRiNR6b8pOfPFxa
        xc5ym6NM7k92D0ZIoIA23D4=
X-Google-Smtp-Source: ABdhPJwhd/LhTRq+JWSW5bzIk6PAoYzRDD2WFOZyHy/0zgbs8GXUoAwbOWmbxU7cQ/01j9Vl+1ORow==
X-Received: by 2002:a05:651c:200b:: with SMTP id s11mr5091489ljo.196.1600097644849;
        Mon, 14 Sep 2020 08:34:04 -0700 (PDT)
Received: from wasted.omprussia.ru ([2a00:1fa0:44ca:acb2:3cb7:6882:b0eb:1108])
        by smtp.gmail.com with ESMTPSA id l129sm3367001lfd.191.2020.09.14.08.34.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 08:34:04 -0700 (PDT)
Subject: Re: [PATCH 03/17] drm/exynos: stop setting DMA_ATTR_NON_CONSISTENT
To:     Christoph Hellwig <hch@lst.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
References: <20200914144433.1622958-1-hch@lst.de>
 <20200914144433.1622958-4-hch@lst.de>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <7a1d11c2-0fc5-e110-dabe-960e516bb343@gmail.com>
Date:   Mon, 14 Sep 2020 18:34:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200914144433.1622958-4-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/20 5:44 PM, Christoph Hellwig wrote:

> DMA_ATTR_NON_CONSISTENT is a no-op except on PARISC and some mips
> configs, so don't set it in this ARM specific driver.

   Hm, PARICS and ARM capitalized but mips in lower case? :-)

> Signed-off-by: Christoph Hellwig <hch@lst.de>
[...]

MBR, Sergei
