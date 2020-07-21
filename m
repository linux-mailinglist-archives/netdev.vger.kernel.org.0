Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B37228225
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 16:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729116AbgGUO2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 10:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728383AbgGUO17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 10:27:59 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F93C0619DA;
        Tue, 21 Jul 2020 07:27:59 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k4so10327564pld.12;
        Tue, 21 Jul 2020 07:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rztZLDwVmXshy2I0VYii6VvZ6b/CEa6jKXB3iTVWQ4o=;
        b=lpqtCpBNGrEpb9rB920qsdHHd+u3Ln+pKgNfy/rj9J7Dr2HWhw6k5XNE5uSHnfU2Dw
         0PXA4XuoKG4rRHrRCWF5QquD6H7rIXu96KOZTw0ko0E5G/18zbtU8V1K0ZGAkoJeWWe3
         ZKAqHP1z5e2vkEHEBunH5Kxk+zc0jRw0CCcgQRrjQ3LzfgLD0T6kbbeTMhvKHDO1+PLV
         LMHh8aTrXB8Q8LEN9fqVX9ypuc6JmgzMHLLMieoucnASGCGZLe81nTBVx35OcFuU/iOT
         EDiUYnGh1FPZ1T2vHhphqi8WGZAilUK1Cmf3XMx3qMaiBnWVoadmGQqjXXqQMKRPP9jR
         BipQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rztZLDwVmXshy2I0VYii6VvZ6b/CEa6jKXB3iTVWQ4o=;
        b=sz/3xVfrRLZ+WS3au57u/JyDyNhynT/9H5yYCkR+sKhKfv7KAc84b1ubkoq7Ab1uGf
         5LwmwCPc1X/lo2MZ6IJ7jUOjcjHMqufaRd4aDjM+8g67PGc/z/W2ZhvlV1wYpV+DShDA
         uNAqZHPyML7pOaW7d9zCFkr0C/tIqyFY40IMK69tMOJA+QgVtGc/KLj0cf7lOQmm2YPf
         rGOlJSe9QbO8SHh06l/YRcB9CkVkT12FKH/ok1SS5JHtsVXWw1PotA0GSEy4GLRaKCKn
         Ll6fBgihrFOkqzmeuWWOp9F1rs/TRPuh3bATNWWGVtPLYCQy4ESNMbkahHrBvHXwYfWD
         88Xg==
X-Gm-Message-State: AOAM530jEeLbVTbDBS45dDLBkqllgLZuATEPnRtyPvR3WAs69h+8ePLO
        taABjehP+9zg0Q9F4gyWzuU=
X-Google-Smtp-Source: ABdhPJwOZkGf2+hjpzR0ukUubhMTS+fw15qB9NT03kp3OB6E49eATRpV/OJ5KldIqcX9/AUJ4fVx5Q==
X-Received: by 2002:a17:90a:b009:: with SMTP id x9mr5047312pjq.136.1595341679439;
        Tue, 21 Jul 2020 07:27:59 -0700 (PDT)
Received: from localhost ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id r9sm3592981pje.12.2020.07.21.07.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 07:27:58 -0700 (PDT)
Date:   Tue, 21 Jul 2020 23:27:56 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        pmladek@suse.com, rostedt@goodmis.org,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>
Subject: Re: [PATCH] docs: core-api/printk-formats.rst: use literal block
 syntax
Message-ID: <20200721142756.GD44523@jagdpanzerIV.localdomain>
References: <20200718165107.625847-1-dwlsalmeida@gmail.com>
 <20200718165107.625847-8-dwlsalmeida@gmail.com>
 <20200721140246.GB44523@jagdpanzerIV.localdomain>
 <20200721082434.504d5788@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721082434.504d5788@lwn.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (20/07/21 08:24), Jonathan Corbet wrote:
> On Tue, 21 Jul 2020 23:02:46 +0900
> 
> I'm happy either way.  I'll grab it

Please go ahead.

	-ss
