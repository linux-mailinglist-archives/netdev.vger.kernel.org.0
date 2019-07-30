Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 071637AF5D
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbfG3RMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 13:12:50 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38952 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfG3RMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 13:12:49 -0400
Received: by mail-pl1-f194.google.com with SMTP id b7so29193807pls.6;
        Tue, 30 Jul 2019 10:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AgS4ynwzpDjtajjWiM+sdCsk6/EASz43HKfRtrvW7tE=;
        b=eDldZPKC31mSktAn9ciKe8sqvOTKt3/jHQeCn69PY+dRj1L6chlFIXBxNLCZm39Oth
         Z44bFNepTXBwjKJlHJLeXfIJtz0fmZPr3HeYtwyybktAt/J/xkij3avn6rLpcZ67dZ46
         uO/mKFCo56+2mbKwFjD8jR743Qg1G8v3YQX56tQKjOnQW4AycxDTJo6RH4rOesU5WU5j
         Za1/Il63NNYYo9/35jNgAVSnVvQSDDRMcFXFc1tKMQLWtL/51vbAep06xJZSNmZ7uifA
         c+ZIxorOaVIDRX65sq+/cawTtvUHQWKuvQLoRAuWCsMm5rL8Gg/60FWv3ZcJKTYeqbdx
         6yDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AgS4ynwzpDjtajjWiM+sdCsk6/EASz43HKfRtrvW7tE=;
        b=UYZD7Jvffyw0GclJwTsk6bFRS1kllvwD+Q0CHs4gg6pTydfcGSdFP/yty1YOyn2ya+
         EnULxlFTS3oytXV+6NOmmC/GLOHdwrtFIBwBxz55tpRurwHoxMUfLfWF53rqplVIaK7K
         lO9kyW1iBldHDH8K+lQr8Zs3umsKgUd/5lNaw98aV7qfz+P5Ck7tfOnwX880uF9j6oos
         2Dc+I1WD+nfZ9WN9k2QZtUBJtpTTYhCBp0Ka5MvGKpi50Am9jkjG2CV0wtRT+16GdSjO
         0lVxb1XID4S0l/flv3VfGyTriTUEbM8zjLOQLXqS4hFZbgsYqZq5tVr+N5z3slTgmRmd
         1G5g==
X-Gm-Message-State: APjAAAU3ktOIW4nHU8z1oXdBb0yIa8P9hBILpKaapGGmdRinrZbwmMUU
        DQ2ZujikHU9FDyylfkKh+fc=
X-Google-Smtp-Source: APXvYqxkeg1kov+b6Jk2q5IzqV3W/CHgXCi6ZltPwHGrICXAnXgUx8aChbb5lWYuzFKYIRAfA9W7+w==
X-Received: by 2002:a17:902:e287:: with SMTP id cf7mr115326891plb.32.1564506769087;
        Tue, 30 Jul 2019 10:12:49 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id e10sm67474212pfi.173.2019.07.30.10.12.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 10:12:48 -0700 (PDT)
Date:   Tue, 30 Jul 2019 10:12:46 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH 4/4] net: dsa: mv88e6xxx: add PTP support for MV88E6250
 family
Message-ID: <20190730171246.GB1251@localhost>
References: <20190730100429.32479-1-h.feurstein@gmail.com>
 <20190730100429.32479-5-h.feurstein@gmail.com>
 <20190730160032.GA1251@localhost>
 <CAFfN3gUCqGuC7WB_UjYYNt+VWGfEBsdfgvPBqxoJi_xitH=yog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFfN3gUCqGuC7WB_UjYYNt+VWGfEBsdfgvPBqxoJi_xitH=yog@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 06:20:00PM +0200, Hubert Feurstein wrote:
> > Please don't re-write this logic.  It is written like that for a reason.
> I used the sja1105_ptp.c as a reference. So it is also wrong there.

I'll let that driver's author worry about that.

Thanks,
Richard

