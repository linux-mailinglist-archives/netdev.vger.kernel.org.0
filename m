Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8680F9A409
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfHVXpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:45:03 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45667 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfHVXpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 19:45:02 -0400
Received: by mail-ed1-f66.google.com with SMTP id x19so10439519eda.12
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 16:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FbdSxSquo6bu+1lG1oBTZE8S4iBmcdynMf46ZL4lHmM=;
        b=KheXXH9DrVugx1DuoPfpXMj/IfzXjVpHInHvpj6ijgfov3SN1hSoFcK3QqMLPCZ1/X
         vCUOCDxU9r4a4pZ9rhbiWWuCmzabDlX3TTwApnzHIoRJJlcj5/bheidkO3U2coDR9Erl
         Nhl/4HC+/sIeyJ5uVVEVCaXLvfAbXAWLE4gW+qYps778CBhsE8vBLj2X6sz3udd+sXu1
         zhkJwX0PhJIu7OpxmGM0RaathiwsW6PCqAoCzGnN7oAhDMB+K028bvQ3AWOxbV3Xs7b+
         dB3hY4ceVoUJyzjepQ8fk9x3do2ke31fO3AOVb0fHJQSJxNYvBe6+MLRN5F5NsdfXlNy
         Fh8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FbdSxSquo6bu+1lG1oBTZE8S4iBmcdynMf46ZL4lHmM=;
        b=OwJyWRKP+dgw8prw8gJgJCihRkSQi3CMv4PLysP9S0T2TuOalUrx+kAhcsq/5RYvL8
         d6llZFniZOh5AMrQj7et7WsYWRVEgP42rQFtfof8GntU2eygy9SwlCPPAGDVyjHrdOrE
         oAFzougZsr51RK9o9vL2Rerf195XAu9yPmGKEZiAePx0H2WovMqIbeMyXpjM+a7V1MFT
         tOnZhjD9FntHkevGT1/fMsIIjdF1to5qJlbAt473MAFGCep6vxNyeLCLonAMRHsveVet
         zk73Zh5NCfHTKrRQfG7aHW8ayxEcDxABGtK8XlMvnE/WUgt3qMs/oHPuyTSKc89WunFb
         E2dg==
X-Gm-Message-State: APjAAAW/+WJDm6Gsq91NdriRmmS1K8uN6QUeEfGdSaZHQSMlgrmx1Teg
        Vd222jB4yzddmlZ7WuBpfBHzAoTHnn1XkQcFzUs=
X-Google-Smtp-Source: APXvYqyJpPVCW1U8PJc/DxrjHUNCxCZVwba6gFlnBoQy7n9n7A08wWuzoscwA1haP9KiWLjDKXIyVC/EK9sRQ6IKB8g=
X-Received: by 2002:a17:906:4683:: with SMTP id a3mr1628711ejr.47.1566517500858;
 Thu, 22 Aug 2019 16:45:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
 <20190822201323.1292-3-vivien.didelot@gmail.com> <f179fa10-3123-d055-1c67-0d24adf3cb08@gmail.com>
 <20190822194304.GB30912@t480s.localdomain>
In-Reply-To: <20190822194304.GB30912@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 23 Aug 2019 02:44:49 +0300
Message-ID: <CA+h21hpgCJ9oKwQxzu62hmvyCOyDZ52R5fYnejprGHWeZR7L6Q@mail.gmail.com>
Subject: Re: [PATCH net-next 2/6] net: dsa: do not skip -EOPNOTSUPP in dsa_port_vid_add
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Aug 2019 at 02:43, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> Hi Vladimir,
>
> On Fri, 23 Aug 2019 01:06:58 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > Hi Vivien,
> >
> > On 8/22/19 11:13 PM, Vivien Didelot wrote:
> > > Currently dsa_port_vid_add returns 0 if the switch returns -EOPNOTSUPP.
> > >
> > > This function is used in the tag_8021q.c code to offload the PVID of
> > > ports, which would simply not work if .port_vlan_add is not supported
> > > by the underlying switch.
> > >
> > > Do not skip -EOPNOTSUPP in dsa_port_vid_add but only when necessary,
> > > that is to say in dsa_slave_vlan_rx_add_vid.
> > >
> >
> > Do you know why Florian suppressed -EOPNOTSUPP in 061f6a505ac3 ("net:
> > dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")?
> > I forced a return value of -EOPNOTSUPP here and when I create a VLAN
> > sub-interface nothing breaks, it just says:
> > RTNETLINK answers: Operation not supported
> > which IMO is expected.
>
> I do not know what you mean. This patch does not change the behavior of
> dsa_slave_vlan_rx_add_vid, which returns 0 if -EOPNOTSUPP is caught.
>

Yes, but what's wrong with just forwarding -EOPNOTSUPP?

>
> Thanks,
>
>         Vivien
