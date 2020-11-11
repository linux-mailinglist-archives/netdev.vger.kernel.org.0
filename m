Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B492AEFBE
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgKKLiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgKKLiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:38:14 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0280BC0613D1;
        Wed, 11 Nov 2020 03:38:14 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id gv24so572894pjb.3;
        Wed, 11 Nov 2020 03:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gZypMvFGW5/pMKgzZVWPRnEirLifs50mu6u8h37HDmI=;
        b=UnTeNA+PLFAXevIi/ssqDSio4u1I91tlJqiYr86WRheEHgdSi1G9D5JAIWe7fSq7KS
         WGumDuvL39rilD2D9i8ViMAyl3L5nWaOpygSnex2HRvvsw3y9Y6ZplBD0FZPzOW/a8m1
         6R4hT5U9Z9mTGkp/DB0vHNnwieO/dy7qu6bt+5f/MWc2q2k0/NBDXIHrGyaY8zc9Zoys
         CCYsYqOl+us1cqiYQ6Q4B2M8sudiVVdr/ka/WQanLqSiRbwftnQLTlx++Gd8iZI51/Ew
         KYXKh2n4YAFj6oXFGrOkAYl9UubhonkSvVH3wva3UFOSScD2Iq+VaHEvB3RZyI+NJcmm
         37Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gZypMvFGW5/pMKgzZVWPRnEirLifs50mu6u8h37HDmI=;
        b=aErBIu+q5CdHmrLFn2Gc3USBi2i6nAqvG5GQdukussEVuJqS7XdtPsTv9XJ4UTLBt+
         h558490C+lZbjln0Nxx7M9rvfwHUIJco96Rdm3AbGRIDmterTCD5ah9JvB0q1S4PBx83
         /BdEK9lYlBUaxBc2WK49spTZhHztM6Ph46qtz43Yr6MceeIjD+MkzgxKSXqyTtAOw/hd
         rA4/sSji2ZLZ3kGe+8DmAgeWEE0W7RUt5GGtzcQpMq6Bm0on9HgfooDA/83Wr3spUg+Z
         lKBMKqZ92ifJG8AO5rE8ztbhays1kV7EBEXzqAT1egc2DXmrHEd7hk48zo0b5r+rDVqN
         n1tg==
X-Gm-Message-State: AOAM530qBA9KLF5eeCtL2UazVBS2Nld/e+X2Zzh5nWldkxFgWQ2k5fsU
        hcPi+aLCy/S0VQvpUAHuAeY=
X-Google-Smtp-Source: ABdhPJxRqBAJEOtgIkFC7KGGS6a90xRf3EqjjcEIqmDVsYRL6UWFw+3Hj7I26fx8EY/MJ7o6fFBBzA==
X-Received: by 2002:a17:90a:fe07:: with SMTP id ck7mr3593991pjb.212.1605094693547;
        Wed, 11 Nov 2020 03:38:13 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:5320:802e:3749:ff39])
        by smtp.gmail.com with ESMTPSA id x4sm2257499pfm.98.2020.11.11.03.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 03:38:13 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, xiyuyang19@fudan.edu.cn,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v2] net/x25: Fix null-ptr-deref in x25_connect
Date:   Wed, 11 Nov 2020 03:38:05 -0800
Message-Id: <20201111113805.44617-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201109065449.9014-1-ms@dev.tdt.de>
References: <20201109065449.9014-1-ms@dev.tdt.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This fixes a regression for blocking connects introduced by commit
> 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 disconnect").

> The x25->neighbour is already set to "NULL" by x25_disconnect() now,
> while a blocking connect is waiting in
> x25_wait_for_connection_establishment(). Therefore x25->neighbour must
> not be accessed here again and x25->state is also already set to
> X25_STATE_0 by x25_disconnect().

> Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 disconnect")
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>

Oh. Sorry, I didn't see your patch. I just submitted another patch to fix
the same problem.

I also found another problem introduced by the same regression commit,
which I was also trying to fix in my patch.

See:
http://patchwork.ozlabs.org/project/netdev/patch/20201111100424.3989-1-xie.he.0141@gmail.com/

