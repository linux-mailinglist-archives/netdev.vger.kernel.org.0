Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282672A4D4C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgKCRmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728855AbgKCRmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:42:20 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807EAC0617A6
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:42:20 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id k9so19262027edo.5
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VYn/vKDpZ5hpbmpnVni806ofiX+cJciXsAeXX/Sk4l0=;
        b=rXQORZKJ2U+ylxQMF+9AWKUkZJig+UmoOXKVflnPvZyXuXR3GWmyk8sl0FLRxGl5xg
         5lfIaoIOsrcyieN13ynqLZkEePlq89EUJamlYl6hghYN63fgjJkxx5xHyPyZzpGICC+o
         2o5rigaAjjX8gaTETVTq1LnQYk/hyVYawJ6DJXxvf7OlCULVdl1YUj4OO7Gu+CRU2OBq
         MAaCSUd8n0j4PhonBKq9VehFQtMRUjEKokqvCTZl0igGB0NPyqMotDu7y/VLM73ncz3z
         f3MmwqNWLrByP7AxDGZS7wh2d1qoMU/OM17PTogjmy70uuo1AHpN8QVQ1rOprZFXD+UO
         5GRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VYn/vKDpZ5hpbmpnVni806ofiX+cJciXsAeXX/Sk4l0=;
        b=pyE5sMGOIdKQQnosjz0FpXn1CNd3xjLY3IuS83GH8S2QOtCdxQ2klcJeUaMHgTcvxt
         ZVUejOKeImRZdoSN30yYYAG9EthcjEMak1iOlr/8XQu8dTW5KpUmmBLA7krHMVW/L1SG
         Ep/lq9YG51CQ4+2TDJG3EC6H3PuRGQ34xg1oQje7PWhZhZKhcGH8E8DvK5tKVkYskkYO
         YDoUJnJsvTJlbexj4KzgI4yEccboUK0HCmMIg4G99sk+Cu8LO9fAOsn9YVrjC8ASN3I0
         6d2gPWREeES1dz4SYmZLQgsspVYjGSx/nxgMdNzjGUOm1dQaqHbquUrvorl4J16+NXFz
         fJcg==
X-Gm-Message-State: AOAM533MTeknTRTZibMZACP03N53l28Xuf+xMDjM+kzYql6D/VhNiV64
        PH6mFaUisYo4wmgfDOOVVcGXTLowocLpc+Z5s5tUxg==
X-Google-Smtp-Source: ABdhPJx5S3UzzTfDY8cKn+TAZM3BY37RtnJgYkeBXCiaVtJb0CB9xGlXlLQ7ZmZrDmrYSo9E3rydacpjFJ5hnLH6KB4=
X-Received: by 2002:a05:6402:4d:: with SMTP id f13mr23008097edu.306.1604425339037;
 Tue, 03 Nov 2020 09:42:19 -0800 (PST)
MIME-Version: 1.0
References: <20201001230403.2445035-1-danielwinkler@google.com>
 <CAP2xMbtC0invbRT2q6LuamfEbE9ppMkRUO+jOisgtBG17JkrwA@mail.gmail.com>
 <CABBYNZJ65vXxeyJmZ_L_D+9pm7uDHo0+_ioHzMyh0q8sVmREsQ@mail.gmail.com>
 <CAP2xMbs4sUyap_-YAFA6=52Qj+_uxGww7LwmbWACVC0j0LvbLQ@mail.gmail.com> <CABBYNZ+0LW0sOPPe+QHWLn7XXdAjqKB3Prm21SyUQLeQqW=StA@mail.gmail.com>
In-Reply-To: <CABBYNZ+0LW0sOPPe+QHWLn7XXdAjqKB3Prm21SyUQLeQqW=StA@mail.gmail.com>
From:   Daniel Winkler <danielwinkler@google.com>
Date:   Tue, 3 Nov 2020 09:42:07 -0800
Message-ID: <CAP2xMbsJ6EQYbJvS=59Dpj83sugFGaP98Mq-1SgxrJ+aSqd4pA@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] Bluetooth: Add new MGMT interface for advertising add
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Luiz,

Thank you for the information. It is good to know that this tool is
actively used and that there is a way to skip existing flaky tests.
Just for clarification, is this a requirement to land the kernel
changes, i.e. should I prioritize adding these tests immediately to
move the process forward? Or can we land the changes based on the
testing I have already done and I'll work on these tests in parallel?

Thanks,
Daniel

On Thu, Oct 29, 2020 at 5:04 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Daniel,
>
> On Thu, Oct 29, 2020 at 3:25 PM Daniel Winkler <danielwinkler@google.com> wrote:
> >
> > Hi Luiz,
> >
> > Thank you for the feedback regarding mgmt-tester. I intended to use
> > the tool, but found that it had a very high rate of test failure even
> > before I started adding new tests. If you have a strong preference for
> > its use, I can look into it again but it may take some time. These
> > changes were tested with manual and automated functional testing on
> > our end.
> >
> > Please let me know your thoughts.
>
> Total: 406, Passed: 358 (88.2%), Failed: 43, Not Run: 5
>
> Looks like there are some 43 tests failing, we will need to fix these
> but it should prevent us to add new ones as well, you can use -p to
> filter what tests to run if you want to avoid these for now.
