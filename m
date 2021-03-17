Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC9733F9C5
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 21:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbhCQULh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 16:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhCQULA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 16:11:00 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D136C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 13:11:00 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id w37so852323lfu.13
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 13:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GwuY5Os0hwvThFgmnaX2i5CEbiXkSD9Cnc88LImmE8U=;
        b=ib1EAXSgC5DszNXgQNlOZkDzUJYDzPguRpAnO/17t6JQnu6ySfklBaHe4k3kC4o2wC
         abjdNCs4RlVlutyv//RC2MQnHb/R4HezC58AX5kccJuMWt838/NcbpD8jMkrAGdqLX8W
         gyXj0kr6aduMQ7VGrCSYSuPzcuX579VCpDVJoKH2dXUuqc53wE1TBTsZnaL7871AZA1f
         srbM3/iDMdblSN784lxsSDQ7FS0iT9WF3/gtOoFzL+MdgmJ0ygdlnIXrwv5YivVyhpia
         9rTGJ8kyAMcbVqEHmbgOjtzOMIIQIY7Vnb7hyD9HtppttVSk2W1tbUfsk6sOkbrSooDk
         rajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GwuY5Os0hwvThFgmnaX2i5CEbiXkSD9Cnc88LImmE8U=;
        b=jtB3n4OPxO/npGGR9UBWj1TvdXEBxEha1bU7JM6NQVqDlhwJSpwuGx/BCpBbziNxJi
         vtGl/h8HQePbn9Lo7+nc6KuH3xE1L5GOtyHfNLn9IWKoFlciCJo1/nqyl/Hf0cVrc3aP
         X4x1Ghn+/Nmq734GMRXBwoNQ+Zt1pnUQghzaHdM8y1L/1ooerdJm/CFFYAEJKzmEeBfI
         mCN547NvdTjNVHy2esmCFxz1FRWCfmNxT07RKcFWfOwwq4P6xyGZEfd2E3B6lHgQXNDC
         Le1d2NPPBgixanZiLMc0sIC6LjEmsxWkaK6ctiV4bR/Jk2CnACbo5kcd8584343suytQ
         EwAg==
X-Gm-Message-State: AOAM5332SbLEtPErOZQDLL5aePdj6UELLACD1wyHdH6yuj7IeoFc5cK3
        2II4tYcR5nCdAFgaRHVMm19YyXryWHZCMy3lYSP/Vq7476B5sA==
X-Google-Smtp-Source: ABdhPJxtz8HJwcpeOoU4ahq/ATlTmzoMARdNU3cB5yASnd15aVUPUDj4HFPTDwaJ5GULoNKuubrclkfJtO9h0qZywz8=
X-Received: by 2002:a05:6512:39c2:: with SMTP id k2mr3043146lfu.69.1616011858514;
 Wed, 17 Mar 2021 13:10:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210317064148.GA55123@embeddedor> <CAG48ez2RDqKwx=umOHjo_1mYyNQgzvcP=KOw1HgSo4Prs_VQDw@mail.gmail.com>
 <3bd8d009-2ad2-c24d-5c34-5970c52502de@embeddedor.com> <CAG48ez2jr_8MbY_sNXfwvs7WsF-5f9j=U4-66dTcgXd2msr39A@mail.gmail.com>
 <03c013b8-4ddb-8e9f-af86-3c43cd746dbb@embeddedor.com>
In-Reply-To: <03c013b8-4ddb-8e9f-af86-3c43cd746dbb@embeddedor.com>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 17 Mar 2021 21:10:32 +0100
Message-ID: <CAG48ez1heVw2WRUMrGskUyJV0wH4YfgbF=raFKWXXM7oY1zKDA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH][next] ixgbe: Fix out-of-bounds warning
 in ixgbe_host_interface_command()
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, linux-hardening@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 9:04 PM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> On 3/17/21 13:57, Jann Horn wrote:
> >>>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
> >>>> index 62ddb452f862..bff3dc1af702 100644
> >>>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
> >>>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
> >>>> @@ -3679,7 +3679,7 @@ s32 ixgbe_host_interface_command(struct ixgbe_hw *hw, void *buffer,
> >>>>         u32 hdr_size = sizeof(struct ixgbe_hic_hdr);
> >>>>         union {
> >>>>                 struct ixgbe_hic_hdr hdr;
> >>>> -               u32 u32arr[1];
> >>>> +               u32 *u32arr;
> >>>>         } *bp = buffer;
> >>>>         u16 buf_len, dword_len;
> >>>>         s32 status;
> >>>
> >>> This looks bogus. An array is inline, a pointer points elsewhere -
> >>> they're not interchangeable.
> >>
> >> Yep; but in this case these are the only places in the code where _u32arr_ is
> >> being used:
> >>
> >> 3707         /* first pull in the header so we know the buffer length */
> >> 3708         for (bi = 0; bi < dword_len; bi++) {
> >> 3709                 bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
> >> 3710                 le32_to_cpus(&bp->u32arr[bi]);
> >> 3711         }
> >
> > So now line 3709 means: Read a pointer from bp->u32arr (the value
> > being read from there is not actually a valid pointer), and write to
> > that pointer at offset `bi`. I don't see how that line could execute
> > without crashing.
>
> Yeah; you're right. I see my confusion now. Apparently, there is no escape
> from allocating heap memory to fix this issue, as I was proposing in my
> last email.

Why? Can't you do something like this?

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 62ddb452f862..768fa124105b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -3677,10 +3677,8 @@ s32 ixgbe_host_interface_command(struct
ixgbe_hw *hw, void *buffer,
                                 bool return_data)
 {
        u32 hdr_size = sizeof(struct ixgbe_hic_hdr);
-       union {
-               struct ixgbe_hic_hdr hdr;
-               u32 u32arr[1];
-       } *bp = buffer;
+       u32 *bp = buffer;
+       struct ixgbe_hic_hdr hdr;
        u16 buf_len, dword_len;
        s32 status;
        u32 bi;
@@ -3706,12 +3704,13 @@ s32 ixgbe_host_interface_command(struct
ixgbe_hw *hw, void *buffer,

        /* first pull in the header so we know the buffer length */
        for (bi = 0; bi < dword_len; bi++) {
-               bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
-               le32_to_cpus(&bp->u32arr[bi]);
+               bp[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
+               le32_to_cpus(&bp[bi]);
        }

        /* If there is any thing in data position pull it in */
-       buf_len = bp->hdr.buf_len;
+       memcpy(&hdr, bp, sizeof(hdr));
+       buf_len = hdr.buf_len;
        if (!buf_len)
                goto rel_out;

@@ -3726,8 +3725,8 @@ s32 ixgbe_host_interface_command(struct ixgbe_hw
*hw, void *buffer,

        /* Pull in the rest of the buffer (bi is where we left off) */
        for (; bi <= dword_len; bi++) {
-               bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
-               le32_to_cpus(&bp->u32arr[bi]);
+               bp[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
+               le32_to_cpus(&bp[bi]);
        }

 rel_out:
