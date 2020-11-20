Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C802BA5AE
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgKTJPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgKTJPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:15:41 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72B4C0613CF;
        Fri, 20 Nov 2020 01:15:40 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id s30so12460094lfc.4;
        Fri, 20 Nov 2020 01:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y8QalvGL8usu1SwxJBoIJinCnrXoIgcEw4s5L2goS2o=;
        b=fAwWFYp2VFJSmmIBV05rXILYcwgnD0HL9tGpAsbw7C6AhzJjsT3eFdHN5Q5OxnOo0h
         0ZK0WJvzeaE8wERL3n3nFmUgDrOMNWLjM0S2WmJhz/aW7jH5Kb6yaHyyQyMm9NIOuPnP
         jaCOvhPW7H0P6aIy80jsKP4xmsHRWWwaZh5cuSd97Rm4tsumhUM6NwAWVtH4FLGLzFyK
         cd2Qo5vr+X0NEMTr6a0wQG2deW9sJarLgncsWN309VrQZWyS0zVZAdCSEQFbifNvAumm
         5AiBaLp/wnuVyU+mkCmaNrQ2KBi+BzoIs3Vr5JTQiQS3fdTQAKZKkWYKiG5VZ0Y7QyhI
         ASaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Y8QalvGL8usu1SwxJBoIJinCnrXoIgcEw4s5L2goS2o=;
        b=YX+2Tu/wzo579TRYTt+kPieLfXLwxWsjD37RFrgyJgJ0qm+DkRT08vLz311xpY5l19
         IT9skvfwwKFxL4BGv5vKV+7F1StdWFDMkGcLkeW/FAHynh0ePabJ/OE3U8vujkwT4ggO
         B1cbzxX//A6OHRuN9/s93g5AZYlWOC1a7DVSv8Zc8kur8WCl5JMhthXNsboGmn4m6Gyv
         bXWeJ11SesuGKN8QjNUT0oLzZVjDMsPnpDhU6IrzsWOwc127zVg1CZi9Vv3NisgTZW84
         1mEp7X2uMlwNmbbzXQ1D4dr+1prpJ8/4lw7/MPxJers+sAklz2jwEToN6wn/rvQm/pTT
         Q3vg==
X-Gm-Message-State: AOAM530TcUbhYBDzLmY/or1/g7x31W85iA6eFnJGxr4f+sTWpz4vLCOI
        q83gj2JJBFkju9I1Kl9FXODYS3kwJXZ21A==
X-Google-Smtp-Source: ABdhPJzXLvDx2eEVxLt/6eq1f5plMqpfDIPoFgYudE2g9hbOtU3QH5N3ENLP4SI7peIxvz577priyA==
X-Received: by 2002:a05:6512:304b:: with SMTP id b11mr7138498lfb.546.1605863739110;
        Fri, 20 Nov 2020 01:15:39 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:46ec:d97a:8999:fa0b:162:4c32? ([2a00:1fa0:46ec:d97a:8999:fa0b:162:4c32])
        by smtp.gmail.com with ESMTPSA id z19sm226988ljn.15.2020.11.20.01.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 01:15:38 -0800 (PST)
Subject: Re: [PATCH] usbnet: ipheth: fix connectivity with iOS 14
To:     Yves-Alexis Perez <corsac@corsac.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Habets <mhabets@solarflare.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Matti Vuorela <matti.vuorela@bitfactor.fi>, stable@vger.kernel.org
References: <CAAn0qaXmysJ9vx3ZEMkViv_B19ju-_ExN8Yn_uSefxpjS6g4Lw@mail.gmail.com>
 <20201119172439.94988-1-corsac@corsac.net>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <22d938ab-babc-815a-f635-5025e871cf62@gmail.com>
Date:   Fri, 20 Nov 2020 12:15:24 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201119172439.94988-1-corsac@corsac.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 19.11.2020 20:24, Yves-Alexis Perez wrote:

> Starting with iOS 14 released in September 2020, connectivity using the
> personal hotspot USB tethering function of iOS devices is broken.
> 
> Communication between the host and the device (for example ICMP traffic
> or DNS resolution using the DNS service running in the device itself)
> works fine, but communication to endpoints further away doesn't work.
> 
> Investigation on the matter shows that UDP and ICMP traffic from the
                                         ^ "no" missing?

> tethered host is reaching the Internet at all. For TCP traffic there are
> exchanges between tethered host and server but packets are modified in
> transit leading to impossible communication.
> 
> After some trials Matti Vuorela discovered that reducing the URB buffer
> size by two bytes restored the previous behavior. While a better
> solution might exist to fix the issue, since the protocol is not
> publicly documented and considering the small size of the fix, let's do
> that.
> 
> Tested-by: Matti Vuorela <matti.vuorela@bitfactor.fi>
> Signed-off-by: Yves-Alexis Perez <corsac@corsac.net>
> Link: https://lore.kernel.org/linux-usb/CAAn0qaXmysJ9vx3ZEMkViv_B19ju-_ExN8Yn_uSefxpjS6g4Lw@mail.gmail.com/
> Link: https://github.com/libimobiledevice/libimobiledevice/issues/1038
> Cc: stable@vger.kernel.org
[...]

MBR, Sergei
