Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEFBB4AB26E
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 22:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242630AbiBFVhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 16:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiBFVhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 16:37:38 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F3BC06173B;
        Sun,  6 Feb 2022 13:37:36 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id l123-20020a1c2581000000b0037b9d960079so4431812wml.0;
        Sun, 06 Feb 2022 13:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e/nI4S+KG3sKPJ67oamywZ9+MX889TO5LPjwkorRRhc=;
        b=mv5VLvp/xIz3K2Mk030U/rva1PHMUEBi+wQJ2FTcldU34bwFv4PqkKv3FGKVgWwVl6
         isKEqZ9kQdOCB7BVWegmSJGvFUd4vf+TohbVJdn7BTh0f0pb5l2oyouPTODr2N8o+wuD
         2gOuXhT8W7bf0qWdMuMbj5KcyR+pVUj2ONQrMgucYngZtp3bSzP9otJ9lIMtxHrVeWLG
         lhN4Ot937R5Q4DKhx7FhDY6a6eLgw1bxq/K+xErL2GxPhas+i5Ow0AuDcHFo7NbBXRkv
         tARAqo2uK0XflZ6LYViYaGDFGmofQwRU6pNDGT7h9G2+Qwdwgd5CK2cCS19Su7R5g69x
         3keg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e/nI4S+KG3sKPJ67oamywZ9+MX889TO5LPjwkorRRhc=;
        b=KMFQDo2grcHk0hppV8GouGmYssWL/CViglr5dYXbCZWiXn+DEV5wQlStKtUwVLjQ1e
         8EklF0Dt68TiRTaABecwv7MTzaz0pZ5mqytbaq6x4cU+BkNHkF/1FjA4koj6KvN3mqKx
         fE80V+fSMQngjTG3Q9K+J7DbS6ZB5HeP7kbXqUD32yO5PXkXhUIFfK78t23SkOk3CCw6
         C5eYfN3ZMIKxag5wIXaQkXXd4dkj/HycoZwHZbOMswp4ZovqJiIHto6X6Y6zrAFZh6Tw
         /azRID4X037zrGLmss7V8tbUqaUAGz/Er8911fdjqTAXtH1zyqK4JiYiRhZlGuzgVxmo
         wZCw==
X-Gm-Message-State: AOAM533YUIE798vasSxvMCDo1XEx1D3/+SBvWyZ94Xy+REWUgsWXWx9h
        mnsVqSO6ZxseJunIz4G1gVssFAHIh4uC1XhbldM=
X-Google-Smtp-Source: ABdhPJyYY6g9ybK861ygyONpra3GDe5zCFBIYBa9CEcyhR3Wv8cUdoHMuxCX8CGHmklQnLbCRFpcVUJ2g83o9H/3gp8=
X-Received: by 2002:a7b:ce90:: with SMTP id q16mr6167526wmj.91.1644183455001;
 Sun, 06 Feb 2022 13:37:35 -0800 (PST)
MIME-Version: 1.0
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
 <20220128110825.1120678-2-miquel.raynal@bootlin.com> <CAB_54W60OiGmjLQ2dAvnraq6fkZ6GGTLMVzjVbVAobcvNsaWtQ@mail.gmail.com>
 <20220131152345.3fefa3aa@xps13> <CAB_54W7SZmgU=2_HEm=_agE0RWfsXxEs_4MHmnAPPFb+iVvxsQ@mail.gmail.com>
 <20220201155507.549cd2e3@xps13>
In-Reply-To: <20220201155507.549cd2e3@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 6 Feb 2022 16:37:23 -0500
Message-ID: <CAB_54W5mnovPX0cyq5dwVoQKa6VZx3QPCfVoPAF+LQ5DkdQ3Mw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 1/5] net: ieee802154: Improve the way
 supported channels are declared
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Feb 1, 2022 at 9:55 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
...
>
> Given the new information that I am currently processing, I believe the
> array is not needed anymore, we can live with a minimal number of
> additional helpers, like the one getting the PRF value for the UWB
> PHYs. It's the only one I have in mind so far.

I am not really sure if I understood now. So far those channel/page
combinations are the same because we have no special "type" value in
wpan_phy, what we currently support is the "normal" (I think they name
it legacy devices) phy type (no UWB, sun phy, whatever) and as Channel
Assignments says that it does not apply for those PHY's I think it
there are channel/page combinations which are different according to
the PHY "type". However we don't support them and I think there might
be an upcoming type field in wpan_phy which might be set only once at
registration time.

- Alex
