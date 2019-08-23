Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7009A707
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 07:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392025AbfHWFWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 01:22:21 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37593 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391792AbfHWFWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 01:22:20 -0400
Received: by mail-pl1-f196.google.com with SMTP id bj8so4890127plb.4;
        Thu, 22 Aug 2019 22:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lMXMx2vDpjNMDIWQ7QSQ6S8z7ajpHm6PRPm15ov737I=;
        b=KeaE7QBzkb3jKyzk60frx2nmGc53sHhcgj4GiTpkE5V+yt+i2UhHwO+i5JZLv2+vvK
         Er45DVGCzzFFKLZbGhkbgnuNHNkCtZOAeD+ry4E+7yqYbpDSDNzUUBGTyQF3WRgwpvNW
         LiVDbx/bk9dxioU/yyIVmxAac9fZ1tb8LF27sFd2qRipKrZ+sAkZhA7joikuu3ThX1z1
         3occALxywoENdOSkR5qr00GCmcRCtuAznyq63/XEemQJM1Nc5zcYzDYsdyiQA8lso6iA
         KpFwX/AvhtUbddB1x7Qd8Up/8JA+9OtS/OBWzklpYSYwcefCSV/k5i4K7SwOVVGsjhgr
         vW+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lMXMx2vDpjNMDIWQ7QSQ6S8z7ajpHm6PRPm15ov737I=;
        b=Zvldfv3by7j7/i4YLkdbLfDM+XGbZdk5HXpo5KHWGZlxE5zNlCe5ct/Jb2PVjRibWe
         HyyFVFDoNnsGop8OgVDdLjHMqeOljpZPy/Z4mJ86tlh0JD1ogOk8T5OM5nWXalqifOkj
         U2leEpdPO9oeauwjZS16BD6F+5F141ei6kLd/rTHp2xy1UUYb1mCsFbMErRQCqxHd8qJ
         fT4d24fbCI/Ot8UrcskOG0bykf/ZGHx2ksevZYgf2Xb2u09NKpi/SIh+Knv/FbToa9mz
         vPgUSxD8jwKT+tBxMTl0HFh5IoP2h4uPV3D3HDlw5XGpBTxX9vu75Jp+AFtd48LSQNT6
         HS6g==
X-Gm-Message-State: APjAAAXFd1TNUBxbh8vzcMzeJW6qOyldt+WjeOnl77hEhiZ7sUp8qu1f
        +sh+VoCSfDvvkXo1naasqpA=
X-Google-Smtp-Source: APXvYqzPpjd79hrCDg9pFpJZaiCK1tp4m/eK9Ybw2SvjavGGMsL0Av8sXWq5CTkdttLcr36xbzW0jw==
X-Received: by 2002:a17:902:2f43:: with SMTP id s61mr2640572plb.22.1566537740206;
        Thu, 22 Aug 2019 22:22:20 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id o67sm1625121pfb.39.2019.08.22.22.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 22:22:19 -0700 (PDT)
Date:   Thu, 22 Aug 2019 22:22:17 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH spi for-5.4 0/5] Deterministic SPI latency with NXP DSPI
 driver
Message-ID: <20190823052217.GD2502@localhost>
References: <20190818182600.3047-1-olteanv@gmail.com>
 <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
 <20190821043845.GB1332@localhost>
 <20190821140815.GA1447@localhost>
 <CA+h21hrtzU1XL-0m+BG5TYZvVh8WN6hgcM7CV5taHyq2MsR5dw@mail.gmail.com>
 <20190822141641.GB1437@localhost>
 <CA+h21hpJm-3svfV93pYYrpoiV12jDjuROHCgvCjPivAjXTB_VA@mail.gmail.com>
 <20190822160521.GC4522@localhost>
 <CA+h21hrELeUKbfGD3n=BL741QN9m3SaoJJ0y+q_uthdxvSFVRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrELeUKbfGD3n=BL741QN9m3SaoJJ0y+q_uthdxvSFVRg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 07:13:12PM +0300, Vladimir Oltean wrote:
> You do think that I understand the problem? But I don't!

;^)

> > And who generates Local_sync_resp?
> >
> 
> Local_sync_resp is the same as Local_sync_req except maybe with a
> custom tag added by the switch. Irrelevant as long as the DSA master
> can timestamp it.

So this is point why it won't work.  The time stamping logic in the
switch only recognizes PTP frames.
 
Thanks,
Richard
