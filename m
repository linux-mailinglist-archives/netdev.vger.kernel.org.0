Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B379743E6E
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733169AbfFMPt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:49:59 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54726 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389754AbfFMPt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 11:49:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id g135so10741780wme.4
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 08:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1wsyKzjLCsXfm42/9RSW9jN5FHKosM3ps189VuAzeHw=;
        b=KMubIG9rvk/sSG7knYZduPcllBZCuTLMrl1DrEezrnmhqqEIKq5SUzIHeLbdHne8+S
         v2o6cefWdj23xsQ3so1q+xluxQgUEgvQaMT1D9ZNCd46Gxex947umszJASnJrqQGutVU
         N6Zf8frc9FXFvNvugUGkXEERpwMty+yIyLtKHWNpzfzDgR2eHpvZEqHbPJyp38vHKih0
         N3ia0bXTQ1gnq2v/5d2SloQVlPIufHpHqTPFHODTaw+fuNTcP5m427oU+/+lq/krfIiY
         e4kxO0xfL/Gx/8CWWCEsw+2kf5qRengINZ9L2+2eBNdbxYtNmTaHW/wPG6/KqxYUYxU2
         1W3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1wsyKzjLCsXfm42/9RSW9jN5FHKosM3ps189VuAzeHw=;
        b=aO+0RPjcuT4RXJVYA6yxnQr3tqSSbGvcCEagOjZHZbKK8oLsOXe1xYBQkMr976dNnw
         M0xCkgtG41UcVXaWhmF2+Pa39YCgu9KVgxp7LYUHl9WKtTJTA5LHXBbh2OQ+aUtsLfS0
         ELUXNpUhq7Ie/PCwqE54pancfA7s6+y7v8fneCjk1ERhD4b+KZZkmxprfmI9Fb4rkPNb
         hIjCnffqWzg/sKpt6Juq5XtN4/5jNRmBdpRkVs67n8qWYKj7FFG2aK9zGpcfMPRY3gGV
         qqpRJ/cQoBlFgXrnCPhj3ygeqhVnJCY7liPxVmsrgNkLHTcydHKrlmWGVTiSQSdlrl8+
         vr7Q==
X-Gm-Message-State: APjAAAWsrGlB3DsvIMPfxCKHe//aXxtCYlfNLl1wpbzee+vnozTg5Ml9
        ZSkkGyklZVGHL93ImqS+L4B+LQ==
X-Google-Smtp-Source: APXvYqyien3ADr0R/KkhEHcFblEh0vX3fjhJpc0lN0IiWXffexXQcWKR/xdA2cfBfImZ9pjimoypxA==
X-Received: by 2002:a1c:dc45:: with SMTP id t66mr4475053wmg.63.1560440994299;
        Thu, 13 Jun 2019 08:49:54 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id o185sm196666wmo.45.2019.06.13.08.49.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 08:49:53 -0700 (PDT)
Date:   Thu, 13 Jun 2019 17:49:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        davem@davemloft.net, pablo@netfilter.org, alexanderk@mellanox.com,
        pabeni@redhat.com, mlxsw@mellanox.com,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net] net: sched: flower: don't call synchronize_rcu() on
 mask creation
Message-ID: <20190613154953.GB2242@nanopsycho>
References: <20190613145404.4774-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613145404.4774-1-vladbu@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 13, 2019 at 04:54:04PM CEST, vladbu@mellanox.com wrote:
>Current flower mask creating code assumes that temporary mask that is used
>when inserting new filter is stack allocated. To prevent race condition
>with data patch synchronize_rcu() is called every time fl_create_new_mask()
>replaces temporary stack allocated mask. As reported by Jiri, this
>increases runtime of creating 20000 flower classifiers from 4 seconds to
>163 seconds. However, this design is no longer necessary since temporary
>mask was converted to be dynamically allocated by commit 2cddd2014782
>("net/sched: cls_flower: allocate mask dynamically in fl_change()").
>
>Remove synchronize_rcu() calls from mask creation code. Instead, refactor
>fl_change() to always deallocate temporary mask with rcu grace period.
>
>Fixes: 195c234d15c9 ("net: sched: flower: handle concurrent mask insertion")
>Reported-by: Jiri Pirko <jiri@mellanox.com>
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Tested-by: Jiri Pirko <jiri@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>

Thanks Vlad!
