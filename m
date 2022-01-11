Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D5348AE60
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 14:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240482AbiAKNYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 08:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiAKNYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 08:24:11 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A9FC06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 05:24:11 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id q3so18358790qvc.7
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 05:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2GKUo16gzL70lehCJgEozfgnVN4eUcr8glNuGmsTl6E=;
        b=lluWOk7HjiUa+G+N5motvbXrlJ8ma3s4f7m7CLJuzLz7xBwOu7KsUQ2fnmAR3sx4Ma
         EmnX/+9Pj4/Ylfu+bxGVY43Cpk+Yugavc/GErMfploP6peofZw2LK4I9rbZIWKN2jBm0
         HMhKiYqJx1mAPrqHxdIYSs5Du0wBUE/WFDTYQvRyTqPRzYQVL19MtFOBgFMEbze714N+
         OPiIl0Gx0md07b/FfpGV67l2PhU6mWDPJ0hTcqnCZR7HHRl47bg5ta/7o8pexR7Xgfxg
         ZUk6UH7oUqP8wChQuBGIDr0DOMw3HQdJs8QBYWQGCXPwu3Hrm44DHGR6xWWDOFP5vOAS
         PBRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2GKUo16gzL70lehCJgEozfgnVN4eUcr8glNuGmsTl6E=;
        b=IlKQHxqidd7ufef9xXA33Y7yQkAC7qZPKn35fz0AxBxWNF0wMPsA8x6XeKljzLoHI7
         h4o2mx8EF0914E6eXqdl5fyqnISSq2qVhqVv9+L5p2ZcFqH4fqqgloAAtl9dd92NcTV+
         PZ71aFiHZzNcchscPpMVL5Bmc/iHN/xcSSHu57jrQ7jj5CO7Aug1V0rOD+ru8Z39bhAd
         yZuj5LIQZ2gzctGEuubIssIC7gpwdwgHs46eGSmqC+uMQVT81OA5FqvkExROYfwe+UHi
         P7OLm3IqTJ0B/cq8fmyVeVdzqsiwYRaeYQN5kLqaTceCQb9Uhn5SAbddWXfEFG2nErLS
         EWIg==
X-Gm-Message-State: AOAM531RxWEsx3l8lqvwadYRSI30H27bU555DxWdbQxzoEO2ETz2JYJJ
        EJT+asXyOy5keTZLOhMKMeHzdPeHKa1nbSumWQ==
X-Google-Smtp-Source: ABdhPJxqD92IVZ7qjRuhC7KaM1BhJCy9NBcyEeqrh00cgfZ68MHV3AQonkpSYHLYH5FnxmmN9Ho/rN8tZTx0PTeYao8=
X-Received: by 2002:a05:6214:c89:: with SMTP id r9mr3797141qvr.116.1641907450228;
 Tue, 11 Jan 2022 05:24:10 -0800 (PST)
MIME-Version: 1.0
References: <20220110081537.82477-1-moshet@nvidia.com>
In-Reply-To: <20220110081537.82477-1-moshet@nvidia.com>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Tue, 11 Jan 2022 14:23:34 +0100
Message-ID: <CAHn8xckHR-1n5jW8dL6AHS3DSX0TOZK87yZ-L13jo79_LjfvVg@mail.gmail.com>
Subject: Re: [PATCH RESEND net] bonding: Fix extraction of ports from the
 packet headers
To:     Moshe Tal <moshet@nvidia.com>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resending my reply as I again forgot that Gmail's mobile app doesn't
do plain text. Sorry about that.

On Mon, Jan 10, 2022 at 9:16 AM Moshe Tal <moshet@nvidia.com> wrote:
>
> Wrong hash sends single stream to multiple output interfaces.
>
> The nhoff parameter is relative to skb->head, so convert it to be
> relative to skb->data for using in skb_flow_get_ports().
...
>         if (l34 && *ip_proto >= 0)
> -               fk->ports.ports = __skb_flow_get_ports(skb, *nhoff, *ip_proto, data, hlen);
> +               /* nhoff is relative to skb->head instead of the usual skb->data */
> +               fk->ports.ports = skb_flow_get_ports(skb, *nhoff - skb_headroom(skb), *ip_proto);

This will likely crash as skb can be NULL here when calculating the
hash for a xdp_buff. You'll need to make sure this code also works for
bond_xmit_hash_xdp, which passes a data pointer, but no skb to
bond_flow_dissect.

In what case was the original code broken? The flow dissector
should've used the passed in "data" pointer, but I guess in some cases
not enough data was in the linear region. The right fix is probably to
make sure "nhoff" stays relative to skb->data. The optional skb
pointer is rather unfortunate and bound to cause issues in the future.
Perhaps might be worthwhile at some point to have a more abstract
notion for a packet buffer, with xdp and skb implementations and a
flow dissector for it?

You can verify that this does not break the XDP bonding functionality
by running the xdp_bonding bpf selftest ("vmtest.sh -t ./test_progs -t
xdp_bonding" in tools/testing/selftests/bpf).
