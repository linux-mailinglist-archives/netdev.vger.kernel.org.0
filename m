Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0186687AD
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 00:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240569AbjALXAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 18:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240497AbjALXAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 18:00:01 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187965373E
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 15:00:00 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id jn22so21662497plb.13
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 15:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P4yRqT0cZObEkCaSOORsoI+aC3KfWWyBWuqXOe8C6e0=;
        b=aXEGDoepJyhIX0743J/2Mw9yuGnmm4CqdguE3TeP56YBzOQgVV21ym3oF8aJazmPc9
         6mTVhGw4VHb7ysnwnuDFX9aVoOjz6fly/Nb+Kr2QJVphqKaOUqqt6F0jO3fU9MWWh9kT
         IMAN1yWMS1JGd4IYFbwBQvvE3u9CCiZfqNgWW773Jekxy3ObY3altTjbKKnDauJIYVor
         OG7EO899SPQRish7AvS2sSLmF38JXYzX9n3squ/RdUREv0rcC/Uf5dVVjJo46AQ+6nPu
         HIDPZ4GDBaSRLiOWRR6kroBDW9tggZD53sZk/k2u0406Ictus/Jv43HnF/v364ytu8rf
         rg/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P4yRqT0cZObEkCaSOORsoI+aC3KfWWyBWuqXOe8C6e0=;
        b=pcER3VSpLvgYnzKaSD5xkPPJ7i81SVkkkJ8JqUn6MoNkPRw7qf/qLdomCgEladIUsR
         Diq0fsax0LCi9HQ0iG7pnOaHkT0bxNwgkdnzumdeP7r3taAbl/fwXkj4vywR2edJFuLU
         1PDf0kIVBC+Ef5xEKtaOYjZYMI6Mz8vHHlpHWX7gcri8nUNcqBUPh0K6H/w2fK/SUnd+
         lPTeJwCBlnRJ0SuiYAS7SpMl0BBdDtQqIizo1WFadJtEclPc1FwpTEXnp74PJy5580mh
         AY0VvKEVhg4YYm9NWpSZ1wP31Kr4ZMfZlQzCDZjth1Ogk92X7AA4PIW53xUbWisHQmTq
         Z6dA==
X-Gm-Message-State: AFqh2koBu6BQKzeLl0ZqXmtrmQeEfDi+yq741NDieLNfVX0EGAdU1pPf
        QL0SD/synwGpKYs23bSUNl0=
X-Google-Smtp-Source: AMrXdXuHr3nMy4TTP4RV2823F6Grz3iqdXPSa9QZnHsrv3Oe+K23JX3GgFTvtyA3NdpUbkXWsUyLvg==
X-Received: by 2002:a17:902:8686:b0:194:3fd8:f56a with SMTP id g6-20020a170902868600b001943fd8f56amr10892381plo.55.1673564399340;
        Thu, 12 Jan 2023 14:59:59 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id t13-20020a1709027fcd00b00176b84eb29asm12640253plb.301.2023.01.12.14.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 14:59:58 -0800 (PST)
Message-ID: <b8f798f7b29a257741ba172d43456c3a79454e9c.camel@gmail.com>
Subject: Re: [PATCH net-next v4 0/3] add tx packets aggregation to ethtool
 and rmnet
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Daniele Palmas <dnlplm@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>, Dave Taht <dave.taht@gmail.com>
Cc:     =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Date:   Thu, 12 Jan 2023 14:59:57 -0800
In-Reply-To: <20230111130520.483222-1-dnlplm@gmail.com>
References: <20230111130520.483222-1-dnlplm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-01-11 at 14:05 +0100, Daniele Palmas wrote:
> Hello maintainers and all,
>=20
> this patchset implements tx qmap packets aggregation in rmnet and generic
> ethtool support for that.
>=20
> Some low-cat Thread-x based modems are not capable of properly reaching t=
he maximum
> allowed throughput both in tx and rx during a bidirectional test if tx pa=
ckets
> aggregation is not enabled.

One question I would have about this is if you are making use of Byte
Queue Limits and netdev_xmit_more at all? I know for high speed devices
most of us added support for xmit_more because PCIe bandwidth was
limiting when we were writing the Tx ring indexes/doorbells with every
packet. To overcome that we added netdev_xmit_more which told us when
the Qdisc had more packets to give us. This allowed us to better
utilize the PCIe bus by bursting packets through without adding
additional latency.

> I verified this problem with rmnet + qmi_wwan by using a MDM9207 Cat. 4 b=
ased modem
> (50Mbps/150Mbps max throughput). What is actually happening is pictured a=
t
> https://drive.google.com/file/d/1gSbozrtd9h0X63i6vdkNpN68d-9sg8f9/view
>=20
> Testing with iperf TCP, when rx and tx flows are tested singularly there'=
s no issue
> in tx and minor issues in rx (not able to reach max throughput). When the=
re are concurrent
> tx and rx flows, tx throughput has an huge drop. rx a minor one, but stil=
l present.
>=20
> The same scenario with tx aggregation enabled is pictured at
> https://drive.google.com/file/d/1jcVIKNZD7K3lHtwKE5W02mpaloudYYih/view
> showing a regular graph.
>=20
> This issue does not happen with high-cat modems (e.g. SDX20), or at least=
 it
> does not happen at the throughputs I'm able to test currently: maybe the =
same
> could happen when moving close to the maximum rates supported by those mo=
dems.
> Anyway, having the tx aggregation enabled should not hurt.
>=20
> The first attempt to solve this issue was in qmi_wwan qmap implementation=
,
> see the discussion at https://lore.kernel.org/netdev/20221019132503.6783-=
1-dnlplm@gmail.com/
>=20
> However, it turned out that rmnet was a better candidate for the implemen=
tation.
>=20
> Moreover, Greg and Jakub suggested also to use ethtool for the configurat=
ion:
> not sure if I got their advice right, but this patchset add also generic =
ethtool
> support for tx aggregation.

I have concerns about this essentially moving queueing disciplines down
into the device. The idea of doing Tx aggregation seems like something
that should be done with the qdisc rather than the device driver.
Otherwise we are looking at having multiple implementations of this
aggregation floating around. It seems like it would make more sense to
have this batching happen at the qdisc layer, and then the qdisc layer
would pass down a batch of frames w/ xmit_more set to indicate it is
flushing the batch.
