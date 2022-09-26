Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A7D5EB367
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 23:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiIZVoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 17:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiIZVoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 17:44:37 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706EDE3A;
        Mon, 26 Sep 2022 14:44:31 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id s90-20020a17090a2f6300b00203a685a1aaso8281776pjd.1;
        Mon, 26 Sep 2022 14:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=+MXwLksTtCK5iCxRh+qzDfrMn1HKYCME03rNY5MPuX4=;
        b=XRJmD7By+SLkgrM3+q32fwbodVwhfnEMJmCpwHDOoihQRWaG8YXv+0sOSziP8xOKLo
         2WJ7hG2qq+NkXrmhKS4RZjgwpC6WJBuuZiVNUwyfPSEWPc3EzcjLr8cXu5+vAJNWACbc
         pRwSJ7jPMW3lWM2LfRA0Mi9MyNDpyLZmHqKUIorhWHOKYh4URnA7TlilmLTPoR5Nj7sD
         IXLjQvW3pGDfZOG9qb94F56o0dYRSnVj9erwMlVKpi5IiGtgAhk9UY2HxfXJTJgvpO2K
         50GNghXJZ2tQJxmD9hYAL3KNd5JuztFbpGJAROsgjWnwHbQ+BBYHyRNwLM/2ObXO47ME
         LdLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=+MXwLksTtCK5iCxRh+qzDfrMn1HKYCME03rNY5MPuX4=;
        b=LhacWtYoJ5lLWaNyh+GgwKcxyAqV3rwJrDxYkYZlZUJGxKDZgLnIUuplZh5gnocebr
         I1HAx32fHbidfBws3CdiF+7UxrxhDEZM21UMaKFEP1h9hRS2zPc6UNzn3MxPyxe6INoZ
         DON+siK/UoZhyagOdty/yHASdp7sJUgUstZbWMU/hjUYbOko75cCwD/ija6KfLSfsTvS
         TbOVynlQlZoFet0OFfnE84RSejgEkZqsxmoNyFfDQaexSj8lgyQN/q4htjsm6X3q9brp
         Y5x8n9EsNROvSOqnlo0hCLig3Md7FptqFUMTxT+4sUgotVzqpv6cLbcKO5edmieEAO03
         YNdQ==
X-Gm-Message-State: ACrzQf3rHHqTsE+D7ohIwMm55n/BT8Lx4AfzLNQJ1mG9mRHoIoVJgC/W
        xzQE4K881v9GwwnMQYO2FpW6tufRAWkPBcDpl9A=
X-Google-Smtp-Source: AMsMyM4N9N+Q11yxesDny8GymJSHVtk6CVMHlmbURTjglT6Coc5S7wO3MWj2pUsxpmR8L8WvIhnG6Q==
X-Received: by 2002:a17:902:e750:b0:176:b0fb:9683 with SMTP id p16-20020a170902e75000b00176b0fb9683mr24487911plf.71.1664228670849;
        Mon, 26 Sep 2022 14:44:30 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id p18-20020a631e52000000b004393f60db36sm11291764pgm.32.2022.09.26.14.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 14:44:30 -0700 (PDT)
Date:   Mon, 26 Sep 2022 21:44:29 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@gmail.com>,
        Wei Liu <wei.liu@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hyperv@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/6] virtio/vsock: introduce dgrams, sk_buff, and qdisc
Message-ID: <YzIdPWL1OWMjg6Ws@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <20220926134219.sreibsw2rfgw7625@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926134219.sreibsw2rfgw7625@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 03:42:19PM +0200, Stefano Garzarella wrote:
> Hi,
> 
> On Mon, Aug 15, 2022 at 10:56:03AM -0700, Bobby Eshleman wrote:
> > Hey everybody,
> > 
> > This series introduces datagrams, packet scheduling, and sk_buff usage
> > to virtio vsock.
> 
> Just a reminder for those who are interested, tomorrow Sep 27 @ 16:00 UTC we
> will discuss more about the next steps for this series in this room:
> https://meet.google.com/fxi-vuzr-jjb
> (I'll try to record it and take notes that we will share)
> 
> Bobby, thank you so much for working on this! It would be great to solve the
> fairness issue and support datagram!
>

I appreciate that, thanks!

> I took a look at the series, left some comments in the individual patches,
> and add some advice here that we could pick up tomorrow:
> - it would be nice to run benchmarks (e.g., iperf-vsock, uperf, etc.) to
>   see how much the changes cost (e.g. sk_buff use)
> - we should take care also of other transports (i.e. vmci, hyperv), the
> uAPI should be as close as possible regardless of the transport
>

Duly noted. I have some measurements with uperf, I'll put the data
together and send that out here.

Regarding the uAPI topic, I'll save that topic for our conversation
tomorrow as I think the netdev topic will weigh on it.

> About the use of netdev, it seems the most controversial point and I
> understand Jakub and Michael's concerns. Tomorrow would be great if you can
> update us if you have found any way to avoid it, just reusing a packet
> scheduler somehow.
> It would be great if we could make it available for all transports (I'm not
> asking you to implement it for all, but to have a generic api that others
> can use).
>
> But we can talk about that tomorrow!

Sounds good, talk to you then!

Best,
Bobby

