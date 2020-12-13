Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9492D8CD1
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 12:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405872AbgLMLev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 06:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgLMLeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 06:34:50 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099D4C0613CF;
        Sun, 13 Dec 2020 03:34:10 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id g20so18657713ejb.1;
        Sun, 13 Dec 2020 03:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=32JDNSeqhHqyIaOh/qzFvhnj5b/m+w8QZFr6dtEN8Bw=;
        b=dTA8b5OUH5yKZKYvrwD8FPaAH1qo6ziTqTgli2eWV/QQwwjrj5RItxhiVtWCYn5J4r
         iU5u2+H3CEqrvgOG4ifSiMinjtA03OpWth2tg99EZKrbp/XHweTnJDEVAsFXw8BEi/2k
         62/n48qL7LWG8Lg/TWLV8Ekvi2YV2XdqZDT6dMQ7h03xg9aGRIuNRGCnlY5Zc5d3YnN9
         nNHTJNN2xuMH7nQvu9FSiVhtrlE/Mw87dMJ3GteW8ox/7IYneqfAWtuLpskhNM3GN80O
         a83qBHYHs8rA5sz+ldeezNiCzs60YSlz4P6KTdIerqBLo/hvBarQx+UVsAPAPvEcyL2G
         H9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=32JDNSeqhHqyIaOh/qzFvhnj5b/m+w8QZFr6dtEN8Bw=;
        b=fGmOZF/3aIX19kouAoWpc4j9eiUCVf1Pki8Gr5NJoxshd8smoK8ftKzRwxG80RcZTC
         vLVd2LuvsuLyxPwi6vD6rCyq5iCjWv5BGoBSPRHIXQ9mpoVzsICebu4gWW67ZobBRUmr
         Q1bjOcjw1lR0MkelsSweCHRMiiD4rw9xuLtTkPAg7m1FnnvRbSJp6h4o7qoqx2WfDWfm
         173Q7AnxGb2cnyezoSKVYGnqLJApT/C69VU8/Gn+KV54XvCPNHzzqa65qsiITfVotYjk
         XxvLz0zOLpUn78vIweCQ/M7DKoPt1sjToNF04fKCdGCHto9g4x8AuVbNlZRPZNIdvRV+
         x3+w==
X-Gm-Message-State: AOAM5338JOs4DDgRB5O0DvNyEvZluE5oZ/jUmMOI9aLaITvYAPm8YarQ
        jH+5r5Kv9eENGwXMH/yDjwE=
X-Google-Smtp-Source: ABdhPJy0f+aRaj1FvtAzME5ZsGleR5z0tMVYyWtlz18MxubIwHyo0udN2mZLmYeJ/0XwIck0k7j0dQ==
X-Received: by 2002:a17:906:85cf:: with SMTP id i15mr10621618ejy.373.1607859248729;
        Sun, 13 Dec 2020 03:34:08 -0800 (PST)
Received: from [192.168.0.107] ([77.127.34.194])
        by smtp.gmail.com with ESMTPSA id r21sm1242331eds.91.2020.12.13.03.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Dec 2020 03:34:08 -0800 (PST)
Subject: Re: [patch 22/30] net/mlx5: Replace irq_to_desc() abuse
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Wambui Karuga <wambui.karugax@gmail.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>, linux-ntb@googlegroups.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-pci@vger.kernel.org,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
References: <20201210192536.118432146@linutronix.de>
 <20201210194044.769458162@linutronix.de>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <02be0e10-f2b5-7cbb-3271-4d872616ffd4@gmail.com>
Date:   Sun, 13 Dec 2020 13:34:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201210194044.769458162@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/10/2020 9:25 PM, Thomas Gleixner wrote:
> No driver has any business with the internals of an interrupt
> descriptor. Storing a pointer to it just to use yet another helper at the
> actual usage site to retrieve the affinity mask is creative at best. Just
> because C does not allow encapsulation does not mean that the kernel has no
> limits.
> 
> Retrieve a pointer to the affinity mask itself and use that. It's still
> using an interface which is usually not for random drivers, but definitely
> less hideous than the previous hack.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en.h      |    2 +-
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    2 +-
>   drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c |    6 +-----
>   3 files changed, 3 insertions(+), 7 deletions(-)
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks.
