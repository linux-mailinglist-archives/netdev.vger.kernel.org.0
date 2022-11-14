Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0FF4627A35
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbiKNKNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbiKNKNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:13:13 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1F21EECD
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:12:39 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id a5so16496116edb.11
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=99BSSraKrQkj3TL77zl4yeVoc9ITdkl4D02aJBtPjug=;
        b=CU4LzNXdKqXMVUDv9WiRS+KY5T+H3T6kjz9llba1wYgi28IAw/pFxwQWgQtpDrkKkk
         Y3YwIWOODPB/TbbKqGNKH5wOYIgyO/r8IHF4Drinct/630wGZrahii4QbO3qK1pxfOzl
         Rd//JLETkfdDc3ZWX5zNcYqgUh21xqOrKew+ovhNXKBlciDK74yRjMRZrfQAFX5fCxaU
         yLbEMP9VDlxgCJKRceFlzT2J+sFUKYcgg5OOVmh0g9YayeCNKA2LF/yjKMf1henfMLti
         iirj81AF4fe+eg/LnyRGmsGsyalUiNU06O/JRiX5iVdVNyeChmQSTzabEzNjMw4Nufwl
         5IJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=99BSSraKrQkj3TL77zl4yeVoc9ITdkl4D02aJBtPjug=;
        b=TilAhPCk/Gq4ojXcGhyS1gBV0bF5NVGvVVZKKWzRg/jtuMqsTZ1p84x+bB1PQ03tTF
         JpHV+hSSrxiKqtfpeNXypQx+srFlcvyrMKNwaxh8T27qCSRQIhvAFuGA+NVbfQ8KmDe7
         MYsDV6OhW5Q9Wb0dSAncp4CGnaYyZ0ov/ZvA66gMJB8L+kh3d5ls4fGXt9zIwszZ6EGA
         19eOnTfvvkwaqCWGe+UivMt8gQla28mJx8plzOXzFkdAid3VPy/j7C2eskhCCFFr4+PM
         BgnnoJIdMxsTgomxx07lkJFRpE1SavgkhMci1inKTlWtQSXYaTD/wYjfi86v0aojeUVD
         GwQA==
X-Gm-Message-State: ANoB5pkpbkvZYdoRh+0GMdXJ/iNkVSd/jNK9zHI32ECZelaLgbLwRDb5
        LeY4N9lq3cx3kbRR1Cm2F1aRdCUXGMl9lOeWH6g=
X-Google-Smtp-Source: AA0mqf6CWoc2fkpsTk8YHxGpEQvqvEKE1Li58Htob0zYv3CXo0dE3vIUYyTBm9syOn6a9JgHZMvnM8inB+0PNaDUnJk=
X-Received: by 2002:a05:6402:380c:b0:467:481e:9e2 with SMTP id
 es12-20020a056402380c00b00467481e09e2mr10696315edb.352.1668420757933; Mon, 14
 Nov 2022 02:12:37 -0800 (PST)
MIME-Version: 1.0
References: <20221109180249.4721-1-dnlplm@gmail.com> <20221109180249.4721-2-dnlplm@gmail.com>
 <20221111090720.278326d1@kernel.org> <8b0aba42-627a-f5f5-a9ec-237b69b3b03f@nvidia.com>
In-Reply-To: <8b0aba42-627a-f5f5-a9ec-237b69b3b03f@nvidia.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Mon, 14 Nov 2022 11:06:19 +0100
Message-ID: <CAGRyCJF49NMTt9aqPhF_Yp5T3cof_GtL7+v8PeowsBQWG0bkJQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] ethtool: add tx aggregation parameters
To:     Gal Pressman <gal@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Gal,

Il giorno dom 13 nov 2022 alle ore 10:48 Gal Pressman <gal@nvidia.com>
ha scritto:
>
> On 11/11/2022 19:07, Jakub Kicinski wrote:
> > On Wed,  9 Nov 2022 19:02:47 +0100 Daniele Palmas wrote:
> >> Add the following ethtool tx aggregation parameters:
> >>
> >> ETHTOOL_A_COALESCE_TX_MAX_AGGR_SIZE
> >> Maximum size of an aggregated block of frames in tx.
> > perhaps s/size/bytes/ ? Or just mention bytes in the doc? I think it's
> > the first argument in coalescing expressed in bytes, so to avoid
> > confusion we should state that clearly.
> >
> >> ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES
> >> Maximum number of frames that can be aggregated into a block.
> >>
> >> ETHTOOL_A_COALESCE_TX_USECS_AGGR_TIME
> >> Time in usecs after the first packet arrival in an aggregated
> >> block for the block to be sent.
> > Can we add this info to the ethtool-netlink.rst doc?
> >
> > Can we also add a couple of sentences describing what aggregation is?
> > Something about copying the packets into a contiguous buffer to submit
> > as one large IO operation, usually found on USB adapters?
> >
> > People with very different device needs will read this and may pattern
> > match the parameters to something completely different like just
> > delaying ringing the doorbell. So even if things seem obvious they are
> > worth documenting.
>
> Seems like I am these people, I was under the impression this is kind of
> a threshold for xmit more or something?
> What is this contiguous buffer?

I would like to explain the issue I'm trying to solve.

I'm using an USB modem that is driven by qmi_wwan which creates a
netdevice: on top of this the rmnet module creates another netdevice,
needed since packets sent to the modem needs to follow the qmap
protocol both for multiplexing and performance.

Without tx packets aggregation each tx packet sent to the rmnet
netdevice makes an URB to be sent through qmi_wwan/usbnet, so that
there is a 1:1 relation between a qmap packet and an URB.

So far, this has not been an issue, but I've run into a family of
modems for which this behavior does not work well, preventing the
modem from reaching the maximum throughput both in rx and tx (an
example of the issue is described at
https://lore.kernel.org/netdev/CAGRyCJEkTHpLVsD9zTzSQp8d98SBM24nyqq-HA0jbvHUre+C4g@mail.gmail.com/
)

Tx packets aggregation allows to overcome this issue, so that a single
URB holds N qmap packets, reducing URBs frequency.

The maximum number of allowed packets in a single URB and the maximum
size of the URB are dictated by the modem through the qmi control
protocol: the values returned by the modem are then configured in the
driver with the new ethtool parameters.

> Isn't this the same as TX copybreak? TX
> copybreak for multiple packets?

I tried looking at how tx copybreak works to understand your comment,
but I could not find any useful document. Probably my fault, but can
you please point me to something I can read?

Thanks,
Daniele
