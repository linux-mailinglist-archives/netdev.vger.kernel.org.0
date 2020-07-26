Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4F322E211
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 20:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgGZSp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 14:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgGZSp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 14:45:58 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76765C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 11:45:58 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 2so9265761qkf.10
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 11:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=prf1QclXqXGXjkPFOo811M0GolRd9qIDnvmNesJEZwU=;
        b=fc0Bx75jtzQ8aoiBsYALJRMZxfd6hG0MlrfNpyGDGR68sWVmTNdayjMhMG6H+ZQYPb
         QvM1Ax7FNVVN5LZFt4tBrTrC8SPrOFBGqeUnBeNDVz5aD9ytdiU667A22FAxFNRBpo5J
         dQgoObkXgLq7Rqsc5E7K9uT8uvEPe50tAhpOO2QAlpxv1XUxVVAJ2+Z7vw/LIDDLtqeT
         otSHvB983rgG8m/+wRhSy7pgkACTHvZ+wHgPLZUuO5kVHhTE1h0keK7jZ0zDLNcHJV4W
         C8EsRSrItKV6WCuIIIZU524EMsT5rWiLSZB5J+pmXfzzviwm8J/Zkguk/QazSyXqh4j1
         OcMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=prf1QclXqXGXjkPFOo811M0GolRd9qIDnvmNesJEZwU=;
        b=BobdNclya6YMyHhW7Hq43FuymfjFz3CJ14Qp8b/pXf+cJenj+lXGQAOMIdvoI3ZemS
         z8V1Z+ckwecOMCuEQlrvQ5CKVcR8LIXzdcp+qpoCxXomCaFhUpkffQlhG0Ssc4u9n5EH
         jvTG9Ke+1RoNKjEq8s40YOP0+1OnMDmcQ3Qlrn7Yc+FMFKqnz4nji7pGN9+FOIbzdgrH
         vHieIh33B7N0mfaPTs7mJ0nPL+77ucJdNhddHB2TFxsrKYcBPkwzvMEZwjVYdO/Z+G23
         RfEBtlu6G0nJ3GCSzKJUP9Mvmx7U4ybqzzl9+bcCQLOMcwlz9VwRJDNLnaZI1ZfYaHCE
         70lQ==
X-Gm-Message-State: AOAM533emVdp6Wp3uvYAe38y//Ywz64qeelEZ2GV0+48QQhYBmv8yLm+
        FkJZIFsweNOMKpTUZk4y/FBqOrV+
X-Google-Smtp-Source: ABdhPJx4ILIAjAtMamPcsslsGdVQaPVNkV6VhNDqKAgy5xRz89HEM0H9v9WqAR/C4fMddZjuTgqEQA==
X-Received: by 2002:a37:b341:: with SMTP id c62mr19375721qkf.128.1595789157235;
        Sun, 26 Jul 2020 11:45:57 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id t12sm14533990qkt.56.2020.07.26.11.45.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2020 11:45:56 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id q16so5388682ybk.6
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 11:45:56 -0700 (PDT)
X-Received: by 2002:a25:6d87:: with SMTP id i129mr28884122ybc.315.1595789155635;
 Sun, 26 Jul 2020 11:45:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAEjGaqfhr=1RMavYUAyG0qMyQe44CQbuet04LWSC8YRM8FMpKA@mail.gmail.com>
 <CA+FuTSfpadw+ea-=pL0pMXxujzjoLW+d9yH2+GQo0jOJv=Zo4Q@mail.gmail.com> <CAEjGaqdo_6watKcGi1WUmrHiB9F=1+i+8LcxBXOMZvLneiEh7A@mail.gmail.com>
In-Reply-To: <CAEjGaqdo_6watKcGi1WUmrHiB9F=1+i+8LcxBXOMZvLneiEh7A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 26 Jul 2020 14:45:19 -0400
X-Gmail-Original-Message-ID: <CA+FuTSddWpsor8n8WaDkR-f=843SVs6SiLXU_E-yRCctDDkg3g@mail.gmail.com>
Message-ID: <CA+FuTSddWpsor8n8WaDkR-f=843SVs6SiLXU_E-yRCctDDkg3g@mail.gmail.com>
Subject: Re: question about using UDP GSO in Linux kernel 4.19
To:     Han <keepsimple@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 26, 2020 at 2:18 PM Han <keepsimple@gmail.com> wrote:
>
> On Sun, Jul 26, 2020 at 6:42 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Sat, Jul 25, 2020 at 7:08 PM Han <keepsimple@gmail.com> wrote:
> > >
> > > My apologies if this is not the right place to ask this question.
> > >
> > > I'm trying to use UDP GSO to improve the throughput. My testing shows
> > > that UDP GSO works with the local server (i.e. loopback interface) but
> > > fails with a remote server (in WLAN, via wlan0 interface).
> > >
> > > My question is: do I need to explicitly enable UDP GSO for wlan0
> > > interface? If yes, how do I do it? I searched online but could not
> > > find a good answer.  I looked at "ethtool" but not clear which option
> > > to use:
> > >
> > > $ ethtool  --show-offload wlan0 | grep -i generic-segment
> > > generic-segmentation-offload: off [requested on]
> >
> > Which wireless driver does your device use. Does it have tx checksum offload?
>
> It seems to be "brcmfmac" :
>
> $ readlink /sys/class/net/wlan0/device/driver
> ../../../../../../../../bus/sdio/drivers/brcmfmac
>
> I think tx checksum offload is off, and I couldn't turn it on. Does
> "[fixed]" mean it cannot be changed?

Indeed. That explains it.
