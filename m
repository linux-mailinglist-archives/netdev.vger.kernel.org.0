Return-Path: <netdev+bounces-1029-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA8846FBD95
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 05:16:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 923981C20A96
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23E42137A;
	Tue,  9 May 2023 03:16:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D91392
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:16:55 +0000 (UTC)
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235C419B3
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 20:16:52 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-24e5d5782edso5106198a91.0
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 20:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683602211; x=1686194211;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7O5bVqTPmrWGonehudouzNCYJCGZ3XVJlk3/Q0pyzsg=;
        b=Uk8lu45hWzVwePsBbOwQ09pBASB2ubvMpfbBRA5QZnjFl14wJfuFaflcy672+UJIj3
         6Y6G1SneNLKT48kgQ+Ou9oFfr13sz1Fxo5cqzUHLKDt+vKRPuLKLhPMN65ljFcXut6I5
         zppBCswry3bYAvBStlYIMVcLvUCgHbX0AnfbnTQ4C4/wOygknCoHYLfwprhxEYI+NPjy
         OMgO3/RtIaAdvEzX64Lp9LAzyeBANa7kAoRx2pgObqnfwcg0QmXnPhsZ43x2mRw9yKXy
         P7bHPZab/VycaKwBs/tbjaepyxquOFvXpo73qh7mUZJKVWRU17ObDNY2QehxsjyVB+Vf
         haFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683602211; x=1686194211;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7O5bVqTPmrWGonehudouzNCYJCGZ3XVJlk3/Q0pyzsg=;
        b=X3Ni0f76osT8XGpMcciLh6iiPi8RuMvKexRahdOsy1vZELvn+ho2AbMBvEcDNZxkRc
         fZtiBwqosgZ2X4MzVHZ3JKOzSwxeAB8M8RKm3Eu6Jej+Mltov1/oOUNaOyTqj6TGmL2h
         O+jzq4YtHobXkY3RT7MDIQXetMCPaLpbSkfXeJXxvMa0bkxIe9Yq/sJne6+zeqykMp/m
         hB+Vf9GyRgmqiJW5VmemqUCgWry5icWY23kPpCiMZ4Rd69C8q7RXDbkSNyU0CsZzdpQS
         +VYuNTFmbj5fKC8yfj+XsD0D4y9B6GHeXcBZtD/r+GG2XvmPENk+Ud3JZyFpITgsMVCM
         mCQw==
X-Gm-Message-State: AC+VfDwglzxBuP5A5dalNjgkvPY/sKFKoseT+kb64nzPvqXy6JMFSMlE
	jLE1sOSXlCxqwImwCU4yMjmsYD2r1GNHgyFq
X-Google-Smtp-Source: ACHHUZ7fvPKUZ1QDmhnP91IT5WZV/Ez9LjeghaM6rOw7Zz5lUQ+gAYLKk6DEClO5JsR7SLSTZGlqFQ==
X-Received: by 2002:a17:90b:817:b0:24b:fd8d:536b with SMTP id bk23-20020a17090b081700b0024bfd8d536bmr12876262pjb.29.1683602211564;
        Mon, 08 May 2023 20:16:51 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d18-20020a17090abf9200b002405d3bbe42sm10795413pjs.0.2023.05.08.20.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 20:16:50 -0700 (PDT)
Date: Tue, 9 May 2023 11:16:47 +0800
From: Hangbin Liu <liuhangbin@gmail.com>
To: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: netdev@vger.kernel.org
Subject: Re: [Issue] Bonding can't show correct speed if lower interface is
 bond 802.3ad
Message-ID: <ZFm7Hwz6cqEkVB1g@Laptop-X1>
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

Thanks for your explanation. I didn't know this before. Now I have learned.

Regards
Hangbin

