Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8E529C8A5
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829828AbgJ0TWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:22:09 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35838 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1829818AbgJ0TVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:21:36 -0400
Received: by mail-lf1-f68.google.com with SMTP id f9so2979204lfq.2
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=WpFKsNvss8IvzEIn5pI/HwxxhiWgR1KW/VquaAm2mVU=;
        b=q5SPwnEqCNjgFYaei2Wo+fnglvrw97thMeEF9gZIKssoFBcAoPNIolB+zruRdKQOmL
         W/znB9bMgZZ/JL2WfV2ixbiiylZmcHzFe/SL0s4Hmu1uAM0WN7KX8sCvA4R9u41WxJns
         5swBEuaylOo90IGL+Qx9VIyIelcbLN2Dp3LYbDeCRkXJRREv3g1CCzZ9+yeDJq03+DLH
         Oau6EIJehXXNirwZtWhV7HrrFqH6HNKOsXhPEwzMQVKBHOa/pkEqTW3EvVjWTCh/3ojQ
         1vfolVs1s+OHuSlPtK1v+Sq/7aJfwGAGHlF3P/EHZzrdWkbwPj3lhF/7YJ+V9lmV86/q
         8XOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WpFKsNvss8IvzEIn5pI/HwxxhiWgR1KW/VquaAm2mVU=;
        b=VDBWw4gf3bVuBajJ+tQI/kPPVBhK1FAxseBh2t+pRS3jDuFgwL1NlV7n4NxLeOJn/O
         8rq161KiHxhlDRFqAh45Gn0HIYzeVgH+IWmdD5VL6LSR8x+0ifGRQir52+sWirsquuFk
         YrYvYZbICucbbbyeaBOA8Pdif2qa5vm2E/+jRmTKwwoFZAru07d0uY5ZXNPwbK7Tr3Xf
         MXuhKur9k2hjwCN4PqX4Dx6f9fRmKbkxhR8tuZcU+1CezHIYrV3xiVXlA+LXsve7gpcy
         vUuTXeGPyEyAcuEtQyLZGNxqinSAyqvC8b152/VokkIvrdEP0R2iTPS1jHnDQKmzYOWQ
         ScxQ==
X-Gm-Message-State: AOAM532iRNv9OE/kie6KlPpM6zCR1q5STZTVTNyJdY1DF9kGTW8BslbK
        FZX5lB+XVMBs+2uvyePa7LMoOrsisM9pkuCm
X-Google-Smtp-Source: ABdhPJz1Pp4+2acpAIEolOPBf6RjaLmdnn97qeb1+A4gNTmbJduzAXrPFRLMx34cHV/QX+69qorpbg==
X-Received: by 2002:ac2:5c01:: with SMTP id r1mr1357630lfp.324.1603826494105;
        Tue, 27 Oct 2020 12:21:34 -0700 (PDT)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id i185sm274598lfi.230.2020.10.27.12.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:21:33 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Marek Behun <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
In-Reply-To: <20201027190444.6cuug4zm6r7z4plm@skbuf>
References: <20201027105117.23052-1-tobias@waldekranz.com> <20201027160530.11fc42db@nic.cz> <20201027152330.GF878328@lunn.ch> <87k0vbv84z.fsf@waldekranz.com> <20201027193337.50f22df0@nic.cz> <20201027190444.6cuug4zm6r7z4plm@skbuf>
Date:   Tue, 27 Oct 2020 20:21:32 +0100
Message-ID: <87h7qfv5j7.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 21:04, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Oct 27, 2020 at 07:33:37PM +0100, Marek Behun wrote:
>> > In order for this to work on transmit, we need to add forward offloading
>> > to the bridge so that we can, for example, send one FORWARD from the CPU
>> > to send an ARP broadcast to swp1..4 instead of four FROM_CPUs.
>> 
>> Wouldn't this be solved if the CPU master interface was a bonding interface?
>
> I don't see how you would do that. Would DSA keep returning -EPROBE_DEFER
> until user space decides to set up a bond over the master interfaces?
> How would you even describe that in device tree?

Yeah that would be very hard indeed. Since this is going to be
completely transparent to the user I think the best way is to just setup
the hardware to see the two CPU ports as a LAG whenever you find
e.g. "cpu0" and "cpu1", but have no representation of it as a separate
netdev.

DSA will have an rx_handler attached to both ports anyway, so it can
just run the same handler for both. On Tx it can just load-balance in
software like team does.

