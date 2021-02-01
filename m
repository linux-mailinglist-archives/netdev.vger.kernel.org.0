Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE4730B157
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhBAUHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbhBAUHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 15:07:14 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045A8C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 12:06:34 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id j18so389593wmi.3
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 12:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aVXNNvrQzhSCART1M9uQi1RCKhtrDut9W9JE2BmbicA=;
        b=SQUrrOl6aYrucTEeDYRip0SpaEMVxaoPrzgQCfN8+xlOuFmO9awYM8CafY24fTHmxz
         F1aB2F6oLElqoAuoac3Adk7VSPHQs2kOdzTQokFHGuAijFUUoQusf6CZ9dnNgG9JVs0/
         AG0H8U5YCR25g4lWlIpw0Tfu+O7/HHGQjLhz7g91hBoLmOPUqH2k1sF/6iB20m5/dWx5
         h6DGbykdcCC7DgTN+f3kNVqk8R3VBDFP7WzdGBX11B/xlWvr1pPwfJgLPqHDGza+7Dry
         8SHc6VLjga9Qm7iiwR2DqYNIaYr+6hu0GSjHGfScCXJuy6TGN3A2T+UXyJevVGtMYb0T
         YnUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aVXNNvrQzhSCART1M9uQi1RCKhtrDut9W9JE2BmbicA=;
        b=KMZPboO0fVyTiZDBgjsZ4d5ZPPoVE3styf+us+VVKFCmNQvcnqxO4IHAxdPZk+iYRM
         1o0KvuA1AzYTZpTi6F1m989anU/saULnIwtijw7fDi2odu5DiDVDbXYEk+TbyKcsD2/b
         3yqf2y6iBoPt35zbDYUOI2VlI5jqEV17UXGRjSpLOBo2xckRSMq8HFax0jQhs4XXGShV
         TotZ0L/lBB57c0bnL1ku6pA4rOjdCZNR06bddsweJCP9x4uOMT+kEXmkxbXs9MbayA8U
         0OhAfbmyhm8ZYSiNbDDuJLRLO0osgrfax9Q8vRjUf3d9JMndFx3Nptjpz1mmtiXq5E9X
         7BgA==
X-Gm-Message-State: AOAM5310v2hz8YxABEjpp8gPDjD6l1kCk1Z/38+wnmWMJJVVizapoeXe
        RAFSkH0hTeQT51RLGaJq5uOqJN4d1PgxUCOKWm4=
X-Google-Smtp-Source: ABdhPJzeCzBgpOeIK1CgeDUKpMODp/l1qgQvJ4yWK7uxXrPvMpDojV1Qhm5z0da3ffUjmDA6GKGd76KmVzf27aNIG3A=
X-Received: by 2002:a1c:dc83:: with SMTP id t125mr479745wmg.154.1612209992707;
 Mon, 01 Feb 2021 12:06:32 -0800 (PST)
MIME-Version: 1.0
References: <20201221222502.1706-1-nick.lowe@gmail.com> <379d4ef3-02e5-f08a-1b04-21848e11a365@bluematt.me>
 <20210201084747.2cb64c3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a7a89e90bf6c3f383fa236b1128db8d012223da0.camel@intel.com> <20210201114545.6278ae5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210201114545.6278ae5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nick Lowe <nick.lowe@gmail.com>
Date:   Mon, 1 Feb 2021 20:06:16 +0000
Message-ID: <CADSoG1uRKexjQJ7Oxqyspzbpx=Qyq2dTbOMp-dEjTSMMySmkFg@mail.gmail.com>
Subject: Re: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "linux-wired-list@bluematt.me" <linux-wired-list@bluematt.me>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

It is correct that this is not a regression, it instead has never worked.

My suggestion would be to merge it during the 5.11 cycle rather than
5.12 where possible because the patch is non-invasive and should be
lower risk.

There are significant and tangible real-world benefits to RSS
functioning with the i211 so I do not personally think, on balance,
that it is proportionate and worth waiting for 5.12 to conclude here.
Any thoughts?

More importantly though, after this does release in a stable kernel
(regardless of whether that is 5.11 or 5.12) and this change has had
some time to soak in the field, I do suggest consideration to then
backport this to the 5.4 and 5.10 LTS kernels so that RSS starts to
function there. 5.4 and 5.10 are the release branches that will, of
course, get far more use for the next couple of years.

Best,

Nick
