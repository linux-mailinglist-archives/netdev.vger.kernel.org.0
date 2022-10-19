Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85ADD605080
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 21:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiJSTgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 15:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiJSTgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 15:36:12 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188251BE439
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 12:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=u18DOJ43gvamLTH7D4VvewPPst0fHSg/feuG51NLlvg=;
        t=1666208171; x=1667417771; b=R2vnRaYATg43bniGFIfmCsr1rUmEngC1ePkO49BkfujjWxR
        9GIFDUBgm7698TSQ6FJsEwZP8lIPeYEAoblIebi0UBkjMqsAlcoqcvyu7BRtKAoTmIXpIk8t4k2dw
        kv+m9YssyTBXWKf/PmOxKSZB7RxYfAsnIkZHI1YSaBCtOiDU1MxcVT1nG2+YaVS5beT1/Nch4ar0t
        NIa3WjofEl0BzSQ9VF6lF+yuAQBSgNqciz32q82xkCu3aLM13jdzSM3Sn2Axz2oqYPenJ46a/dGwB
        BtjU22JJMc4fgNAojd5nreuKEhXUUbvEoPSDoDo6/UGHirQzX8ylw5YePLdRMKgg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1olErC-00BDcM-0A;
        Wed, 19 Oct 2022 21:36:02 +0200
Message-ID: <e5ae37ae75bac9af6d6a7c324acd4e3c97059d50.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 03/13] genetlink: introduce split op
 representation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        jiri@nvidia.com, nhorman@tuxdriver.com, alex.aring@gmail.com,
        stefan@datenfreihafen.org
Date:   Wed, 19 Oct 2022 21:36:00 +0200
In-Reply-To: <20221019121422.799eee78@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
         <20221018230728.1039524-4-kuba@kernel.org>
         <93e9137fb80f63cd13fa226bcca3007c473a74d4.camel@sipsolutions.net>
         <20221019121422.799eee78@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-10-19 at 12:14 -0700, Jakub Kicinski wrote:
>=20
> Yes, we have the space... I think I lost your thread of thought..
> Do you want to define more info for each group than just the pre/post?

Nah. I guess I was thinking why bother, but anyway we have the space,
it's easy, and it might simplify things. So yeah, makes sense. If we
didn't have the space anyway I might've argued against it I guess :)

> > > +static void
> > > +genl_cmd_full_to_split(struct genl_split_ops *op,
> > > +		       const struct genl_family *family,
> > > +		       const struct genl_ops *full, u8 flags)
> > > +{ =20
> >=20
> > [...]
> >=20
> >=20
> > > +	op->flags		|=3D flags; =20
> >=20
> > why |=3D ?
>=20
> op->flags should already have all the existing flags (i.e. ADMIN_PERM)
> from the op, I'm adding the DO/DUMP to them.

OK, I guess I missed where that was being set.

> It's used as an output argument here, so that's what initializes it.
> genl_get_cmd* should always init the split command because in policy
> dumping we don't care about the errors, we just want the structure
> to be zeroed if do/dump is not implemented, and we'll skip accordingly.
> Wiping the 40B just to write all the fields felt... wrong.=20
> Let KASAN catch us if we fail to init something.

KASAN doesn't, I think, you'd need KMSAN?

johannes
