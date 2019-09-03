Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB35A69FB
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbfICNgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:36:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40769 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbfICNgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:36:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id c3so17524516wrd.7
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 06:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XXWSbLsKaHg5I5JkLpivESPwDR8ogw0XgJNZimWH3ok=;
        b=Teo2ZSWsXJgYtI6aGJ8QIQR+ijFjruZMSiEKuPtDDv0rMWQA0JmLG8nCCISOKQnYOy
         NetFt3DFd8uyAB6021HDj4DFccgfSM4sBbIlxeI1rKOwg3QzraEgEh+ThJcOSdrv5d55
         uExIHOud/g8s4F0JPk7gKA21BRQPPzEtOtip2/XRe+lhkE11tZ4PWNIMOWN5QJZqWTtK
         Fdb1GR/CCAVhWDIN7dqtnJ8cf1VY4BVaHTBaPKv3H8hPnsdvKauzoulc4sl9lfsh9RoR
         ZfIpNv+vVinopMauyptxX2ecDAnDzLuhRMkyoBI06LnO1RCjRYVURbwuBH0N63JG858w
         Z6xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=XXWSbLsKaHg5I5JkLpivESPwDR8ogw0XgJNZimWH3ok=;
        b=X7n3vRwHys3IjMg/NWl4UmbCsv9FQZzeAPEbk9aFWaO8TK/uuBzt6pffSyLSmCI/Cw
         Vv2huRnijyTCkEf2Wac4zSzWQ54LvKlzQYdazNzw0Q5o2ZvWtmwniDmBChNYpg4YfG4p
         Il8DNUIQ5pUgksORQUTEsXEtAEkXSRVsqHaCBspf+wV2kItE98C1H9BlGjwNJ+GzVLMp
         uHNkpAtD8/4ZQH5MqCZv9r8X5Wfb1BNK5tFUIsbHiunC1d+t7w3wr/6hs9a+vBAlfMY+
         59OOSB1+pQa+blu6GT6K3EFErxircMCDFIDAjPaKtBUlK7ACOAlqCxEzpJdR8AgRk5ex
         bXgA==
X-Gm-Message-State: APjAAAUVsfZRA7pJY/sg4dKh9B371nnz30b7aPPZeA7i8GnrBsGb8Jfu
        X0nUf1Ezq/EIR+bSAkqGz24=
X-Google-Smtp-Source: APXvYqz4KjqpS358nHrAmtKP8SWA3RqP5GCb/rip3hF2qCoodxn/l/koaslM3TPkpsB28aXEdVBDig==
X-Received: by 2002:a5d:4402:: with SMTP id z2mr10102991wrq.183.1567517798269;
        Tue, 03 Sep 2019 06:36:38 -0700 (PDT)
Received: from tycho (ipbcc09208.dynamic.kabel-deutschland.de. [188.192.146.8])
        by smtp.gmail.com with ESMTPSA id f143sm11102046wme.40.2019.09.03.06.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 06:36:37 -0700 (PDT)
Date:   Tue, 3 Sep 2019 15:36:36 +0200
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     netdev@vger.kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jiri@resnulli.us, nikolay@cumulusnetworks.com,
        simon.horman@netronome.com, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org, jhs@mojatatu.com,
        dsahern@gmail.com, xiyou.wangcong@gmail.com,
        johannes@sipsolutions.net, alexei.starovoitov@gmail.com
Subject: Re: [Bridge] [PATCH v3 1/2] net: bridge: use mac_len in bridge
 forwarding
Message-ID: <20190903133635.siw6xcaqwk7m5a5a@tycho>
References: <20190902181000.25638-1-zahari.doychev@linux.com>
 <76b7723b-68dd-0efc-9a93-0597e9d9b827@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76b7723b-68dd-0efc-9a93-0597e9d9b827@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 08:37:36PM +0900, Toshiaki Makita wrote:
> Hi Zahari,
> 
> Sorry for reviewing this late.
> 
> On 2019/09/03 3:09, Zahari Doychev wrote:
> ...
> > @@ -466,13 +466,14 @@ static bool __allowed_ingress(const struct net_bridge *br,
> >   		/* Tagged frame */
> >   		if (skb->vlan_proto != br->vlan_proto) {
> >   			/* Protocol-mismatch, empty out vlan_tci for new tag */
> > -			skb_push(skb, ETH_HLEN);
> > +			skb_push(skb, skb->mac_len);
> >   			skb = vlan_insert_tag_set_proto(skb, skb->vlan_proto,
> >   							skb_vlan_tag_get(skb));
> 
> I think we should insert vlan at skb->data, i.e. mac_header + mac_len, while this
> function inserts the tag at mac_header + ETH_HLEN which is not always the correct
> offset.

Maybe I am misunderstanding the concern here but this should make sure that
the VLAN tag from the skb is move back in the payload as the outer most tag.
So it should follow the ethernet header. It looks like this e.g.,:

VLAN1 in skb:
+------+------+-------+
| DMAC | SMAC | ETYPE |
+------+------+-------+

VLAN1 moved to payload:
+------+------+-------+-------+
| DMAC | SMAC | VLAN1 | ETYPE |
+------+------+-------+-------+

VLAN2 in skb:
+------+------+-------+-------+
| DMAC | SMAC | VLAN1 | ETYPE |
+------+------+-------+-------+

VLAN2 moved to payload:

+------+------+-------+-------+
| DMAC | SMAC | VLAN2 | VLAN1 | ....
+------+------+-------+-------+

Doing the skb push with mac_len makes sure that VLAN tag is inserted in the
correct offset. For mac_len == ETH_HLEN this does not change the current
behaviour.

> 
> >   			if (unlikely(!skb))
> >   				return false;
> >   			skb_pull(skb, ETH_HLEN);
> 
> Now skb->data is mac_header + ETH_HLEN which would be broken when mac_len is not
> ETH_HLEN?

I thought it would be better to point in this case to the outer tag as otherwise
if mac_len is used the skb->data will point to the next tag which I find somehow
inconsistent or do you see some case where this can cause problems?


> 
> > +			skb_reset_network_header(skb);
> >   			skb_reset_mac_len(skb);
> >   			*vid = 0;
> >   			tagged = false;
> > 
> 
> Toshiaki Makita
