Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A59A4E6967
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 20:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349518AbiCXTk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 15:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239779AbiCXTky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 15:40:54 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4452621814
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 12:39:22 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id x9so3875908ilc.3
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 12:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2mNKjkkmgmcgd5QTfmN4bzTX9Ctlv7KD2+sWhCRlABc=;
        b=n8oGy81H939d1lgmgU59irDFJnGKN/2wuweX2oJvnVvqvRc4aOLXqBkNTqqrGmDcEU
         MbwAvgYZQ6O3YPAhhxyxYo8Q9Qbt33fTdjAVNlfOMNFGojd16CCmmHJfGTc/yObFcPen
         xOZhPSmvBG7WFNHnsg1qpI4C3SYzERg/QW0BWKzh2QBVDmOX6XnxIHJyDec/2iZ+P/BL
         Siw0ghQ7VwC0P2jzfbnNa3k+lnrlVObTTYJ+Hc1/Hr8PnDBZDj5EBjNQiaIqA5cx38sW
         baNgu3VNnzVub7H1ZbgW3iGxC9l79gJOQb50z7D7ELg/kZnTebPIL376hPzNT/6uJnC3
         3Lyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2mNKjkkmgmcgd5QTfmN4bzTX9Ctlv7KD2+sWhCRlABc=;
        b=GKMPBCfZp4DGztWLgSP2Chpoj+9SQSCHYyLcAcz6FKrRo6UHAphSAAHoYk37CVJjEn
         E7JvYO27Aw1bsPz47RSKdhwOpvUM/hQ58ssFxJD3SBTxG4aswyJeRAKFpG9mgtLLsd3u
         oqr2bgPdpSqDG/MPUXNq3JY+y5d+R1bSuz6J73QoWLhXRv5ga9E1b/PeiD7cwbozI2vY
         ucVXMIqY2or9KR2Ja1HqoIDvY60GW9pfXcn4eq46W36KgzHtf2n8N8sezQPTPIYRWduG
         WLtJ9KLGC9W+00kU5jYL0R7Qe3F3WDvY0tNOLi96mQqAlkL5Bo7LPEx2cIxIGPqkYQAP
         fdSQ==
X-Gm-Message-State: AOAM530xjVpsMNh76wCWiV94eI5niFTPuFJtlMWNmevprqxyuG9AzoXy
        c8zxAW2fuvl8ltCyzqfRfQb1cx4Ads9TMxK6b+Ddrw==
X-Google-Smtp-Source: ABdhPJx6B9fSyK4DveLsx1mUgPdanTtgqDu7C/69ZRoZXEWwqswumRIAfwnl3dcA8OjBoXkC4iHSHh8975uikm6WKmM=
X-Received: by 2002:a05:6e02:148a:b0:2c8:615e:5678 with SMTP id
 n10-20020a056e02148a00b002c8615e5678mr3494245ilk.78.1648150761675; Thu, 24
 Mar 2022 12:39:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
 <20220322210722.6405-2-gerhard@engleder-embedded.com> <20220324134337.GA27824@hoboy.vegasvil.org>
In-Reply-To: <20220324134337.GA27824@hoboy.vegasvil.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Thu, 24 Mar 2022 20:39:10 +0100
Message-ID: <CANr-f5wsX+eDH+YSc-AxehNnB90gPaTRvwC8NeTae_pUXPAC6Q@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/6] ptp: Add cycles support for virtual clocks
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

> > diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
> > index dba6be477067..ae66376def84 100644
> > --- a/drivers/ptp/ptp_private.h
> > +++ b/drivers/ptp/ptp_private.h
> > @@ -52,6 +52,7 @@ struct ptp_clock {
> >       int *vclock_index;
> >       struct mutex n_vclocks_mux; /* protect concurrent n_vclocks access */
> >       bool is_virtual_clock;
> > +     bool cycles;
>
> Can we please have something more descriptive?
>
> How about a predicate like is_xyz or has_xyz or xyz_available ?

I'll improve that.

Thanks, Gerhard
