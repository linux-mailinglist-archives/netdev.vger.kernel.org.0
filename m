Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130654B3795
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 20:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiBLTN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 14:13:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiBLTN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 14:13:59 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A503DA4;
        Sat, 12 Feb 2022 11:13:55 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id c7-20020a4ad207000000b002e7ab4185d2so14425669oos.6;
        Sat, 12 Feb 2022 11:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cIzVGyOr678v0APwaWW4Q5osWVvtaj8na4NTqSDdzd8=;
        b=GFjDmK1kmi0t3Phv3LVHxrDdtYWnn2XE4yp1aQgNg/UuBIcnMu+8biytANJ4Ppq7kG
         zShrClz7BTQdR6ibQZxMTH/3qm5vEd60bHWZDa2aZSZ4AGt0jQI4kihLxOhA7IFJm5Cv
         nHjvwz1j51u2qMmNEZAOawp8Wu2nfdBl/lgbPrwGnLwb4IRVUuXeHvbiXb+zCHbL5vHa
         N06cIS+a1CL24qUHkKdIHjayvSYTHWPitlwWZ/FtPVxeZsceh01WO3uOdah7T04SHs+w
         4ewBzuTTzdw8mAn7WyvnlqYBewZDVJcO768xiB2hBl3Js/0Dm4a1Auqe4iV4CZ72NPPk
         rGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cIzVGyOr678v0APwaWW4Q5osWVvtaj8na4NTqSDdzd8=;
        b=zo0i0BJ5Aeos59aHFR8JwAaG7gPAg8L5SWAg59m0kzr0GqZMhIA1IRRvUilpaYW5wB
         GpSOxwbburCgcgWp6hSROmEsAkhPVH5cIc0ldswzkBr+3wbWX+0cel6Yx5u/fZQTFjBj
         TNljxC/2nNWetVQNFF1BfAznv6GDnSJeHLluGflOIPGSHWJ/8e7CbSHKuwKTGDEobC3Y
         PzMFkA3C2148DbNeDlIlKQRBt6P2aey1XHrX9ZWaLUrH6bf6o4wGn33IfeXZ1GXGlaac
         jFDaVc6YX8UpMbtf6Y1f8SYD2l/6lSEsECcfew59cTFMaiL4TioWHpWnAuvU9i/J7YBq
         X5Bg==
X-Gm-Message-State: AOAM533IzVnr2XY3J7Th9n2m1tElufO0+iZGDPyB6eD9rp8rNz2QpybX
        tnJYB8GfZ8pETChRP2x6knzmhDy3pzM=
X-Google-Smtp-Source: ABdhPJxN+W4vBf3Ru3CfF2A++quobOgMOiZGa5LgGsVRWcSuNR0z4miGzYdlLmfe2ZZf7vX9iX/x9w==
X-Received: by 2002:a05:6870:3655:: with SMTP id v21mr1780506oak.302.1644693234963;
        Sat, 12 Feb 2022 11:13:54 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:f984:a220:5d0c:99f9])
        by smtp.gmail.com with ESMTPSA id s13sm10886822ooh.43.2022.02.12.11.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Feb 2022 11:13:54 -0800 (PST)
Date:   Sat, 12 Feb 2022 11:13:53 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v4 net-next 1/8] net: Add skb->mono_delivery_time to
 distinguish mono delivery_time from (rcv) timestamp
Message-ID: <YggG8U9lBD37umyl@pop-os.localdomain>
References: <20220211071232.885225-1-kafai@fb.com>
 <20220211071238.885669-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211071238.885669-1-kafai@fb.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 11:12:38PM -0800, Martin KaFai Lau wrote:
> skb->tstamp was first used as the (rcv) timestamp.
> The major usage is to report it to the user (e.g. SO_TIMESTAMP).
> 
> Later, skb->tstamp is also set as the (future) delivery_time (e.g. EDT in TCP)
> during egress and used by the qdisc (e.g. sch_fq) to make decision on when
> the skb can be passed to the dev.
> 
> Currently, there is no way to tell skb->tstamp having the (rcv) timestamp
> or the delivery_time, so it is always reset to 0 whenever forwarded
> between egress and ingress.
> 
> While it makes sense to always clear the (rcv) timestamp in skb->tstamp
> to avoid confusing sch_fq that expects the delivery_time, it is a
> performance issue [0] to clear the delivery_time if the skb finally
> egress to a fq@phy-dev.  For example, when forwarding from egress to
> ingress and then finally back to egress:
> 
>             tcp-sender => veth@netns => veth@hostns => fq@eth0@hostns
>                                      ^              ^
>                                      reset          rest
> 
> This patch adds one bit skb->mono_delivery_time to flag the skb->tstamp
> is storing the mono delivery_time (EDT) instead of the (rcv) timestamp.
> 
> The current use case is to keep the TCP mono delivery_time (EDT) and
> to be used with sch_fq.  A later patch will also allow tc-bpf@ingress
> to read and change the mono delivery_time.

Can you be more specific? How is the fq in the hostns even visible to
container ns? More importantly, why the packets are always going out from
container to eth0?

From the sender's point of view, it can't see the hostns and can't event
know whether the packets are routed to eth0 or other containers on the
same host. So I don't see how this makes sense.

Crossing netns is pretty much like delivering on wire, *generally speaking*
if the skb meta data is not preserved on wire, it probably should not for
crossing netns either.

Thanks.
