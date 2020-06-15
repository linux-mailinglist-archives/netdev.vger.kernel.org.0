Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80E61FA0D0
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 21:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbgFOTzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 15:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728771AbgFOTzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 15:55:10 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F90C061A0E;
        Mon, 15 Jun 2020 12:55:10 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id l12so18735993ejn.10;
        Mon, 15 Jun 2020 12:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Dg1YNjR1qNbLYCs7KgBFBMAL18hU3eIRDmxwQbF0no8=;
        b=UxWveGGilleiUwQZW5oAmSrQGr8eXhxAubb5laHbLR2j6KVqkNlxtINT/X38J3xvmx
         6u40aWz1mOtI5yBusDV4MC/WWvEKnjIyMoRB0sQ+JeCsXze7mr2GRgz7pBkWAWKJT4uG
         i19NJXvB4CZZrOsF/fZXUrkogtHoi+sS1RZdzipohxdaUOlVAp9wR5P3ToOOeAIcTJn9
         dpuoexhok/6jZsnpwFktLmo4c1nIVuXpcLLzQbbyJHBJBAdTwg2f13T7bPUKEhzyBAKy
         a5qfIsXteGWs6lAY469IUPzfhDr4zc0fyiP/yZKOZ9LWbF8z0BJvQYPO01Hjpx5GNEEM
         G6bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Dg1YNjR1qNbLYCs7KgBFBMAL18hU3eIRDmxwQbF0no8=;
        b=fPAz1LyF/kCO9luQNgF2zBkfsdKgZHhoIqGsK+6JoCn+gtDXza0W8qyhgGXGcY2YaO
         qwVEICPAdQ7pYaoyTSz6jyGUgojzmqTAcidOq+vAv+otVskGJNkUcHVOT/YUrdfp63kQ
         VYSc0GTuU3asNEZuw4jz92n6kUU2/9OSfcwBY9diFKBRqLwrw6FdR9orcs0YkwXI6GfV
         h2MvSEmFt33xGAyC2EayCkncFQYYETFCVO29Vriz8POoZnhAg/fcfaZc5AnNnzx3l/a4
         Uk8NiDXHkfEyX9NkxeFC82dztZZJO+tvc+kzX4WeZ5uQaZD+k3Bw6UC+i08ZelJdBhKH
         UEjQ==
X-Gm-Message-State: AOAM533tRprpTiVt8abDd6Uod9XIWBVki2Zyxcd3Y7yXsOi9BNlsMc00
        E0kBo65SMeWSZqZ1j16xK3vV0+oiZcWcy4pw4zw=
X-Google-Smtp-Source: ABdhPJyUAv4s1AG61rT6r8D1YlI3QbOIOGwWeOavOPfQRIAo6nUW5Uv7YsCJsIJ+dnguMmpI+FEBHz+Dbtkf65fZ11o=
X-Received: by 2002:a17:906:35ca:: with SMTP id p10mr26443854ejb.392.1592250908994;
 Mon, 15 Jun 2020 12:55:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
 <20200615130139.83854-5-mika.westerberg@linux.intel.com> <CA+CmpXtpAaY+zKG-ofPNYHTChTiDtwCAnd8uYQSqyJ8hLE891Q@mail.gmail.com>
 <20200615135112.GA1402792@kroah.com> <CA+CmpXst-5i4L5nW-Z66ZmxuLhdihjeNkHU1JdzTwow1rNH7Ng@mail.gmail.com>
 <20200615142247.GN247495@lahna.fi.intel.com> <CA+CmpXuN+su50RYHvW4S-twqiUjScnqM5jvG4ipEvWORyKfd1g@mail.gmail.com>
 <20200615153249.GR247495@lahna.fi.intel.com> <CA+CmpXtRZ4JMe2V2-kWiYWR0pnnzLQMbXQESni6ne8eFeDCCXg@mail.gmail.com>
 <20200615155512.GS247495@lahna.fi.intel.com>
In-Reply-To: <20200615155512.GS247495@lahna.fi.intel.com>
From:   Yehezkel Bernat <yehezkelshb@gmail.com>
Date:   Mon, 15 Jun 2020 22:54:52 +0300
Message-ID: <CA+CmpXtOAUnSdhjwi5HXaJhPzbUUsZZsitFifyhyPk+X2c=wYw@mail.gmail.com>
Subject: Re: [PATCH 4/4] thunderbolt: Get rid of E2E workaround
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 6:55 PM Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
>
> On Mon, Jun 15, 2020 at 06:41:32PM +0300, Yehezkel Bernat wrote:
> > > I think you are talking about the "prtstns" property in the network
> > > driver. There we only set TBNET_MATCH_FRAGS_ID (bit 1). This is the
> > > thing that get exposed to the other side of the connection and we nev=
er
> > > announced support for full E2E.
> >
> >
> > Ah, yes, this one, Thanks!
> > As Windows driver uses it for flagging full-E2E, and we completely drop=
 E2E
> > support here, it may worth to mention there that this is what bit 2 is =
used in
> > Windows so any reuse should consider the possible compatibility issue.
>
> Note we only drop dead code in this patch. It is that workaround for
> Falcon Ridge controller we actually never used.
>
> I can add a comment to the network driver about the full E2E support
> flag as a separate patch if you think it is useful.
>
> The network protocol will be public soon I guess because USB4 spec
> refers to "USB4 Inter-Domain Specification, Revision 1.0, [to be
> published] =E2=80=93 (USB4 Inter-Domain Specification)" so I would expect=
 it to
> be explained there as well.

I see. I leave it for your decision, then.
Thanks for bearing with me.
