Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 518B517C1CC
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 16:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgCFP3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 10:29:31 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41563 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgCFP3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 10:29:30 -0500
Received: by mail-pg1-f193.google.com with SMTP id b1so1228091pgm.8;
        Fri, 06 Mar 2020 07:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UmltvUS81tbIumWX3xGTWP1jdQyhyXf9smX/ZD9oma8=;
        b=I6guR87axLmn3FfIaT47Xsrqq+ZPGWKuczGyzwal0Njw4274I+g/9/ZK3B4SUgM9F8
         KRJ7nuuzryB0YxS2xOo7sJsw5W8uEkeQAEjWk32LRU1nH5faBij+qVnamVLZ08+9cBPU
         kyFpOHfAzmhhS5C54eTSoSwjdDQGpNVevAuLjId8r4mhqpjUlccTWSAKTs1fLgM79n3u
         yCpu1izZv2nAZnnKysDL1GFwkomk3juFwO3DVGWBjHGJrwtfTOZDwxnVfH/7vOjpOD9s
         whPMKG+Ml5gybm+zqXIcRfy2tVBw4Sb0Vcr+yEI/H/NBBVekZ9Tq491L+rKwF2+LXN5r
         YNDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UmltvUS81tbIumWX3xGTWP1jdQyhyXf9smX/ZD9oma8=;
        b=Y5AVvvpxQo4JvFWZqPffgtyUHjHF3PAFcvRMe2/e9pBHgtxlvnh0Ljt3wuagQeczaN
         ZBNVvnm2mtBYFOshNVTYznCafk7TmKo9txTRwXFyFSvnfHsmMYQp1R+is+OT8e4vC6Hi
         xkonYFdNrpxkNxGuB4KKdypK7s6k5+wUV8jsqz0YRQn7GSUM6Qf6vlAuW6l//Byw+LMe
         /vlDcFM3ygJmXhuF4qZfwJufv/07vUadm6bYD0UcHyjZCg63rH+LZO4qh10FTfaZWlnF
         062wjXHqhCzPTUea9AZXho9YGzE6g5vTQ82oHroDuhEeNBdWEQobFcJ4aBZlIsmUMKbe
         dJNw==
X-Gm-Message-State: ANhLgQ0z3Grprir+12ka2NC3GtLocO7M9afg2Lw+2P5DWmC74BnYc0ke
        Uq11roL+wVDM6J4SWPU+VGw=
X-Google-Smtp-Source: ADFU+vtNAQvM9mvw1j0YD7Oq2MQHqOoY5Ki8nvrqeuryXuYLyINM6b6ff3XpXncoeoy0RT/9ngSUrQ==
X-Received: by 2002:a63:ce0a:: with SMTP id y10mr3765889pgf.44.1583508569030;
        Fri, 06 Mar 2020 07:29:29 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f4sm698041pfn.116.2020.03.06.07.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 07:29:28 -0800 (PST)
Date:   Fri, 06 Mar 2020 07:29:20 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5e626c50bb947_17502acca07205b47@john-XPS-13-9370.notmuch>
In-Reply-To: <20200304101318.5225-7-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
 <20200304101318.5225-7-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v3 06/12] bpf: sockmap: simplify
 sock_map_init_proto
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> We can take advantage of the fact that both callers of
> sock_map_init_proto are holding a RCU read lock, and
> have verified that psock is valid.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  net/core/sock_map.c | 19 ++++---------------
>  1 file changed, 4 insertions(+), 15 deletions(-)
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
