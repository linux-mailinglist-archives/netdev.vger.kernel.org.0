Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C1F24FF5E
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 15:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgHXN6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 09:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbgHXN6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 09:58:38 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B4CC061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 06:58:38 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id u21so11375884ejz.0
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 06:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oItMMEclwrrhe888+C8sT+qGlI8nC6qoRWvMi3mOLY0=;
        b=g2mzSlvHXGsnN2Gmyx78LOyvCum8TwV5V4DgkFdjxB1vZz+rzctNp240G+Thupi+eu
         4zfy6esTBH962Hey4RfgXWWSbBO180D50ZPjUmpwOoHVT+6rEq++T30KZEGiZxiaIH0B
         0dGdUW67vU2vuy7MxZOzdPxQsaTmcUeDAc4yHtBQcy+EksmR6rgQYS2tnuNFCsMn8RxD
         W+NcXlvWmAy5FCVgz9K0E0blWuTQJqpMZHIHvLEkOMkPTrS2bY62ndeFEagw4emFNMuL
         glFwISsJhBK9fuSMhtlPqB2h9f3FNIwS+FUPyAibr38hnJAm26peed1WBJrgHb+yvJUJ
         yLJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oItMMEclwrrhe888+C8sT+qGlI8nC6qoRWvMi3mOLY0=;
        b=apJEX29Rg4+qiCO2df6GVYjFSjNV2Whu2WQfuxsEaNtFCClnldY9bGKTE6tYLK8Xu8
         SHtJ3jBcO7PUSTAo64QQdHuwajHKMflypucgitMyxEXXD1+RaY/zeUKJHc4reFoH/QiP
         fT+374xTQXb4rUaZOcycfx6kagrp1xohTZpH4r/DqbhRAxX4Gja0LHnA4k8Vq/pHAI4R
         U35AswfD2rj4InnZeSdqQh9bHtcWDm5LgSGX2gnQ4ZV84nj/AaATXIt0/l8xmMrLD4Uj
         sYVYkeYV55SD411p+hcQb0vKs+PxQ5qzf/jjd9NBdY319lwt29iWNJYn5NMThSIvylqJ
         vVyA==
X-Gm-Message-State: AOAM532a7l3vRbssCW8FTwxMjZ+00W687WrkccMwwLN2cRG1QAXpg/PE
        G9jmEzatxrHuq6YzCmmSOOM91X0ZbSUyAk1TDn8=
X-Google-Smtp-Source: ABdhPJxBEsVHGhJG0W5UJc97tzLI4sg/yAW6K3/L1/y4rIMgeY4Ok0aikT0jyTrBWq6+qaG2/A1oi7/tf9Z2KGINyNc=
X-Received: by 2002:a17:906:925a:: with SMTP id c26mr5549563ejx.121.1598277516785;
 Mon, 24 Aug 2020 06:58:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200824073602.70812-1-xiangxia.m.yue@gmail.com>
 <20200824073602.70812-3-xiangxia.m.yue@gmail.com> <20200824.060926.429831991235819793.davem@davemloft.net>
In-Reply-To: <20200824.060926.429831991235819793.davem@davemloft.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 24 Aug 2020 21:56:42 +0800
Message-ID: <CAMDZJNVzkbuc2Wx0dOd_JFEiNG+D9FFm0+PFrs2CFU7-x=F5kg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] net: openvswitch: refactor flow free function
To:     David Miller <davem@davemloft.net>
Cc:     Pravin Shelar <pshelar@ovn.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 9:09 PM David Miller <davem@davemloft.net> wrote:
>
> From: xiangxia.m.yue@gmail.com
> Date: Mon, 24 Aug 2020 15:36:01 +0800
>
> > To avoid a bug when deleting flows in the future, add
> > BUG_ON in flush flows function.
>
> BUG_ON() is too severe, I think WARN_ON() or similar are sufficient
> because the kernel can try to continue operating if this condition is
> detected.
>
> And you can force the values to zero in such a situation.
Thanks, David
will be changed to:

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 0473758035b5..5378282e1d13 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -492,8 +492,11 @@ void table_instance_flow_flush(struct flow_table *table,
                }
        }

-       BUG_ON(table->count != 0);
-       BUG_ON(table->ufid_count != 0);
+       if (WARN_ON(table->count != 0 ||
+                   table->ufid_count != 0)) {
+               table->count = 0;
+               table->ufid_count = 0
+       }
 }

> Thank you.



-- 
Best regards, Tonghao
