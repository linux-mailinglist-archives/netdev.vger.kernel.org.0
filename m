Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9ED2C7743
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 02:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbgK2B5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 20:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgK2B5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 20:57:18 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904D3C0613D3;
        Sat, 28 Nov 2020 17:56:32 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id t21so7467142pgl.3;
        Sat, 28 Nov 2020 17:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=58AEDhtEnrsA7W2LQe5jqaWDIN5VgVTAYTu6lovd+Ho=;
        b=txAO6NUkZbwst45dpF5c9gpQchWaYsimBVXnIYABaZ3GNHrvZ3RlbgiT7/G+DUCcHs
         xjiyF/QSvtOVcGwiT20QQOo44CaWeIEyZIl7IcO4XrLJtVcO03NuVMawWRBFptfch/0K
         x5xLjBgXf/ZlSXCfkzBKw4S5UkJmizw8rYN3UcQ0Wp3FFlMmXs+94GdopCrasDYbZYbR
         fW0h69i0Pq9IS5AmLGeoBS29VDlapbFL/Sa7OmKUEeGNah2vFLk0VTCm36LQ6MZdj5lD
         r90snDp3MjihQwX2rtFZStaZHCYXNTh7olOyPbSsqkAMXlaNxXuNaGzjQsKa8q6Cl63V
         MJ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=58AEDhtEnrsA7W2LQe5jqaWDIN5VgVTAYTu6lovd+Ho=;
        b=T0AhIQqpfNRKkXS3XJYPnz5N64vYBfb8Kp3hCy7axFexZIYXVLXpTO2w6VkDsDzhMO
         eFaIuRf3bIoqxYK0fsRnhtcmiHM4xhoozrDnx3L4amhN6Wr59TcsNayB7TPYpSuqiRfj
         5jVfEhLN3wj2JZbBT+b9oY29vIlH1v3Nf874DOZ7rzHT05l5M834FGSumroWcnCdMCrt
         Y0itiXUlwn1VTMWFseqF6OVSiP7wTVJsLJhtpBsKfXRAJWEzMWvl7AFWFXk71lXnrZJF
         q7TP89XEeSRIdNY/50SdKM0lwGf5zfr1853Ri9rT3oIl8cg7axiow2Borz7Gn10fgIE/
         LVew==
X-Gm-Message-State: AOAM5330OUrARk5gjKEJ3zD3OmPnJk94hxJSXgpwXR3tHvAuxMNsXVw5
        zt0v9dimFbpwxfuRLZ7XQOQ=
X-Google-Smtp-Source: ABdhPJyqIHvYPOWMHCR3ugmOtSLC+cUoxoJlyxVHrmhPW/ufKH/ekxSwUA14R8tbovOGL9i95XT0vA==
X-Received: by 2002:a62:f20e:0:b029:197:f6d8:8d4d with SMTP id m14-20020a62f20e0000b0290197f6d88d4dmr13249601pfh.58.1606614992046;
        Sat, 28 Nov 2020 17:56:32 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:5925])
        by smtp.gmail.com with ESMTPSA id v145sm11574146pfc.112.2020.11.28.17.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 17:56:31 -0800 (PST)
Date:   Sat, 28 Nov 2020 17:56:28 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/7] bpf: remove hard-coded btf_vmlinux
 assumption from BPF verifier
Message-ID: <20201129015628.4jxmeesxfynowpcn@ast-mbp>
References: <20201121024616.1588175-1-andrii@kernel.org>
 <20201121024616.1588175-2-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121024616.1588175-2-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 06:46:10PM -0800, Andrii Nakryiko wrote:
>  
> @@ -52,12 +53,19 @@ struct bpf_reg_state {
>  		 */
>  		struct bpf_map *map_ptr;
>  
> -		u32 btf_id; /* for PTR_TO_BTF_ID */
> +		/* for PTR_TO_BTF_ID */
> +		struct {
> +			struct btf *btf;
> +			u32 btf_id;
> +		};

bpf_reg_state is the main structure contributing to the verifier memory consumption.
Is it possible to do the tracking without growing it?

>  
>  		u32 mem_size; /* for PTR_TO_MEM | PTR_TO_MEM_OR_NULL */
>  
>  		/* Max size from any of the above. */
> -		unsigned long raw;
> +		struct {
> +			unsigned long raw1;
> +			unsigned long raw2;
> +		} raw;
