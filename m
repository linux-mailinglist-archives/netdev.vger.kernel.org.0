Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6385DBDB
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbfGCCTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:19:16 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:34608 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbfGCCTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 22:19:15 -0400
Received: by mail-yw1-f67.google.com with SMTP id q128so421488ywc.1
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 19:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U+pksHNztaLwcA2M2956gHib82VF7I/qSlyqNM7rtMo=;
        b=i+SB9aDfm0xleK2p9gOROAAElPFMYBlYA6okONU1/XnCti6vonBDIy0gcBHqqNT4oD
         BV8ED1JghyJqIdG1zfYlCtFezf54kyMyq+/CsCvT8SF5RtTkxG8WnnW9oO1A/TFTPkpM
         OfS4w/iQdOZJ4OYH12uzhl2B/qzKFIUAXIh5GSESsbagfY4mLEk7FvddWjSBUfkF0ypH
         QbbS5AHelZWLXeH+CNZmnXWHemP9wG2KBdrPicj/n5mOCUAqULut0z/GdPrTF6SusqCL
         YigKT8HFSFQxFgvCitNnz9kigLQ6jcShMfAjMwdfv+aKo8caY9e+z3yPi9WGzfOoNj0g
         m04g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U+pksHNztaLwcA2M2956gHib82VF7I/qSlyqNM7rtMo=;
        b=AZSuCLe+POG5uz8EfifLFiFP8UtivsOWwDGXs9PayKPKyhksieuk3+sqTzvUy7gP7T
         /AyzlETiVIbZWMKts2O2pVO4bxUna/ktH2vPp1FdrnGd1ebtgyqV2fcFdFRykj/CmrqQ
         VuwfYFc/iW2llVN9iMiVxS4nQEeA060+oCbshNzhA34fS8VWPvMacA8hhvTUJ3QhEvcR
         9ti7J5SyOsOXOQpRsmpXQPSpUh54Mu0331pbGbaVL9d5f3cVGqeKmJoN70MobR7TXoNU
         TqpgsYLPKL7FKgymjxKvx55o8d6apeecesDFYB2fSJGsv5wb+DOslFU36+5ji5ErvrB2
         epBA==
X-Gm-Message-State: APjAAAUOT8C2BWNx6uZDBwJbh/GFcSj1XTqpDeFmugoPjKhIHu1DUtWI
        KAXlSrtvb+eUZ+nmMzHBz7DJV1wj
X-Google-Smtp-Source: APXvYqwdzKNM43d8wYYsAUlEjJ/k7z1l3gvfTMABjmSyR8EEBlLKfGYEpB73cAwZJyeos9Pm6ViC9Q==
X-Received: by 2002:a81:9a8e:: with SMTP id r136mr21473708ywg.121.1562120354156;
        Tue, 02 Jul 2019 19:19:14 -0700 (PDT)
Received: from mail-yw1-f44.google.com (mail-yw1-f44.google.com. [209.85.161.44])
        by smtp.gmail.com with ESMTPSA id r85sm257843ywg.59.2019.07.02.19.19.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 19:19:13 -0700 (PDT)
Received: by mail-yw1-f44.google.com with SMTP id z197so385879ywd.13
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 19:19:13 -0700 (PDT)
X-Received: by 2002:a0d:c0c4:: with SMTP id b187mr19291559ywd.389.1562120352958;
 Tue, 02 Jul 2019 19:19:12 -0700 (PDT)
MIME-Version: 1.0
References: <1562113531-29296-1-git-send-email-john.hurley@netronome.com>
In-Reply-To: <1562113531-29296-1-git-send-email-john.hurley@netronome.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Jul 2019 22:18:36 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd3DaYsY1o_GFp-X=uRkfb6i0PUPbUsUagERmAZS+Hd7Q@mail.gmail.com>
Message-ID: <CA+FuTSd3DaYsY1o_GFp-X=uRkfb6i0PUPbUsUagERmAZS+Hd7Q@mail.gmail.com>
Subject: Re: [PATCH net-next v5 0/5] Add MPLS actions to TC
To:     John Hurley <john.hurley@netronome.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, jiri@mellanox.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        simon.horman@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 8:32 PM John Hurley <john.hurley@netronome.com> wrote:
>
> This patchset introduces a new TC action module that allows the
> manipulation of the MPLS headers of packets. The code impliments
> functionality including push, pop, and modify.
>
> Also included are tests for the new funtionality. Note that these will
> require iproute2 changes to be submitted soon.
>
> NOTE: these patches are applied to net-next along with the patch:
> [PATCH net 1/1] net: openvswitch: fix csum updates for MPLS actions
> This patch has been accepted into net but, at time of posting, is not yet
> in net-next.
>
> v4-v5:
> - move mpls_hdr() call to after skb_ensure_writable - patch 3
>   (Willem de Bruijn)
> - move mpls_dec_ttl to helper - patch 4 (Willem de Bruijn)
> - add iproute2 usage example to commit msg - patch 4 (David Ahern)
> - align label validation with mpls core code - patch 4 (David Ahern)
> - improve extack message for no proto in mpls pop - patch 4 (David Ahern)
> v3-v4:
> - refactor and reuse OvS code (Cong Wang)
> - use csum API rather than skb_post*rscum to update skb->csum (Cong Wang)
> - remove unnecessary warning (Cong Wang)
> - add comments to uapi attributes (David Ahern)
> - set strict type policy check for TCA_MPLS_UNSPEC (David Ahern)
> - expand/improve extack messages (David Ahern)
> - add option to manually set BOS
> v2-v3:
> - remove a few unnecessary line breaks (Jiri Pirko)
> - retract hw offload patch from set (resubmit with driver changes) (Jiri)
> v1->v2:
> - ensure TCA_ID_MPLS does not conflict with TCA_ID_CTINFO (Davide Caratti)
>
> John Hurley (5):
>   net: core: move push MPLS functionality from OvS to core helper
>   net: core: move pop MPLS functionality from OvS to core helper
>   net: core: add MPLS update core helper and use in OvS
>   net: sched: add mpls manipulation actions to TC
>   selftests: tc-tests: actions: add MPLS tests

Reviewed-by: Willem de Bruijn <willemb@google.com>

I did have some conflicts applying the patches from patchwork (to diff
v4 vs v5). Might be my process. This is clean against net-next, right?
