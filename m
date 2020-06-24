Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6688207943
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404799AbgFXQfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404535AbgFXQfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:35:05 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED792C061573;
        Wed, 24 Jun 2020 09:35:04 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id z2so2686221ilq.0;
        Wed, 24 Jun 2020 09:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+I6y3pNtuMWnbkqUpxbZvfr8752FW4gM6Qr1fXSaUd0=;
        b=NqqTFVJxUER0fAvaPENWhsQbrhd+xhCRvVEPR29e58YecyfMxJEOioJioJJLa7UswL
         ttuFSXvuIRR2BdbqtXI3BT1kOGF6cnyFO9VX5yZBJzqllS9+g7pI5YAvn273rL8IdVa9
         nqsa9/XCaMmS4s+hrAXa+QkOjmLKV2gsq9i3Z3WFctGZ+KLGpKNxoRQW3zpplmSo2l2K
         WnqLW/FyaVBTmqGofjKkj8OMTwQJsMuLuo6Mfn1sqT/pGfQtI57dipiDIyIJ6f9yrnB8
         bW1YjDY1VBL881IjAWqTlhRsz36C4qU2XW7yDzDCmqKoLZoL0aFVXpO/BI20DfPlwIeK
         gHXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+I6y3pNtuMWnbkqUpxbZvfr8752FW4gM6Qr1fXSaUd0=;
        b=NkJhlZN9Ts+E9CfY47oU6AhIRBdJ1wCLtZ6zXlu/3ZAXpYJsm+sMBV2UizsueKHWt4
         M7VUFsyJCYx5tG6afS7hWEXwJTwCY9JHrPi3zh0r18bNPsZ876PqTJn9VE/fXqDdZjy8
         L4lMYSl4zFHHlzs5nysPj8n5t1+Z/hduj5bghBb5CaBrLF38jB01gOv9H4oWOqJNMZ+5
         OBTEFXfXjBKF0TYJiy9A5Ksgtt2maCEfXSOU8gGmvyT4Thn+qvzJKulLY+fopF+dIKKR
         6VwMi/CU0ZW60jJIbTJTQ64HQh87rwWfay5igmeXswSivhRiMIZ5SoM8+C4rGtX0H6Mo
         YQQw==
X-Gm-Message-State: AOAM53009rLsNNYxCDQxtUb5NRjROnTc5FugFwX7OmvLEqJRllzef32k
        /3tB3kjwEZR9gPCpUGFyHQBTvvF7A1bXJuF39IY=
X-Google-Smtp-Source: ABdhPJzLDUekT+GvWZk7aV7tM9rY3U1EqQBwUoHTgmVZz36JFNQs3+g2dME/8Tm7Ik21rOrCpUjvuaHZecG9XEwnmcY=
X-Received: by 2002:a92:4a04:: with SMTP id m4mr31018680ilf.228.1593016504266;
 Wed, 24 Jun 2020 09:35:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200622111400.55956-1-vaibhavgupta40@gmail.com> <20200623.203131.1093463627031337018.davem@davemloft.net>
In-Reply-To: <20200623.203131.1093463627031337018.davem@davemloft.net>
From:   Vaibhav Gupta <vaibhav.varodek@gmail.com>
Date:   Wed, 24 Jun 2020 22:03:30 +0530
Message-ID: <CAPBsFfBCd9+JWji1DeHHtOrpTMTeN5Zk4iQXWM6MRrRJ40ns9w@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ethernet: amd: Convert to generic power management
To:     David Miller <davem@davemloft.net>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Jakub Kicinski <kuba@kernel.org>, pcnet32@frontier.com,
        thomas.lendacky@amd.com, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jun 2020 at 09:01, David Miller <davem@davemloft.net> wrote:
>
> From: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> Date: Mon, 22 Jun 2020 16:43:57 +0530
>
> > Linux Kernel Mentee: Remove Legacy Power Management.
> >
> > The purpose of this patch series is to remove legacy power management callbacks
> > from amd ethernet drivers.
> >
> > The callbacks performing suspend() and resume() operations are still calling
> > pci_save_state(), pci_set_power_state(), etc. and handling the power management
> > themselves, which is not recommended.
> >
> > The conversion requires the removal of the those function calls and change the
> > callback definition accordingly and make use of dev_pm_ops structure.
> >
> > All patches are compile-tested only.
>
> Series applied
Thank You !
-- Vaibhav Gupta
> , thanks.
