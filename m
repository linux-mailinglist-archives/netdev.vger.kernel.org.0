Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA272B2D5D
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 14:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgKNNk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 08:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgKNNk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 08:40:27 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDC4C0613D1;
        Sat, 14 Nov 2020 05:40:27 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id ec16so6433675qvb.0;
        Sat, 14 Nov 2020 05:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9K0qlGohtYrzGXfDLR3np6ZBzIoRLGm123LeS5ehB6o=;
        b=QBWPShZf9o/9p/OI9MORZhNDz7QjfEwWxlxR0VE4WJqHQkZqJ52hpOZ3xvh4LtTbWH
         LEo9kxSrMR/tPpMUI3NtzxnLWzQiylgnh6SXecCE9fv2eyTHEnwDpETQ7TjCjTID/nT/
         2b1238j8yF2cbv53Xr89Q3xl42pHupKVB2mXBzWOPYtNi6ytnXC6I/LBsz0x19pekv5m
         FEtTUqEPgtCPegMz/R9qTQYwVUyZjXhsdeXU0zX3Dvewi5j/guy0Tz6eyMwdmoUWeUi4
         UG+j1vmyhjkWCZwfLhGF2K43IKlPYLZ7klmD7Vxq5aP+AdRqSNmnVz7/6yonAgABQOKZ
         ZHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9K0qlGohtYrzGXfDLR3np6ZBzIoRLGm123LeS5ehB6o=;
        b=jxRPG09yKONTGd30rNtA2JMSASBgOIqrY2JiALo4nQcZOkfBGq0V7xV1N0TUtLx/dA
         Tnnp+bmpIUAEOMRjD2S3w275rWMMUR+LFSYLlGsN49dMwuObQB+VTbkARb6KF+Ou9Qzt
         hxHrS/uzndZmcMZbJKfrEK2domzKZqYI/3S6ag2aIuO2/xgshorf0ZDFDqrUbAG4O0f1
         q1T1Cq88aqqcH8IixlFo5KU0SfT3EwGIEllgDZgK9v/76NVKvARHNxdfyh9HpwKSmt4a
         gcc6NDPIoaaiSC/lZ3TVcv1+PBOigGV4QyCRhvN232YXxUAKcj2xg5CJYJtfVnN5kksb
         gA0w==
X-Gm-Message-State: AOAM532hYyjvW//M0UpkLEk5erQV7+Xd0Lw40hEmEQJDSgWj66a8Jzyo
        E/DoSwpYa6/zepMksDoKOig=
X-Google-Smtp-Source: ABdhPJwRlEjk6BczF8iJ+hS1vxb9j8/g7ms5U1aFtwLtZ692wHZ0SJEldQYSpwV3Dyl8LTPUmPA0tg==
X-Received: by 2002:ad4:5685:: with SMTP id bc5mr7411960qvb.48.1605361226317;
        Sat, 14 Nov 2020 05:40:26 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:9364:c85c:d058:8418:f787])
        by smtp.gmail.com with ESMTPSA id q20sm8669951qtn.80.2020.11.14.05.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 05:40:25 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 431F7C2B35; Sat, 14 Nov 2020 10:40:23 -0300 (-03)
Date:   Sat, 14 Nov 2020 10:40:23 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCHv2 net] sctp: change to hold/put transport for
 proto_unreach_timer
Message-ID: <20201114134023.GC3556@localhost.localdomain>
References: <102788809b554958b13b95d33440f5448113b8d6.1605331373.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <102788809b554958b13b95d33440f5448113b8d6.1605331373.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 01:22:53PM +0800, Xin Long wrote:
> A call trace was found in Hangbin's Codenomicon testing with debug kernel:
> 
...
> 
> So fix it by holding/putting transport instead for proto_unreach_timer
> in transport, just like other timers in transport.
> 
> v1->v2:
>   - Also use sctp_transport_put() for the "out_unlock:" path in
>     sctp_generate_proto_unreach_event(), as Marcelo noticed.
> 
> Fixes: 50b5d6ad6382 ("sctp: Fix a race between ICMP protocol unreachable and connect()")
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
