Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B9D4D97CA
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 10:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346694AbiCOJiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 05:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240794AbiCOJis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 05:38:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 381B94ECFE
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 02:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647337056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5zt6w1F6VRhnNMb1j3DaRdbM9aTFGgFI1xf4MoCzsrQ=;
        b=J9UKBXtwFLRPG4uytOU1JxIG/hZtk2Rfgk9gKAfqRIo+B9PnoPirreX/582hTmsws0davE
        uhsJLEdwlqj/9DNeZJ/FMkHfWtJ+jkCTjByH1W/7xUQQ9L8OSkq/MkIRrzR/U0hmRXu7cn
        kDai2m0T06K6cu/XslUSp6JbQiYQduQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-mVypNozCMeicD_R8_CVeyw-1; Tue, 15 Mar 2022 05:37:34 -0400
X-MC-Unique: mVypNozCMeicD_R8_CVeyw-1
Received: by mail-wr1-f71.google.com with SMTP id p9-20020adf9589000000b001e333885ac1so5095769wrp.10
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 02:37:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=5zt6w1F6VRhnNMb1j3DaRdbM9aTFGgFI1xf4MoCzsrQ=;
        b=8JGpTFk/H/cRm5zxDjkIfadALnVlGPzhLs1joaPDxgxy0TjYvXf5Hh+c5eK2en0gdS
         GGT8g6pCs62Eq76uvpX1i34GcufZU1BZWmH2U11n/Tz308h2QaaWGgwnGEH9eJzRKg5W
         w5uJZJbRpOVY/sBxd8teAB2m+RapVqMCuwux9yX0P2Mybrg5Y+cezwQYTXzygrq9Gs6G
         dUBBDG+to+M8x45h8acAm0xg+gYxN6Gc7yN9JSJrJFZ0EjxT44FmP51c2okhUdla75DM
         0u3tBs2XoiFENGBLI6czZh+ACkRX788qmPuZZ2h/Itixm4s2wtb8o2OB3+5LYG84bacV
         eZyw==
X-Gm-Message-State: AOAM533URn23HbXBDOq6l1fa8LKYagwfdIfTzxCHE03Q6wdd7f6Bz5Gj
        EWLBTHixAWVkt3enIEsN6ZVPiBHxspG3feSaq48h9OUbMdcXzyW4Rt7DNTm8sGzbPSxPEpoYMuo
        CiqbuvOo1yuFKbCFm
X-Received: by 2002:a5d:48d1:0:b0:1e3:2401:f229 with SMTP id p17-20020a5d48d1000000b001e32401f229mr19618523wrs.694.1647337053502;
        Tue, 15 Mar 2022 02:37:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweO31agtT3GqZtzO4ZV2tvLQcDAg6mq7MUHKC3iBmZzzbKYV/IjQ36ajBiXY4xmKdd1OCRjg==
X-Received: by 2002:a5d:48d1:0:b0:1e3:2401:f229 with SMTP id p17-20020a5d48d1000000b001e32401f229mr19618506wrs.694.1647337053200;
        Tue, 15 Mar 2022 02:37:33 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id h13-20020adff18d000000b001f1de9f930esm25083980wro.81.2022.03.15.02.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 02:37:32 -0700 (PDT)
Message-ID: <99b9647a7c3fd8328a78c4a1944d1f41c4606676.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] net/packet: use synchronize_net_expedited()
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Lamparter <equinox@diac24.net>, netdev@vger.kernel.org
Date:   Tue, 15 Mar 2022 10:37:32 +0100
In-Reply-To: <20220313100033.343442-3-equinox@diac24.net>
References: <20220313100033.343442-1-equinox@diac24.net>
         <20220313100033.343442-3-equinox@diac24.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, 2022-03-13 at 11:00 +0100, David Lamparter wrote:
> Since these locations don't have RTNL held, synchronize_net() uses
> synchronize_rcu(), which takes its time.  Unfortunately, this is user
> visible on bind() and close() calls from userspace.  With a good amount
> of network interfaces, this sums up to Wireshark (dumpcap) taking
> several seconds to start for no good reason.
> 
> Signed-off-by: David Lamparter <equinox@diac24.net>
> ---
>  net/packet/af_packet.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 1b93ce1a5600..559e72149110 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -379,7 +379,7 @@ static void __unregister_prot_hook(struct sock *sk, bool sync)
>  
>  	if (sync) {
>  		spin_unlock(&po->bind_lock);
> -		synchronize_net();
> +		synchronize_net_expedited();
>  		spin_lock(&po->bind_lock);
>  	}
>  }

I *think* synchronize_net_expedited could be useful in some (likely
limited) circumstances, but here it looks like a bit too much.
Creating, deleteing or setting up a packet socket will hammer all the
CPUs significanly, while e.g. starting tcpdump on system is supposed
realitively safe.

I *think* you can speed up your test case replacing  synchronize_net 
with call_rcu() in __fanout_set_data_bpf() and in packet_release(). In
packet_set_ring() I guess synchronize_net() is needed only if an older
ring was running. Finally __fanout_set_data_bpf() should matter only
when replacing an existing filter, it likely should not impact your use
-case

Thanks!

Paolo

