Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B403AECF7
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 18:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhFUQDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 12:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhFUQDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 12:03:52 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A461C061574;
        Mon, 21 Jun 2021 09:01:37 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gn32so2253291ejc.2;
        Mon, 21 Jun 2021 09:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AXQsb95tfVUSJnmAPnbsPilhrI1OfYFXkT1W9z6mr7o=;
        b=Ogi7N9hJCRnrT8TRKwfl1lh2nTMVyHSoiGurY31vDj8mVzpGbb2OC+oRAFVW68PQXV
         viEFM8+94BUP8Sqwy/sJEfR3V+1QNrRCfL60u4xDIqqX/cAxTQOkPiwBv/vb5ySrgPn0
         Wf+s+iqEnnwzuN3kospLANtQSAg31nu5dtHqsyMnxbg8zlCGYdawtbGxmkbBD1nIZGX4
         EjZLtWxwVb1teqbtof3fiGEX7hV9AbxYRQXhug4p+hba4ovxD/COhMKMyKE8uICmQxgL
         e3KtnYbb6Y8m9uwvioiJUlr7TIFCyXsBctq9z8Qri0sYtT6kH2eTZpJ/5Vi3xAHqomJU
         wLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AXQsb95tfVUSJnmAPnbsPilhrI1OfYFXkT1W9z6mr7o=;
        b=ZJWWwTPXOmYP0q1knpJ/a4wILlJu8dL1ymn60ALIqHCP9E+GST1ATOq1ZHga0lWfvV
         ZFp63P3Z4vcVP9lSkxE08w51TObIXRk/D5a9EatIDw+fg71K25JnKbxAzLUWy4T446al
         3sBTlGnWF5f4PU8ySKADVTQQhTG0iF5rl14R82aPA1gnkFPRAnJschaxQ3Mc6b1D1E7u
         ZqQmd+b+mvo27wjxVdHGVqkQkCcyQ4GPxdr5swTjUf8v2gTAhGGVI4trVoZDV9bcYE6J
         AxddeglcBc5ZpkDlI539ivhC6LLqCUnFNJebpeVAyalOlwVgoz9Jj9SCwQF125jqf7Vi
         LUaQ==
X-Gm-Message-State: AOAM531zFcef8yQAEq24YImP8HbTDqUOKKeqSpgLXN5f2v2y6NFE6sBS
        Pk1Y10NUlfQHEbHgsGHwsi7wShV4GP5zuIzIPRY=
X-Google-Smtp-Source: ABdhPJy18zZNIVjH6ZjLWzNGjMJcMykbyodCXgXOUYv232TCI+i3sbMsYrw5Y6gqSL9mQ91Ecye65xasjxJrmFy5ahM=
X-Received: by 2002:a17:907:1b1b:: with SMTP id mp27mr24852933ejc.538.1624291295912;
 Mon, 21 Jun 2021 09:01:35 -0700 (PDT)
MIME-Version: 1.0
References: <60cb0586.1c69fb81.8015b.37a1@mx.google.com> <YNCwJqtKKCskB2Au@kroah.com>
In-Reply-To: <YNCwJqtKKCskB2Au@kroah.com>
From:   Amit Klein <aksecurity@gmail.com>
Date:   Mon, 21 Jun 2021 19:01:25 +0300
Message-ID: <CANEQ_++RU=yBCXHBajRJcJNLZ73hqgMJ4yEmjw5gwZZHnbyzTQ@mail.gmail.com>
Subject: Re: [PATCH 4.19] inet: use bigger hash table for IP ID generation
 (backported to 4.19)
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 6:28 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 17, 2021 at 01:19:18AM -0700, Amit Klein wrote:
> > Subject: inet: use bigger hash table for IP ID generation (backported to 4.19)
> > From: Amit Klein <aksecurity@gmail.com>
[...]
>
> I had to dig up what the upstream git commit id was for this, please
> specify it next time :(
>

Sure. Awfully sorry about the omission.

> I've queued this, and the 4.14 version up.

Thanks.

 Can you create a 4.4.y and
> 4.9.y version as well?
>

Absolutely. I plan to do so later this week.

-Amit
