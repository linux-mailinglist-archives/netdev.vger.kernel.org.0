Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA5C605094
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 21:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiJSTh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 15:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiJSThy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 15:37:54 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A201D52FA
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 12:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=E/1cSHzKwbi+EHM9dPYGlTxnRqEAyCFWAXYudd3Z3H4=;
        t=1666208270; x=1667417870; b=CunsXgs9tZRDd9abH5QFivLQnc6rz+AisFWPSP1l7IksSy9
        FTqlSoIQMhUOjTsMa5MsPHXK6SB/QmQYz+Y4shZhSiEiEP5cpePJk9dmKf9GZTUrcwMOncUVcSTYX
        N1sVFfjoqH5bOIgav5e9TePvjnolKZkh/jx9tV1oiM8E6htfEOCQArPEyFEmZsdhUeDPIDGRchkr3
        qjZ2QQLhyxm0NLytu3Ve7rjjlwywMjWUn+fBKpKaSqMG0VMspwFZs1kN5Clca+95xayVK+NBQdVce
        o8vlIMcSXVD4IbvsiT6HGc4hNcjBnHuez52RgBhwmDzWHuiwwsIKH/jpo0rovJJg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1olEso-00BDfL-2a;
        Wed, 19 Oct 2022 21:37:42 +0200
Message-ID: <dfac0b6e09e9739c7f613cb8ed77c81f9db0bb44.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 12/13] genetlink: allow families to use split
 ops directly
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de
Date:   Wed, 19 Oct 2022 21:37:41 +0200
In-Reply-To: <20221019122504.0cb9d326@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
         <20221018230728.1039524-13-kuba@kernel.org>
         <a23c47631957c3ba3aaa87bc325553da04f99a0c.camel@sipsolutions.net>
         <20221019122504.0cb9d326@kernel.org>
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

On Wed, 2022-10-19 at 12:25 -0700, Jakub Kicinski wrote:
> On Wed, 19 Oct 2022 10:15:05 +0200 Johannes Berg wrote:
> > > full ops. Each split op is 40B while full op is 48B.
> > > Devlink for example has 54 dos and 19 dumps, 2 of the dumps
> > > do not have a do -> 56 full commands =3D 2688B.
> > > Split ops would have taken 2920B, so 9% more space while
> > > allowing individual per/post doit and per-type policies. =20
> >=20
> > You mean "Full ops would have [...] while split ops allow individual
> > [...]" or so?
>=20
> Split ops end up being larger as we need a separate entry for each=20
> do and dump. So I think it's right?
>=20

Indeed.

Oh, I see now, you were basically saying "it's only 9% bigger for all
that extra flexibility" ... didn't read that right before.

johannes
