Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB1D2B0960
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgKLQBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728753AbgKLQBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 11:01:04 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25ECC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 08:01:03 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id v20so6732877ljk.8
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 08:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jxO/0qDc2h8hzzhxfYcKTRFtMlvPCGcyayNNruvXqzY=;
        b=OWua5B4j+FW8OE8Yxv+ExxarfITEqhSJetVOFwaUGofF1qsd8pvY68cz1Yv/8mKY1q
         CBstzDhHBQu8hK0iwwarpvX5QsNhKKd08mlgnQNR7IWFLgU0VqappEDlaHgkHdQqTBnO
         Pw+EYM6egHTQKgwQ979nofP5ehKFQL2M+4h1O/F8Y47zkOq6VXBstv5FKpiLDqzJ/hEK
         BeCnE+cfAJGPje+VDeBa5Bneq3WypVJvHJdnpHQfvmXlcye/rh4ECRdrwtNjs357q6DJ
         /gVO7ld8OYJ2FmbfdI5AuYG0IqDQsH6JqeBwmdAhDDGs906BKri9FTHqTKPXzUHqO0eq
         vqAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jxO/0qDc2h8hzzhxfYcKTRFtMlvPCGcyayNNruvXqzY=;
        b=OXFePc9dWHkm4AeDEXvnq3FfSmELRUA7p0NZFBv3limXxSamu/4/jXZZyD8Le/RKL0
         Ah9GfowM2DCetwNFvKm+2/NYt6azyjhsPW+gU8K4Ac/CusdcaRhpVExmWxpBkXRTIG9d
         Rhv3yjZTdfg9OPqfATBu+QTSLBXM5gipWuhwUJnYce2l5x1Zvg5cd2+e0BE6V3j8TAXi
         VnKxKebqXfIB21Xr8JbbaRb80FhYYY46vqtkfEUQEI0BGaIrROFLTPr6oaTid+W7cful
         uVulNtjcM94Qlu48N1vJNzv01VzWF5SWrel3y8I9WupKP9VRNy8JVX+GgrbLdWKpfV58
         CVcA==
X-Gm-Message-State: AOAM531P1/wW9Zq2g3r3rNQc59CmpI5uCSBiCovo9iFHHOJOdxB1haRY
        khuwIoI4yf0VfAwJGOLnzAfiWSDyRJ+hu5fDHoQ=
X-Google-Smtp-Source: ABdhPJy4aimpYv/NLxjYP7apORvzZ2ElArMobcA/N/6bKttypu0kPCq1NHIwqIHdH4q00ODKjkyx3Q+ZEpNk1RlL5wI=
X-Received: by 2002:a2e:151e:: with SMTP id s30mr57206ljd.44.1605196862196;
 Thu, 12 Nov 2020 08:01:02 -0800 (PST)
MIME-Version: 1.0
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
 <CAOMZO5CYVDmCh-qxeKw0eOW6docQYxhZ5WA6ruxjcP+aYR6=LA@mail.gmail.com>
 <CAMeyCbhFfdONLEDYtqHxVZ59kBsH6vEaDBsvc5dWRinNY7RSgA@mail.gmail.com>
 <ba3b594f-bfdb-c8d6-ea1e-508040cf0414@gmail.com> <a3caa320811d4399808b6185dff79534@AcuMS.aculab.com>
 <CAMeyCbhG7-dCr4bVWP=kNuwLa6CNB9h=SwN_kK7VbJ7YFCY2Ow@mail.gmail.com>
In-Reply-To: <CAMeyCbhG7-dCr4bVWP=kNuwLa6CNB9h=SwN_kK7VbJ7YFCY2Ow@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 12 Nov 2020 13:00:50 -0300
Message-ID: <CAOMZO5AY_y_HoHa5YiRf4RbeKC=9HUQtXyAXjVxT+rx3vMg7Yg@mail.gmail.com>
Subject: Re: net: fec: rx descriptor ring out of order
To:     Kegl Rohit <keglrohit@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 8:56 AM Kegl Rohit <keglrohit@gmail.com> wrote:

> Not so easily possible because there are custom drivers and some
> kernel modifications in the mix.

imx6 is a well supported SoC in mainline.
You should try a mainline kernel, otherwise we cannot help you.
