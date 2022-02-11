Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D224B2B2D
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 18:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242820AbiBKRBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 12:01:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242489AbiBKRBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 12:01:51 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527AB3B3
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 09:01:50 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id q11-20020a17090a304b00b001b94d25eaecso4891502pjl.4
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 09:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EnaFGLu4Bbk5FKP+hZ/+pqNMY5zMt8HNpIdDHYzUguc=;
        b=J+lzw56dkbk5k9tZECvmLmCLbze+ZNMA3LwTNQZ2k/RK2QF7AvNOaGDsEMPNicLc5q
         FuXU64E6i/6ZYoDXd//Lc1oAzJPbnnB6nx+Q8STVALuNjgwtPWSZZNsVQjpHRHDd/iZJ
         dLwyYLUyMh6XVIYMfEV+BjwMIkZRkVTGl1lQhw11bNu69NCEcAMHR0t1FHwk6dosc7Wy
         hDlOexU2Wv+AgipcFVtO04PYfhN+K54sSiEwEEzGpIJszpYTfUpc6BY83ujUGGqsTpvX
         FfRAczgu/8W4hmfdzkRFqD/PYu/6r1sRBMMgxfB7rmA8Zmx50ABP9VLHHFn8Ird7ytT1
         RXsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EnaFGLu4Bbk5FKP+hZ/+pqNMY5zMt8HNpIdDHYzUguc=;
        b=vqV7GRKDTeLdSg/D0OhJnOqpnBcID3yoiMWBmHxedwCrjolHjvnKl/uRtuUfomxoxE
         p5YBnllEXpWQLYefEj6n0wntdr7UHMPaxR0CFYIJXprqlic5COUiT2Vf82++8IZ7LGRR
         AxKB4y7DmSMji3rkrMkh1yFKyz4+eyC/4qa+PfslQIRR+YPaeRenm9E1t2XnwWRbBt7K
         /f8M/yef+Et/PTjah7gGU0nkmHwjKkoja6UiAWWDPq4oEnfW2CvG4TDH0S9PYKZosHXd
         uao9MS+gIP6FedS8fzF/hFB1d9iaFGro9AJ+RH8/nmef7cayefhzs8EoS5JEJO5JIH+C
         lxjg==
X-Gm-Message-State: AOAM531+aSk3wfjJUDfu4k1VNTlele/EdQNwG16g5SHhmmg9xAEhF8OV
        IXSoFlkhvEWAwYqjUPwJVDbQwquRx7AaT058
X-Google-Smtp-Source: ABdhPJx1cHTA71QfiXncq7IkPLbnr/WxM4fA/QshI/qDbKNf4IIDs1+Qtbw2+LC5eZT5shry7gdMjw==
X-Received: by 2002:a17:902:d34b:: with SMTP id l11mr2542127plk.75.1644598909800;
        Fri, 11 Feb 2022 09:01:49 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id z13sm27561808pfe.20.2022.02.11.09.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 09:01:49 -0800 (PST)
Date:   Fri, 11 Feb 2022 09:01:47 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Felix Fietkau <nbd@nbd.name>, <netdev@vger.kernel.org>
Subject: Re: [RFC 1/2] net: bridge: add knob for filtering rx/tx BPDU
 packets on a port
Message-ID: <20220211090147.3db33a58@hermes.local>
In-Reply-To: <d4f1f9b1-6e8e-d21d-603f-7a0889e33a78@nvidia.com>
References: <20220210142401.4912-1-nbd@nbd.name>
        <d4f1f9b1-6e8e-d21d-603f-7a0889e33a78@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 16:55:40 +0200
Nikolay Aleksandrov <nikolay@nvidia.com> wrote:

> On 10/02/2022 16:24, Felix Fietkau wrote:
> > Some devices (e.g. wireless APs) can't have devices behind them be part of
> > a bridge topology with redundant links, due to address limitations.
> > Additionally, broadcast traffic on these devices is somewhat expensive, due to
> > the low data rate and wakeups of clients in powersave mode.
> > This knob can be used to ensure that BPDU packets are never sent or forwarded
> > to/from these devices
> > 
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > ---
> >  include/linux/if_bridge.h    | 1 +
> >  include/uapi/linux/if_link.h | 1 +
> >  net/bridge/br_forward.c      | 5 +++++
> >  net/bridge/br_input.c        | 2 ++
> >  net/bridge/br_netlink.c      | 6 +++++-
> >  net/bridge/br_stp_bpdu.c     | 9 +++++++--
> >  net/core/rtnetlink.c         | 4 +++-
> >  7 files changed, 24 insertions(+), 4 deletions(-)
> >   
> 
> Why can't netfilter or tc be used to filter these frames?
> 
> 

It could but this looks better.
BPDU filter matches what other hardware switch vendors offer and
has the benefit of not adding another layer of complexity into
user configurations.

Adding one rule into a complex firewall or starting to have to
configure tc is a mess.
