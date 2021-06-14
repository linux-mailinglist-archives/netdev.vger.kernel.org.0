Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18223A6E0B
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 20:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhFNSPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 14:15:32 -0400
Received: from mail-ej1-f42.google.com ([209.85.218.42]:45759 "EHLO
        mail-ej1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbhFNSPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 14:15:31 -0400
Received: by mail-ej1-f42.google.com with SMTP id k7so18102098ejv.12
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 11:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i7Dz7ltG0kW+wyMN4N65nG4XNYkS2sz8JZOfqqhPBow=;
        b=uS8GRtKW7BC14TGS7Guc7xB9/Sg5OsbFjyz5jX3H9KGP2Rq9I6vlk2QJfNCWbFXnwN
         w/n7nk8HUlpsSpezQiYuK7Ljh9ZOos3SXkTZ3z+4wYKo/M4bE6yMQXcu8rF2RUaJ5D5J
         r/cWiFb1zTxz/0Kh7T9jQHV2u6Q+ExLRQyZs1cfSuwsfnzpJ7elGLLN/Ql68lrUMxLeM
         J3yX+343r/7fK1xQEI7uSuuk0l/fhYC2Zmtclsiuy1OBP7jRlNi3H/oSJ8PJOFz51t+q
         VJf31Lt5fCs8TwgBiMyQC/BBOSpgVHSJ8FpVWXFYaLWzpoc7BJEErGE2BXkuKbJaASNo
         5pAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i7Dz7ltG0kW+wyMN4N65nG4XNYkS2sz8JZOfqqhPBow=;
        b=ajHi6ruzeCTr5gwhLg/qpPiNWm4ideBpnsHgTPusoF4kf8SGu6hYgepNzVTBYBzCYN
         FZjZa++di5GBXoXlNK6sMez16nzoZ26j8Eq2VP/8NYFppz8dVfZrU+1F67GoCtWXOIOb
         kDnpGYvMpXcX189gWIUK/2cyohc3wZfYEQ7fN0DEeB8QPgM6n2Ttmzcy2g+LzXd+4MYF
         3z5aORf9Z92Y9Gr3/IMghEN+S/4jnbAEMn10Dje3nPzqN5vPoRXSMbEozst7XIxKsU0J
         gBvWlCc8Vlv0J/jW7qsXnCxGTtzMdjeftM/ASPKSNPLtMAy58CqyfTCpi2aCGOiwcPxV
         q/mw==
X-Gm-Message-State: AOAM532ytvgi8cQcoP6CNRrxvniUVI5zdlPnZPI6hqTW4XEalrMkkD9x
        v7sTjVGtK0lWNGO5U26aBf4=
X-Google-Smtp-Source: ABdhPJz1Qc9XYILPcmFJWz8PG8SEZ0j/CGmKp/6n/ESFv33JeqzE7nM0sKwz/0LMjuLE7A7oh0/r7A==
X-Received: by 2002:a17:906:f285:: with SMTP id gu5mr16535253ejb.226.1623694347442;
        Mon, 14 Jun 2021 11:12:27 -0700 (PDT)
Received: from localhost ([185.246.22.209])
        by smtp.gmail.com with ESMTPSA id a2sm7919494ejp.1.2021.06.14.11.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 11:12:27 -0700 (PDT)
Date:   Mon, 14 Jun 2021 11:12:20 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 5/8] ice: register 1588 PTP clock device object
 for E810 devices
Message-ID: <20210614181218.GA7788@localhost>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
 <20210611162000.2438023-6-anthony.l.nguyen@intel.com>
 <20210611141800.5ebe1d4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ca27bafc-fdc2-c5f1-fc37-1cdf48d393b2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca27bafc-fdc2-c5f1-fc37-1cdf48d393b2@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 09:43:17AM -0700, Jacob Keller wrote:
> > Since dialed_freq is updated regardless of return value of .adjfine 
> > the driver has no clear way to reject bad scaled_ppm>
> 
> I'm not sure. +Richard?

The driver advertises "max_adj".  The PHC layer checks user space inputs:

ptp_clock.c line 140:
	} else if (tx->modes & ADJ_FREQUENCY) {
		s32 ppb = scaled_ppm_to_ppb(tx->freq);
		if (ppb > ops->max_adj || ppb < -ops->max_adj)
			return -ERANGE;

So, if the max_adj is correct for the driver/HW, then all is well.

Thanks,
Richard


