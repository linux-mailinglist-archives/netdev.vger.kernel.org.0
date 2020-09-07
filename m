Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE7125F3E6
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 09:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgIGHZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 03:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgIGHZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 03:25:29 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF86DC061573;
        Mon,  7 Sep 2020 00:25:28 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id m25so3070163oou.0;
        Mon, 07 Sep 2020 00:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0sX5bNM/24WCOxdYSOyqch71tSRBdpno9T3ncrkQ/ko=;
        b=Z42ZVKOOLfOE8Va3wz/e4gboJ88nf9y4NGykHEz45qW/LLDgjzeMKRT9OFQF9/BQGK
         TCw260rtUq/Q2TPxQ9fth/0+FI4+SjhMIr2Lbmxl5eNhMoFVTrVq07Zu7uQ4iz1mzu5c
         O+SMCRZJmcuEYi5sPz+ey2Xu4Pqc37p1gPNANqq6h7ayA8eS0Hx7gO+Q+Bxk0VApfTaX
         0ox1G41cAODEqSTE61cxwjS46t43JizZhczo5BgrPbPXivAgCyLlZTSnTebfP/Gk2os6
         wDc4c/nJAhVAhVdyRVJf7HsfAKW0u2Y8vYbuKr7zhkZ7zEOj2E+u7qEyKNf2Xraagpgi
         nn+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0sX5bNM/24WCOxdYSOyqch71tSRBdpno9T3ncrkQ/ko=;
        b=Vqv6uRt2jvGFx9s7pIvyn+G8fRLQ7MZLfvAuUgX1S6TJCEKeEMW9BjRIgYS9Ix7ekv
         r4LZ51AM47PHUCOBvqPiwmVkZiKVVa12uNcgVDB3oCKaAImTkKwpw0l494R4s2ML1tK6
         cUNkzMnSF8MbUT9J6kp8JHvqpEcg/4xCQT+X4Dftzpadkgur9Pu6Q95pQilLQNiAbk3O
         isquKM7tbhZ1BYG1rpey0ZI1BFVZQV7lqO/GC8i0XXv9OTj2K5x6hKmIU3Qj8zxLX6ET
         t5WcSsZQUnxZUy6Siac5YvL4JI4hajr0+7Hgv8y3vruA4WMlDeW8aKKiuePk7vmuoH37
         aGIg==
X-Gm-Message-State: AOAM530fSRk0A0Ltx6zpEiJhLWGXWEc1wc0TsZf8YW530ZR53Dl/1Zsy
        ULDjkv68eKYDqCa46DTBW6oqQ7Gx0EJI/l6qcV8=
X-Google-Smtp-Source: ABdhPJy85C5az9Gk1RUoPQIwF9SEuU4wysu+Y3VQVJf7gLMKz3wpudOQxDMONDgc+iJ6YDGeOQse2cX1kla8KwKpWzI=
X-Received: by 2002:a4a:3516:: with SMTP id l22mr14053251ooa.6.1599463527878;
 Mon, 07 Sep 2020 00:25:27 -0700 (PDT)
MIME-Version: 1.0
References: <CA+4pmEueEiz0Act8X6t4y3+4LOaOh_-ZfzScH0CbOKT99x91NA@mail.gmail.com>
 <87wo7una02.fsf@miraculix.mork.no> <CAGRyCJE-VYRthco5=rZ_PX0hkzhXmQ45yGJe_Gm1UvYJBKYQvQ@mail.gmail.com>
In-Reply-To: <CAGRyCJE-VYRthco5=rZ_PX0hkzhXmQ45yGJe_Gm1UvYJBKYQvQ@mail.gmail.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Mon, 7 Sep 2020 09:25:16 +0200
Message-ID: <CAKfDRXg2xRbLu=ZcQYdJUuYbfMQbav9pUDwcVMc-S+hwV3Johw@mail.gmail.com>
Subject: Re: [PATCH] net: usb: qmi_wwan: Fix for packets being rejected in the
 ring buffer used by the xHCI controller.
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Paul Gildea <paul.gildea@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I was able to trigger the same issue as reported by Paul, and came
across this patch (+ Daniele's other patch and thread on the libqmi
mailing list). Applying Paul's fix solved the problem for me, changing
the MTU of the QMI interface now works fine. Thanks a lot to everyone
involved!

I just have one question, is there a specific reason for the patch not
being resubmitted or Daniele's work not resumed? I do not use any of
the aggregation-stuff, so I don't know how that is affected by for
example Paul's change. If there is anything I can do to help, please
let me know.

BR,
Kristian
