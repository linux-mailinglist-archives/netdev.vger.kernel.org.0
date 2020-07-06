Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467A421526A
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 08:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgGFGNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 02:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728828AbgGFGNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 02:13:13 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34DDC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 23:13:12 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id u133so6440174vsc.0
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 23:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hgmD+i4IIWjW4gYd1a3+qDwkfxsxrkEwAeh8o2hGHU0=;
        b=hwrW+OgvGyJ3BaYbxO2yA9DU7pQQ1UzV2fPV2Y4xdISWsNolF4gY6GnEjF1lH69WgC
         PwVhaNSgpS16wjLEBdms7NqpaCPyBMfvsM/Sx8zJxfm0IR7GTcxyBAdqQqL5mLdQqhB0
         BC/Jjf96g1oAo3f7jL6slpkj+CKlUZC7uVGQVapdPZmEm7XbSNu/5LBQ00ID3j4HiJLV
         883OripveTLSDJjR7fekF/NCv6Hq/qNVmy7D+E8JO1daA7AoJ+BOA0GMjOmULR+JmZqS
         nkYYfgQsTb7Wsgl/b8HR0HGmwJyrL1l0l6K6RXscQEyATImDxitAOXgVBATKlw2SmoyV
         oQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hgmD+i4IIWjW4gYd1a3+qDwkfxsxrkEwAeh8o2hGHU0=;
        b=Ebj34AVIC2/w85hoyWE5mGA5h+S5OK++8iqIgBe8bfVW0zQFWH/x+0EQuXFOoixqdW
         VDCn2FdcfEkzk67iwPaW+8lU1P4IqkdI2+7+KVjyZX5O4YMS8e0LnwJEpMBVGJFZB16u
         Nm+Oc4oyb61guz9gBSSBB2Blrgw15IavQC03L5ZbcBKLhPmcju4g4dbbZTatK/mhfreG
         FNq/h2aRxZO72RqxAPA0jyY3N90BsDBMxiKz7d570MBqSvS6pxJLNKFnNXHEPeWeRpvQ
         osOqA4taUIIGoj2EJ/wuRpCjyhMwi9Snmmu4cmZ2RcBe7DXoAgAwh4oJJxj8g0K5+3DN
         ObgQ==
X-Gm-Message-State: AOAM531Sy8fNR2KXTYDgos+BoZveZlr6XfEPbTbb0gMKF0OA7bTjJsNA
        vh7PeQgd2eWooOw3RLubirg/WiGxJgqQ0Ixl6J0=
X-Google-Smtp-Source: ABdhPJx/Hc4c0NZ9rCnjOQ6y3trsKsqEfJPZ5A4C7u14R7+vPzq/L+OyYQgzI5Q3FAQaL2DEmpFE0Ex6zHWmkVNNZgA=
X-Received: by 2002:a67:2d8d:: with SMTP id t135mr13445634vst.23.1594015991991;
 Sun, 05 Jul 2020 23:13:11 -0700 (PDT)
MIME-Version: 1.0
References: <2863b548da1d4c369bbd9d6ceb337a24@baidu.com>
In-Reply-To: <2863b548da1d4c369bbd9d6ceb337a24@baidu.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 6 Jul 2020 08:13:00 +0200
Message-ID: <CAJ8uoz08pyWR43K_zhp6PsDLi0KE=y_4QTs-a7kBA-jkRQksaw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [bug ?] i40e_rx_buffer_flip should not be
 called for redirected xsk copy mode
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you RongQing for reporting this. I will take a look at it and
produce a patch.

/Magnus

On Thu, Jul 2, 2020 at 11:33 AM Li,Rongqing <lirongqing@baidu.com> wrote:
>
> Hi:
>
>
>
> i40e_rx_buffer_flip to xsk copy mode can lead to data corruption, like the following flow:
>
>
>
> 1. first skb is not for xsk, and forwarded to another device or socket queue
>
> 2. seconds skb is for xsk, copy data to xsk memory, and page of skb->data is released
>
> 3. rx_buff is reusable since only first skb is in it, but i40e_rx_buffer_flip will make that page_offset is set to first skb data
>
> 4. then reuse rx buffer, first skb which still is living will be corrupted.
>
>
>
> -Li RongQing
>
>
>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
