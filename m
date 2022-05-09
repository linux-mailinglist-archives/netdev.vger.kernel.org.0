Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A8C520571
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240681AbiEITxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240677AbiEITxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:53:23 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9D74131A;
        Mon,  9 May 2022 12:49:26 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id x88so2510306pjj.1;
        Mon, 09 May 2022 12:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6m2VrNTTXfrBfZVnKNmQiT4jmnrzVdwkBw/0JWejick=;
        b=Duiqlh4x32JnThboBXKb88xk2jDl84O0+YUZ2CoK4/quC8maCjiyQvynXd0Wxh5ZPc
         OvJiK0y4tvwijwB0YsKHuZbLgimrZYSiedv/G3qwXetLK+Bi3ueKHuWGE1L54kgg4C0p
         YXmTvzh/rIxrhYNXO0T0KucZsK1X1hMY5kKHZ/bcKDfTy3kHIgRhp6oIKwBOrHYXxArO
         euM7jsxVwIkP4CyeJ4ydZFbcdQ6iiO/DAOl+yX5H4tuWpO5KIpkSVp/23F8rOcVc0u+x
         KYzvnFUzf3pnlxYgHFwiAFUIHufGEmGh5tW+InEozaEb07wJBSFo8/0e7mEmhbVZgGpH
         pRig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6m2VrNTTXfrBfZVnKNmQiT4jmnrzVdwkBw/0JWejick=;
        b=n0G8sQfdWixCHAD2eq0514h6xBc1yYzknBvWFGP5xJwphb2CMvwqGM95FfuUhg35LT
         s8wqQf8/Kxs/F3ThvAneh3TEyEoEftEzceBSHahNM5n4GELkP5Fwoa/no1BZgN3FK0GJ
         FeW7S7I4K0UNHA9VUTyUN5TYc6oP+CkmnU1DUhMvumbpUEAxAJwy8eYh4HAOliwkKBF0
         spI+49S+LmKBybpfApgPuhEXiafQZE8MEoBCwAD003Yb6MX2o4hhImI3Ht/88/xeV59o
         UynuC5q9Uhzt4FeY2F9c07NL/FvVkv6HrFcdbTwAdapqbHG9abBb0t16GBlYnOoMLdiZ
         xxGA==
X-Gm-Message-State: AOAM5335gLiDaYxooAm1srLZRCkxsKAJOjEblVnVzBp732A/XivMfsQU
        Ka2E2pRnYt13My8hQRFtHPI1AZ9kUgg=
X-Google-Smtp-Source: ABdhPJwfX1xWagxk5nIzZEw/xq548A//ChfF7CREu3G3iVq1e6ZmUhJT3tT7N8HBlzcTtSK5q+KZXg==
X-Received: by 2002:a17:903:11d0:b0:155:c240:a2c0 with SMTP id q16-20020a17090311d000b00155c240a2c0mr17333474plh.143.1652125766156;
        Mon, 09 May 2022 12:49:26 -0700 (PDT)
Received: from localhost ([157.51.71.11])
        by smtp.gmail.com with ESMTPSA id v10-20020aa799ca000000b0050dc7628166sm9058255pfi.64.2022.05.09.12.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 12:49:25 -0700 (PDT)
Date:   Tue, 10 May 2022 01:20:01 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Yuntao Wang <ytcoode@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next] bpf: Remove unused parameter from
 find_kfunc_desc_btf()
Message-ID: <20220509195001.vrfexsqty6igbh2r@apollo.legion>
References: <20220505070114.3522522-1-ytcoode@gmail.com>
 <20220509175242.3zgihomxteagixfa@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509175242.3zgihomxteagixfa@kafai-mbp.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 11:22:42PM IST, Martin KaFai Lau wrote:
> On Thu, May 05, 2022 at 03:01:14PM +0800, Yuntao Wang wrote:
> > The func_id parameter in find_kfunc_desc_btf() is not used, get rid of it.
> >
> > Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> Although it is a bpf-next material, it is still useful to have a Fixes tag
> such that the reviewer can quickly understand how the current code got here.
>
> Fixes: 2357672c54c3 ("bpf: Introduce BPF support for kernel module function calls")
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

--
Kartikeya
