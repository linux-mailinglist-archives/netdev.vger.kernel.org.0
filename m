Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C294366E1
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhJUP5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhJUP5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 11:57:36 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583D2C061764;
        Thu, 21 Oct 2021 08:55:20 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id q13so2148443uaq.2;
        Thu, 21 Oct 2021 08:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HRHfFhz4fMPUx9YOtOao9Bpb9t5tjPxJMHEqRqglFwM=;
        b=D/HrhN/0LrDrsGRfgdFeR48W6kC4c+X4yDSCCgDvMY9Yfj+9RBHFpF8xdRSQNWWeFd
         ChlvcCLRdG6+AHyAxGQk/4Urb67IFT4Mqo/xOJvEW0jBCqbV8mGubGjEcpdQkw5saWMX
         0RyxJqfrpZwZWb0NxtD/1tSR8chgREekcK+cL82ldGb/Mn0wIKA3a2fVgATgIlPSTMvl
         Yk7N3lAB1FA0x0BMeeGeqI4X3gntqERs/5yqCE/uDddwEZ+rXA0fUZDjq+DAzSPRNX/f
         HoTskTjC3uh6iF00W5+CFFV9COkir+vZWCptrM3qPB43dWNhSw/9GD5loHcfHhbhKGZx
         KPfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HRHfFhz4fMPUx9YOtOao9Bpb9t5tjPxJMHEqRqglFwM=;
        b=Ffk4YTdIrTwD1d76vlR/87Wi2w7tLJjAqRGjMtsSFeXzPgiZCOjyI+h9MDkl3ZFSWL
         CkaaUtbmm1ndJVB/9Y6hwL3pQArNGMR8wr3GOsxBAMvwYGTftZwXtUSO/QBRAz6jWTbU
         22xxYob6fyBLRXwjDWJsSAsrNqzCAHvJTFh0hgYK188h5KGHfxXuJiG356/cPJOoDNVI
         gcTmlLCbyJQFk7iw+8wo+ikfbxwUR9hhbDxKrBfZeyfKNYGuD5OvC5qBGkOyqobDqy6r
         3l7dS4sUhmeiB/jlga4vDYtAXXOQx9+Ip/QlxNNZv2A/wh4Oz/gEeSfBIMz0Vchs+NDM
         Rmbw==
X-Gm-Message-State: AOAM531282/kYwYqzMlePJX7nLjIWVOg6VkIkdeXXg0E2d8o/MoqEf/P
        KQfeQ0PVX4dGwK/zNJ6OIbM=
X-Google-Smtp-Source: ABdhPJwyivgybU33oIRvY5+h4YNrbl1bvQ3Lb+fx0N0Gk+ezb51O3awZYpxI7qSBJLWqMSS11HA4Kg==
X-Received: by 2002:a05:6102:a4f:: with SMTP id i15mr6981375vss.49.1634831719443;
        Thu, 21 Oct 2021 08:55:19 -0700 (PDT)
Received: from t14s.localdomain ([2001:1284:f013:eca9:86b:fb8c:36a9:6a8f])
        by smtp.gmail.com with ESMTPSA id m184sm3296920vsc.6.2021.10.21.08.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 08:55:18 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 1AB9E91D02; Thu, 21 Oct 2021 12:55:17 -0300 (-03)
Date:   Thu, 21 Oct 2021 12:55:17 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Haines <richard_c_haines@btinternet.com>,
        Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH] sctp: initialize endpoint LSM labels also on the client
 side
Message-ID: <YXGNZTJPxL9Q/GHt@t14s.localdomain>
References: <20211021153846.745289-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021153846.745289-1-omosnace@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 05:38:46PM +0200, Ondrej Mosnacek wrote:
> The secid* fields in struct sctp_endpoint are used to initialize the
> labels of a peeloff socket created from the given association. Currently
> they are initialized properly when a new association is created on the
> server side (upon receiving an INIT packet), but not on the client side.

+Cc Xin
