Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39504C9C36
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 04:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239367AbiCBDi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 22:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiCBDi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 22:38:26 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FB321815;
        Tue,  1 Mar 2022 19:37:44 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id p3-20020a17090a680300b001bbfb9d760eso3643827pjj.2;
        Tue, 01 Mar 2022 19:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PciJuOAlr8N3GqSNavEdG7YQccwdvrpqQWLs3HjQ+VA=;
        b=PTrKRROTBIa4xEupzDIFrHPrHyenZvzWG12wzZoLZps2cuBcmiiusPNsfOHUIIhXY1
         Dzaqn9aibxk9RctgxxOtEDHEWTp3Sx5miliKdiqss/S1J0EicS0fash1SGy1v9mPvfr7
         T38SofsQMbg8X07nA6By9jVC+2Tz9jDdzuDjpqdBInKOA0ljX1TjvSOcpZjVtP61EznM
         +MQTFBTgZ8VMToldXITtTwvHSIWnSfoU2zYEz5YHpxNW8GD7zvgtZ7FO3HaerB9nhzyO
         xVjj4p3u8kb3Fo2eCDpluGcJlh/hyUHNARfmIpmcyD8f8C6pr0G5S+7Qxg4tswPptD3G
         FDIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PciJuOAlr8N3GqSNavEdG7YQccwdvrpqQWLs3HjQ+VA=;
        b=gvDZLgHvRpznxGdkyCTrIXQHa106/TQZV99R2TzWfCFzyq2K0zkT5bZpdhmJLdLZvS
         9l/UeqCUVHpa7i5DhvA9pg+5Ti8ng0DXUqubR4kqqN/hW2XOnPSbvXmH13xjl7RVpklO
         uAev9uEhiaP4GQIeIV1n8J+Ba7DfE5w1sPKLeDIqcWj1mmfuFQHwcDF0IqPnl2C+cQdp
         rjqIITB6XYNAwHCF8q3M7Md+5t1NgBPblK+QBFXbYIrSL583lEMazmCXtIBtY9HQa7hw
         YkN3HWl2HIDxJrEGoHo/mXwbWiDA7gLvhtKsXwjbYRxWfbJsUNlkj/RivbvPqrQR4dQ9
         qP+g==
X-Gm-Message-State: AOAM533QTOElizu11nGdVnX+BFjApevuFIV6BsCPtDXfED/gWS8G9L8q
        dhcTYJQutxImfSt1p3CsKXT1wFF3LNEOZ0lApOo=
X-Google-Smtp-Source: ABdhPJx3DSL5oCKadQfLogOuMPj7/RztMmYXlngTeE6kQDqGd069vD88fNu+VHUk/rH2vprZMfwWvfhvn2DVYrJFk8A=
X-Received: by 2002:a17:903:18d:b0:150:b6d:64cd with SMTP id
 z13-20020a170903018d00b001500b6d64cdmr28972607plg.123.1646192263949; Tue, 01
 Mar 2022 19:37:43 -0800 (PST)
MIME-Version: 1.0
References: <20220301064314.2028737-1-baymaxhuang@gmail.com> <20220301180512.06f7f6dc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220301180512.06f7f6dc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Harold Huang <baymaxhuang@gmail.com>
Date:   Wed, 2 Mar 2022 11:37:32 +0800
Message-ID: <CAHJXk3aA62C5s-MV-B6mCTuUJGCdc-pEJpEkxX7vBDwDdHaSrw@mail.gmail.com>
Subject: Re: [PATCH net-next] tuntap: add sanity checks about msg_controllen
 in sendmsg
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:VIRTIO HOST (VHOST)" <kvm@vger.kernel.org>,
        "open list:VIRTIO HOST (VHOST)" 
        <virtualization@lists.linux-foundation.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 2, 2022 at 10:05 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  1 Mar 2022 14:43:14 +0800 Harold Huang wrote:
> > In patch [1], tun_msg_ctl was added to allow pass batched xdp buffers to
> > tun_sendmsg. Although we donot use msg_controllen in this path, we should
> > check msg_controllen to make sure the caller pass a valid msg_ctl.
> >
> > [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fe8dd45bb7556246c6b76277b1ba4296c91c2505
> >
> > Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Suggested-by: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Harold Huang <baymaxhuang@gmail.com>
>
> Would you mind resending the same patch? It looks like it depended on
> your other change so the build bot was unable to apply and test it.

Yes, it depends on this patch [1] which has been applied to netdev.  I
see this patch could be applied to netdev by git am. But if I use
another patch that could be applied to linux master, it could not be
applied to netdev anymore.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=fb3f903769e8
