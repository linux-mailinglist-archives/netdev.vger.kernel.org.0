Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6593B316B
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhFXOfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhFXOe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:34:59 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCC9C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 07:32:39 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id w127so7501802oig.12
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 07:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pKjed7cl4UM8CzJciqcuIeALd5UC5u6VaTS1pfylTSk=;
        b=BrFDB7AOugFFOleq2yxAAPv5WbEGGxY9PePnBN0r96PBSa57qfxaCiV4pS2Ks0eIMx
         4dihMgo7sirNqB3Co6P+6jQZFhhdrKU8Frpc8zZlllDdZ7yUfALs/j/n/kBpBbqXV7sT
         wi8KqLLf9+bCC+Vri4BhPSGoK2vTQ1KGcyzd8/KdVmm6awNLBg8TUPea4VDzIoTwYUlP
         jh4voM++uGBaGEtFo7vQjsoWIbDFadlZIZH7TpqbgMKqZonDBjyLjIEqO5duwCqBZ+2+
         C9JR6HDr0k1H57Fn8ZDsbnVFGBsjTiSSjAUmtylNkMc/uzNn8WKcxirCo+vyT2CwNCAI
         WeGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pKjed7cl4UM8CzJciqcuIeALd5UC5u6VaTS1pfylTSk=;
        b=X+GNAKjI+LVUBHYZakA3lMnageoDZ6JlLrn4p2bwhP2cYd39xWA7RBkXOaaynLqmSr
         grWrWDw/5M9S7gUr/6+BLjUAgyJqrZmKoIJHix9HuMIz4pa7KI6bsQnOjYdMKb82EiXV
         Igojpr57pjx3znrguWm07RhQTJHwhmUIFxMzMQZVKgTjHW+hW5/5T2R/5G4Jg3i3V19+
         pFFxUIHE84TmEbU9rJ0VJ/IslWMfw4zvIrAax83hImB93fN7RLhdD/y+Fp5ohrYXDFy3
         e7DM/XXRrB6gD9J6O07vfYP4bQXypqY1R5c+5CpHB2vYjtbkC+ApgrGvOAxzS1VWEya2
         DE5Q==
X-Gm-Message-State: AOAM530vFj/CFZ7ILuv6cX7AjSLY92e8Jw2QSPTXEoSPhHjdFNAUjql4
        suciI/F2tzGGq+4ujaPWtLY=
X-Google-Smtp-Source: ABdhPJzHhDq2Gb2iaht4BhEP/ljb1TG4pkDGu+lziRN815IxZPGzf2a+Qh2WwVmfl0PTuFclbYeyqg==
X-Received: by 2002:aca:4141:: with SMTP id o62mr7494142oia.42.1624545159185;
        Thu, 24 Jun 2021 07:32:39 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id z6sm662595oiz.39.2021.06.24.07.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 07:32:38 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6: ICMPV6: add response to ICMPV6 RFC 8335
 PROBE messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
References: <7eb62f437120d8686f50811a2aebd7c0f7f73ced.1624358016.git.andreas.a.roeseler@gmail.com>
 <CA+FuTSethFwxSpqLhhdRMkQYnWcQ7YE6SDRQPza5Q72bZw3C3A@mail.gmail.com>
 <f35779d9-5c8e-3b3c-2395-dcfb999bc1a3@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1c2b20f7-9892-cc47-035f-29b9d0b2b741@gmail.com>
Date:   Thu, 24 Jun 2021 08:32:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f35779d9-5c8e-3b3c-2395-dcfb999bc1a3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/21 6:51 AM, Andreas Roeseler wrote:
> It is copied because I was under the impression that it is generally
> good practice to keep the IPv4 and IPv6 code separate since they can be
> compiled modularly and exist independantly. If this isn't the case,
> where would be the best place to put a separate function to be called by
> both handlers? net/ipv4/icmp.c?


We want the code as common (the same) as much as possible. IPv6 can
leverage exported functions from IPv4.
