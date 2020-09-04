Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3FB25CF02
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 03:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgIDBJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 21:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbgIDBJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 21:09:29 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1121C061244;
        Thu,  3 Sep 2020 18:09:27 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id np15so4454132pjb.0;
        Thu, 03 Sep 2020 18:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mxjYE0PRkRuompUUiD9AkWHrCqI/ZrN/k6tANngcoAU=;
        b=BbSOlrh94oqe5atG8fcVPGYcrxnLbiC4priIzSGjh3iCylf7h3opgKWwkoVg6o5ZNf
         7/AjJmEhOHSSPhh4FSkiX9BA1ARVL1GeB1dr7KMeqX47MnuSZUEbqGctYE4GYJjo4Jdx
         qRlm3IfuZBCFHodVb9SqXjWnhazRRyyf56RmJ/4Y/e1P8UR9qQ+AUV1+XMwZSDKGSdEA
         rbhEdsdFplg+zPRCYqKAUnOSFc+Aa0gP4Zty3VN2eERdNsr81IuxGeXGgD69niWdYYvH
         DEp2Dhs1hwU07sSre6m1qy4F7AzD6exhC660nrWLMFOv6Y0HY0Yf82At5ApgKVLgFWHl
         ulWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mxjYE0PRkRuompUUiD9AkWHrCqI/ZrN/k6tANngcoAU=;
        b=uSwS1fZaTVlZPfbixJxp7dpIhNhuZlfEe6VDauI6e0lCcPKLAKCf2p1JqqIPvLJLG3
         glsECTl10elhrY55pzQ7YI6+cbu+dzu7iXyxL73iPKuN5hhEC9qJW8U0oKyvWX2Y1dAw
         vsaoPmPV6epaFwjtKZJ7wRXEqV00c+IZLJwfi522pZWKlURASowlvPD8PNDGn/OWCQFP
         zJsgstc3bvquklp7Iqra4pKRKUTzb5oQYsvEJ8wyKcCcqeKSZrarMOo4YvNpGD84mAfO
         7WEobFqfDIHZXdBRetDyh3LZemuIhkYN45u07HhjByLMsPJpQ3ffJFw5nP7+Xl9z5Vn/
         LGpQ==
X-Gm-Message-State: AOAM532vZXa4y7ye1IeIITOWIBBoRUREDSMSOHbpR+g9xYoD7dlvKLsK
        A5kvztdgO00rApa8gGcLOj4=
X-Google-Smtp-Source: ABdhPJx2t+xSWKVg0/03zsqxn2u99Xny/GvV9TyH785cGrE4i5m225kSuI8fHfTcU+6YVKZEgDvPQQ==
X-Received: by 2002:a17:902:d210:b029:d0:81cc:a649 with SMTP id t16-20020a170902d210b02900d081cca649mr5034843ply.1.1599181767152;
        Thu, 03 Sep 2020 18:09:27 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8159])
        by smtp.gmail.com with ESMTPSA id b64sm4429340pfa.200.2020.09.03.18.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 18:09:26 -0700 (PDT)
Date:   Thu, 3 Sep 2020 18:09:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Subject: Re: [PATCH v2 net-next 6/9] bpf: helpers: add
 bpf_xdp_adjust_mb_header helper
Message-ID: <20200904010924.m7h434gms27a3r77@ast-mbp.dhcp.thefacebook.com>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 10:58:50PM +0200, Lorenzo Bianconi wrote:
> Introduce bpf_xdp_adjust_mb_header helper in order to adjust frame
> headers moving *offset* bytes from/to the second buffer to/from the
> first one.
> This helper can be used to move headers when the hw DMA SG is not able
> to copy all the headers in the first fragment and split header and data
> pages.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/uapi/linux/bpf.h       | 25 ++++++++++++----
>  net/core/filter.c              | 54 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 26 ++++++++++++----
>  3 files changed, 95 insertions(+), 10 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 8dda13880957..c4a6d245619c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3571,11 +3571,25 @@ union bpf_attr {
>   *		value.
>   *
>   * long bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
> - * 	Description
> - * 		Read *size* bytes from user space address *user_ptr* and store
> - * 		the data in *dst*. This is a wrapper of copy_from_user().
> - * 	Return
> - * 		0 on success, or a negative error in case of failure.
> + *	Description
> + *		Read *size* bytes from user space address *user_ptr* and store
> + *		the data in *dst*. This is a wrapper of copy_from_user().
> + *
> + * long bpf_xdp_adjust_mb_header(struct xdp_buff *xdp_md, int offset)

botched rebase?
