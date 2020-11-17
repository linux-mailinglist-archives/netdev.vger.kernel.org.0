Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41C52B5670
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgKQBxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKQBx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 20:53:29 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE6EC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 17:53:29 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d17so7842571plr.5
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 17:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SWEtQwrG3K2Jgx0Xor6Ggq7A3J6j8ROirWWSlriDvgg=;
        b=KL2M2JyXtfGhW3JixNXUmRseEYlpigB+y37WdTuYpaihneZoNc0Pr5egA4Nhx7H02g
         DZ8XWwejHDmLEnBDU9YVXdVzCTack75thys7Gl06eOs8c0FqqSliZr8L9kLF++cjXF9A
         Xu90hSJWTr7mUTuZq5eO5IlNbOFe79LSFQ5NDQEMZ17p81TAFa9QcrCl/+sQoYBIkpC+
         2eFOBPI4HsVpqrydmAXFqP0svKTfqITivO7oXwsFzAbhdsQTO9GhSBy+MEJpBo/jhdgS
         M4Si8tW+gXu16CiGpO/3Gfw9Ez0MwpUL3r2U+vel+6Y/x4X4RA02CKnra7ofyrypGIsf
         c1Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SWEtQwrG3K2Jgx0Xor6Ggq7A3J6j8ROirWWSlriDvgg=;
        b=oX/b4ALFfUBI9KMsDNGUKcjlxj5/TyZ3bcuGAuql3ItvzNNUf1br7BoojjHJwi77SN
         AiSAjOIEU3+do1BxRa5ScRpWfwdhWSHM2kEyRvEyXh8n6GTq/NgjdKAtnfEMZTCKjEgV
         B+ORXPqrOb1B7c13XAklXOk6IqM1vfbFMdJ4aff4+FXJeHwpZDhIL3UbaayrV4ZAOA8y
         avAW8WWE1Dh4UreZRJZhlygiolJZKcP0FlWmcrRnAf7S7H5ntQoT52gteA65OZ9SWUuN
         JU/mHTB3rfCwzccQK2JAZz/gKEERwsZZSqlng3edzjdCKur9ubuu+KOreJyMkE70f9UP
         WqgA==
X-Gm-Message-State: AOAM533YJcCxulLaNIzuus2i0XsTJ/GF1ufwStSpk9XvnfIopy5gc0+Y
        BGqujZ4wm36LmoF9hFm3voV8g0DG4EI=
X-Google-Smtp-Source: ABdhPJwV3+jUg8W5YeMmPHZCzWtOUAuImEmRDz2Ob97UrBthOwFhBCUlexJHqA07Nins5zozW/Go7Q==
X-Received: by 2002:a17:902:a5c1:b029:d8:d387:3c23 with SMTP id t1-20020a170902a5c1b02900d8d3873c23mr15534517plq.22.1605578008909;
        Mon, 16 Nov 2020 17:53:28 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 15sm1219874pjy.0.2020.11.16.17.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 17:53:28 -0800 (PST)
Date:   Mon, 16 Nov 2020 17:53:25 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [net-next 1/4] i40e: add support for PTP external
 synchronization clock
Message-ID: <20201117015325.GB26272@hoboy.vegasvil.org>
References: <20201114001057.2133426-1-anthony.l.nguyen@intel.com>
 <20201114001057.2133426-2-anthony.l.nguyen@intel.com>
 <20201116170737.1688ebeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116170737.1688ebeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 05:07:37PM -0800, Jakub Kicinski wrote:
> On Fri, 13 Nov 2020 16:10:54 -0800 Tony Nguyen wrote:

> > +/* get PTP pins for ioctl */
> > +#define SIOCGPINS	(SIOCDEVPRIVATE + 0)
> > +/* set PTP pins for ioctl */
> > +#define SIOCSPINS	(SIOCDEVPRIVATE + 1)
> 
> This is unexpected.. is it really normal to declare private device
> IOCTLs to configure PPS pins? Or are you just exposing this so you're
> able to play with GPIOs from user space?

I missed the full patch, but I'd like to point out that we already
have a rather fully featured pin control API.  If something is missing
from that API, then please, let's discuss it!

Thanks,
Richard
