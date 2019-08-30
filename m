Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 742EBA30DB
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 09:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbfH3HVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 03:21:36 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34840 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfH3HVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 03:21:36 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so6284773wmg.0
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 00:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=twCa64puDiziZK2hsD3AlCru3/vAz8rT+ytz7CCTc+Q=;
        b=ycplImANxSDgLuL4+kM16TKUU18e0wPvvbykU2ZxDAVTh+05eOYSVEqCOzsq38A58g
         JCePWp44lRAbdGu01bLeu0gG7/gNClDgyp4x4fWDvNCSOKyUbkWpiV/bep4ByxIaTAdV
         wVlA3yjw193zSV/zOS6w001K5g3PJWIW5CTxey92/pTG1Dw3TOTBQWjsA2wFW47lsNgp
         7KofvcXQ7OnMQFFEPWlCMSDncDrvtGhPrdm90i3NotON2vSDPFy9qZD5F/2HYuZFFmJS
         FjkL62iVJ2gCXJAMhOjhbvRHAdAT+EfDa3ifGsD5lBILbyndxgKjJJaP7+AvkS+F98jo
         0nsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=twCa64puDiziZK2hsD3AlCru3/vAz8rT+ytz7CCTc+Q=;
        b=eFOB8N66YvOGc0pgplBFweE9n0Ice+pz26wPk1m490snWe0vB03+wvUvdGUb3m5HBr
         VJQR94aLNhWp5S8akoSgKunGokcHWATau6LM/Z95HHijyUwQ4HS6cfnh5KIWL0kOrl2G
         vBbJbPsjZRPY+dDyihMmE1Yki7O+xBNDcEx96PWIvckTB9gcnfE+TKbOSvy9o6vaOr3r
         cPc76S1ZaKhrkFlzquhqt6lVOroPC5gGQ7x/0WpVHIRIMVojDGD0pGeWSXhpSrCgpZSG
         oSOBett6OeqDLpqzrjcGqSKpXFiwh78n5R800Vke3+8AAiEQXKCs2xymSk8gOCkNe8FM
         G2Hg==
X-Gm-Message-State: APjAAAV4UcxtMiHuy7iE64f/zUp4OuAhJ8zquot/SKUaixln9JLWfvwF
        HuwOlBDo6ZHkdPvsMhYd5KEs0Q==
X-Google-Smtp-Source: APXvYqylUVjX12tmncuYbyqQ8NjY6+N8NDkaFh0aScWK4rhmRgO0ieavEjgBJ2VSZyFOnILgxJODjQ==
X-Received: by 2002:a1c:4383:: with SMTP id q125mr16996265wma.16.1567149694154;
        Fri, 30 Aug 2019 00:21:34 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id u128sm1439715wmg.34.2019.08.30.00.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 00:21:33 -0700 (PDT)
Date:   Fri, 30 Aug 2019 09:21:33 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     idosch@idosch.org, andrew@lunn.ch, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        allan.nielsen@microchip.com, ivecera@redhat.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190830072133.GP2312@nanopsycho>
References: <20190830053940.GL2312@nanopsycho>
 <20190829.230233.287975311556641534.davem@davemloft.net>
 <20190830063624.GN2312@nanopsycho>
 <20190830.001223.669650763835949848.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830.001223.669650763835949848.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 30, 2019 at 09:12:23AM CEST, davem@davemloft.net wrote:
>From: Jiri Pirko <jiri@resnulli.us>
>Date: Fri, 30 Aug 2019 08:36:24 +0200
>
>> The promiscuity is a way to setup the rx filter. So promics == rx filter
>> off. For normal nics, where there is no hw fwd datapath,
>> this coincidentally means all received packets go to cpu.
>
>You cannot convince me that the HW datapath isn't a "rx filter" too, sorry.

If you look at it that way, then we have 2: rx_filter and hw_rx_filter.
The point is, those 2 are not one item, that is the point I'm trying to
make :/
