Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C68A2038DF
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgFVOOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728947AbgFVOOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 10:14:49 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BE1C061573;
        Mon, 22 Jun 2020 07:14:48 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a1so4126869ejg.12;
        Mon, 22 Jun 2020 07:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qrru4akBbNmw6yQ1nWeFHMQrM/aKl5Xws00no84+oPI=;
        b=JnwRnwI7MagJ2ZbdnioCIW6ggCbVb+uP+qgTZHMGWBKc40D8y4KYZT5sB6v2lmLwlV
         Uj/pZUj5mrO2M/rw/Qe1uhXlDivx2QF77V1z2n6mhKcELQkoQ2rQv1AXtrRMZnio5uyb
         Ct+ysntg8gP2LPHH4LJX+ZzO1Ge+CW9m2ra0AWKo/WV6pias5l3aiYZdZAylGoiA7j3O
         UFQYwHcAG2dbdTyJ3rpvrh153l0iXNGCMAB6zikJPk7B7z3yyMOlfHB38k8Rm7JTIrNm
         B5uR2mK/9kjgbdmHGbAkN1Ak5vrxgIyVAVyMLspb3+NwlJGO2lfAZz6aKkO4UhhLlZtQ
         bmkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qrru4akBbNmw6yQ1nWeFHMQrM/aKl5Xws00no84+oPI=;
        b=nBKgjPrso7jjjS9VagO32WrOjlYUUTsn1L9/uiBs8ZnOEgxiexG9sBIG+GncSWKmsM
         PUenaEzi8viDVya6HRMBz9AYM2HB//iDImXctpvEHUg57mILF+09f0m1XnKxFAerSFxx
         wSRS4grciFVy3xcYh+DMq2y9Tyhx1mAn66kiKcGQ6bBNOxKRJFPViqtfJ2hOd6XRyneO
         gigMK4YAHvmgmzAX98nrLf1ynDZpqZxXlZf5IhRXO6c5zdwvHIy4idZnk45ZDFS2BwxP
         1Jg+trg+x8tKDmQhfQMSeHC0COrk0kBEiTIsExEwVPx9ybE2+nu8eDZ5cpZJ56WT1XeQ
         8fFQ==
X-Gm-Message-State: AOAM531Du+4UDvLEGtiWP/jiXafzcnZ4jMvojZQWC3jQ9zp29dwHYzoz
        CwxCtfVxi2QDXaF0CFl0ysPaAsQXyQJ44q/dnzU=
X-Google-Smtp-Source: ABdhPJz4essDfToI+tkjRggir56akJLCGPwKfxJ6PNYCpjgI2xIP5GXbrJj9DZ/HfHJRpsfLSdoGQHn02Yt6lFbJaRg=
X-Received: by 2002:a17:906:2e50:: with SMTP id r16mr15443442eji.305.1592835287571;
 Mon, 22 Jun 2020 07:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-7-kurt@linutronix.de>
 <20200618173458.GH240559@lunn.ch> <875zbnqwo2.fsf@kurt> <20200619134218.GD304147@lunn.ch>
 <87d05rth5v.fsf@kurt>
In-Reply-To: <87d05rth5v.fsf@kurt>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 22 Jun 2020 17:14:36 +0300
Message-ID: <CA+h21hokLntfn7sDW-6boJ+=_q2CGUM6aXLg68O7moMyLH=41w@mail.gmail.com>
Subject: Re: [RFC PATCH 6/9] net: dsa: hellcreek: Add debugging mechanisms
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

On Mon, 22 Jun 2020 at 15:34, Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
>  * Re-prioritization of packets based on the ether type (not mac address)

This can be done by offloading a tc skbedit priority action, and a
"protocol" key (even though I don't understand why you need to mention
"not mac address".

>  * Packet logging (-> retrieval of packet time stamps) based on port, traffic class and direction

What does this mean? tcpdump can give you this, for traffic destined
to the CPU. Do you want to mirror/sample traffic to the CPU for debug?

>
> What API would be useful for these mechanisms?
>
> Thanks,
> Kurt

Thanks,
-Vladimir
