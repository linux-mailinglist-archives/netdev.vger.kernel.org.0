Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E90224A5E1
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 20:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgHSSVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 14:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgHSSVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 14:21:12 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A84C061757;
        Wed, 19 Aug 2020 11:21:12 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id x24so19831435otp.3;
        Wed, 19 Aug 2020 11:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zBMYHGoLqcQIDa75kPEyh/KB+iBrkpptU65EqjbhG7Y=;
        b=o2l1Nfy+8w9JtCsVwTjWxIgVHG2aUehxoeLFi30efLZOoVWoTEEBaUi5FOCfLKi04y
         b9mZolDBq8uWo4mIHYQnk61/OsVfF0WQUTy1P5jBSM/ArtN0BnwtUTTMMuDym8emq0E3
         QvRYmTZu1FR1MR378xPRy2DVifzGjzDaCCcZpIleQBJabDFrDcpaGKvYA+zpOW4y9vm0
         0xoXH4sDB65Re0fDGtrWucPfe7xdPAVtdJ1d50Jze9/V/alujo9zmKnslM/4bmD/FtpJ
         GZpCnEHAqQIOPt7fLL1TmMrnAQqEhkgghq7JGTZ02MsEd8dU2v195s4TAiunFEIy/2ow
         RhgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zBMYHGoLqcQIDa75kPEyh/KB+iBrkpptU65EqjbhG7Y=;
        b=mOwwuyJwUQJ6S1gCczB6LpUQxkerbdzv07Ny/x/jy5qAaewxvOzI0ZLD6lRFVtek43
         pHCbtYC2b+7CZvuzZoQmyOVueHr0hXa3Gh/uWAc7tCcXQufN8Q/IHc89d/tT5Yd2eT70
         axK40Oe6m/1MUYvUNeZOkL6wxFcTc239atuGGwrIBQ7WvWgBLrPLhPdRsbG9sdUBM61R
         v48Pb2myq89weRKNHrCD5rIPVGtq3o6dJmRJW6ERBhJxg3O7jS6s+uX+kO9FkJpeN0JN
         Z30tsiVEgUSVdC5uBMVYUdMYoOukjM5UMxamMOJRmtPEQ1VL1s/RtMTwbmnMeVZTU+X3
         8Ntw==
X-Gm-Message-State: AOAM532VDnceF/HLiggW9K5/T3UIAqFhOx5Ro0UfyTMV9Foj7KcaV5aw
        XdT2i5unt1wELI1z0bMeFz9uH6f0IDebtBztnwM=
X-Google-Smtp-Source: ABdhPJyyFtBGtBDQDC0+qpIvbBVOSiO9PH5RJce1zRO3VRRQKtT74SqDuprv6s1YgJttg07Y2wYBSfyUOU1rwvHn3r0=
X-Received: by 2002:a9d:429:: with SMTP id 38mr18272918otc.88.1597861271397;
 Wed, 19 Aug 2020 11:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200813084129.332730-1-josephsih@chromium.org>
 <20200813164059.v1.2.I03247d3813c6dcbcdbeab26d068f9fd765edb1f5@changeid>
 <CABBYNZJ-nBXeujF2WkMEPYPQhXAphqKCV39gr-QYFdTC3GvjXg@mail.gmail.com> <20200819143716.iimo4l3uul7lrpjn@pali>
In-Reply-To: <20200819143716.iimo4l3uul7lrpjn@pali>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 19 Aug 2020 11:21:00 -0700
Message-ID: <CABBYNZJVDk6LWqyY7h8=KwpA4Oub+aCb3WEWnxk_AGWPvgmatg@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] Bluetooth: sco: expose WBS packet length in socket option
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc:     Joseph Hwang <josephsih@chromium.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Joseph Hwang <josephsih@google.com>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pali,

On Wed, Aug 19, 2020 at 7:37 AM Pali Roh=C3=A1r <pali@kernel.org> wrote:
>
> On Friday 14 August 2020 12:56:05 Luiz Augusto von Dentz wrote:
> > Hi Joseph,
> >
> > On Thu, Aug 13, 2020 at 1:42 AM Joseph Hwang <josephsih@chromium.org> w=
rote:
> > >
> > > It is desirable to expose the wideband speech packet length via
> > > a socket option to the user space so that the user space can set
> > > the value correctly in configuring the sco connection.
> > >
> > > Reviewed-by: Alain Michaud <alainm@chromium.org>
> > > Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > > Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> > > ---
> > >
> > >  include/net/bluetooth/bluetooth.h | 2 ++
> > >  net/bluetooth/sco.c               | 8 ++++++++
> > >  2 files changed, 10 insertions(+)
> > >
> > > diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetoot=
h/bluetooth.h
> > > index 9125effbf4483d..922cc03143def4 100644
> > > --- a/include/net/bluetooth/bluetooth.h
> > > +++ b/include/net/bluetooth/bluetooth.h
> > > @@ -153,6 +153,8 @@ struct bt_voice {
> > >
> > >  #define BT_SCM_PKT_STATUS      0x03
> > >
> > > +#define BT_SCO_PKT_LEN         17
> > > +
> > >  __printf(1, 2)
> > >  void bt_info(const char *fmt, ...);
> > >  __printf(1, 2)
> > > diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> > > index dcf7f96ff417e6..97e4e7c7b8cf62 100644
> > > --- a/net/bluetooth/sco.c
> > > +++ b/net/bluetooth/sco.c
> > > @@ -67,6 +67,7 @@ struct sco_pinfo {
> > >         __u32           flags;
> > >         __u16           setting;
> > >         __u8            cmsg_mask;
> > > +       __u32           pkt_len;
> > >         struct sco_conn *conn;
> > >  };
> > >
> > > @@ -267,6 +268,8 @@ static int sco_connect(struct sock *sk)
> > >                 sco_sock_set_timer(sk, sk->sk_sndtimeo);
> > >         }
> > >
> > > +       sco_pi(sk)->pkt_len =3D hdev->sco_pkt_len;
> > > +
> > >  done:
> > >         hci_dev_unlock(hdev);
> > >         hci_dev_put(hdev);
> > > @@ -1001,6 +1004,11 @@ static int sco_sock_getsockopt(struct socket *=
sock, int level, int optname,
> > >                         err =3D -EFAULT;
> > >                 break;
> > >
> > > +       case BT_SCO_PKT_LEN:
> > > +               if (put_user(sco_pi(sk)->pkt_len, (u32 __user *)optva=
l))
> > > +                       err =3D -EFAULT;
> > > +               break;
> >
> > Couldn't we expose this via BT_SNDMTU/BT_RCVMTU?
>
> Hello!
>
> There is already SCO_OPTIONS sock option, uses struct sco_options and
> contains 'mtu' member.
>
> I think that instead of adding new sock option, existing SCO_OPTIONS
> option should be used.

We are moving away from type specific options to so options like
BT_SNDMTU/BT_RCVMTU should be supported in all socket types.

>
> > >         default:
> > >                 err =3D -ENOPROTOOPT;
> > >                 break;
> > > --
> > > 2.28.0.236.gb10cc79966-goog
> > >
> >
> >
> > --
> > Luiz Augusto von Dentz



--=20
Luiz Augusto von Dentz
