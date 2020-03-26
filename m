Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39F119409F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgCZN7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:59:46 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34249 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727652AbgCZN7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 09:59:46 -0400
Received: by mail-pj1-f66.google.com with SMTP id q16so3377425pje.1;
        Thu, 26 Mar 2020 06:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=79P2l9w6W7WmPQUzQ+lJdPeSs/MsFdNWFgy77EXy/Go=;
        b=b4z01HGoSxY5I0/OAnoCK6nGMFAC1VJ4jxpk/xkeTi9zg7bhvnhhyw2bpS5KNad8k5
         jQnuLCuT1XNyCftzpCICXIcXnLmXKtxoQpnET++j7lTEzxTyfYs1tRj39lGjDXBq4AX+
         ywpMk5sxyBfx6DMCZQ/Xh0sPoi5rXhdEvifSk8t73g3vtI98JDi3YuV8Huwp2fjfExBa
         bzUovrtfu+EScEwu7UROnDiHu1CD2L8OLseGYJmJZwmhd8cUYmhdoDDTkAQZVQi41m2l
         jf90ann2F6O5y86kvfilisX7ozjs5RDMEySEOsIG1ysahwREQXizj2Yxylef1jWgzJK8
         tyrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=79P2l9w6W7WmPQUzQ+lJdPeSs/MsFdNWFgy77EXy/Go=;
        b=m8IpQ9j3XQ+cs3Mal6Pjuy33gxXu5GCplSVDPO/NhBnZqf0USWLMhOy5sTCLii/idT
         PncLJ5vpmm4KhsMAvSclvhd5SAYhn+FCCdX4NBPjVx1wH8uZR74uCxM9vq91f/nzWLsL
         4I9RHc22l+2FCTAU9/3A0vWBt/T2ZVzRpf3rGqfMWY84FFNAJM+ZM6ahRHB0nmGJzY/y
         qW/Fc7hPHoZ4z3fYx8oqmCDGoKLN6Hz9aBHLpXicF7MB7y0VfitI1F3VwgELCXZqnR+K
         r5gUxNxerteg4OldXU7LJ6Xvm68TNmEblIxb/2i4nSKgWK0CdkBMIwH6pK3MwBHliG04
         El5g==
X-Gm-Message-State: ANhLgQ31Egtv+pyANpWGHu3qSod0SoDd1P2v0oRaaYUSOY8qMliRJEeo
        5p7khKFXXh2CX2nx0vlgu7lf3AZ2
X-Google-Smtp-Source: ADFU+vsAZr6eD+eeAF+Sdv+/hG+glh6sOhao9VufpzChwNHCKOnD+wATO0o3BmrDtxASVd0N/wlhMA==
X-Received: by 2002:a17:90a:2dc2:: with SMTP id q2mr146980pjm.146.1585231183920;
        Thu, 26 Mar 2020 06:59:43 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id t4sm1772471pfb.156.2020.03.26.06.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 06:59:43 -0700 (PDT)
Date:   Thu, 26 Mar 2020 06:59:41 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Message-ID: <20200326135941.GA20841@localhost>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-7-yangbo.lu@nxp.com>
 <20200324130733.GA18149@localhost>
 <AM7PR04MB688500546D0FC4A64F0DA19DF8CE0@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200325134147.GB32284@localhost>
 <AM7PR04MB68853749A1196B30C917A232F8CF0@AM7PR04MB6885.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM7PR04MB68853749A1196B30C917A232F8CF0@AM7PR04MB6885.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 09:34:52AM +0000, Y.b. Lu wrote:
> > Of course, that is horrible, and I am going to find a way to fix it.
> 
> Thanks a lot.
> Do you think it is ok to move protection into ptp_set_pinfunc() to protect just pin_config accessing?
> ptp_disable_pinfunc() not touching pin_config could be out of protection.
> But it seems indeed total ptp_set_pinfunc() should be under protection...

Yes, and I have way to fix that.  I will post a patch soon...

> I could modify commit messages to indicate the pin supports both PTP_PF_PEROUT and PTP_PF_EXTTS, and PTP_PF_EXTTS support will be added in the future.

Thanks for explaining.  Since you do have programmable pin, please
wait for my patch to fix the deadlock.

Thanks,
Richard
