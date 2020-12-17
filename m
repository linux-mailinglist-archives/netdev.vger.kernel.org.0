Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E332DD82D
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgLQSVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgLQSVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 13:21:34 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1385DC061794
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 10:20:54 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id p5so26688478iln.8
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 10:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fyqNI6mtW7sphWHQsBYKA3i0rPhDeOUk745n7mdOuhk=;
        b=O544o8FKLI3qEoDpbReiLiaAtPTA5JyBCGnHq0lGvjhEkPoNyL6/Jze35Jgh6RV2uZ
         VZeFKV5n1B6Xg5OkmwMO90netkfIYnw0PSa8/s7AGE9Su2JRWETDOg7KDSSo6lr+0ddZ
         MKNe+xtamW7h/EAOWfKydP7agRKRC93acg+/V2q29m2NSpQSylxCsdTNly/Gm59xFVVC
         TM+JWQ8gxc4BSX+o+02jhjPwW2B5HXhGuww1Hb6qHaepCmlVTDs6BMdgXcBRzeSJ65Zy
         akRBD7CbK6lmCAuxopkWfn9Eu6dh9Nx4Hx9fF8rCxBRQNMmZPbF0V5n2A50A+p5pi6fe
         2J8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fyqNI6mtW7sphWHQsBYKA3i0rPhDeOUk745n7mdOuhk=;
        b=MareG2NXX9Sqywo6Pgwc23uVBhHBvzYnmmeNUQkOLJPh9KO84Vnc/oi8m5Ru1vtkFZ
         +ngzBp4tjr1pUTSnYeH7BQ3Zh+Eoi5+Jo4lN18X35WWB30vjlqNPB+GjRFZSLhhe6JWm
         t/snIEcXWlhQpuEjVJ96sWawkOs6fvbD0i0phGFc8v88FBf0I1Q9MZ1Nu2c20JxZxWC9
         UwuvvPCzE7RLhD6tmGdF0tdE0z52iM3SGHlHE0Amxu0dw2GEx9r+46Xf+n7PMcBGSNJ/
         GgXtCuDHrP/fyYr/an2EtlTs9kEBghyG2jRjM3SLXRVw5NFA3fhP6RhGStjk8FjR/o0x
         6x/A==
X-Gm-Message-State: AOAM5326LeK0+5Dtpd+ZDvKUJKcSjYFn7lHE7HRMRkp7b/g5Tdm328m5
        pxLZiAcXcXxdZ7pTuWmIkYNddEgFdu64zxedDaiVPg==
X-Google-Smtp-Source: ABdhPJwpkB+wIMB1sCE+9zcv2IxV06YWUUPzX4kVxd5U2CAUBwEPYlSsENmXG0l3UYMZ/cQigcxcQrcL//NE9RsT7Hc=
X-Received: by 2002:a92:da82:: with SMTP id u2mr98610iln.137.1608229253255;
 Thu, 17 Dec 2020 10:20:53 -0800 (PST)
MIME-Version: 1.0
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
 <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com> <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
 <adbee2ec-c6ba-7a17-eb98-1c53365fa911@candelatech.com> <CANn89iJQnSVZFp2XDgREN1QMtU4exOsnJq=5VzJ6tqTCJ7MH-g@mail.gmail.com>
 <c4bcee7d-b2eb-759c-c659-d65f3e7daec9@candelatech.com>
In-Reply-To: <c4bcee7d-b2eb-759c-c659-d65f3e7daec9@candelatech.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Dec 2020 19:20:42 +0100
Message-ID: <CANn89i++Kgkj57ms70a5GDOQ-Cpewx3NQkzP3EmZmLYQ4eHzww@mail.gmail.com>
Subject: Re: net: tso: add UDP segmentation support: adds regression for ax200 upload
To:     Ben Greear <greearb@candelatech.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 7:13 PM Ben Greear <greearb@candelatech.com> wrote:
>

>
> It is the iwlwifi/mvm logic that supports ax200.

Let me ask again :

I see two different potential call points :

drivers/net/wireless/intel/iwlwifi/pcie/tx.c:1529:
tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);
drivers/net/wireless/intel/iwlwifi/queue/tx.c:427:
tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);

To the best of your knowledge, which one would be used in your case ?

Both are horribly complex, I do not want to spend time studying two
implementations.

Thanks.
