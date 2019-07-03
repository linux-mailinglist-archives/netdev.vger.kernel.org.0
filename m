Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2591D5DF14
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 09:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfGCHmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 03:42:15 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39283 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfGCHmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 03:42:14 -0400
Received: by mail-qt1-f193.google.com with SMTP id i34so1480790qta.6
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 00:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vbcXnianh87vXEjFT9B3w4NaWyc5uSKsAaNy2YUdSho=;
        b=dxP42nkV2Pahhr14oxk8h1+yFAtHKvsqK+i/hKWRTlIRRlRO5mFwJG9ui1MB8rtU01
         sYBVHMMi8p89rlPnckYovpljhcmbRZ4OQRlLOvW6H/7OHl3KAogXVqLzGOQCoiFt55ei
         f8pjU9lYEX7VRj04zhgxmYjCT4rICFJuuMGUyWSW7TClIYf535dZ5VJAi8skgOzIREJ3
         m03y2w8s9hV7MBbsYwP59mI6vCoIycMafoNg10QoZMr+HEbKVS17+nW3aES4NDjsMMGv
         SETeuUCeyOOlMJZoNazL/PITVGLR6bc/9zoUO2zpuWCq+hGalbrJpS7fuVPmMaVHbQJv
         H/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vbcXnianh87vXEjFT9B3w4NaWyc5uSKsAaNy2YUdSho=;
        b=rpKC8B9AmjH2nbhgNIKW+xNMJ/ijwLbyXmxbDscnxDi8hMFt82dB3JvR+WdOeTETP2
         4BydhID+fsucw3XJDnhv9T1O+zrKllh979uifWko6jyQ9twhJZ9Iw7nsclisjZET1pQd
         zfcRe0uuVO2uKb/7IOXRuaiYONQb0vI/qGfRhpHkHrZAWxhk7cUSMI2PBBBQ3CIQAdN7
         QhlmvlEAbJbOGxrgYdnpt82l1Ta35VzXx4UkYx6yFSA/1IAA7nlnJsAKHe+67k8S6EM0
         73zM26ZyVdbiS1mvyY01dkIgzs49cZFyHkEG/5jnAsWrtViceXLpPKM00PfI2fsu4Gt+
         UQ8Q==
X-Gm-Message-State: APjAAAW5CLPqoqr+6ppSGZIE5XZ0JxcfXe5SMdeJL4656+535l5CoZTp
        g5jCBB9Ek+MKGJeH1seK8LF7EWEeng7qQw5mK2M8XQ==
X-Google-Smtp-Source: APXvYqw2helkZ3RMQLGNhGXrJACkePG5udZckFLg9KzZq3HT+da0RblRTkPUzH2vRKtJZ1SuWZitoxREttaJ45NLpCw=
X-Received: by 2002:a0c:d4d0:: with SMTP id y16mr29761996qvh.191.1562139733812;
 Wed, 03 Jul 2019 00:42:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190627095247.8792-1-chiu@endlessm.com> <CAD8Lp44R0a1=fVi=fGv69w1ppdcaFV01opkdkhaX-eJ=K=tYeA@mail.gmail.com>
 <4c99866e-55b7-8852-c078-6b31dce21ee4@gmail.com>
In-Reply-To: <4c99866e-55b7-8852-c078-6b31dce21ee4@gmail.com>
From:   Daniel Drake <drake@endlessm.com>
Date:   Wed, 3 Jul 2019 15:42:02 +0800
Message-ID: <CAD8Lp47mWH1-VsZaHr6_qmSU2EEOr9tQJ3CUhfi_JkQGgKpegA@mail.gmail.com>
Subject: Re: [PATCH] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     Chris Chiu <chiu@endlessm.com>, Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 8:42 PM Jes Sorensen <jes.sorensen@gmail.com> wrote:
> We definitely don't want to bring over the vendor code, since it's a
> pile of spaghetti, but we probably need to get something sorted. This
> went down the drain when the bluetooth driver was added without taking
> it into account - long after this driver was merged.

Yeah, I didn't mean bring over quite so literally.. Chris is studying
it and figuring out the neatest way to reimplement the required bits.

As for the relationship with bluetooth.. actually the bug that Chris
is working on here is that the rtl8xxxu wifi signal is totally
unusable *until* the bluetooth driver is loaded.
Once the bluetooth driver is loaded, at the point of bluetooth
firmware upload, the rtl8xxxu signal magiaclly strength becomes good.
I think this is consistent with other rtl8xxxu problem reports that we
saw lying around, although they had not been diagnosed in so much
detail.
The rtl8723bu vendor driver does not suffer this problem, it works
fine with or without the bluetooth driver in place.

Daniel
