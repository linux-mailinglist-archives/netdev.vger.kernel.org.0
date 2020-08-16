Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC0D2456A9
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 10:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgHPIOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 04:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgHPIOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 04:14:04 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38535C061756;
        Sun, 16 Aug 2020 01:14:04 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id v4so14241149ljd.0;
        Sun, 16 Aug 2020 01:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=bcZntAIR5yiduRedyBOkEhWnIQVjSv+jGHpqWFNJEk0=;
        b=eP3TePlBVUJ/eODfTYNXP1IVxLPaYTu0UrtLqRgS8qLbXhHx3HJWwqJgERuewkWblC
         x5foXZyrSCswF9iPp8ppApJh0xTLD0Z6fxa2CQCyP1OtWQyvo6mj8k9mYGyXo0m/FmTx
         9+XGClEILI5Uk0MbOH5CJYaAlvAmx5HTqpM1nFAoKuDiTW2Ip9s4S57F1F7hNIr6D47g
         RMD3KOnklV+PrKloWLJMeHKIVtppeqMIQVUOovwChl91vVw9uUKBbl8f6sUjrWlI8hTa
         3/dfYOXZWiiP//nzPI3h9hTSsN13EqBaY8BBic/bgajoEoTvmkYP1uLQ7ChdzFrLSsMR
         k9iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=bcZntAIR5yiduRedyBOkEhWnIQVjSv+jGHpqWFNJEk0=;
        b=MeCI4d0Y5Gg1mU+qrsc7JgQll/RFRwRqlNoh+YkRTh5S3n82bfjrM4mIxc4vzOkYPV
         0RS6hXvsS/JVfDSPniXBdhbkdtmFk+V+FKgR6+GnYBP7SRh0AvH8snhb8ky1BUWd5nla
         rf/wgU5c/iCmsZHI0ChnpVJsgEjVKCv9bQ5scLw0j+1HDI3kPMEtweh0SK7x0mmv+JKe
         zMA986kYMHiot1K7U5QuU1B1/8uSKWwcZkssLla8E8huDK9JHN8fI3xL+Kalno6ndT0D
         Iq5gtYqL+gjMhuMkRygb+QAQVuYBAZYItmlGEgwQaVJoe/HSnRASaD0CB1Lud5+0b9q6
         RmEw==
X-Gm-Message-State: AOAM5315oFwe94XBfIghK8U5fbeG4DqDchFKPgkZDmeeKV06X8aJ4xh1
        B3jSitE9ppxsJll/y/D6+uvsYYf9u90UXtJ4GDULZZbriyEK6tFA
X-Google-Smtp-Source: ABdhPJz0V5KIQgcAA7RY/i1gNrKWEWz1r1xkvKxD8xBu2aHhkP3VuMF30qAZarvxvQ6hGhvvALz+hfYM24/3t3fzLaw=
X-Received: by 2002:a05:651c:2cb:: with SMTP id f11mr4594604ljo.431.1597565640647;
 Sun, 16 Aug 2020 01:14:00 -0700 (PDT)
MIME-Version: 1.0
From:   Fox Chen <foxhlchen@gmail.com>
Date:   Sun, 16 Aug 2020 16:13:49 +0800
Message-ID: <CAC2o3D+g9BHpMNJCj3z5QWt3_+k+sUGaGSww+s-udyPP9tEkUg@mail.gmail.com>
Subject: HCI_EV_PHY_LINK_COMPLETE in net/bluetooth/hci_event.c
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear all,

I have a question about

static void hci_phy_link_complete_evt(struct hci_dev *hdev,
struct sk_buff *skb)
-- HCI_EV_PHY_LINK_COMPLETE event packet handler in hci_even.c:4940

if (ev->status) {
        hci_conn_del(hcon);                 <--------------
        hci_dev_unlock(hdev);
        return;
}

Is it correct to del hcon here?? Because later on, when we close the
socket fd, socket_close will call sco_chan_del which will eventually
call hci_conn_drop. With hcon already deleted by this handler, it will
crash.

This bug is reported by syzbot in
https://syzkaller.appspot.com/bug?id=57e98513afbe427bbd65ac295130bcf5bc860dd8

I'm trying to fix that, but I don't know the design nature of
HCI_EV_PHY_LINK_COMPLETE. Will this scenario happen in real life?? Can
I remove hci_conn_del(hcon) here (I tested it, which fixes this bug)
??


Thanks,
Fox
