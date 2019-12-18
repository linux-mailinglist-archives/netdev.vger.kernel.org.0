Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A1C124663
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 13:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfLRMCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 07:02:30 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41976 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbfLRMC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 07:02:29 -0500
Received: by mail-pl1-f194.google.com with SMTP id bd4so875568plb.8
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 04:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pKDPIj7dKOkneEQstS9kmIONL5L79ApxNsEgnINeAsk=;
        b=EijYv16XFdhCOErVNrYVWq65cSZ0y6HRanalzCzYLI0BR2EAuzFYb0YOZuWr2syqau
         at86l8kW+ju66BAZqx5RnoztxpN9tzxCoxa+CeXr/NFgNc6LYmYHJ01mGD8h5oqjdsMk
         bQoOQRxSTUNzz7AbfkIxYWsFZDXu5wghxV2YGjxS8X6328JJI03LjOBJPzRzt9p/4zDP
         mRQKHzdbcSQGaMLgemRssExK54cebRUpXSetclAn4rPtePdbWAMcPCGmfCs/Q242g3HX
         AnBq/rArbb5X2ZLlAjCxVPGwZmIPrr5PX+VCtAuH+QJCsG6dF0oiXUq6JXclQ+5NEj75
         48cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pKDPIj7dKOkneEQstS9kmIONL5L79ApxNsEgnINeAsk=;
        b=tVHjO33k+INOQhExoMSfwld81j+h0VotyAPd87hXLoIBoVrNo1OpB6uVuZV+2QxtFG
         3LxVgPtycMsvhkKPntHyeS0l6J606fYy1EI3ZetCVa82er1x33phe9A9JlcLUn1lCdDH
         w51YR4nWQfFf2d0+ioaEmbfeHWqU7Y7aF3Bis3Z9+hU2sftFjP0/uyzEo4QeuusjcvPt
         JnpFMZTNPcRsGsnPwpQ3tLkAXQ2m6WwEm6/Il5E7zrmZiVGSim86X2M6EJml0bYRM6QT
         H9Eic3aPmiKagYHdbVL1hX+h4Lz0XsP7R0NURqECpH7N2uhhq1dhsLxz4TS53OJtiDQX
         7Khg==
X-Gm-Message-State: APjAAAVSLLlcEyDrFJ/28Ra+yfC7xBlG4+TYSKeF+VJgZS7RiQ9Rqi3J
        qqV/UwmMab7nvRZfoHMtyUfDdhzcyXc=
X-Google-Smtp-Source: APXvYqxeQkjihUaEVDmMeeSgd5vOuy+X0HtYqLs7gQ5mA4IIVW/Ln81eSim8FJuQzf7t82j1hj2MaA==
X-Received: by 2002:a17:90a:a4c4:: with SMTP id l4mr917677pjw.48.1576670548826;
        Wed, 18 Dec 2019 04:02:28 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z14sm3157009pfg.57.2019.12.18.04.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 04:02:23 -0800 (PST)
Date:   Wed, 18 Dec 2019 20:01:48 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>
Subject: Re: [PATCH net-next 0/8] disable neigh update for tunnels during
 pmtu update
Message-ID: <20191218120147.GA27948@dhcp-12-139.nay.redhat.com>
References: <20191203021137.26809-1-liuhangbin@gmail.com>
 <20191218115313.19352-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218115313.19352-1-liuhangbin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 07:53:05PM +0800, Hangbin Liu wrote:
> When we setup a pair of gretap, ping each other and create neighbour cache.
> Then delete and recreate one side. We will never be able to ping6 to the new
> created gretap.
> 

Oh... Sorry I forgot to add PATCHv3 in the subject...
