Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8855B4A480
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfFROxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:53:15 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]:41351 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbfFROxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:53:14 -0400
Received: by mail-qk1-f181.google.com with SMTP id c11so8729933qkk.8;
        Tue, 18 Jun 2019 07:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0q+lDhwoSzLW/vGLXgPFr1bRPZrHxwKku/Yc4H2Wc70=;
        b=pbyrk4o9ZgXacJhZgx6ZYLbBTYI/GQmPImCY/q9Giq0Tv3W9d861V0Cu2qiomhVjbb
         JfpKce9xOkyJmthgWXQjAwCXlKibJ5VLVRIU4eFIt7OqNgca1DaMSFoD34o/td1Syr9n
         CvQ/r6HlXUTC/bR2TT9yqO3kDRFBGtCp91/1D0VZRg890YIWI2c9sjMTh/x031HnckIx
         58OfV5wltHCi0jOTJdvmbzOOQ12+wrcF3nV9hplOmrmIeetxeqLUOglQ6EaSITQ/wrPe
         4K6/EbZUzA+gpOU9zJcsN9ZELmhWTop2AsdoGc5H0k/v6H/MjFdYbImuH5ifP1Ilzy/P
         5czQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0q+lDhwoSzLW/vGLXgPFr1bRPZrHxwKku/Yc4H2Wc70=;
        b=OpqDbhAdkKG5rVnRtYBqFUQBOyk6eqo5GHBEwhoQXiCNsp4pZUDguM07qVFwbTUg8c
         IV5XTk7WGDJwoRKxPZy26jyBafXZJbNpD5b+2P810Dk5hV6mf7ctphmLuyg9rmhylQeF
         tG76MFzbKqCN10LQlnBniZFn1/evCxl+j564lpvkESkEWWbOKxwiN0kd/iigUMKqoQjS
         ZfDf6E6wTvO3purhh79f40VzN9ycH6dStFLS8qYWwfu61KZhmXk1rKRuOmmbl0YkyIpj
         VSwu0982HvK2JlmZNHnlXKWumC3viXuzRSupKijCCwQ+lGZGFTvDQ5KPphq4CX2/tozp
         d3IA==
X-Gm-Message-State: APjAAAUSYeLoR7sEZ6vmjK8NGH74j1uPd0JaQOzFewmUooeAcfyCPyJY
        XrdUUiCX84tseffXc7lRQr8=
X-Google-Smtp-Source: APXvYqwqkiOizVJT0BN9XC/wOoplesdna8o2HjjyGCz1flnMO5Yksw8V3lk+IYPg8hJf2jEL4hlwnw==
X-Received: by 2002:ae9:eb96:: with SMTP id b144mr14015575qkg.321.1560869593227;
        Tue, 18 Jun 2019 07:53:13 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.32])
        by smtp.gmail.com with ESMTPSA id o22sm7976457qkk.50.2019.06.18.07.53.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:53:12 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id F2C2AC0FFC; Tue, 18 Jun 2019 11:53:09 -0300 (-03)
Date:   Tue, 18 Jun 2019 11:53:09 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "lucien.xin@gmail.com" <lucien.xin@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "vyasevich@gmail.com" <vyasevich@gmail.com>
Subject: Re: general protection fault in sctp_sched_prio_sched
Message-ID: <20190618145309.GO3436@localhost.localdomain>
References: <20190618144554.5016-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618144554.5016-1-hdanton@sina.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 10:45:54PM +0800, Hillf Danton wrote:
...
> > Anyway, with the patch above, after calling
> > sctp_stream_init_ext() ->ext will be either completely valid, or it
> > will not be present at all as it is seting ->ext to NULL if sid
> > initialization ended up failing.
> > 
> Correct with no doubt.
> 
> I was wondering if it is likely for the ->ext, loaded with a valid slab,
> to cause a gpf in sctp_sched_prio_sched() without your patch applied.
> And if the failure to initialise sid could likely change the result.

Thanks, I think I understand now. Well, without the patch, yes, as
syzbot reported. Seems you're also worried if it can happen in other
situations as well, and end up triggering the same gpf but on a
different situation. I don't think so. It should be either
initialized or not initialized. Half-initialized as it was, that's a
pain.

  Marcelo
