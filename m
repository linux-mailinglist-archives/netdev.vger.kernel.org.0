Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78023EB97B
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241324AbhHMPth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241152AbhHMPtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 11:49:36 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EF3C0617AD
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:49:09 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id a20so12558608plm.0
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wwWCtmitPIziHrsVDs3e/WXMsT5Htg5FsOmnBCodSj8=;
        b=IYdotH9NOHI+p6YKBepbynbdJfSmXJkJybgDCe1TtlsZi9d8s2ARhtWMwxaW4OtCLq
         bFaaxwtms7kw7v0QGyAhrDtCCioiCLcGglpFR8y2So3ynzX/1/r1QDH+OpSsyD4XSNXW
         e09KeqUi7PPKNy3dHFxjXD1hHHD+rZWpC+hMA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wwWCtmitPIziHrsVDs3e/WXMsT5Htg5FsOmnBCodSj8=;
        b=pIhvNcNFoeBoIDTJc3qJ/WHSOIQxcSuKvibcsJfBYzgmmEWJ20V1/aXZSuHSCH5sOz
         YbXp1grRRtbCSXyMx9t0u35hA+8+XAswdKbUWvZv6TmyXzhKOb+78FhJJqnpkHx8Q7DY
         cFGdT/sThwtAU1crn2nfA3Z9mLXYM+EzRRobvfyoHdL4UVJWFrzc0SQ7BG1ieM16vKNM
         MsUma/3XSWiW9M+9GmJ/HXRyV+SQKGRnfnC0r0pnrfZ2jgLrsXqXGR3jc7Q9Hv1bL+OT
         w0t6tleDQk6fWMF3JdayCMLT35O6AARsVhZmDlafDYifCXe9C8CkajHEXQLDDV+mfRYL
         PoqQ==
X-Gm-Message-State: AOAM532j9Xxvp9ku0Fwq/b4h07qPyDDAWhf120x19xFwSPXyDSJgNtRe
        vJdMX79AWQ2JkcWTB9tFh8e4Kw==
X-Google-Smtp-Source: ABdhPJyv0yGI/+CjV3WSksJoELQp2QfXxshGvk60ssRFFyGXixHmNtvKKEOi+49tFIULL6ceroPwFw==
X-Received: by 2002:a05:6a00:150d:b029:3c8:e86e:79ec with SMTP id q13-20020a056a00150db02903c8e86e79ecmr3123596pfu.62.1628869748959;
        Fri, 13 Aug 2021 08:49:08 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u21sm2725385pfh.163.2021.08.13.08.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 08:49:08 -0700 (PDT)
Date:   Fri, 13 Aug 2021 08:49:07 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 10/64] lib80211: Use struct_group() for memcpy() region
Message-ID: <202108130846.EC339BCA@keescook>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-11-keescook@chromium.org>
 <a9c8ae9e05cfe2679cd8a7ef0ab20b66cf38b930.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a9c8ae9e05cfe2679cd8a7ef0ab20b66cf38b930.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 10:04:09AM +0200, Johannes Berg wrote:
> On Tue, 2021-07-27 at 13:58 -0700, Kees Cook wrote:
> > 
> > +++ b/include/linux/ieee80211.h
> > @@ -297,9 +297,11 @@ static inline u16 ieee80211_sn_sub(u16 sn1, u16 sn2)
> >  struct ieee80211_hdr {
> >  	__le16 frame_control;
> >  	__le16 duration_id;
> > -	u8 addr1[ETH_ALEN];
> > -	u8 addr2[ETH_ALEN];
> > -	u8 addr3[ETH_ALEN];
> > +	struct_group(addrs,
> > +		u8 addr1[ETH_ALEN];
> > +		u8 addr2[ETH_ALEN];
> > +		u8 addr3[ETH_ALEN];
> > +	);
> >  	__le16 seq_ctrl;
> >  	u8 addr4[ETH_ALEN];
> >  } __packed __aligned(2);
> 
> This file isn't really just lib80211, it's also used by everyone else
> for 802.11, but I guess that's OK - after all, this doesn't really
> result in any changes here.
> 
> > +++ b/net/wireless/lib80211_crypt_ccmp.c
> > @@ -136,7 +136,8 @@ static int ccmp_init_iv_and_aad(const struct ieee80211_hdr *hdr,
> >  	pos = (u8 *) hdr;
> >  	aad[0] = pos[0] & 0x8f;
> >  	aad[1] = pos[1] & 0xc7;
> > -	memcpy(aad + 2, hdr->addr1, 3 * ETH_ALEN);
> > +	BUILD_BUG_ON(sizeof(hdr->addrs) != 3 * ETH_ALEN);
> > +	memcpy(aad + 2, &hdr->addrs, ETH_ALEN);
> 
> 
> However, how is it you don't need the same change in net/mac80211/wpa.c?
> 
> We have three similar instances:
> 
>         /* AAD (extra authenticate-only data) / masked 802.11 header
>          * FC | A1 | A2 | A3 | SC | [A4] | [QC] */
>         put_unaligned_be16(len_a, &aad[0]);
>         put_unaligned(mask_fc, (__le16 *)&aad[2]);
>         memcpy(&aad[4], &hdr->addr1, 3 * ETH_ALEN);
> 
> 
> and
> 
>         memcpy(&aad[4], &hdr->addr1, 3 * ETH_ALEN);
> 
> and
> 
>         memcpy(aad + 2, &hdr->addr1, 3 * ETH_ALEN);
> 
> so those should also be changed, it seems?

Ah! Yes, thanks for pointing this out. During earlier development I split
the "cross-field write" changes from the "cross-field read" changes, and
it looks like I missed moving lib80211_crypt_ccmp.c into that portion of
the series (which I haven't posted nor finished -- it's lower priority
than fixing the cross-field writes).

> In which case I'd probably prefer to do this separately from the staging
> drivers ...

Agreed. Sorry for the noise on that part. I will double-check the other
patches.

-- 
Kees Cook
