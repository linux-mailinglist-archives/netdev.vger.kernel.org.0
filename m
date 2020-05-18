Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6791D8009
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 19:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgERRZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 13:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERRZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 13:25:45 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69064C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 10:25:45 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id v12so12757288wrp.12
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 10:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=J5ffYvEH8bNwgNYEaAn2txd6UgSX2w7wySa1YgxATfM=;
        b=dQ2OM/XqJdRvlfPx63JNYhTTEQ6h8wlT/v9E5ZXoH1qhldgJZIXIcqtbaFQftTSoMX
         lN2Ghl5IRwVya+zS4R6pHOoFPc4rBX9cMKzUqlVQUJPek2Ho4KGi01JcCEZvgp00ijqm
         ncIxmufVzTwfdBExWcGdcdmCtglEYTBjJJaUFKbN0eELwU+CQ8F+nxiE1BFyzkzx11Um
         YSOnpG+TOWcdtuHxhSrr06OR7wAqDQqttSIvReyiyms0P4Xu8fvaXDbAfv90d0Jin7AK
         r92eyhR2V8xWnpjK/jQ2zItIxC5Xo84poEIwA43H5VbQEo2TVA1VrAOaMcp4kj+9TA6l
         jmeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=J5ffYvEH8bNwgNYEaAn2txd6UgSX2w7wySa1YgxATfM=;
        b=Q8cj7RS1513aGirOo4gG2JJgVgHCM1nX/YH2bVxkkJePmPSeu00tGapEMC8gL45R12
         +PDd32S0B/Zvtl7oGorF/EVrxpPGAvmW11aJDtUuHg0tCjdBkCpg0gW+Xj3k0wjyNhkI
         jt6x0y4NkIyRvccfPJ5N0xEhKakMIKJZWr5NkSIVAImZ8OwH36GTnjjWtKduipcy9aP2
         zQo4ooRY6gVywBCxOnJJuUE3UK103OcoLb3a2WiNkL+CBzzmSGDnmDdd0pTkn4tVO0s5
         7Xa7h9OB1WAXkIeXDQBOMlo718i3MqvIi08ZIlz1gTeZTSDGNkHN86RWqec0ckJTx6wm
         9Few==
X-Gm-Message-State: AOAM530P8OMq4enCNmcagSi370cDnN/r08Jkh/yXBkZrzt0PKKxM5v7x
        tOzQexfh5h/6PeX0yjbdkK+EBA==
X-Google-Smtp-Source: ABdhPJxfc5SPxPNadGHkyZhnd+wsx526oYU4P6ol99ZxqPgBaIRixiNL+hNC96mJ44Zl0JHg7dgofA==
X-Received: by 2002:adf:dc86:: with SMTP id r6mr20175905wrj.45.1589822744098;
        Mon, 18 May 2020 10:25:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id m7sm251739wmc.40.2020.05.18.10.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 10:25:43 -0700 (PDT)
Date:   Mon, 18 May 2020 19:25:42 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next 0/3] net/sched: act_ct: Add support for
 specifying tuple offload policy
Message-ID: <20200518172542.GE2193@nanopsycho>
References: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
 <3d780eae-3d53-77bb-c3b9-775bf50477bf@solarflare.com>
 <20200514144938.GD2676@nanopsycho>
 <9f68872f-fe3f-e86a-4c74-8b33cd9ee433@solarflare.com>
 <f7236849-420d-558f-8e66-2501e221ca1b@mellanox.com>
 <64db5b99-2c67-750c-e5bd-79c7e426aaa2@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <64db5b99-2c67-750c-e5bd-79c7e426aaa2@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 18, 2020 at 06:48:46PM CEST, ecree@solarflare.com wrote:
>On 18/05/2020 17:17, Paul Blakey wrote:
>> But we think, as you pointed out, explicit as here is better, there is just no API to configure the flow table currently so we suggested this.
>> Do you have any suggestion for an API that would be better?
>I see two possible approaches.  We could either say "conntrack is
> part of netfilter, so this should be an nftnetlink API", or we
> could say "this is about configuring TC offload (of conntracks),
> so it belongs in a TC command".  I lean towards the latter mainly
> so that I don't have to install & learn netfilter commands (the
> current conntrack offload can be enabled without touching them).
>So it'd be something like "tc ct add zone 1 timeout 120 pkts 10",
> and if a 'tc filter add' or 'tc action add' references a ct zone
> that hasn't been 'tc ct add'ed, it gets automatically added with
> the default policy (and if you come along later and try to 'tc ct
> add' it you get an EBUSY or EEXIST or something).

Is it worth to have an object just for this particular purpose? In the
past I was trying to push a tc block object that could be added/removed
and being used to insert filters w/o being attached to any qdisc. This
was frowned upon and refused because the existence of block does not
have any meaning w/o being attached.

What you suggest with zone sounds quite similar. More to that, it is
related only to act_ct. Is it a good idea to have a common object in TC
which is actually used as internal part of act_ct only?

To be honest, I don't like the idea.


>
>WDYT?
>
>-ed
