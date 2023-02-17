Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEAE769ABE9
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjBQMyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjBQMyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:54:01 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004691717E
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:53:58 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id ja15-20020a05600c556f00b003dc52fed235so775832wmb.1
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=45KqkEB3XAWUGWP8wuflSuAHlvBrwamlrO1r+HT6bHo=;
        b=A96uSb+5vY+qrkurwuL+4BLvdu39RIjSO5Pn4Lw4zLJs2Mima7rztmqivSEwSXGQoi
         tGbqRJNF9EZ0yLyM6OLSxrHKut+/Lop8BYeFGZV6TsaTrqYDeFRgl8vF4pvWMMobJ1Ne
         FJWC7AwVZeUbARHRn+qv5CLMP8HCUL/QOipHMNzOcE+LmVO7CfOjIAvkE9OI8nOh3z3Z
         Z/Cb/+b4BSZGTOi28TGU2OL8BABtWUF2Rfv7FUpCOsEdy7PNPXCmsd8XXb8oyidF4PsO
         lZbqsCNW4iobw0LVVCSrpGVLvewIhHQ7i2p4wtTcT9o+ot7foKK7otMhsemcML3r9XSf
         er2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45KqkEB3XAWUGWP8wuflSuAHlvBrwamlrO1r+HT6bHo=;
        b=f4o1Kw2qCzntiSid1I3fhyH70kamSP8mh8+jTc3zZp8qlUWtxHB1w/v/NtWwKgo3dL
         GgzBthbwyWoIaMTDXzBIqDUR/DavjAVkRR5jOqIjqJh/7oqX6pRriTDqbvqEE3BrgsRf
         P2SXKrvCt3B9QUejepZ5/0aimv3kFktBKRJT078SVOTiQP1T2ujfCPdIynPanQcdEu0n
         ib+VvYCTuKeV7dpROqcggCZb/+X4RSZDaSXxc/AZLAgE2YuFnydlo5WIxHwvpeaLQ6Le
         C1rxEQm1msjp0VLwcq8lpCQK83n7YdWZ8qqFwsKqUnXbMDtHlFVVfvNL4LqfrIh7P4Dt
         K95g==
X-Gm-Message-State: AO0yUKV/pev20+JVIzbpx2jsmhjumEHX8pEETA4TFmWnw85uV5Lz7SM+
        JeMN1gX+oXC3nKeI9tiVNhPxepspYJhd1XPJTBJtFQ==
X-Google-Smtp-Source: AK7set8Hp1taGatbfIOYJawb/0OAZoromM7OY6UpatF8LhVN3uM88z6cS36LKj5PPkejFWLqbVPQZQ==
X-Received: by 2002:a05:600c:747:b0:3dc:5a13:c7d1 with SMTP id j7-20020a05600c074700b003dc5a13c7d1mr1005383wmn.16.1676638437462;
        Fri, 17 Feb 2023 04:53:57 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c63-20020a1c3542000000b003df7b40f99fsm8980022wma.11.2023.02.17.04.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 04:53:56 -0800 (PST)
Date:   Fri, 17 Feb 2023 13:53:55 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [patch net-next] net: virtio_net: implement exact header length
 guest feature
Message-ID: <Y+94418p73aUQyIn@nanopsycho>
References: <20230217121547.3958716-1-jiri@resnulli.us>
 <20230217072032-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217072032-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 17, 2023 at 01:22:01PM CET, mst@redhat.com wrote:
>On Fri, Feb 17, 2023 at 01:15:47PM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
>> 
>> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
>> set implicates that the driver provides the exact size of the header.
>> 
>> The driver already complies to fill the correct value. Introduce the
>> feature and advertise it.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
>Could you add a bit of motivation just for the record?
>Does this improve performance for some card? By how much?
>Expected to help some future card?

I can get that info, but isn't that rather something to be appended to
the virtio-spec patch? I mean, the feature is there, this is just
implementing it in one driver.


>
>thanks!
>
>
>> ---
>>  drivers/net/virtio_net.c        | 6 ++++--
>>  include/uapi/linux/virtio_net.h | 1 +
>>  2 files changed, 5 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index fb5e68ed3ec2..e85b03988733 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -62,7 +62,8 @@ static const unsigned long guest_offloads[] = {
>>  	VIRTIO_NET_F_GUEST_UFO,
>>  	VIRTIO_NET_F_GUEST_CSUM,
>>  	VIRTIO_NET_F_GUEST_USO4,
>> -	VIRTIO_NET_F_GUEST_USO6
>> +	VIRTIO_NET_F_GUEST_USO6,
>> +	VIRTIO_NET_F_GUEST_HDRLEN
>>  };
>>  
>>  #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
>> @@ -4213,7 +4214,8 @@ static struct virtio_device_id id_table[] = {
>>  	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>>  	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>>  	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
>> -	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
>> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
>> +	VIRTIO_NET_F_GUEST_HDRLEN
>>  
>>  static unsigned int features[] = {
>>  	VIRTNET_FEATURES,
>> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
>> index b4062bed186a..12c1c9699935 100644
>> --- a/include/uapi/linux/virtio_net.h
>> +++ b/include/uapi/linux/virtio_net.h
>> @@ -61,6 +61,7 @@
>>  #define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
>>  #define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
>>  #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
>> +#define VIRTIO_NET_F_GUEST_HDRLEN  59	/* Guest provides the exact hdr_len value. */
>>  #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>>  #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
>>  #define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
>> -- 
>> 2.39.0
>
