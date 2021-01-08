Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCE12EFB01
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 23:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbhAHWR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 17:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbhAHWR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 17:17:59 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C875EC061793
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 14:17:18 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id w18so11332141iot.0
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 14:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WIrGGKmiGNuKDM4AjDP7KeJRUu2jZtmevjUfYGr14xg=;
        b=TGyei0wQiniwDqvZJvOodCTBPep5woAYuvuAP4kudYGIAtTmA4RRb+fDdITLYhQfJR
         xBfXyyK4EYTBzaHMyfdDDu03ZiaeBEL17l8rW4sL3UQKhSZ6PQnyQH3rTQWTTdoFhObE
         mmLv9s1juzzatunhDwlVIgG8ldmeM+OKspINFP1VsYpDRhSOhegNPEKOiRiMF0/u91uu
         SSz5UZqbWaYwIA3cE1SlWGKUOM3+svAvtmjzsTOgca7CDui/yEVHI+493KEoSxSEHYkJ
         a37xQUbyDuJ8OdMPsRyh0q256aRAWnmJA7ktvhG+V6leFZgAsKGr+kSZncoh1T0UU5Jj
         D+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WIrGGKmiGNuKDM4AjDP7KeJRUu2jZtmevjUfYGr14xg=;
        b=LGMjJXIOs1LpDVoZRCfSgfX+6tZbY9Wzk1F1E0y89BpQns86lxkWXn/yi/7hQasheG
         p4EQUhPkHi+Xt3PpKO/tdMRiLFjHDUHWnp1ue4jdZKkVzD5xu6yRNi8blXlfVWFEr86v
         4c7I2Fc7Dn+x2AUK8mUc/IL3nE8NJvtT+2JCwb+3Kp4AOPKV9EWSvPUioLMh+VxmNjcF
         6QXAaKsPXzyfkgkrwo3VOJrgUtuVg2Mjzps4fOlhROtg0xhf2IwRyTrBVMT6CeogUadv
         muNK3Bo3edhXzbKrIx98PCUr8yLd26JYv6jKkz/6Kas0usmYAM05lmX+KYXxVNo5e9gO
         YvHQ==
X-Gm-Message-State: AOAM530Lkrpy28ja7CbQZXQJy1t58V7388S/1PtB3GFSqHTGtBU2OyjA
        IXjzHhdla8QANHyKfYY2ZeeMU66ixtVvw4ylnccNViblq20pDQ==
X-Google-Smtp-Source: ABdhPJxYaRzVp6EfsCXEUKU8aZoQ6BNLRIe3Rv0tWK6bu+P3FWwRxsiaLK5NUQoZ6ZgbTWPBP+XT0gpXGCUEafoUqP4=
X-Received: by 2002:a6b:918a:: with SMTP id t132mr7190721iod.157.1610144237899;
 Fri, 08 Jan 2021 14:17:17 -0800 (PST)
MIME-Version: 1.0
References: <20210106215539.2103688-1-jesse.brandeburg@intel.com>
 <20210106215539.2103688-2-jesse.brandeburg@intel.com> <1e4ee1cf-c2b7-8ba3-7cb1-5c5cb3ff1e84@pensando.io>
 <20210108102630.00004202@intel.com> <c11bb25a-f73d-3ae9-b1fd-7eb96bc79cc7@pensando.io>
 <0e06ff3234b78b5bde6bf77d192a42c3f8ab5319.camel@kernel.org>
In-Reply-To: <0e06ff3234b78b5bde6bf77d192a42c3f8ab5319.camel@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Jan 2021 23:17:06 +0100
Message-ID: <CANn89iK_yMC2LbA0N+=U3JACAGhciuLpQ_uCa3qZ1_fUbWCyUQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/2] net: core: count drops from GRO
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Shannon Nelson <snelson@pensando.io>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev <netdev@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org,
        Jamal Hadi Salim <jhs@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 9:27 PM Saeed Mahameed <saeed@kernel.org> wrote:
>

> I think there is still some merit in this patchset even with Eric's
> removal of GRO_DROP from gro_receive(). As Eric explained, it is still
> possible to silently drop for the same reason when drivers
> call napi_get_frags or even alloc_skb() apis, many drivers do not
> account for such packet drops, and maybe it is the right thing to do to
> inline the packet drop accounting into the skb alloc APIs ? the
> question is, is it the job of those APIs to update netdev->stats ?
>

You absolutely do not want to have a generic increment of
netdev->stats for multiqueue drivers.
This would add terrible cache line false sharing under DDOS and memory stress.

Each driver maintains (or should maintain) per rx queue counter for this case.

It seems  mlx4 does nothing special, I would suggest you fix it :)
