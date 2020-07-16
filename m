Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F0F222DA7
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgGPVS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgGPVS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 17:18:58 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B96C061755;
        Thu, 16 Jul 2020 14:18:58 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id k17so4722370lfg.3;
        Thu, 16 Jul 2020 14:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=FJ3bW/4MDplVqCGVWSq/Y4HTWcLjazCOxA2VaAymdio=;
        b=tLibSqDixVLggiT3a5OEyl/yqOUjhTW3gev2IISxArAok+qzQagmcK40ICetTX/JsF
         pWKvcs/Boas7uA0vEFBQWFR98U6cMFrQkcr7rEV+D+OSeG812R96mLerKlXtpuDVBPbT
         fQCI9QIuFT1/ctJdTqT7S8yTb0pBRMgpEKc94HhUlpZOmtAJRbcmMO1yC6kUWuu5/7mQ
         cMQaN0eIY+4bHK68yRKFCx7g+dDq1KGMzJ6DC+U6c2ahU7cviE967FgMABZIiVOy+WJ+
         majaZjoEa3i21JrpzGoXOMy6nR5IlsHmOWCBlor3T/xH7BfwaeU9JC4kXQQnq6NWLz0d
         ZWLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=FJ3bW/4MDplVqCGVWSq/Y4HTWcLjazCOxA2VaAymdio=;
        b=RH1b6KoXEMctZxdYEiq+D18ETwF7IEHzPxithqEpezAcez2p3yjIOfUTILrKKd+0ph
         jdyKQuuhadQ+9xh3kBzdGdEbt1YjaGFS8oiGuce6bcnRPT4CX9YWTGVuRZf/kR0Hp+Bv
         ltacbbTb1zQyl1Rux7Nij+kCj8Ib/AnfyYjBxf5ACk4BEM6VV/gXy08QazteyGKL40Ui
         Ts8G0YY5dL+JdNbiHwjGxyVuj5JtKg8ZeY0UlVGxMWOFyASCatJx5tIIJzIlmosOUgAE
         RHtAPkBz9PBFruQAkGB+Q1zARsMksJadkXEGUE7qediybMLT2KAijvVFcZvlHC3WhRmr
         RY6w==
X-Gm-Message-State: AOAM532IA+yrkXfPA81sckTpKTwdzf2sV9Frgp3Am5k9IEkIcbdqQA0I
        U3uaoLE2/E11qjUGDVQL35U=
X-Google-Smtp-Source: ABdhPJw9l3DlJWTKFiEKS7TvlzylVC4K8ePaVh2ivhyQrRffemw7utu2lIUAIrEiZLLKRnZ2sza0rA==
X-Received: by 2002:ac2:4557:: with SMTP id j23mr3179716lfm.124.1594934336863;
        Thu, 16 Jul 2020 14:18:56 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id w15sm1421647lff.25.2020.07.16.14.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 14:18:56 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 net] net: fec: fix hardware time stamping by external
 devices
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200714162802.11926-1-sorganov@gmail.com>
        <20200716112432.127b9d99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87a6zz9owa.fsf@osv.gnss.ru>
        <20200716140602.2a23530b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Fri, 17 Jul 2020 00:18:55 +0300
In-Reply-To: <20200716140602.2a23530b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Thu, 16 Jul 2020 14:06:02 -0700")
Message-ID: <87blkf88g0.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 16 Jul 2020 23:38:13 +0300 Sergey Organov wrote:
>> > Applied, and added to the stable queue, thanks!  
>> 
>> Thanks, and I've also got a no-brainer patch that lets this bug fix
>> compile as-is with older kernels, where there were no phy_has_hwtstamp()
>> function. Dunno how to properly handle this. Here is the patch (on
>> top of v4.9.146), just in case:
>
> I see, I'll only add it to 5.7. By default we backport net fixes to
> the two most recent releases, anyway. Could you send a patch that will 
> work on 4.4 or 4.9 - 5.4 to Greg yourself once this hits Linus's tree
> in a week or two?

Sure. Hopefully I get it right that I'll need to send it to Greg as a
backport of this one to older kernel trees.

Thanks,
-- Sergey
