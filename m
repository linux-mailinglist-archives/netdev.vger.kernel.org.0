Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E1B5CF3D
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 14:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfGBMPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 08:15:34 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:46789 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfGBMPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 08:15:33 -0400
Received: by mail-oi1-f196.google.com with SMTP id 65so12815802oid.13;
        Tue, 02 Jul 2019 05:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GFbQ2lZ75GLkcYyTB1KTIsYzC0uNOByXOoKPod00wFs=;
        b=pNDluYD4lKRhUuqew+bf8iEzR2VpI7d/pPpAoNBJnANBM08Vx6ucs9fZQNgdGF/hTK
         B1pUf2OiFIvEcpwfcGyHbZf2TjDxJ6Tl+qJEzdzTMxYZbrxsYuoBksUkJdWRag9Br//k
         7rQW5fE8Sjb7IKTNgsBK8ZVZ2PtBqQcMPVnjeBC6D+hv5reXbqezkiT2n4ap453C0279
         PPeT+/DEHesZG0kvBZsZyGdJz4PQrKA8GSmOb29q/iqt7qf++ghdMhQ+0JkKKQ9okAuK
         Io0MCljP9E20WwcbRVKh5OL/uIzZBZ8XcApFtfGSUEiBvG4cNSsrcJaAeGYs+huGOirE
         zbGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GFbQ2lZ75GLkcYyTB1KTIsYzC0uNOByXOoKPod00wFs=;
        b=ROLjDvH7T/TlzqNrSY7RtWhO82OBA0u7Y3wB6G34a/SbcPbW7K21hY6qR7AwIo04qO
         9h9iuS0A7koZX2LZMZrFAr6WAduZ4z7SgK3YAH9Wlp4HJKz5DbbC5jvxCAPzE4agH1W3
         dOCRZNZ4IeXLK67l0lwSfvDjjf1bPhPLcu8kS6nNiy7YjyME5mAWM91GFKfm7GhCUW7O
         jwwUR3Lwo9BznegCWd0Y5KegnxdBCLV8SDwkEZFv0+K2R+/RYqgIQT49AOcZrBYT5ElC
         nKMfXvKA7OR+YrzqwqfqHzh7dbKcCdpPVp/2216Hce+ZeSUrPIcCYYE17IyauxrhS76R
         L+ug==
X-Gm-Message-State: APjAAAUVTmuNEvoCK1laY7P5K2+t8CnwoI0+5u9psJjQgmHQq8f36Wwm
        x+O8yAZGUJuvZrL4tIDAEkUdZZ8xG1XG/R/gjOE=
X-Google-Smtp-Source: APXvYqxqY1RjeDWoA94KUAz3xDr0PbjJADx3Xx6bq5j8IotEClW4dHA7dm7lJ2dN8aYC/rKgqpXDA5/5ZRReUmu6BKw=
X-Received: by 2002:aca:cdd3:: with SMTP id d202mr2489070oig.115.1562069732896;
 Tue, 02 Jul 2019 05:15:32 -0700 (PDT)
MIME-Version: 1.0
References: <1562059288-26773-1-git-send-email-magnus.karlsson@intel.com>
 <1562059288-26773-2-git-send-email-magnus.karlsson@intel.com> <a57b5b49-bd03-92af-cc5d-fe11d1d0e437@mellanox.com>
In-Reply-To: <a57b5b49-bd03-92af-cc5d-fe11d1d0e437@mellanox.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 2 Jul 2019 14:15:21 +0200
Message-ID: <CAJ8uoz3wB2x4TB8hOpc7L+Ss_7yKaJXP-n9f08uhDLtz=xJ5+g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/6] xsk: replace ndo_xsk_async_xmit with ndo_xsk_wakeup
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "bruce.richardson@intel.com" <bruce.richardson@intel.com>,
        "ciara.loftus@intel.com" <ciara.loftus@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "xiaolong.ye@intel.com" <xiaolong.ye@intel.com>,
        "qi.z.zhang@intel.com" <qi.z.zhang@intel.com>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "kevin.laatz@intel.com" <kevin.laatz@intel.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 1:43 PM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>
> On 2019-07-02 12:21, Magnus Karlsson wrote:
> > This commit replaces ndo_xsk_async_xmit with ndo_xsk_wakeup. This new
> > ndo provides the same functionality as before but with the addition of
> > a new flags field that is used to specifiy if Rx, Tx or both should be
> > woken up. The previous ndo only woke up Tx, as implied by the
> > name. The i40e and ixgbe drivers (which are all the supported ones)
> > are updated with this new interface.
>
> This API change will break build of mlx5 - XSK support for mlx5 was merged.

Yes, that will definitely break it. But I am glad your support is in
:-). Do you have any other comments on this patch set before I make a
v3?

/Magnus

> > This new ndo will be used by the new need_wakeup functionality of XDP
> > sockets that need to be able to wake up both Rx and Tx driver
> > processing.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
