Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BE75BD6FB
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiISWOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiISWOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:14:50 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A0E6440
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:14:49 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id e17so1215052edc.5
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=R8pPTvK/srm3s9K4dpdEpc5zT9WW46AxDGqqi5KOsBs=;
        b=eWbWBALK7PQjW7+IZ6Y5RISeZqCq8/OLd6n34chdjR2LRg90QScosS7qIqVBamZcU4
         J1W3GtFaFKM4omg6W1GrqofIeJJQDeMJizOM1zG/DMuwEDT+WGcZ8rxZ86XS24xJhZ3N
         cBAPe0zma1Nugle26GP14eTpSC08pK185mEwTWLnMD3eO/Exc5vEv9BRk8qmADrP2G41
         RaITt0grmVQeGqelIT5+ly9y+49NnLzEEH5udDjfodUdl/MbwpQ7Cv1ZkjpStmZgp2bu
         ze5YbY4dKsq+xLYaSl1xzAfoa+hJVr/rZSp4qQJ/0/jyj8XJFebeNxnyfvqc+LG82Sn6
         reYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=R8pPTvK/srm3s9K4dpdEpc5zT9WW46AxDGqqi5KOsBs=;
        b=uiRGz3SLlHZ1Xy993mQKFQ12ywSJlgdsujTiTa/2yv4AOduS/fsux5fTyfj+o1pqgb
         +94odFyHCJ6AT9DApONemPazhv1yG4miviixhqyOpK0k86q34N34TiMtoqU3dLwkleGz
         XK9Ab6MlQcCPtohECrJUJD9+/NnweNJ6PnapNOA9MgzPbU8RSH344MW0UmG9Fw7Df2i6
         36lBKt1HRCuK9bh5+3WdMnjRaXMvvieh+BJFlWEHMHGrpBJF6c3RsHAUD1iTFhv3lFIk
         2JOkh+m0ygerT53NrJvkvYReUu2FkMdH6+iwK8yJuxhVm/1NRYK2yNVU/iGHmZCGe4Xe
         jSRw==
X-Gm-Message-State: ACrzQf1MSj12GhLYTjXG1rIGQ9h5qrHhIPz/1t4hVRA4IHUBW1T6OyQ2
        27IDtTnSvEsa0auJz//y6IH2Pnt0Z2FxLME1
X-Google-Smtp-Source: AMsMyM4/lf+j3fVddLT3RbE7U/xlJoXPFsPFbCeK6ke5GDwovI7/TCuOnnavJinjAW9AsI8jx/8VaQ==
X-Received: by 2002:a05:6402:3718:b0:453:a46c:386c with SMTP id ek24-20020a056402371800b00453a46c386cmr11578901edb.97.1663625688262;
        Mon, 19 Sep 2022 15:14:48 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id cf10-20020a170906b2ca00b007402796f065sm16249210ejb.132.2022.09.19.15.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 15:14:47 -0700 (PDT)
Date:   Tue, 20 Sep 2022 01:14:45 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v14 2/7] net: dsa: Add convenience functions for
 frame handling
Message-ID: <20220919221445.a7gypaggf2wmnf5i@skbuf>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-3-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919110847.744712-3-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 01:08:42PM +0200, Mattias Forsblad wrote:
> +int dsa_switch_inband_tx(struct dsa_switch *ds, struct sk_buff *skb,
> +			 struct completion *completion, unsigned long timeout)
> +{
> +	struct completion *com;
> +
> +	/* Custom completion? */
> +	com = completion ? : &ds->inband_done;
> +
> +	reinit_completion(com);
> +
> +	if (skb)
> +		dev_queue_xmit(skb);

Does it make sense from an API perspective to call dsa_switch_inband_tx()
with a NULL skb? If yes, please add a comment explaining why. If not,
please delete this check.

> +
> +	return wait_for_completion_timeout(com, msecs_to_jiffies(timeout));

If this is going to be provided as a DSA common layer "helper" function,
at least make an effort to document the expected return code.

Hint, wait_for_completion_timeout() returns an unsigned long time_left,
you return an int. What does it mean?!

At the bare minimum, leave a comment, especially when it's not obvious
(DSA typically uses negative integer values as error codes, and zero on
success. Here, zero is an error - timeout. If the amount of time left
does not matter, do translate this into 0 for success, and -ETIMEDOUT
for timeout). If you're also feeling generous, do please also update
Documentation/networking/dsa/dsa.rst with the info about the flow of
Ethernet-based register access that you wish was available while you
were figuring out how things worked.

> +}
> +EXPORT_SYMBOL_GPL(dsa_switch_inband_tx);
