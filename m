Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587AD28AA1E
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 22:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgJKUPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 16:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgJKUPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 16:15:40 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB24C0613CE;
        Sun, 11 Oct 2020 13:15:38 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id md26so20357255ejb.10;
        Sun, 11 Oct 2020 13:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fxGXbZ4rR3KKATBoIOvT5Bak7Llr7/4+tSdJ99Kd1/I=;
        b=vR2tB5CJHdjucZ7zY+9a/U7vQTK4GmhNLfBcXmfL2y1AUPIM6P/Ym55FGeMknQLLl4
         L4ksW3b5iTYcU/1P7j9HhnYtY1JNZjw2ve7gwkxRakdciGIibwq+hCJeglHVAevgYvt9
         mMB7ZRNDGU1VQS4DNzx1qgWgGKh1MJpGRFsT2U4HY7bvfe0XW0wC+ZZ4AOBakX2SwbJy
         1GKeS1ngNe8F1pka0ROx60/QpLrQpsl0SVSlL/8txvDVzChEj4NDMLyCyqF3RNaF/U7o
         11pNNeHoMuI0SiGKBiH9183giapE7dUdewbP1kN0il2Yszl0B3I4Oktz/cN2+INnvkyk
         Zobw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fxGXbZ4rR3KKATBoIOvT5Bak7Llr7/4+tSdJ99Kd1/I=;
        b=tkI2xt3EWwGtqePGFqHQjiPMhn9z9sHGrc9tIpHTbTZqK54f/IDSxZCUb3RCX6k9lM
         /+nuPmGlKcvj542ESZ6XQlWS5EQyYAwhu9kK84gNOHxTVrQ8/2UodmRtnMDI0xKgom/n
         q4H/7Ldk/Aq0cMXrXdcfEAZxhQ8auLFnm6l3b6eYEb5v6BaBjGYqXGhLzimXWHq9YJsW
         ViV5bKyofjoiCmZ/12z78D7yjI/otyDm2NuHiYCz1OiTN4YM3ZWqOUluzZ7m4JdpBgD3
         cJQUqYN//rkoPsESZ0qYbqwky79pK4YOota+Ktr4FTmlevpOVf5gkHet91OcCtp2Ssya
         vw1g==
X-Gm-Message-State: AOAM532IqSiIMMj8LQz7a3NabimxA6GAoHxiwxQYqVFkzqrT6ouh83au
        bDyQVc4dgi4aqVh9dsv0bzo=
X-Google-Smtp-Source: ABdhPJyrL+uXyP76lDNPTj7UgemLEokJ87Hdl817rKRMHxcMgiQkItyZWwOyv5YUb4bbWf0jmBaG2w==
X-Received: by 2002:a17:906:60d3:: with SMTP id f19mr25947736ejk.141.1602447337068;
        Sun, 11 Oct 2020 13:15:37 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id mh2sm9743353ejb.30.2020.10.11.13.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 13:15:36 -0700 (PDT)
Date:   Sun, 11 Oct 2020 23:15:34 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 08/12] net: dsa: use new function
 dev_fetch_sw_netstats
Message-ID: <20201011201534.ybeb4foumck4bpmw@skbuf>
References: <a46f539e-a54d-7e92-0372-cd96bb280729@gmail.com>
 <4c7b9a8d-caa2-52dd-8973-10f4e2892dd6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c7b9a8d-caa2-52dd-8973-10f4e2892dd6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 09:41:27PM +0200, Heiner Kallweit wrote:
> Simplify the code by using new function dev_fetch_sw_netstats().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---

Tested-by: Vladimir Oltean <olteanv@gmail.com>
