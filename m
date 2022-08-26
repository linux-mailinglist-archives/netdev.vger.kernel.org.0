Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC22B5A20F9
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 08:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244807AbiHZGj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 02:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240824AbiHZGj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 02:39:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61FA15A19
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661495996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ECDJ8QTTg2+F1UM14QHCzubQKC4GAzBG+sQ/KnCfupc=;
        b=LX0IBTdAxt5/WyOpQCEc39Xg90KOS4qVsHMKdGQPS/EtPnek2g8f329Pr6sUfT0/Hl6iJx
        f6l5BQI6wiosIU6NyYwWl/k12cZBPBqsCQutvD5bz5IyviDjnMYaL4rqAJISLRpHZ6OUxD
        vk82rHJIR4qz8JRIT+LcnEFSu1K2r8c=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-90-eUkrWJ9UPu6d7MS1t30p3Q-1; Fri, 26 Aug 2022 02:39:55 -0400
X-MC-Unique: eUkrWJ9UPu6d7MS1t30p3Q-1
Received: by mail-qt1-f200.google.com with SMTP id cj19-20020a05622a259300b003446920ea91so696235qtb.10
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:39:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=ECDJ8QTTg2+F1UM14QHCzubQKC4GAzBG+sQ/KnCfupc=;
        b=TkrfbgWWgQ/Bx1nGz6ueCIoeIl8LDRUsKiC02zXQKgzbn8MmFnLxSBp85Um3S3wGpf
         zl4f5EbQsZ4UTFT1EhtnpQnLBrkB53ydaX+CFjFuR48bsumIH/z6yyoLV4yzhcsi5O0y
         vNuAUf+lNzG1kbEEa4CWlY2Jyb0WZVBNQrCD467IOpyV5C6IiCW52P41FUnzQzYyC5Ts
         5qJF/yUDWbb6t5VBeQn54Fki3BvRSxoYIyElL8kGFOP3jBNFntc/b8jmErFDhfioQtBf
         i5tdEvqMyHlilplseulfRMR694gTzowX83nAhvozwow0ez/OPb+ZkfXvsObQy4sph0UF
         +nig==
X-Gm-Message-State: ACgBeo06TseOEULmMGkKB0CofVo06b9R4KAXHOM1HT7qQuKog6qrKqW1
        dD99Ce7zkWGzMQ3JmhOaPErB3rUV4xmOJus7AoKYl5R82t9yynQXbkU/kpc+4sL2wZmSjz70EuZ
        wpnE5AKYdfW55mHFY0HVErokSo6Z7chTR
X-Received: by 2002:ad4:5aa2:0:b0:496:e034:dc4b with SMTP id u2-20020ad45aa2000000b00496e034dc4bmr6698953qvg.43.1661495995185;
        Thu, 25 Aug 2022 23:39:55 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4YdLZqhkPIargP58smhVkNXHwMeO1sdaXJauYCx7PylF3optCdsl/FmY5H0zJi+1AArk9TbCn8SAvSZ+/BpOQ=
X-Received: by 2002:ad4:5aa2:0:b0:496:e034:dc4b with SMTP id
 u2-20020ad45aa2000000b00496e034dc4bmr6698942qvg.43.1661495994964; Thu, 25 Aug
 2022 23:39:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220819082001.15439-1-ihuguet@redhat.com> <20220825090242.12848-1-ihuguet@redhat.com>
 <20220825090242.12848-3-ihuguet@redhat.com> <20220825183229.447ee747@kernel.org>
In-Reply-To: <20220825183229.447ee747@kernel.org>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Fri, 26 Aug 2022 08:39:44 +0200
Message-ID: <CACT4oufi28iXQscAcmrQAuiKa+PRB81-27AC4E7D41LG1uzeAg@mail.gmail.com>
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

On Fri, Aug 26, 2022 at 3:32 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 25 Aug 2022 11:02:41 +0200 =C3=8D=C3=B1igo Huguet wrote:
> > -static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx, u16 port)
> > +static inline void efx_ptp_init_filter(struct efx_nic *efx,
> > +                                    struct efx_filter_spec *rxfilter)
>
> No static inline in sources unless you actually checked and the
> compiler does something stupid (pls mention it in the commit message
> in that case).

OK, I will change it (I think I should read again and remember the
coding style document)

>
> > +static inline int
> > +efx_filter_set_ipv6_local(struct efx_filter_spec *spec, u8 proto,
> > +                       const struct in6_addr *host, __be16 port)
>
> also - unclear why this is defined in the header
>

This is just because it's the equivalent of other already existing
similar functions in that file. I think I should keep this one
untouched for cohesion.
--=20
=C3=8D=C3=B1igo Huguet

