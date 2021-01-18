Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B4D2FA8E5
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407626AbhARSb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407507AbhARSbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 13:31:36 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2711C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 10:30:51 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id e7so19250699ljg.10
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 10:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=mmsMILezmlbSTYILmQmY1IKLr/aQQGzOs51BQrHsmMA=;
        b=Pwlr2zSk4C6dfAWA82DqO4SUi++ZVTQozHwJQ+KXIN093qpNsfMLuEF78mfYBatcCH
         7n+fCK0xwcZQQId/kz0RogRDfK0JCOQnhefZk9PJfqz4sbDs13oarmQw2GpHsDZ90hjO
         WOEp8TTFHloFBsm0YMvmGI5sP0XA3dbUzX2QS6cJ6bKC5RkxXxqKOcrO0JodJlmQyZkf
         LXBQ5DbMHkZdf65SgDfSY8wvGEnWkTq5ER/e469OmoIUFZLOJYF9tjJeEItLg1/3Agaj
         r7KsvnoIWyOEqpXXYQSEnjkL5M4uN5BCDmcQei84uSZWzTxJ8uPn1l20eHUjebZYfQEj
         +dKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mmsMILezmlbSTYILmQmY1IKLr/aQQGzOs51BQrHsmMA=;
        b=YB3L61x5TQKM33gTcegj/k4FAYmb5GfuMw6aD9HwQoEr1IVh1F5YcDT0fZAsKU72F+
         cA0Te/+ZcVmWIkgiXonT3AvwkKl7fSYG6ujZAIj7JVnki1jMNzlx4yBE8TBf6Rtz5A5k
         dDuTdM8SloIKGn94KGkDjijKlDdVCy1uRLPT2xQEo9J7kb7qx2eET33U7G+YopRg1WsS
         w+amvZaI1asg6ckXMNyAQ84EUFCtjC06UGwEAtR2WazYLcsVi6Q/m31RmZRyqSt6DAH5
         /7UscwM7rk7VQR4/5g/UcV2C0MflX5uaomaOehMMF2pKOnHaZjuMG0ddsEk6XZb/hKSi
         bQ7g==
X-Gm-Message-State: AOAM531edYTD7DewpHdKIa/3kv6H7dC/755ve1d/kwYkaMnV1Hw64Z42
        8WtxNljA4h5lfSyxjWSo/Y4jCA==
X-Google-Smtp-Source: ABdhPJykHOvvO8cQ/iaSNtQRup9vN+nNGPXvAyXo889Av9GlYgGlZixQPZ7WERw8cZz0EDxIwbKnYA==
X-Received: by 2002:a2e:3517:: with SMTP id z23mr348140ljz.447.1610994650256;
        Mon, 18 Jan 2021 10:30:50 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w24sm1979302lfl.199.2021.01.18.10.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 10:30:49 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Network Development <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: commit 4c7ea3c0791e (net: dsa: mv88e6xxx: disable SA learning for DSA and CPU ports)
In-Reply-To: <YAXKdWL9CdplNrtm@lunn.ch>
References: <6106e3d5-31fc-388e-d4ac-c84ac0746a72@prevas.dk> <87h7nhlksr.fsf@waldekranz.com> <af05538b-7b64-e115-6960-0df8e503dde3@prevas.dk> <YAXKdWL9CdplNrtm@lunn.ch>
Date:   Mon, 18 Jan 2021 19:30:49 +0100
Message-ID: <87v9bujdwm.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 18:50, Andrew Lunn <andrew@lunn.ch> wrote:
>> I suppose the real solution is having userspace do some "bridge mdb add"
>> yoga, but since no code currently uses
>> MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_DA_MGMT, I don't think there's any
>> way to actually achieve this. And I have no idea how to represent the
>> requirement that "frames with this multicast DA are only to be directed
>> at the CPU" in a hardware-agnostic way.
>
> The switchdev interface for this exists, because there can be
> multicast listeners on the bridge. When they join a group, they ask
> the switch to put in a HOST MDB, which should cause the traffic for

That is not quite the same thing as "management" though. Adding the
group to the host MDB will not allow it to pass through blocked (in the
STP sense) ports for example. With a management entry, the switch will
trap the packet with a TO_CPU tag, which means no ingress policy can get
in the way of it reaching the CPU.

> the group to be sent to the host. What you don't have is the
> exclusivity. If there is an IGMP report for the DA received on another
> port, IGMP snooping will add an MDB entry to forward traffic out that
> port.

Exclusivity should not be an issue as these protocols use groups outside
of the ranges allocated for IGMP/MLD.

I see a few ways forward:

1. Extending the MRP-support in the bridge to support other protocols
   (e.g. ERP). If DSA gets a callback saying that a ring has been setup
   with a certain role, we know which groups to add. Good for defined
   protocols - does not help anyone who needs to be able to configure
   custom groups.

2. Adding yet another flag to MDB entries to mark them as "trap"
   entries. I do not see thing going anywhere since the big fish have
   already solved this with...

3. ... TC, through the "trap" action. We could detect filters which only
   match on DA, with the action "trap"; and convert those to MGMT
   entries in the ATU. I think this could be the way forward for user
   defined entries.

4. Devlink trap configuration. Maybe? I have not managed to wrap my head
   around this yet.
