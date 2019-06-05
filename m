Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9AA63597B
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 11:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfFEJOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 05:14:12 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41153 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfFEJOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 05:14:12 -0400
Received: by mail-ed1-f65.google.com with SMTP id p15so1447917eds.8;
        Wed, 05 Jun 2019 02:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SIkDJF94QQYpgHjDwpPSCXyyZeSnG/w25TXgH00ITJ4=;
        b=dJIeKYAqYBd28rV2p/QlSsx12zlwv+SPzRaNni4M9LXFcPdEM/SQ5LqFS5djuvZGQY
         jTaps0K0Ie7cH0SHbePdXwE29V2QBN9E+iSaoBWQdz6q7mguHzCzWRp1ntgMuLchrDTo
         rTJZBRxfNBjb6OAT6byWZ/l7BZjCUIClDmDZToqReWVUIGOU+FSK/fDKFSamfPNsCNzy
         DZ0vjtfkeqCfqqyIdSEgDNWo3yYby2UALLyE8uboNe+HvQK0pzS6iLoQKKkQsBiOUFCN
         As8x786O1FJeHKdgFlIqQFKVYlyKSsd45ncYNaqhThhjGVM8F9sbdEB72WBMoAlDiLw8
         kaZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SIkDJF94QQYpgHjDwpPSCXyyZeSnG/w25TXgH00ITJ4=;
        b=WS3zCY7ZeIEX0/jDqFykCd0fZuztC+OPFbz/6O9UQlSz9lE9OuQYj7fRLXBbOtmmJm
         bq8Df1EZwv/G+R1G1RYqKCLdhl75IH7GyQl8Z8L+PScI9UugTu3u9l3qvElxXPoPA7wK
         QtLoppT/iYrfxANCn11X5gkxxNCCwZ2y8NsZMVt/7qNZLfk6JIudBkMkJt98n/1OWqnh
         uOIENoX5dONdRet9fcI0AIn6RSnTfnhq5z2U/SziakzXCc/GrsW3ZwKsi7dOIEDkFYBU
         KdEoKaDfKFkNPxwb3acoSCoPHnUuf+oi6EPzFDrH1mJxgMn1reMEpbEsrNcIojMKJKzN
         HT/Q==
X-Gm-Message-State: APjAAAVi3eBmJ3I5gKzfh+aGQsPeGUoCv2bARd2+yZKw8bPSNVRM1/qp
        6WAjZ77HG5Nk45mL7R2YBoE1oawFLe7x+Llwa6Y=
X-Google-Smtp-Source: APXvYqyHSZHvR/bUxZb93EVUfWQPfAPFW8EIGruc4u8ilMEr/FeRSUn6fvrkKFP6vb04Oxns8NU5X8ceMsgMDq/S+NU=
X-Received: by 2002:aa7:da4b:: with SMTP id w11mr34037247eds.36.1559726050471;
 Wed, 05 Jun 2019 02:14:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190604170756.14338-1-olteanv@gmail.com> <20190604.202258.1443410652869724565.davem@davemloft.net>
In-Reply-To: <20190604.202258.1443410652869724565.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 5 Jun 2019 12:13:59 +0300
Message-ID: <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 00/17] PTP support for the SJA1105 DSA driver
To:     David Miller <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jun 2019 at 06:23, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Tue,  4 Jun 2019 20:07:39 +0300
>
> > This patchset adds the following:
> >
> >  - A timecounter/cyclecounter based PHC for the free-running
> >    timestamping clock of this switch.
> >
> >  - A state machine implemented in the DSA tagger for SJA1105, which
> >    keeps track of metadata follow-up Ethernet frames (the switch's way
> >    of transmitting RX timestamps).
>
> This series doesn't apply cleanly to net-next, please respin.
>
> Thank you.

Hi Dave,

It is conflicting because net-next at the moment lacks this patch that
I submitted to net:
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=e8d67fa5696e2fcaf956dae36d11e6eff5246101
What would you like me to do: resubmit after you merge net into
net-next, add the above patch to this series (which you'll have to
skip upon the next merge), or you can just cherry-pick it and then the
series will apply?

Thanks!
-Vladimir
