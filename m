Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D000F117D34
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 02:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfLJBd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 20:33:58 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:46293 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfLJBd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 20:33:57 -0500
Received: by mail-pj1-f66.google.com with SMTP id z21so6654679pjq.13
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 17:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lz2jgCjhsjSBdanP5Xi6rfxGe3ZVUcopSd5AgqFMvY4=;
        b=HrrAaBvu5ZrKUApiRB3ZXOk3raRIC69TCpRgVi6MjOblvxfFCUrIBaV0x5J61dRDRy
         32ehC474dQuc0Hu0NO1apmhvsEtUo9tnKO7LOTpHsyPkEmw698RempaA/m5d/ZW2G03/
         9r/eIVZ3/Bd/uUcdtA+IaP1k/oSbLkKPupPNoJEzqMcKowShlv/TUlldLNt0jYh/s9kn
         bdwNg5BExyLyY16HPZ+fwVKxfGEsUVvt9gqVvJZjSasToZy4CZR4/Z0WqhWVZw/CZiTg
         KbowruIXyD+bVzKgBgeI13i/5F176caI1+500nhwn++FVz8XWvllQSRnPVwmPjzjiRPi
         T6Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lz2jgCjhsjSBdanP5Xi6rfxGe3ZVUcopSd5AgqFMvY4=;
        b=P49Y4Mbfvl4ZPpsZIr+t0fcJ1WDw/Vfn5IorYL4DRvtwBR/gGhl39xjTCu7cSTR1pv
         S1z2y4AX8SPZmwStOcDNcJQQI/TsB/b5NbGz2O9lzxEAeSrFGAfzTqO7q+zqBjnym6q/
         WsoZfe0cWhGHUJYC77k53sXugZiJxieB8bcG0VRjPfnyJVXp/ilDwJbA9w7qrPXdyVBY
         2Am4MGCUMERGucwvE5K64WPPtOic4OZyASaH3v1dNH3++cRlZLlFt4u/z6uDGoKBBFEz
         QCksMEGutWLxM008cl7OmAjluyquraNfAwvJ6GjocYe2aOcXKzAH9y4Zj+lDi4uOnaCo
         t6Zw==
X-Gm-Message-State: APjAAAXPjPz79/G0U8s6psqX13a4HmYl+RKqXfexZvGKLxd2zfTknSpx
        mLrpLvp5HHFlkj1u39NO5yFDVw==
X-Google-Smtp-Source: APXvYqzEiwc8JmGrzzfX3cuGnpphseHbuyQPaGdwrkhTp+6snh25AimwpnNHKLybEAvi8KszEKWWHg==
X-Received: by 2002:a17:90b:f06:: with SMTP id br6mr2349106pjb.125.1575941636989;
        Mon, 09 Dec 2019 17:33:56 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j38sm779975pgj.27.2019.12.09.17.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 17:33:56 -0800 (PST)
Date:   Mon, 9 Dec 2019 17:33:53 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 03/15] libbpf: move non-public APIs from
 libbpf.h to libbpf_internal.h
Message-ID: <20191209173353.64aeef0a@cakuba.netronome.com>
In-Reply-To: <20191210011438.4182911-4-andriin@fb.com>
References: <20191210011438.4182911-1-andriin@fb.com>
        <20191210011438.4182911-4-andriin@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Dec 2019 17:14:26 -0800, Andrii Nakryiko wrote:
> Few libbpf APIs are not public but currently exposed through libbpf.h to be
> used by bpftool. Move them to libbpf_internal.h, where intent of being
> non-stable and non-public is much more obvious.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/bpf/bpftool/net.c         |  1 +
>  tools/lib/bpf/libbpf.h          | 17 -----------------
>  tools/lib/bpf/libbpf_internal.h | 17 +++++++++++++++++
>  3 files changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> index 4f52d3151616..d93bee298e54 100644
> --- a/tools/bpf/bpftool/net.c
> +++ b/tools/bpf/bpftool/net.c
> @@ -18,6 +18,7 @@
>  
>  #include <bpf.h>
>  #include <nlattr.h>
> +#include "libbpf_internal.h"
>  #include "main.h"
>  #include "netlink_dumper.h"

I thought this idea was unpopular when proposed?
