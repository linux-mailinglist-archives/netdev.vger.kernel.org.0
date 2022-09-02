Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F245AA6C2
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 06:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiIBEHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 00:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIBEHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 00:07:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1C5A5725;
        Thu,  1 Sep 2022 21:07:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64A51B829B0;
        Fri,  2 Sep 2022 04:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBF3C433C1;
        Fri,  2 Sep 2022 04:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662091637;
        bh=dRKiue4PNSLGppBkHhKuCrCtoGPPqiOO16cBV8gC5xo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qOgJz3k0wqB/Ds965QwRbz1NWSkWG3k3IdaTfGp6HeKW64uiIOKEu9zA0c+ddR/cI
         lpznMH/v5/FJPzoEiaFW2kc0UNgjqTEcDGXzlz+AmzSmWza83vWwNr6Rog5b7hcK2O
         qzotkYGwn0ZkVthx4i8/Qj9S0g5aUvQKhsby86z1QaIyX6ByqBUFPks0M06dPH94Bu
         Ci40AVtBGubaOqlgCocrAS+t9gVA58QTjhGEIahQcJ9IK2TJlWUibpGJk4sAejU0di
         0a0mny9fGW25m79+qMn1thzspGBqhHIhyHmok5aTZrrkEm351M7ta0WKNr97420G49
         qS1w35Ec6qgdw==
Date:   Thu, 1 Sep 2022 21:07:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netdev@vger.kernel.org>, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, Pablo Neira Ayuso <pablo@netfilter.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH net 1/4] netfilter: remove nf_conntrack_helper sysctl
 and modparam toggles
Message-ID: <20220901210715.00c7b4e1@kernel.org>
In-Reply-To: <20220901071238.3044-2-fw@strlen.de>
References: <20220901071238.3044-1-fw@strlen.de>
        <20220901071238.3044-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Sep 2022 09:12:35 +0200 Florian Westphal wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>=20
> __nf_ct_try_assign_helper() remains in place but it now requires a
> template to configure the helper.
>=20
> A toggle to disable automatic helper assignment was added by:
>=20
>   a9006892643a ("netfilter: nf_ct_helper: allow to disable automatic help=
er assignment")
>=20
> in 2012 to address the issues described in "Secure use of iptables and
> connection tracking helpers". Automatic conntrack helper assignment was
> disabled by:
>=20
>   3bb398d925ec ("netfilter: nf_ct_helper: disable automatic helper assign=
ment")
>=20
> back in 2016.
>=20
> This patch removes the sysctl and modparam toggles, users now have to
> rely on explicit conntrack helper configuration via ruleset.
>=20
> Update tools/testing/selftests/netfilter/nft_conntrack_helper.sh to
> check that auto-assignment does not happen anymore.

=46rom the description itself it's unclear why this is a part of a net PR.
Could you elucidate?
