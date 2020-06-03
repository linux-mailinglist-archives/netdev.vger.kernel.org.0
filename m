Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2F21ED5F0
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 20:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgFCSPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 14:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCSPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 14:15:02 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2C6C08C5C0;
        Wed,  3 Jun 2020 11:15:01 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r10so2278715pgv.8;
        Wed, 03 Jun 2020 11:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Y69G6uVVBfPw/o8oXR0qs1ud5Tbzu38pJnxMfLYq0Zg=;
        b=T6Bb0DGHdWeRunRSRpTFJD9nczhjYVDqrbWKvP7mSI/1MDORYQd9cKqOo+MYzk73re
         NR4ToNHCa7a2fqfKkG7IZ4jjHTeZBCr8Uf7MHNQfMiZSHm8ZlWXWn0meaC5DzSoJP8OK
         NT+OgCXwEosGY3+ncSHB7dO0XijwUzNQxNC70zeLRUf5aTLStCu/HeBaUup03ebcY+NT
         L+QxhKz9Tc2xWdfXGbWAarUkDhSCs+EXBN0Vu2N3GADVXXLadSzQnst5GSooVAcC33YP
         fnYDrYkGQ3aAQMh7q3kmkHck70Tx71gNEFT5oFE0eqLwSn3DNrqYDKxwmN9nfVcSbafN
         GTYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Y69G6uVVBfPw/o8oXR0qs1ud5Tbzu38pJnxMfLYq0Zg=;
        b=bSzGSK7L3p7IHyDurkIkJoaE10i9skSgyOmrUzOZuzwXq9ChlWy3Oetbj6LQ2Dw/3W
         YSzdBmGSmAJhjhKCIiue0DzpU8QVraZRVyB79DXgRQXnxK0kYGM+C/eqgKt24zAZDP5N
         0mWtZMcIpvPCslJo2+KIGsBedbu+Umo7BVR3Y+sbQiIlpQhxAHs61v+p8tFsnbWAjaDL
         qbBZrXQ6h5ykC0zQHp3QC9kMCX6D+1/Ld3T1KGy26gh2euSe3qweFPo6KPbUOV434Wl8
         ngu7xW0+5P2zLBvNNjavbOvApCGPNpr7AIghoDmXGIg5N+T/y9H89Bbv7SE84pbXgyFK
         ExNQ==
X-Gm-Message-State: AOAM532fSYW8gMW0ntvtqgsLm1N/wOdg6pRXsXwqqIA8SDdfe1rpMhCA
        JWxf+FQpt7kBHvyw6FTss74=
X-Google-Smtp-Source: ABdhPJyBJ9u4ZhaM6mHxPwDDrYVO2bMrMWY65A9M5JPMF9jetO5zs8mkBFXfQunbXlFTgdUNFdcLmw==
X-Received: by 2002:a63:eb03:: with SMTP id t3mr643201pgh.222.1591208100418;
        Wed, 03 Jun 2020 11:15:00 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:514a])
        by smtp.gmail.com with ESMTPSA id h11sm3296290pjk.20.2020.06.03.11.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 11:14:58 -0700 (PDT)
Date:   Wed, 3 Jun 2020 11:14:55 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Ferenc Fejes <fejes@inf.elte.hu>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf] bpf: fix unused-var without NETDEVICES
Message-ID: <20200603181455.4sajgdyat7rkxxnf@ast-mbp.dhcp.thefacebook.com>
References: <20200603081124.1627600-1-matthieu.baerts@tessares.net>
 <CAAej5NZZNg+0EbZsa-SrP0S_sOPMqdzgQ9hS8z6DYpQp9G+yhw@mail.gmail.com>
 <1cb3266c-7c8c-ebe6-0b6e-6d970e0adbd1@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1cb3266c-7c8c-ebe6-0b6e-6d970e0adbd1@tessares.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 11:12:01AM +0200, Matthieu Baerts wrote:
> Hi Ferenc,
> 
> On 03/06/2020 10:56, Ferenc Fejes wrote:
> > Matthieu Baerts <matthieu.baerts@tessares.net> ezt írta (időpont:
> > 2020. jún. 3., Sze, 10:11):
> > > 
> > > A recent commit added new variables only used if CONFIG_NETDEVICES is
> > > set.
> > 
> > Thank you for noticing and fixed this!
> > 
> > > A simple fix is to only declare these variables if the same
> > > condition is valid.
> > > 
> > > Other solutions could be to move the code related to SO_BINDTODEVICE
> > > option from _bpf_setsockopt() function to a dedicated one or only
> > > declare these variables in the related "case" section.
> > 
> > Yes thats indeed a cleaner way to approach this. I will prepare a fix for that.
> 
> I should have maybe added that I didn't take this approach because in the
> rest of the code, I don't see that variables are declared only in a "case"
> section (no "{" ... "}" after "case") and code is generally not moved into a
> dedicated function in these big switch/cases. But maybe it makes sense here
> because of the #ifdef!
> At the end, I took the simple approach because it is for -net.
> 
> In other words, I don't know what maintainers would prefer here but I am
> happy to see any another solutions implemented to remove these compiler
> warnings :)

since CONFIG_NETDEVICES doesn't change anything in .h
I think the best is to remove #ifdef CONFIG_NETDEVICES from net/core/filter.c
and rely on sock_bindtoindex() returning ENOPROTOOPT
in the extreme case of oddly configured kernels.
