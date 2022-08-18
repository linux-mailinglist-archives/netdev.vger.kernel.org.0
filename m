Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5705AF9AA
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 04:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiIGCCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 22:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIGCCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 22:02:16 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945858E45C;
        Tue,  6 Sep 2022 19:02:15 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id iw17so6421494plb.0;
        Tue, 06 Sep 2022 19:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Jwpb3CZaX0bMWLoqG62o2gobYjHtSytkFeKeRqFEhrY=;
        b=QKiwhfzXFGTWU+koGlbakEy4hnfAjf2RRPKehip8lIbi1F+bGTjEW5yJnv3JElHfJZ
         MZc5P6QJsQAb/vuQUbDR4Rv7Z9d50pIQIvmXAN28w4MpkfCu6Wbf7LHzcB5SGFTzjFoW
         w4D5n14fxADlWX+ExPNuzu9pgf49j8ewU7Q3LpzVTugHDVpbNNT6BVl8C3vwvvZUnA9u
         n6sKqNth8Cv7/WXx7LTPMlKFZR4vSssT0ZJOEZ3dwTPeYoINlRzsf2L0qBKkLOOnbGDl
         QXcmkK6n8hOoab/BIziBpSIvpPjoeaNEbROWDYhTc/RwQasBqOdX8YkAMJrvDZFEYOBX
         7LQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Jwpb3CZaX0bMWLoqG62o2gobYjHtSytkFeKeRqFEhrY=;
        b=DbhXrxVj4dW89WwOETI0Q7UeRBEdU8FX7L1QTe+Y7GPnZCf4Ij8rwoQyTd4yYancfH
         0Tz8Rp6+rU1V/0NSDbByc8WSloYkChKlaxyGaSusxyqLFTCSPcSNxc2fkoTDrJKcVmrr
         DB1soFYXwUGnM9VzysYhCj9aUXDpS6BhBq76nHrjuysPc7e/AeFySf9r7X7JdwdhhL6V
         jsPMhHQISQ+uUZnwbUw5QUextnBuY3n1jYeBjLadRW276A3yZKpnJ9fW3ZPptrpbrmuy
         S0vgqUbSwNtBUMw/tylwP5puetX59JlfTUMlJKFJxHBC5GoibrK1THEuw1anURg/x/6d
         Nomw==
X-Gm-Message-State: ACgBeo3dKyBZshojwDzDfnToBScZ4Odx7chcdKel7tPqP6sgBfVPU7x6
        Wg97ZgSxIUWoYunaYF1MUv4=
X-Google-Smtp-Source: AA6agR7H+bk1DuR8iBTTcyXMcZqKoOEh+Br0mw78q71U+dGZKIgxgvmo8IgUtWIxojqM4EEQDz7XjA==
X-Received: by 2002:a17:903:1c4:b0:176:e348:c386 with SMTP id e4-20020a17090301c400b00176e348c386mr1404659plh.3.1662516134925;
        Tue, 06 Sep 2022 19:02:14 -0700 (PDT)
Received: from localhost (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id o7-20020a656a47000000b004308422060csm8975063pgu.69.2022.09.06.19.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 19:02:14 -0700 (PDT)
Date:   Thu, 18 Aug 2022 14:39:32 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 0/6] virtio/vsock: introduce dgrams, sk_buff, and qdisc
Message-ID: <Yv5PFz1YrSk8jxzY@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <YxdKiUzlfpHs3h3q@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxdKiUzlfpHs3h3q@fedora>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 09:26:33AM -0400, Stefan Hajnoczi wrote:
> Hi Bobby,
> If you are attending Linux Foundation conferences in Dublin, Ireland
> next week (Linux Plumbers Conference, Open Source Summit Europe, KVM
> Forum, ContainerCon Europe, CloudOpen Europe, etc) then you could meet
> Stefano Garzarella and others to discuss this patch series.
> 
> Using netdev and sk_buff is a big change to vsock. Discussing your
> requirements and the future direction of vsock in person could help.
> 
> If you won't be in Dublin, don't worry. You can schedule a video call if
> you feel it would be helpful to discuss these topics.
> 
> Stefan

Hey Stefan,

That sounds like a great idea! I was unable to make the Dublin trip work
so I think a video call would be best, of course if okay with everyone.

Thanks,
Bobby
