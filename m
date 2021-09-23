Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE09D416611
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 21:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242965AbhIWTnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 15:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242796AbhIWTnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 15:43:40 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B4EC061574;
        Thu, 23 Sep 2021 12:42:08 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v24so27024826eda.3;
        Thu, 23 Sep 2021 12:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wg07Nq0+S7AqwImslpDCTktGQm2uEPJ2QVWkbuBwygU=;
        b=AjlMeFwPecvTyCnhNft0bXeMzyic3b9stseHJDhAwcx0arXZJo+5Gwif96E91wqLtp
         WKfYerRtbcKP86nTH7vi3h3ghS5t762DZ1WpRWhVwhp/2T9LFaAwYLHx4G/Yg1ovKYk8
         63nqj7ChEmRwUhT1ttI4rFu66h1nEFMrtUMZLP5V81QizvBGKOKwU+QBQY7PV4HlxGNo
         NyTheC10s1lG36CsrP8zUe3Tl3Oj5s23RiWHDCHViwdrU7KztKbk7cODh/NK1hPfzV6z
         x6K6UOFeUhklwBn9k6MUmmrKQcp55wQwSIYUEj/lYM0MC/S6bgaH+nLfdpKLCNV89/Dh
         pZ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wg07Nq0+S7AqwImslpDCTktGQm2uEPJ2QVWkbuBwygU=;
        b=t5KUUD7VHB03WbBDuibu2PDyWvZMxZKKbXoPLu0/mYAusD9agfxnv/i/9QPgCj6kPr
         f3LE08bvvCSJZKVwg4mdB3spNInR5sdnUxThXAwyM9m7Wm6PR3MUtNZlU46vrwEQTd4b
         zV1P0qEl5j1bXM20qlZxatVfo2aF7cqNjAHpKiPO8iAET/0OVqJjFRFY1d8Hdp1K/93v
         R3eQvAJPS8ocq8P/zRllCz2GNgtihYQbdc6g0hXG7ojQ8fPhGMM5xdRnY3cRVct8yuKz
         QZzzJ0ReXWD2PQL3eYx/ODATSRUyQBtDZ4fmIcqaDtxHBXBWHUWk+O1ucaS/wv15RHzA
         SeMg==
X-Gm-Message-State: AOAM532nsEhSw3bVh8Dalo1H+0SIkXBgfCv+1c7V0+L9quc0isz77by7
        Tr8atOcGig1fC/yDkDQADAYEwXqeQsnwMD5sErk=
X-Google-Smtp-Source: ABdhPJwht/FokcguS3Z265L1prL1jWL6zI6VFHAxFj21zRVI0cuMn07EXgNyEPNBE7e1W3PLTUV/O4IalXlEWdAk5EY=
X-Received: by 2002:a17:906:1707:: with SMTP id c7mr6697896eje.377.1632426126787;
 Thu, 23 Sep 2021 12:42:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210830123704.221494-1-verdre@v0yd.nl> <20210830123704.221494-2-verdre@v0yd.nl>
 <CA+ASDXPKZ0i5Bi11Q=qqppY8OCgw=7m0dnPn0s+y+GAvvQodog@mail.gmail.com>
 <CAHp75VdR4VC+Ojy9NjAtewAaPAgowq-3rffrr3uAdOeiN8gN-A@mail.gmail.com>
 <CA+ASDXNGR2=sQ+w1LkMiY_UCfaYgQ5tcu2pbBn46R2asv83sSQ@mail.gmail.com>
 <YS/rn8b0O3FPBbtm@google.com> <0ce93e7c-b041-d322-90cd-40ff5e0e8ef0@v0yd.nl>
 <CA+ASDXNMhrxX-nFrr6kBo0a0c-25+Ge2gBP2uTjE8UWJMeQO2A@mail.gmail.com>
 <bd64c142-93d0-c348-834c-34ed80c460f9@v0yd.nl> <e4cbf804-c374-79a3-53ac-8a0fbd8f75b8@v0yd.nl>
In-Reply-To: <e4cbf804-c374-79a3-53ac-8a0fbd8f75b8@v0yd.nl>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 23 Sep 2021 22:41:30 +0300
Message-ID: <CAHp75Vd5iCLELx8s+Zvcj8ufd2bN6CK26soDMkZyC1CwMO2Qeg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
To:     =?UTF-8?Q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 6:28 PM Jonas Dre=C3=9Fler <verdre@v0yd.nl> wrote:
> On 9/22/21 2:50 PM, Jonas Dre=C3=9Fler wrote:

...

> - Just calling mwifiex_write_reg() once and then blocking until the card
> wakes up using my delay-loop doesn't fix the issue, it's actually
> writing multiple times that fixes the issue
>
> These observations sound a lot like writes (and even reads) are actually
> being dropped, don't they?

It sounds like you're writing into a not ready (fully powered on) device.

To check this, try to put a busy loop for reading and check the value
till it gets 0.

Something like

  unsigned int count =3D 1000;

  do {
    if (mwifiex_read_reg(...) =3D=3D 0)
      break;
  } while (--count);


--=20
With Best Regards,
Andy Shevchenko
