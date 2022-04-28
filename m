Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4D6512EFA
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 10:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239529AbiD1Iwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 04:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238979AbiD1Iwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 04:52:42 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA3D6385;
        Thu, 28 Apr 2022 01:49:28 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bv19so8149268ejb.6;
        Thu, 28 Apr 2022 01:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gditj3pIK4QuzcqOW8qGUvUL1/lFL5DV7yQpng/n4Bg=;
        b=SmZEqrKEzVcD/2dBQBE39Ir32WYWyyv0LiXdMOEk2y91yqcjv1JRy9jecPoHlk3Mse
         /p7JZ8A3RIZwyXmD4gccsFRmWfxQc8OjeDRQk7WQi2I4CZpsjNphd1NMriagdl9lCklS
         Sq3j6xpZ481R5ZdFCD7Kgs7+Suid8oKytyoWTmrM1Ul+2cMyqkE0MkJcSYwK46+tO3hz
         yPQDT719L4Aotjyc4mV5MrNA37dM5Px1ffA2YqesVpleJS5B8B3m/BCgSNQNilyZFD4P
         6qoLuxTMp2dYZUTQBtB08izby3FMSG/cS+YK8Mogr+1TIsh7pQWvo2YLf6NK4/NoLgHL
         S1fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gditj3pIK4QuzcqOW8qGUvUL1/lFL5DV7yQpng/n4Bg=;
        b=UrpUE2WFyOQlGSoLPGs004yynbdddnsZTSpmHVw9EPGRnZSfzx6fgycL/Ipg62GUew
         QjWb6oZLsIHgjhn1VH+VeAScH4bs1rlYs3jnS+bdZ7dwpTgrh0ha/Sr9YcodsOan6hFr
         1+RYumOk2wjd9xfLoiJjujNs2svV/ZCWEkkOzMzicl4166+x3TRKiyHS5FbpIgOuHiEc
         tnB4vkFS3yAC6kYn6P/ej0Tf6vyhGkPzn4K1FfGMThkfaOBm+0jVHlttVYHJPorzahwx
         xzsUi7YeKiPTjC1rH7MrQMjJiRBywhDcaS2YHEBtklyI4pk3zY7HhpTF8Kz8oXDfq/UR
         lzlg==
X-Gm-Message-State: AOAM530eDkXBs5QGoCItMdK4qSKkhfkL66coO2HTpK6z1Pc1xDhB7UWe
        vmKTl9g2J3bDfxipkAoMNGbJiZYARSc=
X-Google-Smtp-Source: ABdhPJwh7NCntuLtaQyH1pXzw5R201XZqA2FCHT/035nb8SkKfuoFK92gkdub5ES2IyVmhRVRRQrRA==
X-Received: by 2002:a17:906:99c1:b0:6db:f0cf:e38c with SMTP id s1-20020a17090699c100b006dbf0cfe38cmr30591051ejn.692.1651135767166;
        Thu, 28 Apr 2022 01:49:27 -0700 (PDT)
Received: from [132.68.43.112] ([132.68.43.112])
        by smtp.gmail.com with ESMTPSA id q17-20020a1709064cd100b006e78206fe2bsm8193855ejt.111.2022.04.28.01.49.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 01:49:26 -0700 (PDT)
Message-ID: <068945db-f29e-8586-0487-bb5be68c7ba8@gmail.com>
Date:   Thu, 28 Apr 2022 11:49:24 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
Content-Language: en-US
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     ak@tempesta-tech.com, simo@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
From:   Boris Pismenny <borispismenny@gmail.com>
In-Reply-To: <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/04/2022 19:49, Chuck Lever wrote:
> In-kernel TLS consumers need a way to perform a TLS handshake. In
> the absence of a handshake implementation in the kernel itself, a
> mechanism to perform the handshake in user space, using an existing
> TLS handshake library, is necessary.
>
> I've designed a way to pass a connected kernel socket endpoint to
> user space using the traditional listen/accept mechanism. accept(2)
> gives us a well-understood way to materialize a socket endpoint as a
> normal file descriptor in a specific user space process. Like any
> open socket descriptor, the accepted FD can then be passed to a
> library such as openSSL to perform a TLS handshake.
>
> This prototype currently handles only initiating client-side TLS
> handshakes. Server-side handshakes and key renegotiation are left
> to do.
>
> Security Considerations
> ~~~~~~~~ ~~~~~~~~~~~~~~
>
> This prototype is net-namespace aware.
>
> The kernel has no mechanism to attest that the listening user space
> agent is trustworthy.
>
> Currently the prototype does not handle multiple listeners that
> overlap -- multiple listeners in the same net namespace that have
> overlapping bind addresses.
>

Thanks for posting this. As we discussed offline, I think this approach
is more manageable compared to a full in-kernel TLS handshake. A while
ago, I've hacked around TLS to implement the data-path for NVMe-TLS and
the data-path is indeed very simple provided an infrastructure such as
this one.

Making this more generic is desirable, and this obviously requires
supporting multiple listeners for multiple protocols (TLS, DTLS, QUIC,
PSP, etc.), which suggests that it will reside somewhere outside of net/tls.
Moreover, there is a need to support (TLS) control messages here too.
These will occasionally require going back to the userspace daemon
during kernel packet processing. A few examples are handling: TLS rekey,
TLS close_notify, and TLS keepalives. I'm not saying that we need to
support everything from day-1, but there needs to be a way to support these.

A related kernel interface is the XFRM netlink where the kernel asks a
userspace daemon to perform an IKE handshake for establishing IPsec SAs.
This works well when the handshake runs on a different socket, perhaps
that interface can be extended to do handshakes on a given socket that
lives in the kernel without actually passing the fd to userespace. If we
avoid instantiating a full socket fd in userspace, then the need for an
accept(2) interface is reduced, right?

