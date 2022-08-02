Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0817587992
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 11:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235865AbiHBJF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 05:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiHBJF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 05:05:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 169CC1D319
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 02:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659431126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f9+OLz544Oiwr3awPcdb0FXd/VboX5MrhPNEmAnz5bQ=;
        b=VVU0ufWIAKglRXS32pUh7fj3QbBriin8uwl1nHoaK8miI+Q4vSV5XQyf9Kqcr67DUgTAIz
        p84T2llOwTvEBbkyMPFgIKJodKntZwbooSQDUa6Msc73YFjOCGdS8ww/7+2qPaim4GgjP2
        Y+g+bGu6rdr3CYbzfxL6H/2jzvPMrnw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-W1cy6fmYM2qbvghPnmp7rg-1; Tue, 02 Aug 2022 05:05:25 -0400
X-MC-Unique: W1cy6fmYM2qbvghPnmp7rg-1
Received: by mail-qk1-f199.google.com with SMTP id l15-20020a05620a28cf00b006b46997c070so11220749qkp.20
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 02:05:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=f9+OLz544Oiwr3awPcdb0FXd/VboX5MrhPNEmAnz5bQ=;
        b=3it2qgjLWDK/SH20ezqypi2/joQlRqH2bG5Z5xek2QKlVsAw07p8TPXyL5ODH8CabC
         XtYIzedknDoNI22S9c+Me9NFXqPZEtj1FnGno5KIVlUxLsJPDqx8z+08sRz+W7XipoYZ
         2Lc0ZjG98G7gQsP/BxVamZV4Q+B3Effl9dUoxvv5Yaejgo/UYyqTGVIQKjKPzizpxhs9
         PVn9xzNJrFQMMD+HCYZa9rZAO88e3koxwpbgPKoQRTLQhHvltpesY28CVey22ZWbtd12
         mn2QQPxP43T30bAlQhfVnDU9qKJVC68MVOoUl4cKfAmrBsJu9P/b9Z8Wi6i6BdLBB5gq
         xBdg==
X-Gm-Message-State: ACgBeo2Jmc444zpqQDDwX1CrXU1XYfGHseLjRRPGSExMYk9UHk+dt3Xx
        jGNKc/nIs+vXtoC7x4zYAXGw5RATR8LR4vmYqMA9xJp+vBDpjJFl0HFSM2xtXW/G41iCeswqChh
        vwuP08w0EjlUw1KRA
X-Received: by 2002:a05:6214:21a3:b0:473:2161:f820 with SMTP id t3-20020a05621421a300b004732161f820mr17620256qvc.123.1659431124674;
        Tue, 02 Aug 2022 02:05:24 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7DJOpLIEZcPWrXd3A9dZEo0/M2L1/QN59vvKtb0uSepQp2TJWxX8iXBzWkW+QqCRxnEddNUA==
X-Received: by 2002:a05:6214:21a3:b0:473:2161:f820 with SMTP id t3-20020a05621421a300b004732161f820mr17620245qvc.123.1659431124452;
        Tue, 02 Aug 2022 02:05:24 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-118-222.dyn.eolo.it. [146.241.118.222])
        by smtp.gmail.com with ESMTPSA id q22-20020a05620a0d9600b006b872b606b1sm8501154qkl.128.2022.08.02.02.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 02:05:23 -0700 (PDT)
Message-ID: <d04773ee3e6b6dee88a1362bbc537bf51b020238.camel@redhat.com>
Subject: Re: [PATCH v3 net 1/4] net: bonding: replace dev_trans_start() with
 the jiffies of the last ARP/NS
From:   Paolo Abeni <pabeni@redhat.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
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
Date:   Tue, 02 Aug 2022 11:05:19 +0200
In-Reply-To: <20220802014553.rtyzpkdvwnqje44l@skbuf>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
         <20220731124108.2810233-2-vladimir.oltean@nxp.com> <1547.1659293635@famine>
         <20220731191327.cey4ziiez5tvcxpy@skbuf> <5679.1659402295@famine>
         <20220802014553.rtyzpkdvwnqje44l@skbuf>
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

On Tue, 2022-08-02 at 01:45 +0000, Vladimir Oltean wrote:
> On Mon, Aug 01, 2022 at 06:04:55PM -0700, Jay Vosburgh wrote:
> > 	The ARP monitor in general is pretty easy to fool (which was
> > part of the impetus for adding the "arp_validate" logic).  Ultimately it
> > was simpler to have the ARP monitor logic be "interface sent something
> > AND received an appropriate ARP" since the "sent something" came for
> > free from ->trans_start (which over time became less useful for this
> > purpose).
> > 
> > 	And, I'm not saying your patch isn't better, rather that what I
> > was intending to do is minimize the change in behavior.  My concern is
> > that some change in semantics will break existing configurations that
> > rely on the old behavior.  Then, the question becomes whether the broken
> > configuration was reasonable or not.
> > 
> > 	I haven't thought of anything that seems reasonable thus far;
> > the major change looks to be that the new logic in your patch presumes
> > that arp_xmit cannot fail, so if some device was discarding all TX
> > packets, the new logic would update "last_rx" regardless.
> 
> I don't see why it matters that my logic presumes that arp_xmit cannot fail.
> The bonding driver's logic doesn't put an equality sign anywhere between
> "arp_xmit succeeded" and "the packet actually reached the target".
> If it would, it would have a very broken understanding of Ethernet networks.
> For all practical purposes, updating last_tx in the bonding driver
> rather than letting the qdisc do it should make no perceivable
> difference at all, even if the driver was to drop all TX packets as you
> say.

I personally like Vladimir approach. I *think* it should be reasonably
safe.

If drops in arp_xmit() are really a concerns, what about let the latter
function return the NF error code as other output functions?

In any case, this looks like a significative rework, do you mind
consider it for the net-next, when it re-open?

Thanks!

Paolo

