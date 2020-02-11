Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11715158E6A
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 13:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgBKM0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 07:26:13 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:43849 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbgBKM0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 07:26:13 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 9fbc0156
        for <netdev@vger.kernel.org>;
        Tue, 11 Feb 2020 12:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=ogOM2rGxd6h01WnVx8HKc+lZxUk=; b=sHe1oW
        WQqKtfDj5Tt4VHGzoK81HK4s3HlX2gnSPYSSU+ukt5lZvZGOXfXbj3Bj2rJ3F116
        4TMSvDVN6uqSilkYLcjRDwG8dwdFwzfggvdtK2Z+911gF4tD02kbo7aFKEkeLFyP
        6DMWbAE6eXp160ynYJpYhoQ4s8gE5wa5QgqkwHwKYkVRA18q2/9yj/tVc70/T/m3
        HyMUgd/BcKvfpNEJV09ZlfhH42aSEJdYIrU/aUFwZnO2AXi++kvCcAtRxlvaUpUc
        mzuRf1+eMW99Hsyg0Y9ih59MAee6+HdhABfbELavXLfHG/0tE+R/pED5iKftOIyh
        OhyrhINkqCrBdwhg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2885aca1 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Tue, 11 Feb 2020 12:24:27 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id l136so12607924oig.1
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 04:26:10 -0800 (PST)
X-Gm-Message-State: APjAAAWBo6h4IiS0OpIiVSMyYx6EdKSxSWEaU1zG/kubdbGSbhqUqB3f
        soLmGTYqakyj4sePHClTmOuD3g4+E+uaCTxLwh0=
X-Google-Smtp-Source: APXvYqx+yGIjEfL/KoIIaHRx39G3Mm5mowlm1nKPjymHzGmLegwqiDsv2PNU266qPbrwKz0WzP8nKklDc5BvbMKeN18=
X-Received: by 2002:aca:815:: with SMTP id 21mr2784966oii.52.1581423969660;
 Tue, 11 Feb 2020 04:26:09 -0800 (PST)
MIME-Version: 1.0
References: <20200210141423.173790-1-Jason@zx2c4.com> <20200210141423.173790-2-Jason@zx2c4.com>
 <CAHmME9pa+x_i2b1HJi0Y8+bwn3wFBkM5Mm3bpVaH5z=H=2WJPw@mail.gmail.com> <20200210213259.GI2991@breakpoint.cc>
In-Reply-To: <20200210213259.GI2991@breakpoint.cc>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 11 Feb 2020 13:25:58 +0100
X-Gmail-Original-Message-ID: <CAHmME9pMaJ_OTCEVWkW=RmPSBxq6xneSiDUmZ=zGnkM1Cj5S7A@mail.gmail.com>
Message-ID: <CAHmME9pMaJ_OTCEVWkW=RmPSBxq6xneSiDUmZ=zGnkM1Cj5S7A@mail.gmail.com>
Subject: Re: [PATCH v2 net 1/5] icmp: introduce helper for NAT'd source
 address in network device context
To:     Florian Westphal <fw@strlen.de>
Cc:     Netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 10:33 PM Florian Westphal <fw@strlen.de> wrote:
> I also suggest to check "ct->status & IPS_NAT_MASK", nat is only done if
> those bits are set.

We can optimize even further, because we only care about the IPS_SRC_NAT case.
