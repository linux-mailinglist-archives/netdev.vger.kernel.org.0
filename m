Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C384859CF
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 21:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243874AbiAEUKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 15:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243873AbiAEUKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 15:10:21 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3187C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 12:10:20 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id s15so340483pfk.6
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 12:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kTEd8SR0dKH+e5TRu3aR4XVht71WCbL4ilwOQR/WyXg=;
        b=M6dFBOmX9TYa+rX6s5WsmPg+TQXyLsFFaFDjRJYUEDY+F8EM4h7UeAh6M/2ITgSEgm
         6Oo3bHC4ebTDdVK8IbMXtKdc6y6JG7mNMb/JIgAUu8JEaLtKWKp+IMybE4RFKRqRt9un
         VbUfwhsHX3xIOyD3wds/AqCB+8nWeAKhIWcZdFeW4a0QLYjdOgLCnSSnwxcRz4fbPnWG
         15dVjQ9cuF1fkpU+M5i99cC7arhqN8+RkZxD93FB63kJGfv1/nhfNe/QlPsATpgyjWQA
         nTQxs54KwovB4LrKBwyZ2FTofBCmIQr8EGxbhuL9X19T0z8vHxWY8ckPIJcT0/IFKQuf
         0iuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kTEd8SR0dKH+e5TRu3aR4XVht71WCbL4ilwOQR/WyXg=;
        b=Pc7snaIEyCCU3mql9itzXjP9CrSCXIK8velGAmijNT10/2zBi5BPICXgir/l1HkiEt
         uQhZD2J5+Bp8XvrZmzhq11fzNobOR8r+Q2e67DjnbRHyXAp0k8kBhC4tPgta8nx8JCje
         44fhGb7fx5assvIWgnN3D7vZOS1TyTSPYUI7LFk49YHlMs/10IALce6+tBhBcoYka3E2
         D4xCI+I+kt5MqdWDzoJGRZTl1NzL5Jiz5+A1L7FIg2KYaWf/VAgndaiKkkD1StmqftJ1
         rVGkLVX/1n+f3sxPbSomBVu/SLHRV7e73XoasfCANTXqSICm3t3RUoit/Y0Rl4sqDcGA
         ncPg==
X-Gm-Message-State: AOAM530xXsMD2+F5fVbDHtzwWqnADKk07hXztXh7DtFHZVoY7s57ybe/
        ZnGq+Wgl+f9pHIYJEN0Qsic=
X-Google-Smtp-Source: ABdhPJw5nIAhvARHxkGUkMtFdWxru8gtTVHWDAB4IYyUXI8qqTMnppeHMB/7S/mpmj+4X5NxZHioNQ==
X-Received: by 2002:aa7:8c59:0:b0:4bc:9dd2:6c12 with SMTP id e25-20020aa78c59000000b004bc9dd26c12mr17626163pfd.59.1641413420551;
        Wed, 05 Jan 2022 12:10:20 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x19sm2428083pgi.19.2022.01.05.12.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 12:10:20 -0800 (PST)
Date:   Wed, 5 Jan 2022 12:10:18 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     netdev@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: Re: [PATCH net-next] net: fix SOF_TIMESTAMPING_BIND_PHC to work with
 multiple sockets
Message-ID: <20220105201018.GB27023@hoboy.vegasvil.org>
References: <20220105103326.3130875-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105103326.3130875-1-mlichvar@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 11:33:26AM +0100, Miroslav Lichvar wrote:
> When multiple sockets using the SOF_TIMESTAMPING_BIND_PHC flag received
> a packet with a hardware timestamp (e.g. multiple PTP instances in
> different PTP domains using the UDPv4/v6 multicast or L2 transport),
> the timestamps received on some sockets were corrupted due to repeated
> conversion of the same timestamp (by the same or different vclocks).
> 
> Fix ptp_convert_timestamp() to not modify the shared skb timestamp
> and return the converted timestamp as a ktime_t instead. If the
> conversion fails, return 0 to not confuse the application with
> timestamps corresponding to an unexpected PHC.

Acked-by: Richard Cochran <richardcochran@gmail.com>
