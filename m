Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C3C36A668
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 11:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhDYJ51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 05:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhDYJ50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 05:57:26 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB3DC061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 02:56:47 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j5so51802296wrn.4
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 02:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flodin-me.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LpEneUQUuKYLL+bMl+mBYvXtYXwOrE7cfnqn3TgcuTA=;
        b=gNvEtBwalKMNDxGaOQDpOVetAsU6hNibw9wdJFHzdn+UP6X1WX/2//CJj3YjAaQNLq
         7tEq4FYWNmKsWYXdlIsB8FzwXBl5cUZTx3tyml35Yo9q9yiDoT3bkXjlBN8+60/b4KZj
         S0dGamXQmbQeuruH3xaPDSs9koySl+r1Mo8W1Lq79p3yKgD5fpDfarmjJBiIFCs9ZC+D
         EWSWS0K+YQGhT6jk+BDCdsYWzyfrfVGNK2fxmorhVPpU5GIqEzoQX9UebmOcYlpFoqoj
         cshkTKTbYl9gDILSpWAi/CDsVwfJ+y/inwEO8ab5YCe3EO8cyjQeR9IoNp1WMXPCth46
         i30g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LpEneUQUuKYLL+bMl+mBYvXtYXwOrE7cfnqn3TgcuTA=;
        b=i6hLKfKzYfa6iGbQkNTN9r2MbtVK1Co210u5edB9SNioMR+ZzUPJNMRj8nVnRnVXf4
         RxyfbsDqofyyjbAYhOgroG1LVs3tiHQu9gY1NQhAHpcA0S8IkU9+OYmhmGfPRKiD7Sag
         LTt5dk1yqUehCYVLfPzAWIPsb3f+4TbHHOvb3X18+wqwrtCuGIdwqHUHR5XAQcAInND5
         FzbmDILnuZsLPm0ngOK3qpX3fmkELzf8ZCxBIxUvjdSC9cIJ8LBpEjwWy/VfmuTAmFZB
         /kOfpGfi2ZOBw8RvCsbdteWREEPbewNuJFQsN3MiAQ5ghhyFCLZWgJxjD1rSLqgtPiRH
         lIFQ==
X-Gm-Message-State: AOAM531qGDYaHcAN0n7nJ18J8YTRG1SpZdFOLQzwb/GJEAA+zAvkFknG
        kLc30tfv2KMCep94aOc198gxOqe6hZC7I85ryFMjPvC54oH1pA==
X-Google-Smtp-Source: ABdhPJz04fLCEZLYCV5+ZcH+V8F7prRVP5w5jR900dtPXUm+drMpzfL1xdjkdaH+HqH8r0LChfYCczlPLm/uMIYJTqg=
X-Received: by 2002:a5d:524e:: with SMTP id k14mr15722421wrc.282.1619344605885;
 Sun, 25 Apr 2021 02:56:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210425084950.171529-1-erik@flodin.me> <20210425090751.2jqj4yqx5ztyqhvg@pengutronix.de>
In-Reply-To: <20210425090751.2jqj4yqx5ztyqhvg@pengutronix.de>
From:   Erik Flodin <erik@flodin.me>
Date:   Sun, 25 Apr 2021 11:56:34 +0200
Message-ID: <CAAMKmoefuC4TXAD5JWW71PUWTauadGVkeAqdS87W3cqbHLV0AA@mail.gmail.com>
Subject: Re: [PATCH] can: fix proc/can/net/rcvlist_* header alignment on
 64-bit system
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, 25 Apr 2021 at 11:07, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> the subject is not 100% correct, actually it is /proc/net/can/rcvlist_*

Good catch. That was sloppy of me...

> nitpick:
> For printed strings it's better to have them in a single line, so that
> grepping for them is easier.

I wasn't sure if I should keep the existing layout or change it since
the include %s probably makes it hard(er) to grep anyway. But I've
changed it in the fixed patch.

Thanks for your comments!

// Erik
