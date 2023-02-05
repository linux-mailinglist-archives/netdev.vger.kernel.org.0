Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6370768B17C
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 21:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjBEUIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 15:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBEUIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 15:08:53 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F321B57B;
        Sun,  5 Feb 2023 12:08:52 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id p185so8271886oif.2;
        Sun, 05 Feb 2023 12:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mvIsEYybWu8qfqSxC3SNCLsX1f2a8XyZ+ZzIZVE4ff4=;
        b=FS2o67HoQ50grlACqBfjs7akK7vkBfdkIAsLQBrgfFho3YlVqkzuQiU8aMyJ/zP+Jy
         XUBdMDKvT3wZ3rMjRslvmbaGHJovDP5ENMNjSr9wH42xMGvbJ/uLz7KWluzopcoxfFVm
         0TZH/l0YAHuKXRmysAGEcUWQoAnuSB+s9LLju7juPS14nRGqX2+O8+rzeOdHv4ttAmKk
         hAnWshRUkwKnwq3EegTYpaT6YEkv4puxnPDzWaXxQS8S/tdDsDzlcHH6Tl7AotBNRH1k
         BxZPmNrqrwMUcD8tTD7ohxg1242rPv22vcXHE3CyRywCuhye1qQ9x0xQuUQj2ig17voH
         kTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mvIsEYybWu8qfqSxC3SNCLsX1f2a8XyZ+ZzIZVE4ff4=;
        b=juQ4CfdESwh5htRvPy9wyp1FSgWksXbdr4pfrBz/pp58zhLYu0/nbavrmAH26oB3mv
         U/YqOxxGE8XK1uDjeC6K2zOABjkGPJL5Czwj6/g+x36Bxl4kc409y5/BFGfpQP+YyTi3
         S4wOEcLmSlwM47n7Qn9oOaUqkAoOL2CH5Eh2Wi/FOFK3IXYkTRLE0bBkKrCwRdlk6AXO
         EwiJznEQy8qpQhA/65s6lFkl3fBcDsORsF00jvmpALxhuD0Tk5YG7pHIxV7f8yifOopr
         ggcWHoIwKZ2ugHcWbAdnOG/Hlh9B+hb/WQt1K7AawTJluVNLgcSyPn8yk8IgpibkGgQo
         d/ew==
X-Gm-Message-State: AO0yUKWZ/VQCBIHNCY+qqEnG8GayMSp4fG9NpZnwOqhPhnhW5CyXqbSs
        Y1z9AKNZMJXpvv5xQniWU0g=
X-Google-Smtp-Source: AK7set+eadtPZR2CC0SGrwp/7LLhs+kYqtEHVr0BtVMqUjTJF8NaoOWH6viBDXx/H5BrXYXlb+/6aA==
X-Received: by 2002:a05:6808:a07:b0:378:2df5:49f5 with SMTP id n7-20020a0568080a0700b003782df549f5mr7983074oij.2.1675627731912;
        Sun, 05 Feb 2023 12:08:51 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:a80b:31f2:24c8:7c9a])
        by smtp.gmail.com with ESMTPSA id g17-20020a9d6c51000000b0068d59d15a93sm4005797otq.40.2023.02.05.12.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Feb 2023 12:08:50 -0800 (PST)
Date:   Sun, 5 Feb 2023 12:08:49 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
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
        Shuah Khan <shuah@kernel.org>,
        Bobby Eshleman <bobbyeshleman@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jakub@cloudflare.com, hdanton@sina.com, cong.wang@bytedance.com
Subject: Re: [PATCH RFC net-next v2 0/3] vsock: add support for sockmap
Message-ID: <Y+AM0VXW54YbvsRT@pop-os.localdomain>
References: <20230118-support-vsock-sockmap-connectible-v2-0-58ffafde0965@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118-support-vsock-sockmap-connectible-v2-0-58ffafde0965@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 08:35:11PM -0800, Bobby Eshleman wrote:
> Add support for sockmap to vsock.
> 
> We're testing usage of vsock as a way to redirect guest-local UDS requests to
> the host and this patch series greatly improves the performance of such a
> setup.
> 
> Compared to copying packets via userspace, this improves throughput by 121% in
> basic testing.
> 
> Tested as follows.
> 
> Setup: guest unix dgram sender -> guest vsock redirector -> host vsock server
> Threads: 1
> Payload: 64k
> No sockmap:
> - 76.3 MB/s
> - The guest vsock redirector was
>   "socat VSOCK-CONNECT:2:1234 UNIX-RECV:/path/to/sock"
> Using sockmap (this patch):
> - 168.8 MB/s (+121%)
> - The guest redirector was a simple sockmap echo server,
>   redirecting unix ingress to vsock 2:1234 egress.
> - Same sender and server programs
> 
> *Note: these numbers are from RFC v1
> 
> Only the virtio transport has been tested. The loopback transport was used in
> writing bpf/selftests, but not thoroughly tested otherwise.
> 
> This series requires the skb patch.
> 

Looks good to me. Definitely good to go as non-RFC.

Thanks.
