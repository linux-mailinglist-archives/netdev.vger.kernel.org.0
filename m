Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D113A4E6988
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 20:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352132AbiCXTyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 15:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348773AbiCXTyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 15:54:02 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295C6A94DF
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 12:52:30 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id n16so3865152ile.11
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 12:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ki6SYkzySNnpPxADc5ADribS0+UvZkFRJPk3gpe2mrQ=;
        b=TEKQZluY1vw0GnP1zaDMQzggljTi/PRqARL3KffMtbZfu0pLLCzhdhK0ZquJNznGZc
         Tiaxi9Tb4rMczeSWA6R+pfL5lfl3pY1bEuvprqbZWdTwlMdOceDvQ3twR5AGRKOT9QBi
         Mcea9U0nLs+5lvHpWdj+SojYAZjQf+8GHtqaqq5F+RiDR3px1rSowvBmOXIh7vD3lBkX
         zKNKYMds3zYj29MzICl9nz9b3aSG0V7+JhUt0NXYstOCobI4af/glk/epFb+Wf3GKtSo
         rAyXSUiRtLQF9Ur5LvILdIY1MjuQrUHerBLfILQcpTSn3JXcSTOvMxBigctFgFf/cfg9
         Owvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ki6SYkzySNnpPxADc5ADribS0+UvZkFRJPk3gpe2mrQ=;
        b=Ez0Oz7NwtHzOOXLmwgkWy3so94Q9eAqmx+pwb2F5pCquMHFPfym+CeXRSjw9Fmf+/D
         zz8ud0LWXhZdvU/QEgumBS4Mv6RrK9PM51uX6vNnX9GeO7pZt4Sj0nSg/FRfTIjEEBkh
         CrLAQ91UR0H+6QJ5leMczJeVKcgujDR52dyIVnfULZtkndy8z7eQnHysbgXYeS4p09/P
         c2z315oBbrPo7hgqjfF9taWR8ec0m742fYrnBLL0lwACy291HaooFa6Iq5B74rPXduS5
         mAg21UYBfTXxeLZ6mU2B/gjpjOlvD74WQAuvCcdN5Vy/WbBKjDsoNt5B3qhSkFXgafg4
         2pqA==
X-Gm-Message-State: AOAM530gZLG3jvtVnVdO10zCAheyGa4YQ/eSN1aN739erpV9EfG+rhzg
        qbvP5BzTP9IYTxgfbBH82n2Kq2b5lywlEH4/X/b2mQ==
X-Google-Smtp-Source: ABdhPJyNVryyfuu12wh/NoqgU2GrcNm7lV3NtoukM0hgd2bmGv5jjCFKCO/OXzGNJ3g1VIaox1VZDtITJZsYdKe9bYE=
X-Received: by 2002:a92:1e09:0:b0:2c6:304e:61fa with SMTP id
 e9-20020a921e09000000b002c6304e61famr3763025ile.211.1648151549197; Thu, 24
 Mar 2022 12:52:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
 <20220322210722.6405-6-gerhard@engleder-embedded.com> <20220324140117.GE27824@hoboy.vegasvil.org>
In-Reply-To: <20220324140117.GE27824@hoboy.vegasvil.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Thu, 24 Mar 2022 20:52:18 +0100
Message-ID: <CANr-f5zW9J+1Z+Oe270xRpye4qtD2r97QAdoCrykOrk1SOuVag@mail.gmail.com>
Subject: Re: [PATCH net-next v1 5/6] ptp: Support late timestamp determination
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> > index 54b9f54ac0b2..b7a8cf27c349 100644
> > --- a/drivers/ptp/ptp_clock.c
> > +++ b/drivers/ptp/ptp_clock.c
> > @@ -450,6 +450,33 @@ void ptp_cancel_worker_sync(struct ptp_clock *ptp)
> >  }
> >  EXPORT_SYMBOL(ptp_cancel_worker_sync);
> >
> > +ktime_t ptp_get_timestamp(int index,
> > +                       const struct skb_shared_hwtstamps *hwtstamps,
> > +                       bool cycles)
> > +{
> > +     char name[PTP_CLOCK_NAME_LEN] = "";
> > +     struct ptp_clock *ptp;
> > +     struct device *dev;
> > +     ktime_t ts;
> > +
> > +     snprintf(name, PTP_CLOCK_NAME_LEN, "ptp%d", index);
> > +     dev = class_find_device_by_name(ptp_class, name);
>
> This seems expensive for every single Rx frame in a busy PTP network.
> Can't this be cached in the socket?

I thought that PTP packages are rare and that bloating the socket is
not welcome.
I'll try to implement some caching.

> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -564,7 +564,10 @@ static inline bool skb_frag_must_loop(struct page *p)
> >   * &skb_shared_info. Use skb_hwtstamps() to get a pointer.
> >   */
> >  struct skb_shared_hwtstamps {
> > -     ktime_t hwtstamp;
> > +     union {
> > +             ktime_t hwtstamp;
> > +             void *phc_data;
>
> needs kdoc update

Sorry, I totally forgot that. I'll fix it.

> > @@ -886,18 +885,32 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
> >       if (shhwtstamps &&
> >           (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
> >           !skb_is_swtx_tstamp(skb, false_tstamp)) {
> > -             if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
> > -                     hwtstamp = ptp_convert_timestamp(&shhwtstamps->hwtstamp,
> > -                                                      sk->sk_bind_phc);
> > +             rcu_read_lock();
> > +             orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> > +             if (orig_dev) {
> > +                     if_index = orig_dev->ifindex;
> > +                     if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_PHC)
> > +                             phc_index = ethtool_get_phc(orig_dev);
>
> again, this is something that can be cached, no?

I'll try to implement some caching.

Thanks for your review!

Gerhard
