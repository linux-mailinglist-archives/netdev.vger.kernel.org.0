Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB08E1282B2
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 20:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfLTT13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 14:27:29 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46256 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfLTT12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 14:27:28 -0500
Received: by mail-qt1-f193.google.com with SMTP id g1so2236916qtr.13
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 11:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=8z951pRnsDm85ctySHy2ADwTPUYLjQqAOdBqIVMeCYA=;
        b=S6OHYf8gjbspdqjQ6eC14n66hC7QfIvVZjmRsOj/GW171lpfssbYtpS7TGDZAtyYkT
         nBqRQEe+aZKgZAdN4w5aBemDYh8h+1G3KFTExPd7MtTsvlB4BZMEVSgU/KZDJZ4OUk8b
         LvFYj8/+pNCDsO4xZzu1rx7cqipQkKJY3/DoonmFjhD3OqbRVkNHllc6CRejylkOcDyK
         6W8JUVb9XXywuz5ic+RkwZ7Zg6UVObZuWpAhd7VLK+1zY92WwDRPe50KR1Ffi7BHy/DF
         Dkkq4VqBFx0rbSHvvZu+dCGeJ0Nntccz/Xjh+0UCrSlRc9fuUQhFAyqn3fH4TTNZ1QRn
         YkQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=8z951pRnsDm85ctySHy2ADwTPUYLjQqAOdBqIVMeCYA=;
        b=q0fUnLOaWjtFLPnNhSv2porqVZ6LIWSJxpVHLrCJrkcCHE4MNCa7EyGWA+O1HEOb+K
         1mx6X3IUJWdlrR15lEQSTWF/S+TQflMKsChpfenbQz8K/MPStvx1wp6yoONbML+uFhgH
         Bd7SR7Nmg/GuLiWt4TonAoCQacS0bwAwWHIg1v1f/puwpLTvd0MRbVEG40oX94uvX1Dn
         H6Rf+VDP8qXXxq1VSzItiMjTEbTRxQgzXjZUQ+ikApw8EfEZPg1Z+3R/haTEsHE4sX5A
         NXjeLZlwwcAI5r1RHHQq913PElwHSr8n60TxQUM7ITE57CbkX9oefnE364BTd+t4ullB
         9IlA==
X-Gm-Message-State: APjAAAWYdoO6IlT71gE5xLb8g0sU/s+MvB5zRgoCu0goE5A06lCs334w
        NyznBPGwdUCG25Yx7y2WVQgHQoKf
X-Google-Smtp-Source: APXvYqx2SsVYP5UWkLrJcXjnkZaOyE/Cc/tHyuLDNkp3K9LnYeQSbdsWhGvGDtcP190pxVfpgc6l0g==
X-Received: by 2002:ac8:7648:: with SMTP id i8mr12953597qtr.389.1576870047931;
        Fri, 20 Dec 2019 11:27:27 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id l19sm3308902qtq.48.2019.12.20.11.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 11:27:26 -0800 (PST)
Date:   Fri, 20 Dec 2019 14:27:25 -0500
Message-ID: <20191220142725.GB2458874@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Denis Odintsov <d.odintsov@traviangames.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: force cmode write on 6141/6341
In-Reply-To: <dd029665fdacef34a17f4fb8c5db4584211eacf6.1576748902.git.baruch@tkos.co.il>
References: <dd029665fdacef34a17f4fb8c5db4584211eacf6.1576748902.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Baruch,

On Thu, 19 Dec 2019 11:48:22 +0200, Baruch Siach <baruch@tkos.co.il> wrote:
> mv88e6xxx_port_set_cmode() relies on cmode stored in struct
> mv88e6xxx_port to skip cmode update when the requested value matches the
> cached value. It turns out that mv88e6xxx_port_hidden_write() might
> change the port cmode setting as a side effect, so we can't rely on the
> cached value to determine that cmode update in not necessary.
> 
> Force cmode update in mv88e6341_port_set_cmode(), to make
> serdes configuration work again. Other mv88e6xxx_port_set_cmode()
> callers keep the current behaviour.
> 
> This fixes serdes configuration of the 6141 switch on SolidRun Clearfog
> GT-8K.
> 
> Fixes: 7a3007d22e8 ("net: dsa: mv88e6xxx: fully support SERDES on Topaz family")
> Reported-by: Denis Odintsov <d.odintsov@traviangames.com>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Andrew,

We tend to avoid caching values in the mv88e6xxx driver the more we can and
query the hardware instead to avoid errors like this. We can consider calling a
new mv88e6xxx_port_get_cmode() helper when needed (e.g. in higher level callers
like mv88e6xxx_serdes_power() and mv88e6xxx_serdes_irq_thread_fn()) and pass
the value down to the routines previously accessing chip->ports[port].cmode,
as a new argument. I can prepare a patch doing this. What do you think?


Thanks,

	Vivien
