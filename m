Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7FC4D455B
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 12:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbiCJLLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 06:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbiCJLLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 06:11:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06FA8111185
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 03:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646910614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IlVlE4no/cbfJjauKK6g2r1Se4De89ms/AzQipHNDCk=;
        b=I+GBa+EAzqkuDiL/i5PT45NPV1Vt5Yrqpacz2l4e2FdH4UQhHoGG6T9dhyPAeP3pE4ynHr
        n63yZIJ0cHEhqmjIEmwLf8fWQacziXUXjLRZTgWW4puHHDW3qCrI4o+6Y7YOFwYJQZvTea
        CDfLthKx28YmX53BJZdEIqcTksuEQj8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-4NyQNVOVNXCgAMQ-wYD0cQ-1; Thu, 10 Mar 2022 06:10:13 -0500
X-MC-Unique: 4NyQNVOVNXCgAMQ-wYD0cQ-1
Received: by mail-ed1-f71.google.com with SMTP id h17-20020a05640250d100b004133863d836so2952657edb.0
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 03:10:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=IlVlE4no/cbfJjauKK6g2r1Se4De89ms/AzQipHNDCk=;
        b=yXqD+ca0hu/N+y/DrR2I9IMOwYl2s1j+13nNiYk8lGoKBVXLIskxCDjZk6b3WD6T3A
         hqL7U5O8k/jyMMhak8ILPc0YHxiK18QTcSxcmJEEdZhXkuu1f/q027n9Tz0DBNb7N5dn
         scGmtjWS6sTbKFR2CdbEHOIBqH1mlQaj++dkMzdsQDGSYLEFVzAGmuomdEOTR134uc8c
         XgvylP4/Qen/nDB9LlM4rCBWDF6Bk9lBlFFGhOH9F0F/7K3AuXl6BCbodjMmMBLohwKc
         vlWEVyATdUFm9Sc84OWvzoA/mkCxjNCw2LHv3qtJn6jXAeL49rvowiP8ZJmyan4tJeRC
         7XiQ==
X-Gm-Message-State: AOAM533ml89O4TX0e/iFSP++rQYVEAlxILBWB44IQrUQMYkEATPRvMtp
        Mlx/jIzlMylJ0Y3pATVKtWNM9y/jEvgjmvraufuHV/DC56q6BzGkcZLnkuWumuicK/R9kFlMYkN
        ubUO5+MTLKhlhx5qu
X-Received: by 2002:a17:906:8488:b0:6da:bebf:98b with SMTP id m8-20020a170906848800b006dabebf098bmr3616130ejx.587.1646910611038;
        Thu, 10 Mar 2022 03:10:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxAwDntpFMbkkaGPoprV2Wa42toeq0rKQFyinlblPtJo5bNZcBazJ48EytbG1FD1gspU12r/Q==
X-Received: by 2002:a17:906:8488:b0:6da:bebf:98b with SMTP id m8-20020a170906848800b006dabebf098bmr3615954ejx.587.1646910608563;
        Thu, 10 Mar 2022 03:10:08 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t14-20020a170906608e00b006d1455acc62sm1648957ejj.74.2022.03.10.03.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 03:10:07 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 45206192CC7; Thu, 10 Mar 2022 12:10:07 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, pabeni@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        toshiaki.makita1@gmail.com, andrii@kernel.org
Subject: Re: [PATCH v4 bpf-next 1/3] net: veth: account total xdp_frame len
 running ndo_xdp_xmit
In-Reply-To: <b751d5324b772a7655635b0f516e0a4cf50529db.1646755129.git.lorenzo@kernel.org>
References: <cover.1646755129.git.lorenzo@kernel.org>
 <b751d5324b772a7655635b0f516e0a4cf50529db.1646755129.git.lorenzo@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 10 Mar 2022 12:10:07 +0100
Message-ID: <87h786ukq8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Even if this is a theoretical issue since it is not possible to perform
> XDP_REDIRECT on a non-linear xdp_frame, veth driver does not account
> paged area in ndo_xdp_xmit function pointer.
> Introduce xdp_get_frame_len utility routine to get the xdp_frame full
> length and account total frame size running XDP_REDIRECT of a
> non-linear xdp frame into a veth device.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

