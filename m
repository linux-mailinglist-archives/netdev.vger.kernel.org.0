Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E822749F4
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 22:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgIVUQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 16:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgIVUQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 16:16:03 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5499C061755;
        Tue, 22 Sep 2020 13:16:03 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u24so2069504pgi.1;
        Tue, 22 Sep 2020 13:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l+thkMdwYNeUD83jZWCOal/nLtj+TLcykc7l4j9Wifo=;
        b=NOKCHZd6LGy9JHVOhyuKk9S5/WlT3xLdpOkEA0vQZR8G6rAGOjgtHUjaF0dfYhhBNZ
         O0KNpHS3mgjNuY7/UnZNspH0GIyMOu6wH4wUsBp1tmw+OFKIV8IJV6LXq7m49JArOlzJ
         27MDx6JOUEzdqLy500TpQJ1ZIWNVeDgC9hoCvkZTP4mk822LI3/np2uVqwTN1n7MP2Wg
         PBgp5m4N16cmLISTGhvuCGDQbLFwvifqkPvuhnPCmsX2iqekZf3sw9oTdjWIA1fr/4u0
         eDHmJUO/MWzCP0TIWg/O5qvr6IOnXwuTr27D/Xxqx9PAtXmdWlBfHG0TTAROY0dWVoPq
         xoVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l+thkMdwYNeUD83jZWCOal/nLtj+TLcykc7l4j9Wifo=;
        b=fbc5qT6ntys/X9spDoNf4A9ELCVV3FCyVqnMf6YSqdsB7SStKSGjCo1o5KFTKcCNQv
         4kjKh2fCptsjqrhf38oUBLmPgxIDkaQAjml1neHfmTFJykKMFfd9mkSb322N6myw3Sxm
         keh0GSMwZVO8FQU0I0BsMb8Wc9ItIWerVNuO8KU76SALnaR0QyjTuc/UK9GeD+cBWh6r
         dcXP0sj7oGRN27PsPH9bMH3+B8sh7G1Kf5LEn0rXkNbGsY/gWvSPtC//MD+44RrNIU3t
         Dn3yTDKKkeCvveTgUXrZ6H5vnXbR2k8emOWQE8PAhbCitUyhwCydjY0lbZDIbE7QXiel
         wEwg==
X-Gm-Message-State: AOAM531PHm5z2GdQr1UHIaDuVeS/0ovkG2QTQCYrfm6k6p3hJNjzLIB+
        CUWiai52UQ+swiOGyYbwb3s=
X-Google-Smtp-Source: ABdhPJy0fzDf0cJ1BR1b/dXueit0Gq/J157X8FOnbwGpD1mM04B4pjhgOcWzmoxGvo4B/ygZ0TOsPQ==
X-Received: by 2002:a17:902:fe85:b029:d1:e598:3ff7 with SMTP id x5-20020a170902fe85b02900d1e5983ff7mr6095942plm.49.1600805763198;
        Tue, 22 Sep 2020 13:16:03 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f812])
        by smtp.gmail.com with ESMTPSA id f4sm12407429pgr.68.2020.09.22.13.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 13:16:02 -0700 (PDT)
Date:   Tue, 22 Sep 2020 13:16:00 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Lorenz Bauer <lmb@cloudflare.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 bpf-next 11/11] bpf: selftest: Use
 bpf_skc_to_tcp_sock() in the sock_fields test
Message-ID: <20200922201600.5cz6vslfiuw7hdkw@ast-mbp.dhcp.thefacebook.com>
References: <20200922070409.1914988-1-kafai@fb.com>
 <20200922070518.1923618-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922070518.1923618-1-kafai@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 12:05:18AM -0700, Martin KaFai Lau wrote:
>  
> @@ -165,9 +168,13 @@ int egress_read_sock_fields(struct __sk_buff *skb)
>  	tpcpy(tp_ret, tp);
>  
>  	if (sk_ret == &srv_sk) {
> +		ktp = bpf_skc_to_tcp_sock(sk);
> +		if (!ktp)
> +			RET_LOG();
> +		lsndtime = ktp->lsndtime;

If I understood the patches correctly they extend the use cases significantly,
but this test only covers cgroup/egress type with one particular helper.
Could you please expand the test cases to cover more of things from earlier
patches. Patch 7 covers some, but imo not enough.
Similarly the case of sk_release(sk) in one place and sk_release(ktp)
in another branch (one you mention in commit log) needs to have
C based selftest as well.
