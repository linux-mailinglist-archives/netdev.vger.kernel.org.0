Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4653835912E
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 03:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhDIBNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 21:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhDIBNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 21:13:51 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97ECC061760;
        Thu,  8 Apr 2021 18:13:39 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id p22so2053794wmc.3;
        Thu, 08 Apr 2021 18:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JAqTOaB6AqxWVuo3igBJfsWNViQnv2eMo64FW2jIXe4=;
        b=cIWCgLNe5Xq9k/RDHeGutB+7FTAsghngk4ZdIxKqZ6GzU4/+1sYzxpU9W4xUcr/eDp
         Z9AknBlBc/EBkOXRhRQYqTvofPFYKO9b+NrSbB4Lz0xrd6c3H/zX1a6q+ZFT/arIHcEk
         AnP31BYZTRNe6cF0S9uRN0C0wEpTWl5VUGwcK1ZrsN2wlkJztXapiigAcZRCcKzvJGxX
         lR2/zr0QYk9d8cBVgsaJt1Lnj3CyYphYdeBCliRVe+3CtBtcSYE/HMkadGSwMM30Awep
         GaMsPefZebX7u8soSrEWvtl1A52GPJlvjwTl1NQlb5RkarxJbyb2w6CFmAY5j9zwskHu
         HCcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JAqTOaB6AqxWVuo3igBJfsWNViQnv2eMo64FW2jIXe4=;
        b=j31PzGXvizFv8AmKLlgAjLp/RqJEWw43TCQuxlmBB1JmJ9aDX8ZCLLFAnRY2N+WzfL
         Cd8AMXauANql7oTNCsFjWBMy7rOi9fVnFaGv8hnASR8XkuYqRubVXf/8Ak48j4GRoC5J
         bmqYRhJDUQVbsfelYoLMiboyB+YPkBKD8LRAbJMnavgeBJTEB403lvewgjcoankbzPF9
         G3O2xGeSB4aUaDfEL5oyYbTMhmibfFkmi2AKp5yOM79xVn+y45gMsnLJmkGhTnyF7S3i
         bOxbCfkJL8jbOiIxDdUeDrHLixy+8/AHA6Shff+Smzcuen26bAzoNhvAQ7f1I3Z+CrHA
         Nurg==
X-Gm-Message-State: AOAM530zEj3evH/inEbOjZo001pkXcQmQPQA4eGiGY5lbqtq1IUWBXku
        w3GZGDDmS/N9y0tcPIEh/jhzlUJU2jTH7C4chHg=
X-Google-Smtp-Source: ABdhPJwj25Fn03NInXWGzlwJdKPNC+OGeiSZYvOgNOi9K60s8vB8Z/XjeaHJbuGrqqCr/SbcO9bS9ACIvRKdHGfUwtw=
X-Received: by 2002:a1c:20c2:: with SMTP id g185mr683648wmg.74.1617930818446;
 Thu, 08 Apr 2021 18:13:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210409003904.8957-1-TheSven73@gmail.com> <YG+ntliV37vBZ9RR@lunn.ch>
In-Reply-To: <YG+ntliV37vBZ9RR@lunn.ch>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 8 Apr 2021 21:13:27 -0400
Message-ID: <CAGngYiWDuYt6+sAd+bXfk9J67C5KAY3TN=qc3yJ=-ze-OFyy7w@mail.gmail.com>
Subject: Re: [PATCH net v1] lan743x: fix ethernet frame cutoff issue
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, Apr 8, 2021 at 9:02 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Adding a Suggested-by: would be good. And it might sometime help
> Johnathan Corbet extract some interesting statistics from the commit
> messages if everybody uses the same format.

Thank you for the suggestion. I'll definitely use that in the future.
