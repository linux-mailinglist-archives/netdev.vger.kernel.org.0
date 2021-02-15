Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245B531B57F
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 08:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhBOHBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 02:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhBOHBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 02:01:02 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BDEC061574;
        Sun, 14 Feb 2021 23:00:22 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id cv23so3166739pjb.5;
        Sun, 14 Feb 2021 23:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MLQN9t84WZNNwMBeSpSegbk2anC6/0CnhIjVKrMRW54=;
        b=CFeCL4lmp6j1rJ631/DYI4jxYOOXS3k735zBKpRs1937uFBu/I7d43iRwHcudtVEb3
         0/WyDNTf2PLMFrmkk8oGVZsIncvDU44urhIwRYD7kmHOtKYM+pZhZPEXJdf63agc1e6Q
         /hGuHrwA/hJGh/EWJ7+1QVgvOhlCveKsC8B6iu9OQdmXTibRqo+ENR7XtsPt83VbsPgE
         gNX3ekZ9tO2GdVFScVuxR/vXUN9iW3UhAsKztULuAxP5MqzifX+r4ZGi3VBTf6qZVeGC
         4OyvAJQkJCSu5BdZb1w+hZ6FCtrh/c7jbiSmZbtvFE/qNHUOvN2dSKdm4NRASz6GnFwX
         zcbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MLQN9t84WZNNwMBeSpSegbk2anC6/0CnhIjVKrMRW54=;
        b=FcAe275LKooqXrbd5N5mZsARp4aQZ3+Mzf4x0P/8b8FOAqhkP2rWOd+FV8dailKsxN
         U9jpSPfA+aLqUBdKio5+D6qq4yEECVKgm/HNZstBhm97w9qhddZzvQlQoEHx0pI+zdbn
         ojOyWKq4rF3Z3girPJ9rIdYLtGqfcaSPXASwNCcqr7C4123Q0hrM9j5L/OeIjyS0/8xL
         9ZNZmKjjaAGF8fMXv5z8OwmtfNtb4bonC8aYKYiuCDdDdO3pJzJAl6YCMeuQWoOVq9ks
         UnLGKBHqDkgeAOCZdmqoJRx2tpMsZg1xqEHDQ88z/ZPTU8lxbHWVBQX87HbCJpPqVbhN
         GHOw==
X-Gm-Message-State: AOAM533InF4vsST7HrbQqOVuWRnV56ikIoIkfmrjEMTfuTt7J0gcoIiP
        NkVKHWHvAH16Ql0N9/zTvig+PizAySk7sHBlrKRBkCowY6I=
X-Google-Smtp-Source: ABdhPJyWzW2R32V2f7jZZO1++ndm77nKnJgmX7CGD6JZFxrZUgU+WpY9Ej730UNU+W0MrHewW2Gs2cA8sR4gDiHOJbA=
X-Received: by 2002:a17:902:9a46:b029:e2:f97b:47da with SMTP id
 x6-20020a1709029a46b02900e2f97b47damr13898523plv.77.1613372421849; Sun, 14
 Feb 2021 23:00:21 -0800 (PST)
MIME-Version: 1.0
References: <20210210173532.370914-1-xie.he.0141@gmail.com> <f701aad45e35579c8b79836ffeb86ea9@dev.tdt.de>
In-Reply-To: <f701aad45e35579c8b79836ffeb86ea9@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 14 Feb 2021 23:00:10 -0800
Message-ID: <CAJht_EOrNaavomac8OVv8i0YxMgsX7oWAFDDRUzWTjpNhWpCcg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v2] net: hdlc_x25: Queue outgoing LAPB frames
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 10:27 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> At first glance, the patch looks quite reasonable. The only thing I
> noticed right away is that you also included the changes of your patch
> "Return meaningful error code in x25_open".

Thanks! It was because this patch was sent before that fix got merged
into "net-next". I will drop that part now.

I will also make the MTU of the virtual X.25 device be HDLC_MAX_MTU
(instead of HDLC_MAX_MTU - 2), because I see other HDLC Protocol
Drivers seem to also use this value as MTU (without subtracting the
header length).

> I hope to get back to the office this week and test it.

Thanks!
