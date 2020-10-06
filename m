Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5863284D5E
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgJFOKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFOKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 10:10:20 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B94C061755;
        Tue,  6 Oct 2020 07:10:20 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id j2so13715093eds.9;
        Tue, 06 Oct 2020 07:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cohnu7H/aaaxStWQf5kfTWm2BLYlj/dpqJmZXNRW08E=;
        b=IkyGXmoPBDtYIsluMuww6jucZZIMSZN0XmtrYwPxH3eFNoTxw3v6GlGIb0TInS5YSf
         j/G6W3tcO000ZliBysDTYU23GlmjjTmop6ST3MZAcHXTFubRJbYzqHaCUVXbQ8iDQggx
         zi6AnhFxyQmtOnQPNTcag9JZI2SzpgVa5pgnFTaXNQNQlzEFSHQhrmi2MQRqO4G6RFP+
         qg3/lNx+pKKqrBJVObp9wRooEUO4jUIBBFjlo3C6fcHw44/SWxm3kPcRnDKKsfueyYz4
         ceZxm8KlfUhP/+ZfreDzBqrj0SQoHQzdzaKRwX9tUQELpDcBLhrevdd1y6vglUS9LIfJ
         ayTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cohnu7H/aaaxStWQf5kfTWm2BLYlj/dpqJmZXNRW08E=;
        b=HNokWUCoQyChbSYKa2AJtlrB7IrFL7rXsxhfqOHBLPuaE8vUArXi+qeyzFVR4jwyuK
         U3RFLgvRq6/BcR7j4g3YYjyhwLv/iAvB09c3Bt9sTredd2Q81xqOoqAm9TDT3ZhVV0dr
         tjI0DlMVy2pIIHU2yRgsU4WH+2FlzBdc+Ot4Jnz3gIGhB5uweZTgtfeSji+ii2y71P+w
         t9GhK8NKd4IsnlQRjOCunaSQAnfnmzQtWFwc2caEzCKUJMMsCUbdU/mAxqeMQmsljccF
         myq94k9E5l1oa/NTeVCL+6jVcUB+KS/4318OZ8Dy6pFaAD6MConiJ0jJK/1lDgiz4zj4
         WdIA==
X-Gm-Message-State: AOAM533MEVuhE5E3gDXai9wLFKBilYqzkj/5ex2rdb8GtIqqqkAy31zF
        awcSJZhStjN2lSbuH3M2v+Y=
X-Google-Smtp-Source: ABdhPJwVfZSH6A2/lyPnMTHH6IfwUdX+3VF5h5/fu/eQQiiwzpXHjgTpfqb7rT8B96wCC9fBhLGSwA==
X-Received: by 2002:a05:6402:2d9:: with SMTP id b25mr5687857edx.131.1601993419026;
        Tue, 06 Oct 2020 07:10:19 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id f21sm2399863edw.83.2020.10.06.07.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 07:10:18 -0700 (PDT)
Date:   Tue, 6 Oct 2020 17:10:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann
 Hellcreek switches
Message-ID: <20201006141016.pxsmf4qy762mbhtj@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de>
 <20201004112911.25085-3-kurt@linutronix.de>
 <20201004125601.aceiu4hdhrawea5z@skbuf>
 <87lfgj997g.fsf@kurt>
 <20201006092017.znfuwvye25vsu4z7@skbuf>
 <878scj8xxr.fsf@kurt>
 <20201006113237.73rzvw34anilqh4d@skbuf>
 <87wo037ajr.fsf@kurt>
 <20201006134247.7uwchuo6s7lmyzeq@skbuf>
 <87o8lf78mg.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8lf78mg.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 04:05:11PM +0200, Kurt Kanzenbach wrote:
> > And because my knob is global and not per bridge either, I just set
> > ds->vlan_filtering_is_global = true and let DSA handle the rest.
>
> What's that flag doing? ...
>
> 	/* Disallow bridge core from requesting different VLAN awareness
> 	 * settings on ports if not hardware-supported
> 	 */
> 	bool			vlan_filtering_is_global;
>
> OK, that's what I need for the bridging part.

Yes, with the mention that not all checks for 8021q uppers may be in
place properly today. But we are in a better position of adding those
checks now, since we have a good place to start in
dsa_slave_netdevice_event. If you find scenarios that should be rejected
when this flag is set, but aren't, let me know and we'll fix that.
Nonetheless, if you go this route, then yes, you should set that flag.
