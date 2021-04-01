Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F7F350EC9
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 08:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbhDAGCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 02:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbhDAGCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 02:02:40 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9DCC0613E6;
        Wed, 31 Mar 2021 23:02:40 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id 19so1150315ilj.2;
        Wed, 31 Mar 2021 23:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=HteIhZbIjuEuTNli338lqBwZmsNCD2KIvODa9OzqwxY=;
        b=lbSAKEseY1ERPlsr52NFL7DjK+gIN44auGXUvBbB6pRo023jPA/IUy84RvFgXJ/DMW
         WJCvyxXvUV2vU/zdyoAUL+lGtKSUeC7icKF82W7RSfLTSdGsCSdEL5F7YAgS+xwMCYRk
         HCBEP1aOEL1Bm150Tawq17aTR+01/3Agi6wt69m4CxYUSAcCD0QCWs5E/BCVJy36LdIR
         bc9re+nSEvRT+pGM6l8dQj/WRhw6le5Bsz77/jEFKtt4YMGwvg5mNCkslMy2WsT9ZKBZ
         5HNE5W4kIZJvLegaR/WBpBFfdhET7LRsklYcPXj9rYpTbdxi7uaoK9qZ3CGBPSY0SsEm
         jQKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=HteIhZbIjuEuTNli338lqBwZmsNCD2KIvODa9OzqwxY=;
        b=RghsNMmQgJOzQARvgpH3mTO5xtwIIueiz7j1/v/JA1sEwPb6aEkkqUIBmozpbN4jsu
         amc8xArA0waey2XfdUeLF4oHIbYifZtZEBhymKBPP5t+Cyq9dMZiuLXRh3te/KMRZEmm
         atmW1Hv5RocfLY3YQSWb8x+vaAPynQ7hysqSj3jh6+LnxWqZ6Je2wTi3tD7RhwcsI+Zg
         2BpCfMIfwmTVkqgSLTS268VH9NftJ4XLDA4a6KCBqTWIzFwXUDB/kn0gdQzjOxjyhu/Q
         WGTJuayzwN/6tkk0GekKrwHVHgmqjF2A0fEatR6izkOxol9ic/tFxGVAC380br0cypc2
         r2ng==
X-Gm-Message-State: AOAM532cFtbcdXMiKw9qZFpBY+k35jp2gYYgKEH+//A/WBwZ6bQQTBQY
        5RCrNQgj6kt5ilJiJgdbohE=
X-Google-Smtp-Source: ABdhPJx2mIvZufFqvpEcJY+1AVDN/Z1AbV+gKbUqRo7QdefVGYuhtiBKn/j/UZ2pnQV2HTgxB+SIog==
X-Received: by 2002:a92:dc83:: with SMTP id c3mr5619765iln.167.1617256959523;
        Wed, 31 Mar 2021 23:02:39 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id w1sm2214023iom.53.2021.03.31.23.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 23:02:39 -0700 (PDT)
Date:   Wed, 31 Mar 2021 23:02:31 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <606561f77d15e_938bb208d6@john-XPS-13-9370.notmuch>
In-Reply-To: <20210331023237.41094-15-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-15-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v8 14/16] sock_map: update sock type checks for
 UDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Now UDP supports sockmap and redirection, we can safely update
> the sock type checks for it accordingly.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/core/sock_map.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
Acked-by: John Fastabend <john.fastabend@gmail.com>
