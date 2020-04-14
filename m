Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83F31A7485
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 09:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406497AbgDNHRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 03:17:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49954 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406487AbgDNHRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 03:17:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586848658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ahAiLETp8umnPO/61qAD9JWvNWbW1T8CaoI0m/e9Vbo=;
        b=hGTNj3CbOWSyz4k+c9PWA7W/N3lhSpQpHPqOPHWK9zoWbqcrbl2C5NAavKUjntk/STIbv4
        zMPyY8C0FdwLq8PIXDw1R2DUrnruLHflbUw4VKlkRCEtdPEzW7OYbErjgoi5RjDvF3N/Zs
        KWYtdEeAEq4lpHvnn8SNEIvzCPLjzkU=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-FYZTjRlGMp2k5DTGp3my0g-1; Tue, 14 Apr 2020 03:17:37 -0400
X-MC-Unique: FYZTjRlGMp2k5DTGp3my0g-1
Received: by mail-lf1-f71.google.com with SMTP id y19so4663433lfk.13
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 00:17:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ahAiLETp8umnPO/61qAD9JWvNWbW1T8CaoI0m/e9Vbo=;
        b=OAf/ttPaN4UwARuRzaDNGFy+OK704zXrvo5+L6a0Qew4WyOnHdHGQqRfECjZaEp8Sq
         60Qk9x4+3ZUrKln7cHNKPrHHqO8trUBGdojnAeugsRGViiGF9gAyX3MxZ0esBnZtBEPE
         Rj61T3af2RtVP70EJoPSTo36jzCFVH5PF1nkTx0MvBKcEXVFqqgyRtGzffJZ4LiRTIXu
         yGZTpfv/lACvtxT80gup9pn7rRtg0H83m0Gwu3o9UQ76FUbFJ5QYTBcqHy5GEjIe3mqY
         aiRl4KWGgQgK4oVYoIjIuB8AqoqqFeCYZ/e+WiZVrIoKruXBxkfaEiayOndS3MLXl8FD
         GWmA==
X-Gm-Message-State: AGi0PuZ1IKqu4VfGXVjz7baHql09BB2+7/p6vMEind2OG9WMHwtd0L29
        LpEkuh2W5CTABmru91O3shk+USnJc1l1mWhzX1nxwNdzHBjbIs3WIVcBedWUpGkJXyEnWbGLLZg
        7XoyHMJT9rjnWMwA8
X-Received: by 2002:a05:651c:108:: with SMTP id a8mr9570927ljb.160.1586848655553;
        Tue, 14 Apr 2020 00:17:35 -0700 (PDT)
X-Google-Smtp-Source: APiQypKuoAW8ZeV5W6OuILRjRsKJ41hPLaQm4fGf6ZB4fiS8k2I6LUNJJjs5NRAv96MVu7ZOSX7Exw==
X-Received: by 2002:a05:651c:108:: with SMTP id a8mr9570915ljb.160.1586848655360;
        Tue, 14 Apr 2020 00:17:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id l6sm8547620ljc.80.2020.04.14.00.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 00:17:34 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AF91D181586; Tue, 14 Apr 2020 09:17:32 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH bpf] xdp: Reset prog in dev_change_xdp_fd when fd is negative
In-Reply-To: <20200412133204.43847-1-dsahern@kernel.org>
References: <20200412133204.43847-1-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Apr 2020 09:17:32 +0200
Message-ID: <87imi2pmcz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: David Ahern <dsahern@gmail.com>
>
> The commit mentioned in the Fixes tag reuses the local prog variable
> when looking up an expected_fd. The variable is not reset when fd < 0
> causing a detach with the expected_fd set to actually call
> dev_xdp_install for the existing program. The end result is that the
> detach does not happen.
>
> Fixes: 92234c8f15c8 ("xdp: Support specifying expected existing program w=
hen attaching XDP")
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Ugh, my bad (obviously!). Thanks for the fix! I'll send an update to the
selftest to catch errors like this...

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

