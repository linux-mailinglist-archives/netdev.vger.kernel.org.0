Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A0F4D6438
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 15:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241839AbiCKPAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 10:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242365AbiCKPAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 10:00:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B5EF171ECB
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 06:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647010784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I9nC5wQqiuVhnAx4Yqa5lMKKFE1c4cG7N09X/H5kS2s=;
        b=hYmywskwp0mtjMpIBXAjejrO51gDWLgU43SQoHvX2hYptAHc7a/3KmckcRVAk/SK8A7JqB
        9P7HXytsKdfK7m+UH81YrNHD30vhOAI6d1/LZIIMVX4iJqTo42Wmbyf/7HkBLl4hB/sojm
        WTR0DxMc/0HpI/cxaKTSPaYwIMNvPfE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-gRsfGOseM-G1mEnK-Zokgw-1; Fri, 11 Mar 2022 09:59:43 -0500
X-MC-Unique: gRsfGOseM-G1mEnK-Zokgw-1
Received: by mail-ej1-f71.google.com with SMTP id d7-20020a1709061f4700b006bbf73a7becso5060967ejk.17
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 06:59:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=I9nC5wQqiuVhnAx4Yqa5lMKKFE1c4cG7N09X/H5kS2s=;
        b=PVnj4GyXYRg+scVVdQ6+Qtwa2pcC4a5En93VA4f2stgF7H0et2NHnf7+EYgwVTDrlN
         mveYAZXPH4kDMuRGvQXzE4RpD6remi6+2M9XC0p/bLsopQmzyxGcRomKmsPEhtix5NJO
         ZLdXdBUZWqqBJtepJ1bH1GXRyTHmvHbVR9VhnW+Zu+RnA5LitxpRQkhrTGS05fxH9zAl
         S14IyOhwV/zNcavUgMsAZZORZJ8gdTQUT4xn8VlgPmdTvhiRz90H0W9uvBSEAC/3YD9v
         bMZCyGW/C2uO2SCH+NKvp0IA+vxMZU38OzXjyfXx07fHY5Cms9W5zo1DBsEtJ0polvXV
         x26g==
X-Gm-Message-State: AOAM530Z4EVTaLtdURNgakgt/Z+9kyXuZ+Et7af1rBdNKuyCEWX8P6bx
        HwRtkqUpRmB9yauFB8cBq2pbzkaNxlKU6wd+UpsxZBIzYVL4vD99OAsp5NoefjqK+8jjmArhkMo
        bwzxv30rdhKUIrLdB
X-Received: by 2002:a17:906:6841:b0:6cf:9c02:8965 with SMTP id a1-20020a170906684100b006cf9c028965mr8836273ejs.440.1647010781336;
        Fri, 11 Mar 2022 06:59:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxmvxSgTS3KGD0JT0bQe+CFeJKixbHXYNmnspT9wGRFZguAzPo/qRrGHol+cQjJym43mPW+eg==
X-Received: by 2002:a17:906:6841:b0:6cf:9c02:8965 with SMTP id a1-20020a170906684100b006cf9c028965mr8836110ejs.440.1647010779157;
        Fri, 11 Mar 2022 06:59:39 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id r29-20020a50c01d000000b00415fb0dc793sm3338254edb.47.2022.03.11.06.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 06:59:38 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B955C1AB56D; Fri, 11 Mar 2022 15:59:37 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, pabeni@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        toshiaki.makita1@gmail.com, andrii@kernel.org
Subject: Re: [PATCH v5 bpf-next 3/3] veth: allow jumbo frames in xdp mode
In-Reply-To: <d5dc039c3d4123426e7023a488c449181a7bc57f.1646989407.git.lorenzo@kernel.org>
References: <cover.1646989407.git.lorenzo@kernel.org>
 <d5dc039c3d4123426e7023a488c449181a7bc57f.1646989407.git.lorenzo@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Mar 2022 15:59:37 +0100
Message-ID: <87v8wkwn52.fsf@toke.dk>
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

> Allow increasing the MTU over page boundaries on veth devices
> if the attached xdp program declares to support xdp fragments.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

