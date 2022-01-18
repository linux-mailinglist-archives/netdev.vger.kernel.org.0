Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3602C492F2A
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 21:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349085AbiARUUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 15:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348893AbiARUUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 15:20:48 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DBAC061574;
        Tue, 18 Jan 2022 12:20:44 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso3816764pjo.5;
        Tue, 18 Jan 2022 12:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A9ePxRiUQq6B0AF0q044K2gaQMT6aVOT0H93fEa9kcI=;
        b=ijtqcNf9rU6l8XfvDDeRGubZQMogNDeA4zSM55UJhzSOhVejp4gtg9DsQYjoVxDnh1
         JbjSBmN7lLaXG5PfhEWevWebp4sI61kfKV3mpQEQAOSF4rgLkc7ZGsba0vTUC6sfPEYy
         Rd2EhvmQQoFNl7nHXlcxl0EkN5xkKYhjFJA/fZB/0Dh77uC+o2ComZTedsK6f8txd7LN
         C4ZfTZdBZysfLPLB0Xbs+LuF2JRv3rYFkf1XmEcrBPbICd+nPK1kCHTujb179okc14f7
         ia6QOLnGXr/BwRTjwo7+jigUm7daXRXDe9m+rvoqI1WJBYbyRuBzznA1ewBFDy+Are+g
         4E6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A9ePxRiUQq6B0AF0q044K2gaQMT6aVOT0H93fEa9kcI=;
        b=m8GZlI4G7frjo20APizCfOWSCoujC7MlKr2vYFK/q2FPSMRxer+NpFU5/mG3OOaup1
         kyX4zzUhDeLG6zT4M6DBBptOqY59YtOXNk2/evqLr6e7A5/tqAzlmh8WVPZM8QsnwHgX
         S4a05eVTJQJ+/78dwogHqF14C1UN/9YWLMlmbBlPtp0EMFCKjhgOKBFRaytCqT+yAIdX
         OTF7crwQkJ3S/gNmBS4+hXjiymhei3vy0i2tQ1NI3885MXeb7oDaO/2yGltAWrG4EBp4
         Um685EFbY0rbH6rmTQgAS9HEbQYdrylVN64Wn51LP5vqLwK6CvoCqotg/wMY4E/5mkkM
         8ENw==
X-Gm-Message-State: AOAM530todMWC46H3n3FUAEO5q6zhiYczsxm9OPw4ZuHIdR3o7Z9XEd1
        n8aBNszcRkwTJmWOHGH8wGI=
X-Google-Smtp-Source: ABdhPJydt1cLpOMAWfduTYjzW69cSD3kUZ31dT0/RDMTbJ8EG0rPlI6VtnzqRii0cVSKs1ZQG02rug==
X-Received: by 2002:a17:902:a601:b0:148:adf2:9725 with SMTP id u1-20020a170902a60100b00148adf29725mr29151385plq.136.1642537243803;
        Tue, 18 Jan 2022 12:20:43 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f291])
        by smtp.gmail.com with ESMTPSA id s185sm12731733pgs.39.2022.01.18.12.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 12:20:43 -0800 (PST)
Date:   Tue, 18 Jan 2022 12:20:41 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v22 bpf-next 12/23] bpf: add multi-frags support to the
 bpf_xdp_adjust_tail() API
Message-ID: <20220118202041.uk6ann4w366v4xlf@ast-mbp.dhcp.thefacebook.com>
References: <cover.1642439548.git.lorenzo@kernel.org>
 <087fe9459f451a2dfed4054b693251029f57f848.1642439548.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <087fe9459f451a2dfed4054b693251029f57f848.1642439548.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 06:28:24PM +0100, Lorenzo Bianconi wrote:
>  BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
>  {
>  	void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
>  	void *data_end = xdp->data_end + offset;
>  
> +	if (unlikely(xdp_buff_has_frags(xdp))) { /* xdp multi-frags */
> +		if (offset < 0)
> +			return bpf_xdp_multi_frags_shrink_tail(xdp, -offset);
> +
> +		return bpf_xdp_multi_frags_increase_tail(xdp, offset);
> +	}

"multi frags" isn't quite correct here and in other places.
It sounds like watery water.
Saying "xdp frags" is enough to explain that xdp has fragments.
Either multiple fragments or just one fragment doesn't matter.
I think it would be cleaner to drop "multi".
