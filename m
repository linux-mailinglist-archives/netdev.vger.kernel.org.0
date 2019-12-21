Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89C39128BC2
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 22:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfLUVv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 16:51:56 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46295 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbfLUVv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 16:51:56 -0500
Received: by mail-qt1-f193.google.com with SMTP id g1so4895240qtr.13
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 13:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=YX5Te8VZ0rK69wutrvVg0XuLUUHSeFp8pvqS8Kcxmrc=;
        b=Ky/mIlJHut9LUfWgfkzmF594617GaWUt8iIoykl0FhiBVy5hiCMssitup38ReeTfLC
         NFmecbI1B3ekPCVtDnYG1JRaLMNzfbgAOfXp71OrKAH9Q6sOOSGe5YvmyiMBn2LgDnJ0
         /5H9Y3IYGbhFYPmLg6iizql9kDUy7SXrBOy/26spwAeDx+zdGknlc5BnumuNey36W9rF
         c9Xp9PMGGoLBYjW8zoPhpYgh3QfO8LXJvSnZrMC0zPyZKXbwaa70Cg3H1ZEFCyM9MZ5q
         evDlR43WxNYEnSK/NWigE6Bn+QhadEgaOq6DKhN4BJTOcDgMDLK/eROoY3Dk3vNqWj1O
         SNXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=YX5Te8VZ0rK69wutrvVg0XuLUUHSeFp8pvqS8Kcxmrc=;
        b=OEA6WmeBfJlVJNQM183Icco0KyWIPthiBwj3QSHrtgoC8nt9x6I9Xw/ygeB3KvaaPU
         7fBYpsUJI58ye7EuOnqCrSje9zaVdL00YJWj/yoYdEj0Zx1oKOFLYRTweleG+RmMFH6l
         hCg6P9lRQPYmOf3jnAwqZwakU1XUa/jyj75K3A/3DTTxNN+5CjtvBmJ/QB/wzT/77tRm
         9GJKfe1czp00JDbQPBr4lCeSJ+OpoYbhpaP3uRupwUBxXQPKkCYlzNWtJ1M2agufxir7
         RZCO36jtIUQPQwdFn4wYxPfthZBpHMU4kIwwMYYp27W+i4ZT4NrR9PsAP9Vn2hgnV+Qv
         7L6g==
X-Gm-Message-State: APjAAAX7pKuPfwx2tzoEA9igXs4SEGjRoqFwYz6FhrHJ7CIZZL5O1fi5
        WM2rGT+kEMOpOQ6HsgLyvmI=
X-Google-Smtp-Source: APXvYqw8LOvYbnEBl7sEtdqvrLg/onCtizaPEl5CX12tR4U0Bhv5on9MRNxwxero8RH7UzRGl8RSAA==
X-Received: by 2002:ac8:6f0b:: with SMTP id g11mr17357513qtv.308.1576965115270;
        Sat, 21 Dec 2019 13:51:55 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id n1sm4157116qkk.122.2019.12.21.13.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 13:51:54 -0800 (PST)
Date:   Sat, 21 Dec 2019 16:51:53 -0500
Message-ID: <20191221165153.GC2574713@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Denis Odintsov <d.odintsov@traviangames.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: force cmode write on 6141/6341
In-Reply-To: <20191220142725.GB2458874@t480s.localdomain>
References: <dd029665fdacef34a17f4fb8c5db4584211eacf6.1576748902.git.baruch@tkos.co.il>
 <20191220142725.GB2458874@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, 20 Dec 2019 14:27:25 -0500, Vivien Didelot <vivien.didelot@gmail.com> wrote:
> > mv88e6xxx_port_set_cmode() relies on cmode stored in struct
> > mv88e6xxx_port to skip cmode update when the requested value matches the
> > cached value. It turns out that mv88e6xxx_port_hidden_write() might
> > change the port cmode setting as a side effect, so we can't rely on the
> > cached value to determine that cmode update in not necessary.
> > 
> > Force cmode update in mv88e6341_port_set_cmode(), to make
> > serdes configuration work again. Other mv88e6xxx_port_set_cmode()
> > callers keep the current behaviour.
> > 
> > This fixes serdes configuration of the 6141 switch on SolidRun Clearfog
> > GT-8K.
> > 
> > Fixes: 7a3007d22e8 ("net: dsa: mv88e6xxx: fully support SERDES on Topaz family")
> > Reported-by: Denis Odintsov <d.odintsov@traviangames.com>
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> 
> We tend to avoid caching values in the mv88e6xxx driver the more we can and
> query the hardware instead to avoid errors like this. We can consider calling a
> new mv88e6xxx_port_get_cmode() helper when needed (e.g. in higher level callers
> like mv88e6xxx_serdes_power() and mv88e6xxx_serdes_irq_thread_fn()) and pass
> the value down to the routines previously accessing chip->ports[port].cmode,
> as a new argument. I can prepare a patch doing this. What do you think?

I did not mention it, but mv88e6390x_serdes_get_lane() would access
mv88e6xxx_port_get_cmode(chip, 9) and mv88e6xxx_port_get_cmode(chip, 10)
internally since its implementation is specific.


Thanks,

	Vivien
