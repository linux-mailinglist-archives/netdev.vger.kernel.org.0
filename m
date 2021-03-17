Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F2D33F892
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 19:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbhCQS6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 14:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbhCQS6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 14:58:13 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A00C06175F
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 11:58:12 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id u20so4472951lja.13
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 11:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4tkhXz7ciBpwwPumsE8QZTmyp8AevItredkFY7TSORQ=;
        b=E5uNQ5HR2vm/LcV09nz3Jy9xCy4NevVtgcwEskfoCxV0rh3LoaOeF1rVJdHkhThgla
         OTgXFFEnsj1kovBCJU2GLDgdQPDGlAFX5lP/lTIl3+y5CThXEWZO8+DoGHBwpH00/9eR
         gee/VOKAIre91MnnvaNmSjynUKSJUVpFdRqzj1jVDxoQPbJH2CLaKvBERLTn+qjksv82
         9jzbKUHOdrHW7hsA9xmNS2XQhTyGspCBiyA4QnJTkmiry8dZdtrNVWlKY0tBGh+BuG2A
         ZHWj6NitZnMqBsRbgiCxqhMHWCEAfk6VgDLMPkvqgHE3r+ZcUw7i6YxPt8qPvjO8sRjb
         /CJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4tkhXz7ciBpwwPumsE8QZTmyp8AevItredkFY7TSORQ=;
        b=K1fnX7/5ysA/1IFZD19BNcKwF+k2zsveiABgpmW6E/Dg7SheuEOxlIQ5Nped2ca65j
         EkL3HUaXsID1GgaxcxCgWyou3pp+HU9YcwIJw7bYajFJffZLqMIuClWq/9BFIbjm9+AC
         m/+bLFQ2lTI2XdXrgbypYoCmBq5VbNcS588bXpzlZtpOHwUBaVuNP/XwCr4X27qaMzjd
         DZJLr1MFei5J3epKNMmA2uJIMZGc2nWbzOrQvPHxnVlx6DGuW/m9a6IufV0zdzVdTPK5
         3z1smO8dz2JH671rRZdhJjOxgfNuoFpSMU1L6TCHnnW4jYFqp07W08B5QilYxbYHqZ8t
         446A==
X-Gm-Message-State: AOAM530zIN7Q+lbaB5fFv519UP1o3NqPAGl2JxWlA8ZsmbGNd3I74cZt
        05F4qyWKiWkiWL8dqfulDSqhgDGyMNQp48VYgPgBq0TVrX/CZw==
X-Google-Smtp-Source: ABdhPJwaPhnsiLqqCDjn4YrthpikIfaOtSJjzyFR2YNIAhcPW965YmQXEKwVehsmEmAxjilmIDVwpz9hTiGhU6JLzsQ=
X-Received: by 2002:a05:651c:1134:: with SMTP id e20mr3228605ljo.385.1616007490899;
 Wed, 17 Mar 2021 11:58:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210317064148.GA55123@embeddedor> <CAG48ez2RDqKwx=umOHjo_1mYyNQgzvcP=KOw1HgSo4Prs_VQDw@mail.gmail.com>
 <3bd8d009-2ad2-c24d-5c34-5970c52502de@embeddedor.com>
In-Reply-To: <3bd8d009-2ad2-c24d-5c34-5970c52502de@embeddedor.com>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 17 Mar 2021 19:57:44 +0100
Message-ID: <CAG48ez2jr_8MbY_sNXfwvs7WsF-5f9j=U4-66dTcgXd2msr39A@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 7:27 PM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> On 3/17/21 12:11, Jann Horn wrote:
> > On Wed, Mar 17, 2021 at 8:43 AM Gustavo A. R. Silva
> > <gustavoars@kernel.org> wrote:
> >> Fix the following out-of-bounds warning by replacing the one-element
> >> array in an anonymous union with a pointer:
> >>
> >>   CC [M]  drivers/net/ethernet/intel/ixgbe/ixgbe_common.o
> >> drivers/net/ethernet/intel/ixgbe/ixgbe_common.c: In function =E2=80=98=
ixgbe_host_interface_command=E2=80=99:
> >> drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:3729:13: warning: arra=
y subscript 1 is above array bounds of =E2=80=98u32[1]=E2=80=99 {aka =E2=80=
=98unsigned int[1]=E2=80=99} [-Warray-bounds]
> >>  3729 |   bp->u32arr[bi] =3D IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, =
bi);
> >>       |   ~~~~~~~~~~^~~~
> >> drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:3682:7: note: while re=
ferencing =E2=80=98u32arr=E2=80=99
> >>  3682 |   u32 u32arr[1];
> >>       |       ^~~~~~
> >>
> >> This helps with the ongoing efforts to globally enable -Warray-bounds.
> >>
> >> Notice that, the usual approach to fix these sorts of issues is to
> >> replace the one-element array with a flexible-array member. However,
> >> flexible arrays should not be used in unions. That, together with the
> >> fact that the array notation is not being affected in any ways, is why
> >> the pointer approach was chosen in this case.
> >>
> >> Link: https://github.com/KSPP/linux/issues/109
> >> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> >> ---
> >>  drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers=
/net/ethernet/intel/ixgbe/ixgbe_common.c
> >> index 62ddb452f862..bff3dc1af702 100644
> >> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
> >> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
> >> @@ -3679,7 +3679,7 @@ s32 ixgbe_host_interface_command(struct ixgbe_hw=
 *hw, void *buffer,
> >>         u32 hdr_size =3D sizeof(struct ixgbe_hic_hdr);
> >>         union {
> >>                 struct ixgbe_hic_hdr hdr;
> >> -               u32 u32arr[1];
> >> +               u32 *u32arr;
> >>         } *bp =3D buffer;
> >>         u16 buf_len, dword_len;
> >>         s32 status;
> >
> > This looks bogus. An array is inline, a pointer points elsewhere -
> > they're not interchangeable.
>
> Yep; but in this case these are the only places in the code where _u32arr=
_ is
> being used:
>
> 3707         /* first pull in the header so we know the buffer length */
> 3708         for (bi =3D 0; bi < dword_len; bi++) {
> 3709                 bp->u32arr[bi] =3D IXGBE_READ_REG_ARRAY(hw, IXGBE_FL=
EX_MNG, bi);
> 3710                 le32_to_cpus(&bp->u32arr[bi]);
> 3711         }

So now line 3709 means: Read a pointer from bp->u32arr (the value
being read from there is not actually a valid pointer), and write to
that pointer at offset `bi`. I don't see how that line could execute
without crashing.
