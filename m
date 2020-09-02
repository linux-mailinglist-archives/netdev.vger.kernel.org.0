Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B339125A52D
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 07:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIBFqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 01:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgIBFqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 01:46:46 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0241C061244;
        Tue,  1 Sep 2020 22:46:46 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id c15so1767812plq.4;
        Tue, 01 Sep 2020 22:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0ODfNlmdRj3BYDrmMO0SsBFQWCutglzBSXtyXt2nquw=;
        b=gDp8Sw0+ieDRXSRjNLvLVwcBIFjvcElIDXREUoUXrGrokXi4L4CR4EslnALqBETAUf
         xt71bOzv1kHOSvJsEOFC92fXZsiaQcEBQGFiAfb90g1QjRtu+l4JN2+E85Vq5Y8dfxeI
         f9+kRFI4jl/UI3ZtkyemkWXbJdufh/yY0O77ByMpNWYC51IS1UhdndgLbx6HEXYUJx5D
         q0k6qHaDP4VEm4BCxGEDt2v/te4XKuIR1GkgZVVmBAAg74FWuSx3xrV4TPesuHdED5IR
         0yAi18Qg68oTr3F0vtUVKGIUJLH6NrbgnU5XGoNyeMG+zEh3NiI8+WZcdC3rdpYtGI6g
         TH8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0ODfNlmdRj3BYDrmMO0SsBFQWCutglzBSXtyXt2nquw=;
        b=fM3upHrOZQGOWDsDn35PRTRF0jNLvaZWr3HGjFD08EhkEETJJbXgk7DhdDAEykBRcU
         x5gWcXiSIT1DGQjKB7i/zsuIxmCCNc6aCzVScaXgnE2y/sTiCVoBEmRXmsG6HxBXARlU
         CmvVb/75fOlsjpmrt0GYPpBAQNIFNglHN5EUL75VytxTxErFhC+DRl/jCrGH8ER1JcM/
         6CyZ6dpJFj7EugpvjMGO4TRlvXIzu/ORHZF6TBWJIqHoQJrbmTa+i5DCX44FP4I4YWc/
         k7szWVyVGZ6URQbwO15hTRPgQkqBJwKFYpKuaOmLOXE8f20pxivK03ZIo7iDYVR2hg96
         r22Q==
X-Gm-Message-State: AOAM5315fwKlqyMk2CTCNILSpBYZXUG+5p8NT0pbDwd997VukO7cn25X
        vOD5tgGeJE3fmxwcYgWwi8E=
X-Google-Smtp-Source: ABdhPJxW+gU5pUEA4gogle3fy5UDYCV4fOYv0gKlKNgH8P3sl28woQG/x/OAapW7lv0Ps+lCeaA0Fg==
X-Received: by 2002:a17:90a:ce:: with SMTP id v14mr778326pjd.123.1599025606473;
        Tue, 01 Sep 2020 22:46:46 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:c38b])
        by smtp.gmail.com with ESMTPSA id y3sm3409220pjg.8.2020.09.01.22.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 22:46:45 -0700 (PDT)
Date:   Tue, 1 Sep 2020 22:46:43 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 14/14] selftests/bpf: convert cls_redirect
 selftest to use __noinline
Message-ID: <20200902054643.bvbtteoii2p7xyix@ast-mbp.dhcp.thefacebook.com>
References: <20200901015003.2871861-1-andriin@fb.com>
 <20200901015003.2871861-15-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901015003.2871861-15-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 06:50:03PM -0700, Andrii Nakryiko wrote:
> -static bool ipv4_is_fragment(const struct iphdr *ip)
> +static __noinline bool ipv4_is_fragment(const struct iphdr *ip)
>  {
>  	uint16_t frag_off = ip->frag_off & bpf_htons(IP_OFFSET_MASK);
>  	return (ip->frag_off & bpf_htons(IP_MF)) != 0 || frag_off > 0;
>  }
>  
> -static struct iphdr *pkt_parse_ipv4(buf_t *pkt, struct iphdr *scratch)
> +static __always_inline struct iphdr *pkt_parse_ipv4(buf_t *pkt, struct iphdr *scratch)

similar concern. Could you keep old and add new one with macro magic?
