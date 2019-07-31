Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00AC77B8B8
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 06:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbfGaEbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 00:31:00 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42304 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfGaEbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 00:31:00 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay6so29919843plb.9;
        Tue, 30 Jul 2019 21:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aWCo57+BoaXzwl2WEeJkLPW0p2pUCHqK296Egq73VYU=;
        b=qq+qornHhhh0pApQAe9cYHwBq5LyJ0Ccjx7+I8odAR01HaM7EVQJoEAPCN3MI+78uL
         pweEHxtyieA4zlJS8avkFxacc9PICcIK7Qxipm6vSeevCDodrpiI6tIZEx+SHDj1SmnA
         PV5v0KC8rU1R59gpc03p0+aZE8UL7fNImxwxFvtTbVg9fRSL5rEoDG2uGEbxUClUIz34
         cS4YX1hBH3+QP08ElUMl5d3lCMBu6IviuXtPdPSidpr75u4Wgu/WLErMXc0HAHzCl1kg
         G4QGvNzXtuqgQrS6rWiKuIb7Tl1Yd+XPM+PW1hLKtR8Qdtb9yfTZEisCtDL1XDGJKIN3
         dOfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aWCo57+BoaXzwl2WEeJkLPW0p2pUCHqK296Egq73VYU=;
        b=lfECd4HfO6D25sJDqsljxkPpXOM5fPY5Ug92prDL1DQZ5MXu/rjhozmlcQwPvEDAal
         4tlQQmbpwByjmSRRnUwJiEp3waDMOJ5qPLfYblGc7HaclWISe7hHJb0BbPs4Jo+th4eW
         RSxIqicf+t6M4K3Zj9z2vjo7/HpX/sawBZQTlpXFAXbJzJIYx32GAQQstbJJ5V/8XhGf
         8CSAOzl5mCFm75SIx+uXfw5tKI2kdk+Iz7i+3HkCwo+ZcRaYP4/+jxEi6h6wC2AHwxkm
         9+8DQGKrqJUIsiGyyvy6q+Wvh6KdpteEQfdKTA1f3pyKTJ0ZjRKi5SixGZYbPspV8uR4
         pDrw==
X-Gm-Message-State: APjAAAX9w36YsPOXcOqVE4Vogn9CgCs0ILdbcKzeLzXc360fOt2wD62t
        G+bMKaxMY77vhT+5XVJr/Qw=
X-Google-Smtp-Source: APXvYqx0iYkTtR3C6HQ0OZ5glSnx1Nwsfo9AImrQoC8dMXuWWMuBfLojlmn6g31v1mOP2S6R8Oc82g==
X-Received: by 2002:a17:902:7c90:: with SMTP id y16mr120348323pll.238.1564547459509;
        Tue, 30 Jul 2019 21:30:59 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id h1sm84205792pfg.55.2019.07.30.21.30.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 21:30:58 -0700 (PDT)
Date:   Tue, 30 Jul 2019 21:30:56 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH 4/4] net: dsa: mv88e6xxx: add PTP support for MV88E6250
 family
Message-ID: <20190731043056.GA1482@localhost>
References: <20190730100429.32479-1-h.feurstein@gmail.com>
 <20190730100429.32479-5-h.feurstein@gmail.com>
 <20190730160032.GA1251@localhost>
 <CAFfN3gUCqGuC7WB_UjYYNt+VWGfEBsdfgvPBqxoJi_xitH=yog@mail.gmail.com>
 <20190730171246.GB1251@localhost>
 <CA+h21hqWO=qT6EuQOVgX=J1=m60AWT6EGvQgfzGS=BNNq1cyTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqWO=qT6EuQOVgX=J1=m60AWT6EGvQgfzGS=BNNq1cyTg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 11:46:51PM +0300, Vladimir Oltean wrote:

> Technically it is not "not true".

[Sigh]  The statement was:

    The adjfine API clamps ppb between [-32,768,000, 32,768,000]

The adjfine API does NOT clamp to that range.  That statement is
simply false.

> And what is the reason for the neg_adj thing? Can you give an example
> of when does the "normal way" of doing signed arithmetics not work?

The detail from years ago escape me ATM, but I needed to use div_u64.
Maybe div_s64 was broken.

But that is not the point.  Changing the adjfine() logic for this
driver is out of scope for this series.  If someone thinks the logic
needs changing, then that must carefully explained and justified in
the changelog of a patch implementing that _one_ change.

Thanks,
Richard

