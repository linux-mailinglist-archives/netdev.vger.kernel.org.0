Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBAB2CC885
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388773AbgLBU67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbgLBU66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:58:58 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68A7C0617A6;
        Wed,  2 Dec 2020 12:58:12 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id o9so2009161pfd.10;
        Wed, 02 Dec 2020 12:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OEDQ7BcRoHrHucO55DwBDiiprGZqG+XuWqG13QUhI/A=;
        b=WVx07uD8EdNGRs5Nle3bt/jFrX8DeDnmzw0P4XR4Jc8mVVlx78f5+BO7yrv/nLqIyY
         i8WxIsYR5G5MYxDAL65intimMMVOg/0KK/HBzAVVEtNqE91J24c6ELZIzJkjd04ql3Cc
         Gf42jjbN+M2sjZh+1sciKSMDatI5NEf5/cTrXXfzRTYgrlXaWAyZ6ndIuimoT89f2ngz
         MwmyKelKTBVT8ciItJYUcHpbzQc/vO9C02PMD54FcxcRVt2qvWZdLxrGtzH44tIp3Ayt
         oxwsm4aBTqTPobOPAL8trxEWbzqFyfH2O7ARhs1QAFaiIWc3uFx8NC/TY8Nr2C6jFtQX
         ObLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OEDQ7BcRoHrHucO55DwBDiiprGZqG+XuWqG13QUhI/A=;
        b=hSKxSaNN8Y+FKHdjNsuXy2IJD59a7112VYRPT6ZrKXxrQcJ9ushSWRKhINkmWgihvd
         Pg821FbaSCT0Ur8oeuHmd2clUj5MuAm5nvi6aPd1Mk0+BCZLZk8f+KCQAH/g1+gwP+1l
         7hl02Bxym1vRw5I1lMTq0snbsGc4R4UMAIiVHGB3ebTakUAlFyMYPs/lSkxhuC4bBus7
         aNMEVeaxzSYs1KtV6zk6ReAypzAYzZrg8nJSSqdCeRHm+mftfWzoMNEdFsC9pK+45iNj
         0KCZ41OgP0s3bldbOPS+2q1QqvzPncn/aq7A/UJdFbTWchbxOzjTK5MD8Tz9j65NiThH
         FjHQ==
X-Gm-Message-State: AOAM531ywjxoqTLjvhwOk+QeJtEyVWEqk/79t3LgHo9uj+X2XKmWA8wV
        6dWWmTRmfDGhf09Ug+8Zi+A=
X-Google-Smtp-Source: ABdhPJw0mO8EINh9fV/dwENNw5hRMB96j5DS9AwhVxkDD4jralgJThpaaxJmWAHhcfMur3gQS8fhyQ==
X-Received: by 2002:a05:6a00:2af:b029:18c:5a65:8e0f with SMTP id q15-20020a056a0002afb029018c5a658e0fmr4388680pfs.41.1606942692368;
        Wed, 02 Dec 2020 12:58:12 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:ef25])
        by smtp.gmail.com with ESMTPSA id r11sm565807pgn.26.2020.12.02.12.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 12:58:11 -0800 (PST)
Date:   Wed, 2 Dec 2020 12:58:09 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 10/14] bpf: allow to specify kernel module
 BTFs when attaching BPF programs
Message-ID: <20201202205809.qwbismdmmtrcsar7@ast-mbp>
References: <20201202001616.3378929-1-andrii@kernel.org>
 <20201202001616.3378929-11-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202001616.3378929-11-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 04:16:12PM -0800, Andrii Nakryiko wrote:
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index c3458ec1f30a..60b95b51ccb8 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -558,6 +558,7 @@ union bpf_attr {
>  		__u32		line_info_cnt;	/* number of bpf_line_info records */
>  		__u32		attach_btf_id;	/* in-kernel BTF type id to attach to */
>  		__u32		attach_prog_fd; /* 0 to attach to vmlinux */
> +		__u32		attach_btf_obj_id; /* vmlinux/module BTF object ID for BTF type */

I think the uapi should use attach_btf_obj_fd here.
Everywhere else uapi is using FDs to point to maps, progs, BTFs of progs.
BTF of a module isn't different from BTF of a program.
Looking at libbpf implementation... it has the FD of a module anyway,
since it needs to fetch it to search for the function btf_id in there.
So there won't be any inconvenience for libbpf to pass FD in here.
From the uapi perspective attach_btf_obj_fd will remove potential
race condition. It's very unlikely race, of course.

The rest of the series look good to me.
