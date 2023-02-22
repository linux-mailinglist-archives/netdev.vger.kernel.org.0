Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706A169F376
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 12:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjBVLcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 06:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBVLcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 06:32:15 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CDA28D19
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 03:32:12 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id e9so7406560ljn.9
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 03:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ie1EAFQskbLzZ9c2yaNowwo9PJlaG1TNIeFawZhYi0=;
        b=xWNgHhp8xCIMwy7xA2QF5fvHhjJIN7RaD2lzH5hVBAweuJCGQVwDtqwoDrDKNsHdj/
         6xuR4XRfzJBp6jc4zWN9+83WCqmZMYauiH0QbaxWN2cX0edNa7GksmJDl1ONaOjMZln5
         9vqOtwaXQDvMnpCHDv/g3Qf8IXdPjR3KMnFulByRAhMWY77/7Z6PZsEeptCYPaHb33rV
         sMFWqIyEdU3fAAS3VOmzDm51cvES0MtscEuuMXeLTMjE278Xzpc6FDmOxvTCnWxqr+jI
         dVs+unrHiugxXC14B8PYzY8HeQahpyXG8o0DPjui9fwxBfFaq/LGDNvmaj5RrWKQNi6B
         nO0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ie1EAFQskbLzZ9c2yaNowwo9PJlaG1TNIeFawZhYi0=;
        b=rOYpaSWTvLYhhFxV8YkCVBPTfLJgUb0yy6mUujnutb2W098oCzZ0sF/HU4z9Vflviv
         lTpsFIZmQ6K3iR/F/0geWy1gcwKfpa/0mEzMrqF/oXvcxGHexeGvWCf8D+cJ9Jr6NtTe
         79V8iogsFkSShWsj9YKIWY45J1+mA9qEEcOwVNWxM/nBeOZerLeJ9v+iu7oSjz5GYMX6
         lZb2xkQ7DWColTuhbOU2W1paClc1Z3Oeehi5tU6rq3E8Ol5qCIUhKbOL+qlfgrt4U+G4
         6xPOY/EKjtiASq6iuIwMHlpP+O31AwJiYkrlTSwzv0zhruMKh82qVrePWuyKrWz+lgwd
         EQVw==
X-Gm-Message-State: AO0yUKVvFzRXF02btk35AQBkNSjK5Ri5Y8iwIWdIOzXzlR0hegaislg8
        EhiFPIrs5UZR3+cvno97fQkO4g==
X-Google-Smtp-Source: AK7set+I8w4pkOUhwzpfmgCYOfKOm3eSL1n1kvZ0XXIfmWo9tLlMJhHKbv1hRKDeX2oMfvGFV/1esA==
X-Received: by 2002:a2e:505e:0:b0:293:4e64:1058 with SMTP id v30-20020a2e505e000000b002934e641058mr2951517ljd.35.1677065530839;
        Wed, 22 Feb 2023 03:32:10 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t5-20020a2e9c45000000b002934baca39bsm913872ljj.47.2023.02.22.03.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 03:32:10 -0800 (PST)
Date:   Wed, 22 Feb 2023 12:32:08 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        alvaro.karsz@solid-run.com, vmireyno@marvell.com, parav@nvidia.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [patch net-next v3] net: virtio_net: implement exact header
 length guest feature
Message-ID: <Y/X9OKgGEbxCVdn9@nanopsycho>
References: <20230222080638.382211-1-jiri@resnulli.us>
 <20230222062208-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222062208-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 22, 2023 at 12:24:18PM CET, mst@redhat.com wrote:
>On Wed, Feb 22, 2023 at 09:06:38AM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
>> which when 
>
>which when which when is probably unintentional :)

I copy-pasted your text :)

Anyway, I guess net-next is closed anyway. Will fix&send after merge
window closes.


>
>>set implicates that device benefits from knowing the exact
>> size of the header. For compatibility, to signal to the device that
>> the header is reliable driver also needs to set this feature.
>> Without this feature set by driver, device has to figure
>> out the header size itself.
>> 
>> Quoting the original virtio spec:
>> "hdr_len is a hint to the device as to how much of the header needs to
>>  be kept to copy into each packet"
>> 
>> "a hint" might not be clear for the reader what does it mean, if it is
>> "maybe like that" of "exactly like that". This feature just makes it
>> crystal clear and let the device count on the hdr_len being filled up
>> by the exact length of header.
>> 
>> Also note the spec already has following note about hdr_len:
>> "Due to various bugs in implementations, this field is not useful
>>  as a guarantee of the transport header size."
>> 
>> Without this feature the device needs to parse the header in core
>> data path handling. Accurate information helps the device to eliminate
>> such header parsing and directly use the hardware accelerators
>> for GSO operation.
>> 
>> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
>> The driver already complies to fill the correct value. Introduce the
>> feature and advertise it.
>> 
>> Note that virtio spec also includes following note for device
>> implementation:
>> "Caution should be taken by the implementation so as to prevent
>>  a malicious driver from attacking the device by setting
>>  an incorrect hdr_len."
>> 
>> There is a plan to support this feature in our emulated device.
>> A device of SolidRun offers this feature bit. They claim this feature
>> will save the device a few cycles for every GSO packet.
>> 
>> Link: https://docs.oasis-open.org/virtio/virtio/v1.2/cs01/virtio-v1.2-cs01.html#x1-230006x3
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> Reviewed-by: Parav Pandit <parav@nvidia.com>
>> Reviewed-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>> ---
>> v2->v3:
>> - changed the first paragraph in patch description according to
>>   Michael's suggestion
>> - added Link tag with link to the spec
>> v1->v2:
>> - extended patch description
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
