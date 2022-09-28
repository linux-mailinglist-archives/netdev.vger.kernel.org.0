Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFE75EDEE9
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbiI1OhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbiI1OhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:37:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F04AD98F
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:37:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94E7A61D22
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 14:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AC8C433D6;
        Wed, 28 Sep 2022 14:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664375831;
        bh=4x+9UC5jPWsyx5WQcLQMnqkH9vYaPjkmA2dycBUE8h4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LO5cz1jsD5pigb5hnPjZLm6Lpvq7NtPp/X9rLs1J27ACYwt1aXFWxIMraNdB4mcYn
         NxXyTfPbwWf3H18Iny0HRElWSBEJMl430JQw42qjXibIQtCkPzvYS1MHl45Dlxqpdt
         FdZA4YvKJr0Oluk3C9L9IIfhxSp+Us4vC7+sHta1LgWOSEpp6LzAnL9eZW+L195M+I
         zydNx4Bp4EqinkZnjPPVCnNDq7MymbFX+FyPr6bVxbZSVKfBXgj/fhQmuLFwqKgg6L
         gkPItk3rizkOBjI6tT01F5J+v9AncadPdePYYehFGPcRnUltmcM44xikaNoGChbzzz
         3LcFUlLTFmbEA==
Date:   Wed, 28 Sep 2022 07:37:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     nicolas.dichtel@6wind.com,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage
 of Netlink flags
Message-ID: <20220928073709.1b93b74a@kernel.org>
In-Reply-To: <e4db8d52-5bbb-8667-86a6-c7a2154598d1@blackwall.org>
References: <20220927212306.823862-1-kuba@kernel.org>
        <a93cea13-21e9-f714-270c-559d51f68716@wifirst.fr>
        <d93ee260-9199-b760-40fe-f3d61a0af701@6wind.com>
        <e4db8d52-5bbb-8667-86a6-c7a2154598d1@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 12:21:57 +0300 Nikolay Aleksandrov wrote:
> On 28/09/2022 11:55, Nicolas Dichtel wrote:
> > Le 28/09/2022 =C3=A0 10:04, Florent Fourcot a =C3=A9crit=C2=A0: =20
> >> About NLM_F_EXCL, I'm not sure that my comment is relevant for your in=
tro.rst
> >> document, but it has another usage in ipset submodule. For IPSET_CMD_D=
EL,
> >> setting NLM_F_EXCL means "raise an error if entry does not exist befor=
e the
> >> delete". =20

Interesting.

> > So NLM_F_EXCL could be used with DEL command for netfilter netlink but =
cannot be
> > used (it overlaps with NLM_F_BULK, see [1]) with DEL command for rtnetl=
ink.
> > Sigh :(
> >=20
> > [1] https://lore.kernel.org/netdev/0198618f-7b52-3023-5e9f-b38c49af1677=
@6wind.com/
>=20
> One could argue that's abuse of the api, but since it's part of a differe=
nt family
> I guess it's ok. NLM_F_EXCL is a modifier of NEW cmd as the comment above=
 it says
> and has never had rtnetlink DEL users.

It's fine in the sense that it works, but it's rather pointless to call
the flags common if they have different semantics depending on the
corner of the kernel they are used in, right?

I was very tempted to send a patch which would validate the top
byte of flags in genetlink for new commands, this way we may some day
find a truly common (as in enforced by the code) use for the bits.=20

WDYT?

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 7c136de117eb..0fbaed49e23f 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -739,6 +739,22 @@ static int genl_family_rcv_msg_doit(const struct genl_=
family *family,
 	return err;
 }
=20
+static int genl_header_check(struct nlmsghdr *nlh, struct genlmsghdr *hdr)
+{
+	if (hdr->reserved)
+		return -EINVAL;
+
+	/* Flags - lower byte check */
+	if (nlh->nlmsg_flags & 0xff & ~(NLM_F_REQUEST | NLM_F_ACK | NLM_F_ECHO))
+		return -EINVAL;
+	/* Flags - higher byte check */
+	if (nlh->nlmsg_flags & 0xff00 &&
+	    nlh->nlmsg_flags & 0xff00 !=3D NLM_F_DUMP)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int genl_family_rcv_msg(const struct genl_family *family,
 			       struct sk_buff *skb,
 			       struct nlmsghdr *nlh,
@@ -757,7 +773,7 @@ static int genl_family_rcv_msg(const struct genl_family=
 *family,
 	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
 		return -EINVAL;
=20
-	if (hdr->cmd >=3D family->resv_start_op && hdr->reserved)
+	if (hdr->cmd >=3D family->resv_start_op && genl_header_check(nlh, hdr))
 		return -EINVAL;
=20
 	if (genl_get_cmd(hdr->cmd, family, &op))
