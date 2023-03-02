Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD4D6A7D89
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 10:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjCBJVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 04:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjCBJVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 04:21:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EB230EB9
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 01:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677748820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mNAh7WwsaV0kOk2ITHv/T/MFdHkpYUKS8lAASyQo12s=;
        b=cUMnoJruM/FiQCbLzYKR+v1jwYiCKkN3NTRfoYKkw4UnUWf7wmcVJ9Rk9KbKuYm0isTBie
        zvG1Ajk9oaaty4OL7koiRtxLXpJPwmP204GZ4gxLS1l4/EuJPes5SeEAO+P6pTKssBW+YN
        1eULUJeiyfH2N9o7LJaUAiOpTw8f/sM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-st6txYhYOiGEv0DvN_Yy5w-1; Thu, 02 Mar 2023 04:20:19 -0500
X-MC-Unique: st6txYhYOiGEv0DvN_Yy5w-1
Received: by mail-wr1-f72.google.com with SMTP id u5-20020a5d6da5000000b002cd82373455so1955099wrs.9
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 01:20:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677748818;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNAh7WwsaV0kOk2ITHv/T/MFdHkpYUKS8lAASyQo12s=;
        b=4z3waDSqpXHkb47OtUbFTTQeRmZC+DsCEf6nb1OOGpILH4/8viZ7xXw5wAiw1oTgaY
         zeIyRQc4r7UBgwQgpKTwQIIVCFyOk5C1fQlK8xJvQRiWaRdsGWD/y2aIVAREpxiKNTnk
         pif7H0LwoNRPNoZS3tAhNv5Mzb+JvwuWkEcT1fj6T8DYzNCOg4vPKgSDRROUCpTbsY0S
         Caw1iDCvdp4MYEqqj/N56dK0JxcZwN3lK67/IUe90Nq01ThuSp+C4fn9x3wGiMxasaNm
         l4FnlLKirpQ9OPd4G/ezzMhSs9yQFWlZF9yzXGMbP79q+NMNln1G/uEyTXFn4AWLPk5R
         /FeQ==
X-Gm-Message-State: AO0yUKXrWB3rv+W0AS1BC7zTQoUL4fMdOCobluUPd1elyF8eHaI3sIOy
        hQu5qemF0LPs0gXAJ0BWfcstUcJPJoFV82+xJmeAQ0xiKlIdatMGuWipBa9nDYIuApv4Jt1HDwV
        Zv18k6tuTKuGVtXbz
X-Received: by 2002:adf:ce09:0:b0:2c5:52c3:3f05 with SMTP id p9-20020adfce09000000b002c552c33f05mr6913068wrn.37.1677748818283;
        Thu, 02 Mar 2023 01:20:18 -0800 (PST)
X-Google-Smtp-Source: AK7set9PN/kdkIqrGoMb6UfHqEwEV9RSL6zdzJVeFnieVx1t6UmihOxwNslkLjNRDZls5mCSN7BIMA==
X-Received: by 2002:adf:ce09:0:b0:2c5:52c3:3f05 with SMTP id p9-20020adfce09000000b002c552c33f05mr6913041wrn.37.1677748818002;
        Thu, 02 Mar 2023 01:20:18 -0800 (PST)
Received: from sgarzare-redhat (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id x16-20020a5d54d0000000b002c71703876bsm14635935wrv.14.2023.03.02.01.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 01:20:17 -0800 (PST)
Date:   Thu, 2 Mar 2023 10:20:09 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, kvm@vger.kernel.org,
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
Subject: Re: [PATCH net-next v3 1/3] vsock: support sockmap
Message-ID: <20230302092009.xohos3cvowrrykck@sgarzare-redhat>
References: <20230227-vsock-sockmap-upstream-v3-0-7e7f4ce623ee@bytedance.com>
 <20230227-vsock-sockmap-upstream-v3-1-7e7f4ce623ee@bytedance.com>
 <20230228163518-mutt-send-email-mst@kernel.org>
 <Y/B9ddkfQw6Ae/lY@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y/B9ddkfQw6Ae/lY@bullseye>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 18, 2023 at 07:25:41AM +0000, Bobby Eshleman wrote:
>On Tue, Feb 28, 2023 at 04:36:22PM -0500, Michael S. Tsirkin wrote:
>> On Tue, Feb 28, 2023 at 07:04:34PM +0000, Bobby Eshleman wrote:
>> > @@ -1241,19 +1252,34 @@ static int vsock_dgram_connect(struct socket *sock,
>> >
>> >  	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
>> >  	sock->state = SS_CONNECTED;
>> > +	sk->sk_state = TCP_ESTABLISHED;
>> >
>> >  out:
>> >  	release_sock(sk);
>> >  	return err;
>> >  }
>>
>>
>> How is this related? Maybe add a comment to explain? Does
>> TCP_ESTABLISHED make sense for all types of sockets?
>>
>
>Hey Michael, definitely, I can leave a comment.

I agree, since I had the same doubt in previous versions, I think it's 
worth putting a comment in the code to explain why.

Since there may be a v4, I'll leave some small comments in a separate 
email.

Thanks,
Stefano

>
>The real reason is due to this piece of logic in sockmap:
>https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/core/sock_map.c?h=v6.2#n531
>
>And because of it, you see the same thing in (for example)
>unix_dgram_connect():
>https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/unix/af_unix.c?h=v6.2#n1394
>
>I believe it makes sense for these other socket types.
>

