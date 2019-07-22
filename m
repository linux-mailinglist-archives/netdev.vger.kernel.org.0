Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 030F670B90
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 23:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732771AbfGVVh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 17:37:28 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37958 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbfGVVh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 17:37:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id f5so9454465pgu.5
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 14:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AZRXajcSIrY6PCfFrF5J30FKsx/eQiq/SiURPre+yrw=;
        b=POxPd61QDRujw3PgL5Jhg2puRWmd1v0fOWMw446/mFBZywlsFE+QmiXF8SpzPOJ6B5
         aDhcJaoFam0ew+H37cMDW1mIBPaD4/styVuY2luBwbzk3wYjYfdOGeWyt9PHI1b3clXg
         tjxkmWgqtLsWufOEa652ippDpYs6Yn8jmKUBl1XzhYfQ2lXfYsHCoUhAXmN9/3bmG5gV
         /++FtT1GKuNidducaNzEirhgPQwJwf4+PPyVxfRHo4Sjn+Dcb9SkvE+OmPGTsw6R6lOf
         hbYjQN5DFJ69HwU3Nt493EVE4I+UlOyEAlV7bleCvx7U/bdB+ov4KDTJYnBoyw/AVBN8
         +1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AZRXajcSIrY6PCfFrF5J30FKsx/eQiq/SiURPre+yrw=;
        b=k3eb1JokauF7gNNWlurHHS9Bf/Y9NUhjkT8JU676lA0cZaKYL4F+3Pi/zgUGwMy9Wi
         udYGXqomtKvzF2rnrfftBEtf75t1weFq65V4JkTqtCV3lyoRc6xiAv6GXacO1K9tbqE8
         QsDB+6Pptx/ETH72OlZIm8EvUIjNpWIkU8aay7AHjl8jc31lzV//iogWeBTL22Z70cjU
         P+4JT5XIjL8OrnLE3O1KBQJFZbDgn+pEodLrQOUgOdDoaouM0ztS5ni7r5rzPrJL/R+4
         FiGIKEQSqkM6HxIjeZ8c9bRmLATHyDD7V82GFnikWcM5Jnt0In+0OCZ2WAJh6LQgSXI/
         6EvA==
X-Gm-Message-State: APjAAAVpoH/x+yTq7qn+EkIzDbXwHZlLIUYnbKe8CMoqKwpHbPK5bOPN
        IF1bVYWvlGd7BLXVYOdVTECMEqALNQpHBmWu+Gk=
X-Google-Smtp-Source: APXvYqw5lPv7USsX6tI0wPHg2x3WKJ6W/Y9VPcQBB8L4rKmNULGQwaf2fpTiFUkjeAX+k8fbZ91T1Ss16mKwixblWVk=
X-Received: by 2002:a63:8a43:: with SMTP id y64mr72586058pgd.104.1563831447042;
 Mon, 22 Jul 2019 14:37:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190721144412.2783-1-vladbu@mellanox.com>
In-Reply-To: <20190721144412.2783-1-vladbu@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 22 Jul 2019 14:37:15 -0700
Message-ID: <CAM_iQpXZNj4356+yRg_FqCkDrS5CN2eNgAHQsN99bhFLwRutkg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: sched: verify that q!=NULL before setting q->flags
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 21, 2019 at 7:44 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>
> In function int tc_new_tfilter() q pointer can be NULL when adding filter
> on a shared block. With recent change that resets TCQ_F_CAN_BYPASS after
> filter creation, following NULL pointer dereference happens in case parent
> block is shared:

I completely overlooked shared filter block.

Thanks for fixing it!
