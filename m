Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DDB3A326A
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhFJRsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:48:20 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:37437 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhFJRsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:48:18 -0400
Received: by mail-ed1-f44.google.com with SMTP id b11so34050736edy.4
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tfujEkV1ar40+NestlUagDwSwO9ngrtdnyh+S5BFhwQ=;
        b=tINPLVQAFy+TjgJS8rfu1u1s4IIBbKEc+9F9FtyEQ/2Uo7Imw8uCLqqh8AlFyfT5vx
         G0OdPaqksIZUjN+RF/g0Hqr9lwk1PvfzODsL8cA1rMMxT7lISi0w4TNhZTWmL5GM4RKw
         FVQMl57zED5uEuwy1HLz2wez4wVChS++yv0J4b2BgBnX0I+bCXbws0fO0JUxhHtKuL5H
         xLUpk7CEUkWswNmDBjTvC80knnZ+xA2LLGz3TgyDoqV4u9DPXdZuEjEqdW2xFVzBwBS1
         fT7nuCu1S1zAccOwV16+iteXHFyeLNwIGsigWObgInRpcf0J5Borwq8HfDC360iPf2sq
         b9xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tfujEkV1ar40+NestlUagDwSwO9ngrtdnyh+S5BFhwQ=;
        b=DegbeZnEY15jRGa6970QTLsvqo0zh1tFwyAg7AiFusghfPsSDstPkJgWjRLjLeY8Pk
         OOvp+p1heUSe9v1Ze1OGW4a1SIh7ZQ2Dj0U65ioki0YUqp5UsA6KpVqPY5Ugsmg61ky4
         kBs79c5f5UYhdt7p49eGAb/TtgkXX5xKBzSQc4qU8CdpnVwJyybgc/h/hsrFs48UJWM2
         lsDb2191fOhUb7qQ3ScxYcCWBYondUBYUg6RIFCNC2P8q//E4zaG/WHzsaOawt6OUTEX
         MpoaDqBmpa3a5R1g81Fjs6ZclVAB/N/O0haoDt+CSc2DxDdYQbVpFN5aq9TRI8H+vDMH
         9rHg==
X-Gm-Message-State: AOAM530obaPgOn/QodS9kjcN4KI2qpw1cG45nVsXwBTzKTTYkH07C+SW
        3zX1RytpU7a1hZQpe79vfbk=
X-Google-Smtp-Source: ABdhPJzLSKLrSUiy02p8h09TfMhE+bI5ICcCq0sxAIy8n0FIyr220SP25Xo9E0gM5hdWW5D1ZPakiA==
X-Received: by 2002:aa7:de90:: with SMTP id j16mr612347edv.385.1623347120939;
        Thu, 10 Jun 2021 10:45:20 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id wq10sm1282959ejb.79.2021.06.10.10.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:45:20 -0700 (PDT)
Date:   Thu, 10 Jun 2021 20:45:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 00/13] Port the SJA1105 DSA driver to XPCS
Message-ID: <20210610174518.5stvpwgx2rzdzqk5@skbuf>
References: <20210609184155.921662-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609184155.921662-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 09:41:42PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As requested when adding support for the NXP SJA1110, the SJA1105 driver
> could make use of the common XPCS driver, to eliminate some hardware
> specific code duplication.
> 
> This series modifies the XPCS driver so that it can accommodate the XPCS
> instantiation from NXP switches, and the SJA1105 driver so it can expose
> what the XPCS driver expects.
> 
> Tested on NXP SJA1105S and SJA1110A.

I expected there to be more objections to the choices I made, but I
guess silence is a feedback of sorts too.

I need to resend because of some small fixups that I need to make, so
please mark this as obsolete. Thanks.
