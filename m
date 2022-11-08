Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA8B6210CD
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 13:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiKHMdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 07:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiKHMdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 07:33:06 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FDF120A8
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 04:33:05 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id h193so13245018pgc.10
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 04:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cc0zTIQMp+2IVulxoKCjrdKzfHFymjolJ8nXoCe2rd0=;
        b=Fs0WyWWGy8BqS/RnDDJVOspQWuHoR8x37iokYg4n+wk701Tzedgg3YjBp1oKj5iJlW
         O9YBK45t619s8HfSRNi9XtXpOTCittT0g+stMxyqnMPVbn50OdQBLIA66AFrsZJ7a7wq
         b40EN2W3mPWicsF7gLh3a3jLokYmfRpskhd/huAy2n7nQ1EEcUIqcv2Ucs/fC2xP60Gf
         wnN9EUOVjBqZ2IpUCn1RClglYo2WPc3O5RL4ihaF8oujR6msh9+2UTzmisZkDjfZK2II
         q6ImIDxqFljZXyKdvnNWf1cczi+oF2uGakVmHHmmDFQ1la37SiSjjFlaUXkHRNRgcejN
         V9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cc0zTIQMp+2IVulxoKCjrdKzfHFymjolJ8nXoCe2rd0=;
        b=7xyBwXG76qsAFnTFqkbK6rskeiqobyxMdnOY5Q88fhGYSb6m9a5gfM5fPMFXjvgty3
         fDcq/rLf/g4UV8to7ato5/3Td+vagaSZ0uEJ+RX7FtZJ4bIwNaneQfsyFUPQKMEZn9ir
         NNzs9f/0++x6IyTG9SCIjJiruGXw1/zMMX+r9Isgv41DNWWjsOSbUbf8CesNoiRbrNjQ
         yNYheU6SocxVMOrgfE0QXAtVeOimrCMVp7EZYXkxhnCYYBAIP3P1qXoEdNnpuEHJsLD6
         5yL3c0NVeSnJbjfkLHYRR3OPhl0y8KYkCd0nd58E2gX1KxI96c9SNKDqZfoN9mmbiZIs
         G12g==
X-Gm-Message-State: ACrzQf1m4q9/iMoUcLSMWVbUt/wDuZmMKmtxHQgJNrlJ4AqhB9HQor25
        MHpXPgXTfPIHt6qkIEZhlCsfN5WTE+Qgr7zneY/8iulB/18=
X-Google-Smtp-Source: AMsMyM6MoNQA+lBG8Kp8DI4OHN5MLX6pNbV2q9Khs7G9O+RWE1cTLva5PAwdOcUikP3KfFh/QlGBVUF3D9qO/z5QXHw=
X-Received: by 2002:a65:6c08:0:b0:448:c216:fe9 with SMTP id
 y8-20020a656c08000000b00448c2160fe9mr46706533pgu.243.1667910785093; Tue, 08
 Nov 2022 04:33:05 -0800 (PST)
MIME-Version: 1.0
References: <CAHUXu_WyYzuTOiz75VfhST6nL3gm0B49dDMjgkzEQ0m_h4Rh1g@mail.gmail.com>
 <Y1RJvsTpbC6K5I9Y@pop-os.localdomain>
In-Reply-To: <Y1RJvsTpbC6K5I9Y@pop-os.localdomain>
From:   "J.J. Mars" <mars14850@gmail.com>
Date:   Tue, 8 Nov 2022 20:32:13 +0800
Message-ID: <CAHUXu_Vf5f8G3YkWzNQhqi2ZTjNKGu_BwkuV7SzD-Tc_fHW63g@mail.gmail.com>
Subject: Re: Confused about ip_summed member in sk_buff
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your reply. I've been busy these days so that I can't reply on t=
ime.
I've read the annotation about ip_summed in skbuff.h many times but it
still puzzles me so I write my questions here directly.

First of all, I focus on the receive direction only.

Q1: In section 'CHECKSUM_COMPLETE' it said 'The device supplied
checksum of the _whole_ packet as seen by netif_rx() and fills out in
skb->csum. Meaning, the hardware doesn't need to parse L3/L4 headers
to implement this.' So I assume the 'device' is a nic or something
like that which supplied checksum, but the 'hardware' doesn't need to
parse L3/L4 headers. So what's the difference between 'device' and
'hardware'? Which one is the nic?

Q2: Which layer does the checksum refer in section 'CHECKSUM_COMPLETE'
as it said 'The device supplied checksum of the _whole_ packet'. I
assume it refers to both L3 and L4 checksum because of the word
'whole'.

Q3: The full checksum is not calculated when 'CHECKSUM_UNNECESSARY' is
set. What does the word 'full' mean? Does it refer to both L3 and L4?
As it said 'CHECKSUM_UNNECESSARY' is set for some L4 packets, what's
the status of L3 checksum now? Does L3 checksum MUST be right when
'CHECKSUM_UNNECESSARY' is set?

Q4: In section 'CHECKSUM_PARTIAL' it described status of SOME part of
the checksum is valid. As it said this value is set in GRO path, does
it refer to L4 only?

Q5: 'CHECKSUM_COMPLETE' and 'CHECKSUM_UNNECESSARY', which one supplies
the most complete status of checksum? I assume it's
CHECKSUM_UNNECESSARY.

Q6: The name ip_summed doesn't describe the status of L3 only but also
L4? Or just L4?

Hope to receive replies from all you guys.

Best wishes.

Cong Wang <xiyou.wangcong@gmail.com> =E4=BA=8E2022=E5=B9=B410=E6=9C=8823=E6=
=97=A5=E5=91=A8=E6=97=A5 03:51=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Oct 21, 2022 at 02:29:26PM +0800, J.J. Mars wrote:
> > Hi everyone, I'm new here and I hope this mail won't disturb you :)
> >
> > Recently I was working with something about ip_summed, and I'm really
> > confused about the question what does ip_summed exactly mean?
> > This member is defined with comment Driver fed us an IP checksum'. So
> > I guess it's about IP/L3 checksum status.
> > But the possible value of ip_summed like CHECKSUM_UNNECESSARY is about =
L4.
> >
> > What confused me a lot is ip_summed seems to tell us the checksum of
> > IP/L3 layer is available from its name.
> > But it seems to tell us the checksum status of L4 layer from its value.
> >
> > Besides, in ip_rcv() it seems the ip_summed is not used before
> > calculating the checksum of IP header.
> >
> > So does ip_summed indicate the status of L3 checksum status or L4
> > checksum status?
> > If L4, why is it named like that?
>
> The name itself is indeed confusing, however, there are some good
> explanations in the code, at the beginning of include/linux/skbuff.h. I
> think that could help you to clear your confusions here.
>
> Thanks.
