Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECCF4FBCDD
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346392AbiDKNSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346396AbiDKNSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:18:36 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CD83A703
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:16:22 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ks6so6169342ejb.1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pyQBy9iwkzzjVv7KxJaXhIVVKnfyHz0YqrYMS/rW2CI=;
        b=eIO93YcKcRz2JUkQ1NMSSgpCG+ilOH3kO68zr+7G0mu4pUUFvtrWwMhjRUlCQj/eKr
         s1ymgz2onMH7jS5+aViGe9/Dso5kY8X2DePnjEuWgnMRMBdAQsrq4PdNQrbaFzW/dByV
         i9nJyZeqUW7sTF7I2nQ6tLuLKwBP+Z76wJytMHoeTn8qcvQ+ljp16MpmnBzole04eODj
         x/6MN0LE3ezOMEgELsDfOBxtD8bljLSA8eE6FwGP4IZo/iglxkOxQx/nddS5V5rl5ML7
         7aKeGGDOcNsspP6J1NEllH3rDnf8n67c6WlZaSNZfWtc08iENxZ+3ADLb28xOruBDTrL
         5rzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pyQBy9iwkzzjVv7KxJaXhIVVKnfyHz0YqrYMS/rW2CI=;
        b=B0qVfPsM8ckWT5b+bNWjWmYcKtLJ/znbohrLCtmHEV3OqoMD2xceeXCBzbBe+c3pH4
         mslx8s4FPmERqH+Qe7JrQM/LJmrB3FK0bu5Jyd9xtkO6aPYpYT3HippgBaOMmXLj8GYn
         3y8MBSASCsXb4mLlmQMr32RpaIA8MU09+7d9Cl0nQbyt9ieM2GD9/NmVE0fHbA2sr+1V
         swHdAVq13ndClHoNCUOspoVMkIqUbwm05wyABpTrx/Wt+5fidJa0jwcfe4Zjld3VyvRz
         T26cPmh21UCmT7INOPIMv17kJjcHyChkkJ3gLG+LQkWI80ly+j89ZvzPwrlN0SBSbyOd
         GZIw==
X-Gm-Message-State: AOAM530K4iwYLU3faBgI6D0O1MjjCOQ6Lg9EpS8EOkGozipSMmqxfQq9
        GTtFHE66eRLbRxQL5QC91Ec=
X-Google-Smtp-Source: ABdhPJyNi+PX9o1rHJ/krQSq5LWdiE3EAb1NvfqlI4etqxgtoyDGtfhyPdoB78lJp3pJ2lyD+4XxTA==
X-Received: by 2002:a17:907:1c1c:b0:6e4:e488:4e76 with SMTP id nc28-20020a1709071c1c00b006e4e4884e76mr29321778ejc.93.1649682980804;
        Mon, 11 Apr 2022 06:16:20 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id p24-20020a1709061b5800b006e88dfea127sm1564233ejg.3.2022.04.11.06.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:16:20 -0700 (PDT)
Date:   Mon, 11 Apr 2022 16:16:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v4 net-next 0/3] net: dsa: mv88e6xxx: Implement offload
 of matchall for bridged DSA ports
Message-ID: <20220411131619.43js6owwkalcdwwa@skbuf>
References: <20220411120633.40054-1-mattias.forsblad@gmail.com>
 <20220411123908.i73i7uonbs2qyvjt@skbuf>
 <aa550823-8d75-d255-232e-e5c1791dbca3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa550823-8d75-d255-232e-e5c1791dbca3@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 02:48:29PM +0200, Mattias Forsblad wrote:
> My thinking was that the notifier I was aware of was the one I implemented
> and someway was a preparation for consumers (that didn't exist yes). I didn't even
> know about dsa_tree_notify(). So I'll remove that part, yes? Is that ok even
> if it's not optimal, like you say?

Optimal or sub-optimal, I think there are bigger problems which we're
taking too lightly. Like this one:

| If there is tc rules on a bridge and all the ports leave the bridge
| and then joins the bridge again, the indirect framwork doesn't seem
| to reoffload them at join. The tc rules need to be torn down and
| re-added. This seems to be because of limitations in the tc
| framework. A fix for this would need another patch-series in itself.
| However we prepare for when this issue is fixed by registring and
| deregistring when a dsa_bridge is created/destroyed so it should
| work when it's solved.

You've presented just the more convenient angle of the limitation
(DSA interfaces present as bridge ports, then leave, then re-join).
But the same problem is there even when the tc rule is added to the
bridge before adding any port to it. Which is more likely to result in
buggy user experience, because it doesn't say anywhere that there are
restrictions to the order in which things should be set up.

Personally, I would first try to ask for help, as some work was clearly
put into the indirect flow block offload, and the reasonable expectation
is that the filter replay (and not just the bind/unbind) works on
register/unregister, yet for some unknown reason it doesn't.

Then, if I get no answer/help, I would consider as an alternative
implementing the flow block binding logic in the bridge, and
re-notifying the relevant stuff through switchdev. Via this
SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RCV we're talking about - hence the
reason I'm mentioning it. After all, the flow block binding code is
mostly bloatware, so we can reduce the duplicated code switchdev drivers
have to write.

But I wouldn't consider leaving this up in the air if there is a
non-complicated way to address it, which it seems like there is.

So in short, let's discuss what's optimal overall only when we see an
implementation that fully works, ok? It was my mistake to point out
during review minor optimizations that could be made even if they don't
follow the overall direction that the patch set should go in.
