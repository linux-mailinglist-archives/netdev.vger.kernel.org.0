Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE94A5F02E1
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiI3CgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiI3Cfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:35:52 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAC812CC9E;
        Thu, 29 Sep 2022 19:35:37 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id v1so2800506plo.9;
        Thu, 29 Sep 2022 19:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date;
        bh=geOV+uiuYHteTOnoGFMTsZksd4tYLBBzKNa6NGFjrOs=;
        b=EhVyddOpZhT+hunkmBFc6f0IPsN6CKlv6t7A8LHLS42qZK0CW/LVXyGYbatCNbZBM/
         GtQl8dqZMrDXgDf25ATGKK+vRF5Y39tcSRqbXHi/tWm7RJbOg81Fpa0z+W+TdRmFKNl3
         I8cl/R+PjLoX5lo2+35+x6zCUyW/TwKno8CixyGdgcdjcXMP2diC+lAdTpqdfLgEbTSM
         AZv7aK0f3zWX5z9MrXuXArYQs8CVQdnsPA+3m1V75mGtkBn9Nx5XQnUzUY/jYqWsfI7b
         EWxY4E0qGv9oTSrogoxpVPxyrzFBurx6WVPeguMjnY+hZ9Isrjx05EzXgWdh58sbdjPk
         n3dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date;
        bh=geOV+uiuYHteTOnoGFMTsZksd4tYLBBzKNa6NGFjrOs=;
        b=gfPlsIim+SOsbnNbnlk3tKKi2srYpmuCNgq/XxKnX275whPQdEYHG/4Qq86whDKywG
         ATUARvx36yBMvl3CSGWV1FsyS525rL+PX0Lw1lI7RUbCfJelDNsFsO9kNeg7v5lgEFSX
         raTlEnsE5GrlM6/vey2gTXmmi618xwZtyWfqnkM1kMl5MxAWwT4bZSnvOBubOYCIyBn7
         zuagvbWH4S4j01ge/VnmFMrzQY17o1D8gUIVg4Nok9dNwW6WfVNI/XxJxS+cZYjoHZJG
         HXEvOwUHMfJuznlcI0RD8+YdaM7l1lJN+u9L3t2zP1d5budHwt3GtVRbAVrpKSJlXRzo
         nrJw==
X-Gm-Message-State: ACrzQf2LB+vGW6JTO58l48i6n2QXIyFmXD784AATbGau+R95eSOXb6t6
        3YQIn9T1T8cGBkwUyVrYQ24=
X-Google-Smtp-Source: AMsMyM5G7DJ6Ap0cl4ImexC9M45ZFTjzuKcsPyZZ8K9Sx67PnC0FiIhiMIT619+ZDsNq5j9d13UTtQ==
X-Received: by 2002:a17:903:230e:b0:178:3356:b82a with SMTP id d14-20020a170903230e00b001783356b82amr6609023plh.138.1664505336975;
        Thu, 29 Sep 2022 19:35:36 -0700 (PDT)
Received: from localhost ([98.97.42.14])
        by smtp.gmail.com with ESMTPSA id r9-20020a655089000000b0043a09d5c32bsm612197pgp.74.2022.09.29.19.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 19:35:36 -0700 (PDT)
Date:   Thu, 29 Sep 2022 19:35:34 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, nathan@kernel.org, ykaliuta@redhat.com,
        bpf <bpf@vger.kernel.org>
Message-ID: <633655f64ff90_233df20817@john.notmuch>
In-Reply-To: <abd188ce-a097-5626-87bf-607495035a66@linux.dev>
References: <51a65513d2cda3eeb0754842e8025ab3966068d8.1664490511.git.lorenzo@kernel.org>
 <abd188ce-a097-5626-87bf-607495035a66@linux.dev>
Subject: Re: [PATCH v2 bpf-next] net: netfilter: move bpf_ct_set_nat_info
 kfunc in nf_nat_bpf.c
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau wrote:
> On 9/29/22 3:38 PM, Lorenzo Bianconi wrote:
> > Remove circular dependency between nf_nat module and nf_conntrack one
> > moving bpf_ct_set_nat_info kfunc in nf_nat_bpf.c
> > 
> > Fixes: 0fabd2aa199f ("net: netfilter: add bpf_ct_set_nat_info kfunc helper")
> > Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Tested-by: Nathan Chancellor <nathan@kernel.org>
> > Tested-by: Yauheni Kaliuta <ykaliuta@redhat.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> > Changes since v1:
> > - move register_nf_nat_bpf declaration in nf_conntrack_bpf.h
> > ---
> >   include/net/netfilter/nf_conntrack_bpf.h | 19 ++++++
> >   net/netfilter/Makefile                   |  6 ++
> >   net/netfilter/nf_conntrack_bpf.c         | 50 ---------------
> >   net/netfilter/nf_nat_bpf.c               | 79 ++++++++++++++++++++++++
> >   net/netfilter/nf_nat_core.c              |  4 +-
> 
> lgtm.  It should have addressed Pablo's comment in v1.  Can the netfilter team 
> give an ack for the patch?
> 

Also lgtm

Acked-by: John Fastabend <john.fastabend@gmail.com>
