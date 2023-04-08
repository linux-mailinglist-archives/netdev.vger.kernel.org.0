Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB90E6DBA67
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 13:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjDHLZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 07:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjDHLZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 07:25:09 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA6883F3
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 04:25:08 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id g3so1463007pja.2
        for <netdev@vger.kernel.org>; Sat, 08 Apr 2023 04:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680953108;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=graPfjCNuma8g+giO+SHvv6KsibNsFUqOGxOSdTV67k=;
        b=e/1rO5bTkeykTNVfwOhyHPcc00RCpthRQI+rRBjmaDt89yZWoBRHK5G1gzbdNDqSFi
         eruB5uPSkoHkBD5+8GfmLQ3u3Cvjapbuhfh7TL9HwDhiMBNea5np4uB19eHbuBR41G0k
         KuaWFCvVuWXDPa0vK7Y3niYcdi3kM9bvyJEiZWOA0whp9c/HrzlqIwMHeOpZ7vOveD7c
         fFDnJC23tb8U0hlUwQchQXGRS35MuCM4KTtZTB7fJFeatj+ObZXBnLjhTV1cHiv/jwYH
         R50GA79cTSZioh0FK71WpC8JBmfea+MQS0N90n0vMpcCTlc7WrZjWNP4F2wBGBpfsEaF
         alww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680953108;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=graPfjCNuma8g+giO+SHvv6KsibNsFUqOGxOSdTV67k=;
        b=BW4GX/32pHf48DCmwsaeT6RETa+upJCAygDIVMIldgQ8YQvlfOkG8AH4jrrh6yf7Wh
         j9BvjPS78eT6wC5RzLZ7TBlILwgc2G4fJUOjTCW9g83wbnsyHOv6ttmjiPrl+lq9Dftl
         M4Up8HyaK6Vznghem9H4O9bMJWtBOTJNh/RAs6vnX2qU4L+spfiiu0of8tkpHn9frY9O
         fZ1FRsq/4Pw/Z2QF0Fs97UCidqZKwve7S/Gd0nGMLG8g9CNhZDkvWk2pJVbvP8AOXJ9b
         34jQkvWFj9mVB5dnkkYDTBNrvvxDycv2QfL2R1OCGhvWnIoX+t5lRFIgnOG3QNznZhBO
         01EA==
X-Gm-Message-State: AAQBX9fKpCJbN82V6rNdSjvSxXoDl0asGFREt7EFRHIc1jB2XhTf8tjU
        B1bLmeFQDHsh2RIMUMRyzgc=
X-Google-Smtp-Source: AKy350ZbE5FjOMjX4h3ARQeObduvozeyqhr8zLGGBxg1BmCGAXy3oZdXqXpsfvseinvPW2V91vM3Cg==
X-Received: by 2002:a17:902:cec8:b0:1a1:80ea:4364 with SMTP id d8-20020a170902cec800b001a180ea4364mr7139716plg.31.1680953107567;
        Sat, 08 Apr 2023 04:25:07 -0700 (PDT)
Received: from localhost ([87.118.116.103])
        by smtp.gmail.com with ESMTPSA id be3-20020a170902aa0300b00183c6784704sm2473787plb.291.2023.04.08.04.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 04:25:06 -0700 (PDT)
Date:   Sat, 8 Apr 2023 14:24:59 +0300
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: Re: [net 03/10] net/mlx5e: XDP, Allow growing tail for XDP multi
 buffer
Message-ID: <ZDFPCxBz0u6ClXnQ@mail.gmail.com>
References: <20230223225247.586552-1-saeed@kernel.org>
 <20230223225247.586552-4-saeed@kernel.org>
 <20230223163414.6d860ecd@kernel.org>
 <Y/j88HQtW/uMZDAh@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/j88HQtW/uMZDAh@x130>
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 at 10:07:44 -0800, Saeed Mahameed wrote:
> On 23 Feb 16:34, Jakub Kicinski wrote:
> > On Thu, 23 Feb 2023 14:52:40 -0800 Saeed Mahameed wrote:
> > > From: Maxim Mikityanskiy <maxtram95@gmail.com>
> > > 
> > > The cited commits missed passing frag_size to __xdp_rxq_info_reg, which
> > > is required by bpf_xdp_adjust_tail to support growing the tail pointer
> > > in fragmented packets. Pass the missing parameter when the current RQ
> > > mode allows XDP multi buffer.
> > 
> > Why is this a fix and not an (omitted) feature?
> 
> I am sure not intentional, but I agree not critical.

What's the destiny of my two patches (3 and 4)? I don't see them applied
to either net or net-next.
