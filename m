Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5DA55E31
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 04:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfFZCRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 22:17:46 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34027 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfFZCRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 22:17:45 -0400
Received: by mail-yb1-f194.google.com with SMTP id x32so456522ybh.1
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 19:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oKNSTMowmRk3RkH/jcMvNDg+7Zu5bOsgngVeZGPE5Q8=;
        b=eY0A99wxkmneSw3ebBgb5whYrrPrAoGKxDfaWS3HcYMmutSOo1BH8nElIh41fZwBcD
         NwbVKrWfUvloOlQBGbMYUmhlFpV0RDV3KTes3kOXeIVwySVLujVm4OtqFcre7KKpfq/R
         D7G7dqEy6MSdABObz7svw3zakl/5/mjk7tvkyvGIWAA/cbwPg+//VTklgB0tRo1JkbFm
         7xkZFduPNqi/xRZSkxAx9H4pVVa24jOalHkwUs3GJGqmBtCST7x2tR0RXkBwf/ylqVuf
         IVXxxVoWHNndpMXYBHfCH/0w8BLAZzQ1S2BJ1yjwfCRh9Hmv9akNOAelzJl8IEVCY7xD
         uePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oKNSTMowmRk3RkH/jcMvNDg+7Zu5bOsgngVeZGPE5Q8=;
        b=hUlifsFy/XFzGprv/WpqoWBL3L/E/b+RnqaLsPe8sn/clrL6CxvICBzxZSNW6weaDW
         wTpioxME3lADuGDK8V0v7GuratOBaC8V7RSrqOVNplNLCRXlMZZsVq/654mMn4Q2SmD2
         sP+ClBN2D2rlMEhL1LpOQDSMR85d0nx1zuusSLFTYg0/iWE1b1cipXampDwCqp8VJfMB
         kgADQsUVRjdljNvJ751qU74VenvEPs1hx7kYgEPvHFJrVsa1sQ8EOuFP9y3H6TJncksr
         D06pIj26n5V3rofUtlQcxbrDWh2dRujxZGO6050YK4WH7AwnZUQUrGP26MJALQtq//pa
         H/Og==
X-Gm-Message-State: APjAAAUJPH8eXl4b58WpoK4LjNXVDwglCFzvwERNNQlY3T9BjsB4jPan
        ZvPPOGQcO0BUlVgFj6YA3tpz9x1W
X-Google-Smtp-Source: APXvYqxgaXoq/80FYgWRqLHDmRzTpcpzenZe7vpOQREeN0TIsYCrFtfecvg4oD5ArgolkIW1RPdtqQ==
X-Received: by 2002:a25:8b03:: with SMTP id i3mr1006879ybl.327.1561515464440;
        Tue, 25 Jun 2019 19:17:44 -0700 (PDT)
Received: from mail-yw1-f46.google.com (mail-yw1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id y194sm4063069ywa.86.2019.06.25.19.17.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 19:17:41 -0700 (PDT)
Received: by mail-yw1-f46.google.com with SMTP id v15so332140ywv.0
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 19:17:41 -0700 (PDT)
X-Received: by 2002:a81:7882:: with SMTP id t124mr1124280ywc.494.1561515461099;
 Tue, 25 Jun 2019 19:17:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org> <20190625175948.24771-4-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190625175948.24771-4-ivan.khoronzhuk@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 25 Jun 2019 22:17:03 -0400
X-Gmail-Original-Message-ID: <CA+FuTScQ2WdEqQpsCdM_KZK9e+Zq7v5B+x=HLthxLAyOhYu-zQ@mail.gmail.com>
Message-ID: <CA+FuTScQ2WdEqQpsCdM_KZK9e+Zq7v5B+x=HLthxLAyOhYu-zQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 3/4] net: ethernet: ti: davinci_cpdma: return
 handler status
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     David Miller <davem@davemloft.net>, grygorii.strashko@ti.com,
        hawk@kernel.org, brouer@redhat.com, saeedm@mellanox.com,
        leon@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        jakub.kicinski@netronome.com,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 2:00 PM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> This change is needed to return flush status of rx handler for
> flushing redirected xdp frames after processing channel packets.
> Do it as separate patch for simplicity.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

> @@ -602,7 +605,8 @@ static int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget)
>                 else
>                         cur_budget = txv->budget;
>
> -               num_tx += cpdma_chan_process(txv->ch, cur_budget);
> +               cpdma_chan_process(txv->ch, &cur_budget);
> +               num_tx += cur_budget;

Less code change to add a new argument int *flush to communicate the
new state and leave the existing argument and return values as is?
