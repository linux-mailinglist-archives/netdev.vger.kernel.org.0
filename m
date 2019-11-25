Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE59910928E
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 18:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbfKYRFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 12:05:39 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34307 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728988AbfKYRFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 12:05:39 -0500
Received: by mail-pg1-f196.google.com with SMTP id z188so7494876pgb.1
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 09:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=rW9JU4/TttMewQI/SGeMRBzvONk7lB2IL4O4VVOEv6Y=;
        b=iq85c098/FBEsXFzYWGRMHwlpM0eNLeVx0RnTcr2wk6QzIpgQSAR4MnovLPvCzX1f/
         uOJ2rP3+1xNek87WiymcB942Wm89GaKpgh6Qf310ENwBsGL4Xp4SUHfOaEHy5D1HHfbn
         1hhqppxf1Mgq5le88bndnyhW+5yh5O9sbjhY/fV4+1/Cf48VYq8cKAtcV6YZwGxwAad8
         UZSI1CtdOL1Yjbva4lKqzc7oQmxO095rs73cOgFL1PY6DxwIxts+Sq54quKARL+Tw0oH
         4PrIkpdx9+olzfJTrr3JPvwhtFqmv6uetrHUmaT9pImvYs5+D8D6gFkyYtRAABCfm8Gd
         xujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rW9JU4/TttMewQI/SGeMRBzvONk7lB2IL4O4VVOEv6Y=;
        b=rFESnB5GweBhtOhJBaX71MSx9nyZPehljLMuQdHH2oWfnbYbpftJAYzdPWb1hNfdS7
         dNv3QrTRRiTKCfuzRdAaz+A54KuYpOrYzX9evdVNU5r1LVEoLuRJS/PwZTgC6YUsXVN8
         5GNJdAAruh9MDksyGvLGpFZyiiGgxVNwKmkqvAinKABnSCgmW5L+KSEczHP3vIWorfvO
         UV51Vol03SHKQTIes9hQV+LSA6vW0xxXRewlhl2uy4KqzGrwha7boV2FMWDv72hpT4RU
         5sckiZtkOZEyUbSFPRsrAQPJckZ1JZzs6ePhASN5qX1EWLQPKdD3Vxxy1gxZ6XZNbhvg
         DMzA==
X-Gm-Message-State: APjAAAW/s8fYbhBlyHtOyW9/BsW8CRaP8vHAVbTDGg7kFrqR9AlNnPia
        BHZg3uoAsIB+TJH6tkrfUD6EDg==
X-Google-Smtp-Source: APXvYqzq7HhirEbq3aNH4ukGbA9kI/my+8Mr52j23me2L1wkaBRlaDXtwkFEoMey6j0ZjdcuPqPUjg==
X-Received: by 2002:aa7:9a96:: with SMTP id w22mr36981636pfi.162.1574701538482;
        Mon, 25 Nov 2019 09:05:38 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id n8sm9040730pgs.44.2019.11.25.09.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 09:05:38 -0800 (PST)
Date:   Mon, 25 Nov 2019 09:05:30 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        martin.varghese@nokia.com
Subject: Re: [PATCH v2 net-next] Enhanced skb_mpls_pop to update ethertype
 of the packet in all the cases when an ethernet header is present is the
 packet.
Message-ID: <20191125090530.5e34fc93@cakuba.netronome.com>
In-Reply-To: <20191125110234.GA2795@martin-VirtualBox>
References: <1574505299-23909-1-git-send-email-martinvarghesenokia@gmail.com>
        <20191124191008.1e65f736@cakuba.netronome.com>
        <20191125110234.GA2795@martin-VirtualBox>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Nov 2019 16:32:34 +0530, Martin Varghese wrote:
> > > Changes in v2:
> > >     - check for dev type removed while updating ethertype
> > >       in function skb_mpls_pop.
> > >     - key->mac_proto is checked in function pop_mpls to pass
> > >       ethernt flag to skb_mpls_pop.
> > >     - dev type is checked in function tcf_mpls_act to pass
> > >       ethernet flag to skb_mpls_pop.  
> > 
> > nit: changelog can be kept in the commit message for netdev patches
> >  
> Multiple versions are mostly due to coding error.do you insist to keep
> the change log in commit message ?

Not really, just a minor suggestion.
