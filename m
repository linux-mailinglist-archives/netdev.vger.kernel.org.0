Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9416216E9
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbiKHOiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbiKHOiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:38:06 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC72D2EE
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:38:05 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id t25so39111911ejb.8
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 06:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/YbHJ4ibpE0FQ4BHuZdNaBU3FcOkLHnK8mt3jJ2tQt8=;
        b=KTfLvqiSu2CcpT1y/20uKajI43NPbw82QWz6SxA0Lir3LFhIVCreDjd17jJiA/SaGm
         AcNAaQpUcrMIX7H5HInQwsM5uEUZ0BBQLzmufcqbGiTPMcWhxrQoIimZtNeNWLUPx3v3
         OkgdSlwRJ4mo9VjQEUIKVbPM8olU9MN+RaF/55nEuHtdh33jvWV0N8Lmj9U77VXBULcd
         mB8r4PzXH87nFtyZ3ALFRNfdqWB8ek/SBpF5rzG5YrYyYUdagOxSQmM5EAn+KYYr/YAp
         UE4AJCRu1+MuxTMDHIj0AossrJjIZpLvMrDrtpNUi88EfacEokhe7sbj/tiZOYhS0GVd
         A1OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/YbHJ4ibpE0FQ4BHuZdNaBU3FcOkLHnK8mt3jJ2tQt8=;
        b=CS6W7ldYavhRVvLO+KWVEjLQ+jmGVH2lcBrFpiryo2sIhdlL7+plBA+TBJoYHYnXWz
         5bBn4AxiTGKe/ZuSs+30CZS2sG0Wr/0FTZz+Oi1drYBeIfmeq11dlR8KkUvy87uUSFrj
         CSNLgPYY46+DcSJmukoNtU32yrxr0gF2EgOl60NArteYrJ6KDbe4OWVIYveqXBaz5k9Y
         TjEPhBENQNmEi/neKH65kMF9Wq4wBpv8xUoOOK6JS+l1e7Q4M0OpJR2D/b2s00Ty2QpI
         ZW1EDQs9fP8oIKyqSw41sYWBUEeUwjPwpn3sl7fTu1VH7hsZCBSV2602lWdPWXutxlav
         Akbg==
X-Gm-Message-State: ACrzQf39BGYbIQkAJcRdhqIc2jZcSuUFw+dtYsJTSRT42hfiN+X0xnUZ
        5pFNB9KlbXIU4go+w+8ikX0=
X-Google-Smtp-Source: AMsMyM6BJQaQkCs8iviKLy1mFElapHYnAwJIx487QHMTByllRJi4gCAegc69C5Cfm2RRt9bfrQUajA==
X-Received: by 2002:a17:906:24cd:b0:78d:4cb3:f65d with SMTP id f13-20020a17090624cd00b0078d4cb3f65dmr990263ejb.79.1667918284086;
        Tue, 08 Nov 2022 06:38:04 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id i28-20020a1709067a5c00b0077f20a722dfsm4680287ejo.165.2022.11.08.06.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 06:38:03 -0800 (PST)
Date:   Tue, 8 Nov 2022 16:38:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 04/15] devlink: Add packet traps for 802.1X
 operation
Message-ID: <20221108143801.42rqnrtprjxurgqh@skbuf>
References: <cover.1667902754.git.petrm@nvidia.com>
 <cover.1667902754.git.petrm@nvidia.com>
 <ec42c7bf37d9a5e05096c409dd96c1c582747b24.1667902754.git.petrm@nvidia.com>
 <ec42c7bf37d9a5e05096c409dd96c1c582747b24.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec42c7bf37d9a5e05096c409dd96c1c582747b24.1667902754.git.petrm@nvidia.com>
 <ec42c7bf37d9a5e05096c409dd96c1c582747b24.1667902754.git.petrm@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 11:47:10AM +0100, Petr Machata wrote:
> The "locked_port" drop trap can be enabled to gain visibility into
> packets that were dropped by the device due to the locked bridge port
> check.

Pretty cool.

The action of all devlink DROP traps can be changed to e.g. CONTROL, right?
This doesn't functionally affect an offloading driver, because what
won't be dropped in hw on a locked port will still be dropped by the
bridge, correct?

I'm not familiar with devlink traps. Is there another way to see the
dropped packets except to do what I said (change the action type)?
