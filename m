Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A968519AF8
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 10:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242434AbiEDI7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 04:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346631AbiEDI5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 04:57:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CA1125EAD
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 01:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651654383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7DfIcsOTB6mqPbbGYMVcOJUBywehrsvBjbW97FzGQuA=;
        b=RXs1B0QJh2w6dq+utLwr7HSVYnGU+d1A8d/WIxjcQAzyqCg1MhQSFdw3v8Y+CpUTzwAJaW
        1aMr0lPig9SSF6AtTedS1K16Jd+I9iG4NM9uU/m3zuygFRwuuChotwvxeb7y+66dGK/iFz
        qZpGSB3K0YKvWDo8SBu8EPZZa3BX230=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-r5wduM1-M3i9qQE4t3bCzA-1; Wed, 04 May 2022 04:53:02 -0400
X-MC-Unique: r5wduM1-M3i9qQE4t3bCzA-1
Received: by mail-wr1-f71.google.com with SMTP id j27-20020adfb31b000000b0020c4ca11566so154772wrd.14
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 01:53:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7DfIcsOTB6mqPbbGYMVcOJUBywehrsvBjbW97FzGQuA=;
        b=nHrtG46PLzzqkZVxJRkOoBemkI1i262GhrHfXdG+RDykx/sirr1LVw8HajwqM4C+gn
         5x/Zf1ypO7aEe5SviEQ6KS4W1wHIc+OSHoJ4KdB1DEaQsjt/SFR5eXQPAhDV+FuZGUwe
         HEFQakkzEYkP2z7DWqvz6AwucqPXzCPmW3BhXp8mHvto6dFj7Io6pwozwQBm4dPEJsQg
         k2slgLOJVsRyyVYD6EhyBOIpsKsuSPojQjxMS+TsMiERb7hVacKIUqv0a9Ohc3PFcXIf
         tUGvT2hKTYz8U9PEpRfX53nmzftOf4PhMg9kZ8mnYvbbdrP6SNrNtUhBhDa/XUF/Thnx
         yAIw==
X-Gm-Message-State: AOAM531NX9bofvLRcQxTIx7gBZmjKgnSSe4tSGjdfKqaCawRNNC6MiY+
        fJvtuevV/aZCsxFErP/+/IclUqy2wEZNtH4k/B76Ac/0COp7kTUZmVSOyrpeQKc2LRZxaFQELxX
        rhHQpyNiUNwxOZkUP
X-Received: by 2002:a05:6000:145:b0:20a:ebb3:5c2c with SMTP id r5-20020a056000014500b0020aebb35c2cmr15732344wrx.545.1651654381221;
        Wed, 04 May 2022 01:53:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy63+5SdoEgWaR81Rh3nvkUcLWBHYG87PsXR7zWHjN3ES2SmO3HYwjRRgKC0hfaQk26njgxhQ==
X-Received: by 2002:a05:6000:145:b0:20a:ebb3:5c2c with SMTP id r5-20020a056000014500b0020aebb35c2cmr15732334wrx.545.1651654381034;
        Wed, 04 May 2022 01:53:01 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-66.dyn.eolo.it. [146.241.115.66])
        by smtp.gmail.com with ESMTPSA id o4-20020a05600c338400b003942a244ec2sm3782448wmp.7.2022.05.04.01.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 01:53:00 -0700 (PDT)
Message-ID: <cac58f4ead1cac145d5a2005bcd3556851807f86.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: act_pedit: really ensure the skb is
 writable
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Date:   Wed, 04 May 2022 10:52:59 +0200
In-Reply-To: <7e4682da-6ed6-17cf-8e5a-dff7925aef1d@mojatatu.com>
References: <6c1230ee0f348230a833f92063ff2f5fbae58b94.1651584976.git.pabeni@redhat.com>
         <7e4682da-6ed6-17cf-8e5a-dff7925aef1d@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-03 at 16:10 -0400, Jamal Hadi Salim wrote:
> What was the tc pedit command that triggered this?

From the mptcp self-tests, mptcp_join.sh:

tc -n $ns2 filter add dev ns2eth$i egress \
		protocol ip prio 1000 \
		handle 42 fw \
		action pedit munge offset 148 u8 invert \
		pipe csum tcp \
		index 100 || exit 1

It's used to corrupt a packet so that TCP csum is still correct while
the MPTCP one is not.

The relevant part is that the touched offset is outside the skb head.

> Can we add it to tdc tests?

What happens in the mptcp self-tests it that an almost simultaneous
mptcp-level reinjection on another device using the same cloned data
get unintentionally corrupted and we catch it - when it sporadically
happens - via the MPTCP mibs.

While we could add the above pedit command, but I fear that a
meaningful test for the issue addressed here not fit the tdc
infrastructure easily.

Thanks,

Paolo

