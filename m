Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA832C8787
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgK3PQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgK3PQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 10:16:37 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B8CC0613D3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 07:15:56 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id f190so22551648wme.1
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 07:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NesG8pcsYSfQoY/slcY4d6T+07DJ7f3FoANgYGzQoKc=;
        b=Kfrc/sLA475KYNnrjuw5pkeVf7Ij1Kfep3ag+tD2Pby0kKSV1ZCOesoodBqSdmosjh
         kFGXP/RNXSeSYMuB6x3ZBqFaJVbNYFSuTlkehEkm1IDuCJKJ6WMKtMHSJj0om6qDN0CI
         TSFsXMgH+PrrRO148Q7zuDRRDc9anlvb3A17wMRONtTqSVfyFA6KK+cDD54dN5a2S43L
         HG2DeY3hc1ceTZMv313WDhO7/d610lAcTiE71HeqdvJOOyH/I4i4vpEjx5X03+TEGX1e
         rRalO9uO1snwKC1PT4+2wkq8EhxMLUhUL/gN0bmo3c4J+Om923DZbmA+8qDU6pcVtLdw
         S6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NesG8pcsYSfQoY/slcY4d6T+07DJ7f3FoANgYGzQoKc=;
        b=crQ9/L/B2ImMMOzoouZCWXMyWkxtiOkteMp0cLllsnwBUD6SercjF1o1PfyE/7+0ju
         tQe8OBI96WH+VC4ze9O8OaQ4R8/aQ7aVZxn7wa4S7aAFAvR287mUZQo+o7tSJbxJTwlz
         6wJW7bp9F18QHoXBc51aFO/YcWsaD1poLG1jzvBStEbNOKpJ8WGkK2nb8V2FHboNIgDp
         MyvtBntx7slokM4qqMQUHtA7ia7qfj3yv62mK6vzkYnWHVjG7dBgAAK30chu5xcV3nyw
         RUOKPYMtIaCJc3DPE8945rzs7EbIDaeTeCDn9aArZOhbGRbs0jlKPBBhb9sPDqCoeuZZ
         vXVw==
X-Gm-Message-State: AOAM531++IwR7gB386IGf/ynPp6sZel8SlQknqMZThwd2dvcb3PmSlPN
        BX+8PNAazLWyceZcZun6GRUPqHIV04K+MLoAmj95QQ==
X-Google-Smtp-Source: ABdhPJzs/DZ+fzz23J4RJ9c/ym5TsIHOzSYgN4LtJmT8ecjk4Lxu9If4SyD3IX8KHKdz5SLMGUY7LAM3WMyejkRzPRQ=
X-Received: by 2002:a7b:cb09:: with SMTP id u9mr22204317wmj.25.1606749355171;
 Mon, 30 Nov 2020 07:15:55 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com>
 <4bb2cb8a-c3ef-bfa9-7b04-cb2cca32d3ee@samba.org> <CAM1kxwhUcXLKU=2hCVaBngOKRL_kgMX4ONy9kpzKW+ZBZraEYw@mail.gmail.com>
 <5d71d36c-0bfb-a313-07e8-0e22f7331a7a@samba.org> <CAM1kxwh1A3Fh6g7C=kxr67JLF325Cw5jY6CoL6voNhboV1wsVw@mail.gmail.com>
 <12153e6a-37b1-872f-dd82-399e255eef5d@samba.org> <CACSApvZW-UN9_To0J-bO6SMYKJgF9oFvsKk14D-7Tx4zzc8JUw@mail.gmail.com>
 <ebaa91f1-57c7-6c75-47a9-7e21360be2af@samba.org>
In-Reply-To: <ebaa91f1-57c7-6c75-47a9-7e21360be2af@samba.org>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 30 Nov 2020 10:15:19 -0500
Message-ID: <CACSApvboyVGOmFKdQLpJd+0fnOAfMvgUwpzRXqLbdSJWMQYmyg@mail.gmail.com>
Subject: Re: [RFC 0/1] whitelisting UDP GSO and GRO cmsgs
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>,
        Luke Hsiao <lukehsiao@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jann Horn <jannh@google.com>, Arjun Roy <arjunroy@google.com>,
        netdev <netdev@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 10:05 AM Stefan Metzmacher <metze@samba.org> wrote:
>
> Hi Soheil,
>
> > Thank you for CCing us.
> >
> > The reason for PROTO_CMSG_DATA_ONLY is explained in the paragraph
> > above in the commit message.  PROTO_CMSG_DATA_ONLY is basically to
> > allow-list a protocol that is guaranteed not to have the privilege
> > escalation in https://crbug.com/project-zero/1975.  TCP doesn't have
> > that issue, and I believe UDP doesn't have that issue either (but
> > please audit and confirm that with +Jann Horn).
> >
> > If you couldn't find any non-data CMSGs for UDP, you should just add
> > PROTO_CMSG_DATA_ONLY to inet dgram sockets instead of introducing
> > __sys_whitelisted_cmsghdrs as Stefan mentioned.
>
> Was there a specific reason why you only added the PROTO_CMSG_DATA_ONLY check
> in __sys_recvmsg_sock(), but not in __sys_sendmsg_sock()?

We only needed this for recvmsg(MSG_ERRQUEUE) to support transmit
zerocopy.  So, we took a more conservative approach and didn't add it
for sendmsg().

I believe it should be fine to add it for TCP sendmsg, because for
SO_MARK we check the user's capability:

if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
          return -EPERM;

I believe udp_sendmsg() is sane too and I cannot spot any issue there.

> metze
>
>
>
