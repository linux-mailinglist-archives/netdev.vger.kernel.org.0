Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D27185A0E
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 05:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgCOEYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 00:24:09 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40173 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgCOEYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 00:24:09 -0400
Received: by mail-lf1-f67.google.com with SMTP id j17so11144214lfe.7
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 21:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b9OWSonJPFWMHh6VNn3IkV8b+LoeomMOWenZ3Moo7ac=;
        b=yuW1s8I9rztDZSechSVA37MwvyxBal+rxCn4FlSEI2YrBaxsoUttnX0PU6ExuKrIB1
         A/xZJcZToXs+JbsHLI57LJbb3VkzZe7eEvCVQh3zAIAUUE4WstRIb83cgih7Dzhcx4Au
         4xF8NTHnuZ9ZelkpJqpzMTu8qhF+CD8lCPq0Gs0sfmZSYBYZ5P31Gxg7GgW+UmY1cowZ
         vdfVe/Bp4rheoNGj8GcfSykD/9U8K9eJB7zQYt+BeAC5cuFxVUUaxS3YlqtKCXj+UDMB
         oE3+jfgykD7DdfDc4lkYdHecS1ty5e7lEfTLETxEJP/BfMD0iOp1PxJN9XPSopTonjNt
         2vvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b9OWSonJPFWMHh6VNn3IkV8b+LoeomMOWenZ3Moo7ac=;
        b=Gd1rbXglY15SOwG/Gvkq2W7EGOV2aKjL3KVlcXepW7Zp1qyYVYFG/WF6PIIoJYciEV
         ocSVzVTPNxNgAcNOtu+SHDMcxWdRL1/5x7rx0WJAT3s/q287VCujqtYWDp/4ZNGnapzs
         dDyn1lxo/GlbqGrBx73lww2Cji142ZcyshgjPAYHfQorlKpJfSRlvKFq86Mq/uVIqUOO
         34fLdSTTq7HZTxWAKtBdiRPiQNUrxHZu3s2S4rEliuvn8MD/6qaEhC/aRT2gsxLr1JWI
         jtpJZ3y2F/73zgeRC2mEnkZdk2Xyo0akZygu8/dxpstGyHcgsJ1JFTDHUAD5U+1iOYvx
         qNyA==
X-Gm-Message-State: ANhLgQ2PbvcltNUftqVFTNq9Q+jFS8Q9ljh3hqI3e8hkxTejsowz5+SE
        hcP0ouyBlkbT3C5Q6iI6YOzu7buRCqo=
X-Google-Smtp-Source: ADFU+vuh2mQWj0WzL1c2xh+ZDIOI08yGTYDJXMWNtFd0e7SrtvzcdsISVt3zRrxXXrfMp3uxzgEE1w==
X-Received: by 2002:a5d:66c4:: with SMTP id k4mr22275371wrw.133.1584178002067;
        Sat, 14 Mar 2020 02:26:42 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z11sm4474409wmc.30.2020.03.14.02.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2020 02:26:41 -0700 (PDT)
Date:   Sat, 14 Mar 2020 10:26:40 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: Re: [patch iproute2/net-next v4] tc: m_action: introduce support for
 hw stats type
Message-ID: <20200314092640.GA2199@nanopsycho.orion>
References: <20200313121257.11131-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313121257.11131-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Mar 13, 2020 at 01:12:57PM CET, jiri@resnulli.us wrote:

[...]

>diff --git a/tc/m_action.c b/tc/m_action.c
>index 4da810c8c0aa..2af15738922e 100644
>--- a/tc/m_action.c
>+++ b/tc/m_action.c
>@@ -51,8 +51,9 @@ static void act_usage(void)
> 		"	FL := ls | list | flush | <ACTNAMESPEC>\n"
> 		"	ACTNAMESPEC :=  action <ACTNAME>\n"
> 		"	ACTISPEC := <ACTNAMESPEC> <INDEXSPEC>\n"
>-		"	ACTSPEC := action <ACTDETAIL> [INDEXSPEC]\n"
>+		"	ACTSPEC := action <ACTDETAIL> [INDEXSPEC] [HWSTATSSPEC]\n"
> 		"	INDEXSPEC := index <32 bit indexvalue>\n"
>+		"	HWSTATSSPEC := hwstats [ immediate | delayed | disabled ]\n"

Sent v5 to fix this. Sorry.

> 		"	ACTDETAIL := <ACTNAME> <ACTPARAMS>\n"
> 		"		Example ACTNAME is gact, mirred, bpf, etc\n"
> 		"		Each action has its own parameters (ACTPARAMS)\n"

[...]
