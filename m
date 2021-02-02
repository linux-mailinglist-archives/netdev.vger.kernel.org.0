Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C34C30C58C
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbhBBQZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:25:37 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:38524 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236320AbhBBQXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 11:23:25 -0500
Received: by mail-wr1-f53.google.com with SMTP id b3so2979933wrj.5;
        Tue, 02 Feb 2021 08:23:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0Tl/pMxs9MIy87xsuWIVEOhHXa7tZ9dZIJ0KCeGa4jI=;
        b=fMy85NFgtbjalzT7DedynCqERL/6JDmbAIsO27jM4cpJn6X5QrTtuAMwcbYoexAoT6
         GxVpama5x1SrodeLurAKRCGrmd7+KAdb0pfnuychTpyiFphLSHaWZRhVcfpreCfJRrl8
         Z9UkuogsKzsxlrbq6wqf3XtrudfnL4Hq3cAWGdNcytkCRwQrU0Uq/Q9zU2QBONnAyvns
         c45TQWzOfTVGh39E2FgyKe9iIh+HJaUE03FjCVg/QcsMJDn0nf4t53LgFAoB6Qg+jL+C
         giWpcsNUsen3mX8q2JH5LLIKtVv4EUIxbatJRS6T4TFuBRQZVEk5XYe5b1NF7lr9OuyI
         P++A==
X-Gm-Message-State: AOAM5328KMKzBjudSuWtiUtUzwjJY1SGzK4FvEjPoxORM5ybhAbuTunt
        4a14K7SXdN2FXimpyblDlZ4=
X-Google-Smtp-Source: ABdhPJx6LQHNUFui3giapOyyc5YGOC6dtOEQkMgOyDblBANYn5obn77kkqsoELxUiLKfWRiM9E+4kA==
X-Received: by 2002:adf:dd43:: with SMTP id u3mr25063060wrm.396.1612282956206;
        Tue, 02 Feb 2021 08:22:36 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id e11sm32813367wrt.35.2021.02.02.08.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 08:22:35 -0800 (PST)
Date:   Tue, 2 Feb 2021 16:22:34 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Druzhinin <igor.druzhinin@citrix.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] xen/netback: avoid race in
 xenvif_rx_ring_slots_available()
Message-ID: <20210202162234.sf575hwoj4bngvpt@liuwe-devbox-debian-v2>
References: <20210202070938.7863-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202070938.7863-1-jgross@suse.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 08:09:38AM +0100, Juergen Gross wrote:
> Since commit 23025393dbeb3b8b3 ("xen/netback: use lateeoi irq binding")
> xenvif_rx_ring_slots_available() is no longer called only from the rx
> queue kernel thread, so it needs to access the rx queue with the
> associated queue held.
> 
> Reported-by: Igor Druzhinin <igor.druzhinin@citrix.com>
> Fixes: 23025393dbeb3b8b3 ("xen/netback: use lateeoi irq binding")
> Cc: stable@vger.kernel.org
> Signed-off-by: Juergen Gross <jgross@suse.com>

Acked-by: Wei Liu <wl@xen.org>
