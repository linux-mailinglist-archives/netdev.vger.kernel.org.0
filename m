Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC88B7FB49
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 15:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406513AbfHBNkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 09:40:32 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:45496 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405099AbfHBNkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 09:40:31 -0400
Received: by mail-yw1-f65.google.com with SMTP id m16so27260435ywh.12
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 06:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JnFIxOkpNcZYRay8DKQqQvnlT+t5tL3INkAqh/eYj7U=;
        b=LwXMEarFcR4Bs/zcWuQ8IJ1fnw5GW8qi7QewqVHSgPtxEMZwFnr70Ww/mfO4fsGMsU
         vst2cS60sOBdSWQ+ahzOfd/EX0Huk7RSVXUTyR8jJOCema3fcTbIDC91OAE6uQ60jKCN
         saJRbOOu7t1+twXuZQZ8kdVtoPj5THrS0dZJxlToQ8jPfXwRW5zvJ4gZ1AAfLuvZjwCL
         5Qe6KtgL2vlpQArknto3oiIGXhIDYndqcmwZyWnEs0tAcA3ggoyZDmj/qd41TDwHBY23
         fI0R+qIRrWZjaTFDaECoRlkYW3rHOyH68XzDzTagRens4oc9AUXKOAaMZt09TJ2yfIx0
         ofWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JnFIxOkpNcZYRay8DKQqQvnlT+t5tL3INkAqh/eYj7U=;
        b=NyeddtPZgxHM8Lag8MaVIzc/puLRCDK9cTOTQhduFZC21SQwQite5HqyG/At58/tnj
         fy4Tf6+Lwq5ytXYxDx4IEX1A6dtRITKu0GirZlFiEYfWevmjhmg6KB7YRGDYxjktuAzX
         CiAXVT3dpcNAHS0iCwHLFGR9LUmZWs0gh+SHnQMDJ2m4my0DUGpsPRZVlHtKcn4M+lq3
         Po85wJQqWZJJdLm1f/oYKk/yNeNKAd2XjogsDXU3w3Gxmh3zMjoCvuteIplJsMLBh5Ax
         NnwhVaD3Zk8M/VLpuUjRUrLWhTd++I9eFTbvCwsgUJ1ltP09IuNyEK9aRsm/Bx6vhRbt
         ICww==
X-Gm-Message-State: APjAAAVQS/t3h+wtnCO1z0nAgC6A18JKf2pgvVqJqWgXGTAaWOXugV5o
        wKquKV4y7Ug43AXsSc/AbFIFojAX
X-Google-Smtp-Source: APXvYqzWBQ3tuYusAJrXdOlNZAeN+nlcBOj8nM2Ltcludw5RfeTAEKEkL/js9TDJ4ZagxkOaOZzyHw==
X-Received: by 2002:a81:2f0c:: with SMTP id v12mr79802192ywv.383.1564753230272;
        Fri, 02 Aug 2019 06:40:30 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id v203sm16827921ywa.99.2019.08.02.06.40.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 06:40:28 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id j6so4701007ybm.7
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 06:40:28 -0700 (PDT)
X-Received: by 2002:a25:5e44:: with SMTP id s65mr77950006ybb.235.1564753227994;
 Fri, 02 Aug 2019 06:40:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190802083541.12602-1-hslester96@gmail.com>
In-Reply-To: <20190802083541.12602-1-hslester96@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 2 Aug 2019 09:39:51 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc8WBx2PCUhn-sLtYHQR-OROXm2pUN9SDj7P-Bd8432UQ@mail.gmail.com>
Message-ID: <CA+FuTSc8WBx2PCUhn-sLtYHQR-OROXm2pUN9SDj7P-Bd8432UQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] cxgb4: sched: Use refcount_t for refcount
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 2, 2019 at 4:36 AM Chuhong Yuan <hslester96@gmail.com> wrote:
>
> refcount_t is better for reference counters since its
> implementation can prevent overflows.
> So convert atomic_t ref counters to refcount_t.
>
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
> Changes in v2:
>   - Convert refcount from 0-base to 1-base.

This changes the initial value from 0 to 1, but does not change the
release condition. So this introduces an accounting bug?
