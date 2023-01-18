Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65FA674269
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjASTL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjASTLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:11:31 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36334A23F;
        Thu, 19 Jan 2023 11:10:51 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id s13-20020a17090a6e4d00b0022900843652so6806121pjm.1;
        Thu, 19 Jan 2023 11:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rmw0FrJMdZRJWNjxjWooFZkXRzw3BBeJgu/Q5Wf70sI=;
        b=Gq++Xgp2SEWZZiWi1UhYomHWADBM278cMA4J9Dqp7KNyhArkb+R1Pdv0Y3ZEb/cDbh
         X10EcXwl8UYcaSIH4ac2q7Q6I2VZfHRdb0bEDxLxDAG6kFN6/WF6l2TcI3ZYvh3QSq8u
         hgRjPMwumNddA1MAoNOJZWngltzIzNtWUSf2I8KVDsNt2lnw6/tbljsjps0ynI/UMYzZ
         goMh5ppRmpaJ64GDGYjEZKRojhBhe2HbVTr/0v8IuKECdvm9Z3fa+I8L8OJUUCpjikeA
         87XW9jPe9FEJhgTwchSJUnTQCLGgzlPl6TGDL0w/JeB1fogcxrOu8fjWbMC55qsaWrT5
         sLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rmw0FrJMdZRJWNjxjWooFZkXRzw3BBeJgu/Q5Wf70sI=;
        b=NdlDwKdXaXtqWOG/sleD1FU+qKWqSJAIdQOqI6FjaD6ynFYi1NAnz36AnqH7Z0enWg
         LPHRADnYmXp/gIzgUFk1b1H4DcofIs39zn7S43cjhrG+Zimmkp/GLGxd7uuwAh5J+Gj6
         K6mMV+NRBoU9lpI1tCHIKZ/DYnW0ertpvEoJvLWMwZJlfiIlhc4fwYN6Q3Pk+FEyfQLN
         TsNesI5+suzq68m0ghmx04cxrSsxHzz6GJlEt1v9LdWT1jzf9IKXyJcI9Ya7mGtVAT42
         RtDNkOg2K9k3ucRYeiqUGitrg/CtvLiuLzkpgOFY9vROqAqSLFG91XNy2MUOL0akpBBb
         aflQ==
X-Gm-Message-State: AFqh2kpC5h99VFRjCtAIwPN1lQ9XmO50ANfpKIRQJyYSdOEAFfPK+dcK
        Ljhm9NeeaEt/lxf6DtKMNSw=
X-Google-Smtp-Source: AMrXdXtRxnLiwxQSlfYYRk7tyFPzrOsFJQVL6xcrKnohTHx07CuudK0o5Nm5re6PKL+uHGAbkLHsSQ==
X-Received: by 2002:a17:903:25cf:b0:192:f500:e831 with SMTP id jc15-20020a17090325cf00b00192f500e831mr11413620plb.8.1674155373969;
        Thu, 19 Jan 2023 11:09:33 -0800 (PST)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id s14-20020a170902ea0e00b001926bff074fsm25392583plg.276.2023.01.19.11.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 11:09:33 -0800 (PST)
Date:   Wed, 18 Jan 2023 15:10:16 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Song Liu <song@kernel.org>, Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Paolo Abeni <pabeni@redhat.com>,
        KP Singh <kpsingh@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, Hao Luo <haoluo@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH RFC 0/3] vsock: add support for sockmap
Message-ID: <Y8gL2PjGZltS1Zqg@bullseye>
References: <20230118-support-vsock-sockmap-connectible-v1-0-d47e6294827b@bytedance.com>
 <20230119104902.jxst4eblcuyjvums@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119104902.jxst4eblcuyjvums@sgarzare-redhat>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 11:49:02AM +0100, Stefano Garzarella wrote:
> Hi Bobby,
> 
> On Wed, Jan 18, 2023 at 12:27:39PM -0800, Bobby Eshleman wrote:
> > Add support for sockmap to vsock.
> > 
> > We're testing usage of vsock as a way to redirect guest-local UDS requests to
> > the host and this patch series greatly improves the performance of such a
> > setup.
> > 
> > Compared to copying packets via userspace, this improves throughput by 221% in
> > basic testing.
> 
> Cool, nice series!
> 
> > 
> > Tested as follows.
> > 
> > Setup: guest unix dgram sender -> guest vsock redirector -> host vsock server
> > Threads: 1
> > Payload: 64k
> > No sockmap:
> > - 76.3 MB/s
> > - The guest vsock redirector was
> >  "socat VSOCK-CONNECT:2:1234 UNIX-RECV:/path/to/sock"
> > Using sockmap (this patch):
> > - 168.8 MB/s (+221%)
> 
> Assuming the absolute value is correct, there is a typo here, it would be
> +121% right?
> 

Lol, yes.

> > - The guest redirector was a simple sockmap echo server,
> >  redirecting unix ingress to vsock 2:1234 egress.
> > - Same sender and server programs
> > 
> > Only the virtio transport has been tested.
> 
> I think is fine for now.
> 
> > The loopback transport was used in
> > writing bpf/selftests, but not thoroughly tested otherwise.
> 
> I did a quick review mainly for vsock stuff.
> Hoping others can take a better look at net/vmw_vsock/vsock_bpf.c, since I'm
> not very familiar with that subsystem.
> 
> FYI I will be off the next two weeks (till Feb 7) with limited internet
> access.
> 

Roger that.

Thanks,
Bobby

> Thanks,
> Stefano
> 
> > 
> > This series requires the skb patch.
> > 
> > To: Stefan Hajnoczi <stefanha@redhat.com>
> > To: Stefano Garzarella <sgarzare@redhat.com>
> > To: "Michael S. Tsirkin" <mst@redhat.com>
> > To: Jason Wang <jasowang@redhat.com>
> > To: "David S. Miller" <davem@davemloft.net>
> > To: Eric Dumazet <edumazet@google.com>
> > To: Jakub Kicinski <kuba@kernel.org>
> > To: Paolo Abeni <pabeni@redhat.com>
> > To: Andrii Nakryiko <andrii@kernel.org>
> > To: Mykola Lysenko <mykolal@fb.com>
> > To: Alexei Starovoitov <ast@kernel.org>
> > To: Daniel Borkmann <daniel@iogearbox.net>
> > To: Martin KaFai Lau <martin.lau@linux.dev>
> > To: Song Liu <song@kernel.org>
> > To: Yonghong Song <yhs@fb.com>
> > To: John Fastabend <john.fastabend@gmail.com>
> > To: KP Singh <kpsingh@kernel.org>
> > To: Stanislav Fomichev <sdf@google.com>
> > To: Hao Luo <haoluo@google.com>
> > To: Jiri Olsa <jolsa@kernel.org>
> > To: Shuah Khan <shuah@kernel.org>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: virtualization@lists.linux-foundation.org
> > Cc: netdev@vger.kernel.org
> > Cc: bpf@vger.kernel.org
> > Cc: linux-kselftest@vger.kernel.org
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > 
> > ---
> > Bobby Eshleman (3):
> >      vsock: support sockmap
> >      selftests/bpf: add vsock to vmtest.sh
> >      selftests/bpf: Add a test case for vsock sockmap
> > 
> > drivers/vhost/vsock.c                              |   1 +
> > include/linux/virtio_vsock.h                       |   1 +
> > include/net/af_vsock.h                             |  17 ++
> > net/vmw_vsock/Makefile                             |   1 +
> > net/vmw_vsock/af_vsock.c                           |  59 ++++++-
> > net/vmw_vsock/virtio_transport.c                   |   2 +
> > net/vmw_vsock/virtio_transport_common.c            |  22 +++
> > net/vmw_vsock/vsock_bpf.c                          | 180 +++++++++++++++++++++
> > net/vmw_vsock/vsock_loopback.c                     |   2 +
> > tools/testing/selftests/bpf/config.x86_64          |   4 +
> > .../selftests/bpf/prog_tests/sockmap_listen.c      | 163 +++++++++++++++++++
> > tools/testing/selftests/bpf/vmtest.sh              |   1 +
> > 12 files changed, 447 insertions(+), 6 deletions(-)
> > ---
> > base-commit: f12f4326c6a75a74e908714be6d2f0e2f0fd0d76
> > change-id: 20230118-support-vsock-sockmap-connectible-2e1297d2111a
> > 
> > Best regards,
> > -- 
> > Bobby Eshleman <bobby.eshleman@bytedance.com>
> > 
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
