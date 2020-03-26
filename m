Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C66D9193EEE
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgCZMe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:34:26 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44263 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbgCZMe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 08:34:26 -0400
Received: by mail-ed1-f68.google.com with SMTP id i16so5633456edy.11
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 05:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oBcRIYfCgu6tqgljjJ1+84ZLfrHPeMiHqPaSfarIAnw=;
        b=RA1rS7o5rTxIai+ojS2bld8cYbmSWgpxMl8XI+3Qv60rNqeLOwACFoh4fImsvXGazD
         06I2OQm4kgTKxB1glYxuw6rNq6iTu4e2hAKcL0yCJ3FPAfb/eTAVPXcwOwzSt0HW9mO4
         JIZ/YcD9EOt+p1rdQ9Df2Tun5Nggv1jaCdj1YezLqp+PZZ0VAZ2I212V6WbqlxRLCkuD
         lmekm/YPTguOgm5a2gEp0AjhcpZj8yleuxsdem1WpFiqnJ/M5TqwM42TLjc7uK+ulcrc
         AXeOi8inkOUitXFbqmpfZ8cT+nT8mWUQ/YKM8ysq+0pO4WGSj5d1ApuPRvBg4Oepv2Rh
         s74w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oBcRIYfCgu6tqgljjJ1+84ZLfrHPeMiHqPaSfarIAnw=;
        b=aOx56+YkoNOYfBszOvAL/gYXM7HjZjWzvlbz0TeqnkRkQGG29XsXkGEAgORAXKBrNu
         WzNYP204iamKbr7EBrMTyq/es1GEPfVAgaWq69vwuSAIgkvPUHVoZ8dRvrI1tJYHF1z3
         +aTq3dGio6qNxdEA9VWyAtHnn2hPnY1zDi+AS+B++75Ixn703hgZvO3Tf8C71ihvwn0n
         GGJaXrd4sa1W/JUThq7+XSSeAykX6TdcBy9jJ5/z0rq9mywUheijYGq8kQIm6xgUtW1C
         zMjXoiSjGKlMeAtpkY4VtvCMS0azFHkPTO2APFFbAA6XWmLJb7MMYXkCt4CTd6A8RHT5
         aK7g==
X-Gm-Message-State: ANhLgQ2iNRUFevXIgFVTKcomYoU7BP7L7pdY5ObXAdxW5M7gpePII10L
        YlO1ZZQ5v5apXwBno03wVyW0rydxEtgsFzoFZVY=
X-Google-Smtp-Source: ADFU+vvTmZ22CSBKlxoS2Nlu2yQDYVj2q9PX+wrFCUt7VveXHnUIdM5kXMg5yFQxfaRZLumrox/C0inG4ikTIOrVVkA=
X-Received: by 2002:a50:d5da:: with SMTP id g26mr7949514edj.179.1585226064097;
 Thu, 26 Mar 2020 05:34:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200325152209.3428-1-olteanv@gmail.com> <20200325152209.3428-11-olteanv@gmail.com>
 <20200326101752.GA1362955@splinter> <CA+h21hq2K__kY9Pi4-23x7aA+4TPXAV4evfi1tR=0bZRcZDiQA@mail.gmail.com>
 <20200326113542.GA1383155@splinter> <CA+h21hqSWKSc-AD0fTA0XXsqmPdF_LCvKrksWEe8DGhdLm=AWQ@mail.gmail.com>
 <20200326115435.GA1385597@splinter>
In-Reply-To: <20200326115435.GA1385597@splinter>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 26 Mar 2020 14:34:13 +0200
Message-ID: <CA+h21hrf_FbnGYt1f_7Nqom1ab7CGMVGHpuje3O7t2kxazFPtQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 10/10] net: bridge: implement
 auto-normalization of MTU for hardware datapath
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Mar 2020 at 13:54, Ido Schimmel <idosch@idosch.org> wrote:
>
> On Thu, Mar 26, 2020 at 01:44:51PM +0200, Vladimir Oltean wrote:
> > On Thu, 26 Mar 2020 at 13:35, Ido Schimmel <idosch@idosch.org> wrote:
> > >

> > > Also, I think that having the kernel change MTU
> > > of port A following MTU change of port B is a bit surprising and not
> > > intuitive.
> > >
> >
> > It already changes the MTU of br0, this just goes along the same path.
>
> Yea, but this is an established behavior already. And it applies
> regardless if the data path is offloaded or not, unlike this change.
>

I don't understand the 'established behavior' argument.
And I need to make a correction regarding the fact that it applies
regardless of whether the data path is offloaded or not.
If the data path is offloaded, it applies, sure, but it has no effect.
That is my issue with it.

Regards,
-Vladimir
