Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC8A3482A4
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238048AbhCXUOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237892AbhCXUNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:13:35 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B71C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 13:13:34 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id o19so29079350edc.3
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 13:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tP5DtpUqNNa6r5+B6GU0oJmkSbmMrLPE3dqqcm9iReI=;
        b=crpRbXuSyu71F6AqnY8WL1naJ2kb2SoZ5B9ZA818IMBn7fibPJwYeBRdKUZG53+nu3
         5jii0YZDFA9dj+kz3drPPT24YeJkfqqDRv+Wqe5k/yf+d2jXuBtYc+AYNSOze1yXkY4W
         xuVmAOECx1Kd80cnKcGuHlJ6QIzjzMlJcg4ZCB8y9Q70mP4RSzgXbrI1cLfkhsWkU6SX
         v20ywk9td07GnkcSBP1mAfR6M/FAAJXoJ7nQdFG98CmZe0qluAttWE+N1Hm3h+de2MWu
         LazzQSP9DsEv4/InIrrAYKJ8B+ezuktB4zMExXgzKiBN8YkWJH8vkwGJUtlMuhQcU3sX
         AHAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tP5DtpUqNNa6r5+B6GU0oJmkSbmMrLPE3dqqcm9iReI=;
        b=A4GSG3sIvEXIxpwT5tmtK+ZKlQGwkQqiXh4wSMSpUfS/A4/fieTjwCFaRKhlfOasMi
         L70BV7IFji3KNAMrh0M58FHLsLHaCqFRFyLsq2etucPVMZaxjaGweX/wDkJH0dFbXMCZ
         Lf1/Z6H6+LU+wJxEBNjpNROpYn8JW98hKfKpx8NAfQbSl65gaHDCUn5x3u4t+5GvHdh1
         DbFjkK8a/a08TwSt8H4RkbcFYGuhN4qqh8fhkLOzfQjDb6LzpI8J2roMr8cpGFaF6dFM
         nOJhcQiDc3iCLiTolBKTvVCCavgfJvaEyrxwfe6lvZb6+77aWAdZ9fN1HiIEaAr7YX/y
         ZZhg==
X-Gm-Message-State: AOAM530m/rt3gLwLxhXmxjpk1V6sIyWaTJOILEwRm4PiDQ6C+D7ML5kz
        Py942ZXYBwEWolgjEJt+CUI=
X-Google-Smtp-Source: ABdhPJwVS61ZjeGxpbRCCzPzki1+UlB+qtNw44B3yFjaO/+12vccD5NKlaO8KAKd2JId7OKuQel/Rw==
X-Received: by 2002:aa7:d44a:: with SMTP id q10mr5345827edr.278.1616616813406;
        Wed, 24 Mar 2021 13:13:33 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id j7sm1638804edv.40.2021.03.24.13.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 13:13:33 -0700 (PDT)
Date:   Wed, 24 Mar 2021 22:13:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: lantiq_xrx200: Ethernet MAC with multiple TX queues
Message-ID: <20210324201331.camqijtggfbz7c3f@skbuf>
References: <CAFBinCArx6YONd+ohz76fk2_SW5rj=VY=ivvEMsYKUV-ti4uzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCArx6YONd+ohz76fk2_SW5rj=VY=ivvEMsYKUV-ti4uzw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On Wed, Mar 24, 2021 at 09:04:16PM +0100, Martin Blumenstingl wrote:
> Hello,
> 
> the PMAC (Ethernet MAC) IP built into the Lantiq xRX200 SoCs has
> support for multiple (TX) queues.
> This MAC is connected to the SoC's built-in switch IP (called GSWIP).
> 
> Right now the lantiq_xrx200 driver only uses one TX and one RX queue.
> The vendor driver (which mixes DSA/switch and MAC functionality in one
> driver) uses the following approach:
> - eth0 ("lan") uses the first TX queue
> - eth1 ("wan") uses the second TX queue
> 
> With the current (mainline) lantiq_xrx200 driver some users are able
> to fill up the first (and only) queue.
> This is why I am thinking about adding support for the second queue to
> the lantiq_xrx200 driver.
> 
> My main question is: how do I do it properly?
> Initializing the second TX queue seems simple (calling
> netif_tx_napi_add for a second time).
> But how do I choose the "right" TX queue in xrx200_start_xmit then?
> 
> If my description is too vague then please let me know about any
> specific questions you have.
> Also if there's an existing driver that "does things right" I am happy
> to look at that one.

Is this question specific in any way to DSA?
Many Ethernet drivers are multi-queue. Some map one queue per CPU, some
use mqprio to map one or more queues per priority.
