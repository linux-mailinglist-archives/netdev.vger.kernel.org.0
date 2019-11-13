Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E69FB95C
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfKMUGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:06:12 -0500
Received: from mail-il1-f182.google.com ([209.85.166.182]:39097 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfKMUGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:06:12 -0500
Received: by mail-il1-f182.google.com with SMTP id a7so2970584ild.6;
        Wed, 13 Nov 2019 12:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=kdU3fjSgmWDzNf99f7FZMS2rbqW++6sSQgwzS5i6F9o=;
        b=t9W8gWf0eDVu74707uM9+e3piS0zpBlov14HqKvLfWD8QgXucoRVYz9o/Glzg+NNve
         QqgoH2JyZnlrk04HXmgOTsw4EV7T6b/iHmKqVRVDkyLvD/JJ5WFTCjCLoMGAddkMlpT2
         0KhjHOLoQKZRzQseF+llu/AO1MywzoAjn0tzUQFbOXdKuz7t/H0rV9BHsrV3sawcow8a
         ChltWUn0DBDRqnkfPp4Jx5f0nu1bLJfKDFVvhz3NFz31qbNoprFtzBsUPlOe283jqYu0
         efXt6Sr5TvxqenS8patZ+R+lrAM/O7wefFTNqxsQTj7BlLJ+t7clOKrKQ2SecMZcAp4X
         t9aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=kdU3fjSgmWDzNf99f7FZMS2rbqW++6sSQgwzS5i6F9o=;
        b=p6rQSaUIriu8OkHrZ1cbZdjcwqbvTAV7s7J9RUWuk5cHFrWFvKmKtTw7H7WSx5zQMr
         d1FSdqbX+nUqFJxhvsKUHS0J8PmKfr4qXpIWOxinR06UJ66CUQqrM80w0xSQ3aRQhGSI
         yKJcaOTY8HCV5Y8/XievBDoCWYNGTRDeffoK4qraUvOcaAl0JmZtLpPRhdkIBsRQijxn
         QL/JfIn0Jh5ux6sjd6DUCuTiJDFdCIFOpGKti0wEcrPkz5Knn6r2ZQi8kEbECupxQb05
         lMRwlyUt3agTGog/OCPBQZpGHwGDfi1N2ptLFnsvwv9hKhx7ryR53rorE817p3GLWOnC
         /VFA==
X-Gm-Message-State: APjAAAVeUwy1yLhrwPf4KywMgRnLg4rmXaDJ7VvjLaBiO05D8MD6Fl4j
        M17/ccqRwfD5f1ur9n/LA+Q=
X-Google-Smtp-Source: APXvYqzkgw/hxIMzCjJeeqnNoBSxnVXSKEYoPfWvfgDZvSfEdEFELnGJU7pB2OZMrlWKR6AOVlqu0g==
X-Received: by 2002:a92:680e:: with SMTP id d14mr6365828ilc.224.1573675571614;
        Wed, 13 Nov 2019 12:06:11 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z69sm412453ilc.30.2019.11.13.12.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 12:06:10 -0800 (PST)
Date:   Wed, 13 Nov 2019 12:06:00 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Message-ID: <5dcc622873079_14082b1d9b77e5b420@john-XPS-13-9370.notmuch>
In-Reply-To: <20191113031518.155618-2-andriin@fb.com>
References: <20191113031518.155618-1-andriin@fb.com>
 <20191113031518.155618-2-andriin@fb.com>
Subject: RE: [PATCH v3 bpf-next 1/3] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Add ability to memory-map contents of BPF array map. This is extremely useful
> for working with BPF global data from userspace programs. It allows to avoid
> typical bpf_map_{lookup,update}_elem operations, improving both performance
> and usability.
> 
> There had to be special considerations for map freezing, to avoid having
> writable memory view into a frozen map. To solve this issue, map freezing and
> mmap-ing is happening under mutex now:
>   - if map is already frozen, no writable mapping is allowed;
>   - if map has writable memory mappings active (accounted in map->writecnt),
>     map freezing will keep failing with -EBUSY;
>   - once number of writable memory mappings drops to zero, map freezing can be
>     performed again.
> 
> Only non-per-CPU plain arrays are supported right now. Maps with spinlocks
> can't be memory mapped either.
> 
> For BPF_F_MMAPABLE array, memory allocation has to be done through vmalloc()
> to be mmap()'able. We also need to make sure that array data memory is
> page-sized and page-aligned, so we over-allocate memory in such a way that
> struct bpf_array is at the end of a single page of memory with array->value
> being aligned with the start of the second page. On deallocation we need to
> accomodate this memory arrangement to free vmalloc()'ed memory correctly.
> 
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

[...]

> @@ -102,10 +106,20 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
>  	}
>  
>  	array_size = sizeof(*array);
> -	if (percpu)
> +	if (percpu) {
>  		array_size += (u64) max_entries * sizeof(void *);
> -	else
> -		array_size += (u64) max_entries * elem_size;
> +	} else {
> +		/* rely on vmalloc() to return page-aligned memory and
> +		 * ensure array->value is exactly page-aligned
> +		 */
> +		if (attr->map_flags & BPF_F_MMAPABLE) {
> +			array_size = round_up(array_size, PAGE_SIZE);
> +			array_size += (u64) max_entries * elem_size;
> +			array_size = round_up(array_size, PAGE_SIZE);
> +		} else {
> +			array_size += (u64) max_entries * elem_size;
> +		}
> +	}

Thought about this chunk for a bit, assuming we don't end up with lots of
small mmap arrays it should be OK. So userspace will probably need to try and
optimize this to create as few mmaps as possible. 

[...]

Acked-by: John Fastabend <john.fastabend@gmail.com>
