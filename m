Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCA6669D0A
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjAMQAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjAMP7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 10:59:35 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2A087910
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 07:50:49 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v30so31709984edb.9
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 07:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Sne7IxwR3g4oWt9fVB2kj6IgmNoJJ6G8CQCq3BEz2C0=;
        b=QW4IJ6axteTm8Eq3nxRyUaxSEPYzw5SY5Kh06aWmRIRjc1CV/UPClcj32g8PqdCEsK
         X0v8PN1C4/QMFwHRKVSkrgiTxqoG+mFTfcMxc4aoLU5BR9spS7H5uGcZbv7PP4Sugzbz
         lQpUPpsQVaxAz+j/92oeEXroqGcygs8fmrHBqWb8hUWEY4IZL3SwvFve2B+2RmVf6wqj
         0w8X5nbxNVLEo9yTLIRMHrQWAzjTIn+gUP4JrA2SHUUQTZEX+vxnpQByEp6vmjJj/uZi
         STN8EoVpTW1Ty0frncDEX8z52NnsYOwpGHwYHr/Xc++7WEAxza+wS/N+wvdNvZtp1oZP
         ImBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sne7IxwR3g4oWt9fVB2kj6IgmNoJJ6G8CQCq3BEz2C0=;
        b=zzFGsWZi1XmtyGlCq+c3XODNBYYxpr2rOQmDr4s8rcLGmz5ZuFBfops4Ja9fMZ+/QU
         hO3kAZJcLrEARBhrpVTTWc0HgRyLL6NH/6JzkSWqvaMAQoRCjpC8MoNkXGg2TNWLmKNH
         EBkyO3O0KksihhJc8PHAKuG/+GDLBdXyBSvLDMMXSvv6NbudNKK8h1fDjKcsvxzFDQ+6
         K6gJj2H4fcaFEzcpz/PZd9njopxp4dNwiIk3QZzud9pEs6/jTOgLiR7kzYurPz9lwJXu
         DkOYW7PRqELXeJZyEppad7eu4Nxu6cYh4bZ/NEu4vU2YTItX9A/NjYykhLU8GvWf287r
         n/0w==
X-Gm-Message-State: AFqh2krCzWiY1DZvisJGVvAz9s3aPRuGUuLLE3rVLPotA0zh1/Vnr2uO
        js5ETwp+P4FDAye+q8PeYX5N8u5jaFHQN/1nXgU=
X-Google-Smtp-Source: AMrXdXvI2WP06TjJmgLoSXrMRSMsgNlkyq/2YnWWVkR3qY1vX92DonHGwBPEYFEwYfAjqaXu1rxdNc7tln7T0sqmsrk=
X-Received: by 2002:a05:6402:50e:b0:499:b405:98b9 with SMTP id
 m14-20020a056402050e00b00499b40598b9mr2559604edv.385.1673625047319; Fri, 13
 Jan 2023 07:50:47 -0800 (PST)
MIME-Version: 1.0
References: <20230111130520.483222-1-dnlplm@gmail.com> <b8f798f7b29a257741ba172d43456c3a79454e9c.camel@gmail.com>
In-Reply-To: <b8f798f7b29a257741ba172d43456c3a79454e9c.camel@gmail.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Fri, 13 Jan 2023 16:43:19 +0100
Message-ID: <CAGRyCJGFhNfbHs=qhdOg9DYOq_tLOska2r2B08WTBbnFyXXjhw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 0/3] add tx packets aggregation to ethtool and rmnet
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>, Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Alexander,

Il giorno ven 13 gen 2023 alle ore 00:00 Alexander H Duyck
<alexander.duyck@gmail.com> ha scritto:
>
> On Wed, 2023-01-11 at 14:05 +0100, Daniele Palmas wrote:
> > Hello maintainers and all,
> >
> > this patchset implements tx qmap packets aggregation in rmnet and generic
> > ethtool support for that.
> >
> > Some low-cat Thread-x based modems are not capable of properly reaching the maximum
> > allowed throughput both in tx and rx during a bidirectional test if tx packets
> > aggregation is not enabled.
>
> One question I would have about this is if you are making use of Byte
> Queue Limits and netdev_xmit_more at all? I know for high speed devices
> most of us added support for xmit_more because PCIe bandwidth was
> limiting when we were writing the Tx ring indexes/doorbells with every
> packet. To overcome that we added netdev_xmit_more which told us when
> the Qdisc had more packets to give us. This allowed us to better
> utilize the PCIe bus by bursting packets through without adding
> additional latency.
>

no, I was not aware of BQL: this development has been basically
modelled on what other mobile broadband drivers do (e.g.
cdc_mbim/cdc_ncm, Qualcomm downstream rmnet implementation), that are
not using BQL.

If I understand properly documentation

rmnet0/queues/tx-0/byte_queue_limits/limit_max

would be the candidate for replacing ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES.

But I can't find anything for ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES
and ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS, something that should work
in combination with the bytes limit: at least the first one is
mandatory, since the modem can't receive more than a certain number
(this is a variable value depending on the modem model and is
collected through userspace tools).

ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES works also as a way to determine
that tx aggregation has been enabled by the userspace tool managing
the qmi requests, otherwise no aggregation should be performed.

> > I verified this problem with rmnet + qmi_wwan by using a MDM9207 Cat. 4 based modem
> > (50Mbps/150Mbps max throughput). What is actually happening is pictured at
> > https://drive.google.com/file/d/1gSbozrtd9h0X63i6vdkNpN68d-9sg8f9/view
> >
> > Testing with iperf TCP, when rx and tx flows are tested singularly there's no issue
> > in tx and minor issues in rx (not able to reach max throughput). When there are concurrent
> > tx and rx flows, tx throughput has an huge drop. rx a minor one, but still present.
> >
> > The same scenario with tx aggregation enabled is pictured at
> > https://drive.google.com/file/d/1jcVIKNZD7K3lHtwKE5W02mpaloudYYih/view
> > showing a regular graph.
> >
> > This issue does not happen with high-cat modems (e.g. SDX20), or at least it
> > does not happen at the throughputs I'm able to test currently: maybe the same
> > could happen when moving close to the maximum rates supported by those modems.
> > Anyway, having the tx aggregation enabled should not hurt.
> >
> > The first attempt to solve this issue was in qmi_wwan qmap implementation,
> > see the discussion at https://lore.kernel.org/netdev/20221019132503.6783-1-dnlplm@gmail.com/
> >
> > However, it turned out that rmnet was a better candidate for the implementation.
> >
> > Moreover, Greg and Jakub suggested also to use ethtool for the configuration:
> > not sure if I got their advice right, but this patchset add also generic ethtool
> > support for tx aggregation.
>
> I have concerns about this essentially moving queueing disciplines down
> into the device. The idea of doing Tx aggregation seems like something
> that should be done with the qdisc rather than the device driver.
> Otherwise we are looking at having multiple implementations of this
> aggregation floating around. It seems like it would make more sense to
> have this batching happen at the qdisc layer, and then the qdisc layer
> would pass down a batch of frames w/ xmit_more set to indicate it is
> flushing the batch.

Honestly, I'm not expert enough to give a reliable opinion about this.

I feel like these settings are more related to the hardware, requiring
also a configuration on the hardware itself done by the user, so
ethtool would seem to me a good choice, but I may be biased since I
did this development :-)

Thanks,
Daniele
