Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93CFB18444
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 05:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfEID5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 23:57:23 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34222 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfEID5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 23:57:23 -0400
Received: by mail-pf1-f196.google.com with SMTP id n19so569725pfa.1
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 20:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=33xu8LxtjkodshMi7e+4NO67SFyMWTV3ICy1/FAhFrY=;
        b=mOZxt76IWfko99jQTXFcdf4An8Qg7RYu8krCEifoNrJN34qTSQ6zJuN9n+ucZIFfRm
         3H1ecyH096JsmtDoVYzitQcMyn6aGFc9Rm+RDB10YTE7Kdn6acidQ/D2brXdRJZRuCEK
         H6QcyAQcYYN9U7gLWZ4lhw9E//CATMWTphbRPi4CXlPEej/z9NL+0tbxS1Aeq58z6Ga5
         Cu1RqVvFqUBg6zMrR3vkrsiOmOFx/LcQj9JsUnva1ZL3uxOwGsF+nRU62Ld4fzQ9VfzD
         GD8QxrkMMHBUbXPIsq77UKKU6LjUx/wiQrP/iDzTChe+bnv0EpzL1qKVxNnrfbuPqjTu
         9lxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=33xu8LxtjkodshMi7e+4NO67SFyMWTV3ICy1/FAhFrY=;
        b=J8YM+cWo3DPC33jBJVyaqFgzhxGqHQcxR+Fq/hnhOLgoV2SYJt4j69SidXIPH2MWuj
         I9rpGl/yVjn9k5HMGjHABF/Hm29eOeKwlj0nrQhkqaAh2GAxH/x99hI0hwcJLy9Uven9
         9NPsi59mcVj9qddUKdTsWZaPPLqJB308ZwvcT5FFeWkoAHMzGHev/x3851KVI/QX7bc9
         O1I4pOm0tyuaksxYiuq7wG7sAfBWJZC62lCwGdOcNrHa4iV9YE+BMxQxgbvYd3YJFcMP
         N+PajTRzGcJQBhN/XrLTu9t49QXwV5yCZmTPYv8BH+MhWKSfeGgS6DkzjTzhYSMQfMGn
         B1Sw==
X-Gm-Message-State: APjAAAXh633j0a2PL+hXCn4hhP+sB5SbLrJVF2D0wEq5e7afnMTn0NlO
        pdACt0yiCn3mdLgHdFZKlS0=
X-Google-Smtp-Source: APXvYqwBtc9MHdg/XW4+zB+wCEd8hh+ZmaGyr7mXzDJbWWcEME0dlMFD37VUXsXTHggrGMzV/MxtlA==
X-Received: by 2002:a62:164f:: with SMTP id 76mr2055116pfw.172.1557374242385;
        Wed, 08 May 2019 20:57:22 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id 6sm926372pfd.85.2019.05.08.20.57.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 May 2019 20:57:21 -0700 (PDT)
Date:   Wed, 8 May 2019 20:57:19 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: Re: [PATCH] ptp_qoriq: fix NULL access if ptp dt node missing
Message-ID: <20190509035719.46sg5wh5eywkpupx@localhost>
References: <20190509030845.36713-1-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509030845.36713-1-yangbo.lu@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 03:07:12AM +0000, Y.b. Lu wrote:
> From: Claudiu Manoil <claudiu.manoil@nxp.com>
> 
> Make sure ptp dt node exists before accessing it in case
> of NULL pointer call trace.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
