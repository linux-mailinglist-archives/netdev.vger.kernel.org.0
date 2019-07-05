Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 304345FFD3
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 05:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbfGEDoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 23:44:24 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34353 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbfGEDoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 23:44:24 -0400
Received: by mail-qt1-f193.google.com with SMTP id k10so2237735qtq.1
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 20:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0jLoib/76z+a4Uh7/LsBpEPX0BL6i8Jdhu/hAQPYPrA=;
        b=O/DCTkUDdY+wbbpdsZYAXMEMVdAJtjxZHI7FGfZy0aB/PXCqJ1F5avEAZlTw53jodY
         UAT61lYIAqvWHL5heS7408Etm3ii9Wvj+Vdr/cn8IBElD5xnRuMrKYCAWAdiBcB2+KsW
         z+n0QXKtjZR7K2mRFocZEZId79xyRFfMxZvbdbsyl1AYCk+JfaPW6FBmpGIZ+/J0/YFN
         Uxu0xpFg/QWHTcxeCsQ0lUvm3AMS/urc4EmpPwXoTTL5BegQs0+JGHr9/oCJkALzUWju
         0gxviEsWn/26DcxyxvqzYH0ci2D0msOynX/hoSZrk/tsTSNexN3rkQLPilyj3sZJLLco
         6/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0jLoib/76z+a4Uh7/LsBpEPX0BL6i8Jdhu/hAQPYPrA=;
        b=fSzxtjWsF1HWxqd8F2645G3vSK8zMlRLegVwLP0qPox/uuQ8rz+nPV0IoAdEXUcGW/
         0vDk1o4qHrW0I3g7eUFtBahXffGIpGvpSR0FvLBJ8mEPWiM/bQvT57VEG1ilJ/jAYd03
         8FWSpkB/KfBFkQNxj5e5LjZTcKijrl11dhCKfE58WEUMjlebAgIMGvEUf/akiWNDgHOz
         YPLDkStAiAUF/HNHn8TeAeXw1LQTCR6xIba2z+t6ULBxcZCw9WqizDXIKFD74ziEoP0q
         CI1mtbC/XjI5PGQeN1yGJb/Vz1TvK+mz4/lofm3PRxsGM2eNPCPB4OsuiEKdIvIKj+VX
         tQog==
X-Gm-Message-State: APjAAAWyyeXxh+AVWPQ3Ctyu5Hozvf1UciBikwALa/3N4HUKOe4C+Ai4
        KTajSWLb/z7IELl8RKCRFx2MOoBB73t7KqwGLEmwcA==
X-Google-Smtp-Source: APXvYqzkRImLdcMS1R/EG/cD8XC3hs3YLweRnOSx3fVIiN/Nrm5xsEgOLDOVwZpEwVllOZkZpHdsZcxvp449KvZXL+g=
X-Received: by 2002:a0c:c688:: with SMTP id d8mr1368862qvj.86.1562298263141;
 Thu, 04 Jul 2019 20:44:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190627095247.8792-1-chiu@endlessm.com> <CAD8Lp44R0a1=fVi=fGv69w1ppdcaFV01opkdkhaX-eJ=K=tYeA@mail.gmail.com>
 <4c99866e-55b7-8852-c078-6b31dce21ee4@gmail.com> <CAD8Lp47mWH1-VsZaHr6_qmSU2EEOr9tQJ3CUhfi_JkQGgKpegA@mail.gmail.com>
 <89dbfb9d-a31a-9ecb-66bd-42ac0fc49e70@gmail.com>
In-Reply-To: <89dbfb9d-a31a-9ecb-66bd-42ac0fc49e70@gmail.com>
From:   Daniel Drake <drake@endlessm.com>
Date:   Fri, 5 Jul 2019 11:44:12 +0800
Message-ID: <CAD8Lp44HLPgOU+Z+w4Pq6ukLjZv2hM0=uBL7pWzQp+RsdRgG6Q@mail.gmail.com>
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

On Wed, Jul 3, 2019 at 8:59 PM Jes Sorensen <jes.sorensen@gmail.com> wrote:
> My point is this seems to be very dongle dependent :( We have to be
> careful not breaking it for some users while fixing it for others.

Do you still have your device?

Once we get to the point when you are happy with Chris's two patches
here on a code review level, we'll reach out to other driver
contributors plus people who previously complained about these types
of problems, and see if we can get some wider testing.

Larry, do you have these devices, can you help with testing too?

Thanks
Daniel
