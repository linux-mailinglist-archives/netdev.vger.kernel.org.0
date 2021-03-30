Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFAA34DF06
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 05:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhC3DKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 23:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbhC3DJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 23:09:31 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BD6C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 20:09:31 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so14285984otk.5
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 20:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TZqA77AM+q62H/ZZ/x45fUdNHyG6I6UZu8QNcaQFuWQ=;
        b=T5lYyuqisuJuHyoX38orx6Bo5zbLcDiJ+aG7oPLuu45EaK26S5RIbrHV4Q201s7Gzn
         QaQFVjSuZk4QGl+WJc+CkrX6AFhb6cgxDgGPiFVV3CjN+VWndq4yVzdj+jsO4HZpvGNJ
         7p+V/fosuWXV23dQwp7l+t+nrGEZAtyfJET74YYWJHx8gYbsXs5tD/ayLCOBkqhmuEdo
         lxdEhwNtQ0S+XegxgZz5qpZkJHlY4SkzBGmef74wy7FUUghZc4JIq5XObjFMBkNz0KXQ
         nZ48QtV8aFBJj1VGkKPWDOirv5nyR/aLgsOQ5y4Q2IZS1N09T8Mx6An/SsuZyZtbwtxu
         X8ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TZqA77AM+q62H/ZZ/x45fUdNHyG6I6UZu8QNcaQFuWQ=;
        b=O2bxeNGovisDcZOnOODK7LVd6W82s/uWfzn5k10EDmJneGopVlqp1j8brqZqgKFpU6
         IfqBPA7LtYkf4uQ2D/xuw2PLE7YvwlK8YYkHYB4Nksqd/AjlZDwTR322OCaD+Zb2Jcas
         m9wdjBq646+TboxJOmAJ8Vhpe62WLVFHzRe7hOUtGEFvNJfqoR5fq1pMKsCVE1GZRmhP
         Vqhk65tCBoy8zC7TIpA+MkXNS+O1jgXJ43IljWXGsShP9H5yG47mJBQF071oy+2M8jOo
         v7Xzd2l1fAiisXDZXqNWNWYRJzGQDMkAIB9wjXq9gVpnzF41OHmz4cy2U2P9FVGnhOnx
         LMLA==
X-Gm-Message-State: AOAM531rAE/dccRGO3+8hC7bSWXd+5D4x3mdFohXU45hYcVX1T7oS6yj
        Vg3Oe06ZV79Pxy6PRXvd68BxpAVyXgA=
X-Google-Smtp-Source: ABdhPJw8hfvgCmkeAWQFZfc3L8StOjBDgB4XKJmBwCdBTPJdEcu4C/F8SSuOQK+QBDO9KFvaFluRrQ==
X-Received: by 2002:a9d:20c6:: with SMTP id x64mr24775531ota.262.1617073770606;
        Mon, 29 Mar 2021 20:09:30 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id u11sm3945352oif.10.2021.03.29.20.09.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 20:09:29 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] police: add support for packet-per-second
 rate limiting
To:     Simon Horman <simon.horman@netronome.com>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
References: <20210326125018.32091-1-simon.horman@netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7ac9bca6-9680-b586-8d63-4c34e596ff10@gmail.com>
Date:   Mon, 29 Mar 2021 21:09:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210326125018.32091-1-simon.horman@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/26/21 6:50 AM, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Allow a policer action to enforce a rate-limit based on packets-per-second,
> configurable using a packet-per-second rate and burst parameters.
> 
> e.g.
>  # $TC actions add action police pkts_rate 1000 pkts_burst 200 index 1
>  # $TC actions ls action police
>  total acts 1
> 
> 	action order 0:  police 0x1 rate 0bit burst 0b mtu 4096Mb pkts_rate 1000 pkts_burst 200
> 	ref 1 bind 0
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>
> Signed-off-by: Louis Peens <louis.peens@netronome.com>
> ---
>  man/man8/tc-police.8 | 35 ++++++++++++++++++++++++-------
>  tc/m_police.c        | 50 +++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 75 insertions(+), 10 deletions(-)
> 

applied to iproute2-next.

