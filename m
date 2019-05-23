Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E423C28CCA
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388431AbfEWWAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:00:07 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33565 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387616AbfEWWAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 18:00:07 -0400
Received: by mail-ed1-f68.google.com with SMTP id n17so11339033edb.0;
        Thu, 23 May 2019 15:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NrjoaoALFNTTvuCx/kpH3VCJxv7gD5HUSZpBKLlLy3Y=;
        b=o/rLrxnWlaxo+KO6LQia/PuLTPMOLvFfKv5nueVIVHcQ4LtoL1M+ExBzV2mOXHCkgq
         9FXZmmJt5eqRpe8yMoW92kiXkhsaAQFkuOa+LvBBokqehAAZvNkuqzQeg8PdBjSHJb9T
         2TsMZgmwUDfJG9sTDn+2BogPTov9xd6i4AivrxB6DTqXh9TVSKiyUB6Z6QLmoYX+deUy
         Y7+U6CTkAyQlsh3Uztoum88uCwzTeuNbgXhGI7lbyXZPmftAI7eGkYV/uD1vBhYokyZF
         wwmcWZLsgKcLs50zTx8C9ONYD5j8QHAp0gorKmXlLcMXGn9nPGtz2gpAgAf1ykj0uVZD
         1mXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NrjoaoALFNTTvuCx/kpH3VCJxv7gD5HUSZpBKLlLy3Y=;
        b=DeKZ8uixSASIStNO3HKUq9LL+JZ4sX/5Dgf8qA/FbrcgPNB/dkMjWgFCMYiJW0WTfZ
         /gKzDCSHeVWtGJ6/cwYdjjOx/rGVXW6aXHL2M7rSHpPlyd8z2IS+nMtBR5OcV7i5pDdK
         8Rv0KiyOmCSFdfd0MTg3DbJiWWwjAfwCT4ckrrFKr36epn0I5/i+7ju+Wg1b7zGdjoTg
         e8uC6bcIHTgRb7DDsHYCYOPsgDXK2+cbS+QUg1MEKGXo1rdak47+dLc7vmDUmQdofrGH
         Uy+I+RnZ57pYpUjRIhOYO+w9bG005EsPmnHK4zB3c8WYXML4/TVg5y9if/1hzqlFLjty
         GXOA==
X-Gm-Message-State: APjAAAVtVrPjddPita0+f5vEULhMyu91Iyq/IphCLbYzj4P1PvveadsP
        vSKnM+3i6Py17EtpM7oFBnqmX4nw4dfJJdR2YzA=
X-Google-Smtp-Source: APXvYqwtbiWFmfaqzvHt8wpfu08qW1lq5iWXYv/Rp0ykLQqMYS4xrMICt9HE7VUeyZAeAAEyThDzOA6bsjL/fa3PYhM=
X-Received: by 2002:a17:906:11d3:: with SMTP id o19mr60567117eja.278.1558648805454;
 Thu, 23 May 2019 15:00:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-2-fklassen@appneta.com>
In-Reply-To: <20190523210651.80902-2-fklassen@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 23 May 2019 17:59:29 -0400
Message-ID: <CAF=yD-+4g-HjmCnDWaVfdsyruePXqYeUDJgnffz9ro+rgNGv1g@mail.gmail.com>
Subject: Re: [PATCH net 1/4] net/udp_gso: Allow TX timestamp with UDP GSO
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 5:09 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> Fixes an issue where TX Timestamps are not arriving on the error queue
> when UDP_SEGMENT CMSG type is combined with CMSG type SO_TIMESTAMPING.
> This can be illustrated with an updated updgso_bench_tx program which
> includes the '-T' option to test for this condition.
>
>     ./udpgso_bench_tx -4ucTPv -S 1472 -l2 -D 172.16.120.18
>     poll timeout
>     udp tx:      0 MB/s        1 calls/s      1 msg/s
>
> The "poll timeout" message above indicates that TX timestamp never
> arrived.
>
> It also appears that other TX CMSG types cause similar issues, for
> example trying to set SOL_IP/IP_TOS.
>
>     ./udpgso_bench_tx -4ucPv -S 1472 -q 182 -l2 -D 172.16.120.18
>     poll timeout
>     udp tx:      0 MB/s        1 calls/s      1 msg/s

what exactly is the issue with IP_TOS?

If I understand correctly, the issue here is that the new 'P' option
that polls on the error queue times out. This is unrelated to
specifying TOS bits? Without zerocopy or timestamps, no message is
expected on the error queue.
