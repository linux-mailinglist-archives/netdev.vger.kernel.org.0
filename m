Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510A963D54C
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbiK3MOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiK3MOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:14:06 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EAF2B600;
        Wed, 30 Nov 2022 04:14:05 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id vv4so40874752ejc.2;
        Wed, 30 Nov 2022 04:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Lj97Y0Fj3f0GUlUBEVb57/dPo/1vC2s+z47mWfenrC4=;
        b=Ds3z99e+jksFhw9iEbhhn7cdIkXy9v/AM/890kB0niF9tib84ZTwZLFhcXXqr4H55r
         RCavPP4imf5xYpIkNb19Nt+OVfVY+2/F5zZp5xK41/nuwuaUy/RF3VEAhtuIIdl0bNsY
         57z/ZzOu0n6JMN0/Bg7CCxfdbVH09BVf1h4yFWwiUzkw7Rl7hR1Z6mTvnMGkyaeSOYc7
         gLKR6CQvsaHTaDrWQpRYfAKpeiQtHEF8JUBT77A2FyR4loy1YDtSEdlaTjW/Cpqx1Yyt
         7g7zVzp11AZGltdw9KiZl+XhiVvcyDtrbnYcCqnItqqLxzuGwDS2Bb/tKq1IQV2FrVQY
         4LgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lj97Y0Fj3f0GUlUBEVb57/dPo/1vC2s+z47mWfenrC4=;
        b=NsruYpBzGXcANW8Tl1StrnFFHmmeWiS6eCs7wucIk9aH6tgD+1CaHfBQdx2kt+n6An
         3C1JIO0Xm0enoRTS2B/1nCaS2FzxSsQN/hZORVUCVhy8QngfZpG0y17aKbFxkCBR4axR
         XAWzJzpSNueMgAtPpseQaQEmdpNlkwz6ka27yYYzFyvGykmCBNrJbHWlfpj+hjkEF82u
         nZ8NRlwvUMmwgx00vJxQ9smnXNFWM8HPrTXx6wJUGL+AjXow9izrAYNIoWIJQ24j16T2
         2BXUG1Aj67sUEtGQZw0CJk5ZKd+v8uhBoslHCV0wTiq3/BhuCNMHtlMWzEIAg+rlEy5c
         7jzA==
X-Gm-Message-State: ANoB5pkA/Q49D9GJiDZnDUPwBkxc/NTDzLtZJL7I7Z+jL393XY9waltA
        KudDJuQxzFk9fZROY2LfcbLDIJF6793UoNvWCQs=
X-Google-Smtp-Source: AA0mqf7i+NfB9VUtrTSB4fToW5A8P322CGH2MvHw+TfTtlVnDCtKRglPhu63+YzcUkq3/kBHBfzUYA2WcWuOvWTfPr4=
X-Received: by 2002:a17:907:8e09:b0:7bc:420d:709f with SMTP id
 th9-20020a1709078e0900b007bc420d709fmr23849641ejc.658.1669810444111; Wed, 30
 Nov 2022 04:14:04 -0800 (PST)
MIME-Version: 1.0
References: <20221130094142.545051-1-tirthendu.sarkar@intel.com> <Y4dFR9oR3AAIcPlB@boxer>
In-Reply-To: <Y4dFR9oR3AAIcPlB@boxer>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 30 Nov 2022 13:13:52 +0100
Message-ID: <CAJ8uoz0Fogd9RTMGy1ktqnM5UR==o9nHLst4O+na_gP4kfgmpA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests: xsk: changes for setting up NICs to
 run xsk self-tests
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Saeed Mahameed <saeed@kernel.org>
Cc:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>, bjorn@kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
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

On Wed, Nov 30, 2022 at 1:09 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Wed, Nov 30, 2022 at 03:11:42PM +0530, Tirthendu Sarkar wrote:
> > ETH devies need to be set up for running xsk self-tests, like enable
> > loopback, set promiscuous mode, MTU etc. This patch adds those settings
> > before running xsk self-tests and reverts them back once done.
> >
> > Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> > ---
> >  tools/testing/selftests/bpf/test_xsk.sh | 27 ++++++++++++++++++++++++-
> >  1 file changed, 26 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
> > index d821fd098504..e7a5c5fc4f71 100755
> > --- a/tools/testing/selftests/bpf/test_xsk.sh
> > +++ b/tools/testing/selftests/bpf/test_xsk.sh
> > @@ -106,7 +106,11 @@ MTU=1500
> >  trap ctrl_c INT
> >
> >  function ctrl_c() {
> > -        cleanup_exit ${VETH0} ${VETH1} ${NS1}
> > +     if [ ! -z $ETH ]; then
> > +             cleanup_exit ${VETH0} ${VETH1} ${NS1}
> > +     else
> > +             cleanup_eth
> > +     fi
> >       exit 1
> >  }
> >
> > @@ -138,9 +142,28 @@ setup_vethPairs() {
> >       ip link set ${VETH0} up
> >  }
> >
> > +setup_eth() {
> > +       sudo ethtool -L ${ETH} combined 1
>
> what if particular device has a different way of configuring single
> channel? like
>
> $ sudo ethtool -L ${ETH} tx 1 rx 1
>
> I am not sure if we want to proceed with settings that are specific to
> Intel devices. What if mlx5 will this in a much different way?

Adding Saeed as he will know. How does Mellanox set the number of
channels to 1 and how do you enable loopback mode? At least the rest
should be the same.

> > +       sudo ethtool -K ${ETH} loopback on
> > +       sudo ip link set ${ETH} promisc on
> > +       sudo ip link set ${ETH} mtu ${MTU}
> > +       sudo ip link set ${ETH} up
> > +       IPV6_DISABLE_CMD="sudo sysctl -n net.ipv6.conf.${ETH}.disable_ipv6"
> > +       IPV6_DISABLE=`$IPV6_DISABLE_CMD 2> /dev/null`
> > +       [[ $IPV6_DISABLE == "0" ]] && $IPV6_DISABLE_CMD=1
> > +       sleep 1
> > +}
> > +
> > +cleanup_eth() {
> > +       [[ $IPV6_DISABLE == "0" ]] && $IPV6_DISABLE_CMD=0
> > +       sudo ethtool -K ${ETH} loopback off
> > +       sudo ip link set ${ETH} promisc off
> > +}
> > +
> >  if [ ! -z $ETH ]; then
> >       VETH0=${ETH}
> >       VETH1=${ETH}
> > +     setup_eth
> >       NS1=""
> >  else
> >       validate_root_exec
> > @@ -191,6 +214,8 @@ exec_xskxceiver
> >
> >  if [ -z $ETH ]; then
> >       cleanup_exit ${VETH0} ${VETH1} ${NS1}
> > +else
> > +     cleanup_eth
> >  fi
> >
> >  failures=0
> > --
> > 2.34.1
> >
