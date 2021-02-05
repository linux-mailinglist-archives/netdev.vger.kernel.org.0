Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00EA3115BA
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhBEWjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbhBEOBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:01:55 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31E8C06178C;
        Fri,  5 Feb 2021 06:01:14 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id a1so7807296wrq.6;
        Fri, 05 Feb 2021 06:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O9Z1vQ/uQ4SxUnAHiuEIdowkUzOAfoMC9jAqEdkr9Nc=;
        b=UWxrT6bh/Xpf1+BtBVrZ9fK/2GBwJUwIy4NXoT9AMeyp+n5YPAN8SUhWQN2WcELhYG
         fdQPYxdUDsloXnzHufAPnvtW78zjr8zUH08lMMZ61kV6td/JWczNamNCf8QJfE+lysfW
         tll34l159ytGH2iwZ9YMuWuGpAG7kF/8XcON8V+VqvJF4csdLGeaWlweSvllF+6PFgLg
         8Fqp9NXYyK6doxOj0dVrLiB9+8EiDuDRUB/eLyZg/seZnM74HbnsPeDtnIxfAEoLdBRF
         o/Ys4q1xhs42qIg7R+XixohFjj8bTuvRkVUt9Whc2vRiJtzpMHGzpuYzeJfXpZBvm+7T
         1EyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O9Z1vQ/uQ4SxUnAHiuEIdowkUzOAfoMC9jAqEdkr9Nc=;
        b=Ac6xKNzWoWfiGC/qoLZG5PrFd1VNkK8DpLc4ggcvUlITdg6IRKAATrEW0VufbjMjdz
         7WeMQeMJ4XbFg8czN9mD6fusQ8LwtMx6qvn8hboDsZy8h1f8u6tb4V6IziPdhxiFnztt
         eLDzO/wA7RZHzxnRtlWe9YtINL911Jh2gvkV2qKUy3MvhGVPCBlw4oMSjC0s8Ff+tPLQ
         7UQ9KBgbxTHps2YbEpc0YSwTkUuNlBZbq3f3tPwkBRfeO4be71vgzOpPTRC73f8EDava
         S7tS/JjSqasxSabJWwZJm8UJurpWs2bpOlSqHFNYsMAaHqpEp/JVQresElCm0VKWLggs
         gC9A==
X-Gm-Message-State: AOAM532YIFshCbr57dyY9vCWZc0OiS/j8MxE8Q507uCLKrHW6+sPISZl
        BSI3I4Rmb0XAQCnjFgkY+PvowAvuTPoFDobqvl64GL8L
X-Google-Smtp-Source: ABdhPJyOHG4SiE6og5xdBFGxcy0iwXnPRbOD2EDNpF/PxFrjZk/8vSI+PkljzE0CDgOCkbWwDQ9jzTvF3MnWJMiZkf4=
X-Received: by 2002:adf:ed02:: with SMTP id a2mr5157224wro.197.1612533673208;
 Fri, 05 Feb 2021 06:01:13 -0800 (PST)
MIME-Version: 1.0
References: <20210129195240.31871-1-TheSven73@gmail.com> <20210129195240.31871-2-TheSven73@gmail.com>
 <20210204060210.2362-1-hdanton@sina.com> <20210205093112.GC870@lst.de>
In-Reply-To: <20210205093112.GC870@lst.de>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Fri, 5 Feb 2021 09:01:02 -0500
Message-ID: <CAGngYiUgNMhPnUk6kPYnxpfj9zh05dPzAFQAC093fHzBrsX93A@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/6] lan743x: boost performance on cpu archs
 w/o dma cache snooping
To:     Christoph Hellwig <hch@lst.de>
Cc:     Hillf Danton <hdanton@sina.com>, Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

On Fri, Feb 5, 2021 at 4:31 AM Christoph Hellwig <hch@lst.de> wrote:
>
> This is a pattern we've seen in a few other net driver, so we should
> be ok.  It just is rather hairy and needs a good justification, which
> seems to be given here.

Thank you so much for taking the time to look into this.
That is certainly good news !!
