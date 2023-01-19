Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259EB676B22
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 06:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjAVFDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 00:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjAVFDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 00:03:18 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A2118A97;
        Sat, 21 Jan 2023 21:03:17 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id d10so6820078pgm.13;
        Sat, 21 Jan 2023 21:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1rPxEawLgI/tGMgZXoPPdkllAiNZ4imDQSRKldW+0Tg=;
        b=ZmJe4uoWdrrnu2t0uTnKxkUzdqQIQCbXavzLn5Cckr5wQAN/XNChg6QUa3fC3gqvec
         ZmffyDkvxjsGFn8lwh7w0D2Wqa4wOTLJ6so7CRqVkI/3oPrMWiS7YDk5EU6RD4IAiARw
         WO/6KN+/Y/+1/1XOkM5/8yvgltDyHbcAUSDgyZ51d5H+evuJC7n6s0N4/gWuEGKZljYU
         H6dofb3q0KXwc6iZhZDP6IDfiBZBIgK26cERQryQo/3ttWk3pnyh+th3liOs7N1HT3VD
         exVu0cfFBrJAXSXqMGAtUNVm3cISNCjmI7HSrQfjXbsnybNZsh9PGCBXdD+eQ//CEweb
         FHZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1rPxEawLgI/tGMgZXoPPdkllAiNZ4imDQSRKldW+0Tg=;
        b=sqw+lnym3lFQ9Ah61wyFTZCX0rkzG/rnxetzqwy//eaPst26fiyS3Nc04gzf0b9zrD
         U0PBKDgd+wvSFDR1NebN+TqB9vYQwi11Bdj5LEkgE0XdU0m8qvFH4HU6MhPnh6v1hgNp
         u19AJBQW95I8Im8ow/9oc/d2tGgMQvEIArwxVQe4PmfXRGiM2hvgGcSe9r2PGvSgnLPU
         VGXCLJsOlSHVv/DDhhyYxmLIq8VlCmoyidl97YbyfQMauPhzY8l7/K+q4AZbGzFzwll7
         j8y53BUPmpu5nqrYH+KcHdvdeiXdzBDwUnVSRAoXLiYSElx0e2hESzrTvebf/1sjVhpx
         dTag==
X-Gm-Message-State: AFqh2kowCwCDW+73unZOIU1Bhbf2n3DapW1pTkezp+YG0aNMA9G/7Ylk
        DbnpWMRumHH0z7I7ONTLr94=
X-Google-Smtp-Source: AMrXdXu31CyeCOIYHJy4PMa+lMnTUCPNOOCVGdySsvrNk+I6w/8v5j3J3q9D4DHiL0qBs7XWzHuMxg==
X-Received: by 2002:a05:6a00:4519:b0:58d:f047:53b7 with SMTP id cw25-20020a056a00451900b0058df04753b7mr14535557pfb.3.1674363796900;
        Sat, 21 Jan 2023 21:03:16 -0800 (PST)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id h11-20020a056a00000b00b0058dd9c46a8csm9062788pfk.64.2023.01.21.21.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jan 2023 21:03:16 -0800 (PST)
Date:   Thu, 19 Jan 2023 03:47:02 +0000
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
        linux-kselftest@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH RFC 1/3] vsock: support sockmap
Message-ID: <Y8i9NlRpIR/KE/q2@bullseye>
References: <20230118-support-vsock-sockmap-connectible-v1-0-d47e6294827b@bytedance.com>
 <20230118-support-vsock-sockmap-connectible-v1-1-d47e6294827b@bytedance.com>
 <Y8w7d+6UASP3jUHf@pop-os.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8w7d+6UASP3jUHf@pop-os.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 21, 2023 at 11:22:31AM -0800, Cong Wang wrote:
> On Wed, Jan 18, 2023 at 12:27:39PM -0800, Bobby Eshleman wrote:
> > +static int vsock_read_skb(struct sock *sk, skb_read_actor_t read_actor)
> > +{
> > +	struct vsock_sock *vsk = vsock_sk(sk);
> > +
> > +	if (!vsk->transport)
> > +		return -ENODEV;
> > +
> > +	if (!vsk->transport->read_skb)
> > +		return -EOPNOTSUPP;
> 
> Can we move these two checks to sockmap update path? It would make
> vsock_read_skb() faster.
> 
> > +
> > +	return vsk->transport->read_skb(vsk, read_actor);
> > +}
> 
> Essentially can be just this one line.
> 
> Thanks.

That makes sense, will do.

Thanks,
Bobby
