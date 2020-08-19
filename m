Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB2424A7D8
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgHSUpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHSUpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:45:52 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFE3C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 13:45:52 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id 77so21858219ilc.5
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 13:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=3/k6EOT7/1gK6Z7NVTmmBxLnL88+KP03Peou2aooOIc=;
        b=D8M9N4JN5fXM++Jt8NTku+cmipl4RrJab/eOIqAGLHbJVoWeywD/66k+jauW+FZQgp
         wZQ7JcOcx6AK76HEIDO0kp2tyYODxBXBkTaCmwQ1zZ07l0Jivz/+Wx9pLARY6PQQHurG
         MZ8L/9kNhVxRvIROB+bS3x4Xk6sauiovLMyxKXHrlN540YExiPIJR0iVCmDvyicGxh16
         GSiE4ILm3K6AZfHQFaJoxorllEDSIk2zgib/SWv+PD83bn3YAYze4Y/Va/B9yo4wI8Fe
         T5s7TTPkmso0lCynkuZEVq4VF+NTH7Fx1eAHbDnFaE36v6Aj9LLhxFJjHa8+EcMW/KLd
         OVpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=3/k6EOT7/1gK6Z7NVTmmBxLnL88+KP03Peou2aooOIc=;
        b=V2hOiDyZboAkPF+RXFs4C8ua4ydOXA/jYx5BCzpEiACtD1q3TbGcrsHTc9SpDAjcv1
         mnhf03G+4RV3UhuXpnVEGD6+kKeRP5Q9QAy9gftLKIKiauyniFCLIqD0rl14VH+M/IAY
         mzYFJX0DJEzs4qEbCzw4x5meDnCl7CoEX7F254tYGxxww6BUVmB1Z+AnnhZotibnjfsv
         4u5ujpEdJp7c3hoW+pYcK4WjY4GGw/lcrvc/afvqw/nOjC2SJqZD8Ux/eKa6nc9RkhXK
         tnLK9lNSgzujY2ZXYznX6t0cGvaL+bJJ1tD/29/mujg0zlO44u3+nzXU+WGXfXZE8kBI
         jxCA==
X-Gm-Message-State: AOAM532reYdMcMrcp3orhkcAF987Yj0VBlooW3c2snjrHO8go023moYS
        awyrPCArEz44u0GSly9ahf/jjg==
X-Google-Smtp-Source: ABdhPJykBnTXYXC+s+1JWOsfkY4+097z/aczeOEHKIjxHp75e2nveWVCKOd3TC9kR528YOEbvJ+Jng==
X-Received: by 2002:a92:dac1:: with SMTP id o1mr24211633ilq.86.1597869951534;
        Wed, 19 Aug 2020 13:45:51 -0700 (PDT)
Received: from sevai ([74.127.202.68])
        by smtp.gmail.com with ESMTPSA id h11sm3745922ioe.4.2020.08.19.13.45.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Aug 2020 13:45:50 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Wei Wang <weiwan@google.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Mahesh Bandewar <maheshb@google.com>
Subject: Re: [PATCH iproute2-next v2] iproute2: ss: add support to expose various inet sockopts
References: <20200819184635.2022232-1-weiwan@google.com>
Date:   Wed, 19 Aug 2020 16:45:40 -0400
In-Reply-To: <20200819184635.2022232-1-weiwan@google.com> (Wei Wang's message
        of "Wed, 19 Aug 2020 11:46:35 -0700")
Message-ID: <85v9hefjpn.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wei Wang <weiwan@google.com> writes:

> This commit adds support to expose the following inet socket options:
> -- recverr
> -- is_icsk
> -- freebind
> -- hdrincl
> -- mc_loop
> -- transparent
> -- mc_all
> -- nodefrag
> -- bind_address_no_port
> -- recverr_rfc4884
> -- defer_connect
> with the option --inet-sockopt. The individual option is only shown
> when set.
>

[...]

Thanks for your work. It would be nice if you could update the man page
for the new option.
