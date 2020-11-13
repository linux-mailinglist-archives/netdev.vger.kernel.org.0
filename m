Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DC22B14A9
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 04:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgKMDYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 22:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgKMDYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 22:24:55 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADF0C0613D1;
        Thu, 12 Nov 2020 19:24:55 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id a18so6448626pfl.3;
        Thu, 12 Nov 2020 19:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IrE75K0NizerR3Wqiaotbx/ZTvWDabFAa1OrR3pXQBM=;
        b=tiqP62IaMm6SRIY34zK1I6Vd/AdYWXLclGpsFGDxzEfFmvIutxtBVS8EATJ3zTl1v6
         iMT/9l21aMFpcbx/Zd22XI0meooOfiwQjMMXX5V4hDMKXVRBxmiqT693bbRnaRcZMcPB
         cJUe4emdu6yTO1EOepN4hnPfht8E518Eg++8grjl+hqUlO33jxCx5Z9Ewp9VMxf8HZJ7
         2doCEx5PDUL4l+tpiloMAyeGBqQbluCKb8quaDFIZT1dCqN1nHzZ6OadfU5z2SMvYJ/t
         dwr5IcM6rFyY2n08rG3whqdZZPimxVaSZTNEvEw//8DPm+darGuDtFXqeLcGC0PVK8Ec
         C7GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IrE75K0NizerR3Wqiaotbx/ZTvWDabFAa1OrR3pXQBM=;
        b=AMHEewOfOR7J3nsrG+hd3W34NQnWmNjY1MtevsU3lvqLA9oq6rl5sJbVul2IfyZ32e
         GQjanVyf5GVfYbxSU9jBVxVFvNQHLK1FKA/r9ZrOASyOzFZt0qhu6DCDk0kp50Sl4k4p
         beQ4qs9nP6Ep2T+xyr7UzVLmi1iBYEE8q7DrNnVeokvS0gN5gWgjS3FDYiPo+HGr9rHf
         UEM/nv9q9FsVEyeFDy3vf9kSQ+E95JR/QJN5G48g4OdlgR7niYlMwQPl3xzO2Fw7BUb+
         uUeiAtz3WwD447DMEuXqpWyBzwVeBQkICs5k8Urc9I9eQsR2JVGM76KJqcxmO6KwNxsK
         Dtdg==
X-Gm-Message-State: AOAM533j+OPwcnu0oTgtxTYy86Iv/1V1XOhyJBuKCrt/JJ82aFPtK501
        i0sPcLOwWG0VKrA9CZi4n7A=
X-Google-Smtp-Source: ABdhPJzcuTIzDajv93N7IQPN6QpZ/QfdtRcZ+OE7vEUpY+BoiTpWkaSmuDsIvd1J3W0wjx3m3Q5maQ==
X-Received: by 2002:a65:590e:: with SMTP id f14mr456228pgu.58.1605237894762;
        Thu, 12 Nov 2020 19:24:54 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id v23sm8361002pjh.46.2020.11.12.19.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 19:24:54 -0800 (PST)
Date:   Thu, 12 Nov 2020 19:24:51 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support for
 PTP getcrosststamp()
Message-ID: <20201113032451.GB32138@hoboy.vegasvil.org>
References: <20201112093203.GH1559650@localhost>
 <87pn4i6svv.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pn4i6svv.fsf@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 03:46:12PM -0800, Vinicius Costa Gomes wrote:
> I wanted it so using PCIe PTM was transparent to applications, so adding
> another API wouldn't be my preference.
> 
> That being said, having a trigger from the application to start/stop the
> PTM cycles doesn't sound too bad an idea. So, not too opposed to this
> idea.
> 
> Richard, any opinions here?

Sorry, I only have the last two message from this thread, and so I'm
missing the backstory.

Richard
