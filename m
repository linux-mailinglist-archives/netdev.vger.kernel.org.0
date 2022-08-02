Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63338588327
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 22:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbiHBUeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 16:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbiHBUep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 16:34:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B39BE25C63
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 13:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659472483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+is0TupoIsdZMelWtLOo82/kcSJ6OcRXnRToRi8pzwg=;
        b=ce18Judym/sMAmLeS47IyO8Fs4C/L948MM21ALKSdI2sl6xqtmRCZxYr6mD7d9oD/Iqd0T
        gytfzjFHZ0PIpf3PycRhr6QCDDoz4wtmOAJXlhu74EOR2/1OSD2zbgqVZg8rTEMiCDAF5z
        e6tq++ZBSHA9DosmbilH6WY8VBuyLd0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-KUB_ALVGO1unkNtLlw8xTA-1; Tue, 02 Aug 2022 16:34:42 -0400
X-MC-Unique: KUB_ALVGO1unkNtLlw8xTA-1
Received: by mail-wm1-f72.google.com with SMTP id c189-20020a1c35c6000000b003a4bfb16d86so3349209wma.3
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 13:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=+is0TupoIsdZMelWtLOo82/kcSJ6OcRXnRToRi8pzwg=;
        b=Z9X/RIJyf/Q8nuWzcIjFiGgtrymhvdCMfyWhu8vbrXITYA8vviZuCvxbKJpvFORaay
         gOkLQKy//tT2wHZMWQodOvLPxdr7teH7+rzaGf+7u/kcvf2YzSiLIXMz0VoMSzEyR1lo
         9VhadE+Me0FjS1x/17VPqbluaF20FXbt9TYgXQEWkQQnJM4+C+rpSewCU3SfKCkEThbZ
         yvr+abOTvwcXWfs6ZJR925boeq6/5BRuYXAjTFbMmSH1RivcbyIusRq6I/N8DWkiJVKj
         t+dbUwm5FU1SquzWgCTJkZBGhK2+RiXPChm1QBnq3fw+nZtEuY2KdW0gGjSlO0spxarT
         KMIQ==
X-Gm-Message-State: ACgBeo0XKk0emaG0Gs+x6Q3gTv5IUMhAUZOqkLotLd3X/ALwYwzvybQn
        GKTz+vprNS5+RxC9PHgmItFQ6QZBLns+CVTmmPWG42b3HPWfLrWV1qpigo/7wnRi/ZxBUMS/DK/
        MmAbrfpTtuX689tw3
X-Received: by 2002:a05:600c:1993:b0:3a4:c0a9:5b6f with SMTP id t19-20020a05600c199300b003a4c0a95b6fmr695367wmq.79.1659472481371;
        Tue, 02 Aug 2022 13:34:41 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6gPZQZzCD5Xe6IP/pYbsHjMKe/890WXGHfv+GHbZQSidClSqCbGQ3SbuszEkRSUyzF5pyZww==
X-Received: by 2002:a05:600c:1993:b0:3a4:c0a9:5b6f with SMTP id t19-20020a05600c199300b003a4c0a95b6fmr695357wmq.79.1659472481064;
        Tue, 02 Aug 2022 13:34:41 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-118-222.dyn.eolo.it. [146.241.118.222])
        by smtp.gmail.com with ESMTPSA id k33-20020a05600c1ca100b003a4ef39b8f3sm3011026wms.18.2022.08.02.13.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 13:34:40 -0700 (PDT)
Message-ID: <4cfaacec31ef5f7c7567d5e40d07bd0af9ba99a7.camel@redhat.com>
Subject: Re: [PATCH v3 net 1/4] net: bonding: replace dev_trans_start() with
 the jiffies of the last ARP/NS
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Date:   Tue, 02 Aug 2022 22:34:39 +0200
In-Reply-To: <23020.1659471874@famine>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
         <20220731124108.2810233-2-vladimir.oltean@nxp.com> <1547.1659293635@famine>
         <20220731191327.cey4ziiez5tvcxpy@skbuf> <5679.1659402295@famine>
         <20220802014553.rtyzpkdvwnqje44l@skbuf>
         <d04773ee3e6b6dee88a1362bbc537bf51b020238.camel@redhat.com>
         <20220802091110.036d40dd@kernel.org>
         <20220802163027.z4hjr5en2vcjaek5@skbuf>
         <e11a02756a3253362a1ef17c8b43478b68cc15ba.camel@redhat.com>
         <16274.1659463241@famine> <20220802121029.13b9020b@kernel.org>
         <23020.1659471874@famine>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-08-02 at 13:24 -0700, Jay Vosburgh wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > On Tue, 02 Aug 2022 11:00:41 -0700 Jay Vosburgh wrote:
> > > > > Alternatively, would it be more comfortable to just put this
> > > > > patch (1/4) to stable and not backport the others?   
> > > > 
> > > > The above works for me - I thought it was not ok for Jay, but since he
> > > > is proposing such sulution, I guess I was wrong.  
> > > 
> > > 	My original reluctance was that I hadn't had an opportunity to
> > > sufficiently review the patch set to think through the potential
> > > regressions.  There might be something I haven't thought of, but I think
> > > would only manifest in very unusual configurations.
> > > 
> > > 	I'm ok with applying the series to net-next when it's available,
> > > and backporting 1/4 for stable (and 4/4 with it, since that's the
> > > documentation update).
> > > 
> > > Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> > 
> > One more time, sorry :) If I'm reading things right Vladimir and 
> > I would like this to be part of 5.20, Paolo is okay with that,
> > Jay would prefer to delay it until 5.21.
> > 
> > Is that right?
> 
> 	I'm sure there's an Abbott & Costello joke in here somewhere,

At least not intentionally, not on my side! :)

> but I thought Paolo preferred net-next, and I said I was ok with that.

I initially suggested net-next, but then I agreed for a minimal fix for
net.

> > My preference for 5.20 is because we do have active users reporting
> > problems in stable, and by moving to 5.21 we're delaying things by
> > 2 weeks. At the same time, 5.20 vs 5.21 doesn't matter as we intend 
> > to hit stable users with these change before either of those is out.
> 
> 	I have no objection to 5.20 if you & Paolo don't object.

I also don't have objection for 5.20 (6.0)

> 	For stable, I believe that 1/4 (and 4/4 for docs) is the minimum
> set to resolve the functional issues; is the plan to send all 4 patches
> to stable, or just 1 and 4?

I think that for stable 1 && 4 only would be the better option.

Cheers,

Paolo

