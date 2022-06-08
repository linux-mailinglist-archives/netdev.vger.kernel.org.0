Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75476542736
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiFHEkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 00:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbiFHEhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 00:37:52 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626F13F62EA;
        Tue,  7 Jun 2022 19:29:40 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id w2-20020a17090ac98200b001e0519fe5a8so17089125pjt.4;
        Tue, 07 Jun 2022 19:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=x8jfXCoRdNo81j+YuOPFSNctg2Xa/rnwTNhEDAgXG5w=;
        b=eha6Dy6wDGcKn1duwJ2Ok5ihZilh12rRdY4tzkCvkPTN+hImcZ3sA/5ttBQhFWCFsx
         tV6Ng9/QrD+DBBLMdPr9u18mJTLd36JowYC+9CxqP+rlCO2UHy18iIBqHqxTDHOJ8ZSy
         xu1Zv7uKflZjdzZZ/QQJ1LO2ykRrUW5F8DWxxcPjesWKq/esCCQkz6UmYucA8U4jviBJ
         V3u4IYaDchwx2GkJzPhXILqbEbGsjr20Px0tD2XJ876BMGvuHaJJGPM6UQqFKTp05oOS
         EltY9lfAkpGIi3+/S4t7ZjzThdskDM3sK2G6crlGfllqDebkIU9V4q+v8Otse91ZwzYG
         yZ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=x8jfXCoRdNo81j+YuOPFSNctg2Xa/rnwTNhEDAgXG5w=;
        b=k3RXyBpb1ayORSutg1M/SDKJPW/v+eDwMQHwkoG2LQ8N/hur0Mb18pyoNpEdn1Z4/v
         +g782zM5djmxy2jf0GaWYTNnchU0HnyQJ07PPElsswzY8/yPbg3HhZ8LtPrlOWeZ7nAX
         vzwOI1pevuZZRnP2lK+7f+Wadahevq+mda+6syX4AX2ONP4afJmNugDFqdh4AHWRYy91
         WStqQ24GZ6xTI4tFqxbYYXU/KIljl54RXyYpfkvQdyCzZJ8Hu8ETWajmiPpefjr3WijP
         /cJZ+qsfOlqoZquP6h+eb24mJmG21N18qJORsJ9m+CZ0q61ugOw6vPk0HaNN5VRYR0EU
         88ZQ==
X-Gm-Message-State: AOAM531VMf5SE6g2TCp7CQc2id5k0ccuYyGHu0XvH0RxTintrKMq7lFe
        TWH/ADrzcwJx1IZ+DBAOlNc=
X-Google-Smtp-Source: ABdhPJwWSThahXMN4+i+EkbaZL0/wp99vhCBE+iKn2UwLEOs+eAF9DubXmQ1ZdhyE+nIOArhLyNHjQ==
X-Received: by 2002:a17:902:db0a:b0:165:1672:480e with SMTP id m10-20020a170902db0a00b001651672480emr31655064plx.165.1654655362665;
        Tue, 07 Jun 2022 19:29:22 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w143-20020a627b95000000b0051b8e7765edsm13731862pfc.67.2022.06.07.19.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 19:29:21 -0700 (PDT)
Date:   Wed, 8 Jun 2022 10:29:12 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH bpf-next 0/3] move AF_XDP APIs to libxdp
Message-ID: <YqAJeHAL57cB9qJk@Laptop-X1>
References: <20220607084003.898387-1-liuhangbin@gmail.com>
 <87tu8w6cqa.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87tu8w6cqa.fsf@toke.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 11:31:57AM +0200, Toke Høiland-Jørgensen wrote:
> Hangbin Liu <liuhangbin@gmail.com> writes:
> 
> > libbpf APIs for AF_XDP are deprecated starting from v0.7.
> > Let's move to libxdp.
> >
> > The first patch removed the usage of bpf_prog_load_xattr(). As we
> > will remove the GCC diagnostic declaration in later patches.
> 
> Kartikeya started working on moving some of the XDP-related samples into
> the xdp-tools repo[0]; maybe it's better to just include these AF_XDP
> programs into that instead of adding a build-dep on libxdp to the kernel
> samples?

OK, makes sense to me. Should we remove these samples after the xdp-tools PR
merged? What about xdpxceiver.c in selftests/bpf? Should that also be moved to
xdp-tools?

Thanks
Hangbin
