Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B5A18AB31
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 04:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgCSDg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 23:36:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36483 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCSDg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 23:36:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id z72so462575pgz.3
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 20:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OnF2jvTBlix0EjtImOy+EOkD/MQbZM/wSUwZ8FmbQeM=;
        b=VYV+UdI6ncOs8BrvBqLuX/d9TqB8+vIqQ9Vh/iHPxWMo6DOai2+Oz1NP9dieywCgQ9
         5lJvC5K+8cMVIQrwp68paEjVyJspwHHEHhtmtyxZWFtKCDEi+MfjrRQ9KT7NCfqQwYSg
         +3lBcNwbcq02S+05/Ri9WZVL/YBQ4yws48BJy8a1M+Sn7CHPWs6TWTH7IotmF5/10ELm
         lS+sMvXjEiYYK7nvJMhcZoMOnFEcfrlx3KtFHc/kDK+59enFFbJi8g9LddUmsAlt5wJz
         GI3GRsBOHViAx2yo6Ycq7bKnrrNKXWuZTBgJENpsqlhFelFlWQtrTcdDBsxp8HVMtjh0
         PiUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OnF2jvTBlix0EjtImOy+EOkD/MQbZM/wSUwZ8FmbQeM=;
        b=SgkRBT2n56z2YGiNskGifoE6QKh03SjsCExv45fJr0GgJSwHLf7nWluZmbixiUkUYc
         ZbfuoRFzlx/668yKhEG4kbKyZCggY5a7TbeEQzvd0zwUIVZOJFT9SDSsL4DmZ1XkBb1t
         JQdAUMnhvZru2uy8nIt1mo/WS7tZestXsOf0kUB5jIIV6IHzZ8OtmQ3+8IWN2ogGgjwZ
         ANAOeLkwsMOBlJtYky/f5/YGxmomu3dD5MgvC4hrCZDhWq14RcePtDWWQSHEn12uWGti
         ZHyk+l8PVwIjF6HQ0oHmL9kE3hRCfmvztZ00l0uJmtQm9z4yNrVLiUgl55QaqXPzqrsW
         V2gw==
X-Gm-Message-State: ANhLgQ0Y5ImqT8XexCs9kW4cDydCkw3g0EE1OHZfoAHZ2aXA28wpeswb
        gvOBHUB7JAlLlm2oMt6kIDI=
X-Google-Smtp-Source: ADFU+vsnKV8xKW7+072DGIMp8/At+3AXrrOvW8VPdJW4j8FPoqY5ANTH0GBhG2B9PVI6XACfndoFDQ==
X-Received: by 2002:a62:1c4c:: with SMTP id c73mr1673632pfc.64.1584588984585;
        Wed, 18 Mar 2020 20:36:24 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u41sm472846pgn.8.2020.03.18.20.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 20:36:23 -0700 (PDT)
Subject: Re: [RFC PATCH 15/28] tcp: add AccECN rx byte counters
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1584524612-24470-16-git-send-email-ilpo.jarvinen@helsinki.fi>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <678ad432-377e-c920-5855-1de0dbd5fae5@gmail.com>
Date:   Wed, 18 Mar 2020 20:36:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1584524612-24470-16-git-send-email-ilpo.jarvinen@helsinki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/20 2:43 AM, Ilpo Järvinen wrote:
> From: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
> ---
>  include/linux/tcp.h      |  1 +
>  include/net/tcp.h        | 18 +++++++++++++++++-
>  net/ipv4/tcp_input.c     | 13 +++++++++----
>  net/ipv4/tcp_minisocks.c |  3 ++-
>  4 files changed, 29 insertions(+), 6 deletions(-)
>


Why do we need these counters ?

Please add sensible changelogs to _all_ the patches.

