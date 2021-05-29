Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840A9394D2B
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 18:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhE2Qtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 12:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhE2Qtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 12:49:42 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26B7C061574
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 09:48:04 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id s5-20020a7bc0c50000b0290147d0c21c51so4036551wmh.4
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 09:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IKQyKPe65GI52BeV5z6gmTHSIerDdWeQJKoPXAaiexk=;
        b=ZYvZYI1m+7cjJy4Hk0WCrJFK3eBGSmuP0L0y9MgnGepbbkSeugrSuDvd031pf6yDer
         zBvMecLPDUqPndQTgbNH7C4JbbmMWTDDSXDE6p7ovKLGlyltm0o5n58GOV/u4t1TjVFz
         avvBfbplVvct7agznJeUpT8DXwTXCBSO4pDMtMfz1dEyy35aVpwE98Je1WLsnK68Q4JJ
         WbKQ6nkgFDRDgHhAYWLWx/kgJV2LSaRZxza6nkns6JZGuqY15eWN8fYQSvMZuHZ+iEpv
         wwq40Ub4ND2BHbiKFHykVipnfM4z5t23lkFKNaLJ0RFMMhbWlETNn1b31KGlEbTr4n/7
         LGbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IKQyKPe65GI52BeV5z6gmTHSIerDdWeQJKoPXAaiexk=;
        b=ow8xzBIPj/25vVSkYHhoPsj/sgZ4r8vOxsxlj2H9UjhMzyDgpd6PjrIxTDr9T2LeJE
         tZ5kvopykjo0id0IeW4oD2NIF49R4V6cPXhn0/K4PJumNGihzIAzoSxz5sQQNAoitAhA
         xDhIwL5CKbBBZ34ZPff0wAtBX2fJUxX+Fmk0ph22n1bxVm0kgDYuGY6mLPyfhMafYHXc
         DfJRA6c3sho52ymQQte9KWL1O2YgXXGG60A5BcJJjowzQ3DHKWu8+DI0bid63G70P/OD
         wSBXuTeJ31ISZ8wJ13IVdDswVKp8g3e1OBBVINGI+e6yrxYlD7hAWlHpNhwjwcKDZXHe
         soHQ==
X-Gm-Message-State: AOAM532SqFfUJCi6dFPrXNpI3UV1va4jAjILitvwntzS8AC4D5zYPdBi
        M6UWF3JwSY39zvy1FbGeETPvH1A37PP2oHU4E5k=
X-Google-Smtp-Source: ABdhPJyIMsEXkHIwNEXpVxXoR7SDrgey5bIxWrVkniQOg6RcQkeJOU60aLUTbP0Lzd61WQAbh/Fk9WF7mk4eYkTii04=
X-Received: by 2002:a05:600c:2185:: with SMTP id e5mr13276978wme.156.1622306883679;
 Sat, 29 May 2021 09:48:03 -0700 (PDT)
MIME-Version: 1.0
References: <04cb0c7f6884224c99fbf656579250896af82d5b.1622142759.git.lucien.xin@gmail.com>
 <CADvbK_e0PkKBYAUyg6iYyUwUp+owpv1r9_cnS7pbkLSjwX+VWg@mail.gmail.com>
 <20210528153911.4f67a691@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CADvbK_dvj2ywH5nQGcsjAWOKb5hdLfoVnjKNmLsstk3R1j7MyA@mail.gmail.com> <54cb4e46-28f9-b6db-85ec-f67df1e6bacf@gmail.com>
In-Reply-To: <54cb4e46-28f9-b6db-85ec-f67df1e6bacf@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 29 May 2021 12:47:52 -0400
Message-ID: <CADvbK_endt5VLzyDMumn6ks8oF5WkQ0hbx6XguyRbJZzOf4K5A@mail.gmail.com>
Subject: Re: [PATCH net] udp: fix the len check in udp_lib_getsockopt
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 9:57 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 5/28/21 7:47 PM, Xin Long wrote:
> > The partial byte(or even 0) of the value returned due to passing a wrong
> > optlen should be considered as an error. "On error, -1 is returned, and
> > errno is set appropriately.". Success returned in that case only confuses
> > the user.
>
> It is feasible that some app could use bool or u8 for options that have
> 0 or 1 values and that code has so far worked. This change would break that.
Got it.
Not sure if it's possible or necessary to also return -EINVAL if optlen == 0
