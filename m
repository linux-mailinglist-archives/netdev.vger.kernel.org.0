Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2FE08855D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 23:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfHIV5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 17:57:30 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33452 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfHIV5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 17:57:30 -0400
Received: by mail-qt1-f194.google.com with SMTP id v38so4910864qtb.0
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 14:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=yV103YfFg9VEc6lG16/qc9SdJRxEcQERkIDn+IdI/gk=;
        b=esPlYlRFbM82ezZuqCnKQTm2f5qcze3oCG631Z3k+bWdX8xh1+8HokcyxsqopT5GoZ
         8K8Dfrj1mhG0cU+g7MfVXCY6O7vU1FOWKAuIoNFNValzAP8CeOMJ8b914ndWsMRlP992
         DRrys8UquPQig11sYWZnbUYyaNGpO4A/9GEO1GZw/4CzbNdOUTLzGdizwRjQh9jCXtEn
         CC2OYEX3TiCqHwOFhapuVOCUDMR/uNAyKpd87LpzSmtHs2K4+YlqYlvHGeqdESRyKSMN
         /u9yrMsPnLrY6Uy9hR7T4aoQHqO/EmoUSuTP5/tSs8jMd8VTqjXxi8sytU1SmH12/qPo
         Brcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=yV103YfFg9VEc6lG16/qc9SdJRxEcQERkIDn+IdI/gk=;
        b=J+EPhUCBAAs8BVDgaQFHlIaEhSjy01aTjYvMjIxMHEakPVWbav0oe+10N6L088G9pK
         +7I49qmW/AtUEN/zltT8BcXmgMU5yF5wUJPlajgezzSXoXFRerMD9YMya0fgWY2E/IGR
         Qa3cC4LeBN2rv1lpDB5NzMIwLS3BisTp7p1cjushreUs9YbtCNcxLYWDzCKh22JiPmaA
         cwPZSQ9A32XtCk5vD6/OxFSwWp4xpw5TYC4btl/Hxvggnfrju/YNM+/sYhU1IowSrloY
         fIc6npHVC2sFEjAcO+FmYfQ6PYcNcZwGGBpvBGUTXOWin8p5jXTtSY8UEqU5B+hoF8gr
         pGvQ==
X-Gm-Message-State: APjAAAX1tS8rfub0nc0utAjn8kk0MoA0Q8gqf2x8TM/4Yaoj6vB5VkeC
        t/kTWgYYb31GT9w+JFglwjHQPw==
X-Google-Smtp-Source: APXvYqyrRPCSII1QoXeWuVQQtT5xjHb2xgZU0hwNhJMYc2TemyzTfmk7wyHy9hLHZPvxVawmjH6LOA==
X-Received: by 2002:ac8:2ae8:: with SMTP id c37mr20129070qta.267.1565387849660;
        Fri, 09 Aug 2019 14:57:29 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t14sm5640743qkm.88.2019.08.09.14.57.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 14:57:29 -0700 (PDT)
Date:   Fri, 9 Aug 2019 14:57:26 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Peter Wu <peter@lekensteyn.nl>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH v3] tools: bpftool: fix reading from /proc/config.gz
Message-ID: <20190809145726.2972fa7a@cakuba.netronome.com>
In-Reply-To: <20190809214831.GE2820@mini-arch>
References: <20190809003911.7852-1-peter@lekensteyn.nl>
        <20190809153210.GD2820@mini-arch>
        <20190809140956.24369b00@cakuba.netronome.com>
        <20190809214831.GE2820@mini-arch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Aug 2019 14:48:31 -0700, Stanislav Fomichev wrote:
> I'm just being nit picky :-)
> Because changelog says we already depend on -lz, but then in the patch
> we explicitly add it.
> 
> I think you were right in pointing out that we already implicitly depend
> on -lz via -lelf and/or -lbfd. And it works for non-static builds.
> We don't need an explicit -lz unless somebody puts '-static' in
> EXTRA_CFLAGS. So maybe we should just submit the patch as is because
> it fixes make EXTRA_CFLAGS=-static.

Mm. Sounds reasonable. Fixing EXTRA_CFLAGS=-static would be really cool,
too, I always struggle to get a statically linked build.

> RE $(error): we don't do it for -lelf, right? So probably not worth
> the hassle for zlib.

Right, OTOH bpftool doesn't really care about -lelf, it's libbpf that
needs it, and libbpf does test.
