Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A852A619C29
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiKDPwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbiKDPwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:52:32 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98F731F81;
        Fri,  4 Nov 2022 08:52:28 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id d26so14316651eje.10;
        Fri, 04 Nov 2022 08:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d1/C+CAG7HIMZPrEYMvPPfMFKX7MvL31YyxuzSnzS9E=;
        b=P5+tv2fWGGt4ZY3EySjNmRHnbhuJldfukMl2yghMgx8c2uFaDSMqTPhZt+WVDW2kCY
         pOyboLTX+U1LFQt2+ZtytyxG689T/mYAebBG/JNNzYEW3FwEY2MgpqX6HxRvi4Lobp8V
         1H7mKY9MJhXkAW0jZ16MGunpDzKtjZCyTc5svSeKPztUgfQyuZQI4lNqbnKNcDOE5WpM
         8lhGtW+rJpwzvMdlDe8v21W9jQ74GR6HNUzo/CMFzIRU1gvkf7E9z4w8lKBimUvuBxUz
         zSbBtVO70WYLNpSdOrTY+JH3hl7QF+xewEbBq6bfLD+MAhQoGtAXTjwM5OhBsLCJfWng
         jkog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d1/C+CAG7HIMZPrEYMvPPfMFKX7MvL31YyxuzSnzS9E=;
        b=254P0QE8sZZ36RNQU4nhku4oJ8Re41cPLyqTm1k+gjtGHzOfiqZqwAiz+6AsXPjPBR
         TM1xeKIpUKPAFIYuY0Co6yAYDg9jnXPCYK7gwxpCp9VYnmHL47fMjQ3KUniy7lsVCGV2
         ViVekBExD8G5lct+Zj7Cz0SyePTWdGq9fofgtFzUoGzPjSuxuUKmxxU2xjn58/SHJ1Wx
         ZxKeMSCreD/mVhO6dWMd/3btpz+jB/4wWr71xBdIMdZPGjbFVXooOmYerT+Yy0oNjI7O
         AAv366T7RBNor4uhmi801DQBW8luagHQUQVfl5XNP3qSBA1YgOe8l33yffyikrKVCvxF
         C0Wg==
X-Gm-Message-State: ACrzQf2bAzkpg/LWzs2O3PUmA71PYr5mX7e4OyTk1/XJrW1X3eZt9DU1
        hqLhLzlD1gQj2Iteww3m52s=
X-Google-Smtp-Source: AMsMyM7Lpztb/R6SD/gKzDWcs5dLDFAM/hoNyxawPMRYlojxQoSNGUomWlIJKvAejIHBmTo5BoafIQ==
X-Received: by 2002:a17:906:cc10:b0:7ad:d776:8b7a with SMTP id ml16-20020a170906cc1000b007add7768b7amr26003580ejb.508.1667577147301;
        Fri, 04 Nov 2022 08:52:27 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id f3-20020a056402004300b004611c230bd0sm2089169edu.37.2022.11.04.08.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 08:52:26 -0700 (PDT)
Date:   Fri, 4 Nov 2022 17:52:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Somisetty, Pranavi" <pranavi.somisetty@amd.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/2] Add support for Frame preemption (IEEE
Message-ID: <20221104155224.jqj5axtp5jt77yqt@skbuf>
References: <20221103113348.17378-1-pranavi.somisetty@amd.com>
 <20221103225124.h6nrj2qnypltgqbr@skbuf>
 <BN8PR12MB28528DB6C999C7608958B284F73B9@BN8PR12MB2852.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB28528DB6C999C7608958B284F73B9@BN8PR12MB2852.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 02:08:25PM +0000, Somisetty, Pranavi wrote:
> > Have you seen:
> > https://patchwork.kernel.org/project/netdevbpf/cover/20220816222920.195
> > 2936-1-vladimir.oltean@nxp.com/
> 
> Thanks Vladimir, I hadn't, we will try to use your RFC.

The point is not to *use* it (you can't even without some major effort -
I didn't even publish the user space patches, even though I have ethtool
ready and openlldp almost completely ready as well; plus I also did some
more rework to the posted RFC, which I didn't repost yet).

The point is that the RFC has stalled due to seemingly no clear answers
to some fundamental questions about the placement of these new features.
It would be good if some extra feedback from people familiar with frame
preemption/MAC merge could be provided there.

Thanks.
