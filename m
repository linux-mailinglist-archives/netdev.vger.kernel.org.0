Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD66A5F76
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 04:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfICCq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 22:46:29 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:41532 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfICCq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 22:46:28 -0400
Received: by mail-ua1-f68.google.com with SMTP id x2so4993689uar.8
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 19:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AByWFfabD0l5iIzr5haXrtys5MddymuIhBEL878c4XY=;
        b=r+fx7yV1xbQ9sHs5L7OOr1JLJ+A4esBD3gDKm9U2L8BCCFvyDYOSHxOSPBzf9a1EZZ
         xtOz7Hr1MIbb4f/YVB4o/bEzbaC57dstqFY4WU4nUq5+Y+FP0r1m7WIEC+/vFr4Sk4QI
         ePzwfTXS2Ah6+Iu3ib9mI9DAfPBz1puxEZnoI965Pe8Rbe/q5+t5BhaMxS8jWtD38uwJ
         6VwI8OZfzg2P4speGtcr0VD2ZYSRKs9U+es+7Eii36rvMU7Cna4J1SKAirmVglAn37Fv
         KOdPws33K8IAtQ/btnf5BVwdGd5pXjDRFjr9sWXkILTIEXjW263cb00WR9/whbe3DKL0
         YPpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AByWFfabD0l5iIzr5haXrtys5MddymuIhBEL878c4XY=;
        b=BTAqTqn0H7KFLnrjWL3CyhHsKv9Y7SDcpZgh3xwhi9mrc0Jb8NIFfw+2hVSe810T8u
         0DuC1gt696F2YQwG2z9SFTPUb5XKdpnCKMILjUbQFXJUPhTihc7mYLY0Mqvqq50kpzmi
         XBniAuNLRceedynQhYXo6tgt/YivfuOISrlh0KmkvN/YOotZEd+lDxVA2pVoW2zLOK89
         XDvqjjSndm6vAbYfX7KvW0vMdtjpxtL5r+h1HCsbpZZo7Ha/vYoqBeAxdEhnTdrhtRWG
         m4J700xqQf5MQyy9oNGJ4soRDHkGHBqN/MLupskI++j/Pm1ZxXu/4fJVQHeNQCAoCQT8
         5KEg==
X-Gm-Message-State: APjAAAV/uSEjVUvQATClkbUU0Eo6M27IKUmO009ZaSFkE+F/ErIdOVus
        P7is+W6sy41tCSgGXwnAclwavK2rPi+YTgI+bAzplA==
X-Google-Smtp-Source: APXvYqzjf5enxc0SW2FFkOXEpgTPIgid1ZZ4ujO1/Sq4DMROIL+2Z+lkMf6wyEuNdktTUPuG5JsXpOzdhYyXmJpHM94=
X-Received: by 2002:ab0:248a:: with SMTP id i10mr14573606uan.32.1567478787657;
 Mon, 02 Sep 2019 19:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <F7CD281DE3E379468C6D07993EA72F84D18A5786@RTITMBSVM04.realtek.com.tw>
 <20190826070827.1436-1-jian-hong@endlessm.com> <F7CD281DE3E379468C6D07993EA72F84D18AE2DA@RTITMBSVM04.realtek.com.tw>
 <875zmarivz.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <875zmarivz.fsf@kamboji.qca.qualcomm.com>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Tue, 3 Sep 2019 10:45:50 +0800
Message-ID: <CAPpJ_efAxQN4pRdpVmT5Pdkp-6Y-QVOQdJR4iY4A-PXZokLGtA@mail.gmail.com>
Subject: Re: [PATCH v4] rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> =E6=96=BC 2019=E5=B9=B49=E6=9C=882=E6=97=
=A5 =E9=80=B1=E4=B8=80 =E4=B8=8B=E5=8D=888:18=E5=AF=AB=E9=81=93=EF=BC=9A
>
> Tony Chuang <yhchuang@realtek.com> writes:
>
> >> From: Jian-Hong Pan
> >> Subject: [PATCH v4] rtw88: pci: Move a mass of jobs in hw IRQ to soft =
IRQ
> >>
> >> There is a mass of jobs between spin lock and unlock in the hardware
> >> IRQ which will occupy much time originally. To make system work more
> >> efficiently, this patch moves the jobs to the soft IRQ (bottom half) t=
o
> >> reduce the time in hardware IRQ.
> >>
> >> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> >
> > Now it works fine with MSI interrupt enabled.
> >
> > But this patch is conflicting with MSI interrupt patch.
> > Is there a better way we can make Kalle apply them more smoothly?
> > I can rebase them and submit both if you're OK.

The rebase work is appreciated.

Thank you,
Jian-Hong Pan

> Yeah, submitting all the MSI patches in the same patchset is the easiest
> approach. That way they apply cleanly to wireless-drivers-next.
>
> --
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches
