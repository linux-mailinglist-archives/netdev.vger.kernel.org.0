Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AA55FBF2E
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 04:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiJLC3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 22:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJLC3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 22:29:11 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E436A59AE;
        Tue, 11 Oct 2022 19:29:10 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id w2so15280097pfb.0;
        Tue, 11 Oct 2022 19:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DS+7UWTAKwi61a1gwOFyUAnc5rAX6eUV+RzoBUx0RU4=;
        b=kHHuKV38G60HU68ehpMQSGszVXMAawsfgDkJ4F/ZVSvNixw8yyBeVuGtoC7/smUMaV
         owrtPW8VIUxtwaiQsO34uyqIEPBxuNaxLNUC8h4ssWEkisPioLIgnmYFmahai3ROdkF5
         XGqoS6YeKyp0XTSSpFetcY4y8JJ/bS0N97K0u6Amnp3+tz6bv6QE4/38DntMxBO/LCpx
         rERYPTDgGEYZUhnfKwrTdnz41fMxdiGdFwWm5kFClijHTYB13wQpGPaw/0Rm4/iSaM9K
         BWMHCe6xs/JEimtYesa4Ih9cJCbj2+kWexoubxRJEEqMLE4U4b0md4lf0MGbBecZjZu5
         oTzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DS+7UWTAKwi61a1gwOFyUAnc5rAX6eUV+RzoBUx0RU4=;
        b=ruKJ9QXFKK3aIZXqbQQvCKQb4kK7AWaVoloaDmcH8h5ilvn5xxT9Bz3dLJw27f5WKl
         cFRzVK9EZw7Ba8R84KsZANjlDEfCZz45r33SZlEYJ1o9E1Z28eAyYr3CDM/DF7QEzYBc
         lU7D45M6qL0jE9Ubu8SkqB9rocSF1l5m5c3wzDVMpfVbLx7rtFoVdeb8s7Pk6eW33kaJ
         PdjYt8ci/ohx/uwU/bZsUhirOAyC6PMAKm6a05C3oonIrr13UQ3MKlaz8VqZVTL0tW2h
         u+8xyhG8XD+24I//7c05mCLnOSGcbjKHcxdgR2doR/0yQwzv+eXddLQKz4VOVmGao+cT
         3CZg==
X-Gm-Message-State: ACrzQf3/AkPPgufDm+tXYOILV7vV7oNpPf0TudjMUzpneoWlyVzXkLjd
        MPlMZ4neJcz/9OZyM5eNNCLAqQ/bvQUQBKTXhDc=
X-Google-Smtp-Source: AMsMyM7O/jfdqt4uTelbLRdHE64LQlNSBPTGDzRJqGbsbhOEHhqVa2CsmK0SSK6HctVqN6QuRNpvmw==
X-Received: by 2002:a63:f358:0:b0:43c:5e1:985 with SMTP id t24-20020a63f358000000b0043c05e10985mr23859199pgj.5.1665541749923;
        Tue, 11 Oct 2022 19:29:09 -0700 (PDT)
Received: from localhost (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902650500b001752216ca51sm9261734plk.39.2022.10.11.19.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 19:29:09 -0700 (PDT)
Date:   Mon, 3 Oct 2022 00:11:39 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vsock: replace virtio_vsock_pkt with sk_buff
Message-ID: <Yzoou4UwOv5lh0hE@bullseye>
References: <20221006011946.85130-1-bobby.eshleman@bytedance.com>
 <20221006025956-mutt-send-email-mst@kernel.org>
 <20221006073410.ahhqhlhah4lo47o7@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221006073410.ahhqhlhah4lo47o7@sgarzare-redhat>
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

On Thu, Oct 06, 2022 at 09:34:10AM +0200, Stefano Garzarella wrote:
> On Thu, Oct 06, 2022 at 03:08:12AM -0400, Michael S. Tsirkin wrote:
> > On Wed, Oct 05, 2022 at 06:19:44PM -0700, Bobby Eshleman wrote:
> > > This patch replaces the struct virtio_vsock_pkt with struct sk_buff.
> > > 
> > > Using sk_buff in vsock benefits it by a) allowing vsock to be extended
> > > for socket-related features like sockmap, b) vsock may in the future
> > > use other sk_buff-dependent kernel capabilities, and c) vsock shares
> > > commonality with other socket types.
> > > 
> > > This patch is taken from the original series found here:
> > > https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/
> > > 
> > > Small-sized packet throughput improved by ~5% (from 18.53 Mb/s to 19.51
> > > Mb/s). Tested using uperf, 16B payloads, 64 threads, 100s, averaged from
> > > 10 test runs (n=10). This improvement is likely due to packet merging.
> > > 
> > > Large-sized packet throughput decreases ~9% (from 27.25 Gb/s to 25.04
> > > Gb/s). Tested using uperf, 64KB payloads, 64 threads, 100s, averaged
> > > from 10 test runs (n=10).
> > > 
> > > Medium-sized packet throughput decreases ~5% (from 4.0 Gb/s to 3.81
> > > Gb/s). Tested using uperf, 4k to 8k payload sizes picked randomly
> > > according to normal distribution, 64 threads, 100s, averaged from 10
> > > test runs (n=10).
> > 
> > It is surprizing to me that the original vsock code managed to outperform
> > the new one, given that to my knowledge we did not focus on optimizing it.
> 
> Yeah mee to.
> 

Indeed.

> From this numbers maybe the allocation cost has been reduced as it performs
> better with small packets. But with medium to large packets we perform
> worse, perhaps because previously we were allocating a contiguous buffer up
> to 64k?
> Instead alloc_skb() could allocate non-contiguous pages ? (which would solve
> the problems we saw a few days ago)
> 

I think this would be the case with alloc_skb_with_frags(), but
internally alloc_skb() uses kmalloc() for the payload and sk_buff_head
slab allocations for the sk_buff itself (all the more confusing to me,
as the prior allocator also uses two separate allocations per packet).

> @Bobby Are these numbers for guest -> host communication? Can we try the
> reverse path as well?
> 

Yep, these are guest -> host. Unfortunately, the numbers are worse for
host to guest. Running the same tests, except for 100+ times instead of
just 10, for h2g sockets:

16B payload throughput decreases ~8%.
4K-8KB payload throughput decreases ~15%.
64KB payload throughput decreases ~8%.

I'm currently working on tracking down the root cause and seeing if
there is some way around the performance hit.

Sorry for the delayed response, it took a good minute to collect
enough data to feel confident I wasn't just seeing noise.

Best,
Bobby
