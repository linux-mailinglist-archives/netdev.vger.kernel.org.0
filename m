Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44CC08034C
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 01:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392560AbfHBX5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 19:57:47 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:45249 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390665AbfHBX5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 19:57:47 -0400
Received: by mail-io1-f43.google.com with SMTP id g20so155813355ioc.12
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 16:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=IyB81Se4dKyJSSicBG3IYFczW8MttGqWuRza0oPcY1c=;
        b=iQDE1Skg3USOzYbpoxeGOnWgi3eAMJTgn0i5Q3wOGG9zqeQXR8DpJjeibWmtkn4/jB
         LjMNLE+3OlZ92gYKSQNyhO01ZKTMvfrurPZfd4OZ+8eGZwAiwbLXHKw3JDf3kun4nwPd
         Ro1ddXY6wRkYUF08dp6x/16gSFC1dbphhddRj0uQtLnDsGsc5nEugwhUsbcaoJ22QT2z
         lMISjZNHMi+o3YuMbtyPhkWrTlLi7RMrgDuC9bnfpGowEioqrtFOxBT2638lUvWLLo7a
         3MiDPJtQ1FISAmn0hlhNgKCzP8Zbig8JRx+EjSkq+r8yVu2ie1hQZmvvcGh9+j8zAuPC
         TfUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=IyB81Se4dKyJSSicBG3IYFczW8MttGqWuRza0oPcY1c=;
        b=QmcgzClLPMCd1oLe0z0G2FJRP2R6y9z+btErNplgdaiOf/T4skhZVJKmCheTprThoY
         be3EMqR8NLIdHcUUsrGNlnYlW2sy5NtcnZbZ7E7i/BafIiZl1pEocTZ/cYk836DDrSrT
         25S67UnBj0e5IqtaI1GA8BcgXxrAgwbL5niY4avT4/+BYr7EW2dBH05zi39eBBTlvpzu
         h/yuneZa2VDwHSgmLkmecp4D3EDMXFqutFlTyqPHw8/94RUz2tFxPQi/hv/dqgsshnxv
         4SrPHHTYBzpk4R4E7yMuxz5jfOOZ5EdcwE3Zmf5V3lY1Mzl0wu0ZcGKBTlY8WrGMoWvR
         MFSQ==
X-Gm-Message-State: APjAAAWQwItFGM5HVVI3pQG4q+EOGIwwTsXxlv7JxkqJ4yW4OkU1m8wl
        4wl8ajU/amgigHgbXr7GjEw=
X-Google-Smtp-Source: APXvYqw8cOxGE9c9Eh8m/1R0Ysf+T111NyGpEvetUCkJTDb5jQezYRCt4qqoMJsrUdcqm+6OI7CI6w==
X-Received: by 2002:a02:7a5c:: with SMTP id z28mr3361392jad.40.1564790266110;
        Fri, 02 Aug 2019 16:57:46 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s10sm162796568iod.46.2019.08.02.16.57.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 16:57:45 -0700 (PDT)
Date:   Fri, 02 Aug 2019 16:57:37 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        edumazet@google.com, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Message-ID: <5d44cdf18a373_1f402ac0e21045b4e2@john-XPS-13-9370.notmuch>
In-Reply-To: <20190801213602.19634-1-jakub.kicinski@netronome.com>
References: <20190801213602.19634-1-jakub.kicinski@netronome.com>
Subject: RE: [PATCH net 1/2] net/tls: partially revert fix transition through
 disconnect with close
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> Looks like we were slightly overzealous with the shutdown()
> cleanup. Even though the sock->sk_state can reach CLOSED again,
> socket->state will not got back to SS_UNCONNECTED once
> connections is ESTABLISHED. Meaning we will see EISCONN if
> we try to reconnect, and EINVAL if we try to listen.
> 
> Only listen sockets can be shutdown() and reused, but since
> ESTABLISHED sockets can never be re-connected() or used for
> listen() we don't need to try to clean up the ULP state early.
> 
> Fixes: 32857cf57f92 ("net/tls: fix transition through disconnect with close")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---

Thanks Jakub this looks reasonable to me I'm going to run some tests
with sockmap + ktls on it this weekend to be sure the two work
together with some of our applications. I believe the original
series should be enough so that BPF can be safely unloaded out
from underneath ktls now.

I guess we could do something similar on the sockmap side but I
do want to loosen the restrictions there at some point so might
be best just to keep it as is.

Thanks,
John
