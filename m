Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FA12261EB
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 16:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgGTOVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 10:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgGTOVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 10:21:49 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D243C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 07:21:49 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e8so10353828pgc.5
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 07:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1SkEKu77Kzyu8BKLi4RzzkZx3S5hAWdaRlV6lYlB+Lk=;
        b=emxh8m7jv0t0CIBjwR79GzaFb/KFBSuTKGameBb47k0Si83qWYygJAlES5D73eFSP0
         q85OseRDcuzUWi9uPcl1fEtd4gDPDGmNcTUNl3zDNWPa29Vng5HoLXGp1vFE0uiaKAXx
         VgnFJ3gn/b0euTD64Sf+I4R4vLW9aGGZ+oAT8aXVPLFB42CLSzCmRukn0qJQGVrOyxwm
         FqctoAsue60GJlNbVhzmFh8Z/lyr/6lJUJj0VYnqiqYUQtTc7826sEtlrjE8+TDlAkGx
         LaK8nAv6I40yxQ6mtXeTG7A9NbEf+Ke0eLJ61+D6J/Wv5/X68QB3TzGYntwSc8EDXipD
         PQWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1SkEKu77Kzyu8BKLi4RzzkZx3S5hAWdaRlV6lYlB+Lk=;
        b=s/5keBq7T+POEEp3RM2CPh3ngDc3VV9E0aH/3P9c1feqoAiGNbcdsCrY2PO4DfydcB
         6m6Sz1JcTRBRsxd3mnB6CDk0m2C0Dd6t8I/v1cKJeerWVNt7ARnkM/xB/mVzRNPE728d
         uVCOZ/nuMVQLBam/6by6ER7hmbLv6ZZcOCkSUUvjgZYIeR4/bhAoI4ofHsGkIrkZ9VTO
         dncFpaz8xY8t0felt5DsZ75PTPowwLZZ4sQs5vkZD+Wyf7FxFooVr9LW1WkcyxVWnwCn
         +je7aeiiDzMxwitt8ZJmW08KvO1iCRHcWdq1Cf2AD5SciU42W72QxsJ2u3nyx5CvxRWw
         Jtbw==
X-Gm-Message-State: AOAM53271fvARvEDzMD1m0Jg23pO1Ekfpw/BgCkZkKzs/ZN6sbW5JsMb
        8t9ZmXitD8xge2HeSop1+zBJZWb/
X-Google-Smtp-Source: ABdhPJxhOyNzECk9wL2jXJ96UrvKHFQN3PC7MiKbM63HT7xpot+9Qm7OYJ8/mrqHwHGueeNHTzjR1w==
X-Received: by 2002:a63:338c:: with SMTP id z134mr18416243pgz.245.1595254908837;
        Mon, 20 Jul 2020 07:21:48 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id o8sm11327215pjf.37.2020.07.20.07.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 07:21:48 -0700 (PDT)
Date:   Mon, 20 Jul 2020 07:21:46 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200720142146.GB16001@hoboy>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200716204832.GA1385@hoboy>
 <874kq6mva8.fsf@kurt>
 <20200718022446.GA4599@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718022446.GA4599@hoboy>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 07:24:46PM -0700, Richard Cochran wrote:
> On Fri, Jul 17, 2020 at 09:54:07AM +0200, Kurt Kanzenbach wrote:
> > I'll post the next version of the hellcreek DSA driver probably next
> > week. I can include a generic ptp_header() function if you like in that
> > patch series. But, where to put it? ptp core or maybe ptp_classify?
> 
> Either place is fine with me.  Maybe it makes most sense in ptp_classify?
> Please put the re-factoring in a separate patches, before the new
> driver.

And maybe the new header parsing routine should provide a pointer to a
structure with the message layout.  Something similar to this (from
the linuxptp user stack) might work.

struct ptp_header {
	uint8_t             tsmt; /* transportSpecific | messageType */
	uint8_t             ver;  /* reserved          | versionPTP  */
	UInteger16          messageLength;
	UInteger8           domainNumber;
	Octet               reserved1;
	Octet               flagField[2];
	Integer64           correction;
	UInteger32          reserved2;
	struct PortIdentity sourcePortIdentity;
	UInteger16          sequenceId;
	UInteger8           control;
	Integer8            logMessageInterval;
} PACKED;


Of course, the structure should use the kernel types that include the
big endian annotations.

Thanks,
Richard
