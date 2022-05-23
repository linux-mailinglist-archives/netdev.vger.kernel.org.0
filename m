Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6521530E05
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbiEWKd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234056AbiEWKd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:33:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 713334C41E
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653302034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=78ac/DMFK1OOmwHWGMBq2QKTWVFTkeD18ihAxO0CrpU=;
        b=SlxOBM61onEZ3pptYfoSnJD7EHTTNpAMrINKtYIDKj3K0Euhnn1YMxt0IWJCTn6K7qkPoO
        mdgu84825dI7GnodIEGgqDl3N9OgxaKUriE5qnegMLJrNMkQwWUK1MY47hoN9qmtLuYRoQ
        t+tYJ/AW2hExFBM213VbsJXFxwOu8hg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-mQu0o2kbMU6n3UvCtybZEw-1; Mon, 23 May 2022 06:33:53 -0400
X-MC-Unique: mQu0o2kbMU6n3UvCtybZEw-1
Received: by mail-qv1-f70.google.com with SMTP id p4-20020a056214122400b00461c2b40243so10675207qvv.8
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:33:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=78ac/DMFK1OOmwHWGMBq2QKTWVFTkeD18ihAxO0CrpU=;
        b=bGMyHOy3UqUUXpx5JGAPv6pQP615ZAPwTtsqtoP3enqO3Kev702Q40X/2ae4MxE4m9
         LZ0047gE8dDlrYaBEpKWXQPtDuYEQNZ0aqlZ60ViAf1VGljeiUoV4+QSFuF+ZXgPgtc9
         SBjtDavIFFswXRVthdlQKtYa4w7WPzqP0oGBGK7HUWYroo2UYdfZ2BIcRpOmfrk3Z7Xi
         5vpPfQkbl4VaMLVrD9x7xA+kB7sUaZHbQniihxDjydkNDvWux0VnUoYMT9D3CaYN+OZA
         DqBVJHT7KzD+jgHOpBQ7YEiOKckW/2JmWha6LZ9LN3Jyy2hoaSpD1+SDilZh88e5dGxq
         /XYg==
X-Gm-Message-State: AOAM531bUSLmGdEkUl/RCTW/eN6f24BT2uo1O/n73jo8tgK0M5BVSSMG
        B/Zm1+9U3qWJz5b0ADXpPG8Q7sSnVonDPQU409iPy+HXIpxWSTIcLE1r+bv7JnCIFt8tkk/jjtU
        C4cIcPSzX6/5+yMjE
X-Received: by 2002:a05:6214:d03:b0:462:344c:554a with SMTP id 3-20020a0562140d0300b00462344c554amr4410754qvh.104.1653302032783;
        Mon, 23 May 2022 03:33:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOhcME+iqnGQ+8oMBw4rB9qB1dqWoT+TKPGVVrDkWiFqKYa95gJvT8iPBruG4tBG4TJqmtkQ==
X-Received: by 2002:a05:6214:d03:b0:462:344c:554a with SMTP id 3-20020a0562140d0300b00462344c554amr4410748qvh.104.1653302032604;
        Mon, 23 May 2022 03:33:52 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id k14-20020a37a10e000000b0069fc13ce1f7sm4263939qke.40.2022.05.23.03.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:33:51 -0700 (PDT)
Date:   Mon, 23 May 2022 12:33:45 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] vhost-vdpa: Fix some error handling path in
 vhost_vdpa_process_iotlb_msg()
Message-ID: <20220523103345.6jf3r5e3ox5uvmk4@sgarzare-redhat>
References: <89ef0ae4c26ac3cfa440c71e97e392dcb328ac1b.1653227924.git.christophe.jaillet@wanadoo.fr>
 <CACGkMEtvgL+MxBmhWZ-Hn-QjfS-MBm7gvLoQHhazOiwrLxxUJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACGkMEtvgL+MxBmhWZ-Hn-QjfS-MBm7gvLoQHhazOiwrLxxUJA@mail.gmail.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 12:41:03PM +0800, Jason Wang wrote:
>On Sun, May 22, 2022 at 9:59 PM Christophe JAILLET
><christophe.jaillet@wanadoo.fr> wrote:
>>
>> In the error paths introduced by the commit in the Fixes tag, a mutex may
>> be left locked.
>> Add the correct goto instead of a direct return.
>>
>> Fixes: a1468175bb17 ("vhost-vdpa: support ASID based IOTLB API")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>> WARNING: This patch only fixes the goto vs return mix-up in this function.
>> However, the 2nd hunk looks really spurious to me. I think that the:
>> -               return -EINVAL;
>> +               r = -EINVAL;
>> +               goto unlock;
>> should be done only in the 'if (!iotlb)' block.
>
>It should be fine, the error happen if
>
>1) the batched ASID based request is not equal (the first if)
>2) there's no IOTLB for this ASID (the second if)
>
>But I agree the code could be tweaked to use two different if instead
>of using a or condition here.

Yeah, I think so!

Anyway, this patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

