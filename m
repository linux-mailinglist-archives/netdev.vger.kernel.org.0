Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A36F34052
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 09:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfFDHfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 03:35:33 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37947 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbfFDHfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 03:35:32 -0400
Received: by mail-lf1-f68.google.com with SMTP id b11so15654308lfa.5;
        Tue, 04 Jun 2019 00:35:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ObbNbZR/72D98Vc550uzYyGenM0+DWmngeVzeXEi0ZM=;
        b=ib0Xu1g61kKt4saR39X37LXuWJON+tfn85aLur4B3MXKxOJKsfGcIrueka9ap5bITB
         GZoaEwnWIFosuMgHN8xJ84pTa1Na4qwF5dIz7HuW1rrERMosDX86L2l8Fh60r2plgffi
         wygnHVaoMDJdhDTRBf8gJG/cvFPWof0X0UXRFoQAa+4To8SVIiWJPznjo7/KP/ruXsku
         zWpiEzqudMm+yTj4usuJcPEfEEh4oqWP2FQ7wSx0x0mmb+5SLE5TDO+r2CQgAIxECjqT
         nvdoPLYYOB4vNCVIsAb67gsneD5g5ExuqyzTCFOlEG4UbJB0UdS8u+UZsAtiga1lSjMJ
         o1KA==
X-Gm-Message-State: APjAAAVEY6okXx8ui8koZ53gOQ05I/nYLdNNnd3RVjefPUInN16wUlQR
        hNh8DkJbnCcnDZ5xJ575U/aVjDYqHYMjWqjN1mQ=
X-Google-Smtp-Source: APXvYqzZy7bAsh6aATIcduZ/ydlM1aKS4jqm+mf9GX84nUleah+LyhiDwD0TYIniqNJly32Ees0tY+eMT6LcuMOqD9Q=
X-Received: by 2002:a19:c142:: with SMTP id r63mr17039438lff.49.1559633729962;
 Tue, 04 Jun 2019 00:35:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190528142424.19626-1-geert@linux-m68k.org> <20190528142424.19626-3-geert@linux-m68k.org>
 <15499.1559298884@warthog.procyon.org.uk> <CAMuHMdX57DKCMpLXdtZPE-w0esUNVv9-SwYjmT5=m+u9ryAiHQ@mail.gmail.com>
 <9306.1559633653@warthog.procyon.org.uk>
In-Reply-To: <9306.1559633653@warthog.procyon.org.uk>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 4 Jun 2019 09:35:16 +0200
Message-ID: <CAMuHMdXOikfh56DAHGpNUoRefbhYSbh=VK3J8EzZCXVLqZtEVw@mail.gmail.com>
Subject: Re: [PATCH] rxrpc: Fix uninitialized error code in rxrpc_send_data_packet()
To:     David Howells <dhowells@redhat.com>
Cc:     Igor Konopko <igor.j.konopko@intel.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Matias Bjorling <mb@lightnvm.io>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-block@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Tue, Jun 4, 2019 at 9:34 AM David Howells <dhowells@redhat.com> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> > I'm not such a big fan of BUG(), so I'd go for ret = -EAFNOSUPPORT, but given
> > rxrpc is already full of BUG() calls, I guess it is an acceptable solution.
>
> Okay.  Are you okay with this going through net-next?

Yes, I am.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
