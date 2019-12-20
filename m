Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB7A9127517
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 06:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfLTFTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 00:19:37 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:50263 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbfLTFTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 00:19:36 -0500
Received: by mail-pj1-f65.google.com with SMTP id r67so3579333pjb.0
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 21:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bm7dz8v6v7xOopQbslTs0QmjP2BYiyMGUH15MYokzpE=;
        b=T8xo1GkC5V5B4E5N6KAFDgBCm7AFSOp69gdMMwtI2vAlHvsPDhf+UeOC5gcDEyaFj3
         rd8h1Ou4uORsFa80d/W7II+f/Vs4APxxVp/RyoPg/zae0UCa5jzR16YtWS5EA5P1d3I5
         jNhVWvMB05c8DGXG/lBVJxJO/bApuqbh2osb/TwnR0MynAD44fzREvMdhotqoIIBslkb
         dM+jFymHbtDhklJsRKE/hkjGz+RhTo+zWEFFQQ/VnoFQdXNgXyIT7lDs4HeM6idUZWse
         A3PRHtU2TswhSnu2YpH1VLCBIuQXeRHafpzkDhUguf1yzMfVY7sBxNVUCWJXAxQvcd3G
         uQLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bm7dz8v6v7xOopQbslTs0QmjP2BYiyMGUH15MYokzpE=;
        b=d05LbXZOKpgpDUbseaFQITl09+bMZ8PMlhiw+YSN5DwxCE6ZbTyJkuFJqQklE0hvAU
         XgJXSgkXhhf41LxBnGC7tRkjtnhIleho9ZeD7/JpBLir1APBhxAdENhg8j9xqFyDhAi4
         LRGHDxgCWwZGZsSMeqcil2dDpYm6XDUm11WdGerbnvO1D1LGAk4E7mUiPmypk4HjV85m
         F2ilnqJrIBjIUI5khQpLX1a9V2kS8G2wTsP42O42f6cBIPetQ2opkhkgD2l7M2vz3GiP
         WKFq1paeKrZGmDaVuY9D4iCM9ZghNgneV7yfADrdU7IMSszUuSLpK1CkVJYVINpLIRfo
         G4Vg==
X-Gm-Message-State: APjAAAVjiMKMdqr+VvOAyQU+4pr6yLDBIDKqwFkgQs5MB7tJOx0HbIuG
        pbVbHLBHyCPRvKEHnX8w/Eg=
X-Google-Smtp-Source: APXvYqzBVIhmtG1mEEMspWcAI71KWMdUUtEaeUdHQc7JJBOnaipwNbCctkETdpMkNQgcFZOJN4OLHA==
X-Received: by 2002:a17:902:680f:: with SMTP id h15mr7389837plk.114.1576819176288;
        Thu, 19 Dec 2019 21:19:36 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d65sm10632598pfa.159.2019.12.19.21.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 21:19:35 -0800 (PST)
Date:   Thu, 19 Dec 2019 21:19:33 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Radhey Shyam Pandey <radheys@xilinx.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>
Subject: Re: [PATCH net-next 1/3] net: axienet: Propagate registration errors
 during probe.
Message-ID: <20191220051933.GA1408@localhost>
References: <cover.1576520432.git.richardcochran@gmail.com>
 <42ed0fb7ef99101d6fd8b799bccb6e2d746939c2.1576520432.git.richardcochran@gmail.com>
 <CH2PR02MB70009FEE62CD2AB6B40911E5C7500@CH2PR02MB7000.namprd02.prod.outlook.com>
 <20191217154950.GA8163@localhost>
 <CH2PR02MB700039E0886AE86B9C731A90C7520@CH2PR02MB7000.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR02MB700039E0886AE86B9C731A90C7520@CH2PR02MB7000.namprd02.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 06:13:34PM +0000, Radhey Shyam Pandey wrote:
> I mean in which scenario we are hitting of_mdiobus_register defer? 

of_mdiobus_register_phy() returns EPROBE_DEFER.

Thanks,
Richard
