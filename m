Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31978698FCB
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 10:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjBPJ24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 04:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjBPJ2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 04:28:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907033C1D;
        Thu, 16 Feb 2023 01:28:52 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676539731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VB6nLOQjdg9HrxrnzxjWOc/eLn5DzxQGj/xPNSZpMgE=;
        b=LuJ4vWvn0L5QjkGWfmWcQvmpdhZL9+IwYAlr2WD1Z4vcZtDbkicfj/Hw34zf4F5MlhMHUn
        bYsjzLQjUbehyD5H9fPoPMyaLLVD09FaFSXicER1Z2tvvxDqTgKxt+ehZnX5GnENKWA+Hi
        L54buqdr2tB/6zLESLf6s8GAIG3hkedPRxQq14GbZRKOs5K7FHQvTCRqiCaD+Lfp5OOHFd
        ULpgzol2bnppUhUQqVY9mdhX4n50y6K729fRYbVZ1TdpkFf3esmpbjd3sqN17IfjVpAd9j
        RZd/vFPFaOGeRbgdjv93MrH24EtXcYQ/S2xzcIjY8yuFWv4elLZ0AsmFIl6/aA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676539731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VB6nLOQjdg9HrxrnzxjWOc/eLn5DzxQGj/xPNSZpMgE=;
        b=BqaNTSAbysoKzPhPnrml4LyMwLS3W1VUJv0VvGKmSni+dCR5KXDnwFS1HnTgF7DqaRppKZ
        x5Tbz4XDqnGRsMCw==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net/sched: taprio: dynamic max_sdu larger
 than the max_mtu is unlimited
In-Reply-To: <20230215224632.2532685-4-vladimir.oltean@nxp.com>
References: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
 <20230215224632.2532685-4-vladimir.oltean@nxp.com>
Date:   Thu, 16 Feb 2023 10:28:48 +0100
Message-ID: <87cz6aot67.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Thu Feb 16 2023, Vladimir Oltean wrote:
> It makes no sense to keep randomly large max_sdu values, especially if
> larger than the device's max_mtu. These are visible in "tc qdisc show".
> Such a max_sdu is practically unlimited and will cause no packets for
> that traffic class to be dropped on enqueue.
>
> Just set max_sdu_dynamic to U32_MAX, which in the logic below causes
> taprio to save a max_frm_len of U32_MAX and a max_sdu presented to user
> space of 0 (unlimited).
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Doesn't this deserve a Fixes tag as well?

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJGBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPt91ATHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgiI0D/dS0l99RBHC9jg05/dIdHm+gH9cIsE2
qJd41XPAx+wuONVvCgzbu6Sm/Bu0d98+A61uYLdWxAyli29MPGN6pF77u/GlRw+e
Q5IPyUsutIMjGXnAxMg1YPJhLKCzLMPyDMc6lCm2riIF3SWxFMTeCjdh2imod/3e
X4+JYOF24ctrMFW3trA50jqQDK5VYosEq3ym9yET5gXWvnb2iSbX4hRkN2ucyuTm
zB/2eMpTSdv7+Nnj0NDFgPjrYDqaM30oGRvhr0qum+wd3Fyg/9jwqJY6iwt38m3A
KqYYCLrRdndkDuST2u2O12uSsM/e6kfyWdPJrxqqSc8UQD7Oa74jH4PQSlSOcmcr
+RsMcRLlKBg5KCMre5n9W6zkRtxxY0y4fiziy7b8KwnKRlU1eoD7rTweMXfRJaAA
WflWA/Hwj/0ZEStKPPFdETy/R9l2GDr1/UUXDvOTMiddfUUYrnzB+uwLxoQkVAVa
N8XAM09pkzIYIXmFuZKocyUA73I4WMBVi0A4civyR0aNBZ+Xzuv+TpIQad8zGu0u
8fYWi1ENj3KuiMwB1Bcve9b6ErZTpejBvr+i1O8UryXrou4HZtbJFlzz8YaQi3ER
wQpVEe+Dh1lWu/WU60Cuty0za7z2z7IK9qfTX00qS0N4xG6ccjCBSRcRYfP75LjB
biXpPf1rLbso
=AmxS
-----END PGP SIGNATURE-----
--=-=-=--
