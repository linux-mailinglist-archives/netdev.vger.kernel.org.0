Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10E04FDB95
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244349AbiDLKFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356209AbiDLIJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 04:09:13 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68B7218
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 00:40:01 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id r18so7341193ljp.0
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 00:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=WtbGB7L0QDeE2I+go9zw8Bu1CtyCG18Co3yY1iUrMXY=;
        b=ZaEFBW4EII8WzlwhSzf+zKPxIRzg6pI962lGZG1WVyYyLaE2cWSS01DKRa0p7ADOkP
         NL2TyoCJnBBV+UPo4GSFISlTwDlNFNsoyohFLDRN04udEoN2euT4a5ep2pPgMeJQifl1
         CE2F4c8Fgf0dWkUYXcMRKIa4jwu15X8upnIDHH6RUFz4pglwbYf3t7ySCjN6bWS0SoWC
         MXhULNYOryUu4uB2xQp3PmgZpBuo8jL5xq1U1OUWTjI973ld/vSPFIGuLXdbIJLSddIc
         0FbIdqjCM1tm1ryeUdI/B9/V3hg4fWAjxCpzjRSh8SaqxLwQu9G1Jt/vl6gFa2glKhON
         Befw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WtbGB7L0QDeE2I+go9zw8Bu1CtyCG18Co3yY1iUrMXY=;
        b=m/85vgneOGrbcL7RNryX+lREok8+xUIP2qAD0VQALLD5SXCdl60zXe2na+D6b7+YK3
         JmyTolHu6ZGhiQufuR6hlFMRwWzjM8/YgCIgdnwssOLOat33qxCvT6Ty5JtQwBjWWzpD
         nhk423Aqm1K8OI06KbMkX4FFNNHoJDFXPQqvN8PtJ7nxTNIC0wcshAEAEfAv/cAAIn6X
         ygf6N57rEZ929+YSYGviIwgBZ1JF7/Pf8ykv9C3Zt9N4uxl6CMMp+WPUFswoUtCiBung
         sRu73yRV7FNXpa0krSRtRLPFFTaa0LeCk58bgIsP8kg+zS0hu5RTzdBBMmMh0zghyrQa
         XcLA==
X-Gm-Message-State: AOAM5303w6iQSG269QOvfHDvcCGV8OrV9jC3MeMk2QE4daABeuz2J93+
        F0uBQuhHbyUHB49gG9VDtHoFAB0Nj6nkB4qi
X-Google-Smtp-Source: ABdhPJzxjMniQYaT1ojKhxYXcF6wHOJPF+5Rck6NQj04F5+jVrXSytn/eFveVIMV0Mhql01RgHzFXA==
X-Received: by 2002:a2e:b989:0:b0:24a:d5a0:bfaf with SMTP id p9-20020a2eb989000000b0024ad5a0bfafmr23016573ljp.513.1649749199713;
        Tue, 12 Apr 2022 00:39:59 -0700 (PDT)
Received: from wbg (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id o19-20020a056512053300b0046b51022557sm1396821lfc.232.2022.04.12.00.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 00:39:59 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge\@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH RFC net-next 05/13] selftests: forwarding: add TCPDUMP_EXTRA_FLAGS to lib.sh
In-Reply-To: <20220411172042.prh3hy7ehpc5o34f@skbuf>
References: <20220411133837.318876-1-troglobit@gmail.com> <20220411133837.318876-6-troglobit@gmail.com> <20220411172042.prh3hy7ehpc5o34f@skbuf>
Date:   Tue, 12 Apr 2022 09:39:57 +0200
Message-ID: <87k0bubvhu.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 17:20, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> On Mon, Apr 11, 2022 at 03:38:29PM +0200, Joachim Wiberg wrote:
>> -	$ns_cmd tcpdump -e -n -Q in -i $if_name \
>> +	if [ -z $TCPDUMP_EXTRA_FLAGS ]; then
>> +		extra_flags=""
>> +	else
>> +		extra_flags="$TCPDUMP_EXTRA_FLAGS"
>> +	fi
>> +
>> +	$ns_cmd tcpdump $extra_flags -e -n -Q in -i $if_name \
>
> Could you call directly "$ns_cmd tcpdump $TCPDUMP_EXTRA_FLAGS ..." here,
> without an intermediary "extra_flags" global variable which holds the
> same content?
>
> You could initialize it just like the way other variables are
> initialized, at the beginning of lib.sh:
>
> TCPDUMP_EXTRA_FLAGS=${TCPDUMP_EXTRA_FLAGS:=}

Ah, yes of course.  Will fix in the next drop!

 /J
 
