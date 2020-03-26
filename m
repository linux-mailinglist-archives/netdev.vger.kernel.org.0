Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064C5193EB8
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgCZMSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:18:33 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39132 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgCZMSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 08:18:33 -0400
Received: by mail-ed1-f68.google.com with SMTP id a43so6540431edf.6
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 05:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V4hbjztF5Ik1UZ7YIpbWrgguBuzpB2gmxxKe/vyKQxM=;
        b=XLiyKIILO75sfB6zYR/03qVYttwWpK8fiyZOr5/0zJIN8UY+fkuqUJRyBD4oY7IJIH
         DXoppr+gvUdpd9JD7obphB6VVoOyTJS3Fw8knbP/WdSeqP/LOkToUAwIoxWJ4QxoDSew
         gMoZwl5qH1OucYNIKDygbMfHHfZUoWFi4waNxsH6mM4SNIzqA786KNaSQm/iWWRC610A
         ERkTP4a4tWCsBIuPG+YbIpqR4tKOS0WR6C/uWg/114s5egrE0cYNOV3IF9AP5Q62tk3f
         dHeR3D/GeSWDNhBcghK5h4lVbKkh3eTWAq1MXfkNDnYOnCEpDC8FqK6EobIwr+OcxKMa
         5Quw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V4hbjztF5Ik1UZ7YIpbWrgguBuzpB2gmxxKe/vyKQxM=;
        b=gkn5DZu42PVk934ACJy882JPnUAsWbOc9RYFNxT9e/uYUBluDvXk5VjMe66MtiAyhU
         6isHPHC0RCzIPVSeTdKTK2pq+nOncHn1Y9jJ2vvqvYxxPXeJbb1Wrs27HmW4HiHyn+YQ
         FkCHPpo1jChqkO+GgCQNprKnv0hxnh26BoFWIBlLO0O2IlkExMzAkYSXe6mysBCB/jvp
         MFBUmnDT7GAUHjRWcbpesXpZAZ4q6Atd7sKxRWSRqv+zZ7UVKhO1kKo2EGwVgje+vWDJ
         8Y5GgnsiUaxolNsFDQKy8dNqhdJOStwa5tXuLxvCVXsJDTrzZqIGM+V91rDsUhKa4EnY
         aVwQ==
X-Gm-Message-State: ANhLgQ2pHHgDoFXiFilyx03SWaxdU4MkbgP8O1bg6tD7uKuaHG3VN3Qi
        CL6dEQj7Xln5gUFHCvyzeWimvLdRUwgZal1VNqQ=
X-Google-Smtp-Source: ADFU+vujO94pyblG5kK2aLAQ3NRkgc/z9DPaOvEc1mbLsfiY3dSR20KSkbrHk/vtR5Pxg7pXLOKHbcWL1RgBeOUIjAk=
X-Received: by 2002:a17:906:6992:: with SMTP id i18mr2500921ejr.293.1585225110686;
 Thu, 26 Mar 2020 05:18:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200325152209.3428-1-olteanv@gmail.com> <20200325152209.3428-11-olteanv@gmail.com>
 <20200326101752.GA1362955@splinter> <CA+h21hq2K__kY9Pi4-23x7aA+4TPXAV4evfi1tR=0bZRcZDiQA@mail.gmail.com>
 <20200326113542.GA1383155@splinter> <83375385-7881-53b7-c685-e166c8bdeba4@cumulusnetworks.com>
In-Reply-To: <83375385-7881-53b7-c685-e166c8bdeba4@cumulusnetworks.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 26 Mar 2020 14:18:19 +0200
Message-ID: <CA+h21hoYUqWxVTHKixOKvtOebjC84AxcjoiDHXK75n+TpTL3Mw@mail.gmail.com>
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

On Thu, 26 Mar 2020 at 14:06, Nikolay Aleksandrov
<nikolay@cumulusnetworks.com> wrote:
>
> On 26/03/2020 13:35, Ido Schimmel wrote:
> > On Thu, Mar 26, 2020 at 12:25:20PM +0200, Vladimir Oltean wrote:
> >> Hi Ido,
> >>
> >> On Thu, 26 Mar 2020 at 12:17, Ido Schimmel <idosch@idosch.org> wrote:
> >>>
[snip]
> >
> > I think you should be more explicit about it. Did you consider listening
> > to 'NETDEV_PRECHANGEMTU' notifications in relevant drivers and vetoing
> > unsupported configurations with an appropriate extack message? If you
> > can't veto (in order not to break user space), you can still emit an
> > extack message.
> >
>
> +1, this sounds more appropriate IMO
>

And what does vetoing gain me exactly? The practical inability to
change the MTU of any interface that is already bridged and applies
length check on RX?
