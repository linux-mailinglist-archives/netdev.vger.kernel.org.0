Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F322621C5D2
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 20:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgGKSin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 14:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728510AbgGKSim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 14:38:42 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CD4C08C5DD;
        Sat, 11 Jul 2020 11:38:42 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t6so4014981pgq.1;
        Sat, 11 Jul 2020 11:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=THHKkt+w/SZNXzFVYoleIURyuBADbu4KYpkN8nJTW9Q=;
        b=T5xYXZAd0SWS5N1u8g1JNXEyBmYAr6qdVbKb98PCVTppRlk0mlk3lCjpdtrogebXPO
         IzHBrzmEQ4WEw1fHVlNonL6/R1PKmaXnoZ/e6oVhxhp3I4ywTJuUX/hi3oD9w0RmxXVO
         uzT2kxPcm5A6cqF2CEOwGAwCbT3sldGugZPgsZNVUub7wD8Yqcn04jm13hrckC5ZGBF1
         hP4yLU1Yf2kaxHA5jqomAqxu+MxryyuqlKWgjCKJICl9fxExNPudEkd2uzeWv7AWI+oD
         28ZkNwoIxfEtTeN6y2pg51b62eYfzY0RUpVbVrTQxDS56tlJd/10fzL1UKE9jXtAjtOf
         UMwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=THHKkt+w/SZNXzFVYoleIURyuBADbu4KYpkN8nJTW9Q=;
        b=d381AvMC/FuuJKdyIUHrZCm822ZzlRbWBdociVA1MufXtLqj7R7KZDm3te4BT+CN33
         2DzSK8tu6Tth08+UvC6bjrsZQ+HUsryYqErwncqFBIZg3FiWkCFpvgc6U65VZLZwZqSM
         kUMYvXo1jBntDD0qhfdAeJx30TvvrbBvA4sSUqKX1kUazBTlSX4rcuNrKUXCeSrcWieC
         XLC8g+SW5YBVT8BYtByvhkB+KCdDtWfYmYa4IMSbldaB51rQDxGMxyuuzXHEuAxtf3hJ
         woBzeFXrNi706zICY3yVzo3OI8Q/5OOG3jspIItfy6UWf0i1sWeNjwnahtblOXVMyeXP
         LAYQ==
X-Gm-Message-State: AOAM532FVWUc1MdJdikU7/M7mcIrora+c3p5YkXDllZ0ChddbjsRaQUK
        nDh1Sdix615jgOFGWL45V5PzZ+2A
X-Google-Smtp-Source: ABdhPJz5MgMVzTfGKGN+9KOG5W4Kt5lEo8eCA8w/R/jefRInFTdeTDST6Bv/m7uAW3jlNTZES4h1Lg==
X-Received: by 2002:a05:6a00:4f:: with SMTP id i15mr37622792pfk.93.1594492722220;
        Sat, 11 Jul 2020 11:38:42 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y19sm5175471pgj.35.2020.07.11.11.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2020 11:38:41 -0700 (PDT)
Date:   Sat, 11 Jul 2020 11:38:39 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, min.li.xe@renesas.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ptp: add debugfs support for IDT family of
 timing devices
Message-ID: <20200711183839.GA26032@hoboy>
References: <1594395685-25199-1-git-send-email-min.li.xe@renesas.com>
 <20200710135844.58d76d44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200711134601.GD20443@hoboy>
 <20200711163806.GM1014141@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200711163806.GM1014141@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 06:38:06PM +0200, Andrew Lunn wrote:
> But configuration does not belong in debugfs. It would be good to
> explain what is being configured by these parameters, then we can
> maybe make a suggestion about the correct API to use.

Can we at least enumerate the possibilities?

- driver specific char device
- private ioctls
- debugfs

What else?

My understanding is that debugfs is the preferred place for this kind
of thing.  Of course nobody expects any kind of stable ABI for this,
and so that is a non-issue IHMO.

Thanks,
Richard
