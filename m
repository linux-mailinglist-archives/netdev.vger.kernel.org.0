Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C39516AB31
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgBXQTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:19:48 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44134 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbgBXQTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 11:19:48 -0500
Received: by mail-wr1-f67.google.com with SMTP id m16so11056247wrx.11
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 08:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=19j0trO9Mv3wrvKzfdH1BS//FW2UKY+OrcE5cOGi9/I=;
        b=Cw1HT55FGFoyD6E0iMpdCHp8w7pAVLI/g2wPIpKjKTb5pxUdt8pOFFjBbPq6CJb5i9
         0itvZmEqL7fK3eAzrENC65BmVO6yoTEs11jci0P6njUwvEWxMWj0xoNQBJuNSHN6E3Oq
         u5A5CEANEG3NWiQdRBvexVujjFefbakQ/SsuE92Zn3sQdrnXofC0osFBZaFt4VYs+5or
         YU1dMFj5bNqKknCv4/NbiQYavhyLEWv2dMu0oPkkr2EBTTlKZyOhjway8ig8zsYdb8aT
         eIgu7CPIzZgyylRUyzAWyZEhYZbMiZ4Ed7tKAL7IyEgnig86CdOj1G/oe8UtsjVbuO7i
         bZfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=19j0trO9Mv3wrvKzfdH1BS//FW2UKY+OrcE5cOGi9/I=;
        b=qkH4R08MUDcei7w9nC+oM6/7c2nmcgsjah3aq5eZG3f/eAx1WJZ/N1gazwwqFdw2kE
         6jiyAdIN3CbjCb19TuWuEwb8rbLKdttukIE4aYJdBCqCK8pX82H3rV54NyHRajL58xYm
         cB9OAgorxewg7S+s+0bjuYj3s/P4RnYOkgOubah/sS5W7rt1ZXvUk3w2XPu98khQ+irL
         2x3OTCYvwJgZ5QDhP59JsUk3gikZxtkAoRJZTnZ4Ct/Xbu1rocnuJOq3RqAf6DdVW0lv
         y6VRscL+uUsppQ9KefU9X7Ls1CqezjWQqIvR9ZXolXtvIggpaigRoWsk/PaDtH6ILihk
         iM7g==
X-Gm-Message-State: APjAAAV2Be+WQChdlZCh0s4fzUEyqe9hUIpCriwkDvjuwE1PBDZMIioN
        +FQwc8E5BMlkISSL7AyVBygkMUgnqVUSS6/NqTN29Q==
X-Google-Smtp-Source: APXvYqxU9FUwoF+m5Q66zIMPAB7qaBWxrQS7ZCHR00X4HQuD5lXLTm339u0a6mc2/vAuanTvw3mbbCusDtmw7SArI30=
X-Received: by 2002:adf:dfcc:: with SMTP id q12mr66447402wrn.171.1582561184425;
 Mon, 24 Feb 2020 08:19:44 -0800 (PST)
MIME-Version: 1.0
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
 <20200128025958.43490-3-arjunroy.kdev@gmail.com> <20200212185605.d89c820903b7aa9fbbc060b2@linux-foundation.org>
 <CAOFY-A1o0L_D7Oyi1S=+Ng+2dK35-QHSSUQ9Ct3EA5y-DfWaXA@mail.gmail.com>
 <CAOFY-A0G+NOpi7r=gnrLNsJ-OHYnGKCJ0mJ5PWwH5m7_99bD5w@mail.gmail.com> <20200223193710.596fb5d9ebb23959a3fee187@linux-foundation.org>
In-Reply-To: <20200223193710.596fb5d9ebb23959a3fee187@linux-foundation.org>
From:   Arjun Roy <arjunroy@google.com>
Date:   Mon, 24 Feb 2020 08:19:33 -0800
Message-ID: <CAOFY-A1oBMCJ=2-ZTC7x78p0Oc9hdMBJd1z1hd3MFFK0AZo6ng@mail.gmail.com>
Subject: Re: [PATCH resend mm,net-next 3/3] net-zerocopy: Use
 vm_insert_pages() for tcp rcv zerocopy.
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 23, 2020 at 7:37 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Fri, 21 Feb 2020 13:21:41 -0800 Arjun Roy <arjunroy@google.com> wrote:
>
> > I remain a bit concerned regarding the merge process for this specific
> > patch (0003, the net/ipv4/tcp.c change) since I have other in-flight
> > changes for TCP receive zerocopy that I'd like to upstream for
> > net-next - and would like to avoid weird merge issues.
> >
> > So perhaps the following could work:
> >
> > 1. Andrew, perhaps we could remove this particular patch (0003, the
> > net/ipv4/tcp.c change) from mm-next; that way we merge
> > vm_insert_pages() but not the call-site within TCP, for now.
> > 2. net-next will eventually pick vm_insert_pages() up.
> > 3. I can modify the zerocopy code to use it at that point?
> >
> > Else I'm concerned a complicated merge situation may result.
> >
> > What do you all think?
>
> We could do that.
>
> For now, I'll stage the entire patch series after linux-next and shall
> wait and see whether things which appear in linux-next cause serious
> merge issues to occur.  Sound OK?

Sounds good for now; the conflict itself would be easy enough to fix
when it does crop up.

Thanks,
-Arjun
