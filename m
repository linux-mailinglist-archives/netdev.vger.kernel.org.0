Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 996CA193ECE
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgCZMZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:25:43 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44480 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgCZMZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 08:25:42 -0400
Received: by mail-ed1-f65.google.com with SMTP id i16so5604043edy.11
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 05:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O3fHEG5bFH+lmfbKnqopYmPHIowryI49ozG07KPU6hs=;
        b=uo0nsPPKESlmQ6c09nxP7DnjUvaiz1WpMZYY4/dKL2ERlWMei5cLLHS3oJs1rlb7DA
         gmfewKXLBsaWDdHrQecJaUXiH0tqL5vOHeBqmiPgb23KNwgiEFLGMteekZ9PuULQnWn4
         XXTqw9KYV6ykj2LWW3SeWTYGlqq7bP+8Nf4aQFeQ1WW9Tj9kOHBz2JsQjjsgs9JXZ+F/
         SeL0bLcSI3/CYhL+tMRYZCoanOfKN5nvUhKfYRh+oLkoE05TDuLhntE5OPfuw4QRtKsF
         L+NAQwjgD+jGsuE5FCf+LL8LohkKoaK2Ijf+v7II5/6YO29cNVyXv4vEqJDIF0EZNj1G
         lr5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O3fHEG5bFH+lmfbKnqopYmPHIowryI49ozG07KPU6hs=;
        b=PCiExtqFf9SXGT1LWqYLjNatyOYK/OSakQCWD+NG27yAXFPB+22XO1ePljITdoWtfo
         7FqXjxHG3MHijvX8JtweNLMZDm3uA8dw/LnvfOKazZRQrHYGguLDCnC4D4zNwxomCiia
         a0nEEOI1amNG1ZO8btH13Vt0VrSlzltz6PizzMSJ1LfD2A9nhiybqCJ3mfG8Yq+a4yGg
         cfnHrk+dPUqUAKYWkWrOd4p5zFVLvOHciR5/2M+3uAnaYXNQO1CecygbFr2/86ogrOaZ
         dVgWq+AB7qPHWHNgUV3o0l0QlVFhzJnqiURctbLmIl1yhusci2oYXU4ITc3DxZeTzijN
         ZhPA==
X-Gm-Message-State: ANhLgQ10SZHbl99MXJqywMpNzQbW/UVbqzwdOxfUjipRimUPsJrSFyYR
        LtW59H3F5DXQPkrKWibLi3oBVPei/CwoqQe4JE0=
X-Google-Smtp-Source: ADFU+vtsv+PpOyPGpNCpkATiMFvqXQ9O6P/F5W5TVeQKIO3Th1cvbiAGjT9IWBh+T5EbdgC0oTRuBRBRUn0SkoHracQ=
X-Received: by 2002:a50:aca3:: with SMTP id x32mr7978699edc.368.1585225539345;
 Thu, 26 Mar 2020 05:25:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200325152209.3428-1-olteanv@gmail.com> <20200325152209.3428-11-olteanv@gmail.com>
 <20200326101752.GA1362955@splinter> <CA+h21hq2K__kY9Pi4-23x7aA+4TPXAV4evfi1tR=0bZRcZDiQA@mail.gmail.com>
 <20200326113542.GA1383155@splinter> <83375385-7881-53b7-c685-e166c8bdeba4@cumulusnetworks.com>
 <CA+h21hoYUqWxVTHKixOKvtOebjC84AxcjoiDHXK75n+TpTL3Mw@mail.gmail.com> <25bc3bf2-0dea-5667-8aae-c57a2a693bec@cumulusnetworks.com>
In-Reply-To: <25bc3bf2-0dea-5667-8aae-c57a2a693bec@cumulusnetworks.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 26 Mar 2020 14:25:28 +0200
Message-ID: <CA+h21hp3LWA79WwAGhrL_SiaqZ=81=1P6HVO2a3WeLjcaTFgAg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 10/10] net: bridge: implement
 auto-normalization of MTU for hardware datapath
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Mar 2020 at 14:19, Nikolay Aleksandrov
<nikolay@cumulusnetworks.com> wrote:
>
> On 26/03/2020 14:18, Vladimir Oltean wrote:
> > On Thu, 26 Mar 2020 at 14:06, Nikolay Aleksandrov
> > <nikolay@cumulusnetworks.com> wrote:
> >>
> >> On 26/03/2020 13:35, Ido Schimmel wrote:
> >>> On Thu, Mar 26, 2020 at 12:25:20PM +0200, Vladimir Oltean wrote:
> >>>> Hi Ido,
> >>>>
> >>>> On Thu, 26 Mar 2020 at 12:17, Ido Schimmel <idosch@idosch.org> wrote:
> >>>>>
> > [snip]
> >>>
> >>> I think you should be more explicit about it. Did you consider listening
> >>> to 'NETDEV_PRECHANGEMTU' notifications in relevant drivers and vetoing
> >>> unsupported configurations with an appropriate extack message? If you
> >>> can't veto (in order not to break user space), you can still emit an
> >>> extack message.
> >>>
> >>
> >> +1, this sounds more appropriate IMO
> >>
> >
> > And what does vetoing gain me exactly? The practical inability to
> > change the MTU of any interface that is already bridged and applies
> > length check on RX?
> >
>
> I was referring to moving the logic to NETDEV_PRECHANGEMTU, the rest is up to you.
>

If I'm not going to veto, then I don't see a lot of sense in listening
on this particular notifier either. I can do the normalization just
fine on NETDEV_CHANGEMTU.
