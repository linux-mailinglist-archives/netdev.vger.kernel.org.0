Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFCB5BDFCA
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 10:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiITIVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 04:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiITIUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 04:20:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1C0BC19
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663661914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nYBXnM221OKkMmYnX56agU4HA29O1+0qE07dmbgFr1Y=;
        b=F0OgTcmRQgV+Ch8wa63Iif3veP7AxynKLHbV79zgrraolhR+oDpdSGMZABtGOhz71Udllp
        9/cqc6NHBuE4WvXuHuepAwiPmqRWO4MRwY/MFSWh+7YpzdfaSb7AlD31hCh24ud/DuIayk
        n3f5z9hyD9GmZuEBubv5zcGJVBaxBak=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-31-9IJxjVreNDae-G8KOgs1rw-1; Tue, 20 Sep 2022 04:18:31 -0400
X-MC-Unique: 9IJxjVreNDae-G8KOgs1rw-1
Received: by mail-wm1-f70.google.com with SMTP id p24-20020a05600c1d9800b003b4b226903dso5929738wms.4
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=nYBXnM221OKkMmYnX56agU4HA29O1+0qE07dmbgFr1Y=;
        b=ZneDCsOcf/MTuJqhT2NwL3BMrjkThI/I/cIKy1gOZr/evVhFb2Z1YlZu5Vc4A7w5Fb
         93qJM9vK1LvX1R8p/ON99JCICyqHmdHKU7jlxUF9GMb/78tRWlTY1lC3RTvwzGFC+kuU
         AsFhrdm2dKlGLhSOuGPNQKvfkgoPyP8xYDa8k6Gm+jS1yLkeoKslU8lyx/zCqBIFhQF8
         XZYmkTFejFv9SXWIzez9kGHyYh0b8wq3C6k3kI8IfdOmAVM9w5ZO0C2Mb82qkOkkKyKK
         SiUFyjco49IR1bEdTgJtc6jmghZ4oo1B4rLHBZRdlyNkx32Wi7R9TPy310IU527L5eF8
         2giw==
X-Gm-Message-State: ACrzQf3oP7VQis3T2NoZpekTnnZEEL50dbATwVoFDl7maH+ZtlqhCBpO
        E5U96usFw9MEzvfuJIG88+KoWuioyNNIjXhcXxL66hbwh89FvsUMGMxiiyz6LLrLU3uGvlB/vJv
        SEtjVI+vj3xcw5OUt
X-Received: by 2002:a5d:4ec5:0:b0:228:6707:8472 with SMTP id s5-20020a5d4ec5000000b0022867078472mr13700965wrv.12.1663661910615;
        Tue, 20 Sep 2022 01:18:30 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Gc746EtqOMp12PC/ZhI3qlffavJ9O8HKgnaDgO6702xNdn3VPX99CEZYZBDDZBLY3QzW+vw==
X-Received: by 2002:a5d:4ec5:0:b0:228:6707:8472 with SMTP id s5-20020a5d4ec5000000b0022867078472mr13700953wrv.12.1663661910369;
        Tue, 20 Sep 2022 01:18:30 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-69.retail.telecomitalia.it. [87.11.6.69])
        by smtp.gmail.com with ESMTPSA id z22-20020a05600c0a1600b003b4868eb6bbsm1749112wmp.23.2022.09.20.01.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 01:18:29 -0700 (PDT)
Date:   Tue, 20 Sep 2022 10:18:24 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     vdasa@vmware.com, vbhakta@vmware.com, namit@vmware.com,
        bryantan@vmware.com, zackr@vmware.com,
        linux-graphics-maintainer@vmware.com, doshir@vmware.com,
        gregkh@linuxfoundation.org, davem@davemloft.net,
        pv-drivers@vmware.com, joe@perches.com, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] MAINTAINERS: Update entries for some VMware drivers
Message-ID: <20220920081824.vshwiv3lt5crlxdj@sgarzare-redhat>
References: <20220906172722.19862-1-vdasa@vmware.com>
 <20220919104147.1373eac1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220919104147.1373eac1@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 10:41:47AM -0700, Jakub Kicinski wrote:
>On Tue,  6 Sep 2022 10:27:19 -0700 vdasa@vmware.com wrote:
>> From: Vishnu Dasa <vdasa@vmware.com>
>>
>> This series updates a few existing maintainer entries for VMware
>> supported drivers and adds a new entry for vsock vmci transport
>> driver.
>
>Just to be sure - who are you expecting to take these in?
>

FYI Greg already queued this series in his char-misc-next branch:
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/log/?h=char-misc-next

Thanks,
Stefano

