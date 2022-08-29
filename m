Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE5F5A4380
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 09:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiH2HEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 03:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiH2HD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 03:03:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90F14D169
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661756637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=swPCdAy9+JhM1oPXPMCDi4cY3v+3Wo9MMsdd9agualI=;
        b=CL/59oKwkjVB/jY/zYWn2QwxhJaOWpcIdeDV1vbxu33MLzmpfdFzkG6heNc+wIcxhWP2Ab
        CdOCkiuwpfPPqIMTWs2ic9tsBogEhX16y4Mv9X83rWlm7nK7xfUL4b6iBwxij05e9cq/f5
        vPQ2wAmt9GvD7h6jCQ+hG09hS/EC3rk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-112-OXiQ9_o4MXW06Vuf-6twIg-1; Mon, 29 Aug 2022 03:03:56 -0400
X-MC-Unique: OXiQ9_o4MXW06Vuf-6twIg-1
Received: by mail-qt1-f200.google.com with SMTP id cj19-20020a05622a259300b003446920ea91so5846222qtb.10
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=swPCdAy9+JhM1oPXPMCDi4cY3v+3Wo9MMsdd9agualI=;
        b=FIP61fcu3rJEM7R3Yj8fZmoEFb+rPPQOrIjs6BLbH1AGbKqZ0+VHOCvLe3P+hN38PQ
         6e1UZgDdX4zyvJbdJtTU6uhQtULBvv3PIeI1gX8hCtbdyeaa2jamKaJ+5L7cM8shI3su
         TZabrrBIC2AOadxUXtCDuJqhUL9RItmQ2DPsANkVSHxm1hcSKRGvLUo+/49MndGjvFp0
         ZLoZu8JltiSc4SCxh17cTTCmHoyFwmWfIFEzDySOwI2GMTAW+L+Md3HPC2viFEhDnBOa
         7zu3sE0VlYCIKg3pqApO7yY0nss1le4vXFr0zPvcqQ/EPdhPfttZVPlkJ2HGzrM1OPn4
         ZvnA==
X-Gm-Message-State: ACgBeo0d9+IOI12NrX5BWw8cFI/A+bBLRjIFY0ClBP1/9Lm6PZLaMSTF
        X/w73OfwnjCYM5LMIC4CXrbkcijvZowPVetL/pVtvUA9zHRN8aQHbB0ya1UzrZJqrrPgLw8mU0b
        DARsUEO3WP1hZceAWlLvTIjxGhrHC39/c
X-Received: by 2002:a05:6214:cce:b0:499:606:1526 with SMTP id 14-20020a0562140cce00b0049906061526mr920283qvx.64.1661756635622;
        Mon, 29 Aug 2022 00:03:55 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5DXV+89UQnSpxKV04YlQP3lOOGrmUQQZG4MpHxYKZkgSn/YbRGNzgdfywgcv55dZm/hqH3r5zkRqYNhVoSX58=
X-Received: by 2002:a05:6214:cce:b0:499:606:1526 with SMTP id
 14-20020a0562140cce00b0049906061526mr920271qvx.64.1661756635388; Mon, 29 Aug
 2022 00:03:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220819082001.15439-1-ihuguet@redhat.com> <20220825090242.12848-1-ihuguet@redhat.com>
 <20220825090242.12848-3-ihuguet@redhat.com> <20220825183229.447ee747@kernel.org>
 <CACT4oufi28iXQscAcmrQAuiKa+PRB81-27AC4E7D41LG1uzeAg@mail.gmail.com> <20220826162731.5c153f7e@kernel.org>
In-Reply-To: <20220826162731.5c153f7e@kernel.org>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Mon, 29 Aug 2022 09:03:44 +0200
Message-ID: <CACT4ouegMFu7OZ9MQehYXH002P_Hz4OKfuObCzZ6pFOTGPUAsQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] sfc: support PTP over IPv6/UDP
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 27, 2022 at 1:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 26 Aug 2022 08:39:44 +0200 =C3=8D=C3=B1igo Huguet wrote:
> > > > +static inline int
> > > > +efx_filter_set_ipv6_local(struct efx_filter_spec *spec, u8 proto,
> > > > +                       const struct in6_addr *host, __be16 port)
> > >
> > > also - unclear why this is defined in the header
> >
> > This is just because it's the equivalent of other already existing
> > similar functions in that file. I think I should keep this one
> > untouched for cohesion.
>
> We usually defer refactoring for coding style issues until someone
> is otherwise touching the code, so surrounding code doing something
> against the guidance may be misleading.
>

Yes but I'm not sure what I should do in this case... all other
efx_filter_xxx functions are in filter.h, so putting this one in a
different place could make it difficult to understand how the files
are organized. Should I put the declaration in the header (without
`inline`) and the definition in a new filter.c file? Should I move all
other definitions to this new file?

Also, what's exactly the rule, apart from not using `inline`, to avoid
doing the same thing again: to avoid function definitions directly in
header files?

Thanks
--=20
=C3=8D=C3=B1igo Huguet

