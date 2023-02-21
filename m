Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696AC69E06B
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 13:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbjBUMaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 07:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbjBUMaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 07:30:03 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FF129E28
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:29:35 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id x10so15698490edd.13
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yPNUlcZMBhrjIgLpJx3TAFo49SK7Sn/N+0dd4lpy5r4=;
        b=QU9Sy9oM/2YIMMU4vK16zNUL84LlqbKfVsF4kwcRv/ueBjtkBZa4C3lWWxXAc5SdzH
         40ico2/9qhpITQYT5rzi20H56PU6tCHFTPofXD4PWqbDMJJSfi/PSS54rwNuu5VFne5R
         ZL6MP7L8vpdnkMnYH7UueMW54hU3xoLqYnHHel6Fcvrfev8dCNj4/oy45VPbnLv+wRYV
         YeRi1dmhLnUrg7TLeVB+gl6oOBC8WbFOiZc6VlDQ+YBtiIsjG40mb0WSR5/uRem+x2nc
         qZMDK3Fo/Xn9BViWeI2CeByuqcJKWfK8O1lb+lp2l9f6+YlMQqj4eOOtUVkKr1kNLY8l
         g/OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yPNUlcZMBhrjIgLpJx3TAFo49SK7Sn/N+0dd4lpy5r4=;
        b=mXIYqJ/9g3YE4DWgiXCcN9hh7ZjGFwYDuJOBgyzWB19G2zEe7PtwjwQfjlZH9fdOCV
         xDKJ8QDVnMbiveLfm/J1QZyfm27T/oFUjcuNXYA9sVxypkvwog/y9jSKS+XhnJmxUEVi
         Qw2R8GluRje/RG5kdNwl/8QFhyc8XvqxAmymjtOUsx0rFZHzvVTtW/v5JvjOoYU9hUCT
         OMpt07CsMKLxkL2QB5xpFCeu+umsi9ukIi4BDigwVNakFIn8LFVizSCvgOLZms81vVpg
         DO+69ZJ1ggZhJnrwGB4mMG36pVFVaIRUC+jINNkHyxDC7KWxSiD3PzLDm0bbLQDJ/sjW
         bpvw==
X-Gm-Message-State: AO0yUKWXO7nJXndVpY3s7yTs4QsRlos3p72HASb5cenLq3nRVCIRzX00
        5FhfETrNaYIWj8zl/Kyyau5fiQ==
X-Google-Smtp-Source: AK7set/WE/4jcq71W5OC19pxOo6brwpC18w8vr4W0gSDRYYU3pLBET5CnIcnluiBj6UxHmQLi2E+Ig==
X-Received: by 2002:a17:907:6025:b0:878:683c:f0d1 with SMTP id fs37-20020a170907602500b00878683cf0d1mr9909884ejc.38.1676982569540;
        Tue, 21 Feb 2023 04:29:29 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n4-20020a170906724400b008df97fae83dsm718201ejk.91.2023.02.21.04.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 04:29:28 -0800 (PST)
Date:   Tue, 21 Feb 2023 13:29:27 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, virtualization@lists.linux-foundation.org,
        Vitaly Mireyno <vmireyno@marvell.com>
Subject: Re: [patch net-next] net: virtio_net: implement exact header length
 guest feature
Message-ID: <Y/S5J3wZ8CDB6lVT@nanopsycho>
References: <20230217121547.3958716-1-jiri@resnulli.us>
 <20230217072032-mutt-send-email-mst@kernel.org>
 <Y+94418p73aUQyIn@nanopsycho>
 <20230217083915-mutt-send-email-mst@kernel.org>
 <Y/MwtAGru3yAY7r3@nanopsycho>
 <20230220074947-mutt-send-email-mst@kernel.org>
 <Y/N7+IJ+gzvP0IEf@nanopsycho>
 <cc14248c-cd6c-d604-003c-7384363dab8e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc14248c-cd6c-d604-003c-7384363dab8e@redhat.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 21, 2023 at 03:38:10AM CET, jasowang@redhat.com wrote:
>
>在 2023/2/20 21:56, Jiri Pirko 写道:
>> Mon, Feb 20, 2023 at 01:55:33PM CET, mst@redhat.com wrote:
>> > On Mon, Feb 20, 2023 at 09:35:00AM +0100, Jiri Pirko wrote:
>> > > Fri, Feb 17, 2023 at 02:47:36PM CET, mst@redhat.com wrote:
>> > > > On Fri, Feb 17, 2023 at 01:53:55PM +0100, Jiri Pirko wrote:
>> > > > > Fri, Feb 17, 2023 at 01:22:01PM CET, mst@redhat.com wrote:
>> > > > > > On Fri, Feb 17, 2023 at 01:15:47PM +0100, Jiri Pirko wrote:
>> > > > > > > From: Jiri Pirko <jiri@nvidia.com>
>> > > > > > > 
>> > > > > > > virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
>> > > > > > > 
>> > > > > > > Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
>> > > > > > > set implicates that the driver provides the exact size of the header.
>> > > > > > > 
>> > > > > > > The driver already complies to fill the correct value. Introduce the
>> > > > > > > feature and advertise it.
>> > > > > > > 
>> > > > > > > Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> > > > > > Could you add a bit of motivation just for the record?
>> > > > > > Does this improve performance for some card? By how much?
>> > > > > > Expected to help some future card?
>> > > > > I can get that info, but isn't that rather something to be appended to
>> > > > > the virtio-spec patch? I mean, the feature is there, this is just
>> > > > > implementing it in one driver.
>> > > > It is more like using it in the driver.  It's not like we have to use
>> > > > everything - it could be useful for e.g. dpdk but not linux.
>> > > > Implementing it in the Linux driver has support costs - for example what
>> > > > if there's a bug and sometimes the length is incorrect?
>> > > > We'll be breaking things.
>> > > I understand. To my understanding this feature just fixes the original
>> > > ambiguity in the virtio spec.
>> > > 
>> > > Quoting the original virtio spec:
>> > > "hdr_len is a hint to the device as to how much of the header needs to
>> > >   be kept to copy into each packet"
>> > > 
>> > > "a hint" might not be clear for the reader what does it mean, if it is
>> > > "maybe like that" of "exactly like that". This feature just makes it
>> > > crystal clear.
>> > > 
>> > > If you look at the tap implementation, it uses hdr_len to alloc
>> > > skb linear part. No hint, it counts with the provided value.
>> > > So if the driver is currently not precise, it breaks tap.
>> > Well that's only for gso though right?
>> Yep.
>> 
>> 
>> > And making it bigger than necessary works fine ...
>> Well yeah. But tap does not do that, does it? it uses hdr_len directly.
>
>
>tap_get_user() limit the head length:
>
>
>static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
>                            struct iov_iter *from, int noblock)
>{
>    int good_linear = SKB_MAX_HEAD(TAP_RESERVE);
>...
>
>
>> 
>> 
>> > > I will add this to the patch description and send v2.
>> > > 
>> > I feel this does not answer the question yet, or maybe I am being dense.
>> > My point was not about making hdr_len precise.  My point was that we are
>> > making a change here for no apparent reason. I am guessing you are not
>> > doing it for fun - so why? Is there a device with this feature bit
>> > you are aware of?
>> Afaik real hw which does emulation of virtio_net would benefit from
>> that, our hw including.
>
>
>Note that driver can choose to no negotiate this feature, so malicious
>drivers can still try to use illegal value.

That's probably why the spec says:
5.1.6.2.2
...
Note: Caution should be taken by the implementation so as to prevent a malicious driver from attacking
the device by setting an incorrect hdr_len.

And that is exactly what tun does by caping the linear size to
SKB_MAX_HEAD(TAP_RESERVE)



>
>Thanks
>
>
>> 
>> 
>> > 
>> > 
>> > > > The patch was submitted by Marvell but they never bothered with
>> > > > using it in Linux. I guess they are using it for something else?
>> > > > CC Vitaly who put this in.
>> > > > 
>> > > > > > thanks!
>> > > > > > 
>> > > > > > 
>> > > > > > > ---
>> > > > > > >   drivers/net/virtio_net.c        | 6 ++++--
>> > > > > > >   include/uapi/linux/virtio_net.h | 1 +
>> > > > > > >   2 files changed, 5 insertions(+), 2 deletions(-)
>> > > > > > > 
>> > > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> > > > > > > index fb5e68ed3ec2..e85b03988733 100644
>> > > > > > > --- a/drivers/net/virtio_net.c
>> > > > > > > +++ b/drivers/net/virtio_net.c
>> > > > > > > @@ -62,7 +62,8 @@ static const unsigned long guest_offloads[] = {
>> > > > > > >   	VIRTIO_NET_F_GUEST_UFO,
>> > > > > > >   	VIRTIO_NET_F_GUEST_CSUM,
>> > > > > > >   	VIRTIO_NET_F_GUEST_USO4,
>> > > > > > > -	VIRTIO_NET_F_GUEST_USO6
>> > > > > > > +	VIRTIO_NET_F_GUEST_USO6,
>> > > > > > > +	VIRTIO_NET_F_GUEST_HDRLEN
>> > > > > > >   };
>> > > > > > >   #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
>> > > > > > > @@ -4213,7 +4214,8 @@ static struct virtio_device_id id_table[] = {
>> > > > > > >   	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>> > > > > > >   	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>> > > > > > >   	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
>> > > > > > > -	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
>> > > > > > > +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
>> > > > > > > +	VIRTIO_NET_F_GUEST_HDRLEN
>> > > > > > >   static unsigned int features[] = {
>> > > > > > >   	VIRTNET_FEATURES,
>> > > > > > > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
>> > > > > > > index b4062bed186a..12c1c9699935 100644
>> > > > > > > --- a/include/uapi/linux/virtio_net.h
>> > > > > > > +++ b/include/uapi/linux/virtio_net.h
>> > > > > > > @@ -61,6 +61,7 @@
>> > > > > > >   #define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
>> > > > > > >   #define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
>> > > > > > >   #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
>> > > > > > > +#define VIRTIO_NET_F_GUEST_HDRLEN  59	/* Guest provides the exact hdr_len value. */
>> > > > > > >   #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>> > > > > > >   #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
>> > > > > > >   #define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
>> > > > > > > -- 
>> > > > > > > 2.39.0
>
