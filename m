Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7270C8559D
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 00:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388919AbfHGWQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 18:16:54 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44985 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388866AbfHGWQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 18:16:54 -0400
Received: by mail-pl1-f193.google.com with SMTP id t14so42595274plr.11;
        Wed, 07 Aug 2019 15:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yka6QBnpXGBVg7YAzRcillX/vAGUpKTOeMf+z/itpAM=;
        b=UUPSm8UraT0ABOXwRCdfveBm/Ewp54mgDurHJpnSKpzCC7T44sUAzN7Nnh032HU/vO
         NXQPdPAmQtZ0HjBMSo/8b1i29nYhjuJroNzGI4bmVE+uMISCB0Aa1ziYO/jfr9+aaSrU
         nqTY9JO8kCogNYKQ47IPP1oLlc10cEhlLzKRS6QY/dw6tIq6klm7FvM7GPL+GkfKLoxC
         G+7Egrq01fswZfKscy4DubqzIhAeISdj+CBIYz9ItYafXHz0GlesB6TQmWAshO7af9lu
         d2kR2/ArcYvdM4ve2KfTqKF5yJTt0BaBD2wBLlNitBmhLDnw+KCCkHYbMchHmpqu+9IG
         ce2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yka6QBnpXGBVg7YAzRcillX/vAGUpKTOeMf+z/itpAM=;
        b=WXgfwzVMK94UQXI4Rjqkr7bt67MAvFAJdXTXufFCsSy40gr4MSrj1iCtPV0z2QV81+
         NZ3rtNDWpn0Le6d7f8eF81jKEPzOmFT7RhmgiF5yqihMBvH4cLVmqxmuPLVUocaS8bWZ
         1idEiLb3Ark3Hf/UgPWbDz5iCM6cH/bkhi00nOm+6Z1d1aKN0ggMK3KqXCDyb33NTg8i
         z+vCAchASQhozYQr5SgM+FPNCSQJmXxISm+liNLjsRP1dwX59vGPB8QqtGyCKg3J8NKP
         JbcAfYtvinbrix8HvAgz/KjIQC05dba71Qi/YSB35d2vkxiLt3hhiQBU93Y5Ikco4l5n
         Pg1Q==
X-Gm-Message-State: APjAAAVz/Fd8GDfa5pogY+sSjp/wHBBM44oszKCdk5hhH+Dsb8b9jjpo
        4264CNRmesxAJgkfjuHNoAM=
X-Google-Smtp-Source: APXvYqxMQ30j91F83ridn3wyvt6DNvzDXsaQGSFrxa5JTiJSqsgQFP9YSYeUXea9NfrKJ/vUx7uvdg==
X-Received: by 2002:a17:902:aa8a:: with SMTP id d10mr10588840plr.154.1565216213317;
        Wed, 07 Aug 2019 15:16:53 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::7084])
        by smtp.gmail.com with ESMTPSA id c98sm220370pje.1.2019.08.07.15.16.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 15:16:52 -0700 (PDT)
Date:   Wed, 7 Aug 2019 15:16:51 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, yhs@fb.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH v6 bpf-next 04/14] libbpf: implement BPF CO-RE offset
 relocation algorithm
Message-ID: <20190807221649.fiqo2kqj73qjcakr@ast-mbp>
References: <20190807214001.872988-1-andriin@fb.com>
 <20190807214001.872988-5-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807214001.872988-5-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 02:39:51PM -0700, Andrii Nakryiko wrote:
> This patch implements the core logic for BPF CO-RE offsets relocations.
> Every instruction that needs to be relocated has corresponding
> bpf_offset_reloc as part of BTF.ext. Relocations are performed by trying
> to match recorded "local" relocation spec against potentially many
> compatible "target" types, creating corresponding spec. Details of the
> algorithm are noted in corresponding comments in the code.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> Acked-by: Song Liu <songliubraving@fb.com>
...
> +static struct btf *bpf_core_find_kernel_btf(void)
> +{
> +	const char *locations[] = {
> +		"/lib/modules/%1$s/vmlinux-%1$s",
> +		"/usr/lib/modules/%1$s/kernel/vmlinux",
> +	};

the vmlinux finding logic didn't work out of the box for me.
My vmlinux didn't have -`uname -r` suffix.
Probably worth adding /boot/vmlinux-uname too.
May be vmlinuz can have BTF as well?

Overall looks great. Applied to bpf-next. Thanks!

