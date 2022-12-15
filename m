Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB0764E215
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 21:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiLOUAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 15:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiLOUAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 15:00:06 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03217537F8
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 12:00:06 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so218095pjo.3
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 12:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=99Dl3b+Xd16PXSIqrGCyckGZ5mO9meE4tOd/yuF/D/c=;
        b=DU5Rdhj/S2JmHBM7zShQYM6Qp1VszV1vogPDQKhK6too95M4vHOCB85LmaCaIpWTLC
         sbSEAvQpwTS1zKlTHfuDQWNYy3lMGD1gSPTapxyjatKcH3VsXiqizYQxYM51lUUCyFxI
         UF/ldgA+S0Yq3pCjDU1h9znD7RhODukiFP9JoV70EMnQz0dabcSQm99PWLmQpORtdc84
         7MsOM/VY+Ua6OociSvzqi/BiVCayqIS/nh1xIxzDRqw8SyJUGdQLuGd8MnWTxvvmkM+D
         q6tKO/WxRUdLf9OIufaoUBjdnUjQHhz6+xL/0fhl4dMsn5+kXmY57HmUnSB2MsD8HJd/
         j7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=99Dl3b+Xd16PXSIqrGCyckGZ5mO9meE4tOd/yuF/D/c=;
        b=4COBXn2p+/Ja/fIc9bHMB1CSA5gzHSrirPGEaiczVrTIiKfNCIQ14RRSYCNLCwy2hC
         Ob4SFBsocBAa7ZQ/pK0M824EksawUu4U+F2A/miQ+ozZ0gnFKmUI3vfgK1pLDF64wSD6
         qsyWtZLffbOtf0S9/xNuVX/nl3LC3NngkTTYf3PyEt+LMjadgm043EohUahf+wbFFTu8
         +AsvEsc5mxc4MoSf2VfKSRBMT1jENrWodYIHmVQ0axlLAgOJSt2WpygFVwMUHVU94dvQ
         cI5T46Ai+qdByvSwsrRsm2zp+WtnIJQRZu6Dt1CuZiSypEAl2QwT87UoBAhDm0lnd3OJ
         I3+A==
X-Gm-Message-State: ANoB5pmkDsTJg+aOK2wPeFThH6jg+9o6CT/JmFL4gXFdyj62zhVDE9OX
        sc+sOZm3MFds69mnDAv8kWTRv9QwovMqpgHvBfQ=
X-Google-Smtp-Source: AA0mqf7cb5sTE9aY2Qm7WNF3d3uE3SIgzk4kbzBBmJRDsiiPaYROYRRUZr1eY4nHKhPYDxFEQfOPzg0UezRvFHJhUUA=
X-Received: by 2002:a17:902:e313:b0:189:aee3:a185 with SMTP id
 q19-20020a170902e31300b00189aee3a185mr38125313plc.21.1671134405351; Thu, 15
 Dec 2022 12:00:05 -0800 (PST)
MIME-Version: 1.0
References: <20221214000555.22785-1-u9012063@gmail.com> <935e24d6f6b51b5aaee4cf086ad08474e75410b8.camel@gmail.com>
 <CALDO+SaoW5XoroBMoYLWsqCvYYVkKiTFFPMTLUEt7Qu5rQ+z3Q@mail.gmail.com>
 <c213b4c3e8774e59389948b3b9b3ff132043dfcf.camel@gmail.com> <CALDO+Sax4=0tkq1xeH5W3FGaqXtweHj=eKFAUf15J2k7K1_4hA@mail.gmail.com>
In-Reply-To: <CALDO+Sax4=0tkq1xeH5W3FGaqXtweHj=eKFAUf15J2k7K1_4hA@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 15 Dec 2022 11:59:53 -0800
Message-ID: <CAKgT0UdhjAV2qed04SNepa0EvXJKO9QmXLDorQHF9AJ3YqMLHQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5] vmxnet3: Add XDP support.
To:     William Tu <u9012063@gmail.com>
Cc:     netdev@vger.kernel.org, tuc@vmware.com, gyang@vmware.com,
        doshir@vmware.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 10:25 AM William Tu <u9012063@gmail.com> wrote:
>
> On Wed, Dec 14, 2022 at 2:51 PM Alexander H Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Wed, 2022-12-14 at 13:55 -0800, William Tu wrote:
> > > Thanks for taking a look at this patch!
> > >
> > > <...>

> > > How do I avoid overwriting frames that might be waiting on transmit?
> > > I checked my vmxnet3_xdp_xmit_back and vmxnet3_xdp_xmit_frame,
> > > I think since I called the vmxnet3_xdp_xmit_frame at the rx context,
> > > it should be ok?
> >
> > I don't think you can guarantee that. Normally for TX you would want to
> > detach and replace the page unless you have some sort of other
> > recycling/reuse taking care of it for you. Normally that is handled via
> > page pool.
> >
> > On the Intel parts I had gotten around that via our split buffer model
> > so we just switched to the other half of the page while the Tx sat on
> > the first half, and by the time we would have to check again we would
> > either detach the page for flip back if it had already been freed by
> > the Tx path.
> I see your point. So for XDP_TX, I can also do s.t like I did in XDP_REDIRECT,
> memcpy to a freshly allocated page so the frame won't get overwritten.
> Probably the performance will suffer.
> Do you suggest allocating new page or risk buffer overwritten?

This is one of the reasons for the page pool being used in other
drivers. You may want to look at going that route if you want to avoid
the memcpy. I don't think you can leave the page mapped without
risking it will be overwritten.

> >
> > > +static int
> > > +vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
> > > +                   struct xdp_frame *xdpf,
> > > +                   struct sk_buff *skb)
> > >
> >
> > Also after re-reviewing this I was wondering why you have the skb
> > argument for this function? The only caller is passing NULL and I
> > wouldn't expect you to be passing an skb since you are working with XDP
> > buffers anyway. Seems like you could also drop the argument from
> > vmxnet3_xdp_xmit_frame() since you are only passing it NULL as well.
>
> You're right! I don't need to pass skb here. I probably forgot to remove it
> when refactoring code. Will remove the two places.
> Thanks!

Sounds good. I will keep an eye out for v6.
