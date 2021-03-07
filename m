Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED50A330414
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 20:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhCGSzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 13:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbhCGSzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 13:55:36 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C04C06174A;
        Sun,  7 Mar 2021 10:55:36 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id d5so6910108iln.6;
        Sun, 07 Mar 2021 10:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yTMxu6lUFjwpBpsU0zPd/ZeXXHAFde8y4EnRup74iaU=;
        b=rp5AOs/qAciU0UjvxmMxIjSnqzRdtXAV0asS8mNcqAbEH1X9nQZp3hBG4EtkAT8gIO
         n26dIl/s6jWAcfPdR+dGug17EG80hL4ixwFVuhF9C8W84pXo3sVCSHZN4nzpY/MpDqBL
         U2Zdz3fJUiSRsbyx7xLaYOMDlKl7rMduRfsjMnp+Z1MAC9JzghPPAYNdeQap1byxFEHn
         YkrOIsaxchY7GYnAC+8e/04K56zdFguhf7Qgvia3JS8Tjt8uBBhjdzi+xbczOO0zKSQK
         NXolUCZX0IgtvwnmhYFlHSkA0ZMuwpPxcjOr6PEF6WdzRMSlKC2tHF9edlZDiDCwUAGq
         Y1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yTMxu6lUFjwpBpsU0zPd/ZeXXHAFde8y4EnRup74iaU=;
        b=IYVXS7XPPqGUlQE1zSyZkFck6vywJPxq0X2taS7Y+TUoMyZwb1HcE++ST7mVP06iZz
         ysdvu/+xpcXwqMMEnZJUmF679ZvbPwHFHWjqhSO3PMZOimI/+YVECHm2f286m0uk9A8a
         ea56T5n9CW/OqW9fqmzwv6tjlV5aqVYGF+FLebRXW9wRB3uulhYVKxcP6mPc7ppxfp43
         ahC/py4plGAi9wmdy3MF/imWBwioARlXIXNIWa8WCjjVxf1Nrmjo54XAadk2/0y2nkxA
         sbLoA1r8BadWZF7Fn2Ik7OJeUF0b8xFVd5oBYIe64BSMW9lUAdY2GMRHrwS/s95WqoB9
         Jsfw==
X-Gm-Message-State: AOAM530YxxH7unmK2jqbyQXq3n07rGgLo2tE24glvLLivW+DW5bHB3qr
        Fhof541ui7pDaG/Zobe2jTXk4gF470X+o77H/nrNSY7e8rQ=
X-Google-Smtp-Source: ABdhPJwFEZQBcFSn5AaZYi5rDIruu4ACC7Jsozz+Ur0K/zqBp+QpzlCC9Sn/jz75B+nWm+f2VwCP+GTIAWcYfmvPsBE=
X-Received: by 2002:a05:6e02:1069:: with SMTP id q9mr17248298ilj.97.1615143335620;
 Sun, 07 Mar 2021 10:55:35 -0800 (PST)
MIME-Version: 1.0
References: <20210301075524.441609-1-leon@kernel.org>
In-Reply-To: <20210301075524.441609-1-leon@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sun, 7 Mar 2021 10:55:24 -0800
Message-ID: <CAKgT0Ue=g+1pZCct8Kd0OnkPEP0qhggBF96s=noDoWHMJTL6FA@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 11:55 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> @Alexander Duyck, please update me if I can add your ROB tag again
> to the series, because you liked v6 more.
>
> Thanks
>
> ---------------------------------------------------------------------------------
> Changelog
> v7:
>  * Rebase on top v5.12-rc1
>  * More english fixes
>  * Returned to static sysfs creation model as was implemented in v0/v1.

Yeah, so I am not a fan of the series. The problem is there is only
one driver that supports this, all VFs are going to expose this sysfs,
and I don't know how likely it is that any others are going to
implement this functionality. I feel like you threw out all the
progress from v2-v6.

I really feel like the big issue is that this model is broken as you
have the VFs exposing sysfs interfaces that make use of the PFs to
actually implement. Greg's complaint was the PF pushing sysfs onto the
VFs. My complaint is VFs sysfs files operating on the PF. The trick is
to find a way to address both issues.

Maybe the compromise is to reach down into the IOV code and have it
register the sysfs interface at device creation time in something like
pci_iov_sysfs_link if the PF has the functionality present to support
it.

Also we might want to double check that the PF cannot be unbound while
the VF is present. I know for a while there it was possible to remove
the PF driver while the VF was present. The Mellanox drivers may not
allow it but it might not hurt to look at taking a reference against
the PF driver if you are allocating the VF MSI-X configuration sysfs
file.
