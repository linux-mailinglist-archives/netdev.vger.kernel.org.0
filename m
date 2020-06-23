Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA3D204976
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbgFWGDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730362AbgFWGDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 02:03:01 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96391C061573;
        Mon, 22 Jun 2020 23:03:00 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id z2so12498299qts.5;
        Mon, 22 Jun 2020 23:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WjxM9sg38cEaNOwA1lwrcYCBuLoMTzlRPxPZDKD8IhA=;
        b=oN5Z1+CrEv9B3MX7RP9AZssrvlObTqawZ/NNXCD8cZRCnBW3WzqEhhVqFRXujnwkMG
         +no7EIo6sFTIxRZDo8SJj6L1nU6rjzLFp+0z7QZd42EqxNE+p9HgJ6tgt+zEzLCQP3Tg
         4GUFxtqNYyd+ZkUWeY40LSMZq/0zW0IaUGQqjOUdLT88HNPTD8QuSI4LvP+WLg16jUVI
         tJ9O4FRIAV4NjTQhSe8raqwj9wfc8XoXq01kqyO++zC5BjtnHbRtF2/4Lsdo53OEGNYn
         Fu3T73deeF3tG2NP+vAVBoiCPQeGXFQJgNPdHa4Pyf/VgBSmiIVFMrytOkSb1Sm50EEX
         Xnug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WjxM9sg38cEaNOwA1lwrcYCBuLoMTzlRPxPZDKD8IhA=;
        b=XI2N7oBZu4GK8wU+o87D/cCYiZaLBhJgU/M3/Dd0oNeqLy76a3nDUO9QmS2C3DDQ5I
         /je+I4pTp1B8uAGg9YchY83KqjRLVNiJ2hIy6p+LVu9GE1Gg6fKtUnQUGjsetrxpieCn
         G+9nGFSAMX1doEO5H0qeXTUe5Ax5Fiv+jqmpOuOtBJDBhRNVoa+t0SIuO3SaCg/BbI3R
         AhYSKavPvKkj6kQotIZNNgEDHMOX0P+brVDl0ednhs3Q1RY0qow24Pm2UlOnflkD8ZPi
         mhfceTjABeOeHUFZ4qkbxvRU9uGyL4bxogJAyqN6IuwLE0GTOlFjMB0lbyiPif7+s+jS
         s/HA==
X-Gm-Message-State: AOAM532c6MrKzAXooYgczuh3FtDpE0hyA8u3ZJ1yjKPzcWY8QxXWrfQs
        ochtZugEqrlbP3U7B13sSHw0nuXNalFtrywxGzQ=
X-Google-Smtp-Source: ABdhPJxR+7SbwOohoazZHosm+/zIqUBaCi5dvAtoeJ8f0K3FBFsGlwHIKEXqxGD5Z0Ifs5zg866RVpLOr/ywKSv1bME=
X-Received: by 2002:ac8:2dc3:: with SMTP id q3mr19714217qta.141.1592892179884;
 Mon, 22 Jun 2020 23:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200622160300.636567-1-jakub@cloudflare.com> <20200622160300.636567-2-jakub@cloudflare.com>
In-Reply-To: <20200622160300.636567-2-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 23:02:49 -0700
Message-ID: <CAEf4BzZ0_01j4g-APS9HQ-jqKf3=qTerYWCkRmYscWWo2R0xwg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] flow_dissector: Pull BPF program assignment
 up to bpf-netns
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 9:03 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Prepare for using bpf_prog_array to store attached programs by moving out
> code that updates the attached program out of flow dissector.
>
> Managing bpf_prog_array is more involved than updating a single bpf_prog
> pointer. This will let us do it all from one place, bpf/net_namespace.c, in
> the subsequent patch.
>
> No functional change intended.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/net/flow_dissector.h |  3 ++-
>  kernel/bpf/net_namespace.c   | 20 ++++++++++++++++++--
>  net/core/flow_dissector.c    | 13 ++-----------
>  3 files changed, 22 insertions(+), 14 deletions(-)
>

[...]
