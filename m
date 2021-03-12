Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B89338247
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhCLA3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhCLA26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 19:28:58 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB57C061574;
        Thu, 11 Mar 2021 16:28:58 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id t18so4297068pjs.3;
        Thu, 11 Mar 2021 16:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=15VUT7DJn+pnOXHgIaEAd3HHArwp6lQ8zP41QSI3bfY=;
        b=ZJYo+PRkcpG5ShjLmsQYOvjCuPMVFH0KciMv3hf7amMitAnW72Lya1SpEg8moGGCO8
         4Zatez7ckGwdpCRP7Fwcb5AswfegpMyRGq8q7EMCw19jrdPwJP6Ov2HTB0ZeIiQwdXmT
         6cHBEEHriwAJEmND5WFStO8DZ8VWXeOOuM8XutlV3JyfU5V5nodVWNiH9XVmiyeKMXaL
         WLiyIQnzTjZ2qs+pYHfLG+U4JFXrCxjCQ+ajORSjlcRjlOisZkdL3W4+yBXb9cjkNoDw
         3MzF8TqudjqdXK9VEAvdvZgrgEuuNNg2vTCakN6y8GCBJb3ijJQjgqM8GklTd8/eLmcQ
         5KLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=15VUT7DJn+pnOXHgIaEAd3HHArwp6lQ8zP41QSI3bfY=;
        b=KjHsKAtFQ7yWaDBPUu+zzFE7WmgIMybu2IvSbAbBoLpCXChLtUnREqzG5yHOY3fFcR
         QYSXzI8jF2LGWcSbGRF1pRfP+rBwNwd4RJpmq+29mkQj4ED1PlRMSh6d1uXNDEJ2P8LK
         xjOLZ2Ew073xOYWg94LPbR72vPVnrQ6Ot3JSZ730CS7dnnKz8udK4Js2dQ7KBc72zxc2
         L5jbwv/5dQfqCsPCPGhOSMRujHQcKk9EUby4NG3mNt4HDQva8XxHDtapLRBe+T9rSxX8
         iHZ+z7kHKwx+DZ/eEeYrNISxbqklxl1sUVK4ocD0ml3iVKa87uUenk6KOjAkFADZQvaU
         8ljg==
X-Gm-Message-State: AOAM532G4iEbDxwCiucHHEDedsl4PViBUCEUYudjnCPDVwNCI/1+qfJV
        72bda0DZW2G1LeEFiCmWCpQo69WO3l+Apo5j5Cc=
X-Google-Smtp-Source: ABdhPJyc5WkdWAbCbtxeh2tlXfG8byRG+AjnQvX7WPwURgiCF7SmTF1Eg1JOolxh4qyVRiFg3NpeyeVwB+db2ENUW5c=
X-Received: by 2002:a17:90a:ea91:: with SMTP id h17mr11386538pjz.66.1615508937868;
 Thu, 11 Mar 2021 16:28:57 -0800 (PST)
MIME-Version: 1.0
References: <20210311072311.2969-1-xie.he.0141@gmail.com> <20210311124309.5ee0ef02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EMToKj2OeeE1fMfwAVYvhbgZpENkv0C7ac+XHnWcTe2Tg@mail.gmail.com>
 <20210311145230.5f368151@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EMR6kqsetwNUbJJziLW97T0pXBSqSNZ5ma-q175cxoKyQ@mail.gmail.com> <20210311161030.5ed11805@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210311161030.5ed11805@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 11 Mar 2021 16:28:47 -0800
Message-ID: <CAJht_EPf+MT+QARY3VUHzZUtNKshpAD0239xN1weAmRyj=2WTA@mail.gmail.com>
Subject: Re: [PATCH net] net: lapbether: Prevent racing when checking whether
 the netif is running
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 4:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> And the "noqueue" queue is there because it's on top of hdlc_fr.c
> somehow or some out of tree driver? Or do you install it manually?

No, this driver is not related to "hdlc_fr.c" or any out-of-tree
driver. The default qdisc is "noqueue" for this driver because this
driver doesn't set "tx_queue_len". This means the value of
"tx_queue_len" would be 0. In this case, "alloc_netdev_mqs" will
automatically add the "IFF_NO_QUEUE" flag to the device, then
"attach_one_default_qdisc" in "net/sched/sch_generic.c" will attach
the "noqueue" qdisc for devices with the "IFF_NO_QUEUE" flag.
