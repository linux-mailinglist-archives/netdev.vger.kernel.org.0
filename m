Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029D96937FD
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 16:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjBLPkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 10:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBLPkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 10:40:24 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0F5CA38
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 07:40:23 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-52eb7a5275aso124360907b3.2
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 07:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZmqKDCjwlbqGqNlxSmQCRxQK26yLu7xByW/jI9dTtqg=;
        b=rSw1MZoWRg6adceS12u9H0tVjxyrB2tgz6TF511WjLd5PlNiOkJb844jQ2OrM97xyP
         98bFZ+B5rbP7d62AbkcuGNh9oUxnsTKOnVWHTef5sMoAcJ5ZT3XT97G1EsWJYE3CRL6O
         bkO5j6C4PTZZUZhXX5l6e58Xj/ATZ8BCSz6ouwWo0sT7vAuGXjkCx2z0Zxb81Dw9X+l1
         SjMJ6QJVCg5FNq9aeik64q2D7vWEe+3knR8dwXSwU66cr0WGMCcCbbDfDmljGo0XGQyY
         bNGNbaDbRU96OwS+v31CPiW2+IXOyY+7lECNTqge3iU7fowDRgDSrxITUqTG81RFEG0Z
         9TvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZmqKDCjwlbqGqNlxSmQCRxQK26yLu7xByW/jI9dTtqg=;
        b=XNRuPkq0cfPn5nGPYIvsov3+Hv0wHrKK5z/uWht7B3fy9bAXC+U8WsKLhkcHmUlmEY
         D7KG7ZhHV3+ff/7jkBbwzTIQKIc2OuDyvvBo6bMzAXIzNHGW97x3ZN3J4NEhdsccLx5c
         5ymwDVjZTzMgF7PWGri+LLPUeRHG9TrxEt7DQuUoBl41QtwtVmkB/EBnSOWgF+zTpPuK
         D83ilQVF53qCN5DYfe+r9vZSGGrXG8QZ0D7vFPjVCIYI/TffmK6ea9bzZdVZYu2D46MN
         xvPoQQC5oVnd2GW2+7yb+nVDySH9LBdGeiOuENoLSaOQJe349084hSlwlPZ6BEL51jcp
         Dy0A==
X-Gm-Message-State: AO0yUKXQ83awgcMWZE5aWXj4GrS04G9zjdamug3esz1nUHN74lQ1FVSP
        MZGkxd181hjXVOAq5nKQJdWhE0y6lP2U+mtjrxjdaRNw4UWdtg==
X-Google-Smtp-Source: AK7set95Yl7AWBFvGpmSdSt501LRdNq8Y5QKIblggT7IbwfKuWCUz3MXj3O49Wth+hQTn+zGaKRkmEqm41mOkB89sf8=
X-Received: by 2002:a05:690c:eab:b0:4ff:a70a:1286 with SMTP id
 cr11-20020a05690c0eab00b004ffa70a1286mr1986099ywb.447.1676216422498; Sun, 12
 Feb 2023 07:40:22 -0800 (PST)
MIME-Version: 1.0
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
 <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
 <20230208220025.0c3e6591@kernel.org> <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
 <a793b8ae257e87fd58e6849f3529f3b886b68262.camel@redhat.com> <1A3363FD-16A1-4A4B-AB30-DD56AFA5FFB0@oracle.com>
In-Reply-To: <1A3363FD-16A1-4A4B-AB30-DD56AFA5FFB0@oracle.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 12 Feb 2023 10:40:11 -0500
Message-ID: <CAM0EoMm4KF=Q22D71gELYYZ2eo-s=Gkvovhe+YBSVQ39VmQRDQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 9, 2023 at 11:36 AM Chuck Lever III <chuck.lever@oracle.com> wrote:
>
>
>
> > On Feb 9, 2023, at 11:02 AM, Paolo Abeni <pabeni@redhat.com> wrote:

[..]

> > IIRC the previous version allowed the user-space to create a socket of
> > the HANDSHAKE family which in turn accept()ed tcp sockets. That kind of
> > construct - assuming I interpreted it correctly - did not sound right
> > to me.
> >
> > Back to these patches, they looks sane to me, even if the whole
> > architecture is a bit hard to follow, given the non trivial cross
> > references between the patches - I can likely have missed some relevant
> > point.
>
> One of the original goals was to support other security protocols
> besides TLS v1.3, which is why the code is split between two
> patches. I know that is cumbersome for some review workflows.
>
> Now is a good time to simplify, if we see a sensible opportunity
> to do so.
>
>
> > I'm wondering if this approach scales well enough with the number of
> > concurrent handshakes: the single list looks like a potential bottle-
> > neck.
>
> It's not clear how much scaling is needed. I don't have a strong
> sense of how frequently a busy storage server will need a handshake,
> for instance, but it seems like it would be relatively less frequent
> than, say, I/O. Network storage connections are typically long-lived,
> unlike http.
>

So this is for storage type traffic only? Assuming TCP/NVME probably.
IOW, is it worth doing the handshake via the kernel for a short flow?
We have done some analysis and TLS handshake certainly affects overall
performance, so moving it into the kernel is a good idea. Question is
how would this interact with a) KTLS b) KTLS offload c) user space
type of crypto needs like quic, etc?

cheers,
jamal
