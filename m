Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3712A2F8A
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgKBQTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 11:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgKBQTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 11:19:04 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CBFC0617A6;
        Mon,  2 Nov 2020 08:19:03 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id w145so9533315oie.9;
        Mon, 02 Nov 2020 08:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=zdFReR8FLI3L2rmZ+bPGir2Ezs1m6/s5ZEKZB6h+WL8=;
        b=lb6XPxhWY1Diy5O34NK1fGwX18XZhwbsl/h4MK/tDAjcYSeCLEQP/3O61q5kVGbzAn
         nTZnViZY76dAySfoXse0fSo6wAxPmfRtSTRGba5l8LbTR9UvsNnzxuce7PlQckVXq5GJ
         QQB+DcGFadB2JDS/Xilq9M2CWSYjDDR0l0WAM/AsURWWtoeaRL70HXlCDQDgJqxU0ryK
         rxptpCsRB+/iD0UiLDYoxjWuX2AZr9Aj9K6XEPB98dPkZ9A/iJILmELWu8kX5ud9zKpD
         HyZ1Sj5sonGikA5v/PFl6el60wZ689qeRtVumZoeLjWez4Zyth9ncqpvllfnv26uhykU
         7j/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=zdFReR8FLI3L2rmZ+bPGir2Ezs1m6/s5ZEKZB6h+WL8=;
        b=d8uL2apTSMWh6jKcSqF8MEc8KOgSL4JWKO2OscZwAvjF/+cafZGiY3xe6fScpfWo5Y
         k4zy/aIHEJLlZES2JB4ZyexsU6+ZgHyPnebFfFAmRUgxb1tDgvIMNAzcwOZBFDRCoBjZ
         FohCD2svu7FaAaYKUGg14FiZhReCKh8GhJK7Fo7QZpQ08poPEWWFZw4mEx81JCckoU2u
         D3tBvH+A4bptZDEfCjJxuP6vUO1/3XnE+uwKMaaINo/M1VRmkkiNTxcjJKom53VJdgoW
         x+XjZ4Qzlv33u0ej8fo48oFrAGmWHSb+YhFbF1Wmi2nR9VHVXKXlEx2iMhcGdrC12E4q
         2T7w==
X-Gm-Message-State: AOAM531ZOgHfHLqe+CjtAcZ1NXCQ8sBNz8fyyvwt8bYVNJP2gKTTaG85
        xZLtlfgtQh0t7qyYaQk/UZY=
X-Google-Smtp-Source: ABdhPJxWy/PEFdfkLRnpJd86/chpZMFRmCCsckYEYXGoFZaxHsSD0fZmM5bcMdKJTXg+cFOxq1yJUg==
X-Received: by 2002:aca:bcc2:: with SMTP id m185mr10380008oif.127.1604333942691;
        Mon, 02 Nov 2020 08:19:02 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a16sm3818183otk.39.2020.11.02.08.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:19:01 -0800 (PST)
Date:   Mon, 02 Nov 2020 08:18:55 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Message-ID: <5fa0316fc36a_1ecdb20851@john-XPS-13-9370.notmuch>
In-Reply-To: <dd0d1a41-1d1d-5104-0fa0-42241f5a960c@gmail.com>
References: <160407661383.1525159.12855559773280533146.stgit@firesoul>
 <160407665728.1525159.18300199766779492971.stgit@firesoul>
 <5f9c6c259dfe5_16d420817@john-XPS-13-9370.notmuch>
 <20201102102850.1dc3124a@carbon>
 <dd0d1a41-1d1d-5104-0fa0-42241f5a960c@gmail.com>
Subject: Re: [PATCH bpf-next V5 2/5] bpf: bpf_fib_lookup return MTU value as
 output when looked up
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern wrote:
> On 11/2/20 2:28 AM, Jesper Dangaard Brouer wrote:
> >>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >>> index e6ceac3f7d62..01b2b17c645a 100644
> >>> --- a/include/uapi/linux/bpf.h
> >>> +++ b/include/uapi/linux/bpf.h
> >>> @@ -2219,6 +2219,9 @@ union bpf_attr {
> >>>   *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
> >>>   *		  packet is not forwarded or needs assist from full stack
> >>>   *
> >>> + *		If lookup fails with BPF_FIB_LKUP_RET_FRAG_NEEDED, then the MTU
> >>> + *		was exceeded and result params->mtu contains the MTU.
> >>> + *  
> >>
> >> Do we need to hide this behind a flag? It seems otherwise you might confuse
> >> users. I imagine on error we could reuse the params arg, but now we changed
> >> the tot_len value underneath them?
> > 
> > The principle behind this bpf_fib_lookup helper, is that params (struct
> > bpf_fib_lookup) is used for both input and output (results). Almost
> > every field is change after the lookup. (For performance reasons this
> > is kept at 64 bytes (cache-line))  Thus, users of this helper already
> > expect/knows the contents of params have changed.
> > 
> 
> yes, that was done on purpose.

OK sounds good then. Thanks.

> 
> Jesper: you should remove the '(if requested check_mtu)' comment in the
> documentation. That is an internal flag only -- xdp is true, tc is false.


