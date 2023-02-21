Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1555D69E324
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 16:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbjBUPL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 10:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbjBUPL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 10:11:58 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEE529E10
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:11:55 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id ev13so5241202qvb.10
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/2n1LmxSFVVYvXpnEg2BE1jr0IuaC3UX1/QkFU5QwEM=;
        b=EIqFiA7L6BXoJnj850Mtn8tf837gOgf+zvcPPvv+CgAweUpF+UcQrMAgggNCXHRgko
         aEIx9RRnkYzIP7BiVcRjBtYPS+oiStK+0L+pXvJAbQZDhgFE70xKUUrelYZ5VV12orfH
         k2eMuSvwxCXvNqrfPTwqCrWHCkwqhlasA8TcSEgdwFk/7/mI3/L1cxlXpMaZIgCY0rre
         TsuRSfbCloQ2zdAyJvNCXik0B/leqfLzt/3Bs1rOqPnr2et75otd+VRqbcKiPCzRRsnO
         H6NXC87IH1F8YIN2XJlETb2cFizF/sfM5QLukgwBUErqj7JpwLPtNOs8L0Y+8PSaRnjS
         WNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/2n1LmxSFVVYvXpnEg2BE1jr0IuaC3UX1/QkFU5QwEM=;
        b=nmTl25ZrNiPmqS7LXu59FOAuDY+NoD7fRwndqdIxISNZDlq4Zui2xa+txyNPMfOjO1
         zIRzVcWe83EQNTHxIJC1yKJaDVUQpP2Wxf5L83ybPT4Fk+C2GntC1HDRCrt2PEuZGV3e
         hdcLbVWDV/A4qEpM8R+ACKjt9L/vvP8JaN0a7rSdIe4LLC4UTjYX3DmoqIyv0T8N1XrC
         oejA4wXnhncnoonOs5OgfweUNyNdpB71pUPLYDlNBGss+KpZ5QZMSkI2lzaP1dGGo1I8
         jmiohJlUN88i5BcoxRqepwkWqNPiyg598r14JFp9f1m12jjLWiusjLzqiAabwHw6i4n/
         wXYw==
X-Gm-Message-State: AO0yUKVNXXfE8vgfp0JwDp9u0T6DKbOg3qQXKa+1M4F+CtHdRfdmQeGu
        rtnJHl6WDtinU2bxrAuZC50=
X-Google-Smtp-Source: AK7set+b3tlj/r1WK8l+9lyPeiloTyCYHtosJmTw1LHA8gIcH1MOa0EA9ydxO/T85OgRdJVq7soUXw==
X-Received: by 2002:ad4:5de5:0:b0:56e:fef4:7ff1 with SMTP id jn5-20020ad45de5000000b0056efef47ff1mr7154614qvb.21.1676992314541;
        Tue, 21 Feb 2023 07:11:54 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id 196-20020a3707cd000000b0073ba97eb13csm9038385qkh.50.2023.02.21.07.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 07:11:54 -0800 (PST)
Date:   Tue, 21 Feb 2023 10:11:53 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        alvaro.karsz@solid-run.com, vmireyno@marvell.com, parav@nvidia.com
Message-ID: <63f4df39e0728_ce6df208fe@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230221144741.316477-1-jiri@resnulli.us>
References: <20230221144741.316477-1-jiri@resnulli.us>
Subject: RE: [patch net-next v2] net: virtio_net: implement exact header
 length guest feature
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
> set implicates that the driver provides the exact size of the header.
> 
> Quoting the original virtio spec:
> "hdr_len is a hint to the device as to how much of the header needs to
>  be kept to copy into each packet"
> 
> "a hint" might not be clear for the reader what does it mean, if it is
> "maybe like that" of "exactly like that". This feature just makes it
> crystal clear and let the device count on the hdr_len being filled up
> by the exact length of header.
> 
> Also note the spec already has following note about hdr_len:
> "Due to various bugs in implementations, this field is not useful
>  as a guarantee of the transport header size."
> 
> Without this feature the device needs to parse the header in core
> data path handling. Accurate information helps the device to eliminate
> such header parsing and directly use the hardware accelerators
> for GSO operation.
> 
> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
> The driver already complies to fill the correct value. Introduce the
> feature and advertise it.
> 
> Note that virtio spec also includes following note for device
> implementation:
> "Caution should be taken by the implementation so as to prevent
>  a malicious driver from attacking the device by setting
>  an incorrect hdr_len."
> 
> There is a plan to support this feature in our emulated device.
> A device of SolidRun offers this feature bit. They claim this feature
> will save the device a few cycles for every GSO packet.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
> v1->v2:
> - extended patch description

Is the expectation that in-kernel devices support this feature, and
if so how would it affect them? If I read the spec correctly, devices
still need to be careful against malicious drivers, so cannot assume
much beyond what they do today (i.e., a hint).

Might be good to point to the definition commit:
https://github.com/oasis-tcs/virtio-spec/commit/4f1981a1ff46b7aeb801c4c524ff76e93d9ce022
