Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44BA6319B3
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 07:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfFAFDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 01:03:17 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37881 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfFAFDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 01:03:16 -0400
Received: by mail-pg1-f193.google.com with SMTP id 20so5167385pgr.4;
        Fri, 31 May 2019 22:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W5YOjTSjcVEeH4tLlP4YyUILFLR3HEckYULDnrQTH5s=;
        b=FyDqpJnrl9tMtaQP4byW7MOQFdvKUCq0V8aUcPw4Xp5LPe5cKcdA4J3GWa1K8ap/lj
         ju94WoMcU6e9fJstu1saFNZ9WoN+XEKPABBX6L5erzQRRfVDiSQDigQSLSXraR+f50eS
         Wex+1qvelB/K6UiTy7wePxsDJL5peysoZxFgAC+qW1cHNt/BkfPW6Cy2CJqk8LkbMCS6
         aGzvAOnAikbQ0rZCIsto6P0koykIIjRqfjs/C5HGIk6qGIkw3FFP6h/nCW6KA541WkHg
         VvqJ4vf2vPIsHmJioF4lePWtQO0F/gyyT5MJn9sqWybZZoEWUy5QTE3yNW4Ka0YVg9xa
         yUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W5YOjTSjcVEeH4tLlP4YyUILFLR3HEckYULDnrQTH5s=;
        b=E213EwGpcDI86G59YrjGnKZfIKPDOEv49mEIYPZQiHU7mljf1unh5rW8pFPZsG4XYn
         9wuVgxbCc6veXIlmKRdsAoEfPvTc54cbcW98bgIz9pbeeoYq7dqa9sSUC2cqo6rxq/PA
         5lLNpTjZfCNBqjrP+idROi54Px/IQKIFGbv9GowjWaxwWzjTODnUWx4Jw5OAfSLntm4U
         HPHjoNqw7SfcYglPsY21t+qEoTcOSBAwUvyvyNu1BSFAS3v2bPzilCFHy+H8MOpvgVMZ
         0C88ZJ7fFlWm79ym95xse/Fx9MSEboGoOe62VDxWpEcl0rjcH5lWUuvezzjrfE/np7ss
         GAkw==
X-Gm-Message-State: APjAAAWRci9w19Czl9peq2jz4AY+UVglF+jIpc9ktcBaKZbcLOSmlDvR
        2J6u6G2gBRyKRXX2K/pOQus=
X-Google-Smtp-Source: APXvYqyQ+rkew2nmTWMD6uCs/uRxWQpttscW0srV2r3TExIw3gA+xxdCJXv9rFsPtIJm80YvFu3e9g==
X-Received: by 2002:a62:1692:: with SMTP id 140mr14245699pfw.166.1559365395965;
        Fri, 31 May 2019 22:03:15 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id p63sm6766694pgp.65.2019.05.31.22.03.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 22:03:14 -0700 (PDT)
Date:   Fri, 31 May 2019 22:03:11 -0700
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
Message-ID: <20190601050311.3dkzbsm3kiccyd35@localhost>
References: <20190530150557.iur7fruhyf5bs3qw@localhost>
 <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
 <20190531043417.6phscbpmo6krvxam@localhost>
 <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
 <20190531140841.j4f72rlojmaayqr5@localhost>
 <CA+h21hroywaij3gyO0u6v+GFVO2Fv_dP_a+L3oMGpQH8mQgJ5g@mail.gmail.com>
 <20190531151151.k3a2wdf5f334qmqh@localhost>
 <CA+h21hpHKbTc8toPZf0iprW1b4v6ErnRaSM=C6vk-GCiXM8NvA@mail.gmail.com>
 <20190531160909.jh43saqvichukv7p@localhost>
 <CA+h21hpVrVNJTFj4DHHV+zphs2MjyRO-XZsM3D-STra+BYYHtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpVrVNJTFj4DHHV+zphs2MjyRO-XZsM3D-STra+BYYHtw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 07:16:17PM +0300, Vladimir Oltean wrote:
> But now comes the question on what to do on error cases - the meta
> frame didn't arrive. Should I just drop the skb waiting for it?

Yes, that is what other drivers do.

> Right now I "goto rcv_anyway" - which linuxptp doesn't like btw.

The application sees the missing time stamp and prints a warning
message.  This is IHMO the right thing to do, so that the user is made
aware of the degradation of the synchronization.

Thanks,
Richard
