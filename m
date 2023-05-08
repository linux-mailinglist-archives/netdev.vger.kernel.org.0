Return-Path: <netdev+bounces-826-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B3766FA333
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 11:26:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0263D280E8E
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 09:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 167781549F;
	Mon,  8 May 2023 09:26:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D98210C
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 09:26:26 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC7E18DE6
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 02:26:25 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-643a6f993a7so1968792b3a.1
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 02:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683537985; x=1686129985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sUwxNjsJiPgi4peNA0+ZS6LsJUUvXvufdw5CPGol7Jk=;
        b=TMSmMzyJzJoHo/yuE8Y+9M0GLekIX4K0SS1CDD2hGxLYhzncl+C6XmFRHlF3DrrY8+
         kxKh5FKwrYu9O9WWUCJJytyvIBaEK7YDGwuvLf9jzkgzgV791Cpm8HspElUQACuesqtB
         g4Kl7L2UDOsWLK2gjlYO6pKY/eMf6OnSBJvkLYFBq7nYTQQZUHZoZnLUaXi5G9qpIxX8
         Uxd17MwGfa9qzNrrA3ZTesvw4Gi9/YEw8FbgsQGZScCZoJDiT2Nj6+WEElvohEzebcww
         c4+EvrGNaQB6Ro2iA/UeFDJ5OIOnlGxT1lz0fJCh9qtGJVQLqApNB/a1PcpH2PiHp5kC
         6ikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683537985; x=1686129985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sUwxNjsJiPgi4peNA0+ZS6LsJUUvXvufdw5CPGol7Jk=;
        b=Yqmg6d1aIZZbo0ojYT5knaRbl2oWPcZV5TECELgPf8Y6CSYEW0hjTaEiNBOH+dEdus
         As2h91XkB5ImkeS8V8LfgOwKc+FE8B6iTcWy6oksExIwWzggu3jXNO8dTzl+dVji1bjt
         WC+zvtdZhSUmz9vb5aCkiMtaSy+6Y0mqcAxW6f8zMsSg4YC4HB3bbfNrOVoEVgYnX0/d
         p1IDoU67jWRN5eHEgWH4Ffqe9CPcAktwNHXltqbaotZ0JltSyk+/gEI5CvLfmI/2jotQ
         qqEuSpugnP2yZjzTrZIG1Hic4sPUDCFGAGvqkfgGiXzKvgl31nmsaXMV0QjzVvJVr/gh
         04VA==
X-Gm-Message-State: AC+VfDxH6p0PL37reE148wuwMxAIJWlYmfSra7gcmgW1Op0Txcic53g/
	QZy8MRrA00MkthrzfNbVNI83zXh4/ngwiiiR
X-Google-Smtp-Source: ACHHUZ7IjcW6v6H7bmnDbhQoxdRQFUQUXVS0ErxQ/mNjOD66TxFC5vDy4xhYlQhiWXII3mSHjgccBg==
X-Received: by 2002:a05:6a00:1492:b0:63b:6149:7ad6 with SMTP id v18-20020a056a00149200b0063b61497ad6mr13070327pfu.34.1683537984967;
        Mon, 08 May 2023 02:26:24 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v33-20020a631521000000b0051b70c8d446sm5829301pgl.73.2023.05.08.02.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 02:26:24 -0700 (PDT)
Date: Mon, 8 May 2023 17:26:21 +0800
From: Hangbin Liu <liuhangbin@gmail.com>
To: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: netdev@vger.kernel.org
Subject: Re: [Issue] Bonding can't show correct speed if lower interface is
 bond 802.3ad
Message-ID: <ZFjAPRQNYRgYWsD+@Laptop-X1>
References: <ZEt3hvyREPVdbesO@Laptop-X1>
 <15524.1682698000@famine>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15524.1682698000@famine>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Apr 28, 2023 at 09:06:40AM -0700, Jay Vosburgh wrote:
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> >A user reported a bonding issue that if we put an active-back bond on top of a
> >802.3ad bond interface. When the 802.3ad bond's speed/duplex changed
> >dynamically. The upper bonding interface's speed/duplex can't be changed at
> >the same time.
> >
> >This seems not easy to fix since we update the speed/duplex only
> >when there is a failover(except 802.3ad mode) or slave netdev change.
> >But the lower bonding interface doesn't trigger netdev change when the speed
> >changed as ethtool get bonding speed via bond_ethtool_get_link_ksettings(),
> >which not affect bonding interface itself.
> 
> 	Well, this gets back into the intermittent discussion on whether
> or not being able to nest bonds is useful or not, and thus whether it
> should be allowed or not.  It's at best a niche use case (I don't recall
> the example configurations ever being anything other than 802.3ad under
> active-backup), and was broken for a number of years without much
> uproar.
> 
> 	In this particular case, nesting two LACP (802.3ad) bonds inside
> an active-backup bond provides no functional benefit as far as I'm aware
> (maybe gratuitous ARP?), as 802.3ad mode will correctly handle switching
> between multiple aggregators.  The "ad_select" option provides a few
> choices on the criteria for choosing the active aggregator.
> 
> 	Is there a reason the user in your case doesn't use 802.3ad mode
> directly?

Hi Jay,

I just back from holiday and re-read you reply. The user doesn't add 2 LACP
bonds inside an active-backup bond. He add 1 LACP bond and 1 normal NIC in to
an active-backup bond. This seems reasonable. e.g. The LACP bond in a switch
and the normal NIC in another switch.

What do you think?

Thanks
Hangbin

