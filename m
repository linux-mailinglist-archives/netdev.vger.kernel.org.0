Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4A22EF2DF
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 14:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbhAHNJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 08:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbhAHNJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 08:09:14 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EB2C0612F4
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 05:08:34 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id w18so9690147iot.0
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 05:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=tjQZ6ifU9y1rovJPVlI6hcEMM/rEFs+5hVhaueqyfAw=;
        b=Ih49Bg0H4oYltejrkXTC54/lsZDMElUv1imT+QbSWzxkhDdkQ6Z4L1xaDB35lfWnhl
         7pmkuLdtYVbHQOzhCE48V0dqlSVT39K98lmM8fxjrJYSGfihT0qUA8ENxiXSTbGsK3Nu
         T+n8BTD7C9maALoRI7QHYL+y3pGIXs4xLK0c5CmpPUH2HEyY2kkW45CnPSNP0kJodWk8
         rtKEtLVYCf26rouaVfSNLIPvsui2qiF4h8IEQhscTmtZJyVQdOB7tPsX9ueD93lBxtjm
         6nehpqmrdEEiij6opZVFnSPLJZ+XuO9UFW/MLs6hpupPy2ofkEPVxuQC1ktL5pHRa6H8
         3vag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=tjQZ6ifU9y1rovJPVlI6hcEMM/rEFs+5hVhaueqyfAw=;
        b=ElXqBbwRqvmj8I9EuxIzbGfJuHMY6/3zbCMxNitPTkhBWOkF7yX1aLXmB4JA/gqEoI
         XLdXIXKT+WAFCN4RKo/nVAtp9edeXavRORA9RpCFbNYpOyVUfuKpL4xO8kjzUnbMvLD4
         8gvv90TzPJIQJ7HdDFFtPFjjRQV+cFeXliF9exl3ZqDTItj6n2ZIIXvc0o7+z+sArGlc
         jzPDCHNNYRhLOMbPeb/JHN8tWJdgB7SgaFTjIyi27y9FVxnlJAZqWhG4XU7PEMp+G+Vf
         0zW7YLQ+h6UG7Bw+OaorMPiXORMpViGwR5n7SaS+F+5rFWVkejw1fRKnzrbmD5iGhIJ2
         T+7A==
X-Gm-Message-State: AOAM532ncVQLfZJJaTblmwUOHO9RRSkectcBshzZVIZOc2QaprejTsa2
        nrS2blgh1AP3/ys/sacnrnltnabqIOk1QWwTQ88=
X-Google-Smtp-Source: ABdhPJxoVMPOSCSmR5RHdolQAtJ/EOti4hADXIUIz5mjEyvYgcaK4lJpHGCYDohAUIetqVH8khqlr7QNnn/MSK9WdL0=
X-Received: by 2002:a02:2ace:: with SMTP id w197mr3333895jaw.132.1610111313749;
 Fri, 08 Jan 2021 05:08:33 -0800 (PST)
MIME-Version: 1.0
References: <CA+icZUXzW3RTyr5M_r-YYBB_k7Yw_JnurwPV5o0xGNpn7QPgRw@mail.gmail.com>
 <6d9a041f-858e-2426-67a9-4e15acd06a95@gmail.com> <CA+icZUW+v5ZHq4FGt7JPyGOL7y7wUrw1N9BHtiuE-EmwqQrcQw@mail.gmail.com>
 <CANn89iJvw55jeWDVzyfNewr-=pXiEwCkG=c5eu6j8EeiD=PN4g@mail.gmail.com>
In-Reply-To: <CANn89iJvw55jeWDVzyfNewr-=pXiEwCkG=c5eu6j8EeiD=PN4g@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 8 Jan 2021 14:08:22 +0100
Message-ID: <CA+icZUXixAGnFYXn9NC2+QgU+gYdwVQv=pkndaBnbz8V0LBKiw@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 6:25 PM Eric Dumazet <edumazet@google.com> wrote:

> > Also, I tried the diff for tcp_conn_request...
> > With removing the call to prandom_u32() not useful for
> > prandom_u32/tracing via perf.
>
> I am planning to send the TCP patch once net-next is open. (probably next week)

Ping.

What is the status of this?

- Sedat -
