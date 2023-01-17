Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6E9670E4D
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 01:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjARAAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 19:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjARAAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 19:00:22 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F4723304;
        Tue, 17 Jan 2023 15:14:46 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 127so7536859pfe.4;
        Tue, 17 Jan 2023 15:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xYYclJT0SRDfx3j8T+Q0suM7DxwMbnZVfV94sfe2l/Q=;
        b=SUGzEMXa0jJdEwFho5rOpwE6/0R8GdrrgHWuJ9A1SrVwo77Hm3LTMmEb9SEudLh8Vl
         /PzoC5ZdwJBap1nOWNR9fwyuVyVfUtPNjJ1xqesNmhIPl2n741WqCP891qVps8pR771i
         jlcTzyQG9GLGcc+1IdjZpqQuF7qa+qCEuAd+8c8VA6FhYh5k+5zRE8Un0G3Zkd263osf
         ejBQthbTJSE4AsyTQ8SfjlBqabcl0D0R0YbOudEw1v6QXBLDy+lAQsBnd0O/WJe8F25Q
         kqP/KwLHw3TdMoHU+Pu2+wS3+0D0w5BxqSnXnMW5GdPQQScGDJi0wcedNHPdein62LSj
         o9Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xYYclJT0SRDfx3j8T+Q0suM7DxwMbnZVfV94sfe2l/Q=;
        b=Qg8gmOedMZ1zppRSfQEBYqMtZuvzn8Erttv0UQ0XSs+DFv0rfzI7Qt9bo8knevBHyS
         KgCnERthijW1crCBKm6rEADQalusKpciVwzUvY5PcKOh8x32Z7jhZPP+EXyZFT+sSemg
         677DAguRZEJ+JLu1wz28v8URiOay8ztSekjM//8djcSFRrm1fH16pWPxVLScJlSkXeVa
         ps7UiCCxgytG72j4pd/wTlZplbKjwJAtrbaszQUQLV4c6xmvAM0wIkHtlX52ednfXcFe
         V47GpNUyGJm6URxUl6qjcvckc/wIkKVyV6zDI6igyXoa8Izh8CkwLPxwcX+rp86WzcU1
         qqZg==
X-Gm-Message-State: AFqh2krQMwyF5tfn2xuk9TdB2iQ563aDH6zwnF9Mcsn7exV5niDFdhkn
        BwIobZjwFGR0Gpz60ehLjzMtv6h6G9JQbw==
X-Google-Smtp-Source: AMrXdXvOL5Zurqa1giRr2W+k4fK1YThD3bN38NPuR85GBFd2A050lb3UL4kQDBziA5MMZRUaGpH0Sw==
X-Received: by 2002:a62:5341:0:b0:57f:c170:dc6 with SMTP id h62-20020a625341000000b0057fc1700dc6mr4178981pfb.14.1673997286354;
        Tue, 17 Jan 2023 15:14:46 -0800 (PST)
Received: from localhost (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id z30-20020aa7991e000000b005898fcb7c2bsm16244841pff.170.2023.01.17.15.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 15:14:45 -0800 (PST)
Date:   Tue, 17 Jan 2023 23:14:44 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v10] virtio/vsock: replace virtio_vsock_pkt with
 sk_buff
Message-ID: <Y8cr5KosN5kZaOgK@bullseye>
References: <20230113222137.2490173-1-bobby.eshleman@bytedance.com>
 <20230116111207.yxlwh4jlejtn4ple@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116111207.yxlwh4jlejtn4ple@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 12:12:07PM +0100, Stefano Garzarella wrote:
> On Fri, Jan 13, 2023 at 10:21:37PM +0000, Bobby Eshleman wrote:
> > This commit changes virtio/vsock to use sk_buff instead of
> > virtio_vsock_pkt. Beyond better conforming to other net code, using
> > sk_buff allows vsock to use sk_buff-dependent features in the future
> > (such as sockmap) and improves throughput.
> > 
> > This patch introduces the following performance changes:
> > 
> > Tool: Uperf
> > Env: Phys Host + L1 Guest
> > Payload: 64k
> > Threads: 16
> > Test Runs: 10
> > Type: SOCK_STREAM
> > Before: commit b7bfaa761d760 ("Linux 6.2-rc3")
> > 
> > Before
> > ------
> > g2h: 16.77Gb/s
> > h2g: 10.56Gb/s
> > 
> > After
> > -----
> > g2h: 21.04Gb/s
> > h2g: 10.76Gb/s
> > 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > 
> > ---
> > Changes in v10:
> > - vhost/vsock: use virtio_vsock_skb_dequeue()
> > - vhost/vsock: remove extra iov_length() call
> > - vhost/vsock: also consider hdr when evaluating that incoming size is
> >  valid
> > - new uperf data
> 
> Tests seem fine!
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thank you for all of the reviews and testing!

Best,
Bobby
