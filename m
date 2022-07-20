Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6C557B4C8
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 12:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239021AbiGTKvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 06:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238678AbiGTKvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 06:51:38 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FE54B4B4
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 03:51:36 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g1so23206362edb.12
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 03:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XvkB9zin56rfzIq4R1MRybLcAMqcCGMvDQA6u/hFrnE=;
        b=ADZsSISJLDvXnhPSwNKwJFmhBCrm50aqWBhymCe/0rq36Bd+pMUq9XfXgSIaqMAQbz
         8IDu5esYUwzz5ttqFK0f+lyRNEcgM2RVJEG4DjAbkK30+uJGUidiTyT7XzVbI07Aeyo+
         z3Y8zhcJJIzjKLG4xW2sGx6bbbGbFzrFczpLCCQ5P7xPPKi9h/7rrbtFsstljEzBTFXk
         WWNx66icqVa5hxnmFbQ9HBrWH5Rw1e31FP4VMo49hJJb81TmnSsutX1jX6wcwbzEBxaR
         mJ07c8NoOPjJjgPoUNRAkeWA5jJEn+YqhRYIkMlXWGklNjNO9YLI4Sg/63ttFZdPBnN5
         ABug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XvkB9zin56rfzIq4R1MRybLcAMqcCGMvDQA6u/hFrnE=;
        b=nVCym6ljALBlb1w4UmDbTDLHxOxLOZgfHNOE95mPiNw9Q7OMsjhMbdlPGDAc7wN4EA
         9I6I/xPLDRPvz5lPPjlrB1lfnKbruPe1eupGI3okd+aE/ES2OARqUEzwZXPF1agkQE9i
         /zqVxbEsysFJMmmg7/ALKpy/PSN9taYjfvutitTlI0ZziWI6eTdmpF/v+l8hm/lruGui
         G94ZUh6l1aTCCWPFTCfrHOZKgNikSd1Q4xE36MmV7iWzvWKAmqHOqZohmJWfp7OuX2Aq
         L4oZ13pi1Dn1X2bxRGn4e5cIfzEEO9edk3HFf4X8Y9sxN6G7NRAxExQmoZI2iL/TKmIR
         sd+Q==
X-Gm-Message-State: AJIora+rJptnrlReSBMPpm6uRsvQxfnMLE/k5+D84UTttfkjX1xuD/Ns
        7UzTsxKsC4ucyl4c/J1Z9cPDBw==
X-Google-Smtp-Source: AGRyM1uGfcA7n87wZOG9JMyPEfH82gE31WaBVdvoeRs/QD+66lkw9Gr/xdauq7Hlgiv2JG2DQJ/OMA==
X-Received: by 2002:a05:6402:3486:b0:43a:9b82:6d8a with SMTP id v6-20020a056402348600b0043a9b826d8amr51437527edc.23.1658314295386;
        Wed, 20 Jul 2022 03:51:35 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id qn17-20020a170907211100b0072af890f52dsm7765952ejb.88.2022.07.20.03.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 03:51:34 -0700 (PDT)
Date:   Wed, 20 Jul 2022 12:51:33 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 07/12] mlxsw: core_linecards: Probe
 provisioned line cards for devices and expose FW version
Message-ID: <YtfeNeebi04zcbs4@nanopsycho>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-8-jiri@resnulli.us>
 <YtfHgvf7ZRg3V2EA@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtfHgvf7ZRg3V2EA@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 20, 2022 at 11:14:42AM CEST, idosch@nvidia.com wrote:
>On Tue, Jul 19, 2022 at 08:48:42AM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> In case the line card is provisioned, go over all possible existing
>> devices (gearboxes) on it and expose FW version of the flashable one.
>
>I think this is a bit misleading. The FW version is only exposed for
>line cards that are "ready", which is a temporary state between
>"provisioned" and "active".
>
>Any reason not to expose the FW version only when the line card is
>"active"? At least this state is exposed to user space.

When it is active, the ready bool is still set. So it is "since ready".
