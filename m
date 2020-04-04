Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC3C019E1F7
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 02:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgDDAjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 20:39:47 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39433 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgDDAjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 20:39:46 -0400
Received: by mail-oi1-f196.google.com with SMTP id d63so7823187oig.6
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 17:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fwdppA0HowuUxClKJSgNKg+JHXHmd+YQUDGgvkgPrgc=;
        b=CTYeesYijL6YL0zbY2T3qZ9i9jeI+GL+zJV/w8dCXBJeLXh80ZNTvBGixknssfhX1T
         1rCCELoyTTit8BEXfL9towo6fN7qTznLFlsXaS3X17sDNz77Xy9qtI2NGU4R04t0aovx
         OuWqaIM5p76ajHQA97GKBo8dejcwB7YDY/FWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fwdppA0HowuUxClKJSgNKg+JHXHmd+YQUDGgvkgPrgc=;
        b=aPQ/SHCeJWEKBCJIc4Tx6+JQpmJaWtg0AcIeaK0FF88Rz00RhFb2vosLN4NGrlaaZ1
         hbH2Yw4UptEFmosXbYoVTaYnb0HG7/4MW+ZeRY4ZyUnL2cgGYDL3RNKwq3UufIDbWXGv
         3dOkfL5kQQCSZMFBLvoHKSL3cCZaYAnJ04Xpe4TEDpWBtnNe8UzvKbzk59tbQcj+7HXy
         37sE+WouYzIfBd96iQV07VSue7n09/55oblj4t1lXl09AQf6kb7yEozJbEwJAO8BVsOy
         lVGQSXHByHQDtIPp4IR5oUT7QmTLRzdc9Y3q2XJPwRqUGpJr6I0Zxzk2N610/UCudmE9
         uw7g==
X-Gm-Message-State: AGi0PubzKXnDbtHg7k9mbbqY+VTl5ceoDr9ocjf0MQj8H+s7kBHq9FSi
        4JLSEGTG5qdBlUag8eSTmRKIr4FBcLH77BOg6PLArMwp
X-Google-Smtp-Source: APiQypK6wmBpZkXXMEXYONFsAJvr2BqqX5Cgz+k5e2G1JIYQoEjpB2AFV8zsmkWIpww0h+1ARvwfZ49JiRrnCJchBqs=
X-Received: by 2002:aca:1e0e:: with SMTP id m14mr5275665oic.136.1585960785750;
 Fri, 03 Apr 2020 17:39:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200403150236.74232-1-linux@roeck-us.net> <CALWDO_WK2Vcq+92isabfsn8+=0UPoexF4pxbnEcJJPGas62-yw@mail.gmail.com>
 <0f0ea237-5976-e56f-cd31-96b76bb03254@roeck-us.net> <CALWDO_VfZV0_uvsXyWAa-uOQ21228rUDsaChgkex88pyiP3U=A@mail.gmail.com>
In-Reply-To: <CALWDO_VfZV0_uvsXyWAa-uOQ21228rUDsaChgkex88pyiP3U=A@mail.gmail.com>
From:   Sonny Sasaka <sonnysasaka@chromium.org>
Date:   Fri, 3 Apr 2020 17:39:34 -0700
Message-ID: <CAOxioNn-eRnMmLu7dk9bLi5KwRzh_yip4hiwMY6mRW6cYMaWeA@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Simplify / fix return values from tk_request
To:     Alain Michaud <alainmichaud@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch looks good to me. Agreed with Guenter's assessment, I made a
mistake in the original patch by not being consistent with the
function contract.

On Fri, Apr 3, 2020 at 9:57 AM Alain Michaud <alainmichaud@google.com> wrote:
>
> On Fri, Apr 3, 2020 at 12:43 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > On 4/3/20 8:13 AM, Alain Michaud wrote:
> > > Hi Guenter/Marcel,
> > >
> > >
> > > On Fri, Apr 3, 2020 at 11:03 AM Guenter Roeck <linux@roeck-us.net> wrote:
> > >>
> > >> Some static checker run by 0day reports a variableScope warning.
> > >>
> > >> net/bluetooth/smp.c:870:6: warning:
> > >>         The scope of the variable 'err' can be reduced. [variableScope]
> > >>
> > >> There is no need for two separate variables holding return values.
> > >> Stick with the existing variable. While at it, don't pre-initialize
> > >> 'ret' because it is set in each code path.
> > >>
> > >> tk_request() is supposed to return a negative error code on errors,
> > >> not a bluetooth return code. The calling code converts the return
> > >> value to SMP_UNSPECIFIED if needed.
> > >>
> > >> Fixes: 92516cd97fd4 ("Bluetooth: Always request for user confirmation for Just Works")
> > >> Cc: Sonny Sasaka <sonnysasaka@chromium.org>
> > >> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > >> ---
> > >>  net/bluetooth/smp.c | 9 ++++-----
> > >>  1 file changed, 4 insertions(+), 5 deletions(-)
> > >>
> > >> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
> > >> index d0b695ee49f6..30e8626dd553 100644
> > >> --- a/net/bluetooth/smp.c
> > >> +++ b/net/bluetooth/smp.c
> > >> @@ -854,8 +854,7 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
> > >>         struct l2cap_chan *chan = conn->smp;
> > >>         struct smp_chan *smp = chan->data;
> > >>         u32 passkey = 0;
> > >> -       int ret = 0;
> > >> -       int err;
> > >> +       int ret;
> > >>
> > >>         /* Initialize key for JUST WORKS */
> > >>         memset(smp->tk, 0, sizeof(smp->tk));
> > >> @@ -887,12 +886,12 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
> > >>         /* If Just Works, Continue with Zero TK and ask user-space for
> > >>          * confirmation */
> > >>         if (smp->method == JUST_WORKS) {
> > >> -               err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
> > >> +               ret = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
> > >>                                                 hcon->type,
> > >>                                                 hcon->dst_type,
> > >>                                                 passkey, 1);
> > >> -               if (err)
> > >> -                       return SMP_UNSPECIFIED;
> > >> +               if (ret)
> > >> +                       return ret;
> > > I think there may be some miss match between expected types of error
> > > codes here.  The SMP error code type seems to be expected throughout
> > > this code base, so this change would propagate a potential negative
> > > value while the rest of the SMP protocol expects strictly positive
> > > error codes.
> > >
> >
> > Up to the patch introducing the SMP_UNSPECIFIED return value, tk_request()
> > returned negative error codes, and all callers convert it to SMP_UNSPECIFIED.
> >
> > If tk_request() is supposed to return SMP_UNSPECIFIED on error, it should
> > be returned consistently, and its callers don't have to convert it again.
> Agreed, the conventions aren't clear here.  I'll differ to Marcel to
> provide guidance in this case where as a long term solution might
> increase the scope of this patch beyond what would be reasonable.
> >
> > Guenter
> >
> > >>                 set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
> > >>                 return 0;
> > >>         }
> > >> --
> > >> 2.17.1
> > >>
> > >
> > > Thanks,
> > > Alain
> > >
> >
