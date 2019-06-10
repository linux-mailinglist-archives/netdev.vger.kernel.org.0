Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE873BFB7
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390455AbfFJXIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:08:43 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:45796 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390340AbfFJXIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 19:08:43 -0400
Received: by mail-oi1-f196.google.com with SMTP id m206so7505815oib.12
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 16:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wbPFL3WPHFuIkZ+3A0g2bvOxpuhQfMhZUKtmaboqR6s=;
        b=UNbo7z8bGyxxKAeiavtoFDTumTPXSy9LbuRvn8eJf05NWC93+SLAquB4h+52La8Doe
         MZfKPokCwaGHzFKl9OORCX6EN7DPJfw3HBfKTwpiZ8uqCIvtTrl6Z/PqPRfXl+CJvgA4
         1Zjb7ScLdEcwU83Qaaft7CKWZWx1DjVioj2X8Q7hyjWwkNRLQlUIQqHJZN7CfP4QzV6t
         OthPesreaZTRgWPGvm4Nm64Pg6IPtdU5PdGH3F4iL95/LQthjG4hhePmCEIduq3k8ASn
         yjLaYU+Eu7Vem0fWB4vukY1Kv0PZKgj66VA677yyGQZaNGTcXdtySXaF4j8h0Fw12xaj
         olIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wbPFL3WPHFuIkZ+3A0g2bvOxpuhQfMhZUKtmaboqR6s=;
        b=jGUOj0gA9ftWWmZbCYJWvmFEFPTCz3VW9X+xfrqH7orNe2I3bNBf3HBkx1op1a/uEv
         DwuoMiTQ3govgFzbvYE1YU1Q2GGlPA0V96QG9oPhWMcb2b323K9VkYH83ylqTqOwBUoW
         3DM3hnnllVjZH7kXgCeOt+dj+svSpuEcqgs0ePoD9liiAaCH4x04Da0gm62sLJHEDiVp
         0Z+r36xz4GMXMZZppRZSC2jg0SGUj4UGBT7NU2p/Md7O3G2OIupPri6w/n+N4jn0jMhQ
         j/+aYeDi9W0larhbDwNzyGbjGBWcd6KFYcrFD7buPmcQ8vDWqw8wdDVe1F7UdKtES+02
         CxZA==
X-Gm-Message-State: APjAAAWwj8y5Q4fbUauwtuIrc9wZqjmDiKVrNj/ZX3vNVnuN5YPQnyq6
        PP8e7/vJG3EqU0XRx1AUow==
X-Google-Smtp-Source: APXvYqzK/YMyLM0x+JTR4hHEh5m0rJ6NYWYvmSrjh7BX/YudQJCv2YnJzX/+d4RAwtN3RHEExH8PGw==
X-Received: by 2002:aca:d846:: with SMTP id p67mr13666660oig.6.1560208122339;
        Mon, 10 Jun 2019 16:08:42 -0700 (PDT)
Received: from ubuntu (99-149-127-125.lightspeed.rlghnc.sbcglobal.net. [99.149.127.125])
        by smtp.gmail.com with ESMTPSA id e4sm4442497oti.64.2019.06.10.16.08.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Jun 2019 16:08:41 -0700 (PDT)
Date:   Mon, 10 Jun 2019 19:08:36 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     gvaradar@cisco.com, benve@cisco.com, netdev@vger.kernel.org,
        govind.varadar@gmail.com
Subject: Re: [PATCH net] net: handle 802.1P vlan 0 packets properly
Message-ID: <20190610230836.GA3390@ubuntu>
References: <20190610142702.2698-1-gvaradar@cisco.com>
 <20190610.142810.138225058759413106.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610.142810.138225058759413106.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 02:28:10PM -0700, David Miller wrote:
> From: Govindarajulu Varadarajan <gvaradar@cisco.com>
> Date: Mon, 10 Jun 2019 07:27:02 -0700
> 
> > When stack receives pkt: [802.1P vlan 0][802.1AD vlan 100][IPv4],
> > vlan_do_receive() returns false if it does not find vlan_dev. Later
> > __netif_receive_skb_core() fails to find packet type handler for
> > skb->protocol 801.1AD and drops the packet.
> > 
> > 801.1P header with vlan id 0 should be handled as untagged packets.
> > This patch fixes it by checking if vlan_id is 0 and processes next vlan
> > header.
> > 
> > Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
> 
> Under Linux we absolutely do not decapsulate the VLAN protocol unless
> a VLAN device is configured on that interface.

VLAN ID 0 is treated as if the VLAN protocol isn't there. It is used so
that the 802.1 priority bits can be encoded and acted upon.
