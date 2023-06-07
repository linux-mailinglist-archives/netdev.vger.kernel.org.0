Return-Path: <netdev+bounces-8831-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C36DE725E64
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:15:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CA16281373
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D55DD34449;
	Wed,  7 Jun 2023 12:15:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A3230B90
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:15:33 +0000 (UTC)
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B3C1BD6;
	Wed,  7 Jun 2023 05:15:31 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id 6a1803df08f44-626157a186bso2335226d6.1;
        Wed, 07 Jun 2023 05:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686140131; x=1688732131;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8XZPPmOXy+covKv0eQSNPQLMzOY+EavY6mLoP79rZc=;
        b=RGQvr3p04xUWWIeDw2dJD14fHUEH+t2fQJULdyu1HiFLPmDI93BCxfeKaEMR6OzRbd
         2WdXR6a5p62AeHvJvwoV1ag5/VvKU+reaumHWcxfGhuRRQrpkLx+EUKwC9srrIxu445f
         /AZ9jWJXl4MnmsS/bFhQbMOmnD8X2eUfGQzORHyDA6I5697PukxVm6Xmbud0o0CAxHK9
         JfXOAKYktCDvSWwqUgzrd/jtv+e9Ed6IQcXReyd+np1mX+awYFT7eDnCIFt0s3vb740y
         FSpTAzbTFF/jMXT3fcdJMStR4lwyafdpb0sOXTsAQEDI4VventjDj0eUBgHwXMVS0Agg
         sxQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686140131; x=1688732131;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u8XZPPmOXy+covKv0eQSNPQLMzOY+EavY6mLoP79rZc=;
        b=Cvn5iXqrWDQsWKrPXmUZrsj7Hf/8jtKDTpcqGeNXr0h/BBnXWtVS1Dq0pwcYWOR5ES
         2aJBr9h9VLWaUN9v6X+MYGuhdZOAMhnq7ODIBaVJ84Lq+NTTw09F4Moz8U4PlLRKXWCG
         ZeWRJjUEiL5VOLxtqcXuq5mNBjKXWVYxe8FCkXsHu+lnfYoVx0r6SZoKN1VdVBPDQ88T
         6idpLBG2guzpCgypnyjwZC+pjdS7r+VcG+zSpuff58MdUxkX8uPG2zdq4BA0of2UzSUT
         +6RCPEtzxhOsW3hBgjJ/G7sbleekRlJf7MWP8CDSnZL+OjWfDRjxcSkVxQy+HHnLCK0L
         WDKQ==
X-Gm-Message-State: AC+VfDyJhiVQKwo8eXgiEXAZayEEsIJ/9kA5CnmF3b/CpoSQibkY1TmF
	Bu2McYJMwDpAGr3yLWgcUFw=
X-Google-Smtp-Source: ACHHUZ40wZwVfAH1nA4kaYq3UbMkylR8h6hcTZi3Wc3cqIzz8ZU0CMZc79z0MEk7u52LeM2nzhofNQ==
X-Received: by 2002:a05:6214:518b:b0:621:65de:f600 with SMTP id kl11-20020a056214518b00b0062165def600mr3011629qvb.1.1686140130585;
        Wed, 07 Jun 2023 05:15:30 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id bz5-20020ad44c05000000b005f227de6b1bsm6029533qvb.116.2023.06.07.05.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 05:15:29 -0700 (PDT)
Date: Wed, 07 Jun 2023 08:15:28 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Breno Leitao <leitao@debian.org>, 
 Remi Denis-Courmont <courmisch@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Alexander Aring <alex.aring@gmail.com>, 
 Stefan Schmidt <stefan@datenfreihafen.org>, 
 Miquel Raynal <miquel.raynal@bootlin.com>, 
 David Ahern <dsahern@kernel.org>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Matthieu Baerts <matthieu.baerts@tessares.net>, 
 Mat Martineau <martineau@kernel.org>, 
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 Xin Long <lucien.xin@gmail.com>
Cc: axboe@kernel.dk, 
 asml.silence@gmail.com, 
 leit@fb.com, 
 Martin KaFai Lau <martin.lau@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, 
 Kuniyuki Iwashima <kuniyu@amazon.com>, 
 Jason Xing <kernelxing@tencent.com>, 
 Joanne Koong <joannelkoong@gmail.com>, 
 Hangyu Hua <hbh25y@gmail.com>, 
 Guillaume Nault <gnault@redhat.com>, 
 Andrea Righi <andrea.righi@canonical.com>, 
 Wojciech Drewek <wojciech.drewek@intel.com>, 
 linux-kernel@vger.kernel.org (open list), 
 netdev@vger.kernel.org (open list:NETWORKING [GENERAL]), 
 dccp@vger.kernel.org (open list:DCCP PROTOCOL), 
 linux-wpan@vger.kernel.org (open list:IEEE 802.15.4 SUBSYSTEM), 
 mptcp@lists.linux.dev (open list:NETWORKING [MPTCP]), 
 linux-sctp@vger.kernel.org (open list:SCTP PROTOCOL)
Message-ID: <648074e0e52d9_143118294e0@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230606180045.827659-1-leitao@debian.org>
References: <20230606180045.827659-1-leitao@debian.org>
Subject: RE: [PATCH net-next v6] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Breno Leitao wrote:
> Most of the ioctls to net protocols operates directly on userspace
> argument (arg). Usually doing get_user()/put_user() directly in the
> ioctl callback.  This is not flexible, because it is hard to reuse these
> functions without passing userspace buffers.
> 
> Change the "struct proto" ioctls to avoid touching userspace memory and
> operate on kernel buffers, i.e., all protocol's ioctl callbacks is
> adapted to operate on a kernel memory other than on userspace (so, no
> more {put,get}_user() and friends being called in the ioctl callback).
> 
> This changes the "struct proto" ioctl format in the following way:
> 
>     int                     (*ioctl)(struct sock *sk, int cmd,
> -                                        unsigned long arg);
> +                                        int *karg);
> 
> (Important to say that this patch does not touch the "struct proto_ops"
> protocols)
> 
> So, the "karg" argument, which is passed to the ioctl callback, is a
> pointer allocated to kernel space memory (inside a function wrapper).
> This buffer (karg) may contain input argument (copied from userspace in
> a prep function) and it might return a value/buffer, which is copied
> back to userspace if necessary. There is not one-size-fits-all format
> (that is I am using 'may' above), but basically, there are three type of
> ioctls:
> 
> 1) Do not read from userspace, returns a result to userspace
> 2) Read an input parameter from userspace, and does not return anything
>   to userspace
> 3) Read an input from userspace, and return a buffer to userspace.
> 
> The default case (1) (where no input parameter is given, and an "int" is
> returned to userspace) encompasses more than 90% of the cases, but there
> are two other exceptions. Here is a list of exceptions:
> 
> * Protocol RAW:
>    * cmd = SIOCGETVIFCNT:
>      * input and output = struct sioc_vif_req
>    * cmd = SIOCGETSGCNT
>      * input and output = struct sioc_sg_req
>    * Explanation: for the SIOCGETVIFCNT case, userspace passes the input
>      argument, which is struct sioc_vif_req. Then the callback populates
>      the struct, which is copied back to userspace.
> 
> * Protocol RAW6:
>    * cmd = SIOCGETMIFCNT_IN6
>      * input and output = struct sioc_mif_req6
>    * cmd = SIOCGETSGCNT_IN6
>      * input and output = struct sioc_sg_req6
> 
> * Protocol PHONET:
>   * cmd == SIOCPNADDRESOURCE | SIOCPNDELRESOURCE
>      * input int (4 bytes)
>   * Nothing is copied back to userspace.
> 
> For the exception cases, functions sock_sk_ioctl_inout() will
> copy the userspace input, and copy it back to kernel space.
> 
> The wrapper that prepare the buffer and put the buffer back to user is
> sk_ioctl(), so, instead of calling sk->sk_prot->ioctl(), the callee now
> calls sk_ioctl(), which will handle all cases.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Willem de Bruijn <willemb@google.com>

