Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF7CCC1EE
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 19:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388187AbfJDRna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 13:43:30 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42506 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387935AbfJDRn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 13:43:29 -0400
Received: by mail-ed1-f66.google.com with SMTP id y91so6677370ede.9
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 10:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xOQw4GWvP/j8/ucnFVBR7X1s5Q8RL5HoeNmM6jQ2zaI=;
        b=c0W4dVtlgFbXFV6xwk3AB18OArzx8aG5H/xz4VRBdZZATzu0yKH725ttqpcfy6cJq2
         D+wabG69qhoRiJA2J3irSZ17scFXfI7zaZk3nI7/qvqGgaXqc1BNKsS1Vi8yu+G6sf+r
         d86n9zta5zM6lZWAJUH4YrSsXFEvV4M/R9TzE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xOQw4GWvP/j8/ucnFVBR7X1s5Q8RL5HoeNmM6jQ2zaI=;
        b=XXAHTb6S7qrW/ocNtaVUkG8zaDwtqI0ytExr6CoHqECBBWIrfewMdqVj4VrFaGPpcW
         MavHQPKJd2C54wWMMjN5PWcOBZIN3zPvkNwQsprXWnCS051JDPezyTuZKMhUyJzmPelL
         HBIrhsU5hkxhXoLa17Z0Wxag3A9xGGKrgL5urLJC8n3Bp7jUNnCT06wRpC1EYTqzSFac
         QVAGmnxQP9uZiGPTi7z4VRICj3o2oZWyw/hss44UHEyKJxB+w2IWyw8AyBD/7kw4XVLD
         T1sU+zmUhWhdkyzVpibjyog/f8thFRm3Xi08hfHK2m01XIcqqpu/EG+5ge2rfZXa/0ex
         9TxA==
X-Gm-Message-State: APjAAAV6beS/mzrddNKC9XY6sJapRXt7czArQTocfU1xcIuxY1v+Ba9c
        T90jNv06DrHmRL0Sy25CPReS/C08qFIXcaCNJ7CHKg==
X-Google-Smtp-Source: APXvYqxNTwKdhwb691DIaTZzQTA/UAU+fnnM5344CVaYTBH8/rWy6WHSQLTEmzI0nlVM9+76rVMTYTXW13KZaHO4E/E=
X-Received: by 2002:aa7:cdd6:: with SMTP id h22mr16811575edw.132.1570211008089;
 Fri, 04 Oct 2019 10:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <20191002084103.12138-1-idosch@idosch.org> <20191002084103.12138-13-idosch@idosch.org>
 <CAJieiUiEHyU1UbX_rJGb-Ggnwk6SA6paK_zXvxyuYJSrah+8vg@mail.gmail.com>
 <20191002182119.GF2279@nanopsycho> <1eea9e93-dbd9-8b50-9bf1-f8f6c6842dcc@gmail.com>
 <20191003053750.GC4325@splinter> <e4f0dbf6-2852-c658-667b-65374e73a27d@gmail.com>
 <20191004144340.GA15825@splinter> <0ba448e3-3c27-d440-ee16-55f778b57bb1@gmail.com>
In-Reply-To: <0ba448e3-3c27-d440-ee16-55f778b57bb1@gmail.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Fri, 4 Oct 2019 10:43:17 -0700
Message-ID: <CAJieiUivWMD_QkqYA6Y08Ru3hCoy==MGaiNq7ma2K06WxgFuRg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 12/15] ipv4: Add "in hardware" indication to routes
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 9:38 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 10/4/19 8:43 AM, Ido Schimmel wrote:
> >> Sounds like there are 2 cases for prefixes that should be flagged to the
> >> user -- "offloaded" (as in traffic is offloaded) and  "in_hw" (prefix is
> >> in hardware but forwarding is not offloaded).
> > Sounds good. Are you and Roopa OK with the below?
> >
> > RTM_F_IN_HW - route is in hardware
> > RTM_F_OFFLOAD - route is offloaded
> >
> > For example, host routes will have the first flag set, whereas prefix
> > routes will have both flags set.
>
> if "offload" always includes "in_hw", then are both needed? ie., why not
> document that offload means in hardware with offloaded traffic, and then
> "in_hw" is a lesser meaning - only in hardware with a trap to CPU?

I was wondering if we can just call these RTM_F_OFFLOAD_TRAP or
RTM_F_OFFLOAD_ASSIT or something along those lines.

My only concern with the proposed names is, both mean HW offload but
only one uses HW in the name which can be confusing down the lane :).



>
> >
> > Together with the existing offload flags for nexthops and neighbours
> > this provides great visibility into the entire offload process.
>
