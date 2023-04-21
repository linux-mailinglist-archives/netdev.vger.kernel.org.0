Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1086EA79E
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbjDUJzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbjDUJzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:55:18 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100A8A26F
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:55:17 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-63b62d2f729so1740973b3a.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682070916; x=1684662916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hhQ5d2eoF+4cNA1x8a8CdobJpCrUwblLyQkyozMENwQ=;
        b=pgYcnT7MudjSjpCCx6y6T5OZlGcCkndQ+umKWw5rwzWd/gZeMir2EhkmXETxu+oGt8
         C2AEkSjnE93ZkWOKfs5cbnn4E9M8y2pKUPVW1ZcZBiiI34OPf23DlHldso+pNgYYhFAN
         j/dimAiDbHXPbhL+4sOrGYS3mnrH4FIdjaccjyG/RVg5FKPjPGwHdzigNc3ibSoRPlCy
         2XjmBFPKjS8v4rbuOZ5hNwGUetgs3bkchD2tVgv90XLOFkG+8VmhxPNfKcHrvLN69M7H
         K6Bjq8iEbWxujruL+mykSBcHFMQPdmv2Px+54sqPFG/EjpQg4z0TAp7c6De/FqzhPkaU
         6K+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682070916; x=1684662916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhQ5d2eoF+4cNA1x8a8CdobJpCrUwblLyQkyozMENwQ=;
        b=QFpNR3IN6QS+zeaS5eQN8hjLiH4h+el9hivikNPGFt0QZ/5fW1JaLxoRxlPQqR6OQH
         IaRsBr1wHLVV+viU6Q2UwmEpb3+d45Ai3ja2Pn7fPEnAEU1TjlJX2eAf7MiraWAnXV9X
         GLaoenY1ADnObYfvOtWmcAK18iK7bGx0R2qrIlZJzgBqi0OFalP0e5X9xvUhl4C3/2sf
         cWQa060+wIbH50KUnzE/7a7sLRINZMfCXZ6NzSezDbPPh63qVwDH1XSpHAExSxtSt9Ub
         Wb7WdpLIhF97K/WiTkvbeNOYkpeSUJeH+UESBlCzW2U0WCdeWlCctt3PeIT2m6E+9oEo
         c2Bg==
X-Gm-Message-State: AAQBX9e+V0DfJy+wPR/aa2V+go/AyjGAUNjFgM8VmQ5t+rT0nUDTAm2u
        Yg03Xhkbk920NT5dmhw+YCc=
X-Google-Smtp-Source: AKy350bSCKg6ntFRD3Dz5CrQc9Rk7OvojA27TcAhvOBg5dHCvHPpKnGsz4zUonxjB+Qk4dVFJnHddA==
X-Received: by 2002:a05:6a20:8407:b0:ef:9115:c718 with SMTP id c7-20020a056a20840700b000ef9115c718mr6288972pzd.26.1682070916484;
        Fri, 21 Apr 2023 02:55:16 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j3-20020a635503000000b0051b72ef978fsm2342777pgb.20.2023.04.21.02.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 02:55:15 -0700 (PDT)
Date:   Fri, 21 Apr 2023 17:55:09 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        oe-kbuild-all@lists.linux.dev,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>, Vincent Bernat <vincent@bernat.ch>
Subject: Re: [PATCH net 1/4] bonding: fix send_peer_notif overflow
Message-ID: <ZEJdfWNwzfjpTXom@Laptop-X1>
References: <20230420082230.2968883-2-liuhangbin@gmail.com>
 <202304202222.eUq4Xfv8-lkp@intel.com>
 <27709.1682006380@famine>
 <20230420162139.3926e85c@kernel.org>
 <ZEIGCaLWKIY3lDBo@Laptop-X1>
 <6347.1682053997@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6347.1682053997@famine>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 10:13:17PM -0700, Jay Vosburgh wrote:
> >It looks define send_peer_notif to u64 is a bit too large, which introduce
> >complex conversion for 32bit arch.
> >
> >For the remainder operation,
> >bond->send_peer_notif % max(1, bond->params.peer_notif_delay). u32 % u32 look OK.
> >
> >But for multiplication operation,
> >bond->send_peer_notif = bond->params.num_peer_notif * max(1, bond->params.peer_notif_delay);
> >It's u8 * u32. How about let's limit the peer_notif_delay to less than max(u32 / u8),
> >then we can just use u32 for send_peer_notif. Is there any realistic meaning
> >to set peer_notif_delay to max(u32)? I don't think so.
> >
> >Jay, what do you think?
> 
> 	I'm fine to limit the peerf_notif_delay range and then use a
> smaller type.
> 
> 	num_peer_notif is already limited to 255; I'm going to suggest a
> limit to the delay of 300 seconds.  That seems like an absurdly long
> time for this; I didn't do any kind of science to come up with that
> number.
> 
> 	As peer_notif_delay is stored in units of miimon intervals, that
> gives a worst case peer_notif_delay value of 300000 if miimon is 1, and
> 255 * 300000 fits easily in a u32 for send_peer_notif.

OK, I just found another overflow. In bond_fill_info(),
or bond_option_miimon_set():

        if (nla_put_u32(skb, IFLA_BOND_PEER_NOTIF_DELAY,
                        bond->params.peer_notif_delay * bond->params.miimon))
                goto nla_put_failure;

Since both peer_notif_delay and miimon are defined as int, there is a
possibility that the fill in number got overflowed. The same with up/down delay.

Even we limit the peer_notif_delay to 300s, which is 30000, there is still has
possibility got overflowed if we set miimon large enough.

This overflow should only has effect on use space shown since it's a
multiplication result. The kernel part works fine. I'm not sure if we should
also limit the miimon, up/down delay values..

Thanks
Hangbin
