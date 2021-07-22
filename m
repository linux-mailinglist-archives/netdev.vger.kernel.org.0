Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEC93D2FEC
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 00:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhGVV7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 17:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbhGVV7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 17:59:09 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E96C061757
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 15:39:44 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so1231617pji.5
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 15:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=464kg1T68pC5HwMKv9Atpe0ec1sq9kytcANNnpthBek=;
        b=yS/hsbwawQ19QCicvuWG6QDZq0p315I7hOo/EtTmA9IHLQNCHUWlv+iOFl/Ly8W4T5
         0At4dkxFnyw1F5/AMAwjsjEFAkxOfYyPOBGS68vy6pk+r1+FsG+aiaoCRqPDaUOgvOYR
         umlEpbfBd0uf4HJQW1eWcFo0U/E7ZEKM7dhGKoTKtOhLFRsvJuzYzCPTTHqUDYYn3v0w
         eQJ/PNeDz9gPOhSvqVHwbuSjw3XMo39aqPtmFh5bz0IRu7dxG1b4MNwJXV98y3vClhJL
         CBDYyPrdKoijtYt2L8LNvOzvKuOX8msDMvBPxhomXUOhvDxXbB9/YJjywRsXe0l8PMht
         Q3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=464kg1T68pC5HwMKv9Atpe0ec1sq9kytcANNnpthBek=;
        b=ToRstX4PzKk6/54H4PTDjlr/da8+AybxY9lgIL8EYW2mZmaCqyJoOjAoiFH/CWGz1w
         E93FQOgTyGhewbfeL68U0Vt56+vfp/azPPxtXFiZiBdtAx5a/eiU5vU6A3qoRK40kTSP
         YGgEsA2pMvnHDnRlQslUFhy2Czo/iH6uYQg22oP2x2iAxDdxtG477jws0rcm951hcDSE
         SjdWVkJHh5yrqFsrgAQjTEKqEnUPiEFeHzl1OV+VsbpCvlKHpXs5bwEmkt0pRduHstx6
         FuYST22ToZ43IrJbp/1F6WKUaqvj4Q3YaT0u6dm0g1POHFD9XZY/OS4PbtUOJ6Ez0azI
         64tg==
X-Gm-Message-State: AOAM530LQLgb0o6WToSbKVQDmkxG1apYHiM+Z31CyQRO3nRznsNOO8YE
        y+U1KP7LUvknivTMp15ZV/epkQ==
X-Google-Smtp-Source: ABdhPJyDUgyzv99y/lDZIzirOw2rLLLDML8ftb5T/FAs9qRdcruNT4j6gmNAEv7kfBkJ19Tk0Oil2w==
X-Received: by 2002:a63:1718:: with SMTP id x24mr2084278pgl.416.1626993583767;
        Thu, 22 Jul 2021 15:39:43 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id g123sm30673812pfb.187.2021.07.22.15.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 15:39:43 -0700 (PDT)
Date:   Thu, 22 Jul 2021 15:39:39 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     gregkh@linuxfoundation.org, tj@kernel.org, shuah@kernel.org,
        akpm@linux-foundation.org, rafael@kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, andriin@fb.com,
        daniel@iogearbox.net, atenart@kernel.org, alobakin@pm.me,
        weiwan@google.com, ap420073@gmail.com, jeyu@kernel.org,
        ngupta@vflare.org, sergey.senozhatsky.work@gmail.com,
        minchan@kernel.org, axboe@kernel.dk, mbenes@suse.com,
        jpoimboe@redhat.com, tglx@linutronix.de, keescook@chromium.org,
        jikos@kernel.org, rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/module: add documentation for try_module_get()
Message-ID: <20210722153939.08a6853c@hermes.local>
In-Reply-To: <20210722221905.1718213-1-mcgrof@kernel.org>
References: <20210722221905.1718213-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Jul 2021 15:19:05 -0700
Luis Chamberlain <mcgrof@kernel.org> wrote:

> +/**
> + * try_module_get - yields to module removal and bumps reference count otherwise
> + * @module: the module we should check for

You have the right intentions, but this patch needs some work.

This looks like a docbook comment format but isn't that format.

The first couple of lines need to be reworded to be a complete sentence like
the rest.

In general best to make new comments the same as existing comments
in the same area.

It would be better to put this description in the header file where other
docbook comments for module API are. See example around module_init() and module_exit().

Ideally, all the api's around module reference counts would be documented there.
