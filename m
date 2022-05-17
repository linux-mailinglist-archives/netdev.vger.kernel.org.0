Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E5A52AC06
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 21:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352794AbiEQTdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 15:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352798AbiEQTdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 15:33:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6564F522D9
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 12:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652815995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+1sB48ou7sq4iG5odbW5UgPnDZdHq+eVYauDlKBiRrs=;
        b=S463gJCBWFlvOXD5DmJehN0IxcF2rgSDzJByhhg0VPsfxkq4iZaJVTuE+k9HgLy5DAJaYg
        Al/FB5np77IXpON5MDaYZxLRAlSpCoSORPQltRuGQvtXcq7d7DpfWZYMK5oBmixIIUR5sv
        /bYZ1F1rnfGxKQtgTAGmPzvbNVINxRg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-chuAna1GP7Kn7Rni-BclXg-1; Tue, 17 May 2022 15:33:14 -0400
X-MC-Unique: chuAna1GP7Kn7Rni-BclXg-1
Received: by mail-qv1-f69.google.com with SMTP id kc6-20020a056214410600b0045a97658c7dso15624483qvb.16
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 12:33:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+1sB48ou7sq4iG5odbW5UgPnDZdHq+eVYauDlKBiRrs=;
        b=zywBeDneydzf1f0fPSrdAnL74lowwsuMh8Lb7Ih8WSbXXD1nYF9PeJ8GidsU2k0EPG
         fn+Tk7L6CfsljLzjpTOrVn8y8dSvZmAwUYF1S2I+ppFOZmngDiE+dhIYJ1RabP8V5BpD
         A7Y6vGYXAiG0cr+zMSFnC8VHaw7SOPnbloixU+S+4wv64uc5GKYq8TouMq3ucUsYlo7h
         L+OczhDfs7ScpksJQd92+CYTNtKgg0F2z7ZAK90OXrA+KizuONbnX5k2bMu/+7nT6LbC
         U8VB9+VeTn+2VSFVsx9xx8zccD4Aib6JGxG1foiD+HHbp8BxpDUCqJqZMM2V16HVO1RQ
         8eDw==
X-Gm-Message-State: AOAM531EafFWeqC7kdkDsdd5D1r2DxvhjI+44+a0jdPGw5WNOu53FHNn
        HvI4IeHFuPkBXD/fvnWxfSa7COlyttBrlwHjzn91lcXolFPFrdsYTuk2SB2YZRayy/IUyOvUuLA
        Ckx7OxnK8G+VQuyDDqx/DEVdVJWWZ0ddx
X-Received: by 2002:a05:620a:40c2:b0:6a0:2b1b:2b86 with SMTP id g2-20020a05620a40c200b006a02b1b2b86mr17543581qko.80.1652815993405;
        Tue, 17 May 2022 12:33:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyErJA1QMczBYTs9gR2mpRT35GolnnXP55O3949L3bTONuRk5dupXTRdiVJjTkve0f85GDa08PrMhPUDoaknLI=
X-Received: by 2002:a05:620a:40c2:b0:6a0:2b1b:2b86 with SMTP id
 g2-20020a05620a40c200b006a02b1b2b86mr17543569qko.80.1652815993241; Tue, 17
 May 2022 12:33:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220516215638.1787257-1-kuba@kernel.org> <8e9f1b04-d17b-2812-22bb-e62b5560aa6e@gmail.com>
In-Reply-To: <8e9f1b04-d17b-2812-22bb-e62b5560aa6e@gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 17 May 2022 15:33:02 -0400
Message-ID: <CAK-6q+jRDMDGbNS2JkTXmW2dp6D7mGzZ6ghrjf7m-wp7Xo9weQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ifdefy the wireless pointers in struct net_device
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        edumazet@google.com, Paolo Abeni <pabeni@redhat.com>,
        johannes@sipsolutions.net, Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, linux-wireless@vger.kernel.org,
        linux-wpan - ML <linux-wpan@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, May 16, 2022 at 10:13 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/16/2022 2:56 PM, Jakub Kicinski wrote:
> > Most protocol-specific pointers in struct net_device are under
> > a respective ifdef. Wireless is the notable exception. Since
> > there's a sizable number of custom-built kernels for datacenter
> > workloads which don't build wireless it seems reasonable to
> > ifdefy those pointers as well.
> >
> > While at it move IPv4 and IPv6 pointers up, those are special
> > for obvious reasons.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>
> Could not we move to an union of pointers in the future since in many
> cases a network device can only have one of those pointers at any given
> time?

note that ieee802154 has also functionality like __dev_get_by_index()
and checks via "if (netdev->ieee802154_ptr)" if it's a wpan interface
or not, guess the solution would be like it's done in wireless then.

- Alex

