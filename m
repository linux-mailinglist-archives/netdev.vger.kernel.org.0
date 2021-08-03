Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7AF3DF43E
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238547AbhHCR7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238536AbhHCR7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 13:59:23 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE43C061757;
        Tue,  3 Aug 2021 10:59:10 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id e25-20020a05600c4b99b0290253418ba0fbso2640090wmp.1;
        Tue, 03 Aug 2021 10:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NdNGEZnkIReFGRbvKm7ES1u0aHYUQFB1OavFTkgaq4o=;
        b=S86myK+6wWO63bssW2t/9Ng2YNvM1DFL4Vtdr/rDo2rs9MJXbhBWtfF2Ptepnkl6VS
         guGewDmpFD+yPsGZ4dN+pr25yEMROllw1Q3F3fSxDMdorfBRyYAd3pv+HP3srtKgXPYB
         2dVfriMo7iObMBviKv5rPusKHYi3ia6PFO78qIwpx9Emyh6UHM6cE8sgZEg911JJHjcB
         tDcjkp7ntLiZBmpLd7pqtU88/TXcLXGvuGc8c/V072aaNuk5nKxLyzfF3ZXRaDgGZSZb
         gpj4D6k80XJ38Vlntwq96OeXhrSPJ7HmhObzQ8z8z7YMAQ27VVTE9nqgQEp4u224Vt3s
         0gwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NdNGEZnkIReFGRbvKm7ES1u0aHYUQFB1OavFTkgaq4o=;
        b=cveeQTpR4LaPSyuCYqFzdoji0yAnj6dy2V5crAl2k+AH/kkOyps+7PL5qaEY54ho8m
         IC3uiGRGedwF2aw64EQMFFkMps+F1/d4JSTXFWui01jfX2SI2ri2XrLNle7bpxuioaDL
         wP3F/XVVdshqaP7GOmRb44+mBxo2+/9n+k/ovj98NRWG4sN1rzdNO57yngRjQ71B6C0R
         /0ySytDjaPNKNvg2Mh33DFqouO/pGv8pWSqqyY5W8E2h2nwhcIi2ufv+KMJwe399TxNt
         oVesdSCUByjGemMCauUv5vSa0qGDIBmFgJURdiJjYAo9hdQNZ+FTHLfCCa+/7/4gIXkg
         96TA==
X-Gm-Message-State: AOAM533axo4sPElS366IqZ0BhqFC5z9V6tOEQAu9ppPv7ztbcWb+Zpxt
        RxRcTKnW99PNCsQxqC8VF4A0Clq6Q6MOaHnICQU=
X-Google-Smtp-Source: ABdhPJzidk6XmSHAiRFyVpv/tKzpVGxZGGy99rtgjo6zlmzKZQOEf1GDLPy4rW24nhDKfEwMN+wcxw==
X-Received: by 2002:a05:600c:35d6:: with SMTP id r22mr5504280wmq.41.1628013549063;
        Tue, 03 Aug 2021 10:59:09 -0700 (PDT)
Received: from [80.5.213.92] (cpc108963-cmbg20-2-0-cust347.5-4.cable.virginm.net. [80.5.213.92])
        by smtp.gmail.com with ESMTPSA id l7sm13629417wmj.9.2021.08.03.10.59.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 10:59:08 -0700 (PDT)
Subject: Re: [PATCH net-next 13/21] ethernet, sfc: convert to standard XDP
 stats
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
 <20210803163641.3743-14-alexandr.lobakin@intel.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <f33f4662-5d35-6bda-d78b-b48e0b083d5d@gmail.com>
Date:   Tue, 3 Aug 2021 18:59:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210803163641.3743-14-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/08/2021 17:36, Alexander Lobakin wrote:
> Just like DPAA2 driver, EF{100,X} store XDP stats per-channel, but
> present them as the sums across all channels.
> Switch to the standard per-channel XDP stats. n_rx_xdp_bad_drops
> goes as "general XDP errors", because driver uses just one counter
> for all kinds of errors.
> 
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Acked-by: Edward Cree <ecree.xilinx@gmail.com>
