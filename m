Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52685E07B3
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731906AbfJVPor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:44:47 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39362 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730141AbfJVPor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 11:44:47 -0400
Received: by mail-qt1-f194.google.com with SMTP id t8so9897790qtc.6
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 08:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aEJsGhajzyCVJOuCKLwjFSUsO0f3i2TI6DyKPqhR7FY=;
        b=P4KaiQhiShClpqiLgPf5gudvn16iX2Kr2un34ScnbMCovXjG7urRX9NX3TTIbTVUgk
         XHOIlj8ZK4+vVlJuXnwcSSHVGHXYj9ObSK2EfxMULFain91k++d9aiOq69FkQx88o0KW
         knNsmqAcwFS84dTcIiCw2083rsOyaeLOvyozLHgkoVRTrs4qpz+F6X8dqi1DZdB7uBCt
         4V9iK+fAxi6gIJMU9xKhsVOlSP1nTOIUlDN4Y7bffFeUB4R/RRdI5zsoOt7F7r3JhCI8
         Oy4vLCnFpF+rwp0BQ2+dTQO/OX+FBtUfjvCL7BsBY2qyJtDiWnnI5OBp/iPgkBUaQpSo
         9XMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aEJsGhajzyCVJOuCKLwjFSUsO0f3i2TI6DyKPqhR7FY=;
        b=Nc6WWYzymI9VAh7jqo+dxkV3ISG5kBFDfKyg5/0XdXUcYk+OEpQ/Dihs18WOdwq+JL
         qh6rVtg77FJcnh5wzdugGUgjSbSPTa7izfRQbJSMSB1xhyCT5j/S5wuPrAAFzFkLUSvn
         Bil0J1K0dP7V6q2UnxvgV3XGPzfLJ33i8Ce05Tu7Ml+YBtk8IdmzxRyNTBIesWvy4Fzq
         HiNeIhpVpFeqWFv8X+/uwJjF/VEaFnc83lExKOJP8RRMJh0GVN55QsKEpjUKlFxyRKGp
         cdg6FG49DBZIFf0QLViBwnD4xJMWA7+L+NN+YDIZiOgRjCGDF8R8x7/xDFwPfZYn+HfC
         spDw==
X-Gm-Message-State: APjAAAUeeofN3RykOwrj4cXKumX9uCshY10dJO6AUMHWXKM0OKYX4t4j
        HrbrTKYs4/eox0IJK9ldcQaC1En/IaCKyTYIUOd0GwhI1Vk=
X-Google-Smtp-Source: APXvYqwECgeN5LvVGdUpWT/GatzkGlQa8bXTwru1Tj5fcP4R8/a38nvi5Z2x8komLBTmiSq73OgEsBKrkwi3g/uN1JE=
X-Received: by 2002:ad4:500f:: with SMTP id s15mr1689551qvo.200.1571759086650;
 Tue, 22 Oct 2019 08:44:46 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
 <CALDO+SZib59P3qmQNWGNjKnrn_+DsFnu+QoPE0gfqRLVRpDk+Q@mail.gmail.com> <CAMDZJNVea1MZG2CRgi9KR1yf6r3x3RnonA0b_ZvEu9B_v5z1Lw@mail.gmail.com>
In-Reply-To: <CAMDZJNVea1MZG2CRgi9KR1yf6r3x3RnonA0b_ZvEu9B_v5z1Lw@mail.gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Tue, 22 Oct 2019 08:44:04 -0700
Message-ID: <CALDO+SYPnx_iWKJq1MoFFes14kEJOwYpjozcBgoY+FcA=0Dz=g@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v4 00/10] optimize openvswitch flow
 looking up
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>, pravin shelar <pshelar@ovn.org>,
        "<dev@openvswitch.org>" <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 6:16 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wr=
ote:
>
> On Tue, Oct 22, 2019 at 1:14 AM William Tu <u9012063@gmail.com> wrote:
> >
> > On Wed, Oct 16, 2019 at 5:50 AM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > This series patch optimize openvswitch for performance or simplify
> > > codes.
> > >
> > > Patch 1, 2, 4: Port Pravin B Shelar patches to
> > > linux upstream with little changes.
> >
> > btw, should we keep Pravin as the author of the above three patches?
> Agree=EF=BC=8C but how i can to that, these patches should be sent by Pra=
vin ?

you can send the patch, and use
git commit --amend --author=3D""
to change author

William
