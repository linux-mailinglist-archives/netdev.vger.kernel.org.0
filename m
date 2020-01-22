Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A05B2145C86
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 20:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgAVTeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 14:34:23 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34069 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVTeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 14:34:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id t2so386919wrr.1
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 11:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tiOyaxdYWRE+8VNu/k2aIXfnV11TYd9JeQpp7uZgmKo=;
        b=RDYzMtec8I1f07RBjCs6pX2Qk5HclWAkxsmtVGljW3SGcT+jEiqWD4GxWdbyi4kYA7
         ASlhERJfCRF367tVEUKnHR22A56e69SCtjL3wOaIKM7jhK5qaLNFNfY28C9FCHN15g26
         eeil6ynbrVzSJJJna0CwRcwOiTkocKFO1u6IXMqO8ezw3ikMB+jkKB01/I3CcIHjD9P0
         mFonGh//82Z40cOkeqA/CP2sUTbwoeczqQtdqgXvOr0CKnvUMd8U6FEahRkwjt8DXFcz
         +3JaW29AKWnWEKiX5G1Ah4quKVg7Qiwg1iOsdgUI6+vPXW6C0jrvF/PYp0vWcS7mvoPu
         VI7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tiOyaxdYWRE+8VNu/k2aIXfnV11TYd9JeQpp7uZgmKo=;
        b=WLVy8h4tTAYPjMXwu1qLcsVCqBjQvcKdSL2sz5uf1HBchTAKOUnQ3bTv9/MUGOXOSw
         jH4aNxlzWKGl8E7s3Jr+8kv0qSb21hEy4Ugc72iXxhJ/+xAIQmO5IDmLDYCUNh+748C8
         MQAApkgtg0Uz42VBgaW9H8glesrBUEEQ0o1YX1jzy/5OsZgl1LhQJwflrZKimWSjZlll
         1FUGNgnyUzO/XMttvdwZkuBDkuDN7ahUeNwE/agmzSYbSPJvGaSW9dU7xSiiBYG7f69o
         JtqDrbd9taCMxFs/S/lzfP1wVoJR5OtD0tEqM6UOzdMxXHEEeu0EShbNp+5126JFgMZI
         dlTw==
X-Gm-Message-State: APjAAAUPoyXDNz6dgQ1yq7Kp6mq/AAgFIGOy4ZBDZU0XwKVXPTmEkn/z
        3+1k+ve5VEoYQErzpp/GCmhBRBDiaks1PGtj/RY=
X-Google-Smtp-Source: APXvYqyTbh6cmIwRMrD1MR/Whukvk3gevAeoPqApH78Befafa8oPQifln0pSVz7g/beE6lg0p07jmFzjWJImye+rM94=
X-Received: by 2002:adf:ebc1:: with SMTP id v1mr13350237wrn.351.1579721661388;
 Wed, 22 Jan 2020 11:34:21 -0800 (PST)
MIME-Version: 1.0
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
 <1579612911-24497-7-git-send-email-sunil.kovvuri@gmail.com> <20200121083322.1d0b6e86@cakuba>
In-Reply-To: <20200121083322.1d0b6e86@cakuba>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Thu, 23 Jan 2020 01:04:10 +0530
Message-ID: <CA+sq2Ce3New6xSsHwE=mOHvRm-0aq09p0G9m9HD+PcGLF6L90w@mail.gmail.com>
Subject: Re: [PATCH v4 06/17] octeontx2-pf: Receive packet handling support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 10:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 21 Jan 2020 18:51:40 +0530, sunil.kovvuri@gmail.com wrote:
> >  static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
> >                               struct napi_struct *napi,
> >                               struct otx2_cq_queue *cq, int budget)
>
> > +     int processed_cqe = 0;
> > +     s64 bufptr;
> > +
> > +     /* Make sure HW writes to CQ are done */
> > +     dma_rmb();
>
> What is this memory barrier between?
>
> Usually dma_rmb() barrier is placed between accesses to the part of the
> descriptor which tells us device is done and the rest of descriptor
> accesses.
>

Will recheck, i think this can be removed.
Previously the logic was different and used to read number of valid
descriptor count from HW
and a barrier between that and descriptor processing was needed.

Thanks,
Sunil.
