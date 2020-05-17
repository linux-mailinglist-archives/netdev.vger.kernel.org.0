Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4251D6787
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 12:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgEQKve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 06:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgEQKvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 06:51:33 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C58C061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 03:51:33 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id h21so6340143ejq.5
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 03:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c6QtPg2o/RHjcYUveiYsELNNbSChIH+Ej9lMJs/Ed+g=;
        b=PSAT6c3+0cvNMHRbcVnekTMp7uJe/SLojwkidlvvMuXz9VGVXD9XTQPgEd0SxNCxam
         ZhOARMsgrugbuyN4+I8tCCz3jIADk3/90QhUMlbg5yazJFegblbszikblFhkoZqRITrf
         C8CtoP7BTzuCGwlzUrh7iUUz2lSL/lKEAwR7D0crcFpHPj0qOlNCofCMqcCb7BneZIUD
         X7e9W9MDxcCu1gWTPeGgQgS1xteLsau3HAgHkZJh2qpMcxvrMPs+JPDlgHo5U+LxpfXG
         YlrRr6Vvi9SozrTqEdbfo9up5w3VrtHd6Vsq6bPYOVD0prqMrQ9N8AxzF7SreH8daBZI
         ix3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c6QtPg2o/RHjcYUveiYsELNNbSChIH+Ej9lMJs/Ed+g=;
        b=o4K0dEDPvFnrdXbAT+gyuuh6ESemaq9KEF9CWbfaGI4JfBs77eKsehJK4vgbbgf1ND
         MOEK0NBKWypnI+90/PqtNTVgrY3oZdORVyj1bY6PDzjy9OWmCI7bWwqsrHWZ/o7rQf4z
         gL8GG17XJxVCyATxMf7T5NCb2rzqAlNp2XfZlAbrbL8fA3OzReiBHd3mpNspMO/ksC8y
         CytcXtpcK0tkvh1iMzfpwMSnq78FTx/4w1EElQrECQW9T0907Mr685RXJ1q3Q/jxH5SR
         uo2qghsb139nmq+dOjvflikgh7CwYiaJxzSoU+2UTNxiAhkxUAFR2kZx6r5mXhYb3ca9
         drQw==
X-Gm-Message-State: AOAM530c5jvOZbpFZmHADRWnVw+sYlxG53okpauCHh32anQXXSbClj3T
        SeyhgUQCTMEdtecmCHJXjgYYxuZ7ygzliy2/faD4sg==
X-Google-Smtp-Source: ABdhPJymibuT4oftjhAP7TyFU53ASlulh2i8ppuyvd8+9wHFKTHQFCaP5PXygatv5htGJEAW+CSoA3ybJUdmeA0F/BI=
X-Received: by 2002:a17:906:dbcf:: with SMTP id yc15mr10748540ejb.176.1589712690293;
 Sun, 17 May 2020 03:51:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
 <20200516.133739.285740119627243211.davem@davemloft.net> <CA+h21hoNW_++QHRob+NbWC2k7y7sFec3kotSjTL6s8eZGGT+2Q@mail.gmail.com>
 <20200516.151932.575795129235955389.davem@davemloft.net>
In-Reply-To: <20200516.151932.575795129235955389.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 17 May 2020 13:51:19 +0300
Message-ID: <CA+h21hrg_CeD2-zT+7v3b3hPRFaeggmZC9NqPp+soedCYwG63A@mail.gmail.com>
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
To:     David Miller <davem@davemloft.net>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 May 2020 at 01:19, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Sun, 17 May 2020 00:03:39 +0300
>
> > As to why this doesn't go to tc but to ethtool: why would it go to tc?
>
> Maybe you can't %100 duplicate the on-the-wire special format and
> whatever, but the queueing behavior ABSOLUTELY you can emulate in
> software.
>
> And then you have the proper hooks added for HW offload which can
> do the on-the-wire stuff.
>
> That's how we do these things, not with bolted on ethtool stuff.

When talking about frame preemption in the way that it is defined in
802.1Qbu and 802.3br, it says or assumes nothing about queuing. It
describes the fact that there are 2 MACs per interface, 1 MAC dealing
with some traffic classes and the other dealing with the rest. Queuing
sits completely above the layer where frame preemption happens:
- The queuing layer does not care if packets go to a traffic class
that is serviced by a preemptible MAC or an express MAC
- The MAC does not care by what means have packets been classified to
one traffic class or another.
I have no idea what emulation of queuing behavior you are talking
about. Frame preemption is a MAC hardware feature. Your NIC supports
it or it doesn't. Which means it can talk to a link partner that
supports frame preemption, or it can't.

Thanks,
-Vladimir
