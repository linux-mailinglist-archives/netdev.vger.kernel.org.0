Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BF3633C9C
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbiKVMhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbiKVMhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:37:13 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65505B849
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:37:08 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id n20so35605574ejh.0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6OWh7dv+Xs7Q8OFYOdx0oezdZtrniwlSgCEDTQrHkL4=;
        b=zmxlL3kwjqz8VihILxYCHo9B/feHbzoKggP0EyQICup5w2nY5j899qeJZWAGPME6aW
         Jmeazw6WpvMBWz+1cpIoDF9dC5CHuIaciwjqOE40nMFHdTTMkcwYoelkqOeAsja/v9mF
         B7RnMwDsT+TxmamuY2DUxXiju7aC3xqWCetY/Y7Ic0LWIbwG9mDAEZibHO1PufXxXzZr
         U77NSc6IoPESBEyb0WbG/rP0yPx5+pFmvp65nyFGknNqQzF4hEj/d/rr+IXhDO2YQ+Zg
         PNnP0n37G9vrj4dczWsmV1EYHTSm5EY41RxBFJSr+gd1fLG97I6Rlo0TMdmdzR3kQh53
         VBAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6OWh7dv+Xs7Q8OFYOdx0oezdZtrniwlSgCEDTQrHkL4=;
        b=BBiCEvTqHsebLW3WOW4Aho8UUaV35Japo7LMslXhdY41TRRVuybMw/WCQOSVfRMDqQ
         vaKPPuLl4SKMxoyCmizuXwMTXopy0rGIywKwzyMUOSABeRyiE/mnVxNGJTd3gwb8eYX2
         9ucZZ5Y283uDUd6L/ESK2qKIeJ7j/8MDYBsd8wBQHBSEHfguAS+yvbwuQlGF/DN1YZ5o
         t7fHGU1wbfBjdKyn+Au5tUpkrCo8dIt4owi9xxVxNC0H+TwB2CDLBiyZQEa4IslDspJp
         UCSisxNRGICtrcbgouwxAgFAdM1VCkq0N0y5fgrDiYoM666T96YT0FhFY0jjGyNI84EQ
         qM1Q==
X-Gm-Message-State: ANoB5pkgTVYh79qCwFMOPQ57pmrPKd/zU2oWdGfQZtOBA99FTmruZyDe
        hYU2fZhG8fdpLzc/9zwQZXm8yQ==
X-Google-Smtp-Source: AA0mqf6LVumkohilyMyIwh6Kxflhmmu2gbEbVIbJpr6cJ4s56FngkY5eEFiMyTBeE2SxZ74ff99cgw==
X-Received: by 2002:a17:906:a155:b0:7b5:576e:b7d6 with SMTP id bu21-20020a170906a15500b007b5576eb7d6mr10047921ejb.127.1669120627155;
        Tue, 22 Nov 2022 04:37:07 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e12-20020a1709062c0c00b0073d7b876621sm6003985ejh.205.2022.11.22.04.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 04:37:06 -0800 (PST)
Date:   Tue, 22 Nov 2022 13:37:05 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [patch iproute2] devlink: load ifname map on demand from
 ifname_map_rev_lookup() as well
Message-ID: <Y3zCca4L2KU/p50D@nanopsycho>
References: <20221109124851.975716-1-jiri@resnulli.us>
 <Y3s8PUndcemwO+kk@nanopsycho>
 <20221121103437.513d13d4@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121103437.513d13d4@hermes.local>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 21, 2022 at 07:34:37PM CET, stephen@networkplumber.org wrote:
>On Mon, 21 Nov 2022 09:52:13 +0100
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> Wed, Nov 09, 2022 at 01:48:51PM CET, jiri@resnulli.us wrote:
>> >From: Jiri Pirko <jiri@nvidia.com>
>> >
>> >Commit 5cddbb274eab ("devlink: load port-ifname map on demand") changed
>> >the ifname map to be loaded on demand from ifname_map_lookup(). However,
>> >it didn't put this on-demand loading into ifname_map_rev_lookup() which
>> >causes ifname_map_rev_lookup() to return -ENOENT all the time.
>> >
>> >Fix this by triggering on-demand ifname map load
>> >from ifname_map_rev_lookup() as well.
>> >
>> >Fixes: 5cddbb274eab ("devlink: load port-ifname map on demand")
>> >Signed-off-by: Jiri Pirko <jiri@nvidia.com>  
>> 
>> Stephen, its' almost 3 weeks since I sent this. Could you please check
>> this out? I would like to follow-up with couple of patches to -next
>> branch which are based on top of this fix.
>> 
>> Thanks!
>
>David applied it to iproute2-next branch already

Ah. Okay. Thanks!
