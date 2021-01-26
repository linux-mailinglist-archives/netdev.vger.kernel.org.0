Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B68305CFA
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238314AbhA0NVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S313585AbhAZWhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 17:37:48 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6858FC061573;
        Tue, 26 Jan 2021 14:37:04 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id bl23so4721467ejb.5;
        Tue, 26 Jan 2021 14:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gc5BORIY4C9Cc86U8RfKKX9CjY/UO39sY81TTcS+iUA=;
        b=eYJs10z/aijpCbz/WlTru9a6hYwDQFGuW7L6ZXADc7bHEkfrx4n2oE+I8ZKIn0Ag+X
         gu8TknMmwkCSxkiSIUOyYAW/ffbh4+JpKRsRMr1DWk94SsKabPwCsF2rAOCNcga/EC20
         Hu/OxGI7IOwpUNWV8uBl+jgVaAzWg6eBblT+6cP6y0gTewaeD9Hm/PRVwLtRnjXEhLuT
         k9+KNVGL+OW/kZPGNGlZimDjQVUVZo/Mhw/oNhCgmI2bP4CtItv7QELRmdkrvdOLme1S
         HYU48Wix1tGVaSdFe88XzCA76pH2zERFalSuABTpL9u/zxk/MIA7UcqAsnU9Vuoadcx/
         EBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gc5BORIY4C9Cc86U8RfKKX9CjY/UO39sY81TTcS+iUA=;
        b=hwKHmFaFVkd6L6tcBU6ZXzT13rrBPIvEgzxcRHM3PJaGAWxB9Y+VJxMV0t8NKQZ+Pi
         VGyrn6nXA2bE3UD06kwFPiBfKcQGdDFkC+4SlTtQVn94Uu6qggwjXeedBcHhlupzjyht
         751cA/COZD/N5X98+j7uFcvVe47PD2Ru4kdnClz4c3ioAJGMqs5Y/XpqyatEwutuTLet
         3MmR8qPfpZOQMiOH8lTs1p75HMdeIJwo+igutwyY73y8qYid0KbYZ9+O9q/NivTU0Oyi
         +g+ilWpmxpOmrWxJK3rcqoDS0PZgAqJbSw8fICcEFa0wsK6fE08P5b+sOGoG1Ff/6yvs
         szmQ==
X-Gm-Message-State: AOAM5328LpIDqmgzgaytsIAwvbRRh2ykCI6MP698DKy6YnCICN9TjDIG
        AKVBfIVI7L4Hysr0VXtPp8jX/GmUS+w=
X-Google-Smtp-Source: ABdhPJwdtK5AWD1D/N75tscLpf28V8EvXdBF35LMq/rVPUqor72GqJFtejFg7cwiDq9o+uv0jkqdOg==
X-Received: by 2002:a17:906:7253:: with SMTP id n19mr4787776ejk.543.1611700623207;
        Tue, 26 Jan 2021 14:37:03 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id d9sm14575ejy.123.2021.01.26.14.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 14:37:02 -0800 (PST)
Date:   Wed, 27 Jan 2021 00:37:00 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lorenzo Carletti <lorenzo.carletti98@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: dsa: rtl8366rb: standardize init jam tables
Message-ID: <20210126223700.d3wdlf264ox7ea2w@skbuf>
References: <20210125045631.2345-1-lorenzo.carletti98@gmail.com>
 <20210125045631.2345-2-lorenzo.carletti98@gmail.com>
 <20210126210837.7mfzkjqsc3aui3fn@skbuf>
 <20210126213852.zjpejk7ryw7kq4dv@skbuf>
 <CABRCJOSzm6s3hv17KFXMZigJjuBEidLLAM8+dqrGk9xTE=FkcQ@mail.gmail.com>
 <20210126222805.fd7pzt7zenl72mmo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126222805.fd7pzt7zenl72mmo@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 12:28:05AM +0200, Vladimir Oltean wrote:
> > So, allow me to explain. The kernel jams every "i + 1" value in the array
> > tables into the registers at " i", and then increments "i" by 2.
> > These can be seen as [n][2] matrixes, just like the ethernet one.
> > Having the arrays converted to matrixes can help visualize which
> > value is jammed where, or at least that's how I feel like it is.
> > I know it's not a big change...
> 
> Got it, thanks. It is better, in fact, once you get over that whole
> 0xBE00 thing...

If you really want beautiful code, I guess you could create a structure
with two fields:

struct rtl8366rb_jam_table_entry {
	u16 addr;
	u16 val;
};

and then convert those ugly looking matrix definitions:
u16 (*jam_table)[2]
with:
struct rtl8366rb_jam_table_entry *jam_table

and this:
		ret = regmap_write(smi->map,
				   jam_table[i][0],
				   jam_table[i][1]);
with this:
		ret = regmap_write(smi->map,
				   jam_table[i].addr,
				   jam_table[i].val);

The memory footprint would be exactly the same, and the struct
initializers would look exactly the same as your current array
declarations.
