Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03975774CB
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 08:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiGQGZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 02:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiGQGZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 02:25:14 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D3C1C117
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 23:25:12 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so9827434pjf.2
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 23:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0sN1sbNkaErQb23q05TEI1vM4GG/gjWq368Ny0MMruA=;
        b=uzdpcOY5JI8SC83YhJJcb5JJDtzI/F/gDmby6CVzYX/hgSizbmFmjWkF6fILTlxuAh
         ZfQc0HnzeLgBQPY7P1wIUddWNhhMoVnd5Yz7nVwkpF/1TkRdoaBn0IoUzfDDohyd69Ph
         WuIeJbvEQKtCHIbVxlkkBpblMXPyXbk1pr65F00ejQw1HLBxFezzYzS6l8udwtnG5hbV
         VuaWL/hyPdXbcnWA0yWvDwMGlwavWxZrSZ74kH2AyRryYsBHcMEAao1lsiMotH4WxYSs
         l4UpAgPbGNan1Xp+N8/AMrDtEnJToVWCUY0exHucuO9BKcmyrXdDqTQzlEFST7Cp8DwS
         zAgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0sN1sbNkaErQb23q05TEI1vM4GG/gjWq368Ny0MMruA=;
        b=R/ZRpdB9AkiTvmkr6fUb0upt4V1ZPFRm5OrGfeMuAE+xj7Qb22S/dtblPLrNlS0E4G
         6UAhUh+DaqNUBnyH2aB9z3GgE/r2xfg8/APj+EsTNuBOiMjBmjcKYYGf1xtsh7yNGLLh
         coe5lVMU/VG53r7Y6g4hkuh9sHAp+fklwJN48otAznj0i+sXwgxG3GKlgMZPKF6fIx9R
         Bp9jnEtODDvGWdTvdLcbF4GGvmM0FBKY/wFTpPuVuq512eMaCRPaUktHe+OuHb1O1+bl
         v6zjoiypnV7Zv50Sp8/dVLKsGYaqe3344cWUHdsj3xFjK255vqVNg9bXwc7eR3grLyNW
         b10w==
X-Gm-Message-State: AJIora/H9IpoJGMpQsynnDSP78JNljsvg5AX55QQ2Lif2GK9IDY7eZds
        2Q1hvGKsBIZ/5KNP4nbG0FDrLVeR/LwXTxCs0zzXtS0XWug=
X-Google-Smtp-Source: AGRyM1ulcVn9YIHuAsHTeHhWP3aet3lgkb174Qys42u45pzQMAdt7pyYugyYXaLUvEFEnLltl8SdkqlWNxy1hiMdYbY=
X-Received: by 2002:a17:90b:17c1:b0:1f0:1fc9:bcc7 with SMTP id
 me1-20020a17090b17c100b001f01fc9bcc7mr32345663pjb.53.1658039112213; Sat, 16
 Jul 2022 23:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220714142027.3684622-1-alvaro.karsz@solid-run.com>
In-Reply-To: <20220714142027.3684622-1-alvaro.karsz@solid-run.com>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Sun, 17 Jul 2022 09:24:36 +0300
Message-ID: <CAJs=3_DjiMZm+Yf8bwoRAn+=uKpiNToCRMWGuemPWFyPCtuMhw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v3] net: virtio_net: notifications coalescing support
To:     netdev <netdev@vger.kernel.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If VIRTIO_NET_F_NOTF_COAL is negotiated, and we try to change the
coalescing parameters when the link is up,
the control commands will be sent to the device, but the
virtnet_set_coalesce function will return -EBUSY anyway.

I'll fix it in the next version by checking if the link is up before
sending the control commands.

BTW, the VirtIO patch was merged, so the next version won't be tagged as RFC.
