Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05DBD11F557
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 03:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfLOCFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 21:05:13 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41695 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbfLOCFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 21:05:13 -0500
Received: by mail-pg1-f194.google.com with SMTP id x8so1585074pgk.8
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 18:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NPJKZB/MZ31vp9CqIbB5orONwRixLLIIKcw2xgA7Dx4=;
        b=Dcxds5iXxttcM/C8VZ+0IuUluFLrfcuMHmB4f8l/K+VTzOaDu2oDFFXFu8M3vlF5As
         I75WU0pDiThlKZNHUkqOfdmFxBL+hIq0IJiWfthxOSWt+NBkfWglkRI81jclrA/ZgFJc
         wIcQocs1srWuuSZfY9U5rNtRwoaF16LknNseOg9SzBw8mJWM3Jwuvfn1ju+F3TpLSR75
         92QXWY1BfQ/eYh2EvF/5TsCeALe6Rr8k+pYnA1vzEvpPSioBZwKd8iIWvfuanVifk4CA
         W6ieDEYNnqkzt0el31drHeG26NdrL3Ebt66J0EjmFNcXe+0ejxtPukQZ27fXRBfY3QgL
         Y0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NPJKZB/MZ31vp9CqIbB5orONwRixLLIIKcw2xgA7Dx4=;
        b=mzMWTfmgBAF9o7PW7D/cHwgHnJrTZRPm8wob+bFwvC/mgoAz7Jt0KP/JoEIqUYgIGK
         u/68OAm3iOZYyrtKbpMAPVZfFpPAKGiwre2+FSyY2GGohgMKmrt6LkMqpyZ3xFvWU1Zn
         fY7v72n0vWjy+2AbNXOIcyhuI/DQEhcX3KRvGSbBcLX+okAUYZ6uNQsoBnuMvEnCCKDZ
         Gic9qtAdzOoMGPzdMgs2Y2FwgPiATTZK37QqqKxbsOFCxrV0ixNOoxtOMbpzD3Dsy3Wr
         7qsS0QQJxX/MUlqYUWQCHXzOQPGfTNYkP211KobOjM+7c6t2SYHzUplq96IetrWTwDxX
         ZV5Q==
X-Gm-Message-State: APjAAAV2WgShKAtLHahliLLvcEO/5FogZA6ftttpuVu29Xylk1dNnAOn
        bSvlqf1/OTrUbQ2KVcVo7ztz93EovRo=
X-Google-Smtp-Source: APXvYqwALjEw0IsJtNPSsz5Q/k1leTojLnnf3en/PFb2MzPTZAbcIz8NFj8OytyHdbnNsB2kikwc0Q==
X-Received: by 2002:a65:55cc:: with SMTP id k12mr9526368pgs.184.1576375512762;
        Sat, 14 Dec 2019 18:05:12 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id j18sm15617760pgk.1.2019.12.14.18.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 18:05:12 -0800 (PST)
Date:   Sat, 14 Dec 2019 18:05:09 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Willem de Bruijn <willemb@google.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH net-next] selftests/net: make so_txtime more robust to
 timer variance
Message-ID: <20191214180509.2dfd117d@cakuba.netronome.com>
In-Reply-To: <20191212163646.190982-1-willemdebruijn.kernel@gmail.com>
References: <20191212163646.190982-1-willemdebruijn.kernel@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 11:36:46 -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> The SO_TXTIME test depends on accurate timers. In some virtualized
> environments the test has been reported to be flaky. This is easily
> reproduced by disabling kvm acceleration in Qemu.
> 
> Allow greater variance in a run and retry to further reduce flakiness.
> 
> Observed errors are one of two kinds: either the packet arrives too
> early or late at recv(), or it was dropped in the qdisc itself and the
> recv() call times out.
> 
> In the latter case, the qdisc queues a notification to the error
> queue of the send socket. Also explicitly report this cause.
> 
> Link: https://lore.kernel.org/netdev/CA+FuTSdYOnJCsGuj43xwV1jxvYsaoa_LzHQF9qMyhrkLrivxKw@mail.gmail.com
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied, thank you!
