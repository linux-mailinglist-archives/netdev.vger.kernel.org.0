Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239CB3B3437
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhFXQzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhFXQzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:55:53 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FDAC061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:53:34 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id m18so7445980wrv.2
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zuhcWJERGt7ti3qI+IDS3oOVRRUP6vYOE3ipm0vpTdo=;
        b=aFM2AN8eiJRfgJWZhMere3ow47V2HuqOHRAPMO8XUavpMVDk9+UIkxBBn0vYsFr96h
         1VS0RTYdE7Bf54pOeD0Yj3Sv1phzAHHi3BRuTxFLWBaahVimEYER7MzL+Rzw986Jl5YV
         d2KPlkTFiADY7a2oltOqxKUtdd7K+WHpvB9gxNAuC6J2e5GfGFPHsPXEay6FOgSjGFFx
         7RtUF5O1NS1+owEkAAujBgL0RneTGABQrUF7YyX+E/qTFj06wGpN4UgQgCp+pfAQaV/e
         LFQpOl/B+vO6IKzqVfk44V0eNQKGGw86jaUvW4cZxP1H2rkUt6XKmMoccP1sMtuxiGVr
         QzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zuhcWJERGt7ti3qI+IDS3oOVRRUP6vYOE3ipm0vpTdo=;
        b=ghpgEIsd79GexSOoUsrTADXPjaO6L/VK0hJyMYGwz260qLclXOrnROlJ/iTH5lVmiY
         VbhZbqcZUoDxeHZYD+c8oZEje3BdNEFQnffuPXiXUqyG3CpS/68NA8xgzo2AZfXDy7fh
         OcEhXx7dsjmsOq/IY9Zr2xD+pHXApZlzcStuPXtfTcAnTSWtG4CZkgM0LjSpxCreU1KI
         x+gZC0ml+2d2/f3dIyXT/o/H3bw1pOwW0Q/u7IO2RCJbbhsHkim+HaDEbIR+s3l8+tp7
         b5W58UdxsSHGvtTZo0L8kFSK2gOFtrgiUiIutWgXi6eI8U2Z+JJntFdl8Qz3cjsQt04i
         6rHA==
X-Gm-Message-State: AOAM531hQLX0D1dURVqvWsumGd3X75GuAtYCjULBHlN0IZ3hNKJVwEwU
        6JDw8GHc24rI0lxBTJBj5I8mSKFiyuvy0FKIDkc=
X-Google-Smtp-Source: ABdhPJzWGan8AqNaP6cnr0YVjU8LK3d/INAbDtWyGUKCekjvVrns35ryW0B5wCRIrYAC1O5FJ7A+vRreKOKSubPyw1w=
X-Received: by 2002:adf:f68a:: with SMTP id v10mr5649280wrp.366.1624553613223;
 Thu, 24 Jun 2021 09:53:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
 <20210624041316.567622-3-sukadev@linux.ibm.com> <CAJAjEthEoZk8LLWhhwMaTy0nrh5qaeY6ouUu--Uv2D_Zr+1pug@mail.gmail.com>
In-Reply-To: <CAJAjEthEoZk8LLWhhwMaTy0nrh5qaeY6ouUu--Uv2D_Zr+1pug@mail.gmail.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 24 Jun 2021 11:53:22 -0500
Message-ID: <CAOhMmr6g4XhnhRdMxP-CZxpJ6A1F0b=Lr+1vGWEKYfEk9YCVzA@mail.gmail.com>
Subject: Re: [PATCH net 2/7] Revert "ibmvnic: remove duplicate napi_schedule
 call in open function"
To:     Johaan Smith <johaansmith74@gmail.com>
Cc:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Networking <netdev@vger.kernel.org>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Brian King <brking@linux.ibm.com>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Abdul Haleem <abdhalee@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 2:05 AM Johaan Smith <johaansmith74@gmail.com> wrote:
>
> On Wed, Jun 23, 2021 at 11:17 PM Sukadev Bhattiprolu
> <sukadev@linux.ibm.com> wrote:
> >
> > From: Dany Madden <drt@linux.ibm.com>
> >
> > This reverts commit 7c451f3ef676c805a4b77a743a01a5c21a250a73.
> >
> > When a vnic interface is taken down and then up, connectivity is not
> > restored. We bisected it to this commit. Reverting this commit until
> > we can fully investigate the issue/benefit of the change.
> >
>
> Sometimes git bisect may lead us to the false positives. Full investigation is
> always the best solution if it is not too hard.

Agreed.
