Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688C25A32D2
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 01:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiHZX5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 19:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbiHZX5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 19:57:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5703A1F2C8
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 16:57:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FB34B83343
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 23:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D289C433C1;
        Fri, 26 Aug 2022 23:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661558232;
        bh=rUt+KO1+DvrYGPcRKsc4+09hLPjzMqw8+pvPSplI0nY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K/Mh8UNOnN4jfv4w71jMlcgqb6ahD/KE7F4hwmTaPyOuytN/d0ZC1zpQPeYowYv2n
         +zUgIGUqL6jlqmKfCxsMBdDYZA2/AJf6BrNbweTVYKEcnZx+3ZXvbdpDcjgyl+m+xU
         L45KYuDgQcaliFWJNFZILN/OTIQFENB5nb5+wyuT9eJhQbFR2k5zVaWy2SfkCC8DgT
         bwCbQMroysQlkicWeUam4bDAf/8gCvws0faKzy1w1s9BauSiH7yJ61UKdLRQiZK2al
         jnPy2hH+mnCv1+SZ65dBs82SsMS7gJ3F8v8WMfIi8ITUsqZemcAzf/e7n4gzI3ewvt
         0fkt992qKy3hQ==
Date:   Fri, 26 Aug 2022 16:57:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Gal Pressman <gal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Message-ID: <20220826165711.015e7827@kernel.org>
In-Reply-To: <9d962e38-1aa9-d0ed-261e-eb77c82b186b@intel.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
        <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
        <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
        <20220825092957.26171986@kernel.org>
        <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20220825103027.53fed750@kernel.org>
        <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20220825133425.7bfb34e9@kernel.org>
        <bcdfe60a-0eb7-b1cf-15c8-5be7740716a1@intel.com>
        <20220825180107.38915c09@kernel.org>
        <9d962e38-1aa9-d0ed-261e-eb77c82b186b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

On Fri, 26 Aug 2022 10:51:21 -0700 Jacob Keller wrote:
> On 8/25/2022 6:01 PM, Jakub Kicinski wrote:
> > Oh, but per the IEEE standard No FEC is _not_ an option for CA-L.
> > From the initial reading of your series I thought that Intel NICs=20
> > would _never_ pick No FEC.
>=20
> That was my original interpretation when I was first introduced to this
> problem but I was mistaken, hence why the commit message wasn't clear :(
>=20
> This is rather more complicated than I originally understood and the
> names for various bits have not been named very well so their behavior
> isn't exactly obvious...
>=20
> > Sounds like we need a bit for "ignore the standard and try everything".
> >=20
> > What about BASE-R FEC? Is the FW going to try it on the CA-L cable?
>=20
> Ok I got further clarification on this. We have a bit, "Auto FEC
> enable", as well as a bitmask for which FEC modes to try.
>=20
> If "Auto FEC En" is set, then the Link Establishment State Machine will
> try all of the FEC options we list in that bitmask, as long as we can
> theoretically support them even if they aren't spec compliant.
>=20
> For old firmware the bitmask didn't include a bit for "No FEC", where as
> the new firmware has a bit for "No FEC".
>=20
> We were always setting "Auto FEC En" so currently we try all FEC modes
> we could theoretically support.
>=20
> If "Auto FEC En" is disabled, then we only try FEC modes which are spec
> compliant. Additionally, only a single FEC mode is tried based on a
> priority and the bitmask.
>=20
> Currently and historically the driver has always set "Auto FEC En", so
> we were enabling non-spec compliant FEC modes, but "No FEC" was only
> based on spec compliance with the media type.
>=20
> From this, I think I agree the correct behavior is to add a bit for
> "override the spec and try everything", and then on new firmware we'd
> set the "No FEC" while on old firmware we'd be limited to only trying
> FEC modes.
>=20
> Does that make sense?
>=20
> So yea I think we do probably need a "ignore the standard" bit.. but
> currently that appears to already be what ice does (excepting No FEC
> which didn't previously have a bit to set for it)

Thanks for getting to the bottom of this :)

The "override spec modes" bit sounds like a reasonable addition,
since we possibly have different behavior between vendors letting=20
the user know if the device will follow the rules can save someone
debugging time.

But it does sound orthogonal to you adding the No FEC bit to the mask
for ice.

Let me add Simon and Andy so that we have the major vendors on the CC.
(tl;dr the question is whether your FW follows the guidance of=20
'Table 110C=E2=80=931=E2=80=94Host and cable assembly combinations' in AUTO=
 FEC mode).

If all the vendors already ignore the standard (like Intel and AFAIU
nVidia) then we just need to document, no point adding the bit...
