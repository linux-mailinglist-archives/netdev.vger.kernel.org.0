Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158A32562A3
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 23:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgH1VwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 17:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgH1VwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 17:52:14 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09C8C06121B
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 14:52:12 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id g207so1317883pfb.1
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 14:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BGIFgHhnj4ZZ+ZwmJ+azPNOf9dZgEALfNMtI3CFWx/o=;
        b=iZovJBNhkq0B0uvt1ArnlCzdGbse3STj2vz7fm/5VWNq+S1otd+TvNXZEUISe40n4r
         3tyV7aZKRDpcO8Xj0Mrnb0RFV5xmg0I8ORIUjCNCrvsgPb0d8Bun/VjtpPNSc/dfVpKT
         uS0YwSrtAIaaZAeAitIxGI7YsF/TOi0NkB/2zD/YiJYxK4wMVhVW0mHTLZyrIXJPpESq
         y06pufjnDraLjjx8YNwTEqj440DVB6lkZF+ldjBz/N+O4Pc4nEPAthTnNQEdzYhkK/W3
         qIkdIyU503gGOvgOhAL7fG7yiYDGHx8m7RtnSdb1qBuDmi3Q35PlKpNHYR+hXjomtOgO
         +BDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BGIFgHhnj4ZZ+ZwmJ+azPNOf9dZgEALfNMtI3CFWx/o=;
        b=Y/N8pk3ebMDm9599WQ+dD4JVfpzGLtyJworxuyNbxwQCprX7SS9gztgN6xpRalO+gL
         GsjPIwibd/iklnr0FbeTD0jFddfkyEjdKo/1JH07Essr1NSK6tY/X/COCqeGXVbd02TM
         M2RMGjavqwEPw4E5FHhmFGpu/RR9cdKQfl9D2ROPUOARPh44pbkGJWUQqsZpvbM5mVeL
         tr2LRzG7q9lzlVg/5M4M3GWkLQVAxtS5S8Y9WsldFPRM4SSYMGOj7bXXPZ+ayNdw/h01
         flErRiTjURyyWhcyvricAbBCNXpWoOxqd9UiC2U2HVK2vRU/ih2r4qJ1XfaB5VqmgZZk
         kUMA==
X-Gm-Message-State: AOAM530Ewnziqrdfiv8Ex9S8Es4bGKoiqE/gCOh8B7dezMJf246jdtdg
        xnTM7AUsL0hd/L+FxrRGHn9iHY6J97C9iw==
X-Google-Smtp-Source: ABdhPJwhZJvDd6XsVHxUj8a4OFtxbQPgRKloZkMgTlDj0buCsdSbeE00LtElOYuUed4PK8i3k/2dZA==
X-Received: by 2002:a62:5214:: with SMTP id g20mr821890pfb.168.1598651532034;
        Fri, 28 Aug 2020 14:52:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r199sm400334pfc.98.2020.08.28.14.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 14:52:11 -0700 (PDT)
Date:   Fri, 28 Aug 2020 14:52:03 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Bart Groeneveld <avi@bartavi.nl>
Cc:     linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] net: Use standardized (IANA) local port range
Message-ID: <20200828145203.65395ad8@hermes.lan>
In-Reply-To: <20200828204447.32838-1-avi@bartavi.nl>
References: <20200828203959.32010-1-avi@bartavi.nl>
        <20200828204447.32838-1-avi@bartavi.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Aug 2020 22:44:47 +0200
Bart Groeneveld <avi@bartavi.nl> wrote:

> IANA specifies User ports as 1024-49151,
> and Private ports (local/ephemeral/dynamic/w/e) as 49152-65535 [1].
> 
> This means Linux uses 32768-49151 'illegally'.
> This is not just a matter of following specifications:
> IANA actually assigns numbers in this range [1].
> 
> I understand that Linux uses 61000-65535 for masquarading/NAT [2],
> so I left the high value at 60999.
> This means the high value still does not follow the specification,
> but it also doesn't conflict with it.
> 
> This change will effectively halve the available ephemeral ports,
> increasing the risk of port exhaustion. But:
> a) I don't think that warrants ignoring standards.
> 	Consider for example setting up a (corporate) firewall blocking
> 	all unknown external services.
> 	It will only allow outgoing trafiic at port 80,443 and 49152-65535.
> 	A Linux computer behind such a firewall will not be able to connect
> 	to *any* external service *half of the time*.
> 	Of course, the firewall can be adjusted to also allow 32768-49151,
> 	but that allows computers to use some services against the policy.
> b) It is only an issue with more than 11848 *outgoing* connections.
> 	I think that is a niche case (I know, citation needed, but still).
> 	If someone finds themselves in such a niche case,
> 	they can still modify ip_local_port_range.
> 
> This patch keeps the low and high value at different parity,
> as to optimize port assignment [3].
> 
> [1]: https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.txt
> [2]: https://marc.info/?l=linux-kernel&m=117900026927289
> [3]: See for example commit 1580ab63fc9a03593072cc5656167a75c4f1d173 ("tcp/dccp: better use of ephemeral ports in connect()")
> 
> Signed-off-by: Bart Groeneveld <avi@bartavi.nl>

Changing the default range impacts existing users. Since Linux has been doing
this for so long, I don't think just because a standards body decided to reserve
some space is sufficient justification to do this.

