Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098612259C3
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 10:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgGTINf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 04:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgGTINe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 04:13:34 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBE4C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 01:13:34 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f18so16908474wrs.0
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 01:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x8P1vPc3cG56c8OALf51cJaB/JeKKZDLAvU5YGW6lTU=;
        b=UhH69TwMiEgS5M3dopH105B4jH4pQgtQuEQ5FDPzsLu+X35Wnlr2h9aX5DlFdC4cF8
         jzBVmO3YwU89yBk9dvkVhmL9ufmCIczc+toEE3/ZaDH++CGUL+SwO6kYf69cECTBaQKu
         NVKkWUweMZ3EwYPe6u3l83OH0rhwrxo1WDhYVepUGLNjIU5JpJ1hcsoMa25tp4uSq+7H
         3U0GdG9Ti1SHTM4h/bEg80P+DIH5BTgELScpIVPLSlWH2K1j3xNc0MbgvRmq2CxH6Rw4
         FGL96N36FcRO0h3PMPRnxv7xdJM+JADAV2ugnmy15O2Mmeg+aMtdzZkETtLJzi67FbLI
         swBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x8P1vPc3cG56c8OALf51cJaB/JeKKZDLAvU5YGW6lTU=;
        b=Af460IFDWXH8c24fRXRiOxAUIZkYeHi5tCqkI83Uvb+t9T1rJ5qB3i+eJuFGBSzxnt
         TkTsSuCIz9tVpX3DjHBpWoUcjQXGpxkIb0oMptCtGx3vBS9LEjs925ZHogpdUIOM/21a
         mf9z1HfcTNfv9XtuOeKhD2babm3seg5arCYJni0TC9pJpkeBRB5ucjIkN75i27yT/b6W
         YDbhC3T4G/4iPuLyg9N0hAXtEql9YhhZju5JbcZBXHZNVWbsh+uxTNG8dR/9Z5s8L+0V
         SLwYbv8EO14I8W+g9igYorhR9ZMJofkjEWWlviS5czfqm6m33QMgBFak4m61yBbRp2el
         CSkg==
X-Gm-Message-State: AOAM533oTV8YE1XOBWdwcGON8QfGm1pxp7jvzvlIaY50+rZ9JXtNgfcp
        FabdUK+DsnwnZc4PIJUjaPqqtHg4yr8osw==
X-Google-Smtp-Source: ABdhPJz2rpSSnItm9VagCsTdy29JV2ZiCPZ4cDeRA7Cz9uKL39WS4+PGhlf/9pV5cm4BF1KfjM0h7w==
X-Received: by 2002:a5d:5642:: with SMTP id j2mr21012404wrw.19.1595232813251;
        Mon, 20 Jul 2020 01:13:33 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.117.103])
        by smtp.gmail.com with ESMTPSA id v3sm31087315wrq.57.2020.07.20.01.13.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 01:13:32 -0700 (PDT)
Subject: Re: [PATCH bpf-next v3] bpftool: use only nftw for file tree parsing
To:     Tony Ambardar <tony.ambardar@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20200716052926.10933-1-Tony.Ambardar () gmail ! com>
 <20200717225543.32126-1-Tony.Ambardar@gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <fdd2d23f-773d-172c-fce1-0f2641763580@isovalent.com>
Date:   Mon, 20 Jul 2020 09:13:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200717225543.32126-1-Tony.Ambardar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/07/2020 23:55, Tony Ambardar wrote:
> The bpftool sources include code to walk file trees, but use multiple
> frameworks to do so: nftw and fts. While nftw conforms to POSIX/SUSv3 and
> is widely available, fts is not conformant and less common, especially on
> non-glibc systems. The inconsistent framework usage hampers maintenance
> and portability of bpftool, in particular for embedded systems.
> 
> Standardize code usage by rewriting one fts-based function to use nftw and
> clean up some related function warnings by extending use of "const char *"
> arguments. This change helps in building bpftool against musl for OpenWrt.
> 
> Also fix an unsafe call to dirname() by duplicating the string to pass,
> since some implementations may directly alter it. The same approach is
> used in libbpf.c.
> 
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> ---
> 
> V3:
> * clarify dirname() path copy in commit message
> * fix whitespace and rearrange comment for clarity
> * drop unnecessary initializers, rebalance Christmas tree
> * fixup error message and drop others not previously present
> * simplify malloc() + memset() -> calloc() and check for mem errors
> 
> V2:
> * use _GNU_SOURCE to pull in getpagesize(), getline(), nftw() definitions
> * use "const char *" in open_obj_pinned() and open_obj_pinned_any()
> * make dirname() safely act on a string copy
> 
> ---
>  tools/bpf/bpftool/common.c | 132 +++++++++++++++++++++----------------
>  tools/bpf/bpftool/main.h   |   4 +-
>  2 files changed, 78 insertions(+), 58 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> index 29f4e7611ae8..2ecfafcd01df 100644
> --- a/tools/bpf/bpftool/common.c
> +++ b/tools/bpf/bpftool/common.c

>  int build_pinned_obj_table(struct pinned_obj_table *tab,
>  			   enum bpf_obj_type type)
>  {

[...]

>  	while ((mntent = getmntent(mntfile))) {

[...]

> -		while ((ftse = fts_read(fts))) {

[...]

> +		if (nftw(path, do_build_table_cb, nopenfd, flags) == -1)
> +			break;

Sorry I missed that on the previous reviews; but I think a simple break
out of the loop changes the previous behaviour, we should instead
"return -1" from build_pinned_obj_table() if nftw() returns -1, as we
were doing so far.

Looks good otherwise.

>  	}
>  	fclose(mntfile);
>  	return 0;
