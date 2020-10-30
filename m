Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB8E2A0FC4
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgJ3U4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgJ3U4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 16:56:34 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4FFC0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 13:56:34 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id b3so4131370vsc.5
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 13:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2TmD6mOVo6fdM3EWAqX44P/bwglIb6OCA6SeBfVl1js=;
        b=qv3Y++FIFD0Y2GX/d6QH7XkP9Qur+52lgS7nd9NKR0+O1FyP3edY/EpM5lSYcD6TH0
         3Y+z7sc6eHZski6LwMfLvKpg/9X0/nXLIxiQ4gTWOA8wzh6b1K1WnT+bMHwrD/Hr+yGz
         gYBXhv4A/pPS5WJopsLOY6/GPWeiVoAw2LQAZzgTLEq/vzdTI97j7vycpHf810mq0cI+
         TIXZLIjAdFZoVuL4yh3deAzDNUC//LNpaP8QR+JHLmGG2XeF71oH7JSQOjsSJl0DPAtG
         t9UJ/drHhotBTuyrNu4M3wasZl35CxsiCgLNAd/dOYUl6Pq4RzeJmaM5yoJKsMqCXE3F
         qvyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2TmD6mOVo6fdM3EWAqX44P/bwglIb6OCA6SeBfVl1js=;
        b=HeXqQIMNcy/ydy/PT3DCEqIfVw6rE4b04l3lpCmVoTHoEv31VVWdNldRc0I1mDQumv
         0fKIcalyStodOxeesG4katJXfA8aPSeHu01BeuH/w73VOTilh7URrNk/3OIi+W3qHo/9
         ZJcA6TRYfiw6f8JeQAQPsC1nOb2DY+r1HprBNnPPnGucY/0HaaQcL+iEnLwsxOoXfNFV
         SPbaGqU24DnFJRlYwxcTlqgZfCVSSE4gYO/AzbBpHfQyfmPwmqFax1prRsPUyxaLDBZn
         ZAILJSQvYqdtGGiSlsn2TISW23F5vP/kq+EmluxjQZJ5SqExLtJ7WCuCNXcgPy3vQM+C
         ST/A==
X-Gm-Message-State: AOAM5331CpIXpfwxF7YV06U+uYYSRKwISHRJF+EglMU1c5u9uXOGkaMC
        qh9IglXz8Q3K9huZNNApQzCtVnX3sIc=
X-Google-Smtp-Source: ABdhPJxmQdqhJZgEehO2WEcQ2JCkrsRhV3Tg/KIQPH5Hxlbgmd2gCM7lRFGLFECKx4LAw29t11fJ6A==
X-Received: by 2002:a67:6504:: with SMTP id z4mr9388317vsb.48.1604091392744;
        Fri, 30 Oct 2020 13:56:32 -0700 (PDT)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id x81sm884979vsx.19.2020.10.30.13.56.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 13:56:31 -0700 (PDT)
Received: by mail-ua1-f52.google.com with SMTP id x26so2141391uau.0
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 13:56:31 -0700 (PDT)
X-Received: by 2002:a9f:2067:: with SMTP id 94mr2964098uam.141.1604091391090;
 Fri, 30 Oct 2020 13:56:31 -0700 (PDT)
MIME-Version: 1.0
References: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
 <94ca05ca-2871-3da6-e14f-0a9cb48ed2a5@solarflare.com> <CA+FuTSdaPV_ZsU=YfT6vAx-ScGWu1O1Ji1ubNmgxe4PZYYNfZw@mail.gmail.com>
 <ca372399-fecb-2e5a-ae92-dca7275be7ab@solarflare.com> <CA+FuTSdk-UZ92VdpWTAx87xnzhsDKcWfVOOwG_B16HdAuP7PQA@mail.gmail.com>
 <e1765f12-daa4-feb3-28e1-7d360830026d@solarflare.com> <CA+FuTSf1dGDmRexKR54p=FnEY0LSBCc+tzknfVFTsmX7gk+fpQ@mail.gmail.com>
 <1fa7b4c0-e019-bf84-307b-61a1152f5a04@solarflare.com>
In-Reply-To: <1fa7b4c0-e019-bf84-307b-61a1152f5a04@solarflare.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 16:55:54 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfdjzm06oUBz4DTH33ix-o+sOqHQ=oojPA+CSXGt7HLYg@mail.gmail.com>
Message-ID: <CA+FuTSfdjzm06oUBz4DTH33ix-o+sOqHQ=oojPA+CSXGt7HLYg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] sfc: implement encap TSO on EF100
To:     Edward Cree <ecree@solarflare.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-net-drivers@solarflare.com, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 2:14 PM Edward Cree <ecree@solarflare.com> wrote:
>
> On 30/10/2020 17:33, Willem de Bruijn wrote:
> > On Fri, Oct 30, 2020 at 12:43 PM Edward Cree <ecree@solarflare.com> wro=
te:
> >> But possibly I don't need to have NETIF_F_GSO_UDP_TUNNEL[_CSUM] in
> >>  net_dev->gso_partial_features?
> > If the device can handle fixing the odd last segment length, indeed.
> It can, but...
> I thought Linux didn't give drivers odd last segments any more.  At
>  least I'm fairly sure that in the (non-PARTIAL) non-encap TSO tests
>  I've done, the GSO skbs we've been given have all been a whole
>  number of mss long.
> Which means I haven't been able to test that the device gets it right.

Perhaps the local TCP stack tries to avoid it. Off the top of my head
not sure if this is assured in all edge cases.

The forwarding path is another wildcard.

> > Until adding other tunnel types like NETIF_F_GSO_GRE_CSUM, for this
> > device gso_partial_features would then be 0 and thus
> > NETIF_F_GSO_PARTIAL is not needed at all?
> Unless the kernel supports GSO_PARTIAL of nested tunnels.  The device
>  will handle (say) VxLAN-in-VxLAN just fine, as long as you don't want
>  it to update the middle IPID; and being able to cope with crazy
>  things like that was (I thought) part of the point of GSO_PARTIAL.

Oh right.

> Indeed, given that GSO_PARTIAL is supposed to be a non-protocol-
>  ossified design, it seems a bit silly to me that we have to specify
>  a list of other NETIF_F_GSO_foo, rather than just being able to say
>  "I can handle anything of the form ETH-IP-gubbins-IP-TCP" and let
>  the kernel put whatever it likes =E2=80=94 VxLAN, GRE, fou-over-geneve w=
ith
>  cherry and sprinkles =E2=80=94 in the 'gubbins'.  Wasn't that what 'less=
 is
>  more' was supposed to be all about?
>
> -ed
