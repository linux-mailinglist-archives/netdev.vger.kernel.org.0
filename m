Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8522FA9CF
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393877AbhARTMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436989AbhARTLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 14:11:39 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D459FC061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 11:10:57 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id 23so25559188lfg.10
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 11:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=jh0PZw/KI4zYbfJBV9/AeMR8ymfHrCpiKCmUx+9qono=;
        b=wMqrteHK4BekSl2ihM/mJ8POm7DOkAVbSo+noJpnuiA2WN30ws7HfCcW1GsPNNhR9f
         c/kz9wj2biJJjCfvgSUD43e6qtOk5+jp0o/IVon5maQ0HjFkmOtB+APJEM1Lelh4ONfx
         omVE+UdFnJoWJwcztT7PpGBIfW2bIVX7l3Hnrk/Ws0ZNAynErz39KskRF/jHHQGx6tJN
         y58GUkfJc5NGc86KTVD0Dh9m8kxpzLgcfj6HFNuXSy9swQtYzaDrARKDAUBpsKL5rrG3
         HzE7tSDZjjw3s55XzQlmNVIWv60Wyshc+kVFIHOvuPqPXV38r9JONxQy5GJLwDjLumup
         q+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=jh0PZw/KI4zYbfJBV9/AeMR8ymfHrCpiKCmUx+9qono=;
        b=LpkgVU1JZhNQYYsUZtWhWC1SEF03nJWdVt5vVYazWsL1Jd8UlDct8yR4GnKRSWS1qf
         pt/bLExUapnAVkfFutAGhOtD8aFHKal0IkSCo82ZRdFtqPDNm7sHqYf/gTRyCD6B5vOT
         ozSMHGnmVLBazd/oiVLsUxdSl1e7oIvNt2dT1V22tJoG1GEhodeG6cSfOyW+VzWOSg6R
         wkKd8MlRUXWOMKVi00RSl+zSZO5v9EB7fyZy9irps6uvMYJYnIsAWhaG43vyaer2v1F2
         DAI0DMGcMs39bSJ0jq2a0leNHuo0ICM0AZUy0ZpVvF8kndWkZF990Nef51O9eP5HSkom
         Xneg==
X-Gm-Message-State: AOAM531CnirVxPVG437PrTKPTJnQm/Q6R06iJqlav5uTdZzj9b9/ZuNP
        oNs9dxcagalJder8KC5Q8FbJBQ==
X-Google-Smtp-Source: ABdhPJyCwCO53RxqGuGz+H5xQY6cljpNnFDKQfSnenMuLXZC1Zc/tiXTxf+CI1sa8ydlPNnBMHbaHw==
X-Received: by 2002:ac2:43b9:: with SMTP id t25mr233025lfl.261.1610997056343;
        Mon, 18 Jan 2021 11:10:56 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id i29sm1987723lfc.193.2021.01.18.11.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 11:10:55 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Network Development <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: commit 4c7ea3c0791e (net: dsa: mv88e6xxx: disable SA learning for DSA and CPU ports)
In-Reply-To: <YAXa+FkP3DHR9nlK@lunn.ch>
References: <6106e3d5-31fc-388e-d4ac-c84ac0746a72@prevas.dk> <87h7nhlksr.fsf@waldekranz.com> <af05538b-7b64-e115-6960-0df8e503dde3@prevas.dk> <YAXKdWL9CdplNrtm@lunn.ch> <87v9bujdwm.fsf@waldekranz.com> <YAXa+FkP3DHR9nlK@lunn.ch>
Date:   Mon, 18 Jan 2021 20:10:55 +0100
Message-ID: <87r1mijc1s.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 20:01, Andrew Lunn <andrew@lunn.ch> wrote:
> On Mon, Jan 18, 2021 at 07:30:49PM +0100, Tobias Waldekranz wrote:
>> On Mon, Jan 18, 2021 at 18:50, Andrew Lunn <andrew@lunn.ch> wrote:
>> >> I suppose the real solution is having userspace do some "bridge mdb add"
>> >> yoga, but since no code currently uses
>> >> MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_DA_MGMT, I don't think there's any
>> >> way to actually achieve this. And I have no idea how to represent the
>> >> requirement that "frames with this multicast DA are only to be directed
>> >> at the CPU" in a hardware-agnostic way.
>> >
>> > The switchdev interface for this exists, because there can be
>> > multicast listeners on the bridge. When they join a group, they ask
>> > the switch to put in a HOST MDB, which should cause the traffic for
>> 
>> That is not quite the same thing as "management" though. Adding the
>> group to the host MDB will not allow it to pass through blocked (in the
>> STP sense) ports for example. With a management entry, the switch will
>> trap the packet with a TO_CPU tag, which means no ingress policy can get
>> in the way of it reaching the CPU.
>
> Ah, yes. I don't suppose the DA is part of the special group which the
> switch will recognise as management and pass it on?
>
> 01:80:c2:00:00:00 - 01:80:c2:00:00:07
> 01:80:c2:00:00:08 - 01:80:c2:00:00:0f
> 01:80:c2:00:00:20 - 01:80:c2:00:00:27
> 01:80:c2:00:00:28 - 01:80:c2:00:00:2f

Unfortunately there are many protocols that live outside of the IEEE
range. ERP(S) which Rasmus was talking about uses a range assigned to
ITU IIRC. MRP a third one I believe.

The Reserved2CPU functionality has an additional deficiency vs. separate
management entries: they all use the same priority. This means that you
must assign LLDP frames to the same queue as STP for example, which is
typically not what you want. With a management entry (with priority
override) you can set them individually.
