Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811451C5BD8
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgEEPmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729447AbgEEPmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 11:42:17 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499E0C061A0F;
        Tue,  5 May 2020 08:42:17 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id k12so2318040qtm.4;
        Tue, 05 May 2020 08:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OdSiaVzqGpXkKErkBltChUbo57smog+mPGXXST7mpwE=;
        b=swOHeOWR+HuU6TtVziCADaRF6lOWBfKvUpUX8SVljvZscu1Iz4LWJEZNcUdU9+cjIo
         WGjooglq64KqR0LMuLqXbZlaVO0oqb9oEZNJok4mBm7CtcG4YI4KDq0vHslEFi/ZAyb9
         8ij98N+MzWxd9N5Iwgi9cbUBr3ErTo8StfSvrSJ7Lx1ItCjO3+dLF4Jie5eGLEZ6uafD
         2BEirE8E9hyHYFrtmuhamxMUqyYbUNpWtJr1pxMaznzCpHVKheb+MFVKn5Y7eHigvybY
         xblDiVnKGSO1YOVZCBOhDyivCijimZrtwgQUMs6QzuaU2V0EFW5hbL22ycsa7Hc27KUL
         dPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OdSiaVzqGpXkKErkBltChUbo57smog+mPGXXST7mpwE=;
        b=qjHLX1Kwl6V7eJppyVhl308jh3lmghSqQMjaheYHrRBJW57CgpD5gCWc5B2diyGdwa
         9uIuWL49fU+gSHn20va+5+4/akQQPvS3Glq7iRXDkzICC5ikiCxUGNWVh078lvjSNVzM
         1l+mDXA/lKwvGDGaZlXFO1fL3+m04huiLqc3WZ33HHYiZ3vQd/0oHwsyOFZk6dRT2PNi
         wE3tQy+yv0p+4LkB68bXnvD9hMNQa6JQxvX3VgjgvWqAzYzoRGhW867RTWWd6AfOuDnE
         f5Lhb+zDsXsUdcZLn3ke3b2YF4Jy/yuHaZT6yJyLtipN41L9yQrf05I32bGUIAo5wM/X
         2E4A==
X-Gm-Message-State: AGi0Pua3xZlhx8eu5ciysPyZijHshf/9CNWYbbLld7lS/NqqEI9bLGQW
        TB5oGECIBvwKwy3p/bGndtsG1D8P
X-Google-Smtp-Source: APiQypJ88ZbYg7+35egNTg+Nfq1JqkXSNm9MjWkXgtZgOUWm6nDxFFp7G7QadeEJbnIW+iiXF7VSjw==
X-Received: by 2002:ac8:82f:: with SMTP id u44mr3244954qth.198.1588693335969;
        Tue, 05 May 2020 08:42:15 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c19:a884:3b89:d8b6? ([2601:282:803:7700:c19:a884:3b89:d8b6])
        by smtp.googlemail.com with ESMTPSA id e3sm749294qkd.113.2020.05.05.08.42.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 08:42:15 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 1/2] ss: introduce cgroup2 cache and helper
 functions
To:     Dmitry Yakunin <zeil@yandex-team.ru>, netdev@vger.kernel.org
Cc:     khlebnikov@yandex-team.ru, cgroups@vger.kernel.org,
        bpf@vger.kernel.org
References: <20200430155245.83364-1-zeil@yandex-team.ru>
 <20200430155245.83364-2-zeil@yandex-team.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7edb94ab-badb-e2f5-42fc-f04d38d29791@gmail.com>
Date:   Tue, 5 May 2020 09:42:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430155245.83364-2-zeil@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

global comment. iproute2 uses the net coding style of reverse xmas tree
for declarations. There are a number of places that need to be fixed up.

On 4/30/20 9:52 AM, Dmitry Yakunin wrote:
> diff --git a/lib/cg_map.c b/lib/cg_map.c
> new file mode 100644
> index 0000000..0a1d834
> --- /dev/null
> +++ b/lib/cg_map.c
> @@ -0,0 +1,133 @@
> +/*
> + * cg_map.c	cgroup v2 cache
> + *
> + *		This program is free software; you can redistribute it and/or
> + *		modify it under the terms of the GNU General Public License
> + *		as published by the Free Software Foundation; either version
> + *		2 of the License, or (at your option) any later version.

Drop the boilerplate in favor of SPDX line

> + *
> + * Authors:	Dmitry Yakunin <zeil@yandex-team.ru>
> + */
> +
> +#include <stdlib.h>
> +#include <string.h>
> +#include <stdio.h>
> +#include <stdbool.h>
> +#include <linux/types.h>
> +#include <linux/limits.h>
> +#include <ftw.h>
> +
> +#include "cg_map.h"
> +#include "list.h"
> +#include "utils.h"
> +
> +struct cg_cache {
> +	struct hlist_node id_hash;
> +	__u64	id;
> +	char	path[];
> +};
> +
> +#define IDMAP_SIZE	1024
> +static struct hlist_head id_head[IDMAP_SIZE];
> +
> +static struct cg_cache *cg_get_by_id(__u64 id)
> +{
> +	struct hlist_node *n;
> +	unsigned int h = id & (IDMAP_SIZE - 1);
> +
> +	hlist_for_each(n, &id_head[h]) {
> +		struct cg_cache *cg
> +			= container_of(n, struct cg_cache, id_hash);

Don't split the line like that. Since you need 2 lines just do:
+		struct cg_cache *cg;
+
+		cg = container_of(n, struct cg_cache, id_hash);

> +		if (cg->id == id)
> +			return cg;
> +	}
> +
> +	return NULL;
> +}
> +




