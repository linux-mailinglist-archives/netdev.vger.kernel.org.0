Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565716B5F91
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 19:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjCKSJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 13:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjCKSJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 13:09:06 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07B331E32;
        Sat, 11 Mar 2023 10:09:04 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id j11so33239905edq.4;
        Sat, 11 Mar 2023 10:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678558143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oTuVxMONaKXsR7cffhKFyvdIsq8IF3Y+Pd3kTIZ1Ai8=;
        b=X0VEjevd18rV4CPUNmTkiqphTtjh17sDHoeiGv4+xFM5XkZuvW56QhKXLbWCVzjNiJ
         /qtCKaw0q3vsK/ZKhuNvV3nzrxGXPV/ATxcNYMIgOV+iL6Rw/niepUY+5w97kYG6zXFv
         ttTrmKAwW6eNsV1k3Wsw6nZNCvehOo++d2ibzkAL0gkRKO22TeODxtvpdiCqSFabVu4c
         trA3cbHkZIcav36ndzhVrinqQFMBgZu0aVmV0/ArQ1ox75KG89xWSFzdWkZGo34dxsuz
         CPr9KkeITOWwc/dEVMeDRYVBq9AlqM+Xi86Vu5QN2Je1A/EL0YMVwvzyvGabrV+khJc+
         iGFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678558143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oTuVxMONaKXsR7cffhKFyvdIsq8IF3Y+Pd3kTIZ1Ai8=;
        b=S5XQhOCrxZ7sVU/ouGwwLvX/R0L99AMvyMA+I+PigSGAXg1cebfmVUOKXZPTSkAfa9
         e8CA6zoSO66VN16ubGBD/77e/sEQbh4I/7t+0XzTmmPvzdHpWKNwFOoVfqdDIojmEbf2
         BxCmCuMv8AOmpqjNGw+aEVsdfqat2yARe3cx+VZG/rVCdQUQy6Br4b4fzHya66pbhnYH
         rwaFBRB3z69fZuyPgWLHfl3NF/cEDNO6hm2S6ez9+3i9P4f7+6Oz+aQlXccc7QHRmMZ/
         2H4iwNtvUgYpZkZsvF5vwV447gopXlWli35X5gWH6b2ZCYVSX29oQ3ssQuQcc4SsnsKy
         nT2w==
X-Gm-Message-State: AO0yUKVXtEW4C6Pk23nvzXrK00W+tUzOBx007RwDltJgMScBL/+XLHEn
        5IgKLVACLTFpeuFL0o2/p70=
X-Google-Smtp-Source: AK7set9CrV/E2VUBfpv6C+RSqIc20ASml1Txch6XNoN/PYgCMaDGZi8DjFDpjR0H11BcXXMg++Cf9w==
X-Received: by 2002:a05:6402:70f:b0:4af:7390:b488 with SMTP id w15-20020a056402070f00b004af7390b488mr27565124edx.40.1678558143264;
        Sat, 11 Mar 2023 10:09:03 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id i23-20020a508717000000b004bc422b58a2sm1453768edb.88.2023.03.11.10.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 10:09:03 -0800 (PST)
Date:   Sat, 11 Mar 2023 20:09:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Klaus Kudielka <klaus.kudielka@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: mv88e6xxx: move call to
 mv88e6xxx_mdios_register()
Message-ID: <20230311180901.m45p5c26ln35cc6a@skbuf>
References: <20230311094141.34578-1-klaus.kudielka@gmail.com>
 <20230311094141.34578-2-klaus.kudielka@gmail.com>
 <98767929-b401-402b-8e6b-d997cf27bfb0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98767929-b401-402b-8e6b-d997cf27bfb0@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 04:19:43PM +0100, Andrew Lunn wrote:
> >  static int mv88e6xxx_setup(struct dsa_switch *ds)
> > @@ -3889,6 +3892,10 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
> >  	int err;
> >  	int i;
> >  
> > +	err = mv88e6xxx_mdios_register(chip);
> > +	if (err)
> > +		return err;
> > +
> >  	chip->ds = ds;
> >  	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
> 
> Other calls in mv88e6xxx_setup() can fail, so you need to extend the
> cleanup to remove the mdio bus on failure.

FWIW, here is a snippet of how mv88e6xxx_setup() and mv88e6xxx_teardown()
should look like, with error handling taken into consideration (but I
was lazy and just added forward declarations, something which Klaus
handled better with the movement preparatory patch):
https://lore.kernel.org/lkml/20230210210804.vdyfrog5nq6hrxi5@skbuf/
