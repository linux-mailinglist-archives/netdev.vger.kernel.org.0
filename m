Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8837C1ECB9E
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 10:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgFCIc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 04:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgFCIc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 04:32:29 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0809BC05BD43
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 01:32:29 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id o9so1630161ljj.6
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 01:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mDAyNRU3XefldnvzxYm82NqzX+xk1cFYCEzdChStbN8=;
        b=w6ED+BFPg4/pGizUTrwUAetmhXLz5P13CvisIsZApaBN5AlebtSbfXCVoID4x0vqrR
         Uq0TanskEQRCn1MgwRjz9yd+tgg5jbLYD8aj7fl3fqbU/TNBag0rNVJ7J/p+X7Yt10zG
         4xio7oeUnUZxxeXOdZS97KqFdfQGuB11OWoHAuCHVks72DKrZLaRTnZxwo6wA9pmqWZf
         9huLKumqal81cJbRbWyajbIE7HWS0ITSCzAvyUJgwnobsDlM54ESpeU9YssqxtWRmMVD
         gkzMhQtzmzqRO0P90HM+B29WsXX2NfBGuxqYUCi8niO2S4M0XYWYsHl75+3jPhaVv5wp
         74Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mDAyNRU3XefldnvzxYm82NqzX+xk1cFYCEzdChStbN8=;
        b=jdQzcw9soN/pit8W7dN0VjabKsDAjOZpweS2vReh8dsO6ySsjMX8tvECVO5h+VGdOW
         ZH7Azks3RAvrSSAsKPFjzEy6CVgg4WJwnFS6dTaoc0tWuHrK/9AenCpYDL8eMAJgmPBa
         kGWpCWH+ClMoGmIk8wl65TWul8MwmdFOJeMxyAHjB+DCPvAPHzCg0SNxrqXdVi85mcmn
         zYqP38a9i/A2nUKx0pUt+EITNeItExx0G9lYLCAxK/Bn0Agl/1MG/z2SabeMg/uDOgsE
         0LyQHyHNQG/zPnQpRjAvoswEkMLW2AHIdKxb08qu/ZD3bzZ1EdyhohOGdkoSuAL5ponS
         tZ5Q==
X-Gm-Message-State: AOAM533hDFU5jxHIYWOBGk2VYdyQiHSjMoD+PdL8sDLjfbyh3cj+LTAH
        PqiN9gzu2ihSIYXNdDH+VIUxR48OYAlP7lkBFWvviA==
X-Google-Smtp-Source: ABdhPJyaKRJGCWzeuiAkm68d+S70Re3ECOxQuGMZWLyhkj3whBBgOx3VFQQCdzraXmNgafed+fOxVtBdttTNRsCHNxE=
X-Received: by 2002:a2e:7303:: with SMTP id o3mr1587782ljc.100.1591173147487;
 Wed, 03 Jun 2020 01:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200602205456.2392024-1-linus.walleij@linaro.org> <20200602.154817.123211415255195579.davem@davemloft.net>
In-Reply-To: <20200602.154817.123211415255195579.davem@davemloft.net>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 3 Jun 2020 10:32:16 +0200
Message-ID: <CACRpkdbYhncyb4DLAE+Qes39b=BK45OS1cn2VmCuTes-WuDuTQ@mail.gmail.com>
Subject: Re: [net-next PATCH 1/5] net: dsa: tag_rtl4_a: Implement Realtek 4
 byte A tag
To:     David Miller <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, DENG Qingfang <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 3, 2020 at 12:48 AM David Miller <davem@davemloft.net> wrote:

> net-next is closed, sorry

No problem I just resend it later (I should have known since
it is merge window).

I'll watch this URL for opening hours:
http://vger.kernel.org/~davem/net-next.html

Yours,
Linus Walleij
