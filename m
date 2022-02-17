Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79224BAD11
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 00:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiBQXKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 18:10:20 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiBQXKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 18:10:19 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A375577C
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 15:10:00 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id v25so1257957oiv.2
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 15:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cesWgw8mrS3vFyNhmPb3KYWdD7c34BQe1uFV470EgiU=;
        b=ERc7hJOlMGpztLdEXQ+Ivm4Nq4T5qcU30xiVZ9EjlUZooVsiBBBPj9l1YA+ES64xne
         mD4AYNOOs6SwBX6HMtKCGd6eUT9sgIALYbEfjepQpRiMGIzRlInkrccyzJkLBBsd+JLG
         QlQalWeKnIz/1KYrUsV8ebm1peQL6bJaXIyWaFb1ovTXp9wwohQ42wAqrDPpjZg1BPLF
         /4kKtBJWAhsbl9k22uEUKHp2XNvSdOLOmM5inTdPo/f33r89Mkfi3+mHxYiXDkxma7mM
         EzL7kK04GCyRfsPepvW8/WkT0ZHObprMR8drvrdd1NKnqkaxuxPSIbHAxv/+7sB91qiZ
         IZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cesWgw8mrS3vFyNhmPb3KYWdD7c34BQe1uFV470EgiU=;
        b=l+WOaFTwiyymTxSujDyV1KTivMg07fOzCSIPaXIgqVYDzFe/0/xwRtuviMGTEKf72p
         p9ppaNfr5bb83DpvvSil6RaER5NIc+biIA8Ebit44K21i7ftsH58tEmq+SAGG48iRNJF
         +388p72ZAov7rrh10OoQQQNCwO7TNyvkK4PxS8AhuBLJBiQ5qeMyD1GWHYAmCrHLkhl5
         9OCYsdmDNzAtQRf3yVdEtKl7bSDCZAlMxn7L9AwwDmlvljhDEbw4loTOfKllrl5e699d
         m2cER3OpuGUG/tvCcYncS1MEQmj9kivoh++o7xHpzsxheY3PEnPBbR7QLWpnlVRZUlyf
         yKpA==
X-Gm-Message-State: AOAM5306A7UPmYSawAGcKcwWBN2l03zgQji/LpWXKCrPX+XDQrIKPP4J
        lPhfkFEEXdtx9SyW34qGo0o=
X-Google-Smtp-Source: ABdhPJy0oAjiigrmYsIVtqv5+hJqUY/H1W9YVu9sFVdlmSDM/YsH+9PVbBdXfa9qqFFwxtElyNCalA==
X-Received: by 2002:a05:6808:14c2:b0:2cf:51f6:51db with SMTP id f2-20020a05680814c200b002cf51f651dbmr2171529oiw.30.1645139400113;
        Thu, 17 Feb 2022 15:10:00 -0800 (PST)
Received: from t14s.localdomain ([177.220.172.100])
        by smtp.gmail.com with ESMTPSA id w7sm573224oou.13.2022.02.17.15.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 15:09:59 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 3E5A4167736; Thu, 17 Feb 2022 20:09:57 -0300 (-03)
Date:   Thu, 17 Feb 2022 20:09:57 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>, davem@davemloft.net,
        Jiri Pirko <jiri@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Oz Shlomo <ozsh@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: Re: [PATCH net 1/1] net/sched: act_ct: Fix flow table lookup after
 ct clear or switching zones
Message-ID: <20220217230957.xovkve564x6qqucc@t14s.localdomain>
References: <20220217093048.23392-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217093048.23392-1-paulb@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 11:30:48AM +0200, Paul Blakey wrote:
> Flow table lookup is skipped if packet either went through ct clear
> action (which set the IP_CT_UNTRACKED flag on the packet), or while
> switching zones and there is already a connection associated with
> the packet. This will result in no SW offload of the connection,
> and the and connection not being removed from flow table with
> TCP teardown (fin/rst packet).
> 
> To fix the above, remove these unneccary checks in flow
> table lookup.
> 
> Fixes: 46475bb20f4b ("net/sched: act_ct: Software offload of established flows")
> Signed-off-by: Paul Blakey <paulb@nvidia.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
