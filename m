Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AF563F3A9
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiLAPVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiLAPVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:21:23 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F5BA95AB
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 07:21:22 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id x24so733112qkf.5
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 07:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=F+aJp9nKjPGTL8kc2LjILS5v+0u+UwxQjsGUkZU58yo=;
        b=T7ZxDVxe+Ywjh4UUtEtwOqON3VjmUHLhLR0gfCSAYJ7YyZ1b6aFffciBrCR4WK7btn
         8lhlZi4RIBNx7J1+i0TEVfhPfk27qSkJsldYhgbjhnKrnO5W90cb4GR6AIOR0fewkGjq
         NSyRWvYWMCpz12bBPo69oP5frjsemX/8qZOv4oGbb6Zl+/jM/ISPlNe3d3Dy0Rs2WYhg
         P5QV6fByuVedQaAht8GGc5gv3U7kmRz7idweXUfe3wAYpg/e8Y2GSzqvzQMOHCdnonz/
         XLmnzpN/wJTYcjb3w5C12vr8+36TEYLP7rVrAlVYZN4BYcojhSdGL7kD7kM/dd3VwJhO
         qJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F+aJp9nKjPGTL8kc2LjILS5v+0u+UwxQjsGUkZU58yo=;
        b=BJ4F/CALz3+eXuhAQpFgtuHly5NKcneQ5vblEUJepdjPoemuZS8cukmW2DOOJl0A8W
         +yMiyclKCwMwnXytZsGPSDFUondm/dG/SWKZkgDcVh9sopxruTP4tAPyTl2yfOxjyfJb
         f5UZuHkkL8YtZKVosO6b6MEnNmkEeZeDSX0UdsnUo92GEoOeLEx+xP0Ytt47tA0dDauK
         vlLbswOZkJs+UbRl5Uf24w3H/pSHZlysdE0j5ybhkZpDWTfu+yNuaPysoeuCqzXIABHt
         EpFR1XNSURWGN89hX08eO0Ly+H+3S61zfeNntmf0n7KYtwX9nuLrVjJ2+FSFVv1x5FVl
         +OJw==
X-Gm-Message-State: ANoB5pliokRrD5C3gYgKCpBdvEXYOcMRf0QV6ikV6lfgU4xvAw+4eTcG
        OCczcZn/bvdIB7jxhmog1uPzpCYhxEbMXTByaDc=
X-Google-Smtp-Source: AA0mqf7+O+K+gVqCfzLsaYusvxMfIZ6u4ct4O8yGJ7fPPuPcdPb8myfdpqI51AM6DJInrsBPM6bpc9cEggqXy1wFJL0=
X-Received: by 2002:a37:80c:0:b0:6fa:2cab:4945 with SMTP id
 12-20020a37080c000000b006fa2cab4945mr43701973qki.256.1669908081701; Thu, 01
 Dec 2022 07:21:21 -0800 (PST)
MIME-Version: 1.0
References: <CAHRDKfRZEw3Mq9GP3rCf2U10Y7X7N61BNZCa95tKESZkVD2qAg@mail.gmail.com>
 <Y2yzKfSPJ7h2arO/@shredder>
In-Reply-To: <Y2yzKfSPJ7h2arO/@shredder>
From:   Leonid Komaryanskiy <lkomaryanskiy@gmail.com>
Date:   Thu, 1 Dec 2022 17:21:10 +0200
Message-ID: <CAHRDKfSoNdWWjv8X6-fBvaaaJ7wFekvKAYkfD01JBcqrMiLtUA@mail.gmail.com>
Subject: Re: ip_forward notification for driver
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     dmytro_firsov@epam.com, petrm@nvidia.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel, thank you for your advice.
We checked netevents (NETEVENT_IPV4_MPATH_HASH_UPDATE and
NETEVENT_IPV4_FWD_UPDATE_PRIORITY_UPDATE) but unfortunately, netevents
notifier doesn't trigger at all in case of changing value in
/proc/sys/net/ipv4/ip_forward. We see, that these events come in the
case of modifying /proc/sys/net/ipv4/fib_multipath_hash_policy, but
not for ip_forward. Shell we prepare an upstream patch with notifier
for ip_forward modify netevent?

On Thu, Nov 10, 2022 at 10:15 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Thu, Nov 10, 2022 at 09:51:35AM +0200, Leonid Komaryanskiy wrote:
> > I'm working on L3 routing offload for switch device and have a
> > question about ip_forwarding. I want to disable/enable forwarding on
> > the hardware side according to changing value in
> > /proc/sys/net/ipv4/ip_forward. As I see, inet_netconf_notify_devconf
> > just sends rtnl_notify for userspace. Could I ask you for advice, on
> > how can I handle updating value via some notifier or some other Linux
> > mechanism in driver?
>
> You can look into netevents. See NETEVENT_IPV4_MPATH_HASH_UPDATE and
> NETEVENT_IPV4_FWD_UPDATE_PRIORITY_UPDATE, for example.
