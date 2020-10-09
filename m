Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B3A2891E3
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390735AbgJITmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390731AbgJITmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 15:42:07 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A3AC0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 12:42:06 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 7so8008600pgm.11
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 12:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tqM3sVoz/RCFxKyfLOaHZdxgdM0zEd9Rfvsck3IllYc=;
        b=LTmi7rtjDzBpwQJDhsoQrQSeBidkMcdnaKeR9uSpAUHSSvDkvlWeImoa6nWRcAHtUc
         GM6SlP8kCiUEhIhWx8J8SReSek92/7Q2orgDsEpSGakSmbKunuBMBK9Cajg0asZ3XQ8m
         osf4cj6G3WnqXxm5z2n19eBqxtFGYgEA7y+l82mt7jNfNEh/1i/GFbXV4ssvhlLvi/hA
         MM2JJsBwDB0p3gYK2klhwkdxrmz3Euj6aSdsaLjd1llsl2XlaxrHXEmaU4rqgeKVF3V8
         FnrztK11anQ+lSNryQQax1StX8L1EwWNCWW2B3asqoKMV9al1eVrDjZdKhPuQzg1uw8c
         kh7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tqM3sVoz/RCFxKyfLOaHZdxgdM0zEd9Rfvsck3IllYc=;
        b=WTQ0Jbwrmu4AD/DrJpsTOIKbfiw/fiOOUOw8kH8oLQ4bcZ8KoxjkTA9W10Vk4Ro7z1
         N46hPUF6V5YMncRQMGaNqQfomtT6SR7EeWJKxL4XbsNeMYgopC4Sfvq9ZGb3Sb/kPEQ4
         q+m883R6bg+z9/okxN0x5AS67Y9wLtcu7lLI3aCSRNSNuEnLXpoC7O5M6zOcyOa3Bffy
         4SSX4bMPidluXoneTtxT3kYF/yIYp320CKyHA8uI3HOgJ+tpsScUKRhaKylPQVFEAFmY
         C6Ekf4SVmUVaGmtyYPuuA/DOOQ9xBvgU5l9+HQuP09kqCVO6enyum5d8aPz09ZreEK/Y
         Pw6Q==
X-Gm-Message-State: AOAM532JHvIJClb1FCQCZzfmBdLa3t9K5B1alUweXSeHSDqhGjz8+qpq
        Gd70D7N9LvfcKjGIMJd+6cId5CFxVpD5H407C1w=
X-Google-Smtp-Source: ABdhPJzuFT5V+MaliefWl2E/pZllrIdseLePw3wI+LU7ILtk8bmGkhxtCiZ01pXETz2zbivSKq34NKpqiw3anZhbeVc=
X-Received: by 2002:a17:90a:bf92:: with SMTP id d18mr6287236pjs.210.1602272525964;
 Fri, 09 Oct 2020 12:42:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
 <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
 <CAJht_ENnmYRh-RomBodJE0HoFzaLQhD+DKEu2WWST+B43JxWcQ@mail.gmail.com>
 <CA+FuTSdWYDs5u+3VzpTA1-Xs1OiVzv8QiKGTH4GUYrvXFfGT_A@mail.gmail.com>
 <CAJht_ENMFY_HwaJDjvxZbQgcDv7btC+bU6gzdjyddY-JS=a6Lg@mail.gmail.com>
 <CA+FuTScizeZC-ndVvXj4VyArth2gnxoh3kTSoe5awGoiFXtkBA@mail.gmail.com>
 <CAJht_ENmrPbhfPaD5kkiDVWQsvA_LRndPiCMrS9zdje6sVPk=g@mail.gmail.com>
 <CA+FuTSfhDgn-Qej4HOY-kYWSy8pUsnafMk=ozwtYGfS4W2DNuA@mail.gmail.com>
 <CAJht_ENxoAyUOoiHSbFXEZ6Jf2xqfOmYfQ6Sh-hfmTUk-kTrfQ@mail.gmail.com>
 <CAJht_EOMQRKWfwhfqwXB3RYA1h463q43ycNjJmaGZm6RS65QGA@mail.gmail.com> <CAM_iQpWRftQkOfgfMACNR_5YZxvzLJH1aMtmZNj7nJH_Wu-NRw@mail.gmail.com>
In-Reply-To: <CAM_iQpWRftQkOfgfMACNR_5YZxvzLJH1aMtmZNj7nJH_Wu-NRw@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 9 Oct 2020 12:41:55 -0700
Message-ID: <CAJht_ENnYyXbOxtPHD9GHB92U4uonKO_oRZ82g2OR2DaFZ7bBQ@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 10:44 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 4:40 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > I found another possible issue. Shouldn't we update hard_header_len
> > every time t->tun_hlen and t->hlen are updated in ipgre_link_update?
>
> Good catch. It should be updated there like ->needed_headroom.
> I will update my patch.

Thanks. But there is still something that I don't understand. What is
needed_headroom used for? If we are requesting space for t->encap_hlen
and t->tun_hlen in hard_header_len. Do we still need to use
needed_headroom?

Also, if we update hard_header_len or needed_headroom in
ipgre_link_update, would there be racing issues if they are updated
while skbs are being sent?

If these are indeed issues, it might not be easy to fix this driver.
Willem, do you have any thoughts?
