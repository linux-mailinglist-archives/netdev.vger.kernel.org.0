Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9CC34D3EF
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhC2P3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbhC2P3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 11:29:13 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D23C061574;
        Mon, 29 Mar 2021 08:29:10 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id i26so19004342lfl.1;
        Mon, 29 Mar 2021 08:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YNSI6utIdzEkVaZ1ObCL91nCSNDK1rRdMbCcqeZDoUw=;
        b=eBwN6Y938TNH+phkVteIoYlBZa8P9+bKNWWvxBIQr6+5DFLf22PpWLsOfDLqW1ag+K
         g5jGAKZD4jLZ0x+93Xo0MuQl9Qb/qQa9wKk/Ytxj0ASrHBUc4b+qIWI/zJxEGEFs5YtE
         Qia7SWWbMWeYzgenrbf8Um7onj5EfCIZH5IWtaDWw33YRdy3WyZNcrzodv/TJ6I5kA41
         rbPiqdZroTnGGHvKsDheYAUnjE8bLk1P+hLlYvLmHPHqIVXBzsmTWM1uwBq1JkkG7z0s
         urX4bZ7U4e+uqaFiL3Mp0aA71xv/yLzL1VFjQm9abMCYG8zwh3uhf5y+RdecF8HDiQ73
         I3zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YNSI6utIdzEkVaZ1ObCL91nCSNDK1rRdMbCcqeZDoUw=;
        b=cGFeyCg7p+qhP8TrJ4fg9ZssQTsyFZeQDMR7NQVRETvMNiV9gBO8cqOq9rISSBLUPI
         128ggxpAt4PF92QOp/McgIXO4UOKQFLttenCQEQSgCfqkNtnPysmZ5tWD8ip2r4i/CoF
         i+6s2go/Un++Jaruwdny3KN4u62tFLMQVRKSd+TGEKbvZMBw0Hh4qtutULcOWoD2t8u1
         qwc86FprYV0r96+UiYrFGVLfuqpMnjurmtcEdAk8QX3EkPHVyUEPzSYH/CbUlhwRbtSK
         tpBzhqm89nbTIEKYrDjlGp1wiCoyWzJfyyDQGEVmyqZbBdM2qIXvss4ECIMPuYhNPXIR
         naFQ==
X-Gm-Message-State: AOAM531uePsl2JfXXyqAU0M7rGSa8wS/H1D+0d20Nq3QjY9AF0pX2pZA
        +MeYelxQKY3R6H2VYj6V81pJKVwvDgUS7Cx/FfFI0oDo
X-Google-Smtp-Source: ABdhPJzYVnTFrHNHuc5lV4/F6PFEGFHVERsQO8gxiDIDEmGYZ2V8sM++InCjT7bB3aRiLy56zUDjhjAoxzznuY+O85I=
X-Received: by 2002:ac2:5ec2:: with SMTP id d2mr17368504lfq.214.1617031748535;
 Mon, 29 Mar 2021 08:29:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210326142946.5263-1-ciara.loftus@intel.com> <20210326142946.5263-4-ciara.loftus@intel.com>
 <20210327022729.cgizt5xnhkerbrmy@ast-mbp> <bc1d9e861d27499da5f5a84bc6d22177@intel.com>
In-Reply-To: <bc1d9e861d27499da5f5a84bc6d22177@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 29 Mar 2021 08:28:57 -0700
Message-ID: <CAADnVQLt9Wa-Ue85HRzRe0HO_Cyqo9Cd4MyvXRgqSC_dmVe=DQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 3/3] libbpf: ignore return values of setsockopt for
 XDP rings.
To:     "Loftus, Ciara" <ciara.loftus@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 1:41 AM Loftus, Ciara <ciara.loftus@intel.com> wrote:
>
> >
> > On Fri, Mar 26, 2021 at 02:29:46PM +0000, Ciara Loftus wrote:
> > > During xsk_socket__create the XDP_RX_RING and XDP_TX_RING
> > setsockopts
> > > are called to create the rx and tx rings for the AF_XDP socket. If the ring
> > > has already been set up, the setsockopt will return an error. However,
> > > in the event of a failure during xsk_socket__create(_shared) after the
> > > rings have been set up, the user may wish to retry the socket creation
> > > using these pre-existing rings. In this case we can ignore the error
> > > returned by the setsockopts. If there is a true error, the subsequent
> > > call to mmap() will catch it.
> > >
> > > Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
> > >
> > > Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> > > ---
> > >  tools/lib/bpf/xsk.c | 34 ++++++++++++++++------------------
> > >  1 file changed, 16 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > > index d4991ddff05a..cfc4abf505c3 100644
> > > --- a/tools/lib/bpf/xsk.c
> > > +++ b/tools/lib/bpf/xsk.c
> > > @@ -900,24 +900,22 @@ int xsk_socket__create_shared(struct xsk_socket
> > **xsk_ptr,
> > >     }
> > >     xsk->ctx = ctx;
> > >
> > > -   if (rx) {
> > > -           err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
> > > -                            &xsk->config.rx_size,
> > > -                            sizeof(xsk->config.rx_size));
> > > -           if (err) {
> > > -                   err = -errno;
> > > -                   goto out_put_ctx;
> > > -           }
> > > -   }
> > > -   if (tx) {
> > > -           err = setsockopt(xsk->fd, SOL_XDP, XDP_TX_RING,
> > > -                            &xsk->config.tx_size,
> > > -                            sizeof(xsk->config.tx_size));
> > > -           if (err) {
> > > -                   err = -errno;
> > > -                   goto out_put_ctx;
> > > -           }
> > > -   }
> > > +   /* The return values of these setsockopt calls are intentionally not
> > checked.
> > > +    * If the ring has already been set up setsockopt will return an error.
> > However,
> > > +    * this scenario is acceptable as the user may be retrying the socket
> > creation
> > > +    * with rings which were set up in a previous but ultimately
> > unsuccessful call
> > > +    * to xsk_socket__create(_shared). The call later to mmap() will fail if
> > there
> > > +    * is a real issue and we handle that return value appropriately there.
> > > +    */
> > > +   if (rx)
> > > +           setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
> > > +                      &xsk->config.rx_size,
> > > +                      sizeof(xsk->config.rx_size));
> > > +
> > > +   if (tx)
> > > +           setsockopt(xsk->fd, SOL_XDP, XDP_TX_RING,
> > > +                      &xsk->config.tx_size,
> > > +                      sizeof(xsk->config.tx_size));
> >
> > Instead of ignoring the error can you remember that setsockopt was done
> > in struct xsk_socket and don't do it the second time?
>
> Ideally we don't have to ignore the error. However in the event of failure struct xsk_socket is freed at the end of xsk_socket__create so we can't use it to remember state between subsequent calls to __create().

but umem is not, right? and fd is taken from there.
