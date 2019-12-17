Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E15861230D6
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfLQPty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:49:54 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36808 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbfLQPtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 10:49:53 -0500
Received: by mail-pg1-f193.google.com with SMTP id k3so5890883pgc.3
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 07:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kSrTvcjDG2rfeDj/DoUiqKIsmDe1I17BLAhzGf2Jm4s=;
        b=ck5P1R1EaASD/ERU56tf6luVfzFgK/8DfxUQ4I4JHl7sYKw8rIh1n4SGKasj88Wtvh
         8f3AN8UqbwgfHZfmVVXsqJNosqwUqvUf9X0fdOdObRXcAngL+ipReHFzgmx6EpALRcIF
         ah+CNb7sQMFM2ujnQbAFA7fB8Sg2uAHowOje4uYLYDyEQ8YA9xLVsE7el3m/xOwoRQC+
         TZ+KVp1TiaKeTBcCJKHrfHamTj9ar2kUCOoRpu9yc3OdFG6FhrlT8CDSPBn8kH3t25kY
         A/lfPqUILX/jrmkrlObvqXm03CdwPtREkGJ9oin6b/6yl3ZsOXuthnWZlQG5/hD/XyiF
         1a1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kSrTvcjDG2rfeDj/DoUiqKIsmDe1I17BLAhzGf2Jm4s=;
        b=qYlTL8Ew4fng9JDgMCeJCb6BEt2mc8i473fRGaVtfK3WYu5cK40NDtwj5T7ZfbFY8/
         K8bSIkEjkadLfmAMmfhNoAvm7MfBbUf0QSAM1LCrusbaML6puBIVq3NzGWoXjx0sJRfV
         P1Utke/nkG46O+Q4azwqnSHQOHMhgZ4o9watuRhNc+h+1AZm1ho+xTkrlleIVaXOtM1V
         Efiodo+D9+x4VYPtkHHBREiifG49TsPjIxe7EuYLFrK49B9WegcPwVllGc2pwogZChRd
         8WCIGlBlTjQFxM/UFl8lbvmrs2EaTAvpQx9RkYRhGHNEdnwHVwL7/b9MKu8CNl+Iequz
         MIew==
X-Gm-Message-State: APjAAAXfKXIzPMcha8tGE3bAHldJFrFcMFnKiJgt4FKWasM7UEFiTFXo
        n95mQQjwA4oSduVnQLp7HVA=
X-Google-Smtp-Source: APXvYqxAT+2R/DrvmX06LKH0oImnzJLf2V6f1mddgkR61EuGHJZAMszwBWQ6OpqKZ9vaIBN35oKDPg==
X-Received: by 2002:a63:4b48:: with SMTP id k8mr25732169pgl.362.1576597793355;
        Tue, 17 Dec 2019 07:49:53 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id u6sm2657561pjv.31.2019.12.17.07.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 07:49:52 -0800 (PST)
Date:   Tue, 17 Dec 2019 07:49:50 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Radhey Shyam Pandey <radheys@xilinx.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>
Subject: Re: [PATCH net-next 1/3] net: axienet: Propagate registration errors
 during probe.
Message-ID: <20191217154950.GA8163@localhost>
References: <cover.1576520432.git.richardcochran@gmail.com>
 <42ed0fb7ef99101d6fd8b799bccb6e2d746939c2.1576520432.git.richardcochran@gmail.com>
 <CH2PR02MB70009FEE62CD2AB6B40911E5C7500@CH2PR02MB7000.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR02MB70009FEE62CD2AB6B40911E5C7500@CH2PR02MB7000.namprd02.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 06:19:47AM +0000, Radhey Shyam Pandey wrote:
> > -----Original Message-----
> > From: Richard Cochran <richardcochran@gmail.com>
> > Sent: Tuesday, December 17, 2019 12:03 AM
> > To: netdev@vger.kernel.org
> > Cc: linux-arm-kernel@lists.infradead.org; David Miller
> > <davem@davemloft.net>; Michal Simek <michals@xilinx.com>; Radhey
> > Shyam Pandey <radheys@xilinx.com>
> > Subject: [PATCH net-next 1/3] net: axienet: Propagate registration errors
> > during probe.
> > 
> > The function, axienet_mdio_setup(), calls of_mdiobus_register() which
> > might return EDEFER_PROBE.  However, this error is not propagated to
> EPROBE_DEFER.  In which scenario we are hitting probe_defer?

Did you see the cover letter?  I am referring to this series:

 16.Dec'19  [PATCH V6 net-next 00/11] Peer to Peer One-Step time stamping

Thanks,
Richard
