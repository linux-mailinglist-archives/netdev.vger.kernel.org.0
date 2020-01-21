Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D43143523
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 02:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgAUBZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 20:25:01 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:41364 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728668AbgAUBZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 20:25:01 -0500
Received: by mail-io1-f68.google.com with SMTP id m25so1054915ioo.8;
        Mon, 20 Jan 2020 17:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UunH37VOr3wHiAzQ1z78FuFG4k7hq/AWUpDbJuZQ/8s=;
        b=f8/UVN62eI1U9B8baJqhLAzBBRiKpGgMGoD24jeM51EwHpuMPJ9s5FBHF3I2SU++uE
         EE+SGUKC1b7MtafrXKhaBZamzlA+hM9HP4mtJZkS3wEAevoOFsoTnsawK/M/9uajOYaJ
         mbfUtSbleweXrO060m/2KO6vveh7joZ7WAwvHk6KOIAxR5hc0YBzW3DUy2LrKZqrF4hL
         1A41TSA4cOEwpPfh8SROB+cvJ0Lf6AcNKODO1VAN5ScrW8AE9Feg5BZK+vOwwTQMhv/+
         r1vibdSx/Sy/fdK9skaQtZ99qF9rBtJFoGgnWPokfqs7sLWVcrWbm35pfjSM2jRjw7as
         9dig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UunH37VOr3wHiAzQ1z78FuFG4k7hq/AWUpDbJuZQ/8s=;
        b=nXSIfeoJvu9axPhV0Pfzdop3JwtVgzDCxBaHHo8IMtKglx5zo7o0U5C+n5Ff1vfERf
         Dmj59FiXdP+AS/qoleOQJXdXLvJ+S/Cg1HK1Y4249eC7ui5mE7aDfzbAGpvmqkK0236n
         CcPl4n0FRLeh7DKWgFKTzaytWm0VMIv+depIfaRdC4sA0QRZ/XxbcJpf5myFfl9pp6Lj
         8CHi+KmgOxboyw2U39wN5pAUEboUECCOQVRwfHg8fgEZ2h6U/RbIuk1Zhujixrj9+NuF
         EtkmC4afYF0F9vOKg1Bj9oZpV2teNmGDigDRDBbW1lL4MvO41elSVFvRQ+p1Hsw6Y8jT
         F0dQ==
X-Gm-Message-State: APjAAAWR60PRNPtGQ5DuFKiT5D43V2tAb0FC5W1AIkME804hZMaZAEud
        AMdrW6oe67r+AjQb74bc8/o=
X-Google-Smtp-Source: APXvYqw8DNLcZzp/P7u6atg+BAJqynOJci3FTqJR+lwPEway5iP/jdFMiJ/GbpHGqon2D/jaODUpag==
X-Received: by 2002:a6b:e90b:: with SMTP id u11mr1284178iof.14.1579569900080;
        Mon, 20 Jan 2020 17:25:00 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f76sm12490214ild.82.2020.01.20.17.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 17:24:59 -0800 (PST)
Date:   Mon, 20 Jan 2020 17:24:52 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Message-ID: <5e2652e4239a8_20912afc5c86e5c49f@john-XPS-13-9370.notmuch>
In-Reply-To: <20200120092149.13775-1-bjorn.topel@gmail.com>
References: <20200120092149.13775-1-bjorn.topel@gmail.com>
Subject: RE: [PATCH bpf-next] xsk: update rings for load-acquire/store-release
 semantics
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> =

> Currently, the AF_XDP rings uses fences for the kernel-side
> produce/consume functions. By updating rings for
> load-acquire/store-release semantics, the full barrier (smp_mb()) on
> the consumer side can be replaced.
> =

> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  net/xdp/xsk_queue.h | 31 ++++++++++++++-----------------
>  1 file changed, 14 insertions(+), 17 deletions(-)
> =

> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index bec2af11853a..2fff80576ee1 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -39,19 +39,18 @@ struct xsk_queue {
>  	u64 invalid_descs;
>  };

Should the xsk_cons_* libbpf routines also be updated then as well?
In general my understanding is the userspace and kernel should be
in sync?=
