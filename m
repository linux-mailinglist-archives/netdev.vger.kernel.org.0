Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A0B4F99AC
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 17:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbiDHPnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 11:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237708AbiDHPnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 11:43:39 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECA54B430
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 08:41:33 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so10031301pjk.4
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 08:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EPGVb31c9VYtNFxiQ9pmgvnPXTLkuL0jOYpmVyuPVWQ=;
        b=Kay8uKFyZQV4THgnBTgMBMQFvRcWqk4YW5Z+fwvXEGnN7+7x0t3XiZ2EogACfdRSKP
         PvvXpZ1YayQ+cP3ehpiLWc6jbGDZgdku3bvPOI7APZ+QtfPbxmzCai3MiTRzMGCSxkT0
         piCdWho3gYkEpwxd7gGiem+hX/2LR3zb2Cwy3vPaoNPAKbZVopNsgqdSDjc7e8WNE0QS
         V3hd2+r9//XerfszuVvPiCobig9SBmiS4A21touEG7/5+Tc0now7QK5EAbQCURSgM18r
         7aix9lQZhmeaWYCZB1hPMdQ4+tlptsNzxEHD/pvlSc2myeQxVfXQ+BUptzL1eP43ad6h
         6K7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EPGVb31c9VYtNFxiQ9pmgvnPXTLkuL0jOYpmVyuPVWQ=;
        b=2UzFA+aNudhLQf4pW+jctojuJDs5H18kFGEvHlIWTWXqUQDDoFGjKRqlZF17NlG70a
         kzsYoU36tq4bA0EZhHCPGmdbgFzaz17bhLHbsmpkHpJMUYRrGVIVgFexg2VImNIp8DnQ
         cbxHW3+5WdfE4+RlY4OJ0JDaKYBIldNFTip20/VBLOsnmDZCSI1uPX8Jcf39cObWCTC1
         xqMTixnwO+wPXeV/utnZFe9mtr3dZxDcL7YS5bJvib/ChVs+stG7Cvkk6/KCwaMF9Ag2
         TuNQW2V5Nt4twPCDfcgHcr+jz/Xl16bViAEV/WuKPOJqXx8KLZof6owKhaOCqqsjLmUQ
         a1xQ==
X-Gm-Message-State: AOAM532nLMImouuxgmVm33eW4CIRa8xkoAsNMYB/42nkFGPgyFopgMLT
        AbNZTraZapjOXIIYhn6r0AT8MOsmEpTjNQ==
X-Google-Smtp-Source: ABdhPJxbizw1hXUaB/fVdj2Ts0pkOBT5gHbGvFL00A+AVIFC8+lE3K2lSXim22VBGUXLB8Lod9EAQQ==
X-Received: by 2002:a17:902:6b8b:b0:14d:66c4:f704 with SMTP id p11-20020a1709026b8b00b0014d66c4f704mr20243985plk.53.1649432493311;
        Fri, 08 Apr 2022 08:41:33 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id s141-20020a632c93000000b0038134d09219sm22356564pgs.55.2022.04.08.08.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 08:41:32 -0700 (PDT)
Date:   Fri, 8 Apr 2022 08:41:29 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dave Jones <davej@codemonkey.org.uk>, netdev@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH] decouple llc/bridge
Message-ID: <20220408084129.26944522@hermes.local>
In-Reply-To: <20220407194859.1e897edf@kernel.org>
References: <20220407151217.GA8736@codemonkey.org.uk>
        <20220407091640.1551b9d4@hermes.local>
        <20220407194859.1e897edf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Apr 2022 19:48:59 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 7 Apr 2022 09:16:40 -0700 Stephen Hemminger wrote:
> > > I was wondering why the llc code was getting compiled and it turned out
> > > to be because I had bridging enabled. It turns out to only needs it for
> > > a single function (llc_mac_hdr_init).  
> 
> > > +static inline int llc_mac_hdr_init(struct sk_buff *skb,
> > > +				   const unsigned char *sa, const unsigned char *da)
> > > +{
> > > +	int rc = -EINVAL;
> > > +
> > > +	switch (skb->dev->type) {
> > > +	case ARPHRD_ETHER:
> > > +	case ARPHRD_LOOPBACK:
> > > +		rc = dev_hard_header(skb, skb->dev, ETH_P_802_2, da, sa,
> > > +				     skb->len);
> > > +		if (rc > 0)
> > > +			rc = 0;
> > > +		break;
> > > +	default:
> > > +		break;
> > > +	}
> > > +	return rc;
> > > +}
> > > +
> > >    
> 
> nit: extra new line
> 
> > > -int llc_mac_hdr_init(struct sk_buff *skb,
> > > -		     const unsigned char *sa, const unsigned char *da)
> > > -{
> > > -	int rc = -EINVAL;
> > > -
> > > -	switch (skb->dev->type) {
> > > -	case ARPHRD_ETHER:
> > > -	case ARPHRD_LOOPBACK:
> > > -		rc = dev_hard_header(skb, skb->dev, ETH_P_802_2, da, sa,
> > > -				     skb->len);
> > > -		if (rc > 0)
> > > -			rc = 0;
> > > -		break;
> > > -	default:
> > > -		break;
> > > -	}
> > > -	return rc;
> > > -}  
> 
> There's also an EXPORT somewhere in this file that has to go.
> 
> > >  /**
> > >   *	llc_build_and_send_ui_pkt - unitdata request interface for upper layers
> > >   *	@sap: sap to use    
> > 
> > You may break other uses of LLC.
> > 
> > Why not open code as different function.  I used the llc stuff because there
> > were multiple copies of same code (DRY).  
> 
> I didn't quite get what you mean, Stephen, would you mind restating?


Short answer: it was idea that didn't pan out.

Suggestion: get rid of using LLC  in bridge and just rewrite that one place.
