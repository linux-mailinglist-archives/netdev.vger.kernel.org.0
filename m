Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD3369E3BA
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 16:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbjBUPk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 10:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbjBUPkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 10:40:07 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4701F222CD
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:39:37 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id bp25so6399219lfb.0
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HutO66KxdGHGXw1VHimKBSyzTw6e0TxvcOhPJxxjBb0=;
        b=wEIZixv04yJaFPEtg6JdN9oobN3EhiImcU0Co823WH+CzQNc6Ow3t7pJAET3RbY510
         vCCezjypPz/mj2XD0rEwYmJahaENiyWpBPqO28pHhu1ERoeMIuOyod69izUU/ejva0fr
         ktLc9UVkP/ZiboLkh5xKHHpvIE6M+ZPS+NzPtVseb7rK9plTiE6OMzYWGVpsA/RcPOr7
         TJ7r/hGnWEc9p9TGMfoNqZXAiqwVCDrt+Hf41n1T5c8Y8FJnMYz/ypv9EbV9sdfsHZXJ
         55DX9q3NDoWQzFLBCnG8tjGpPIvKAaF7tNlVUYr+CQEZ6DULfIow43bGa53NR5lw+qsT
         loWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HutO66KxdGHGXw1VHimKBSyzTw6e0TxvcOhPJxxjBb0=;
        b=fmAW0/T6M6pTK5hgwDCTUvncuXHssfDh87sE3DDi6NDl8CxfaIJi6bO5MddVICCrGF
         NJXPpJMvXVL+NrQ1Te7dj6CFC7FHSVFtNP+CuAwB0D01oPx/wj5fOH382nnFVJDKfHOm
         MhJqeTv4GV9QKwgc+fNg1PdYt26cPlWA9jTdmX7g3J4uTBGQbJeWWLi4/3RoqvP1gvig
         J7+4R2zDCN/LqS4XOeLe92kjdWPNT4f7z4w2bQ17Q9vrVSdAIuoCulzB4qSHMCSgXRx3
         7P1SGmBOwG4axHb4ZwKXtO2cC/WmX62f0C3uG68cx3faEK62K2m97kSuTeNpiSbn/UKW
         WquQ==
X-Gm-Message-State: AO0yUKVgvLN3dnE7x+NnQz2YxHSAnMmggdseLYeeUz4F+5MZumBWxslD
        DK7jY/3OdiDVDplcP+GjfiDd/w==
X-Google-Smtp-Source: AK7set/vRNIeWrREIcRiKHq0u5h+Fj+Gsr9w4Yql0nAXYDncrBF9KTq5y19jLB+EEC6drEZoWOepGQ==
X-Received: by 2002:a05:6512:32c5:b0:4d8:86c1:4781 with SMTP id f5-20020a05651232c500b004d886c14781mr2106698lfg.22.1676993974766;
        Tue, 21 Feb 2023 07:39:34 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q10-20020ac25a0a000000b004dc4b0ca734sm385566lfn.250.2023.02.21.07.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 07:39:34 -0800 (PST)
Date:   Tue, 21 Feb 2023 16:39:32 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        alvaro.karsz@solid-run.com, vmireyno@marvell.com, parav@nvidia.com
Subject: Re: [patch net-next v2] net: virtio_net: implement exact header
 length guest feature
Message-ID: <Y/TltJnD4k5hB6Z1@nanopsycho>
References: <20230221144741.316477-1-jiri@resnulli.us>
 <63f4df39e0728_ce6df208fe@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63f4df39e0728_ce6df208fe@willemb.c.googlers.com.notmuch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 21, 2023 at 04:11:53PM CET, willemdebruijn.kernel@gmail.com wrote:
>Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
>> set implicates that the driver provides the exact size of the header.
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
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>> v1->v2:
>> - extended patch description
>
>Is the expectation that in-kernel devices support this feature, and
>if so how would it affect them? If I read the spec correctly, devices

Well, the tap driver actually trusts the hdr_len to be of correct header
size nowadays.


>still need to be careful against malicious drivers, so cannot assume
>much beyond what they do today (i.e., a hint).

Malicious how? There is upper limit of size in tap which is checked.
I assume that for hw implementation, that would be the same.

But anyway, this discussion would be rather part of the spec/device
patch, don't you think?


>
>Might be good to point to the definition commit:
>https://github.com/oasis-tcs/virtio-spec/commit/4f1981a1ff46b7aeb801c4c524ff76e93d9ce022

There were couple of fixes to the spec since then, that's why I didn't
include it. It is trivial to look it up in the spec.
