Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46EB9307C3
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 06:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfEaEeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 00:34:21 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41318 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfEaEeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 00:34:21 -0400
Received: by mail-pg1-f193.google.com with SMTP id z3so3283420pgp.8;
        Thu, 30 May 2019 21:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=k1lABvVv11G/1BGI9nFcE5F+PdE4XUoO5D323rtAKn8=;
        b=VRx9M24f5WLDV7pO7VbGq3NnECZWZo49yn53ZDxxXzB6Ysaw+lGCHsM+IR+9GTI5JJ
         qwRgmUyQy+w2hD3Nj+aonhpWWRn2Vz9kzXkg3LvI4orh0feiMftuokFoi1KQzvmyuMp1
         eq0LY8z0BriZEDzd0DLsx/NXj4UA19KmY8pXoxTI4zttCh+4cknuUKTfl/I3yYo0o4C1
         b0fxTiBGF8Dd0VOAOTxPay9cRjP13dUah6rI6sU9DYoyCpxsVyh7GDU3oJni+t+ukzWU
         FyBRJBN+k0ZUXgMIgEJspxQOYkIjQ+EvPdSe+GNHXy4Iz5nBpoALaKvC5EFahSd4uezi
         o80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=k1lABvVv11G/1BGI9nFcE5F+PdE4XUoO5D323rtAKn8=;
        b=rfFExN90A5cEGzuc4aH8VS0cztzrkXVHTCsXZ16HVAK98FvLLVO1oLtM6mbJzfwC9E
         2K6EU13opjPFjiNXrxTjv+SUwz7eS2eK40kJVos37VQVNIP40HJm9x+Y0NFcSXOmARYa
         SBKI/5TeifDq72a5Ne+K0ln7qyRqIGjsDlU6WS7LpgGLKAm3/LzR7+4a15FuWNxzw7dW
         MJoXyoj4azfqp/eDd3e9LxS/Mr3YUH1yyDSAabG67BnntR0QN85LJOEckhfQhkxa3e+i
         R55OdC7CLYdpJr6+UG+6+vftJ/ISTl4k0AQ41RKrb2ig0TdcCQC2eK18qrhiuV7XdDmS
         FLuw==
X-Gm-Message-State: APjAAAUSm0M+H4glDrTlYa55oG2sUn20NrdA2M2nlUw5CDbhotd3OZUX
        6vQsVBW+irFA0SCOEEHHXK4=
X-Google-Smtp-Source: APXvYqyvXcJpTbvqOxUrPR7uenuJD7LBPIw1igpdciEBKs6jKLMDddZZXtXSa7h14V7eU7WormWGzA==
X-Received: by 2002:a63:eb55:: with SMTP id b21mr6749426pgk.67.1559277260515;
        Thu, 30 May 2019 21:34:20 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id u11sm4303610pfh.130.2019.05.30.21.34.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 21:34:19 -0700 (PDT)
Date:   Thu, 30 May 2019 21:34:17 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] PTP support for the SJA1105 DSA driver
Message-ID: <20190531043417.6phscbpmo6krvxam@localhost>
References: <20190528235627.1315-1-olteanv@gmail.com>
 <20190529045207.fzvhuu6d6jf5p65t@localhost>
 <dbe0a38f-8b48-06dd-cc2c-676e92ba0e74@gmail.com>
 <20190530034555.wv35efen3igwwzjq@localhost>
 <CA+h21hpjsC=ie5G7Gx3EcPpazyxze6X_k+8eC+vw7JBvEO2zNg@mail.gmail.com>
 <20190530143037.iky5kk3h4ssmec3f@localhost>
 <CA+h21hpp68AEEykxr8bJB=uJ+b0tg881Z7Ao_OfbTAXNxS8WgQ@mail.gmail.com>
 <20190530150557.iur7fruhyf5bs3qw@localhost>
 <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 06:23:09PM +0300, Vladimir Oltean wrote:
> On Thu, 30 May 2019 at 18:06, Richard Cochran <richardcochran@gmail.com> wrote:
> >
> > But are the frames received in the same order?  What happens your MAC
> > drops a frame?
> >
> 
> If it drops a normal frame, it carries on.
> If it drops a meta frame, it prints "Expected meta frame", resets the
> state machine and carries on.
> If it drops a timestampable frame, it prints "Unexpected meta frame",
> resets the state machine and carries on.

What I meant was, consider how dropped frames in the MAC will spoil
any chance that the driver has to correctly match time stamps with
frames.

Thanks,
Richard
