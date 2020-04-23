Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220B21B51A0
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 03:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgDWBJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 21:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725846AbgDWBJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 21:09:35 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7795EC03C1AA;
        Wed, 22 Apr 2020 18:09:35 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id 71so3514132qtc.12;
        Wed, 22 Apr 2020 18:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=0Nc9PAcfnsQWfMgAPc1Kh3y6RAHuZsLbh688NoIbbaw=;
        b=BUQPQREXXFy4AHFMGqfkUD0nw1lCNFM/8zeMJegLdGuDWskwiYY7VYrvN2RW4Q+4mZ
         rWLhQtHLNfPWF2fufWZgZSkdJ2GYubNg/rrwRRcLd3bIeBXAzgxFC3RnLMhjWPAlrXxI
         ksDHGKBzwZRAxZAFvUHxsuWIoHTt80y21AxgJP5dAF5BM6lJrhSs9twYZsgBhxizfZ3u
         C8rq3LuGfxlN6cu9zyVfH8qCQwWG5M2yvqR+7Mfql/6p6VCG8Lnf+TbL9GSLgRhkjNOb
         CF4Gu4JmGM89i6pDfX8a6Vn77LebhZbfMrhTcKGRwIKu6f3JqZrsQZVUrhtVaWjPt5qt
         A6hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=0Nc9PAcfnsQWfMgAPc1Kh3y6RAHuZsLbh688NoIbbaw=;
        b=cpnl5P7ok9+wacSjYGF2tfwkBZbb4keZzkMZbmOQWezfB+OiFwFO9yHMDq40TNzvDo
         S45b3y1x58r/dNsCcWacz2wSgWJZtmBRHWFcrO2bIm0H2iosvPnZX2IQHFIYoDJAN20E
         5Na5YX8qHHb1dM9kIDWnBlsM+ij4U3TQb/4ZvBFQjp6yruSK29H2VpbN2641+Ot3PUMQ
         kfLb4xnzKeVJsRUxNXt/nPVn3gO6jLAb2q2Ia6Et0Ri14vAkUvP1A5eNmsXcXbgg4m7u
         hpO3n5g2I5+0FhdkkcZ/73fvz5+u7SPXg0T2S7Xtql3wKS7KZQYt0DGWy2wuCjxUCdMm
         /EFg==
X-Gm-Message-State: AGi0PuaS8O6Cw3MyLuu2p1HpGXseFDfqxjhsPDFTsHt5ES+9AhBy0yPe
        UGBCRqj6Fyo0cJykG29sNE4=
X-Google-Smtp-Source: APiQypL3jV3A+0fxethquJQXyQbdIrPOwGjBjrq5ln/hteFh1B9qFGmxwURfZ9LBhtR5JJPGU0Wl8Q==
X-Received: by 2002:ac8:4e2c:: with SMTP id d12mr1587841qtw.204.1587604174688;
        Wed, 22 Apr 2020 18:09:34 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:6408:158f:9d03:3b46:2548])
        by smtp.gmail.com with ESMTPSA id n67sm625966qke.88.2020.04.22.18.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 18:09:33 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 1076DC1D6B; Wed, 22 Apr 2020 22:09:31 -0300 (-03)
Date:   Wed, 22 Apr 2020 22:09:31 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jere =?iso-8859-1?Q?Lepp=E4nen?= <jere.leppanen@nokia.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH net 2/2] sctp: Fix SHUTDOWN CTSN Ack in the peer restart
 case
Message-ID: <20200423010931.GC2688@localhost.localdomain>
References: <20200421190342.548226-1-jere.leppanen@nokia.com>
 <20200421190342.548226-3-jere.leppanen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200421190342.548226-3-jere.leppanen@nokia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 10:03:42PM +0300, Jere Leppänen wrote:
> When starting shutdown in sctp_sf_do_dupcook_a(), get the value for
> SHUTDOWN Cumulative TSN Ack from the new association, which is
> reconstructed from the cookie, instead of the old association, which
> the peer doesn't have anymore.
> 
> Otherwise the SHUTDOWN is either ignored or replied to with an ABORT
> by the peer because CTSN Ack doesn't match the peer's Initial TSN.
> 
> Fixes: bdf6fa52f01b ("sctp: handle association restarts when the socket is closed.")
> Signed-off-by: Jere Leppänen <jere.leppanen@nokia.com>

Nice patches. Thanks.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
