Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B924A51FDCE
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbiEINSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235327AbiEINSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:18:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7E0D2A83CA
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 06:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652102048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HSehGCfaMMMVDJ5lNrHbgEK3DMNptmQ+vAoaTmu35Bo=;
        b=K4dsyXFEIyTgzy0/L4o1Ht/hB9MyM9MMyzdWiDIGeSC1OyvXmkl37R9zoHzowar8EPUmAA
        QqmE2z8/McmBOD1Mvmdjg7C1Rz4wQzuZB1t3bVnx34bA4euwpqv6wjjmsjYJXf6uIwxFqJ
        GNrqpDNOPaI/zzMS3j+gn8gvqDgFmTA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-QhfvmJ5LMVuW8tWzgPYa2Q-1; Mon, 09 May 2022 09:14:04 -0400
X-MC-Unique: QhfvmJ5LMVuW8tWzgPYa2Q-1
Received: by mail-wr1-f69.google.com with SMTP id m8-20020adfc588000000b0020c4edd8a57so5762797wrg.10
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 06:14:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=HSehGCfaMMMVDJ5lNrHbgEK3DMNptmQ+vAoaTmu35Bo=;
        b=IS88yPfaugBnXuaxR5UYXL/gj745f4iYF4GYAS0CBOhmsXZ75qxDatUsGOVel85lke
         xyLOeZs0jG1qHpaNNzgMX+54+kZ3aUvM6bBDu9OR2WK/fgkBx2EUk78NkSjYX+QdLiEv
         wXQFWFidGdKCbVgMLH0sCXx9NwHLAUGAFdCoykhj5TNqBgnLuV2JDW/SD8buxWAZidON
         jO5xRmzlvuSGH8kWzvoM50hO5qFnqO9JshfeMBuXsIk7NOv9kB7DzAwmGewmU+Voj8Dp
         +4pjfrInJ+urxFS7GtiX8CbIq0/xYW/trYMn01lExlX0xQlQJlG8OwR7Qtce/vp+0hHO
         /7Zg==
X-Gm-Message-State: AOAM532NhnEV5BWKW5rbe4NCPSdctmRo8i7mfXEuwciPZa3S+n/hLO01
        3YbIRCrCeeVYPe7yaSa7vF8MovjrKryAnifHr6ACcnywngPiGHnWSQGbWmUTHMgBSiHp+sq8tz1
        70F7GW80EWljXhUsE
X-Received: by 2002:a5d:42c3:0:b0:20c:c094:8746 with SMTP id t3-20020a5d42c3000000b0020cc0948746mr6318716wrr.691.1652102042322;
        Mon, 09 May 2022 06:14:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzOrLfRK4c2MxV3jjs8K8hux9X7D3F1J92MWFNnyNJjLedI21nSfWTnkT3JvzfirTzSegIxw==
X-Received: by 2002:a5d:42c3:0:b0:20c:c094:8746 with SMTP id t3-20020a5d42c3000000b0020cc0948746mr6318700wrr.691.1652102042079;
        Mon, 09 May 2022 06:14:02 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-89.dyn.eolo.it. [146.241.113.89])
        by smtp.gmail.com with ESMTPSA id h5-20020a1ccc05000000b003942a244f29sm17297912wmb.2.2022.05.09.06.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 06:14:01 -0700 (PDT)
Message-ID: <1941abbcd1b9f33061d90533313da0efdb171a93.camel@redhat.com>
Subject: Re: [PATCH v2 net] net/sched: act_pedit: really ensure the skb is
 writable
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Date:   Mon, 09 May 2022 15:14:00 +0200
In-Reply-To: <b898299d-7361-f5e9-2e0e-aa5a0686faab@mojatatu.com>
References: <004a9eddf22a44b415a6573bdc67040b995c14dc.1652095998.git.pabeni@redhat.com>
         <b898299d-7361-f5e9-2e0e-aa5a0686faab@mojatatu.com>
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

On Mon, 2022-05-09 at 08:16 -0400, Jamal Hadi Salim wrote:
> On 2022-05-09 07:33, Paolo Abeni wrote:
> 
> [..]
> >   	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
> > @@ -308,13 +320,18 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
> >   			 struct tcf_result *res)
> >   {
> >   	struct tcf_pedit *p = to_pedit(a);
> > +	u32 max_offset;
> >   	int i;
> >   
> > -	if (skb_unclone(skb, GFP_ATOMIC))
> > -		return p->tcf_action;
> > -
> >   	spin_lock(&p->tcf_lock);
> >   
> > +	max_offset = (skb_transport_header_was_set(skb) ?
> > +		      skb_transport_offset(skb) :
> > +		      skb_network_offset(skb)) +
> > +		     p->tcfp_off_max_hint;
> > +	if (skb_ensure_writable(skb, min(skb->len, max_offset)))
> > +		goto unlock;
> > +
> 
> goto bad; would have been better so we can record it in the stats?

I thought about that, but it looked like an unexpected behavioral
change: currently skb_unclone() failures do not touch stats.
> 
> Other than that LGTM.
> The commit message is good - but it would be better if you put that
> example that triggered it.

Please let me know if you prefer another revision to cope with the
above.

Thanks!

Paolo

