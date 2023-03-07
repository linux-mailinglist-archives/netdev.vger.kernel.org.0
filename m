Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7996AFB00
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 01:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCHAWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 19:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjCHAWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 19:22:38 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4CCAFB8B;
        Tue,  7 Mar 2023 16:22:33 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id l1so15024322pjt.2;
        Tue, 07 Mar 2023 16:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678234953;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=35Won8zMWVVfPTEvhn2MxcVhR7a/DGVFntbhUz0/4yw=;
        b=fIpSwKd2OegJR409d02lXFRB+ZwhOyO+8Qbrkm5cJPg4Bop5P+9uNq4LillBqDYNEj
         AUefz91QTTsnh8pYk3xdsYjpMqlS/ceg3z2GyzreXnzl9eIF67e2hDG9ilDVwpT42LAx
         EMcpl5mZdzrwvN3qzbCKEIAe9gVaNy29wzl657wpSk3dLTSjT7mc+Mb7yzSFwSuxgeZe
         QqsnBYrMIo08xiZ1psrckYPqLFAzMTtpYQGbE7za4TF9rtQXay6nyJZdz07DFjMxoeeb
         vVmaveiFeEjmBEaGcpIBQTxW7tWR/1AzhgccPWMuuz2eiyOzCW3hoIz36nNHL2oASfRC
         +sxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678234953;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=35Won8zMWVVfPTEvhn2MxcVhR7a/DGVFntbhUz0/4yw=;
        b=IxUBbcP1PVLU2seWaRMsVEsRoCFBQLJN4ejv5V1nWcBKXTu3UWZRiO8yvVzNChFYbN
         OCORqNLMo6lSbpQIzha449bgOp0lIy3dto+v0Ilrxhl4G/yuBOXkL/i9xViuOL4yGpig
         TuZhZhev/AO6ndA/U8rCXMw/wtGIsDV01tTTessOXacfs3TBMOlLJ2KMhi/Sum+lBWQz
         4gRVWOce2tB20SZHN4eRagNlr6csqIIWyxPQI9lbhO/VjLmca1kv3qA/Ccwh//R2Qgf1
         +5IhpBRuqduBOICK1An62whmvp8uW0nF1XOf9LOlZk9mVV8lpIr56jAliylOFzfE1j0J
         kALg==
X-Gm-Message-State: AO0yUKW8cm8JgJqZgAs1F08WIcpUs+s5nHODj5TRTHoixL8gLMTN+E2D
        38+t73sBkXg8IEo8IKa4drw=
X-Google-Smtp-Source: AK7set+OU+ZArKrJvYHh6kIMnL/wqiCiVHWQeGVEMq11+eDuOJCa5624lHFNshLCgAWUXNZhBrn1MQ==
X-Received: by 2002:a17:90b:4c0a:b0:22c:aaaf:8dd9 with SMTP id na10-20020a17090b4c0a00b0022caaaf8dd9mr17003966pjb.47.1678234952980;
        Tue, 07 Mar 2023 16:22:32 -0800 (PST)
Received: from localhost (ec2-52-9-159-93.us-west-1.compute.amazonaws.com. [52.9.159.93])
        by smtp.gmail.com with ESMTPSA id c21-20020a17090a8d1500b002347475e71fsm8085968pjo.14.2023.03.07.16.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 16:22:32 -0800 (PST)
Date:   Tue, 7 Mar 2023 23:53:17 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Arseniy Krasnov <avkrasnov@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, oxffffaa@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kernel@sberdevices.ru,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v2 2/4] virtio/vsock: remove all data from sk_buff
Message-ID: <ZAfObcosX5PlS4Lf@bullseye>
References: <a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru>
 <dfadea17-a91e-105f-c213-a73f9731c8bd@sberdevices.ru>
 <20230306120857.6flftb3fftmsceyl@sgarzare-redhat>
 <b18e3b13-3386-e9ee-c817-59588e6d5fb6@sberdevices.ru>
 <20230306155121.7xwxzgxtle7qjbnc@sgarzare-redhat>
 <9b882d45-3d9d-c44d-a172-f23fff54962b@sberdevices.ru>
 <20230306161852.4s7qf4qm3fnwjck7@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306161852.4s7qf4qm3fnwjck7@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 05:18:52PM +0100, Stefano Garzarella wrote:
> On Mon, Mar 06, 2023 at 07:00:10PM +0300, Arseniy Krasnov wrote:
> > 
> > 
> > On 06.03.2023 18:51, Stefano Garzarella wrote:
> > > On Mon, Mar 06, 2023 at 06:31:22PM +0300, Arseniy Krasnov wrote:
> > > > 
> > > > 
> > > > On 06.03.2023 15:08, Stefano Garzarella wrote:
> > > > > On Sun, Mar 05, 2023 at 11:07:37PM +0300, Arseniy Krasnov wrote:
> > > > > > In case of SOCK_SEQPACKET all sk_buffs are used once - after read some
> > > > > > data from it, it will be removed, so user will never read rest of the
> > > > > > data. Thus we need to update credit parameters of the socket like whole
> > > > > > sk_buff is read - so call 'skb_pull()' for the whole buffer.
> > > > > > 
> > > > > > Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
> > > > > > Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> > > > > > ---
> > > > > > net/vmw_vsock/virtio_transport_common.c | 2 +-
> > > > > > 1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > Maybe we could avoid this patch if we directly use pkt_len as I
> > > > > suggested in the previous patch.
> > > > Hm, may be we can avoid calling 'skb_pull()' here if 'virtio_transport_dec_rx_pkt()'
> > > > will use integer argument?
> > > 
> > > Yep, exactly!
> > > 
> > > > Just call 'virtio_transport_dec_rx_pkt(skb->len)'. skb
> > > 
> > > It depends on how we call virtio_transport_inc_rx_pkt(). If we use
> > > hdr->len there I would use the same to avoid confusion. Plus that's the
> > > value the other peer sent us, so definitely the right value to increase
> > > fwd_cnt with. But if skb->len always reflects it, then that's fine.
> > i've checked 'virtio_transport_rx_work()', it calls 'virtio_vsock_skb_rx_put()' which
> > sets 'skb->len'. Value is used from header, so seems 'skb->len' == 'hdr->len' in this
> > case.
> 
> Thank you for checking it.
> 
> However, I still think it is better to use `hdr->len` (we have to assign it
> to `pkt_len` anyway, as in the proposal I sent for patch 1), otherwise we
> have to go every time to check if skb_* functions touch skb->len.
> 
> E.g. skb_pull() decrease skb->len, so I'm not sure we can call
> virtio_transport_dec_rx_pkt(skb->len) if we don't remove `skb_pull(skb,
> bytes_to_copy);` inside the loop.
> 

I think it does make reasoning about the bytes accounting easier if it
is based off of the non-mutating hdr->len.

Especially if vsock does ever support tunneling (e.g., through
virtio-net) or some future feature that makes the skb->len more dynamic.

Best,
Bobby
