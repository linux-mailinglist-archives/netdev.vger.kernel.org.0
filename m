Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6F655109
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 16:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbfFYOEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 10:04:39 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:37781 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728147AbfFYOEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 10:04:37 -0400
Received: by mail-yb1-f196.google.com with SMTP id 189so7498860ybh.4
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 07:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6pIIC3jytWsmntojJM5beMPwkkISJ/lE+BJnG08AcnU=;
        b=mRU4gBCrfg1gioLKe8ve3oGpbXdbfnB/ITSmqUQ9RcKXPtDFqmjktz9gM9ltsUh+wg
         yUOjr6uBYr3ljB+H8Qpntj89LzaLJ8o3QlvN9SRou/ztu9mINIl4ZYYaTN4BJuuYlANb
         Ut0kJmWvQM9BgB5orcacPdtvxfMMYeSgbJvugc/6SVKkKeNPc9WXLZlNEwSzV7Jyz7dw
         D2YbmYBouyrHwbDsgfzL+et32rsvUyNbdFc2SUx5jusN9rhLxCH4jZgtjKHlro+olg7q
         B0MwiYxTbk+3sGmNj0ndHj6Tn9PKidy1jzuvBQtDn3VADbLLRGWJqFTBKEe1779CkJhT
         49Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6pIIC3jytWsmntojJM5beMPwkkISJ/lE+BJnG08AcnU=;
        b=B3UUFylUJOhBRYnrYzcKKUIxJ0pt5J7C7m0wT2z1cvnm5YixZ1uRnfHVRPOrrZMK1i
         Pw2bV8a+MEe2v2l06uG6texi1i9tu2LsvVA8Tr5EHDsufwtsP5kSqUlGfKRHAtP92Xib
         mhEsaYRdYp9OAVG3XS+AOtwP7bGZrTDZri31k2ZWcqOsPgkDN0CGXccMoHBHHLTjwbDl
         uoR3nXDQ40sifIQOBFMkuUAAVG7dOdJn+/iu5AC8NuQzqjz9T2twcAuL/lW3mEiyoXUU
         20FM0kp/cfCuC4kb3Xl6Ul+0KLI4qNaYCpV4BhKHn2aFyXLl3WBmz5W+jRhkqHC+fvAy
         PP0Q==
X-Gm-Message-State: APjAAAXZcIAk6UZsk66112joGkOqg+abFm2iAPgaaSyUqNr//DcoohQC
        Pp3jhRKVj4ettdVguwub3H+QM+se
X-Google-Smtp-Source: APXvYqxvcEl/S+9nkGOkXBoeUCuLpK1mIlr85FUyNH1Lv7LSi8n9+OttgdMamnafdu/xjfez5LxR6A==
X-Received: by 2002:a25:8489:: with SMTP id v9mr7225920ybk.144.1561471475656;
        Tue, 25 Jun 2019 07:04:35 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id g64sm1815646ywg.11.2019.06.25.07.04.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 07:04:34 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id p8so7469301ybo.13
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 07:04:33 -0700 (PDT)
X-Received: by 2002:a25:99c4:: with SMTP id q4mr11512887ybo.390.1561471473136;
 Tue, 25 Jun 2019 07:04:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190625125048.28849-1-houweitaoo@gmail.com>
In-Reply-To: <20190625125048.28849-1-houweitaoo@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 25 Jun 2019 10:03:56 -0400
X-Gmail-Original-Message-ID: <CA+FuTSegsUvPSWX+CZuafSD32Sx+xJmYPiQ92geDNqAe8_JGrQ@mail.gmail.com>
Message-ID: <CA+FuTSegsUvPSWX+CZuafSD32Sx+xJmYPiQ92geDNqAe8_JGrQ@mail.gmail.com>
Subject: Re: [PATCH] can: mcp251x: add error check when wq alloc failed
To:     Weitao Hou <houweitaoo@gmail.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        allison@lohutok.net, tglx@linutronix.de, sean@geanix.com,
        linux-can@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 8:51 AM Weitao Hou <houweitaoo@gmail.com> wrote:
>
> add error check when workqueue alloc failed, and remove
> redundant code to make it clear
>
> Signed-off-by: Weitao Hou <houweitaoo@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>
