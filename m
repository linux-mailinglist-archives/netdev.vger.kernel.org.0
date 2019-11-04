Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B73AEE4A9
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 17:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbfKDQ3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 11:29:44 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33426 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbfKDQ3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 11:29:43 -0500
Received: by mail-pg1-f194.google.com with SMTP id u23so11624595pgo.0
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 08:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=yDJzuHaFrgDE1koaL4VlaTE201wYefd3OwCvYO8ysEU=;
        b=PfsYHrTRK/P8+qRQn8NZ79YZ2CjKL1sum8VuGgpn8h9BLbBW7CZql+HC8UWdA7p2+L
         cEyGOwBWZaqjUkm/0Z6U9XtvNhIbzziY8UCWrXTGhoLQf+h7WUIiT0sV91wgiucBFShk
         jqkhbQqemKwmthXRxZXjY0dY99BQsVkF6mDP112JH0PCgTrDkL/OE8I/V8DWscn8eEVy
         9YCihiMSS72wFW5oL56XBsUVgjtU0b+LdyvpIHLSPsPnOx6KsaQ+HaexF8gAdo7tcHub
         EKZqSzm8zCniN6MaVWfVHf0ValeVg+vB1PqjdGzIIU00morL98KbP1Wtww6fQ+SahL2c
         VPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=yDJzuHaFrgDE1koaL4VlaTE201wYefd3OwCvYO8ysEU=;
        b=NEzd68++sB37/BA+nkDiXw07LpuGvRohpxq1EkGB4XBkvHG+7L+v2J1Xx1BbrdD/3D
         YcNf1BRFFonarRg/MyoXibbj8LAiQyoodeqEuF0L1v4XCOdf7GWgq0ixPx7mL1iro3bN
         p/KJEEH10UPBPmZfYmZn1KZ25ljZg38TGMi7/2rWEP5GZUg9HwzVj9n2lIfo+ShhWX9E
         tzl6gNZX5fFgWFJRbQ3wk7DOulF9fLPLHQlvNOsz1UPJgNPPR/fsSiGCgfoYfcWOZ+6z
         D5Kjqr/3kbG76DCVLZ/l6z2wlnZsRXDm3MDVstD2ANb4X3YLqEJ0kBG4GhisqRpriMIs
         mVCA==
X-Gm-Message-State: APjAAAUEqEvDt4l6DcpkwJRw87kpzPiztd63LG9OU/LgR9cLN72olu2G
        A/0CL1iV3Qd5723TyFEdvH3eMQ==
X-Google-Smtp-Source: APXvYqwpiP2aKfBZwiONDK30yJFr79JwBMg1oHg1YfDywuN4GIzwpS1bI4ZA7pGHqCSOKyoITCVseg==
X-Received: by 2002:a17:90a:5d0f:: with SMTP id s15mr36068769pji.90.1572884982928;
        Mon, 04 Nov 2019 08:29:42 -0800 (PST)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::4])
        by smtp.gmail.com with ESMTPSA id 6sm17328038pfz.156.2019.11.04.08.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 08:29:42 -0800 (PST)
Date:   Mon, 4 Nov 2019 08:29:38 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH bpf] bpf: offload: unlock on error in
 bpf_offload_dev_create()
Message-ID: <20191104082938.351c1f07@cakuba.netronome.com>
In-Reply-To: <20191104091536.GB31509@mwanda>
References: <20191104091536.GB31509@mwanda>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Nov 2019 12:15:36 +0300, Dan Carpenter wrote:
> We need to drop the bpf_devs_lock on error before returning.
> 
> Fixes: 9fd7c5559165 ("bpf: offload: aggregate offloads per-device")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
