Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121CC620BA7
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbiKHJAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiKHJAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:00:44 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82671FD04;
        Tue,  8 Nov 2022 01:00:43 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id x2so21432613edd.2;
        Tue, 08 Nov 2022 01:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qqad13SKeURtqLzBBk2kO3txC+IAP/eZrITsK9q/+vM=;
        b=Fyo6VKZFQCvyNKwJRr9u1BS9sxRBdiYwe4YcODvmtE+p8ZsS7RB/HbdAAwdL8JAb+s
         nt1aESdu6rrhWskQlB7pxVWMVZVL8qx67qeKc9iCGhnN0vJquZx2AYFbWb3o5xU7zCGy
         ncEuuWXw4523mIrYKX73Natdzn08Bz/I2xgFy8M9NNAN9rOcqupPgRGZerow6bqlUmwR
         kEyC11F+2eCkIVoSvtoWf/0+xpaZ8z2a1JYSsYxFMMQirxwChSM/2ztTr5jO90dz+pJH
         im+1bLc1CCyvW4Z4EymXPUw45Qu3n3u/I3Wv25HxRte3R/1wbz5xskKgsz89illO6g1/
         il4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqad13SKeURtqLzBBk2kO3txC+IAP/eZrITsK9q/+vM=;
        b=bBJziHUYeDrNrLBBRl4HqUj7FJDqQD7y2T0SQeQL98dGPr8oXG6X+4qdhLmbBwaORa
         1Xvr1oIX+Baa9OXCWHNdTezX6uSMKqGHhidoCvkx0WoKTa2OmCN2UQ/ZjG8qM/rsqB1N
         dSlKX7secSTPAGd8JsMDzoirl5JMPM2P/PWTyH+pwKtoHrX+Xs27VgIFVH6iSWOLsYfA
         NbNblWeOEMFMhg9sLQml35zoooJclcCs2mzJRiHxTqn97ONjZyONd6+RQFFlbK+r1f9g
         6195Fu4yojmaenctlWyJa26sgcqCmlHmnTWSykv52sFwTdMhGSvsk7WfcTAu9VSo4xD3
         yo7w==
X-Gm-Message-State: ACrzQf1BT1sQ4cRn9ymc9AQWJWXw53DG1NSgp5/kBZliHrAtBEox2A4+
        mKZeYzaawk4c3YIzC3N0+ds=
X-Google-Smtp-Source: AMsMyM5fbz3Yar1FPlSiwEnrpZO0I/ObPDsunwBbAzz+bwhP5SMPbqSOgpd843grN3CwmQztGbN4aA==
X-Received: by 2002:aa7:cd12:0:b0:463:69ac:a5d3 with SMTP id b18-20020aa7cd12000000b0046369aca5d3mr46793480edw.269.1667898041911;
        Tue, 08 Nov 2022 01:00:41 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id f24-20020a056402069800b00458a03203b1sm5304486edy.31.2022.11.08.01.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 01:00:41 -0800 (PST)
Date:   Tue, 8 Nov 2022 11:00:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/14] net: vlan: remove invalid VLAN protocol warning
Message-ID: <20221108090039.imamht5iyh2bbbnl@skbuf>
References: <20221107185452.90711-1-nbd@nbd.name>
 <20221107185452.90711-8-nbd@nbd.name>
 <20221107215745.ascdvnxqrbw4meuv@skbuf>
 <3b275dda-39ac-282d-8a46-d3a95fdfc766@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b275dda-39ac-282d-8a46-d3a95fdfc766@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 07:08:46AM +0100, Felix Fietkau wrote:
> On 07.11.22 22:57, Vladimir Oltean wrote:
> > Aren't you calling __vlan_hwaccel_put_tag() with the wrong thing (i.e.
> > htons(RX_DMA_VPID()) as opposed to VPID translated to something
> > digestible by the rest of the network stack.. ETH_P_8021Q, ETH_P_8021AD
> > etc)?
> 
> The MTK ethernet hardware treats the DSA special tag as a VLAN tag and
> reports it as such. The ethernet driver passes this on as a hwaccel tag, and
> the MTK DSA tag parser consumes it. The only thing that's sitting in the
> middle looking at the tag is the VLAN device lookup with that warning.
> 
> Whenever DSA is not being used, the MTK ethernet device can also process
> regular VLAN tags. For those tags, htons(RX_DMA_VPID()) will contain the
> correct VPID.

So I don't object to the overall theme of having the DSA master offload
the parsing and removal of the DSA tag, but you knock down a bit too
many fences if you carry the DSA tag in skb->vlan_present (not only VLAN
upper device lookup, but also the flow dissector).

What other information will be present in the offloaded DSA headers
except source port information? Maxime Chevallier is also working on a
similar problem for qca8k, except in that case, the RX DSA offload seems
to not be optional for him.

https://patchwork.kernel.org/project/netdevbpf/patch/20221104174151.439008-4-maxime.chevallier@bootlin.com/

Would a solution based on METADATA_HW_PORT_MUX and dst_metadata that
point to refcounted, preallocated structs work for Mediatek SoCs with
DSA, or would more information be necessary?

Meaning: mtk_eth_soc attaches the dst_metadata to the skb, tag_mtk.c
retrieves and removes it.
