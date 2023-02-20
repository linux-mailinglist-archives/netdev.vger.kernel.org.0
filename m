Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E60269CA39
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbjBTLuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbjBTLun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:50:43 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FCB1A665;
        Mon, 20 Feb 2023 03:50:39 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676893837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0bR055dEu0HPYZjKcQaRUqqYKzNcHQe9yAg/lgSReGM=;
        b=hK2UJ40UIb8v0PcrGtHAnPrgtJyqAZXePbeJ4PzL7g2USdy5QvCbJURNHnlE80xPkNeuY6
        4OehVp3svLYH2v0SxUYxlwxQwYMG8+fsIbYVyJ4z2fJDCgzvKTGCo97mWgXpXBo+PGw+cH
        IQh6i4tWOMLdLO7Cqm81r14jv0+f+J7XnSG30K/XThgK/6goJzmwpugaOcnlGjnQmOphkp
        D1NQ9ZjaAZ9xr9d1trbf7zGt9+CvCZ/qHFk8JtqxnzV8gokobkZVm5Tx5uA+n1om7Er9se
        3Oy3gip0vcsQw2f7nky/kUppMaSJLF44dqIlH2JSYomuvjBfMRMPjfflacq1eA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676893837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0bR055dEu0HPYZjKcQaRUqqYKzNcHQe9yAg/lgSReGM=;
        b=wWPCVQGtK7oPhERiYeSeoK1UTXirjv4ypNGOt3hPvwquRmNm991jSmOAVhJ41dIvOL0jmd
        c7TpS8LKAr8CemCg==
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
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH v2 net-next 04/12] net: ethtool: fix
 __ethtool_dev_mm_supported() implementation
In-Reply-To: <20230219135309.594188-5-vladimir.oltean@nxp.com>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
 <20230219135309.594188-5-vladimir.oltean@nxp.com>
Date:   Mon, 20 Feb 2023 12:50:35 +0100
Message-ID: <87sff0ftdg.fsf@kurt>
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

On Sun Feb 19 2023, Vladimir Oltean wrote:
> The MAC Merge layer is supported when ops->get_mm() returns 0.
> The implementation was changed during review, and in this process, a bug
> was introduced.
>
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230111161706.1465242-5-vladimir.oltean@nxp.com/

Nit:

Link: https://lore.kernel.org/r/20230111161706.1465242-5-vladimir.oltean@nxp.com/

is preferred, because it is supposed to be stable. Same for patch #8.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPzXosTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgksqEACletf1QAUO2Uf0pATTg/VT1TQ88koW
suLQyGY03D6anJuTCs2ocutBvNLqf0fYKLc1LtFN/DE32eRUJKA7PJlujH4pnKJM
qMNNQfVisR7P8mspITxt9EU+U+ESVW8kCQnjYKNqQBda5OJmbJInJ7QYxKB5s+H+
eibGHbbymNdOWarhW3bfa4EAqWXfWSZ6DGEBGTagQzCvW5rUx5OlXQVwZa4MepJO
zPLcwaT0FGzYKWzESBPU95ts0D2ehPe7w58zx2uBRCvfMP/vwsiSONH0eAH/xHPh
Eja7bn2vLgUZ3s1MzUERHb/6/QHcBNlb/BIelnIYhfbSwNIKyTPMYdh8HI76khYx
MR2FIdG7WUDSjNVYKtIoVzExrTouIkOKcY2PastLarO31CPe2nQW4cMVWxvr6BWt
AJw4UnaC+c4F4I/duiD9u7S4YcYGah5Wy4lh1upmxujrZ09veGVGtrI5yaflslNE
7/7jD/fYoZ9l48txA7GjyeAmfoXbsQWz8lpDY5p5+IHLwMpEIZJKiI3evQiwOC5+
h62H1VpxUEOfFjnnqAg9phvhgUssJdHmtnBfYr0My9hneCeYFW6isSte/UP0jl4J
wkPJrRMYrTcUKA8CRAfCKrD34E/kOj9pWF8tv0SrwpXQAIh9va5+bTyrRC7Lii3E
PWbEEkWw9kfcaA==
=gE3T
-----END PGP SIGNATURE-----
--=-=-=--
