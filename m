Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7138C4D6436
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 15:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240969AbiCKPAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 10:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241648AbiCKPAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 10:00:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E34EB1693A8
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 06:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647010776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3W/IoaQ0z5H2FlrGbqflpFUCLF4DbPLlyyeKMaGHUXY=;
        b=gAVpBQin9sACPXnDPbVY8kzdhJ5hI/Lj7jKucE/b7Db9OX4ye3crH7I3UnOvTL6vj2KoFF
        dQR4kVZR6KrQ9VI8q06wKPwQZ8XUeQsL2/RN3EAOmAG8I7wRhfX0YBYrBjpzW0IsBHJK1S
        Sww07s9ksRgvWVPU0NF0RoaJrvW5ri8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-jecsucpWOIywaOpzw7hRog-1; Fri, 11 Mar 2022 09:59:33 -0500
X-MC-Unique: jecsucpWOIywaOpzw7hRog-1
Received: by mail-ed1-f71.google.com with SMTP id u28-20020a50d51c000000b004159ffb8f24so5008712edi.4
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 06:59:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=3W/IoaQ0z5H2FlrGbqflpFUCLF4DbPLlyyeKMaGHUXY=;
        b=Mf8VqEOySKXe/L7JgzBZV3xc+/hDpriQUz3oStLGKIsnImjp+w+I+n734EZdlIfzQf
         9F10r8RVe8TYO13BWag3ChAZuuwbc9wHAHpb8k9cLvhgutGSn7QV9r+07WHN5VQr30QX
         Ud6Ewl2V4LpKC0rLgmpsugi1Rv776+vK1D601xta/r4gGFsOdk9fPSRJB8e6HxYbqlZH
         oiSlii5FKSCaTISodv0XcSdGzvgdcGa1ay0uYrl3RieBv9VsdTIEGSj/k2y4NdyJGUI9
         7Xs4IBxymO4Kc/uFxJD+ZIKaRT4MMb6MhpRQfq81BTUELEyccUrwejypYWeszPeZJuep
         h7TA==
X-Gm-Message-State: AOAM532iMmJPfC3nQ3P1ZTwF6pOmR52JGQ1LgAURfewaT9yt9oC4oyM8
        PV3BrVMIZtP1YnqmWz52oL53YnZqFaRay/ToeeM+nSb9ycXRFE+JDWhBQxShWVUrFHEp6jCQKiW
        nnbOTqqL6ImRhOPut
X-Received: by 2002:a17:906:9754:b0:6da:7d72:1353 with SMTP id o20-20020a170906975400b006da7d721353mr8887366ejy.273.1647010768933;
        Fri, 11 Mar 2022 06:59:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7fXe6QQk628+FhGowANMFq1dijH20UyoC49Xg3az5EYhBMrj6bMQHREdwOGK+yoQOK8p1dg==
X-Received: by 2002:a17:906:9754:b0:6da:7d72:1353 with SMTP id o20-20020a170906975400b006da7d721353mr8887172ejy.273.1647010766196;
        Fri, 11 Mar 2022 06:59:26 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id ec21-20020a170906b6d500b006d170a3444csm3012478ejb.164.2022.03.11.06.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 06:59:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 25B441AB56B; Fri, 11 Mar 2022 15:59:25 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, pabeni@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        toshiaki.makita1@gmail.com, andrii@kernel.org
Subject: Re: [PATCH v5 bpf-next 2/3] veth: rework veth_xdp_rcv_skb in order
 to accept non-linear skb
In-Reply-To: <8d228b106bc1903571afd1d77e797bffe9a5ea7c.1646989407.git.lorenzo@kernel.org>
References: <cover.1646989407.git.lorenzo@kernel.org>
 <8d228b106bc1903571afd1d77e797bffe9a5ea7c.1646989407.git.lorenzo@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Mar 2022 15:59:25 +0100
Message-ID: <87y21gwn5e.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Introduce veth_convert_skb_to_xdp_buff routine in order to
> convert a non-linear skb into a xdp buffer. If the received skb
> is cloned or shared, veth_convert_skb_to_xdp_buff will copy it
> in a new skb composed by order-0 pages for the linear and the
> fragmented area. Moreover veth_convert_skb_to_xdp_buff guarantees
> we have enough headroom for xdp.
> This is a preliminary patch to allow attaching xdp programs with frags
> support on veth devices.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

