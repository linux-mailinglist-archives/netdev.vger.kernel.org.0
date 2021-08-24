Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B883F5771
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 06:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhHXE6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 00:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbhHXE6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 00:58:40 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4ACDC061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 21:57:56 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id y6so35403956lje.2
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 21:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=bU+QKR/jrdY7YoIA73vKkOY7YY3CxR7uor1mOZjxtso=;
        b=KSCrddLs6U68zIzkZLhPXI0oGJ0cuu2RycTKqzFWIOBG26Uk9onw3Oy1ndB3O34duG
         ZPdiaGe4mLs3EYpv0CeEEVsdgksAAWJhko1zmCT36FhyfJTfaNXCtfjdRAkJY7TKlWRY
         /fMZtNtkBaJ0k3254dGikJ4DDCirxMHiO9WBFYLj4uJqmWuuQpIj/PEwOzictp5f7v5E
         5EkogzE/8UGj5YzP8NJugE+mS/dYGbokjiCAfv+Ok3kxIFLTQL/tXqmMJRL8P30XYMvJ
         48UtC3QY73ZL1/j47CplD3URrCqu9ZKCTKHOi7Pn0HNVOCkP+4I2N28SBJLT8NPRdwcC
         m18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=bU+QKR/jrdY7YoIA73vKkOY7YY3CxR7uor1mOZjxtso=;
        b=t0K/XFofkBKqjG9O8UGyuUac9pqgqq/GxfrmDZR+DUF0zKbY3HR0prGlyhqTJBs4Hw
         TxYhEGoFK8tMXVIKs9isYbAjJH3LKxKIVEXq7KuHnZ4F4+PT4p9MLXmbYTelS7iqzc0K
         /yia0qQSzNYK3atbRiGnuD3oYy0pyxi/rEuDgw+LgL98m2V3O9TuwJo8h6vSBMNiRsnp
         5FrBH82RE+rclxtZRO3651zpJFmmCNx/OWqUviFYe9LVB66RyeZ6nAz1ZZob+ddBwNB0
         1hp7TokdeLOgTfDwXQbFec/v8xIBgjtvCeUA7dsxThkKIZ3Eqwg8D06CyZ4U6A3lVr1o
         CLUw==
X-Gm-Message-State: AOAM5318MRkNTufFXdvPU85V1y7byE4dxYetexH8Uew9QwYElEQqQnck
        T4PDEwoAA1ATexdnjEjWaAsnDRqDmH+sLmmpRH+XLlp+TuALTA==
X-Google-Smtp-Source: ABdhPJzk81eyke+yJkjvHKNLzzSdNpHW6OkSWfxQz+TvpTpvGJBfExAhRH9QSq+EQ+n1POZnKE3K1FMhsfNe71jAjKc=
X-Received: by 2002:a05:651c:11c7:: with SMTP id z7mr30052469ljo.87.1629781075128;
 Mon, 23 Aug 2021 21:57:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAGnHSEk-gxY3jr-2k8+NSB0uf9H94SDQyxJFVM1LH3A+Bs+5MA@mail.gmail.com>
 <CAGnHSEmeLTq6FsG18QDBmD_cHcNfTk2N6t7Nwrc53p9Ejnd5kg@mail.gmail.com>
In-Reply-To: <CAGnHSEmeLTq6FsG18QDBmD_cHcNfTk2N6t7Nwrc53p9Ejnd5kg@mail.gmail.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Tue, 24 Aug 2021 12:57:44 +0800
Message-ID: <CAGnHSEkBiJdLFb88U2d7EhgxvfwbE7DtOxp115SzoP8Cv_Jq4A@mail.gmail.com>
Subject: Re: Bridged passthru MACVLAN breaks IPv6 multicast?
To:     netdev@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Never mind. I made a mistake. Turns out only Neighbor Solicitation
from a LAN host does not "walk across" the MACVLAN. ping
ff02::1%some_dev and Neighbor Solicitation from a bridge tap host
actually do. (I forgot to change the ether saddr for them: the
underlying link is a wireless NIC)

Btw Neighbor Advertisement from a LAN host "walks across" the MACVLAN
as well. I can see it on this host.

I guess I can workaround the problem by re-enabling IPv6LL on the
MACVLAN. Still wonder why that is broken though.

On Tue, 24 Aug 2021 at 12:12, Tom Yan <tom.ty89@gmail.com> wrote:
>
> Hi,
>
> I've further investigated the problem:
>
> What "walk across":
> ping ff02::1%bridge and Neighbor Solicitation from this host (tcpdump
> multicast on a LAN host can see them)
> ping ff02::1%some_dev from a LAN host (tcpdump multicast on this host
> or a bridge tap host can see them)
>
> What do not "walk across":
> Neighbor Solicitation from a LAN host (both tcpdump multicast on this
> host and on a bridge tap host cannot see them)
> ping ff02::1%some_dev and Neighbor Solicitation from a bridge tap host
> (tcpdump multicast on this host can see them, but that on a LAN host
> cannot)
>
> There is no problem with ARP (or IPv4 multicast, apparently).
>
> P.S. I've filed a bug report on:
> https://bugzilla.kernel.org/show_bug.cgi?id=214153
>
> Regards,
> Tom
>
> On Mon, 23 Aug 2021 at 02:07, Tom Yan <tom.ty89@gmail.com> wrote:
> >
> > Hi,
> >
> > Normally when a NIC is (directly) enslaved as a bridge port, the NIC
> > itself does not need to have a IPv6 link-local address configured on
> > it for IPv6 multicast / NDP to work properly (instead the address can
> > simply be configured on the bridge like IPv4 addresses).
> >
> > Yet it appears that if the bridge port is instead a passthru mode
> > MACVLAN, IPv6 multicast traffics from (the link/"side" of) it cannot
> > reach the host (as in, cannot even be captured with tcpdump) unless
> > either the MACVLAN or its underlying link has a/the[1] IPv6 link-local
> > address configured.
> >
> > Is it an expected behavior? Or is it a bug?
> >
> > [1]: In my configuration, the bridge, the bridged passthru MACVLAN and
> > its underlying link have the same MAC address and hence (at least by
> > default) their IPv6 link-local addresses are identical.
> >
> > Regards,
> > Tom
