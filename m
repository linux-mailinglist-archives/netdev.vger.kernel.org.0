Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2D420E4A3
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgF2V10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729070AbgF2Smo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:42:44 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D02DC033C07
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 11:25:46 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id y13so9683579lfe.9
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 11:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id
         :in-reply-to;
        bh=x2TVejwESBGwIZIrpSyiV+BhBJwf7MU/sImsujfIriY=;
        b=kaAEEIeKW+HixXOCGQgDom8PI1QJh+1575+ZfyH8j491A06E9EF37L3wbJK2+1xeeW
         UjcdUuYkif9PRGjebg54X7/4jJ25nYdTV7QCKDfdz2zk8fK8Nzj1nyNYSAp1Nc2kV27J
         yuxGg3Vk+oXstNFg8lTtQshyXcKagYzq9Vmphbu6fWKFx7Ym8FzrH1BLIvcjASYNAMRY
         rlF9yjIf0SAbHexypD2twO8B4oQtiDcjy9CthdWlNogR8b4FYuP6SEgMv1WP8z+EMp+W
         i6jzTiaBvyBGQiFaKJ5Oxfyk+kfbIdqbn2y1myDyMAjBnnNDXcQVFt1oWfBVaHTjSNVe
         5UIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id:in-reply-to;
        bh=x2TVejwESBGwIZIrpSyiV+BhBJwf7MU/sImsujfIriY=;
        b=CyXqvTihLwNFddnFpNrikmUJKdQt231i/CqU9HLxolt1wbm8bL6+2e3kwiG0w+8jKx
         Z2LxPa7RShZmF8o1qLqEvfNi+u2Fi+W3dpM20IhonAjT1qOq6vpbGa7nS4popgpQc9IN
         AT+Nj6qViroPBtn81nolMTsXiO2PV7TJ9OLhL3pn4gtahsfzkuJMJf98wMMycpmNHu+f
         JqFW+5ev7aW2xVbyBQIrWyjjUW3Ou7GaXOjVNNH4eb/othepR3SG/7sjYZUiJukPwVLf
         ituXyMRz3wqU2hgvXKWIiiwroOxgwVABLVOD1afxG9Nw2DN5B1tysRazM5I0JKBCoqUN
         X7kQ==
X-Gm-Message-State: AOAM532scnGEV8ntxrkCa68pHyPfFONG+8pJ5hmL7BJv3+eacxJjvp6j
        7XdfuIUv6r0gEdNm7wcmhG3fVmmZ35E=
X-Google-Smtp-Source: ABdhPJzf7ZCXnMjOf+mmJHK0q4T51Lhdk+fMifE9/cspjVGyzWcDZBN9rnR+Hs2xD2C4+np9HkP/Eg==
X-Received: by 2002:a05:6512:3046:: with SMTP id b6mr9838585lfb.65.1593455143334;
        Mon, 29 Jun 2020 11:25:43 -0700 (PDT)
Received: from localhost (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f22sm123764ljn.66.2020.06.29.11.25.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 11:25:42 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next] net: ethernet: fec: prevent tx
 starvation under high rx load
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Andy Duan" <fugang.duan@nxp.com>,
        "David Miller" <davem@davemloft.net>
Date:   Mon, 29 Jun 2020 18:29:06 +0200
Message-Id: <C3TQ84VVJ0GY.3NZQOFY5QW9VM@wkz-x280>
In-Reply-To: <AM6PR0402MB3607B4D0AD43E1CBC41214BCFF910@AM6PR0402MB3607.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun Jun 28, 2020 at 8:23 AM CEST, Andy Duan wrote:
> I never seem bandwidth test cause netdev watchdog trip.
> Can you describe the reproduce steps on the commit, then we can
> reproduce it
> on my local. Thanks.

My setup uses a i.MX8M Nano EVK connected to an ethernet switch, but
can get the same results with a direct connection to a PC.

On the iMX, configure two VLANs on top of the FEC and enable IPv4
forwarding.

On the PC, configure two VLANs and put them in different
namespaces. From one namespace, use trafgen to generate a flow that
the iMX will route from the first VLAN to the second and then back
towards the second namespace on the PC.

Something like:

    {
        eth(sa=3DPC_MAC, da=3DIMX_MAC),
        ipv4(saddr=3D10.0.2.2, daddr=3D10.0.3.2, ttl=3D2)
        udp(sp=3D1, dp=3D2),
        "Hello world"
    }

Wait a couple of seconds and then you'll see the output from fec_dump.

In the same setup I also see a weird issue when running a TCP flow
using iperf3. Most of the time (~70%) when i start the iperf3 client
I'll see ~450Mbps of throughput. In the other case (~30%) I'll see
~790Mbps. The system is "stably bi-modal", i.e. whichever rate is
reached in the beginning is then sustained for as long as the session
is kept alive.

I've inserted some tracepoints in the driver to try to understand
what's going on: https://svgshare.com/i/MVp.svg

What I can't figure out is why the Tx buffers seem to be collected at
a much slower rate in the slow case (top in the picture). If we fall
behind in one NAPI poll, we should catch up at the next call (which we
can see in the fast case). But in the slow case we keep falling
further and further behind until we freeze the queue. Is this
something you've ever observed? Any ideas?

Thank you
