Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80B7665816
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237975AbjAKJvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbjAKJta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:49:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30CA11828
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673430441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UE0xeHCU2bfsdgMc1zyv/Lgw7gDb0/ii1vRY0TiYYqA=;
        b=F0Qzc9pOcBHuo5Dde0ELojDlA4f5urFDt1ws+oXym06rv8eG33z9EgVqY3ASn5cGyA6ktC
        q6QYvf6FWHasKjS14G1dqiRtZQJxxBRCLqclHzmhwOkLjUeLQ9FqSGibRbLofFu8ywA/Su
        8JLKUOldYAVYoQfpgZJcigTnV6uwMqo=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-93-_juGmWoAOMGKyUSrm4nUCA-1; Wed, 11 Jan 2023 04:47:19 -0500
X-MC-Unique: _juGmWoAOMGKyUSrm4nUCA-1
Received: by mail-il1-f199.google.com with SMTP id g11-20020a056e021a2b00b0030da3e7916fso6906911ile.18
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:47:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UE0xeHCU2bfsdgMc1zyv/Lgw7gDb0/ii1vRY0TiYYqA=;
        b=31JYm60ADEn1NlLDfp3W9mnVXocSqAY/G0iMQ3wjxi7/rqQxnBci9W+pnb1Hzt1sfL
         JUCxF/HX2A5TkUWPIvLnl+DSL5U2l05rY+co5WElTgh2qORbzUDCTtNGkS1MqDPBZYBn
         twBG3TpkeO5Nd/PnPTfbpiN2BhWeDLnDVN+4AdJGmGK90r1xPEG6/jDu3KiGrFm7M4ZX
         Q60YL89ttv3dkFsmbLZuWb1odDgY9jDiBulU9EsdQVMp6rluMEmKG8lL1Wjfxz1tbgv6
         0a+XoRTp2dSCTXEWPrbO34cxZA22Z6tVug0H8RVLC+CO0v4JGbpTJOJP7LlLomTzkJPu
         N26A==
X-Gm-Message-State: AFqh2kozIQv/6oKFR5VQzSC7HgpVtBf19dCVsse6YstiP0sVA6Evos9I
        VT1DKcyuMKy0W/ZHBomkkfdgaBKtOHMaWM6+cXQ6N9lEl3ZVLYsguR3GnLyolG7T8jzYXxKopwE
        OIH8h4RP93hUC6/k+2fIJbqR8aDArKyyz
X-Received: by 2002:a05:6602:449:b0:6df:bfeb:f15d with SMTP id e9-20020a056602044900b006dfbfebf15dmr5813367iov.122.1673430439237;
        Wed, 11 Jan 2023 01:47:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtMGuR8Fz8YM4jgsNWownmj/QbuhKvKMrvrkynsYoffbOpUWKeQSLAK7R9clAJLj9D4yWVopYxCWeyDIqtLC0Q=
X-Received: by 2002:a05:6602:449:b0:6df:bfeb:f15d with SMTP id
 e9-20020a056602044900b006dfbfebf15dmr5813358iov.122.1673430439027; Wed, 11
 Jan 2023 01:47:19 -0800 (PST)
MIME-Version: 1.0
References: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
 <20230106102332.1019632-7-benjamin.tissoires@redhat.com> <20230111061054.dqduab66plb6uzg2@macbook-pro-6.dhcp.thefacebook.com>
In-Reply-To: <20230111061054.dqduab66plb6uzg2@macbook-pro-6.dhcp.thefacebook.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Wed, 11 Jan 2023 10:47:07 +0100
Message-ID: <CAO-hwJLk7dNYHiharC0wR0563aTE9NfD_jE5qxdoM9m0pW__cA@mail.gmail.com>
Subject: Re: [PATCH HID for-next v1 6/9] HID: bpf: rework how programs are
 attached and stored in the kernel
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 7:11 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jan 06, 2023 at 11:23:29AM +0100, Benjamin Tissoires wrote:
> >
> > +static void hid_bpf_link_release(struct bpf_link *link)
> > +{
> > +     struct hid_bpf_link *hid_link =
> > +             container_of(link, struct hid_bpf_link, link);
> > +
> > +     __clear_bit(hid_link->index, jmp_table.enabled);
> > +     schedule_work(&release_work);
> > +}
>
> ...
>
> > +     link->index = prog_idx;
>
> I was super confused that you use prog_idx as a bit in jmp_table
> and had to look into your tree what hid_bpf_jmp_table.c is doing.
> Looks like it's not prog_id (which is prog->aux->id) that we know.
> It's hid specific prog idx in that jmp table.
> Maybe would be good to rename your prog_idx to something with 'hid' suffix or prefix?
> or 'table' suffix or prefix ?
> prog_table_idx ?

prog_table_idx sounds good :)

>
> Other than that the patch set looking great.

great, thanks!

> I'm assuming removing call_hid_bpf_prog_put_deferred() and everything related
> comes in the next set?
>

Yep. I'll probably send it tomorrow. I have a bunch of urgent
corporate stuff to do today so won't have time for the fun part of the
job :(

Cheers,
Benjamin

