Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E601B221B74
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 06:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgGPEja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 00:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbgGPEj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 00:39:29 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746ACC061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 21:39:29 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id a17so2289927vsq.6
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 21:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=A0ekUFjcERHJPPW8HrmDlsvidqbHD3DiKBNeYrFpKfE=;
        b=k+O7x3KYzyHO09DuKILUXHtfIrxTzPLdI32853eDisjGI1+U2/wMOB2HoKp+y1Y4Ws
         +fOEHFf2KlpGDL0HsKFzzCxREYckhu1+xCjBQSfEaxSw3sKKGkLwBfnsZTWbDzNTkMaj
         bzYJz/sX9PHq9FRk5G8ZNeSjsdNaNQpGR2JMv3Ad3/e0guAR4EJgECmVcSRYEYfieAFc
         zgeRlFZ9+jCQlfM8xuMzLZ5s8kblZMGySiDtpNBnAj0Gj11wf13Lx+DndcYmJoZxhGP8
         BIh1vKK/8RY6rZC54W0BhovmYoDO0Hlba3kogF8LhMXY9KnHZMvjnorBNvFB2FMeSLBm
         S1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A0ekUFjcERHJPPW8HrmDlsvidqbHD3DiKBNeYrFpKfE=;
        b=OiO+/JDtr3PUunpqQRQdLzBZ/Kz9SIsXTm+VTguZ5gIuueUHErkbqd457hcSuMI3Yo
         H6vw2QycNbKtQS9J28l4L9KxDQy2RjuIRiqKfD8mvapi2POe8eqvOgHkqhQiDExb1w5g
         zGD2VTDoUSGXpPKcDV9zGA0Aw0pDyX7+zg5bf7exsDo9+nUPWTmuj6GZx2ObxHZmgZ/e
         j1JDgIQS8ILi4u1y2Cb9dhWryGpoAMLU+WWQVIn81atUbvTHj695kUEraD3a0/iYaNnT
         ixAongTFAcr8KDYRVOQg5AqrrFujxX4Keoa55zGOnArFoDKC379bRRCig3dOxE0Sn9Hx
         davg==
X-Gm-Message-State: AOAM530qZl4W+0w5ZAoWZOxhpFGWyL873Scfzz14hNINyGykAfxoDzf/
        /ZYEARFZau1Qk50TkGLfUDTrCJpZjx9afZCqo598Y7pWD1I9Vw==
X-Google-Smtp-Source: ABdhPJwVCBIFQpf6VxtKKBuMdwSlFwo5K5gHOOjllRteuKAKYlLoAKLDiSVGF/WLCh6WOsU7fWtpftM8g3rwh5rZ04M=
X-Received: by 2002:a05:6102:830:: with SMTP id k16mr1840918vsb.182.1594874368719;
 Wed, 15 Jul 2020 21:39:28 -0700 (PDT)
MIME-Version: 1.0
References: <2863b548da1d4c369bbd9d6ceb337a24@baidu.com> <CAJ8uoz08pyWR43K_zhp6PsDLi0KE=y_4QTs-a7kBA-jkRQksaw@mail.gmail.com>
 <7aac955840df438e99e6681b0ae5b5b8@baidu.com>
In-Reply-To: <7aac955840df438e99e6681b0ae5b5b8@baidu.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 16 Jul 2020 06:39:20 +0200
Message-ID: <CAJ8uoz3Qrh7gTtsOPiz=Z_vHEk+ZoC35cEZ1audDNu5G5pogZg@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [bug ?] i40e_rx_buffer_flip should not be
 called for redirected xsk copy mode
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 1:05 PM Li,Rongqing <lirongqing@baidu.com> wrote:
>
>
>
> > -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> > =E5=8F=91=E4=BB=B6=E4=BA=BA: Li,Rongqing
> > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2020=E5=B9=B47=E6=9C=886=E6=97=A5=
 14:38
> > =E6=94=B6=E4=BB=B6=E4=BA=BA: 'Magnus Karlsson' <magnus.karlsson@gmail.c=
om>
> > =E6=8A=84=E9=80=81: intel-wired-lan <intel-wired-lan@lists.osuosl.org>;=
 Bj=C3=B6rn T=C3=B6pel
> > <bjorn.topel@intel.com>; Karlsson, Magnus <magnus.karlsson@intel.com>;
> > Netdev <netdev@vger.kernel.org>
> > =E4=B8=BB=E9=A2=98: =E7=AD=94=E5=A4=8D: [Intel-wired-lan] [bug ?] i40e_=
rx_buffer_flip should not be called
> > for redirected xsk copy mode
> >
> >
> >
> > > -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> > > =E5=8F=91=E4=BB=B6=E4=BA=BA: Magnus Karlsson [mailto:magnus.karlsson@=
gmail.com]
> > > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2020=E5=B9=B47=E6=9C=886=E6=97=
=A5 14:13
> > > =E6=94=B6=E4=BB=B6=E4=BA=BA: Li,Rongqing <lirongqing@baidu.com>
> > > =E6=8A=84=E9=80=81: intel-wired-lan <intel-wired-lan@lists.osuosl.org=
>; Bj=C3=B6rn T=C3=B6pel
> > > <bjorn.topel@intel.com>; Karlsson, Magnus <magnus.karlsson@intel.com>=
;
> > > Netdev <netdev@vger.kernel.org>
> > > =E4=B8=BB=E9=A2=98: Re: [Intel-wired-lan] [bug ?] i40e_rx_buffer_flip=
 should not be
> > > called for redirected xsk copy mode
> > >
> > > Thank you RongQing for reporting this. I will take a look at it and
> > > produce a patch.
> > >
> > > /Magnus
> >
>
> Ping

My apologies RongQing, but it is taking longer than expected due to
key people being on vacation during this summer period. We are
debating weather the simple fix you provided covers all cases.
Hopefully it does, but we just want to make sure. The fix is needed in
four drivers: the ones you mention plus ice.

/Magnus

>
> -Li
