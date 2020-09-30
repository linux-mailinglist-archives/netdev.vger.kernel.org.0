Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAF527F25C
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgI3TL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727438AbgI3TLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:11:25 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D724CC061755;
        Wed, 30 Sep 2020 12:11:25 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id v14so315381pjd.4;
        Wed, 30 Sep 2020 12:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8YWBk6SzR671V+UOUVyMBr51LcYWzl9S2GvBCwgZRzo=;
        b=R3HimT/BWzn1DS3rbLQ0IPq5xf7WE2eR+vNBXscgRYgWrkUbKaevkQK9ttFhReNSzi
         JmMQPv9bGH/WIROqxo0hUa9mZCvV4QAq+XNMVygVjh3kLBBI5V+Ywme4aUaXo0vzRLS3
         dvWssxgjCo23p0IZUQPZ41mty1VC7s3x8fGvprufaEv74LbjSUFkb1KeFV2pzMEiQ0Ay
         0UTWUeXKD5vBp0f2Se6jvF0F7ViwTA8cNE/a+Bq4IoUfZZtC6brm5SQa5dqO4+VCKz5K
         ZvMr64nbngQ+BlPm5685+vBtBw/9VVL1pnDSw5/rpHmKFDfFczl6wYd5uDHwDADHn1SD
         rSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8YWBk6SzR671V+UOUVyMBr51LcYWzl9S2GvBCwgZRzo=;
        b=UXxlo4EX/rJy7WSvaJyzL1JnBHqLAnchpowDiwIb7Nbp5aVPoO2yKV5LO/68eZCKa0
         oOULY8rGqKwIMHJhp2bUc6+PKOc4WlVYqy/fSwjA1ZlYpFmNg9xwZLjDiY7RNCUMusrJ
         2IroTrBkpi0tZgXdyjkRr26jimQw+WPHLin5DFMnJrtPvtxmjdEVyzU1TRYS+1E3WVv7
         u951icrV0hXdZrlMFKcxKlJvRTh0jemYfuplgeWqADoMZg5zX5AYo2xryNuFzuOh5BPh
         h3gQhlV0R58SP4kHxmp30e/oFcDFI1aJxlx5gmyGcGBbm0REIg+MiExFLYfpVapgQXI4
         HWnA==
X-Gm-Message-State: AOAM5337fPbLUO1DTD5vfg9ALA7DHilr9itCOVezHCAtZJuxdJNO4CMI
        bbuKeSnXKI1kUk3BZp88NsDbJ20BmDM=
X-Google-Smtp-Source: ABdhPJzHwfHovKijUvEPEzWUBXXwuRS5qQjSznFHzZnEnhRUUBOF/bsoazxPPluy35q/9ZKPEPeUOQ==
X-Received: by 2002:a17:90b:1211:: with SMTP id gl17mr3975858pjb.87.1601493085089;
        Wed, 30 Sep 2020 12:11:25 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2a2])
        by smtp.gmail.com with ESMTPSA id gx5sm3057180pjb.57.2020.09.30.12.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 12:11:24 -0700 (PDT)
Date:   Wed, 30 Sep 2020 12:11:21 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        sameehj@amazon.com, kuba@kernel.org, john.fastabend@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        brouer@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org
Subject: Re: [PATCH v3 net-next 06/12] bpf: helpers: add multibuffer support
Message-ID: <20200930191121.jm62rlopekegbjx5@ast-mbp.dhcp.thefacebook.com>
References: <cover.1601478613.git.lorenzo@kernel.org>
 <5e248485713d2470d97f36ad67c9b3ceedfc2b3f.1601478613.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e248485713d2470d97f36ad67c9b3ceedfc2b3f.1601478613.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 05:41:57PM +0200, Lorenzo Bianconi wrote:
> From: Sameeh Jubran <sameehj@amazon.com>
> 
> The implementation is based on this [0] draft by Jesper D. Brouer.
> 
> Provided two new helpers:
> 
> * bpf_xdp_get_frag_count()
> * bpf_xdp_get_frags_total_size()
> 
> [0] xdp mb design - https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/uapi/linux/bpf.h       | 14 ++++++++++++
>  net/core/filter.c              | 42 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 14 ++++++++++++
>  3 files changed, 70 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a22812561064..6f97dce8cccf 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3586,6 +3586,18 @@ union bpf_attr {
>   * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
>   * 	Return
>   * 		0 on success, or a negative error in case of failure.
> + *
> + * int bpf_xdp_get_frag_count(struct xdp_buff *xdp_md)
> + *	Description
> + *		Get the number of fragments for a given xdp multi-buffer.
> + *	Return
> + *		The number of fragments
> + *
> + * int bpf_xdp_get_frags_total_size(struct xdp_buff *xdp_md)
> + *	Description
> + *		Get the total size of fragments for a given xdp multi-buffer.
> + *	Return
> + *		The total size of fragments for a given xdp multi-buffer.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3737,6 +3749,8 @@ union bpf_attr {
>  	FN(inode_storage_delete),	\
>  	FN(d_path),			\
>  	FN(copy_from_user),		\
> +	FN(xdp_get_frag_count),		\
> +	FN(xdp_get_frags_total_size),	\
>  	/* */

Please route the set via bpf-next otherwise merge conflicts will be severe.
