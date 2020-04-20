Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084151B0E0E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgDTOO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727905AbgDTOOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:14:25 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5857DC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:14:25 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id u13so12383247wrp.3
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xI2JaVzV5j13dnYS8FpAAt0D9/yzYpNBAOL6NLN+nOI=;
        b=moEwSuinh8p0wHS2yuO3sqKtegOJKOjKii1BkEFkGaT8WhrL90grxzNefYN5CkV96U
         UvRw5c55Bkj0CZl9fq27XlcNPB8O8GZvkwPx6eCTEJnY8ThxAteoud/ulUgLK2bNSAKD
         Q1SX+Aa1nNn6MvZ4/IPdZVB5VGSXWGm3OT02GmBowUKMEJVhGfi/F70JqHYiwUgHPGY6
         H7CNDfRo+NNG1oKdWpvQiRveCetumNe9TQR858IC0h7ezg+5ADPMsm9ZvKFr3BzRVcod
         xrRgd6EyOEoaayDCOjfunoJ0niZ6kgEzVEPjWuCbZr+rxGKgvPjCPgzKrcHZ3wfEsoWT
         qHzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xI2JaVzV5j13dnYS8FpAAt0D9/yzYpNBAOL6NLN+nOI=;
        b=Eeyu50SKZOUvvGZdjizyEhrR1TGhdhSZNJNKfE8mCKmPFA+6aeVBBoA5nvOifMc0Xc
         g8bCQSR9/J5BUzkrvlY3B1QmQ9k3Pjn98riRltiFNQOj4qmeO+NIrUQC3M1sbdpa+EfG
         e1qta8FMUFLpFskpu8EQE5aga0sS3w+X5b7U2b7sgu5DQjjUvazWXza/ifZB/qiccQPM
         ltuy9W2/JM+ewEytmL6VRTfM2yeljdFb7oT7cUJGcA7vm9abUVoM2Qj7e62jKqB7pp5+
         H+2t+iC0eNDsd1NUAgrBy1r2pUtbFtZuJ70Ko/QBJWbtZ8502ZFiQDBWWuzeD+XA4dyE
         JRig==
X-Gm-Message-State: AGi0PuYQ9RVOOtyBylpIatUIeRH+V8+GKTiSwn1ifIi54weWDHlyTU81
        uBWV/1hOPtAfQn1+eY2G6SM3QQ==
X-Google-Smtp-Source: APiQypJqJbSLrNOl6ke4lkTcgYa8/XauIoBjRulAFuhy2H2VQdbONOUAbDWigs6GpsKezx15agTEIg==
X-Received: by 2002:adf:978c:: with SMTP id s12mr16250853wrb.312.1587392064072;
        Mon, 20 Apr 2020 07:14:24 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a1sm1421372wrn.80.2020.04.20.07.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 07:14:23 -0700 (PDT)
Date:   Mon, 20 Apr 2020 16:14:22 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Edward Cree <ecree@solarflare.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
Message-ID: <20200420141422.GK6581@nanopsycho.orion>
References: <20200419115338.659487-1-pablo@netfilter.org>
 <20200420080200.GA6581@nanopsycho.orion>
 <20200420090505.pr6wsunozfh7afaj@salvia>
 <20200420091302.GB6581@nanopsycho.orion>
 <20200420100341.6qehcgz66wq4ysax@salvia>
 <20200420115210.GE6581@nanopsycho.orion>
 <3980eea4-18d8-5e62-2d6d-fce0a7e7ed4c@solarflare.com>
 <20200420123915.nrqancwjb7226l7e@salvia>
 <20200420134826.GH6581@nanopsycho.orion>
 <20200420135754.GD32392@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200420135754.GD32392@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 20, 2020 at 03:57:54PM CEST, fw@strlen.de wrote:
>Jiri Pirko <jiri@resnulli.us> wrote:
>> Mon, Apr 20, 2020 at 02:39:15PM CEST, pablo@netfilter.org wrote:
>> >On Mon, Apr 20, 2020 at 01:28:22PM +0100, Edward Cree wrote:
>> >> On 20/04/2020 12:52, Jiri Pirko wrote:
>> >> > However for TC, when user specifies "HW_STATS_DISABLED", the driver
>> >> > should not do stats.
>> >>
>> >> What should a driver do if the user specifies DISABLED, but the stats
>> >>  are still needed for internal bookkeeping (e.g. to prod an ARP entry
>> >>  that's in use for encapsulation offload, so that it doesn't get
>> >>  expired out of the cache)?  Enable the stats on the HW anyway but
>> >>  not report them to FLOW_CLS_STATS?  Or return an error?
>> >
>> >My interpretation is that HW_STATS_DISABLED means that the front-end
>> >does not care / does not need counters. The driver can still allocate
>> 
>> That is wrong interpretation. If user does not care, he specifies "ANY".
>> That is the default.
>> 
>> When he says "DISABLED" he means disabled. Not "I don't care".
>
>Under what circumstances would the user care about this?

On some HW, the stats are separate resource. The user instructs the
stats to be disabled so safe resources. It is explicit. He like to safe
the resources for other usage (he can list them in devlink resource).


>Rejecting such config seems to be just to annoy user?

Well, the user passed the arg, he should know what is he doing. There's
no annoyment.


>
>I mean, the user is forced to use SW datapath just because HW can't turn
>off stats?!  Same for a config change, why do i need to change my rules

By default, they are on. That is what user should do in most of the
cases.


>to say 'enable stats' even though I don't need them in first place?

It may require to program HW differently (as in case of mlxsw).


>
>Unlike the inverse (want feature X but HW can't support it), it makes
>no sense to me to reject with an error here:
>stats-off is just a hint that can be safely ignored.
