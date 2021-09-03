Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85BD3FFDED
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 12:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349066AbhICKHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 06:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349057AbhICKHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 06:07:54 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD212C061757
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 03:06:54 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id i21so11015157ejd.2
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 03:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=XIZPXBqpbnE/doQoEW3zJ8C0t2VIAYoFrQcnzlqatVo=;
        b=ZJQw5QKYtS2NZG1utq9XRVQIGg4RUlbNzNk+YgNbgC+NKKq17c62ycVWSX9FxdxF1e
         9rcqC7h9FqiOTsny91Mp1kiCXX0ekflcvspJeUaxdDuvavRUema+J/dckwIhewzivuW9
         +/EQw4DVtQjvt55iPjyrIu8c3fRc/HtTcOXkExAMd82qIaAKQR9KtI5AN3De9tRY5ti4
         3RY3gIq8FDwb2zc2nnH9TNClLjbIUCVDc1E20+8hHnuKXS13sOI7yVmUyvtPwjLQiD8Z
         UxHZUxhlfgWacHnXB1hpdrq+kg+bj5Tq2u4Q0PPg3LdD6J37qSclmjvaAeEWaA3G4u/v
         plbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=XIZPXBqpbnE/doQoEW3zJ8C0t2VIAYoFrQcnzlqatVo=;
        b=fiiwA0Gfa89lwq2V9yqtUatcEk7TK5CikmVdwZtKXPRASZN677rE5C7Eu9KYjHO2bU
         AO4rl+ec8qSbrV8p1MoslmhBrOcOD7XPF1II9VPghKxfPko365AvQf3KJCGs8495cvrO
         ESrBSGZ1ZMWiL/FvPcMBdPg8GOGi47NcaNatwce7eqgPhQyqtFHLjDnnJJSfRT99OwW/
         kJStxsZNwHAR+MFMiiKvjywqZ+NyNEfYR+pVxt1NmiNJ2iUYI2sycI+MaRhi17gOwQz5
         PIG4KQXQiZlSxxeVqK/WxdI039QdoRRUHKPQbb+gPdcsHxgBRxA+QZ+t29YfaTImswq0
         fEFg==
X-Gm-Message-State: AOAM530pfNih4g9QW0f61oyllfl5/tSnLRWGwjbbD5FMlM9zbpTYK21g
        HSq4gSCVN5Yqa4A7AGNZ+MSdB+MhJWF1ae18o/bWoKgE
X-Google-Smtp-Source: ABdhPJyDLsNs9IoFAU2BcWRj2SqdDMSnATuosO+iqr+ltsp7iFJqE4mIzDgh9RtSVdwC94og2CiJgA3gWft+X1YLUeI=
X-Received: by 2002:a17:906:38c8:: with SMTP id r8mr3333354ejd.172.1630663613180;
 Fri, 03 Sep 2021 03:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <CACsRnHVGatk0YrV1ayrGqK0S3G1xTJYatgY07h86bRZ5BFA6Ug@mail.gmail.com>
In-Reply-To: <CACsRnHVGatk0YrV1ayrGqK0S3G1xTJYatgY07h86bRZ5BFA6Ug@mail.gmail.com>
From:   Michael Johnson <mjohnson459@gmail.com>
Date:   Fri, 3 Sep 2021 11:06:42 +0100
Message-ID: <CACsRnHWzB4LKBTKn80QZPC6Uz3Rs+KXEjjQSTTAHOGXNnGhEUQ@mail.gmail.com>
Subject: Re: Delay sending packets after a wireless roam
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Mon, 30 Aug 2021 at 16:37, Michael Johnson <mjohnson459@gmail.com> wrote:
> I started seeing this delay after upgrading from Ubuntu 16.04 to 20.04
> but because so much of the wireless stack changed between those
> releases I'm not sure if it's possible to bisect the change?

Since my last email I have managed to test different kernel versions
to narrow it down to something introduced v4.20-rc1. The issue doesn't
exist in v4.19.
I also compiled and tested the mainline and can confirm that the issue
still exists as of 5.14-rc7.

Does anyone have any suspicions about what commits might cause this issue?

I'm currently trying to bisect the remaining commits but my laptop has
a new intel chip that wasn't supported in old kernel versions and I
can't seem to backport the iwlwifi driver with a compiled kernel (I
could use the backport-iwlwifi repo when installing old debian
packages).

Finally, one other thing I've noticed after more testing is the send
gap is almost exactly one second from the last packet sent before a
roam to the first packet received after. This hints to me it might be
scheduling or timeout related?

Kind Regards,
Michael
