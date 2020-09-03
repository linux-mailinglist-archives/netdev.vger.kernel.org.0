Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335BC25CC6A
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgICVhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgICVhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:37:42 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDA0C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 14:37:42 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id k15so3369621pfc.12
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 14:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=1lUZXY3obDCexHeavsduJhO2U2kDNfyOlQUSMArHgfc=;
        b=NnQ9gVrkeyDanJNAruBnjg5NEjs2tFNM/ev+IwiVI+F49ohyzz/4mxIkiF/Gck0Bzh
         OJylH7IZefsdmaohVLB//vwc7hktSAszFIhqs4V7yVu426Jd1etgn5ijkOsRInGVS0rn
         yaEKy/fi4ki9H2nIeV/OdBZpckXZVjACpJlggbXVdJoPc7G8pMw4FbhcK3O+jkdH3N0V
         JDIeJqBE6f8d3IpbQXZN75H1HjKLMNfBJhNeh/w66WTpfAVNUuCfyxtavZqDctmgrReH
         6ICXs7rKiwEaA8PTL/dY1sqjjbYnyusdzJm6kJRZ3TRhfa2zUsPfF8NQFCnfE3dmeNLy
         lUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=1lUZXY3obDCexHeavsduJhO2U2kDNfyOlQUSMArHgfc=;
        b=LGmsUVPQpc0ZsRtC+Xu1LCL2MFc+0Uu6JPOzabtGd1taQaL/Zp+yXRexAR0kXRhnOq
         Gi/uqm4OckecMv9K+CrfnEwJNv3U7TDI9Fk02RF3wAsjYwC/BrCHP5FDb18jVYdp0fyW
         lPA8POFq3cxWY/iQpD4UkRw4C+VnQT6b3gMgiyuc1j7TLOXna0d0BYUvhkyistaU+omZ
         1EvgzbNxV9lLFzMTwoFgyPAX3/ejkJW2pkrpEPa9pQ6ZlcEVdGbTNIeTcdh9b3StXIMH
         w1Kid+ZIcQ0Ivk2HP6eQgVwMLBxdb9cjvZt5k0e+qo4DFX3sI0rND/TU1gjTAr0cPCNT
         Js8w==
X-Gm-Message-State: AOAM530pZ9a8pB52lbUvHh4WNFr6uNsE0XF91EcH3VM0SLpxiCY+24Fy
        lYI8rT9pfdqbbyxWpkKwhe2g/Q==
X-Google-Smtp-Source: ABdhPJyLBS4jZnIdBmVHlSToXDQnmt6SNzTP+YNy9AJuTJe9+efTgMiYrXXEBLYrpbfjASIkbz9vDg==
X-Received: by 2002:a17:902:6902:: with SMTP id j2mr5917508plk.2.1599169061625;
        Thu, 03 Sep 2020 14:37:41 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id x4sm4175645pfm.86.2020.09.03.14.37.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 14:37:41 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] ionic: add devlink firmware update
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200902195717.56830-1-snelson@pensando.io>
 <20200902195717.56830-3-snelson@pensando.io>
 <20200903125350.4bc345e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <bd395a37-92b1-8d5f-eea5-66bb82a02e94@pensando.io>
Date:   Thu, 3 Sep 2020 14:37:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200903125350.4bc345e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/20 12:53 PM, Jakub Kicinski wrote:
> On Wed,  2 Sep 2020 12:57:17 -0700 Shannon Nelson wrote:
>> Add support for firmware update through the devlink interface.
>> This update copies the firmware object into the device, asks
>> the current firmware to install it, then asks the firmware to
>> set the device to use the new firmware on the next boot-up.
> Activate sounds too much like fw-active in Moshe's patches.
>
> Just to be clear - you're not actually switching from the current
> FW to the new one here, right?
>
> If it's more analogous to switching between flash images perhaps
> selecting would be a better term?
>
>> The install and activate steps are launched as asynchronous
>> requests, which are then followed up with status requests
>> commands.  These status request commands will be answered with
>> an EAGAIN return value and will try again until the request
>> has completed or reached the timeout specified.

I think I can find a way to reword that - perhaps "enable" would be 
better than "activate"?

Thanks,
sln

