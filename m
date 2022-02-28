Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F164C725C
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 18:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbiB1RQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 12:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbiB1RQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 12:16:22 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D3E74DC2
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:15:43 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id i1so11304944plr.2
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c3jES/MWXROupZlLhXD3/nZtFOtL9jKvxxOu5N/ZF2U=;
        b=6bruvRBPzu5N+K8jNWZSzzyg0icNW1GmXwDlmkVwXez9VtCKvxGdvmHr/CH7/3mSkE
         WwP0gauUNRFNJhpWDNwWC35ed/4lfHCLqFcxEzYQidb7vQnfOPr75AZndLxrRb2n4tjl
         wkZEUtRMDzInbedJz24LrQzPpgwUpPGYxYXFncezzwkUSr1OIVzg1wxw4VXrh3HxWRXh
         i+I9kDFqoW8OCrFuYfLK8dkHlvygbDepVp0TKKLJJ7aH5DFzi4dFtiyqNjtyCE2X40R0
         6oo9CErRGGqH7Kb8UO3ka/lWkAc7/yEbM2PbrqhU0lqGATmtXsxM3czaQD4q5EtoW2vR
         KuEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c3jES/MWXROupZlLhXD3/nZtFOtL9jKvxxOu5N/ZF2U=;
        b=iHOJX1BNnw8KjCR03ksLtmMdex+YLVPJzwM6vyMRw1DIex8EZ/ekAvP5JZz9I0AkwI
         CHQtnvfd+uwZ7RDwUZZ2EY1EaoI4MJvCXjRiUuQ6bOorU9zIGotfvY8bXQvfX+v1LzxY
         vakHrFROFbnpBcVVNbBPgh8xysqAvGyiiBb7rwSaC6E7Y0KKBn4mRmZm/gDpTaOJC8iF
         SobA1xJqUNPHf+0Tz1Pt7p2lkybIZI3RHtXoKxv58bxswqRVKCAshodih87xrvl68hl/
         9UPjM72P7tgURIGH7LnDWy1T022ENO493ieLvzzIlMB+o/LQlzwApXADvUgwegJYAjU0
         VUdg==
X-Gm-Message-State: AOAM532PFJ1i1Ayv2Vj6/WxobeqYk7/EfbMw5tAyJBclvDzWohOAbh6w
        KVocxlR1EDKZoD/CN+d9KV1fRQ==
X-Google-Smtp-Source: ABdhPJyYJJcqGTqz8EuDk56BKYpIS/Xu45TRpGfUKMr2JtY0rlBNc7jaqn+NltNr+sa8o8Ig/t5gxA==
X-Received: by 2002:a17:902:c286:b0:151:605c:fadd with SMTP id i6-20020a170902c28600b00151605cfaddmr7633678pld.100.1646068542622;
        Mon, 28 Feb 2022 09:15:42 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id oc3-20020a17090b1c0300b001bce36844c7sm11588990pjb.17.2022.02.28.09.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 09:15:42 -0800 (PST)
Date:   Mon, 28 Feb 2022 09:15:39 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Harold Huang <baymaxhuang@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next v3] tun: support NAPI for packets received from
 batched XDP buffs
Message-ID: <20220228091539.057c80ef@hermes.local>
In-Reply-To: <CACGkMEtFFe3mVkXYjYJZtGdU=tAB+T5TYCqySzSxR2N5e4UV1A@mail.gmail.com>
References: <20220224103852.311369-1-baymaxhuang@gmail.com>
        <20220228033805.1579435-1-baymaxhuang@gmail.com>
        <CACGkMEtFFe3mVkXYjYJZtGdU=tAB+T5TYCqySzSxR2N5e4UV1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 15:46:56 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On Mon, Feb 28, 2022 at 11:38 AM Harold Huang <baymaxhuang@gmail.com> wrote:
> >
> > In tun, NAPI is supported and we can also use NAPI in the path of
> > batched XDP buffs to accelerate packet processing. What is more, after
> > we use NAPI, GRO is also supported. The iperf shows that the throughput of
> > single stream could be improved from 4.5Gbps to 9.2Gbps. Additionally, 9.2
> > Gbps nearly reachs the line speed of the phy nic and there is still about
> > 15% idle cpu core remaining on the vhost thread.
> >
> > Test topology:
> > [iperf server]<--->tap<--->dpdk testpmd<--->phy nic<--->[iperf client]
> >
> > Iperf stream:
> > iperf3 -c 10.0.0.2  -i 1 -t 10
> >
> > Before:
> > ...
> > [  5]   5.00-6.00   sec   558 MBytes  4.68 Gbits/sec    0   1.50 MBytes
> > [  5]   6.00-7.00   sec   556 MBytes  4.67 Gbits/sec    1   1.35 MBytes
> > [  5]   7.00-8.00   sec   556 MBytes  4.67 Gbits/sec    2   1.18 MBytes
> > [  5]   8.00-9.00   sec   559 MBytes  4.69 Gbits/sec    0   1.48 MBytes
> > [  5]   9.00-10.00  sec   556 MBytes  4.67 Gbits/sec    1   1.33 MBytes
> > - - - - - - - - - - - - - - - - - - - - - - - - -
> > [ ID] Interval           Transfer     Bitrate         Retr
> > [  5]   0.00-10.00  sec  5.39 GBytes  4.63 Gbits/sec   72          sender
> > [  5]   0.00-10.04  sec  5.39 GBytes  4.61 Gbits/sec               receiver
> >
> > After:
> > ...
> > [  5]   5.00-6.00   sec  1.07 GBytes  9.19 Gbits/sec    0   1.55 MBytes
> > [  5]   6.00-7.00   sec  1.08 GBytes  9.30 Gbits/sec    0   1.63 MBytes
> > [  5]   7.00-8.00   sec  1.08 GBytes  9.25 Gbits/sec    0   1.72 MBytes
> > [  5]   8.00-9.00   sec  1.08 GBytes  9.25 Gbits/sec   77   1.31 MBytes
> > [  5]   9.00-10.00  sec  1.08 GBytes  9.24 Gbits/sec    0   1.48 MBytes
> > - - - - - - - - - - - - - - - - - - - - - - - - -
> > [ ID] Interval           Transfer     Bitrate         Retr
> > [  5]   0.00-10.00  sec  10.8 GBytes  9.28 Gbits/sec  166          sender
> > [  5]   0.00-10.04  sec  10.8 GBytes  9.24 Gbits/sec               receiver
> >
> > Reported-at: https://lore.kernel.org/all/CACGkMEvTLG0Ayg+TtbN4q4pPW-ycgCCs3sC3-TF8cuRTf7Pp1A@mail.gmail.com
> > Signed-off-by: Harold Huang <baymaxhuang@gmail.com>  
> 
> Acked-by: Jason Wang <jasowang@redhat.com>

Would this help when using sendmmsg and recvmmsg on the TAP device?
Asking because interested in speeding up another use of TAP device, and wondering
if this would help.
