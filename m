Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B23179C89
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 00:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbfG2Wq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 18:46:59 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44637 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbfG2Wq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 18:46:58 -0400
Received: by mail-qk1-f195.google.com with SMTP id d79so45181968qke.11;
        Mon, 29 Jul 2019 15:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=h67qCGvm0vTXKgIvUnIlBDCvJ9/QVn68KTO/eo/1zmM=;
        b=WfrN/y03AxOglG1Z1TeJp9DyYJ1UTFmyZYGgaLxQjj7b5aT0LtiFaOBq93emjg/fwQ
         /HC8E818HDinvaSEcih5b952yDsA07fT9mcVTu/edVD1BXqIAiuuDOtjyw7/NBXLb91i
         Vx7jryKE6n2PfFk5Y06NjdqOrhgn8AvGQg+CyUrMpCCq3QOZKYoNFrp2/wbkft/CpJhL
         8pr41isaou1xYR+pCDOH1JDZCl2AjhocYK7lVdLGT510oHd7AoxnPUVDPE8OAGWtR7TK
         2MvPXjVe0a3+duMW9GQXIRQdg+BkHxXtWyqQGmuH1ku9ibIkQYBmoYIqECutPtPPdZ2H
         f/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=h67qCGvm0vTXKgIvUnIlBDCvJ9/QVn68KTO/eo/1zmM=;
        b=dnBxhrQEoJ+ebj77bvHZEyyVWTMbwsMwGcM0MLcQczz/4gC2p2ZaERefbT+iDVilQi
         QOzxRZm21jPDnguje+DaWyfo3TXw9/pYS2UeJqYks8V1uqfOcbxpL5TdD+rAdQJIUuSM
         vUlCUC0K4Dl+81fGp66CTxtPCDTD/CTTFEOPHbZM6ElfDDYnNRV2Y4BQvPPvyiO+xqwZ
         BvzwGO0qLTU3j3noDzAqqL71QwbmJeMXG9xQ5QSQqK8wEL03ovWWCpo9a/q7CWrTUwuY
         ZXpIwRuBtL4V8rsG/aM26Ed02JwAnlqzHCbPgnJmsWEfv1IacnxZXwJRMIN5znLSuVNy
         DdQw==
X-Gm-Message-State: APjAAAU4pTTEVNf7blcokUT1N0ydNEkKfe91kQOKighiuK5z9sG11xpe
        opZJV/dyVcFMh9fi3qCtIQg=
X-Google-Smtp-Source: APXvYqxGN/PrqrLwxa0ubP16VJN6Tc9atCYrusn+WPQ9FgY1lJKZQKlZ4iTMyWcdEaH3tcgIGJ0TvA==
X-Received: by 2002:a37:c45:: with SMTP id 66mr73264687qkm.31.1564440416719;
        Mon, 29 Jul 2019 15:46:56 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id t6sm27871081qkh.129.2019.07.29.15.46.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 15:46:55 -0700 (PDT)
Date:   Mon, 29 Jul 2019 18:46:54 -0400
Message-ID: <20190729184654.GC25249@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: avoid some redundant vtu
 load/purge operations
In-Reply-To: <20190722233713.31396-1-rasmus.villemoes@prevas.dk>
References: <20190722233713.31396-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On Mon, 22 Jul 2019 23:37:26 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> We have an ERPS (Ethernet Ring Protection Switching) setup involving
> mv88e6250 switches which we're in the process of switching to a BSP
> based on the mainline driver. Breaking any link in the ring works as
> expected, with the ring reconfiguring itself quickly and traffic
> continuing with almost no noticable drops. However, when plugging back
> the cable, we see 5+ second stalls.
> 
> This has been tracked down to the userspace application in charge of
> the protocol missing a few CCM messages on the good link (the one that
> was not unplugged), causing it to broadcast a "signal fail". That
> message eventually reaches its link partner, which responds by
> blocking the port. Meanwhile, the first node has continued to block
> the port with the just plugged-in cable, breaking the network. And the
> reason for those missing CCM messages has in turn been tracked down to
> the VTU apparently being too busy servicing load/purge operations that
> the normal lookups are delayed.
> 
> Initial state, the link between C and D is blocked in software.
> 
>      _____________________
>     /                     \
>    |                       |
>    A ----- B ----- C *---- D
> 
> Unplug the cable between C and D.
> 
>      _____________________
>     /                     \
>    |                       |
>    A ----- B ----- C *   * D
> 
> Reestablish the link between C and D.
>      _____________________
>     /                     \
>    |                       |
>    A ----- B ----- C *---- D
> 
> Somehow, enough VTU/ATU operations happen inside C that prevents
> the application from receving the CCM messages from B in a timely
> manner, so a Signal Fail message is sent by C. When B receives
> that, it responds by blocking its port.
> 
>      _____________________
>     /                     \
>    |                       |
>    A ----- B *---* C *---- D
> 
> Very shortly after this, the signal fail condition clears on the
> BC link (some CCM messages finally make it through), so C
> unblocks the port. However, a guard timer inside B prevents it
> from removing the blocking before 5 seconds have elapsed.
> 
> It is not unlikely that our userspace ERPS implementation could be
> smarter and/or is simply buggy. However, this patch fixes the symptoms
> we see, and is a small optimization that should not break anything
> (knock wood). The idea is simply to avoid doing an VTU load of an
> entry identical to the one already present. To do that, we need to
> know whether mv88e6xxx_vtu_get() actually found an existing entry, or
> has just prepared a struct mv88e6xxx_vtu_entry for us to load. To that
> end, let vlan->valid be an output parameter. The other two callers of
> mv88e6xxx_vtu_get() are not affected by this patch since they pass
> new=false.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 6b17cd961d06..2e500428670c 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1423,7 +1423,6 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
>  
>  		/* Initialize a fresh VLAN entry */
>  		memset(entry, 0, sizeof(*entry));
> -		entry->valid = true;
>  		entry->vid = vid;
>  
>  		/* Exclude all ports */
> @@ -1618,6 +1617,9 @@ static int _mv88e6xxx_port_vlan_add(struct mv88e6xxx_chip *chip, int port,
>  	if (err)
>  		return err;
>  
> +	if (vlan.valid && vlan.member[port] == member)
> +		return 0;
> +	vlan.valid = true;
>  	vlan.member[port] = member;
>  
>  	err = mv88e6xxx_vtu_loadpurge(chip, &vlan);

I'd prefer not to use the mv88e6xxx_vtu_entry structure for output
parameters, this can be confusing. As you correctly mentioned, this
initialization is only done for _mv88e6xxx_port_vlan_add, so I'll
prepare a patch which gets rid of the boolean parameter and move that
logic up.


Thanks,
Vivien
