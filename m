Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0F946A345
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244299AbhLFRp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244218AbhLFRpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 12:45:52 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E57DC061D5F;
        Mon,  6 Dec 2021 09:42:23 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id z26so13846745iod.10;
        Mon, 06 Dec 2021 09:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=C8/RDaniZ86S5c9Z/M5oMEJ9mpn6f+Z6Ax+hxsm2cKA=;
        b=mrz41PLO0ref7/5psXNYlpA405dnTiYcRpibTvgYvIpopQhCmtd1CiQ9epj7W5zDoR
         KdfT1pS6dG674KO3oMB6LqaDlyypIb0xPRdVTmXTvR0t0wTuFMciB51n2LjTiu6/1nAZ
         PK7H7nEZZHzT3aiZNahdIFUdYxwXYEt9HwyRgzt5OPsSeqN0srLw6Umh5RwmpORQWbbQ
         Vzqk07t1/lnPdoVkVZ3NpEmol7bHBvQPXsdANCKzo6md0mcn8n9MOqHSmXLQXhHM6lg9
         4lq2f4vHb1/mezumYvNwp8WeOMLVcCEzPJx8367CE6zAwWGKv+Qodvfyc3G08CSZVIgn
         3x5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=C8/RDaniZ86S5c9Z/M5oMEJ9mpn6f+Z6Ax+hxsm2cKA=;
        b=4q03NLjFFpNpkDRBzbf17n+j7Y1rtMZzrzeF+bdmCD+YuOnCfItsEc4GPAsAXJ/tuk
         3ApNqtwLYQjprbW9KX6MAliuLcsiOc7ho7DL3hS3QRlD4wrHPJdpa7aAUeVujBRu20W4
         tlmpZte4Ia0pRC/57LCba8HJV4mNSjFHvsx6YQD8xctF2YMiFkl3oxqnS3MAtrJNzWrw
         APz8L3bBUH/o9kt4bSlEJi3VyRvb/LwrauuNG8K+xKrWKCzTg4+hL8QL4jnIEovpTisV
         vL1MSH9SeYiLcttYDx7iHfSDmP8tbOksE/VkiOWEuNcAKKtjJLRA1sQ35d8DR6Zr/ZsK
         rJkA==
X-Gm-Message-State: AOAM531gLjhZKuq9YXQE9ktUAOgxzvbLMVb5Btk+0drmsppQFPUFLenW
        NC+lvg2OwMG05gud5GMTsKwiKSJoK4woFQ==
X-Google-Smtp-Source: ABdhPJy4P8U1nrSpAypRw6nnwqaPyKM2Fz8KOuDQbKUFDqaxy048B+SBv1ayg54kkBDztmDTS9CwlQ==
X-Received: by 2002:a5e:c707:: with SMTP id f7mr35120068iop.188.1638812542936;
        Mon, 06 Dec 2021 09:42:22 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id h12sm7739520ila.81.2021.12.06.09.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 09:42:22 -0800 (PST)
Date:   Mon, 06 Dec 2021 09:42:14 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <61ae4b768d787_8818208f@john.notmuch>
In-Reply-To: <15afc316a8727f171fd6e9ec93ab95ad23857b33.1638272239.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <15afc316a8727f171fd6e9ec93ab95ad23857b33.1638272239.git.lorenzo@kernel.org>
Subject: RE: [PATCH v19 bpf-next 19/23] bpf: generalise tail call map
 compatibility check
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> From: Toke Hoiland-Jorgensen <toke@redhat.com>
> 
> The check for tail call map compatibility ensures that tail calls only
> happen between maps of the same type. To ensure backwards compatibility for
> XDP multi-buffer we need a similar type of check for cpumap and devmap
> programs, so move the state from bpf_array_aux into bpf_map, add xdp_mb to
> the check, and apply the same check to cpumap and devmap.
> 
> Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> ---

...

> -bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_prog *fp);
> +static inline bool map_type_contains_progs(struct bpf_map *map)

Maybe map_type_check_needed()? Just noticing that devmap doesn't contain
progs.

> +{
> +	return map->map_type == BPF_MAP_TYPE_PROG_ARRAY ||
> +	       map->map_type == BPF_MAP_TYPE_DEVMAP ||
> +	       map->map_type == BPF_MAP_TYPE_CPUMAP;
> +}
> +
> +bool bpf_prog_map_compatible(struct bpf_map *map, const struct bpf_prog *fp);
>  int bpf_prog_calc_tag(struct bpf_prog *fp);

Otherwise LGTM.
