Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E753773D1
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 00:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbfGZWCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 18:02:53 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38244 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfGZWCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 18:02:52 -0400
Received: by mail-pg1-f195.google.com with SMTP id f5so16554677pgu.5
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 15:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eeq6ZmHqeX9or2Yv9Y1qkOcJbBCoWpUg936ABjAZaUE=;
        b=N92PT1jdw+QRWkhJhwfU5asZqZa02L8WdbaYcAJ2Val12sjrede0hQazjr4q6ylnTz
         ovGrD1ul7xZvJhOVFP5wbhO+WoA1k1SWIks2ElVdA8DsIvmcp/v2PEEWS7fJux09nOJl
         g4DMm3tyagzYoFWDXgzqgaXj1OlNQKTTxo3hmmZClLyT4d8OlhJqxIirfx6cwMRtoc3h
         tE3iaJzxWkHx6MDOf0LPcGGs1kardhcr/qyvBqrbSjPMCy6kMJ5NuM8dromuy8rgjBOa
         RFCVKBQJSl+J3BIgA8bq0kaFwFwFVh+25cwM06mOenKNO3sLtzMM6VamR5Dk2OXW4Bxy
         6jjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eeq6ZmHqeX9or2Yv9Y1qkOcJbBCoWpUg936ABjAZaUE=;
        b=JeZJJdKC7pidGqZDtTBwscDquEhzl60grfrxtXhQ8LDHVQy7kTmVFaa9KOxqpAAxTT
         6SSmT6BlC6MGVIJfD+7KLtHncNc7SRFnwgP1Tstw/Twcar8i8vEmjSDCM60p4P/CprHj
         hbrmgr1YQNSiMqUgS9VKEf5NHkDo2Qrfb+oSD6WHlNjFqXU40WxuJ1QG7ql6Xu9BrA6N
         vTMEr4XLn6BHvCGS3BjnG5wgYd4p9s6mt7owGn6ngZOPMrHmQ1op0Bx+oELUgPmvYED4
         EUeltocYpV51RHneQUE+R6HPH4DlES6WOysU+FGpUatvJrhrTCfJ25jGZMEUaJ/+Bkgg
         +wsg==
X-Gm-Message-State: APjAAAVfXkyryapH1btwB9yt45kPofE3SaZzFukKOfYyiqPULiwmLMjG
        PBB3IblA7gTHFF3gknMxnc5kVWs0
X-Google-Smtp-Source: APXvYqxHsveR7p7xjWtdjnkz9bM/oy0AZtYEfvCaiXIDSHJkbT34pYOWfBtxPCnhwAqpESR5Uc/pdQ==
X-Received: by 2002:a63:d301:: with SMTP id b1mr85608116pgg.379.1564178571957;
        Fri, 26 Jul 2019 15:02:51 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y128sm72356576pgy.41.2019.07.26.15.02.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 15:02:51 -0700 (PDT)
Date:   Fri, 26 Jul 2019 15:02:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Sergei Trofimovich <slyfox@gentoo.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2] iproute2: devlink: port from sys/queue.h to list.h
Message-ID: <20190726150249.5f1e6167@hermes.lan>
In-Reply-To: <20190726210105.25458-1-slyfox@gentoo.org>
References: <20190726112956.3b54f906@hermes.lan>
        <20190726210105.25458-1-slyfox@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jul 2019 22:01:05 +0100
Sergei Trofimovich <slyfox@gentoo.org> wrote:

> sys/queue.h does not exist on linux-musl targets and fails build as:
> 
>     devlink.c:28:10: fatal error: sys/queue.h: No such file or directory
>        28 | #include <sys/queue.h>
>           |          ^~~~~~~~~~~~~
> 
> The change ports to list.h API and drops dependency of 'sys/queue.h'.
> The API maps one-to-one.
> 
> Build-tested on linux-musl and linux-glibc.
> 
> Bug: https://bugs.gentoo.org/690486
> CC: Stephen Hemminger <stephen@networkplumber.org>
> CC: netdev@vger.kernel.org
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>

Looks good, thanks for following through.
Applied.
