Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098943DF4AC
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 20:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238536AbhHCSWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 14:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238434AbhHCSWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 14:22:08 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF142C0613D5;
        Tue,  3 Aug 2021 11:21:55 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id f42so73306lfv.7;
        Tue, 03 Aug 2021 11:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zhwIDcGB7pT8aVd97qYWg//ziHYjFqUsFMZWHdYVjQs=;
        b=VeYSBFudqfoM74qP/LF0h16xB/vLsDQa7UiOl453BOnutGSBdgEQ9h+bq2AyPe8vjM
         1YtljIfoAbssl8v4Qi6TuDchJrTvSv5zXoL80XuU/aWu8Y5oJk8UPBseYFuwhGnPt8nv
         lCqJI10gyItS03p//WQ7NX67IyPMP9XaIRWaDi7hBVNpZ7FdxT4JL6O5y9NuIKx6RZrZ
         xy1sRCrht6B9/jkbaTM0xrkf9dE1chH+QDRRqNp2cwKvfaDrNAotDcQ6kR1sfzoA79YY
         w6hCrgf78MnDNzPSRVPPhoG97GutbMHZl1RQsX9k9Sfr1yyIXGSH+JnZTLryCpLZNazo
         jufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zhwIDcGB7pT8aVd97qYWg//ziHYjFqUsFMZWHdYVjQs=;
        b=rlsDQU/EwM9jXnkpYzO3vzQeoSdft7Y+mIzMHND/JtTyppkhLOOSu7NxonARLQrDYl
         rWu42TyyIMYLYjzGDb91YbLoD317sYL9a+SnvvnBtTWI+3auIEBvubmdlzMWxEoMr0Ac
         GybHzmmvGG7H8e0N1UqElz7s6w+KqLznng/SZurZf52eAdK0OqhIQuxK8p9WKat9p2Ls
         IxKfItx/aGbyAMAkXmv4Wa7DbtEVY7SdOPwwwMhmluJurG9zcJCw44K9R7jtLLRBvLiZ
         RFdbex9JR3j1SPMSyS4SpBCDrcvjF3VTjJGdO/C2g00a1cRN38v5qV4ZaD1k52aFK1ZH
         OmeQ==
X-Gm-Message-State: AOAM532vxIdP0MG9su/voU8CArYWHwKmex2pNF6h2++IOSsvIlrNSg/E
        h14NWJq5G8yMPrownN2H7YI=
X-Google-Smtp-Source: ABdhPJwi++lS69Mr4newRrLTwZS2yWF/9lrfJsUOo+VOQp+w7huYXSy2wdK0s+TNEUTB1Pa9WP/nFA==
X-Received: by 2002:a05:6512:23a7:: with SMTP id c39mr12506526lfv.358.1628014914231;
        Tue, 03 Aug 2021 11:21:54 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.73.7])
        by smtp.gmail.com with ESMTPSA id o19sm1131976ljp.129.2021.08.03.11.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 11:21:53 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/8] ravb: Add num_gstat_queue to struct
 ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-4-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <dab78c92-8ee0-f170-89db-ee276d670a1b@gmail.com>
Date:   Tue, 3 Aug 2021 21:21:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210802102654.5996-4-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 8/2/21 1:26 PM, Biju Das wrote:

> The number of queues used in retrieving device stats for R-Car is 2,
> whereas for RZ/G2L it is 1.

   Mhm, how many RX queues are on your platform, 1? Then we don't need so specific name, just num_rx_queue.

> Add the num_gstat_queue variable to struct ravb_hw_info, to add subsequent
> SoCs without any code changes to the ravb_get_ethtool_stats function.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
[...]

MBR, Sergei
