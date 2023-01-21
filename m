Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95827676850
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 20:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjAUTWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 14:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjAUTWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 14:22:35 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BA6279BD;
        Sat, 21 Jan 2023 11:22:34 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id u13-20020a4aa34d000000b004f5219f9424so1544556ool.5;
        Sat, 21 Jan 2023 11:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o445b1MnVY2xcczIeGhfEHs/6/N/MTgkwXpPKatAAvc=;
        b=blGf0rssVVm4/xsfLxsV1fJdJ18QG6trE/kND3h68y2KoRQZ7YJqp3Ug2tjGJtc/7C
         UIa94wgq+dllVnMbIEl45CyyUgycOLzfLCm/Gy8CwS+X82vAypOsKizt70EpHKmH35Cn
         eXEc9zjW5E4B3Qzv5HwgiO9plLXKZ1AgZ50JWCmAMizmIZ0LPLCDEZdfGNhrH3W4Nu5u
         pifwhrY8QR5QEvuKGRTWnGkd4zN7cGcM4cBrbXuNdE9Nz2zG1ea9YlqME+265CqNW4ky
         ds2QxNvIFt0WFifhuegALERmlghRRPVH8ypCEe/w9wYyMoPO8g4IJkiV0DEiirQoRZFN
         UluA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o445b1MnVY2xcczIeGhfEHs/6/N/MTgkwXpPKatAAvc=;
        b=w3qNgSPRbERFhYcL0okOdh4WllhjwSA6+KuAmP0/Up0stomBMPmbjAFPMnb8ToAh8P
         eu+aqBB+9Px0gM03XwG26x6PuSD0YGvDHlE1xDBYMh49wzXcZilw5wQPAwFlvxitEq/i
         rx36z72B31LlwyqGlS8G/aN39VOzqBBZglGxWP2au3wPVCvvXL8WmNuoh2oZYZjJPKcI
         fmEGSgeWkqoG3B9BaGnBc5G2YwSqZIk71FBDOlpvHjwZweiBXgnirb91jYpyZ+fOWa4M
         fpwqfQtHLw9sdmipE0mhY7lQC2MrRxK2lgb93EozrPBSUiLi7yGTUODFEt+fE+kxYZHZ
         xXTQ==
X-Gm-Message-State: AFqh2kpQohtdRrbUiJROZPcM2XTztY1A6Y6d5Ol+hpgsjVxeWHk06lvw
        UTedBO12dsx5O5Fr8ALcrCU=
X-Google-Smtp-Source: AMrXdXsPJ0hrC7d2aVvmAOndVW+aw6x1kZCJgXCrvyj1ojnc8V7P1KkUOwesPpPFMQGd6vCCgvmGgw==
X-Received: by 2002:a4a:e68e:0:b0:4f5:200e:a1bf with SMTP id u14-20020a4ae68e000000b004f5200ea1bfmr8669367oot.1.1674328953754;
        Sat, 21 Jan 2023 11:22:33 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:b306:d5d0:37ec:2fa])
        by smtp.gmail.com with ESMTPSA id i23-20020a4a8d97000000b004a0ad937ccdsm10693131ook.1.2023.01.21.11.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jan 2023 11:22:32 -0800 (PST)
Date:   Sat, 21 Jan 2023 11:22:31 -0800
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
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH RFC 1/3] vsock: support sockmap
Message-ID: <Y8w7d+6UASP3jUHf@pop-os.localdomain>
References: <20230118-support-vsock-sockmap-connectible-v1-0-d47e6294827b@bytedance.com>
 <20230118-support-vsock-sockmap-connectible-v1-1-d47e6294827b@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118-support-vsock-sockmap-connectible-v1-1-d47e6294827b@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 12:27:39PM -0800, Bobby Eshleman wrote:
> +static int vsock_read_skb(struct sock *sk, skb_read_actor_t read_actor)
> +{
> +	struct vsock_sock *vsk = vsock_sk(sk);
> +
> +	if (!vsk->transport)
> +		return -ENODEV;
> +
> +	if (!vsk->transport->read_skb)
> +		return -EOPNOTSUPP;

Can we move these two checks to sockmap update path? It would make
vsock_read_skb() faster.

> +
> +	return vsk->transport->read_skb(vsk, read_actor);
> +}

Essentially can be just this one line.

Thanks.
