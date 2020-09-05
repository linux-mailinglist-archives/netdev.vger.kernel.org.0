Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A28425E6AC
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 11:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgIEJUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 05:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbgIEJUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 05:20:47 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB45C061244;
        Sat,  5 Sep 2020 02:20:47 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id e33so5579378pgm.0;
        Sat, 05 Sep 2020 02:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e3y7TtM1JD4U0ZffjOd3KNj7XrU0K7i58kkxLru4syI=;
        b=MjMGYubx0SYscDX2p1a1H6uD7JtzYiTkJ4Y1Eb/7x5ZYYCtql/QvlEcR+Os+gYIN0n
         HjBqaDTtetEHIB5P0ArJkahJLDgozRXx4AlmRXhKAL1UHwjmKh/irsvnGqS2fphfwr0l
         zhcfa0wyuN5VQbsQHZfQ2TxuCuFiPGYVxmlg7fEgGk/Thhpr6j0kKmC8j75ou0w4axQ+
         4I6lFGOZ60pBeBqQ7Mjie2PBxJFRP6k7VM0qENR4BOGrPah1ocprsdoZSXClX+dwQ5lk
         kMSxxPQAHo8U6u1iPTG8QjeDyXnrMzrTeoYcG0gFFBK+Sf7ZqEdvTG1RuBAVPCYHiuwD
         4L7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e3y7TtM1JD4U0ZffjOd3KNj7XrU0K7i58kkxLru4syI=;
        b=qZZl9E1FWoQ8dnBAk+F1zhgHLHnyiZ1ybhVWmENNq/CTRuwzga9e5gsaug3OkzeCmc
         ZxTBcSZ/OU9V6oGhuzMvQDy+pAGeQNKW/NHSke0f2RDHGyDRrUTdb1juRMntR77rnLcz
         qWDvAe884U32UZn4mSfgzHVg+lI+d+PvFC31eetlafrx4b+WpyN3V8t+soVhirp7K43U
         pNKgGXUhNZNEKAXTcZF/ecc8dOR5qeux1AJQR2u1lXgm1PcsEmVE495ARrXijm3ySs5n
         E84euzlsrAAvp3HL6rzkXFt8xceE6nR/Z6hlD9o6br/qru/lvkeNqfahNEN/ILMMjc0O
         dYkQ==
X-Gm-Message-State: AOAM530lJmENl1qmNSOLnoUaEtFOluAyDh3npytey/CpObdEGO4uDrT2
        tjN0ZDAadVb3IIoBWft9tWW7bQyz1VQaUQoG0Rw=
X-Google-Smtp-Source: ABdhPJyg4/3ir6a2udyWDViNAOHiA6KwVTSKIsQHw/1Ee+7elKMhbRgdi8MSL/gai9YKpK6BCJG4+VBzYraH4AzzzyI=
X-Received: by 2002:a63:4923:: with SMTP id w35mr10042456pga.368.1599297646736;
 Sat, 05 Sep 2020 02:20:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200903000658.89944-1-xie.he.0141@gmail.com> <20200904151441.27c97d80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EN+=WTuduvm43_Lq=XWL78AcF5q6Zoyg8S5fao_udL=+Q@mail.gmail.com>
 <CAJht_ENKyfMm7wAxcVSThEG63oVe72FvMs-5VaLWemKvveY+dQ@mail.gmail.com> <20200904213621.05dd6462@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200904213621.05dd6462@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 5 Sep 2020 02:20:35 -0700
Message-ID: <CAJht_EPf2Ht-mGEiim0oR7emkTwarpjv8uUvuQ439U1KCzsV-w@mail.gmail.com>
Subject: Re: [PATCH net v2] drivers/net/wan/hdlc_fr: Add needed_headroom for
 PVC devices
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 9:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Applied to net, thank you!

Thank you, Jakub!
