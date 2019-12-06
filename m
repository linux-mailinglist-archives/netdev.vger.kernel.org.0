Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D944115159
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 14:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfLFNux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 08:50:53 -0500
Received: from mail-qk1-f176.google.com ([209.85.222.176]:41342 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfLFNux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 08:50:53 -0500
Received: by mail-qk1-f176.google.com with SMTP id g15so6492039qka.8;
        Fri, 06 Dec 2019 05:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NiDaKuvLNF7Z/i8+TnLDcpYUyGOM+YelR4zEAqebIDs=;
        b=EsS2v0KULFWUh/qXDmlgEWDpY9YSs8p8qmqCJ7y+0vPbpMj07PvjR2HvMvmJSHvaR3
         7+/y83Wt8MOaeO+NNgalY6bwqQfr3/s+NKAsF24yU1HEHbcjs5louLElulUvl63oRjWL
         lx4YMgzllkpF1/YVwSl+EBY4rldP0RUD0DiYA47eqDXxB3CjLTMd1s4EF09AJTPyHInZ
         oIh+1OLt84hlvMjxh1d13ltdgpKAluKPYtX883sYjiqRjlNDeHnXX8JdzRyWwlQjZRD1
         1AAK5pni34oFY1HAgernkt/jj0ek39VzYf8j6mGwJNf6kj9CbLqmJQKEuHI0Ule4NLyK
         sH+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NiDaKuvLNF7Z/i8+TnLDcpYUyGOM+YelR4zEAqebIDs=;
        b=Gbhq6+TP7wLT3+QUIgczTeBmyp58xjbskUveZhPGbpqWNonAcYWHhF0HU8WanzCebm
         L7V1/LOgiqBtlBB+MGuoxjkGhnUlBZh4feSPVPloi4F9afc7dFQHSTNpY5g/5j62yJl4
         +SOZG6w5T3YCijoz2AyFthiXKbzr8eWrEAolWEyZ4eKfP0xQBqdEi1KFyurBnRFD9Igf
         DM1KcHJzGyHy9Hse//CIKOdqWbpaKSdlYYTY2lPj7lpvG5gd29WauIIZsJwTLUul4OUs
         1lpI6KRYPmKZVH0ak/a4IcO1iTXELWk5i4kWCfSkLw2uiK2zab8o15xrK7LuGJm+otS+
         JRag==
X-Gm-Message-State: APjAAAXumnIrTMv7q/YEjUZS/CTZnjq9bexFAt9lGqfTh0ebEylUgKWg
        mqudkdwnN1wLhiUNhXGLY8ffGRO8wN7Dc7yU4IRYwErO
X-Google-Smtp-Source: APXvYqzlIA8TF1564W54jUBNhmiFgyIHex5Mo3qMq9W0Kzhn3Hh/EdXplrXCXwIJe9N24GCUxxWHkuUxwpvfLPRtANY=
X-Received: by 2002:a37:b602:: with SMTP id g2mr14036067qkf.174.1575640252258;
 Fri, 06 Dec 2019 05:50:52 -0800 (PST)
MIME-Version: 1.0
References: <CALDO+Sbd82Eqb27PezcUxTOhrD-YEsVw8cGW-abraZCLZ3fEAg@mail.gmail.com>
 <851ad28e-dc8b-da7c-66fa-ef88d684d7d2@intel.com>
In-Reply-To: <851ad28e-dc8b-da7c-66fa-ef88d684d7d2@intel.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 6 Dec 2019 05:50:14 -0800
Message-ID: <CALDO+SbciaNy5EReV5YHvciOSJmdMRPBQdF6XbhxfBF6gvPFDw@mail.gmail.com>
Subject: Re: Possible race condition on xsk_socket__create/xsk_bind
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 5, 2019 at 10:25 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.co=
m> wrote:
>
> On 2019-12-06 00:21, William Tu wrote:
> > Hi,
> >
> > While testing XSK using OVS, we hit an issue when create xsk,
> > destroy xsk, create xsk in a short time window.
> > The call to xsk_socket__create returns EBUSY due to
> >    xsk_bind
> >      xdp_umem_assign_dev
> >        xdp_get_umem_from_qid --> return EBUSY
> >
> > I found that when everything works, the sequence is
> >    <ovs creates xsk>
> >    xsk_bind
> >      xdp_umem_assign_dev
> >    <ovs destroy xsk> ...
> >    xsk_release
> >    xsk_destruct
> >      xdp_umem_release_deferred
> >        xdp_umem_release
> >          xdp_umem_clear_dev --> avoid the error above
> >
> > But sometimes xsk_destruct has not yet called, the
> > next call to xsk_bind shows up, ex:
> >
> >    <ovs creates xsk>
> >    xsk_bind
> >      xdp_umem_assign_dev
> >    <ovs destroy xsk> ...
> >    xsk_release
> >    xsk_bind
> >      xdp_umem_assign_dev
> >        xdp_get_umem_from_qid (failed!)
> >    ....
> >    xsk_destruct
> >
> > Is there a way to make sure the previous xsk is fully cleanup,
> > so we can safely call xsk_socket__create()?
> >
>
> Yes, the async cleanup is annoying. I *think* it can be done
> synchronous, since the map doesn't linger on a sockref anymore --
> 0402acd683c6 ("xsk: remove AF_XDP socket from map when the socket is
> released").
>
> So, it's not a race, it just asynch. :-(
>
Yes, thank you for quick response.
Now I can work around it by adding a sleep.
Look forward to your patch.

Thanks
William
