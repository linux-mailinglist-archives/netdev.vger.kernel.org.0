Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3FC19E9BF
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 09:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgDEHcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 03:32:07 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41115 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgDEHcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 03:32:07 -0400
Received: by mail-lj1-f193.google.com with SMTP id n17so11218111lji.8;
        Sun, 05 Apr 2020 00:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eD1t6b6bMcxK4Ie5EdhHP4NX5L/6yZx5WWdL+NqTuFM=;
        b=IaUFjyzGMjvSuZUhuIT+qX06jQmPcM9zWOwoyVDc9uLUmFlE+sahAVX+0e9YPgVIla
         6tb2IbvPacUnriosr16vxHsDBxhnZT0uBiCPWRHn8MswqURqTAbb21rzHQs/84JUgKyV
         pp4ok2OLNxQ25Y/P+8xRcTwVN7Q1Gb3hyHkgbHO4eOtWGx/S5Yj4DMII3RkpbnTTmXN2
         2BUuBaqh5AwW+ing808geuVCgSpaqPzM+lEwjnzNqoK9YXN3F3rXng9IbyRVlHM7MDw4
         nY3KBii/I7alyruhKl1s0KtU1yiwXfM+877h7BcAckjrV26GttzdgXJgI20nZ93XG8t8
         MNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eD1t6b6bMcxK4Ie5EdhHP4NX5L/6yZx5WWdL+NqTuFM=;
        b=RFeuTv6iQvTzIYNFZYRq7rXvtGhzn0N8poazjKirQoMEMCjcqqi7ZAS4iByeiscCgD
         1zgjIzjao0UmeD6AHGYPaXJ43W4dcx1vK4BbO4N0smT0MikIAV9UL6wRPyvptjLliWEh
         VBx749T/0ba01QRgCHaASPm5xEBUD7B562e90rcij7oX5BcCipb9AWB7J/P1VtT4c3F6
         0zMMPKviBO8xXahp6260zDftieRLyAqVZWUsAMz30YjLvW6AcL7leRpXyykmbFINkVsC
         GtOF+GhJ5gR6PKAmGNeT2iaR1HjxRDb2pvSuw/EZkuiod/y5vKg47iLkd0e8rD+7XeZE
         TfFg==
X-Gm-Message-State: AGi0PubXLapU52zg9vvrvGyG9TCCbw77H55YZkux1QnY7+rCfCpd9sXp
        Whw8fTUnWOct5QtLMo6F3clJA79rplHA7oNjKXA=
X-Google-Smtp-Source: APiQypJXdhdQBquZgZTuHcyBb40zTgvwv7f2rBl+afcbHzTn4x/NBwTXLrLQdqpUR11TUZKMM7vHIYbWMG7nYY7ww64=
X-Received: by 2002:a2e:b4e9:: with SMTP id s9mr9174132ljm.108.1586071923337;
 Sun, 05 Apr 2020 00:32:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200404141922.26492-1-ap420073@gmail.com> <20200404155247.GE1476305@kroah.com>
In-Reply-To: <20200404155247.GE1476305@kroah.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 5 Apr 2020 16:31:51 +0900
Message-ID: <CAMArcTVOgG_4Qp4UDFNj-FwxkePJDOw92fkNtDEtTVte9EUpLQ@mail.gmail.com>
Subject: Re: [PATCH net v2 3/3] net: core: avoid warning in dev_change_net_namespace()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, rafael@kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, mitch.a.williams@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 Apr 2020 at 00:52, Greg KH <gregkh@linuxfoundation.org> wrote:
>

Hi Greg,
Thank you for your review!

> On Sat, Apr 04, 2020 at 02:19:22PM +0000, Taehee Yoo wrote:
> > When interface's namespace is being changed, dev_change_net_namespace()
> > is called. This removes and re-allocates many resources that include
> > sysfs files. The "/net/class/net/<interface name>" is one of them.
> > If the sysfs creation routine(device_rename()) found duplicate sysfs
> > file name, it warns about it and fails. But unfortunately, at that point,
> > dev_change_net_namespace() doesn't return fail because rollback cost
> > is too high.
> > So, the interface can't have a sysfs file.
>
> Why don't you check for a duplicate namespace before you do anything
> like mess with sysfs?  Wouldn't that be the correct thing instead of
> trying to paper over the issue by having sysfs be the thing to tell you
> not to do this or not?
>

Sorry, I don't understand about "check for a duplicate namespace".
Could you please explain it?

> > The approach of this patch is to find the duplicate sysfs file as
> > fast as possible. If it found that, dev_change_net_namespace() returns
> > fail immediately with zero rollback cost.
>
> Don't rely on sysfs to save you from this race condition, it's not the
> way to do it at all.

Okay, I will find another approach.

Thank you so much.
Taehee Yoo
