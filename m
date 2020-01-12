Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F207913845A
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 01:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731832AbgALA4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 19:56:53 -0500
Received: from mail-io1-f44.google.com ([209.85.166.44]:43544 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731791AbgALA4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 19:56:53 -0500
Received: by mail-io1-f44.google.com with SMTP id n21so5960879ioo.10;
        Sat, 11 Jan 2020 16:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=BWpF7eTNZZUDhfMcmymaRHjNDWReQsXmHHPwFlsJAB8=;
        b=vC+J9VRt9I/IMlTbebVzbNozxdlzYWnZkRDtbBnpad+cmSNlIMSJAfpLzoNLNPKhXY
         ry/ec+sIK9Ktip14dbPo+J33XivBPWlYu+frQXNXg966LghvvY2pjZbiQUdUBGszq5my
         uNNwfzdKxVI8nJyzTJuVHjunJ/s5uKW/LED1PVraJ4Oh26KKDH2sIPFDKUqCfyCq0m8v
         xO9YEgTkqyAn45tIEYIrNv/4du10R/AioQFpiIXR1itf7PfalV5mGaHZxCCkbCc3V/EN
         M3begldoo+UMLf7tse7I6Ws5T1x4DpKfk/CH8ZvTe9979i4M9fXlV1YumqPzD/3QU1YD
         HbKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=BWpF7eTNZZUDhfMcmymaRHjNDWReQsXmHHPwFlsJAB8=;
        b=ucp25s7oSy62R328AYZprz80q2LjhlVaUofMA/ZP2xJ5sfKX/KZId6PvD3Eib642Li
         tAPSW21Zoz6LtvSTVkZQzoHeLVYQ8/bKX6DDNBXoFAruTDAJL3kqeGhNBYR4/xpsD05d
         2N0UgOoKqGWa+4yBmK2I9/5evx0BPS1xHcv6c673HuX+TL8TqVZnWor2FJeNH1Nk3Nhy
         DnvmpLktFmIgvsl6JI8KSHPh1dENXc5x65Ofbo0kK/NMya7OD3ebovguleRGmxDBQjIM
         ZoWBHrUJef/1gyzdBEsHEwP0OG9bvU//cShOOKhBbu9EUUbz8XKfxJtB4WxMbsOUFZQK
         K4lg==
X-Gm-Message-State: APjAAAX9lStE7EJk4JNGdZj01V8dWaJ64HKrgGjpAvqDy0pR0OlIIcP3
        YFvrFmz8YLAQloo0r8NSj4s=
X-Google-Smtp-Source: APXvYqwnG83lidqljqH0Le+0nWVC8MprUYHIZUsLUkONutB9lxkR96xOaR1Kz55zKtced1eCeGrogg==
X-Received: by 2002:a6b:7e48:: with SMTP id k8mr7384865ioq.12.1578790612464;
        Sat, 11 Jan 2020 16:56:52 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l17sm2210727ilc.49.2020.01.11.16.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 16:56:52 -0800 (PST)
Date:   Sat, 11 Jan 2020 16:56:43 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5e1a6ecbcc114_76782ace374ba5c0f9@john-XPS-13-9370.notmuch>
In-Reply-To: <20200110105027.257877-8-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-8-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 07/11] bpf, sockmap: Return socket cookie on
 lookup from syscall
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Tooling that populates the SOCKMAP with sockets from user-space needs a way
> to inspect its contents. Returning the struct sock * that SOCKMAP holds to
> user-space is neither safe nor useful. An approach established by
> REUSEPORT_SOCKARRAY is to return a socket cookie (a unique identifier)
> instead.
> 
> Since socket cookies are u64 values SOCKMAP needs to support such a value
> size for lookup to be possible. This requires special handling on update,
> though. Attempts to do a lookup on SOCKMAP holding u32 values will be met
> with ENOSPC error.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
