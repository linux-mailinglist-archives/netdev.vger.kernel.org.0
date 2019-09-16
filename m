Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4849B3793
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 11:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfIPJyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 05:54:05 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39301 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfIPJyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 05:54:05 -0400
Received: by mail-ed1-f67.google.com with SMTP id g12so6815948eds.6
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 02:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ehb7mlVPZOVuSiyeAn4SloRvILxa7FnK3e9ARXERlwk=;
        b=WkOF+vipIw//1u2USiWk8sJqpKc/CyueAcNGhWrRQeHr0CSUU+aX0p+cFK03Vh9xhq
         thrC4hYUu9cn5BfCzjYsjWUnYpfozZ8iHwojRtligcEul7AhErRzcQOT0BeZE5Qwya6c
         9xby5O4rUja7UtPG5Xc3bYI1XdaIh3lq0JBW03WM1OBAL55VCc2dm4nmJNArqsBQz6H5
         jWs0GLIpN8fFkmOcYHrh7waqIwvqI+pj6KFgRfuUvwrAvmRZYAFZPVWn2ICqWWpowGpy
         3sS4ldsFIsj9Pb5P6QhYCi+xrf86sKzRPsnXr3vI5H55YNkO9DpZcQAEAZJFZtidRMBA
         jOiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ehb7mlVPZOVuSiyeAn4SloRvILxa7FnK3e9ARXERlwk=;
        b=lSAovuCUgAXCgyYGryjIpt0AAhLL9L5hHMMtA2dY+YeCJdzaSz9N7ErSjdUV/mTwok
         uEEDHCsNT+IyCjRrPBWbnIssyvatndEFq9bUeWIUyw0R+atzBzhmc4p0byJr4XNLUGoo
         I3Akgyb6xQPMvKCtS+5k/fzEXIGo1SsJTlK1QqN5ysfeHxBzGOOwawrqNRRaEVJWRzjN
         8+qX+A7Y3xIgO78D45N4cavD4C/q/Cr1d4ZhqSI9ZdIxrpLRwjEKafJynhExTyCR2Sae
         W0SoHwAbHPk738qJSKTSGv5GLKhg9uMDUWMToyYUOV1YH635EWdtW3ZfLNo/ISASdvx1
         e60A==
X-Gm-Message-State: APjAAAX2DDAkF1cSXU9+0jihOZDxX+tdgb1duT/RSlpCWotliuUfThgN
        B9iRGP6nHhhqPbsQsh8UbJsyQZwnUVWmHQZJAdY=
X-Google-Smtp-Source: APXvYqz8f4tErvvEGiOKdM+htiGHQh8cjPvBz0FARqdE7Zr2Uk3QuIf+tmHQvZ0DvGsQZynN2OZww98ncNbEClnZSE4=
X-Received: by 2002:a05:6402:14da:: with SMTP id f26mr11523468edx.165.1568627643544;
 Mon, 16 Sep 2019 02:54:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190914011802.1602-1-olteanv@gmail.com> <20190914011802.1602-3-olteanv@gmail.com>
 <20190916093108.GA28448@apalos.home>
In-Reply-To: <20190916093108.GA28448@apalos.home>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 16 Sep 2019 12:53:52 +0300
Message-ID: <CA+h21hq1Mhsrub-8VEq9N1vcXEoWhfHQ1c09u+Pk=gKf=89PxQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/7] net: dsa: Pass ndo_setup_tc slave
 callback to drivers
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "Patel, Vedang" <vedang.patel@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>, jiri@mellanox.com,
        m-karicheri2@ti.com, Jose Abreu <Jose.Abreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilias,

On Mon, 16 Sep 2019 at 12:31, Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> Hi Vladimir,
>
> Yes fixes my request on the initial RFC. Sorry for the delayed response.
>
> On Sat, Sep 14, 2019 at 04:17:57AM +0300, Vladimir Oltean wrote:
> > DSA currently handles shared block filters (for the classifier-action
> > qdisc) in the core due to what I believe are simply pragmatic reasons -
> > hiding the complexity from drivers and offerring a simple API for port
> > mirroring.
> >
> > Extend the dsa_slave_setup_tc function by passing all other qdisc
> > offloads to the driver layer, where the driver may choose what it
> > implements and how. DSA is simply a pass-through in this case.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
> > ---
> > Changes since v1:
> > - Added Kurt Kanzenbach's Acked-by.
> >
> > Changes since RFC:
> > - Removed the unused declaration of struct tc_taprio_qopt_offload.
> >
> >  include/net/dsa.h |  2 ++
> >  net/dsa/slave.c   | 12 ++++++++----
> >  2 files changed, 10 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index 96acb14ec1a8..541fb514e31d 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -515,6 +515,8 @@ struct dsa_switch_ops {
> >                                  bool ingress);
> >       void    (*port_mirror_del)(struct dsa_switch *ds, int port,
> >                                  struct dsa_mall_mirror_tc_entry *mirror);
> > +     int     (*port_setup_tc)(struct dsa_switch *ds, int port,
> > +                              enum tc_setup_type type, void *type_data);
> >
> >       /*
> >        * Cross-chip operations
> > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > index 9a88035517a6..75d58229a4bd 100644
> > --- a/net/dsa/slave.c
> > +++ b/net/dsa/slave.c
> > @@ -1035,12 +1035,16 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
> >  static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
> >                             void *type_data)
> >  {
> > -     switch (type) {
> > -     case TC_SETUP_BLOCK:
> > +     struct dsa_port *dp = dsa_slave_to_port(dev);
> > +     struct dsa_switch *ds = dp->ds;
> > +
> > +     if (type == TC_SETUP_BLOCK)
> >               return dsa_slave_setup_tc_block(dev, type_data);
> > -     default:
> > +
> > +     if (!ds->ops->port_setup_tc)
> >               return -EOPNOTSUPP;
> > -     }
> > +
> > +     return ds->ops->port_setup_tc(ds, dp->index, type, type_data);
> >  }
> >
> >  static void dsa_slave_get_stats64(struct net_device *dev,
> > --
> > 2.17.1
> >
>
> Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Thanks. Could you add this Acked-by to the v4 email, just so we keep
the discussion on the latest submitted version?

-Vladimir
