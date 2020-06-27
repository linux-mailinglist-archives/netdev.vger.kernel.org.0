Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E420A20BEE7
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 07:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgF0Fvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 01:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgF0Fvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 01:51:39 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427F6C03E979;
        Fri, 26 Jun 2020 22:51:39 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id c75so10281499ila.8;
        Fri, 26 Jun 2020 22:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/XK9O5e9WYvpLJ8CUU6lWm9WXLh2aPJdj62lrelY7z0=;
        b=PZbX8WV/OaNA6DgZ6Is7kfIwNjE23/oVVVKhrWXOyaLkvljZiKFQePoBr4dSVTBwSC
         E5Ham/C1pDzR++vWFqCyS32++gOZAMbZDS/kW+rKqCg0p3qxQvMVFeTM/zgo4uOQ+0dX
         fh8hQOJiJS5uvlX3uUMpqREYSLfevJbuWyqfoLDtVjVs10d0JqdcC6BPHX4LUs28VTl4
         osf2a3EZCj1YCIXf4AFKI8yQuH3L0vAOBtmOYnBZlOFjr/z6YS14c0oPxOeX7i91wXFQ
         pYM3R4u9W0ySVOKT/fzyficDQ5xuil6YkvUyisGqmOjkhjtA8jc3y4an0/FDNet/PtuQ
         OvEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/XK9O5e9WYvpLJ8CUU6lWm9WXLh2aPJdj62lrelY7z0=;
        b=GM1VPccKK7+4bNMx00RnFfWAzjeIdk2Uzm16Q/wnHTa549SvN5C8241F4X0ZWI76jG
         kMMYUzAYB4tJtC7zYLj2ccLC4yj2T6Jr5EseNPBWmGqwc2Fodd/Qh5c23l0d/866AJsa
         p3q/3QoVP9SbRhgZjVDic8FOpUpbNlFyaYEzhGa1mO29pLZVaN++k2t5qEUM9+xsCUoC
         QtBbvqlSpRzU5YyHABvx5bPTMQEatlwKX5bmc8h8zIhRHpiWoVQBU8V76rebhlz6FN7U
         nQh010pDnHbkQe1zeID8odnt4YQOLoqB+w7lzm7gdCVtEHuztFGQ5S/xKCplej9Oc/Ak
         FVLg==
X-Gm-Message-State: AOAM5318SI3cQ/A0EAbqzvGsP+fsAEFxaHoHgQiE5VpxYlIUWTlFQ4lN
        Q08XeedwVwqJt8Ms5vI37kPD0IfTPyQXZGKgBUU=
X-Google-Smtp-Source: ABdhPJy6prHvLGtnP9a/NnYKc8hXTVPikrzhNjdmbCOe1v5Ut7+vGkabZpdZwEYEUy+QJdErXgomCSZw1GERy2496/Y=
X-Received: by 2002:a05:6e02:48e:: with SMTP id b14mr6281351ils.143.1593237098484;
 Fri, 26 Jun 2020 22:51:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200624175116.67911-1-vaibhavgupta40@gmail.com> <20200626.121428.112500348777695663.davem@davemloft.net>
In-Reply-To: <20200626.121428.112500348777695663.davem@davemloft.net>
From:   Vaibhav Gupta <vaibhav.varodek@gmail.com>
Date:   Sat, 27 Jun 2020 11:20:03 +0530
Message-ID: <CAPBsFfDBogBbLuzMd2dLwR_DD2hMpoYsXnOpLwMyS7CJ0vUH3A@mail.gmail.com>
Subject: Re: [PATCH v1] bnx2x: use generic power management
To:     David Miller <davem@davemloft.net>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Jakub Kicinski <kuba@kernel.org>, aelior@marvell.com,
        skalluru@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Jun 2020 at 00:44, David Miller <davem@davemloft.net> wrote:
>
> From: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> Date: Wed, 24 Jun 2020 23:21:17 +0530
>
> > With legacy PM, drivers themselves were responsible for managing the
> > device's power states and takes care of register states.
> >
> > After upgrading to the generic structure, PCI core will take care of
> > required tasks and drivers should do only device-specific operations.
> >
> > The driver was also calling bnx2x_set_power_state() to set the power state
> > of the device by changing the device's registers' value. It is no more
> > needed.
> >
> > Compile-tested only.
> >
> > Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
>
> Applied, thanks.
Thanks everyone :)
-- Vaibhav Gupta
