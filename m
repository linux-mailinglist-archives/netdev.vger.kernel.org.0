Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B3C567B6E
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 03:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiGFBXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 21:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiGFBXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 21:23:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CC171835B
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 18:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657070619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LgRO2LsJ2aYmwc8L5Dz0LPduacftx8Zt8A0gl3JpkJE=;
        b=Fvi8a8GJcN57qGfs5j9Sc/fMoIImBshnPT+2gIADUQYTHjdFPS0k4+yfhgCEVipeKBcXNc
        r8DYmc/Bd+s5cMUJTbbyp3Z71tneN2Iea/cNtd9rI3Gfeho5PemBV4R8W6B79uhIN+UThX
        ZnoWJcdvNdERk1XlBQhS3ZHpkJff2kw=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-4OIVlO4VOU6XWI3wuqh90g-1; Tue, 05 Jul 2022 21:23:32 -0400
X-MC-Unique: 4OIVlO4VOU6XWI3wuqh90g-1
Received: by mail-qt1-f199.google.com with SMTP id q21-20020ac84115000000b0031bf60d9b35so10845556qtl.4
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 18:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LgRO2LsJ2aYmwc8L5Dz0LPduacftx8Zt8A0gl3JpkJE=;
        b=26LSfBmMgKVMTzN4aVaUMtMM672w9+oe7ljobnpaRBvvoSt2Q/kylModlpU+rrLKnr
         UcuX497pnNe2PXwy0q5H+8KfJzBFEivfgzV53+g5q5axMbjmOy/aLHjwp0gFh7d57B7A
         oRJfQ1KivyM4tA/7koh4wtTo18n8bsrVRnmPuUmHAZlPE+NP5b2zlIrIQTp3uz7XEuWZ
         4/5cebJzx/h/5dPExPpsMHNes+XbntlLipeN/ekRCVYwPFDVyEK6+BCTtjzl+eMxwoAC
         nYSTyx8Y+7OKnzrNgy4fkrv3px/8Pdx7KpA9pvjBEULqeOmyRHekzhEWi/Ah9/XAJa1X
         yZjA==
X-Gm-Message-State: AJIora/CLTr7Jkao/FElZFb22VCBtwagbGRBNJUY/d7GwZ41oJ9BUzNX
        NFpwD5ND4gRsXXongB26qNfeucl4TqEz0RFwmXDTsxB4JA3AbIMLQVN0rAtStQfaVqlOGfbNPng
        ehz/U45y71lSufGDgbZeprcbKQLg9eNWV
X-Received: by 2002:a05:622a:1306:b0:31a:f73e:3d6d with SMTP id v6-20020a05622a130600b0031af73e3d6dmr31008151qtk.339.1657070612541;
        Tue, 05 Jul 2022 18:23:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v7NctD63htmmRps11di1rFpfwAzvuDqVBdjDk5DGUahVyeqNJfi8VMs+GwOXUYxlcV4+NsvlFs/zav2KIJ0xI=
X-Received: by 2002:a05:622a:1306:b0:31a:f73e:3d6d with SMTP id
 v6-20020a05622a130600b0031af73e3d6dmr31008140qtk.339.1657070612377; Tue, 05
 Jul 2022 18:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com> <20220701143052.1267509-20-miquel.raynal@bootlin.com>
In-Reply-To: <20220701143052.1267509-20-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 5 Jul 2022 21:23:21 -0400
Message-ID: <CAK-6q+ihSui2ra188kt9W5CT0HPfJgHoOJfsMS_XDLfVvoQJTg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 19/20] ieee802154: hwsim: Do not check the rtnl
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jul 1, 2022 at 10:37 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> There is no need to ensure the rtnl is locked when changing a driver's
> channel. This cause issues when scanning and this is the only driver
> relying on it. Just drop this dependency because it does not seem
> legitimate.
>

switching channels relies on changing pib attributes, pib attributes
are protected by rtnl. If you experience issues here then it's
probably because you do something wrong. All drivers assuming here
that rtnl lock is held.

- Alex

