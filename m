Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8E322C9B0
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 18:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgGXQDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 12:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgGXQDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 12:03:39 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC4FC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 09:03:38 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o13so5496064pgf.0
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 09:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iTWzZ1epZdTMbD//DXmhN5Aht50rMYkx9CMxqer7iJg=;
        b=nm+/a0Nrmbb5h4JONgC7IM88/uAmlfKr3UOSpK82EbUOUa5MoIwe5Zit9rVZ8LJ7s0
         BHkNbKUemRR37NIBQfkNUZ+YrhnwoMq7RtiarBbGDOugiMJppcLWzAClC8PmlzLd3JzG
         5HQvXXfJzTOCZarl5wX8GHo96zflQmGEwBCDxSgeRucMDkJxZ32bPk2cKix9jfNuy+1Z
         T0fRDY1KekxTW+ommMHyMgEOEBDnY0BRuMVtE41z7L1nYUBY/VGetHUYN05bsiSmhCNY
         9XUZ98aF5Q8Bm7TzBkAUPHu/kc+4ubatMVNAIZvEst6/5g3xl22KOAqlq4MAEYDwPLSC
         3K7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iTWzZ1epZdTMbD//DXmhN5Aht50rMYkx9CMxqer7iJg=;
        b=Bzw2MPvR1IJN4tEJcrTnJfMu+DoRY0sXwSZB9tVdSvl7yctnVvkURJWd79t7KOz64p
         pAWw1ucvNVGtI87PAmnkfJuz3tpgr6Y9a+K5LG5HHsyyIlvcK/Bq3EckXg28+5wYa8lB
         IGiiEx5daIq9DJhh/rY8/DfdSmkDhN0fflia5y2xZ9cZQ81XvVTAaeb3cQSEtbkz75P9
         oXKxtEUG/Me5pYzgrCTgmUXhi1yABgYPcGFwIdH63ZUV7sSF22KWGBL/IjfnjWU+Wmjd
         cILekqmYO3CfM47SjJLPpNbt2OCPXfevFu9Dr9D9oeManxl3XdDqUmImWA79RHs7Noj9
         rWlA==
X-Gm-Message-State: AOAM532R8S2XoYBK7D+AA63DiLVA8BhI/6bamEu7yb0XJsLoBNjpNXO0
        LNEJp/DdvCpyXA0VxAaaJJI=
X-Google-Smtp-Source: ABdhPJwv06ojC2bXnPYrURWkt0o+Q2qz5kJfAr1o0lbstdjBdhyb8d+pj68Ylsh3SBGUkJktfxbVTQ==
X-Received: by 2002:a62:2ad6:: with SMTP id q205mr9551824pfq.316.1595606618452;
        Fri, 24 Jul 2020 09:03:38 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d24sm5949906pjx.36.2020.07.24.09.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 09:03:38 -0700 (PDT)
Date:   Fri, 24 Jul 2020 09:03:35 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 0/2] ptp: Add generic header parsing function
Message-ID: <20200724160335.GA30531@hoboy>
References: <20200723074946.14253-1-kurt@linutronix.de>
 <20200723170842.GB2975@hoboy>
 <87r1t12zuw.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1t12zuw.fsf@kurt>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 08:25:59AM +0200, Kurt Kanzenbach wrote:
> These three drivers also deal with ptp v1 and they need access to the
> message type. However, the message type is located at a different offset
> depending on the ptp version. They all do:
> 
> |if (unlikely(ptp_class & PTP_CLASS_V1))
> |	msgtype = data + offset + OFF_PTP_CONTROL;
> |else
> |	msgtype = data + offset;
> 
> Maybe we can put that in a helper function, too?

Yes, please.

> |static inline u8 ptp_get_msgtype(const struct ptp_header *hdr, unsigned int type)
> |{
> |	u8 msg;
> |
> |	if (unlikely(type & PTP_CLASS_V1))
> |		/* msg type is located @ offset 20 for ptp v1 */ 
> |		msg = hdr->source_port_identity.clock_identity.id[0];
> |	else
> |		msg = hdr->tsmt & 0x0f;
> |
> |	return msg;
> |}
> 
> What do you think about it?

Looks good.

I can also test the dp83640.  Maybe you could test the cpts on a bbb?


Thanks,
Richard
