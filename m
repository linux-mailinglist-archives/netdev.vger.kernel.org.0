Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2258A33CA77
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 01:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbhCPAqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 20:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhCPAqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 20:46:03 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E676AC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 17:46:02 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x21so6367905pfa.3
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 17:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IR6Pq1h53na4wxGwjToRQy9zNA/w1TVn72BP4z6Q2+c=;
        b=BsL4oqT3doTn8jiZzNbuYM58V4NJAV60EjQuM9ZZJ0OiGEVRqkN9zjFGry6sZhdHij
         ZkhaxHbRCvjv/d+/RBxBaIcQs8r7FUTyhRdrgQvsEjJfhNXwB3qkNwa4dR98Fz0LxS1B
         pqqBq9/lINO3MrQgit285WgF3HMVgF/JnXJX2nre22TCN9A6g7wU62lAgAHxR1M7wKPn
         E5yMTTB5C9ut8uyTH+3agibYTEfw76HwGyIVw/gBZnfmw6iK1Tv2g+YvwfBlqltYIqCl
         MFUp+pxjBpjIZSx/lJjloDDhYtLCkk+DY9cPl9en09VNwTJvuv3P91sF88fhKHQxww2Z
         kZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IR6Pq1h53na4wxGwjToRQy9zNA/w1TVn72BP4z6Q2+c=;
        b=o9WIiJxS320k4dUQmV2AKlRv8KTuC61LomeJ/H11nvhnZotSUOgmkAEMvMV8PbgjbP
         Zw7Apg1cUMit/bHomcOQnvEKTvNnt3BMFr/5l9I134CL7XNpTVyWhsVaA9aI3AhgYUDN
         g9HmC9YT8MkkYciUrUq082K4yi1TyOyd3bzXsj1o6/JiWKgHMHq9jE3xRfNi73+Jpbb8
         mJuQmmK107MPD4ocqRNiu9RaKp9qf8PqdRb+TZ/KhLBhU42smXKi/snB5Ka3c1k7pklF
         MVbuo5iJnEvgH/hy7T8KNKBdP5sQse3oEV6QVXGf4bG8nFuJObWDrkE7lGaI7deEL134
         Z4oQ==
X-Gm-Message-State: AOAM533z5y9VzPiuSnLSNb5JdmHnMUQducNg6YRgjm8fX0DyDN82Pags
        jeaMXu04M0Uf0+PO60HzzSLvBj/1WXIfzPS00P2M6qXCW7QfSQ==
X-Google-Smtp-Source: ABdhPJxCfEbJ+ezjwcX4S+Zs01jw7XGBMz40/hp4rIBeSxRWfeOG9UqMnzWYDMOC82MKNAxNI09D0VeN+RTIe3gyX9I=
X-Received: by 2002:aa7:8f30:0:b029:20a:20d8:901a with SMTP id
 y16-20020aa78f300000b029020a20d8901amr3273054pfr.7.1615855562344; Mon, 15 Mar
 2021 17:46:02 -0700 (PDT)
MIME-Version: 1.0
References: <CADbyt64e2cmQzZTEg3VoY6py=1pAqkLDRw+mniRdr9Rua5XtgQ@mail.gmail.com>
 <5b2595ed-bf5b-2775-405c-bb5031fd2095@gmail.com> <CADbyt66Ujtn5D+asPndkgBEDBWJiMScqicGVoNBVpNyR3iQ6PQ@mail.gmail.com>
 <CADbyt64HpzGf6A_=wrouL+vT73DBndww34gMPSH9jDOiGEysvQ@mail.gmail.com>
 <5f673241-9cb1-eb36-be9a-a82b0174bd9c@gmail.com> <CADbyt6542624xAVzWXM6KEfk=zAOmB_SHbN=nzC_oib_+eXB1Q@mail.gmail.com>
 <642fb4d6-4188-968f-6d43-249ca8e38d7a@gmail.com>
In-Reply-To: <642fb4d6-4188-968f-6d43-249ca8e38d7a@gmail.com>
From:   Greesha Mikhalkin <grigoriymikhalkin@gmail.com>
Date:   Tue, 16 Mar 2021 01:45:51 +0100
Message-ID: <CADbyt67VwPDLp2rU66VjaYPUq_U3ry3dtiz1JphoKWaAgP2SDw@mail.gmail.com>
Subject: Re: VRF leaking doesn't work
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> VRF is implemented via policy routing. did you re-order the FIB rules?

Reordered. Output of `ip rule`:
    1000: from all lookup [l3mdev-table]
    32765: from all lookup local
    32766: from all lookup main
    32767: from all lookup default

Unfortunately, that didn't help.
