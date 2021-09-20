Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58F34126A6
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 21:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347498AbhITTRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 15:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243382AbhITTPw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 15:15:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 277DF60FC1;
        Mon, 20 Sep 2021 19:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632165265;
        bh=0g8QTHavk1g8jErThgF8Kwdgu3c5ORY2nZ9iZPtiABA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xb1d8KAlERK0ejLDz2t1CulG4RHyauoH7X35DNDDYLPdUzuR9oUWYQfVDItv76Wus
         lRfs+/lJvBDZifXUFQ4pNgSu9BCaeg0R1Z6yRF0hanOkZ+rSlqVjSg+gQboN7vXVCj
         e5xz4B1xMXyqzLkLz1VWPocTg10fwVPYdYQUjjwnJ0tLIe42oPKHWiIWgGW4dVtTIs
         M6eVJIdcojX6SvoUfuYNU3wbbesNiNZZ0JA8zF2WTZuWIBlzg8lBEwFd4yAw14ZPNo
         rQYOMana294NcpG59hUS5P1xCt5p/BrA27tABKZZritX7JCZQfc5CL9SxWAapX1yoq
         vV2brQN3tMvog==
Date:   Mon, 20 Sep 2021 12:14:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net v2 2/2] ptp: idt82p33: implement double dco time
 correction
Message-ID: <20210920121424.212c7df8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <OS3PR01MB65935EC20F350036340F3348BAA09@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <1631889589-26941-1-git-send-email-min.li.xe@renesas.com>
        <1631889589-26941-2-git-send-email-min.li.xe@renesas.com>
        <20210917125401.6e22ae13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <OS3PR01MB65936ADCEF63D966B44C5FEFBADD9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
        <20210917140631.696aadc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <OS3PR01MB65935EC20F350036340F3348BAA09@OS3PR01MB6593.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Sep 2021 14:08:37 +0000 Min Li wrote:
> > > We use this parameter to specify firmware so that module can be
> > > autoloaded /etc/modprobe.d/modname.conf  
> > 
> > Sorry, I don't understand. The firmware is in /lib/firmware.
> > Previously you used a card coded name (whatever FW_FILENAME is,
> > "idt82p33xxx.bin"?). This patch adds the ability to change the firmware file
> > name by a module param.
> > 
> > Now let me repeat the question - what's the point of user changing the
> > requested firmware name if they can simply rename the file?  
> 
> We have different firmware named after different 1588 profiles. If we
> rename firmware, it would make every profile  look same and
> confusing.

You can use symlinks to "choose" which FW will be loaded by the kernel:

ls -sn $real_fw_filename $FW_FILENAME

> On the other hand, with this module parameter, we can have
> phc module auto start with correct firmware.
