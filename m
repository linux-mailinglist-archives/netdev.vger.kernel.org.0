Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA25CDF625
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbfJUThz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:37:55 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45477 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfJUThz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 15:37:55 -0400
Received: by mail-qt1-f195.google.com with SMTP id c21so22866436qtj.12;
        Mon, 21 Oct 2019 12:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=OvR7qZTN7z+OQITB5g0tsZqaN65/2chZfmtHixddV6M=;
        b=UddYj1I13Df1ib5gS+cO7AEnjxjMACvGxxpBFhhPxy6aqTFoOVSCk004bJPWlHaLol
         3uJCaoZcyXgFrmMm7tudkLK2Quk00vEFpX4tZxfs9EddWODhyi4QYAF9vfAgko3fA05O
         XZlJVqhV/mX/Q1OtpWPvVeDGdc28+TEuMXp8ODlb547QQlJfHi82vuoOzUImN/K7arlt
         /SDIe/0ngQLnMDPFOIouSz/l9PaLE9tix0sHw2o/+m42TMI7cN79WjyC6mLbxebyrr0o
         6a2N6vaskyLWDNwYub8jJTCZ36/bBsbAQwWlnz1Dv4dUgA2eXScEPG0w0HXwfWS7DMxK
         OynA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=OvR7qZTN7z+OQITB5g0tsZqaN65/2chZfmtHixddV6M=;
        b=UWz3Lgj4CFuxVXTHQyGHMe5kgJ4RAgLzncTaHrujA1RZjjlxxdp8G14ue+YuBHCI47
         2ZTGyhnjMF0cgn01iaGbXRBwIJ2VMpGVP226ZS6hfvFsn/yuZySirxKqJgwHKSOCI/pY
         cyCY2UHlbn0Dy/o13q+lbT+v1n4vS8NHRM15REHM2pcxH6VQ4v4HczhjEus+1SyCZnhG
         zd2LsC7hNCsd/ubdtkTEtcgBKxprBerruniNDfCWcxbxCVx7WkJP/8VLFXFgUELhN07l
         1+jHK8rlerUJGGECOtQD1q11raALnek7F7KxPpaUr4nYngu4j0X51Iix+fSkjTFxgroD
         zh7w==
X-Gm-Message-State: APjAAAVbB8NUn0mjkHAAmuiOxj+LKaba8PjJH4Hf9D1IJhmzX9AxezbT
        CNGAWKA97BtWQdl9N/F5ioJAGD/Q
X-Google-Smtp-Source: APXvYqz989ocNhooAn2C9jPnGfPL+Ya9E4GvReVSsCzgSht22ZfFT6OEq4NiSmYUnUZJZGauM9QoHA==
X-Received: by 2002:ac8:2c86:: with SMTP id 6mr25828203qtw.317.1571686673828;
        Mon, 21 Oct 2019 12:37:53 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id z5sm7851619qkl.101.2019.10.21.12.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 12:37:53 -0700 (PDT)
Date:   Mon, 21 Oct 2019 15:37:52 -0400
Message-ID: <20191021153752.GB90634@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 05/16] net: dsa: use ports list to setup switches
In-Reply-To: <20191021124902.GF16084@lunn.ch>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-6-vivien.didelot@gmail.com>
 <21738767-7e98-6c4c-ba1c-bea29142d481@gmail.com>
 <20191021124902.GF16084@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 14:49:02 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> On Sun, Oct 20, 2019 at 07:42:15PM -0700, Florian Fainelli wrote:
> > 
> > 
> > On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> > > Use the new ports list instead of iterating over switches and their
> > > ports when setting up the switches and their ports.
> > > 
> > > At the same time, provide setup states and messages for ports and
> > > switches as it is done for the trees.
> > 
> > Humm, that becomes quite noisy, would it make sense to have those
> > messages only for non-user ports that are not already visible because
> > they do not have a net_device?
> 
> I agree, it looks noise. Maybe change them to _dbg()?
>  
> > If you have multiple switches in a fabric, it might be convenient to use
> > dev_info(dp->ds->dev, ...) to print your message so you can clearly
> > identify which port belongs to which switch, which becomes even more
> > important as it is all flattened thanks to lists now. What do you think?
> 
> I do think it needs to identify both the dst and the ds.

It is noise indeed and doesn't add much value, I'll remove them.


Thanks,
Vivien
