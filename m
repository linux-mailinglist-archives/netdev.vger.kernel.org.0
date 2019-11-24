Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A307D10817D
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 03:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfKXCoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 21:44:21 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34288 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKXCoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 21:44:20 -0500
Received: by mail-pj1-f66.google.com with SMTP id bo14so4861322pjb.1
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 18:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=uSbEr+vhnRVppHeZqO76/gkPHgaCCiq0/m4Ia9qLGuM=;
        b=FwdFgM4aWBOE61JY1zLzibGzXN+gX+CqAjxfTq9aeaW5PrH+QPslmXMFJKbd87qpFk
         D7JNVtl4GVidu26ZYnJqUbhNbm9Dd4NkWJSetB9Nbk6Z+wyWeFq9YF3OlLzdiqARum+U
         yEKWuRfuXQVfBwriu1eqU1kxSPHV8ePvWcYAeNuueS/4oJblmWlc0y2K5qPf8VskDH/u
         tcpZcS99bfJabnMo45/YjLEVaqHQm+o8j51EWE/k9Op+7iU9yZ+KykLnfMevOs6iLubr
         owluzqwZfe77rRmm1pmc+Zr8YtGwMquw2rT7Q6awnV3YKPhQMOzzvpof5tTeXsfCAS8X
         B1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uSbEr+vhnRVppHeZqO76/gkPHgaCCiq0/m4Ia9qLGuM=;
        b=ZFck5puI9CMSSwC+N3N19Qpj1o1HY2/Hf8lY+iglBwfeYjs4uK71eyGKTu2G2S+y5I
         pMIDwq8wX8kGWBOO/wYFHjoAjOwsXASFth/MUHdxsNt5k5mBJXGvh9/tYNgPlYsf85oF
         fLD4GaK8X2PpC/HhKWZPU5NNG3zjwRi2UHB7WFApANwBz5A7uy6enkI1fqgTxa3+UhlD
         rjPmkBJ1p2YhjSaBARw1ywLlUVUC8x8V2gBXIhA5OQYgEkWy+OAoiWmgcu4Br9h1ASTl
         vEtobacci9ar4f/sr8CO+00rzGnBM4iMzM3teygliNNxX73EknRni0sLQ5TmPH8Sibw+
         J2pg==
X-Gm-Message-State: APjAAAWeWA2t871gn3rVW3L9WChneYhMBzH0ZhtsuUqfcAGbWfC36Gqi
        aNUp/eyFdYXnYaAL7Cpv/NW89w==
X-Google-Smtp-Source: APXvYqwMfHgA5rV5ZOiOUcicFeeVxfDJ7wYY9KmH6lop7UKE8nWEIWhS1PKfh3F1m0NnPerfgZO34g==
X-Received: by 2002:a17:902:8ec5:: with SMTP id x5mr18613869plo.201.1574563458444;
        Sat, 23 Nov 2019 18:44:18 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id n62sm3249514pjc.6.2019.11.23.18.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 18:44:18 -0800 (PST)
Date:   Sat, 23 Nov 2019 18:44:13 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] hv_netvsc: make recording RSS hash depend on
 feature flag
Message-ID: <20191123184413.3b179db4@cakuba.netronome.com>
In-Reply-To: <1574553017-87877-1-git-send-email-haiyangz@microsoft.com>
References: <1574553017-87877-1-git-send-email-haiyangz@microsoft.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 15:50:17 -0800, Haiyang Zhang wrote:
> From: Stephen Hemminger <sthemmin@microsoft.com>
> 
> The recording of RSS hash should be controlled by NETIF_F_RXHASH.
> 
> Fixes: 1fac7ca4e63b ("hv_netvsc: record hardware hash in skb")
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Applied, thank you!
