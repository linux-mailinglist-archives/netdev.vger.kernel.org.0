Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF61503770
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 17:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbiDPPy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 11:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiDPPy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 11:54:57 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B05972DF;
        Sat, 16 Apr 2022 08:52:25 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id p15so20085703ejc.7;
        Sat, 16 Apr 2022 08:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WB0OkA4npUVlTHKxP5L/zecMJKXRJHu4yHb6ykPI+d0=;
        b=p1PdgWeV4/8OWZSYyJ2Gtl7Sb29XmosvPG966HCgE+yOaNpBXl37cLieNQh1YhCimK
         cfjREeBGHHB7QtLvlG2M7NPMi038s27WDZ0PyHroXUbzv8mgsj8Qhdb/F8TEqVYIKDvg
         tN2I6HQfvs2KlGV6UrdM8caLjg8HNpylVyGPM+5YIoS2WwN63G32fgwrsxy2k66zCBgy
         Bri21J62bTzs2JnbGPL282vrgIBnHBLUgIuY3xW1qVAqJTdBaTnOL018zIF1KpddLUp4
         4Ah+hh5gs2LzYujyxZoo+L3hfQCXXhiJI0eiTbhDXRppsWwKweBe2G3/IYbK4AkHMquQ
         LBYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WB0OkA4npUVlTHKxP5L/zecMJKXRJHu4yHb6ykPI+d0=;
        b=zCHfYnx1NdJIES1q10RBv/MMXLajx02hori8VkCJLMYkYR/cHZ70GcLPy1/ZKzhvQi
         Ssxxda4luersiExY1NWaRyBhpC+UllSgeeElTXFF686Ux0evZfDxDGm+jIPz23/JTZW8
         YIYRufDh4NYMQHoYf75XZ46dTvqdC9kp84nAg93lbmO9YnISfF98yBBU0Ocg675x36/4
         AeL+rEfo/MHLkBPa17hHp9o5nFvxbtrN3WNta8BVWj+pJSg3vaE7XBWiojy0Aab5YFXv
         krM1t0vBifH9SIblhgwsjsVcZiRDmuFLrH/qvweZJXdc2jD75K+33dnYZw+TZpxKRDIF
         fi2w==
X-Gm-Message-State: AOAM5300oOcJudEWkUXc4SG8jd6pVyGRQHvltbyGDT7wBptandvdzxWp
        AaqfR+dZbzg31TcZLFUCofT9r9y8+yE=
X-Google-Smtp-Source: ABdhPJwxtNuBtqOCmrmCxvK+GvsLdC4aeyXb2uo3u3eVpeTvHsXFV6Kh5xcnPCNk6rHSsh2eMiP5cg==
X-Received: by 2002:a17:906:dc8b:b0:6ef:86e8:777 with SMTP id cs11-20020a170906dc8b00b006ef86e80777mr1451459ejc.326.1650124343944;
        Sat, 16 Apr 2022 08:52:23 -0700 (PDT)
Received: from leap.localnet (host-79-50-86-254.retail.telecomitalia.it. [79.50.86.254])
        by smtp.gmail.com with ESMTPSA id fy11-20020a1709069f0b00b006e8b68c92d8sm2752978ejc.162.2022.04.16.08.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Apr 2022 08:52:22 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        Julia Lawall <julia.lawall@inria.fr>
Cc:     Julia Lawall <julia.lawall@inria.fr>, outreachy@lists.linux.dev,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ira.weiny@intel.com
Subject: Re: [PATCH v3] intel: igb: igb_ethtool.c: Convert kmap() to kmap_local_page()
Date:   Sat, 16 Apr 2022 17:52:20 +0200
Message-ID: <1897617.PYKUYFuaPT@leap>
In-Reply-To: <alpine.DEB.2.22.394.2204161608230.3501@hadrien>
References: <20220416111457.5868-1-eng.alaamohamedsoliman.am@gmail.com> <857a2d22-5d0f-99d6-6686-98d50e4491d5@gmail.com> <alpine.DEB.2.22.394.2204161608230.3501@hadrien>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="ISO-8859-1"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On sabato 16 aprile 2022 16:09:58 CEST Julia Lawall wrote:
>=20
> On Sat, 16 Apr 2022, Alaa Mohamed wrote:
>=20
> >
> > On =D9=A1=D9=A6/=D9=A4/=D9=A2=D9 =D9=A2=D9=A2 =D9=A1=D9=A3:=D9=A3=D9=A1=
, Julia Lawall wrote:
> > >
> > > On Sat, 16 Apr 2022, Alaa Mohamed wrote:
> > >
> > > > Convert kmap() to kmap_local_page()
> > > >
> > > > With kmap_local_page(), the mapping is per thread, CPU local and=20
not
> > > > globally visible.
> > > It's not clearer.
> > I mean this " fix kunmap_local path value to take address of the mapped=
=20
page"
> > be more clearer
> > > This is a general statement about the function.  You
> > > need to explain why it is appropriate to use it here.  Unless it is=20
the
> > > case that all calls to kmap should be converted to call=20
kmap_local_page.
> > It's required to convert all calls kmap to kmap_local_page. So, I don't=
=20
what
> > should the commit message be?
>=20
> If all calls should be changed then you can also say that.

If all calls should be changed with no regards to the surrounding contexts=
=20
and special situations, we can just make an automated s/kmap()/
kmap_local_page()/ or something else similar :)

Thanks,

=46abio M. De Francesco

>=20
> I thought that a previous commit on the outreachy list made some=20
arguments
> about how the affacted value was just allocated and thus could not yet be
> shared.
>=20
> julia



