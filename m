Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49A84FB9A0
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfKMUVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:21:49 -0500
Received: from mail-il1-f169.google.com ([209.85.166.169]:34494 "EHLO
        mail-il1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfKMUVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:21:49 -0500
Received: by mail-il1-f169.google.com with SMTP id p6so3036402ilp.1;
        Wed, 13 Nov 2019 12:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=BpcTbLaRWudEGQfN/LEwSFlyaDv7GvOqLZgmkBiETUw=;
        b=ZGGT3dVagNxjQ1GG7ZNI2cAVz3sGg7eW61AVKzF8diRye6nJW1WsgMTMExQQfWqOTx
         8y5XVY2j85F+1qSfi9VL+rin2BlSbEmLTQpq7vlvPLbq7WmVlhUkbY5TKk1tSnqj45gX
         lsnI8DpoLKeeYooC1ADolx2sqLXtc/XNHcwX0Jtrx8l1mh/ghX/dpb+ceDtkQYxS177C
         jL5DXkIgapmLyZvE33AHX0BgoGaezOHIExhfhhlejr60ZvZ9GJUhrLvSeghcwosHaNkH
         vnbnzcCUz/8nVadWSX756YqH82LI6sEwG42fK7BIvcyX3WsRD6OXGucz2SuunnViZQFP
         HedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=BpcTbLaRWudEGQfN/LEwSFlyaDv7GvOqLZgmkBiETUw=;
        b=JVwroUKBnPdHTrRiJWpbUixeP4aknlob1KJIlJuwtmux0+6nfOEF508h6efhxYYAQV
         zXJeiQYvxyw2rg0zDhhCnr7p62JcQRQNz0tg5exP36ZWZcvnoNAHFCyK5JQGEx+tHEzy
         3FbHgXupZBednGOCotBbQiGrJHGwH2P03uN0i3ddmPKU4XvaWbT4XFc0NwJDe4ZR+krk
         kgnDjkEjzjCsQ+iu+UCSd1kW5lIyJMsi6vXh2hpjikaSnuwaCkrZkDm3zZjEj4QlIZ8l
         lRXzBe+GuJvovFxHOwAyfomWBIk7coyXAI4Lokuifrpi2tyPE/xOLijR8f3+oTk5B0bs
         tehA==
X-Gm-Message-State: APjAAAWJeyB4ztI/9g7bw9kdXQ0BaNWqCHOFGuDRUCYGTO7M1l+o5LJj
        Y708woxz/uqmuWFis9y7Vsw=
X-Google-Smtp-Source: APXvYqzzKXbawntG3wgVCrAKU5wyXTMg2Wx6dqxfGtd03ynKPupLVFUGpq6xQxYA5VyOrMGF3fOCpg==
X-Received: by 2002:a92:484f:: with SMTP id v76mr6085538ila.279.1573676508198;
        Wed, 13 Nov 2019 12:21:48 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t185sm290672iod.25.2019.11.13.12.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 12:21:47 -0800 (PST)
Date:   Wed, 13 Nov 2019 12:21:39 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5dcc65d33bdfa_14082b1d9b77e5b4eb@john-XPS-13-9370.notmuch>
In-Reply-To: <20191113031518.155618-3-andriin@fb.com>
References: <20191113031518.155618-1-andriin@fb.com>
 <20191113031518.155618-3-andriin@fb.com>
Subject: RE: [PATCH v3 bpf-next 2/3] libbpf: make global data internal arrays
 mmap()-able, if possible
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Add detection of BPF_F_MMAPABLE flag support for arrays and add it as an extra
> flag to internal global data maps, if supported by kernel. This allows users
> to memory-map global data and use it without BPF map operations, greatly
> simplifying user experience.
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

[...]

>  /*
> @@ -856,8 +858,6 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
>  		pr_warn("failed to alloc map name\n");
>  		return -ENOMEM;
>  	}
> -	pr_debug("map '%s' (global data): at sec_idx %d, offset %zu.\n",
> -		 map_name, map->sec_idx, map->sec_offset);
>  
>  	def = &map->def;
>  	def->type = BPF_MAP_TYPE_ARRAY;
> @@ -865,6 +865,12 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
>  	def->value_size = data->d_size;
>  	def->max_entries = 1;
>  	def->map_flags = type == LIBBPF_MAP_RODATA ? BPF_F_RDONLY_PROG : 0;
> +	if (obj->caps.array_mmap)
> +		def->map_flags |= BPF_F_MMAPABLE;
> +
> +	pr_debug("map '%s' (global data): at sec_idx %d, offset %zu, flags %x.\n",
> +		 map_name, map->sec_idx, map->sec_offset, def->map_flags);
> +
>  	if (data_buff) {
>  		*data_buff = malloc(data->d_size);
>  		if (!*data_buff) {
> @@ -2160,6 +2166,27 @@ static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
>  	return 0;
>  }

I was a bit concerned we should fall back to making the call without the
BPF_F_MMAPABLE flag set if it fails but did a quick walk through the call
path and it seems like it shouldn't fail except if vmalloc/vzalloc failures
so seems fine.

Acked-by: John Fastabend <john.fastabend@gmail.com>
