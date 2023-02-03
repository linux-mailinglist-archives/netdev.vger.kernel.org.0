Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7629A68C32C
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 17:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjBFQ0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 11:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjBFQ0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 11:26:11 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FE922A10;
        Mon,  6 Feb 2023 08:26:05 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id bg10-20020a17090b0d8a00b00230c7f312d4so2491066pjb.3;
        Mon, 06 Feb 2023 08:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U4PuUge7HmVvSHLmT7HLFiMDhxJjx5FOHK8on78MzZU=;
        b=apFrYLiBmdyRCLAG9gSM5+zha9NJFk3kTW0bmaU2lZlqC4wcrUEQ/QZ1Z4B9elSfBc
         k3gvWGZNBRbC7AhWa/iftbnT9eRpZKkGESRlyRjwPtUW27LNw8hxZ+BbghvC63s8Qd/l
         bt4Rd9XhkL1hJHM8CNvgjY+kg2kPF7u9S23wo50lax8nvShQMvHzgUo4/MJzUTCzD/T1
         uT/zUR7trpf72ub0UIrdIPN693GFpqmP/TBim+CygzUnwXZZqxrwSOSWt8DEP3GrObYF
         AVKdcPOzoSYA7DsDwO2vuHvTY91ddP2eQJuxipnB6aH6JzkU+xltqTfs8onp50/6dhXH
         zRjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U4PuUge7HmVvSHLmT7HLFiMDhxJjx5FOHK8on78MzZU=;
        b=KkzzzdKojVXySBmEK0Z+J+2pF4Z8oY38yN/Zyh1l2uPvEospE4WPvT8rZ5Z6awqJtn
         AAG5TTwr3ho0hRJscp8AE3BBl0voOI1n/ALrBvcJHxt6NkQH6eiu3b8fDS/NXhEMznrn
         3HC/9pViRtGCtsXtKKVMrsHu85Og8NzFM0lys8LtsAZbxCgi8QEubnUoJHxYlc+untkI
         kMoo+K6LR51xiK5wf+h3YdnAqzKqVfVpmr/+cxxA6ae3WzVGiiUp0NI4wfhTmvgJQxO9
         f0asla7LB1yvCorh4n98RGB1W6UeykqelNiATzNmwubbH3bZMtoGKN3FWiv9exZFu5Wm
         2F4Q==
X-Gm-Message-State: AO0yUKXQkvt0ybsmHE6ZrDR/fFu1Xsui1fDW31rmVH9OMQFenkQN7ZqK
        I8gqP0yaBC6h+SzgtilSI7E=
X-Google-Smtp-Source: AK7set/gU0/qYHhMbpJCI3MdQrcgRDOaImjLmlyL71pJN0LwPBMjguFzjYsW3Ksfdc0YEJ9tO+CQMw==
X-Received: by 2002:a17:902:c702:b0:196:64bf:ed86 with SMTP id p2-20020a170902c70200b0019664bfed86mr16668694plp.62.1675700764448;
        Mon, 06 Feb 2023 08:26:04 -0800 (PST)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id p20-20020a170902ead400b0017a032d7ae4sm4496349pld.104.2023.02.06.08.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 08:26:03 -0800 (PST)
Date:   Fri, 3 Feb 2023 05:30:07 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, jakub@cloudflare.com,
        hdanton@sina.com, cong.wang@bytedance.com
Subject: Re: [PATCH RFC net-next v2 0/3] vsock: add support for sockmap
Message-ID: <Y9yb301OYUknwUlH@bullseye>
References: <20230118-support-vsock-sockmap-connectible-v2-0-58ffafde0965@bytedance.com>
 <Y+AM0VXW54YbvsRT@pop-os.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+AM0VXW54YbvsRT@pop-os.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 12:08:49PM -0800, Cong Wang wrote:
> On Mon, Jan 30, 2023 at 08:35:11PM -0800, Bobby Eshleman wrote:
> > Add support for sockmap to vsock.
> > 
> > We're testing usage of vsock as a way to redirect guest-local UDS requests to
> > the host and this patch series greatly improves the performance of such a
> > setup.
> > 
> > Compared to copying packets via userspace, this improves throughput by 121% in
> > basic testing.
> > 
> > Tested as follows.
> > 
> > Setup: guest unix dgram sender -> guest vsock redirector -> host vsock server
> > Threads: 1
> > Payload: 64k
> > No sockmap:
> > - 76.3 MB/s
> > - The guest vsock redirector was
> >   "socat VSOCK-CONNECT:2:1234 UNIX-RECV:/path/to/sock"
> > Using sockmap (this patch):
> > - 168.8 MB/s (+121%)
> > - The guest redirector was a simple sockmap echo server,
> >   redirecting unix ingress to vsock 2:1234 egress.
> > - Same sender and server programs
> > 
> > *Note: these numbers are from RFC v1
> > 
> > Only the virtio transport has been tested. The loopback transport was used in
> > writing bpf/selftests, but not thoroughly tested otherwise.
> > 
> > This series requires the skb patch.
> > 
> 
> Looks good to me. Definitely good to go as non-RFC.
> 
> Thanks.

Thank you for the review.

Best,
Bobby
