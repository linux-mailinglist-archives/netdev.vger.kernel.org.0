Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DBF34D874
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 21:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhC2Tna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 15:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbhC2TnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 15:43:02 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20940C061574;
        Mon, 29 Mar 2021 12:43:02 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id b10so13991853iot.4;
        Mon, 29 Mar 2021 12:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=wA2YuNzDUhga5b8IX3g26MHDlIF6Z9LUEmxeasAuI8I=;
        b=T191qq+vz7KoItZcnceS+H1oKsFaOcSgpOUeCAfCAnLqZLuOuFTLrUx63MSyLa6dRO
         n+UWU4CahU87xz+A5qmO4BpBO7FSXMWTA0IEYzKNUokKQgsFbsUwS6eis2VuAMWZ/XJs
         PqhxGeQgVRsz4gNBr7Ibf9wr+znFXy94o12JVOTyvdeumpH/YM4GCBbrCMO+7snjmBxR
         acPNER9IoH9e23gMlETI96RWjk0HdWyYS+bmkGa2xrlqHAb9LMsel5ctLOScBJVN/nNu
         1Sk9ZePq98uxlYFH8XWsdf9FEyA4lXQJZjMMrnwwjbTgUidsTAon9uNlkdsLA5bVnotM
         Hc9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=wA2YuNzDUhga5b8IX3g26MHDlIF6Z9LUEmxeasAuI8I=;
        b=hVmeAm0OmJNUSrzBIkFMbzZugF9XqGuxNIfOcRIr0gX+ZaGpBxb8haRWh9Eo79pqaG
         c3DTN2XSluicW6/e1hJSNkyLEOGBoklGZpe4G5hNhX++FyWMWNwwPIzKWgxkSwE/SWVj
         LWkltJDn3+ApIqd8X9zLWFGdLsCjR/X7GaW6/w+pirOpS2Ur/4xhlonsEr0FN+FX7TnM
         6hjwf59R4Cpypq4XXGO7Tu8X5wdIbxXu3UFeXHa/gSILhTdPEtuuhgX8v/cP8xYTzXyH
         td+jAm81oYkbXUH8r+qWZ8jhhpzSlyg3CFjgL1zgtjQ5Y0I6xBaVel2XswwbJSSI90ZI
         99dg==
X-Gm-Message-State: AOAM530kr8YxrJkDNNTaZxAWPUsrlg0ewiycXDk1X5kl0Fu5cqNkdBE7
        6FrT9ZUk+gNNQju1U5aTUOM=
X-Google-Smtp-Source: ABdhPJzUGs5baSipetGbndx7cp/Z7NfzD926omDzGI/+ibiiRxktxNk8hwEQx5Hflg3JNqQlXiwgnw==
X-Received: by 2002:a02:c894:: with SMTP id m20mr25879647jao.80.1617046981462;
        Mon, 29 Mar 2021 12:43:01 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id p5sm9935305iod.31.2021.03.29.12.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 12:43:01 -0700 (PDT)
Date:   Mon, 29 Mar 2021 12:42:53 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <60622dbd29c07_401fb20828@john-XPS-13-9370.notmuch>
In-Reply-To: <20210328202013.29223-6-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
 <20210328202013.29223-6-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v7 05/13] skmsg: use rcu work for destroying
 psock
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
> The RCU callback sk_psock_destroy() only queues work psock->gc,
> so we can just switch to rcu work to simplify the code.
> 
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

LGTM

Acked-by: John Fastabend <john.fastabend@gmail.com>
