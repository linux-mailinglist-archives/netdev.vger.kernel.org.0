Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6506116399C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 02:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgBSBt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 20:49:58 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34245 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbgBSBt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 20:49:56 -0500
Received: by mail-pg1-f194.google.com with SMTP id j4so11894930pgi.1
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 17:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mCpHqL2j5BnpvPO+BvKBhD4kS+poF12ECCa7tnpH+YM=;
        b=ts8VDPPBuLBZSekAbBB4AA9teS6dDAo1HBlFrWgCyrq8tuMc3thxftGa4AHpAl9HfC
         u7yxDltYVpeECwcY8RzDqO6Oc+ujMt1LKMzE60hyRUp4CRmsuXIAURjdU5sPKFRoFEwm
         6FN7vQ7hbitggAiOqBJscQwLzxfsXk6P3kE/ijGHV8xJt/0agF6tzs7iGM9/TJ0Fvy9F
         ArDT1pSLD7/sstOaJU2GCdk92lHOemZWj0EQ3zQfulnRwfJ76bPc+DDLQ9ZRE1nVboYb
         jR7FRhkDaPhSRUnmUrrhkxZbwc53oVyaoPQDanlDY6cxtAjJ8vR46+8/3WdA4kMg6eXF
         I4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mCpHqL2j5BnpvPO+BvKBhD4kS+poF12ECCa7tnpH+YM=;
        b=Y9q3q8/PQD9zEsRx4avXlRxd8WzNtHiNiYr4WxHIkBoiV2bpJtXqEMaw10Z87ElPeH
         iPCWBVZQXHvQ66Y7z6HxD00T8GXBVpVx8qvp2IG5ufZdhPhdp+WPhfcj4PxoXdUH91B1
         X1NLByaeu9lCqkyidaHlDl3mB6qZhrrTZFDCb8CZ1aTr/IkvPDZHQnkwgd/7jGeI4wKu
         ftHAfSK0+JnIisxljInppODn+uHOWR81PSDUMlwz0YQTsG9mevWwGK3NrXdg/eql7A/G
         YT33eraFjoWQp3H/PhwK+JE3ia1L+wCJ19AUITzTaYoJI5KmJlwd/ycdhPmr/pCrlBlA
         E9PQ==
X-Gm-Message-State: APjAAAWeYhJmpg3T9oto7YnPZ6A76XtYp2+AwwWIzRll2+1jIOgHw4wf
        u9plbPa55ofubuzQnd9Gq+YSPQ==
X-Google-Smtp-Source: APXvYqywbiuEpD1gaeQyiKrj/G0fRGBegWe1kQhCb3QNT2ZiaM+5B/V4zEAel8kBFDrwr4m3Dknbgg==
X-Received: by 2002:a63:2266:: with SMTP id t38mr26477980pgm.145.1582076994532;
        Tue, 18 Feb 2020 17:49:54 -0800 (PST)
Received: from localhost ([223.226.55.170])
        by smtp.gmail.com with ESMTPSA id q25sm288920pfg.41.2020.02.18.17.49.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Feb 2020 17:49:53 -0800 (PST)
Date:   Wed, 19 Feb 2020 07:19:51 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        soc@kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH 04/11] cpufreq: Remove Calxeda driver
Message-ID: <20200219014951.2o2diuw5dzooafji@vireshk-i7>
References: <20200218171321.30990-1-robh@kernel.org>
 <20200218171321.30990-5-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218171321.30990-5-robh@kernel.org>
User-Agent: NeoMutt/20180716-391-311a52
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18-02-20, 11:13, Rob Herring wrote:
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> Do not apply yet.
> 
>  drivers/cpufreq/Kconfig.arm          |  10 ---
>  drivers/cpufreq/Makefile             |   3 +-
>  drivers/cpufreq/cpufreq-dt-platdev.c |   3 -
>  drivers/cpufreq/highbank-cpufreq.c   | 106 ---------------------------
>  4 files changed, 1 insertion(+), 121 deletions(-)
>  delete mode 100644 drivers/cpufreq/highbank-cpufreq.c

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh
