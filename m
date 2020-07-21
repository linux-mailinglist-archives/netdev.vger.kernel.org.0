Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9013A228169
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgGUN43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgGUN43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:56:29 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0B4C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 06:56:28 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a15so6359167wrh.10
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 06:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S++uFRP09ZuFrTLUiysiSiwMq+fPcXJJ3gKqMef2s+k=;
        b=xgOr8N9c+O1aa/Ev6JM0ra97PxUA3eQpFgvriGVG5kU/apH/FjBaC7BlCd/ubb15hC
         BydmAizwNV3srQB6ePSs3qqp26PW/g5nLaXouD7X5tIaA8OR2VGQj47u5e8J9J/01vEi
         QB+lNrvmsNQm590S1tj2B2pKYKTK7UL018LVud5+0Hc8FB7F2EfYv1O94mj68wk2B4F9
         cSbGJl2eNTFjl7nSefPoJUyHtd9lMoD1pxk2w6uRc7kFpgMhSOin6hl+D99uo13JycML
         xCsiboktK+tsx3uaN8gaaf9RaHOUiEyIxUUfxzaOo95Zd4uuA3yN3JF7KwfqUco59QgS
         mEgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S++uFRP09ZuFrTLUiysiSiwMq+fPcXJJ3gKqMef2s+k=;
        b=R30u1Ibn0TQ1tJ3xWuIB0SyOTOBAkC4ER0E41L6/cEo1bV1cMY58OI9HJ8fCNOvkf/
         Awol8LfGQ+Qey9EhRdcmUM+WVU5fdbN/H9ZNhLvrbkh3dEeBC+jVTmBh17kKfqBmTPsD
         0ZP3+OGS05FjD9S5qv/rSilSNFZoe6irIjr62XtKdyTLYPD7HFWDtafuy9fk8IBGDFf4
         Oe5fHzpsjl6AoMlnurldMBQrE34KVcgDcPQI4Q+mh8TD2iFJhwvFWcsCoh/ZuqqhrLGR
         IS6IbLPsBz+CoNdEMAykH1FM7xuuai+M37ZsnwC+N9/sgjq7RBThbp355Sfi66tljT23
         Bc5A==
X-Gm-Message-State: AOAM532533nVNA/9F2VameDjNRVAmLTV67eRpsmVdQeMVl+bcdoegpvT
        eQKzC1w/VyG+DULQuc5meWcW6Q==
X-Google-Smtp-Source: ABdhPJxsrv9bG39f1EAvrY+CtqK1dKSk6do85jJq0jZQ4gjzzLiSAzUjXdY/Mo+YMZ9eNdX+f7plSw==
X-Received: by 2002:a05:6000:1190:: with SMTP id g16mr25522341wrx.286.1595339787570;
        Tue, 21 Jul 2020 06:56:27 -0700 (PDT)
Received: from localhost (ip-89-103-111-149.net.upcbroadband.cz. [89.103.111.149])
        by smtp.gmail.com with ESMTPSA id d201sm3544598wmd.34.2020.07.21.06.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 06:56:27 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:56:26 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kubakici@wp.pl>, netdev@vger.kernel.org,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
Message-ID: <20200721135626.GC2205@nanopsycho>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717183541.797878-7-jacob.e.keller@intel.com>
 <20200720100953.GB2235@nanopsycho>
 <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <078815e8-637c-10d0-b4ec-9485b1be5df0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <078815e8-637c-10d0-b4ec-9485b1be5df0@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 20, 2020 at 08:52:58PM CEST, jacob.e.keller@intel.com wrote:
>
>
>On 7/20/2020 8:51 AM, Jakub Kicinski wrote:
>> On Mon, 20 Jul 2020 12:09:53 +0200 Jiri Pirko wrote:
>>> This looks odd. You have a single image yet you somehow divide it
>>> into "program" and "config" areas. We already have infra in place to
>>> take care of this. See DEVLINK_ATTR_FLASH_UPDATE_COMPONENT.
>>> You should have 2 components:
>>> 1) "program"
>>> 2) "config"
>>>
>
>First off, unfortunately at least for ice, the "main" section of NVM
>contains both the management firmware as well as config settings. I
>don't really have a way to split it up.

You don't have to split it up. Just for component "x" you push binary
"A" and flash part of it and for comonent "y" you push the same binary
"A" and flash different part of it.

Consider the component as a "mask" in your case.


>
>This series includes support for updating the main NVM section
>containing the management firmware (and some config) "fw.mgmt", as well
>as "fw.undi" which contains the OptionROM, and "fw.netlist" which
>contains additional configuration TLVs.
>
>The firmware interface allows me to separate the three components, but
>does not let me separate the "fw binary" from the "config settings" that
>are stored within the main NVM bank. (These fields include other data
>like the device MAC address and VPD area of the device too, so using
>"config" is a bit of a misnomer).
>
>>> Then it is up to the user what he decides to flash.
>> 
>> 99.9% of the time users want to flash "all". To achieve "don't flash
>> config" with current infra users would have to flash each component 
>> one by one and then omit the one(s) which is config (guessing which 
>> one that is based on the name).
>> 
>> Wouldn't this be quite inconvenient?
>> 
>
>I also agree here, I'd like to be able to make the "update with the
>complete file" just work in the most straight forward  way (i.e. without
>erasing stuff by accident) be the default.
>
>The option I'm proposing here is to enable allowing tools to optionally
>specify handling this type of overwrite. The goal is to support these
>use cases:
>
>a) (default) just update the image, but keep the config and vital data
>the same as before the update.
>
>b) overwrite config fields, but keep vital fields the same. Intended to
>allow returning configuration to "image defaults". This mostly is
>intended in case regular update caused some issues like if somehow the
>config preservation didn't work properly.
>
>c) overwrite all fields. The intention here is to allow programming a
>customized image during initial setup that would contain new IDs etc. It
>is not expected to be used in general, as this does overwrite vital data
>like the MAC addresses and such.
>
>So the problem is that the vital data, config data, and firmware
>binaries are stored in the same section, without a good way to separate
>between them. We program all of these together as one chunk to the
>"secondary NVM bank"  and then ask firmware to update. It reads through
>and based on our "preservation" setting will update the binaries and
>merge the configuration sections.
>
>> In case of MLX is PSID considered config?
>> 
