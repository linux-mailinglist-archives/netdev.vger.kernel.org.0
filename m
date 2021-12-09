Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D8346F618
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 22:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhLIVmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 16:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhLIVmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 16:42:14 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C92C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 13:38:41 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 137so6283535pgg.3
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 13:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gJXuuMgNuNgrFBYfkqmzoCt0UhY3r4a3OTl83mloyJ8=;
        b=ZyKDiHqqQ/E9wm8pKWHaiX84upTuEfH+Bb7spwjWbl0mWZXPPzUfRDHhf3VPk16rXx
         B/ONx2qiMc3w2pqPOsl/x6WvqA6CJK7rcF8BaJ3ZatsdiiXj3RM5z0XnhcClIFdN4CsL
         HvYHjIWyAkBlt8JTKpqQjdXkSUwogkg25eHyFs+KPityPftyUk9Tyq/vNL5YE4U8vTEB
         A33pgUU2SKV8zE5MZZwD1+Iopvay8zd0TWmlN1B1w7UcfsU6VTtNJa3Fxnflys0O6pXE
         ASobS/xgsigZllf+BsnSBXlDbh9BP3JDRtiKS4Y9bh+kaj6J5o5Lo8Leya1y/IdvXlp2
         56Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gJXuuMgNuNgrFBYfkqmzoCt0UhY3r4a3OTl83mloyJ8=;
        b=WabmiFwKvDBoy0GYaY7jg028LYAvzh/2seupSe22tmklD0KJJIIh2AvTbAym6Eg5BT
         jees8ftSIzZvq4urAYjUVm5LJnFWAiypifl1gj3PZzhZmJ6KIdNSy1T0hia0b6tzGTpd
         OqD2ecTwtomaYwttY05d8TKjZs5opFxybKwzsFhhhUTBSjV83KtgaTH444EVrJxtiEvz
         Ziq34hqyn9F+ZeqOoSOsfgTrtCho6wH4uOdTpOfERyQ7Cv15uOxWSYx/CGttJ2T6Y9kj
         2oEjWpMYr11K4YTuM765pF62x4dStF3xpoGdNoDYuvERMFNoBAGDzkKANRgWfhoovBMm
         jW8w==
X-Gm-Message-State: AOAM531J9dyb3eMXF9Q6Zz7Twt97IHubXl4OWt3dIkr7M2RJ0QVl5fMy
        ep2O/m39lYuoqhhyl3KIxjc=
X-Google-Smtp-Source: ABdhPJzf1UZ1PFFIHMd0ArPym6fO9z+O8D8DlQsa13l7KBLJnsqMXfXOL3o9mD2OC0H+bkAk2cwnOw==
X-Received: by 2002:a63:5a20:: with SMTP id o32mr35806636pgb.42.1639085920749;
        Thu, 09 Dec 2021 13:38:40 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id nn4sm572581pjb.38.2021.12.09.13.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 13:38:40 -0800 (PST)
Date:   Thu, 9 Dec 2021 13:38:37 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCHv2 net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAG_BONDED_PHC_INDEX
Message-ID: <20211209213837.GA21948@hoboy.vegasvil.org>
References: <20211209102449.2000401-1-liuhangbin@gmail.com>
 <20211209102449.2000401-2-liuhangbin@gmail.com>
 <20211209213347.GE21819@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209213347.GE21819@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 01:33:47PM -0800, Richard Cochran wrote:
> On Thu, Dec 09, 2021 at 06:24:48PM +0800, Hangbin Liu wrote:
> 
> > +/* possible values for hwtstamp_config->flags */
> > +enum hwtstamp_flags {
> > +	/*
> > +	 * With this flag, the user could get bond active interface's
> > +	 * PHC index. Note this PHC index is not stable as when there
> > +	 * is a failover, the bond active interface will be changed, so
> > +	 * will be the PHC index.
> > +	 */
> > +	HWTSTAMP_FLAG_BONDED_PHC_INDEX = (1<<0),
> > +
> > +	/* add new constants above here */
> > +	__HWTSTAMP_FLAGS_CNT
> > +};
> 
> I think this shouldn't be an enumerated type, but rather simply a bit
> field of independent options.

Ok, it can be an enum (to be like the other fields in this header) but
still the bits need to be independent of each other.

IOW, you should drop __HWTSTAMP_FLAGS_CNT and instead use a mask of
valid bits.

Thanks,
Richard
