Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABC33DDBA6
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbhHBO4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbhHBO4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 10:56:20 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B71CC06179A
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 07:56:09 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id n12so21830101wrr.2
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 07:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Ud7TFr55W5oEmMZKy4EhRkQvfrK4tdwbt68d3j996Is=;
        b=A3YIPu9fWdG+b0SkcEuJ/PPYqL0lz5tjemsZDamSZ9XpD0PMQ7b5XpOcW1tXFCTk0L
         KQpgcw0FoX2EoJL0lUjuOr9OEIViMgDVQJxq3xrpf6mWcIE7So/nogDjnEIN1chfHOxF
         ibTLspokdwafnfKTwD9xk3rtttdgIONOzgk19Uc8M938MW5RAyrq17WTv+gQA7IKhDSL
         y5kCZZ2llPd6lzXEJd1KZAr5NTN+YDG7TwcoZ4nzkGzCAan31pTGUaLXl3qpzQboFiGg
         2onZ4DP5PJicMMihEfg+HaPNDSLJegOYoMZU9Pka8XVH9YqfJcYVwQhfVv40fPzb1hYT
         BLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Ud7TFr55W5oEmMZKy4EhRkQvfrK4tdwbt68d3j996Is=;
        b=oUen4xynXoAriyURW2s5vYDUO3gTJXEQQaXXEJT35w36m4W5cd21htEnHt4oydbXIP
         buNMkO1oX+EjybF8hm62oQjI3PizapyvdvRJ13Ymv4I6uBbQFhzqCocy8nG2xZ4JqwUd
         xHDyLUmhpLbHROkm2Kt4s5uJVL7G5wvSsTsm/OsFrKoQD5APsal7ziseH8K3+2AAa79Z
         u6ZWZqvcZ/ywMxtm/VWpbOzcwZlJ27B7UEDxk6JvgsAyiLQmNMroB2tSW0xB7EzvYxOB
         +79EAAy8KNq0Q27xSom19Z0u7M70lU7ugPNvwabJgMiKGPnWUf6VyNZQYxciemyDM6Qn
         Ummg==
X-Gm-Message-State: AOAM533iJKosltZjEWjRM3QyCEll1oPNK7J3NTU0Q3GWWrvgv1G00Anc
        uhafADlspe2oRwqfMhKuQQF+N+8urJA/+6MdryUQ9wJxJCQ=
X-Google-Smtp-Source: ABdhPJzYCAJ5KP+Ba+t2ZSZLmyKz+KYSZrbBmnL2yvjp56Dv5zw+WdPq2r7h8ZrSP4mVqWQ6HGnTi+slM/WK0NJouBE=
X-Received: by 2002:a5d:63cf:: with SMTP id c15mr18008146wrw.230.1627916167926;
 Mon, 02 Aug 2021 07:56:07 -0700 (PDT)
MIME-Version: 1.0
From:   Leandro Coutinho <lescoutinhovr@gmail.com>
Date:   Mon, 2 Aug 2021 11:55:56 -0300
Message-ID: <CAN6UTaw7Rtoz4q-AsDjKbTm7_sU8BrTAmuMp8-wr6FzaxDMe2Q@mail.gmail.com>
Subject: net: intel/e1000e/netdev.c __ew32_prepare parameter not used?
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm a newbie and I was just looking at the code to learn.

It seems the parameter `*hw` is not used.
Although I didn't find where `FWSM` is defined.

Should it be removed? Or is the parameter really needed?

```c
static void __ew32_prepare(struct e1000_hw *hw)
{
    s32 i = E1000_ICH_FWSM_PCIM2PCI_COUNT;

    while ((er32(FWSM) & E1000_ICH_FWSM_PCIM2PCI) && --i)
        udelay(50);
}
```

It's because it gives an impression that "hw" is being changed somehow.

If you think it should be removed, I can send a patch.
