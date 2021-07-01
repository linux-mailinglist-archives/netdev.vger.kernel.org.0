Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D363B8C84
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 05:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238707AbhGADGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 23:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238056AbhGADGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 23:06:08 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC211C061756;
        Wed, 30 Jun 2021 20:03:38 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id d1-20020a4ad3410000b029024c4d2ea72aso1200791oos.4;
        Wed, 30 Jun 2021 20:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=miX+HUGNry9LPmmE01qiRM28/4hRXxW/rSyq1X5RMvA=;
        b=rrcLIpMYDVHo8YMMCg+C5g3Y2pyHlfkH9Yasw0GfBTJIJG5VkNl/+aT2dHxvcG0KsZ
         58ARZrBU4ydpsDCtR+e6MwvgQ08Y4ibgDTktIZ6qHftwV2zNobAZm0Ke0KvdEBDdjJeA
         FHi5esfucH4d0STJBO/p9uYNtDeepR4HxMhnAO9G50xqtpMaHe1BQZJim6ZRYeaxZBBO
         5kRB5Tb5rDsvbJJzpnY68MmDDr1K4Gm+PicNXhDZHyx58gvPWIoraS5uflsiArm/o70G
         4W+fctfsQQVHlRXh8/PsKiaQdBuom0cXbMOnGCwKcxokZ/O5i/M++eR3WO81Sz17gBBN
         e1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=miX+HUGNry9LPmmE01qiRM28/4hRXxW/rSyq1X5RMvA=;
        b=sszzhreMmEWVS9BKM3YqLNH/5aODVbHrKDlwJZDdp0AKdkUdl4xztsWR16pBr9W1Lf
         3Cn8X0Ij5hcMISSC1C4DFvy5L52S395euWAogXAdVFQEMWqsmYGUmKJOrLtLjzUU34yh
         bkzCzcrPJ/v66Tw7IQuHc9JsbGgLbQTjNUiEF79abLCQfltJKhDA7j2RrynqGn7CmUOT
         1B3KDfpACiBIs0VVsPRFzvDHSpDDKz3aFxXDR8pHd8lqCxZYT5rfoQwxHTGDbIaqnxg/
         zvkmb/YBrYn328eq+H2CHy9k7fvx1FrmgK2h3V7JNUjOF+UJA+uxBAlsaB3HXvr/f8up
         A+Wg==
X-Gm-Message-State: AOAM5310yDFof1QcZkkijPdaXWMc4Gj3rMlaI+NXN+be9URDnOUu5Txj
        FhYTvoiCOmTY3heDpoQ4baY=
X-Google-Smtp-Source: ABdhPJxNS3uM9ZSKZcUsFOgGvl15CC7VjYn6u1n4W3yLMranX1a/tzUlEv8HZdfoRQfVP/XaZUYLaA==
X-Received: by 2002:a4a:cb06:: with SMTP id r6mr11136256ooq.15.1625108618137;
        Wed, 30 Jun 2021 20:03:38 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id c34sm5236974otu.42.2021.06.30.20.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 20:03:37 -0700 (PDT)
Subject: Re: [PATCH] net: ipv6: don't generate link-local address in any
 addr_gen_mode
To:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        Rocco.Yue@gmail.com, chao.song@mediatek.com,
        kuohong.wang@mediatek.com, zhuoliang.zhang@mediatek.com
References: <20210701015940.29726-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3c0e5c52-4204-ae1e-526a-5f3a5c9738c2@gmail.com>
Date:   Wed, 30 Jun 2021 21:03:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701015940.29726-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/21 7:59 PM, Rocco Yue wrote:
> This patch provides an ipv6 proc file named
> "disable_gen_linklocal_addr", its absolute path is as follows:
> "/proc/sys/net/ipv6/conf/<iface>/disable_gen_linklocal_addr".
> 
> When the "disable_gen_linklocal_addr" value of a device is 1,
> it means that this device does not need the Linux kernel to
> automatically generate the ipv6 link-local address no matter
> which IN6_ADDR_GEN_MODE is used.
> 

doesn't this duplicate addr_gen_mode == 1 == IN6_ADDR_GEN_MODE_NONE?
