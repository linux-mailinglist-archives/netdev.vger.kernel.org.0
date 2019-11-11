Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD0CF7BBE
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 19:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfKKSjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 13:39:21 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35223 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbfKKSjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 13:39:20 -0500
Received: by mail-pf1-f193.google.com with SMTP id d13so11262639pfq.2
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 10:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0Mu4udifMW2tdEjG6UYU2zT+RxK9F/wgdArkhXdHLKk=;
        b=Wz88+p3XFfPbBq2jkfD75pN1azkIyYcRgohl37Bo8NUOwmW5K5ilJS+O8lA0ThFV48
         Nk+WAltH90XO24/CKTHW5Rxm/L5euGHmIVXSp3sbw1tFboUtCdwUL962rIy9lJE+2qci
         atdgIpcx6EONK9ZUWm40teQepN/o082ib5f6dkIuqdsE4s2Ri3DE2aXY9k9shs7SxkgW
         B7lGDS2dxHmPVv7YyqcCAaUJ4QRoX3AFxGVoysOdaszyfmpFU7pz+G9IloDNx6JmcqfP
         G4HArcPt7Ss4EYPoyla8yw0GVe5VQlFFuOzA9ObmlmbdDzt0ZXJ2NgoqHWR/0AdOO3Sc
         xtjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0Mu4udifMW2tdEjG6UYU2zT+RxK9F/wgdArkhXdHLKk=;
        b=ITgqs8qvFRYC/TJoXwotATE1GKZDLh5h3f0GiaQz1AbHk9uDYihvPytGX6cvtiuYJL
         AqJwpPPE2cZUI1KJoQ/1ox8s89aqBvC/YQRrb7iWapcf2LA2vLId2NSv9n5tNnqzu89U
         SOOV5EM46bwLjMueS5v9EIxaeGOJVvrCoAnlbY/pxPuDiK5uYCM5Mj/H+5dNLm4dpASQ
         g2UPjTfxQXxpTzPbMSTX6DnyA4ZkCBvuV0+SVLvLoNDxqUi63oDQgdk81RjtiJR0ieom
         junCKwxlIZphUYj790IV/kDxcLcCAD7Sz314KppkSknND393aunZaCCwD5IzqRkYExMw
         +ujw==
X-Gm-Message-State: APjAAAXcpoKfWHyVdwW7zlw+9/GQp3eQKM4aVESHZIwVKV/vnUgj2uG9
        ZJZyJOJ4cmBv5MM/BzWzgHH+ZHPVbX4=
X-Google-Smtp-Source: APXvYqyNKEVZUi7PkBOrunPMI8En5eOdd1G4iqdJWGFXePrC4G6pZaQFPJ7LpNqvBvf7JnFw2pn6JA==
X-Received: by 2002:a65:620d:: with SMTP id d13mr31242730pgv.64.1573497559352;
        Mon, 11 Nov 2019 10:39:19 -0800 (PST)
Received: from cakuba (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id h3sm1671026pgr.81.2019.11.11.10.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 10:39:19 -0800 (PST)
Date:   Mon, 11 Nov 2019 10:39:16 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>, Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Message-ID: <20191111103916.0af3ac5b@cakuba>
In-Reply-To: <20191109080633.2855561-2-andriin@fb.com>
References: <20191109080633.2855561-1-andriin@fb.com>
        <20191109080633.2855561-2-andriin@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Nov 2019 00:06:30 -0800, Andrii Nakryiko wrote:
> @@ -74,7 +78,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
>  	int ret, numa_node = bpf_map_attr_numa_node(attr);
>  	u32 elem_size, index_mask, max_entries;
>  	bool unpriv = !capable(CAP_SYS_ADMIN);
> -	u64 cost, array_size, mask64;
> +	u64 cost, array_size, data_size, mask64;
>  	struct bpf_map_memory mem;
>  	struct bpf_array *array;
>  

Please don't break reverse xmas tree where it exists.
