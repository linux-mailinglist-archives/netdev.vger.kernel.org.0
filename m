Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63AFB50A536
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiDUQ1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390630AbiDUQRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:17:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BAA4F4504D
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650557673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ngZ3ZDY9ywW927Z5RN+MQNpAIO8k9NmG/nkTnk+1Gs=;
        b=RQV6R/OB43yQqrkm5oggp9zm3OQVzwmouCHF2z78ixodK8OWZ+73QtiVn5v5sLXs/47n/e
        LBEFsbpvqxHeeZj870spCCxizcQfMiXe9l8nIRG/ZqVnUtZVauDPYTWM8n3jqP48B57MtD
        I1PDHote2fMra8vv+o1SdBPcIs4Yu+I=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-EyGPkcQPMk-DVDAdrprVIQ-1; Thu, 21 Apr 2022 12:14:32 -0400
X-MC-Unique: EyGPkcQPMk-DVDAdrprVIQ-1
Received: by mail-lj1-f198.google.com with SMTP id 20-20020a05651c009400b002462f08f8d2so1704973ljq.2
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:14:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ngZ3ZDY9ywW927Z5RN+MQNpAIO8k9NmG/nkTnk+1Gs=;
        b=DQ4671nJwEZ0by01MWsSh1DuuBcHQtLN//k+l6F/nWnNBycpDVu4sECu069larz/Se
         S3Uvv1RpX2megXLIE/fYlxO0Z1udjAJTTyY+FsXjXArAA29rGsACaFby+aZusC6qBKTJ
         g274V/xmy8tAF+U1vrCYjTgEGhowyr5FtA+WXNWQ+2miRZ6SGbUQKZiMK0yTQLXZdT0h
         xeuBD/rpCL/B+Vz7KtLLMiM5HBDoQi9wEY1YP4rG1dGmplk5Ljg6ZYnk2S22Fx6R+nda
         ZetmWmgt+iZRzHOrUy/axG5HKzM15Vi1JboPBOhBhxGphcUeNyuTKl8kZQHfyXBf8MBJ
         hreQ==
X-Gm-Message-State: AOAM533vI3TPbdJ35cynZWr9Y3Jjqs6visyvLF9/bP9JEZqKR8ojZGHZ
        GoRJ3RkPtJX0nGW8nv0meMJ9REMF+dg42Ofy9zTh6TDtuBWc6VYsamQW2ORKJk7Ha5ZI/+/5qX8
        QBPByocr9EWRBbq0d1+KWCHsgo6GwU1t9
X-Received: by 2002:a05:6512:68b:b0:471:d466:979b with SMTP id t11-20020a056512068b00b00471d466979bmr145639lfe.519.1650557671047;
        Thu, 21 Apr 2022 09:14:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyH8/DjjuvvyMkckIHc+m1v/FBNR0YvL8JTrt6ayXJd/rtn7oBKbgJ1GEaT0nlskTay3z63zTKH5i8fe1g198I=
X-Received: by 2002:a05:6512:68b:b0:471:d466:979b with SMTP id
 t11-20020a056512068b00b00471d466979bmr145622lfe.519.1650557670855; Thu, 21
 Apr 2022 09:14:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220420200720.434717-1-parri.andrea@gmail.com>
 <20220420200720.434717-4-parri.andrea@gmail.com> <20220421140805.qg4cwqhsq5vuqkut@sgarzare-redhat>
 <20220421152827.GB4679@anparri>
In-Reply-To: <20220421152827.GB4679@anparri>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Thu, 21 Apr 2022 18:14:19 +0200
Message-ID: <CAGxU2F6UCiFQrXu4Nn=jNPbuE8i5hYe=Hkwak43kTMQoCQQy2A@mail.gmail.com>
Subject: Re: [PATCH 3/5] hv_sock: Add validation for untrusted Hyper-V values
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hyperv@vger.kernel.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 5:30 PM Andrea Parri <parri.andrea@gmail.com> wrote:
>
> > > @@ -577,12 +577,19 @@ static bool hvs_dgram_allow(u32 cid, u32 port)
> > > static int hvs_update_recv_data(struct hvsock *hvs)
> > > {
> > >     struct hvs_recv_buf *recv_buf;
> > > -   u32 payload_len;
> > > +   u32 pkt_len, payload_len;
> > > +
> > > +   pkt_len = hv_pkt_len(hvs->recv_desc);
> > > +
> > > +   /* Ensure the packet is big enough to read its header */
> > > +   if (pkt_len < HVS_HEADER_LEN)
> > > +           return -EIO;
> > >
> > >     recv_buf = (struct hvs_recv_buf *)(hvs->recv_desc + 1);
> > >     payload_len = recv_buf->hdr.data_size;
> > >
> > > -   if (payload_len > HVS_MTU_SIZE)
> > > +   /* Ensure the packet is big enough to read its payload */
> > > +   if (payload_len > pkt_len - HVS_HEADER_LEN || payload_len > HVS_MTU_SIZE)
> >
> > checkpatch warns that we exceed 80 characters, I do not have a strong
> > opinion on this, but if you have to resend better break the condition into 2
> > lines.
>
> Will break if preferred.  (but does it really warn??  I understand that
> the warning was deprecated and the "limit" increased to 100 chars...)

I see the warn here:
https://patchwork.kernel.org/project/netdevbpf/patch/20220420200720.434717-4-parri.andrea@gmail.com/

in the kernel doc [1] we still say we prefer 80 columns, so I try to
follow, especially when it doesn't make things worse.

[1] https://docs.kernel.org/process/coding-style.html#breaking-long-lines-and-strings

>
>
> > Maybe even update or remove the comment? (it only describes the first
> > condition, but the conditions are pretty clear, so I don't think it adds
> > much).
>
> Works for me.  (taking it as this applies to the previous comment too.)

Yep.

Thanks,
Stefano

