Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C438A34D86C
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 21:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhC2Tlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 15:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbhC2Tls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 15:41:48 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FE7C061574;
        Mon, 29 Mar 2021 12:41:47 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id j26so13946474iog.13;
        Mon, 29 Mar 2021 12:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=LZkRo4em2lEC1LuvHKXmIJPlxn15qXzVBruE0eBJksQ=;
        b=XTMppQsFGEDyl2qfTSb2W0O3glqwhjteOisxR4mZiO25u+tDfkrkZ6tE3+bKaspFML
         19O/rsaXDqoIRu1oPNEcAuAXgSXZnKCZpM/Y56GrdOlWVElXIDt7tRXrDFYe/ABmz3lr
         L/TyXBPcWDEVg6LPAVAWxwOkWTonKV70S1Qki/24GU4SXHFO9cOrkSxwuzaU//FVVe/M
         irBXPIr1JVNlC/uG/6LTETxGDgAHZq1sVasFrjBrzzR2LRfY/EHqwQKu5OdHj6fvXE3e
         Y4M8Bk/lWigxsZacoOju4UF7m4KbFKhngWwrGJD8oV1Wdw6vwxJ2y0w85jcvJ/BwkTGM
         ULAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=LZkRo4em2lEC1LuvHKXmIJPlxn15qXzVBruE0eBJksQ=;
        b=hBfZmPoFYYOoUWb1rIRWQbzXq5+Dba8PjplajR9Cth3eU0G/LR+N/doZpfB9ARZer9
         DVbQgTjUCt+vhtF644LKUqCZP2X53odFdrP0Yf+JWhS6z5N2M/VWXYPlwNntPxRv6ZLw
         h0qGCH0Td8/udUOAW6zf4/exqX35zAE5itb45LIEi28wFw2iNgLsXy9BAxwLxvobH58P
         1Fv5nwKTMUOKKnmr9hHidYaPXj8+z3SuPvD6AvYGaSQ23UcK81lJBRKab8HDLlr1Uuhr
         lxW10blHuydIF22oBYSDg4irRMUyTsqDdwmJ8hKw8nuq9aIYvkwzLzHMCswvuGH+vuUe
         ejWQ==
X-Gm-Message-State: AOAM533EWXz3YEp23esgXPNyIpQppbCwo6uydoPmHfmxGW22GQhAfHof
        7J8RIfFS3KnATeeZLUn7k1E=
X-Google-Smtp-Source: ABdhPJy1hcIch7XwTiM/W4HB6UVX01BvBAulGKnRTUv7csC8rb9OpnWgbxw5ZgWInuCj4etO4WE+aA==
X-Received: by 2002:a05:6638:2726:: with SMTP id m38mr6889758jav.6.1617046907130;
        Mon, 29 Mar 2021 12:41:47 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id k125sm10015301iof.14.2021.03.29.12.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 12:41:46 -0700 (PDT)
Date:   Mon, 29 Mar 2021 12:41:39 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60622d735adf3_401fb208d0@john-XPS-13-9370.notmuch>
In-Reply-To: <20210328202013.29223-5-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
 <20210328202013.29223-5-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v7 04/13] skmsg: avoid lock_sock() in
 sk_psock_backlog()
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
> We do not have to lock the sock to avoid losing sk_socket,
> instead we can purge all the ingress queues when we close
> the socket. Sending or receiving packets after orphaning
> socket makes no sense.
> 
> We do purge these queues when psock refcnt reaches zero but
> here we want to purge them explicitly in sock_map_close().
> There are also some nasty race conditions on testing bit
> SK_PSOCK_TX_ENABLED and queuing/canceling the psock work,
> we can expand psock->ingress_lock a bit to protect them too.
> 
> As noticed by John, we still have to lock the psock->work,
> because the same work item could be running concurrently on
> different CPU's.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
