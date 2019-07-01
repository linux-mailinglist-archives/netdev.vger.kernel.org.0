Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71EEA5B2B8
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 03:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfGAB1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 21:27:54 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:46606 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbfGAB1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 21:27:54 -0400
Received: by mail-yb1-f195.google.com with SMTP id p2so8044070ybl.13
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 18:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v4wz4jFOlFe7di2Mk6TbfcyOi87/+hjmbOtVtZ7YxpU=;
        b=vCf/LcJrQYtgT0KSwCi1dnh8A9lMV8xs9U9r2LGZrIX55Dt4c39i7lIO4UWvnxtYal
         hC0BOj0/QexNBf/yjAQmvmZ1yFgsBb15faLukCYXnYWpuCVCvbObAaIkG0e3l6dQK7NT
         2V0ZhgL5o6pRIbsZqXcdIDoNaysJrRfJXKLizYXgjfs/Ribr0xdxgbPUaExNCnEeCZ9d
         D/3wvu4GbrUzNtho97tbO069yrWyskzcWceVJp93CQ271mtJdn0O3siKW4oxnlhxIos/
         /vegSDTkZSnZq0S4Nnv3jExbxftqqzYV0GeVA3HVhWUrLBVJx/eLwhY1OoN1OJ2PHKTE
         T1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v4wz4jFOlFe7di2Mk6TbfcyOi87/+hjmbOtVtZ7YxpU=;
        b=hCROmbAlkG7CP0k4RZ7O8p8grCAUD1Lr55SgAxuan8tDdlH+R97Uci8ufK96g3iVmR
         BG3tRmrOf25RmdYALoA15NMhZ7FBfVvq+vUw/xOmhhmKVe6edlsQSgTph/Ammf6jO4Z9
         P47qnZBUNPcxRlOcG5hzIFkhLSXIxoLhyS+sKz6e7HXN/RyA1Ai2CqN7x+CzXcbH606h
         x1yD4OOoJoIYwGgWvBAw6kGWGiPNMJSRMgXAt9hwhya21GBPIJwZ/4wlZpdxd8tocjgd
         wNSQEp/RmZvwgdhZIDb6gIpomTGrtlbsSGZemxMGvozwHNW4Fpkw0sNYuoAtT8PDPY1Q
         0Tsg==
X-Gm-Message-State: APjAAAXu0DGJpbc71ZjyssXMZt1gq2grQEtBRiEBq39O8x6exfCNYdE5
        N0DNRt8qkUtWEXSq2rXPQ768thzP
X-Google-Smtp-Source: APXvYqyfqjXHKbyPCk++5/3QtFa+Mcq6qt5iJJM2V9fw0UpCC+eIgTIzpktJ2lJ/tCgJUAneOrGaUQ==
X-Received: by 2002:a25:6b06:: with SMTP id g6mr5179808ybc.446.1561944473253;
        Sun, 30 Jun 2019 18:27:53 -0700 (PDT)
Received: from mail-yw1-f42.google.com (mail-yw1-f42.google.com. [209.85.161.42])
        by smtp.gmail.com with ESMTPSA id e12sm2369719ywa.49.2019.06.30.18.27.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 18:27:52 -0700 (PDT)
Received: by mail-yw1-f42.google.com with SMTP id b143so7670371ywb.7
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 18:27:51 -0700 (PDT)
X-Received: by 2002:a81:4807:: with SMTP id v7mr11769454ywa.494.1561944471513;
 Sun, 30 Jun 2019 18:27:51 -0700 (PDT)
MIME-Version: 1.0
References: <88846d6ff622a908655562e0be1a094e3b5a3b2d.camel@domdv.de>
In-Reply-To: <88846d6ff622a908655562e0be1a094e3b5a3b2d.camel@domdv.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 30 Jun 2019 21:27:14 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdL6+q5H8jNKWYB49BCSQi=QeGJWTCUL8qaHWD2gNbHmw@mail.gmail.com>
Message-ID: <CA+FuTSdL6+q5H8jNKWYB49BCSQi=QeGJWTCUL8qaHWD2gNbHmw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] macsec: fix use-after-free of skb during RX
To:     Andreas Steinmetz <ast@domdv.de>
Cc:     Network Development <netdev@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 4:48 PM Andreas Steinmetz <ast@domdv.de> wrote:
>
> Fix use-after-free of skb when rx_handler returns RX_HANDLER_PASS.
>
> Signed-off-by: Andreas Steinmetz <ast@domdv.de>

Acked-by: Willem de Bruijn <willemb@google.com>
