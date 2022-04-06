Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB63F4F663B
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbiDFQ6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238256AbiDFQ6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:58:12 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F88A2CCB34;
        Wed,  6 Apr 2022 07:21:52 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id b17so4398954lfv.3;
        Wed, 06 Apr 2022 07:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=REQTmVxpj4zme6o+oGdwOZm2l8eVhwiMS6w/mpasR1M=;
        b=JceAsxPVaasjxVoPGWp3s6beeVzBC9VqwMgYprR20jmvB7cEGsvEaDwrmfc/vCj4fl
         J1llof7zAbm9VLTTByQ+VOB0nYuGhj1TdIqDvGAdhbuk5uSWHhcwHrv1018HYJ50NAmW
         FuahQ/GeJqcX8GAnHijNJ0TSMCWyNsmp+f3b26fpvACZaS1BGpHe2pNBME6hClTXdr12
         k+MXXyE9am3kI0FsPVvnSPUcowVBqaP61/xj8BXK2q/QJ6QM4NTurWi19rJxdtuKvN+F
         x7VaR9TUH9qVk5Jbxd90tKvhtezKI4ZgOA4yT+P3DHiMbH8Gkb+F8QtVGLljmMGtjUjY
         OMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=REQTmVxpj4zme6o+oGdwOZm2l8eVhwiMS6w/mpasR1M=;
        b=cff9SUuAAPXZ+I1E3eE79NmAp0WhLTE6mww8ISRs/7+UYj/mA79liu/HQZpQF4us4t
         jy7hmwC04KnKMiVawoHTAQ65jm0pS6W5VJc8pBLTSpvxShhPTEYrrGpomvidL435hccF
         LPjdu18c2PEiA9ur3wliY8A7q4OXf/lxJOQNNoCzguHGtVGOlQHQ4elVuavW6wpbxOO3
         rP1wSWQzIrI1O5I6rPPVEG6CcaRVAG2kMckaNDHb38wIaZFpFsTcCqhnHJfw7wWA8za0
         LRe41JUVaD2XIhLVbAglaL2ppnecqXUHWTFpVt+uqzO7r5KPoQYOhrtl3rqqLY8x0sZd
         QW2Q==
X-Gm-Message-State: AOAM5335jBnPEXo4Rb/mgjvjEZeOkhMggdOWUfvQqAMyej0tLOr/QKQo
        bAgUUnj13ZeFEVSNYl8ThDIgjzb7LZa0V9FlPnZTRI+eX1yaCw==
X-Google-Smtp-Source: ABdhPJy1ozoISNTm+a3R+m01ItIb2+B5czqQun44KpVxUsyer8Q7afXnEOVGNrstlPLTjhhBLBzbVfstEQ5YhyuDIGw=
X-Received: by 2002:ac2:4207:0:b0:442:bf8b:eee with SMTP id
 y7-20020ac24207000000b00442bf8b0eeemr6235067lfh.536.1649254910239; Wed, 06
 Apr 2022 07:21:50 -0700 (PDT)
MIME-Version: 1.0
References: <a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com>
 <CAFqZXNt=Ca+x7PaYgc1jXq-3cKxin-_=UNCSiyVHjbP7OYUKvA@mail.gmail.com>
 <CADvbK_fTnWhnuxR7JkNYeoSB4a1nSX7O0jg4Mif6V_or-tOy3w@mail.gmail.com> <CAFqZXNss=7DMb=75ZBDwL9HrrubkxJK=xu7-kqxX-Mw1FtRuuA@mail.gmail.com>
In-Reply-To: <CAFqZXNss=7DMb=75ZBDwL9HrrubkxJK=xu7-kqxX-Mw1FtRuuA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 6 Apr 2022 10:21:37 -0400
Message-ID: <CADvbK_ciV+evm6JY=uVpsHn1W-Cevp+FRzaQtxJO-CpQ392htQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: use the correct skb for security_sctp_assoc_request
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 6, 2022 at 9:34 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>
> On Tue, Apr 5, 2022 at 1:58 PM Xin Long <lucien.xin@gmail.com> wrote:
> > On Mon, Apr 4, 2022 at 6:15 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > >
> > > Adding LSM and SELinux lists to CC for awareness; the original patch
> > > is available at:
> > > https://lore.kernel.org/netdev/a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com/T/
> > > https://patchwork.kernel.org/project/netdevbpf/patch/a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com/
> > >
> > > On Mon, Apr 4, 2022 at 3:53 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > >
> > > > Yi Chen reported an unexpected sctp connection abort, and it occurred when
> > > > COOKIE_ECHO is bundled with DATA Fragment by SCTP HW GSO. As the IP header
> > > > is included in chunk->head_skb instead of chunk->skb, it failed to check
> > > > IP header version in security_sctp_assoc_request().
> > > >
> > > > According to Ondrej, SELinux only looks at IP header (address and IPsec
> > > > options) and XFRM state data, and these are all included in head_skb for
> > > > SCTP HW GSO packets. So fix it by using head_skb when calling
> > > > security_sctp_assoc_request() in processing COOKIE_ECHO.
> > >
> > > The logic looks good to me, but I still have one unanswered concern.
> > > The head_skb member of struct sctp_chunk is defined inside a union:
> > >
> > > struct sctp_chunk {
> > >         [...]
> > >         union {
> > >                 /* In case of GSO packets, this will store the head one */
> > >                 struct sk_buff *head_skb;
> > >                 /* In case of auth enabled, this will point to the shkey */
> > >                 struct sctp_shared_key *shkey;
> > >         };
> > >         [...]
> > > };
> > >
> > > What guarantees that this chunk doesn't have "auth enabled" and the
> > > head_skb pointer isn't actually a non-NULL shkey pointer? Maybe it's
> > > obvious to a Linux SCTP expert, but at least for me as an outsider it
> > > isn't - that's usually a good hint that there should be a code comment
> > > explaining it.
> > Hi Ondrej,
> >
> > shkey is for tx skbs only, while head_skb is for skbs on rx path.
>
> That makes sense, thanks. I would still be happier if this was
> documented, but the comment would best fit in the struct sctp_chunk
> definition and that wouldn't fit in this patch...
>
> Actually I have one more question - what about the
> security_sctp_assoc_established() call in sctp_sf_do_5_1E_ca()? Is
> COOKIE ACK guaranteed to be never bundled?
COOKIE ACK could also be bundled with DATA.
I didn't change it as it would not break SCTP.
(security_inet_conn_established() returns void)
But I don't mind changing it if you think it's necessary.

Thanks.

>
> --
> Ondrej Mosnacek
> Software Engineer, Linux Security - SELinux kernel
> Red Hat, Inc.
>
