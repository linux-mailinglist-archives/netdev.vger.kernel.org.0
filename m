Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9BA2BBC6A
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 03:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgKUCwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 21:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbgKUCwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 21:52:32 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF1CC0613CF;
        Fri, 20 Nov 2020 18:52:31 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id v21so4619623plo.12;
        Fri, 20 Nov 2020 18:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8mnAmGJVt0wk6lg3SP3cGYFCzdDtUly5uoisYFOO9NU=;
        b=oqddmQSaU7WxHgpLmUVJ3J/xq9Qc7OBKmNm7a0BKlSQr3MoqAomFOFFsLIsIw6DJq3
         /QHzlkkasHDOo3v4171XEcXqb3a4lYFisi9DNc+B3mNU/KYq+xci3EVlzL3wfKqzm2lb
         uQEJKprdNpnnkzxfAXTalB0uBbULuaa0vMmo8/JeNss5QWEHB9ikM+QGfnDR7bIIyQNB
         b8FnDaVuiwv/cSB3BgeqXYwOZxYd8Giwiyfv8Ddc5Jd+tmCsE5yiCaEgavHZe5rdkw1G
         u74/rBpKLHY2jTrgzCld1FTwH4l4/9M4X5tRT0dJRyCb9/mrQQ8rybAkPGry71TWvA+s
         dpyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8mnAmGJVt0wk6lg3SP3cGYFCzdDtUly5uoisYFOO9NU=;
        b=HAdT8txvSldq3vocvVMn87KPa1FDfv9dyXkJwcErOuiIshOXoqIT3965RfPgnMiVih
         1eY2RkbBD0Y83Tmm+Tho06FH0zEde+LAPouDFWgLI/HiKIG1fV1Ng7owDeetBnRLaUgJ
         9fy98aN/ResSJJVDWWZBY7aL2m7YQeT/YyuEFjtQdk0IM+fh43vxoptcXwg/yD1ITMbD
         31H8L3MI9YhqCfDg32SfpMefa6jxM5KSA18O/Hnpc7jBPHkkhGzhYSnShqj3dw4o9SlF
         woy3RrvGexH+d2HxS5tYP5e1AQjNUK99Yo0x2Uco5w9bzfsnnta9h+Pv/ezzg4P787c1
         oJ1A==
X-Gm-Message-State: AOAM533AyU5KNdbdBvsFn3rXw4ifqM4HmUmN/PYXv5i0HuebVuBMsPgd
        H8UAiZt988JoxrDw2VK5Neg=
X-Google-Smtp-Source: ABdhPJwrc478tMIxFH4OkcAptTBlTCM05uMFT4s3vs8gHDP9iAVDcZEGToVd5Fs2EDy3HYaVV9Ze9A==
X-Received: by 2002:a17:902:8691:b029:d7:e0f9:b1b with SMTP id g17-20020a1709028691b02900d7e0f90b1bmr16912308plo.37.1605927150967;
        Fri, 20 Nov 2020 18:52:30 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:501])
        by smtp.gmail.com with ESMTPSA id h7sm5203491pgi.90.2020.11.20.18.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 18:52:30 -0800 (PST)
Date:   Fri, 20 Nov 2020 18:52:27 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, andrii@kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next v7 32/34] bpf: eliminate rlimit-based memory
 accounting infra for bpf maps
Message-ID: <20201121025227.dypweojhaz7elwb3@ast-mbp>
References: <20201119173754.4125257-1-guro@fb.com>
 <20201119173754.4125257-33-guro@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119173754.4125257-33-guro@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 09:37:52AM -0800, Roman Gushchin wrote:
>  static void bpf_map_put_uref(struct bpf_map *map)
> @@ -619,7 +562,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
>  		   "value_size:\t%u\n"
>  		   "max_entries:\t%u\n"
>  		   "map_flags:\t%#x\n"
> -		   "memlock:\t%llu\n"
> +		   "memlock:\t%llu\n" /* deprecated */
>  		   "map_id:\t%u\n"
>  		   "frozen:\t%u\n",
>  		   map->map_type,
> @@ -627,7 +570,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
>  		   map->value_size,
>  		   map->max_entries,
>  		   map->map_flags,
> -		   map->memory.pages * 1ULL << PAGE_SHIFT,
> +		   0LLU,

The set looks great to me overall, but above change is problematic.
There are tools out there that read this value.
Returning zero might cause oncall alarms to trigger.
I think we can be more accurate here.
Instead of zero the kernel can return
round_up(max_entries * round_up(key_size + value_size, 8), PAGE_SIZE)
It's not the same as before, but at least the numbers won't suddenly
go to zero and comparison between maps is still relevant.
Of course we can introduce a page size calculating callback per map type,
but imo that would be overkill. These monitoring tools don't care about
precise number, but rather about relative value and growth from one
version of the application to another.

If Daniel doesn't find other issues this can be fixed in the follow up.
