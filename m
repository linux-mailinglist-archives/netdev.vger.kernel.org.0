Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB26B231B1C
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 10:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgG2IVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 04:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgG2IVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 04:21:33 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3ECDC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 01:21:31 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f18so20744131wrs.0
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 01:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6T88XFHoZwdWNsG0U6QQMdTCzN7l6GijNyTjBnRKzIM=;
        b=pazJ7rsfIt4mv4lkXVBNaxT4vr7c797y0zfzpipeuXgWr8mStz/bjgqWbS6O0fs8dH
         +bgwJOtxYYvSkzQnc/hXSAegpEHud/UMnMvLk9SOgcEkh0iX6/QaPqCXevnDNAHr9kmR
         vanM6GslgIzv2kSQ9z83jXK9ffg6I1PCKvOetI+rakfFE4929eZEOouu+hpztUQtEu3V
         dA5Z6GsCzW0BZNvHh34erSnNabwQXIvQVWgQnmiIxkPgJX+h1NR+n1rHMYS8uDTh10nQ
         pjLK0IHNt6cZC18FYY9nbq0GP8nk6+kk0ih3ki4gSGPI19BxFLjTfRkFqo0ahEbm5XXg
         tiEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6T88XFHoZwdWNsG0U6QQMdTCzN7l6GijNyTjBnRKzIM=;
        b=qY88zNipDWIyxxIjlHLE3YdQRBtk+hF1REkJr29LS1jxHyjfx3rW7lpPKECfRH4jwf
         Q+HRoMDzUYr23wdxxLjdtVp/1INxbhEbtX2w7XUNZHrL0aq+vhJ0YiTSeNFd11YoGVLN
         2SaY68D9F6LHv4wzsrWtu/ORmdCkgs9v+LeYjGQl0qZVmzGdSPgRmI4P1NlQeOcKDbq7
         69wSErCXZuwtW18wuWwEdQ7ppbEGzQbw/7ZPEWbyI36v7C3AbEpfvMgu/lbtw8BWVNxm
         tQjVsGJK3k2BnB4lPM91Tmwd5ueiz670NF9WCfNPYbEChSG38p4c1WE1w1dDIq19Xg/I
         vniQ==
X-Gm-Message-State: AOAM531BRylfOD4drNRvCAaf2v8Ri7wCjaTQmnSQe5CkneeOdL/GcH2y
        xk85+j18Glb4x0lsIXyG96C1nw==
X-Google-Smtp-Source: ABdhPJzLK30A7nRk1zbebASvAWR0eRDz/wmb9O/kVmuOVpo+P4fnLv6g3rkNyifb8Xs1CPQI5KT2rw==
X-Received: by 2002:adf:fb87:: with SMTP id a7mr28702596wrr.390.1596010890488;
        Wed, 29 Jul 2020 01:21:30 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g16sm3650100wrs.88.2020.07.29.01.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 01:21:29 -0700 (PDT)
Date:   Wed, 29 Jul 2020 10:21:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@mellanox.com, kernel-team@fb.com
Subject: Re: [PATCH net] devlink: ignore -EOPNOTSUPP errors on dumpit
Message-ID: <20200729082129.GA2204@nanopsycho>
References: <20200728231507.426387-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728231507.426387-1-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 29, 2020 at 01:15:07AM CEST, kuba@kernel.org wrote:
>Number of .dumpit functions try to ignore -EOPNOTSUPP errors.
>Recent change missed that, and started reporting all errors
>but -EMSGSIZE back from dumps. This leads to situation like
>this:
>
>$ devlink dev info
>devlink answers: Operation not supported
>
>Dump should not report an error just because the last device
>to be queried could not provide an answer.
>
>To fix this and avoid similar confusion make sure we clear
>err properly, and not leave it set to an error if we don't
>terminate the iteration.
>
>Fixes: c62c2cfb801b ("net: devlink: don't ignore errors during dumpit")
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Yeah, that makes perfect sense. Thanks for the fix Kuba!

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
