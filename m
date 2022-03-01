Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DC84C97AC
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 22:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238518AbiCAVVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 16:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236559AbiCAVVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 16:21:16 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C259D377C8
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 13:20:34 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id t13so17050059lfd.9
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 13:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=xWWyZGW03ybyYdOpl65GgcmPLqi0GLI/po6R5RGyI04=;
        b=5R8NituuRk1fNDuBW/0VnIPErFhdun3HJhCiiXg+Xnt1URDomDa1vqyvkC4Secb5JY
         t6R7VpyuJgVAKt74QI1lG+IHOkcH+qfN2v19uhJzExj1Mh0iuGDfk9wHKhzb0vdAgG9J
         kYyK5LuXHfOD9g0bH+l4iBg6piA9+8JnQ5ewG6rs/S6TuVj6ubfx/Q5AACXAGSGTzb8M
         +OZ6M/OEQEAcbU7arOlnIJl8RMMO0TafUPm2EojaqXyDA7BDxEKk6+PqrTfbmjuIuD20
         8DEuzueI0EjUxmkPCMcw3aep9hKfmaEHhdL+RRwUIa0b+G41CPvLpsG7/YvnRhoReNf6
         WbRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xWWyZGW03ybyYdOpl65GgcmPLqi0GLI/po6R5RGyI04=;
        b=QIV3pcO8Q7vX46CuSshPKyYaOik8/YdrHGrrtrLijZTWBVnKDbp1tmaScaMb3IBDJ0
         fPKf1IJSRnIZsWyIJKv8GFMSKD/3MM0EZuLtItlLeFH8q7HQ0m1wm/CpMZ4stXp/gkjz
         YRpKy3VCf+IJaUaUXqxK8KtiKS7ebJxP9b/TnFulOplZK4mi3L0dY6mhAHTDLBwTYbVO
         izZEqjJARZW14c4IrVsA7TMcqK1cc+u1cpglO+PqaSULLZEe17DNX1f3NsqzDXcCnBxz
         WU4VMyFtRMZtXkmIJxNAcq+/xY3TqFYaOOIk4pflVx3hzMvPAQ2/HN/Rpx22kYOpIagD
         /Gtg==
X-Gm-Message-State: AOAM5331hR9R4NFszV0fQuf1dV9/Dt41N6v69+7VZoTbJJK6Zk0u0RnS
        CiB9iWCKKhOQn8Xr4ZAvC9o0DQ==
X-Google-Smtp-Source: ABdhPJyMu3GSfK5F/3LPZfqkZQ4z4M40zsIk/PNNWsnVXhMJKij8GdgvcM+kwWU2Q7fk30/SFjm5bg==
X-Received: by 2002:a05:6512:287:b0:443:7f1d:e8ed with SMTP id j7-20020a056512028700b004437f1de8edmr16542871lfp.321.1646169631444;
        Tue, 01 Mar 2022 13:20:31 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id g37-20020a0565123ba500b00443685d5ecfsm1673158lfv.151.2022.03.01.13.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 13:20:31 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, navolnenoze@simerda.eu
Subject: Re: [PATCH v2 net-next 00/10] net: bridge: Multiple Spanning Trees
In-Reply-To: <20220301162142.2rv23g4cyd2yacbs@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301162142.2rv23g4cyd2yacbs@skbuf>
Date:   Tue, 01 Mar 2022 22:20:30 +0100
Message-ID: <87fso1nzdt.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 18:21, Vladimir Oltean <olteanv@gmail.com> wrote:
> Hi Tobias,
>
> On Tue, Mar 01, 2022 at 11:03:11AM +0100, Tobias Waldekranz wrote:
>> A proposal for the corresponding iproute2 interface is available here:
>> 
>> https://github.com/wkz/iproute2/tree/mst
>
> Please pardon my ignorance. Is there a user-mode STP protocol application
> that supports MSTP, and that you've tested these patches with?
> I'd like to give it a try.

I see that Stephen has already pointed you to mstpd in a sibling
message.

It is important to note though, that AFAIK mstpd does not actually
support MSTP on a vanilla Linux system. The protocol implementation is
in place, and they have a plugin architecture that makes it easy for people
to hook it up to various userspace SDKs and whatnot, but you can't use
it with a regular bridge.

A colleague of mine has been successfully running a modified version of
mstpd which was tailored for v1 of this series (RFC). But I do not
believe he has had the time to rework it for v2. That should mostly be a
matter of removing code though, as v2 allows you to manage the MSTIs
directly, rather than having to translate it to an associated VLAN.
