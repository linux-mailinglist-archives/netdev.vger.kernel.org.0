Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C7D51053F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 19:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbiDZRYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 13:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiDZRXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 13:23:55 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E5A38795
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 10:20:47 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id h8so700414iov.12
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 10:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2xt2bp7x87CoZowz/+tBHRcsZ+XY0BlT50TGFgS7h/w=;
        b=gxmHxPn7Dnw01zE08iDHw8bZRVqwGe4ygKYL0Se9OrUFYZ5iNeCJn462eOg/lu2+pP
         Y/t5JIKwQ5s1as6hEseYYolITNW45/TWsHDkoLBryBQWOaQjP8Jfudwh+Mji5W060Rnj
         3J72fIn4ofNg/fUPRWth3Jm+hSTV7DOio/5M0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2xt2bp7x87CoZowz/+tBHRcsZ+XY0BlT50TGFgS7h/w=;
        b=MTrsqDHFhXSWuweb3+nqiCoaO2ew5I7eZkdQZJwsXbm2sMYRXZ8lhaEk4gMp2nKuoV
         5xS+YkVY9ZQkp4IWWp9pPQpaf4RFy9hRleXJNXw44S7ADp44DJUocU3l5wNQTIuurU4m
         m+vKoE1xYl/b1Nm3F5SMSVI9wU0dxDc8zBZUN/Wt+n1r8VD2mY1ShUR85VUU07Z//4ku
         RDlMvfiEL8WQjEl11VUO0PZQHPYLFUyOUTzT6briuup3A6SHNaNuHZdIXP6tRhpERHCX
         J0rnX2ocUb5WE52Fdmqi2aU9v90ZQtkizLFA0z7jwFun1+d2GdqBzBmGLMEEXjenXjTZ
         LfSg==
X-Gm-Message-State: AOAM533AliNV4pbzWA40vbYfII2497HKOUH4d/enOO8qTzEoxqMvDQnb
        6S3JSO/2w7K6yrgVDx2WLBNYTWGMvGQ9Tjjcs7rZ//TQAiTrQQ==
X-Google-Smtp-Source: ABdhPJzYtrBwwIY+ZQ3w19qLj2iDwJPTNb8XnvRMTDIdR5OR5ZXdNBv6tcNrZDkwYKk98HmYG9ELvr1Z+mAZQgL/8Uw=
X-Received: by 2002:a05:6602:1406:b0:649:d35b:4bbb with SMTP id
 t6-20020a056602140600b00649d35b4bbbmr10101251iov.23.1650993646158; Tue, 26
 Apr 2022 10:20:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220418231746.2464800-1-grundler@chromium.org>
 <CANEJEGtaFCRhVBaVtHrQiJvwsuBk3f_4RNTg87CWERHt+453KA@mail.gmail.com> <23cbe4be-7ced-62da-8fdb-366b726fe10f@marvell.com>
In-Reply-To: <23cbe4be-7ced-62da-8fdb-366b726fe10f@marvell.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Tue, 26 Apr 2022 10:20:35 -0700
Message-ID: <CANEJEGtVFE8awJz3j9j7T2BseJ5qMd_7er7WbdPQNgrdz9F5dg@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH 0/5] net: atlantic: more fuzzing fixes
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     Grant Grundler <grundler@chromium.org>,
        Dmitry Bezrukov <dbezrukov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Aashay Shringarpure <aashay@google.com>,
        Yi Chou <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[reply-all again since I forgot to tell gmail to post this as "plain
text"...grrh... so much for AI figuring this stuff out.]


On Tue, Apr 26, 2022 at 9:00 AM Igor Russkikh <irusskikh@marvell.com> wrote=
:
>
> Hi Grant,
>
> Sorry for the delay, I was on vacation.
> Thanks for working on this.

Hi Igor!
Very welcome! And yes, I was starting to wonder... but I'm now glad
that you didn't review them before you got back. These patches are no
reason to ruin a perfectly good vacation. :)

> I'm adding here Dmitrii, to help me review the patches.
> Dmitrii, here is a full series:
>
> https://patchwork.kernel.org/project/netdevbpf/cover/20220418231746.24648=
00-1-grundler@chromium.org/
>
> Grant, I've reviewed and also quite OK with patches 1-4.

Excellent! \o/


> For patch 5 - why do you think we need these extra comparisons with softw=
are head/tail?

The ChromeOS security team (CC'd) believes the driver needs to verify
"expected behavior". In other words, the driver expects the device to
provide new values of tail index which are between [tail,head)
("available to fill").

Your question makes me chuckle because I asked exactly the same
question. :D Everyone agrees it is a minimum requirement to verify the
index was "in bounds". And I agree it's prudent to verify the device
is "well behaved" where we can. I haven't looked at the code enough to
know what could go wrong if, for example, the tail index is
decremented instead of incremented or a "next fragment" index falls in
the "available to fill" range.

However, I didn't run the fuzzer and, for now, I'm taking the ChromeOS
security team's word that this check is needed. If you (or Dmitrii)
feel strongly the driver can handle malicious or firmware bugs in
other ways, I'm not offended if you decline this patch. However, I
would be curious what those other mechanisms are.

> From what I see in logic, only the size limiting check is enough there..
>
> Other extra checks are tricky and non intuitive..

Yes, somewhat tricky in the code but conceptually simple: For the RX
buffer ring, IIUC, [head,tail) is "CPU to process" and [tail, head) is
"available to fill". New tail values should always be in the latter
range.

The trickiness comes in because this is a ring buffer and [tail, head)
it is equally likely that head =3D< tail  or head > tail numerically.

If you like, feel free to add comments explaining the ring behavior or
ask me to add such a comment (and repost #5). I'm a big fan of
documenting non-intuitive things in the code. That way the next person
to look at the code can verify the code and the IO device do what the
comment claims.

On the RX buffer ring, I'm also wondering if there is a race condition
such that the driver uses stale values of the tail pointer when
walking the RX fragment lists and validating index values. Aashay
assures me this race condition is not possible and I am convinced this
is true for the TX buffer ring where the driver is the "producer"
(tells the device what is in the TX ring). I still have to review the
RX buffer handling code more and will continue the conversation with
him until we agree.

cheers,
grant

>
> Regards,
>   Igor
>
> On 4/21/2022 9:53 PM, Grant Grundler wrote:
> > External Email
> >
> > ----------------------------------------------------------------------
> > Igor,
> > Will you have a chance to comment on this in the near future?
> > Should someone else review/integrate these patches?
> >
> > I'm asking since I've seen no comments in the past three days.
> >
> > cheers,
> > grant
> >
> >
> > On Mon, Apr 18, 2022 at 4:17 PM Grant Grundler <grundler@chromium.org>
> > wrote:
> >>
> >> The Chrome OS fuzzing team posted a "Fuzzing" report for atlantic driv=
er
> >> in Q4 2021 using Chrome OS v5.4 kernel and "Cable Matters
> >> Thunderbolt 3 to 10 Gb Ethernet" (b0 version):
> >>
> >> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__docs.google.com=
_document_d_e_2PACX-2D1vT4oCGNhhy-5FAuUqpu6NGnW0N9HF-5Fjxf2kS7raOpOlNRqJNiT=
HAtjiHRthXYSeXIRTgfeVvsEt0qK9qK_pub&d=3DDwIBaQ&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=
=3D3kUjVPjrPMvlbd3rzgP63W0eewvCq4D-kzQRqaXHOqU&m=3DQoxR8WoQQ-hpWu_tThQydP3-=
6zkRWACvRmj_7aY1qo2FG6DdPdI86vAYrfKQFMHX&s=3D620jqeSvQrGg6aotI35cWwQpjaL94s=
7TFeFh2cYSyvA&e=3D
> >>
> >> It essentially describes four problems:
> >> 1) validate rxd_wb->next_desc_ptr before populating buff->next
> >> 2) "frag[0] not initialized" case in aq_ring_rx_clean()
> >> 3) limit iterations handling fragments in aq_ring_rx_clean()
> >> 4) validate hw_head_ in hw_atl_b0_hw_ring_tx_head_update()
> >>
> >> I've added one "clean up" contribution:
> >>     "net: atlantic: reduce scope of is_rsc_complete"
> >>
> >> I tested the "original" patches using chromeos-v5.4 kernel branch:
> >>
> >> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__chromium-2Drevi=
ew.googlesource.com_q_hashtag-3Apcinet-2Datlantic-2D2022q1-2B-28status-3Aop=
en-2520OR-2520status-3Amerged-29&d=3DDwIBaQ&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3D=
3kUjVPjrPMvlbd3rzgP63W0eewvCq4D-kzQRqaXHOqU&m=3DQoxR8WoQQ-hpWu_tThQydP3-6zk=
RWACvRmj_7aY1qo2FG6DdPdI86vAYrfKQFMHX&s=3D1a1YwJqrY-be2oDgGAG5oOyZDnqIok_2p=
5G-N8djo2I&e=3D
> >>
> >> The fuzzing team will retest using the chromeos-v5.4 patches and the b=
0
> >> HW.
> >>
> >> I've forward ported those patches to 5.18-rc2 and compiled them but am
> >> currently unable to test them on 5.18-rc2 kernel (logistics problems).
> >>
> >> I'm confident in all but the last patch:
> >>    "net: atlantic: verify hw_head_ is reasonable"
> >>
> >> Please verify I'm not confusing how ring->sw_head and ring->sw_tail
> >> are used in hw_atl_b0_hw_ring_tx_head_update().
> >>
> >> Credit largely goes to Chrome OS Fuzzing team members:
> >>     Aashay Shringarpure, Yi Chou, Shervin Oloumi
> >>
> >> cheers,
> >> grant
