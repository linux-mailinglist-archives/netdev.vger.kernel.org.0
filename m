Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916B84D095A
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 22:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242765AbiCGVbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 16:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236560AbiCGVbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 16:31:19 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39BF4A911
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 13:30:23 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id s18so1972934plp.1
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 13:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IpTgnM4Pf3JHxHCnyphPQdqSOn8hesc03v808EjKQew=;
        b=jZmYFC4kcPxANCZzAYAsDKFRgfLrCC6IxiD8EnNjO7i2NyIoDgQYqutapuT3uNNZgI
         BByuTyT0s+VfRvEZKR+YQO2P4B62gurbhQpT5uGjoeiKH5EP+UADFmSPyGrgK/B7yHdY
         SCvs3FJwuikBF21VuL02eLDwS4urvqt8+f7GCa7E/Zdngc7Xc/HPisBrzn8WpiLUEPHD
         q5ACQ3MS/zIY+p3ckC7Vhrt3pOAU1UG75KT5y3nmSyEUrjVTEMcToRZmXP13LqXddcWj
         8dQhickbceQc8Kw5ZSA26HO0lUFv1gE+eSQ4UJ8xPDUnNmeF1KbOx32hyH5AFqLobEiC
         Q9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IpTgnM4Pf3JHxHCnyphPQdqSOn8hesc03v808EjKQew=;
        b=Omy2IZOwe5Kn+S0OIvdAdROn5upt1eCSgn7kaTCqUdRT4zrE8e8cBfnvSIkr0UTJZR
         8pvdnZFkuWERGQ4MUK1STxVJo1yRrAnXmSs+1etGmylGG2V/0/1WE794ZikHH6pc17Vd
         Cqq4yx+gtcqnzt0io4Bmnn/m7HOXDKyxewRmxy8ELXYymxVTVb58oQAXRbG/VWelhkvp
         vI9fjrGNGJHovyaIthCboSBc9Um9ghgxUasOjvlslX70Cj+f4oYZGOMPAECv7cCvxQRQ
         x111RNHqgOJ+Lf17HIIBdwseu6hOUSCqn6wRKMqZSy2uixb3onAs+qsKRkDvcD5TtTds
         AIdA==
X-Gm-Message-State: AOAM531MS3hzkPWEg6S5Kt3vGDW8IXBNVxKrsdAJtsPajpE1bJcHDa+S
        ygnHyjidarlNy1gFFRrx4tU=
X-Google-Smtp-Source: ABdhPJzReLTTzZE4uIj2Mg5qClgiUO8G9r0TuUrq2j/P7+R1zI9PfYLaJwhCBnIMuvnzOFi4XwKIEA==
X-Received: by 2002:a17:90b:4b4f:b0:1bf:3661:b47b with SMTP id mi15-20020a17090b4b4f00b001bf3661b47bmr1016843pjb.201.1646688623169;
        Mon, 07 Mar 2022 13:30:23 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id i15-20020a63b30f000000b003803aee35a2sm4583999pgf.31.2022.03.07.13.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 13:30:22 -0800 (PST)
Date:   Mon, 7 Mar 2022 13:30:20 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
Message-ID: <20220307213020.GB4490@hoboy.vegasvil.org>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220306170504.GE6290@hoboy.vegasvil.org>
 <CANr-f5wNJM4raaXrMA8if8gkUgMRrK7+5beCnpGOzoLu59zwsg@mail.gmail.com>
 <20220306215032.GA10311@hoboy.vegasvil.org>
 <20220307143440.GC29247@hoboy.vegasvil.org>
 <CANr-f5zyLX1YAW+D4AJn2MBQ8g7e8F+KVDc0GuxL7s9K89Qx_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5zyLX1YAW+D4AJn2MBQ8g7e8F+KVDc0GuxL7s9K89Qx_A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 06:54:19PM +0100, Gerhard Engleder wrote:

> ktime_to_cycles uses hwtstamp as key for the cache lookup. As long as
> the PHC is monotonic, the key is unique. If the time of the PHC is set, then
> the cache would be invalidated. I'm afraid that setting the PHC could lead to
> wrong or missing timestamps.

"Wrong" timestamps happen with normal PHCs anyhow.  Not a big deal.
Your driver can drop the cache and force racing vclock frames to omit
the Rx timestamp.  User space must deal with this in any case.

> For RX both timestamps are already available within skbuff, because they are
> stored in front of the Ethernet header by the hardware. So I have to find a way
> to detect the RX case and copy the right timestamp to hwtstamp.

This works for your driver, but not for the generic vclock.  Maybe you
could let the ptp_convert_timestamp() method pass the skb back into your
driver.

Thanks,
Richard


