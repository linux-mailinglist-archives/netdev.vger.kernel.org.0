Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB36B1B0D30
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 15:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgDTNrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 09:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728669AbgDTNrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 09:47:01 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082B9C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 06:47:01 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id i10so12210780wrv.10
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 06:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wsWgognXkyEJT1UIvmcDrn43yqBK6KfpyRr4ELdxHLo=;
        b=NIQ9BU39Vshvp4ydGcxXnwAf6LUP9oZUY+WCnL/Hug7lGBZDZNWZEhNY8WAXLLp/oW
         kOgKvwm2RN6CzhE5/DUFTnDdPEAgMEG+bTWhqRHUpxvBeciS7F314OWKeCilM7g9hPdG
         MswvHrKeEc7wnjFxzRB+ipduMRa2NwX6vc8x165alb2lNdC4E81KXEI3E+noLAr/4Uuc
         vyJMvH4azWbmVBNt+WRUJ2PSxNnTt/pyLixwDLIT1sy3HN1PQthkQYX/3DZ/7J9dM6Yx
         SCa8w7+S0TGOkFOOC208oqq5vqJM8CoU41mrZ2m2HkZT2bijP6hrq/L1PFdmEPhlE40c
         JkUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wsWgognXkyEJT1UIvmcDrn43yqBK6KfpyRr4ELdxHLo=;
        b=dgHOkdFPbZ+fdetKgp41Lnjw04IqEF4UbdwBM9wkoggQGngk7MQwfFnvOcZ9872Tvo
         gWZh2qwQg49tgRl7K7C9T62nmHWe1uwrdqZrqUPLBrOrcp/qVz/vIw+AIWBVv1HfBeVr
         svIChNJGLTlpKULHnEM0HikyrXqb4J3FWJmpXkAbf1HOV9Mw2bbSmFlMZKWKVUq9cWTG
         U2SEdj7jvBGtwr952yqZWeC6SqxcqBEL0M0Row7bRuXeVPWq30NDtkDXnqSevYXRc7A2
         fnOQMb3b+yTCXFZ4lngdt258B57AFD2kddRYq+/qUIeMZYwIPKrsH8wxFk8VWS8mML7t
         soJg==
X-Gm-Message-State: AGi0PubYPAv4qvXBqJVLDd5QbXi/iHRYqCrVG5aehcQYc/Lq9lCQU1w1
        imJVVVd2l06cEk//t3kRpbE+9w==
X-Google-Smtp-Source: APiQypI+W4U++M8rNtI/PTdscoRv7/dm15wL156InxCAV+pfAxNvwvTqVp2tjfeIuaqKBiDNctPgcw==
X-Received: by 2002:a5d:44c6:: with SMTP id z6mr17989985wrr.192.1587390419821;
        Mon, 20 Apr 2020 06:46:59 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 60sm1352411wrr.7.2020.04.20.06.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 06:46:59 -0700 (PDT)
Date:   Mon, 20 Apr 2020 15:46:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Edward Cree <ecree@solarflare.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
Message-ID: <20200420134658.GG6581@nanopsycho.orion>
References: <20200419115338.659487-1-pablo@netfilter.org>
 <20200420080200.GA6581@nanopsycho.orion>
 <20200420090505.pr6wsunozfh7afaj@salvia>
 <20200420091302.GB6581@nanopsycho.orion>
 <20200420100341.6qehcgz66wq4ysax@salvia>
 <20200420115210.GE6581@nanopsycho.orion>
 <3980eea4-18d8-5e62-2d6d-fce0a7e7ed4c@solarflare.com>
 <20200420123611.GF6581@nanopsycho.orion>
 <20200420124920.j3edwvc5fwobqhyg@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200420124920.j3edwvc5fwobqhyg@salvia>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 20, 2020 at 02:49:20PM CEST, pablo@netfilter.org wrote:
>On Mon, Apr 20, 2020 at 02:36:11PM +0200, Jiri Pirko wrote:
>> Mon, Apr 20, 2020 at 02:28:22PM CEST, ecree@solarflare.com wrote:
>> >On 20/04/2020 12:52, Jiri Pirko wrote:
>> >> However for TC, when user specifies "HW_STATS_DISABLED", the driver
>> >> should not do stats.
>> >What should a driver do if the user specifies DISABLED, but the stats
>> > are still needed for internal bookkeeping (e.g. to prod an ARP entry
>> > that's in use for encapsulation offload, so that it doesn't get
>> > expired out of the cache)?  Enable the stats on the HW anyway but
>> > not report them to FLOW_CLS_STATS?  Or return an error?
>> 
>> If internally needed, it means they cannot be disabled. So returning
>> error would make sense, as what the user requested is not supported.
>
>Hm.
>
>Then, if the user disables counters but there is internal dependency
>on them, the tc rule fails to be loaded for this reason.

User asked for disable. They should be disabled. If driver does not
support it, should not pretend they are disabled. Does not make sense.


>
>After this the user is forced to re-load the rule, specifying enable
>counters.
>
>Why does the user need to force in this case to reload? It seems more
>natural to me to give the user what it is requesting (disabled
>counters / front-end doesn't care) and the driver internally allocates
>the resources that it needs (actually turn them on if there is a
>dependency like tunneling).
