Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E6225CEF9
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 03:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgIDBHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 21:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728697AbgIDBHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 21:07:09 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497A0C061244;
        Thu,  3 Sep 2020 18:07:09 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f18so3677752pfa.10;
        Thu, 03 Sep 2020 18:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SxNkfzABcMK8plIbAb6qHG6L7OqiRioCR1EChs7Jpvc=;
        b=CfRFepK7NzA6JLyeBP6geDkYiZCLz/5eDrTDeFEzszdBmDQ9Oj64Mi/9X2T7eAQE8h
         irM4sgKoKpy4JTLpJjfNsm2wwkn0GvgVOESpVSdakLSSTyM19CW7k08Fgfkyu6noWQAP
         RseMnGVqdFI13I5cROeDhtBnqToXbjLFfxxbQVbtVaFVSNUggYSOVXRiCN0y7G9/Rk91
         K3+gJxWcP0gqOpL1h3HoFIiHJmWcuwjo+OpRpBLHoxbCXMo3cHTLcLi9I8xgvsJEnSMG
         JQbwv8COAPn5ySTR6DdlHiOmX9n4I8iMdS6RFUlcUAwN16AthfF/Kxt6moCIjMfmt1Qo
         drow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SxNkfzABcMK8plIbAb6qHG6L7OqiRioCR1EChs7Jpvc=;
        b=b5WSsOXlfAcYNyV+eP1gXHUUlcBb2s1Z+rg0hqBwalLH4zTRWQm2K+yq1zQrCfObhi
         7011mLIeMnXtfUHClR082PwkmthQj+MMNd42wLio0hC6mH05QE04lSnmHefz0luDTUSL
         OrS9/FolV68V/pxZWRFc1X1UuI4hVmArZ+ZySSKm9THrOjl5OIMZ8YlB2CWR6sUo07NE
         q9YUXtQLpr3kLqQKM6j0IO+8c+f1BF5g89hhhkJlTJPy06/lagCZPgmuWJAx8qWAtZun
         9DMHw/pj3GqN/O0IXsJQXliZtFit7rbPEaQZgIJPKTJmJVa9Q+gAlwunoYMe5y8qoUfa
         ESPA==
X-Gm-Message-State: AOAM530POHLAjIX1T/cGR6nkVciMvKf9meY3y1OXunzvxrtxVEnVE9HU
        VbRSXHagMjGYn25xhoVXb68=
X-Google-Smtp-Source: ABdhPJxruk9Z0mu7jEiENV/xQnwEEt0Csirc6MZ5Zt93A0E0S6OqmGvoXRyPwFJc1ewID986WfMcvw==
X-Received: by 2002:a63:d43:: with SMTP id 3mr5162490pgn.170.1599181628682;
        Thu, 03 Sep 2020 18:07:08 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8159])
        by smtp.gmail.com with ESMTPSA id u14sm4383517pfm.103.2020.09.03.18.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 18:07:07 -0700 (PDT)
Date:   Thu, 3 Sep 2020 18:07:05 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Subject: Re: [PATCH v2 net-next 1/9] xdp: introduce mb in xdp_buff/xdp_frame
Message-ID: <20200904010705.jm6dnuyj3oq4cpjd@ast-mbp.dhcp.thefacebook.com>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <1e8e82f72e46264b7a7a1ac704d24e163ebed100.1599165031.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e8e82f72e46264b7a7a1ac704d24e163ebed100.1599165031.git.lorenzo@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 10:58:45PM +0200, Lorenzo Bianconi wrote:
> Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer to specify
> if shared_info area has been properly initialized for non-linear
> xdp buffers
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/xdp.h | 8 ++++++--
>  net/core/xdp.c    | 1 +
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 3814fb631d52..42f439f9fcda 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -72,7 +72,8 @@ struct xdp_buff {
>  	void *data_hard_start;
>  	struct xdp_rxq_info *rxq;
>  	struct xdp_txq_info *txq;
> -	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
> +	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved tailroom*/
> +	u32 mb:1; /* xdp non-linear buffer */
>  };
>  
>  /* Reserve memory area at end-of data area.
> @@ -96,7 +97,8 @@ struct xdp_frame {
>  	u16 len;
>  	u16 headroom;
>  	u32 metasize:8;
> -	u32 frame_sz:24;
> +	u32 frame_sz:23;
> +	u32 mb:1; /* xdp non-linear frame */

Hmm. Last time I checked compilers were generating ugly code with bitfields.
Not performant and not efficient.
frame_sz is used in the fast path.
I suspect the first hunk alone will cause performance degradation.
Could you use normal u8 or u32 flag field?
