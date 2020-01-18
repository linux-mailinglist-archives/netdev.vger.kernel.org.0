Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2BAB141647
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 08:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgARHAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 02:00:01 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:45128 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgARHAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 02:00:00 -0500
Received: by mail-io1-f66.google.com with SMTP id i11so28372640ioi.12;
        Fri, 17 Jan 2020 23:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=in3PaGq/NpVE6pYehQSiATO9al0YHakPSsRs7/ya4xY=;
        b=Fq9oU05tCl7rhDvw/9cJy9oWF63d4zAPiYh6jQXhaCXb5V96nkf2hlgH4en8WNZxZB
         otUBrmGHxJAXU2c+jrWyOzEz/HrIYxkVspjWkpn5WdK5Ml1GgXKbHXIVslaY1S7L5PE+
         SvmdLSCm5iwhGTvdbU7YrPIvn7cHCrvlzipD4vCf2SfHoIEatX1hGK1vQ5PDoEtMOrhB
         HJ9khmxX9XdqtoqdeF/U1hDICT1vt+OzdvChuVbWzV/S6GUamW//D+wOhkUtMUUIQkcK
         KE7BbwpLkvcgDo8yxGm4CpP93Y2NIq3tmuNnVwtkHWQEIhVEkw1QlGsYyZ52xXeA3oIN
         Vt3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=in3PaGq/NpVE6pYehQSiATO9al0YHakPSsRs7/ya4xY=;
        b=NYuBSv7R6QlZsx3qZJi+26rY54thUPn3RXmel5rRmVQwouv0FbzM/TCgBvjTqU6+L5
         tY8gjyJQ3vQsWMHPgZf7n1uXrzYsrdiWHMyfdtpUbNpZgUaaEH7e1fCD/v/qBylTJW+k
         +2fh66iA5KQyUKxgT2P9uA3r6wL5yTuPVF6FmNxHW0LWzCtt97x7CzebafVbbg2WKi6N
         TicNv6go152umGs6RTOsb3NHyDm6fejaHlN0IZv22wVSuo9+Tddzom4iADauVx+06ZiT
         XXhI0eZrubrwQFwzesafFb0pDhx4Pj9mQF7oXE30IozkNz8BfX3qxij2LdTXU0aTvGJh
         BfpA==
X-Gm-Message-State: APjAAAXi0e6rixpi5GRKvp6cV+HVO+8dr6LIIEcCdGhAMGKwQGK3H8tY
        3Bi+Z+Sp5FYfHnf8Ym40ZHY=
X-Google-Smtp-Source: APXvYqzr2NNo7zXtAVqrYPtrnor3hBErQdIxqAM4Fiq7PgMqN9enYklbUXgFWG4J0vfn9UKELr5DhA==
X-Received: by 2002:a02:b808:: with SMTP id o8mr37753092jam.104.1579330799830;
        Fri, 17 Jan 2020 22:59:59 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a9sm8595799ilk.14.2020.01.17.22.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 22:59:59 -0800 (PST)
Date:   Fri, 17 Jan 2020 22:59:51 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Petar Penkov <ppenkov.kernel@gmail.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5e22ace73625b_33062b1a40ed85c0af@john-XPS-13-9370.notmuch>
In-Reply-To: <20200117070533.402240-2-komachi.yoshiki@gmail.com>
References: <20200117070533.402240-1-komachi.yoshiki@gmail.com>
 <20200117070533.402240-2-komachi.yoshiki@gmail.com>
Subject: RE: [PATCH v2 bpf 1/2] flow_dissector: Fix to use new variables for
 port ranges in bpf hook
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yoshiki Komachi wrote:
> This patch applies new flag (FLOW_DISSECTOR_KEY_PORTS_RANGE) and
> field (tp_range) to BPF flow dissector to generate appropriate flow
> keys when classified by specified port ranges.
> 
> Fixes: 8ffb055beae5 ("cls_flower: Fix the behavior using port ranges with hw-offload")
> Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
> ---
>  net/core/flow_dissector.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 2dbbb03..cc32d1d 100644

LGTM

Acked-by: John Fastabend <john.fastabend@gmail.com>
