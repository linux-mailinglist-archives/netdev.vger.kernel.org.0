Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848831638BE
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 01:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbgBSAwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 19:52:38 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:40749 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgBSAwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 19:52:38 -0500
Received: by mail-qv1-f67.google.com with SMTP id q9so9145104qvu.7
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 16:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=ReYYo0nJD4XqtOkbDQZgf1vkNB8BgQ6IXmfA/VC6LVE=;
        b=tZZe3EuS9pdGP180rzZJFevAf9wDC+0k0+ziG4iRqGzFyrxEYw7/CG6++1N+UQzgy0
         iceLtgN1GWDbHSXnnuiViF2YicJBSQksnmVurMJd3hM7NkdkMU1kadSPjVb1hZ7ld1xH
         wRvtOfPA62s9IhIsvLCF19lHHIbPB/KMriNxQOFGK+zV4nFbWe21Werk+c/1VIRDfTlf
         7onc87E0PwnmQeKGrLWMOd9gKa7Q+PEGS8Vw2oa2QHcTfK5lJ/ZKeqUf1oqjJGalAEUw
         XH54re80xn+bx9u3nITVII/kRn3MUQS3bpR+3f5V2BhBL8bXrDHLVTHJvGZVC2PP98AH
         Sraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=ReYYo0nJD4XqtOkbDQZgf1vkNB8BgQ6IXmfA/VC6LVE=;
        b=oLgVi6jKsx5XQ05Z6H3Wpv5v82I1EVtThQeQW6v8vrosX9Qefx2k/ZiFXsQRbRzzj5
         iWk45cjX1BoxQQIcNizG5LhoNvXsTgOStgyq8Uz5qn40CAvix5JLo5FfRg6qjVHXCK0A
         jSfxNy4vg6+l49C6rHhLB6qLxqjsetO45ufOsTlCr7RSooDDpMeQ1TnSX4tSMlIQBShl
         MJnNrK2t8SMEmUabdKx6yC6nQAWw7eVP5E0oEtCartBh/C5pXi7ki+qr6gLSHfl86jjL
         Br5wvNPDQXNqAv0YNPCPYNhNKEvzXYc9Oo9YmjZEBAD+x7zcO2wyA/q7FwcGUErjTTeI
         F1SQ==
X-Gm-Message-State: APjAAAVrNcfuLWNmaqrH34cYSFUgQOhYNt4+8byiKJtmwHbZms6NI1br
        2mGY37Uvjn7fprNr2DpjwHE6tX7DPRQ=
X-Google-Smtp-Source: APXvYqxV/DqJbV3qdXYTi2lFX39nmDDLbC730/JxnBDz2/LCnPWPRlTIOmy3+aiFvZ7QN88+uIODlA==
X-Received: by 2002:a05:6214:9d2:: with SMTP id dp18mr18607076qvb.98.1582073557370;
        Tue, 18 Feb 2020 16:52:37 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id d20sm124586qto.2.2020.02.18.16.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 16:52:36 -0800 (PST)
Date:   Tue, 18 Feb 2020 19:52:35 -0500
Message-ID: <20200218195235.GB80929@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: fix vlan setup
In-Reply-To: <20200218234806.GN25745@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <E1j41KW-0002v5-2S@rmk-PC.armlinux.org.uk>
 <20200218140907.GB15095@t480s.localdomain>
 <3bfda6cc-5108-427f-e225-beba0f809d73@gmail.com>
 <20200218234806.GN25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, 18 Feb 2020 23:48:06 +0000, Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> On Tue, Feb 18, 2020 at 11:34:38AM -0800, Florian Fainelli wrote:
> > Russell, in your tests/examples, did the tagged traffic of $VN continue
> > to work after you toggled vlan_filtering on? If so, that must be because
> > on a bridge with VLAN filtering disabled, we still ended up calling down
> > to the lan1..6 ndo_vlan_rx_add_vid() and so we do have VLAN entries
> > programmed for $VN.
> 
> From what I remember, _all_ traffic was blocked because the VTU
> was completely empty when vlan filtering is turned on.

Not sure if the default PVID is 0 or 1, but one of them is ignored
somehow. Setting up a default PVID in the first place is a way to ensure
the programmation of the VTU, like in the following example:

    # ip link add name br0 type bridge vlan_filtering 1 vlan_default_pvid 42
    # ip link set master br0 dev lan2 up
    # cat /sys/kernel/debug/mv88e6xxx/sw0/vtu 
    vid 42	fid 1	sid 0	dpv 0 unmodified 2 untagged 10 unmodified

Russell can you test this? If things work out for you when setting up a VLAN
filtering aware bridge with your own default PVID before enslaving DSA ports,
then the problem is narrowed to propagating the default bridge configuration
(default PVID and configuration after enabling VLAN filtering).


Thanks,

	Vivien
