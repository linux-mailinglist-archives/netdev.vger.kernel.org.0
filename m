Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6FF668812
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 01:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbjAMAEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 19:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbjAMAEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 19:04:37 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5863F101E3;
        Thu, 12 Jan 2023 16:04:36 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id y5so15007626pfe.2;
        Thu, 12 Jan 2023 16:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vMn7hkK3bLSkDVAJzCnb41079ImalXSJzjCGEjodsqA=;
        b=b7Mhb6rCYs8+WWDA6jBKmxcZDYLgCfumHM3xZIhhReAKnBYHNU/9yaqb4YPs1F5fMh
         upBsRCFo6euITn7IcfNmcDX7gLzmqvQ7MVzWOYzSGFndXXptMwRKL9DtSzHI0ex9+Qvz
         xft0QSnl3flMHAhzR9ILbmZsBMYehM9wBk7uGTTd/zuVKILgxZXUlrnCkLzOwvJJmgMj
         jJIHkOc+J6B+jRFZL9rh6/cZqQdlxqCWNEiTCpqd4pniNoEMoykel/q6Nx46x4rJpc1I
         xh8NFIXl0Apout5eNBhbE5w+vOQdhyepcNNfpGj4WvP2Ef6RrxiXZp4m8VgGSv5LzS2/
         N1VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vMn7hkK3bLSkDVAJzCnb41079ImalXSJzjCGEjodsqA=;
        b=YurtN8U62NqIbagmep1f7/Ak2uzLoeQcqDMscuC8LoUpYAjyKFEnaMBD8515yyaqZ3
         klrWI+6JQ7m+EB1weKlcUeNukkvSm/0tC30QysDqeiP4rY+EbUSalmoowUNF2qxmHP/r
         nQZ6tbEKIiHUFeqkWL4wtR4jvqSvjYCcrUk0C2IOlF2Hp8/1IY8/YMAkNLyMp/7XEe2b
         cf9jW3HiQBtpp0ZumpzCx7XYq7GLXdERg5T8zh/HWPlGsf1Hx2YuNLxcpdHyl3C6Vuw7
         q2V+sjonF262DW0jlfD4631hVUw+Zw656nQw9gvTjIrN/cxsCFRKJU7ZCMIpo5AIQetu
         m19g==
X-Gm-Message-State: AFqh2kqIrMgEqMQM75ya4SUID92lgkEp7yoB1sAKYN6UR88OG3znrIGM
        FAwQGoJSEReGFC6focGv6IY=
X-Google-Smtp-Source: AMrXdXtoSVwx8a5QnSDfDdo6vZOtrGuGyhLOotfoZsEuv4hhzqBN6KwlHyhQPaAiSbZdkjr772MOgA==
X-Received: by 2002:aa7:9d92:0:b0:58a:aaa3:f72e with SMTP id f18-20020aa79d92000000b0058aaaa3f72emr8569284pfq.6.1673568275659;
        Thu, 12 Jan 2023 16:04:35 -0800 (PST)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id q20-20020aa79834000000b0058134d2df41sm11447068pfl.146.2023.01.12.16.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 16:04:35 -0800 (PST)
Date:   Thu, 22 Dec 2022 06:12:29 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v9] virtio/vsock: replace virtio_vsock_pkt with
 sk_buff
Message-ID: <Y6P1TawSu9xRIQMq@bullseye>
References: <20230107002937.899605-1-bobby.eshleman@bytedance.com>
 <91593e9c8a475a26a465369f6caff86ac5d662e3.camel@redhat.com>
 <5042e5c6e57a3f99895616c891512e482bf6ed28.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5042e5c6e57a3f99895616c891512e482bf6ed28.camel@redhat.com>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 03:45:32PM +0100, Paolo Abeni wrote:
> On Tue, 2023-01-10 at 09:36 +0100, Paolo Abeni wrote:
> > On Sat, 2023-01-07 at 00:29 +0000, Bobby Eshleman wrote:
> > > This commit changes virtio/vsock to use sk_buff instead of
> > > virtio_vsock_pkt. Beyond better conforming to other net code, using
> > > sk_buff allows vsock to use sk_buff-dependent features in the future
> > > (such as sockmap) and improves throughput.
> > > 
> > > This patch introduces the following performance changes:
> > > 
> > > Tool/Config: uperf w/ 64 threads, SOCK_STREAM
> > > Test Runs: 5, mean of results
> > > Before: commit 95ec6bce2a0b ("Merge branch 'net-ipa-more-endpoints'")
> > > 
> > > Test: 64KB, g2h
> > > Before: 21.63 Gb/s
> > > After: 25.59 Gb/s (+18%)
> > > 
> > > Test: 16B, g2h
> > > Before: 11.86 Mb/s
> > > After: 17.41 Mb/s (+46%)
> > > 
> > > Test: 64KB, h2g
> > > Before: 2.15 Gb/s
> > > After: 3.6 Gb/s (+67%)
> > > 
> > > Test: 16B, h2g
> > > Before: 14.38 Mb/s
> > > After: 18.43 Mb/s (+28%)
> > > 
> > > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > > Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> > > Acked-by: Paolo Abeni <pabeni@redhat.com>
> > > ---
> > > 
> > > Tested using vsock_test g2h and h2g.  I'm not sure if it is standard
> > > practice here to carry Acks and Reviews forward to future versions, but
> > > I'm doing that here to hopefully make life easier for maintainers.
> > > Please let me know if it is not standard practice.
> > 
> > As Jakub noted, there is no clear rule for tag passing across different
> > patch revisions.
> > 
> > Here, given the complexity of the patch and the not trivial list of
> > changes, I would have preferred you would have dropped my tag.
> > 
> > > Changes in v9:
> > > - check length in rx header
> > > - guard alloactor from small requests
> > > - squashed fix for v8 bug reported by syzbot:
> > >     syzbot+30b72abaa17c07fe39dd@syzkaller.appspotmail.com
> > 
> > It's not clear to me what/where is the fix exactly, could you please
> > clarify?
> 
> Reading the syzkaller report, it looks like iov_length() in
> vhost_vsock_alloc_pkt() can not be trusted to carry a reasonable value.
> 
> As such, don't you additionally need to ensure/check that iov_length()
> is greater or equal to sizeof(virtio_vsock_hdr) ?

Yep, the check is in virtio_vsock_alloc_skb() (a good central point that
both vhost/virtio call into), returning NULL and allocating nothing if
the size is nonsense.

Thanks,
Bobby
