Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F4E2A3BAC
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgKCFKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCFKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:10:06 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7BEC0617A6;
        Mon,  2 Nov 2020 21:10:06 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w65so13182194pfd.3;
        Mon, 02 Nov 2020 21:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tCyGkq/pHteVAh0HIDT7egDnjjzBOE7dZIpKsnhRnsM=;
        b=etNDRHh0vuI9pqe4UUpt/3cX9ZGv/0D5ySVu4E5ayITnJPmyVjLJ29aHzsLWT4CYnp
         ewXSLKkexigwdSTrG3Pdd7OLPdALbFDX/QU9huvOeOUgMb6ZNNG2R9oB3QkBi1Ncxhhd
         Z1iVjRPXnnHixMgNs+SUjwJp/P1GJW9392gsolU+AwbWZVPx/j4E858An7jCIsRaYNJH
         LOfb4uhr/qGf71+HE3dwjN62SNmKMjyYTOm997UpJRG8EEqpLKUs30liHmyfgVqEKIl+
         kfQBPtMtIlzJlHaofm9/O1RofswfIgLyTaLfRheSm5ZqV8MBzwMXbQK03tgFvqZPba/W
         +RzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tCyGkq/pHteVAh0HIDT7egDnjjzBOE7dZIpKsnhRnsM=;
        b=M16fTPgu3H+Rg73k4tSO93ObTIDdJxMwufzOKVFL7AKvqGft9ztNX3bzRLQpb3qIsd
         XRykihYePi301LOoTiqlH0iSs8LR9i00uzWSM8l+8rM9PsSOxSFiUWidtfMpwoKh1Pcx
         ycBUkWd0tAuwmfKlvs/dcPfmk2AktYf0fBc3mVV/qV4pf/IrQeEMXCRl54ADqERRHuaK
         pQSW/ntPm1U7NG8IfPajkmKz1jeDeDv8I3L21W2i6n7takiBYSUEeYLWIuMhp6LEPgpf
         OoQufpqJXwrJKuk8MbR98oVBqfgAgMhsXtFItEfvVSqVUBlB/mhuM2JEZEfZ40kJkHfG
         wF+A==
X-Gm-Message-State: AOAM531Xuezg1XAz441ErohFiVY/7mLdtL5YjDACKlr0V1LUxSifQ723
        MpS0EpiSkpevbrTo0kX9AV4=
X-Google-Smtp-Source: ABdhPJxdAZ9knOjZVXZk9desjGLDSbJ9bzfrYQjovHhCJhcQruH8pe8JufMTU6EKZxQPeJe0kloP3A==
X-Received: by 2002:a17:90a:b63:: with SMTP id 90mr2006281pjq.154.1604380206267;
        Mon, 02 Nov 2020 21:10:06 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4055])
        by smtp.gmail.com with ESMTPSA id f21sm3733267pga.32.2020.11.02.21.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 21:10:05 -0800 (PST)
Date:   Mon, 2 Nov 2020 21:10:03 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 08/11] libbpf: support BTF dedup of split BTFs
Message-ID: <20201103051003.i565jv3ph54lw5rj@ast-mbp.dhcp.thefacebook.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-9-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029005902.1706310-9-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 05:58:59PM -0700, Andrii Nakryiko wrote:
> @@ -2942,6 +2948,13 @@ struct btf_dedup {
>  	__u32 *hypot_list;
>  	size_t hypot_cnt;
>  	size_t hypot_cap;
> +	/* Whether hypothethical mapping, if successful, would need to adjust
> +	 * already canonicalized types (due to a new forward declaration to
> +	 * concrete type resolution). In such case, during split BTF dedup
> +	 * candidate type would still be considered as different, because base
> +	 * BTF is considered to be immutable.
> +	 */
> +	bool hypot_adjust_canon;

why one flag per dedup session is enough?
Don't you have a case where some fwd are pointing to base btf and shouldn't
be adjusted while some are in split btf and should be?
It seems when this flag is set to true it will miss fwd in split btf?
