Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0AF2257A6
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 20:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfEUSif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 14:38:35 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38802 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbfEUSie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 14:38:34 -0400
Received: by mail-qt1-f195.google.com with SMTP id l3so10948428qtj.5
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 11:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h8+aGeYT5qXDSdkx6yR9bpYe/TTOAuzsAfwvtvzf5Is=;
        b=Eh/0/qLlE+PGEv0szp/tME8Mf492pAcyTPjOVx74OXnRf+jIxZatVgsDae4oYvjtZl
         chwtNLzvs9AxfrmUu4yhjTOPtkscRUuZLj22BLVREdhGSQB8nOGDWtvSCooK4/Cer76G
         8PcTM4k7z6NtwPzs9T+GmXkUaScvZTMQ2yheSiQ8nVxEnFRmmYZUldUvi2k9LMq+Mjye
         REKMlkuBqlOMWao8ae9PoGnQLnH9jvCUe2S12yiNkgo0Nen4GZ8ZlWj+T4qU2PF9HO4j
         IqTYxFWEM8Yd+lQN50zrDaEqGPzNsWRlTdWijeEC+3JtDacBp8V2h3dsTCSDH2zYdUuw
         W2VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h8+aGeYT5qXDSdkx6yR9bpYe/TTOAuzsAfwvtvzf5Is=;
        b=OmEKB7XrQolI6oCPfsjUqBbJhZNq5SetVzv1FFnmJEQGq+XS96nhfpY+venhdFbNCc
         yuXHzu87yzt6WVyNCFUisJ1ewH4C8XFou221/xsyPzfaHeNOYSKqErUdWE04z8nOYUax
         6SW9H23gArWntWBpw/FFubYeMLhq8RMkB6izO07JfKAd3DzBv/qCZrAFG9Be2qfW13oR
         rO0GzkrSTW/PeU74RBCDouAJKsCgTcsz8XivnPB9JXd4WzzJ5ex7W4ADawKBJW/qJue6
         glQlSvMr7vn6Dxkh8gdJEWv7m+at7ekYH6iuX3DIc6+76wJF07c0zM9Wh0hJmmKxbdPv
         jvPA==
X-Gm-Message-State: APjAAAUSvGUhCT8NJ/VrsczvatxbtHuEV3HnL4xRyJ/qbRp/ui4TnjkT
        iIU3vSyGYx+g5tsN8RzNqOkUP3CYLLPaa1E+QuKalwHm1vw=
X-Google-Smtp-Source: APXvYqxjLR1+JQUK3DsrE04xtBbnElUmnO1bZ+gsciVGSjeY1MzK8qqbHWhPwzBsh15GBYPHvv+1xO7G5Aes2mpTzK4=
X-Received: by 2002:ac8:6b14:: with SMTP id w20mr48888998qts.110.1558463913900;
 Tue, 21 May 2019 11:38:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190503072146.49999-1-chiu@endlessm.com> <20190503072146.49999-3-chiu@endlessm.com>
 <CAD8Lp47_-6d2wCAs5QbuR6Mw2w91TyJ9W3kFiJHH4F_6dXqnHg@mail.gmail.com>
 <CAB4CAweQXz=wQGA5t7BwWYdwbRrHCji+BWc0G52SUcZFGc8Pnw@mail.gmail.com>
 <CAD8Lp46hcx0ZHFMUdXdR6unbeMQJsfyuEQ7hUFpHY2jU9R7Gcw@mail.gmail.com> <CAB4CAwf26pdCY7FJA5H7d1aEY2xpjSto4JxARwczmVJ==41yng@mail.gmail.com>
In-Reply-To: <CAB4CAwf26pdCY7FJA5H7d1aEY2xpjSto4JxARwczmVJ==41yng@mail.gmail.com>
From:   Daniel Drake <drake@endlessm.com>
Date:   Tue, 21 May 2019 12:38:22 -0600
Message-ID: <CAD8Lp47K0Jn2wotANdQV3kT9yPP7bLnVd0eYhWui-vNDOEXBTA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] rtl8xxxu: Add watchdog to update rate mask by
 signal strength
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 2:37 AM Chris Chiu <chiu@endlessm.com> wrote:
> I've verified that multiple virtual interface can not work simultaneously in
> STA mode. I assigned different mac address for different vifs, I can only
> bring only one interface up. If I want to bring the second vif up, it always
> complains "SIOCSIFFLAGS: Device or resource busy".

Interesting. Can you go deeper into that so that we can be more
confident of this limitation?

ieee80211_open() is the starting point.
ieee80211_check_concurrent_iface() is one candidate to generate -EBUSY
but from inspection, I don't think that's happening in this case,
perhaps you can keep following through in order to figure out which
part of the code is not allowing the 2nd STA interface to come up.

Daniel
