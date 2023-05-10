Return-Path: <netdev+bounces-1347-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF5A46FD892
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:50:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B70351C20C5E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 07:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99A376AA4;
	Wed, 10 May 2023 07:50:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C38280C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:50:44 +0000 (UTC)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0942CD
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 00:50:40 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-643990c5319so4870859b3a.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 00:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683705040; x=1686297040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g8QHypOkR2rR0fg1SwZYSlW6v3H9FDxdE7DBNoENqLM=;
        b=VPxC1OTsU5pzrXOTTWgW+t6qLxghZsK3Z2dBtwWTVkMnghbNr4FEatym2Nm6o2PuHp
         xdB91hzk7DvX1XckX4gI9koc9baLWm17B5mUPRAoLLgKmkWjJDSaLBBZXRO0+yzrqeer
         R5MRIwxZiGyYhVdh0GjlXvp1967P0PqZWZ1TDGzY4MxGIs3PoN4CLvgWehabws/p/NYf
         hcf32k2cPmY1KsuagreuqyVqzDNnfuttK1Ud+Zqx1eGeVOzOXRRDzhgRETKjlXy1WK+v
         ViZepiL+3RAQp51az/6uHPirFARQY7039JqYV+A3i7voR/qIOHqjXOWYf05TGzYV6eay
         1sNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683705040; x=1686297040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8QHypOkR2rR0fg1SwZYSlW6v3H9FDxdE7DBNoENqLM=;
        b=i6gvIcye4F86Z3y9ivt4VNtfsb0iEUNpw6AML8ukHHh1eZ5BB6BVWPejE0pls8x7of
         JykkddKQpmNY3j8f+yb9K4T+SM0G2z3ghGciDhvYYXZdaUwokmz+wKg8vsE0Sg724Rll
         CoaAi2y7OYiqf6zqtOqEiACwl/kqEGP2LZ1x/iFfwEr+V8lUEnXHSdhSDRV/i4Tr3Pj6
         IUePzPk5eVeg/CUu+3QRtNUzBlyHZ3PwrzjIeEAiglvn1onZn+aHlB8RkoikLO4u3q5I
         7pt7i6XZwMbVtV+cg5kYW0GQdL7DJrX/GdHm0hoe68rWLt7YsViibkJlnfa6abwCAPmn
         09Jw==
X-Gm-Message-State: AC+VfDxNgCAWx1kWwyLeIwfBcb5dF1m2iw7lHQ2phSsrSlnjH5AjcSaK
	nLeIAg8LadW2NptmK251/n4RuN5/S4KYHbKR
X-Google-Smtp-Source: ACHHUZ7uzVP+/Y7Ljx58JJzGnbZwugHNMIAMsAuSqHqVMQouXx86iCu0ni2hXrnIoWh5s3LuSnXXtA==
X-Received: by 2002:a05:6a20:4658:b0:f2:ba78:3d50 with SMTP id eb24-20020a056a20465800b000f2ba783d50mr16043121pzb.12.1683705040230;
        Wed, 10 May 2023 00:50:40 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n22-20020aa79056000000b0063d24fcc2b7sm3006622pfo.1.2023.05.10.00.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 00:50:39 -0700 (PDT)
Date: Wed, 10 May 2023 15:50:34 +0800
From: Hangbin Liu <liuhangbin@gmail.com>
To: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: netdev@vger.kernel.org, Andrew Schorr <ajschorr@alumni.princeton.edu>
Subject: Re: [Issue] Bonding can't show correct speed if lower interface is
 bond 802.3ad
Message-ID: <ZFtMyi9wssslDuD0@Laptop-X1>
References: <ZEt3hvyREPVdbesO@Laptop-X1>
 <15524.1682698000@famine>
 <ZFjAPRQNYRgYWsD+@Laptop-X1>
 <84548.1683570736@vermin>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84548.1683570736@vermin>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 11:32:16AM -0700, Jay Vosburgh wrote:
> >Hi Jay,
> >
> >I just back from holiday and re-read you reply. The user doesn't add 2 LACP
> >bonds inside an active-backup bond. He add 1 LACP bond and 1 normal NIC in to
> >an active-backup bond. This seems reasonable. e.g. The LACP bond in a switch
> >and the normal NIC in another switch.
> >
> >What do you think?
> 
> 	That case should work fine without the active-backup.  LACP has
> a concept of an "individual" port, which (in this context) would be the
> "normal NIC," presuming that that means its link peer isn't running
> LACP.
> 
> 	If all of the ports (N that are LACP to a single switch, plus 1
> that's the non-LACP "normal NIC") were attached to a single bond, it
> would create one aggregator with the LACP enabled ports, and then a
> separate aggregator for the indvidual port that's not.  The aggregator
> selection logic prefers the LACP enabled aggregator over the individual
> port aggregator.  The precise criteria is in the commentary within
> ad_agg_selection_test().
> 

cc Andrew, He add active-backup bond over LACP bond because he want to
use arp_ip_target to ensure that the target network is reachable...

Hangbin

