Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A7B3DAA21
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhG2R2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbhG2R2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 13:28:33 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8293FC061765;
        Thu, 29 Jul 2021 10:28:29 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id q6so9393560oiw.7;
        Thu, 29 Jul 2021 10:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T4634nEU7h1FMASxQlJXurHsCOwc8FrOI5tJXiiXeII=;
        b=ktpTazTWfguZ49pyVRHW8CWP7MID2LgaKgHZRwDP9C+D5e+fbBEK9XdGTXMDqWOPaC
         pR4EN+0ZyJS1h40sC88vRfULp01m8jWiB1rxvZ6e/cmk++MN+gh9jDTCsJwmA+o5TXPp
         y1klOH7188f78HV+Fnbwt4oEt5wb6LojxKbJKrO+OuwF71deVXsVtuqjEL7zGenz30oR
         r+mZmfOL4jD9AgBrhA6AQFNYIML2JJLr6v2pcN4tsYydl1WSGQNbR6m+62CuWiKl79i1
         X4n4C3YfbfpxcGbqNAc343VKVlhRhDFafLNO21tj/tFQxnxEctBvTp+1jVpHYEExvo+f
         UGTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T4634nEU7h1FMASxQlJXurHsCOwc8FrOI5tJXiiXeII=;
        b=KAweBK4q/EvAo38i8LDkUaiqyI3zpfY1gKnYnCVoFYdAzGNhxniaCFSIDG8O/laO7T
         SBWLN5nTQoBPWO951IJcIRFegxkoSRNf8EgFqBYIfpwYvltJ3HjCWhON3zPNdgTCVffe
         u5dj0ndmOJkz1LWk+0XCIopIK9zAJOoUf8YuDHL05EBt1rTaxWJ7zjw7BXyLAo8GGytP
         78GeA4h0ioJt8tSYSJwAsQo4fkENbpj7OgXIzdaJx3DDCxt85wf6MH3QikPLI9um3OPB
         cglkCneDRzFuRRqvsKp4MV5rtry+ZqsK3H2k2D7fEXtI+1J2yAd0JGkcvRJlkM9X2HJs
         iHhA==
X-Gm-Message-State: AOAM531wf36rKqatR8AmCysspXfiarWTdmF7hBnovCvkYejxrowA5MuA
        h6XFTiA0joZc2TP75p6jo6k=
X-Google-Smtp-Source: ABdhPJxoUx2dL4gO6cXj2XI9CKAW2Xkw2stlC8KQ+HBW6uwYZLrX61/EqE8spljKolA9iphj4rdhhg==
X-Received: by 2002:aca:bc43:: with SMTP id m64mr11250240oif.174.1627579708922;
        Thu, 29 Jul 2021 10:28:28 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id h1sm648323otj.48.2021.07.29.10.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 10:28:28 -0700 (PDT)
Subject: Re: [PATCH net-next] net: ipv6: add IFLA_RA_MTU to expose mtu value
 in the RA message
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com
References: <c4099beb-1c22-ac71-ae05-e3f9a8ab69e2@gmail.com>
 <20210729154251.1380-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <57652c0b-ded8-8386-c9a7-40deb1525db2@gmail.com>
Date:   Thu, 29 Jul 2021 11:28:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729154251.1380-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/21 9:42 AM, Rocco Yue wrote:
> Because the purpose of this patch is for userspace to correctly read the
> ra_mtu value of different network device, if the DEVCONF is completely dropped,
> does that mean I can add the "ra_mtu" member in the "struct net_device" .

good point. IFLA is the wrong attribute. It should be IFLA_INET6_RA_MTU,
stored in inet6_dev and added to the link message in
inet6_fill_ifla6_attrs.

