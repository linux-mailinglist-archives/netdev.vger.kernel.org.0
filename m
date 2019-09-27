Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81DE7C0602
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 15:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfI0NIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 09:08:36 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42406 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfI0NIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 09:08:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id n14so2649628wrw.9
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 06:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ygbIJXHqXvBmu/gSPkwBJPvYzBCU0DQBygj8Q7vov5E=;
        b=mmEiYxfaAKjEh/GFUe2G4UXfJTI1XHlkJN2ofjD1xeWSauZqiSPUEUIEopC7u0eSjZ
         9J3MqB12CAtbwNnX9kUlzXoIn8qdE4SYDq4fk4mMpNdk7WixyWf6DRWr37NIw/ROIIWy
         DCIaqD4Cy5RHq1CVolMHThht6LNDU6xDo57WstZk5vBhffU7P2zj/o1meDtuZYVec9SU
         4u7ZR8B3vpmle14R7/XoE/jNJ+vO3Se/HVTHRFi6yjrBe2pvO56W62S6vP7eMzcboYlf
         KlJRq5llrj/FPfnOCv6exw9Uz1y8q5Rt0Zsn4wTZgS1/xNS9T/GlJT2rQFL3JBKc9OP2
         JNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ygbIJXHqXvBmu/gSPkwBJPvYzBCU0DQBygj8Q7vov5E=;
        b=Wv+7b58gJ+Lo2N1qQMVOH182X/+jOtoCsXOz3Gu+00zVK3A+Cuz46ni08G+Wj/+V0B
         GNot+1F4Sj0jnju+7h+xIaIv1Xx3Jo/Flq0fhr4CwUqQ9qu/XpZlZyE/27cg0SliHFDM
         Riyepe5TwuIPCMFboEdcSNdUm4BGSnnrREDCUv88PbA/mlU7eo5ZH0aBph+Sfokvt/md
         /NZMFd3S6R77FqDqFXseZ2QUQcSCssT2yj3pLLYW3UOEre3NtDLwOX5UwQ4V6AZopg++
         aLgOG2Ip8/j9WQAjp2bcgoD6YHCQ46Xc0XFrSpQzNvcCqpoeqbwSnw+Z7eubojXZHJr6
         rTRA==
X-Gm-Message-State: APjAAAWDpx4lZywqjpfyUk5Cgbk50LumzISSgWdz4R5DHAvXjMaxyTDB
        OzORGD14D6F++0XwHc5TygNi4ekmM70=
X-Google-Smtp-Source: APXvYqyeYPecaiz/Gx81L2ifMLregW/RNUmP8cBp1ZUY1Y3HfpEyme5V3pVim6CFCxt2W+Qu29n85g==
X-Received: by 2002:a5d:4a01:: with SMTP id m1mr2904421wrq.343.1569589713448;
        Fri, 27 Sep 2019 06:08:33 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l13sm4392620wmj.25.2019.09.27.06.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 06:08:33 -0700 (PDT)
Date:   Fri, 27 Sep 2019 15:08:32 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net] devlink: Fix error handling in param and info_get
 dumpit cb
Message-ID: <20190927130832.GA2733@nanopsycho>
References: <1569490554-21238-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20190926122726.GE1864@lunn.ch>
 <CAACQVJpgZz3Fb36=x_wPb+hAaXecHj6oVuUsD-GgEhz9yfRgKg@mail.gmail.com>
 <20190927123129.GB25474@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927123129.GB25474@lunn.ch>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Sep 27, 2019 at 02:31:29PM CEST, andrew@lunn.ch wrote:
>On Fri, Sep 27, 2019 at 10:28:36AM +0530, Vasundhara Volam wrote:
>> On Thu, Sep 26, 2019 at 5:57 PM Andrew Lunn <andrew@lunn.ch> wrote:
>> >
>> > On Thu, Sep 26, 2019 at 03:05:54PM +0530, Vasundhara Volam wrote:
>> > > If any of the param or info_get op returns error, dumpit cb is
>> > > skipping to dump remaining params or info_get ops for all the
>> > > drivers.
>> > >
>> > > Instead skip only for the param/info_get op which returned error
>> > > and continue to dump remaining information, except if the return
>> > > code is EMSGSIZE.
>> >
>> > Hi Vasundhara
>> >
>> > How do we get to see something did fail? If it failed, it failed for a
>> > reason, and we want to know.
>> >
>> > What is your real use case here? What is failing, and why are you
>> > O.K. to skip this failure?
>> >
>> >      Andrew
>> Hi Andrew,
>> 
>> Thank you for looking into the patch.
>> 
>> If any of the devlink parameter is returning error like EINVAL, then
>> current code is not displaying any further parameters for all the other
>> devices as well.
>> 
>> In bnxt_en driver case, some of the parameters are not supported in
>> certain configurations like if the parameter is not part of the
>> NVM configuration, driver returns EINVAL error to the stack. And devlink is
>> skipping to display all the remaining parameters for that device and others
>> as well.
>> 
>> I am trying to fix to skip only the error parameter and display the remaining
>> parameters.
>
>Hi Vasundhara
>
>Thanks for explaining your use case. It sounds sensible. But i would
>narrow this down.
>
>Make the driver return EOPNOTSUP, not EINVAL. And then in dump, only
>skip EOPNOTSUP. Any other errors cause the error to be returned, so we
>get to see them.

Agreed, that would be more reasonable.

>
>   Andrew
