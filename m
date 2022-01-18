Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1314F491EB9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 05:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiARE6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 23:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiARE6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 23:58:51 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D003C061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 20:58:51 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id w12-20020a17090a528c00b001b276aa3aabso1235025pjh.0
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 20:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/v3qEXPklfS/QqpPeVJWwAZVwQgNj+u+BpV3m65eLfU=;
        b=dwTjfz39hodOz8U4Un67tz2P3W1J44R8KbQ7xJSMiCnc9vohvdgdQho7JXwhU8X2jy
         U6qF+w5HInLRfPwOhd1ascg1mwfUSfeNgNXNV6VhzgAkEEDsiVniF1Jd6WXU3lxkKCPy
         xzRo7cOoAJAwhsME5p80hWsoHtWVWFSqJt0D/J7dBq2ArqcUkoQr2pDZ3BdDsHYkhMMo
         S246YMPB/bHsVO1iESM+naolAopoug52l7wBVS9mYRGMITTDQzPJ9KtcS0qSNrK6OWHS
         neR3e49bMmEjClB6vmZUzEB7QAtEhe6Mee0MVmRr1vuC5zgfNhva1ff4Q/rGJDv1rnQw
         Gqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/v3qEXPklfS/QqpPeVJWwAZVwQgNj+u+BpV3m65eLfU=;
        b=JbVfLaYwrmtNkCt+WqTQQWNJDhXYkf0mOcXaF7u9cSXA7QAMUa88iXUzwplufaSIrx
         yzEAbCBVPEsjxAkNDYjRPIorKP7LfhasR5AYhSAha2qMa1BwR7W1XR9adAsHpzqIRF6N
         C/3WEGt8aWn092lDtqmsuRaMcXhB+VsIWyixRI+zUP8qzTuums98MHfQQ0vv8VOJkEPv
         QAEx+C4HFM/kIQhm+D2koehGnQxxfjEiMjJkgCACIciyyFE6vwpICzTb2xJXdXPCZQzV
         nItoe12PsGGfKgRtR9xHMI4zvp1VSIrJxSvFjQtBgtoFXrxpJ7bAVuAAjBKoSo0HUv1m
         wK0w==
X-Gm-Message-State: AOAM532kpxDJ1SZIBWQLLrPA1eU0ql9tk064OPD265ZVBki8ptXVWY7+
        H/eMdv+StivuCfk7xHhU79XU7hUvZaDGiYRcr1Q=
X-Google-Smtp-Source: ABdhPJyxvrwuG7nyIF2MVWi9iqIXiqGXSu0ZASupEzHO85OQN5zy+hTkQXFkxZnWEEMeK2fpWsiC7aOaSozMZiq9/mA=
X-Received: by 2002:a17:902:8544:b0:14a:bea3:1899 with SMTP id
 d4-20020a170902854400b0014abea31899mr7562035plo.143.1642481930272; Mon, 17
 Jan 2022 20:58:50 -0800 (PST)
MIME-Version: 1.0
References: <20220105031515.29276-1-luizluca@gmail.com> <20220105031515.29276-12-luizluca@gmail.com>
 <87ee5fd80m.fsf@bang-olufsen.dk> <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk> <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk> <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
In-Reply-To: <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 18 Jan 2022 01:58:39 -0300
Message-ID: <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
Subject: Re: Re: Re: Re: [PATCH net-next v4 11/11] net: dsa: realtek:
 rtl8365mb: multiple cpu ports, non cpu extint
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> the problem is checksum offloading on the gmac (soc-side)

I suggested it might be checksum problem because I'm also affected. In
my case, I have an mt7620a SoC connected to the rtl8367s switch. The
OS offloads checksum to HW but the mt7620a cannot calculate the
checksum with the (EtherType) Realtek CPU Tag in place. I'll try to
move the CPU tag to test if the mt7620a will then digest the frame
correctly.

Regards,
