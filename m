Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC33E1791EA
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 15:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbgCDOHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 09:07:09 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39408 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgCDOHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 09:07:08 -0500
Received: by mail-wm1-f65.google.com with SMTP id j1so2005581wmi.4
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 06:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AOvwsnEYlfX0Wqq21z+5GQns09nLBH6qOfo+ZW59MFQ=;
        b=k4NNoIPrMEjzo8b2MI8K+hvHLIAGD1ownECLfYmBTxNeb9hsJnSWelPEXtGqQKHs7U
         1ubmBRih9aM7mnqftu2W1PunJe0bxFYDEoyFxeqMM9Hg9RZ7vCW5pWwlHJ6KxHiItj4y
         UtCC/tFWXRqjwixhWG1QNDmRQjAcBX0UeyEYasOsxhZTvkGz2VYr8S6SeqQXjAzSdzcL
         dgxUZc11WHYkgYH+kodg0QQYPvmArj6Y8ed/VGRom4kPsUZcziho9gnoeB8+TAWD0CRz
         bDx++0ESjHHqKT8mgSBKeNOGlJ8/QbUNsaDvpN61Z/tnVBITIjGyWWAikf2zj2adRy/7
         8fYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AOvwsnEYlfX0Wqq21z+5GQns09nLBH6qOfo+ZW59MFQ=;
        b=s3esH5S0tjLMbK+LMwlpU+hLWEo0A+IKcOqTocCdH1OMTB+n1oWpC5wyeAULIKckEw
         RVUDtZBkm8FOyTHMU4zvq1Koi9UWUvT4+LUefiIy2uLh3PI+JCOa60PVmF1YIVn9QQ9D
         Y4sPsWt/cBQaB6qbXYrlU188E65XkRUqbbu6hidowEDjjyCEVbSn4ZhYtbTBtpFONWA7
         0/HvLeQFlWH7Zcc+yD4p2jL8lf1DhOErXLCerMv6IzUAuhULIh8TTMCYlhxjkFi06vIl
         Ek5VOwZ8BJoFA2ijg6hC2bSNNpEraAsfL/aBP/XAFq1IyfnEgkwnvMFOZQr/TEYad3s1
         OKXA==
X-Gm-Message-State: ANhLgQ2fwCrid78XwiwJ+YdAuUa0J+xE0BEwDs/PUekKKo/BY3PlGjEc
        q0DwMpnpsFavp4CdlDx4Ioyjhc6DpNQ=
X-Google-Smtp-Source: ADFU+vv+EGyqgy2O4YSBYHZfqHw82OL52KroX7LWkWS2OdDxhzdiQwoKx8JeEWAn+1Aam76sCnEPyw==
X-Received: by 2002:a05:600c:20c7:: with SMTP id y7mr3939800wmm.77.1583330825603;
        Wed, 04 Mar 2020 06:07:05 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id t83sm4524560wmf.43.2020.03.04.06.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 06:06:58 -0800 (PST)
Date:   Wed, 4 Mar 2020 15:06:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH net-next 1/2] net/sched: act_ct: Fix ipv6 lookup of
 offloaded connections
Message-ID: <20200304140648.GB4558@nanopsycho>
References: <1583322579-11558-1-git-send-email-paulb@mellanox.com>
 <1583322579-11558-2-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583322579-11558-2-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Mar 04, 2020 at 12:49:38PM CET, paulb@mellanox.com wrote:
>When checking the protocol number tcf_ct_flow_table_lookup() handles
>the flow as if it's always ipv4, while it can be ipv6.
>
>Instead, refactor the code to fetch the tcp header, if available,
>in the relevant family (ipv4/ipv6) filler function, and do the
>check on the returned tcp header.
>
>Fixes: 46475bb20f4b ("net/sched: act_ct: Software offload of established flows")
>Signed-off-by: Paul Blakey <paulb@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
