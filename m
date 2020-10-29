Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD2B29E643
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgJ2IU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbgJ2IU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 04:20:58 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E05C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 01:11:26 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id p15so2092221ljj.8
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 01:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id
         :in-reply-to;
        bh=0pOM50VBIVgYUcjgLqeHV2YZkQncc1S8zNRv56k4JAc=;
        b=zJDJsixiO0la6tuJVfYMwmw1YymnTpaGSaakpukDC9+Xy/LHlmb0OAgcqSk49Bdm2n
         QIH7PjykJXrqT5I5L4fT5zCxYTKOU/Ht1uybZ02KAnnaAWOXAXrFcJdn1oGhUMCqaiUk
         r4iLEApv9b4xF3uttTYHmNi7qyzx7r4crm7ZZzMGyGzcli0GsDKoG/7qMD/zVv09bqNL
         I7/B3ZKvkean+TYDKk1fR/u7Vf6xvYF8uNKcvXxDGgI7Wni2qTkjDbZrbJnfWem1fvOb
         gRSoei2uuMx8jAJ3EqaEtOx0gY8oOwlUfbsY+HaQB9tbSplD6RKfDTByiSoetM7hEitv
         H1hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id:in-reply-to;
        bh=0pOM50VBIVgYUcjgLqeHV2YZkQncc1S8zNRv56k4JAc=;
        b=DZKF2z/gEblZEYfexzV5xLmfNzL14k8jBQgbl9ogTkD4QWR8vwCVVGdjxAtitUS/Ln
         4XAIC9nk2GN22eKuJj+HVFgPkz7tbGAB4GtZEIjATELt4ZOFL8YIp0Hkd6POLu2x9NuX
         l3yyaAh/+9wSBGP17cL+PtjUl3+6rz3QnFC/Lxid1HUSSmAibjpamYbB2UzGKgKllVr7
         yzT4eZLK4z2RML1FiFRbvyogorJaTS+reJ902IAL9wc7Nn2Qgkey7X74KKiwPEfIYn5G
         gHYOuSVhBaPbYODiagg/EDg7iwW0js7tWZXzoqEevZqlYgFk/Z43fIti3YffCLRkfjHr
         sEUQ==
X-Gm-Message-State: AOAM533tpXLkx9pmssX7mnCjTC3ohzeF0o8I/Puvc9LFgmTMrJ+9hugh
        c876Gbi5CtwkJ14xdEBbax0T6Q==
X-Google-Smtp-Source: ABdhPJzxPobIvsr04P+mI+QIGmNC0Rn6r3n/VRBRanwnMzAj4V9wKCfUqElzm+x9V61mn3/GuZsLng==
X-Received: by 2002:a2e:8798:: with SMTP id n24mr1208094lji.317.1603959085332;
        Thu, 29 Oct 2020 01:11:25 -0700 (PDT)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id k16sm243378ljc.39.2020.10.29.01.11.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 01:11:24 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        "Ido Schimmel" <idosch@idosch.org>
Subject: Re: [RFC PATCH 4/4] net: dsa: tag_edsa: support reception of
 packets from lag devices
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Vladimir Oltean" <olteanv@gmail.com>
Date:   Thu, 29 Oct 2020 08:47:17 +0100
Message-Id: <C6P7J2EICLJ2.2QY1SQHL62MH3@wkz-x280>
In-Reply-To: <20201028230858.5rgzbgdnxo2boqnd@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu Oct 29, 2020 at 2:08 AM CET, Vladimir Oltean wrote:
> On Wed, Oct 28, 2020 at 11:31:58PM +0100, Tobias Waldekranz wrote:
> > The thing is, unlike L2 where the hardware will add new neighbors to
> > its FDB autonomously, every entry in the hardware FIB is under the
> > strict control of the CPU. So I think you can avoid much of this
> > headache simply by determining if a given L3 nexthop/neighbor is
> > "foreign" to the switch or not, and then just skip offloading for
> > those entries.
> >=20
> > You miss out on the hardware acceleration of replacing the L2 header
> > of course. But my guess would be that once you have payed the tax of
> > receiving the buffer via the NIC driver, allocated an skb, and called
> > netif_rx() etc. the routing operation will be a rounding error. At
> > least on smaller devices where the FIB is typically quite small.
>
> Right, but in that case, there is less of an argument to have something
> like DSA injecting directly into an upper device's RX path, if only
> mv88e6xxx with bonding is ever going to use that.

Doesn't that basically boil down to the argument that "we can't merge
this change because it's never going to be used, except for when it is
used"? I don't know if I buy that.

How about the inverse question: If this change is not acceptable, do
you have any other suggestion on to solve it? The hardware is what it
is, I can not will the source port information into existence, and
injecting packets on the wrong DSA port feels even more dirty to me.
