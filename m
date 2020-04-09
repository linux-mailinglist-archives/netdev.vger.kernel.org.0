Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA38F1A2E79
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 06:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgDIEpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 00:45:14 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37662 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgDIEpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 00:45:13 -0400
Received: by mail-wr1-f66.google.com with SMTP id w10so10330934wrm.4;
        Wed, 08 Apr 2020 21:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=P+FlJCkwPf/azKtYWPJtzmTKRGoPr//gBroGNE4MTSM=;
        b=b3feWRBNgz6em1w5K5MzcOP5LvA7xD1SMkQCigA1NTs07NZpRmeqF8qtATfp1RMd6O
         P8vDdTf0+ndl9fBsqS8K42DLHC1DrPP0BZJfZqOG5EJi3NOLcVJS2MrzDFXYLUvE9h5h
         JnonpZ+dEl5PFn6Z20oNrTFYKNzuX45VYNnHO1lWfDup5bcV5nw3B1G4pQxGvzVgTKCl
         FJcJeQi2/9BZ4UKUbU9ewjY84udgNd6ajdCVafUhKWwZuYBZg4Vb/U1Hpc3JAICc0gQt
         QRlNSdP8L7WSndqtEEfpOZkzaDzjWJ2H3jikBHDPqYiJ9lh9R0pNBtaEISQ4yZ83VVvO
         rXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=P+FlJCkwPf/azKtYWPJtzmTKRGoPr//gBroGNE4MTSM=;
        b=BYVEIl7eZCvEMvyBLnFJ7GxRQqddnGAN9q7d3CKqh12eIVaIBiT1UWakHhR9ClFMyL
         hcY7KqJsRnd0ttGVUbRJSTXxDJvZlomnn2CbzjR8t3PuQjTWl2Ivfb6+h0dhk26LGXNB
         fyeVRpZ6glvWCLZmVIbWHlaebgkW0lsOTMjSSm2Nvm5VmJf9KVLvxkHMIt1N/5w/eaoO
         jJ+5L/jRu3aH5e+wObrTWqzYdwiuv0sTTecCnhC2bI1LFEksmHu/oPgdKhMTHM+7LFWv
         UKCUWdALJHU/A4ffXD6NU1MjYKRhC6YOmZHqvmwckmcmfvLKE7UKn8YrN/HZ/j1D2ubK
         X+RA==
X-Gm-Message-State: AGi0PubnCfdZNrIvMYoq4138lPfrCRMePZGjHJGXO11oWG6kLOTSaYEA
        Z/0/CNvyqRF7ehykuch6a66aq3rx68Iovtoa73Y=
X-Google-Smtp-Source: APiQypI7Wh7sJIXLBbMYJGRN93eG+br3YZJ28emQ59Ep9oDYdY4AafvPvjxJppGnJew6vIO2q12Ka4+UJ/3edvjn5U8=
X-Received: by 2002:adf:ef8d:: with SMTP id d13mr10166318wro.197.1586407510642;
 Wed, 08 Apr 2020 21:45:10 -0700 (PDT)
MIME-Version: 1.0
References: <1586254255-28713-1-git-send-email-sumit.garg@linaro.org>
 <CABPxzY+hL=jD6Zy=netP3oqNXg69gDL2g0KiPe40eaXXgZBnxw@mail.gmail.com> <CAFA6WYMZAq6X5m++h33ySCa6jOQCq_tHL=8mUi-kPMcn4FH=jA@mail.gmail.com>
In-Reply-To: <CAFA6WYMZAq6X5m++h33ySCa6jOQCq_tHL=8mUi-kPMcn4FH=jA@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 9 Apr 2020 06:44:59 +0200
Message-ID: <CA+icZUVACJ8e0R04Ao7JejonytjG57oVFyGC3=kJpEP+_e8S-g@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: fix race in ieee80211_register_hw()
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Krishna Chaitanya <chaitanya.mgit@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Matthias=2DPeter_Sch=C3=B6pfer?= 
        <matthias.schoepfer@ithinx.io>,
        "Berg Philipp (HAU-EDS)" <Philipp.Berg@liebherr.com>,
        "Weitner Michael (HAU-EDS)" <Michael.Weitner@liebherr.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 9, 2020 at 6:43 AM Sumit Garg <sumit.garg@linaro.org> wrote:
>
> Hi Johannes,
>
> On Wed, 8 Apr 2020 at 00:55, Krishna Chaitanya <chaitanya.mgit@gmail.com> wrote:
> >
> > On Tue, Apr 7, 2020 at 3:41 PM Sumit Garg <sumit.garg@linaro.org> wrote:
> > >
> > > A race condition leading to a kernel crash is observed during invocation
> > > of ieee80211_register_hw() on a dragonboard410c device having wcn36xx
> > > driver built as a loadable module along with a wifi manager in user-space
> > > waiting for a wifi device (wlanX) to be active.
> > >
> > > Sequence diagram for a particular kernel crash scenario:
> > >
> > >     user-space  ieee80211_register_hw()  ieee80211_tasklet_handler()
> > >     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >        |                    |                 |
> > >        |<---phy0----wiphy_register()          |
> > >        |-----iwd if_add---->|                 |
> > just a nitpick, a better one would be (iwd: if_add + ap_start) since
> > we need to have 'iwctl ap start'
> > to trigger the interrupts.
> > >        |                    |<---IRQ----(RX packet)
> > >        |              Kernel crash            |
> > >        |              due to unallocated      |
> > >        |              workqueue.              |
> > >        |                    |                 |
> > >        |       alloc_ordered_workqueue()      |
> > >        |                    |                 |
> > >        |              Misc wiphy init.        |
> > >        |                    |                 |
> > >        |            ieee80211_if_add()        |
> > >        |                    |                 |
> > >
> > > As evident from above sequence diagram, this race condition isn't specific
> > > to a particular wifi driver but rather the initialization sequence in
> > > ieee80211_register_hw() needs to be fixed. So re-order the initialization
> > > sequence and the updated sequence diagram would look like:
> > >
> > >     user-space  ieee80211_register_hw()  ieee80211_tasklet_handler()
> > >     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >        |                    |                 |
> > >        |       alloc_ordered_workqueue()      |
> > >        |                    |                 |
> > >        |              Misc wiphy init.        |
> > >        |                    |                 |
> > >        |<---phy0----wiphy_register()          |
> > >        |-----iwd if_add---->|                 |
> > same as above.
> > >        |                    |<---IRQ----(RX packet)
> > >        |                    |                 |
> > >        |            ieee80211_if_add()        |
> > >        |                    |                 |
> > >
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > > ---
> > >
>
> In case we don't have any further comments, could you fix this nitpick
> from Chaitanya while applying or would you like me to respin and send
> v3?
>

Hi Sumit,

when you send out a v3, feel free to add...

   Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

Thanks.

Regards,
- Sedat -

> -Sumit
>
> > > Changes in v2:
> > > - Move rtnl_unlock() just after ieee80211_init_rate_ctrl_alg().
> > > - Update sequence diagrams in commit message for more clarification.
> > >
> > >  net/mac80211/main.c | 22 +++++++++++++---------
> > >  1 file changed, 13 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> > > index 4c2b5ba..d497129 100644
> > > --- a/net/mac80211/main.c
> > > +++ b/net/mac80211/main.c
> > > @@ -1051,7 +1051,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> > >                 local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
> > >                 if (hw->max_signal <= 0) {
> > >                         result = -EINVAL;
> > > -                       goto fail_wiphy_register;
> > > +                       goto fail_workqueue;
> > >                 }
> > >         }
> > >
> > > @@ -1113,7 +1113,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> > >
> > >         result = ieee80211_init_cipher_suites(local);
> > >         if (result < 0)
> > > -               goto fail_wiphy_register;
> > > +               goto fail_workqueue;
> > >
> > >         if (!local->ops->remain_on_channel)
> > >                 local->hw.wiphy->max_remain_on_channel_duration = 5000;
> > > @@ -1139,10 +1139,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> > >
> > >         local->hw.wiphy->max_num_csa_counters = IEEE80211_MAX_CSA_COUNTERS_NUM;
> > >
> > > -       result = wiphy_register(local->hw.wiphy);
> > > -       if (result < 0)
> > > -               goto fail_wiphy_register;
> > > -
> > >         /*
> > >          * We use the number of queues for feature tests (QoS, HT) internally
> > >          * so restrict them appropriately.
> > > @@ -1207,6 +1203,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> > >                 goto fail_rate;
> > >         }
> > >
> > > +       rtnl_unlock();
> > > +
> > >         if (local->rate_ctrl) {
> > >                 clear_bit(IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW, hw->flags);
> > >                 if (local->rate_ctrl->ops->capa & RATE_CTRL_CAPA_VHT_EXT_NSS_BW)
> > > @@ -1254,6 +1252,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> > >                 local->sband_allocated |= BIT(band);
> > >         }
> > >
> > > +       result = wiphy_register(local->hw.wiphy);
> > > +       if (result < 0)
> > > +               goto fail_wiphy_register;
> > > +
> > > +       rtnl_lock();
> > > +
> > >         /* add one default STA interface if supported */
> > >         if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION) &&
> > >             !ieee80211_hw_check(hw, NO_AUTO_VIF)) {
> > > @@ -1293,6 +1297,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> > >  #if defined(CONFIG_INET) || defined(CONFIG_IPV6)
> > >   fail_ifa:
> > >  #endif
> > > +       wiphy_unregister(local->hw.wiphy);
> > > + fail_wiphy_register:
> > >         rtnl_lock();
> > >         rate_control_deinitialize(local);
> > >         ieee80211_remove_interfaces(local);
> > > @@ -1302,8 +1308,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> > >         ieee80211_led_exit(local);
> > >         destroy_workqueue(local->workqueue);
> > >   fail_workqueue:
> > > -       wiphy_unregister(local->hw.wiphy);
> > > - fail_wiphy_register:
> > >         if (local->wiphy_ciphers_allocated)
> > >                 kfree(local->hw.wiphy->cipher_suites);
> > >         kfree(local->int_scan_req);
> > > @@ -1353,8 +1357,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
> > >         skb_queue_purge(&local->skb_queue_unreliable);
> > >         skb_queue_purge(&local->skb_queue_tdls_chsw);
> > >
> > > -       destroy_workqueue(local->workqueue);
> > >         wiphy_unregister(local->hw.wiphy);
> > > +       destroy_workqueue(local->workqueue);
> > >         ieee80211_led_exit(local);
> > >         kfree(local->int_scan_req);
> > >  }
> > > --
> > > 2.7.4
> > >
> >
> >
> > --
> > Thanks,
> > Regards,
> > Chaitanya T K.
