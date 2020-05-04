Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E99A1C481C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 22:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgEDUY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 16:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbgEDUY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 16:24:57 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F68EC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 13:24:57 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id k6so13806606iob.3
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 13:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YNH8StUB+9nzm9PNJ2b7bLgIcJdLAZhLuPc4nwfjY5E=;
        b=Q4uDOhbgjTAMIQ7j4kexvqX/S59Shj4dn3FIajfi+hptU9B+GJsMxRbrDuM6jOAVCw
         qd75H+5ctG9RtK93VuZHC0tNbuohengwul2rST1FMRVT+E34NVDGSd7VHyzUb6Xd2ux6
         m3np6ZPPvm9K7OWLkoEHRPaffsDdQzLVLYrQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YNH8StUB+9nzm9PNJ2b7bLgIcJdLAZhLuPc4nwfjY5E=;
        b=HCVBmVNLO6ufSjPCYJk0Bg8ve4itPsUfvi24mStTltLoLvE+Sd+3wLk5AY/eh3HIvm
         JPiMIzjZ9XpVgIt55AJjFXb2yS9gfbimodd2lUzhywzFnb9Y0Kly8s6r0R78hqpQg/bd
         A8ftT+5nwrxiJMxpQ0s1mOwgKOJpEvDrUkb1bazfr5Q/HSdXy596T0uABxYmWaWZTrTV
         MDddf+Zj6D+ox9KagZgIspmiyrBjvc8LpXJxrCvuTZVoWuXAovBRGsc72UNoVSlB8qC3
         /P1Sxh8G2LD2KxpLDTknT6d6LOAGIhEzCbYkDrXS11BuvDUvip3aS5A0m0tElNDHq3NQ
         E3Cw==
X-Gm-Message-State: AGi0PuZ0z6dpp0f/1ZtpDkqUjU9cymXoqoEQgjZFKii9GKI3hjNhH9lH
        ayV0Tue7vK6LVXCyBLGMYYefbh3y3VTYQH5VQXmyFg==
X-Google-Smtp-Source: APiQypI10XYjvaXsQbF9mf+y8pjjSl/JCnUxGAZOD3H9d8wFvAb7sKBjmpvFcOGHhICjduZQuKFsWObzaCvQgojH1aA=
X-Received: by 2002:a05:6638:f92:: with SMTP id h18mr177211jal.115.1588623896621;
 Mon, 04 May 2020 13:24:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAHrpVsUFBTEj9VB_aURRB+=w68nybiKxkEX+kO2pe+O9GGyzBg@mail.gmail.com>
 <87b7e9f5-39d3-5523-83da-71361cf193f5@gmail.com>
In-Reply-To: <87b7e9f5-39d3-5523-83da-71361cf193f5@gmail.com>
From:   Jonathan Richardson <jonathan.richardson@broadcom.com>
Date:   Mon, 4 May 2020 13:24:45 -0700
Message-ID: <CAHrpVsXhNtg7Lt75OZ2+BLkqktO8UnNhxmekij=-Lp35aQkaWw@mail.gmail.com>
Subject: Re: bgmac-enet driver broken in 5.7
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     zhengdejin5@gmail.com, davem@davemloft.net,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 1:20 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/4/2020 12:32 PM, Jonathan Richardson wrote:
> > Hi,
> >
> > Commit d7a5502b0bb8b (net: broadcom: convert to
> > devm_platform_ioremap_resource_byname()) broke the bgmac-enet driver.
> > probe fails with -22. idm_base and nicpm_base were optional. Now they
> > are mandatory. Our upstream dtb doesn't have them defined. I'm not
> > clear on why this change was made. Can it be reverted?
>
> You don't get a change reverted by just asking for it, you have to
> submit a revert to get that done can you do that?
> --
> Florian

If the author is fine with reverting it yes I will submit the change.
