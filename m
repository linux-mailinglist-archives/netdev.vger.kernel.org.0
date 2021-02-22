Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C78B3216B9
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhBVMbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhBVMbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 07:31:05 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66929C06178B
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 04:30:20 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id v14so18872761wro.7
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 04:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=+5FjT6BL7TWtnWBbuxvQGk5iDW/ARvKk9CGt0Yit98Y=;
        b=wrReV27Wqu6HXTC9oAAnYexAtiYwCj3WMVZ6Hyc3pXTqXtGiAgQTT7vSJ9vndvb7wV
         VWFa0q6pBDO+94Rl+7Cu87UY2xXtI16qjMq/2eotMXKbQm5bGw3fWCfVvma3ejg6R+qd
         eac2zqpbv+h3WuDZZ6XknRCXMxru7CTvdyiKo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=+5FjT6BL7TWtnWBbuxvQGk5iDW/ARvKk9CGt0Yit98Y=;
        b=cxaaXuaNeDuePT/88doDQZPZSachQnbVdkjRJYJBxUCHPUMtp1sI+Gjb+esIaKY7+l
         ay/wTd+YQPxfRkiGH/M1UBQsx96519UI0vMGFOFuAOSRNTQKLCeQ986DxjeQGtZ1kR/d
         Gph7YCqKaJuDJZWZH0yPQSdfsYHO4KeTxI0A9CpKhzvhLzQQY2J57o6BnirhRkSDDqS4
         RCQSrkGiN7BB3h4lJDEnWO9YjjDTNIJUH3pl9gty15jfWVaH6X5m5hUb6g6mmtrecMph
         hAVL7stMr6wweeielnMvmYNRZAYRa9w1hNQanQfLpK/umIHEWfEIXtt5stfq+QcHEXgv
         kbwA==
X-Gm-Message-State: AOAM5338TQfosb2RP1DOtuXo/ilY91VU4wNxaXoVkKhSfr+UtvtCaYgw
        5PmQjDvj5PrnLm0dk6Po0A2MTQ==
X-Google-Smtp-Source: ABdhPJy72fKE18mEee454FQSixKBimcXNLyUVC670NZGVJBf2ppuHgISlUREGmeKVtEiAIBE3ZPG4A==
X-Received: by 2002:adf:cd0b:: with SMTP id w11mr3588014wrm.86.1613997019207;
        Mon, 22 Feb 2021 04:30:19 -0800 (PST)
Received: from cloudflare.com (79.184.34.53.ipv4.supernova.orange.pl. [79.184.34.53])
        by smtp.gmail.com with ESMTPSA id t16sm10494577wrq.53.2021.02.22.04.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 04:30:18 -0800 (PST)
References: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
 <20210220052924.106599-8-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [Patch bpf-next v6 7/8] skmsg: make
 __sk_psock_purge_ingress_msg() static
In-reply-to: <20210220052924.106599-8-xiyou.wangcong@gmail.com>
Date:   Mon, 22 Feb 2021 13:30:17 +0100
Message-ID: <87a6rw4752.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 06:29 AM CET, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> It is only used within skmsg.c so can become static.
>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
