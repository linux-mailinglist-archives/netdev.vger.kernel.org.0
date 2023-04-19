Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0472D6E721B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 06:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjDSEJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 00:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjDSEJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 00:09:26 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE0565B0
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 21:09:24 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b46186c03so3313483b3a.3
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 21:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681877364; x=1684469364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4qe7zCOwW5jWJyA7/VG2QkAQ8aBfGz1NbOMxoUmDyZU=;
        b=soqJFZD2q/0FHh0iG1TlCUNfMjW/0V5ESXuX+WGz0X3tSwolMYr6wMhmsSwAbcjQj6
         DUleQzGWE/sXxSTOuvjaN/He1NcxsrQkx8uDVKNjlg7V+txTM8d2CQtqV8WmOjx0G2jZ
         g9HA9dK5bqZc2JDrKDoug/j/EnG5XslIRWQW6w/uohQjMxYrM3zqzX8qpdIZZ5x0sCFq
         G+og5PIgrDlx+GlV/Rjp8ui/4cWc37+c95UGg0Uds7Wg06tq5vCyKeFuiMDxYW0K4Rth
         gJUERV/nah9Kic6jK5yBMY7xhexuQi4/1WVBiiaVIuKyPCm2cdtHLbjzbGO1aBwRpf/1
         Pvkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681877364; x=1684469364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4qe7zCOwW5jWJyA7/VG2QkAQ8aBfGz1NbOMxoUmDyZU=;
        b=Xr8dmeQZN1Gm37dw/WZVZb3LfozacT6143DEPW58A+kUeZjxVr0dLJGm9z3tErh7VQ
         NnNeG35EHhxskdMQWkF9BiE7Iw7zKR+504X3vH345F/TDbmyI/Mlpv1apXpZdY04dUgn
         sd7vwaQE4qR1v1p72wjsPxSG/HUcvfEv0CGe4XAiye4xrCJdv1V+jkSssEp8lSR2pWZI
         g4uVXcxzdA5hvHpJv4B9zY93tMullBs7fla5b+lALivHAJhRt/H1tXQgj8JSTdc9uo1b
         8GnTSB/Rj+XgdjnGxWqmqOrtBnuFwYG8yTus5LhYbDrE51pQF0amGTkCRV81mC0MpNn/
         cmwA==
X-Gm-Message-State: AAQBX9c/5Je6iY6Sd60xXOhcQVFYqcJkd/PY/lDlbY6VnHyVnZCrxkSC
        HnvXX5f5wdO+aiw8gAU3WEQ=
X-Google-Smtp-Source: AKy350YGiEm0vPvsiN0gswfh9EQR+EqsxGzqxy1qWdkIWjqj9xW1NpIXXk5lAePLnaN6eXsOOvdwUg==
X-Received: by 2002:a05:6a00:807:b0:636:e52f:631e with SMTP id m7-20020a056a00080700b00636e52f631emr2581165pfk.1.1681877363865;
        Tue, 18 Apr 2023 21:09:23 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j2-20020aa78002000000b0062ddefe02dfsm10350090pfi.171.2023.04.18.21.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 21:09:22 -0700 (PDT)
Date:   Wed, 19 Apr 2023 12:09:17 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv5 net-next] bonding: add software tx timestamping support
Message-ID: <ZD9pbffw3s1HVwvE@Laptop-X1>
References: <20230418034841.2566262-1-liuhangbin@gmail.com>
 <20230418205023.414275ab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418205023.414275ab@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 08:50:23PM -0700, Jakub Kicinski wrote:
> On Tue, 18 Apr 2023 11:48:41 +0800 Hangbin Liu wrote:
> > Currently, bonding only obtain the timestamp (ts) information of
> > the active slave, which is available only for modes 1, 5, and 6.
> > For other modes, bonding only has software rx timestamping support.
> > 
> > However, some users who use modes such as LACP also want tx timestamp
> > support. To address this issue, let's check the ts information of each
> > slave. If all slaves support tx timestamping, we can enable tx
> > timestamping support for the bond.
> > 
> > Add a note that the get_ts_info may be called with RCU, or rtnl or
> > reference on the device in ethtool.h>
> > 
> > Suggested-by: Miroslav Lichvar <mlichvar@redhat.com>
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> > v5: remove ASSERT_RTNL since bond_ethtool_get_ts_info could be called
> >     without RTNL. Update ethtool kdoc.
> 
> I'll apply Jay's ack from v4 since these are not substantial changes.
> Thanks!

Sorry, not sure if I missed something. bond_ethtool_get_ts_info() could be
called without RTNL. And we have ASSERT_RTNL() in v4.

Thanks
Hangbin
