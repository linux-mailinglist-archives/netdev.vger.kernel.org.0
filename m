Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9903D1DDC7D
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 03:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgEVBP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 21:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgEVBPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 21:15:55 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE10C061A0E;
        Thu, 21 May 2020 18:15:55 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id b12so3733259plz.13;
        Thu, 21 May 2020 18:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UBJGFTXSGo+UPp7XYn9ZrTErT7E+VTF6ZtZtvuINGag=;
        b=kimnnaIX9OjDVFuqUyxOzv92ZMZrrpfRGwrnZ71/9lSUbvHFc0tUnDaIE4Xcnck6Gw
         a5dLTYKXNoEGtVndQwEfCAC/gpmHFfuUKz1SwQw0dWGca+U9+m9o4SnD0yBOxUsKp+k3
         gesva2dE1ERBr8v+iSkthDEbOuyys5IljmzK1/f9UHJD+Ym7SDVrr/JqjzgSJX76fhzP
         l1wPXrNlBmfrunzW0D/2gTMmTis/B6DQ+406LC5QJ4K1rmTEaXD81xOZ3rZrj6JJqFXm
         ZcbFnn/XG+AKDl/+vIP+BWhulijClFp1OcyCJqC6Ncu2WSYEYLj6hPTUnEBSXRkb0iO4
         w2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UBJGFTXSGo+UPp7XYn9ZrTErT7E+VTF6ZtZtvuINGag=;
        b=hm28EkCY8B/wJJ8Tt2PSf+CK/8sotNiLZZ/ZhhF/0zcvn9wuZTEZgwN5muTM6jWUXE
         Umg4oa1kQOoXqAWoefp8VhV+4QUfM0IB6B2MJmibmG29l5B/2X5Bd+ouyPz1GXftJPAI
         gIMWV2zXAEHpu4p1LY/MAtD8VQFKOpNu+Ivme2AC4JGQBHAeoNEGZJaasUm460R1iy4J
         1s9sAbA874BgPTRmfcdQfZjKw/zzazENyjONo1vGMi+/mpQv80dIvBydCyL60+AL0VR5
         b19KfC5YqRVlpHR1c6zMpSf6w0lEhK1i7OpzjJHho1TRHNPFyAs10xbddqV7k/192I6O
         BhLw==
X-Gm-Message-State: AOAM530x4zuKOtEW67BMce+N4yFvGRVjX9W1+31S7B7wmFDEGycWANMM
        MdfMSgP+i0ONUt4xeWAqnmI=
X-Google-Smtp-Source: ABdhPJytgXo/c/FEVNde564dMSmkq6Xx7r4V0FNxEUQzKStCiv3Ww464gd10U+TKjvzym3kRwUo2VQ==
X-Received: by 2002:a17:90a:21cf:: with SMTP id q73mr1504496pjc.230.1590110155328;
        Thu, 21 May 2020 18:15:55 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e680])
        by smtp.gmail.com with ESMTPSA id y75sm5448112pfb.212.2020.05.21.18.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 18:15:54 -0700 (PDT)
Date:   Thu, 21 May 2020 18:15:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/7] libbpf: add BPF ring buffer support
Message-ID: <20200522011552.ak4dkxhqwg6j2koy@ast-mbp.dhcp.thefacebook.com>
References: <20200517195727.279322-1-andriin@fb.com>
 <20200517195727.279322-5-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200517195727.279322-5-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 12:57:24PM -0700, Andrii Nakryiko wrote:
> +
> +static inline int roundup_len(__u32 len)
> +{
> +	/* clear out top 2 bits */
> +	len <<= 2;
> +	len >>= 2;

what this is for?
Overflow prevention?
but kernel checked the size already?

> +	/* add length prefix */
> +	len += BPF_RINGBUF_HDR_SZ;
> +	/* round up to 8 byte alignment */
> +	return (len + 7) / 8 * 8;
> +}
> +
