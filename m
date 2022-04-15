Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C68502676
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 10:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351285AbiDOIE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 04:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiDOIE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 04:04:26 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADB31BE92;
        Fri, 15 Apr 2022 01:01:58 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id i24-20020a17090adc1800b001cd5529465aso6570559pjv.0;
        Fri, 15 Apr 2022 01:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QBkn3eeqJuFTCBC21KwI1sFHjtTbFep2R7GxdftUZx8=;
        b=barxOCuFSntfHYJG2rn/cpZ8R9kC313FM51Ml+iwxG8L8FJwNSCkpWSXkEsz+1K3pt
         5oK32TX1sdwzhsfWhnJuemxrizHKdgPy5T8A9MJpiqKhNps6pKTWbkY/oUz4DbVxpQpY
         MIIZIS/nKlQWmLpxoN8N2t5+0weRo1u4mBcHMW5G/2N2f8R4XGcbB8TV1YSrl5MH2m9l
         +g8FOQSTpL4s5bGlQW2mlbVRZ7spK8479sK2VHzyhnSpvKrVBY9XVVenxJ23IFoCETYn
         bScnPNHKtkfJsZCO1/7OPb4o6TyIgeRzgKbSJSpiktT9RXEHnqMoO0F3D7cq6bA1ySbO
         8hdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QBkn3eeqJuFTCBC21KwI1sFHjtTbFep2R7GxdftUZx8=;
        b=gpEBMufhmcVdf/VTkemfLGMInxJtiOnlpeqSjBUlmdDgnJIhv9xdLVl9nx+ooMt4GC
         c8gUyD4OUQmRekYiW/1Zy+et/a/jvhPB/oX5SAK/39BN5DYpJd3ZGkvgc9+Ig+AKtI5T
         s3ROgCkOCdiD/1ZQonxdAcAptSCAB8xV1tDphiRcCqrWtribBpn3luMlgUG/9wfQ1tvH
         XSC7zgRMrFGzGwDXEfNSu3bMwYBO4/bxJghl3ASWJl58sIgMfRaup59NY9yrIDgcJIXL
         3K73YoRjRa063aLpXxlJHzn6eZFvjOMKnJQN3TJRHJCS2Ci3oPgwqdc5boYV9T0ovJdm
         5LxQ==
X-Gm-Message-State: AOAM530F6xYDEZVf/Lq5DY+2aTGfiv9wCkz6SdLA6PjXuXmFl111fL1K
        Bspx4/MHTaTcvSWqN3+WUzKIwtp38wtORsFPaJA=
X-Google-Smtp-Source: ABdhPJzUKf0/lVAPNa4/ZgiKBXh+oxw3lzDGmkPJRgsM2pFXsuN9lwU73kjl8TFBglomCAgZaFqfv9AmMJJfKFUWqC8=
X-Received: by 2002:a17:902:d2d0:b0:158:761e:c165 with SMTP id
 n16-20020a170902d2d000b00158761ec165mr20505494plc.59.1650009717870; Fri, 15
 Apr 2022 01:01:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220411230305.28951-1-luizluca@gmail.com> <20220413200841.4nmnv2qgapqhfnx3@skbuf>
 <Ylc3ca1k1IZUhFxZ@lunn.ch> <20220413205350.3jhtm7u6cusc7kh3@skbuf>
 <Ylc5RhzehbIuLswA@lunn.ch> <20220413210026.pe4jpq7jjefcuypo@skbuf>
 <CAJq09z7h_M9u=7jC3i3xEXCt+8wjkV9PfD4iVdje_jZ=9NZNKA@mail.gmail.com> <20220414125849.hinuxwesqrwumpd2@skbuf>
In-Reply-To: <20220414125849.hinuxwesqrwumpd2@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 15 Apr 2022 05:01:46 -0300
Message-ID: <CAJq09z6XTz7Xb0VBFdFVELb26LztFng7hULe6tSDX7KCQjzUmg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] docs: net: dsa: describe issues with checksum offload
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Kurt Kanzenbach <kurt@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
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

> On Wed, Apr 13, 2022 at 11:48:46PM -0300, Luiz Angelo Daros de Luca wrote:
> > > Ok, I'll go with "no checksum offload for its trailer tag, and bugs
> > > never fixed because no one uses it", in any case no Sasquatch. Thanks.
> >
> > Vladimir, so the DSA switch will not copy the offload flags when a tag
> > requests tail room? At least it will work.
> >
> > Now, if the offload HW does support that tag, what would be the
> > options? Set the slave port checksum flag from userland?
> > It would be nice to have some type of "magic trick" to have it enabled
> > by default. I'm already expecting a no, but wouldn't it be a nice case
> > for a DSA property in the device tree?
> >
> > Regards,
> >
> > Luiz
>
> DSA calls netdev_upper_dev_link(master, slave_dev, NULL) to establish a
> relationship with its master and the master driver can detect this by
> monitoring NETDEV_CHANGEUPPER.
>
> If we look a bit closer at the implementation of netdev_upper_dev_link
> we see it calls __netdev_upper_dev_link() which contains an interesting
> pair of arguments "void *upper_priv, void *upper_info". These are
> accessible to netdev_master_upper_dev_link(), and the bonding driver
> (for example) makes use of them, see bond_master_upper_dev_link().
>
> I'm thinking DSA could create a struct netdev_dsa_upper_info too, and
> certain DSA masters could populate things in it. Then DSA could look at
> what the DSA master has said (or not said) and fix up features
> accordingly.
>
> One information that could get populated by the master is a bit field of
> whether checksumming is supported for a certain tagging protocol.
> I'd rather pass a full bit field of all tagging protocols, rather than
> just the protocol in current use by the slave, because:
> (a) it's less gory compared to having the master look at
>     dsa_port_from_netdev(info->upper_dev)->cpu_dp->tag_ops->proto
> (b) the DSA tagging protocol can change at runtime, and when it does, no
>     NETDEV_CHANGEUPPER will be emitted, so the master won't have a
>     chance to inform us whether it can offload checksumming for the new
>     protocol. So it's better to have this information from the get go.
>
> We'd also need the DSA master to populate a "bool acked=true" from this
> new struct netdev_dsa_upper_info. The reason is to be able to
> distinguish between an empty bit mask that means "yup, I really can't
> offload checksumming for anything", and a bit mask that means "DSA who?"
> (where checksum offloading is expected to work under the normal
> circumstances described by you, no special code required).

That looks like a larger change. Should we put this patch on hold
waiting for the code refactor or we merge it as is (as it tells no
lies about current code).
